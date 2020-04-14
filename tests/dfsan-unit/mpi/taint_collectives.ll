; RUN: opt %mpidfsan -extrap-extractor-out-name=%t4 -S < %s 2> /dev/null | llc %llcparams - -o %t1 && clang++ %link %t1 -o %t2 && %execparams mpiexec -n 2 %t2 && diff -w %s.json %t4_0.json && diff -w %s.json %t4_1.json
; ModuleID = 'tests/dfsan-unit/mpi/taint_collectives.cpp'
source_filename = "tests/dfsan-unit/mpi/taint_collectives.cpp"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.ompi_predefined_datatype_t = type opaque
%struct.ompi_predefined_communicator_t = type opaque
%struct.ompi_predefined_op_t = type opaque
%struct.ompi_datatype_t = type opaque
%struct.ompi_communicator_t = type opaque
%struct.ompi_op_t = type opaque

$_Z17register_variableIiEvPT_PKc = comdat any

@ompi_mpi_int = external dso_local global %struct.ompi_predefined_datatype_t, align 1
@ompi_mpi_comm_world = external dso_local global %struct.ompi_predefined_communicator_t, align 1
@ompi_mpi_op_sum = external dso_local global %struct.ompi_predefined_op_t, align 1
@.str = private unnamed_addr constant [7 x i8] c"extrap\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [43 x i8] c"tests/dfsan-unit/mpi/taint_collectives.cpp\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [6 x i8] c"param\00", align 1
@.str.3 = private unnamed_addr constant [7 x i8] c"param2\00", align 1

; Function Attrs: uwtable
define dso_local void @_Z5bcastii(i32, i32) #0 !dbg !117 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i32 %0, i32* %3, align 4, !tbaa !125
  call void @llvm.dbg.declare(metadata i32* %3, metadata !121, metadata !DIExpression()), !dbg !129
  store i32 %1, i32* %4, align 4, !tbaa !125
  call void @llvm.dbg.declare(metadata i32* %4, metadata !122, metadata !DIExpression()), !dbg !130
  %7 = bitcast i32* %5 to i8*, !dbg !131
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %7) #5, !dbg !131
  call void @llvm.dbg.declare(metadata i32* %5, metadata !123, metadata !DIExpression()), !dbg !132
  store i32 0, i32* %5, align 4, !dbg !132, !tbaa !125
  %8 = bitcast i32* %6 to i8*, !dbg !133
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %8) #5, !dbg !133
  call void @llvm.dbg.declare(metadata i32* %6, metadata !124, metadata !DIExpression()), !dbg !134
  store i32 1, i32* %6, align 4, !dbg !134, !tbaa !125
  %9 = bitcast i32* %5 to i8*, !dbg !135
  %10 = load i32, i32* %6, align 4, !dbg !136, !tbaa !125
  %11 = call i32 @MPI_Bcast(i8* %9, i32 %10, %struct.ompi_datatype_t* bitcast (%struct.ompi_predefined_datatype_t* @ompi_mpi_int to %struct.ompi_datatype_t*), i32 0, %struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*)), !dbg !137
  %12 = bitcast i32* %5 to i8*, !dbg !138
  %13 = load i32, i32* %4, align 4, !dbg !139, !tbaa !125
  %14 = call i32 @MPI_Bcast(i8* %12, i32 %13, %struct.ompi_datatype_t* bitcast (%struct.ompi_predefined_datatype_t* @ompi_mpi_int to %struct.ompi_datatype_t*), i32 1, %struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*)), !dbg !140
  %15 = bitcast i32* %6 to i8*, !dbg !141
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %15) #5, !dbg !141
  %16 = bitcast i32* %5 to i8*, !dbg !141
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %16) #5, !dbg !141
  ret void, !dbg !141
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #2

declare dso_local i32 @MPI_Bcast(i8*, i32, %struct.ompi_datatype_t*, i32, %struct.ompi_communicator_t*) #3

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: uwtable
define dso_local void @_Z8alltoalliii(i32, i32, i32) #0 !dbg !142 {
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca [2 x i32], align 4
  %8 = alloca [2 x i32], align 4
  %9 = alloca i32, align 4
  store i32 %0, i32* %4, align 4, !tbaa !125
  call void @llvm.dbg.declare(metadata i32* %4, metadata !146, metadata !DIExpression()), !dbg !155
  store i32 %1, i32* %5, align 4, !tbaa !125
  call void @llvm.dbg.declare(metadata i32* %5, metadata !147, metadata !DIExpression()), !dbg !156
  store i32 %2, i32* %6, align 4, !tbaa !125
  call void @llvm.dbg.declare(metadata i32* %6, metadata !148, metadata !DIExpression()), !dbg !157
  %10 = bitcast [2 x i32]* %7 to i8*, !dbg !158
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %10) #5, !dbg !158
  call void @llvm.dbg.declare(metadata [2 x i32]* %7, metadata !149, metadata !DIExpression()), !dbg !159
  %11 = bitcast [2 x i32]* %7 to i8*, !dbg !159
  call void @llvm.memset.p0i8.i64(i8* align 4 %11, i8 0, i64 8, i1 false), !dbg !159
  %12 = bitcast [2 x i32]* %8 to i8*, !dbg !160
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %12) #5, !dbg !160
  call void @llvm.dbg.declare(metadata [2 x i32]* %8, metadata !153, metadata !DIExpression()), !dbg !161
  %13 = bitcast [2 x i32]* %8 to i8*, !dbg !161
  call void @llvm.memset.p0i8.i64(i8* align 4 %13, i8 0, i64 8, i1 false), !dbg !161
  %14 = bitcast i32* %9 to i8*, !dbg !162
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %14) #5, !dbg !162
  call void @llvm.dbg.declare(metadata i32* %9, metadata !154, metadata !DIExpression()), !dbg !163
  store i32 2, i32* %9, align 4, !dbg !163, !tbaa !125
  %15 = getelementptr inbounds [2 x i32], [2 x i32]* %7, i64 0, i64 0, !dbg !164
  %16 = bitcast i32* %15 to i8*, !dbg !164
  %17 = load i32, i32* %9, align 4, !dbg !165, !tbaa !125
  %18 = getelementptr inbounds [2 x i32], [2 x i32]* %8, i64 0, i64 0, !dbg !166
  %19 = bitcast i32* %18 to i8*, !dbg !166
  %20 = load i32, i32* %9, align 4, !dbg !167, !tbaa !125
  %21 = call i32 @MPI_Alltoall(i8* %16, i32 %17, %struct.ompi_datatype_t* bitcast (%struct.ompi_predefined_datatype_t* @ompi_mpi_int to %struct.ompi_datatype_t*), i8* %19, i32 %20, %struct.ompi_datatype_t* bitcast (%struct.ompi_predefined_datatype_t* @ompi_mpi_int to %struct.ompi_datatype_t*), %struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*)), !dbg !168
  %22 = getelementptr inbounds [2 x i32], [2 x i32]* %7, i64 0, i64 0, !dbg !169
  %23 = bitcast i32* %22 to i8*, !dbg !169
  %24 = load i32, i32* %5, align 4, !dbg !170, !tbaa !125
  %25 = add nsw i32 %24, 1, !dbg !171
  %26 = getelementptr inbounds [2 x i32], [2 x i32]* %8, i64 0, i64 0, !dbg !172
  %27 = bitcast i32* %26 to i8*, !dbg !172
  %28 = load i32, i32* %9, align 4, !dbg !173, !tbaa !125
  %29 = call i32 @MPI_Alltoall(i8* %23, i32 %25, %struct.ompi_datatype_t* bitcast (%struct.ompi_predefined_datatype_t* @ompi_mpi_int to %struct.ompi_datatype_t*), i8* %27, i32 %28, %struct.ompi_datatype_t* bitcast (%struct.ompi_predefined_datatype_t* @ompi_mpi_int to %struct.ompi_datatype_t*), %struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*)), !dbg !174
  %30 = getelementptr inbounds [2 x i32], [2 x i32]* %7, i64 0, i64 0, !dbg !175
  %31 = bitcast i32* %30 to i8*, !dbg !175
  %32 = load i32, i32* %9, align 4, !dbg !176, !tbaa !125
  %33 = getelementptr inbounds [2 x i32], [2 x i32]* %8, i64 0, i64 0, !dbg !177
  %34 = bitcast i32* %33 to i8*, !dbg !177
  %35 = load i32, i32* %6, align 4, !dbg !178, !tbaa !125
  %36 = add nsw i32 %35, 1, !dbg !179
  %37 = call i32 @MPI_Alltoall(i8* %31, i32 %32, %struct.ompi_datatype_t* bitcast (%struct.ompi_predefined_datatype_t* @ompi_mpi_int to %struct.ompi_datatype_t*), i8* %34, i32 %36, %struct.ompi_datatype_t* bitcast (%struct.ompi_predefined_datatype_t* @ompi_mpi_int to %struct.ompi_datatype_t*), %struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*)), !dbg !180
  %38 = getelementptr inbounds [2 x i32], [2 x i32]* %7, i64 0, i64 0, !dbg !181
  %39 = bitcast i32* %38 to i8*, !dbg !181
  %40 = load i32, i32* %5, align 4, !dbg !182, !tbaa !125
  %41 = add nsw i32 %40, 1, !dbg !183
  %42 = getelementptr inbounds [2 x i32], [2 x i32]* %8, i64 0, i64 0, !dbg !184
  %43 = bitcast i32* %42 to i8*, !dbg !184
  %44 = load i32, i32* %6, align 4, !dbg !185, !tbaa !125
  %45 = add nsw i32 %44, 1, !dbg !186
  %46 = call i32 @MPI_Alltoall(i8* %39, i32 %41, %struct.ompi_datatype_t* bitcast (%struct.ompi_predefined_datatype_t* @ompi_mpi_int to %struct.ompi_datatype_t*), i8* %43, i32 %45, %struct.ompi_datatype_t* bitcast (%struct.ompi_predefined_datatype_t* @ompi_mpi_int to %struct.ompi_datatype_t*), %struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*)), !dbg !187
  %47 = bitcast i32* %9 to i8*, !dbg !188
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %47) #5, !dbg !188
  %48 = bitcast [2 x i32]* %8 to i8*, !dbg !188
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %48) #5, !dbg !188
  %49 = bitcast [2 x i32]* %7 to i8*, !dbg !188
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %49) #5, !dbg !188
  ret void, !dbg !188
}

