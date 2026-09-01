# AVR/Embedded IRGen regression after rebasing onto current Swift `main`

Written 2026-09-01, on branch `s4a-mods-2` (`16ceb855250`).

## Symptom

Compiling **any class** in Embedded Swift for AVR aborts in IRGen. The visible
failure was `test/embedded/avr/main.swift`:

```
Assertion failed: (CastInst::castIsValid(Instruction::BitCast, C, DstTy) &&
                   "Invalid constantexpr bitcast!"), Constants.cpp:2315
While emitting lazy specialized class metadata for type 'ConstantSizeBuffer<1, UInt32>'
```

It reproduces with a two-line program (`final class Box { var x: UInt32 = 0 }`),
so it is not specific to that test. Two separate bugs are involved; the second is
only reachable once the first is fixed.

## What is actually broken

Both defects are in **upstream** code (byte-identical to `origin/main`, and
unchanged since 6.3). AVR is simply the first target to reach them: it is the
only 16-bit target, and the only one that puts code in a non-zero address space.

1. **Address space.** `lib/IRGen/GenValueWitness.cpp`, the `addFunction` lambda in
   `addValueWitness`, bitcast a value witness function to `IGM.Int8PtrTy`. On AVR
   every `llvm::Function` is created in `addrspace(1)` (LLVM's
   `Module::getOrInsertFunction` uses `DataLayout::getProgramAddressSpace()`),
   while `Int8PtrTy` is address space 0 — a bitcast cannot change address space.

2. **16-bit pointers.** `lib/IRGen/ExtraInhabitants.cpp`:
   `PointerInfo::getExtraInhabitantIndex` used `CreateTrunc(index, Int32Ty)`,
   which is an *extension* when pointers are 16-bit, and
   `PointerInfo::storeExtraInhabitant` used `CreateZExt(index, SizeTy)`, which is
   a *truncation* in the same situation. Both are invalid casts.

## Why 6.3 was fine and the rebase broke it

Neither buggy line changed. What changed is whether they are reached at all:
embedded class metadata did not carry a value witness table in 6.3.

```
6.3   ClassMetadataVisitor.h, layoutEmbedded():  noteAddressPoint(); addEmbeddedSuperclass(); ...
main  ClassMetadataVisitor.h, layoutEmbedded():  addValueWitnessTable();   <-- added
                                                 noteAddressPoint(); addEmbeddedSuperclass(); ...
```

And in 6.3, `irgen::emitValueWitnessTable` returned early via
`getAddrOfKnownValueWitnessTable()` unconditionally, i.e. it *referenced* the
runtime's prefab table instead of *defining* one — so no witness function
pointers were ever emitted in an embedded build.

Four upstream commits closed that gap. None is an ancestor of
`swift-6.3-RELEASE`; all are in current `main`:

| Commit | Date | PR | Effect |
| --- | --- | --- | --- |
| `4285a2169d7` | 2025-10-24 | — | "IRGen: Start support for embedded existentials". Adds `addValueWitnessTable()` to `layoutEmbedded()` and the branch in `emitValueWitnessTable` that *defines* the table locally (there is no runtime to supply `$sBoWV`). Gated on `Feature::EmbeddedExistentials`, so it was opt-in. |
| `4d879967a7b` | 2025-12-09 | #85923 | Collects the checks into `IRGenModule::isEmbeddedWithExistentials()`, still `Embedded && EmbeddedExistentials`. |
| **`d019f37b680`** | **2025-12-10** | **#85948** | **The trigger.** `CompilerInvocation.cpp` now auto-enables the feature: `if (Opts.hasFeature(Feature::Embedded) && !Args.hasArg(OPT_disable_embedded_existentials)) Opts.enableFeature(Feature::EmbeddedExistentials);`. From here, plain `-enable-experimental-feature Embedded` — exactly what the AVR builds pass — implies existentials. |
| `aad51cab01f` | 2026-04-17 | #88541 | "Remove the ability to disable existentials in Embedded Swift". Deletes the feature flag and the `-disable-embedded-existentials` opt-out; the gate becomes plain `hasFeature(Feature::Embedded)`. |

Note on chronology: `swift-6.3-RELEASE` is `aa782beb23b`, dated **2026-03-20**.
The commits above are dated earlier but landed on `main` after the 6.3 branch was
cut, which is why a March 2026 release does not contain December 2025 work.

Consequence: every embedded build now emits a locally defined value witness table
full of function pointers for every class — precisely what AVR's addressing model
and 16-bit pointers cannot express. There is **no flag-level workaround left**;
`-disable-embedded-existentials` no longer exists.

This is not test-only. Any user compiling a class on this base is affected.

## Fixes applied

- `lib/IRGen/GenValueWitness.cpp` — use
  `ConstantExpr::getPointerBitCastOrAddrSpaceCast`, which emits an
  `addrspacecast` where needed. This is the same treatment already used
  throughout `GenDecl.cpp` and by `IRGenModule::getOpaquePtr`.
- `lib/IRGen/ExtraInhabitants.cpp` — use `CreateZExtOrTrunc` in both places.

Both are no-ops for every target with 32-bit or wider pointers in address space
0. Verified: emitted IR is byte-identical before and after for arm64 macOS
(`-O` and `-Onone`), wasm32 and armv7em, and the `test/IRGen` failure set is
unchanged. On AVR the witness table lowers to `.short pm(<symbol>)`, the correct
word-address form, and `-c -O` produces a valid object file.

## Test changes

- `test/embedded/avr/coroutines.swift` — the test checked for a `...vMZ` symbol
  that can never exist as written. The `_modify` that Swift synthesizes for a
  `get`/`set` pair is `[transparent]`, so it is always inlined, and Embedded
  Swift only emits symbols something refers to. The accessor is now written out
  explicitly and used, which does produce the coroutine (`...vMZ` and
  `...vMZ.resume.0`); the existing CHECK lines then match unchanged. The
  underlying S4A coroutine address-space fix was fine all along.
- `UNSUPPORTED: CPU=wasm32` added to the remaining AVR tests that lacked it, so
  the Wasm test suite skips them like the older ones.

## Known remaining AVR issues (not addressed here)

- **Keypaths** hit the same class of address-space bug in
  `lib/IRGen/GenFunc.cpp` (~2276 and ~2767, `emitPartialApplicationForwarder` /
  `emitFunctionPartialApplication`). Fixing one site exposes the next, so it is a
  small cluster rather than a one-line change.
- **`-O0`/`-Onone` codegen is unusable on AVR**: the register allocator runs out
  of registers in stdlib code and `AVRExpandPseudoInsts.cpp` then asserts. This
  reproduces on files with no classes at all, and matters little in practice
  since AVR builds are size-constrained and use optimization.
