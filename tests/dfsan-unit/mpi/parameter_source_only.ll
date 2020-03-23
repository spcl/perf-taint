; RUN: opt %mpidfsan -extrap-extractor-out-name=%t4 -S < %s 2> /dev/null | llc %llcparams - -o %t1 && clang++ %link %t1 -o %t2 && %execparams mpiexec -n 2 %t2 && diff -w %s.json %t4_0.json && diff -w %s.json %t4_1.json
; ModuleID = 'tests/dfsan-unit/mpi/parameter_source_only.cpp'
source_filename = "tests/dfsan-unit/mpi/parameter_source_only.cpp"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.ompi_predefined_communicator_t = type opaque
%struct.ompi_communicator_t = type opaque

@.str = private unnamed_addr constant [7 x i8] c"extrap\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [47 x i8] c"tests/dfsan-unit/mpi/parameter_source_only.cpp\00", section "llvm.metadata"
@ompi_mpi_comm_world = external dso_local global %struct.ompi_predefined_communicator_t, align 1

; Function Attrs: uwtable
define dso_local i32 @_Z6sourcev() #0 !dbg !110 {
  %1 = alloca i32, align 4
  %2 = bitcast i32* %1 to i8*, !dbg !115
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %2) #3, !dbg !115
  call void @llvm.dbg.declare(metadata i32* %1, metadata !114, metadata !DIExpression()), !dbg !116
  %3 = bitcast i32* %1 to i8*, !dbg !115
  call void @llvm.var.annotation(i8* %3, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([47 x i8], [47 x i8]* @.str.1, i32 0, i32 0), i32 11), !dbg !115
  %4 = call i32 @MPI_Comm_size(%struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*), i32* %1), !dbg !117
  %5 = load i32, i32* %1, align 4, !dbg !118, !tbaa !119
  %6 = bitcast i32* %1 to i8*, !dbg !123
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %6) #3, !dbg !123
  ret i32 %5, !dbg !124
}

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

; Function Attrs: nounwind
declare void @llvm.var.annotation(i8*, i8*, i8*, i32) #3

declare dso_local i32 @MPI_Comm_size(%struct.ompi_communicator_t*, i32*) #4

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: uwtable
define dso_local i32 @_Z24test_implicit_parameter1v() #0 !dbg !125 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = bitcast i32* %1 to i8*, !dbg !131
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %4) #3, !dbg !131
  call void @llvm.dbg.declare(metadata i32* %1, metadata !127, metadata !DIExpression()), !dbg !132
  %5 = bitcast i32* %2 to i8*, !dbg !131
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %5) #3, !dbg !131
  call void @llvm.dbg.declare(metadata i32* %2, metadata !128, metadata !DIExpression()), !dbg !133
  %6 = call i32 @MPI_Comm_size(%struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*), i32* %1), !dbg !134
  %7 = bitcast i32* %3 to i8*, !dbg !135
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %7) #3, !dbg !135
  call void @llvm.dbg.declare(metadata i32* %3, metadata !129, metadata !DIExpression()), !dbg !136
  store i32 0, i32* %3, align 4, !dbg !136, !tbaa !119
  br label %8, !dbg !135

8:                                                ; preds = %18, %0
  %9 = load i32, i32* %3, align 4, !dbg !137, !tbaa !119
  %10 = load i32, i32* %1, align 4, !dbg !139, !tbaa !119
  %11 = icmp slt i32 %9, %10, !dbg !140
  br i1 %11, label %14, label %12, !dbg !141

12:                                               ; preds = %8
  %13 = bitcast i32* %3 to i8*, !dbg !142
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %13) #3, !dbg !142
  br label %21

14:                                               ; preds = %8
  %15 = load i32, i32* %3, align 4, !dbg !143, !tbaa !119
  %16 = load i32, i32* %2, align 4, !dbg !144, !tbaa !119
  %17 = add nsw i32 %16, %15, !dbg !144
  store i32 %17, i32* %2, align 4, !dbg !144, !tbaa !119
  br label %18, !dbg !145

18:                                               ; preds = %14
  %19 = load i32, i32* %3, align 4, !dbg !146, !tbaa !119
  %20 = add nsw i32 %19, 1, !dbg !146
  store i32 %20, i32* %3, align 4, !dbg !146, !tbaa !119
  br label %8, !dbg !142, !llvm.loop !147

