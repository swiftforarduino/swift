; A low level test of the runtime scanner.
; Test cases: (see runtime_scanner_greylist.swift)

; (note: this was hand modified from the original llvm ir to remove attributes that shouldn't have been there. )

; RUN: %swift -S -no-runtime-verify \
; RUN: -O -target avr-atmel-linux-gnueabihf \
; RUN: -Xcc "-DAVR_LIBC_DEFINED -DLIBC_DEFINED" "-DAVR_LIBC_DEFINED_SWIFT" \
; RUN: -I "/Applications/Swift For Arduino.app/Contents/XPCServices/S4ABuildEngine.xpc/Contents/Resources/gpl-tools-avr/lib/avr-libgcc/include" \
; RUN: -I "/Applications/Swift For Arduino.app/Contents/XPCServices/S4ABuildEngine.xpc/Contents/Resources/gpl-tools-avr/lib/avr-libc/include" \
; RUN: -enforce-exclusivity=unchecked -enable-library-evolution -disable-reflection-metadata -nostdimport \
; RUN: -I "/Applications/Swift For Arduino.app/Contents/XPCServices/S4ABuildEngine.xpc/Contents/Resources/uSwiftShims" \
; RUN: -I "/Applications/Swift For Arduino.app/Contents/XPCServices/S4ABuildEngine.xpc/Contents/Resources/uSwift-AVR" \
; RUN: %s 2>&1 | %FileCheck %s

; CHECK-NOT: error: runtime call used that is missing in uSwift, not available on this platform

; ModuleID = '<swift-imported-modules>'
source_filename = "<swift-imported-modules>"
target datalayout = "e-p:16:8-i8:8-i16:8-i32:8-i64:8-f32:8-f64:8-n8-a:8"
target triple = "avr-atmel-linux-gnueabihf"

module asm ".section .swift1_autolink_entries,\220x80000000\22"

%swift.method_descriptor = type { i32, i16 }
%T25runtime_scanner_blacklist12MyDummyClassC = type <{ %swift.refcounted, %TSb }>
%swift.refcounted = type { %swift.type*, i16 }
%TSb = type <{ i1 }>
%swift.type = type { i16 }
%swift.opaque = type opaque
%swift.type_metadata_record = type { i16 }
%swift.metadata_response = type { %swift.type*, i16 }

@"$s25runtime_scanner_blacklist12MyDummyClassC7testVarSbvpWvd" = hidden local_unnamed_addr constant i16 4, align 2
@"$sBoWV" = external global i8*, align 2
@0 = private constant [26 x i8] c"runtime_scanner_blacklist\00"
@"$s25runtime_scanner_blacklistMXM" = linkonce_odr hidden constant <{ i32, i32, i16 }> <{ i32 0, i32 0, i16 sub (i16 ptrtoint ([26 x i8]* @0 to i16), i16 ptrtoint (i16* getelementptr inbounds (<{ i32, i32, i16 }>, <{ i32, i32, i16 }>* @"$s25runtime_scanner_blacklistMXM", i32 0, i32 2) to i16)) }>, section ".rodata", align 4
@1 = private constant [13 x i8] c"MyDummyClass\00"
@"$s25runtime_scanner_blacklist12MyDummyClassCMn" = hidden constant <{ i32, i16, i16, i16, i32, i32, i32, i32, i32, i32, i32, i32, i32, %swift.method_descriptor, %swift.method_descriptor, %swift.method_descriptor, %swift.method_descriptor }> <{ i32 -2147483568, i16 sub (i16 ptrtoint (<{ i32, i32, i16 }>* @"$s25runtime_scanner_blacklistMXM" to i16), i16 ptrtoint (i16* getelementptr inbounds (<{ i32, i16, i16, i16, i32, i32, i32, i32, i32, i32, i32, i32, i32, %swift.method_descriptor, %swift.method_descriptor, %swift.method_descriptor, %swift.method_descriptor }>, <{ i32, i16, i16, i16, i32, i32, i32, i32, i32, i32, i32, i32, i32, %swift.method_descriptor, %swift.method_descriptor, %swift.method_descriptor, %swift.method_descriptor }>* @"$s25runtime_scanner_blacklist12MyDummyClassCMn", i32 0, i32 1) to i16)), i16 sub (i16 ptrtoint ([13 x i8]* @1 to i16), i16 ptrtoint (i16* getelementptr inbounds (<{ i32, i16, i16, i16, i32, i32, i32, i32, i32, i32, i32, i32, i32, %swift.method_descriptor, %swift.method_descriptor, %swift.method_descriptor, %swift.method_descriptor }>, <{ i32, i16, i16, i16, i32, i32, i32, i32, i32, i32, i32, i32, i32, %swift.method_descriptor, %swift.method_descriptor, %swift.method_descriptor, %swift.method_descriptor }>* @"$s25runtime_scanner_blacklist12MyDummyClassCMn", i32 0, i32 2) to i16)), i16 sub (i16 ptrtoint (%swift.metadata_response (i16)* @"$s25runtime_scanner_blacklist12MyDummyClassCMa" to i16), i16 ptrtoint (i16* getelementptr inbounds (<{ i32, i16, i16, i16, i32, i32, i32, i32, i32, i32, i32, i32, i32, %swift.method_descriptor, %swift.method_descriptor, %swift.method_descriptor, %swift.method_descriptor }>, <{ i32, i16, i16, i16, i32, i32, i32, i32, i32, i32, i32, i32, i32, %swift.method_descriptor, %swift.method_descriptor, %swift.method_descriptor, %swift.method_descriptor }>* @"$s25runtime_scanner_blacklist12MyDummyClassCMn", i32 0, i32 3) to i16)), i32 0, i32 0, i32 2, i32 24, i32 5, i32 1, i32 19, i32 20, i32 4, %swift.method_descriptor { i32 18, i16 0 }, %swift.method_descriptor { i32 19, i16 0 }, %swift.method_descriptor { i32 20, i16 0 }, %swift.method_descriptor { i32 1, i16 0 } }>, section ".rodata", align 4
@"$s25runtime_scanner_blacklist12MyDummyClassCMf" = internal global <{ void (%T25runtime_scanner_blacklist12MyDummyClassC*)*, i8**, i16, %swift.type*, %swift.opaque*, %swift.opaque*, i16, i32, i32, i32, i16, i16, i32, i32, <{ i32, i16, i16, i16, i32, i32, i32, i32, i32, i32, i32, i32, i32, %swift.method_descriptor, %swift.method_descriptor, %swift.method_descriptor, %swift.method_descriptor }>*, i8*, i16, i8*, i8*, i8*, i8* }> <{ void (%T25runtime_scanner_blacklist12MyDummyClassC*)* @"$s25runtime_scanner_blacklist12MyDummyClassCfD", i8** @"$sBoWV", i16 0, %swift.type* null, %swift.opaque* null, %swift.opaque* null, i16 1, i32 2, i32 0, i32 5, i16 1, i16 0, i32 52, i32 4, <{ i32, i16, i16, i16, i32, i32, i32, i32, i32, i32, i32, i32, i32, %swift.method_descriptor, %swift.method_descriptor, %swift.method_descriptor, %swift.method_descriptor }>* @"$s25runtime_scanner_blacklist12MyDummyClassCMn", i8* null, i16 4, i8* bitcast (void ()* @swift_deletedMethodError to i8*), i8* bitcast (void ()* @swift_deletedMethodError to i8*), i8* bitcast (void ()* @swift_deletedMethodError to i8*), i8* bitcast (void ()* @swift_deletedMethodError to i8*) }>, align 2
@"\01l_type_metadata_table" = private constant [1 x %swift.type_metadata_record] [%swift.type_metadata_record { i16 sub (i16 ptrtoint (<{ i32, i16, i16, i16, i32, i32, i32, i32, i32, i32, i32, i32, i32, %swift.method_descriptor, %swift.method_descriptor, %swift.method_descriptor, %swift.method_descriptor }>* @"$s25runtime_scanner_blacklist12MyDummyClassCMn" to i16), i16 ptrtoint ([1 x %swift.type_metadata_record]* @"\01l_type_metadata_table" to i16)) }], section "swift5_type_metadata", align 4
@__swift_reflection_version = linkonce_odr hidden constant i16 3
@_swift1_autolink_entries = private constant [0 x i8] zeroinitializer, section ".swift1_autolink_entries", align 2
@llvm.used = appending global [4 x i8*] [i8* bitcast ([1 x %swift.type_metadata_record]* @"\01l_type_metadata_table" to i8*), i8* bitcast (i16* @__swift_reflection_version to i8*), i8* getelementptr inbounds ([0 x i8], [0 x i8]* @_swift1_autolink_entries, i32 0, i32 0), i8* bitcast (i32 (i32, i8**)* @main to i8*)], section "llvm.metadata"

@"$s25runtime_scanner_blacklist12MyDummyClassC7testVarSbvgTq" = hidden alias %swift.method_descriptor, getelementptr inbounds (<{ i32, i16, i16, i16, i32, i32, i32, i32, i32, i32, i32, i32, i32, %swift.method_descriptor, %swift.method_descriptor, %swift.method_descriptor, %swift.method_descriptor }>, <{ i32, i16, i16, i16, i32, i32, i32, i32, i32, i32, i32, i32, i32, %swift.method_descriptor, %swift.method_descriptor, %swift.method_descriptor, %swift.method_descriptor }>* @"$s25runtime_scanner_blacklist12MyDummyClassCMn", i32 0, i32 13)
@"$s25runtime_scanner_blacklist12MyDummyClassC7testVarSbvsTq" = hidden alias %swift.method_descriptor, getelementptr inbounds (<{ i32, i16, i16, i16, i32, i32, i32, i32, i32, i32, i32, i32, i32, %swift.method_descriptor, %swift.method_descriptor, %swift.method_descriptor, %swift.method_descriptor }>, <{ i32, i16, i16, i16, i32, i32, i32, i32, i32, i32, i32, i32, i32, %swift.method_descriptor, %swift.method_descriptor, %swift.method_descriptor, %swift.method_descriptor }>* @"$s25runtime_scanner_blacklist12MyDummyClassCMn", i32 0, i32 14)
@"$s25runtime_scanner_blacklist12MyDummyClassC7testVarSbvMTq" = hidden alias %swift.method_descriptor, getelementptr inbounds (<{ i32, i16, i16, i16, i32, i32, i32, i32, i32, i32, i32, i32, i32, %swift.method_descriptor, %swift.method_descriptor, %swift.method_descriptor, %swift.method_descriptor }>, <{ i32, i16, i16, i16, i32, i32, i32, i32, i32, i32, i32, i32, i32, %swift.method_descriptor, %swift.method_descriptor, %swift.method_descriptor, %swift.method_descriptor }>* @"$s25runtime_scanner_blacklist12MyDummyClassCMn", i32 0, i32 15)
@"$s25runtime_scanner_blacklist12MyDummyClassCACycfCTq" = hidden alias %swift.method_descriptor, getelementptr inbounds (<{ i32, i16, i16, i16, i32, i32, i32, i32, i32, i32, i32, i32, i32, %swift.method_descriptor, %swift.method_descriptor, %swift.method_descriptor, %swift.method_descriptor }>, <{ i32, i16, i16, i16, i32, i32, i32, i32, i32, i32, i32, i32, i32, %swift.method_descriptor, %swift.method_descriptor, %swift.method_descriptor, %swift.method_descriptor }>* @"$s25runtime_scanner_blacklist12MyDummyClassCMn", i32 0, i32 16)
@"$s25runtime_scanner_blacklist12MyDummyClassCN" = hidden alias %swift.type, bitcast (i16* getelementptr inbounds (<{ void (%T25runtime_scanner_blacklist12MyDummyClassC*)*, i8**, i16, %swift.type*, %swift.opaque*, %swift.opaque*, i16, i32, i32, i32, i16, i16, i32, i32, <{ i32, i16, i16, i16, i32, i32, i32, i32, i32, i32, i32, i32, i32, %swift.method_descriptor, %swift.method_descriptor, %swift.method_descriptor, %swift.method_descriptor }>*, i8*, i16, i8*, i8*, i8*, i8* }>, <{ void (%T25runtime_scanner_blacklist12MyDummyClassC*)*, i8**, i16, %swift.type*, %swift.opaque*, %swift.opaque*, i16, i32, i32, i32, i16, i16, i32, i32, <{ i32, i16, i16, i16, i32, i32, i32, i32, i32, i32, i32, i32, i32, %swift.method_descriptor, %swift.method_descriptor, %swift.method_descriptor, %swift.method_descriptor }>*, i8*, i16, i8*, i8*, i8*, i8* }>* @"$s25runtime_scanner_blacklist12MyDummyClassCMf", i32 0, i32 2) to %swift.type*)
; Function Attrs: norecurse nounwind readnone
define protected i32 @main(i32 %0, i8** nocapture readnone %1) #0 !norealtime !10 {
entry:
  ret i32 0
}

