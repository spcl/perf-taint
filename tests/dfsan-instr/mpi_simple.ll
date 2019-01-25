; RUN: opt %dfsan -extrap-extractor-out-name=%s -S < %s 2> /dev/null | llc %llcparams - -o %t1 && clang++ %link %t1 -o %t2 && %execparams mpiexec -n 2 %t2 10 10 10 && diff -w %s.json %s_0.json && diff -w %s.json %s_1.json

; ModuleID = 'tests/dfsan-instr/mpi_simple.cpp'
source_filename = "tests/dfsan-instr/mpi_simple.cpp"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.ompi_predefined_datatype_t = type opaque
%struct.ompi_predefined_op_t = type opaque
%struct.ompi_predefined_communicator_t = type opaque
%struct.ompi_datatype_t = type opaque
%struct.ompi_op_t = type opaque
%struct.ompi_communicator_t = type opaque

$_Z17register_variableIiEvPT_PKc = comdat any

@ompi_mpi_double = external dso_local global %struct.ompi_predefined_datatype_t, align 1
@ompi_mpi_op_sum = external dso_local global %struct.ompi_predefined_op_t, align 1
@ompi_mpi_comm_world = external dso_local global %struct.ompi_predefined_communicator_t, align 1
@.str = private unnamed_addr constant [7 x i8] c"extrap\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [33 x i8] c"tests/dfsan-instr/mpi_simple.cpp\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [5 x i8] c"size\00", align 1
@.str.3 = private unnamed_addr constant [6 x i8] c"ranks\00", align 1
@.str.4 = private unnamed_addr constant [4 x i8] c"%f\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @_Z1fPdm(double*, i64) #0 !dbg !109 {
  %3 = alloca double*, align 8
  %4 = alloca i64, align 8
  store double* %0, double** %3, align 8
  call void @llvm.dbg.declare(metadata double** %3, metadata !114, metadata !DIExpression()), !dbg !115
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !116, metadata !DIExpression()), !dbg !117
  br label %5, !dbg !118

; <label>:5:                                      ; preds = %9, %2
  %6 = load i64, i64* %4, align 8, !dbg !119
  %7 = add i64 %6, -1, !dbg !119
  store i64 %7, i64* %4, align 8, !dbg !119
  %8 = icmp ne i64 %6, 0, !dbg !120
  br i1 %8, label %9, label %15, !dbg !118

; <label>:9:                                      ; preds = %5
  %10 = load double*, double** %3, align 8, !dbg !121
  %11 = load double, double* %10, align 8, !dbg !123
  %12 = fadd double %11, 2.000000e+00, !dbg !123
  store double %12, double* %10, align 8, !dbg !123
  %13 = load double*, double** %3, align 8, !dbg !124
  %14 = getelementptr inbounds double, double* %13, i32 1, !dbg !124
  store double* %14, double** %3, align 8, !dbg !124
  br label %5, !dbg !118, !llvm.loop !125

; <label>:15:                                     ; preds = %5
  ret void, !dbg !127
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline optnone uwtable
define dso_local double @_Z1hPd(double*) #2 !dbg !128 {
  %2 = alloca double*, align 8
  %3 = alloca double, align 8
  store double* %0, double** %2, align 8
  call void @llvm.dbg.declare(metadata double** %2, metadata !131, metadata !DIExpression()), !dbg !132
  call void @llvm.dbg.declare(metadata double* %3, metadata !133, metadata !DIExpression()), !dbg !134
  %4 = load double*, double** %2, align 8, !dbg !135
  %5 = getelementptr inbounds double, double* %4, i64 0, !dbg !135
  %6 = load double, double* %5, align 8, !dbg !135
  store double %6, double* %3, align 8, !dbg !134
  %7 = load double*, double** %2, align 8, !dbg !136
  %8 = bitcast double* %7 to i8*, !dbg !136
  %9 = bitcast double* %3 to i8*, !dbg !137
  %10 = call i32 @MPI_Reduce(i8* %8, i8* %9, i32 1, %struct.ompi_datatype_t* bitcast (%struct.ompi_predefined_datatype_t* @ompi_mpi_double to %struct.ompi_datatype_t*), %struct.ompi_op_t* bitcast (%struct.ompi_predefined_op_t* @ompi_mpi_op_sum to %struct.ompi_op_t*), i32 0, %struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*)), !dbg !138
  %11 = load double, double* %3, align 8, !dbg !139
  ret double %11, !dbg !140
}

