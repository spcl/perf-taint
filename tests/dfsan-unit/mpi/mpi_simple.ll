; RUN: opt %mpidfsan -extrap-extractor-out-name=%t4 -S < %s 2> /dev/null | llc %llcparams - -o %t1 && clang++ %link %t1 -o %t2 && %execparams mpiexec -n 2 %t2 10 10 10 && diff -w %s.json %t4_0.json && diff -w %s.json %t4_1.json
; ModuleID = 'tests/dfsan-unit/mpi/mpi_simple.cpp'
source_filename = "tests/dfsan-unit/mpi/mpi_simple.cpp"
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
@.str.1 = private unnamed_addr constant [36 x i8] c"tests/dfsan-unit/mpi/mpi_simple.cpp\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [5 x i8] c"size\00", align 1
@.str.3 = private unnamed_addr constant [6 x i8] c"ranks\00", align 1
@.str.4 = private unnamed_addr constant [4 x i8] c"%f\0A\00", align 1

; Function Attrs: nounwind uwtable
define dso_local void @_Z1fPdm(double*, i64) #0 !dbg !122 {
  %3 = alloca double*, align 8
  %4 = alloca i64, align 8
  store double* %0, double** %3, align 8, !tbaa !128
  call void @llvm.dbg.declare(metadata double** %3, metadata !126, metadata !DIExpression()), !dbg !132
  store i64 %1, i64* %4, align 8, !tbaa !133
  call void @llvm.dbg.declare(metadata i64* %4, metadata !127, metadata !DIExpression()), !dbg !135
  br label %5, !dbg !136

5:                                                ; preds = %9, %2
  %6 = load i64, i64* %4, align 8, !dbg !137, !tbaa !133
  %7 = add i64 %6, -1, !dbg !137
  store i64 %7, i64* %4, align 8, !dbg !137, !tbaa !133
  %8 = icmp ne i64 %6, 0, !dbg !138
  br i1 %8, label %9, label %15, !dbg !136

9:                                                ; preds = %5
  %10 = load double*, double** %3, align 8, !dbg !139, !tbaa !128
  %11 = load double, double* %10, align 8, !dbg !141, !tbaa !142
  %12 = fadd double %11, 2.000000e+00, !dbg !141
  store double %12, double* %10, align 8, !dbg !141, !tbaa !142
  %13 = load double*, double** %3, align 8, !dbg !144, !tbaa !128
  %14 = getelementptr inbounds double, double* %13, i32 1, !dbg !144
  store double* %14, double** %3, align 8, !dbg !144, !tbaa !128
  br label %5, !dbg !136, !llvm.loop !145

15:                                               ; preds = %5
  ret void, !dbg !147
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: uwtable
define dso_local double @_Z16h_multiple_loopsPdm(double*, i64) #2 !dbg !148 {
  %3 = alloca double*, align 8
  %4 = alloca i64, align 8
  %5 = alloca i32, align 4
  %6 = alloca double, align 8
  store double* %0, double** %3, align 8, !tbaa !128
  call void @llvm.dbg.declare(metadata double** %3, metadata !152, metadata !DIExpression()), !dbg !157
  store i64 %1, i64* %4, align 8, !tbaa !133
  call void @llvm.dbg.declare(metadata i64* %4, metadata !153, metadata !DIExpression()), !dbg !158
  %7 = bitcast i32* %5 to i8*, !dbg !159
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %7) #6, !dbg !159
  call void @llvm.dbg.declare(metadata i32* %5, metadata !154, metadata !DIExpression()), !dbg !160
  store i32 0, i32* %5, align 4, !dbg !160, !tbaa !161
  br label %8, !dbg !159

8:                                                ; preds = %22, %2
  %9 = load i32, i32* %5, align 4, !dbg !163, !tbaa !161
  %10 = sext i32 %9 to i64, !dbg !163
  %11 = load i64, i64* %4, align 8, !dbg !165, !tbaa !133
  %12 = icmp ult i64 %10, %11, !dbg !166
  br i1 %12, label %15, label %13, !dbg !167

13:                                               ; preds = %8
  %14 = bitcast i32* %5 to i8*, !dbg !168
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %14) #6, !dbg !168
  br label %25

15:                                               ; preds = %8
  %16 = load double*, double** %3, align 8, !dbg !169, !tbaa !128
  %17 = load i32, i32* %5, align 4, !dbg !170, !tbaa !161
  %18 = sext i32 %17 to i64, !dbg !169
  %19 = getelementptr inbounds double, double* %16, i64 %18, !dbg !169
  %20 = load double, double* %19, align 8, !dbg !171, !tbaa !142
  %21 = fadd double %20, 1.000000e+00, !dbg !171
  store double %21, double* %19, align 8, !dbg !171, !tbaa !142
  br label %22, !dbg !169

22:                                               ; preds = %15
  %23 = load i32, i32* %5, align 4, !dbg !172, !tbaa !161
  %24 = add nsw i32 %23, 1, !dbg !172
  store i32 %24, i32* %5, align 4, !dbg !172, !tbaa !161
  br label %8, !dbg !168, !llvm.loop !173

25:                                               ; preds = %13
  %26 = bitcast double* %6 to i8*, !dbg !175
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %26) #6, !dbg !175
  call void @llvm.dbg.declare(metadata double* %6, metadata !156, metadata !DIExpression()), !dbg !176
  %27 = load double*, double** %3, align 8, !dbg !177, !tbaa !128
  %28 = getelementptr inbounds double, double* %27, i64 0, !dbg !177
  %29 = load double, double* %28, align 8, !dbg !177, !tbaa !142
  store double %29, double* %6, align 8, !dbg !176, !tbaa !142
  %30 = load double*, double** %3, align 8, !dbg !178, !tbaa !128
  %31 = bitcast double* %30 to i8*, !dbg !178
  %32 = bitcast double* %6 to i8*, !dbg !179
  %33 = call i32 @MPI_Reduce(i8* %31, i8* %32, i32 1, %struct.ompi_datatype_t* bitcast (%struct.ompi_predefined_datatype_t* @ompi_mpi_double to %struct.ompi_datatype_t*), %struct.ompi_op_t* bitcast (%struct.ompi_predefined_op_t* @ompi_mpi_op_sum to %struct.ompi_op_t*), i32 0, %struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*)), !dbg !180
  %34 = load double, double* %6, align 8, !dbg !181, !tbaa !142
  %35 = bitcast double* %6 to i8*, !dbg !182
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %35) #6, !dbg !182
  ret double %34, !dbg !183
}

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #3

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #3

declare dso_local i32 @MPI_Reduce(i8*, i8*, i32, %struct.ompi_datatype_t*, %struct.ompi_op_t*, i32, %struct.ompi_communicator_t*) #4

; Function Attrs: uwtable
define dso_local double @_Z1hPd(double*) #2 !dbg !184 {
  %2 = alloca double*, align 8
  %3 = alloca double, align 8
  store double* %0, double** %2, align 8, !tbaa !128
  call void @llvm.dbg.declare(metadata double** %2, metadata !188, metadata !DIExpression()), !dbg !190
  %4 = bitcast double* %3 to i8*, !dbg !191
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %4) #6, !dbg !191
  call void @llvm.dbg.declare(metadata double* %3, metadata !189, metadata !DIExpression()), !dbg !192
  %5 = load double*, double** %2, align 8, !dbg !193, !tbaa !128
  %6 = getelementptr inbounds double, double* %5, i64 0, !dbg !193
  %7 = load double, double* %6, align 8, !dbg !193, !tbaa !142
  store double %7, double* %3, align 8, !dbg !192, !tbaa !142
  %8 = load double*, double** %2, align 8, !dbg !194, !tbaa !128
  %9 = bitcast double* %8 to i8*, !dbg !194
  %10 = bitcast double* %3 to i8*, !dbg !195
  %11 = call i32 @MPI_Reduce(i8* %9, i8* %10, i32 1, %struct.ompi_datatype_t* bitcast (%struct.ompi_predefined_datatype_t* @ompi_mpi_double to %struct.ompi_datatype_t*), %struct.ompi_op_t* bitcast (%struct.ompi_predefined_op_t* @ompi_mpi_op_sum to %struct.ompi_op_t*), i32 0, %struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*)), !dbg !196
  %12 = load double, double* %3, align 8, !dbg !197, !tbaa !142
  %13 = bitcast double* %3 to i8*, !dbg !198
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %13) #6, !dbg !198
  ret double %12, !dbg !199
}

; Function Attrs: uwtable
define dso_local void @_Z8h_nestedPdm(double*, i64) #2 !dbg !200 {
  %3 = alloca double*, align 8
  %4 = alloca i64, align 8
  %5 = alloca i32, align 4
  store double* %0, double** %3, align 8, !tbaa !128
  call void @llvm.dbg.declare(metadata double** %3, metadata !202, metadata !DIExpression()), !dbg !206
  store i64 %1, i64* %4, align 8, !tbaa !133
  call void @llvm.dbg.declare(metadata i64* %4, metadata !203, metadata !DIExpression()), !dbg !207
  %6 = bitcast i32* %5 to i8*, !dbg !208
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %6) #6, !dbg !208
  call void @llvm.dbg.declare(metadata i32* %5, metadata !204, metadata !DIExpression()), !dbg !209
  store i32 0, i32* %5, align 4, !dbg !209, !tbaa !161
  br label %7, !dbg !208

7:                                                ; preds = %20, %2
  %8 = load i32, i32* %5, align 4, !dbg !210, !tbaa !161
  %9 = sext i32 %8 to i64, !dbg !210
  %10 = load i64, i64* %4, align 8, !dbg !212, !tbaa !133
  %11 = icmp ult i64 %9, %10, !dbg !213
  br i1 %11, label %14, label %12, !dbg !214

12:                                               ; preds = %7
  %13 = bitcast i32* %5 to i8*, !dbg !215
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %13) #6, !dbg !215
  br label %23

14:                                               ; preds = %7
  %15 = load double*, double** %3, align 8, !dbg !216, !tbaa !128
  %16 = load i32, i32* %5, align 4, !dbg !218, !tbaa !161
  %17 = sext i32 %16 to i64, !dbg !216
  %18 = getelementptr inbounds double, double* %15, i64 %17, !dbg !216
  %19 = call double @_Z1hPd(double* %18), !dbg !219
  br label %20, !dbg !220

20:                                               ; preds = %14
  %21 = load i32, i32* %5, align 4, !dbg !221, !tbaa !161
  %22 = add nsw i32 %21, 1, !dbg !221
  store i32 %22, i32* %5, align 4, !dbg !221, !tbaa !161
  br label %7, !dbg !215, !llvm.loop !222

23:                                               ; preds = %12
  ret void, !dbg !224
}

