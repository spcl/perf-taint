; RUN: opt %mpidfsan -extrap-extractor-out-name=%t4 -S < %s 2> /dev/null | llc %llcparams - -o %t1 && clang++ %link %t1 -o %t2 && %execparams mpiexec -n 2 %t2 && diff -w %s.json %t4_0.json && diff -w %s.json %t4_1.json
; ModuleID = 'tests/dfsan-unit/mpi/mpi_wait.cpp'
source_filename = "tests/dfsan-unit/mpi/mpi_wait.cpp"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.ompi_predefined_datatype_t = type opaque
%struct.ompi_predefined_communicator_t = type opaque
%struct.ompi_request_t = type opaque
%struct.ompi_datatype_t = type opaque
%struct.ompi_communicator_t = type opaque
%struct.ompi_status_public_t = type { i32, i32, i32, i32, i64 }

@ompi_mpi_int = external dso_local global %struct.ompi_predefined_datatype_t, align 1
@ompi_mpi_comm_world = external dso_local global %struct.ompi_predefined_communicator_t, align 1

; Function Attrs: uwtable
define dso_local void @_Z7prepareiPiS_PP14ompi_request_tS2_(i32, i32*, i32*, %struct.ompi_request_t**, %struct.ompi_request_t**) #0 !dbg !116 {
  %6 = alloca i32, align 4
  %7 = alloca i32*, align 8
  %8 = alloca i32*, align 8
  %9 = alloca %struct.ompi_request_t**, align 8
  %10 = alloca %struct.ompi_request_t**, align 8
  store i32 %0, i32* %6, align 4, !tbaa !130
  call void @llvm.dbg.declare(metadata i32* %6, metadata !125, metadata !DIExpression()), !dbg !134
  store i32* %1, i32** %7, align 8, !tbaa !135
  call void @llvm.dbg.declare(metadata i32** %7, metadata !126, metadata !DIExpression()), !dbg !137
  store i32* %2, i32** %8, align 8, !tbaa !135
  call void @llvm.dbg.declare(metadata i32** %8, metadata !127, metadata !DIExpression()), !dbg !138
  store %struct.ompi_request_t** %3, %struct.ompi_request_t*** %9, align 8, !tbaa !135
  call void @llvm.dbg.declare(metadata %struct.ompi_request_t*** %9, metadata !128, metadata !DIExpression()), !dbg !139
  store %struct.ompi_request_t** %4, %struct.ompi_request_t*** %10, align 8, !tbaa !135
  call void @llvm.dbg.declare(metadata %struct.ompi_request_t*** %10, metadata !129, metadata !DIExpression()), !dbg !140
  %11 = load i32*, i32** %8, align 8, !dbg !141, !tbaa !135
  %12 = bitcast i32* %11 to i8*, !dbg !141
  %13 = load i32, i32* %6, align 4, !dbg !142, !tbaa !130
  %14 = sub nsw i32 1, %13, !dbg !143
  %15 = load %struct.ompi_request_t**, %struct.ompi_request_t*** %10, align 8, !dbg !144, !tbaa !135
  %16 = call i32 @MPI_Irecv(i8* %12, i32 1, %struct.ompi_datatype_t* bitcast (%struct.ompi_predefined_datatype_t* @ompi_mpi_int to %struct.ompi_datatype_t*), i32 %14, i32 0, %struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*), %struct.ompi_request_t** %15), !dbg !145
  %17 = load i32*, i32** %7, align 8, !dbg !146, !tbaa !135
  %18 = bitcast i32* %17 to i8*, !dbg !146
  %19 = load i32, i32* %6, align 4, !dbg !147, !tbaa !130
  %20 = sub nsw i32 1, %19, !dbg !148
  %21 = load %struct.ompi_request_t**, %struct.ompi_request_t*** %9, align 8, !dbg !149, !tbaa !135
  %22 = call i32 @MPI_Isend(i8* %18, i32 1, %struct.ompi_datatype_t* bitcast (%struct.ompi_predefined_datatype_t* @ompi_mpi_int to %struct.ompi_datatype_t*), i32 %20, i32 0, %struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*), %struct.ompi_request_t** %21), !dbg !150
  ret void, !dbg !151
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare dso_local i32 @MPI_Irecv(i8*, i32, %struct.ompi_datatype_t*, i32, i32, %struct.ompi_communicator_t*, %struct.ompi_request_t**) #2

