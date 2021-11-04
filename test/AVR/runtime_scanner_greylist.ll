; A low level test of the runtime scanner.
; Test cases: (see runtime_scanner_greylist.swift)

; (note: this was hand modified from the original llvm ir to remove attributes that shouldn't have been there. )

; RUN: %swift -S \
; RUN: -O -target avr-atmel-linux-gnueabihf \
; RUN: -Xcc "-DAVR_LIBC_DEFINED -DLIBC_DEFINED" "-DAVR_LIBC_DEFINED_SWIFT" \
; RUN: -I "/Applications/Swift For Arduino.app/Contents/XPCServices/S4ABuildEngine.xpc/Contents/Resources/gpl-tools-avr/lib/avr-libgcc/include" \
; RUN: -I "/Applications/Swift For Arduino.app/Contents/XPCServices/S4ABuildEngine.xpc/Contents/Resources/gpl-tools-avr/lib/avr-libc/include" \
; RUN: -enforce-exclusivity=unchecked -enable-library-evolution -disable-reflection-metadata -nostdimport \
; RUN: -I "/Applications/Swift For Arduino.app/Contents/XPCServices/S4ABuildEngine.xpc/Contents/Resources/uSwiftShims" \
; RUN: -I "/Applications/Swift For Arduino.app/Contents/XPCServices/S4ABuildEngine.xpc/Contents/Resources/uSwift-AVR" \
; RUN: %s 2>&1 | %FileCheck %s

; CHECK-NOT: warning: runtime used that violates the realtime context{{.*}}testAllocations1
; CHECK-NOT: warning: runtime used that violates the realtime context{{.*}}testAllocations3
; CHECK-DAG: warning: runtime used that violates the realtime context{{.*}}testAllocations2
; CHECK-NOT: warning: runtime used that violates the realtime context{{.*}}testAllocations1
; CHECK-NOT: warning: runtime used that violates the realtime context{{.*}}testAllocations3

; ModuleID = '<swift-imported-modules>'
source_filename = "<swift-imported-modules>"
target datalayout = "e-p:16:8-i8:8-i16:8-i32:8-i64:8-f32:8-f64:8-n8-a:8"
target triple = "avr-atmel-linux-gnueabihf"

module asm ".section .swift1_autolink_entries,\220x80000000\22"

%TSrys5UInt8VGSg = type <{ [4 x i8], [1 x i8] }>

@"$s24runtime_scanner_greylist7buffer1Srys5UInt8VGSgvp" = hidden local_unnamed_addr global %TSrys5UInt8VGSg zeroinitializer, align 2
@__swift_reflection_version = linkonce_odr hidden constant i16 3
@_swift1_autolink_entries = private constant [0 x i8] zeroinitializer, section ".swift1_autolink_entries", align 2
@llvm.used = appending global [6 x i8*] [i8* bitcast (void ()* @"$s24runtime_scanner_greylist16testAllocations1yyF" to i8*), i8* bitcast (void ()* @"$s24runtime_scanner_greylist16testAllocations2yyF" to i8*), i8* bitcast (void ()* @"$s24runtime_scanner_greylist16testAllocations3yyF" to i8*), i8* bitcast (i16* @__swift_reflection_version to i8*), i8* getelementptr inbounds ([0 x i8], [0 x i8]* @_swift1_autolink_entries, i32 0, i32 0), i8* bitcast (i32 (i32, i8**)* @main to i8*)], section "llvm.metadata"
; Function Attrs: nofree norecurse nounwind writeonly
define protected i32 @main(i32 %0, i8** nocapture readnone %1) #0 {
entry:
  store i16 0, i16* bitcast (%TSrys5UInt8VGSg* @"$s24runtime_scanner_greylist7buffer1Srys5UInt8VGSgvp" to i16*), align 2
  store i16 0, i16* bitcast (i8* getelementptr inbounds (%TSrys5UInt8VGSg, %TSrys5UInt8VGSg* @"$s24runtime_scanner_greylist7buffer1Srys5UInt8VGSgvp", i16 0, i32 0, i16 2) to i16*), align 2
  store i1 true, i1* bitcast ([1 x i8]* getelementptr inbounds (%TSrys5UInt8VGSg, %TSrys5UInt8VGSg* @"$s24runtime_scanner_greylist7buffer1Srys5UInt8VGSgvp", i16 0, i32 1) to i1*), align 2
  ret i32 0
}

; CHECK-LABEL: main:
; CHECK: ret
; CHECK-NEXT: .Lfunc_end

