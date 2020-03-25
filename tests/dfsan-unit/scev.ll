; RUN: opt %dfsan -perf-taint-scev -perf-taint-pass-stats=scev.json -S < %s 2> /dev/null && diff %s.pass.json scev.json
; ModuleID = 'tests/dfsan-unit/scev.cpp'
source_filename = "tests/dfsan-unit/scev.cpp"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; Function Attrs: nounwind uwtable
define dso_local i32 @_Z14empty_functionii(i32, i32) #0 !dbg !217 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, i32* %3, align 4, !tbaa !223
  call void @llvm.dbg.declare(metadata i32* %3, metadata !221, metadata !DIExpression()), !dbg !227
  store i32 %1, i32* %4, align 4, !tbaa !223
  call void @llvm.dbg.declare(metadata i32* %4, metadata !222, metadata !DIExpression()), !dbg !228
  %5 = load i32, i32* %3, align 4, !dbg !229, !tbaa !223
  %6 = load i32, i32* %4, align 4, !dbg !230, !tbaa !223
  %7 = add nsw i32 %5, %6, !dbg !231
  ret i32 %7, !dbg !232
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind uwtable
define dso_local i32 @_Z13constant_loopii(i32, i32) #0 !dbg !233 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i32 %0, i32* %3, align 4, !tbaa !223
  call void @llvm.dbg.declare(metadata i32* %3, metadata !235, metadata !DIExpression()), !dbg !240
  store i32 %1, i32* %4, align 4, !tbaa !223
  call void @llvm.dbg.declare(metadata i32* %4, metadata !236, metadata !DIExpression()), !dbg !241
  %7 = bitcast i32* %5 to i8*, !dbg !242
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %7) #6, !dbg !242
  call void @llvm.dbg.declare(metadata i32* %5, metadata !237, metadata !DIExpression()), !dbg !243
  store i32 0, i32* %5, align 4, !dbg !243, !tbaa !223
  %8 = bitcast i32* %6 to i8*, !dbg !244
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %8) #6, !dbg !244
  call void @llvm.dbg.declare(metadata i32* %6, metadata !238, metadata !DIExpression()), !dbg !245
  store i32 0, i32* %6, align 4, !dbg !245, !tbaa !223
  br label %9, !dbg !244

9:                                                ; preds = %18, %2
  %10 = load i32, i32* %6, align 4, !dbg !246, !tbaa !223
  %11 = icmp slt i32 %10, 100, !dbg !248
  br i1 %11, label %14, label %12, !dbg !249

12:                                               ; preds = %9
  %13 = bitcast i32* %6 to i8*, !dbg !250
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %13) #6, !dbg !250
  br label %21

14:                                               ; preds = %9
  %15 = load i32, i32* %6, align 4, !dbg !251, !tbaa !223
  %16 = load i32, i32* %5, align 4, !dbg !252, !tbaa !223
  %17 = add nsw i32 %16, %15, !dbg !252
  store i32 %17, i32* %5, align 4, !dbg !252, !tbaa !223
  br label %18, !dbg !253

18:                                               ; preds = %14
  %19 = load i32, i32* %6, align 4, !dbg !254, !tbaa !223
  %20 = add nsw i32 %19, 1, !dbg !254
  store i32 %20, i32* %6, align 4, !dbg !254, !tbaa !223
  br label %9, !dbg !250, !llvm.loop !255

21:                                               ; preds = %12
  %22 = load i32, i32* %5, align 4, !dbg !257, !tbaa !223
  %23 = load i32, i32* %3, align 4, !dbg !258, !tbaa !223
  %24 = add nsw i32 %22, %23, !dbg !259
  %25 = load i32, i32* %4, align 4, !dbg !260, !tbaa !223
  %26 = add nsw i32 %24, %25, !dbg !261
  %27 = bitcast i32* %5 to i8*, !dbg !262
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %27) #6, !dbg !262
  ret i32 %26, !dbg !263
}

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: nounwind uwtable
define dso_local i32 @_Z16nonconstant_loopii(i32, i32) #0 !dbg !264 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i32 %0, i32* %3, align 4, !tbaa !223
  call void @llvm.dbg.declare(metadata i32* %3, metadata !266, metadata !DIExpression()), !dbg !271
  store i32 %1, i32* %4, align 4, !tbaa !223
  call void @llvm.dbg.declare(metadata i32* %4, metadata !267, metadata !DIExpression()), !dbg !272
  %7 = bitcast i32* %5 to i8*, !dbg !273
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %7) #6, !dbg !273
  call void @llvm.dbg.declare(metadata i32* %5, metadata !268, metadata !DIExpression()), !dbg !274
  store i32 0, i32* %5, align 4, !dbg !274, !tbaa !223
  %8 = bitcast i32* %6 to i8*, !dbg !275
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %8) #6, !dbg !275
  call void @llvm.dbg.declare(metadata i32* %6, metadata !269, metadata !DIExpression()), !dbg !276
  store i32 0, i32* %6, align 4, !dbg !276, !tbaa !223
  br label %9, !dbg !275

