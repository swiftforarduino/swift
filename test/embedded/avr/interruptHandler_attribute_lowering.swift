// RUN: %swift -emit-ir\
// RUN: -target avr-none-none-elf  \
// RUN: -wmo -enable-experimental-feature Embedded \
// RUN: %s | %FileCheck --check-prefix=CHECK %s

// REQUIRES: embedded_stdlib_cross_compiling
// REQUIRES: CODEGENERATOR=AVR
// REQUIRES: swift_feature_Embedded

// These tests check that attributes on swift functions are propagated correctly to LLVM.

// CHECK-LABEL define protected i32 @main

@interruptHandler
public func foo() { }
// CHECK-LABEL: define protected avr_signalcc void {{.*}}foo

public func foo3() {}
// CHECK-LABEL: define protected void {{.*}}foo3
