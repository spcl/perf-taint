; ModuleID = 'tests/extrap/globals_tu2.cpp'
source_filename = "tests/extrap/globals_tu2.cpp"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@global2 = dso_local global double 2.000000e+02, align 8, !dbg !0
@.str = private unnamed_addr constant [7 x i8] c"extrap\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [29 x i8] c"tests/extrap/globals_tu2.cpp\00", section "llvm.metadata"
@global = external dso_local global i32, align 4
@llvm.global.annotations = appending global [1 x { i8*, i8*, i8*, i32 }] [{ i8*, i8*, i8*, i32 } { i8* bitcast (double* @global2 to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([29 x i8], [29 x i8]* @.str.1, i32 0, i32 0), i32 6 }], section "llvm.metadata"

; Function Attrs: uwtable
define dso_local i32 @_Z1gi(i32) #0 !dbg !359 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, i32* %2, align 4, !tbaa !365
  call void @llvm.dbg.declare(metadata i32* %2, metadata !361, metadata !DIExpression()), !dbg !369
  %5 = bitcast i32* %3 to i8*, !dbg !370
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %5) #5, !dbg !370
  call void @llvm.dbg.declare(metadata i32* %3, metadata !362, metadata !DIExpression()), !dbg !371
  store i32 0, i32* %3, align 4, !dbg !371, !tbaa !365
  %6 = bitcast i32* %4 to i8*, !dbg !372
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %6) #5, !dbg !372
  call void @llvm.dbg.declare(metadata i32* %4, metadata !363, metadata !DIExpression()), !dbg !373
  store i32 0, i32* %4, align 4, !dbg !373, !tbaa !365
  br label %7, !dbg !372

; <label>:7:                                      ; preds = %25, %1
  %8 = load i32, i32* %4, align 4, !dbg !374, !tbaa !365
  %9 = load i32, i32* @global, align 4, !dbg !376, !tbaa !365
  %10 = icmp slt i32 %8, %9, !dbg !377
  br i1 %10, label %13, label %11, !dbg !378

; <label>:11:                                     ; preds = %7
  %12 = bitcast i32* %4 to i8*, !dbg !379
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %12) #5, !dbg !379
  br label %28

; <label>:13:                                     ; preds = %7
  %14 = load i32, i32* %2, align 4, !dbg !380, !tbaa !365
  %15 = add nsw i32 100, %14, !dbg !381
  %16 = sitofp i32 %15 to double, !dbg !382
  %17 = load i32, i32* @global, align 4, !dbg !383, !tbaa !365
  %18 = sitofp i32 %17 to double, !dbg !383
  %19 = call double @pow(double %18, double 3.000000e+00) #5, !dbg !384
  %20 = fadd double %16, %19, !dbg !385
  %21 = fptosi double %20 to i32, !dbg !382
  %22 = call i32 @_Z1hi(i32 %21), !dbg !386
  %23 = load i32, i32* %3, align 4, !dbg !387, !tbaa !365
  %24 = add nsw i32 %23, %22, !dbg !387
  store i32 %24, i32* %3, align 4, !dbg !387, !tbaa !365
  br label %25, !dbg !388

; <label>:25:                                     ; preds = %13
  %26 = load i32, i32* %4, align 4, !dbg !389, !tbaa !365
  %27 = add nsw i32 %26, 1, !dbg !389
  store i32 %27, i32* %4, align 4, !dbg !389, !tbaa !365
  br label %7, !dbg !379, !llvm.loop !390

; <label>:28:                                     ; preds = %11
  %29 = load i32, i32* %3, align 4, !dbg !392, !tbaa !365
  %30 = bitcast i32* %3 to i8*, !dbg !393
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %30) #5, !dbg !393
  ret i32 %29, !dbg !394
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #2

declare dso_local i32 @_Z1hi(i32) #3

; Function Attrs: nounwind
declare dso_local double @pow(double, double) #4

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #2

