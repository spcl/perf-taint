; RUN: opt %mpidfsan -extrap-extractor-out-name=%t4 -S < %s 2> /dev/null | llc %llcparams - -o %t1 && clang++ %link %t1 -o %t2 && %execparams mpiexec -n 2 %t2 && diff -w %s.json %t4_0.json && diff -w %s.json %t4_1.json
; ModuleID = 'tests/dfsan-unit/mpi/taint_communication_size_p2p.cpp'
source_filename = "tests/dfsan-unit/mpi/taint_communication_size_p2p.cpp"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.ompi_predefined_datatype_t = type opaque
%struct.ompi_predefined_communicator_t = type opaque
%struct.ompi_request_t = type opaque
%struct.ompi_datatype_t = type opaque
%struct.ompi_communicator_t = type opaque
%struct.ompi_status_public_t = type { i32, i32, i32, i32, i64 }

$_Z17register_variableIiEvPT_PKc = comdat any

@ompi_mpi_int = external dso_local global %struct.ompi_predefined_datatype_t, align 1
@ompi_mpi_comm_world = external dso_local global %struct.ompi_predefined_communicator_t, align 1
@.str = private unnamed_addr constant [7 x i8] c"extrap\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [54 x i8] c"tests/dfsan-unit/mpi/taint_communication_size_p2p.cpp\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [6 x i8] c"param\00", align 1

; Function Attrs: uwtable
define dso_local void @_Z4sendiiPi(i32, i32, i32*) #0 !dbg !117 {
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32*, align 8
  %7 = alloca %struct.ompi_request_t*, align 8
  %8 = alloca %struct.ompi_request_t*, align 8
  store i32 %0, i32* %4, align 4, !tbaa !130
  call void @llvm.dbg.declare(metadata i32* %4, metadata !122, metadata !DIExpression()), !dbg !134
  store i32 %1, i32* %5, align 4, !tbaa !130
  call void @llvm.dbg.declare(metadata i32* %5, metadata !123, metadata !DIExpression()), !dbg !135
  store i32* %2, i32** %6, align 8, !tbaa !136
  call void @llvm.dbg.declare(metadata i32** %6, metadata !124, metadata !DIExpression()), !dbg !138
  %9 = bitcast %struct.ompi_request_t** %7 to i8*, !dbg !139
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %9) #5, !dbg !139
  call void @llvm.dbg.declare(metadata %struct.ompi_request_t** %7, metadata !125, metadata !DIExpression()), !dbg !140
  %10 = bitcast %struct.ompi_request_t** %8 to i8*, !dbg !139
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %10) #5, !dbg !139
  call void @llvm.dbg.declare(metadata %struct.ompi_request_t** %8, metadata !129, metadata !DIExpression()), !dbg !141
  %11 = load i32*, i32** %6, align 8, !dbg !142, !tbaa !136
  %12 = bitcast i32* %11 to i8*, !dbg !142
  %13 = load i32, i32* %4, align 4, !dbg !143, !tbaa !130
  %14 = sub nsw i32 1, %13, !dbg !144
  %15 = call i32 @MPI_Isend(i8* %12, i32 1, %struct.ompi_datatype_t* bitcast (%struct.ompi_predefined_datatype_t* @ompi_mpi_int to %struct.ompi_datatype_t*), i32 %14, i32 0, %struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*), %struct.ompi_request_t** %7), !dbg !145
  %16 = load i32*, i32** %6, align 8, !dbg !146, !tbaa !136
  %17 = bitcast i32* %16 to i8*, !dbg !146
  %18 = load i32, i32* %5, align 4, !dbg !147, !tbaa !130
  %19 = load i32, i32* %4, align 4, !dbg !148, !tbaa !130
  %20 = sub nsw i32 1, %19, !dbg !149
  %21 = call i32 @MPI_Isend(i8* %17, i32 %18, %struct.ompi_datatype_t* bitcast (%struct.ompi_predefined_datatype_t* @ompi_mpi_int to %struct.ompi_datatype_t*), i32 %20, i32 1, %struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*), %struct.ompi_request_t** %8), !dbg !150
  %22 = load i32*, i32** %6, align 8, !dbg !151, !tbaa !136
  %23 = bitcast i32* %22 to i8*, !dbg !151
  %24 = load i32, i32* %4, align 4, !dbg !152, !tbaa !130
  %25 = sub nsw i32 1, %24, !dbg !153
  %26 = call i32 @MPI_Send(i8* %23, i32 1, %struct.ompi_datatype_t* bitcast (%struct.ompi_predefined_datatype_t* @ompi_mpi_int to %struct.ompi_datatype_t*), i32 %25, i32 2, %struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*)), !dbg !154
  %27 = load i32*, i32** %6, align 8, !dbg !155, !tbaa !136
  %28 = bitcast i32* %27 to i8*, !dbg !155
  %29 = load i32, i32* %5, align 4, !dbg !156, !tbaa !130
  %30 = load i32, i32* %4, align 4, !dbg !157, !tbaa !130
  %31 = sub nsw i32 1, %30, !dbg !158
  %32 = call i32 @MPI_Send(i8* %28, i32 %29, %struct.ompi_datatype_t* bitcast (%struct.ompi_predefined_datatype_t* @ompi_mpi_int to %struct.ompi_datatype_t*), i32 %31, i32 3, %struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*)), !dbg !159
  %33 = call i32 @MPI_Wait(%struct.ompi_request_t** %7, %struct.ompi_status_public_t* null), !dbg !160
  %34 = call i32 @MPI_Wait(%struct.ompi_request_t** %8, %struct.ompi_status_public_t* null), !dbg !161
  %35 = bitcast %struct.ompi_request_t** %8 to i8*, !dbg !162
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %35) #5, !dbg !162
  %36 = bitcast %struct.ompi_request_t** %7 to i8*, !dbg !162
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %36) #5, !dbg !162
  ret void, !dbg !162
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #2