; CHECK-LABEL: main:
; CHECK: ret
; CHECK-NEXT: .Lfunc_end

; Function Attrs: nounwind
define hidden swiftcc void @"$s25runtime_scanner_blacklist12MyDummyClassCfD"(%T25runtime_scanner_blacklist12MyDummyClassC* swiftself %0) #1 !norealtime !10 {
entry:
  %1 = getelementptr %T25runtime_scanner_blacklist12MyDummyClassC, %T25runtime_scanner_blacklist12MyDummyClassC* %0, i16 0, i32 0
  tail call void @swift_deallocClassInstance(%swift.refcounted* %1, i16 5, i16 1)
  ret void
}

; CHECK-LABEL: {{[[:alnum:]_]+}}MyDummyClassCfD:
; CHECK: ret
; CHECK-NEXT: .Lfunc_end

; Function Attrs: noinline norecurse nounwind readnone
define hidden swiftcc %swift.metadata_response @"$s25runtime_scanner_blacklist12MyDummyClassCMa"(i16 %0) #2 {
entry:
  ret %swift.metadata_response { %swift.type* bitcast (i16* getelementptr inbounds (<{ void (%T25runtime_scanner_blacklist12MyDummyClassC*)*, i8**, i16, %swift.type*, %swift.opaque*, %swift.opaque*, i16, i32, i32, i32, i16, i16, i32, i32, <{ i32, i16, i16, i16, i32, i32, i32, i32, i32, i32, i32, i32, i32, %swift.method_descriptor, %swift.method_descriptor, %swift.method_descriptor, %swift.method_descriptor }>*, i8*, i16, i8*, i8*, i8*, i8* }>, <{ void (%T25runtime_scanner_blacklist12MyDummyClassC*)*, i8**, i16, %swift.type*, %swift.opaque*, %swift.opaque*, i16, i32, i32, i32, i16, i16, i32, i32, <{ i32, i16, i16, i16, i32, i32, i32, i32, i32, i32, i32, i32, i32, %swift.method_descriptor, %swift.method_descriptor, %swift.method_descriptor, %swift.method_descriptor }>*, i8*, i16, i8*, i8*, i8*, i8* }>* @"$s25runtime_scanner_blacklist12MyDummyClassCMf", i32 0, i32 2) to %swift.type*), i16 0 }
}

