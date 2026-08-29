// RUN: %swift -emit-ir -o %t\
// RUN: -target avr-none-none-elf  \
// RUN: -wmo -enable-experimental-feature Embedded %s
// RUN: llc -O3 \
// RUN: -march=avr -mcpu=avr5 -filetype=asm -o - %t | %FileCheck --check-prefix=CHECK %s

// REQUIRES: embedded_stdlib_cross_compiling
// REQUIRES: CODEGENERATOR=AVR
// REQUIRES: swift_feature_Embedded

// These tests check that attributes on swift functions are propagated correctly to AVR assembly.

// CHECK-LABEL main:
// CHECK: ret

// check interrupt handlers have the minimum expected prolog and epilog and a RETI
@interruptHandler
public func foo() { }
// CHECK-LABEL: {{.*}}fooyyF
// CHECK-NOT: sei
// CHECK: push	r0
// CHECK: in	r0, 63
// CHECK: push	r0
// CHECK: pop	r0
// CHECK: out	63, r0
// CHECK: pop	r0
// CHECK: reti

// anything else must not have a RETI
public func foo3() {}
// CHECK-LABEL: {{.*}}foo3yyF
// CHECK-NOT: reti