declare dso_local i32 @MPI_Reduce(i8*, i8*, i32, %struct.ompi_datatype_t*, %struct.ompi_op_t*, i32, %struct.ompi_communicator_t*) #3

; Function Attrs: noinline optnone uwtable
define dso_local void @_Z8h_nestedPdm(double*, i64) #2 !dbg !141 {
  %3 = alloca double*, align 8
  %4 = alloca i64, align 8
  %5 = alloca i32, align 4
  store double* %0, double** %3, align 8
  call void @llvm.dbg.declare(metadata double** %3, metadata !142, metadata !DIExpression()), !dbg !143
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !144, metadata !DIExpression()), !dbg !145
  call void @llvm.dbg.declare(metadata i32* %5, metadata !146, metadata !DIExpression()), !dbg !148
  store i32 0, i32* %5, align 4, !dbg !148
  br label %6, !dbg !149

; <label>:6:                                      ; preds = %17, %2
  %7 = load i32, i32* %5, align 4, !dbg !150
  %8 = sext i32 %7 to i64, !dbg !150
  %9 = load i64, i64* %4, align 8, !dbg !152
  %10 = icmp ult i64 %8, %9, !dbg !153
  br i1 %10, label %11, label %20, !dbg !154

; <label>:11:                                     ; preds = %6
  %12 = load double*, double** %3, align 8, !dbg !155
  %13 = load i32, i32* %5, align 4, !dbg !157
  %14 = sext i32 %13 to i64, !dbg !155
  %15 = getelementptr inbounds double, double* %12, i64 %14, !dbg !155
  %16 = call double @_Z1hPd(double* %15), !dbg !158
  br label %17, !dbg !159

; <label>:17:                                     ; preds = %11
  %18 = load i32, i32* %5, align 4, !dbg !160
  %19 = add nsw i32 %18, 1, !dbg !160
  store i32 %19, i32* %5, align 4, !dbg !160
  br label %6, !dbg !161, !llvm.loop !162

; <label>:20:                                     ; preds = %6
  ret void, !dbg !164
}

