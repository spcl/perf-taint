; RUN: opt %loadpass  -o /dev/null < %s 2> /dev/null | diff -w %s.json -

; ModuleID = 'llvm-link'
source_filename = "llvm-link"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@global = dso_local global i32 100, align 4, !dbg !0
@llvm.global.annotations = appending global [2 x { i8*, i8*, i8*, i32 }] [{ i8*, i8*, i8*, i32 } { i8* bitcast (i32* @global to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([29 x i8], [29 x i8]* @.str.1, i32 0, i32 0), i32 7 }, { i8*, i8*, i8*, i32 } { i8* bitcast (double* @global2 to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.4, i32 0, i32 0), i8* getelementptr inbounds ([29 x i8], [29 x i8]* @.str.1.5, i32 0, i32 0), i32 6 }], section "llvm.metadata"
@.str = private unnamed_addr constant [7 x i8] c"extrap\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [29 x i8] c"tests/extrap/globals_tu1.cpp\00", section "llvm.metadata"
@global2 = dso_local global double 2.000000e+02, align 8, !dbg !549
@.str.4 = private unnamed_addr constant [7 x i8] c"extrap\00", section "llvm.metadata"
@.str.1.5 = private unnamed_addr constant [29 x i8] c"tests/extrap/globals_tu2.cpp\00", section "llvm.metadata"

; Function Attrs: nounwind uwtable
define dso_local i32 @_Z1hi(i32) #0 !dbg !560 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4, !tbaa !563
  call void @llvm.dbg.declare(metadata i32* %2, metadata !562, metadata !DIExpression()), !dbg !567
  %3 = load i32, i32* %2, align 4, !dbg !568, !tbaa !563
  %4 = mul nsw i32 100, %3, !dbg !569
  %5 = sitofp i32 %4 to double, !dbg !570
  %6 = load double, double* @global2, align 8, !dbg !571, !tbaa !572
  %7 = call double @log(double %6) #7, !dbg !574
  %8 = fmul double %5, %7, !dbg !575
  %9 = fptosi double %8 to i32, !dbg !570
  ret i32 %9, !dbg !576
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind
declare dso_local double @log(double) #2

; Function Attrs: nounwind uwtable
define dso_local i32 @_Z1fii(i32, i32) #0 !dbg !577 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, i32* %3, align 4, !tbaa !563
  call void @llvm.dbg.declare(metadata i32* %3, metadata !581, metadata !DIExpression()), !dbg !583
  store i32 %1, i32* %4, align 4, !tbaa !563
  call void @llvm.dbg.declare(metadata i32* %4, metadata !582, metadata !DIExpression()), !dbg !584
  %5 = load i32, i32* %3, align 4, !dbg !585, !tbaa !563
  %6 = mul nsw i32 10, %5, !dbg !586
  %7 = load i32, i32* @global, align 4, !dbg !587, !tbaa !563
  %8 = load i32, i32* %4, align 4, !dbg !588, !tbaa !563
  %9 = mul nsw i32 %7, %8, !dbg !589
  %10 = call i32 @_Z1hi(i32 %9), !dbg !590
  %11 = add nsw i32 %6, %10, !dbg !591
  ret i32 %11, !dbg !592
}

; Function Attrs: uwtable
define dso_local i32 @_Z1iiii(i32, i32, i32) #3 !dbg !593 {
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store i32 %0, i32* %4, align 4, !tbaa !563
  call void @llvm.dbg.declare(metadata i32* %4, metadata !597, metadata !DIExpression()), !dbg !601
  store i32 %1, i32* %5, align 4, !tbaa !563
  call void @llvm.dbg.declare(metadata i32* %5, metadata !598, metadata !DIExpression()), !dbg !602
  store i32 %2, i32* %6, align 4, !tbaa !563
  call void @llvm.dbg.declare(metadata i32* %6, metadata !599, metadata !DIExpression()), !dbg !603
  %8 = bitcast i32* %7 to i8*, !dbg !604
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %8) #7, !dbg !604
  call void @llvm.dbg.declare(metadata i32* %7, metadata !600, metadata !DIExpression()), !dbg !605
  %9 = load double, double* @global2, align 8, !dbg !606, !tbaa !572
  %10 = fadd double %9, 1.000000e+00, !dbg !607
  %11 = fptosi double %10 to i32, !dbg !606
  store i32 %11, i32* %7, align 4, !dbg !605, !tbaa !563
  %12 = load i32, i32* %7, align 4, !dbg !608, !tbaa !563
  %13 = call i32 @_Z1gi(i32 %12), !dbg !609
  %14 = load i32, i32* %5, align 4, !dbg !610, !tbaa !563
  %15 = load i32, i32* %4, align 4, !dbg !611, !tbaa !563
  %16 = call i32 @_Z1fii(i32 %14, i32 %15), !dbg !612
  %17 = load i32, i32* %5, align 4, !dbg !613, !tbaa !563
  %18 = mul nsw i32 %16, %17, !dbg !614
  %19 = load i32, i32* %6, align 4, !dbg !615, !tbaa !563
  %20 = call i32 @_Z1fii(i32 2, i32 5), !dbg !616
  %21 = mul nsw i32 %19, %20, !dbg !617
  %22 = add nsw i32 %18, %21, !dbg !618
  %23 = load i32, i32* @global, align 4, !dbg !619, !tbaa !563
  %24 = add nsw i32 %22, %23, !dbg !620
  %25 = bitcast i32* %7 to i8*, !dbg !621
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %25) #7, !dbg !621
  ret i32 %24, !dbg !622
}

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #4

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #4

; Function Attrs: norecurse uwtable
define dso_local i32 @main(i32, i8**) #5 !dbg !623 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4, !tbaa !563
  call void @llvm.dbg.declare(metadata i32* %4, metadata !627, metadata !DIExpression()), !dbg !631
  store i8** %1, i8*** %5, align 8, !tbaa !632
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !628, metadata !DIExpression()), !dbg !634
  %8 = bitcast i32* %6 to i8*, !dbg !635
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %8) #7, !dbg !635
  call void @llvm.dbg.declare(metadata i32* %6, metadata !629, metadata !DIExpression()), !dbg !636
  %9 = load i8**, i8*** %5, align 8, !dbg !637, !tbaa !632
  %10 = getelementptr inbounds i8*, i8** %9, i64 1, !dbg !637
  %11 = load i8*, i8** %10, align 8, !dbg !637, !tbaa !632
  %12 = call i32 @atoi(i8* %11) #8, !dbg !638
  store i32 %12, i32* %6, align 4, !dbg !636, !tbaa !563
  %13 = bitcast i32* %7 to i8*, !dbg !639
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %13) #7, !dbg !639
  call void @llvm.dbg.declare(metadata i32* %7, metadata !630, metadata !DIExpression()), !dbg !640
  %14 = load i8**, i8*** %5, align 8, !dbg !641, !tbaa !632
  %15 = getelementptr inbounds i8*, i8** %14, i64 2, !dbg !641
  %16 = load i8*, i8** %15, align 8, !dbg !641, !tbaa !632
  %17 = call i32 @atoi(i8* %16) #8, !dbg !642
  store i32 %17, i32* %7, align 4, !dbg !640, !tbaa !563
  %18 = load i32, i32* %6, align 4, !dbg !643, !tbaa !563
  %19 = load double, double* @global2, align 8, !dbg !644, !tbaa !572
  %20 = fptosi double %19 to i32, !dbg !644
  %21 = call i32 @_Z1fii(i32 %18, i32 %20), !dbg !645
  %22 = load i32, i32* %7, align 4, !dbg !646, !tbaa !563
  %23 = call i32 @_Z1fii(i32 %22, i32 100), !dbg !647
  %24 = call i32 @_Z1gi(i32 100), !dbg !648
  %25 = call i32 @_Z1hi(i32 200), !dbg !649
  %26 = call i32 @_Z1hi(i32 100), !dbg !650
  %27 = load i32, i32* %7, align 4, !dbg !651, !tbaa !563
  %28 = load i32, i32* %6, align 4, !dbg !652, !tbaa !563
  %29 = mul nsw i32 %27, %28, !dbg !653
  %30 = call i32 @_Z1iiii(i32 100, i32 15, i32 %29), !dbg !654
  %31 = bitcast i32* %7 to i8*, !dbg !655
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %31) #7, !dbg !655
  %32 = bitcast i32* %6 to i8*, !dbg !655
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %32) #7, !dbg !655
  ret i32 0, !dbg !656
}