; Function Attrs: norecurse uwtable
define dso_local i32 @main(i32, i8**) #5 !dbg !225 {
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
  store i32 %0, i32* %4, align 4, !tbaa !161
  call void @llvm.dbg.declare(metadata i32* %4, metadata !229, metadata !DIExpression()), !dbg !237
  store i8** %1, i8*** %5, align 8, !tbaa !128
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !230, metadata !DIExpression()), !dbg !238
  %12 = call i32 @MPI_Init(i32* %4, i8*** %5), !dbg !239
  %13 = bitcast i32* %6 to i8*, !dbg !240
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %13) #6, !dbg !240
  call void @llvm.dbg.declare(metadata i32* %6, metadata !231, metadata !DIExpression()), !dbg !241
  %14 = bitcast i32* %6 to i8*, !dbg !240
  call void @llvm.var.annotation(i8* %14, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([36 x i8], [36 x i8]* @.str.1, i32 0, i32 0), i32 43), !dbg !240
  %15 = load i8**, i8*** %5, align 8, !dbg !242, !tbaa !128
  %16 = getelementptr inbounds i8*, i8** %15, i64 1, !dbg !242
  %17 = load i8*, i8** %16, align 8, !dbg !242, !tbaa !128
  %18 = call i32 @atoi(i8* %17) #9, !dbg !243
  store i32 %18, i32* %6, align 4, !dbg !241, !tbaa !161
  call void @_Z17register_variableIiEvPT_PKc(i32* %6, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.2, i64 0, i64 0)), !dbg !244
  %19 = bitcast i32* %7 to i8*, !dbg !245
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %19) #6, !dbg !245
  call void @llvm.dbg.declare(metadata i32* %7, metadata !232, metadata !DIExpression()), !dbg !246
  %20 = bitcast i32* %7 to i8*, !dbg !245
  call void @llvm.var.annotation(i8* %20, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([36 x i8], [36 x i8]* @.str.1, i32 0, i32 0), i32 45), !dbg !245
  store i32 1, i32* %7, align 4, !dbg !246, !tbaa !161
  %21 = bitcast i32* %8 to i8*, !dbg !245
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %21) #6, !dbg !245
  call void @llvm.dbg.declare(metadata i32* %8, metadata !233, metadata !DIExpression()), !dbg !247
  %22 = call i32 @MPI_Comm_size(%struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*), i32* %7), !dbg !248
  %23 = call i32 @MPI_Comm_rank(%struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*), i32* %8), !dbg !249
  call void @_Z17register_variableIiEvPT_PKc(i32* %7, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.3, i64 0, i64 0)), !dbg !250
  %24 = load i32, i32* %7, align 4, !dbg !251, !tbaa !161
  %25 = load i32, i32* %6, align 4, !dbg !252, !tbaa !161
  %26 = sdiv i32 %25, %24, !dbg !252
  store i32 %26, i32* %6, align 4, !dbg !252, !tbaa !161
  %27 = bitcast i32* %9 to i8*, !dbg !253
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %27) #6, !dbg !253
  call void @llvm.dbg.declare(metadata i32* %9, metadata !234, metadata !DIExpression()), !dbg !254
  %28 = load i32, i32* %6, align 4, !dbg !255, !tbaa !161
  %29 = load i32, i32* %8, align 4, !dbg !256, !tbaa !161
  %30 = mul nsw i32 %28, %29, !dbg !257
  store i32 %30, i32* %9, align 4, !dbg !254, !tbaa !161
  %31 = bitcast double** %10 to i8*, !dbg !258
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %31) #6, !dbg !258
  call void @llvm.dbg.declare(metadata double** %10, metadata !235, metadata !DIExpression()), !dbg !259
  %32 = load i32, i32* %6, align 4, !dbg !260, !tbaa !161
  %33 = sext i32 %32 to i64, !dbg !260
  %34 = call noalias i8* @calloc(i64 %33, i64 8) #6, !dbg !261
  %35 = bitcast i8* %34 to double*, !dbg !262
  store double* %35, double** %10, align 8, !dbg !259, !tbaa !128
  %36 = load double*, double** %10, align 8, !dbg !263, !tbaa !128
  %37 = load i32, i32* %6, align 4, !dbg !264, !tbaa !161
  %38 = sext i32 %37 to i64, !dbg !264
  call void @_Z1fPdm(double* %36, i64 %38), !dbg !265
  %39 = bitcast double* %11 to i8*, !dbg !266
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %39) #6, !dbg !266
  call void @llvm.dbg.declare(metadata double* %11, metadata !236, metadata !DIExpression()), !dbg !267
  %40 = load double*, double** %10, align 8, !dbg !268, !tbaa !128
  %41 = load i32, i32* %6, align 4, !dbg !269, !tbaa !161
  %42 = sext i32 %41 to i64, !dbg !269
  %43 = call double @_Z16h_multiple_loopsPdm(double* %40, i64 %42), !dbg !270
  store double %43, double* %11, align 8, !dbg !267, !tbaa !142
  %44 = load double*, double** %10, align 8, !dbg !271, !tbaa !128
  %45 = load i32, i32* %6, align 4, !dbg !272, !tbaa !161
  %46 = sext i32 %45 to i64, !dbg !272
  call void @_Z8h_nestedPdm(double* %44, i64 %46), !dbg !273
  %47 = load i32, i32* %8, align 4, !dbg !274, !tbaa !161
  %48 = icmp eq i32 %47, 0, !dbg !276
  br i1 %48, label %49, label %52, !dbg !277