; Function Attrs: argmemonly nounwind
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #2

declare dso_local i32 @MPI_Alltoall(i8*, i32, %struct.ompi_datatype_t*, i8*, i32, %struct.ompi_datatype_t*, %struct.ompi_communicator_t*) #3

; Function Attrs: uwtable
define dso_local void @_Z9allgatheriii(i32, i32, i32) #0 !dbg !189 {
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca [1 x i32], align 4
  %8 = alloca [4 x i32], align 16
  %9 = alloca i32, align 4
  store i32 %0, i32* %4, align 4, !tbaa !125
  call void @llvm.dbg.declare(metadata i32* %4, metadata !191, metadata !DIExpression()), !dbg !203
  store i32 %1, i32* %5, align 4, !tbaa !125
  call void @llvm.dbg.declare(metadata i32* %5, metadata !192, metadata !DIExpression()), !dbg !204
  store i32 %2, i32* %6, align 4, !tbaa !125
  call void @llvm.dbg.declare(metadata i32* %6, metadata !193, metadata !DIExpression()), !dbg !205
  %10 = bitcast [1 x i32]* %7 to i8*, !dbg !206
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %10) #5, !dbg !206
  call void @llvm.dbg.declare(metadata [1 x i32]* %7, metadata !194, metadata !DIExpression()), !dbg !207
  %11 = bitcast [1 x i32]* %7 to i8*, !dbg !207
  call void @llvm.memset.p0i8.i64(i8* align 4 %11, i8 0, i64 4, i1 false), !dbg !207
  %12 = bitcast [4 x i32]* %8 to i8*, !dbg !208
  call void @llvm.lifetime.start.p0i8(i64 16, i8* %12) #5, !dbg !208
  call void @llvm.dbg.declare(metadata [4 x i32]* %8, metadata !198, metadata !DIExpression()), !dbg !209
  %13 = bitcast [4 x i32]* %8 to i8*, !dbg !209
  call void @llvm.memset.p0i8.i64(i8* align 16 %13, i8 0, i64 16, i1 false), !dbg !209
  %14 = bitcast i32* %9 to i8*, !dbg !210
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %14) #5, !dbg !210
  call void @llvm.dbg.declare(metadata i32* %9, metadata !202, metadata !DIExpression()), !dbg !211
  store i32 1, i32* %9, align 4, !dbg !211, !tbaa !125
  %15 = getelementptr inbounds [1 x i32], [1 x i32]* %7, i64 0, i64 0, !dbg !212
  %16 = bitcast i32* %15 to i8*, !dbg !212
  %17 = load i32, i32* %9, align 4, !dbg !213, !tbaa !125
  %18 = getelementptr inbounds [4 x i32], [4 x i32]* %8, i64 0, i64 0, !dbg !214
  %19 = bitcast i32* %18 to i8*, !dbg !214
  %20 = load i32, i32* %9, align 4, !dbg !215, !tbaa !125
  %21 = call i32 @MPI_Allgather(i8* %16, i32 %17, %struct.ompi_datatype_t* bitcast (%struct.ompi_predefined_datatype_t* @ompi_mpi_int to %struct.ompi_datatype_t*), i8* %19, i32 %20, %struct.ompi_datatype_t* bitcast (%struct.ompi_predefined_datatype_t* @ompi_mpi_int to %struct.ompi_datatype_t*), %struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*)), !dbg !216
  %22 = getelementptr inbounds [1 x i32], [1 x i32]* %7, i64 0, i64 0, !dbg !217
  %23 = bitcast i32* %22 to i8*, !dbg !217
  %24 = load i32, i32* %5, align 4, !dbg !218, !tbaa !125
  %25 = getelementptr inbounds [4 x i32], [4 x i32]* %8, i64 0, i64 0, !dbg !219
  %26 = bitcast i32* %25 to i8*, !dbg !219
  %27 = load i32, i32* %9, align 4, !dbg !220, !tbaa !125
  %28 = call i32 @MPI_Allgather(i8* %23, i32 %24, %struct.ompi_datatype_t* bitcast (%struct.ompi_predefined_datatype_t* @ompi_mpi_int to %struct.ompi_datatype_t*), i8* %26, i32 %27, %struct.ompi_datatype_t* bitcast (%struct.ompi_predefined_datatype_t* @ompi_mpi_int to %struct.ompi_datatype_t*), %struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*)), !dbg !221
  %29 = getelementptr inbounds [1 x i32], [1 x i32]* %7, i64 0, i64 0, !dbg !222
  %30 = bitcast i32* %29 to i8*, !dbg !222
  %31 = load i32, i32* %9, align 4, !dbg !223, !tbaa !125
  %32 = getelementptr inbounds [4 x i32], [4 x i32]* %8, i64 0, i64 0, !dbg !224
  %33 = bitcast i32* %32 to i8*, !dbg !224
  %34 = load i32, i32* %6, align 4, !dbg !225, !tbaa !125
  %35 = call i32 @MPI_Allgather(i8* %30, i32 %31, %struct.ompi_datatype_t* bitcast (%struct.ompi_predefined_datatype_t* @ompi_mpi_int to %struct.ompi_datatype_t*), i8* %33, i32 %34, %struct.ompi_datatype_t* bitcast (%struct.ompi_predefined_datatype_t* @ompi_mpi_int to %struct.ompi_datatype_t*), %struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*)), !dbg !226
  %36 = getelementptr inbounds [1 x i32], [1 x i32]* %7, i64 0, i64 0, !dbg !227
  %37 = bitcast i32* %36 to i8*, !dbg !227
  %38 = load i32, i32* %5, align 4, !dbg !228, !tbaa !125
  %39 = getelementptr inbounds [4 x i32], [4 x i32]* %8, i64 0, i64 0, !dbg !229
  %40 = bitcast i32* %39 to i8*, !dbg !229
  %41 = load i32, i32* %6, align 4, !dbg !230, !tbaa !125
  %42 = call i32 @MPI_Allgather(i8* %37, i32 %38, %struct.ompi_datatype_t* bitcast (%struct.ompi_predefined_datatype_t* @ompi_mpi_int to %struct.ompi_datatype_t*), i8* %40, i32 %41, %struct.ompi_datatype_t* bitcast (%struct.ompi_predefined_datatype_t* @ompi_mpi_int to %struct.ompi_datatype_t*), %struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*)), !dbg !231
  %43 = bitcast i32* %9 to i8*, !dbg !232
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %43) #5, !dbg !232
  %44 = bitcast [4 x i32]* %8 to i8*, !dbg !232
  call void @llvm.lifetime.end.p0i8(i64 16, i8* %44) #5, !dbg !232
  %45 = bitcast [1 x i32]* %7 to i8*, !dbg !232
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %45) #5, !dbg !232
  ret void, !dbg !232
}