declare dso_local i32 @MPI_Isend(i8*, i32, %struct.ompi_datatype_t*, i32, i32, %struct.ompi_communicator_t*, %struct.ompi_request_t**) #3

declare dso_local i32 @MPI_Send(i8*, i32, %struct.ompi_datatype_t*, i32, i32, %struct.ompi_communicator_t*) #3

declare dso_local i32 @MPI_Wait(%struct.ompi_request_t**, %struct.ompi_status_public_t*) #3

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: uwtable
define dso_local void @_Z3rcviiPi(i32, i32, i32*) #0 !dbg !163 {
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32*, align 8
  %7 = alloca %struct.ompi_request_t*, align 8
  %8 = alloca %struct.ompi_request_t*, align 8
  store i32 %0, i32* %4, align 4, !tbaa !130
  call void @llvm.dbg.declare(metadata i32* %4, metadata !165, metadata !DIExpression()), !dbg !170
  store i32 %1, i32* %5, align 4, !tbaa !130
  call void @llvm.dbg.declare(metadata i32* %5, metadata !166, metadata !DIExpression()), !dbg !171
  store i32* %2, i32** %6, align 8, !tbaa !136
  call void @llvm.dbg.declare(metadata i32** %6, metadata !167, metadata !DIExpression()), !dbg !172
  %9 = bitcast %struct.ompi_request_t** %7 to i8*, !dbg !173
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %9) #5, !dbg !173
  call void @llvm.dbg.declare(metadata %struct.ompi_request_t** %7, metadata !168, metadata !DIExpression()), !dbg !174
  %10 = bitcast %struct.ompi_request_t** %8 to i8*, !dbg !173
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %10) #5, !dbg !173
  call void @llvm.dbg.declare(metadata %struct.ompi_request_t** %8, metadata !169, metadata !DIExpression()), !dbg !175
  %11 = load i32*, i32** %6, align 8, !dbg !176, !tbaa !136
  %12 = bitcast i32* %11 to i8*, !dbg !176
  %13 = load i32, i32* %4, align 4, !dbg !177, !tbaa !130
  %14 = sub nsw i32 1, %13, !dbg !178
  %15 = call i32 @MPI_Irecv(i8* %12, i32 1, %struct.ompi_datatype_t* bitcast (%struct.ompi_predefined_datatype_t* @ompi_mpi_int to %struct.ompi_datatype_t*), i32 %14, i32 0, %struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*), %struct.ompi_request_t** %7), !dbg !179
  %16 = load i32*, i32** %6, align 8, !dbg !180, !tbaa !136
  %17 = bitcast i32* %16 to i8*, !dbg !180
  %18 = load i32, i32* %5, align 4, !dbg !181, !tbaa !130
  %19 = load i32, i32* %4, align 4, !dbg !182, !tbaa !130
  %20 = sub nsw i32 1, %19, !dbg !183
  %21 = call i32 @MPI_Irecv(i8* %17, i32 %18, %struct.ompi_datatype_t* bitcast (%struct.ompi_predefined_datatype_t* @ompi_mpi_int to %struct.ompi_datatype_t*), i32 %20, i32 1, %struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*), %struct.ompi_request_t** %8), !dbg !184
  %22 = load i32*, i32** %6, align 8, !dbg !185, !tbaa !136
  %23 = bitcast i32* %22 to i8*, !dbg !185
  %24 = load i32, i32* %4, align 4, !dbg !186, !tbaa !130
  %25 = sub nsw i32 1, %24, !dbg !187
  %26 = call i32 @MPI_Recv(i8* %23, i32 1, %struct.ompi_datatype_t* bitcast (%struct.ompi_predefined_datatype_t* @ompi_mpi_int to %struct.ompi_datatype_t*), i32 %25, i32 2, %struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*), %struct.ompi_status_public_t* null), !dbg !188
  %27 = load i32*, i32** %6, align 8, !dbg !189, !tbaa !136
  %28 = bitcast i32* %27 to i8*, !dbg !189
  %29 = load i32, i32* %5, align 4, !dbg !190, !tbaa !130
  %30 = load i32, i32* %4, align 4, !dbg !191, !tbaa !130
  %31 = sub nsw i32 1, %30, !dbg !192
  %32 = call i32 @MPI_Recv(i8* %28, i32 %29, %struct.ompi_datatype_t* bitcast (%struct.ompi_predefined_datatype_t* @ompi_mpi_int to %struct.ompi_datatype_t*), i32 %31, i32 3, %struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*), %struct.ompi_status_public_t* null), !dbg !193
  %33 = call i32 @MPI_Wait(%struct.ompi_request_t** %7, %struct.ompi_status_public_t* null), !dbg !194
  %34 = call i32 @MPI_Wait(%struct.ompi_request_t** %8, %struct.ompi_status_public_t* null), !dbg !195
  %35 = bitcast %struct.ompi_request_t** %8 to i8*, !dbg !196
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %35) #5, !dbg !196
  %36 = bitcast %struct.ompi_request_t** %7 to i8*, !dbg !196
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %36) #5, !dbg !196
  ret void, !dbg !196
}

