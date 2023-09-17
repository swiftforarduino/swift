// runtime_scanner_interruptHandler_attribute.swift

// These tests check that attributes on swift functions are propagated correctly to LLVM.

// RUN: %swift -emit-ir\
// RUN: -target avr-atmel-linux-gnueabihf \
// RUN: -enforce-exclusivity=unchecked -disable-reflection-metadata -nostdimport \
// RUN: -Xcc "-DAVR_LIBC_DEFINED -DLIBC_DEFINED" "-DAVR_LIBC_DEFINED_SWIFT" \
// RUN: -I "/Applications/Swift For Arduino.app/Contents/XPCServices/BuildEngine.xpc/Contents/Resources/uSwiftShims" \
// RUN: -I "/Applications/Swift For Arduino.app/Contents/XPCServices/BuildEngine.xpc/Contents/Resources/uSwift-AVR" \
// RUN: -I "/Applications/Swift For Arduino.app/Contents/XPCServices/BuildEngine.xpc/Contents/Resources/gpl-tools-avr/lib/avr-libgcc/include" \
// RUN: -I "/Applications/Swift For Arduino.app/Contents/XPCServices/BuildEngine.xpc/Contents/Resources/gpl-tools-avr/lib/avr-libc/include" \
// RUN: %s | %FileCheck --check-prefix=CHECK %s


// CHECK-LABEL define protected i32 @main
// CHECK-NOT !interrupt

@interruptHandler
public func foo() { }
// CHECK-LABEL: define protected swiftcc void {{.*}}foo
// CHECK-SAME: !interrupt

public func foo3() {}
// CHECK-LABEL: define protected swiftcc void {{.*}}foo3
// CHECK-NOT: !interrupt