declare dso_local i32 @MPI_Isend(i8*, i32, %struct.ompi_datatype_t*, i32, i32, %struct.ompi_communicator_t*, %struct.ompi_request_t**) #2

; Function Attrs: uwtable
define dso_local void @_Z4waitP14ompi_request_tS0_(%struct.ompi_request_t*, %struct.ompi_request_t*) #0 !dbg !152 {
  %3 = alloca %struct.ompi_request_t*, align 8
  %4 = alloca %struct.ompi_request_t*, align 8
  store %struct.ompi_request_t* %0, %struct.ompi_request_t** %3, align 8, !tbaa !135
  call void @llvm.dbg.declare(metadata %struct.ompi_request_t** %3, metadata !156, metadata !DIExpression()), !dbg !158
  store %struct.ompi_request_t* %1, %struct.ompi_request_t** %4, align 8, !tbaa !135
  call void @llvm.dbg.declare(metadata %struct.ompi_request_t** %4, metadata !157, metadata !DIExpression()), !dbg !159
  %5 = call i32 @MPI_Wait(%struct.ompi_request_t** %4, %struct.ompi_status_public_t* null), !dbg !160
  %6 = call i32 @MPI_Wait(%struct.ompi_request_t** %3, %struct.ompi_status_public_t* null), !dbg !161
  ret void, !dbg !162
}

declare dso_local i32 @MPI_Wait(%struct.ompi_request_t**, %struct.ompi_status_public_t*) #2

; Function Attrs: norecurse uwtable
define dso_local i32 @main(i32, i8**) #3 !dbg !163 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca %struct.ompi_request_t*, align 8
  %11 = alloca %struct.ompi_request_t*, align 8
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4, !tbaa !130
  call void @llvm.dbg.declare(metadata i32* %4, metadata !170, metadata !DIExpression()), !dbg !178
  store i8** %1, i8*** %5, align 8, !tbaa !135
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !171, metadata !DIExpression()), !dbg !179
  %12 = call i32 @MPI_Init(i32* %4, i8*** %5), !dbg !180
  %13 = bitcast i32* %6 to i8*, !dbg !181
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %13) #5, !dbg !181
  call void @llvm.dbg.declare(metadata i32* %6, metadata !172, metadata !DIExpression()), !dbg !182
  %14 = bitcast i32* %7 to i8*, !dbg !181
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %14) #5, !dbg !181
  call void @llvm.dbg.declare(metadata i32* %7, metadata !173, metadata !DIExpression()), !dbg !183
  %15 = call i32 @MPI_Comm_size(%struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*), i32* %6), !dbg !184
  %16 = call i32 @MPI_Comm_rank(%struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*), i32* %7), !dbg !185
  %17 = bitcast i32* %8 to i8*, !dbg !186
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %17) #5, !dbg !186
  call void @llvm.dbg.declare(metadata i32* %8, metadata !174, metadata !DIExpression()), !dbg !187
  store i32 0, i32* %8, align 4, !dbg !187, !tbaa !130
  %18 = bitcast i32* %9 to i8*, !dbg !186
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %18) #5, !dbg !186
  call void @llvm.dbg.declare(metadata i32* %9, metadata !175, metadata !DIExpression()), !dbg !188
  store i32 1, i32* %9, align 4, !dbg !188, !tbaa !130
  %19 = bitcast %struct.ompi_request_t** %10 to i8*, !dbg !189
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %19) #5, !dbg !189
  call void @llvm.dbg.declare(metadata %struct.ompi_request_t** %10, metadata !176, metadata !DIExpression()), !dbg !190
  %20 = bitcast %struct.ompi_request_t** %11 to i8*, !dbg !189
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %20) #5, !dbg !189
  call void @llvm.dbg.declare(metadata %struct.ompi_request_t** %11, metadata !177, metadata !DIExpression()), !dbg !191
  %21 = load i32, i32* %7, align 4, !dbg !192, !tbaa !130
  call void @_Z7prepareiPiS_PP14ompi_request_tS2_(i32 %21, i32* %9, i32* %8, %struct.ompi_request_t** %10, %struct.ompi_request_t** %11), !dbg !193
  %22 = load %struct.ompi_request_t*, %struct.ompi_request_t** %10, align 8, !dbg !194, !tbaa !135
  %23 = load %struct.ompi_request_t*, %struct.ompi_request_t** %11, align 8, !dbg !195, !tbaa !135
  call void @_Z4waitP14ompi_request_tS0_(%struct.ompi_request_t* %22, %struct.ompi_request_t* %23), !dbg !196
  %24 = call i32 @MPI_Finalize(), !dbg !197
  %25 = bitcast %struct.ompi_request_t** %11 to i8*, !dbg !198
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %25) #5, !dbg !198
  %26 = bitcast %struct.ompi_request_t** %10 to i8*, !dbg !198
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %26) #5, !dbg !198
  %27 = bitcast i32* %9 to i8*, !dbg !198
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %27) #5, !dbg !198
  %28 = bitcast i32* %8 to i8*, !dbg !198
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %28) #5, !dbg !198
  %29 = bitcast i32* %7 to i8*, !dbg !198
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %29) #5, !dbg !198
  %30 = bitcast i32* %6 to i8*, !dbg !198
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %30) #5, !dbg !198
  ret i32 0, !dbg !199
}