declare dso_local i32 @MPI_Allgather(i8*, i32, %struct.ompi_datatype_t*, i8*, i32, %struct.ompi_datatype_t*, %struct.ompi_communicator_t*) #3

; Function Attrs: uwtable
define dso_local void @_Z4scanii(i32, i32) #0 !dbg !233 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca [1 x i32], align 4
  %6 = alloca [1 x i32], align 4
  %7 = alloca i32, align 4
  store i32 %0, i32* %3, align 4, !tbaa !125
  call void @llvm.dbg.declare(metadata i32* %3, metadata !235, metadata !DIExpression()), !dbg !240
  store i32 %1, i32* %4, align 4, !tbaa !125
  call void @llvm.dbg.declare(metadata i32* %4, metadata !236, metadata !DIExpression()), !dbg !241
  %8 = bitcast [1 x i32]* %5 to i8*, !dbg !242
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %8) #5, !dbg !242
  call void @llvm.dbg.declare(metadata [1 x i32]* %5, metadata !237, metadata !DIExpression()), !dbg !243
  %9 = bitcast [1 x i32]* %5 to i8*, !dbg !243
  call void @llvm.memset.p0i8.i64(i8* align 4 %9, i8 0, i64 4, i1 false), !dbg !243
  %10 = bitcast [1 x i32]* %6 to i8*, !dbg !244
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %10) #5, !dbg !244
  call void @llvm.dbg.declare(metadata [1 x i32]* %6, metadata !238, metadata !DIExpression()), !dbg !245
  %11 = bitcast [1 x i32]* %6 to i8*, !dbg !245
  call void @llvm.memset.p0i8.i64(i8* align 4 %11, i8 0, i64 4, i1 false), !dbg !245
  %12 = bitcast i32* %7 to i8*, !dbg !246
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %12) #5, !dbg !246
  call void @llvm.dbg.declare(metadata i32* %7, metadata !239, metadata !DIExpression()), !dbg !247
  store i32 1, i32* %7, align 4, !dbg !247, !tbaa !125
  %13 = getelementptr inbounds [1 x i32], [1 x i32]* %5, i64 0, i64 0, !dbg !248
  %14 = bitcast i32* %13 to i8*, !dbg !248
  %15 = getelementptr inbounds [1 x i32], [1 x i32]* %6, i64 0, i64 0, !dbg !249
  %16 = bitcast i32* %15 to i8*, !dbg !249
  %17 = load i32, i32* %7, align 4, !dbg !250, !tbaa !125
  %18 = call i32 @MPI_Scan(i8* %14, i8* %16, i32 %17, %struct.ompi_datatype_t* bitcast (%struct.ompi_predefined_datatype_t* @ompi_mpi_int to %struct.ompi_datatype_t*), %struct.ompi_op_t* bitcast (%struct.ompi_predefined_op_t* @ompi_mpi_op_sum to %struct.ompi_op_t*), %struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*)), !dbg !251
  %19 = getelementptr inbounds [1 x i32], [1 x i32]* %5, i64 0, i64 0, !dbg !252
  %20 = bitcast i32* %19 to i8*, !dbg !252
  %21 = getelementptr inbounds [1 x i32], [1 x i32]* %6, i64 0, i64 0, !dbg !253
  %22 = bitcast i32* %21 to i8*, !dbg !253
  %23 = load i32, i32* %4, align 4, !dbg !254, !tbaa !125
  %24 = call i32 @MPI_Scan(i8* %20, i8* %22, i32 %23, %struct.ompi_datatype_t* bitcast (%struct.ompi_predefined_datatype_t* @ompi_mpi_int to %struct.ompi_datatype_t*), %struct.ompi_op_t* bitcast (%struct.ompi_predefined_op_t* @ompi_mpi_op_sum to %struct.ompi_op_t*), %struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*)), !dbg !255
  %25 = bitcast i32* %7 to i8*, !dbg !256
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %25) #5, !dbg !256
  %26 = bitcast [1 x i32]* %6 to i8*, !dbg !256
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %26) #5, !dbg !256
  %27 = bitcast [1 x i32]* %5 to i8*, !dbg !256
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %27) #5, !dbg !256
  ret void, !dbg !256
}

declare dso_local i32 @MPI_Scan(i8*, i8*, i32, %struct.ompi_datatype_t*, %struct.ompi_op_t*, %struct.ompi_communicator_t*) #3

; Function Attrs: uwtable
define dso_local void @_Z6reduceii(i32, i32) #0 !dbg !257 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca [1 x i32], align 4
  %6 = alloca [1 x i32], align 4
  %7 = alloca i32, align 4
  store i32 %0, i32* %3, align 4, !tbaa !125
  call void @llvm.dbg.declare(metadata i32* %3, metadata !259, metadata !DIExpression()), !dbg !264
  store i32 %1, i32* %4, align 4, !tbaa !125
  call void @llvm.dbg.declare(metadata i32* %4, metadata !260, metadata !DIExpression()), !dbg !265
  %8 = bitcast [1 x i32]* %5 to i8*, !dbg !266
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %8) #5, !dbg !266
  call void @llvm.dbg.declare(metadata [1 x i32]* %5, metadata !261, metadata !DIExpression()), !dbg !267
  %9 = bitcast [1 x i32]* %5 to i8*, !dbg !267
  call void @llvm.memset.p0i8.i64(i8* align 4 %9, i8 0, i64 4, i1 false), !dbg !267
  %10 = bitcast [1 x i32]* %6 to i8*, !dbg !268
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %10) #5, !dbg !268
  call void @llvm.dbg.declare(metadata [1 x i32]* %6, metadata !262, metadata !DIExpression()), !dbg !269
  %11 = bitcast [1 x i32]* %6 to i8*, !dbg !269
  call void @llvm.memset.p0i8.i64(i8* align 4 %11, i8 0, i64 4, i1 false), !dbg !269
  %12 = bitcast i32* %7 to i8*, !dbg !270
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %12) #5, !dbg !270
  call void @llvm.dbg.declare(metadata i32* %7, metadata !263, metadata !DIExpression()), !dbg !271
  store i32 1, i32* %7, align 4, !dbg !271, !tbaa !125
  %13 = getelementptr inbounds [1 x i32], [1 x i32]* %5, i64 0, i64 0, !dbg !272
  %14 = bitcast i32* %13 to i8*, !dbg !272
  %15 = getelementptr inbounds [1 x i32], [1 x i32]* %6, i64 0, i64 0, !dbg !273
  %16 = bitcast i32* %15 to i8*, !dbg !273
  %17 = load i32, i32* %7, align 4, !dbg !274, !tbaa !125
  %18 = call i32 @MPI_Reduce(i8* %14, i8* %16, i32 %17, %struct.ompi_datatype_t* bitcast (%struct.ompi_predefined_datatype_t* @ompi_mpi_int to %struct.ompi_datatype_t*), %struct.ompi_op_t* bitcast (%struct.ompi_predefined_op_t* @ompi_mpi_op_sum to %struct.ompi_op_t*), i32 0, %struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*)), !dbg !275
  %19 = getelementptr inbounds [1 x i32], [1 x i32]* %5, i64 0, i64 0, !dbg !276
  %20 = bitcast i32* %19 to i8*, !dbg !276
  %21 = getelementptr inbounds [1 x i32], [1 x i32]* %6, i64 0, i64 0, !dbg !277
  %22 = bitcast i32* %21 to i8*, !dbg !277
  %23 = load i32, i32* %4, align 4, !dbg !278, !tbaa !125
  %24 = call i32 @MPI_Reduce(i8* %20, i8* %22, i32 %23, %struct.ompi_datatype_t* bitcast (%struct.ompi_predefined_datatype_t* @ompi_mpi_int to %struct.ompi_datatype_t*), %struct.ompi_op_t* bitcast (%struct.ompi_predefined_op_t* @ompi_mpi_op_sum to %struct.ompi_op_t*), i32 0, %struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*)), !dbg !279
  %25 = bitcast i32* %7 to i8*, !dbg !280
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %25) #5, !dbg !280
  %26 = bitcast [1 x i32]* %6 to i8*, !dbg !280
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %26) #5, !dbg !280
  %27 = bitcast [1 x i32]* %5 to i8*, !dbg !280
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %27) #5, !dbg !280
  ret void, !dbg !280
}