; Function Attrs: noinline norecurse optnone uwtable
define dso_local i32 @main(i32, i8**) #4 !dbg !165 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca double*, align 8
  %11 = alloca double, align 8
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !171, metadata !DIExpression()), !dbg !172
  store i8** %1, i8*** %5, align 8
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !173, metadata !DIExpression()), !dbg !174
  %12 = call i32 @MPI_Init(i32* %4, i8*** %5), !dbg !175
  call void @llvm.dbg.declare(metadata i32* %6, metadata !176, metadata !DIExpression()), !dbg !177
  %13 = bitcast i32* %6 to i8*, !dbg !178
  call void @llvm.var.annotation(i8* %13, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([33 x i8], [33 x i8]* @.str.1, i32 0, i32 0), i32 34), !dbg !178
  %14 = load i8**, i8*** %5, align 8, !dbg !179
  %15 = getelementptr inbounds i8*, i8** %14, i64 1, !dbg !179
  %16 = load i8*, i8** %15, align 8, !dbg !179
  %17 = call i32 @atoi(i8* %16) #8, !dbg !180
  store i32 %17, i32* %6, align 4, !dbg !177
  call void @_Z17register_variableIiEvPT_PKc(i32* %6, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.2, i32 0, i32 0)), !dbg !181
  call void @llvm.dbg.declare(metadata i32* %7, metadata !182, metadata !DIExpression()), !dbg !183
  %18 = bitcast i32* %7 to i8*, !dbg !184
  call void @llvm.var.annotation(i8* %18, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([33 x i8], [33 x i8]* @.str.1, i32 0, i32 0), i32 36), !dbg !184
  store i32 1, i32* %7, align 4, !dbg !183
  call void @llvm.dbg.declare(metadata i32* %8, metadata !185, metadata !DIExpression()), !dbg !186
  %19 = call i32 @MPI_Comm_size(%struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*), i32* %7), !dbg !187
  %20 = call i32 @MPI_Comm_rank(%struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*), i32* %8), !dbg !188
  call void @_Z17register_variableIiEvPT_PKc(i32* %7, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.3, i32 0, i32 0)), !dbg !189
  %21 = load i32, i32* %7, align 4, !dbg !190
  %22 = load i32, i32* %6, align 4, !dbg !191
  %23 = sdiv i32 %22, %21, !dbg !191
  store i32 %23, i32* %6, align 4, !dbg !191
  call void @llvm.dbg.declare(metadata i32* %9, metadata !192, metadata !DIExpression()), !dbg !193
  %24 = load i32, i32* %6, align 4, !dbg !194
  %25 = load i32, i32* %8, align 4, !dbg !195
  %26 = mul nsw i32 %24, %25, !dbg !196
  store i32 %26, i32* %9, align 4, !dbg !193
  call void @llvm.dbg.declare(metadata double** %10, metadata !197, metadata !DIExpression()), !dbg !198
  %27 = load i32, i32* %6, align 4, !dbg !199
  %28 = sext i32 %27 to i64, !dbg !199
  %29 = call noalias i8* @calloc(i64 %28, i64 8) #5, !dbg !200
  %30 = bitcast i8* %29 to double*, !dbg !201
  store double* %30, double** %10, align 8, !dbg !198
  %31 = load double*, double** %10, align 8, !dbg !202
  %32 = load i32, i32* %6, align 4, !dbg !203
  %33 = sext i32 %32 to i64, !dbg !203
  call void @_Z1fPdm(double* %31, i64 %33), !dbg !204
  call void @llvm.dbg.declare(metadata double* %11, metadata !205, metadata !DIExpression()), !dbg !206
  %34 = load double*, double** %10, align 8, !dbg !207
  %35 = call double @_Z1hPd(double* %34), !dbg !208
  store double %35, double* %11, align 8, !dbg !206
  %36 = load i32, i32* %8, align 4, !dbg !209
  %37 = icmp eq i32 %36, 0, !dbg !211
  br i1 %37, label %38, label %41, !dbg !212

; <label>:38:                                     ; preds = %2
  %39 = load double, double* %11, align 8, !dbg !213
  %40 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i32 0, i32 0), double %39), !dbg !214
  br label %41, !dbg !214

; <label>:41:                                     ; preds = %38, %2
  %42 = load double*, double** %10, align 8, !dbg !215
  %43 = bitcast double* %42 to i8*, !dbg !215
  call void @free(i8* %43) #5, !dbg !216
  %44 = call i32 @MPI_Finalize(), !dbg !217
  ret i32 0, !dbg !218
}

declare dso_local i32 @MPI_Init(i32*, i8***) #3

; Function Attrs: nounwind
declare void @llvm.var.annotation(i8*, i8*, i8*, i32) #5

; Function Attrs: nounwind readonly
declare dso_local i32 @atoi(i8*) #6

