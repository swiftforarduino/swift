// RUN: %target-swift-frontend -emit-ir %s -target avr-none-none-elf \
// RUN:   -wmo -enable-experimental-feature Embedded | %FileCheck %s
// REQUIRES: embedded_stdlib_cross_compiling
// REQUIRES: CODEGENERATOR=AVR
// REQUIRES: swift_feature_Embedded

public typealias StringLiteralType = StaticString

let testString = "Hello, World!"

// CHECK: addrspace(1) constant [14 x i8] c"Hello, World!\00"