declare dso_local i32 @MPI_Irecv(i8*, i32, %struct.ompi_datatype_t*, i32, i32, %struct.ompi_communicator_t*, %struct.ompi_request_t**) #3

declare dso_local i32 @MPI_Recv(i8*, i32, %struct.ompi_datatype_t*, i32, i32, %struct.ompi_communicator_t*, %struct.ompi_status_public_t*) #3

; Function Attrs: norecurse uwtable
define dso_local i32 @main(i32, i8**) #4 !dbg !197 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4, !tbaa !130
  call void @llvm.dbg.declare(metadata i32* %4, metadata !204, metadata !DIExpression()), !dbg !211
  store i8** %1, i8*** %5, align 8, !tbaa !136
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !205, metadata !DIExpression()), !dbg !212
  %11 = bitcast i32* %6 to i8*, !dbg !213
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %11) #5, !dbg !213
  call void @llvm.dbg.declare(metadata i32* %6, metadata !206, metadata !DIExpression()), !dbg !214
  %12 = bitcast i32* %6 to i8*, !dbg !213
  call void @llvm.var.annotation(i8* %12, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([54 x i8], [54 x i8]* @.str.1, i32 0, i32 0), i32 41), !dbg !213
  store i32 1, i32* %6, align 4, !dbg !214, !tbaa !130
  %13 = call i32 @MPI_Init(i32* %4, i8*** %5), !dbg !215
  %14 = bitcast i32* %7 to i8*, !dbg !216
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %14) #5, !dbg !216
  call void @llvm.dbg.declare(metadata i32* %7, metadata !207, metadata !DIExpression()), !dbg !217
  %15 = bitcast i32* %8 to i8*, !dbg !216
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %15) #5, !dbg !216
  call void @llvm.dbg.declare(metadata i32* %8, metadata !208, metadata !DIExpression()), !dbg !218
  %16 = call i32 @MPI_Comm_size(%struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*), i32* %7), !dbg !219
  %17 = call i32 @MPI_Comm_rank(%struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*), i32* %8), !dbg !220
  call void @_Z17register_variableIiEvPT_PKc(i32* %6, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.2, i64 0, i64 0)), !dbg !221
  %18 = bitcast i32* %9 to i8*, !dbg !222
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %18) #5, !dbg !222
  call void @llvm.dbg.declare(metadata i32* %9, metadata !209, metadata !DIExpression()), !dbg !223
  store i32 0, i32* %9, align 4, !dbg !223, !tbaa !130
  %19 = bitcast i32* %10 to i8*, !dbg !222
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %19) #5, !dbg !222
  call void @llvm.dbg.declare(metadata i32* %10, metadata !210, metadata !DIExpression()), !dbg !224
  store i32 1, i32* %10, align 4, !dbg !224, !tbaa !130
  %20 = load i32, i32* %8, align 4, !dbg !225, !tbaa !130
  %21 = load i32, i32* %6, align 4, !dbg !226, !tbaa !130
  call void @_Z4sendiiPi(i32 %20, i32 %21, i32* %10), !dbg !227
  %22 = load i32, i32* %8, align 4, !dbg !228, !tbaa !130
  %23 = load i32, i32* %6, align 4, !dbg !229, !tbaa !130
  call void @_Z3rcviiPi(i32 %22, i32 %23, i32* %10), !dbg !230
  %24 = call i32 @MPI_Finalize(), !dbg !231
  %25 = bitcast i32* %10 to i8*, !dbg !232
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %25) #5, !dbg !232
  %26 = bitcast i32* %9 to i8*, !dbg !232
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %26) #5, !dbg !232
  %27 = bitcast i32* %8 to i8*, !dbg !232
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %27) #5, !dbg !232
  %28 = bitcast i32* %7 to i8*, !dbg !232
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %28) #5, !dbg !232
  %29 = bitcast i32* %6 to i8*, !dbg !232
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %29) #5, !dbg !232
  ret i32 0, !dbg !233
}

