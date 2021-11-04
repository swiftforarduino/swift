// A holistic test of the runtime scanner.
// Test cases:


// runtime_scanner_whitelist.ll
// 1) test swift code that should emit a whitelisted runtime call results in no errors (needs to be done in IR only)

// runtime_scanner_greylist.swift
// 2) test swift code that should emit a greylisted (non realtime) call results in no errors in normal compile (non realtime)

// runtime_scanner_greylist_realtime.swift
// 3) test that the greylisted call results in a warning if compiled with -realtime

// runtime_scanner_greylist.swift and runtime_scanner_greylist_realtime.swift
// 4) test that @realtime and @norealtime attributes modify this behaviour as expected

// runtime_scanner_blacklist.swift
// 5) test swift code that emits a blacklisted (nonexistent) call results in an error

// runtime_scanner_blacklist_suppressed.swift
// 6) test the same code with -Xfrontend -no-runtime-verify suppresses the error


// note: ideally we should test all the above from an llvm ir file too, but that will be in a different test files


// RUN: %swift -emit-ir \
// RUN: -O -target avr-atmel-linux-gnueabihf \
// RUN: -Xcc "-DAVR_LIBC_DEFINED -DLIBC_DEFINED" "-DAVR_LIBC_DEFINED_SWIFT" \
// RUN: -I "/Applications/Swift For Arduino.app/Contents/XPCServices/S4ABuildEngine.xpc/Contents/Resources/gpl-tools-avr/lib/avr-libgcc/include" \
// RUN: -I "/Applications/Swift For Arduino.app/Contents/XPCServices/S4ABuildEngine.xpc/Contents/Resources/gpl-tools-avr/lib/avr-libc/include" \
// RUN: -enforce-exclusivity=unchecked -enable-library-evolution -disable-reflection-metadata -nostdimport \
// RUN: -I "/Applications/Swift For Arduino.app/Contents/XPCServices/S4ABuildEngine.xpc/Contents/Resources/uSwiftShims" \
// RUN: -I "/Applications/Swift For Arduino.app/Contents/XPCServices/S4ABuildEngine.xpc/Contents/Resources/uSwift-AVR" \
// RUN: %s 2>&1 | %FileCheck %s

// first scan for the expected warning(s), that will be reported before the IR is dumped
// also check unexpected warnings not produced
// CHECK-NOT: warning: runtime used that violates the realtime context{{.*}}testAllocations1
// CHECK-NOT: warning: runtime used that violates the realtime context{{.*}}testAllocations3
// CHECK-DAG: warning: runtime used that violates the realtime context{{.*}}testAllocations2
// CHECK-NOT: warning: runtime used that violates the realtime context{{.*}}testAllocations1
// CHECK-NOT: warning: runtime used that violates the realtime context{{.*}}testAllocations3

var buffer1: UnsafeMutableBufferPointer<UInt8>?

// 2)
@inline(never)
public func testAllocations1() {
    buffer1 = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: 5)
}

// CHECK-LABEL: define protected swiftcc void {{.*}}testAllocations
// CHECK-NEXT: entry:

// 4)
@realtime
@inline(never)
public func testAllocations2() {
    buffer1 = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: 6)
}

// CHECK-LABEL: define protected swiftcc void {{.*}}testAllocations2
// CHECK-NEXT: entry:

@norealtime
@inline(never)
public func testAllocations3() {
    buffer1 = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: 7)
}

// CHECK-LABEL: define protected swiftcc void {{.*}}testAllocations3
// CHECK-NEXT: entry:
