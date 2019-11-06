; RUN: opt %mpidfsan -extrap-extractor-out-name=%t4 -S < %s 2> /dev/null | llc %llcparams - -o %t1 && clang++ %link %t1 -o %t2 && %execparams mpiexec -n 2 %t2 10 10 10 && diff -w %s.json %t4_0.json && diff -w %s.json %t4_1.json
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
define dso_local double @_Z16h_multiple_loopsPdm(double*, i64) #2 !dbg !128 {
  %3 = alloca double*, align 8
  %4 = alloca i64, align 8
  %5 = alloca i32, align 4
  %6 = alloca double, align 8
  store double* %0, double** %3, align 8
  call void @llvm.dbg.declare(metadata double** %3, metadata !131, metadata !DIExpression()), !dbg !132
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !133, metadata !DIExpression()), !dbg !134
  call void @llvm.dbg.declare(metadata i32* %5, metadata !135, metadata !DIExpression()), !dbg !137
  store i32 0, i32* %5, align 4, !dbg !137
  br label %7, !dbg !138

; <label>:7:                                      ; preds = %19, %2
  %8 = load i32, i32* %5, align 4, !dbg !139
  %9 = sext i32 %8 to i64, !dbg !139
  %10 = load i64, i64* %4, align 8, !dbg !141
  %11 = icmp ult i64 %9, %10, !dbg !142
  br i1 %11, label %12, label %22, !dbg !143

; <label>:12:                                     ; preds = %7
  %13 = load double*, double** %3, align 8, !dbg !144
  %14 = load i32, i32* %5, align 4, !dbg !145
  %15 = sext i32 %14 to i64, !dbg !144
  %16 = getelementptr inbounds double, double* %13, i64 %15, !dbg !144
  %17 = load double, double* %16, align 8, !dbg !146
  %18 = fadd double %17, 1.000000e+00, !dbg !146
  store double %18, double* %16, align 8, !dbg !146
  br label %19, !dbg !144

; <label>:19:                                     ; preds = %12
  %20 = load i32, i32* %5, align 4, !dbg !147
  %21 = add nsw i32 %20, 1, !dbg !147
  store i32 %21, i32* %5, align 4, !dbg !147
  br label %7, !dbg !148, !llvm.loop !149

; <label>:22:                                     ; preds = %7
  call void @llvm.dbg.declare(metadata double* %6, metadata !151, metadata !DIExpression()), !dbg !152
  %23 = load double*, double** %3, align 8, !dbg !153
  %24 = getelementptr inbounds double, double* %23, i64 0, !dbg !153
  %25 = load double, double* %24, align 8, !dbg !153
  store double %25, double* %6, align 8, !dbg !152
  %26 = load double*, double** %3, align 8, !dbg !154
  %27 = bitcast double* %26 to i8*, !dbg !154
  %28 = bitcast double* %6 to i8*, !dbg !155
  %29 = call i32 @MPI_Reduce(i8* %27, i8* %28, i32 1, %struct.ompi_datatype_t* bitcast (%struct.ompi_predefined_datatype_t* @ompi_mpi_double to %struct.ompi_datatype_t*), %struct.ompi_op_t* bitcast (%struct.ompi_predefined_op_t* @ompi_mpi_op_sum to %struct.ompi_op_t*), i32 0, %struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*)), !dbg !156
  %30 = load double, double* %6, align 8, !dbg !157
  ret double %30, !dbg !158
}

declare dso_local i32 @MPI_Reduce(i8*, i8*, i32, %struct.ompi_datatype_t*, %struct.ompi_op_t*, i32, %struct.ompi_communicator_t*) #3

; Function Attrs: noinline optnone uwtable
define dso_local double @_Z1hPd(double*) #2 !dbg !159 {
  %2 = alloca double*, align 8
  %3 = alloca double, align 8
  store double* %0, double** %2, align 8
  call void @llvm.dbg.declare(metadata double** %2, metadata !162, metadata !DIExpression()), !dbg !163
  call void @llvm.dbg.declare(metadata double* %3, metadata !164, metadata !DIExpression()), !dbg !165
  %4 = load double*, double** %2, align 8, !dbg !166
  %5 = getelementptr inbounds double, double* %4, i64 0, !dbg !166
  %6 = load double, double* %5, align 8, !dbg !166
  store double %6, double* %3, align 8, !dbg !165
  %7 = load double*, double** %2, align 8, !dbg !167
  %8 = bitcast double* %7 to i8*, !dbg !167
  %9 = bitcast double* %3 to i8*, !dbg !168
  %10 = call i32 @MPI_Reduce(i8* %8, i8* %9, i32 1, %struct.ompi_datatype_t* bitcast (%struct.ompi_predefined_datatype_t* @ompi_mpi_double to %struct.ompi_datatype_t*), %struct.ompi_op_t* bitcast (%struct.ompi_predefined_op_t* @ompi_mpi_op_sum to %struct.ompi_op_t*), i32 0, %struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*)), !dbg !169
  %11 = load double, double* %3, align 8, !dbg !170
  ret double %11, !dbg !171
}

; Function Attrs: noinline optnone uwtable
define dso_local void @_Z8h_nestedPdm(double*, i64) #2 !dbg !172 {
  %3 = alloca double*, align 8
  %4 = alloca i64, align 8
  %5 = alloca i32, align 4
  store double* %0, double** %3, align 8
  call void @llvm.dbg.declare(metadata double** %3, metadata !173, metadata !DIExpression()), !dbg !174
  store i64 %1, i64* %4, align 8
  call void @llvm.dbg.declare(metadata i64* %4, metadata !175, metadata !DIExpression()), !dbg !176
  call void @llvm.dbg.declare(metadata i32* %5, metadata !177, metadata !DIExpression()), !dbg !179
  store i32 0, i32* %5, align 4, !dbg !179
  br label %6, !dbg !180

; <label>:6:                                      ; preds = %17, %2
  %7 = load i32, i32* %5, align 4, !dbg !181
  %8 = sext i32 %7 to i64, !dbg !181
  %9 = load i64, i64* %4, align 8, !dbg !183
  %10 = icmp ult i64 %8, %9, !dbg !184
  br i1 %10, label %11, label %20, !dbg !185

; <label>:11:                                     ; preds = %6
  %12 = load double*, double** %3, align 8, !dbg !186
  %13 = load i32, i32* %5, align 4, !dbg !188
  %14 = sext i32 %13 to i64, !dbg !186
  %15 = getelementptr inbounds double, double* %12, i64 %14, !dbg !186
  %16 = call double @_Z1hPd(double* %15), !dbg !189
  br label %17, !dbg !190

; <label>:17:                                     ; preds = %11
  %18 = load i32, i32* %5, align 4, !dbg !191
  %19 = add nsw i32 %18, 1, !dbg !191
  store i32 %19, i32* %5, align 4, !dbg !191
  br label %6, !dbg !192, !llvm.loop !193

; <label>:20:                                     ; preds = %6
  ret void, !dbg !195
}

; Function Attrs: noinline norecurse optnone uwtable
define dso_local i32 @main(i32, i8**) #4 !dbg !196 {
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
  call void @llvm.dbg.declare(metadata i32* %4, metadata !202, metadata !DIExpression()), !dbg !203
  store i8** %1, i8*** %5, align 8
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !204, metadata !DIExpression()), !dbg !205
  %12 = call i32 @MPI_Init(i32* %4, i8*** %5), !dbg !206
  call void @llvm.dbg.declare(metadata i32* %6, metadata !207, metadata !DIExpression()), !dbg !208
  %13 = bitcast i32* %6 to i8*, !dbg !209
  call void @llvm.var.annotation(i8* %13, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([33 x i8], [33 x i8]* @.str.1, i32 0, i32 0), i32 43), !dbg !209
  %14 = load i8**, i8*** %5, align 8, !dbg !210
  %15 = getelementptr inbounds i8*, i8** %14, i64 1, !dbg !210
  %16 = load i8*, i8** %15, align 8, !dbg !210
  %17 = call i32 @atoi(i8* %16) #8, !dbg !211
  store i32 %17, i32* %6, align 4, !dbg !208
  call void @_Z17register_variableIiEvPT_PKc(i32* %6, i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.2, i32 0, i32 0)), !dbg !212
  call void @llvm.dbg.declare(metadata i32* %7, metadata !213, metadata !DIExpression()), !dbg !214
  %18 = bitcast i32* %7 to i8*, !dbg !215
  call void @llvm.var.annotation(i8* %18, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([33 x i8], [33 x i8]* @.str.1, i32 0, i32 0), i32 45), !dbg !215
  store i32 1, i32* %7, align 4, !dbg !214
  call void @llvm.dbg.declare(metadata i32* %8, metadata !216, metadata !DIExpression()), !dbg !217
  %19 = call i32 @MPI_Comm_size(%struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*), i32* %7), !dbg !218
  %20 = call i32 @MPI_Comm_rank(%struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*), i32* %8), !dbg !219
  call void @_Z17register_variableIiEvPT_PKc(i32* %7, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.3, i32 0, i32 0)), !dbg !220
  %21 = load i32, i32* %7, align 4, !dbg !221
  %22 = load i32, i32* %6, align 4, !dbg !222
  %23 = sdiv i32 %22, %21, !dbg !222
  store i32 %23, i32* %6, align 4, !dbg !222
  call void @llvm.dbg.declare(metadata i32* %9, metadata !223, metadata !DIExpression()), !dbg !224
  %24 = load i32, i32* %6, align 4, !dbg !225
  %25 = load i32, i32* %8, align 4, !dbg !226
  %26 = mul nsw i32 %24, %25, !dbg !227
  store i32 %26, i32* %9, align 4, !dbg !224
  call void @llvm.dbg.declare(metadata double** %10, metadata !228, metadata !DIExpression()), !dbg !229
  %27 = load i32, i32* %6, align 4, !dbg !230
  %28 = sext i32 %27 to i64, !dbg !230
  %29 = call noalias i8* @calloc(i64 %28, i64 8) #5, !dbg !231
  %30 = bitcast i8* %29 to double*, !dbg !232
  store double* %30, double** %10, align 8, !dbg !229
  %31 = load double*, double** %10, align 8, !dbg !233
  %32 = load i32, i32* %6, align 4, !dbg !234
  %33 = sext i32 %32 to i64, !dbg !234
  call void @_Z1fPdm(double* %31, i64 %33), !dbg !235
  call void @llvm.dbg.declare(metadata double* %11, metadata !236, metadata !DIExpression()), !dbg !237
  %34 = load double*, double** %10, align 8, !dbg !238
  %35 = load i32, i32* %6, align 4, !dbg !239
  %36 = sext i32 %35 to i64, !dbg !239
  %37 = call double @_Z16h_multiple_loopsPdm(double* %34, i64 %36), !dbg !240
  store double %37, double* %11, align 8, !dbg !237
  %38 = load double*, double** %10, align 8, !dbg !241
  %39 = load i32, i32* %6, align 4, !dbg !242
  %40 = sext i32 %39 to i64, !dbg !242
  call void @_Z8h_nestedPdm(double* %38, i64 %40), !dbg !243
  %41 = load i32, i32* %8, align 4, !dbg !244
  %42 = icmp eq i32 %41, 0, !dbg !246
  br i1 %42, label %43, label %46, !dbg !247

; <label>:43:                                     ; preds = %2
  %44 = load double, double* %11, align 8, !dbg !248
  %45 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i32 0, i32 0), double %44), !dbg !249
  br label %46, !dbg !249

; <label>:46:                                     ; preds = %43, %2
  %47 = call i32 @MPI_Barrier(%struct.ompi_communicator_t* bitcast (%struct.ompi_predefined_communicator_t* @ompi_mpi_comm_world to %struct.ompi_communicator_t*)), !dbg !250
  %48 = load double*, double** %10, align 8, !dbg !251
  %49 = bitcast double* %48 to i8*, !dbg !251
  call void @free(i8* %49) #5, !dbg !252
  %50 = call i32 @MPI_Finalize(), !dbg !253
  ret i32 0, !dbg !254
}

declare dso_local i32 @MPI_Init(i32*, i8***) #3

; Function Attrs: nounwind
declare void @llvm.var.annotation(i8*, i8*, i8*, i32) #5

; Function Attrs: nounwind readonly
declare dso_local i32 @atoi(i8*) #6

; Function Attrs: noinline optnone uwtable
define linkonce_odr dso_local void @_Z17register_variableIiEvPT_PKc(i32*, i8*) #2 comdat !dbg !255 {
  %3 = alloca i32*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca i32, align 4
  store i32* %0, i32** %3, align 8
  call void @llvm.dbg.declare(metadata i32** %3, metadata !264, metadata !DIExpression()), !dbg !265
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !266, metadata !DIExpression()), !dbg !267
  call void @llvm.dbg.declare(metadata i32* %5, metadata !268, metadata !DIExpression()), !dbg !269
  %6 = call i32 @__dfsw_EXTRAP_VAR_ID(), !dbg !270
  store i32 %6, i32* %5, align 4, !dbg !269
  %7 = load i32*, i32** %3, align 8, !dbg !271
  %8 = bitcast i32* %7 to i8*, !dbg !272
  %9 = load i32, i32* %5, align 4, !dbg !273
  %10 = add nsw i32 %9, 1, !dbg !273
  store i32 %10, i32* %5, align 4, !dbg !273
  %11 = load i8*, i8** %4, align 8, !dbg !274
  call void @__dfsw_EXTRAP_STORE_LABEL(i8* %8, i32 4, i32 %9, i8* %11), !dbg !275
  ret void, !dbg !276
}

declare dso_local i32 @MPI_Comm_size(%struct.ompi_communicator_t*, i32*) #3

declare dso_local i32 @MPI_Comm_rank(%struct.ompi_communicator_t*, i32*) #3

; Function Attrs: nounwind
declare dso_local noalias i8* @calloc(i64, i64) #7

declare dso_local i32 @printf(i8*, ...) #3