; Function Attrs: nounwind
declare void @llvm.var.annotation(i8*, i8*, i8*, i32) #5

declare dso_local i32 @MPI_Init(i32*, i8***) #3

declare dso_local i32 @MPI_Comm_size(%struct.ompi_communicator_t*, i32*) #3

declare dso_local i32 @MPI_Comm_rank(%struct.ompi_communicator_t*, i32*) #3

; Function Attrs: uwtable
define linkonce_odr dso_local void @_Z17register_variableIiEvPT_PKc(i32*, i8*) #0 comdat !dbg !234 {
  %3 = alloca i32*, align 8
  %4 = alloca i8*, align 8
  store i32* %0, i32** %3, align 8, !tbaa !136
  call void @llvm.dbg.declare(metadata i32** %3, metadata !241, metadata !DIExpression()), !dbg !245
  store i8* %1, i8** %4, align 8, !tbaa !136
  call void @llvm.dbg.declare(metadata i8** %4, metadata !242, metadata !DIExpression()), !dbg !246
  %5 = load i32*, i32** %3, align 8, !dbg !247, !tbaa !136
  %6 = bitcast i32* %5 to i8*, !dbg !248
  %7 = load i8*, i8** %4, align 8, !dbg !249, !tbaa !136
  call void @__dfsw_EXTRAP_WRITE_LABEL(i8* %6, i32 4, i8* %7), !dbg !250
  ret void, !dbg !251
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
!1 = !DIFile(filename: "tests/dfsan-unit/mpi/taint_communication_size_p2p.cpp", directory: "/home/mcopik/projects/ETH/extrap/rebuild/perf-taint")
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
!12 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !13, size: 64)
!13 = !DIDerivedType(tag: DW_TAG_typedef, name: "MPI_Status", file: !5, line: 341, baseType: !14)
!14 = !DICompositeType(tag: DW_TAG_structure_type, name: "ompi_status_public_t", file: !5, line: 351, flags: DIFlagFwdDecl, identifier: "_ZTS20ompi_status_public_t")
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
!117 = distinct !DISubprogram(name: "send", linkageName: "_Z4sendiiPi", scope: !1, file: !1, line: 9, type: !118, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !121)
!118 = !DISubroutineType(types: !119)
!119 = !{null, !50, !50, !120}
!120 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !50, size: 64)
!121 = !{!122, !123, !124, !125, !129}
!122 = !DILocalVariable(name: "rank", arg: 1, scope: !117, file: !1, line: 9, type: !50)
!123 = !DILocalVariable(name: "size", arg: 2, scope: !117, file: !1, line: 9, type: !50)
!124 = !DILocalVariable(name: "send_value", arg: 3, scope: !117, file: !1, line: 9, type: !120)
!125 = !DILocalVariable(name: "r1", scope: !117, file: !1, line: 11, type: !126)
!126 = !DIDerivedType(tag: DW_TAG_typedef, name: "MPI_Request", file: !5, line: 339, baseType: !127)
!127 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !128, size: 64)
!128 = !DICompositeType(tag: DW_TAG_structure_type, name: "ompi_request_t", file: !5, line: 339, flags: DIFlagFwdDecl, identifier: "_ZTS14ompi_request_t")
!129 = !DILocalVariable(name: "r2", scope: !117, file: !1, line: 11, type: !126)
!130 = !{!131, !131, i64 0}
!131 = !{!"int", !132, i64 0}
!132 = !{!"omnipotent char", !133, i64 0}
!133 = !{!"Simple C++ TBAA"}
!134 = !DILocation(line: 9, column: 15, scope: !117)
!135 = !DILocation(line: 9, column: 25, scope: !117)
!136 = !{!137, !137, i64 0}
!137 = !{!"any pointer", !132, i64 0}
!138 = !DILocation(line: 9, column: 37, scope: !117)
!139 = !DILocation(line: 11, column: 3, scope: !117)
!140 = !DILocation(line: 11, column: 15, scope: !117)
!141 = !DILocation(line: 11, column: 19, scope: !117)
!142 = !DILocation(line: 13, column: 13, scope: !117)
!143 = !DILocation(line: 13, column: 41, scope: !117)
!144 = !DILocation(line: 13, column: 39, scope: !117)
!145 = !DILocation(line: 13, column: 3, scope: !117)
!146 = !DILocation(line: 15, column: 13, scope: !117)
!147 = !DILocation(line: 15, column: 25, scope: !117)
!148 = !DILocation(line: 15, column: 44, scope: !117)
!149 = !DILocation(line: 15, column: 42, scope: !117)
!150 = !DILocation(line: 15, column: 3, scope: !117)
!151 = !DILocation(line: 17, column: 12, scope: !117)
!152 = !DILocation(line: 17, column: 40, scope: !117)
!153 = !DILocation(line: 17, column: 38, scope: !117)
!154 = !DILocation(line: 17, column: 3, scope: !117)
!155 = !DILocation(line: 19, column: 12, scope: !117)
!156 = !DILocation(line: 19, column: 24, scope: !117)
!157 = !DILocation(line: 19, column: 43, scope: !117)
!158 = !DILocation(line: 19, column: 41, scope: !117)
!159 = !DILocation(line: 19, column: 3, scope: !117)
!160 = !DILocation(line: 20, column: 3, scope: !117)
!161 = !DILocation(line: 21, column: 3, scope: !117)
!162 = !DILocation(line: 22, column: 1, scope: !117)
!163 = distinct !DISubprogram(name: "rcv", linkageName: "_Z3rcviiPi", scope: !1, file: !1, line: 24, type: !118, scopeLine: 25, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !164)
!164 = !{!165, !166, !167, !168, !169}
!165 = !DILocalVariable(name: "rank", arg: 1, scope: !163, file: !1, line: 24, type: !50)
!166 = !DILocalVariable(name: "size", arg: 2, scope: !163, file: !1, line: 24, type: !50)
!167 = !DILocalVariable(name: "rcv_value", arg: 3, scope: !163, file: !1, line: 24, type: !120)
!168 = !DILocalVariable(name: "r1", scope: !163, file: !1, line: 26, type: !126)
!169 = !DILocalVariable(name: "r2", scope: !163, file: !1, line: 26, type: !126)
!170 = !DILocation(line: 24, column: 14, scope: !163)
!171 = !DILocation(line: 24, column: 24, scope: !163)
!172 = !DILocation(line: 24, column: 35, scope: !163)
!173 = !DILocation(line: 26, column: 3, scope: !163)
!174 = !DILocation(line: 26, column: 15, scope: !163)
!175 = !DILocation(line: 26, column: 19, scope: !163)
!176 = !DILocation(line: 28, column: 13, scope: !163)
!177 = !DILocation(line: 28, column: 40, scope: !163)
!178 = !DILocation(line: 28, column: 38, scope: !163)
!179 = !DILocation(line: 28, column: 3, scope: !163)
!180 = !DILocation(line: 30, column: 13, scope: !163)
!181 = !DILocation(line: 30, column: 24, scope: !163)
!182 = !DILocation(line: 30, column: 43, scope: !163)
!183 = !DILocation(line: 30, column: 41, scope: !163)
!184 = !DILocation(line: 30, column: 3, scope: !163)
!185 = !DILocation(line: 32, column: 12, scope: !163)
!186 = !DILocation(line: 32, column: 39, scope: !163)
!187 = !DILocation(line: 32, column: 37, scope: !163)
!188 = !DILocation(line: 32, column: 3, scope: !163)
!189 = !DILocation(line: 34, column: 12, scope: !163)
!190 = !DILocation(line: 34, column: 23, scope: !163)
!191 = !DILocation(line: 34, column: 42, scope: !163)
!192 = !DILocation(line: 34, column: 40, scope: !163)
!193 = !DILocation(line: 34, column: 3, scope: !163)
!194 = !DILocation(line: 35, column: 3, scope: !163)
!195 = !DILocation(line: 36, column: 3, scope: !163)
!196 = !DILocation(line: 37, column: 1, scope: !163)
!197 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 39, type: !198, scopeLine: 40, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !203)
!198 = !DISubroutineType(types: !199)
!199 = !{!50, !50, !200}
!200 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !201, size: 64)
!201 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !202, size: 64)
!202 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!203 = !{!204, !205, !206, !207, !208, !209, !210}
!204 = !DILocalVariable(name: "argc", arg: 1, scope: !197, file: !1, line: 39, type: !50)
!205 = !DILocalVariable(name: "argv", arg: 2, scope: !197, file: !1, line: 39, type: !200)
!206 = !DILocalVariable(name: "param", scope: !197, file: !1, line: 41, type: !50)
!207 = !DILocalVariable(name: "ranks", scope: !197, file: !1, line: 43, type: !50)
!208 = !DILocalVariable(name: "rank_id", scope: !197, file: !1, line: 43, type: !50)
!209 = !DILocalVariable(name: "rcv_val", scope: !197, file: !1, line: 48, type: !50)
!210 = !DILocalVariable(name: "send_val", scope: !197, file: !1, line: 48, type: !50)
!211 = !DILocation(line: 39, column: 14, scope: !197)
!212 = !DILocation(line: 39, column: 28, scope: !197)
!213 = !DILocation(line: 41, column: 3, scope: !197)
!214 = !DILocation(line: 41, column: 7, scope: !197)
!215 = !DILocation(line: 42, column: 3, scope: !197)
!216 = !DILocation(line: 43, column: 3, scope: !197)
!217 = !DILocation(line: 43, column: 7, scope: !197)
!218 = !DILocation(line: 43, column: 14, scope: !197)
!219 = !DILocation(line: 44, column: 3, scope: !197)
!220 = !DILocation(line: 45, column: 3, scope: !197)
!221 = !DILocation(line: 46, column: 3, scope: !197)
!222 = !DILocation(line: 48, column: 3, scope: !197)
!223 = !DILocation(line: 48, column: 7, scope: !197)
!224 = !DILocation(line: 48, column: 20, scope: !197)
!225 = !DILocation(line: 49, column: 8, scope: !197)
!226 = !DILocation(line: 49, column: 17, scope: !197)
!227 = !DILocation(line: 49, column: 3, scope: !197)
!228 = !DILocation(line: 50, column: 7, scope: !197)
!229 = !DILocation(line: 50, column: 16, scope: !197)
!230 = !DILocation(line: 50, column: 3, scope: !197)
!231 = !DILocation(line: 52, column: 3, scope: !197)
!232 = !DILocation(line: 54, column: 1, scope: !197)
!233 = !DILocation(line: 53, column: 3, scope: !197)
!234 = distinct !DISubprogram(name: "register_variable<int>", linkageName: "_Z17register_variableIiEvPT_PKc", scope: !235, file: !235, line: 15, type: !236, scopeLine: 16, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, templateParams: !243, retainedNodes: !240)
!235 = !DIFile(filename: "include/ExtraPInstrumenter.hpp", directory: "/home/mcopik/projects/ETH/extrap/rebuild/perf-taint")
!236 = !DISubroutineType(types: !237)
!237 = !{null, !120, !238}
!238 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !239, size: 64)
!239 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !202)
!240 = !{!241, !242}
!241 = !DILocalVariable(name: "ptr", arg: 1, scope: !234, file: !235, line: 15, type: !120)
!242 = !DILocalVariable(name: "name", arg: 2, scope: !234, file: !235, line: 15, type: !238)
!243 = !{!244}
!244 = !DITemplateTypeParameter(name: "T", type: !50)
!245 = !DILocation(line: 15, column: 28, scope: !234)
!246 = !DILocation(line: 15, column: 46, scope: !234)
!247 = !DILocation(line: 20, column: 55, scope: !234)
!248 = !DILocation(line: 20, column: 29, scope: !234)
!249 = !DILocation(line: 20, column: 72, scope: !234)
!250 = !DILocation(line: 20, column: 3, scope: !234)
!251 = !DILocation(line: 21, column: 1, scope: !234)