; CHECK-LABEL: {{[[:alnum:]_]+}}MyDummyClassCMa:
; CHECK: ret
; CHECK-NEXT: .Lfunc_end

; Function Attrs: nounwind
declare void @swift_deletedMethodError() #3
; Function Attrs: nounwind
declare void @swift_deallocClassInstance(%swift.refcounted*, i16, i16) local_unnamed_addr #3

attributes #0 = { norecurse nounwind readnone "frame-pointer"="all" }
attributes #1 = { nounwind "frame-pointer"="all" }
attributes #2 = { noinline norecurse nounwind readnone "frame-pointer"="none" }
attributes #3 = { nounwind }

!swift.module.flags = !{!0}
!llvm.asan.globals = !{!1, !2, !3, !4, !5}
!llvm.linker.options = !{}
!llvm.module.flags = !{!6, !7, !8, !9}

!0 = !{!"standard-library", i1 false}
!1 = !{<{ i32, i32, i16 }>* @"$s25runtime_scanner_blacklistMXM", null, null, i1 false, i1 true}
!2 = !{<{ i32, i16, i16, i16, i32, i32, i32, i32, i32, i32, i32, i32, i32, %swift.method_descriptor, %swift.method_descriptor, %swift.method_descriptor, %swift.method_descriptor }>* @"$s25runtime_scanner_blacklist12MyDummyClassCMn", null, null, i1 false, i1 true}
!3 = !{[1 x %swift.type_metadata_record]* @"\01l_type_metadata_table", null, null, i1 false, i1 true}
!4 = !{[0 x i8]* @_swift1_autolink_entries, null, null, i1 false, i1 true}
!5 = distinct !{null, null, null, i1 false, i1 true}
!6 = !{i32 1, !"wchar_size", i32 2}
!7 = !{i32 7, !"PIC Level", i32 2}
!8 = !{i32 4, !"Objective-C Garbage Collection", i32 84084480}
!9 = !{i32 1, !"Swift Version", i32 7}
!10 = !{!"norealtime"}
