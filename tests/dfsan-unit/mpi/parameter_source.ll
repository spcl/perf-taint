; RUN: opt %mpidfsan -extrap-extractor-out-name=%t4 -S < %s 2> /dev/null | llc %llcparams - -o %t1 && clang++ %link %t1 -o %t2 && %execparams mpiexec -n 2 %t2 && diff -w %s.json %t4_0.json && diff -w %s.json %t4_1.json
; ModuleID = 'tests/dfsan-unit/mpi/parameter_source.cpp'
source_filename = "tests/dfsan-unit/mpi/parameter_source.cpp"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.ompi_predefined_communicator_t = type opaque
%struct.ompi_communicator_t = type opaque

$_Z17register_variableIiEvPT_PKc = comdat any

@ompi_mpi_comm_world = external dso_local global %struct.ompi_predefined_communicator_t, align 1
@.str = private unnamed_addr constant [7 x i8] c"extrap\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [42 x i8] c"tests/dfsan-unit/mpi/parameter_source.cpp\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [6 x i8] c"param\00", align 1

; Function Attrs: uwtable
define dso_local i32 @_Z6sourcev() #0 !dbg !111 {
  %1 = alloca i32, align 4
  %2 = bitcast i32* %1 to i8*, !dbg !116
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %2) #6, !dbg !116
  call void @llvm.dbg.declare(metadata i32* %1, metadata !115, metadata !DIExpression()), !dbg !117
  %3 = call i32 @MPI_Comm_size(%struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*), i32* %1), !dbg !118
  %4 = load i32, i32* %1, align 4, !dbg !119, !tbaa !120
  %5 = bitcast i32* %1 to i8*, !dbg !124
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %5) #6, !dbg !124
  ret i32 %4, !dbg !125
}

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

declare dso_local i32 @MPI_Comm_size(%struct.ompi_communicator_t*, i32*) #3

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: uwtable
define dso_local i32 @_Z24test_implicit_parameter1i(i32) #0 !dbg !126 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store i32 %0, i32* %2, align 4, !tbaa !120
  call void @llvm.dbg.declare(metadata i32* %2, metadata !130, metadata !DIExpression()), !dbg !135
  %6 = bitcast i32* %3 to i8*, !dbg !136
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %6) #6, !dbg !136
  call void @llvm.dbg.declare(metadata i32* %3, metadata !131, metadata !DIExpression()), !dbg !137
  %7 = bitcast i32* %4 to i8*, !dbg !136
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %7) #6, !dbg !136
  call void @llvm.dbg.declare(metadata i32* %4, metadata !132, metadata !DIExpression()), !dbg !138
  %8 = call i32 @MPI_Comm_size(%struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*), i32* %3), !dbg !139
  %9 = bitcast i32* %5 to i8*, !dbg !140
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %9) #6, !dbg !140
  call void @llvm.dbg.declare(metadata i32* %5, metadata !133, metadata !DIExpression()), !dbg !141
  store i32 0, i32* %5, align 4, !dbg !141, !tbaa !120
  br label %10, !dbg !140

10:                                               ; preds = %22, %1
  %11 = load i32, i32* %5, align 4, !dbg !142, !tbaa !120
  %12 = load i32, i32* %3, align 4, !dbg !144, !tbaa !120
  %13 = load i32, i32* %2, align 4, !dbg !145, !tbaa !120
  %14 = add nsw i32 %12, %13, !dbg !146
  %15 = icmp slt i32 %11, %14, !dbg !147
  br i1 %15, label %18, label %16, !dbg !148

16:                                               ; preds = %10
  %17 = bitcast i32* %5 to i8*, !dbg !149
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %17) #6, !dbg !149
  br label %25

18:                                               ; preds = %10
  %19 = load i32, i32* %5, align 4, !dbg !150, !tbaa !120
  %20 = load i32, i32* %4, align 4, !dbg !151, !tbaa !120
  %21 = add nsw i32 %20, %19, !dbg !151
  store i32 %21, i32* %4, align 4, !dbg !151, !tbaa !120
  br label %22, !dbg !152

22:                                               ; preds = %18
  %23 = load i32, i32* %5, align 4, !dbg !153, !tbaa !120
  %24 = add nsw i32 %23, 1, !dbg !153
  store i32 %24, i32* %5, align 4, !dbg !153, !tbaa !120
  br label %10, !dbg !149, !llvm.loop !154

25:                                               ; preds = %16
  %26 = load i32, i32* %4, align 4, !dbg !156, !tbaa !120
  %27 = bitcast i32* %4 to i8*, !dbg !157
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %27) #6, !dbg !157
  %28 = bitcast i32* %3 to i8*, !dbg !157
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %28) #6, !dbg !157
  ret i32 %26, !dbg !158
}

; Function Attrs: nounwind uwtable
define dso_local i32 @_Z24test_implicit_parameter2i(i32) #4 !dbg !159 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, i32* %2, align 4, !tbaa !120
  call void @llvm.dbg.declare(metadata i32* %2, metadata !161, metadata !DIExpression()), !dbg !165
  %5 = bitcast i32* %3 to i8*, !dbg !166
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %5) #6, !dbg !166
  call void @llvm.dbg.declare(metadata i32* %3, metadata !162, metadata !DIExpression()), !dbg !167
  %6 = bitcast i32* %4 to i8*, !dbg !168
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %6) #6, !dbg !168
  call void @llvm.dbg.declare(metadata i32* %4, metadata !163, metadata !DIExpression()), !dbg !169
  store i32 0, i32* %4, align 4, !dbg !169, !tbaa !120
  br label %7, !dbg !168

7:                                                ; preds = %17, %1
  %8 = load i32, i32* %4, align 4, !dbg !170, !tbaa !120
  %9 = load i32, i32* %2, align 4, !dbg !172, !tbaa !120
  %10 = icmp slt i32 %8, %9, !dbg !173
  br i1 %10, label %13, label %11, !dbg !174

11:                                               ; preds = %7
  %12 = bitcast i32* %4 to i8*, !dbg !175
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %12) #6, !dbg !175
  br label %20

13:                                               ; preds = %7
  %14 = load i32, i32* %4, align 4, !dbg !176, !tbaa !120
  %15 = load i32, i32* %3, align 4, !dbg !177, !tbaa !120
  %16 = add nsw i32 %15, %14, !dbg !177
  store i32 %16, i32* %3, align 4, !dbg !177, !tbaa !120
  br label %17, !dbg !178

17:                                               ; preds = %13
  %18 = load i32, i32* %4, align 4, !dbg !179, !tbaa !120
  %19 = add nsw i32 %18, 1, !dbg !179
  store i32 %19, i32* %4, align 4, !dbg !179, !tbaa !120
  br label %7, !dbg !175, !llvm.loop !180

20:                                               ; preds = %11
  %21 = load i32, i32* %3, align 4, !dbg !182, !tbaa !120
  %22 = bitcast i32* %3 to i8*, !dbg !183
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %22) #6, !dbg !183
  ret i32 %21, !dbg !184
}

; Function Attrs: norecurse uwtable
define dso_local i32 @main(i32, i8**) #5 !dbg !185 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  %6 = alloca i32, align 4
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4, !tbaa !120
  call void @llvm.dbg.declare(metadata i32* %4, metadata !192, metadata !DIExpression()), !dbg !195
  store i8** %1, i8*** %5, align 8, !tbaa !196
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !193, metadata !DIExpression()), !dbg !198
  %7 = call i32 @MPI_Init(i32* %4, i8*** %5), !dbg !199
  %8 = bitcast i32* %6 to i8*, !dbg !200
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %8) #6, !dbg !200
  call void @llvm.dbg.declare(metadata i32* %6, metadata !194, metadata !DIExpression()), !dbg !201
  %9 = bitcast i32* %6 to i8*, !dbg !200
  call void @llvm.var.annotation(i8* %9, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([42 x i8], [42 x i8]* @.str.1, i32 0, i32 0), i32 35), !dbg !200
  store i32 3, i32* %6, align 4, !dbg !201, !tbaa !120
  call void @_Z17register_variableIiEvPT_PKc(i32* %6, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.2, i64 0, i64 0)), !dbg !202
  %10 = load i32, i32* %6, align 4, !dbg !203, !tbaa !120
  %11 = call i32 @_Z24test_implicit_parameter1i(i32 %10), !dbg !204
  %12 = call i32 @_Z6sourcev(), !dbg !205
  %13 = call i32 @_Z24test_implicit_parameter2i(i32 %12), !dbg !206
  %14 = call i32 @MPI_Finalize(), !dbg !207
  %15 = bitcast i32* %6 to i8*, !dbg !208
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %15) #6, !dbg !208
  ret i32 0, !dbg !209
}