21:                                               ; preds = %12
  %22 = load i32, i32* %2, align 4, !dbg !149, !tbaa !119
  %23 = bitcast i32* %2 to i8*, !dbg !150
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %23) #3, !dbg !150
  %24 = bitcast i32* %1 to i8*, !dbg !150
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %24) #3, !dbg !150
  ret i32 %22, !dbg !151
}

; Function Attrs: nounwind uwtable
define dso_local i32 @_Z24test_implicit_parameter2i(i32) #5 !dbg !152 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, i32* %2, align 4, !tbaa !119
  call void @llvm.dbg.declare(metadata i32* %2, metadata !156, metadata !DIExpression()), !dbg !160
  %5 = bitcast i32* %3 to i8*, !dbg !161
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %5) #3, !dbg !161
  call void @llvm.dbg.declare(metadata i32* %3, metadata !157, metadata !DIExpression()), !dbg !162
  %6 = bitcast i32* %4 to i8*, !dbg !163
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %6) #3, !dbg !163
  call void @llvm.dbg.declare(metadata i32* %4, metadata !158, metadata !DIExpression()), !dbg !164
  store i32 0, i32* %4, align 4, !dbg !164, !tbaa !119
  br label %7, !dbg !163

7:                                                ; preds = %17, %1
  %8 = load i32, i32* %4, align 4, !dbg !165, !tbaa !119
  %9 = load i32, i32* %2, align 4, !dbg !167, !tbaa !119
  %10 = icmp slt i32 %8, %9, !dbg !168
  br i1 %10, label %13, label %11, !dbg !169

11:                                               ; preds = %7
  %12 = bitcast i32* %4 to i8*, !dbg !170
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %12) #3, !dbg !170
  br label %20

13:                                               ; preds = %7
  %14 = load i32, i32* %4, align 4, !dbg !171, !tbaa !119
  %15 = load i32, i32* %3, align 4, !dbg !172, !tbaa !119
  %16 = add nsw i32 %15, %14, !dbg !172
  store i32 %16, i32* %3, align 4, !dbg !172, !tbaa !119
  br label %17, !dbg !173

17:                                               ; preds = %13
  %18 = load i32, i32* %4, align 4, !dbg !174, !tbaa !119
  %19 = add nsw i32 %18, 1, !dbg !174
  store i32 %19, i32* %4, align 4, !dbg !174, !tbaa !119
  br label %7, !dbg !170, !llvm.loop !175

20:                                               ; preds = %11
  %21 = load i32, i32* %3, align 4, !dbg !177, !tbaa !119
  %22 = bitcast i32* %3 to i8*, !dbg !178
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %22) #3, !dbg !178
  ret i32 %21, !dbg !179
}

; Function Attrs: norecurse uwtable
define dso_local i32 @main(i32, i8**) #6 !dbg !180 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4, !tbaa !119
  call void @llvm.dbg.declare(metadata i32* %4, metadata !187, metadata !DIExpression()), !dbg !189
  store i8** %1, i8*** %5, align 8, !tbaa !190
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !188, metadata !DIExpression()), !dbg !192
  %6 = call i32 @MPI_Init(i32* %4, i8*** %5), !dbg !193
  %7 = call i32 @_Z24test_implicit_parameter1v(), !dbg !194
  %8 = call i32 @_Z6sourcev(), !dbg !195
  %9 = call i32 @_Z24test_implicit_parameter2i(i32 %8), !dbg !196
  %10 = call i32 @MPI_Finalize(), !dbg !197
  ret i32 0, !dbg !198
}

declare dso_local i32 @MPI_Init(i32*, i8***) #4

declare dso_local i32 @MPI_Finalize() #4

