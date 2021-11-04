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

; CHECK-NOT: error: runtime call used that is missing in uSwift, not available on this platform
; CHECK-NOT: warning: runtime used that violates the realtime context

; ModuleID = 'sides.bc'
source_filename = "main.bc"
target datalayout = "e-p:16:8-i8:8-i16:8-i32:8-i64:8-f32:8-f64:8-n8-a:8"
target triple = "avr-atmel-linux-gnueabihf"

module asm ".section .swift1_autolink_entries,\220x80000000\22"

%Ts5UInt8V = type <{ i8 }>

@"$s4main9testCounts5UInt8Vvp" = weak_odr hidden global %Ts5UInt8V <{ i8 1 }>, align 1, !dbg !0
@__swift_reflection_version = linkonce_odr hidden constant i16 3
@_swift1_autolink_entries = private constant [6 x i8] c"-lAVR\00", section ".swift1_autolink_entries", align 2
@llvm.used = appending global [5 x i8*] [i8* bitcast ({ i8*, %Ts5UInt8V* } (i8*)* @"$s4main9testCounts5UInt8VvM" to i8*), i8* bitcast (i8 ()* @"$s4main9testCounts5UInt8Vvg" to i8*), i8* bitcast (void (i8)* @"$s4main9testCounts5UInt8Vvs" to i8*), i8* bitcast (i16* @__swift_reflection_version to i8*), i8* getelementptr inbounds ([6 x i8], [6 x i8]* @_swift1_autolink_entries, i32 0, i32 0)], section "llvm.metadata"

; Function Attrs: norecurse nounwind readnone
define hidden swiftcc i8* @"$s4main9testCounts5UInt8Vvau"() local_unnamed_addr #0 !dbg !32 !realtime !36 {
  ret i8* getelementptr inbounds (%Ts5UInt8V, %Ts5UInt8V* @"$s4main9testCounts5UInt8Vvp", i16 0, i32 0), !dbg !37
}

; Function Attrs: nounwind
define protected swiftcc i8 @"$s4main9testCounts5UInt8Vvg"() #1 !dbg !38 !realtime !36 {
  %1 = alloca [6 x i8], align 2
  %2 = getelementptr inbounds [6 x i8], [6 x i8]* %1, i16 0, i16 0, !dbg !41
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* nonnull %2), !dbg !41
  call void @swift_beginAccess(i8* getelementptr inbounds (%Ts5UInt8V, %Ts5UInt8V* @"$s4main9testCounts5UInt8Vvp", i16 0, i32 0), [6 x i8]* nonnull %1, i16 0, i8* null) #3, !dbg !41
  %3 = load i8, i8* getelementptr inbounds (%Ts5UInt8V, %Ts5UInt8V* @"$s4main9testCounts5UInt8Vvp", i16 0, i32 0), align 1, !dbg !41
  ret i8 %3, !dbg !44
}

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: nounwind
declare void @swift_beginAccess(i8*, [6 x i8]*, i16, i8*) local_unnamed_addr #3

; Function Attrs: nounwind
define protected swiftcc void @"$s4main9testCounts5UInt8Vvs"(i8 %0) #1 !dbg !45 !realtime !36 {
  %2 = alloca [6 x i8], align 2
  call void @llvm.dbg.value(metadata i8 %0, metadata !49, metadata !DIExpression()), !dbg !51
  %3 = getelementptr inbounds [6 x i8], [6 x i8]* %2, i16 0, i16 0, !dbg !52
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* nonnull %3), !dbg !52
  call void @swift_beginAccess(i8* getelementptr inbounds (%Ts5UInt8V, %Ts5UInt8V* @"$s4main9testCounts5UInt8Vvp", i16 0, i32 0), [6 x i8]* nonnull %2, i16 1, i8* null) #3, !dbg !52
  store i8 %0, i8* getelementptr inbounds (%Ts5UInt8V, %Ts5UInt8V* @"$s4main9testCounts5UInt8Vvp", i16 0, i32 0), align 1, !dbg !52
  ret void, !dbg !55
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #4

; Function Attrs: noinline nounwind
define protected swiftcc { i8*, %Ts5UInt8V* } @"$s4main9testCounts5UInt8VvM"(i8* noalias dereferenceable(8) %0) #5 !dbg !56 !realtime !36 {
  %2 = bitcast i8* %0 to [6 x i8]*, !dbg !59
  tail call void @llvm.lifetime.start.p0i8(i64 -1, i8* nonnull %0), !dbg !59
  tail call void @swift_beginAccess(i8* getelementptr inbounds (%Ts5UInt8V, %Ts5UInt8V* @"$s4main9testCounts5UInt8Vvp", i16 0, i32 0), [6 x i8]* nonnull %2, i16 33, i8* null) #3, !dbg !59
  ret { i8*, %Ts5UInt8V* } { i8* bitcast (void (i8*, i1)* @"$s4main9testCounts5UInt8VvM.resume.0" to i8*), %Ts5UInt8V* @"$s4main9testCounts5UInt8Vvp" }
}