; Function Attrs: inlinehint nounwind readonly uwtable
define available_externally dso_local i32 @atoi(i8* nonnull) #6 !dbg !382 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8, !tbaa !632
  call void @llvm.dbg.declare(metadata i8** %2, metadata !386, metadata !DIExpression()), !dbg !657
  %3 = load i8*, i8** %2, align 8, !dbg !658, !tbaa !632
  %4 = call i64 @strtol(i8* %3, i8** null, i32 10) #7, !dbg !659
  %5 = trunc i64 %4 to i32, !dbg !659
  ret i32 %5, !dbg !660
}

; Function Attrs: nounwind
declare dso_local i64 @strtol(i8*, i8**, i32) #2

; Function Attrs: uwtable
define dso_local i32 @_Z1gi(i32) #3 !dbg !661 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4, !tbaa !563
  call void @llvm.dbg.declare(metadata i32* %2, metadata !663, metadata !DIExpression()), !dbg !664
  %3 = load i32, i32* %2, align 4, !dbg !665, !tbaa !563
  %4 = add nsw i32 100, %3, !dbg !666
  %5 = sitofp i32 %4 to double, !dbg !667
  %6 = load i32, i32* @global, align 4, !dbg !668, !tbaa !563
  %7 = sitofp i32 %6 to double, !dbg !668
  %8 = call double @pow(double %7, double 3.000000e+00) #7, !dbg !669
  %9 = fadd double %5, %8, !dbg !670
  %10 = fptosi double %9 to i32, !dbg !667
  %11 = call i32 @_Z1hi(i32 %10), !dbg !671
  ret i32 %11, !dbg !672
}

; Function Attrs: nounwind
declare dso_local double @pow(double, double) #2

attributes #0 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { argmemonly nounwind }
attributes #5 = { norecurse uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #6 = { inlinehint nounwind readonly uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #7 = { nounwind }
attributes #8 = { nounwind readonly }