declare dso_local i32 @MPI_Reduce(i8*, i8*, i32, %struct.ompi_datatype_t*, %struct.ompi_op_t*, i32, %struct.ompi_communicator_t*) #3

; Function Attrs: uwtable
define dso_local void @_Z9allreduceii(i32, i32) #0 !dbg !281 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca [1 x i32], align 4
  %6 = alloca [2 x i32], align 4
  %7 = alloca i32, align 4
  store i32 %0, i32* %3, align 4, !tbaa !125
  call void @llvm.dbg.declare(metadata i32* %3, metadata !283, metadata !DIExpression()), !dbg !288
  store i32 %1, i32* %4, align 4, !tbaa !125
  call void @llvm.dbg.declare(metadata i32* %4, metadata !284, metadata !DIExpression()), !dbg !289
  %8 = bitcast [1 x i32]* %5 to i8*, !dbg !290
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %8) #5, !dbg !290
  call void @llvm.dbg.declare(metadata [1 x i32]* %5, metadata !285, metadata !DIExpression()), !dbg !291
  %9 = bitcast [1 x i32]* %5 to i8*, !dbg !291
  call void @llvm.memset.p0i8.i64(i8* align 4 %9, i8 0, i64 4, i1 false), !dbg !291
  %10 = bitcast [2 x i32]* %6 to i8*, !dbg !292
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %10) #5, !dbg !292
  call void @llvm.dbg.declare(metadata [2 x i32]* %6, metadata !286, metadata !DIExpression()), !dbg !293
  %11 = bitcast [2 x i32]* %6 to i8*, !dbg !293
  call void @llvm.memset.p0i8.i64(i8* align 4 %11, i8 0, i64 8, i1 false), !dbg !293
  %12 = bitcast i32* %7 to i8*, !dbg !294
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %12) #5, !dbg !294
  call void @llvm.dbg.declare(metadata i32* %7, metadata !287, metadata !DIExpression()), !dbg !295
  store i32 1, i32* %7, align 4, !dbg !295, !tbaa !125
  %13 = getelementptr inbounds [1 x i32], [1 x i32]* %5, i64 0, i64 0, !dbg !296
  %14 = bitcast i32* %13 to i8*, !dbg !296
  %15 = getelementptr inbounds [2 x i32], [2 x i32]* %6, i64 0, i64 0, !dbg !297
  %16 = bitcast i32* %15 to i8*, !dbg !297
  %17 = load i32, i32* %7, align 4, !dbg !298, !tbaa !125
  %18 = call i32 @MPI_Allreduce(i8* %14, i8* %16, i32 %17, %struct.ompi_datatype_t* bitcast (%struct.ompi_predefined_datatype_t* @ompi_mpi_int to %struct.ompi_datatype_t*), %struct.ompi_op_t* bitcast (%struct.ompi_predefined_op_t* @ompi_mpi_op_sum to %struct.ompi_op_t*), %struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*)), !dbg !299
  %19 = getelementptr inbounds [1 x i32], [1 x i32]* %5, i64 0, i64 0, !dbg !300
  %20 = bitcast i32* %19 to i8*, !dbg !300
  %21 = getelementptr inbounds [2 x i32], [2 x i32]* %6, i64 0, i64 0, !dbg !301
  %22 = bitcast i32* %21 to i8*, !dbg !301
  %23 = load i32, i32* %4, align 4, !dbg !302, !tbaa !125
  %24 = call i32 @MPI_Allreduce(i8* %20, i8* %22, i32 %23, %struct.ompi_datatype_t* bitcast (%struct.ompi_predefined_datatype_t* @ompi_mpi_int to %struct.ompi_datatype_t*), %struct.ompi_op_t* bitcast (%struct.ompi_predefined_op_t* @ompi_mpi_op_sum to %struct.ompi_op_t*), %struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*)), !dbg !303
  %25 = bitcast i32* %7 to i8*, !dbg !304
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %25) #5, !dbg !304
  %26 = bitcast [2 x i32]* %6 to i8*, !dbg !304
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %26) #5, !dbg !304
  %27 = bitcast [1 x i32]* %5 to i8*, !dbg !304
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %27) #5, !dbg !304
  ret void, !dbg !304
}

declare dso_local i32 @MPI_Allreduce(i8*, i8*, i32, %struct.ompi_datatype_t*, %struct.ompi_op_t*, %struct.ompi_communicator_t*) #3