9:                                                ; preds = %19, %2
  %10 = load i32, i32* %6, align 4, !dbg !277, !tbaa !223
  %11 = load i32, i32* %3, align 4, !dbg !279, !tbaa !223
  %12 = icmp slt i32 %10, %11, !dbg !280
  br i1 %12, label %15, label %13, !dbg !281

13:                                               ; preds = %9
  %14 = bitcast i32* %6 to i8*, !dbg !282
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %14) #6, !dbg !282
  br label %22

15:                                               ; preds = %9
  %16 = load i32, i32* %6, align 4, !dbg !283, !tbaa !223
  %17 = load i32, i32* %5, align 4, !dbg !284, !tbaa !223
  %18 = add nsw i32 %17, %16, !dbg !284
  store i32 %18, i32* %5, align 4, !dbg !284, !tbaa !223
  br label %19, !dbg !285

19:                                               ; preds = %15
  %20 = load i32, i32* %6, align 4, !dbg !286, !tbaa !223
  %21 = add nsw i32 %20, 1, !dbg !286
  store i32 %21, i32* %6, align 4, !dbg !286, !tbaa !223
  br label %9, !dbg !282, !llvm.loop !287

22:                                               ; preds = %13
  %23 = load i32, i32* %5, align 4, !dbg !289, !tbaa !223
  %24 = load i32, i32* %3, align 4, !dbg !290, !tbaa !223
  %25 = add nsw i32 %23, %24, !dbg !291
  %26 = load i32, i32* %4, align 4, !dbg !292, !tbaa !223
  %27 = add nsw i32 %25, %26, !dbg !293
  %28 = bitcast i32* %5 to i8*, !dbg !294
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %28) #6, !dbg !294
  ret i32 %27, !dbg !295
}

; Function Attrs: nounwind uwtable
define dso_local i32 @_Z10mixed_loopii(i32, i32) #0 !dbg !296 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store i32 %0, i32* %3, align 4, !tbaa !223
  call void @llvm.dbg.declare(metadata i32* %3, metadata !298, metadata !DIExpression()), !dbg !305
  store i32 %1, i32* %4, align 4, !tbaa !223
  call void @llvm.dbg.declare(metadata i32* %4, metadata !299, metadata !DIExpression()), !dbg !306
  %8 = bitcast i32* %5 to i8*, !dbg !307
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %8) #6, !dbg !307
  call void @llvm.dbg.declare(metadata i32* %5, metadata !300, metadata !DIExpression()), !dbg !308
  store i32 0, i32* %5, align 4, !dbg !308, !tbaa !223
  %9 = bitcast i32* %6 to i8*, !dbg !309
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %9) #6, !dbg !309
  call void @llvm.dbg.declare(metadata i32* %6, metadata !301, metadata !DIExpression()), !dbg !310
  store i32 0, i32* %6, align 4, !dbg !310, !tbaa !223
  br label %10, !dbg !309

10:                                               ; preds = %20, %2
  %11 = load i32, i32* %6, align 4, !dbg !311, !tbaa !223
  %12 = load i32, i32* %3, align 4, !dbg !313, !tbaa !223
  %13 = icmp slt i32 %11, %12, !dbg !314
  br i1 %13, label %16, label %14, !dbg !315

14:                                               ; preds = %10
  %15 = bitcast i32* %6 to i8*, !dbg !316
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %15) #6, !dbg !316
  br label %23

16:                                               ; preds = %10
  %17 = load i32, i32* %6, align 4, !dbg !317, !tbaa !223
  %18 = load i32, i32* %5, align 4, !dbg !318, !tbaa !223
  %19 = add nsw i32 %18, %17, !dbg !318
  store i32 %19, i32* %5, align 4, !dbg !318, !tbaa !223
  br label %20, !dbg !319

20:                                               ; preds = %16
  %21 = load i32, i32* %6, align 4, !dbg !320, !tbaa !223
  %22 = add nsw i32 %21, 1, !dbg !320
  store i32 %22, i32* %6, align 4, !dbg !320, !tbaa !223
  br label %10, !dbg !316, !llvm.loop !321

23:                                               ; preds = %14
  %24 = bitcast i32* %7 to i8*, !dbg !323
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %24) #6, !dbg !323
  call void @llvm.dbg.declare(metadata i32* %7, metadata !303, metadata !DIExpression()), !dbg !324
  store i32 10, i32* %7, align 4, !dbg !324, !tbaa !223
  br label %25, !dbg !323

25:                                               ; preds = %34, %23
  %26 = load i32, i32* %7, align 4, !dbg !325, !tbaa !223
  %27 = icmp slt i32 %26, 93, !dbg !327
  br i1 %27, label %30, label %28, !dbg !328

28:                                               ; preds = %25
  %29 = bitcast i32* %7 to i8*, !dbg !329
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %29) #6, !dbg !329
  br label %37

30:                                               ; preds = %25
  %31 = load i32, i32* %7, align 4, !dbg !330, !tbaa !223
  %32 = load i32, i32* %5, align 4, !dbg !331, !tbaa !223
  %33 = add nsw i32 %32, %31, !dbg !331
  store i32 %33, i32* %5, align 4, !dbg !331, !tbaa !223
  br label %34, !dbg !332

