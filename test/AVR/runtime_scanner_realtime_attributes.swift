// These tests check that attributes on swift functions are propagated correctly to LLVM.


// RUN: %swift -emit-ir\
// RUN: -target avr-atmel-linux-gnueabihf \
// RUN: -Xcc "-DAVR_LIBC_DEFINED -DLIBC_DEFINED" "-DAVR_LIBC_DEFINED_SWIFT" \
// RUN: -I "/Applications/Swift For Arduino.app/Contents/XPCServices/S4ABuildEngine.xpc/Contents/Resources/gpl-tools-avr/lib/avr-libgcc/include" \
// RUN: -I "/Applications/Swift For Arduino.app/Contents/XPCServices/S4ABuildEngine.xpc/Contents/Resources/gpl-tools-avr/lib/avr-libc/include" \
// RUN: -enforce-exclusivity=unchecked -enable-library-evolution -disable-reflection-metadata -nostdimport \
// RUN: -I "/Applications/Swift For Arduino.app/Contents/XPCServices/S4ABuildEngine.xpc/Contents/Resources/uSwiftShims" \
// RUN: -I "/Applications/Swift For Arduino.app/Contents/XPCServices/S4ABuildEngine.xpc/Contents/Resources/uSwift-AVR" \
// RUN: %s | %FileCheck --check-prefix=CHECK %s

// RUN: %swift -emit-ir -realtime\
// RUN: -target avr-atmel-linux-gnueabihf \
// RUN: -Xcc "-DAVR_LIBC_DEFINED -DLIBC_DEFINED" "-DAVR_LIBC_DEFINED_SWIFT" \
// RUN: -I "/Applications/Swift For Arduino.app/Contents/XPCServices/S4ABuildEngine.xpc/Contents/Resources/gpl-tools-avr/lib/avr-libgcc/include" \
// RUN: -I "/Applications/Swift For Arduino.app/Contents/XPCServices/S4ABuildEngine.xpc/Contents/Resources/gpl-tools-avr/lib/avr-libc/include" \
// RUN: -enforce-exclusivity=unchecked -enable-library-evolution -disable-reflection-metadata -nostdimport \
// RUN: -I "/Applications/Swift For Arduino.app/Contents/XPCServices/S4ABuildEngine.xpc/Contents/Resources/uSwiftShims" \
// RUN: -I "/Applications/Swift For Arduino.app/Contents/XPCServices/S4ABuildEngine.xpc/Contents/Resources/uSwift-AVR" \
// RUN: %s | %FileCheck --check-prefix=CHECKRT %s


// CHECK-LABEL define protected i32 @main
// CHECK-NOT !realtime
// CHECK-NOT !norealtime
// CHECKRT-LABEL: define protected i32 @main
// CHECKRT-NOT: !realtime
// CHECKRT-NOT: !norealtime

@realtime public func foo() { }
// CHECK-LABEL: define protected swiftcc void {{.*}}foo
// CHECK-NOT: !norealtime
// CHECK-SAME: !realtime
// CHECK-NOT: !norealtime
// CHECKRT-LABEL: define protected swiftcc void {{.*}}foo
// CHECKRT-NOT: !norealtime
// CHECKRT-SAME: !realtime
// CHECKRT-NOT: !norealtime

@norealtime public func foo2() { }
// CHECK-LABEL: define protected swiftcc void {{.*}}foo2
// CHECK-NOT: !realtime
// CHECK-SAME: !norealtime
// CHECK-NOT: !realtime
// CHECKRT-LABEL: define protected swiftcc void {{.*}}foo2
// CHECKRT-NOT: !realtime
// CHECKRT-SAME: !norealtime
// CHECKRT-NOT: !realtime

public func foo3() {}
// CHECK-LABEL: define protected swiftcc void {{.*}}foo3
// CHECK-NOT: !realtime
// CHECK-NOT: !norealtime
// CHECKRT-LABEL: define protected swiftcc void {{.*}}foo3
// CHECKRT-NOT: !realtime
// CHECKRT-NOT: !norealtime