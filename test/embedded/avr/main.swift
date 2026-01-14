// RUN: %target-swift-frontend -emit-ir %s %S/Inputs/ConstantSizeBuffer.swift -target avr-none-none-elf \
// RUN:   -wmo -enable-experimental-feature Embedded | %FileCheck %s
// REQUIRES: embedded_stdlib_cross_compiling
// REQUIRES: CODEGENERATOR=AVR
// REQUIRES: swift_feature_Embedded

testConstantSizeBuffer.memory[0] = 19

// CHECK: target triple = "avr-none-none-elf"
// CHECK: @"$e4main22testConstantSizeBuffer_Wz" = protected global i16 0, align 2
// CHECK: define protected i32 @main(i32 %0, ptr %1) addrspace(1)

// in our stdlib we would have
// tail call addrspace(1) void @swift_once(ptr nonnull @"$e4main22testConstantSizeBuffer_Wz", ptr addrspacecast (ptr addrspace(1) @"$e4main22testConstantSizeBuffer_WZ" to ptr), ptr undef)
// but it's inlined with the mainstream embedded stdlib because swift_once is implemented in swift
// this is probably a better model tbh