34:                                               ; preds = %30
  %35 = load i32, i32* %7, align 4, !dbg !333, !tbaa !223
  %36 = add nsw i32 %35, 2, !dbg !333
  store i32 %36, i32* %7, align 4, !dbg !333, !tbaa !223
  br label %25, !dbg !329, !llvm.loop !334

37:                                               ; preds = %28
  %38 = load i32, i32* %5, align 4, !dbg !336, !tbaa !223
  %39 = load i32, i32* %3, align 4, !dbg !337, !tbaa !223
  %40 = add nsw i32 %38, %39, !dbg !338
  %41 = load i32, i32* %4, align 4, !dbg !339, !tbaa !223
  %42 = add nsw i32 %40, %41, !dbg !340
  %43 = bitcast i32* %5 to i8*, !dbg !341
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %43) #6, !dbg !341
  ret i32 %42, !dbg !342
}

; Function Attrs: norecurse nounwind uwtable
define dso_local i32 @main(i32, i8**) #3 !dbg !343 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4, !tbaa !223
  call void @llvm.dbg.declare(metadata i32* %4, metadata !347, metadata !DIExpression()), !dbg !351
  store i8** %1, i8*** %5, align 8, !tbaa !352
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !348, metadata !DIExpression()), !dbg !354
  %8 = bitcast i32* %6 to i8*, !dbg !355
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %8) #6, !dbg !355
  call void @llvm.dbg.declare(metadata i32* %6, metadata !349, metadata !DIExpression()), !dbg !356
  %9 = load i8**, i8*** %5, align 8, !dbg !357, !tbaa !352
  %10 = getelementptr inbounds i8*, i8** %9, i64 1, !dbg !357
  %11 = load i8*, i8** %10, align 8, !dbg !357, !tbaa !352
  %12 = call i32 @atoi(i8* %11) #7, !dbg !358
  store i32 %12, i32* %6, align 4, !dbg !356, !tbaa !223
  %13 = bitcast i32* %7 to i8*, !dbg !359
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %13) #6, !dbg !359
  call void @llvm.dbg.declare(metadata i32* %7, metadata !350, metadata !DIExpression()), !dbg !360
  %14 = load i8**, i8*** %5, align 8, !dbg !361, !tbaa !352
  %15 = getelementptr inbounds i8*, i8** %14, i64 2, !dbg !361
  %16 = load i8*, i8** %15, align 8, !dbg !361, !tbaa !352
  %17 = call i32 @atoi(i8* %16) #7, !dbg !362
  store i32 %17, i32* %7, align 4, !dbg !360, !tbaa !223
  %18 = load i32, i32* %6, align 4, !dbg !363, !tbaa !223
  %19 = load i32, i32* %7, align 4, !dbg !364, !tbaa !223
  %20 = call i32 @_Z14empty_functionii(i32 %18, i32 %19), !dbg !365
  %21 = load i32, i32* %6, align 4, !dbg !366, !tbaa !223
  %22 = load i32, i32* %7, align 4, !dbg !367, !tbaa !223
  %23 = call i32 @_Z13constant_loopii(i32 %21, i32 %22), !dbg !368
  %24 = load i32, i32* %6, align 4, !dbg !369, !tbaa !223
  %25 = load i32, i32* %7, align 4, !dbg !370, !tbaa !223
  %26 = call i32 @_Z16nonconstant_loopii(i32 %24, i32 %25), !dbg !371
  %27 = load i32, i32* %6, align 4, !dbg !372, !tbaa !223
  %28 = load i32, i32* %7, align 4, !dbg !373, !tbaa !223
  %29 = call i32 @_Z10mixed_loopii(i32 %27, i32 %28), !dbg !374
  %30 = bitcast i32* %7 to i8*, !dbg !375
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %30) #6, !dbg !375
  %31 = bitcast i32* %6 to i8*, !dbg !375
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %31) #6, !dbg !375
  ret i32 0, !dbg !376
}

; Function Attrs: inlinehint nounwind readonly uwtable
define available_externally dso_local i32 @atoi(i8* nonnull) #4 !dbg !51 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8, !tbaa !352
  call void @llvm.dbg.declare(metadata i8** %2, metadata !55, metadata !DIExpression()), !dbg !377
  %3 = load i8*, i8** %2, align 8, !dbg !378, !tbaa !352
  %4 = call i64 @strtol(i8* %3, i8** null, i32 10) #6, !dbg !379
  %5 = trunc i64 %4 to i32, !dbg !379
  ret i32 %5, !dbg !380
}

; Function Attrs: nounwind
declare dso_local i64 @strtol(i8*, i8**, i32) #5