define internal swiftcc void @"$s4main9testCounts5UInt8VvM.resume.0"(i8* noalias nonnull align 2 dereferenceable(8) %0, i1 %1) #6 !dbg !62 !realtime !36 {
  %3 = bitcast i8* %0 to [6 x i8]*, !dbg !63
  tail call void @swift_endAccess([6 x i8]* nonnull %3) #3, !dbg !66
  tail call void @llvm.lifetime.end.p0i8(i64 -1, i8* nonnull %0), !dbg !66
  ret void, !dbg !66
}

declare swiftcc void @"$ss5UInt8VIetAYl_TC"(i8* noalias dereferenceable(8), i1) #6

; Function Attrs: nofree nounwind
declare noalias i8* @malloc(i16) #7

; Function Attrs: nounwind
declare void @free(i8* nocapture) #3

; Function Attrs: nounwind
declare token @llvm.coro.id.retcon.once(i32, i32, i8*, i8*, i8*, i8*) #3

; Function Attrs: nounwind
declare i8* @llvm.coro.begin(token, i8* writeonly) #3

; Function Attrs: nounwind
declare void @swift_endAccess([6 x i8]*) local_unnamed_addr #3

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #2

attributes #0 = { norecurse nounwind readnone "frame-pointer"="all" }
attributes #1 = { nounwind "frame-pointer"="all" }
attributes #2 = { argmemonly nofree nosync nounwind willreturn }
attributes #3 = { nounwind }
attributes #4 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #5 = { noinline nounwind "frame-pointer"="all" }
attributes #6 = { "frame-pointer"="all" }
attributes #7 = { nofree nounwind }