; Function Attrs: norecurse uwtable
define dso_local i32 @main(i32, i8**) #4 !dbg !305 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4, !tbaa !125
  call void @llvm.dbg.declare(metadata i32* %4, metadata !312, metadata !DIExpression()), !dbg !318
  store i8** %1, i8*** %5, align 8, !tbaa !319
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !313, metadata !DIExpression()), !dbg !321
  %10 = bitcast i32* %6 to i8*, !dbg !322
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %10) #5, !dbg !322
  call void @llvm.dbg.declare(metadata i32* %6, metadata !314, metadata !DIExpression()), !dbg !323
  %11 = bitcast i32* %6 to i8*, !dbg !322
  call void @llvm.var.annotation(i8* %11, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([43 x i8], [43 x i8]* @.str.1, i32 0, i32 0), i32 90), !dbg !322
  store i32 1, i32* %6, align 4, !dbg !323, !tbaa !125
  %12 = bitcast i32* %7 to i8*, !dbg !322
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %12) #5, !dbg !322
  call void @llvm.dbg.declare(metadata i32* %7, metadata !315, metadata !DIExpression()), !dbg !324
  %13 = bitcast i32* %7 to i8*, !dbg !322
  call void @llvm.var.annotation(i8* %13, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([43 x i8], [43 x i8]* @.str.1, i32 0, i32 0), i32 90), !dbg !322
  store i32 1, i32* %7, align 4, !dbg !324, !tbaa !125
  %14 = call i32 @MPI_Init(i32* %4, i8*** %5), !dbg !325
  %15 = bitcast i32* %8 to i8*, !dbg !326
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %15) #5, !dbg !326
  call void @llvm.dbg.declare(metadata i32* %8, metadata !316, metadata !DIExpression()), !dbg !327
  %16 = bitcast i32* %9 to i8*, !dbg !326
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %16) #5, !dbg !326
  call void @llvm.dbg.declare(metadata i32* %9, metadata !317, metadata !DIExpression()), !dbg !328
  %17 = call i32 @MPI_Comm_size(%struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*), i32* %8), !dbg !329
  %18 = call i32 @MPI_Comm_rank(%struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*), i32* %9), !dbg !330
  call void @_Z17register_variableIiEvPT_PKc(i32* %6, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.2, i64 0, i64 0)), !dbg !331
  call void @_Z17register_variableIiEvPT_PKc(i32* %7, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.3, i64 0, i64 0)), !dbg !332
  %19 = load i32, i32* %9, align 4, !dbg !333, !tbaa !125
  %20 = load i32, i32* %6, align 4, !dbg !334, !tbaa !125
  call void @_Z5bcastii(i32 %19, i32 %20), !dbg !335
  %21 = load i32, i32* %9, align 4, !dbg !336, !tbaa !125
  %22 = load i32, i32* %6, align 4, !dbg !337, !tbaa !125
  %23 = load i32, i32* %7, align 4, !dbg !338, !tbaa !125
  call void @_Z8alltoalliii(i32 %21, i32 %22, i32 %23), !dbg !339
  %24 = load i32, i32* %9, align 4, !dbg !340, !tbaa !125
  %25 = load i32, i32* %6, align 4, !dbg !341, !tbaa !125
  %26 = load i32, i32* %7, align 4, !dbg !342, !tbaa !125
  call void @_Z9allgatheriii(i32 %24, i32 %25, i32 %26), !dbg !343
  %27 = load i32, i32* %9, align 4, !dbg !344, !tbaa !125
  %28 = load i32, i32* %6, align 4, !dbg !345, !tbaa !125
  call void @_Z4scanii(i32 %27, i32 %28), !dbg !346
  %29 = load i32, i32* %9, align 4, !dbg !347, !tbaa !125
  %30 = load i32, i32* %6, align 4, !dbg !348, !tbaa !125
  call void @_Z6reduceii(i32 %29, i32 %30), !dbg !349
  %31 = load i32, i32* %9, align 4, !dbg !350, !tbaa !125
  %32 = load i32, i32* %6, align 4, !dbg !351, !tbaa !125
  call void @_Z9allreduceii(i32 %31, i32 %32), !dbg !352
  %33 = call i32 @MPI_Finalize(), !dbg !353
  %34 = bitcast i32* %9 to i8*, !dbg !354
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %34) #5, !dbg !354
  %35 = bitcast i32* %8 to i8*, !dbg !354
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %35) #5, !dbg !354
  %36 = bitcast i32* %7 to i8*, !dbg !354
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %36) #5, !dbg !354
  %37 = bitcast i32* %6 to i8*, !dbg !354
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %37) #5, !dbg !354
  ret i32 0, !dbg !355
}

; Function Attrs: nounwind
declare void @llvm.var.annotation(i8*, i8*, i8*, i32) #5

declare dso_local i32 @MPI_Init(i32*, i8***) #3

declare dso_local i32 @MPI_Comm_size(%struct.ompi_communicator_t*, i32*) #3

declare dso_local i32 @MPI_Comm_rank(%struct.ompi_communicator_t*, i32*) #3

; Function Attrs: uwtable
define linkonce_odr dso_local void @_Z17register_variableIiEvPT_PKc(i32*, i8*) #0 comdat !dbg !356 {
  %3 = alloca i32*, align 8
  %4 = alloca i8*, align 8
  store i32* %0, i32** %3, align 8, !tbaa !319
  call void @llvm.dbg.declare(metadata i32** %3, metadata !364, metadata !DIExpression()), !dbg !368
  store i8* %1, i8** %4, align 8, !tbaa !319
  call void @llvm.dbg.declare(metadata i8** %4, metadata !365, metadata !DIExpression()), !dbg !369
  %5 = load i32*, i32** %3, align 8, !dbg !370, !tbaa !319
  %6 = bitcast i32* %5 to i8*, !dbg !371
  %7 = load i8*, i8** %4, align 8, !dbg !372, !tbaa !319
  call void @__dfsw_EXTRAP_WRITE_LABEL(i8* %6, i32 4, i8* %7), !dbg !373
  ret void, !dbg !374
}

declare dso_local i32 @MPI_Finalize() #3

declare dso_local void @__dfsw_EXTRAP_WRITE_LABEL(i8*, i32, i8*) #3