attributes #0 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { argmemonly nounwind }
attributes #3 = { norecurse nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { inlinehint nounwind readonly uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #6 = { nounwind }
attributes #7 = { nounwind readonly }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!213, !214, !215}
!llvm.ident = !{!216}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !1, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !3, imports: !8, nameTableKind: None)
!1 = !DIFile(filename: "tests/dfsan-unit/scev.cpp", directory: "/home/mcopik/projects/ETH/extrap/rebuild/perf-taint")
!2 = !{}
!3 = !{!4, !5}
!4 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !6, size: 64)
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!7 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!8 = !{!9, !16, !19, !23, !25, !29, !35, !42, !50, !56, !60, !64, !70, !75, !80, !84, !88, !92, !97, !101, !106, !111, !115, !119, !123, !127, !132, !136, !138, !142, !144, !155, !159, !164, !168, !172, !176, !180, !182, !186, !193, !197, !201, !209, !211}
!9 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !12, file: !15, line: 49)
!10 = !DINamespace(name: "__1", scope: !11, exportSymbols: true)
!11 = !DINamespace(name: "std", scope: null)
!12 = !DIDerivedType(tag: DW_TAG_typedef, name: "ptrdiff_t", file: !13, line: 35, baseType: !14)
!13 = !DIFile(filename: "clang_llvm/llvm-9.0/build-9.0/lib/clang/9.0.0/include/stddef.h", directory: "/home/mcopik/projects")
!14 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!15 = !DIFile(filename: "build_tool/../usr/include/c++/v1/cstddef", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!16 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !17, file: !15, line: 50)
!17 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !13, line: 46, baseType: !18)
!18 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!19 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !20, file: !15, line: 55)
!20 = !DIDerivedType(tag: DW_TAG_typedef, name: "max_align_t", file: !21, line: 24, baseType: !22)
!21 = !DIFile(filename: "clang_llvm/llvm-9.0/build-9.0/lib/clang/9.0.0/include/__stddef_max_align_t.h", directory: "/home/mcopik/projects")
!22 = !DICompositeType(tag: DW_TAG_structure_type, file: !21, line: 19, flags: DIFlagFwdDecl, identifier: "_ZTS11max_align_t")
!23 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !17, file: !24, line: 99)
!24 = !DIFile(filename: "build_tool/../usr/include/c++/v1/cstdlib", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!25 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !26, file: !24, line: 100)
!26 = !DIDerivedType(tag: DW_TAG_typedef, name: "div_t", file: !27, line: 62, baseType: !28)
!27 = !DIFile(filename: "/usr/include/stdlib.h", directory: "")
!28 = !DICompositeType(tag: DW_TAG_structure_type, file: !27, line: 58, flags: DIFlagFwdDecl, identifier: "_ZTS5div_t")
!29 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !30, file: !24, line: 101)
!30 = !DIDerivedType(tag: DW_TAG_typedef, name: "ldiv_t", file: !27, line: 70, baseType: !31)
!31 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !27, line: 66, size: 128, flags: DIFlagTypePassByValue, elements: !32, identifier: "_ZTS6ldiv_t")
!32 = !{!33, !34}
!33 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !31, file: !27, line: 68, baseType: !14, size: 64)
!34 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !31, file: !27, line: 69, baseType: !14, size: 64, offset: 64)
!35 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !36, file: !24, line: 103)
!36 = !DIDerivedType(tag: DW_TAG_typedef, name: "lldiv_t", file: !27, line: 80, baseType: !37)
!37 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !27, line: 76, size: 128, flags: DIFlagTypePassByValue, elements: !38, identifier: "_ZTS7lldiv_t")
!38 = !{!39, !41}
!39 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !37, file: !27, line: 78, baseType: !40, size: 64)
!40 = !DIBasicType(name: "long long int", size: 64, encoding: DW_ATE_signed)
!41 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !37, file: !27, line: 79, baseType: !40, size: 64, offset: 64)
!42 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !43, file: !24, line: 105)
!43 = !DISubprogram(name: "atof", scope: !44, file: !44, line: 25, type: !45, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!44 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdlib-float.h", directory: "")
!45 = !DISubroutineType(types: !46)
!46 = !{!47, !48}
!47 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!48 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !49, size: 64)
!49 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !7)
!50 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !51, file: !24, line: 106)
!51 = distinct !DISubprogram(name: "atoi", scope: !27, file: !27, line: 361, type: !52, scopeLine: 362, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !54)
!52 = !DISubroutineType(types: !53)
!53 = !{!4, !48}
!54 = !{!55}
!55 = !DILocalVariable(name: "__nptr", arg: 1, scope: !51, file: !27, line: 361, type: !48)
!56 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !57, file: !24, line: 107)
!57 = !DISubprogram(name: "atol", scope: !27, file: !27, line: 366, type: !58, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!58 = !DISubroutineType(types: !59)
!59 = !{!14, !48}
!60 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !61, file: !24, line: 109)
!61 = !DISubprogram(name: "atoll", scope: !27, file: !27, line: 373, type: !62, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!62 = !DISubroutineType(types: !63)
!63 = !{!40, !48}
!64 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !65, file: !24, line: 111)
!65 = !DISubprogram(name: "strtod", scope: !27, file: !27, line: 117, type: !66, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!66 = !DISubroutineType(types: !67)
!67 = !{!47, !68, !69}
!68 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !48)
!69 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !5)
!70 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !71, file: !24, line: 112)
!71 = !DISubprogram(name: "strtof", scope: !27, file: !27, line: 123, type: !72, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!72 = !DISubroutineType(types: !73)
!73 = !{!74, !68, !69}
!74 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!75 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !76, file: !24, line: 113)
!76 = !DISubprogram(name: "strtold", scope: !27, file: !27, line: 126, type: !77, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!77 = !DISubroutineType(types: !78)
!78 = !{!79, !68, !69}
!79 = !DIBasicType(name: "long double", size: 128, encoding: DW_ATE_float)
!80 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !81, file: !24, line: 114)
!81 = !DISubprogram(name: "strtol", scope: !27, file: !27, line: 176, type: !82, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!82 = !DISubroutineType(types: !83)
!83 = !{!14, !68, !69, !4}
!84 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !85, file: !24, line: 116)
!85 = !DISubprogram(name: "strtoll", scope: !27, file: !27, line: 200, type: !86, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!86 = !DISubroutineType(types: !87)
!87 = !{!40, !68, !69, !4}
!88 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !89, file: !24, line: 118)
!89 = !DISubprogram(name: "strtoul", scope: !27, file: !27, line: 180, type: !90, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!90 = !DISubroutineType(types: !91)
!91 = !{!18, !68, !69, !4}
!92 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !93, file: !24, line: 120)
!93 = !DISubprogram(name: "strtoull", scope: !27, file: !27, line: 205, type: !94, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!94 = !DISubroutineType(types: !95)
!95 = !{!96, !68, !69, !4}
!96 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!97 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !98, file: !24, line: 122)
!98 = !DISubprogram(name: "rand", scope: !27, file: !27, line: 453, type: !99, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!99 = !DISubroutineType(types: !100)
!100 = !{!4}
!101 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !102, file: !24, line: 123)
!102 = !DISubprogram(name: "srand", scope: !27, file: !27, line: 455, type: !103, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!103 = !DISubroutineType(types: !104)
!104 = !{null, !105}
!105 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!106 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !107, file: !24, line: 124)
!107 = !DISubprogram(name: "calloc", scope: !27, file: !27, line: 541, type: !108, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!108 = !DISubroutineType(types: !109)
!109 = !{!110, !17, !17}
!110 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!111 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !112, file: !24, line: 125)
!112 = !DISubprogram(name: "free", scope: !27, file: !27, line: 563, type: !113, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!113 = !DISubroutineType(types: !114)
!114 = !{null, !110}
!115 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !116, file: !24, line: 126)
!116 = !DISubprogram(name: "malloc", scope: !27, file: !27, line: 539, type: !117, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!117 = !DISubroutineType(types: !118)
!118 = !{!110, !17}
!119 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !120, file: !24, line: 127)
!120 = !DISubprogram(name: "realloc", scope: !27, file: !27, line: 549, type: !121, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!121 = !DISubroutineType(types: !122)
!122 = !{!110, !110, !17}
!123 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !124, file: !24, line: 128)
!124 = !DISubprogram(name: "abort", scope: !27, file: !27, line: 588, type: !125, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!125 = !DISubroutineType(types: !126)
!126 = !{null}
!127 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !128, file: !24, line: 129)
!128 = !DISubprogram(name: "atexit", scope: !27, file: !27, line: 592, type: !129, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!129 = !DISubroutineType(types: !130)
!130 = !{!4, !131}
!131 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !125, size: 64)
!132 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !133, file: !24, line: 130)
!133 = !DISubprogram(name: "exit", scope: !27, file: !27, line: 614, type: !134, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!134 = !DISubroutineType(types: !135)
!135 = !{null, !4}
!136 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !137, file: !24, line: 131)
!137 = !DISubprogram(name: "_Exit", scope: !27, file: !27, line: 626, type: !134, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!138 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !139, file: !24, line: 133)
!139 = !DISubprogram(name: "getenv", scope: !27, file: !27, line: 631, type: !140, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!140 = !DISubroutineType(types: !141)
!141 = !{!6, !48}
!142 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !143, file: !24, line: 134)
!143 = !DISubprogram(name: "system", scope: !27, file: !27, line: 781, type: !52, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!144 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !145, file: !24, line: 136)
!145 = !DISubprogram(name: "bsearch", scope: !146, file: !146, line: 20, type: !147, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!146 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdlib-bsearch.h", directory: "")
!147 = !DISubroutineType(types: !148)
!148 = !{!110, !149, !149, !17, !17, !151}
!149 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !150, size: 64)
!150 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!151 = !DIDerivedType(tag: DW_TAG_typedef, name: "__compar_fn_t", file: !27, line: 805, baseType: !152)
!152 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !153, size: 64)
!153 = !DISubroutineType(types: !154)
!154 = !{!4, !149, !149}
!155 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !156, file: !24, line: 137)
!156 = !DISubprogram(name: "qsort", scope: !27, file: !27, line: 827, type: !157, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!157 = !DISubroutineType(types: !158)
!158 = !{null, !110, !17, !17, !151}
!159 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !160, file: !24, line: 138)
!160 = !DISubprogram(name: "abs", linkageName: "_Z3abse", scope: !161, file: !161, line: 789, type: !162, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!161 = !DIFile(filename: "build_tool/../usr/include/c++/v1/math.h", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!162 = !DISubroutineType(types: !163)
!163 = !{!79, !79}
!164 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !165, file: !24, line: 139)
!165 = !DISubprogram(name: "labs", scope: !27, file: !27, line: 838, type: !166, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!166 = !DISubroutineType(types: !167)
!167 = !{!14, !14}
!168 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !169, file: !24, line: 141)
!169 = !DISubprogram(name: "llabs", scope: !27, file: !27, line: 841, type: !170, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!170 = !DISubroutineType(types: !171)
!171 = !{!40, !40}
!172 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !173, file: !24, line: 143)
!173 = !DISubprogram(name: "div", linkageName: "_Z3divxx", scope: !161, file: !161, line: 808, type: !174, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!174 = !DISubroutineType(types: !175)
!175 = !{!36, !40, !40}
!176 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !177, file: !24, line: 144)
!177 = !DISubprogram(name: "ldiv", scope: !27, file: !27, line: 851, type: !178, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!178 = !DISubroutineType(types: !179)
!179 = !{!30, !14, !14}
!180 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !181, file: !24, line: 146)
!181 = !DISubprogram(name: "lldiv", scope: !27, file: !27, line: 855, type: !174, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!182 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !183, file: !24, line: 148)
!183 = !DISubprogram(name: "mblen", scope: !27, file: !27, line: 919, type: !184, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!184 = !DISubroutineType(types: !185)
!185 = !{!4, !48, !17}
!186 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !187, file: !24, line: 149)
!187 = !DISubprogram(name: "mbtowc", scope: !27, file: !27, line: 922, type: !188, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!188 = !DISubroutineType(types: !189)
!189 = !{!4, !190, !68, !17}
!190 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !191)
!191 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !192, size: 64)
!192 = !DIBasicType(name: "wchar_t", size: 32, encoding: DW_ATE_signed)
!193 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !194, file: !24, line: 150)
!194 = !DISubprogram(name: "wctomb", scope: !27, file: !27, line: 926, type: !195, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!195 = !DISubroutineType(types: !196)
!196 = !{!4, !6, !192}
!197 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !198, file: !24, line: 151)
!198 = !DISubprogram(name: "mbstowcs", scope: !27, file: !27, line: 930, type: !199, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!199 = !DISubroutineType(types: !200)
!200 = !{!17, !190, !68, !17}
!201 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !202, file: !24, line: 152)
!202 = !DISubprogram(name: "wcstombs", scope: !27, file: !27, line: 933, type: !203, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!203 = !DISubroutineType(types: !204)
!204 = !{!17, !205, !206, !17}
!205 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !6)
!206 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !207)
!207 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !208, size: 64)
!208 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !192)
!209 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !210, file: !24, line: 154)
!210 = !DISubprogram(name: "at_quick_exit", scope: !27, file: !27, line: 597, type: !129, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!211 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !10, entity: !212, file: !24, line: 155)
!212 = !DISubprogram(name: "quick_exit", scope: !27, file: !27, line: 620, type: !134, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!213 = !{i32 2, !"Dwarf Version", i32 4}
!214 = !{i32 2, !"Debug Info Version", i32 3}
!215 = !{i32 1, !"wchar_size", i32 4}
!216 = !{!"clang version 9.0.0 (tags/RELEASE_900/final)"}
!217 = distinct !DISubprogram(name: "empty_function", linkageName: "_Z14empty_functionii", scope: !1, file: !1, line: 6, type: !218, scopeLine: 7, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !220)
!218 = !DISubroutineType(types: !219)
!219 = !{!4, !4, !4}
!220 = !{!221, !222}
!221 = !DILocalVariable(name: "x1", arg: 1, scope: !217, file: !1, line: 6, type: !4)
!222 = !DILocalVariable(name: "x2", arg: 2, scope: !217, file: !1, line: 6, type: !4)
!223 = !{!224, !224, i64 0}
!224 = !{!"int", !225, i64 0}
!225 = !{!"omnipotent char", !226, i64 0}
!226 = !{!"Simple C++ TBAA"}
!227 = !DILocation(line: 6, column: 24, scope: !217)
!228 = !DILocation(line: 6, column: 32, scope: !217)
!229 = !DILocation(line: 8, column: 10, scope: !217)
!230 = !DILocation(line: 8, column: 15, scope: !217)
!231 = !DILocation(line: 8, column: 13, scope: !217)
!232 = !DILocation(line: 8, column: 3, scope: !217)
!233 = distinct !DISubprogram(name: "constant_loop", linkageName: "_Z13constant_loopii", scope: !1, file: !1, line: 11, type: !218, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !234)
!234 = !{!235, !236, !237, !238}
!235 = !DILocalVariable(name: "x1", arg: 1, scope: !233, file: !1, line: 11, type: !4)
!236 = !DILocalVariable(name: "x2", arg: 2, scope: !233, file: !1, line: 11, type: !4)
!237 = !DILocalVariable(name: "tmp", scope: !233, file: !1, line: 13, type: !4)
!238 = !DILocalVariable(name: "i", scope: !239, file: !1, line: 14, type: !4)
!239 = distinct !DILexicalBlock(scope: !233, file: !1, line: 14, column: 3)
!240 = !DILocation(line: 11, column: 23, scope: !233)
!241 = !DILocation(line: 11, column: 31, scope: !233)
!242 = !DILocation(line: 13, column: 3, scope: !233)
!243 = !DILocation(line: 13, column: 7, scope: !233)
!244 = !DILocation(line: 14, column: 7, scope: !239)
!245 = !DILocation(line: 14, column: 11, scope: !239)
!246 = !DILocation(line: 14, column: 18, scope: !247)
!247 = distinct !DILexicalBlock(scope: !239, file: !1, line: 14, column: 3)
!248 = !DILocation(line: 14, column: 20, scope: !247)
!249 = !DILocation(line: 14, column: 3, scope: !239)
!250 = !DILocation(line: 14, column: 3, scope: !247)
!251 = !DILocation(line: 15, column: 14, scope: !247)
!252 = !DILocation(line: 15, column: 11, scope: !247)
!253 = !DILocation(line: 15, column: 7, scope: !247)
!254 = !DILocation(line: 14, column: 27, scope: !247)
!255 = distinct !{!255, !249, !256}
!256 = !DILocation(line: 15, column: 14, scope: !239)
!257 = !DILocation(line: 16, column: 10, scope: !233)
!258 = !DILocation(line: 16, column: 16, scope: !233)
!259 = !DILocation(line: 16, column: 14, scope: !233)
!260 = !DILocation(line: 16, column: 21, scope: !233)
!261 = !DILocation(line: 16, column: 19, scope: !233)
!262 = !DILocation(line: 17, column: 1, scope: !233)
!263 = !DILocation(line: 16, column: 3, scope: !233)
!264 = distinct !DISubprogram(name: "nonconstant_loop", linkageName: "_Z16nonconstant_loopii", scope: !1, file: !1, line: 19, type: !218, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !265)
!265 = !{!266, !267, !268, !269}
!266 = !DILocalVariable(name: "x1", arg: 1, scope: !264, file: !1, line: 19, type: !4)
!267 = !DILocalVariable(name: "x2", arg: 2, scope: !264, file: !1, line: 19, type: !4)
!268 = !DILocalVariable(name: "tmp", scope: !264, file: !1, line: 21, type: !4)
!269 = !DILocalVariable(name: "i", scope: !270, file: !1, line: 22, type: !4)
!270 = distinct !DILexicalBlock(scope: !264, file: !1, line: 22, column: 3)
!271 = !DILocation(line: 19, column: 26, scope: !264)
!272 = !DILocation(line: 19, column: 34, scope: !264)
!273 = !DILocation(line: 21, column: 3, scope: !264)
!274 = !DILocation(line: 21, column: 7, scope: !264)
!275 = !DILocation(line: 22, column: 7, scope: !270)
!276 = !DILocation(line: 22, column: 11, scope: !270)
!277 = !DILocation(line: 22, column: 18, scope: !278)
!278 = distinct !DILexicalBlock(scope: !270, file: !1, line: 22, column: 3)
!279 = !DILocation(line: 22, column: 22, scope: !278)
!280 = !DILocation(line: 22, column: 20, scope: !278)
!281 = !DILocation(line: 22, column: 3, scope: !270)
!282 = !DILocation(line: 22, column: 3, scope: !278)
!283 = !DILocation(line: 23, column: 14, scope: !278)
!284 = !DILocation(line: 23, column: 11, scope: !278)
!285 = !DILocation(line: 23, column: 7, scope: !278)
!286 = !DILocation(line: 22, column: 26, scope: !278)
!287 = distinct !{!287, !281, !288}
!288 = !DILocation(line: 23, column: 14, scope: !270)
!289 = !DILocation(line: 24, column: 10, scope: !264)
!290 = !DILocation(line: 24, column: 16, scope: !264)
!291 = !DILocation(line: 24, column: 14, scope: !264)
!292 = !DILocation(line: 24, column: 21, scope: !264)
!293 = !DILocation(line: 24, column: 19, scope: !264)
!294 = !DILocation(line: 25, column: 1, scope: !264)
!295 = !DILocation(line: 24, column: 3, scope: !264)
!296 = distinct !DISubprogram(name: "mixed_loop", linkageName: "_Z10mixed_loopii", scope: !1, file: !1, line: 27, type: !218, scopeLine: 28, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !297)
!297 = !{!298, !299, !300, !301, !303}
!298 = !DILocalVariable(name: "x1", arg: 1, scope: !296, file: !1, line: 27, type: !4)
!299 = !DILocalVariable(name: "x2", arg: 2, scope: !296, file: !1, line: 27, type: !4)
!300 = !DILocalVariable(name: "tmp", scope: !296, file: !1, line: 29, type: !4)
!301 = !DILocalVariable(name: "i", scope: !302, file: !1, line: 30, type: !4)
!302 = distinct !DILexicalBlock(scope: !296, file: !1, line: 30, column: 3)
!303 = !DILocalVariable(name: "i", scope: !304, file: !1, line: 32, type: !4)
!304 = distinct !DILexicalBlock(scope: !296, file: !1, line: 32, column: 3)
!305 = !DILocation(line: 27, column: 20, scope: !296)
!306 = !DILocation(line: 27, column: 28, scope: !296)
!307 = !DILocation(line: 29, column: 3, scope: !296)
!308 = !DILocation(line: 29, column: 7, scope: !296)
!309 = !DILocation(line: 30, column: 7, scope: !302)
!310 = !DILocation(line: 30, column: 11, scope: !302)
!311 = !DILocation(line: 30, column: 18, scope: !312)
!312 = distinct !DILexicalBlock(scope: !302, file: !1, line: 30, column: 3)
!313 = !DILocation(line: 30, column: 22, scope: !312)
!314 = !DILocation(line: 30, column: 20, scope: !312)
!315 = !DILocation(line: 30, column: 3, scope: !302)
!316 = !DILocation(line: 30, column: 3, scope: !312)
!317 = !DILocation(line: 31, column: 14, scope: !312)
!318 = !DILocation(line: 31, column: 11, scope: !312)
!319 = !DILocation(line: 31, column: 7, scope: !312)
!320 = !DILocation(line: 30, column: 26, scope: !312)
!321 = distinct !{!321, !315, !322}
!322 = !DILocation(line: 31, column: 14, scope: !302)
!323 = !DILocation(line: 32, column: 7, scope: !304)
!324 = !DILocation(line: 32, column: 11, scope: !304)
!325 = !DILocation(line: 32, column: 19, scope: !326)
!326 = distinct !DILexicalBlock(scope: !304, file: !1, line: 32, column: 3)
!327 = !DILocation(line: 32, column: 21, scope: !326)
!328 = !DILocation(line: 32, column: 3, scope: !304)
!329 = !DILocation(line: 32, column: 3, scope: !326)
!330 = !DILocation(line: 33, column: 14, scope: !326)
!331 = !DILocation(line: 33, column: 11, scope: !326)
!332 = !DILocation(line: 33, column: 7, scope: !326)
!333 = !DILocation(line: 32, column: 29, scope: !326)
!334 = distinct !{!334, !328, !335}
!335 = !DILocation(line: 33, column: 14, scope: !304)
!336 = !DILocation(line: 34, column: 10, scope: !296)
!337 = !DILocation(line: 34, column: 16, scope: !296)
!338 = !DILocation(line: 34, column: 14, scope: !296)
!339 = !DILocation(line: 34, column: 21, scope: !296)
!340 = !DILocation(line: 34, column: 19, scope: !296)
!341 = !DILocation(line: 35, column: 1, scope: !296)
!342 = !DILocation(line: 34, column: 3, scope: !296)
!343 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 37, type: !344, scopeLine: 38, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !346)
!344 = !DISubroutineType(types: !345)
!345 = !{!4, !4, !5}
!346 = !{!347, !348, !349, !350}
!347 = !DILocalVariable(name: "argc", arg: 1, scope: !343, file: !1, line: 37, type: !4)
!348 = !DILocalVariable(name: "argv", arg: 2, scope: !343, file: !1, line: 37, type: !5)
!349 = !DILocalVariable(name: "x1", scope: !343, file: !1, line: 39, type: !4)
!350 = !DILocalVariable(name: "x2", scope: !343, file: !1, line: 40, type: !4)
!351 = !DILocation(line: 37, column: 14, scope: !343)
!352 = !{!353, !353, i64 0}
!353 = !{!"any pointer", !225, i64 0}
!354 = !DILocation(line: 37, column: 28, scope: !343)
!355 = !DILocation(line: 39, column: 3, scope: !343)
!356 = !DILocation(line: 39, column: 7, scope: !343)
!357 = !DILocation(line: 39, column: 17, scope: !343)
!358 = !DILocation(line: 39, column: 12, scope: !343)
!359 = !DILocation(line: 40, column: 3, scope: !343)
!360 = !DILocation(line: 40, column: 7, scope: !343)
!361 = !DILocation(line: 40, column: 17, scope: !343)
!362 = !DILocation(line: 40, column: 12, scope: !343)
!363 = !DILocation(line: 42, column: 18, scope: !343)
!364 = !DILocation(line: 42, column: 22, scope: !343)
!365 = !DILocation(line: 42, column: 3, scope: !343)
!366 = !DILocation(line: 43, column: 17, scope: !343)
!367 = !DILocation(line: 43, column: 21, scope: !343)
!368 = !DILocation(line: 43, column: 3, scope: !343)
!369 = !DILocation(line: 44, column: 20, scope: !343)
!370 = !DILocation(line: 44, column: 24, scope: !343)
!371 = !DILocation(line: 44, column: 3, scope: !343)
!372 = !DILocation(line: 45, column: 14, scope: !343)
!373 = !DILocation(line: 45, column: 18, scope: !343)
!374 = !DILocation(line: 45, column: 3, scope: !343)
!375 = !DILocation(line: 48, column: 1, scope: !343)
!376 = !DILocation(line: 47, column: 3, scope: !343)
!377 = !DILocation(line: 361, column: 1, scope: !51)
!378 = !DILocation(line: 363, column: 24, scope: !51)
!379 = !DILocation(line: 363, column: 16, scope: !51)
!380 = !DILocation(line: 363, column: 3, scope: !51)