49:                                               ; preds = %2
  %50 = load double, double* %11, align 8, !dbg !278, !tbaa !142
  %51 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i64 0, i64 0), double %50), !dbg !279
  br label %52, !dbg !279

52:                                               ; preds = %49, %2
  %53 = call i32 @MPI_Barrier(%struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*)), !dbg !280
  %54 = load double*, double** %10, align 8, !dbg !281, !tbaa !128
  %55 = bitcast double* %54 to i8*, !dbg !281
  call void @free(i8* %55) #6, !dbg !282
  %56 = call i32 @MPI_Finalize(), !dbg !283
  %57 = bitcast double* %11 to i8*, !dbg !284
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %57) #6, !dbg !284
  %58 = bitcast double** %10 to i8*, !dbg !284
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %58) #6, !dbg !284
  %59 = bitcast i32* %9 to i8*, !dbg !284
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %59) #6, !dbg !284
  %60 = bitcast i32* %8 to i8*, !dbg !284
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %60) #6, !dbg !284
  %61 = bitcast i32* %7 to i8*, !dbg !284
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %61) #6, !dbg !284
  %62 = bitcast i32* %6 to i8*, !dbg !284
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %62) #6, !dbg !284
  ret i32 0, !dbg !285
}

declare dso_local i32 @MPI_Init(i32*, i8***) #4

; Function Attrs: nounwind
declare void @llvm.var.annotation(i8*, i8*, i8*, i32) #6

; Function Attrs: inlinehint nounwind readonly uwtable
define available_externally dso_local i32 @atoi(i8* nonnull) #7 !dbg !286 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8, !tbaa !128
  call void @llvm.dbg.declare(metadata i8** %2, metadata !293, metadata !DIExpression()), !dbg !294
  %3 = load i8*, i8** %2, align 8, !dbg !295, !tbaa !128
  %4 = call i64 @strtol(i8* %3, i8** null, i32 10) #6, !dbg !296
  %5 = trunc i64 %4 to i32, !dbg !296
  ret i32 %5, !dbg !297
}

; Function Attrs: uwtable
define linkonce_odr dso_local void @_Z17register_variableIiEvPT_PKc(i32*, i8*) #2 comdat !dbg !298 {
  %3 = alloca i32*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca i32, align 4
  store i32* %0, i32** %3, align 8, !tbaa !128
  call void @llvm.dbg.declare(metadata i32** %3, metadata !304, metadata !DIExpression()), !dbg !309
  store i8* %1, i8** %4, align 8, !tbaa !128
  call void @llvm.dbg.declare(metadata i8** %4, metadata !305, metadata !DIExpression()), !dbg !310
  %6 = bitcast i32* %5 to i8*, !dbg !311
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %6) #6, !dbg !311
  call void @llvm.dbg.declare(metadata i32* %5, metadata !306, metadata !DIExpression()), !dbg !312
  %7 = call i32 @__dfsw_EXTRAP_VAR_ID(), !dbg !313
  store i32 %7, i32* %5, align 4, !dbg !312, !tbaa !161
  %8 = load i32*, i32** %3, align 8, !dbg !314, !tbaa !128
  %9 = bitcast i32* %8 to i8*, !dbg !315
  %10 = load i32, i32* %5, align 4, !dbg !316, !tbaa !161
  %11 = add nsw i32 %10, 1, !dbg !316
  store i32 %11, i32* %5, align 4, !dbg !316, !tbaa !161
  %12 = load i8*, i8** %4, align 8, !dbg !317, !tbaa !128
  call void @__dfsw_EXTRAP_STORE_LABEL(i8* %9, i32 4, i32 %10, i8* %12), !dbg !318
  %13 = bitcast i32* %5 to i8*, !dbg !319
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %13) #6, !dbg !319
  ret void, !dbg !319
}

declare dso_local i32 @MPI_Comm_size(%struct.ompi_communicator_t*, i32*) #4

declare dso_local i32 @MPI_Comm_rank(%struct.ompi_communicator_t*, i32*) #4

; Function Attrs: nounwind
declare dso_local noalias i8* @calloc(i64, i64) #8

declare dso_local i32 @printf(i8*, ...) #4

declare dso_local i32 @MPI_Barrier(%struct.ompi_communicator_t*) #4

; Function Attrs: nounwind
declare dso_local void @free(i8*) #8

declare dso_local i32 @MPI_Finalize() #4

; Function Attrs: nounwind
declare dso_local i64 @strtol(i8*, i8**, i32) #8

declare dso_local i32 @__dfsw_EXTRAP_VAR_ID() #4

declare dso_local void @__dfsw_EXTRAP_STORE_LABEL(i8*, i32, i32, i8*) #4