declare dso_local i32 @MPI_Init(i32*, i8***) #3

; Function Attrs: nounwind
declare void @llvm.var.annotation(i8*, i8*, i8*, i32) #6

; Function Attrs: uwtable
define linkonce_odr dso_local void @_Z17register_variableIiEvPT_PKc(i32*, i8*) #0 comdat !dbg !210 {
  %3 = alloca i32*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca i32, align 4
  store i32* %0, i32** %3, align 8, !tbaa !196
  call void @llvm.dbg.declare(metadata i32** %3, metadata !218, metadata !DIExpression()), !dbg !223
  store i8* %1, i8** %4, align 8, !tbaa !196
  call void @llvm.dbg.declare(metadata i8** %4, metadata !219, metadata !DIExpression()), !dbg !224
  %6 = bitcast i32* %5 to i8*, !dbg !225
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %6) #6, !dbg !225
  call void @llvm.dbg.declare(metadata i32* %5, metadata !220, metadata !DIExpression()), !dbg !226
  %7 = call i32 @__dfsw_EXTRAP_VAR_ID(), !dbg !227
  store i32 %7, i32* %5, align 4, !dbg !226, !tbaa !120
  %8 = load i32*, i32** %3, align 8, !dbg !228, !tbaa !196
  %9 = bitcast i32* %8 to i8*, !dbg !229
  %10 = load i32, i32* %5, align 4, !dbg !230, !tbaa !120
  %11 = add nsw i32 %10, 1, !dbg !230
  store i32 %11, i32* %5, align 4, !dbg !230, !tbaa !120
  %12 = load i8*, i8** %4, align 8, !dbg !231, !tbaa !196
  call void @__dfsw_EXTRAP_STORE_LABEL(i8* %9, i32 4, i32 %10, i8* %12), !dbg !232
  %13 = bitcast i32* %5 to i8*, !dbg !233
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %13) #6, !dbg !233
  ret void, !dbg !233
}

declare dso_local i32 @MPI_Finalize() #3

declare dso_local i32 @__dfsw_EXTRAP_VAR_ID() #3

declare dso_local void @__dfsw_EXTRAP_STORE_LABEL(i8*, i32, i32, i8*) #3