!llvm.dbg.cu = !{!2, !551}
!llvm.ident = !{!556, !556}
!llvm.module.flags = !{!557, !558, !559}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "global", scope: !2, file: !3, line: 7, type: !7, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !3, producer: "clang version 8.0.0 (git@github.com:llvm-mirror/clang.git e3e8f2a67bc17cb4f751b22e53e16d7c39b371d0) (git@github.com:llvm-mirror/LLVM.git 48e9774b6791c48760d18775039eefa6d824522d)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !5, globals: !11, imports: !12, nameTableKind: None)
!3 = !DIFile(filename: "tests/extrap/globals_tu1.cpp", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!4 = !{}
!5 = !{!6, !7, !8}
!6 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!7 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!8 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !9, size: 64)
!9 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !10, size: 64)
!10 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!11 = !{!0}
!12 = !{!13, !20, !26, !28, !30, !34, !36, !38, !40, !42, !44, !46, !48, !53, !57, !59, !61, !66, !68, !70, !72, !74, !76, !78, !81, !84, !86, !90, !95, !97, !99, !101, !103, !105, !107, !109, !111, !113, !115, !119, !123, !125, !127, !129, !131, !133, !135, !137, !139, !141, !143, !145, !147, !149, !151, !153, !157, !161, !165, !167, !169, !171, !173, !175, !177, !179, !181, !183, !187, !191, !195, !197, !199, !201, !206, !210, !214, !216, !218, !220, !222, !224, !226, !228, !230, !232, !234, !236, !238, !243, !247, !251, !253, !255, !257, !263, !267, !271, !273, !275, !277, !279, !281, !283, !287, !291, !293, !295, !297, !299, !303, !307, !311, !313, !315, !317, !319, !321, !323, !327, !331, !335, !337, !341, !345, !347, !349, !351, !353, !355, !357, !361, !367, !371, !376, !378, !381, !387, !391, !406, !410, !414, !418, !422, !426, !430, !434, !438, !442, !450, !454, !458, !460, !464, !468, !473, !478, !482, !486, !488, !496, !500, !507, !509, !513, !517, !521, !525, !530, !534, !538, !539, !540, !541, !543, !544, !545, !546, !547, !548}
!13 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !15, file: !19, line: 52)
!14 = !DINamespace(name: "std", scope: null)
!15 = !DISubprogram(name: "abs", scope: !16, file: !16, line: 837, type: !17, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!16 = !DIFile(filename: "/usr/include/stdlib.h", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!17 = !DISubroutineType(types: !18)
!18 = !{!7, !7}
!19 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.3.0/../../../../include/c++/7.3.0/bits/std_abs.h", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!20 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !21, file: !25, line: 83)
!21 = !DISubprogram(name: "acos", scope: !22, file: !22, line: 53, type: !23, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!22 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/mathcalls.h", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!23 = !DISubroutineType(types: !24)
!24 = !{!6, !6}
!25 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.3.0/../../../../include/c++/7.3.0/cmath", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!26 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !27, file: !25, line: 102)
!27 = !DISubprogram(name: "asin", scope: !22, file: !22, line: 55, type: !23, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!28 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !29, file: !25, line: 121)
!29 = !DISubprogram(name: "atan", scope: !22, file: !22, line: 57, type: !23, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!30 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !31, file: !25, line: 140)
!31 = !DISubprogram(name: "atan2", scope: !22, file: !22, line: 59, type: !32, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!32 = !DISubroutineType(types: !33)
!33 = !{!6, !6, !6}
!34 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !35, file: !25, line: 161)
!35 = !DISubprogram(name: "ceil", scope: !22, file: !22, line: 159, type: !23, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!36 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !37, file: !25, line: 180)
!37 = !DISubprogram(name: "cos", scope: !22, file: !22, line: 62, type: !23, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!38 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !39, file: !25, line: 199)
!39 = !DISubprogram(name: "cosh", scope: !22, file: !22, line: 71, type: !23, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!40 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !41, file: !25, line: 218)
!41 = !DISubprogram(name: "exp", scope: !22, file: !22, line: 95, type: !23, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!42 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !43, file: !25, line: 237)
!43 = !DISubprogram(name: "fabs", scope: !22, file: !22, line: 162, type: !23, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!44 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !45, file: !25, line: 256)
!45 = !DISubprogram(name: "floor", scope: !22, file: !22, line: 165, type: !23, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!46 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !47, file: !25, line: 275)
!47 = !DISubprogram(name: "fmod", scope: !22, file: !22, line: 168, type: !32, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!48 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !49, file: !25, line: 296)
!49 = !DISubprogram(name: "frexp", scope: !22, file: !22, line: 98, type: !50, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!50 = !DISubroutineType(types: !51)
!51 = !{!6, !6, !52}
!52 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!53 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !54, file: !25, line: 315)
!54 = !DISubprogram(name: "ldexp", scope: !22, file: !22, line: 101, type: !55, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!55 = !DISubroutineType(types: !56)
!56 = !{!6, !6, !7}
!57 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !58, file: !25, line: 334)
!58 = !DISubprogram(name: "log", scope: !22, file: !22, line: 104, type: !23, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!59 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !60, file: !25, line: 353)
!60 = !DISubprogram(name: "log10", scope: !22, file: !22, line: 107, type: !23, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!61 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !62, file: !25, line: 372)
!62 = !DISubprogram(name: "modf", scope: !22, file: !22, line: 110, type: !63, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!63 = !DISubroutineType(types: !64)
!64 = !{!6, !6, !65}
!65 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !6, size: 64)
!66 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !67, file: !25, line: 384)
!67 = !DISubprogram(name: "pow", scope: !22, file: !22, line: 140, type: !32, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!68 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !69, file: !25, line: 421)
!69 = !DISubprogram(name: "sin", scope: !22, file: !22, line: 64, type: !23, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!70 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !71, file: !25, line: 440)
!71 = !DISubprogram(name: "sinh", scope: !22, file: !22, line: 73, type: !23, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!72 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !73, file: !25, line: 459)
!73 = !DISubprogram(name: "sqrt", scope: !22, file: !22, line: 143, type: !23, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!74 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !75, file: !25, line: 478)
!75 = !DISubprogram(name: "tan", scope: !22, file: !22, line: 66, type: !23, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!76 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !77, file: !25, line: 497)
!77 = !DISubprogram(name: "tanh", scope: !22, file: !22, line: 75, type: !23, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!78 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !79, file: !25, line: 1080)
!79 = !DIDerivedType(tag: DW_TAG_typedef, name: "double_t", file: !80, line: 150, baseType: !6)
!80 = !DIFile(filename: "/usr/include/math.h", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!81 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !82, file: !25, line: 1081)
!82 = !DIDerivedType(tag: DW_TAG_typedef, name: "float_t", file: !80, line: 149, baseType: !83)
!83 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!84 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !85, file: !25, line: 1084)
!85 = !DISubprogram(name: "acosh", scope: !22, file: !22, line: 85, type: !23, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!86 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !87, file: !25, line: 1085)
!87 = !DISubprogram(name: "acoshf", scope: !22, file: !22, line: 85, type: !88, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!88 = !DISubroutineType(types: !89)
!89 = !{!83, !83}
!90 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !91, file: !25, line: 1086)
!91 = !DISubprogram(name: "acoshl", scope: !22, file: !22, line: 85, type: !92, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!92 = !DISubroutineType(types: !93)
!93 = !{!94, !94}
!94 = !DIBasicType(name: "long double", size: 128, encoding: DW_ATE_float)
!95 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !96, file: !25, line: 1088)
!96 = !DISubprogram(name: "asinh", scope: !22, file: !22, line: 87, type: !23, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!97 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !98, file: !25, line: 1089)
!98 = !DISubprogram(name: "asinhf", scope: !22, file: !22, line: 87, type: !88, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!99 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !100, file: !25, line: 1090)
!100 = !DISubprogram(name: "asinhl", scope: !22, file: !22, line: 87, type: !92, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!101 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !102, file: !25, line: 1092)
!102 = !DISubprogram(name: "atanh", scope: !22, file: !22, line: 89, type: !23, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!103 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !104, file: !25, line: 1093)
!104 = !DISubprogram(name: "atanhf", scope: !22, file: !22, line: 89, type: !88, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!105 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !106, file: !25, line: 1094)
!106 = !DISubprogram(name: "atanhl", scope: !22, file: !22, line: 89, type: !92, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!107 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !108, file: !25, line: 1096)
!108 = !DISubprogram(name: "cbrt", scope: !22, file: !22, line: 152, type: !23, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!109 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !110, file: !25, line: 1097)
!110 = !DISubprogram(name: "cbrtf", scope: !22, file: !22, line: 152, type: !88, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!111 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !112, file: !25, line: 1098)
!112 = !DISubprogram(name: "cbrtl", scope: !22, file: !22, line: 152, type: !92, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!113 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !114, file: !25, line: 1100)
!114 = !DISubprogram(name: "copysign", scope: !22, file: !22, line: 196, type: !32, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!115 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !116, file: !25, line: 1101)
!116 = !DISubprogram(name: "copysignf", scope: !22, file: !22, line: 196, type: !117, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!117 = !DISubroutineType(types: !118)
!118 = !{!83, !83, !83}
!119 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !120, file: !25, line: 1102)
!120 = !DISubprogram(name: "copysignl", scope: !22, file: !22, line: 196, type: !121, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!121 = !DISubroutineType(types: !122)
!122 = !{!94, !94, !94}
!123 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !124, file: !25, line: 1104)
!124 = !DISubprogram(name: "erf", scope: !22, file: !22, line: 228, type: !23, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!125 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !126, file: !25, line: 1105)
!126 = !DISubprogram(name: "erff", scope: !22, file: !22, line: 228, type: !88, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!127 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !128, file: !25, line: 1106)
!128 = !DISubprogram(name: "erfl", scope: !22, file: !22, line: 228, type: !92, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!129 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !130, file: !25, line: 1108)
!130 = !DISubprogram(name: "erfc", scope: !22, file: !22, line: 229, type: !23, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!131 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !132, file: !25, line: 1109)
!132 = !DISubprogram(name: "erfcf", scope: !22, file: !22, line: 229, type: !88, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!133 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !134, file: !25, line: 1110)
!134 = !DISubprogram(name: "erfcl", scope: !22, file: !22, line: 229, type: !92, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!135 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !136, file: !25, line: 1112)
!136 = !DISubprogram(name: "exp2", scope: !22, file: !22, line: 130, type: !23, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!137 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !138, file: !25, line: 1113)
!138 = !DISubprogram(name: "exp2f", scope: !22, file: !22, line: 130, type: !88, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!139 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !140, file: !25, line: 1114)
!140 = !DISubprogram(name: "exp2l", scope: !22, file: !22, line: 130, type: !92, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!141 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !142, file: !25, line: 1116)
!142 = !DISubprogram(name: "expm1", scope: !22, file: !22, line: 119, type: !23, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!143 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !144, file: !25, line: 1117)
!144 = !DISubprogram(name: "expm1f", scope: !22, file: !22, line: 119, type: !88, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!145 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !146, file: !25, line: 1118)
!146 = !DISubprogram(name: "expm1l", scope: !22, file: !22, line: 119, type: !92, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!147 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !148, file: !25, line: 1120)
!148 = !DISubprogram(name: "fdim", scope: !22, file: !22, line: 326, type: !32, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!149 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !150, file: !25, line: 1121)
!150 = !DISubprogram(name: "fdimf", scope: !22, file: !22, line: 326, type: !117, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!151 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !152, file: !25, line: 1122)
!152 = !DISubprogram(name: "fdiml", scope: !22, file: !22, line: 326, type: !121, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!153 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !154, file: !25, line: 1124)
!154 = !DISubprogram(name: "fma", scope: !22, file: !22, line: 335, type: !155, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!155 = !DISubroutineType(types: !156)
!156 = !{!6, !6, !6, !6}
!157 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !158, file: !25, line: 1125)
!158 = !DISubprogram(name: "fmaf", scope: !22, file: !22, line: 335, type: !159, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!159 = !DISubroutineType(types: !160)
!160 = !{!83, !83, !83, !83}
!161 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !162, file: !25, line: 1126)
!162 = !DISubprogram(name: "fmal", scope: !22, file: !22, line: 335, type: !163, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!163 = !DISubroutineType(types: !164)
!164 = !{!94, !94, !94, !94}
!165 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !166, file: !25, line: 1128)
!166 = !DISubprogram(name: "fmax", scope: !22, file: !22, line: 329, type: !32, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!167 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !168, file: !25, line: 1129)
!168 = !DISubprogram(name: "fmaxf", scope: !22, file: !22, line: 329, type: !117, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!169 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !170, file: !25, line: 1130)
!170 = !DISubprogram(name: "fmaxl", scope: !22, file: !22, line: 329, type: !121, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!171 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !172, file: !25, line: 1132)
!172 = !DISubprogram(name: "fmin", scope: !22, file: !22, line: 332, type: !32, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!173 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !174, file: !25, line: 1133)
!174 = !DISubprogram(name: "fminf", scope: !22, file: !22, line: 332, type: !117, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!175 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !176, file: !25, line: 1134)
!176 = !DISubprogram(name: "fminl", scope: !22, file: !22, line: 332, type: !121, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!177 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !178, file: !25, line: 1136)
!178 = !DISubprogram(name: "hypot", scope: !22, file: !22, line: 147, type: !32, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!179 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !180, file: !25, line: 1137)
!180 = !DISubprogram(name: "hypotf", scope: !22, file: !22, line: 147, type: !117, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!181 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !182, file: !25, line: 1138)
!182 = !DISubprogram(name: "hypotl", scope: !22, file: !22, line: 147, type: !121, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!183 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !184, file: !25, line: 1140)
!184 = !DISubprogram(name: "ilogb", scope: !22, file: !22, line: 280, type: !185, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!185 = !DISubroutineType(types: !186)
!186 = !{!7, !6}
!187 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !188, file: !25, line: 1141)
!188 = !DISubprogram(name: "ilogbf", scope: !22, file: !22, line: 280, type: !189, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!189 = !DISubroutineType(types: !190)
!190 = !{!7, !83}
!191 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !192, file: !25, line: 1142)
!192 = !DISubprogram(name: "ilogbl", scope: !22, file: !22, line: 280, type: !193, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!193 = !DISubroutineType(types: !194)
!194 = !{!7, !94}
!195 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !196, file: !25, line: 1144)
!196 = !DISubprogram(name: "lgamma", scope: !22, file: !22, line: 230, type: !23, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!197 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !198, file: !25, line: 1145)
!198 = !DISubprogram(name: "lgammaf", scope: !22, file: !22, line: 230, type: !88, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!199 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !200, file: !25, line: 1146)
!200 = !DISubprogram(name: "lgammal", scope: !22, file: !22, line: 230, type: !92, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!201 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !202, file: !25, line: 1149)
!202 = !DISubprogram(name: "llrint", scope: !22, file: !22, line: 316, type: !203, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!203 = !DISubroutineType(types: !204)
!204 = !{!205, !6}
!205 = !DIBasicType(name: "long long int", size: 64, encoding: DW_ATE_signed)
!206 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !207, file: !25, line: 1150)
!207 = !DISubprogram(name: "llrintf", scope: !22, file: !22, line: 316, type: !208, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!208 = !DISubroutineType(types: !209)
!209 = !{!205, !83}
!210 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !211, file: !25, line: 1151)
!211 = !DISubprogram(name: "llrintl", scope: !22, file: !22, line: 316, type: !212, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!212 = !DISubroutineType(types: !213)
!213 = !{!205, !94}
!214 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !215, file: !25, line: 1153)
!215 = !DISubprogram(name: "llround", scope: !22, file: !22, line: 322, type: !203, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!216 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !217, file: !25, line: 1154)
!217 = !DISubprogram(name: "llroundf", scope: !22, file: !22, line: 322, type: !208, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!218 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !219, file: !25, line: 1155)
!219 = !DISubprogram(name: "llroundl", scope: !22, file: !22, line: 322, type: !212, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!220 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !221, file: !25, line: 1158)
!221 = !DISubprogram(name: "log1p", scope: !22, file: !22, line: 122, type: !23, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!222 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !223, file: !25, line: 1159)
!223 = !DISubprogram(name: "log1pf", scope: !22, file: !22, line: 122, type: !88, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!224 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !225, file: !25, line: 1160)
!225 = !DISubprogram(name: "log1pl", scope: !22, file: !22, line: 122, type: !92, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!226 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !227, file: !25, line: 1162)
!227 = !DISubprogram(name: "log2", scope: !22, file: !22, line: 133, type: !23, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!228 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !229, file: !25, line: 1163)
!229 = !DISubprogram(name: "log2f", scope: !22, file: !22, line: 133, type: !88, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!230 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !231, file: !25, line: 1164)
!231 = !DISubprogram(name: "log2l", scope: !22, file: !22, line: 133, type: !92, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!232 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !233, file: !25, line: 1166)
!233 = !DISubprogram(name: "logb", scope: !22, file: !22, line: 125, type: !23, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!234 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !235, file: !25, line: 1167)
!235 = !DISubprogram(name: "logbf", scope: !22, file: !22, line: 125, type: !88, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!236 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !237, file: !25, line: 1168)
!237 = !DISubprogram(name: "logbl", scope: !22, file: !22, line: 125, type: !92, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!238 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !239, file: !25, line: 1170)
!239 = !DISubprogram(name: "lrint", scope: !22, file: !22, line: 314, type: !240, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!240 = !DISubroutineType(types: !241)
!241 = !{!242, !6}
!242 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!243 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !244, file: !25, line: 1171)
!244 = !DISubprogram(name: "lrintf", scope: !22, file: !22, line: 314, type: !245, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!245 = !DISubroutineType(types: !246)
!246 = !{!242, !83}
!247 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !248, file: !25, line: 1172)
!248 = !DISubprogram(name: "lrintl", scope: !22, file: !22, line: 314, type: !249, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!249 = !DISubroutineType(types: !250)
!250 = !{!242, !94}
!251 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !252, file: !25, line: 1174)
!252 = !DISubprogram(name: "lround", scope: !22, file: !22, line: 320, type: !240, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!253 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !254, file: !25, line: 1175)
!254 = !DISubprogram(name: "lroundf", scope: !22, file: !22, line: 320, type: !245, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!255 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !256, file: !25, line: 1176)
!256 = !DISubprogram(name: "lroundl", scope: !22, file: !22, line: 320, type: !249, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!257 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !258, file: !25, line: 1178)
!258 = !DISubprogram(name: "nan", scope: !22, file: !22, line: 201, type: !259, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!259 = !DISubroutineType(types: !260)
!260 = !{!6, !261}
!261 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !262, size: 64)
!262 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !10)
!263 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !264, file: !25, line: 1179)
!264 = !DISubprogram(name: "nanf", scope: !22, file: !22, line: 201, type: !265, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!265 = !DISubroutineType(types: !266)
!266 = !{!83, !261}
!267 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !268, file: !25, line: 1180)
!268 = !DISubprogram(name: "nanl", scope: !22, file: !22, line: 201, type: !269, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!269 = !DISubroutineType(types: !270)
!270 = !{!94, !261}
!271 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !272, file: !25, line: 1182)
!272 = !DISubprogram(name: "nearbyint", scope: !22, file: !22, line: 294, type: !23, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!273 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !274, file: !25, line: 1183)
!274 = !DISubprogram(name: "nearbyintf", scope: !22, file: !22, line: 294, type: !88, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!275 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !276, file: !25, line: 1184)
!276 = !DISubprogram(name: "nearbyintl", scope: !22, file: !22, line: 294, type: !92, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!277 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !278, file: !25, line: 1186)
!278 = !DISubprogram(name: "nextafter", scope: !22, file: !22, line: 259, type: !32, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!279 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !280, file: !25, line: 1187)
!280 = !DISubprogram(name: "nextafterf", scope: !22, file: !22, line: 259, type: !117, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!281 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !282, file: !25, line: 1188)
!282 = !DISubprogram(name: "nextafterl", scope: !22, file: !22, line: 259, type: !121, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!283 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !284, file: !25, line: 1190)
!284 = !DISubprogram(name: "nexttoward", scope: !22, file: !22, line: 261, type: !285, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!285 = !DISubroutineType(types: !286)
!286 = !{!6, !6, !94}
!287 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !288, file: !25, line: 1191)
!288 = !DISubprogram(name: "nexttowardf", scope: !22, file: !22, line: 261, type: !289, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!289 = !DISubroutineType(types: !290)
!290 = !{!83, !83, !94}
!291 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !292, file: !25, line: 1192)
!292 = !DISubprogram(name: "nexttowardl", scope: !22, file: !22, line: 261, type: !121, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!293 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !294, file: !25, line: 1194)
!294 = !DISubprogram(name: "remainder", scope: !22, file: !22, line: 272, type: !32, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!295 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !296, file: !25, line: 1195)
!296 = !DISubprogram(name: "remainderf", scope: !22, file: !22, line: 272, type: !117, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!297 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !298, file: !25, line: 1196)
!298 = !DISubprogram(name: "remainderl", scope: !22, file: !22, line: 272, type: !121, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!299 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !300, file: !25, line: 1198)
!300 = !DISubprogram(name: "remquo", scope: !22, file: !22, line: 307, type: !301, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!301 = !DISubroutineType(types: !302)
!302 = !{!6, !6, !6, !52}
!303 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !304, file: !25, line: 1199)
!304 = !DISubprogram(name: "remquof", scope: !22, file: !22, line: 307, type: !305, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!305 = !DISubroutineType(types: !306)
!306 = !{!83, !83, !83, !52}
!307 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !308, file: !25, line: 1200)
!308 = !DISubprogram(name: "remquol", scope: !22, file: !22, line: 307, type: !309, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!309 = !DISubroutineType(types: !310)
!310 = !{!94, !94, !94, !52}
!311 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !312, file: !25, line: 1202)
!312 = !DISubprogram(name: "rint", scope: !22, file: !22, line: 256, type: !23, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!313 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !314, file: !25, line: 1203)
!314 = !DISubprogram(name: "rintf", scope: !22, file: !22, line: 256, type: !88, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!315 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !316, file: !25, line: 1204)
!316 = !DISubprogram(name: "rintl", scope: !22, file: !22, line: 256, type: !92, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!317 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !318, file: !25, line: 1206)
!318 = !DISubprogram(name: "round", scope: !22, file: !22, line: 298, type: !23, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!319 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !320, file: !25, line: 1207)
!320 = !DISubprogram(name: "roundf", scope: !22, file: !22, line: 298, type: !88, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!321 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !322, file: !25, line: 1208)
!322 = !DISubprogram(name: "roundl", scope: !22, file: !22, line: 298, type: !92, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!323 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !324, file: !25, line: 1210)
!324 = !DISubprogram(name: "scalbln", scope: !22, file: !22, line: 290, type: !325, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!325 = !DISubroutineType(types: !326)
!326 = !{!6, !6, !242}
!327 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !328, file: !25, line: 1211)
!328 = !DISubprogram(name: "scalblnf", scope: !22, file: !22, line: 290, type: !329, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!329 = !DISubroutineType(types: !330)
!330 = !{!83, !83, !242}
!331 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !332, file: !25, line: 1212)
!332 = !DISubprogram(name: "scalblnl", scope: !22, file: !22, line: 290, type: !333, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!333 = !DISubroutineType(types: !334)
!334 = !{!94, !94, !242}
!335 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !336, file: !25, line: 1214)
!336 = !DISubprogram(name: "scalbn", scope: !22, file: !22, line: 276, type: !55, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!337 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !338, file: !25, line: 1215)
!338 = !DISubprogram(name: "scalbnf", scope: !22, file: !22, line: 276, type: !339, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!339 = !DISubroutineType(types: !340)
!340 = !{!83, !83, !7}
!341 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !342, file: !25, line: 1216)
!342 = !DISubprogram(name: "scalbnl", scope: !22, file: !22, line: 276, type: !343, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!343 = !DISubroutineType(types: !344)
!344 = !{!94, !94, !7}
!345 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !346, file: !25, line: 1218)
!346 = !DISubprogram(name: "tgamma", scope: !22, file: !22, line: 235, type: !23, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!347 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !348, file: !25, line: 1219)
!348 = !DISubprogram(name: "tgammaf", scope: !22, file: !22, line: 235, type: !88, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!349 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !350, file: !25, line: 1220)
!350 = !DISubprogram(name: "tgammal", scope: !22, file: !22, line: 235, type: !92, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!351 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !352, file: !25, line: 1222)
!352 = !DISubprogram(name: "trunc", scope: !22, file: !22, line: 302, type: !23, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!353 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !354, file: !25, line: 1223)
!354 = !DISubprogram(name: "truncf", scope: !22, file: !22, line: 302, type: !88, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!355 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !356, file: !25, line: 1224)
!356 = !DISubprogram(name: "truncl", scope: !22, file: !22, line: 302, type: !92, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!357 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !358, file: !360, line: 127)
!358 = !DIDerivedType(tag: DW_TAG_typedef, name: "div_t", file: !16, line: 62, baseType: !359)
!359 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !16, line: 58, flags: DIFlagFwdDecl, identifier: "_ZTS5div_t")
!360 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.3.0/../../../../include/c++/7.3.0/cstdlib", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!361 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !362, file: !360, line: 128)
!362 = !DIDerivedType(tag: DW_TAG_typedef, name: "ldiv_t", file: !16, line: 70, baseType: !363)
!363 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !16, line: 66, size: 128, flags: DIFlagTypePassByValue | DIFlagTrivial, elements: !364, identifier: "_ZTS6ldiv_t")
!364 = !{!365, !366}
!365 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !363, file: !16, line: 68, baseType: !242, size: 64)
!366 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !363, file: !16, line: 69, baseType: !242, size: 64, offset: 64)
!367 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !368, file: !360, line: 130)
!368 = !DISubprogram(name: "abort", scope: !16, file: !16, line: 588, type: !369, isLocal: false, isDefinition: false, flags: DIFlagPrototyped | DIFlagNoReturn, isOptimized: true)
!369 = !DISubroutineType(types: !370)
!370 = !{null}
!371 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !372, file: !360, line: 134)
!372 = !DISubprogram(name: "atexit", scope: !16, file: !16, line: 592, type: !373, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!373 = !DISubroutineType(types: !374)
!374 = !{!7, !375}
!375 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !369, size: 64)
!376 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !377, file: !360, line: 137)
!377 = !DISubprogram(name: "at_quick_exit", scope: !16, file: !16, line: 597, type: !373, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!378 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !379, file: !360, line: 140)
!379 = !DISubprogram(name: "atof", scope: !380, file: !380, line: 25, type: !259, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!380 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdlib-float.h", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!381 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !382, file: !360, line: 141)
!382 = distinct !DISubprogram(name: "atoi", scope: !16, file: !16, line: 361, type: !383, isLocal: false, isDefinition: true, scopeLine: 362, flags: DIFlagPrototyped, isOptimized: true, unit: !2, retainedNodes: !385)
!383 = !DISubroutineType(types: !384)
!384 = !{!7, !261}
!385 = !{!386}
!386 = !DILocalVariable(name: "__nptr", arg: 1, scope: !382, file: !16, line: 361, type: !261)
!387 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !388, file: !360, line: 142)
!388 = !DISubprogram(name: "atol", scope: !16, file: !16, line: 366, type: !389, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!389 = !DISubroutineType(types: !390)
!390 = !{!242, !261}
!391 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !392, file: !360, line: 143)
!392 = !DISubprogram(name: "bsearch", scope: !393, file: !393, line: 20, type: !394, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!393 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdlib-bsearch.h", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!394 = !DISubroutineType(types: !395)
!395 = !{!396, !397, !397, !399, !399, !402}
!396 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!397 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !398, size: 64)
!398 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!399 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !400, line: 62, baseType: !401)
!400 = !DIFile(filename: "/home/mcopik/projects/clang_llvm/build_release/lib/clang/8.0.0/include/stddef.h", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!401 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!402 = !DIDerivedType(tag: DW_TAG_typedef, name: "__compar_fn_t", file: !16, line: 805, baseType: !403)
!403 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !404, size: 64)
!404 = !DISubroutineType(types: !405)
!405 = !{!7, !397, !397}
!406 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !407, file: !360, line: 144)
!407 = !DISubprogram(name: "calloc", scope: !16, file: !16, line: 541, type: !408, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!408 = !DISubroutineType(types: !409)
!409 = !{!396, !399, !399}
!410 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !411, file: !360, line: 145)
!411 = !DISubprogram(name: "div", scope: !16, file: !16, line: 849, type: !412, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!412 = !DISubroutineType(types: !413)
!413 = !{!358, !7, !7}
!414 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !415, file: !360, line: 146)
!415 = !DISubprogram(name: "exit", scope: !16, file: !16, line: 614, type: !416, isLocal: false, isDefinition: false, flags: DIFlagPrototyped | DIFlagNoReturn, isOptimized: true)
!416 = !DISubroutineType(types: !417)
!417 = !{null, !7}
!418 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !419, file: !360, line: 147)
!419 = !DISubprogram(name: "free", scope: !16, file: !16, line: 563, type: !420, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!420 = !DISubroutineType(types: !421)
!421 = !{null, !396}
!422 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !423, file: !360, line: 148)
!423 = !DISubprogram(name: "getenv", scope: !16, file: !16, line: 631, type: !424, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!424 = !DISubroutineType(types: !425)
!425 = !{!9, !261}
!426 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !427, file: !360, line: 149)
!427 = !DISubprogram(name: "labs", scope: !16, file: !16, line: 838, type: !428, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!428 = !DISubroutineType(types: !429)
!429 = !{!242, !242}
!430 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !431, file: !360, line: 150)
!431 = !DISubprogram(name: "ldiv", scope: !16, file: !16, line: 851, type: !432, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!432 = !DISubroutineType(types: !433)
!433 = !{!362, !242, !242}
!434 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !435, file: !360, line: 151)
!435 = !DISubprogram(name: "malloc", scope: !16, file: !16, line: 539, type: !436, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!436 = !DISubroutineType(types: !437)
!437 = !{!396, !399}
!438 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !439, file: !360, line: 153)
!439 = !DISubprogram(name: "mblen", scope: !16, file: !16, line: 919, type: !440, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!440 = !DISubroutineType(types: !441)
!441 = !{!7, !261, !399}
!442 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !443, file: !360, line: 154)
!443 = !DISubprogram(name: "mbstowcs", scope: !16, file: !16, line: 930, type: !444, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!444 = !DISubroutineType(types: !445)
!445 = !{!399, !446, !449, !399}
!446 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !447)
!447 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !448, size: 64)
!448 = !DIBasicType(name: "wchar_t", size: 32, encoding: DW_ATE_signed)
!449 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !261)
!450 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !451, file: !360, line: 155)
!451 = !DISubprogram(name: "mbtowc", scope: !16, file: !16, line: 922, type: !452, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!452 = !DISubroutineType(types: !453)
!453 = !{!7, !446, !449, !399}
!454 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !455, file: !360, line: 157)
!455 = !DISubprogram(name: "qsort", scope: !16, file: !16, line: 827, type: !456, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!456 = !DISubroutineType(types: !457)
!457 = !{null, !396, !399, !399, !402}
!458 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !459, file: !360, line: 160)
!459 = !DISubprogram(name: "quick_exit", scope: !16, file: !16, line: 620, type: !416, isLocal: false, isDefinition: false, flags: DIFlagPrototyped | DIFlagNoReturn, isOptimized: true)
!460 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !461, file: !360, line: 163)
!461 = !DISubprogram(name: "rand", scope: !16, file: !16, line: 453, type: !462, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!462 = !DISubroutineType(types: !463)
!463 = !{!7}
!464 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !465, file: !360, line: 164)
!465 = !DISubprogram(name: "realloc", scope: !16, file: !16, line: 549, type: !466, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!466 = !DISubroutineType(types: !467)
!467 = !{!396, !396, !399}
!468 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !469, file: !360, line: 165)
!469 = !DISubprogram(name: "srand", scope: !16, file: !16, line: 455, type: !470, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!470 = !DISubroutineType(types: !471)
!471 = !{null, !472}
!472 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!473 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !474, file: !360, line: 166)
!474 = !DISubprogram(name: "strtod", scope: !16, file: !16, line: 117, type: !475, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!475 = !DISubroutineType(types: !476)
!476 = !{!6, !449, !477}
!477 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !8)
!478 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !479, file: !360, line: 167)
!479 = !DISubprogram(name: "strtol", scope: !16, file: !16, line: 176, type: !480, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!480 = !DISubroutineType(types: !481)
!481 = !{!242, !449, !477, !7}
!482 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !483, file: !360, line: 168)
!483 = !DISubprogram(name: "strtoul", scope: !16, file: !16, line: 180, type: !484, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!484 = !DISubroutineType(types: !485)
!485 = !{!401, !449, !477, !7}
!486 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !487, file: !360, line: 169)
!487 = !DISubprogram(name: "system", scope: !16, file: !16, line: 781, type: !383, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!488 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !489, file: !360, line: 171)
!489 = !DISubprogram(name: "wcstombs", scope: !16, file: !16, line: 933, type: !490, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!490 = !DISubroutineType(types: !491)
!491 = !{!399, !492, !493, !399}
!492 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !9)
!493 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !494)
!494 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !495, size: 64)
!495 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !448)
!496 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !497, file: !360, line: 172)
!497 = !DISubprogram(name: "wctomb", scope: !16, file: !16, line: 926, type: !498, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!498 = !DISubroutineType(types: !499)
!499 = !{!7, !9, !448}
!500 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !501, entity: !502, file: !360, line: 200)
!501 = !DINamespace(name: "__gnu_cxx", scope: null)
!502 = !DIDerivedType(tag: DW_TAG_typedef, name: "lldiv_t", file: !16, line: 80, baseType: !503)
!503 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !16, line: 76, size: 128, flags: DIFlagTypePassByValue | DIFlagTrivial, elements: !504, identifier: "_ZTS7lldiv_t")
!504 = !{!505, !506}
!505 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !503, file: !16, line: 78, baseType: !205, size: 64)
!506 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !503, file: !16, line: 79, baseType: !205, size: 64, offset: 64)
!507 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !501, entity: !508, file: !360, line: 206)
!508 = !DISubprogram(name: "_Exit", scope: !16, file: !16, line: 626, type: !416, isLocal: false, isDefinition: false, flags: DIFlagPrototyped | DIFlagNoReturn, isOptimized: true)
!509 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !501, entity: !510, file: !360, line: 210)
!510 = !DISubprogram(name: "llabs", scope: !16, file: !16, line: 841, type: !511, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!511 = !DISubroutineType(types: !512)
!512 = !{!205, !205}
!513 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !501, entity: !514, file: !360, line: 216)
!514 = !DISubprogram(name: "lldiv", scope: !16, file: !16, line: 855, type: !515, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!515 = !DISubroutineType(types: !516)
!516 = !{!502, !205, !205}
!517 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !501, entity: !518, file: !360, line: 227)
!518 = !DISubprogram(name: "atoll", scope: !16, file: !16, line: 373, type: !519, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!519 = !DISubroutineType(types: !520)
!520 = !{!205, !261}
!521 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !501, entity: !522, file: !360, line: 228)
!522 = !DISubprogram(name: "strtoll", scope: !16, file: !16, line: 200, type: !523, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!523 = !DISubroutineType(types: !524)
!524 = !{!205, !449, !477, !7}
!525 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !501, entity: !526, file: !360, line: 229)
!526 = !DISubprogram(name: "strtoull", scope: !16, file: !16, line: 205, type: !527, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!527 = !DISubroutineType(types: !528)
!528 = !{!529, !449, !477, !7}
!529 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!530 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !501, entity: !531, file: !360, line: 231)
!531 = !DISubprogram(name: "strtof", scope: !16, file: !16, line: 123, type: !532, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!532 = !DISubroutineType(types: !533)
!533 = !{!83, !449, !477}
!534 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !501, entity: !535, file: !360, line: 232)
!535 = !DISubprogram(name: "strtold", scope: !16, file: !16, line: 126, type: !536, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!536 = !DISubroutineType(types: !537)
!537 = !{!94, !449, !477}
!538 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !502, file: !360, line: 240)
!539 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !508, file: !360, line: 242)
!540 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !510, file: !360, line: 244)
!541 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !542, file: !360, line: 245)
!542 = !DISubprogram(name: "div", linkageName: "_ZN9__gnu_cxx3divExx", scope: !501, file: !360, line: 213, type: !515, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!543 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !514, file: !360, line: 246)
!544 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !518, file: !360, line: 248)
!545 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !531, file: !360, line: 249)
!546 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !522, file: !360, line: 250)
!547 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !526, file: !360, line: 251)
!548 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !14, entity: !535, file: !360, line: 252)
!549 = !DIGlobalVariableExpression(var: !550, expr: !DIExpression())
!550 = distinct !DIGlobalVariable(name: "global2", scope: !551, file: !552, line: 6, type: !6, isLocal: false, isDefinition: true)
!551 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !552, producer: "clang version 8.0.0 (git@github.com:llvm-mirror/clang.git e3e8f2a67bc17cb4f751b22e53e16d7c39b371d0) (git@github.com:llvm-mirror/LLVM.git 48e9774b6791c48760d18775039eefa6d824522d)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !553, globals: !554, imports: !555, nameTableKind: None)
!552 = !DIFile(filename: "tests/extrap/globals_tu2.cpp", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!553 = !{!6}
!554 = !{!549}
!555 = !{!13, !20, !26, !28, !30, !34, !36, !38, !40, !42, !44, !46, !48, !53, !57, !59, !61, !66, !68, !70, !72, !74, !76, !78, !81, !84, !86, !90, !95, !97, !99, !101, !103, !105, !107, !109, !111, !113, !115, !119, !123, !125, !127, !129, !131, !133, !135, !137, !139, !141, !143, !145, !147, !149, !151, !153, !157, !161, !165, !167, !169, !171, !173, !175, !177, !179, !181, !183, !187, !191, !195, !197, !199, !201, !206, !210, !214, !216, !218, !220, !222, !224, !226, !228, !230, !232, !234, !236, !238, !243, !247, !251, !253, !255, !257, !263, !267, !271, !273, !275, !277, !279, !281, !283, !287, !291, !293, !295, !297, !299, !303, !307, !311, !313, !315, !317, !319, !321, !323, !327, !331, !335, !337, !341, !345, !347, !349, !351, !353, !355}
!556 = !{!"clang version 8.0.0 (git@github.com:llvm-mirror/clang.git e3e8f2a67bc17cb4f751b22e53e16d7c39b371d0) (git@github.com:llvm-mirror/LLVM.git 48e9774b6791c48760d18775039eefa6d824522d)"}
!557 = !{i32 2, !"Dwarf Version", i32 4}
!558 = !{i32 2, !"Debug Info Version", i32 3}
!559 = !{i32 1, !"wchar_size", i32 4}
!560 = distinct !DISubprogram(name: "h", linkageName: "_Z1hi", scope: !3, file: !3, line: 12, type: !17, isLocal: false, isDefinition: true, scopeLine: 13, flags: DIFlagPrototyped, isOptimized: true, unit: !2, retainedNodes: !561)
!561 = !{!562}
!562 = !DILocalVariable(name: "x", arg: 1, scope: !560, file: !3, line: 12, type: !7)
!563 = !{!564, !564, i64 0}
!564 = !{!"int", !565, i64 0}
!565 = !{!"omnipotent char", !566, i64 0}
!566 = !{!"Simple C++ TBAA"}
!567 = !DILocation(line: 12, column: 11, scope: !560)
!568 = !DILocation(line: 14, column: 18, scope: !560)
!569 = !DILocation(line: 14, column: 16, scope: !560)
!570 = !DILocation(line: 14, column: 12, scope: !560)
!571 = !DILocation(line: 14, column: 39, scope: !560)
!572 = !{!573, !573, i64 0}
!573 = !{!"double", !565, i64 0}
!574 = !DILocation(line: 14, column: 22, scope: !560)
!575 = !DILocation(line: 14, column: 20, scope: !560)
!576 = !DILocation(line: 14, column: 5, scope: !560)
!577 = distinct !DISubprogram(name: "f", linkageName: "_Z1fii", scope: !3, file: !3, line: 17, type: !578, isLocal: false, isDefinition: true, scopeLine: 18, flags: DIFlagPrototyped, isOptimized: true, unit: !2, retainedNodes: !580)
!578 = !DISubroutineType(types: !579)
!579 = !{!7, !7, !7}
!580 = !{!581, !582}
!581 = !DILocalVariable(name: "x", arg: 1, scope: !577, file: !3, line: 17, type: !7)
!582 = !DILocalVariable(name: "y", arg: 2, scope: !577, file: !3, line: 17, type: !7)
!583 = !DILocation(line: 17, column: 11, scope: !577)
!584 = !DILocation(line: 17, column: 18, scope: !577)
!585 = !DILocation(line: 19, column: 15, scope: !577)
!586 = !DILocation(line: 19, column: 14, scope: !577)
!587 = !DILocation(line: 19, column: 21, scope: !577)
!588 = !DILocation(line: 19, column: 30, scope: !577)
!589 = !DILocation(line: 19, column: 28, scope: !577)
!590 = !DILocation(line: 19, column: 19, scope: !577)
!591 = !DILocation(line: 19, column: 17, scope: !577)
!592 = !DILocation(line: 19, column: 5, scope: !577)
!593 = distinct !DISubprogram(name: "i", linkageName: "_Z1iiii", scope: !3, file: !3, line: 22, type: !594, isLocal: false, isDefinition: true, scopeLine: 23, flags: DIFlagPrototyped, isOptimized: true, unit: !2, retainedNodes: !596)
!594 = !DISubroutineType(types: !595)
!595 = !{!7, !7, !7, !7}
!596 = !{!597, !598, !599, !600}
!597 = !DILocalVariable(name: "x1", arg: 1, scope: !593, file: !3, line: 22, type: !7)
!598 = !DILocalVariable(name: "x2", arg: 2, scope: !593, file: !3, line: 22, type: !7)
!599 = !DILocalVariable(name: "x3", arg: 3, scope: !593, file: !3, line: 22, type: !7)
!600 = !DILocalVariable(name: "c", scope: !593, file: !3, line: 24, type: !7)
!601 = !DILocation(line: 22, column: 11, scope: !593)
!602 = !DILocation(line: 22, column: 19, scope: !593)
!603 = !DILocation(line: 22, column: 27, scope: !593)
!604 = !DILocation(line: 24, column: 5, scope: !593)
!605 = !DILocation(line: 24, column: 9, scope: !593)
!606 = !DILocation(line: 24, column: 13, scope: !593)
!607 = !DILocation(line: 24, column: 21, scope: !593)
!608 = !DILocation(line: 25, column: 7, scope: !593)
!609 = !DILocation(line: 25, column: 5, scope: !593)
!610 = !DILocation(line: 26, column: 14, scope: !593)
!611 = !DILocation(line: 26, column: 18, scope: !593)
!612 = !DILocation(line: 26, column: 12, scope: !593)
!613 = !DILocation(line: 26, column: 24, scope: !593)
!614 = !DILocation(line: 26, column: 22, scope: !593)
!615 = !DILocation(line: 26, column: 29, scope: !593)
!616 = !DILocation(line: 26, column: 34, scope: !593)
!617 = !DILocation(line: 26, column: 32, scope: !593)
!618 = !DILocation(line: 26, column: 27, scope: !593)
!619 = !DILocation(line: 26, column: 44, scope: !593)
!620 = !DILocation(line: 26, column: 42, scope: !593)
!621 = !DILocation(line: 27, column: 1, scope: !593)
!622 = !DILocation(line: 26, column: 5, scope: !593)
!623 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 29, type: !624, isLocal: false, isDefinition: true, scopeLine: 30, flags: DIFlagPrototyped, isOptimized: true, unit: !2, retainedNodes: !626)
!624 = !DISubroutineType(types: !625)
!625 = !{!7, !7, !8}
!626 = !{!627, !628, !629, !630}
!627 = !DILocalVariable(name: "argc", arg: 1, scope: !623, file: !3, line: 29, type: !7)
!628 = !DILocalVariable(name: "argv", arg: 2, scope: !623, file: !3, line: 29, type: !8)
!629 = !DILocalVariable(name: "x1", scope: !623, file: !3, line: 31, type: !7)
!630 = !DILocalVariable(name: "x2", scope: !623, file: !3, line: 32, type: !7)
!631 = !DILocation(line: 29, column: 14, scope: !623)
!632 = !{!633, !633, i64 0}
!633 = !{!"any pointer", !565, i64 0}
!634 = !DILocation(line: 29, column: 28, scope: !623)
!635 = !DILocation(line: 31, column: 5, scope: !623)
!636 = !DILocation(line: 31, column: 9, scope: !623)
!637 = !DILocation(line: 31, column: 19, scope: !623)
!638 = !DILocation(line: 31, column: 14, scope: !623)
!639 = !DILocation(line: 32, column: 5, scope: !623)
!640 = !DILocation(line: 32, column: 9, scope: !623)
!641 = !DILocation(line: 32, column: 19, scope: !623)
!642 = !DILocation(line: 32, column: 14, scope: !623)
!643 = !DILocation(line: 35, column: 7, scope: !623)
!644 = !DILocation(line: 35, column: 11, scope: !623)
!645 = !DILocation(line: 35, column: 5, scope: !623)
!646 = !DILocation(line: 36, column: 7, scope: !623)
!647 = !DILocation(line: 36, column: 5, scope: !623)
!648 = !DILocation(line: 38, column: 5, scope: !623)
!649 = !DILocation(line: 40, column: 5, scope: !623)
!650 = !DILocation(line: 41, column: 5, scope: !623)
!651 = !DILocation(line: 43, column: 16, scope: !623)
!652 = !DILocation(line: 43, column: 19, scope: !623)
!653 = !DILocation(line: 43, column: 18, scope: !623)
!654 = !DILocation(line: 43, column: 5, scope: !623)
!655 = !DILocation(line: 46, column: 1, scope: !623)
!656 = !DILocation(line: 45, column: 5, scope: !623)
!657 = !DILocation(line: 361, column: 1, scope: !382)
!658 = !DILocation(line: 363, column: 24, scope: !382)
!659 = !DILocation(line: 363, column: 16, scope: !382)
!660 = !DILocation(line: 363, column: 3, scope: !382)
!661 = distinct !DISubprogram(name: "g", linkageName: "_Z1gi", scope: !552, file: !552, line: 10, type: !17, isLocal: false, isDefinition: true, scopeLine: 11, flags: DIFlagPrototyped, isOptimized: true, unit: !551, retainedNodes: !662)
!662 = !{!663}
!663 = !DILocalVariable(name: "x", arg: 1, scope: !661, file: !552, line: 10, type: !7)
!664 = !DILocation(line: 10, column: 11, scope: !661)
!665 = !DILocation(line: 12, column: 20, scope: !661)
!666 = !DILocation(line: 12, column: 18, scope: !661)
!667 = !DILocation(line: 12, column: 14, scope: !661)
!668 = !DILocation(line: 12, column: 41, scope: !661)
!669 = !DILocation(line: 12, column: 24, scope: !661)
!670 = !DILocation(line: 12, column: 22, scope: !661)
!671 = !DILocation(line: 12, column: 12, scope: !661)
!672 = !DILocation(line: 12, column: 5, scope: !661)
