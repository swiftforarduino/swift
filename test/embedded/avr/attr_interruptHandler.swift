// RUN: %target-typecheck-verify-swift \
// RUN: -wmo -enable-experimental-feature Embedded

// xREQUIRES: embedded_stdlib_cross_compiling
// xREQUIRES: CODEGENERATOR=AVR
// xREQUIRES: swift_feature_Embedded

// Check that warnings on use of @interruptHandler attribute are correct.
//-target avr-none-none-elf 

@interruptHandler func foo() { }

struct Foo {
	@interruptHandler func foo() { }
}

@interruptHandler // expected-error {{@interruptHandler may only be used on 'func' declarations}}
struct Bar { }