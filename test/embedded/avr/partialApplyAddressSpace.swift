// RUN: %target-swift-frontend -emit-ir %s -target avr-none-none-elf \
// RUN:   -wmo -enable-experimental-feature Embedded | %FileCheck %s
// REQUIRES: embedded_stdlib_cross_compiling
// REQUIRES: CODEGENERATOR=AVR
// REQUIRES: swift_feature_Embedded
// UNSUPPORTED: CPU=wasm32

// A closure that captures context needs a partial-apply forwarder. On AVR,
// code lives in the program address space (addrspace 1) while data lives in
// address space 0, so IRGen has to keep the forwarder in the program address
// space. Bitcasting it to a generic pointer is not merely wrong, it is invalid
// IR: a bitcast cannot change address space, and IRGen aborts in
// ConstantExpr::getCast ("Invalid constantexpr cast!").
//
// The capturing closures have to live in this test rather than being inherited
// from the standard library. Whether a stdlib closure survives into the
// client's IR depends on how the embedded stdlib itself was built -- a -Onone
// stdlib keeps it, a -O stdlib inlines it away -- so a stdlib-driven reproducer
// only fails on the Debug-stdlib CI jobs and passes everywhere else.

import Swift

var sink: ((Int) -> Void)?
var result: Int = 0

final class Counter {
  var n: Int = 0
}

// Captures two Ints, so the closure context is a heap box: the general path
// through emitFunctionPartialApplication.
func installValueCapture(offset: Int, scale: Int) {
  sink = { result = $0 &* scale &+ offset }
}

// Captures exactly one class reference, so the object is used directly as the
// context: the single-refcounted-context path, which emits its own cast of the
// forwarder.
func installObjectCapture(_ c: Counter) {
  sink = { c.n &+= $0 }
}

installValueCapture(offset: 3, scale: 2)
installObjectCapture(Counter())

// CHECK: target triple = "avr-none-none-elf"

// A closure value is { code pointer in the program address space, context
// pointer in the data address space }.
// CHECK: %swift.function = type { ptr addrspace(1), ptr }

// Both forwarders are emitted into the program address space...
// CHECK-DAG: define internal void @"$e{{.*}}19installValueCapture6offset5scaleySi_SitFySicfU_TA"({{.*}}) addrspace(1)
// CHECK-DAG: define internal void @"$e{{.*}}20installObjectCaptureyyAA7CounterCFySicfU_TA"({{.*}}) addrspace(1)

// ...and are stored into the closure without being cast out of it.
// CHECK-DAG: store ptr addrspace(1) {{.*}}@"$e{{.*}}19installValueCapture6offset5scaleySi_SitFySicfU_TA"{{.*}}, ptr @"$e{{.*}}4sinkySicSgvp"
// CHECK-DAG: store ptr addrspace(1) {{.*}}@"$e{{.*}}20installObjectCaptureyyAA7CounterCFySicfU_TA"{{.*}}, ptr @"$e{{.*}}4sinkySicSgvp"