declare dso_local i32 @MPI_Barrier(%struct.ompi_communicator_t*) #3

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
!128 = distinct !DISubprogram(name: "h_multiple_loops", linkageName: "_Z16h_multiple_loopsPdm", scope: !1, file: !1, line: 17, type: !129, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!129 = !DISubroutineType(types: !130)
!130 = !{!16, !15, !112}
!131 = !DILocalVariable(name: "data", arg: 1, scope: !128, file: !1, line: 17, type: !15)
!132 = !DILocation(line: 17, column: 34, scope: !128)
!133 = !DILocalVariable(name: "size", arg: 2, scope: !128, file: !1, line: 17, type: !112)
!134 = !DILocation(line: 17, column: 47, scope: !128)
!135 = !DILocalVariable(name: "i", scope: !136, file: !1, line: 19, type: !40)
!136 = distinct !DILexicalBlock(scope: !128, file: !1, line: 19, column: 5)
!137 = !DILocation(line: 19, column: 13, scope: !136)
!138 = !DILocation(line: 19, column: 9, scope: !136)
!139 = !DILocation(line: 19, column: 20, scope: !140)
!140 = distinct !DILexicalBlock(scope: !136, file: !1, line: 19, column: 5)
!141 = !DILocation(line: 19, column: 24, scope: !140)
!142 = !DILocation(line: 19, column: 22, scope: !140)
!143 = !DILocation(line: 19, column: 5, scope: !136)
!144 = !DILocation(line: 20, column: 9, scope: !140)
!145 = !DILocation(line: 20, column: 14, scope: !140)
!146 = !DILocation(line: 20, column: 16, scope: !140)
!147 = !DILocation(line: 19, column: 30, scope: !140)
!148 = !DILocation(line: 19, column: 5, scope: !140)
!149 = distinct !{!149, !143, !150}
!150 = !DILocation(line: 20, column: 16, scope: !136)
!151 = !DILocalVariable(name: "acc_rcv", scope: !128, file: !1, line: 21, type: !16)
!152 = !DILocation(line: 21, column: 12, scope: !128)
!153 = !DILocation(line: 21, column: 22, scope: !128)
!154 = !DILocation(line: 22, column: 16, scope: !128)
!155 = !DILocation(line: 22, column: 22, scope: !128)
!156 = !DILocation(line: 22, column: 5, scope: !128)
!157 = !DILocation(line: 23, column: 12, scope: !128)
!158 = !DILocation(line: 23, column: 5, scope: !128)
!159 = distinct !DISubprogram(name: "h", linkageName: "_Z1hPd", scope: !1, file: !1, line: 26, type: !160, scopeLine: 27, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!160 = !DISubroutineType(types: !161)
!161 = !{!16, !15}
!162 = !DILocalVariable(name: "data", arg: 1, scope: !159, file: !1, line: 26, type: !15)
!163 = !DILocation(line: 26, column: 19, scope: !159)
!164 = !DILocalVariable(name: "acc_rcv", scope: !159, file: !1, line: 28, type: !16)
!165 = !DILocation(line: 28, column: 12, scope: !159)
!166 = !DILocation(line: 28, column: 22, scope: !159)
!167 = !DILocation(line: 29, column: 16, scope: !159)
!168 = !DILocation(line: 29, column: 22, scope: !159)
!169 = !DILocation(line: 29, column: 5, scope: !159)
!170 = !DILocation(line: 30, column: 12, scope: !159)
!171 = !DILocation(line: 30, column: 5, scope: !159)
!172 = distinct !DISubprogram(name: "h_nested", linkageName: "_Z8h_nestedPdm", scope: !1, file: !1, line: 33, type: !110, scopeLine: 34, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!173 = !DILocalVariable(name: "data", arg: 1, scope: !172, file: !1, line: 33, type: !15)
!174 = !DILocation(line: 33, column: 24, scope: !172)
!175 = !DILocalVariable(name: "size", arg: 2, scope: !172, file: !1, line: 33, type: !112)
!176 = !DILocation(line: 33, column: 37, scope: !172)
!177 = !DILocalVariable(name: "i", scope: !178, file: !1, line: 35, type: !40)
!178 = distinct !DILexicalBlock(scope: !172, file: !1, line: 35, column: 5)
!179 = !DILocation(line: 35, column: 13, scope: !178)
!180 = !DILocation(line: 35, column: 9, scope: !178)
!181 = !DILocation(line: 35, column: 20, scope: !182)
!182 = distinct !DILexicalBlock(scope: !178, file: !1, line: 35, column: 5)
!183 = !DILocation(line: 35, column: 24, scope: !182)
!184 = !DILocation(line: 35, column: 22, scope: !182)
!185 = !DILocation(line: 35, column: 5, scope: !178)
!186 = !DILocation(line: 36, column: 12, scope: !187)
!187 = distinct !DILexicalBlock(scope: !182, file: !1, line: 35, column: 35)
!188 = !DILocation(line: 36, column: 17, scope: !187)
!189 = !DILocation(line: 36, column: 9, scope: !187)
!190 = !DILocation(line: 37, column: 5, scope: !187)
!191 = !DILocation(line: 35, column: 30, scope: !182)
!192 = !DILocation(line: 35, column: 5, scope: !182)
!193 = distinct !{!193, !185, !194}
!194 = !DILocation(line: 37, column: 5, scope: !178)
!195 = !DILocation(line: 38, column: 1, scope: !172)
!196 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 40, type: !197, scopeLine: 41, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!197 = !DISubroutineType(types: !198)
!198 = !{!40, !40, !199}
!199 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !200, size: 64)
!200 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !201, size: 64)
!201 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!202 = !DILocalVariable(name: "argc", arg: 1, scope: !196, file: !1, line: 40, type: !40)
!203 = !DILocation(line: 40, column: 14, scope: !196)
!204 = !DILocalVariable(name: "argv", arg: 2, scope: !196, file: !1, line: 40, type: !199)
!205 = !DILocation(line: 40, column: 28, scope: !196)
!206 = !DILocation(line: 42, column: 5, scope: !196)
!207 = !DILocalVariable(name: "size", scope: !196, file: !1, line: 43, type: !40)
!208 = !DILocation(line: 43, column: 9, scope: !196)
!209 = !DILocation(line: 43, column: 5, scope: !196)
!210 = !DILocation(line: 43, column: 28, scope: !196)
!211 = !DILocation(line: 43, column: 23, scope: !196)
!212 = !DILocation(line: 44, column: 5, scope: !196)
!213 = !DILocalVariable(name: "ranks", scope: !196, file: !1, line: 45, type: !40)
!214 = !DILocation(line: 45, column: 9, scope: !196)
!215 = !DILocation(line: 45, column: 5, scope: !196)
!216 = !DILocalVariable(name: "rank_id", scope: !196, file: !1, line: 45, type: !40)
!217 = !DILocation(line: 45, column: 27, scope: !196)
!218 = !DILocation(line: 46, column: 5, scope: !196)
!219 = !DILocation(line: 47, column: 5, scope: !196)
!220 = !DILocation(line: 49, column: 5, scope: !196)
!221 = !DILocation(line: 51, column: 13, scope: !196)
!222 = !DILocation(line: 51, column: 10, scope: !196)
!223 = !DILocalVariable(name: "start", scope: !196, file: !1, line: 52, type: !40)
!224 = !DILocation(line: 52, column: 9, scope: !196)
!225 = !DILocation(line: 52, column: 17, scope: !196)
!226 = !DILocation(line: 52, column: 24, scope: !196)
!227 = !DILocation(line: 52, column: 22, scope: !196)
!228 = !DILocalVariable(name: "data", scope: !196, file: !1, line: 53, type: !15)
!229 = !DILocation(line: 53, column: 14, scope: !196)
!230 = !DILocation(line: 53, column: 38, scope: !196)
!231 = !DILocation(line: 53, column: 31, scope: !196)
!232 = !DILocation(line: 53, column: 21, scope: !196)
!233 = !DILocation(line: 54, column: 7, scope: !196)
!234 = !DILocation(line: 54, column: 13, scope: !196)
!235 = !DILocation(line: 54, column: 5, scope: !196)
!236 = !DILocalVariable(name: "acc_rcv", scope: !196, file: !1, line: 55, type: !16)
!237 = !DILocation(line: 55, column: 12, scope: !196)
!238 = !DILocation(line: 55, column: 39, scope: !196)
!239 = !DILocation(line: 55, column: 45, scope: !196)
!240 = !DILocation(line: 55, column: 22, scope: !196)
!241 = !DILocation(line: 56, column: 14, scope: !196)
!242 = !DILocation(line: 56, column: 20, scope: !196)
!243 = !DILocation(line: 56, column: 5, scope: !196)
!244 = !DILocation(line: 57, column: 8, scope: !245)
!245 = distinct !DILexicalBlock(scope: !196, file: !1, line: 57, column: 8)
!246 = !DILocation(line: 57, column: 16, scope: !245)
!247 = !DILocation(line: 57, column: 8, scope: !196)
!248 = !DILocation(line: 58, column: 24, scope: !245)
!249 = !DILocation(line: 58, column: 9, scope: !245)
!250 = !DILocation(line: 59, column: 5, scope: !196)
!251 = !DILocation(line: 60, column: 10, scope: !196)
!252 = !DILocation(line: 60, column: 5, scope: !196)
!253 = !DILocation(line: 61, column: 5, scope: !196)
!254 = !DILocation(line: 62, column: 5, scope: !196)
!255 = distinct !DISubprogram(name: "register_variable<int>", linkageName: "_Z17register_variableIiEvPT_PKc", scope: !256, file: !256, line: 14, type: !257, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, templateParams: !262, retainedNodes: !2)
!256 = !DIFile(filename: "include/ExtraPInstrumenter.hpp", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!257 = !DISubroutineType(types: !258)
!258 = !{null, !259, !260}
!259 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !40, size: 64)
!260 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !261, size: 64)
!261 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !201)
!262 = !{!263}
!263 = !DITemplateTypeParameter(name: "T", type: !40)
!264 = !DILocalVariable(name: "ptr", arg: 1, scope: !255, file: !256, line: 14, type: !259)
!265 = !DILocation(line: 14, column: 28, scope: !255)
!266 = !DILocalVariable(name: "name", arg: 2, scope: !255, file: !256, line: 14, type: !260)
!267 = !DILocation(line: 14, column: 46, scope: !255)
!268 = !DILocalVariable(name: "param_id", scope: !255, file: !256, line: 16, type: !38)
!269 = !DILocation(line: 16, column: 13, scope: !255)
!270 = !DILocation(line: 16, column: 24, scope: !255)
!271 = !DILocation(line: 17, column: 57, scope: !255)
!272 = !DILocation(line: 17, column: 31, scope: !255)
!273 = !DILocation(line: 18, column: 21, scope: !255)
!274 = !DILocation(line: 18, column: 25, scope: !255)
!275 = !DILocation(line: 17, column: 5, scope: !255)
!276 = !DILocation(line: 19, column: 1, scope: !255)