; Function Attrs: noinline nounwind
define protected swiftcc void @"$s24runtime_scanner_greylist16testAllocations1yyF"() #1 {
entry:
  %0 = tail call noalias i8* @swift_slowAlloc(i16 5, i16 -1) #2
  %1 = ptrtoint i8* %0 to i16
  %2 = icmp eq i8* %0, null
  %3 = select i1 %2, i16 0, i16 5
  store i16 %1, i16* bitcast (%TSrys5UInt8VGSg* @"$s24runtime_scanner_greylist7buffer1Srys5UInt8VGSgvp" to i16*), align 2
  store i16 %3, i16* bitcast (i8* getelementptr inbounds (%TSrys5UInt8VGSg, %TSrys5UInt8VGSg* @"$s24runtime_scanner_greylist7buffer1Srys5UInt8VGSgvp", i16 0, i32 0, i16 2) to i16*), align 2
  store i1 %2, i1* bitcast ([1 x i8]* getelementptr inbounds (%TSrys5UInt8VGSg, %TSrys5UInt8VGSg* @"$s24runtime_scanner_greylist7buffer1Srys5UInt8VGSgvp", i16 0, i32 1) to i1*), align 2
  ret void
}

; CHECK-LABEL: {{[[:alnum:]_]+}}testAllocations1{{[[:alnum:]]+}}:
; CHECK: ret
; CHECK-NEXT: .Lfunc_end

; Function Attrs: nounwind
declare i8* @swift_slowAlloc(i16, i16) local_unnamed_addr #2
; Function Attrs: noinline nounwind
define protected swiftcc void @"$s24runtime_scanner_greylist16testAllocations2yyF"() #1 !realtime !8 {
entry:
  %0 = tail call noalias i8* @swift_slowAlloc(i16 6, i16 -1) #2
  %1 = ptrtoint i8* %0 to i16
  %2 = icmp eq i8* %0, null
  %3 = select i1 %2, i16 0, i16 6
  store i16 %1, i16* bitcast (%TSrys5UInt8VGSg* @"$s24runtime_scanner_greylist7buffer1Srys5UInt8VGSgvp" to i16*), align 2
  store i16 %3, i16* bitcast (i8* getelementptr inbounds (%TSrys5UInt8VGSg, %TSrys5UInt8VGSg* @"$s24runtime_scanner_greylist7buffer1Srys5UInt8VGSgvp", i16 0, i32 0, i16 2) to i16*), align 2
  store i1 %2, i1* bitcast ([1 x i8]* getelementptr inbounds (%TSrys5UInt8VGSg, %TSrys5UInt8VGSg* @"$s24runtime_scanner_greylist7buffer1Srys5UInt8VGSgvp", i16 0, i32 1) to i1*), align 2
  ret void
}

; CHECK-LABEL: {{[[:alnum:]_]+}}testAllocations2{{[[:alnum:]]+}}:
; CHECK: ret
; CHECK-NEXT: .Lfunc_end

; Function Attrs: noinline nounwind
define protected swiftcc void @"$s24runtime_scanner_greylist16testAllocations3yyF"() #1 !norealtime !7 {
entry:
  %0 = tail call noalias i8* @swift_slowAlloc(i16 7, i16 -1) #2
  %1 = ptrtoint i8* %0 to i16
  %2 = icmp eq i8* %0, null
  %3 = select i1 %2, i16 0, i16 7
  store i16 %1, i16* bitcast (%TSrys5UInt8VGSg* @"$s24runtime_scanner_greylist7buffer1Srys5UInt8VGSgvp" to i16*), align 2
  store i16 %3, i16* bitcast (i8* getelementptr inbounds (%TSrys5UInt8VGSg, %TSrys5UInt8VGSg* @"$s24runtime_scanner_greylist7buffer1Srys5UInt8VGSgvp", i16 0, i32 0, i16 2) to i16*), align 2
  store i1 %2, i1* bitcast ([1 x i8]* getelementptr inbounds (%TSrys5UInt8VGSg, %TSrys5UInt8VGSg* @"$s24runtime_scanner_greylist7buffer1Srys5UInt8VGSgvp", i16 0, i32 1) to i1*), align 2
  ret void
}

; CHECK-LABEL: {{[[:alnum:]_]+}}testAllocations3{{[[:alnum:]]+}}:
; CHECK: ret
; CHECK-NEXT: .Lfunc_end

attributes #0 = { nofree norecurse nounwind writeonly "frame-pointer"="all" }
attributes #1 = { noinline nounwind "frame-pointer"="all" }
attributes #2 = { nounwind }

!swift.module.flags = !{!0}
!llvm.linker.options = !{}
!llvm.module.flags = !{!1, !2, !3, !4}
!llvm.asan.globals = !{!5, !6}

!0 = !{!"standard-library", i1 false}
!1 = !{i32 1, !"wchar_size", i32 2}
!2 = !{i32 7, !"PIC Level", i32 2}
!3 = !{i32 4, !"Objective-C Garbage Collection", i32 84084480}
!4 = !{i32 1, !"Swift Version", i32 7}
!5 = !{[0 x i8]* @_swift1_autolink_entries, null, null, i1 false, i1 true}
!6 = distinct !{null, null, null, i1 false, i1 true}
!7 = !{!"norealtime"}
!8 = !{!"realtime"}