; Function Attrs: noinline optnone uwtable
define linkonce_odr dso_local void @_Z17register_variableIiEvPT_PKc(i32*, i8*) #2 comdat !dbg !219 {
  %3 = alloca i32*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca i32, align 4
  store i32* %0, i32** %3, align 8
  call void @llvm.dbg.declare(metadata i32** %3, metadata !228, metadata !DIExpression()), !dbg !229
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !230, metadata !DIExpression()), !dbg !231
  call void @llvm.dbg.declare(metadata i32* %5, metadata !232, metadata !DIExpression()), !dbg !233
  %6 = call i32 @__dfsw_EXTRAP_VAR_ID(), !dbg !234
  store i32 %6, i32* %5, align 4, !dbg !233
  %7 = load i32*, i32** %3, align 8, !dbg !235
  %8 = bitcast i32* %7 to i8*, !dbg !236
  %9 = load i32, i32* %5, align 4, !dbg !237
  %10 = add nsw i32 %9, 1, !dbg !237
  store i32 %10, i32* %5, align 4, !dbg !237
  %11 = load i8*, i8** %4, align 8, !dbg !238
  call void @__dfsw_EXTRAP_STORE_LABEL(i8* %8, i32 4, i32 %9, i8* %11), !dbg !239
  ret void, !dbg !240
}

declare dso_local i32 @MPI_Comm_size(%struct.ompi_communicator_t*, i32*) #3

declare dso_local i32 @MPI_Comm_rank(%struct.ompi_communicator_t*, i32*) #3

; Function Attrs: nounwind
declare dso_local noalias i8* @calloc(i64, i64) #7

declare dso_local i32 @printf(i8*, ...) #3

; Function Attrs: nounwind
declare dso_local void @free(i8*) #7

declare dso_local i32 @MPI_Finalize() #3

declare dso_local i32 @__dfsw_EXTRAP_VAR_ID() #3

