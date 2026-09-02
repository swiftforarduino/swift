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
- `lib/IRGen/GenFunc.cpp` — three sites in the partial-application path. In
  `emitPartialApplicationForwarder`, the callee type for a statically known
  function is now `IGM.FunctionPtrTy` (`ptr addrspace(<program AS>)`) instead of
  `IGM.PtrTy`, and in both arms of `emitFunctionPartialApplication` the
  forwarder is cast to `IGM.Int8ProgramSpacePtrTy` rather than `IGM.Int8PtrTy`
  before being added to the closure explosion. `FunctionPtrTy` and
  `Int8ProgramSpacePtrTy` are a union of the same type
  (`IRGenModule.h:823-826`) and equal `PtrTy` wherever the program address
  space is 0, so this is a no-op off AVR. The result matches the layout IRGen
  already uses for closures, `%swift.function = { ptr addrspace(1), ptr }`, and
  is the same treatment `FunctionPointer::getExplosionValue` applies in
  `GenCall.cpp:6647`.

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
- `test/embedded/avr/partialApplyAddressSpace.swift` — **new**, the regression
  guard for the `GenFunc.cpp` fix. It defines its own capturing closures rather
  than leaning on the stdlib, because whether a stdlib closure reaches the
  client's IRGen depends on how the embedded stdlib was built (see the section
  below). Two shapes are covered: a multi-value capture, which boxes its context
  and takes the general path, and a single class-reference capture, which takes
  the single-refcounted-context path — the two arms cast the forwarder
  separately, so one test case does not cover the other.

  Note that adding `-Onone`/`-O0` to an existing AVR test would *not* have
  caught this. `testIRGenFunctioning.swift` already runs at the default
  `-Onone`; the flag that mattered was the one the *stdlib* was built with, and
  no RUN line can change that.

## Known remaining AVR issues (not addressed here)

- **Dynamic (non-static) callees in `partial_apply`.** `GenFunc.cpp` ~2718 still
  bitcasts the callee to `IGM.Int8PtrTy` before storing it into the closure
  context, whose field is a `Builtin.RawPointer` in address space 0. Reaching
  that path on AVR needs an honest addrspacecast (or a program-space capture
  field), not a bitcast. The static-callee path — which is what all the current
  tests and the stdlib hit — is fixed.
- **`-O0`/`-Onone` codegen is unusable on AVR**: the register allocator runs out
  of registers in stdlib code and `AVRExpandPseudoInsts.cpp` then asserts. This
  reproduces on files with no classes at all, and matters little in practice
  since AVR builds are size-constrained and use optimization.

## The `stdlib=DA` buildbot failure (2026-09-01)

`oss-swift_tools-RA_stdlib-DA_test-simulators-apple-silicon` build b282 failed
`test/embedded/avr/testIRGenFunctioning.swift`:

```
Assertion failed: (CastInst::castIsValid(opc, C, Ty) && "Invalid constantexpr cast!"),
                  function getCast, file Constants.cpp, line 2220.
While emitting IR SIL function "@$es31_ensureErrorMetadataInitialized...LLyyF".
 for <<debugloc at ".../stdlib/public/core/EmbeddedRuntime.swift":562:14>>
  #10 emitPartialApplicationForwarder(...)
  #11 swift::irgen::emitFunctionPartialApplication(...)
```

This is the *same* defect cluster, reached from a new direction. It is not a new
upstream bug: the crashing line has been in `GenFunc.cpp` unchanged for years.

**Trigger.** `Link.cpp:52-56` force-SIL-links every `RuntimeFunctions.def` entry
— including `swift_allocError` — into *every* embedded program, so
`_ensureErrorMetadataInitialized` (`EmbeddedRuntime.swift:562-570`, added
2026-04-14 by `b589f05c107`, #87617) is IRGen'd even by a program that never
throws. It contains

```swift
withUnsafeMutablePointer(to: &_errorMetadataStorage.destroy) { p in
  p.pointee = UnsafeRawPointer(destroyPtr)     // captures destroyPtr
}
```

a closure with a capture, i.e. a real `partial_apply` needing a forwarder.

**Why only this bot.** The forwarder only survives to IRGen if the *stdlib's
serialized SIL* is unoptimized:

| Job | preset line | `swift-stdlib-build-type` | embedded AVR stdlib flag | result |
| --- | --- | --- | --- | --- |
| `buildbot,tools=RA,stdlib=DA` | `build-presets.ini:160` | `Debug` | `-Onone` | `partial_apply` survives → **crash** |
| macOS PR smoke test | `build-presets.ini:668` | `RelWithDebInfo` | `-O` | closure inlined away → passes |

(`swift_optimize_flag_for_build_type`, `stdlib/cmake/modules/SwiftSource.cmake:21-32`:
`Debug` → `-Onone`, `RelWithDebInfo`/`Release` → `-O`.)

Both presets set `build-embedded-stdlib-cross-compiling` and both build the AVR
LLVM target, so the lit `REQUIRES:` lines are satisfied either way — the stdlib
optimization level is the only difference that matters. The sibling test
`avrCallbackEmission.swift` passes on both because it compiles with `-O`.

**Why it appeared on 2026-09-01 and not in April.** The test itself is only a
week old on `main`. `testIRGenFunctioning.swift` and `avrCallbackEmission.swift`
landed via merge `b26460ba975` on **2026-08-24** (the "[AVR] Fix IRGen function
emission to respect LLVM DataLayout program address space" PR; the 2024-12-30
date on the file is a stale author date from a long-lived branch). Before that,
the only AVR test on `main` was `testStdlibFunctioning.swift`, which is
`-typecheck` only and never reaches IRGen. The PR merged green because PR CI
runs the `stdlib=RD` smoke test. Nothing landed in `lib/IRGen`, `lib/SIL`,
`lib/SILOptimizer` or `stdlib/public/core` between 08-29 and 09-01, so the
first-failure date just reflects when that Debug-stdlib job next ran.

Reproduced locally with the branch compiler on a two-line program — no stdlib
involvement needed, and none of the S4A patches on this branch affect it:

```swift
var sink: ((Int) -> Void)? = nil
func mk(_ a: Int) { sink = { x in globalOut = x &+ a } }   // capture ⇒ forwarder
```

Fixed by the `GenFunc.cpp` change above, and guarded by the new
`test/embedded/avr/partialApplyAddressSpace.swift`. Verified by reverting the
fix and rebuilding: that test is the **only** one of the ten AVR tests that
fails without it. Reverting just the two `Int8ProgramSpacePtrTy` casts and
keeping the `FunctionPtrTy` one also still fails — the crash simply moves from
`emitPartialApplicationForwarder` to `emitFunctionPartialApplication` — so all
three sites are needed. With the full fix, `test/embedded/avr` is 10/10 and the
`test/IRGen` failure set is unchanged at the usual 32.

