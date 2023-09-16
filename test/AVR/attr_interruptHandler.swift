// attr_interruptHandler.swift

// Check that warnings on use of @interruptHandler attribute are correct.

// RUN: %target-typecheck-verify-swift -target avr-atmel-linux-gnueabihf \
// RUN: -enforce-exclusivity=unchecked -disable-reflection-metadata -nostdimport \
// RUN: -Xcc "-DAVR_LIBC_DEFINED -DLIBC_DEFINED" "-DAVR_LIBC_DEFINED_SWIFT" \
// RUN: -I "/Applications/Swift For Arduino.app/Contents/XPCServices/BuildEngine.xpc/Contents/Resources/uSwiftShims" \
// RUN: -I "/Applications/Swift For Arduino.app/Contents/XPCServices/BuildEngine.xpc/Contents/Resources/uSwift-AVR" \
// RUN: -I "/Applications/Swift For Arduino.app/Contents/XPCServices/BuildEngine.xpc/Contents/Resources/gpl-tools-avr/lib/avr-libgcc/include" \
// RUN: -I "/Applications/Swift For Arduino.app/Contents/XPCServices/BuildEngine.xpc/Contents/Resources/gpl-tools-avr/lib/avr-libc/include" \
// RUN: -disable-implicit-concurrency-module-import -disable-implicit-string-processing-module-import


@interruptHandler func foo() { }

struct Foo {
	@interruptHandler func foo() { }
}

@interruptHandler // expected-error {{@interruptHandler may only be used on 'func' declarations}}
struct Bar { }