attributes #0 = { uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind }
attributes #2 = { nounwind readnone speculatable }
attributes #3 = { nounwind }
attributes #4 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #6 = { norecurse uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!106, !107, !108}
!llvm.ident = !{!109}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !1, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !3, imports: !9, nameTableKind: None)
!1 = !DIFile(filename: "tests/dfsan-unit/mpi/parameter_source_only.cpp", directory: "/home/mcopik/projects/ETH/extrap/rebuild/perf-taint")
!2 = !{}
!3 = !{!4, !8}
!4 = !DIDerivedType(tag: DW_TAG_typedef, name: "MPI_Comm", file: !5, line: 330, baseType: !6)
!5 = !DIFile(filename: "/usr/lib/x86_64-linux-gnu/openmpi/include/mpi.h", directory: "")
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!7 = !DICompositeType(tag: DW_TAG_structure_type, name: "ompi_communicator_t", file: !5, line: 330, flags: DIFlagFwdDecl, identifier: "_ZTS19ompi_communicator_t")
!8 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!9 = !{!10, !17, !20, !24, !29, !36, !40, !44, !47, !52, !56, !60, !63, !66, !68, !70, !72, !74, !76, !78, !80, !82, !84, !86, !88, !90, !92, !94, !96, !98, !100, !103}
!10 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !13, file: !16, line: 49)
!11 = !DINamespace(name: "__1", scope: !12, exportSymbols: true)
!12 = !DINamespace(name: "std", scope: null)
!13 = !DIDerivedType(tag: DW_TAG_typedef, name: "ptrdiff_t", file: !14, line: 35, baseType: !15)
!14 = !DIFile(filename: "clang_llvm/llvm-9.0/build-9.0/lib/clang/9.0.0/include/stddef.h", directory: "/home/mcopik/projects")
!15 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!16 = !DIFile(filename: "build_tool/../usr/include/c++/v1/cstddef", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!17 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !18, file: !16, line: 50)
!18 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !14, line: 46, baseType: !19)
!19 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!20 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !21, file: !16, line: 55)
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "max_align_t", file: !22, line: 24, baseType: !23)
!22 = !DIFile(filename: "clang_llvm/llvm-9.0/build-9.0/lib/clang/9.0.0/include/__stddef_max_align_t.h", directory: "/home/mcopik/projects")
!23 = !DICompositeType(tag: DW_TAG_structure_type, file: !22, line: 19, flags: DIFlagFwdDecl, identifier: "_ZTS11max_align_t")
!24 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !25, file: !28, line: 51)
!25 = !DIDerivedType(tag: DW_TAG_typedef, name: "nullptr_t", scope: !12, file: !26, line: 56, baseType: !27)
!26 = !DIFile(filename: "build_tool/../usr/include/c++/v1/__nullptr", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!27 = !DIBasicType(tag: DW_TAG_unspecified_type, name: "decltype(nullptr)")
!28 = !DIFile(filename: "build_tool/../usr/include/c++/v1/stddef.h", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!29 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !30, file: !35, line: 152)
!30 = !DIDerivedType(tag: DW_TAG_typedef, name: "int8_t", file: !31, line: 24, baseType: !32)
!31 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-intn.h", directory: "")
!32 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int8_t", file: !33, line: 36, baseType: !34)
!33 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "")
!34 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!35 = !DIFile(filename: "build_tool/../usr/include/c++/v1/cstdint", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!36 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !37, file: !35, line: 153)
!37 = !DIDerivedType(tag: DW_TAG_typedef, name: "int16_t", file: !31, line: 25, baseType: !38)
!38 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int16_t", file: !33, line: 38, baseType: !39)
!39 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!40 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !41, file: !35, line: 154)
!41 = !DIDerivedType(tag: DW_TAG_typedef, name: "int32_t", file: !31, line: 26, baseType: !42)
!42 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int32_t", file: !33, line: 40, baseType: !43)
!43 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!44 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !45, file: !35, line: 155)
!45 = !DIDerivedType(tag: DW_TAG_typedef, name: "int64_t", file: !31, line: 27, baseType: !46)
!46 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int64_t", file: !33, line: 43, baseType: !15)
!47 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !48, file: !35, line: 157)
!48 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint8_t", file: !49, line: 24, baseType: !50)
!49 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "")
!50 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint8_t", file: !33, line: 37, baseType: !51)
!51 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!52 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !53, file: !35, line: 158)
!53 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint16_t", file: !49, line: 25, baseType: !54)
!54 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint16_t", file: !33, line: 39, baseType: !55)
!55 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!56 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !57, file: !35, line: 159)
!57 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !49, line: 26, baseType: !58)
!58 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !33, line: 41, baseType: !59)
!59 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!60 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !61, file: !35, line: 160)
!61 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", file: !49, line: 27, baseType: !62)
!62 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint64_t", file: !33, line: 44, baseType: !19)
!63 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !64, file: !35, line: 162)
!64 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least8_t", file: !65, line: 43, baseType: !34)
!65 = !DIFile(filename: "/usr/include/stdint.h", directory: "")
!66 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !67, file: !35, line: 163)
!67 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least16_t", file: !65, line: 44, baseType: !39)
!68 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !69, file: !35, line: 164)
!69 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least32_t", file: !65, line: 45, baseType: !43)
!70 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !71, file: !35, line: 165)
!71 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least64_t", file: !65, line: 47, baseType: !15)
!72 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !73, file: !35, line: 167)
!73 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least8_t", file: !65, line: 54, baseType: !51)
!74 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !75, file: !35, line: 168)
!75 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least16_t", file: !65, line: 55, baseType: !55)
!76 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !77, file: !35, line: 169)
!77 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least32_t", file: !65, line: 56, baseType: !59)
!78 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !79, file: !35, line: 170)
!79 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least64_t", file: !65, line: 58, baseType: !19)
!80 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !81, file: !35, line: 172)
!81 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast8_t", file: !65, line: 68, baseType: !34)
!82 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !83, file: !35, line: 173)
!83 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast16_t", file: !65, line: 70, baseType: !15)
!84 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !85, file: !35, line: 174)
!85 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast32_t", file: !65, line: 71, baseType: !15)
!86 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !87, file: !35, line: 175)
!87 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast64_t", file: !65, line: 72, baseType: !15)
!88 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !89, file: !35, line: 177)
!89 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast8_t", file: !65, line: 81, baseType: !51)
!90 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !91, file: !35, line: 178)
!91 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast16_t", file: !65, line: 83, baseType: !19)
!92 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !93, file: !35, line: 179)
!93 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast32_t", file: !65, line: 84, baseType: !19)
!94 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !95, file: !35, line: 180)
!95 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast64_t", file: !65, line: 85, baseType: !19)
!96 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !97, file: !35, line: 182)
!97 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !65, line: 97, baseType: !15)
!98 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !99, file: !35, line: 183)
!99 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !65, line: 100, baseType: !19)
!100 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !101, file: !35, line: 185)
!101 = !DIDerivedType(tag: DW_TAG_typedef, name: "intmax_t", file: !65, line: 111, baseType: !102)
!102 = !DIDerivedType(tag: DW_TAG_typedef, name: "__intmax_t", file: !33, line: 61, baseType: !15)
!103 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !11, entity: !104, file: !35, line: 186)
!104 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintmax_t", file: !65, line: 112, baseType: !105)
!105 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uintmax_t", file: !33, line: 62, baseType: !19)
!106 = !{i32 2, !"Dwarf Version", i32 4}
!107 = !{i32 2, !"Debug Info Version", i32 3}
!108 = !{i32 1, !"wchar_size", i32 4}
!109 = !{!"clang version 9.0.0 (tags/RELEASE_900/final)"}
!110 = distinct !DISubprogram(name: "source", linkageName: "_Z6sourcev", scope: !1, file: !1, line: 9, type: !111, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !113)
!111 = !DISubroutineType(types: !112)
!112 = !{!43}
!113 = !{!114}
!114 = !DILocalVariable(name: "size", scope: !110, file: !1, line: 11, type: !43)
!115 = !DILocation(line: 11, column: 3, scope: !110)
!116 = !DILocation(line: 11, column: 7, scope: !110)
!117 = !DILocation(line: 12, column: 3, scope: !110)
!118 = !DILocation(line: 13, column: 10, scope: !110)
!119 = !{!120, !120, i64 0}
!120 = !{!"int", !121, i64 0}
!121 = !{!"omnipotent char", !122, i64 0}
!122 = !{!"Simple C++ TBAA"}
!123 = !DILocation(line: 14, column: 1, scope: !110)
!124 = !DILocation(line: 13, column: 3, scope: !110)
!125 = distinct !DISubprogram(name: "test_implicit_parameter1", linkageName: "_Z24test_implicit_parameter1v", scope: !1, file: !1, line: 16, type: !111, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !126)
!126 = !{!127, !128, !129}
!127 = !DILocalVariable(name: "size", scope: !125, file: !1, line: 18, type: !43)
!128 = !DILocalVariable(name: "sum", scope: !125, file: !1, line: 18, type: !43)
!129 = !DILocalVariable(name: "i", scope: !130, file: !1, line: 20, type: !43)
!130 = distinct !DILexicalBlock(scope: !125, file: !1, line: 20, column: 3)
!131 = !DILocation(line: 18, column: 3, scope: !125)
!132 = !DILocation(line: 18, column: 7, scope: !125)
!133 = !DILocation(line: 18, column: 13, scope: !125)
!134 = !DILocation(line: 19, column: 3, scope: !125)
!135 = !DILocation(line: 20, column: 7, scope: !130)
!136 = !DILocation(line: 20, column: 11, scope: !130)
!137 = !DILocation(line: 20, column: 18, scope: !138)
!138 = distinct !DILexicalBlock(scope: !130, file: !1, line: 20, column: 3)
!139 = !DILocation(line: 20, column: 22, scope: !138)
!140 = !DILocation(line: 20, column: 20, scope: !138)
!141 = !DILocation(line: 20, column: 3, scope: !130)
!142 = !DILocation(line: 20, column: 3, scope: !138)
!143 = !DILocation(line: 21, column: 12, scope: !138)
!144 = !DILocation(line: 21, column: 9, scope: !138)
!145 = !DILocation(line: 21, column: 5, scope: !138)
!146 = !DILocation(line: 20, column: 28, scope: !138)
!147 = distinct !{!147, !141, !148}
!148 = !DILocation(line: 21, column: 12, scope: !130)
!149 = !DILocation(line: 22, column: 10, scope: !125)
!150 = !DILocation(line: 23, column: 1, scope: !125)
!151 = !DILocation(line: 22, column: 3, scope: !125)
!152 = distinct !DISubprogram(name: "test_implicit_parameter2", linkageName: "_Z24test_implicit_parameter2i", scope: !1, file: !1, line: 25, type: !153, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !155)
!153 = !DISubroutineType(types: !154)
!154 = !{!43, !43}
!155 = !{!156, !157, !158}
!156 = !DILocalVariable(name: "size", arg: 1, scope: !152, file: !1, line: 25, type: !43)
!157 = !DILocalVariable(name: "sum", scope: !152, file: !1, line: 27, type: !43)
!158 = !DILocalVariable(name: "i", scope: !159, file: !1, line: 28, type: !43)
!159 = distinct !DILexicalBlock(scope: !152, file: !1, line: 28, column: 3)
!160 = !DILocation(line: 25, column: 34, scope: !152)
!161 = !DILocation(line: 27, column: 3, scope: !152)
!162 = !DILocation(line: 27, column: 7, scope: !152)
!163 = !DILocation(line: 28, column: 7, scope: !159)
!164 = !DILocation(line: 28, column: 11, scope: !159)
!165 = !DILocation(line: 28, column: 18, scope: !166)
!166 = distinct !DILexicalBlock(scope: !159, file: !1, line: 28, column: 3)
!167 = !DILocation(line: 28, column: 22, scope: !166)
!168 = !DILocation(line: 28, column: 20, scope: !166)
!169 = !DILocation(line: 28, column: 3, scope: !159)
!170 = !DILocation(line: 28, column: 3, scope: !166)
!171 = !DILocation(line: 29, column: 12, scope: !166)
!172 = !DILocation(line: 29, column: 9, scope: !166)
!173 = !DILocation(line: 29, column: 5, scope: !166)
!174 = !DILocation(line: 28, column: 28, scope: !166)
!175 = distinct !{!175, !169, !176}
!176 = !DILocation(line: 29, column: 12, scope: !159)
!177 = !DILocation(line: 30, column: 10, scope: !152)
!178 = !DILocation(line: 31, column: 1, scope: !152)
!179 = !DILocation(line: 30, column: 3, scope: !152)
!180 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 32, type: !181, scopeLine: 33, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !186)
!181 = !DISubroutineType(types: !182)
!182 = !{!43, !43, !183}
!183 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !184, size: 64)
!184 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !185, size: 64)
!185 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!186 = !{!187, !188}
!187 = !DILocalVariable(name: "argc", arg: 1, scope: !180, file: !1, line: 32, type: !43)
!188 = !DILocalVariable(name: "argv", arg: 2, scope: !180, file: !1, line: 32, type: !183)
!189 = !DILocation(line: 32, column: 14, scope: !180)
!190 = !{!191, !191, i64 0}
!191 = !{!"any pointer", !121, i64 0}
!192 = !DILocation(line: 32, column: 28, scope: !180)
!193 = !DILocation(line: 34, column: 3, scope: !180)
!194 = !DILocation(line: 36, column: 3, scope: !180)
!195 = !DILocation(line: 37, column: 28, scope: !180)
!196 = !DILocation(line: 37, column: 3, scope: !180)
!197 = !DILocation(line: 39, column: 3, scope: !180)
!198 = !DILocation(line: 40, column: 3, scope: !180)