attributes #0 = { uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { argmemonly nounwind }
attributes #3 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { norecurse uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!113, !114, !115}
!llvm.ident = !{!116}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !1, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !3, imports: !21, nameTableKind: None)
!1 = !DIFile(filename: "tests/dfsan-unit/mpi/taint_collectives.cpp", directory: "/home/mcopik/projects/ETH/extrap/rebuild/perf-taint")
!2 = !{}
!3 = !{!4, !8, !9, !12, !15}
!4 = !DIDerivedType(tag: DW_TAG_typedef, name: "MPI_Datatype", file: !5, line: 331, baseType: !6)
!5 = !DIFile(filename: "/usr/lib/x86_64-linux-gnu/openmpi/include/mpi.h", directory: "")
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!7 = !DICompositeType(tag: DW_TAG_structure_type, name: "ompi_datatype_t", file: !5, line: 331, flags: DIFlagFwdDecl, identifier: "_ZTS15ompi_datatype_t")
!8 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!9 = !DIDerivedType(tag: DW_TAG_typedef, name: "MPI_Comm", file: !5, line: 330, baseType: !10)
!10 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !11, size: 64)
!11 = !DICompositeType(tag: DW_TAG_structure_type, name: "ompi_communicator_t", file: !5, line: 330, flags: DIFlagFwdDecl, identifier: "_ZTS19ompi_communicator_t")
!12 = !DIDerivedType(tag: DW_TAG_typedef, name: "MPI_Op", file: !5, line: 338, baseType: !13)
!13 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !14, size: 64)
!14 = !DICompositeType(tag: DW_TAG_structure_type, name: "ompi_op_t", file: !5, line: 338, flags: DIFlagFwdDecl, identifier: "_ZTS9ompi_op_t")
!15 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !16, size: 64)
!16 = !DIDerivedType(tag: DW_TAG_typedef, name: "int8_t", file: !17, line: 24, baseType: !18)
!17 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-intn.h", directory: "")
!18 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int8_t", file: !19, line: 36, baseType: !20)
!19 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "")
!20 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!21 = !{!22, !29, !32, !36, !41, !43, !47, !51, !54, !59, !63, !67, !70, !73, !75, !77, !79, !81, !83, !85, !87, !89, !91, !93, !95, !97, !99, !101, !103, !105, !107, !110}
!22 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !23, entity: !25, file: !28, line: 49)
!23 = !DINamespace(name: "__1", scope: !24, exportSymbols: true)
!24 = !DINamespace(name: "std", scope: null)
!25 = !DIDerivedType(tag: DW_TAG_typedef, name: "ptrdiff_t", file: !26, line: 35, baseType: !27)
!26 = !DIFile(filename: "clang_llvm/llvm-9.0/build-9.0/lib/clang/9.0.0/include/stddef.h", directory: "/home/mcopik/projects")
!27 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!28 = !DIFile(filename: "build_tool/../usr/include/c++/v1/cstddef", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!29 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !23, entity: !30, file: !28, line: 50)
!30 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !26, line: 46, baseType: !31)
!31 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!32 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !23, entity: !33, file: !28, line: 55)
!33 = !DIDerivedType(tag: DW_TAG_typedef, name: "max_align_t", file: !34, line: 24, baseType: !35)
!34 = !DIFile(filename: "clang_llvm/llvm-9.0/build-9.0/lib/clang/9.0.0/include/__stddef_max_align_t.h", directory: "/home/mcopik/projects")
!35 = !DICompositeType(tag: DW_TAG_structure_type, file: !34, line: 19, flags: DIFlagFwdDecl, identifier: "_ZTS11max_align_t")
!36 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !0, entity: !37, file: !40, line: 51)
!37 = !DIDerivedType(tag: DW_TAG_typedef, name: "nullptr_t", scope: !24, file: !38, line: 56, baseType: !39)
!38 = !DIFile(filename: "build_tool/../usr/include/c++/v1/__nullptr", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!39 = !DIBasicType(tag: DW_TAG_unspecified_type, name: "decltype(nullptr)")
!40 = !DIFile(filename: "build_tool/../usr/include/c++/v1/stddef.h", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!41 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !23, entity: !16, file: !42, line: 152)
!42 = !DIFile(filename: "build_tool/../usr/include/c++/v1/cstdint", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!43 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !23, entity: !44, file: !42, line: 153)
!44 = !DIDerivedType(tag: DW_TAG_typedef, name: "int16_t", file: !17, line: 25, baseType: !45)
!45 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int16_t", file: !19, line: 38, baseType: !46)
!46 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!47 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !23, entity: !48, file: !42, line: 154)
!48 = !DIDerivedType(tag: DW_TAG_typedef, name: "int32_t", file: !17, line: 26, baseType: !49)
!49 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int32_t", file: !19, line: 40, baseType: !50)
!50 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!51 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !23, entity: !52, file: !42, line: 155)
!52 = !DIDerivedType(tag: DW_TAG_typedef, name: "int64_t", file: !17, line: 27, baseType: !53)
!53 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int64_t", file: !19, line: 43, baseType: !27)
!54 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !23, entity: !55, file: !42, line: 157)
!55 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint8_t", file: !56, line: 24, baseType: !57)
!56 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "")
!57 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint8_t", file: !19, line: 37, baseType: !58)
!58 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!59 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !23, entity: !60, file: !42, line: 158)
!60 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint16_t", file: !56, line: 25, baseType: !61)
!61 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint16_t", file: !19, line: 39, baseType: !62)
!62 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!63 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !23, entity: !64, file: !42, line: 159)
!64 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !56, line: 26, baseType: !65)
!65 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !19, line: 41, baseType: !66)
!66 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!67 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !23, entity: !68, file: !42, line: 160)
!68 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", file: !56, line: 27, baseType: !69)
!69 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint64_t", file: !19, line: 44, baseType: !31)
!70 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !23, entity: !71, file: !42, line: 162)
!71 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least8_t", file: !72, line: 43, baseType: !20)
!72 = !DIFile(filename: "/usr/include/stdint.h", directory: "")
!73 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !23, entity: !74, file: !42, line: 163)
!74 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least16_t", file: !72, line: 44, baseType: !46)
!75 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !23, entity: !76, file: !42, line: 164)
!76 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least32_t", file: !72, line: 45, baseType: !50)
!77 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !23, entity: !78, file: !42, line: 165)
!78 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least64_t", file: !72, line: 47, baseType: !27)
!79 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !23, entity: !80, file: !42, line: 167)
!80 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least8_t", file: !72, line: 54, baseType: !58)
!81 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !23, entity: !82, file: !42, line: 168)
!82 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least16_t", file: !72, line: 55, baseType: !62)
!83 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !23, entity: !84, file: !42, line: 169)
!84 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least32_t", file: !72, line: 56, baseType: !66)
!85 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !23, entity: !86, file: !42, line: 170)
!86 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least64_t", file: !72, line: 58, baseType: !31)
!87 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !23, entity: !88, file: !42, line: 172)
!88 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast8_t", file: !72, line: 68, baseType: !20)
!89 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !23, entity: !90, file: !42, line: 173)
!90 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast16_t", file: !72, line: 70, baseType: !27)
!91 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !23, entity: !92, file: !42, line: 174)
!92 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast32_t", file: !72, line: 71, baseType: !27)
!93 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !23, entity: !94, file: !42, line: 175)
!94 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast64_t", file: !72, line: 72, baseType: !27)
!95 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !23, entity: !96, file: !42, line: 177)
!96 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast8_t", file: !72, line: 81, baseType: !58)
!97 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !23, entity: !98, file: !42, line: 178)
!98 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast16_t", file: !72, line: 83, baseType: !31)
!99 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !23, entity: !100, file: !42, line: 179)
!100 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast32_t", file: !72, line: 84, baseType: !31)
!101 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !23, entity: !102, file: !42, line: 180)
!102 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast64_t", file: !72, line: 85, baseType: !31)
!103 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !23, entity: !104, file: !42, line: 182)
!104 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !72, line: 97, baseType: !27)
!105 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !23, entity: !106, file: !42, line: 183)
!106 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !72, line: 100, baseType: !31)
!107 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !23, entity: !108, file: !42, line: 185)
!108 = !DIDerivedType(tag: DW_TAG_typedef, name: "intmax_t", file: !72, line: 111, baseType: !109)
!109 = !DIDerivedType(tag: DW_TAG_typedef, name: "__intmax_t", file: !19, line: 61, baseType: !27)
!110 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !23, entity: !111, file: !42, line: 186)
!111 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintmax_t", file: !72, line: 112, baseType: !112)
!112 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uintmax_t", file: !19, line: 62, baseType: !31)
!113 = !{i32 2, !"Dwarf Version", i32 4}
!114 = !{i32 2, !"Debug Info Version", i32 3}
!115 = !{i32 1, !"wchar_size", i32 4}
!116 = !{!"clang version 9.0.0 (tags/RELEASE_900/final)"}
!117 = distinct !DISubprogram(name: "bcast", linkageName: "_Z5bcastii", scope: !1, file: !1, line: 9, type: !118, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !120)
!118 = !DISubroutineType(types: !119)
!119 = !{null, !50, !50}
!120 = !{!121, !122, !123, !124}
!121 = !DILocalVariable(name: "rank", arg: 1, scope: !117, file: !1, line: 9, type: !50)
!122 = !DILocalVariable(name: "size", arg: 2, scope: !117, file: !1, line: 9, type: !50)
!123 = !DILocalVariable(name: "data", scope: !117, file: !1, line: 11, type: !50)
!124 = !DILocalVariable(name: "s", scope: !117, file: !1, line: 12, type: !50)
!125 = !{!126, !126, i64 0}
!126 = !{!"int", !127, i64 0}
!127 = !{!"omnipotent char", !128, i64 0}
!128 = !{!"Simple C++ TBAA"}
!129 = !DILocation(line: 9, column: 16, scope: !117)
!130 = !DILocation(line: 9, column: 26, scope: !117)
!131 = !DILocation(line: 11, column: 3, scope: !117)
!132 = !DILocation(line: 11, column: 7, scope: !117)
!133 = !DILocation(line: 12, column: 3, scope: !117)
!134 = !DILocation(line: 12, column: 7, scope: !117)
!135 = !DILocation(line: 14, column: 13, scope: !117)
!136 = !DILocation(line: 14, column: 20, scope: !117)
!137 = !DILocation(line: 14, column: 3, scope: !117)
!138 = !DILocation(line: 16, column: 13, scope: !117)
!139 = !DILocation(line: 16, column: 20, scope: !117)
!140 = !DILocation(line: 16, column: 3, scope: !117)
!141 = !DILocation(line: 17, column: 1, scope: !117)
!142 = distinct !DISubprogram(name: "alltoall", linkageName: "_Z8alltoalliii", scope: !1, file: !1, line: 19, type: !143, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !145)
!143 = !DISubroutineType(types: !144)
!144 = !{null, !50, !50, !50}
!145 = !{!146, !147, !148, !149, !153, !154}
!146 = !DILocalVariable(name: "rank", arg: 1, scope: !142, file: !1, line: 19, type: !50)
!147 = !DILocalVariable(name: "size", arg: 2, scope: !142, file: !1, line: 19, type: !50)
!148 = !DILocalVariable(name: "size2", arg: 3, scope: !142, file: !1, line: 19, type: !50)
!149 = !DILocalVariable(name: "send_data", scope: !142, file: !1, line: 21, type: !150)
!150 = !DICompositeType(tag: DW_TAG_array_type, baseType: !50, size: 64, elements: !151)
!151 = !{!152}
!152 = !DISubrange(count: 2)
!153 = !DILocalVariable(name: "rcv_data", scope: !142, file: !1, line: 22, type: !150)
!154 = !DILocalVariable(name: "s", scope: !142, file: !1, line: 23, type: !50)
!155 = !DILocation(line: 19, column: 19, scope: !142)
!156 = !DILocation(line: 19, column: 29, scope: !142)
!157 = !DILocation(line: 19, column: 39, scope: !142)
!158 = !DILocation(line: 21, column: 3, scope: !142)
!159 = !DILocation(line: 21, column: 7, scope: !142)
!160 = !DILocation(line: 22, column: 3, scope: !142)
!161 = !DILocation(line: 22, column: 7, scope: !142)
!162 = !DILocation(line: 23, column: 3, scope: !142)
!163 = !DILocation(line: 23, column: 7, scope: !142)
!164 = !DILocation(line: 26, column: 16, scope: !142)
!165 = !DILocation(line: 26, column: 27, scope: !142)
!166 = !DILocation(line: 26, column: 39, scope: !142)
!167 = !DILocation(line: 26, column: 49, scope: !142)
!168 = !DILocation(line: 26, column: 3, scope: !142)
!169 = !DILocation(line: 28, column: 16, scope: !142)
!170 = !DILocation(line: 28, column: 27, scope: !142)
!171 = !DILocation(line: 28, column: 32, scope: !142)
!172 = !DILocation(line: 28, column: 46, scope: !142)
!173 = !DILocation(line: 28, column: 56, scope: !142)
!174 = !DILocation(line: 28, column: 3, scope: !142)
!175 = !DILocation(line: 30, column: 16, scope: !142)
!176 = !DILocation(line: 30, column: 27, scope: !142)
!177 = !DILocation(line: 30, column: 39, scope: !142)
!178 = !DILocation(line: 30, column: 49, scope: !142)
!179 = !DILocation(line: 30, column: 55, scope: !142)
!180 = !DILocation(line: 30, column: 3, scope: !142)
!181 = !DILocation(line: 32, column: 16, scope: !142)
!182 = !DILocation(line: 32, column: 27, scope: !142)
!183 = !DILocation(line: 32, column: 32, scope: !142)
!184 = !DILocation(line: 32, column: 46, scope: !142)
!185 = !DILocation(line: 32, column: 56, scope: !142)
!186 = !DILocation(line: 32, column: 62, scope: !142)
!187 = !DILocation(line: 32, column: 3, scope: !142)
!188 = !DILocation(line: 33, column: 1, scope: !142)
!189 = distinct !DISubprogram(name: "allgather", linkageName: "_Z9allgatheriii", scope: !1, file: !1, line: 35, type: !143, scopeLine: 36, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !190)
!190 = !{!191, !192, !193, !194, !198, !202}
!191 = !DILocalVariable(name: "rank", arg: 1, scope: !189, file: !1, line: 35, type: !50)
!192 = !DILocalVariable(name: "size", arg: 2, scope: !189, file: !1, line: 35, type: !50)
!193 = !DILocalVariable(name: "size2", arg: 3, scope: !189, file: !1, line: 35, type: !50)
!194 = !DILocalVariable(name: "send_data", scope: !189, file: !1, line: 37, type: !195)
!195 = !DICompositeType(tag: DW_TAG_array_type, baseType: !50, size: 32, elements: !196)
!196 = !{!197}
!197 = !DISubrange(count: 1)
!198 = !DILocalVariable(name: "rcv_data", scope: !189, file: !1, line: 38, type: !199)
!199 = !DICompositeType(tag: DW_TAG_array_type, baseType: !50, size: 128, elements: !200)
!200 = !{!201}
!201 = !DISubrange(count: 4)
!202 = !DILocalVariable(name: "s", scope: !189, file: !1, line: 39, type: !50)
!203 = !DILocation(line: 35, column: 20, scope: !189)
!204 = !DILocation(line: 35, column: 30, scope: !189)
!205 = !DILocation(line: 35, column: 40, scope: !189)
!206 = !DILocation(line: 37, column: 3, scope: !189)
!207 = !DILocation(line: 37, column: 7, scope: !189)
!208 = !DILocation(line: 38, column: 3, scope: !189)
!209 = !DILocation(line: 38, column: 7, scope: !189)
!210 = !DILocation(line: 39, column: 3, scope: !189)
!211 = !DILocation(line: 39, column: 7, scope: !189)
!212 = !DILocation(line: 42, column: 17, scope: !189)
!213 = !DILocation(line: 42, column: 28, scope: !189)
!214 = !DILocation(line: 42, column: 40, scope: !189)
!215 = !DILocation(line: 42, column: 50, scope: !189)
!216 = !DILocation(line: 42, column: 3, scope: !189)
!217 = !DILocation(line: 44, column: 17, scope: !189)
!218 = !DILocation(line: 44, column: 28, scope: !189)
!219 = !DILocation(line: 44, column: 43, scope: !189)
!220 = !DILocation(line: 44, column: 53, scope: !189)
!221 = !DILocation(line: 44, column: 3, scope: !189)
!222 = !DILocation(line: 46, column: 17, scope: !189)
!223 = !DILocation(line: 46, column: 28, scope: !189)
!224 = !DILocation(line: 46, column: 40, scope: !189)
!225 = !DILocation(line: 46, column: 50, scope: !189)
!226 = !DILocation(line: 46, column: 3, scope: !189)
!227 = !DILocation(line: 48, column: 17, scope: !189)
!228 = !DILocation(line: 48, column: 28, scope: !189)
!229 = !DILocation(line: 48, column: 43, scope: !189)
!230 = !DILocation(line: 48, column: 53, scope: !189)
!231 = !DILocation(line: 48, column: 3, scope: !189)
!232 = !DILocation(line: 49, column: 1, scope: !189)
!233 = distinct !DISubprogram(name: "scan", linkageName: "_Z4scanii", scope: !1, file: !1, line: 51, type: !118, scopeLine: 52, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !234)
!234 = !{!235, !236, !237, !238, !239}
!235 = !DILocalVariable(name: "rank", arg: 1, scope: !233, file: !1, line: 51, type: !50)
!236 = !DILocalVariable(name: "size", arg: 2, scope: !233, file: !1, line: 51, type: !50)
!237 = !DILocalVariable(name: "send_data", scope: !233, file: !1, line: 53, type: !195)
!238 = !DILocalVariable(name: "rcv_data", scope: !233, file: !1, line: 54, type: !195)
!239 = !DILocalVariable(name: "s", scope: !233, file: !1, line: 55, type: !50)
!240 = !DILocation(line: 51, column: 15, scope: !233)
!241 = !DILocation(line: 51, column: 25, scope: !233)
!242 = !DILocation(line: 53, column: 3, scope: !233)
!243 = !DILocation(line: 53, column: 7, scope: !233)
!244 = !DILocation(line: 54, column: 3, scope: !233)
!245 = !DILocation(line: 54, column: 7, scope: !233)
!246 = !DILocation(line: 55, column: 3, scope: !233)
!247 = !DILocation(line: 55, column: 7, scope: !233)
!248 = !DILocation(line: 58, column: 12, scope: !233)
!249 = !DILocation(line: 58, column: 23, scope: !233)
!250 = !DILocation(line: 58, column: 33, scope: !233)
!251 = !DILocation(line: 58, column: 3, scope: !233)
!252 = !DILocation(line: 60, column: 12, scope: !233)
!253 = !DILocation(line: 60, column: 23, scope: !233)
!254 = !DILocation(line: 60, column: 33, scope: !233)
!255 = !DILocation(line: 60, column: 3, scope: !233)
!256 = !DILocation(line: 61, column: 1, scope: !233)
!257 = distinct !DISubprogram(name: "reduce", linkageName: "_Z6reduceii", scope: !1, file: !1, line: 63, type: !118, scopeLine: 64, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !258)
!258 = !{!259, !260, !261, !262, !263}
!259 = !DILocalVariable(name: "rank", arg: 1, scope: !257, file: !1, line: 63, type: !50)
!260 = !DILocalVariable(name: "size", arg: 2, scope: !257, file: !1, line: 63, type: !50)
!261 = !DILocalVariable(name: "send_data", scope: !257, file: !1, line: 65, type: !195)
!262 = !DILocalVariable(name: "rcv_data", scope: !257, file: !1, line: 66, type: !195)
!263 = !DILocalVariable(name: "s", scope: !257, file: !1, line: 67, type: !50)
!264 = !DILocation(line: 63, column: 17, scope: !257)
!265 = !DILocation(line: 63, column: 27, scope: !257)
!266 = !DILocation(line: 65, column: 3, scope: !257)
!267 = !DILocation(line: 65, column: 7, scope: !257)
!268 = !DILocation(line: 66, column: 3, scope: !257)
!269 = !DILocation(line: 66, column: 7, scope: !257)
!270 = !DILocation(line: 67, column: 3, scope: !257)
!271 = !DILocation(line: 67, column: 7, scope: !257)
!272 = !DILocation(line: 70, column: 14, scope: !257)
!273 = !DILocation(line: 70, column: 25, scope: !257)
!274 = !DILocation(line: 70, column: 35, scope: !257)
!275 = !DILocation(line: 70, column: 3, scope: !257)
!276 = !DILocation(line: 72, column: 14, scope: !257)
!277 = !DILocation(line: 72, column: 25, scope: !257)
!278 = !DILocation(line: 72, column: 35, scope: !257)
!279 = !DILocation(line: 72, column: 3, scope: !257)
!280 = !DILocation(line: 73, column: 1, scope: !257)
!281 = distinct !DISubprogram(name: "allreduce", linkageName: "_Z9allreduceii", scope: !1, file: !1, line: 75, type: !118, scopeLine: 76, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !282)
!282 = !{!283, !284, !285, !286, !287}
!283 = !DILocalVariable(name: "rank", arg: 1, scope: !281, file: !1, line: 75, type: !50)
!284 = !DILocalVariable(name: "size", arg: 2, scope: !281, file: !1, line: 75, type: !50)
!285 = !DILocalVariable(name: "send_data", scope: !281, file: !1, line: 77, type: !195)
!286 = !DILocalVariable(name: "rcv_data", scope: !281, file: !1, line: 78, type: !150)
!287 = !DILocalVariable(name: "s", scope: !281, file: !1, line: 79, type: !50)
!288 = !DILocation(line: 75, column: 20, scope: !281)
!289 = !DILocation(line: 75, column: 30, scope: !281)
!290 = !DILocation(line: 77, column: 3, scope: !281)
!291 = !DILocation(line: 77, column: 7, scope: !281)
!292 = !DILocation(line: 78, column: 3, scope: !281)
!293 = !DILocation(line: 78, column: 7, scope: !281)
!294 = !DILocation(line: 79, column: 3, scope: !281)
!295 = !DILocation(line: 79, column: 7, scope: !281)
!296 = !DILocation(line: 82, column: 17, scope: !281)
!297 = !DILocation(line: 82, column: 28, scope: !281)
!298 = !DILocation(line: 82, column: 38, scope: !281)
!299 = !DILocation(line: 82, column: 3, scope: !281)
!300 = !DILocation(line: 84, column: 17, scope: !281)
!301 = !DILocation(line: 84, column: 28, scope: !281)
!302 = !DILocation(line: 84, column: 38, scope: !281)
!303 = !DILocation(line: 84, column: 3, scope: !281)
!304 = !DILocation(line: 85, column: 1, scope: !281)
!305 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 88, type: !306, scopeLine: 89, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !311)
!306 = !DISubroutineType(types: !307)
!307 = !{!50, !50, !308}
!308 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !309, size: 64)
!309 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !310, size: 64)
!310 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!311 = !{!312, !313, !314, !315, !316, !317}
!312 = !DILocalVariable(name: "argc", arg: 1, scope: !305, file: !1, line: 88, type: !50)
!313 = !DILocalVariable(name: "argv", arg: 2, scope: !305, file: !1, line: 88, type: !308)
!314 = !DILocalVariable(name: "param", scope: !305, file: !1, line: 90, type: !50)
!315 = !DILocalVariable(name: "param2", scope: !305, file: !1, line: 90, type: !50)
!316 = !DILocalVariable(name: "ranks", scope: !305, file: !1, line: 92, type: !50)
!317 = !DILocalVariable(name: "rank_id", scope: !305, file: !1, line: 92, type: !50)
!318 = !DILocation(line: 88, column: 14, scope: !305)
!319 = !{!320, !320, i64 0}
!320 = !{!"any pointer", !127, i64 0}
!321 = !DILocation(line: 88, column: 28, scope: !305)
!322 = !DILocation(line: 90, column: 3, scope: !305)
!323 = !DILocation(line: 90, column: 7, scope: !305)
!324 = !DILocation(line: 90, column: 25, scope: !305)
!325 = !DILocation(line: 91, column: 3, scope: !305)
!326 = !DILocation(line: 92, column: 3, scope: !305)
!327 = !DILocation(line: 92, column: 7, scope: !305)
!328 = !DILocation(line: 92, column: 14, scope: !305)
!329 = !DILocation(line: 93, column: 3, scope: !305)
!330 = !DILocation(line: 94, column: 3, scope: !305)
!331 = !DILocation(line: 95, column: 3, scope: !305)
!332 = !DILocation(line: 96, column: 3, scope: !305)
!333 = !DILocation(line: 98, column: 9, scope: !305)
!334 = !DILocation(line: 98, column: 18, scope: !305)
!335 = !DILocation(line: 98, column: 3, scope: !305)
!336 = !DILocation(line: 99, column: 12, scope: !305)
!337 = !DILocation(line: 99, column: 21, scope: !305)
!338 = !DILocation(line: 99, column: 28, scope: !305)
!339 = !DILocation(line: 99, column: 3, scope: !305)
!340 = !DILocation(line: 100, column: 13, scope: !305)
!341 = !DILocation(line: 100, column: 22, scope: !305)
!342 = !DILocation(line: 100, column: 29, scope: !305)
!343 = !DILocation(line: 100, column: 3, scope: !305)
!344 = !DILocation(line: 101, column: 8, scope: !305)
!345 = !DILocation(line: 101, column: 17, scope: !305)
!346 = !DILocation(line: 101, column: 3, scope: !305)
!347 = !DILocation(line: 102, column: 10, scope: !305)
!348 = !DILocation(line: 102, column: 19, scope: !305)
!349 = !DILocation(line: 102, column: 3, scope: !305)
!350 = !DILocation(line: 103, column: 13, scope: !305)
!351 = !DILocation(line: 103, column: 22, scope: !305)
!352 = !DILocation(line: 103, column: 3, scope: !305)
!353 = !DILocation(line: 105, column: 3, scope: !305)
!354 = !DILocation(line: 107, column: 1, scope: !305)
!355 = !DILocation(line: 106, column: 3, scope: !305)
!356 = distinct !DISubprogram(name: "register_variable<int>", linkageName: "_Z17register_variableIiEvPT_PKc", scope: !357, file: !357, line: 15, type: !358, scopeLine: 16, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, templateParams: !366, retainedNodes: !363)
!357 = !DIFile(filename: "include/ExtraPInstrumenter.hpp", directory: "/home/mcopik/projects/ETH/extrap/rebuild/perf-taint")
!358 = !DISubroutineType(types: !359)
!359 = !{null, !360, !361}
!360 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !50, size: 64)
!361 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !362, size: 64)
!362 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !310)
!363 = !{!364, !365}
!364 = !DILocalVariable(name: "ptr", arg: 1, scope: !356, file: !357, line: 15, type: !360)
!365 = !DILocalVariable(name: "name", arg: 2, scope: !356, file: !357, line: 15, type: !361)
!366 = !{!367}
!367 = !DITemplateTypeParameter(name: "T", type: !50)
!368 = !DILocation(line: 15, column: 28, scope: !356)
!369 = !DILocation(line: 15, column: 46, scope: !356)
!370 = !DILocation(line: 20, column: 55, scope: !356)
!371 = !DILocation(line: 20, column: 29, scope: !356)
!372 = !DILocation(line: 20, column: 72, scope: !356)
!373 = !DILocation(line: 20, column: 3, scope: !356)
!374 = !DILocation(line: 21, column: 1, scope: !356)