attributes #0 = { uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { argmemonly nounwind }
attributes #2 = { nounwind readnone speculatable }
attributes #3 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { norecurse uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #6 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!107, !108, !109}
!llvm.ident = !{!110}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !1, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !3, imports: !15, nameTableKind: None)
!1 = !DIFile(filename: "tests/dfsan-unit/mpi/parameter_source.cpp", directory: "/home/mcopik/projects/ETH/extrap/rebuild/perf-taint")
!2 = !{}
!3 = !{!4, !8, !9}
!4 = !DIDerivedType(tag: DW_TAG_typedef, name: "MPI_Comm", file: !5, line: 330, baseType: !6)
!5 = !DIFile(filename: "/usr/lib/x86_64-linux-gnu/openmpi/include/mpi.h", directory: "")
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!7 = !DICompositeType(tag: DW_TAG_structure_type, name: "ompi_communicator_t", file: !5, line: 330, flags: DIFlagFwdDecl, identifier: "_ZTS19ompi_communicator_t")
!8 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!9 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !10, size: 64)
!10 = !DIDerivedType(tag: DW_TAG_typedef, name: "int8_t", file: !11, line: 24, baseType: !12)
!11 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-intn.h", directory: "")
!12 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int8_t", file: !13, line: 36, baseType: !14)
!13 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "")
!14 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!15 = !{!16, !23, !26, !30, !35, !37, !41, !45, !48, !53, !57, !61, !64, !67, !69, !71, !73, !75, !77, !79, !81, !83, !85, !87, !89, !91, !93, !95, !97, !99, !101, !104}
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
!35 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !10, file: !36, line: 152)
!36 = !DIFile(filename: "build_tool/../usr/include/c++/v1/cstdint", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!37 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !38, file: !36, line: 153)
!38 = !DIDerivedType(tag: DW_TAG_typedef, name: "int16_t", file: !11, line: 25, baseType: !39)
!39 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int16_t", file: !13, line: 38, baseType: !40)
!40 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!41 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !42, file: !36, line: 154)
!42 = !DIDerivedType(tag: DW_TAG_typedef, name: "int32_t", file: !11, line: 26, baseType: !43)
!43 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int32_t", file: !13, line: 40, baseType: !44)
!44 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!45 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !46, file: !36, line: 155)
!46 = !DIDerivedType(tag: DW_TAG_typedef, name: "int64_t", file: !11, line: 27, baseType: !47)
!47 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int64_t", file: !13, line: 43, baseType: !21)
!48 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !49, file: !36, line: 157)
!49 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint8_t", file: !50, line: 24, baseType: !51)
!50 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "")
!51 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint8_t", file: !13, line: 37, baseType: !52)
!52 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!53 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !54, file: !36, line: 158)
!54 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint16_t", file: !50, line: 25, baseType: !55)
!55 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint16_t", file: !13, line: 39, baseType: !56)
!56 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!57 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !58, file: !36, line: 159)
!58 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !50, line: 26, baseType: !59)
!59 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !13, line: 41, baseType: !60)
!60 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!61 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !62, file: !36, line: 160)
!62 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", file: !50, line: 27, baseType: !63)
!63 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint64_t", file: !13, line: 44, baseType: !25)
!64 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !65, file: !36, line: 162)
!65 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least8_t", file: !66, line: 43, baseType: !14)
!66 = !DIFile(filename: "/usr/include/stdint.h", directory: "")
!67 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !68, file: !36, line: 163)
!68 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least16_t", file: !66, line: 44, baseType: !40)
!69 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !70, file: !36, line: 164)
!70 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least32_t", file: !66, line: 45, baseType: !44)
!71 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !72, file: !36, line: 165)
!72 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least64_t", file: !66, line: 47, baseType: !21)
!73 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !74, file: !36, line: 167)
!74 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least8_t", file: !66, line: 54, baseType: !52)
!75 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !76, file: !36, line: 168)
!76 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least16_t", file: !66, line: 55, baseType: !56)
!77 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !78, file: !36, line: 169)
!78 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least32_t", file: !66, line: 56, baseType: !60)
!79 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !80, file: !36, line: 170)
!80 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least64_t", file: !66, line: 58, baseType: !25)
!81 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !82, file: !36, line: 172)
!82 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast8_t", file: !66, line: 68, baseType: !14)
!83 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !84, file: !36, line: 173)
!84 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast16_t", file: !66, line: 70, baseType: !21)
!85 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !86, file: !36, line: 174)
!86 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast32_t", file: !66, line: 71, baseType: !21)
!87 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !88, file: !36, line: 175)
!88 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast64_t", file: !66, line: 72, baseType: !21)
!89 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !90, file: !36, line: 177)
!90 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast8_t", file: !66, line: 81, baseType: !52)
!91 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !92, file: !36, line: 178)
!92 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast16_t", file: !66, line: 83, baseType: !25)
!93 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !94, file: !36, line: 179)
!94 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast32_t", file: !66, line: 84, baseType: !25)
!95 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !96, file: !36, line: 180)
!96 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast64_t", file: !66, line: 85, baseType: !25)
!97 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !98, file: !36, line: 182)
!98 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !66, line: 97, baseType: !21)
!99 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !100, file: !36, line: 183)
!100 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !66, line: 100, baseType: !25)
!101 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !102, file: !36, line: 185)
!102 = !DIDerivedType(tag: DW_TAG_typedef, name: "intmax_t", file: !66, line: 111, baseType: !103)
!103 = !DIDerivedType(tag: DW_TAG_typedef, name: "__intmax_t", file: !13, line: 61, baseType: !21)
!104 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !17, entity: !105, file: !36, line: 186)
!105 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintmax_t", file: !66, line: 112, baseType: !106)
!106 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uintmax_t", file: !13, line: 62, baseType: !25)
!107 = !{i32 2, !"Dwarf Version", i32 4}
!108 = !{i32 2, !"Debug Info Version", i32 3}
!109 = !{i32 1, !"wchar_size", i32 4}
!110 = !{!"clang version 9.0.0 (tags/RELEASE_900/final)"}
!111 = distinct !DISubprogram(name: "source", linkageName: "_Z6sourcev", scope: !1, file: !1, line: 9, type: !112, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !114)
!112 = !DISubroutineType(types: !113)
!113 = !{!44}
!114 = !{!115}
!115 = !DILocalVariable(name: "size", scope: !111, file: !1, line: 11, type: !44)
!116 = !DILocation(line: 11, column: 3, scope: !111)
!117 = !DILocation(line: 11, column: 7, scope: !111)
!118 = !DILocation(line: 12, column: 3, scope: !111)
!119 = !DILocation(line: 13, column: 10, scope: !111)
!120 = !{!121, !121, i64 0}
!121 = !{!"int", !122, i64 0}
!122 = !{!"omnipotent char", !123, i64 0}
!123 = !{!"Simple C++ TBAA"}
!124 = !DILocation(line: 14, column: 1, scope: !111)
!125 = !DILocation(line: 13, column: 3, scope: !111)
!126 = distinct !DISubprogram(name: "test_implicit_parameter1", linkageName: "_Z24test_implicit_parameter1i", scope: !1, file: !1, line: 16, type: !127, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !129)
!127 = !DISubroutineType(types: !128)
!128 = !{!44, !44}
!129 = !{!130, !131, !132, !133}
!130 = !DILocalVariable(name: "size_x", arg: 1, scope: !126, file: !1, line: 16, type: !44)
!131 = !DILocalVariable(name: "size", scope: !126, file: !1, line: 18, type: !44)
!132 = !DILocalVariable(name: "sum", scope: !126, file: !1, line: 18, type: !44)
!133 = !DILocalVariable(name: "i", scope: !134, file: !1, line: 20, type: !44)
!134 = distinct !DILexicalBlock(scope: !126, file: !1, line: 20, column: 3)
!135 = !DILocation(line: 16, column: 34, scope: !126)
!136 = !DILocation(line: 18, column: 3, scope: !126)
!137 = !DILocation(line: 18, column: 7, scope: !126)
!138 = !DILocation(line: 18, column: 13, scope: !126)
!139 = !DILocation(line: 19, column: 3, scope: !126)
!140 = !DILocation(line: 20, column: 7, scope: !134)
!141 = !DILocation(line: 20, column: 11, scope: !134)
!142 = !DILocation(line: 20, column: 18, scope: !143)
!143 = distinct !DILexicalBlock(scope: !134, file: !1, line: 20, column: 3)
!144 = !DILocation(line: 20, column: 22, scope: !143)
!145 = !DILocation(line: 20, column: 29, scope: !143)
!146 = !DILocation(line: 20, column: 27, scope: !143)
!147 = !DILocation(line: 20, column: 20, scope: !143)
!148 = !DILocation(line: 20, column: 3, scope: !134)
!149 = !DILocation(line: 20, column: 3, scope: !143)
!150 = !DILocation(line: 21, column: 12, scope: !143)
!151 = !DILocation(line: 21, column: 9, scope: !143)
!152 = !DILocation(line: 21, column: 5, scope: !143)
!153 = !DILocation(line: 20, column: 37, scope: !143)
!154 = distinct !{!154, !148, !155}
!155 = !DILocation(line: 21, column: 12, scope: !134)
!156 = !DILocation(line: 22, column: 10, scope: !126)
!157 = !DILocation(line: 23, column: 1, scope: !126)
!158 = !DILocation(line: 22, column: 3, scope: !126)
!159 = distinct !DISubprogram(name: "test_implicit_parameter2", linkageName: "_Z24test_implicit_parameter2i", scope: !1, file: !1, line: 25, type: !127, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !160)
!160 = !{!161, !162, !163}
!161 = !DILocalVariable(name: "size", arg: 1, scope: !159, file: !1, line: 25, type: !44)
!162 = !DILocalVariable(name: "sum", scope: !159, file: !1, line: 27, type: !44)
!163 = !DILocalVariable(name: "i", scope: !164, file: !1, line: 28, type: !44)
!164 = distinct !DILexicalBlock(scope: !159, file: !1, line: 28, column: 3)
!165 = !DILocation(line: 25, column: 34, scope: !159)
!166 = !DILocation(line: 27, column: 3, scope: !159)
!167 = !DILocation(line: 27, column: 7, scope: !159)
!168 = !DILocation(line: 28, column: 7, scope: !164)
!169 = !DILocation(line: 28, column: 11, scope: !164)
!170 = !DILocation(line: 28, column: 18, scope: !171)
!171 = distinct !DILexicalBlock(scope: !164, file: !1, line: 28, column: 3)
!172 = !DILocation(line: 28, column: 22, scope: !171)
!173 = !DILocation(line: 28, column: 20, scope: !171)
!174 = !DILocation(line: 28, column: 3, scope: !164)
!175 = !DILocation(line: 28, column: 3, scope: !171)
!176 = !DILocation(line: 29, column: 12, scope: !171)
!177 = !DILocation(line: 29, column: 9, scope: !171)
!178 = !DILocation(line: 29, column: 5, scope: !171)
!179 = !DILocation(line: 28, column: 28, scope: !171)
!180 = distinct !{!180, !174, !181}
!181 = !DILocation(line: 29, column: 12, scope: !164)
!182 = !DILocation(line: 30, column: 10, scope: !159)
!183 = !DILocation(line: 31, column: 1, scope: !159)
!184 = !DILocation(line: 30, column: 3, scope: !159)
!185 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 32, type: !186, scopeLine: 33, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !191)
!186 = !DISubroutineType(types: !187)
!187 = !{!44, !44, !188}
!188 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !189, size: 64)
!189 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !190, size: 64)
!190 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!191 = !{!192, !193, !194}
!192 = !DILocalVariable(name: "argc", arg: 1, scope: !185, file: !1, line: 32, type: !44)
!193 = !DILocalVariable(name: "argv", arg: 2, scope: !185, file: !1, line: 32, type: !188)
!194 = !DILocalVariable(name: "param", scope: !185, file: !1, line: 35, type: !44)
!195 = !DILocation(line: 32, column: 14, scope: !185)
!196 = !{!197, !197, i64 0}
!197 = !{!"any pointer", !122, i64 0}
!198 = !DILocation(line: 32, column: 28, scope: !185)
!199 = !DILocation(line: 34, column: 3, scope: !185)
!200 = !DILocation(line: 35, column: 3, scope: !185)
!201 = !DILocation(line: 35, column: 7, scope: !185)
!202 = !DILocation(line: 36, column: 3, scope: !185)
!203 = !DILocation(line: 38, column: 28, scope: !185)
!204 = !DILocation(line: 38, column: 3, scope: !185)
!205 = !DILocation(line: 39, column: 28, scope: !185)
!206 = !DILocation(line: 39, column: 3, scope: !185)
!207 = !DILocation(line: 41, column: 3, scope: !185)
!208 = !DILocation(line: 43, column: 1, scope: !185)
!209 = !DILocation(line: 42, column: 3, scope: !185)
!210 = distinct !DISubprogram(name: "register_variable<int>", linkageName: "_Z17register_variableIiEvPT_PKc", scope: !211, file: !211, line: 14, type: !212, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, templateParams: !221, retainedNodes: !217)
!211 = !DIFile(filename: "include/ExtraPInstrumenter.hpp", directory: "/home/mcopik/projects/ETH/extrap/rebuild/perf-taint")
!212 = !DISubroutineType(types: !213)
!213 = !{null, !214, !215}
!214 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !44, size: 64)
!215 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !216, size: 64)
!216 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !190)
!217 = !{!218, !219, !220}
!218 = !DILocalVariable(name: "ptr", arg: 1, scope: !210, file: !211, line: 14, type: !214)
!219 = !DILocalVariable(name: "name", arg: 2, scope: !210, file: !211, line: 14, type: !215)
!220 = !DILocalVariable(name: "param_id", scope: !210, file: !211, line: 16, type: !42)
!221 = !{!222}
!222 = !DITemplateTypeParameter(name: "T", type: !44)
!223 = !DILocation(line: 14, column: 28, scope: !210)
!224 = !DILocation(line: 14, column: 46, scope: !210)
!225 = !DILocation(line: 16, column: 5, scope: !210)
!226 = !DILocation(line: 16, column: 13, scope: !210)
!227 = !DILocation(line: 16, column: 24, scope: !210)
!228 = !DILocation(line: 17, column: 57, scope: !210)
!229 = !DILocation(line: 17, column: 31, scope: !210)
!230 = !DILocation(line: 18, column: 21, scope: !210)
!231 = !DILocation(line: 18, column: 25, scope: !210)
!232 = !DILocation(line: 17, column: 5, scope: !210)
!233 = !DILocation(line: 19, column: 1, scope: !210)