declare dso_local void @__dfsw_EXTRAP_STORE_LABEL(i8*, i32, i32, i8*) #3

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { noinline optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { noinline norecurse optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { nounwind }
attributes #6 = { nounwind readonly "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #7 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #8 = { nounwind readonly }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!105, !106, !107}
!llvm.ident = !{!108}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !1, producer: "clang version 8.0.0 (git@github.com:llvm-mirror/clang.git fd01d8b9288b3558a597daeb0cb4481b37c5bf68) (git@github.com:llvm-mirror/LLVM.git 7135d8b482d3d0d1a8c50111eebb9b207e92a8bc)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !3, imports: !23, nameTableKind: None)
!1 = !DIFile(filename: "tests/dfsan-instr/mpi_simple.cpp", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!2 = !{}
!3 = !{!4, !8, !9, !12, !15, !17}
!4 = !DIDerivedType(tag: DW_TAG_typedef, name: "MPI_Datatype", file: !5, line: 331, baseType: !6)
!5 = !DIFile(filename: "/usr/lib/x86_64-linux-gnu/openmpi/include/mpi.h", directory: "")
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!7 = !DICompositeType(tag: DW_TAG_structure_type, name: "ompi_datatype_t", file: !5, line: 331, flags: DIFlagFwdDecl, identifier: "_ZTS15ompi_datatype_t")
!8 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!9 = !DIDerivedType(tag: DW_TAG_typedef, name: "MPI_Op", file: !5, line: 338, baseType: !10)
!10 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !11, size: 64)
!11 = !DICompositeType(tag: DW_TAG_structure_type, name: "ompi_op_t", file: !5, line: 338, flags: DIFlagFwdDecl, identifier: "_ZTS9ompi_op_t")
!12 = !DIDerivedType(tag: DW_TAG_typedef, name: "MPI_Comm", file: !5, line: 330, baseType: !13)
!13 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !14, size: 64)
!14 = !DICompositeType(tag: DW_TAG_structure_type, name: "ompi_communicator_t", file: !5, line: 330, flags: DIFlagFwdDecl, identifier: "_ZTS19ompi_communicator_t")
!15 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !16, size: 64)
!16 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!17 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !18, size: 64)
!18 = !DIDerivedType(tag: DW_TAG_typedef, name: "int8_t", file: !19, line: 24, baseType: !20)
!19 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-intn.h", directory: "")
!20 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int8_t", file: !21, line: 36, baseType: !22)
!21 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "")
!22 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!23 = !{!24, !30, !33, !37, !41, !45, !50, !54, !58, !62, !65, !67, !69, !71, !73, !75, !77, !79, !81, !83, !85, !87, !89, !91, !93, !95, !97, !99, !102}
!24 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !25, file: !29, line: 52)
!25 = !DIDerivedType(tag: DW_TAG_typedef, name: "nullptr_t", scope: !27, file: !26, line: 57, baseType: !28)
!26 = !DIFile(filename: "clang_llvm/build_dfsan_full/include/c++/v1/__nullptr", directory: "/home/mcopik/projects")
!27 = !DINamespace(name: "std", scope: null)
!28 = !DIBasicType(tag: DW_TAG_unspecified_type, name: "decltype(nullptr)")
!29 = !DIFile(filename: "clang_llvm/build_dfsan_full/include/c++/v1/stddef.h", directory: "/home/mcopik/projects")
!30 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !18, file: !32, line: 153)
!31 = !DINamespace(name: "__1", scope: !27, exportSymbols: true)
!32 = !DIFile(filename: "clang_llvm/build_dfsan_full/include/c++/v1/cstdint", directory: "/home/mcopik/projects")
!33 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !34, file: !32, line: 154)
!34 = !DIDerivedType(tag: DW_TAG_typedef, name: "int16_t", file: !19, line: 25, baseType: !35)
!35 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int16_t", file: !21, line: 38, baseType: !36)
!36 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!37 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !38, file: !32, line: 155)
!38 = !DIDerivedType(tag: DW_TAG_typedef, name: "int32_t", file: !19, line: 26, baseType: !39)
!39 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int32_t", file: !21, line: 40, baseType: !40)
!40 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!41 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !42, file: !32, line: 156)
!42 = !DIDerivedType(tag: DW_TAG_typedef, name: "int64_t", file: !19, line: 27, baseType: !43)
!43 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int64_t", file: !21, line: 43, baseType: !44)
!44 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!45 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !46, file: !32, line: 158)
!46 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint8_t", file: !47, line: 24, baseType: !48)
!47 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "")
!48 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint8_t", file: !21, line: 37, baseType: !49)
!49 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!50 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !51, file: !32, line: 159)
!51 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint16_t", file: !47, line: 25, baseType: !52)
!52 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint16_t", file: !21, line: 39, baseType: !53)
!53 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!54 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !55, file: !32, line: 160)
!55 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !47, line: 26, baseType: !56)
!56 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !21, line: 41, baseType: !57)
!57 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!58 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !59, file: !32, line: 161)
!59 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", file: !47, line: 27, baseType: !60)
!60 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint64_t", file: !21, line: 44, baseType: !61)
!61 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!62 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !63, file: !32, line: 163)
!63 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least8_t", file: !64, line: 43, baseType: !22)
!64 = !DIFile(filename: "/usr/include/stdint.h", directory: "")
!65 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !66, file: !32, line: 164)
!66 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least16_t", file: !64, line: 44, baseType: !36)
!67 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !68, file: !32, line: 165)
!68 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least32_t", file: !64, line: 45, baseType: !40)
!69 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !70, file: !32, line: 166)
!70 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least64_t", file: !64, line: 47, baseType: !44)
!71 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !72, file: !32, line: 168)
!72 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least8_t", file: !64, line: 54, baseType: !49)
!73 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !74, file: !32, line: 169)
!74 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least16_t", file: !64, line: 55, baseType: !53)
!75 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !76, file: !32, line: 170)
!76 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least32_t", file: !64, line: 56, baseType: !57)
!77 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !78, file: !32, line: 171)
!78 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least64_t", file: !64, line: 58, baseType: !61)
!79 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !80, file: !32, line: 173)
!80 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast8_t", file: !64, line: 68, baseType: !22)
!81 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !82, file: !32, line: 174)
!82 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast16_t", file: !64, line: 70, baseType: !44)
!83 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !84, file: !32, line: 175)
!84 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast32_t", file: !64, line: 71, baseType: !44)
!85 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !86, file: !32, line: 176)
!86 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast64_t", file: !64, line: 72, baseType: !44)
!87 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !88, file: !32, line: 178)
!88 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast8_t", file: !64, line: 81, baseType: !49)
!89 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !90, file: !32, line: 179)
!90 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast16_t", file: !64, line: 83, baseType: !61)
!91 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !92, file: !32, line: 180)
!92 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast32_t", file: !64, line: 84, baseType: !61)
!93 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !94, file: !32, line: 181)
!94 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast64_t", file: !64, line: 85, baseType: !61)
!95 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !96, file: !32, line: 183)
!96 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !64, line: 97, baseType: !44)
!97 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !98, file: !32, line: 184)
!98 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !64, line: 100, baseType: !61)
!99 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !100, file: !32, line: 186)
!100 = !DIDerivedType(tag: DW_TAG_typedef, name: "intmax_t", file: !64, line: 111, baseType: !101)
!101 = !DIDerivedType(tag: DW_TAG_typedef, name: "__intmax_t", file: !21, line: 61, baseType: !44)
!102 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !103, file: !32, line: 187)
!103 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintmax_t", file: !64, line: 112, baseType: !104)
!104 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uintmax_t", file: !21, line: 62, baseType: !61)
!105 = !{i32 2, !"Dwarf Version", i32 4}
!106 = !{i32 2, !"Debug Info Version", i32 3}
!107 = !{i32 1, !"wchar_size", i32 4}
!108 = !{!"clang version 8.0.0 (git@github.com:llvm-mirror/clang.git fd01d8b9288b3558a597daeb0cb4481b37c5bf68) (git@github.com:llvm-mirror/LLVM.git 7135d8b482d3d0d1a8c50111eebb9b207e92a8bc)"}
!109 = distinct !DISubprogram(name: "f", linkageName: "_Z1fPdm", scope: !1, file: !1, line: 9, type: !110, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!110 = !DISubroutineType(types: !111)
!111 = !{null, !15, !112}
!112 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !113, line: 62, baseType: !61)
!113 = !DIFile(filename: "clang_llvm/build_release/lib/clang/8.0.0/include/stddef.h", directory: "/home/mcopik/projects")
!114 = !DILocalVariable(name: "b", arg: 1, scope: !109, file: !1, line: 9, type: !15)
!115 = !DILocation(line: 9, column: 17, scope: !109)
!116 = !DILocalVariable(name: "size", arg: 2, scope: !109, file: !1, line: 9, type: !112)
!117 = !DILocation(line: 9, column: 27, scope: !109)
!118 = !DILocation(line: 11, column: 5, scope: !109)
!119 = !DILocation(line: 11, column: 15, scope: !109)
!120 = !DILocation(line: 11, column: 11, scope: !109)
!121 = !DILocation(line: 12, column: 10, scope: !122)
!122 = distinct !DILexicalBlock(scope: !109, file: !1, line: 11, column: 19)
!123 = !DILocation(line: 12, column: 12, scope: !122)
!124 = !DILocation(line: 13, column: 9, scope: !122)
!125 = distinct !{!125, !118, !126}
!126 = !DILocation(line: 14, column: 5, scope: !109)
!127 = !DILocation(line: 15, column: 1, scope: !109)
!128 = distinct !DISubprogram(name: "h", linkageName: "_Z1hPd", scope: !1, file: !1, line: 17, type: !129, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!129 = !DISubroutineType(types: !130)
!130 = !{!16, !15}
!131 = !DILocalVariable(name: "data", arg: 1, scope: !128, file: !1, line: 17, type: !15)
!132 = !DILocation(line: 17, column: 19, scope: !128)
!133 = !DILocalVariable(name: "acc_rcv", scope: !128, file: !1, line: 19, type: !16)
!134 = !DILocation(line: 19, column: 12, scope: !128)
!135 = !DILocation(line: 19, column: 22, scope: !128)
!136 = !DILocation(line: 20, column: 16, scope: !128)
!137 = !DILocation(line: 20, column: 22, scope: !128)
!138 = !DILocation(line: 20, column: 5, scope: !128)
!139 = !DILocation(line: 21, column: 12, scope: !128)
!140 = !DILocation(line: 21, column: 5, scope: !128)
!141 = distinct !DISubprogram(name: "h_nested", linkageName: "_Z8h_nestedPdm", scope: !1, file: !1, line: 24, type: !110, scopeLine: 25, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!142 = !DILocalVariable(name: "data", arg: 1, scope: !141, file: !1, line: 24, type: !15)
!143 = !DILocation(line: 24, column: 24, scope: !141)
!144 = !DILocalVariable(name: "size", arg: 2, scope: !141, file: !1, line: 24, type: !112)
!145 = !DILocation(line: 24, column: 37, scope: !141)
!146 = !DILocalVariable(name: "i", scope: !147, file: !1, line: 26, type: !40)
!147 = distinct !DILexicalBlock(scope: !141, file: !1, line: 26, column: 5)
!148 = !DILocation(line: 26, column: 13, scope: !147)
!149 = !DILocation(line: 26, column: 9, scope: !147)
!150 = !DILocation(line: 26, column: 20, scope: !151)
!151 = distinct !DILexicalBlock(scope: !147, file: !1, line: 26, column: 5)
!152 = !DILocation(line: 26, column: 24, scope: !151)
!153 = !DILocation(line: 26, column: 22, scope: !151)
!154 = !DILocation(line: 26, column: 5, scope: !147)
!155 = !DILocation(line: 27, column: 12, scope: !156)
!156 = distinct !DILexicalBlock(scope: !151, file: !1, line: 26, column: 35)
!157 = !DILocation(line: 27, column: 17, scope: !156)
!158 = !DILocation(line: 27, column: 9, scope: !156)
!159 = !DILocation(line: 28, column: 5, scope: !156)
!160 = !DILocation(line: 26, column: 30, scope: !151)
!161 = !DILocation(line: 26, column: 5, scope: !151)
!162 = distinct !{!162, !154, !163}
!163 = !DILocation(line: 28, column: 5, scope: !147)
!164 = !DILocation(line: 29, column: 1, scope: !141)
!165 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 31, type: !166, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!166 = !DISubroutineType(types: !167)
!167 = !{!40, !40, !168}
!168 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !169, size: 64)
!169 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !170, size: 64)
!170 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!171 = !DILocalVariable(name: "argc", arg: 1, scope: !165, file: !1, line: 31, type: !40)
!172 = !DILocation(line: 31, column: 14, scope: !165)
!173 = !DILocalVariable(name: "argv", arg: 2, scope: !165, file: !1, line: 31, type: !168)
!174 = !DILocation(line: 31, column: 28, scope: !165)
!175 = !DILocation(line: 33, column: 5, scope: !165)
!176 = !DILocalVariable(name: "size", scope: !165, file: !1, line: 34, type: !40)
!177 = !DILocation(line: 34, column: 9, scope: !165)
!178 = !DILocation(line: 34, column: 5, scope: !165)
!179 = !DILocation(line: 34, column: 28, scope: !165)
!180 = !DILocation(line: 34, column: 23, scope: !165)
!181 = !DILocation(line: 35, column: 5, scope: !165)
!182 = !DILocalVariable(name: "ranks", scope: !165, file: !1, line: 36, type: !40)
!183 = !DILocation(line: 36, column: 9, scope: !165)
!184 = !DILocation(line: 36, column: 5, scope: !165)
!185 = !DILocalVariable(name: "rank_id", scope: !165, file: !1, line: 36, type: !40)
!186 = !DILocation(line: 36, column: 27, scope: !165)
!187 = !DILocation(line: 37, column: 5, scope: !165)
!188 = !DILocation(line: 38, column: 5, scope: !165)
!189 = !DILocation(line: 40, column: 5, scope: !165)
!190 = !DILocation(line: 42, column: 13, scope: !165)
!191 = !DILocation(line: 42, column: 10, scope: !165)
!192 = !DILocalVariable(name: "start", scope: !165, file: !1, line: 43, type: !40)
!193 = !DILocation(line: 43, column: 9, scope: !165)
!194 = !DILocation(line: 43, column: 17, scope: !165)
!195 = !DILocation(line: 43, column: 24, scope: !165)
!196 = !DILocation(line: 43, column: 22, scope: !165)
!197 = !DILocalVariable(name: "data", scope: !165, file: !1, line: 44, type: !15)
!198 = !DILocation(line: 44, column: 14, scope: !165)
!199 = !DILocation(line: 44, column: 38, scope: !165)
!200 = !DILocation(line: 44, column: 31, scope: !165)
!201 = !DILocation(line: 44, column: 21, scope: !165)
!202 = !DILocation(line: 45, column: 7, scope: !165)
!203 = !DILocation(line: 45, column: 13, scope: !165)
!204 = !DILocation(line: 45, column: 5, scope: !165)
!205 = !DILocalVariable(name: "acc_rcv", scope: !165, file: !1, line: 46, type: !16)
!206 = !DILocation(line: 46, column: 12, scope: !165)
!207 = !DILocation(line: 46, column: 24, scope: !165)
!208 = !DILocation(line: 46, column: 22, scope: !165)
!209 = !DILocation(line: 47, column: 8, scope: !210)
!210 = distinct !DILexicalBlock(scope: !165, file: !1, line: 47, column: 8)
!211 = !DILocation(line: 47, column: 16, scope: !210)
!212 = !DILocation(line: 47, column: 8, scope: !165)
!213 = !DILocation(line: 48, column: 24, scope: !210)
!214 = !DILocation(line: 48, column: 9, scope: !210)
!215 = !DILocation(line: 49, column: 10, scope: !165)
!216 = !DILocation(line: 49, column: 5, scope: !165)
!217 = !DILocation(line: 50, column: 5, scope: !165)
!218 = !DILocation(line: 51, column: 5, scope: !165)
!219 = distinct !DISubprogram(name: "register_variable<int>", linkageName: "_Z17register_variableIiEvPT_PKc", scope: !220, file: !220, line: 14, type: !221, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, templateParams: !226, retainedNodes: !2)
!220 = !DIFile(filename: "include/ExtraPInstrumenter.hpp", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!221 = !DISubroutineType(types: !222)
!222 = !{null, !223, !224}
!223 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !40, size: 64)
!224 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !225, size: 64)
!225 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !170)
!226 = !{!227}
!227 = !DITemplateTypeParameter(name: "T", type: !40)
!228 = !DILocalVariable(name: "ptr", arg: 1, scope: !219, file: !220, line: 14, type: !223)
!229 = !DILocation(line: 14, column: 28, scope: !219)
!230 = !DILocalVariable(name: "name", arg: 2, scope: !219, file: !220, line: 14, type: !224)
!231 = !DILocation(line: 14, column: 46, scope: !219)
!232 = !DILocalVariable(name: "param_id", scope: !219, file: !220, line: 16, type: !38)
!233 = !DILocation(line: 16, column: 13, scope: !219)
!234 = !DILocation(line: 16, column: 24, scope: !219)
!235 = !DILocation(line: 17, column: 57, scope: !219)
!236 = !DILocation(line: 17, column: 31, scope: !219)
!237 = !DILocation(line: 18, column: 21, scope: !219)
!238 = !DILocation(line: 18, column: 25, scope: !219)
!239 = !DILocation(line: 17, column: 5, scope: !219)
!240 = !DILocation(line: 19, column: 1, scope: !219)
