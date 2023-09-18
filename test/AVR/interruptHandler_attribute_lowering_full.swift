// interruptHandler_attribute_lowering_full.swift
// XFAIL: *

// These tests check that attributes on swift functions are propagated correctly to assembly.

// RUN: %swift -emit-ir -o %t\
// RUN: -target avr-atmel-linux-gnueabihf \
// RUN: -enforce-exclusivity=unchecked -disable-reflection-metadata -nostdimport \
// RUN: -Xcc "-DAVR_LIBC_DEFINED -DLIBC_DEFINED" "-DAVR_LIBC_DEFINED_SWIFT" \
// RUN: -I "/Applications/Swift For Arduino.app/Contents/XPCServices/BuildEngine.xpc/Contents/Resources/uSwiftShims" \
// RUN: -I "/Applications/Swift For Arduino.app/Contents/XPCServices/BuildEngine.xpc/Contents/Resources/uSwift-AVR" \
// RUN: -I "/Applications/Swift For Arduino.app/Contents/XPCServices/BuildEngine.xpc/Contents/Resources/gpl-tools-avr/lib/avr-libgcc/include" \
// RUN: -I "/Applications/Swift For Arduino.app/Contents/XPCServices/BuildEngine.xpc/Contents/Resources/gpl-tools-avr/lib/avr-libc/include" \
// RUN: %s
// RUN: "/Applications/Swift For Arduino.app/Contents/XPCServices/BuildEngine.xpc/Contents/Resources/llvm/llc" -O3 \
// RUN: -march=avr -mcpu=avr5 -filetype=asm -data-sections -function-sections  -o - %t | %FileCheck --check-prefix=CHECK %s


// CHECK-LABEL main:
// CHECK: ret

// check interrupt handlers have the minimum expected prolog and epilog and a RETI
@interruptHandler
public func foo() { }
// CHECK-LABEL: {{.*}}fooyyF
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