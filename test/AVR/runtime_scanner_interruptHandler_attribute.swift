// These tests check that attributes on swift functions are propagated correctly to LLVM.


// RUN: %swift -emit-ir\
// RUN: -target avr-atmel-linux-gnueabihf \
// RUN: -enforce-exclusivity=unchecked -disable-reflection-metadata -nostdimport \
// RUN: -I "/Applications/Swift For Arduino.app/Contents/XPCServices/BuildEngine.xpc/Contents/Resources/uSwiftShims" \
// RUN: -I "/Applications/Swift For Arduino.app/Contents/XPCServices/BuildEngine.xpc/Contents/Resources/uSwift-AVR" \
// RUN: %s | %FileCheck --check-prefix=CHECK %s


// CHECK-LABEL define protected i32 @main
// CHECK-NOT !interrupt

@realtime public func foo() { }
// CHECK-LABEL: define protected swiftcc void {{.*}}foo
// CHECK-SAME: !interrupt

public func foo3() {}
// CHECK-LABEL: define protected swiftcc void {{.*}}foo3
// CHECK-NOT: !interrupt