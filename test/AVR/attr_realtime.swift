// RUN: %target-typecheck-verify-swift -target avr-atmel-linux-gnueabihf \
// RUN: -Xcc "-DAVR_LIBC_DEFINED -DLIBC_DEFINED" "-DAVR_LIBC_DEFINED_SWIFT" \
// RUN: -I "/Applications/Swift For Arduino.app/Contents/XPCServices/S4ABuildEngine.xpc/Contents/Resources/gpl-tools-avr/lib/avr-libgcc/include" \
// RUN: -I "/Applications/Swift For Arduino.app/Contents/XPCServices/S4ABuildEngine.xpc/Contents/Resources/gpl-tools-avr/lib/avr-libc/include" \
// RUN: -enforce-exclusivity=unchecked -enable-library-evolution -disable-reflection-metadata -nostdimport \
// RUN: -I "/Applications/Swift For Arduino.app/Contents/XPCServices/S4ABuildEngine.xpc/Contents/Resources/uSwiftShims" \
// RUN: -I "/Applications/Swift For Arduino.app/Contents/XPCServices/S4ABuildEngine.xpc/Contents/Resources/uSwift-AVR"

@realtime func foo() { }

@norealtime func foo2() { }

struct Foo {
	@realtime func foo() { }
}

struct Foo2 {
	@norealtime func foo2() { }
}

@realtime // expected-error {{@realtime may only be used on 'func' declarations}}
struct Bar { }

@norealtime // expected-error {{@norealtime may only be used on 'func' declarations}}
struct Bar2 { }