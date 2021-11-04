// RUN: %target-typecheck-verify-swift

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
struct Bar { }