declare dso_local i32 @MPI_Init(i32*, i8***) #2

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #4

declare dso_local i32 @MPI_Comm_size(%struct.ompi_communicator_t*, i32*) #2

declare dso_local i32 @MPI_Comm_rank(%struct.ompi_communicator_t*, i32*) #2

declare dso_local i32 @MPI_Finalize() #2

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #4

attributes #0 = { uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { norecurse uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { argmemonly nounwind }
attributes #5 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!112, !113, !114}
!llvm.ident = !{!115}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !1, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !3, imports: !15, nameTableKind: None)
!1 = !DIFile(filename: "tests/dfsan-unit/mpi/mpi_wait.cpp", directory: "/home/mcopik/projects/ETH/extrap/rebuild/perf-taint")
!2 = !{}
!3 = !{!4, !8, !9, !12}
!4 = !DIDerivedType(tag: DW_TAG_typedef, name: "MPI_Datatype", file: !5, line: 331, baseType: !6)
!5 = !DIFile(filename: "/usr/lib/x86_64-linux-gnu/openmpi/include/mpi.h", directory: "")
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!7 = !DICompositeType(tag: DW_TAG_structure_type, name: "ompi_datatype_t", file: !5, line: 331, flags: DIFlagFwdDecl, identifier: "_ZTS15ompi_datatype_t")
!8 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!9 = !DIDerivedType(tag: DW_TAG_typedef, name: "MPI_Comm", file: !5, line: 330, baseType: !10)
!10 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !11, size: 64)
!11 = !DICompositeType(tag: DW_TAG_structure_type, name: "ompi_communicator_t", file: !5, line: 330, flags: DIFlagFwdDecl, identifier: "_ZTS19ompi_communicator_t")
!12 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !13, size: 64)
!13 = !DIDerivedType(tag: DW_TAG_typedef, name: "MPI_Status", file: !5, line: 341, baseType: !14)
!14 = !DICompositeType(tag: DW_TAG_structure_type, name: "ompi_status_public_t", file: !5, line: 351, flags: DIFlagFwdDecl, identifier: "_ZTS20ompi_status_public_t")
!15 = !{!16, !23, !26, !30, !35, !42, !46, !50, !53, !58, !62, !66, !69, !72, !74, !76, !78, !80, !82, !84, !86, !88, !90, !92, !94, !96, !98, !100, !102, !104, !106, !109}
!16 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !19, file: !22, line: 49)
!17 = !DINamespace(name: "__1", scope: !18, exportSymbols: true)
!18 = !DINamespace(name: "std", scope: null)
!19 = !DIDerivedType(tag: DW_TAG_typedef, name: "ptrdiff_t", file: !20, line: 35, baseType: !21)
!20 = !DIFile(filename: "clang_llvm/llvm-9.0/build-9.0/lib/clang/9.0.0/include/stddef.h", directory: "/home/mcopik/projects")
!21 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!22 = !DIFile(filename: "build_tool/../usr/include/c++/v1/cstddef", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!23 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !24, file: !22, line: 50)
!24 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !20, line: 46, baseType: !25)
!25 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!26 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !27, file: !22, line: 55)
!27 = !DIDerivedType(tag: DW_TAG_typedef, name: "max_align_t", file: !28, line: 24, baseType: !29)
!28 = !DIFile(filename: "clang_llvm/llvm-9.0/build-9.0/lib/clang/9.0.0/include/__stddef_max_align_t.h", directory: "/home/mcopik/projects")
!29 = !DICompositeType(tag: DW_TAG_structure_type, file: !28, line: 19, flags: DIFlagFwdDecl, identifier: "_ZTS11max_align_t")
!30 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !31, file: !34, line: 51)
!31 = !DIDerivedType(tag: DW_TAG_typedef, name: "nullptr_t", scope: !18, file: !32, line: 56, baseType: !33)
!32 = !DIFile(filename: "build_tool/../usr/include/c++/v1/__nullptr", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!33 = !DIBasicType(tag: DW_TAG_unspecified_type, name: "decltype(nullptr)")
!34 = !DIFile(filename: "build_tool/../usr/include/c++/v1/stddef.h", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!35 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !36, file: !41, line: 152)
!36 = !DIDerivedType(tag: DW_TAG_typedef, name: "int8_t", file: !37, line: 24, baseType: !38)
!37 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-intn.h", directory: "")
!38 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int8_t", file: !39, line: 36, baseType: !40)
!39 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "")
!40 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!41 = !DIFile(filename: "build_tool/../usr/include/c++/v1/cstdint", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!42 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !43, file: !41, line: 153)
!43 = !DIDerivedType(tag: DW_TAG_typedef, name: "int16_t", file: !37, line: 25, baseType: !44)
!44 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int16_t", file: !39, line: 38, baseType: !45)
!45 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!46 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !47, file: !41, line: 154)
!47 = !DIDerivedType(tag: DW_TAG_typedef, name: "int32_t", file: !37, line: 26, baseType: !48)
!48 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int32_t", file: !39, line: 40, baseType: !49)
!49 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!50 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !51, file: !41, line: 155)
!51 = !DIDerivedType(tag: DW_TAG_typedef, name: "int64_t", file: !37, line: 27, baseType: !52)
!52 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int64_t", file: !39, line: 43, baseType: !21)
!53 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !54, file: !41, line: 157)
!54 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint8_t", file: !55, line: 24, baseType: !56)
!55 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "")
!56 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint8_t", file: !39, line: 37, baseType: !57)
!57 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!58 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !59, file: !41, line: 158)
!59 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint16_t", file: !55, line: 25, baseType: !60)
!60 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint16_t", file: !39, line: 39, baseType: !61)
!61 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!62 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !63, file: !41, line: 159)
!63 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !55, line: 26, baseType: !64)
!64 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !39, line: 41, baseType: !65)
!65 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!66 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !67, file: !41, line: 160)
!67 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", file: !55, line: 27, baseType: !68)
!68 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint64_t", file: !39, line: 44, baseType: !25)
!69 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !70, file: !41, line: 162)
!70 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least8_t", file: !71, line: 43, baseType: !40)
!71 = !DIFile(filename: "/usr/include/stdint.h", directory: "")
!72 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !73, file: !41, line: 163)
!73 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least16_t", file: !71, line: 44, baseType: !45)
!74 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !75, file: !41, line: 164)
!75 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least32_t", file: !71, line: 45, baseType: !49)
!76 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !77, file: !41, line: 165)
!77 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least64_t", file: !71, line: 47, baseType: !21)
!78 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !79, file: !41, line: 167)
!79 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least8_t", file: !71, line: 54, baseType: !57)
!80 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !81, file: !41, line: 168)
!81 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least16_t", file: !71, line: 55, baseType: !61)
!82 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !83, file: !41, line: 169)
!83 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least32_t", file: !71, line: 56, baseType: !65)
!84 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !85, file: !41, line: 170)
!85 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least64_t", file: !71, line: 58, baseType: !25)
!86 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !87, file: !41, line: 172)
!87 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast8_t", file: !71, line: 68, baseType: !40)
!88 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !89, file: !41, line: 173)
!89 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast16_t", file: !71, line: 70, baseType: !21)
!90 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !91, file: !41, line: 174)
!91 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast32_t", file: !71, line: 71, baseType: !21)
!92 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !93, file: !41, line: 175)
!93 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast64_t", file: !71, line: 72, baseType: !21)
!94 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !95, file: !41, line: 177)
!95 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast8_t", file: !71, line: 81, baseType: !57)
!96 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !97, file: !41, line: 178)
!97 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast16_t", file: !71, line: 83, baseType: !25)
!98 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !99, file: !41, line: 179)
!99 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast32_t", file: !71, line: 84, baseType: !25)
!100 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !101, file: !41, line: 180)
!101 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast64_t", file: !71, line: 85, baseType: !25)
!102 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !103, file: !41, line: 182)
!103 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !71, line: 97, baseType: !21)
!104 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !105, file: !41, line: 183)
!105 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !71, line: 100, baseType: !25)
!106 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !107, file: !41, line: 185)
!107 = !DIDerivedType(tag: DW_TAG_typedef, name: "intmax_t", file: !71, line: 111, baseType: !108)
!108 = !DIDerivedType(tag: DW_TAG_typedef, name: "__intmax_t", file: !39, line: 61, baseType: !21)
!109 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !110, file: !41, line: 186)
!110 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintmax_t", file: !71, line: 112, baseType: !111)
!111 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uintmax_t", file: !39, line: 62, baseType: !25)
!112 = !{i32 2, !"Dwarf Version", i32 4}
!113 = !{i32 2, !"Debug Info Version", i32 3}
!114 = !{i32 1, !"wchar_size", i32 4}
!115 = !{!"clang version 9.0.0 (tags/RELEASE_900/final)"}
!116 = distinct !DISubprogram(name: "prepare", linkageName: "_Z7prepareiPiS_PP14ompi_request_tS2_", scope: !1, file: !1, line: 9, type: !117, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !124)
!117 = !DISubroutineType(types: !118)
!118 = !{null, !49, !119, !119, !120, !120}
!119 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !49, size: 64)
!120 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !121, size: 64)
!121 = !DIDerivedType(tag: DW_TAG_typedef, name: "MPI_Request", file: !5, line: 339, baseType: !122)
!122 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !123, size: 64)
!123 = !DICompositeType(tag: DW_TAG_structure_type, name: "ompi_request_t", file: !5, line: 339, flags: DIFlagFwdDecl, identifier: "_ZTS14ompi_request_t")
!124 = !{!125, !126, !127, !128, !129}
!125 = !DILocalVariable(name: "rank", arg: 1, scope: !116, file: !1, line: 9, type: !49)
!126 = !DILocalVariable(name: "send_value", arg: 2, scope: !116, file: !1, line: 9, type: !119)
!127 = !DILocalVariable(name: "rcv_value", arg: 3, scope: !116, file: !1, line: 9, type: !119)
!128 = !DILocalVariable(name: "send", arg: 4, scope: !116, file: !1, line: 9, type: !120)
!129 = !DILocalVariable(name: "rcv", arg: 5, scope: !116, file: !1, line: 9, type: !120)
!130 = !{!131, !131, i64 0}
!131 = !{!"int", !132, i64 0}
!132 = !{!"omnipotent char", !133, i64 0}
!133 = !{!"Simple C++ TBAA"}
!134 = !DILocation(line: 9, column: 18, scope: !116)
!135 = !{!136, !136, i64 0}
!136 = !{!"any pointer", !132, i64 0}
!137 = !DILocation(line: 9, column: 30, scope: !116)
!138 = !DILocation(line: 9, column: 48, scope: !116)
!139 = !DILocation(line: 9, column: 73, scope: !116)
!140 = !DILocation(line: 9, column: 93, scope: !116)
!141 = !DILocation(line: 11, column: 13, scope: !116)
!142 = !DILocation(line: 11, column: 40, scope: !116)
!143 = !DILocation(line: 11, column: 38, scope: !116)
!144 = !DILocation(line: 11, column: 65, scope: !116)
!145 = !DILocation(line: 11, column: 3, scope: !116)
!146 = !DILocation(line: 12, column: 13, scope: !116)
!147 = !DILocation(line: 12, column: 41, scope: !116)
!148 = !DILocation(line: 12, column: 39, scope: !116)
!149 = !DILocation(line: 12, column: 66, scope: !116)
!150 = !DILocation(line: 12, column: 3, scope: !116)
!151 = !DILocation(line: 13, column: 1, scope: !116)
!152 = distinct !DISubprogram(name: "wait", linkageName: "_Z4waitP14ompi_request_tS0_", scope: !1, file: !1, line: 15, type: !153, scopeLine: 16, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !155)
!153 = !DISubroutineType(types: !154)
!154 = !{null, !121, !121}
!155 = !{!156, !157}
!156 = !DILocalVariable(name: "send", arg: 1, scope: !152, file: !1, line: 15, type: !121)
!157 = !DILocalVariable(name: "rcv", arg: 2, scope: !152, file: !1, line: 15, type: !121)
!158 = !DILocation(line: 15, column: 23, scope: !152)
!159 = !DILocation(line: 15, column: 41, scope: !152)
!160 = !DILocation(line: 17, column: 3, scope: !152)
!161 = !DILocation(line: 18, column: 3, scope: !152)
!162 = !DILocation(line: 19, column: 1, scope: !152)
!163 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 21, type: !164, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !169)
!164 = !DISubroutineType(types: !165)
!165 = !{!49, !49, !166}
!166 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !167, size: 64)
!167 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !168, size: 64)
!168 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!169 = !{!170, !171, !172, !173, !174, !175, !176, !177}
!170 = !DILocalVariable(name: "argc", arg: 1, scope: !163, file: !1, line: 21, type: !49)
!171 = !DILocalVariable(name: "argv", arg: 2, scope: !163, file: !1, line: 21, type: !166)
!172 = !DILocalVariable(name: "ranks", scope: !163, file: !1, line: 24, type: !49)
!173 = !DILocalVariable(name: "rank_id", scope: !163, file: !1, line: 24, type: !49)
!174 = !DILocalVariable(name: "rcv_val", scope: !163, file: !1, line: 28, type: !49)
!175 = !DILocalVariable(name: "send_val", scope: !163, file: !1, line: 28, type: !49)
!176 = !DILocalVariable(name: "send", scope: !163, file: !1, line: 29, type: !121)
!177 = !DILocalVariable(name: "rcv", scope: !163, file: !1, line: 29, type: !121)
!178 = !DILocation(line: 21, column: 14, scope: !163)
!179 = !DILocation(line: 21, column: 28, scope: !163)
!180 = !DILocation(line: 23, column: 3, scope: !163)
!181 = !DILocation(line: 24, column: 3, scope: !163)
!182 = !DILocation(line: 24, column: 7, scope: !163)
!183 = !DILocation(line: 24, column: 14, scope: !163)
!184 = !DILocation(line: 25, column: 3, scope: !163)
!185 = !DILocation(line: 26, column: 3, scope: !163)
!186 = !DILocation(line: 28, column: 3, scope: !163)
!187 = !DILocation(line: 28, column: 7, scope: !163)
!188 = !DILocation(line: 28, column: 20, scope: !163)
!189 = !DILocation(line: 29, column: 3, scope: !163)
!190 = !DILocation(line: 29, column: 15, scope: !163)
!191 = !DILocation(line: 29, column: 21, scope: !163)
!192 = !DILocation(line: 30, column: 11, scope: !163)
!193 = !DILocation(line: 30, column: 3, scope: !163)
!194 = !DILocation(line: 31, column: 8, scope: !163)
!195 = !DILocation(line: 31, column: 14, scope: !163)
!196 = !DILocation(line: 31, column: 3, scope: !163)
!197 = !DILocation(line: 33, column: 3, scope: !163)
!198 = !DILocation(line: 35, column: 1, scope: !163)
!199 = !DILocation(line: 34, column: 3, scope: !163)