!llvm.dbg.cu = !{!8, !18}
!swift.module.flags = !{!20}
!llvm.linker.options = !{}
!llvm.module.flags = !{!21, !22, !23, !24, !25, !26, !27, !28, !29}
!llvm.asan.globals = !{!30, !31}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "testCount", linkageName: "$s4main9testCounts5UInt8Vvp", scope: !2, file: !3, line: 1, type: !4, isLocal: false, isDefinition: true)
!2 = !DIModule(scope: null, name: "main")
!3 = !DIFile(filename: "sides.swift", directory: "/Users/carlpeto/Documents/Code/AVR2")
!4 = !DICompositeType(tag: DW_TAG_structure_type, name: "UInt8", scope: !6, file: !5, size: 8, elements: !7, runtimeLang: DW_LANG_Swift, identifier: "$ss5UInt8VD")
!5 = !DIFile(filename: "uSwift/bin/AVR/Swift.swiftmodule", directory: "/Users/carlpeto/Documents/Code/AVR2")
!6 = !DIModule(scope: null, name: "Swift", configMacros: "\22-DAVR_LIBC_DEFINED -DLIBC_DEFINED\22", includePath: "/Users/carlpeto/Documents/Code/AVR2/uSwift/bin/AVR/Swift.swiftmodule")
!7 = !{}
!8 = distinct !DICompileUnit(language: DW_LANG_Swift, file: !3, producer: "Swift version 5.3-dev (LLVM 9bbbe0cda8, Swift 571c4d95d3)", isOptimized: true, flags: "-private-discriminator _EE61D5EFAD861E53B41E724A0DA1DCB5", runtimeVersion: 5, emissionKind: FullDebug, enums: !7, globals: !9, imports: !10)
!9 = !{!0}
!10 = !{!11, !12, !14, !16}
!11 = !DIImportedEntity(tag: DW_TAG_imported_module, scope: !3, entity: !2, file: !3)
!12 = !DIImportedEntity(tag: DW_TAG_imported_module, scope: !13, entity: !6, file: !13)
!13 = !DIFile(filename: "<compiler-generated>", directory: "")
!14 = !DIImportedEntity(tag: DW_TAG_imported_module, scope: !3, entity: !15, file: !3)
!15 = !DIModule(scope: null, name: "__ObjC", configMacros: "\22-DAVR_LIBC_DEFINED -DLIBC_DEFINED\22", includePath: "<imports>")
!16 = !DIImportedEntity(tag: DW_TAG_imported_module, scope: !3, entity: !17, file: !3)
!17 = !DIModule(scope: null, name: "AVR", configMacros: "\22-DAVR_LIBC_DEFINED -DLIBC_DEFINED\22", includePath: "/Users/carlpeto/Documents/Code/AVR2/AVR/AVR.swiftmodule")
!18 = distinct !DICompileUnit(language: DW_LANG_C99, file: !19, producer: "clang version 10.0.0 (git@github.com:carlos4242/llvm-project.git 9bbbe0cda82f3263637d9769e6e20a563b1cb359)", isOptimized: true, flags: "-private-discriminator _EE61D5EFAD861E53B41E724A0DA1DCB5", runtimeVersion: 0, emissionKind: FullDebug, enums: !7, splitDebugInlining: false, nameTableKind: None)
!19 = !DIFile(filename: "<swift-imported-modules>", directory: "/Users/carlpeto/Documents/Code/AVR2")
!20 = !{!"standard-library", i1 false}
!21 = !{i32 7, !"Dwarf Version", i32 4}
!22 = !{i32 2, !"Debug Info Version", i32 3}
!23 = !{i32 1, !"wchar_size", i32 2}
!24 = !{i32 7, !"PIC Level", i32 2}
!25 = !{i32 1, !"Objective-C Garbage Collection", i8 0}
!26 = !{i32 1, !"Swift Version", i32 7}
!27 = !{i32 1, !"Swift ABI Version", i32 7}
!28 = !{i32 1, !"Swift Major Version", i8 5}
!29 = !{i32 1, !"Swift Minor Version", i8 3}
!30 = !{[6 x i8]* @_swift1_autolink_entries, null, null, i1 false, i1 true}
!31 = distinct !{null, null, null, i1 false, i1 true}
!32 = distinct !DISubprogram(linkageName: "$s4main9testCounts5UInt8Vvau", scope: !2, file: !3, line: 1, type: !33, flags: DIFlagArtificial, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !8, retainedNodes: !7)
!33 = !DISubroutineType(types: !34)
!34 = !{!35}
!35 = !DIDerivedType(tag: DW_TAG_pointer_type, name: "$sBpD", baseType: null, size: 16)
!36 = !{!"realtime"}
!37 = !DILocation(line: 1, column: 12, scope: !32)
!38 = distinct !DISubprogram(name: "testCount.get", linkageName: "$s4main9testCounts5UInt8Vvg", scope: !2, file: !3, line: 1, type: !39, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !8, retainedNodes: !7)
!39 = !DISubroutineType(types: !40)
!40 = !{!4}
!41 = !DILocation(line: 0, scope: !42)
!42 = !DILexicalBlockFile(scope: !43, file: !13, discriminator: 0)
!43 = distinct !DILexicalBlock(scope: !38, file: !3, line: 1, column: 12)
!44 = !DILocation(line: 1, column: 12, scope: !43)
!45 = distinct !DISubprogram(name: "testCount.set", linkageName: "$s4main9testCounts5UInt8Vvs", scope: !2, file: !3, line: 1, type: !46, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !8, retainedNodes: !7)
!46 = !DISubroutineType(types: !47)
!47 = !{!48, !4}
!48 = !DICompositeType(tag: DW_TAG_structure_type, name: "$sytD", file: !3, elements: !7, runtimeLang: DW_LANG_Swift, identifier: "$sytD")
!49 = !DILocalVariable(name: "value", arg: 1, scope: !45, file: !3, line: 1, type: !50)
!50 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !4)
!51 = !DILocation(line: 1, column: 12, scope: !45)
!52 = !DILocation(line: 0, scope: !53)
!53 = !DILexicalBlockFile(scope: !54, file: !13, discriminator: 0)
!54 = distinct !DILexicalBlock(scope: !45, file: !3, line: 1, column: 12)
!55 = !DILocation(line: 1, column: 12, scope: !54)
!56 = distinct !DISubprogram(name: "testCount.modify", linkageName: "$s4main9testCounts5UInt8VvM", scope: !2, file: !3, line: 1, type: !57, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !8, retainedNodes: !7)
!57 = !DISubroutineType(types: !58)
!58 = !{!48}
!59 = !DILocation(line: 0, scope: !60)
!60 = !DILexicalBlockFile(scope: !61, file: !13, discriminator: 0)
!61 = distinct !DILexicalBlock(scope: !56, file: !3, line: 1, column: 12)
!62 = distinct !DISubprogram(name: "testCount.modify", linkageName: "$s4main9testCounts5UInt8VvM", scope: !2, file: !3, line: 1, type: !57, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !8, retainedNodes: !7)
!63 = !DILocation(line: 0, scope: !64)
!64 = !DILexicalBlockFile(scope: !65, file: !13, discriminator: 0)
!65 = distinct !DILexicalBlock(scope: !62, file: !3, line: 1, column: 12)
!66 = !DILocation(line: 1, column: 12, scope: !65)