attributes #0 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { argmemonly nounwind }
attributes #4 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { norecurse uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #6 = { nounwind }
attributes #7 = { inlinehint nounwind readonly uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #8 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #9 = { nounwind readonly }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!118, !119, !120}
!llvm.ident = !{!121}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !1, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !3, imports: !27, nameTableKind: None)
!1 = !DIFile(filename: "tests/dfsan-unit/mpi/mpi_simple.cpp", directory: "/home/mcopik/projects/ETH/extrap/rebuild/perf-taint")
!2 = !{}
!3 = !{!4, !8, !9, !12, !15, !17, !18, !21}
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
!17 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!18 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !19, size: 64)
!19 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !20, size: 64)
!20 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!21 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !22, size: 64)
!22 = !DIDerivedType(tag: DW_TAG_typedef, name: "int8_t", file: !23, line: 24, baseType: !24)
!23 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-intn.h", directory: "")
!24 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int8_t", file: !25, line: 36, baseType: !26)
!25 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "")
!26 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!27 = !{!28, !35, !38, !42, !47, !49, !53, !56, !59, !64, !68, !72, !75, !78, !80, !82, !84, !86, !88, !90, !92, !94, !96, !98, !100, !102, !104, !106, !108, !110, !112, !115}
!28 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !29, entity: !31, file: !34, line: 49)
!29 = !DINamespace(name: "__1", scope: !30, exportSymbols: true)
!30 = !DINamespace(name: "std", scope: null)
!31 = !DIDerivedType(tag: DW_TAG_typedef, name: "ptrdiff_t", file: !32, line: 35, baseType: !33)
!32 = !DIFile(filename: "clang_llvm/llvm-9.0/build-9.0/lib/clang/9.0.0/include/stddef.h", directory: "/home/mcopik/projects")
!33 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!34 = !DIFile(filename: "build_tool/../usr/include/c++/v1/cstddef", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!35 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !29, entity: !36, file: !34, line: 50)
!36 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !32, line: 46, baseType: !37)
!37 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!38 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !29, entity: !39, file: !34, line: 55)
!39 = !DIDerivedType(tag: DW_TAG_typedef, name: "max_align_t", file: !40, line: 24, baseType: !41)
!40 = !DIFile(filename: "clang_llvm/llvm-9.0/build-9.0/lib/clang/9.0.0/include/__stddef_max_align_t.h", directory: "/home/mcopik/projects")
!41 = !DICompositeType(tag: DW_TAG_structure_type, file: !40, line: 19, flags: DIFlagFwdDecl, identifier: "_ZTS11max_align_t")
!42 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !43, file: !46, line: 51)
!43 = !DIDerivedType(tag: DW_TAG_typedef, name: "nullptr_t", scope: !30, file: !44, line: 56, baseType: !45)
!44 = !DIFile(filename: "build_tool/../usr/include/c++/v1/__nullptr", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!45 = !DIBasicType(tag: DW_TAG_unspecified_type, name: "decltype(nullptr)")
!46 = !DIFile(filename: "build_tool/../usr/include/c++/v1/stddef.h", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!47 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !29, entity: !22, file: !48, line: 152)
!48 = !DIFile(filename: "build_tool/../usr/include/c++/v1/cstdint", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!49 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !29, entity: !50, file: !48, line: 153)
!50 = !DIDerivedType(tag: DW_TAG_typedef, name: "int16_t", file: !23, line: 25, baseType: !51)
!51 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int16_t", file: !25, line: 38, baseType: !52)
!52 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!53 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !29, entity: !54, file: !48, line: 154)
!54 = !DIDerivedType(tag: DW_TAG_typedef, name: "int32_t", file: !23, line: 26, baseType: !55)
!55 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int32_t", file: !25, line: 40, baseType: !17)
!56 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !29, entity: !57, file: !48, line: 155)
!57 = !DIDerivedType(tag: DW_TAG_typedef, name: "int64_t", file: !23, line: 27, baseType: !58)
!58 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int64_t", file: !25, line: 43, baseType: !33)
!59 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !29, entity: !60, file: !48, line: 157)
!60 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint8_t", file: !61, line: 24, baseType: !62)
!61 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "")
!62 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint8_t", file: !25, line: 37, baseType: !63)
!63 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!64 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !29, entity: !65, file: !48, line: 158)
!65 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint16_t", file: !61, line: 25, baseType: !66)
!66 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint16_t", file: !25, line: 39, baseType: !67)
!67 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!68 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !29, entity: !69, file: !48, line: 159)
!69 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !61, line: 26, baseType: !70)
!70 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !25, line: 41, baseType: !71)
!71 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!72 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !29, entity: !73, file: !48, line: 160)
!73 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", file: !61, line: 27, baseType: !74)
!74 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint64_t", file: !25, line: 44, baseType: !37)
!75 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !29, entity: !76, file: !48, line: 162)
!76 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least8_t", file: !77, line: 43, baseType: !26)
!77 = !DIFile(filename: "/usr/include/stdint.h", directory: "")
!78 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !29, entity: !79, file: !48, line: 163)
!79 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least16_t", file: !77, line: 44, baseType: !52)
!80 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !29, entity: !81, file: !48, line: 164)
!81 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least32_t", file: !77, line: 45, baseType: !17)
!82 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !29, entity: !83, file: !48, line: 165)
!83 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least64_t", file: !77, line: 47, baseType: !33)
!84 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !29, entity: !85, file: !48, line: 167)
!85 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least8_t", file: !77, line: 54, baseType: !63)
!86 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !29, entity: !87, file: !48, line: 168)
!87 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least16_t", file: !77, line: 55, baseType: !67)
!88 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !29, entity: !89, file: !48, line: 169)
!89 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least32_t", file: !77, line: 56, baseType: !71)
!90 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !29, entity: !91, file: !48, line: 170)
!91 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least64_t", file: !77, line: 58, baseType: !37)
!92 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !29, entity: !93, file: !48, line: 172)
!93 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast8_t", file: !77, line: 68, baseType: !26)
!94 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !29, entity: !95, file: !48, line: 173)
!95 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast16_t", file: !77, line: 70, baseType: !33)
!96 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !29, entity: !97, file: !48, line: 174)
!97 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast32_t", file: !77, line: 71, baseType: !33)
!98 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !29, entity: !99, file: !48, line: 175)
!99 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast64_t", file: !77, line: 72, baseType: !33)
!100 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !29, entity: !101, file: !48, line: 177)
!101 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast8_t", file: !77, line: 81, baseType: !63)
!102 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !29, entity: !103, file: !48, line: 178)
!103 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast16_t", file: !77, line: 83, baseType: !37)
!104 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !29, entity: !105, file: !48, line: 179)
!105 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast32_t", file: !77, line: 84, baseType: !37)
!106 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !29, entity: !107, file: !48, line: 180)
!107 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast64_t", file: !77, line: 85, baseType: !37)
!108 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !29, entity: !109, file: !48, line: 182)
!109 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !77, line: 97, baseType: !33)
!110 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !29, entity: !111, file: !48, line: 183)
!111 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !77, line: 100, baseType: !37)
!112 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !29, entity: !113, file: !48, line: 185)
!113 = !DIDerivedType(tag: DW_TAG_typedef, name: "intmax_t", file: !77, line: 111, baseType: !114)
!114 = !DIDerivedType(tag: DW_TAG_typedef, name: "__intmax_t", file: !25, line: 61, baseType: !33)
!115 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !29, entity: !116, file: !48, line: 186)
!116 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintmax_t", file: !77, line: 112, baseType: !117)
!117 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uintmax_t", file: !25, line: 62, baseType: !37)
!118 = !{i32 2, !"Dwarf Version", i32 4}
!119 = !{i32 2, !"Debug Info Version", i32 3}
!120 = !{i32 1, !"wchar_size", i32 4}
!121 = !{!"clang version 9.0.0 (tags/RELEASE_900/final)"}
!122 = distinct !DISubprogram(name: "f", linkageName: "_Z1fPdm", scope: !1, file: !1, line: 9, type: !123, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !125)
!123 = !DISubroutineType(types: !124)
!124 = !{null, !15, !36}
!125 = !{!126, !127}
!126 = !DILocalVariable(name: "b", arg: 1, scope: !122, file: !1, line: 9, type: !15)
!127 = !DILocalVariable(name: "size", arg: 2, scope: !122, file: !1, line: 9, type: !36)
!128 = !{!129, !129, i64 0}
!129 = !{!"any pointer", !130, i64 0}
!130 = !{!"omnipotent char", !131, i64 0}
!131 = !{!"Simple C++ TBAA"}
!132 = !DILocation(line: 9, column: 17, scope: !122)
!133 = !{!134, !134, i64 0}
!134 = !{!"long", !130, i64 0}
!135 = !DILocation(line: 9, column: 27, scope: !122)
!136 = !DILocation(line: 11, column: 5, scope: !122)
!137 = !DILocation(line: 11, column: 15, scope: !122)
!138 = !DILocation(line: 11, column: 11, scope: !122)
!139 = !DILocation(line: 12, column: 10, scope: !140)
!140 = distinct !DILexicalBlock(scope: !122, file: !1, line: 11, column: 19)
!141 = !DILocation(line: 12, column: 12, scope: !140)
!142 = !{!143, !143, i64 0}
!143 = !{!"double", !130, i64 0}
!144 = !DILocation(line: 13, column: 9, scope: !140)
!145 = distinct !{!145, !136, !146}
!146 = !DILocation(line: 14, column: 5, scope: !122)
!147 = !DILocation(line: 15, column: 1, scope: !122)
!148 = distinct !DISubprogram(name: "h_multiple_loops", linkageName: "_Z16h_multiple_loopsPdm", scope: !1, file: !1, line: 17, type: !149, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !151)
!149 = !DISubroutineType(types: !150)
!150 = !{!16, !15, !36}
!151 = !{!152, !153, !154, !156}
!152 = !DILocalVariable(name: "data", arg: 1, scope: !148, file: !1, line: 17, type: !15)
!153 = !DILocalVariable(name: "size", arg: 2, scope: !148, file: !1, line: 17, type: !36)
!154 = !DILocalVariable(name: "i", scope: !155, file: !1, line: 19, type: !17)
!155 = distinct !DILexicalBlock(scope: !148, file: !1, line: 19, column: 5)
!156 = !DILocalVariable(name: "acc_rcv", scope: !148, file: !1, line: 21, type: !16)
!157 = !DILocation(line: 17, column: 34, scope: !148)
!158 = !DILocation(line: 17, column: 47, scope: !148)
!159 = !DILocation(line: 19, column: 9, scope: !155)
!160 = !DILocation(line: 19, column: 13, scope: !155)
!161 = !{!162, !162, i64 0}
!162 = !{!"int", !130, i64 0}
!163 = !DILocation(line: 19, column: 20, scope: !164)
!164 = distinct !DILexicalBlock(scope: !155, file: !1, line: 19, column: 5)
!165 = !DILocation(line: 19, column: 24, scope: !164)
!166 = !DILocation(line: 19, column: 22, scope: !164)
!167 = !DILocation(line: 19, column: 5, scope: !155)
!168 = !DILocation(line: 19, column: 5, scope: !164)
!169 = !DILocation(line: 20, column: 9, scope: !164)
!170 = !DILocation(line: 20, column: 14, scope: !164)
!171 = !DILocation(line: 20, column: 16, scope: !164)
!172 = !DILocation(line: 19, column: 30, scope: !164)
!173 = distinct !{!173, !167, !174}
!174 = !DILocation(line: 20, column: 16, scope: !155)
!175 = !DILocation(line: 21, column: 5, scope: !148)
!176 = !DILocation(line: 21, column: 12, scope: !148)
!177 = !DILocation(line: 21, column: 22, scope: !148)
!178 = !DILocation(line: 22, column: 16, scope: !148)
!179 = !DILocation(line: 22, column: 22, scope: !148)
!180 = !DILocation(line: 22, column: 5, scope: !148)
!181 = !DILocation(line: 23, column: 12, scope: !148)
!182 = !DILocation(line: 24, column: 1, scope: !148)
!183 = !DILocation(line: 23, column: 5, scope: !148)
!184 = distinct !DISubprogram(name: "h", linkageName: "_Z1hPd", scope: !1, file: !1, line: 26, type: !185, scopeLine: 27, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !187)
!185 = !DISubroutineType(types: !186)
!186 = !{!16, !15}
!187 = !{!188, !189}
!188 = !DILocalVariable(name: "data", arg: 1, scope: !184, file: !1, line: 26, type: !15)
!189 = !DILocalVariable(name: "acc_rcv", scope: !184, file: !1, line: 28, type: !16)
!190 = !DILocation(line: 26, column: 19, scope: !184)
!191 = !DILocation(line: 28, column: 5, scope: !184)
!192 = !DILocation(line: 28, column: 12, scope: !184)
!193 = !DILocation(line: 28, column: 22, scope: !184)
!194 = !DILocation(line: 29, column: 16, scope: !184)
!195 = !DILocation(line: 29, column: 22, scope: !184)
!196 = !DILocation(line: 29, column: 5, scope: !184)
!197 = !DILocation(line: 30, column: 12, scope: !184)
!198 = !DILocation(line: 31, column: 1, scope: !184)
!199 = !DILocation(line: 30, column: 5, scope: !184)
!200 = distinct !DISubprogram(name: "h_nested", linkageName: "_Z8h_nestedPdm", scope: !1, file: !1, line: 33, type: !123, scopeLine: 34, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !201)
!201 = !{!202, !203, !204}
!202 = !DILocalVariable(name: "data", arg: 1, scope: !200, file: !1, line: 33, type: !15)
!203 = !DILocalVariable(name: "size", arg: 2, scope: !200, file: !1, line: 33, type: !36)
!204 = !DILocalVariable(name: "i", scope: !205, file: !1, line: 35, type: !17)
!205 = distinct !DILexicalBlock(scope: !200, file: !1, line: 35, column: 5)
!206 = !DILocation(line: 33, column: 24, scope: !200)
!207 = !DILocation(line: 33, column: 37, scope: !200)
!208 = !DILocation(line: 35, column: 9, scope: !205)
!209 = !DILocation(line: 35, column: 13, scope: !205)
!210 = !DILocation(line: 35, column: 20, scope: !211)
!211 = distinct !DILexicalBlock(scope: !205, file: !1, line: 35, column: 5)
!212 = !DILocation(line: 35, column: 24, scope: !211)
!213 = !DILocation(line: 35, column: 22, scope: !211)
!214 = !DILocation(line: 35, column: 5, scope: !205)
!215 = !DILocation(line: 35, column: 5, scope: !211)
!216 = !DILocation(line: 36, column: 12, scope: !217)
!217 = distinct !DILexicalBlock(scope: !211, file: !1, line: 35, column: 35)
!218 = !DILocation(line: 36, column: 17, scope: !217)
!219 = !DILocation(line: 36, column: 9, scope: !217)
!220 = !DILocation(line: 37, column: 5, scope: !217)
!221 = !DILocation(line: 35, column: 30, scope: !211)
!222 = distinct !{!222, !214, !223}
!223 = !DILocation(line: 37, column: 5, scope: !205)
!224 = !DILocation(line: 38, column: 1, scope: !200)
!225 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 40, type: !226, scopeLine: 41, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !228)
!226 = !DISubroutineType(types: !227)
!227 = !{!17, !17, !18}
!228 = !{!229, !230, !231, !232, !233, !234, !235, !236}
!229 = !DILocalVariable(name: "argc", arg: 1, scope: !225, file: !1, line: 40, type: !17)
!230 = !DILocalVariable(name: "argv", arg: 2, scope: !225, file: !1, line: 40, type: !18)
!231 = !DILocalVariable(name: "size", scope: !225, file: !1, line: 43, type: !17)
!232 = !DILocalVariable(name: "ranks", scope: !225, file: !1, line: 45, type: !17)
!233 = !DILocalVariable(name: "rank_id", scope: !225, file: !1, line: 45, type: !17)
!234 = !DILocalVariable(name: "start", scope: !225, file: !1, line: 52, type: !17)
!235 = !DILocalVariable(name: "data", scope: !225, file: !1, line: 53, type: !15)
!236 = !DILocalVariable(name: "acc_rcv", scope: !225, file: !1, line: 55, type: !16)
!237 = !DILocation(line: 40, column: 14, scope: !225)
!238 = !DILocation(line: 40, column: 28, scope: !225)
!239 = !DILocation(line: 42, column: 5, scope: !225)
!240 = !DILocation(line: 43, column: 5, scope: !225)
!241 = !DILocation(line: 43, column: 9, scope: !225)
!242 = !DILocation(line: 43, column: 28, scope: !225)
!243 = !DILocation(line: 43, column: 23, scope: !225)
!244 = !DILocation(line: 44, column: 5, scope: !225)
!245 = !DILocation(line: 45, column: 5, scope: !225)
!246 = !DILocation(line: 45, column: 9, scope: !225)
!247 = !DILocation(line: 45, column: 27, scope: !225)
!248 = !DILocation(line: 46, column: 5, scope: !225)
!249 = !DILocation(line: 47, column: 5, scope: !225)
!250 = !DILocation(line: 49, column: 5, scope: !225)
!251 = !DILocation(line: 51, column: 13, scope: !225)
!252 = !DILocation(line: 51, column: 10, scope: !225)
!253 = !DILocation(line: 52, column: 5, scope: !225)
!254 = !DILocation(line: 52, column: 9, scope: !225)
!255 = !DILocation(line: 52, column: 17, scope: !225)
!256 = !DILocation(line: 52, column: 24, scope: !225)
!257 = !DILocation(line: 52, column: 22, scope: !225)
!258 = !DILocation(line: 53, column: 5, scope: !225)
!259 = !DILocation(line: 53, column: 14, scope: !225)
!260 = !DILocation(line: 53, column: 38, scope: !225)
!261 = !DILocation(line: 53, column: 31, scope: !225)
!262 = !DILocation(line: 53, column: 21, scope: !225)
!263 = !DILocation(line: 54, column: 7, scope: !225)
!264 = !DILocation(line: 54, column: 13, scope: !225)
!265 = !DILocation(line: 54, column: 5, scope: !225)
!266 = !DILocation(line: 55, column: 5, scope: !225)
!267 = !DILocation(line: 55, column: 12, scope: !225)
!268 = !DILocation(line: 55, column: 39, scope: !225)
!269 = !DILocation(line: 55, column: 45, scope: !225)
!270 = !DILocation(line: 55, column: 22, scope: !225)
!271 = !DILocation(line: 56, column: 14, scope: !225)
!272 = !DILocation(line: 56, column: 20, scope: !225)
!273 = !DILocation(line: 56, column: 5, scope: !225)
!274 = !DILocation(line: 57, column: 8, scope: !275)
!275 = distinct !DILexicalBlock(scope: !225, file: !1, line: 57, column: 8)
!276 = !DILocation(line: 57, column: 16, scope: !275)
!277 = !DILocation(line: 57, column: 8, scope: !225)
!278 = !DILocation(line: 58, column: 24, scope: !275)
!279 = !DILocation(line: 58, column: 9, scope: !275)
!280 = !DILocation(line: 59, column: 5, scope: !225)
!281 = !DILocation(line: 60, column: 10, scope: !225)
!282 = !DILocation(line: 60, column: 5, scope: !225)
!283 = !DILocation(line: 61, column: 5, scope: !225)
!284 = !DILocation(line: 63, column: 1, scope: !225)
!285 = !DILocation(line: 62, column: 5, scope: !225)
!286 = distinct !DISubprogram(name: "atoi", scope: !287, file: !287, line: 361, type: !288, scopeLine: 362, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !292)
!287 = !DIFile(filename: "/usr/include/stdlib.h", directory: "")
!288 = !DISubroutineType(types: !289)
!289 = !{!17, !290}
!290 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !291, size: 64)
!291 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !20)
!292 = !{!293}
!293 = !DILocalVariable(name: "__nptr", arg: 1, scope: !286, file: !287, line: 361, type: !290)
!294 = !DILocation(line: 361, column: 1, scope: !286)
!295 = !DILocation(line: 363, column: 24, scope: !286)
!296 = !DILocation(line: 363, column: 16, scope: !286)
!297 = !DILocation(line: 363, column: 3, scope: !286)
!298 = distinct !DISubprogram(name: "register_variable<int>", linkageName: "_Z17register_variableIiEvPT_PKc", scope: !299, file: !299, line: 14, type: !300, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, templateParams: !307, retainedNodes: !303)
!299 = !DIFile(filename: "include/ExtraPInstrumenter.hpp", directory: "/home/mcopik/projects/ETH/extrap/rebuild/perf-taint")
!300 = !DISubroutineType(types: !301)
!301 = !{null, !302, !290}
!302 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !17, size: 64)
!303 = !{!304, !305, !306}
!304 = !DILocalVariable(name: "ptr", arg: 1, scope: !298, file: !299, line: 14, type: !302)
!305 = !DILocalVariable(name: "name", arg: 2, scope: !298, file: !299, line: 14, type: !290)
!306 = !DILocalVariable(name: "param_id", scope: !298, file: !299, line: 16, type: !54)
!307 = !{!308}
!308 = !DITemplateTypeParameter(name: "T", type: !17)
!309 = !DILocation(line: 14, column: 28, scope: !298)
!310 = !DILocation(line: 14, column: 46, scope: !298)
!311 = !DILocation(line: 16, column: 5, scope: !298)
!312 = !DILocation(line: 16, column: 13, scope: !298)
!313 = !DILocation(line: 16, column: 24, scope: !298)
!314 = !DILocation(line: 17, column: 57, scope: !298)
!315 = !DILocation(line: 17, column: 31, scope: !298)
!316 = !DILocation(line: 18, column: 21, scope: !298)
!317 = !DILocation(line: 18, column: 25, scope: !298)
!318 = !DILocation(line: 17, column: 5, scope: !298)
!319 = !DILocation(line: 19, column: 1, scope: !298)
