// RUN: %target-swift-frontend -S -O %s -target avr-none-none-elf \
// RUN:   -wmo -enable-experimental-feature Embedded \
// RUN:   -import-objc-header %S/Inputs/coroutines.h | %FileCheck %s
// REQUIRES: embedded_stdlib_cross_compiling
// REQUIRES: CODEGENERATOR=AVR
// REQUIRES: swift_feature_Embedded

// IRGen must be able to create llvm coroutines for _modify accessors.
// This requires a bugfix for an address space cast to get the
// pointer right on AVR.

public struct CPUCore {
    public static var statusRegister: UInt8 {
        get {
            return _volatileRegisterReadUInt8(0x5F)
        }
        set {
            _volatileRegisterWriteUInt8(0x5F, newValue)
        }
    }
}

// CHECK:   .protected  $e10coroutines7CPUCoreV14statusRegisters5UInt8VvMZ ; -- Begin function $e10coroutines7CPUCoreV14statusRegisters5UInt8VvMZ
// CHECK:    .globl  $e10coroutines7CPUCoreV14statusRegisters5UInt8VvMZ
// CHECK:    .p2align    1
// CHECK:    .type   $e10coroutines7CPUCoreV14statusRegisters5UInt8VvMZ,@function
// CHECK:$e10coroutines7CPUCoreV14statusRegisters5UInt8VvMZ: ; @"$e10coroutines7CPUCoreV14statusRegisters5UInt8VvMZ"
// CHECK:; %bb.0:
// CHECK:    mov{{w?}}    r26, r24
// CHECK:    in  r24, 63
// CHECK-NEXT:    st  X, r24
// CHECK-NEXT:    ldi r22, pm_lo8($e10coroutines7CPUCoreV14statusRegisters5UInt8VvMZ.resume.0)
// CHECK-NEXT:    ldi r23, pm_hi8($e10coroutines7CPUCoreV14statusRegisters5UInt8VvMZ.resume.0)
// CHECK-NEXT:    mov{{w?}}    r24, r26
// CHECK:    ret