attributes #0 = { uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { argmemonly nounwind }
attributes #3 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { nounwind }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!355, !356, !357}
!llvm.ident = !{!358}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "global2", scope: !2, file: !3, line: 6, type: !6, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !3, producer: "clang version 8.0.0 (git@github.com:llvm-mirror/clang.git e3e8f2a67bc17cb4f751b22e53e16d7c39b371d0) (git@github.com:llvm-mirror/LLVM.git 48e9774b6791c48760d18775039eefa6d824522d)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !5, globals: !7, imports: !8, nameTableKind: None)
!3 = !DIFile(filename: "tests/extrap/globals_tu2.cpp", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!4 = !{}
!5 = !{!6}
!6 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!7 = !{!0}
!8 = !{!9, !17, !23, !25, !27, !31, !33, !35, !37, !39, !41, !43, !45, !50, !54, !56, !58, !63, !65, !67, !69, !71, !73, !75, !78, !81, !83, !87, !92, !94, !96, !98, !100, !102, !104, !106, !108, !110, !112, !116, !120, !122, !124, !126, !128, !130, !132, !134, !136, !138, !140, !142, !144, !146, !148, !150, !154, !158, !162, !164, !166, !168, !170, !172, !174, !176, !178, !180, !184, !188, !192, !194, !196, !198, !203, !207, !211, !213, !215, !217, !219, !221, !223, !225, !227, !229, !231, !233, !235, !240, !244, !248, !250, !252, !254, !261, !265, !269, !271, !273, !275, !277, !279, !281, !285, !289, !291, !293, !295, !297, !301, !305, !309, !311, !313, !315, !317, !319, !321, !325, !329, !333, !335, !339, !343, !345, !347, !349, !351, !353}
!9 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !11, file: !16, line: 52)
!10 = !DINamespace(name: "std", scope: null)
!11 = !DISubprogram(name: "abs", scope: !12, file: !12, line: 837, type: !13, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!12 = !DIFile(filename: "/usr/include/stdlib.h", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!13 = !DISubroutineType(types: !14)
!14 = !{!15, !15}
!15 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!16 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.3.0/../../../../include/c++/7.3.0/bits/std_abs.h", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!17 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !18, file: !22, line: 83)
!18 = !DISubprogram(name: "acos", scope: !19, file: !19, line: 53, type: !20, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!19 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/mathcalls.h", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!20 = !DISubroutineType(types: !21)
!21 = !{!6, !6}
!22 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.3.0/../../../../include/c++/7.3.0/cmath", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!23 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !24, file: !22, line: 102)
!24 = !DISubprogram(name: "asin", scope: !19, file: !19, line: 55, type: !20, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!25 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !26, file: !22, line: 121)
!26 = !DISubprogram(name: "atan", scope: !19, file: !19, line: 57, type: !20, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!27 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !28, file: !22, line: 140)
!28 = !DISubprogram(name: "atan2", scope: !19, file: !19, line: 59, type: !29, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!29 = !DISubroutineType(types: !30)
!30 = !{!6, !6, !6}
!31 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !32, file: !22, line: 161)
!32 = !DISubprogram(name: "ceil", scope: !19, file: !19, line: 159, type: !20, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!33 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !34, file: !22, line: 180)
!34 = !DISubprogram(name: "cos", scope: !19, file: !19, line: 62, type: !20, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!35 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !36, file: !22, line: 199)
!36 = !DISubprogram(name: "cosh", scope: !19, file: !19, line: 71, type: !20, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!37 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !38, file: !22, line: 218)
!38 = !DISubprogram(name: "exp", scope: !19, file: !19, line: 95, type: !20, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!39 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !40, file: !22, line: 237)
!40 = !DISubprogram(name: "fabs", scope: !19, file: !19, line: 162, type: !20, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!41 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !42, file: !22, line: 256)
!42 = !DISubprogram(name: "floor", scope: !19, file: !19, line: 165, type: !20, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!43 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !44, file: !22, line: 275)
!44 = !DISubprogram(name: "fmod", scope: !19, file: !19, line: 168, type: !29, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!45 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !46, file: !22, line: 296)
!46 = !DISubprogram(name: "frexp", scope: !19, file: !19, line: 98, type: !47, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!47 = !DISubroutineType(types: !48)
!48 = !{!6, !6, !49}
!49 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 64)
!50 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !51, file: !22, line: 315)
!51 = !DISubprogram(name: "ldexp", scope: !19, file: !19, line: 101, type: !52, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!52 = !DISubroutineType(types: !53)
!53 = !{!6, !6, !15}
!54 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !55, file: !22, line: 334)
!55 = !DISubprogram(name: "log", scope: !19, file: !19, line: 104, type: !20, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!56 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !57, file: !22, line: 353)
!57 = !DISubprogram(name: "log10", scope: !19, file: !19, line: 107, type: !20, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!58 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !59, file: !22, line: 372)
!59 = !DISubprogram(name: "modf", scope: !19, file: !19, line: 110, type: !60, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!60 = !DISubroutineType(types: !61)
!61 = !{!6, !6, !62}
!62 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !6, size: 64)
!63 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !64, file: !22, line: 384)
!64 = !DISubprogram(name: "pow", scope: !19, file: !19, line: 140, type: !29, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!65 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !66, file: !22, line: 421)
!66 = !DISubprogram(name: "sin", scope: !19, file: !19, line: 64, type: !20, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!67 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !68, file: !22, line: 440)
!68 = !DISubprogram(name: "sinh", scope: !19, file: !19, line: 73, type: !20, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!69 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !70, file: !22, line: 459)
!70 = !DISubprogram(name: "sqrt", scope: !19, file: !19, line: 143, type: !20, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!71 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !72, file: !22, line: 478)
!72 = !DISubprogram(name: "tan", scope: !19, file: !19, line: 66, type: !20, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!73 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !74, file: !22, line: 497)
!74 = !DISubprogram(name: "tanh", scope: !19, file: !19, line: 75, type: !20, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!75 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !76, file: !22, line: 1080)
!76 = !DIDerivedType(tag: DW_TAG_typedef, name: "double_t", file: !77, line: 150, baseType: !6)
!77 = !DIFile(filename: "/usr/include/math.h", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!78 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !79, file: !22, line: 1081)
!79 = !DIDerivedType(tag: DW_TAG_typedef, name: "float_t", file: !77, line: 149, baseType: !80)
!80 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!81 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !82, file: !22, line: 1084)
!82 = !DISubprogram(name: "acosh", scope: !19, file: !19, line: 85, type: !20, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!83 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !84, file: !22, line: 1085)
!84 = !DISubprogram(name: "acoshf", scope: !19, file: !19, line: 85, type: !85, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!85 = !DISubroutineType(types: !86)
!86 = !{!80, !80}
!87 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !88, file: !22, line: 1086)
!88 = !DISubprogram(name: "acoshl", scope: !19, file: !19, line: 85, type: !89, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!89 = !DISubroutineType(types: !90)
!90 = !{!91, !91}
!91 = !DIBasicType(name: "long double", size: 128, encoding: DW_ATE_float)
!92 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !93, file: !22, line: 1088)
!93 = !DISubprogram(name: "asinh", scope: !19, file: !19, line: 87, type: !20, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!94 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !95, file: !22, line: 1089)
!95 = !DISubprogram(name: "asinhf", scope: !19, file: !19, line: 87, type: !85, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!96 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !97, file: !22, line: 1090)
!97 = !DISubprogram(name: "asinhl", scope: !19, file: !19, line: 87, type: !89, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!98 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !99, file: !22, line: 1092)
!99 = !DISubprogram(name: "atanh", scope: !19, file: !19, line: 89, type: !20, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!100 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !101, file: !22, line: 1093)
!101 = !DISubprogram(name: "atanhf", scope: !19, file: !19, line: 89, type: !85, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!102 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !103, file: !22, line: 1094)
!103 = !DISubprogram(name: "atanhl", scope: !19, file: !19, line: 89, type: !89, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!104 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !105, file: !22, line: 1096)
!105 = !DISubprogram(name: "cbrt", scope: !19, file: !19, line: 152, type: !20, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!106 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !107, file: !22, line: 1097)
!107 = !DISubprogram(name: "cbrtf", scope: !19, file: !19, line: 152, type: !85, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!108 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !109, file: !22, line: 1098)
!109 = !DISubprogram(name: "cbrtl", scope: !19, file: !19, line: 152, type: !89, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!110 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !111, file: !22, line: 1100)
!111 = !DISubprogram(name: "copysign", scope: !19, file: !19, line: 196, type: !29, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!112 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !113, file: !22, line: 1101)
!113 = !DISubprogram(name: "copysignf", scope: !19, file: !19, line: 196, type: !114, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!114 = !DISubroutineType(types: !115)
!115 = !{!80, !80, !80}
!116 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !117, file: !22, line: 1102)
!117 = !DISubprogram(name: "copysignl", scope: !19, file: !19, line: 196, type: !118, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!118 = !DISubroutineType(types: !119)
!119 = !{!91, !91, !91}
!120 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !121, file: !22, line: 1104)
!121 = !DISubprogram(name: "erf", scope: !19, file: !19, line: 228, type: !20, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!122 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !123, file: !22, line: 1105)
!123 = !DISubprogram(name: "erff", scope: !19, file: !19, line: 228, type: !85, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!124 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !125, file: !22, line: 1106)
!125 = !DISubprogram(name: "erfl", scope: !19, file: !19, line: 228, type: !89, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!126 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !127, file: !22, line: 1108)
!127 = !DISubprogram(name: "erfc", scope: !19, file: !19, line: 229, type: !20, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!128 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !129, file: !22, line: 1109)
!129 = !DISubprogram(name: "erfcf", scope: !19, file: !19, line: 229, type: !85, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!130 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !131, file: !22, line: 1110)
!131 = !DISubprogram(name: "erfcl", scope: !19, file: !19, line: 229, type: !89, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!132 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !133, file: !22, line: 1112)
!133 = !DISubprogram(name: "exp2", scope: !19, file: !19, line: 130, type: !20, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!134 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !135, file: !22, line: 1113)
!135 = !DISubprogram(name: "exp2f", scope: !19, file: !19, line: 130, type: !85, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!136 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !137, file: !22, line: 1114)
!137 = !DISubprogram(name: "exp2l", scope: !19, file: !19, line: 130, type: !89, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!138 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !139, file: !22, line: 1116)
!139 = !DISubprogram(name: "expm1", scope: !19, file: !19, line: 119, type: !20, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!140 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !141, file: !22, line: 1117)
!141 = !DISubprogram(name: "expm1f", scope: !19, file: !19, line: 119, type: !85, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!142 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !143, file: !22, line: 1118)
!143 = !DISubprogram(name: "expm1l", scope: !19, file: !19, line: 119, type: !89, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!144 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !145, file: !22, line: 1120)
!145 = !DISubprogram(name: "fdim", scope: !19, file: !19, line: 326, type: !29, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!146 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !147, file: !22, line: 1121)
!147 = !DISubprogram(name: "fdimf", scope: !19, file: !19, line: 326, type: !114, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!148 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !149, file: !22, line: 1122)
!149 = !DISubprogram(name: "fdiml", scope: !19, file: !19, line: 326, type: !118, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!150 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !151, file: !22, line: 1124)
!151 = !DISubprogram(name: "fma", scope: !19, file: !19, line: 335, type: !152, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!152 = !DISubroutineType(types: !153)
!153 = !{!6, !6, !6, !6}
!154 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !155, file: !22, line: 1125)
!155 = !DISubprogram(name: "fmaf", scope: !19, file: !19, line: 335, type: !156, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!156 = !DISubroutineType(types: !157)
!157 = !{!80, !80, !80, !80}
!158 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !159, file: !22, line: 1126)
!159 = !DISubprogram(name: "fmal", scope: !19, file: !19, line: 335, type: !160, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!160 = !DISubroutineType(types: !161)
!161 = !{!91, !91, !91, !91}
!162 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !163, file: !22, line: 1128)
!163 = !DISubprogram(name: "fmax", scope: !19, file: !19, line: 329, type: !29, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!164 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !165, file: !22, line: 1129)
!165 = !DISubprogram(name: "fmaxf", scope: !19, file: !19, line: 329, type: !114, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!166 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !167, file: !22, line: 1130)
!167 = !DISubprogram(name: "fmaxl", scope: !19, file: !19, line: 329, type: !118, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!168 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !169, file: !22, line: 1132)
!169 = !DISubprogram(name: "fmin", scope: !19, file: !19, line: 332, type: !29, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!170 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !171, file: !22, line: 1133)
!171 = !DISubprogram(name: "fminf", scope: !19, file: !19, line: 332, type: !114, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!172 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !173, file: !22, line: 1134)
!173 = !DISubprogram(name: "fminl", scope: !19, file: !19, line: 332, type: !118, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!174 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !175, file: !22, line: 1136)
!175 = !DISubprogram(name: "hypot", scope: !19, file: !19, line: 147, type: !29, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!176 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !177, file: !22, line: 1137)
!177 = !DISubprogram(name: "hypotf", scope: !19, file: !19, line: 147, type: !114, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!178 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !179, file: !22, line: 1138)
!179 = !DISubprogram(name: "hypotl", scope: !19, file: !19, line: 147, type: !118, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!180 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !181, file: !22, line: 1140)
!181 = !DISubprogram(name: "ilogb", scope: !19, file: !19, line: 280, type: !182, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!182 = !DISubroutineType(types: !183)
!183 = !{!15, !6}
!184 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !185, file: !22, line: 1141)
!185 = !DISubprogram(name: "ilogbf", scope: !19, file: !19, line: 280, type: !186, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!186 = !DISubroutineType(types: !187)
!187 = !{!15, !80}
!188 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !189, file: !22, line: 1142)
!189 = !DISubprogram(name: "ilogbl", scope: !19, file: !19, line: 280, type: !190, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!190 = !DISubroutineType(types: !191)
!191 = !{!15, !91}
!192 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !193, file: !22, line: 1144)
!193 = !DISubprogram(name: "lgamma", scope: !19, file: !19, line: 230, type: !20, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!194 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !195, file: !22, line: 1145)
!195 = !DISubprogram(name: "lgammaf", scope: !19, file: !19, line: 230, type: !85, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!196 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !197, file: !22, line: 1146)
!197 = !DISubprogram(name: "lgammal", scope: !19, file: !19, line: 230, type: !89, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!198 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !199, file: !22, line: 1149)
!199 = !DISubprogram(name: "llrint", scope: !19, file: !19, line: 316, type: !200, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!200 = !DISubroutineType(types: !201)
!201 = !{!202, !6}
!202 = !DIBasicType(name: "long long int", size: 64, encoding: DW_ATE_signed)
!203 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !204, file: !22, line: 1150)
!204 = !DISubprogram(name: "llrintf", scope: !19, file: !19, line: 316, type: !205, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!205 = !DISubroutineType(types: !206)
!206 = !{!202, !80}
!207 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !208, file: !22, line: 1151)
!208 = !DISubprogram(name: "llrintl", scope: !19, file: !19, line: 316, type: !209, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!209 = !DISubroutineType(types: !210)
!210 = !{!202, !91}
!211 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !212, file: !22, line: 1153)
!212 = !DISubprogram(name: "llround", scope: !19, file: !19, line: 322, type: !200, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!213 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !214, file: !22, line: 1154)
!214 = !DISubprogram(name: "llroundf", scope: !19, file: !19, line: 322, type: !205, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!215 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !216, file: !22, line: 1155)
!216 = !DISubprogram(name: "llroundl", scope: !19, file: !19, line: 322, type: !209, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!217 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !218, file: !22, line: 1158)
!218 = !DISubprogram(name: "log1p", scope: !19, file: !19, line: 122, type: !20, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!219 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !220, file: !22, line: 1159)
!220 = !DISubprogram(name: "log1pf", scope: !19, file: !19, line: 122, type: !85, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!221 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !222, file: !22, line: 1160)
!222 = !DISubprogram(name: "log1pl", scope: !19, file: !19, line: 122, type: !89, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!223 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !224, file: !22, line: 1162)
!224 = !DISubprogram(name: "log2", scope: !19, file: !19, line: 133, type: !20, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!225 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !226, file: !22, line: 1163)
!226 = !DISubprogram(name: "log2f", scope: !19, file: !19, line: 133, type: !85, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!227 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !228, file: !22, line: 1164)
!228 = !DISubprogram(name: "log2l", scope: !19, file: !19, line: 133, type: !89, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!229 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !230, file: !22, line: 1166)
!230 = !DISubprogram(name: "logb", scope: !19, file: !19, line: 125, type: !20, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!231 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !232, file: !22, line: 1167)
!232 = !DISubprogram(name: "logbf", scope: !19, file: !19, line: 125, type: !85, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!233 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !234, file: !22, line: 1168)
!234 = !DISubprogram(name: "logbl", scope: !19, file: !19, line: 125, type: !89, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!235 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !236, file: !22, line: 1170)
!236 = !DISubprogram(name: "lrint", scope: !19, file: !19, line: 314, type: !237, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!237 = !DISubroutineType(types: !238)
!238 = !{!239, !6}
!239 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!240 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !241, file: !22, line: 1171)
!241 = !DISubprogram(name: "lrintf", scope: !19, file: !19, line: 314, type: !242, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!242 = !DISubroutineType(types: !243)
!243 = !{!239, !80}
!244 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !245, file: !22, line: 1172)
!245 = !DISubprogram(name: "lrintl", scope: !19, file: !19, line: 314, type: !246, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!246 = !DISubroutineType(types: !247)
!247 = !{!239, !91}
!248 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !249, file: !22, line: 1174)
!249 = !DISubprogram(name: "lround", scope: !19, file: !19, line: 320, type: !237, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!250 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !251, file: !22, line: 1175)
!251 = !DISubprogram(name: "lroundf", scope: !19, file: !19, line: 320, type: !242, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!252 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !253, file: !22, line: 1176)
!253 = !DISubprogram(name: "lroundl", scope: !19, file: !19, line: 320, type: !246, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!254 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !255, file: !22, line: 1178)
!255 = !DISubprogram(name: "nan", scope: !19, file: !19, line: 201, type: !256, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!256 = !DISubroutineType(types: !257)
!257 = !{!6, !258}
!258 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !259, size: 64)
!259 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !260)
!260 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!261 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !262, file: !22, line: 1179)
!262 = !DISubprogram(name: "nanf", scope: !19, file: !19, line: 201, type: !263, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!263 = !DISubroutineType(types: !264)
!264 = !{!80, !258}
!265 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !266, file: !22, line: 1180)
!266 = !DISubprogram(name: "nanl", scope: !19, file: !19, line: 201, type: !267, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!267 = !DISubroutineType(types: !268)
!268 = !{!91, !258}
!269 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !270, file: !22, line: 1182)
!270 = !DISubprogram(name: "nearbyint", scope: !19, file: !19, line: 294, type: !20, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!271 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !272, file: !22, line: 1183)
!272 = !DISubprogram(name: "nearbyintf", scope: !19, file: !19, line: 294, type: !85, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!273 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !274, file: !22, line: 1184)
!274 = !DISubprogram(name: "nearbyintl", scope: !19, file: !19, line: 294, type: !89, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!275 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !276, file: !22, line: 1186)
!276 = !DISubprogram(name: "nextafter", scope: !19, file: !19, line: 259, type: !29, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!277 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !278, file: !22, line: 1187)
!278 = !DISubprogram(name: "nextafterf", scope: !19, file: !19, line: 259, type: !114, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!279 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !280, file: !22, line: 1188)
!280 = !DISubprogram(name: "nextafterl", scope: !19, file: !19, line: 259, type: !118, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!281 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !282, file: !22, line: 1190)
!282 = !DISubprogram(name: "nexttoward", scope: !19, file: !19, line: 261, type: !283, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!283 = !DISubroutineType(types: !284)
!284 = !{!6, !6, !91}
!285 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !286, file: !22, line: 1191)
!286 = !DISubprogram(name: "nexttowardf", scope: !19, file: !19, line: 261, type: !287, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!287 = !DISubroutineType(types: !288)
!288 = !{!80, !80, !91}
!289 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !290, file: !22, line: 1192)
!290 = !DISubprogram(name: "nexttowardl", scope: !19, file: !19, line: 261, type: !118, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!291 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !292, file: !22, line: 1194)
!292 = !DISubprogram(name: "remainder", scope: !19, file: !19, line: 272, type: !29, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!293 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !294, file: !22, line: 1195)
!294 = !DISubprogram(name: "remainderf", scope: !19, file: !19, line: 272, type: !114, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!295 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !296, file: !22, line: 1196)
!296 = !DISubprogram(name: "remainderl", scope: !19, file: !19, line: 272, type: !118, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!297 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !298, file: !22, line: 1198)
!298 = !DISubprogram(name: "remquo", scope: !19, file: !19, line: 307, type: !299, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!299 = !DISubroutineType(types: !300)
!300 = !{!6, !6, !6, !49}
!301 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !302, file: !22, line: 1199)
!302 = !DISubprogram(name: "remquof", scope: !19, file: !19, line: 307, type: !303, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!303 = !DISubroutineType(types: !304)
!304 = !{!80, !80, !80, !49}
!305 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !306, file: !22, line: 1200)
!306 = !DISubprogram(name: "remquol", scope: !19, file: !19, line: 307, type: !307, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!307 = !DISubroutineType(types: !308)
!308 = !{!91, !91, !91, !49}
!309 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !310, file: !22, line: 1202)
!310 = !DISubprogram(name: "rint", scope: !19, file: !19, line: 256, type: !20, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!311 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !312, file: !22, line: 1203)
!312 = !DISubprogram(name: "rintf", scope: !19, file: !19, line: 256, type: !85, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!313 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !314, file: !22, line: 1204)
!314 = !DISubprogram(name: "rintl", scope: !19, file: !19, line: 256, type: !89, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!315 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !316, file: !22, line: 1206)
!316 = !DISubprogram(name: "round", scope: !19, file: !19, line: 298, type: !20, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!317 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !318, file: !22, line: 1207)
!318 = !DISubprogram(name: "roundf", scope: !19, file: !19, line: 298, type: !85, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!319 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !320, file: !22, line: 1208)
!320 = !DISubprogram(name: "roundl", scope: !19, file: !19, line: 298, type: !89, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!321 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !322, file: !22, line: 1210)
!322 = !DISubprogram(name: "scalbln", scope: !19, file: !19, line: 290, type: !323, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!323 = !DISubroutineType(types: !324)
!324 = !{!6, !6, !239}
!325 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !326, file: !22, line: 1211)
!326 = !DISubprogram(name: "scalblnf", scope: !19, file: !19, line: 290, type: !327, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!327 = !DISubroutineType(types: !328)
!328 = !{!80, !80, !239}
!329 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !330, file: !22, line: 1212)
!330 = !DISubprogram(name: "scalblnl", scope: !19, file: !19, line: 290, type: !331, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!331 = !DISubroutineType(types: !332)
!332 = !{!91, !91, !239}
!333 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !334, file: !22, line: 1214)
!334 = !DISubprogram(name: "scalbn", scope: !19, file: !19, line: 276, type: !52, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!335 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !336, file: !22, line: 1215)
!336 = !DISubprogram(name: "scalbnf", scope: !19, file: !19, line: 276, type: !337, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!337 = !DISubroutineType(types: !338)
!338 = !{!80, !80, !15}
!339 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !340, file: !22, line: 1216)
!340 = !DISubprogram(name: "scalbnl", scope: !19, file: !19, line: 276, type: !341, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!341 = !DISubroutineType(types: !342)
!342 = !{!91, !91, !15}
!343 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !344, file: !22, line: 1218)
!344 = !DISubprogram(name: "tgamma", scope: !19, file: !19, line: 235, type: !20, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!345 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !346, file: !22, line: 1219)
!346 = !DISubprogram(name: "tgammaf", scope: !19, file: !19, line: 235, type: !85, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!347 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !348, file: !22, line: 1220)
!348 = !DISubprogram(name: "tgammal", scope: !19, file: !19, line: 235, type: !89, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!349 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !350, file: !22, line: 1222)
!350 = !DISubprogram(name: "trunc", scope: !19, file: !19, line: 302, type: !20, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!351 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !352, file: !22, line: 1223)
!352 = !DISubprogram(name: "truncf", scope: !19, file: !19, line: 302, type: !85, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!353 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !354, file: !22, line: 1224)
!354 = !DISubprogram(name: "truncl", scope: !19, file: !19, line: 302, type: !89, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!355 = !{i32 2, !"Dwarf Version", i32 4}
!356 = !{i32 2, !"Debug Info Version", i32 3}
!357 = !{i32 1, !"wchar_size", i32 4}
!358 = !{!"clang version 8.0.0 (git@github.com:llvm-mirror/clang.git e3e8f2a67bc17cb4f751b22e53e16d7c39b371d0) (git@github.com:llvm-mirror/LLVM.git 48e9774b6791c48760d18775039eefa6d824522d)"}
!359 = distinct !DISubprogram(name: "g", linkageName: "_Z1gi", scope: !3, file: !3, line: 11, type: !13, isLocal: false, isDefinition: true, scopeLine: 12, flags: DIFlagPrototyped, isOptimized: true, unit: !2, retainedNodes: !360)
!360 = !{!361, !362, !363}
!361 = !DILocalVariable(name: "x", arg: 1, scope: !359, file: !3, line: 11, type: !15)
!362 = !DILocalVariable(name: "x2", scope: !359, file: !3, line: 13, type: !15)
!363 = !DILocalVariable(name: "i", scope: !364, file: !3, line: 14, type: !15)
!364 = distinct !DILexicalBlock(scope: !359, file: !3, line: 14, column: 5)
!365 = !{!366, !366, i64 0}
!366 = !{!"int", !367, i64 0}
!367 = !{!"omnipotent char", !368, i64 0}
!368 = !{!"Simple C++ TBAA"}
!369 = !DILocation(line: 11, column: 11, scope: !359)
!370 = !DILocation(line: 13, column: 5, scope: !359)
!371 = !DILocation(line: 13, column: 9, scope: !359)
!372 = !DILocation(line: 14, column: 9, scope: !364)
!373 = !DILocation(line: 14, column: 13, scope: !364)
!374 = !DILocation(line: 14, column: 20, scope: !375)
!375 = distinct !DILexicalBlock(scope: !364, file: !3, line: 14, column: 5)
!376 = !DILocation(line: 14, column: 24, scope: !375)
!377 = !DILocation(line: 14, column: 22, scope: !375)
!378 = !DILocation(line: 14, column: 5, scope: !364)
!379 = !DILocation(line: 14, column: 5, scope: !375)
!380 = !DILocation(line: 15, column: 23, scope: !375)
!381 = !DILocation(line: 15, column: 21, scope: !375)
!382 = !DILocation(line: 15, column: 17, scope: !375)
!383 = !DILocation(line: 15, column: 44, scope: !375)
!384 = !DILocation(line: 15, column: 27, scope: !375)
!385 = !DILocation(line: 15, column: 25, scope: !375)
!386 = !DILocation(line: 15, column: 15, scope: !375)
!387 = !DILocation(line: 15, column: 12, scope: !375)
!388 = !DILocation(line: 15, column: 9, scope: !375)
!389 = !DILocation(line: 14, column: 32, scope: !375)
!390 = distinct !{!390, !378, !391}
!391 = !DILocation(line: 15, column: 56, scope: !364)
!392 = !DILocation(line: 16, column: 12, scope: !359)
!393 = !DILocation(line: 17, column: 1, scope: !359)
!394 = !DILocation(line: 16, column: 5, scope: !359)
