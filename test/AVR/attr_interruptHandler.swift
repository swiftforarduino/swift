// RUN: %target-typecheck-verify-swift -target avr-atmel-linux-gnueabihf \
// RUN: -enforce-exclusivity=unchecked -disable-reflection-metadata -nostdimport \
// RUN: -I "/Applications/Swift For Arduino.app/Contents/XPCServices/BuildEngine.xpc/Contents/Resources/uSwiftShims" \
// RUN: -I "/Applications/Swift For Arduino.app/Contents/XPCServices/BuildEngine.xpc/Contents/Resources/uSwift-AVR"

@interruptHandler func foo() { }

struct Foo {
	@interruptHandler func foo() { }
}

@interruptHandler // expected-error {{@interruptHandler may only be used on 'func' declarations}}
struct Bar { }