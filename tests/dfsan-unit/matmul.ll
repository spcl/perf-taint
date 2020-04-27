; RUN: opt %dfsan -S < %s 2> /dev/null | llc %llcparams - -o %t1 && clang++ %t1 -o %t2 %link && %execparams %t2 50 30 40 > %t2.json && diff -w %s.json %t2.json
; RUN: %jsonconvert %s.json 2> /dev/null | diff -w %s.processed.json -
; ModuleID = 'tests/dfsan-unit/matmul.c'
source_filename = "tests/dfsan-unit/matmul.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }
%struct.__va_list_tag = type { i32, i32, i8*, i8* }
%struct._matrix = type { i64, i64, double* }

@stderr = external dso_local global %struct._IO_FILE*, align 8
@.str = private unnamed_addr constant [19 x i8] c"Register variable\0A\00", align 1
@.str.1 = private unnamed_addr constant [24 x i8] c"Register %zu variables\0A\00", align 1
@.str.2 = private unnamed_addr constant [7 x i8] c"extrap\00", section "llvm.metadata"
@.str.3 = private unnamed_addr constant [26 x i8] c"tests/dfsan-unit/matmul.c\00", section "llvm.metadata"
@.str.4 = private unnamed_addr constant [10 x i8] c"argc == 4\00", align 1
@.str.5 = private unnamed_addr constant [26 x i8] c"tests/dfsan-unit/matmul.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [23 x i8] c"int main(int, char **)\00", align 1
@.str.6 = private unnamed_addr constant [2 x i8] c"m\00", align 1
@.str.7 = private unnamed_addr constant [2 x i8] c"n\00", align 1
@.str.8 = private unnamed_addr constant [2 x i8] c"k\00", align 1
@.str.9 = private unnamed_addr constant [4 x i8] c"%f\0A\00", align 1

; Function Attrs: nounwind uwtable
define dso_local void @register_variable(i8*, i64, i8*) #0 !dbg !21 {
  %4 = alloca i8*, align 8
  %5 = alloca i64, align 8
  %6 = alloca i8*, align 8
  store i8* %0, i8** %4, align 8, !tbaa !34
  call void @llvm.dbg.declare(metadata i8** %4, metadata !31, metadata !DIExpression()), !dbg !38
  store i64 %1, i64* %5, align 8, !tbaa !39
  call void @llvm.dbg.declare(metadata i64* %5, metadata !32, metadata !DIExpression()), !dbg !41
  store i8* %2, i8** %6, align 8, !tbaa !34
  call void @llvm.dbg.declare(metadata i8** %6, metadata !33, metadata !DIExpression()), !dbg !42
  %7 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !43, !tbaa !34
  %8 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %7, i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str, i64 0, i64 0)), !dbg !44
  %9 = load i8*, i8** %4, align 8, !dbg !45, !tbaa !34
  %10 = load i64, i64* %5, align 8, !dbg !46, !tbaa !39
  %11 = trunc i64 %10 to i32, !dbg !46
  %12 = load i8*, i8** %6, align 8, !dbg !47, !tbaa !34
  call void @__dfsw_EXTRAP_WRITE_LABEL(i8* %9, i32 %11, i8* %12), !dbg !48
  ret void, !dbg !49
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare dso_local i32 @fprintf(%struct._IO_FILE*, i8*, ...) #2

declare dso_local void @__dfsw_EXTRAP_WRITE_LABEL(i8*, i32, i8*) #2

; Function Attrs: nounwind uwtable
define dso_local void @register_variables(i8*, i64, ...) #0 !dbg !50 {
  %3 = alloca i8*, align 8
  %4 = alloca i64, align 8
  %5 = alloca [1 x %struct.__va_list_tag], align 16
  store i8* %0, i8** %3, align 8, !tbaa !34
  call void @llvm.dbg.declare(metadata i8** %3, metadata !54, metadata !DIExpression()), !dbg !72
  store i64 %1, i64* %4, align 8, !tbaa !39
  call void @llvm.dbg.declare(metadata i64* %4, metadata !55, metadata !DIExpression()), !dbg !73
  %6 = bitcast [1 x %struct.__va_list_tag]* %5 to i8*, !dbg !74
  call void @llvm.lifetime.start.p0i8(i64 24, i8* %6) #4, !dbg !74
  call void @llvm.dbg.declare(metadata [1 x %struct.__va_list_tag]* %5, metadata !56, metadata !DIExpression()), !dbg !75
  %7 = getelementptr inbounds [1 x %struct.__va_list_tag], [1 x %struct.__va_list_tag]* %5, i64 0, i64 0, !dbg !76
  %8 = bitcast %struct.__va_list_tag* %7 to i8*, !dbg !76
  call void @llvm.va_start(i8* %8), !dbg !76
  %9 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !77, !tbaa !34
  %10 = load i64, i64* %4, align 8, !dbg !78, !tbaa !39
  %11 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %9, i8* getelementptr inbounds ([24 x i8], [24 x i8]* @.str.1, i64 0, i64 0), i64 %10), !dbg !79
  %12 = load i8*, i8** %3, align 8, !dbg !80, !tbaa !34
  %13 = load i64, i64* %4, align 8, !dbg !81, !tbaa !39
  %14 = getelementptr inbounds [1 x %struct.__va_list_tag], [1 x %struct.__va_list_tag]* %5, i64 0, i64 0, !dbg !82
  call void @__dfsw_EXTRAP_WRITE_LABELS(i8* %12, i64 %13, %struct.__va_list_tag* %14), !dbg !83
  %15 = bitcast [1 x %struct.__va_list_tag]* %5 to i8*, !dbg !84
  call void @llvm.lifetime.end.p0i8(i64 24, i8* %15) #4, !dbg !84
  ret void, !dbg !84
}

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #3

; Function Attrs: nounwind
declare void @llvm.va_start(i8*) #4

declare dso_local void @__dfsw_EXTRAP_WRITE_LABELS(i8*, i64, %struct.__va_list_tag*) #2

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #3

; Function Attrs: nounwind uwtable
define dso_local void @create_matrix(%struct._matrix* noalias sret, i32, i32, i1 zeroext) #0 !dbg !85 {
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i8, align 1
  %8 = alloca i64, align 8
  %9 = alloca i64, align 8
  store i32 %1, i32* %5, align 4, !tbaa !105
  call void @llvm.dbg.declare(metadata i32* %5, metadata !96, metadata !DIExpression()), !dbg !107
  store i32 %2, i32* %6, align 4, !tbaa !105
  call void @llvm.dbg.declare(metadata i32* %6, metadata !97, metadata !DIExpression()), !dbg !108
  %10 = zext i1 %3 to i8
  store i8 %10, i8* %7, align 1, !tbaa !109
  call void @llvm.dbg.declare(metadata i8* %7, metadata !98, metadata !DIExpression()), !dbg !111
  call void @llvm.dbg.declare(metadata %struct._matrix* %0, metadata !99, metadata !DIExpression()), !dbg !112
  %11 = load i32, i32* %5, align 4, !dbg !113, !tbaa !105
  %12 = sext i32 %11 to i64, !dbg !113
  %13 = getelementptr inbounds %struct._matrix, %struct._matrix* %0, i32 0, i32 0, !dbg !114
  store i64 %12, i64* %13, align 8, !dbg !115, !tbaa !116
  %14 = load i32, i32* %6, align 4, !dbg !118, !tbaa !105
  %15 = sext i32 %14 to i64, !dbg !118
  %16 = getelementptr inbounds %struct._matrix, %struct._matrix* %0, i32 0, i32 1, !dbg !119
  store i64 %15, i64* %16, align 8, !dbg !120, !tbaa !121
  %17 = load i32, i32* %5, align 4, !dbg !122, !tbaa !105
  %18 = load i32, i32* %6, align 4, !dbg !123, !tbaa !105
  %19 = mul nsw i32 %17, %18, !dbg !124
  %20 = sext i32 %19 to i64, !dbg !122
  %21 = call noalias i8* @calloc(i64 %20, i64 8) #4, !dbg !125
  %22 = bitcast i8* %21 to double*, !dbg !126
  %23 = getelementptr inbounds %struct._matrix, %struct._matrix* %0, i32 0, i32 2, !dbg !127
  store double* %22, double** %23, align 8, !dbg !128, !tbaa !129
  %24 = load i8, i8* %7, align 1, !dbg !130, !tbaa !109, !range !131
  %25 = trunc i8 %24 to i1, !dbg !130
  br i1 %25, label %26, label %52, !dbg !132

26:                                               ; preds = %4
  %27 = bitcast i64* %8 to i8*, !dbg !133
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %27) #4, !dbg !133
  call void @llvm.dbg.declare(metadata i64* %8, metadata !100, metadata !DIExpression()), !dbg !134
  %28 = load i32, i32* %5, align 4, !dbg !135, !tbaa !105
  %29 = load i32, i32* %6, align 4, !dbg !136, !tbaa !105
  %30 = mul nsw i32 %28, %29, !dbg !137
  %31 = sext i32 %30 to i64, !dbg !135
  store i64 %31, i64* %8, align 8, !dbg !134, !tbaa !39
  %32 = bitcast i64* %9 to i8*, !dbg !138
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %32) #4, !dbg !138
  call void @llvm.dbg.declare(metadata i64* %9, metadata !103, metadata !DIExpression()), !dbg !139
  store i64 0, i64* %9, align 8, !dbg !139, !tbaa !39
  br label %33, !dbg !138

33:                                               ; preds = %47, %26
  %34 = load i64, i64* %9, align 8, !dbg !140, !tbaa !39
  %35 = load i64, i64* %8, align 8, !dbg !142, !tbaa !39
  %36 = icmp ult i64 %34, %35, !dbg !143
  br i1 %36, label %39, label %37, !dbg !144

37:                                               ; preds = %33
  %38 = bitcast i64* %9 to i8*, !dbg !145
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %38) #4, !dbg !145
  br label %50

39:                                               ; preds = %33
  %40 = call i32 @rand() #4, !dbg !146
  %41 = srem i32 %40, 100, !dbg !147
  %42 = sitofp i32 %41 to double, !dbg !146
  %43 = getelementptr inbounds %struct._matrix, %struct._matrix* %0, i32 0, i32 2, !dbg !148
  %44 = load double*, double** %43, align 8, !dbg !148, !tbaa !129
  %45 = load i64, i64* %9, align 8, !dbg !149, !tbaa !39
  %46 = getelementptr inbounds double, double* %44, i64 %45, !dbg !150
  store double %42, double* %46, align 8, !dbg !151, !tbaa !152
  br label %47, !dbg !150

47:                                               ; preds = %39
  %48 = load i64, i64* %9, align 8, !dbg !154, !tbaa !39
  %49 = add i64 %48, 1, !dbg !154
  store i64 %49, i64* %9, align 8, !dbg !154, !tbaa !39
  br label %33, !dbg !145, !llvm.loop !155

50:                                               ; preds = %37
  %51 = bitcast i64* %8 to i8*, !dbg !157
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %51) #4, !dbg !157
  br label %52, !dbg !158

52:                                               ; preds = %50, %4
  ret void, !dbg !159
}

; Function Attrs: nounwind
declare dso_local noalias i8* @calloc(i64, i64) #5

; Function Attrs: nounwind
declare dso_local i32 @rand() #5

; Function Attrs: nounwind uwtable
define dso_local void @mat_mul(%struct._matrix* noalias sret, %struct._matrix*, %struct._matrix*) #0 !dbg !160 {
  %4 = alloca %struct._matrix*, align 8
  %5 = alloca %struct._matrix*, align 8
  %6 = alloca i64, align 8
  %7 = alloca i64, align 8
  %8 = alloca i64, align 8
  %9 = alloca i64, align 8
  %10 = alloca i32, align 4
  %11 = alloca i64, align 8
  %12 = alloca double, align 8
  %13 = alloca i64, align 8
  store %struct._matrix* %1, %struct._matrix** %4, align 8, !tbaa !34
  call void @llvm.dbg.declare(metadata %struct._matrix** %4, metadata !165, metadata !DIExpression()), !dbg !182
  store %struct._matrix* %2, %struct._matrix** %5, align 8, !tbaa !34
  call void @llvm.dbg.declare(metadata %struct._matrix** %5, metadata !166, metadata !DIExpression()), !dbg !183
  %14 = bitcast i64* %6 to i8*, !dbg !184
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %14) #4, !dbg !184
  call void @llvm.dbg.declare(metadata i64* %6, metadata !167, metadata !DIExpression()), !dbg !185
  %15 = load %struct._matrix*, %struct._matrix** %4, align 8, !dbg !186, !tbaa !34
  %16 = getelementptr inbounds %struct._matrix, %struct._matrix* %15, i32 0, i32 0, !dbg !187
  %17 = load i64, i64* %16, align 8, !dbg !187, !tbaa !116
  store i64 %17, i64* %6, align 8, !dbg !185, !tbaa !39
  %18 = bitcast i64* %7 to i8*, !dbg !184
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %18) #4, !dbg !184
  call void @llvm.dbg.declare(metadata i64* %7, metadata !168, metadata !DIExpression()), !dbg !188
  %19 = load %struct._matrix*, %struct._matrix** %4, align 8, !dbg !189, !tbaa !34
  %20 = getelementptr inbounds %struct._matrix, %struct._matrix* %19, i32 0, i32 1, !dbg !190
  %21 = load i64, i64* %20, align 8, !dbg !190, !tbaa !121
  store i64 %21, i64* %7, align 8, !dbg !188, !tbaa !39
  %22 = bitcast i64* %8 to i8*, !dbg !184
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %22) #4, !dbg !184
  call void @llvm.dbg.declare(metadata i64* %8, metadata !169, metadata !DIExpression()), !dbg !191
  %23 = load %struct._matrix*, %struct._matrix** %5, align 8, !dbg !192, !tbaa !34
  %24 = getelementptr inbounds %struct._matrix, %struct._matrix* %23, i32 0, i32 1, !dbg !193
  %25 = load i64, i64* %24, align 8, !dbg !193, !tbaa !121
  store i64 %25, i64* %8, align 8, !dbg !191, !tbaa !39
  call void @llvm.dbg.declare(metadata %struct._matrix* %0, metadata !170, metadata !DIExpression()), !dbg !194
  %26 = load i64, i64* %6, align 8, !dbg !195, !tbaa !39
  %27 = trunc i64 %26 to i32, !dbg !195
  %28 = load i64, i64* %8, align 8, !dbg !196, !tbaa !39
  %29 = trunc i64 %28 to i32, !dbg !196
  call void @create_matrix(%struct._matrix* sret %0, i32 %27, i32 %29, i1 zeroext false), !dbg !197
  %30 = bitcast i64* %9 to i8*, !dbg !198
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %30) #4, !dbg !198
  call void @llvm.dbg.declare(metadata i64* %9, metadata !171, metadata !DIExpression()), !dbg !199
  store i64 0, i64* %9, align 8, !dbg !199, !tbaa !39
  br label %31, !dbg !198

31:                                               ; preds = %96, %3
  %32 = load i64, i64* %9, align 8, !dbg !200, !tbaa !39
  %33 = load i64, i64* %6, align 8, !dbg !201, !tbaa !39
  %34 = icmp ult i64 %32, %33, !dbg !202
  br i1 %34, label %37, label %35, !dbg !203

35:                                               ; preds = %31
  store i32 2, i32* %10, align 4
  %36 = bitcast i64* %9 to i8*, !dbg !204
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %36) #4, !dbg !204
  br label %99

37:                                               ; preds = %31
  %38 = bitcast i64* %11 to i8*, !dbg !205
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %38) #4, !dbg !205
  call void @llvm.dbg.declare(metadata i64* %11, metadata !173, metadata !DIExpression()), !dbg !206
  store i64 0, i64* %11, align 8, !dbg !206, !tbaa !39
  br label %39, !dbg !205

39:                                               ; preds = %92, %37
  %40 = load i64, i64* %11, align 8, !dbg !207, !tbaa !39
  %41 = load i64, i64* %8, align 8, !dbg !208, !tbaa !39
  %42 = icmp ult i64 %40, %41, !dbg !209
  br i1 %42, label %45, label %43, !dbg !210

43:                                               ; preds = %39
  store i32 5, i32* %10, align 4
  %44 = bitcast i64* %11 to i8*, !dbg !211
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %44) #4, !dbg !211
  br label %95

45:                                               ; preds = %39
  %46 = bitcast double* %12 to i8*, !dbg !212
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %46) #4, !dbg !212
  call void @llvm.dbg.declare(metadata double* %12, metadata !177, metadata !DIExpression()), !dbg !213
  store double 0.000000e+00, double* %12, align 8, !dbg !213, !tbaa !152
  %47 = bitcast i64* %13 to i8*, !dbg !214
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %47) #4, !dbg !214
  call void @llvm.dbg.declare(metadata i64* %13, metadata !180, metadata !DIExpression()), !dbg !215
  store i64 0, i64* %13, align 8, !dbg !215, !tbaa !39
  br label %48, !dbg !214

48:                                               ; preds = %78, %45
  %49 = load i64, i64* %13, align 8, !dbg !216, !tbaa !39
  %50 = load i64, i64* %7, align 8, !dbg !218, !tbaa !39
  %51 = icmp ult i64 %49, %50, !dbg !219
  br i1 %51, label %54, label %52, !dbg !220

52:                                               ; preds = %48
  store i32 8, i32* %10, align 4
  %53 = bitcast i64* %13 to i8*, !dbg !221
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %53) #4, !dbg !221
  br label %81

54:                                               ; preds = %48
  %55 = load %struct._matrix*, %struct._matrix** %4, align 8, !dbg !222, !tbaa !34
  %56 = getelementptr inbounds %struct._matrix, %struct._matrix* %55, i32 0, i32 2, !dbg !224
  %57 = load double*, double** %56, align 8, !dbg !224, !tbaa !129
  %58 = load i64, i64* %9, align 8, !dbg !225, !tbaa !39
  %59 = load i64, i64* %7, align 8, !dbg !226, !tbaa !39
  %60 = mul i64 %58, %59, !dbg !227
  %61 = load i64, i64* %13, align 8, !dbg !228, !tbaa !39
  %62 = add i64 %60, %61, !dbg !229
  %63 = getelementptr inbounds double, double* %57, i64 %62, !dbg !222
  %64 = load double, double* %63, align 8, !dbg !222, !tbaa !152
  %65 = load %struct._matrix*, %struct._matrix** %5, align 8, !dbg !230, !tbaa !34
  %66 = getelementptr inbounds %struct._matrix, %struct._matrix* %65, i32 0, i32 2, !dbg !231
  %67 = load double*, double** %66, align 8, !dbg !231, !tbaa !129
  %68 = load i64, i64* %13, align 8, !dbg !232, !tbaa !39
  %69 = load i64, i64* %8, align 8, !dbg !233, !tbaa !39
  %70 = mul i64 %68, %69, !dbg !234
  %71 = load i64, i64* %11, align 8, !dbg !235, !tbaa !39
  %72 = add i64 %70, %71, !dbg !236
  %73 = getelementptr inbounds double, double* %67, i64 %72, !dbg !230
  %74 = load double, double* %73, align 8, !dbg !230, !tbaa !152
  %75 = fmul double %64, %74, !dbg !237
  %76 = load double, double* %12, align 8, !dbg !238, !tbaa !152
  %77 = fadd double %76, %75, !dbg !238
  store double %77, double* %12, align 8, !dbg !238, !tbaa !152
  br label %78, !dbg !239

78:                                               ; preds = %54
  %79 = load i64, i64* %13, align 8, !dbg !240, !tbaa !39
  %80 = add i64 %79, 1, !dbg !240
  store i64 %80, i64* %13, align 8, !dbg !240, !tbaa !39
  br label %48, !dbg !221, !llvm.loop !241

81:                                               ; preds = %52
  %82 = load double, double* %12, align 8, !dbg !243, !tbaa !152
  %83 = getelementptr inbounds %struct._matrix, %struct._matrix* %0, i32 0, i32 2, !dbg !244
  %84 = load double*, double** %83, align 8, !dbg !244, !tbaa !129
  %85 = load i64, i64* %9, align 8, !dbg !245, !tbaa !39
  %86 = load i64, i64* %8, align 8, !dbg !246, !tbaa !39
  %87 = mul i64 %85, %86, !dbg !247
  %88 = load i64, i64* %11, align 8, !dbg !248, !tbaa !39
  %89 = add i64 %87, %88, !dbg !249
  %90 = getelementptr inbounds double, double* %84, i64 %89, !dbg !250
  store double %82, double* %90, align 8, !dbg !251, !tbaa !152
  %91 = bitcast double* %12 to i8*, !dbg !252
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %91) #4, !dbg !252
  br label %92, !dbg !253

92:                                               ; preds = %81
  %93 = load i64, i64* %11, align 8, !dbg !254, !tbaa !39
  %94 = add i64 %93, 1, !dbg !254
  store i64 %94, i64* %11, align 8, !dbg !254, !tbaa !39
  br label %39, !dbg !211, !llvm.loop !255

95:                                               ; preds = %43
  br label %96, !dbg !257

96:                                               ; preds = %95
  %97 = load i64, i64* %9, align 8, !dbg !258, !tbaa !39
  %98 = add i64 %97, 1, !dbg !258
  store i64 %98, i64* %9, align 8, !dbg !258, !tbaa !39
  br label %31, !dbg !204, !llvm.loop !259

99:                                               ; preds = %35
  store i32 1, i32* %10, align 4
  %100 = bitcast i64* %8 to i8*, !dbg !261
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %100) #4, !dbg !261
  %101 = bitcast i64* %7 to i8*, !dbg !261
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %101) #4, !dbg !261
  %102 = bitcast i64* %6 to i8*, !dbg !261
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %102) #4, !dbg !261
  ret void, !dbg !261
}

; Function Attrs: nounwind uwtable
define dso_local i32 @main(i32, i8**) #0 !dbg !262 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca %struct._matrix, align 8
  %10 = alloca %struct._matrix, align 8
  %11 = alloca %struct._matrix, align 8
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4, !tbaa !105
  call void @llvm.dbg.declare(metadata i32* %4, metadata !266, metadata !DIExpression()), !dbg !274
  store i8** %1, i8*** %5, align 8, !tbaa !34
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !267, metadata !DIExpression()), !dbg !275
  %12 = bitcast i32* %6 to i8*, !dbg !276
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %12) #4, !dbg !276
  call void @llvm.dbg.declare(metadata i32* %6, metadata !268, metadata !DIExpression()), !dbg !277
  %13 = bitcast i32* %6 to i8*, !dbg !276
  call void @llvm.var.annotation(i8* %13, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.3, i32 0, i32 0), i32 51), !dbg !276
  %14 = bitcast i32* %7 to i8*, !dbg !276
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %14) #4, !dbg !276
  call void @llvm.dbg.declare(metadata i32* %7, metadata !269, metadata !DIExpression()), !dbg !278
  %15 = bitcast i32* %7 to i8*, !dbg !276
  call void @llvm.var.annotation(i8* %15, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.3, i32 0, i32 0), i32 51), !dbg !276
  %16 = bitcast i32* %8 to i8*, !dbg !276
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %16) #4, !dbg !276
  call void @llvm.dbg.declare(metadata i32* %8, metadata !270, metadata !DIExpression()), !dbg !279
  %17 = bitcast i32* %8 to i8*, !dbg !276
  call void @llvm.var.annotation(i8* %17, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.3, i32 0, i32 0), i32 51), !dbg !276
  %18 = load i32, i32* %4, align 4, !dbg !280, !tbaa !105
  %19 = icmp eq i32 %18, 4, !dbg !280
  br i1 %19, label %20, label %21, !dbg !283

20:                                               ; preds = %2
  br label %22, !dbg !283

21:                                               ; preds = %2
  call void @__assert_fail(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.4, i64 0, i64 0), i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.5, i64 0, i64 0), i32 52, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #8, !dbg !280
  unreachable, !dbg !280

22:                                               ; preds = %20
  %23 = load i8**, i8*** %5, align 8, !dbg !284, !tbaa !34
  %24 = getelementptr inbounds i8*, i8** %23, i64 1, !dbg !284
  %25 = load i8*, i8** %24, align 8, !dbg !284, !tbaa !34
  %26 = call i32 @atoi(i8* %25) #9, !dbg !285
  store i32 %26, i32* %6, align 4, !dbg !286, !tbaa !105
  %27 = load i8**, i8*** %5, align 8, !dbg !287, !tbaa !34
  %28 = getelementptr inbounds i8*, i8** %27, i64 2, !dbg !287
  %29 = load i8*, i8** %28, align 8, !dbg !287, !tbaa !34
  %30 = call i32 @atoi(i8* %29) #9, !dbg !288
  store i32 %30, i32* %7, align 4, !dbg !289, !tbaa !105
  %31 = load i8**, i8*** %5, align 8, !dbg !290, !tbaa !34
  %32 = getelementptr inbounds i8*, i8** %31, i64 3, !dbg !290
  %33 = load i8*, i8** %32, align 8, !dbg !290, !tbaa !34
  %34 = call i32 @atoi(i8* %33) #9, !dbg !291
  store i32 %34, i32* %8, align 4, !dbg !292, !tbaa !105
  %35 = call i64 @time(i64* null) #4, !dbg !293
  %36 = trunc i64 %35 to i32, !dbg !293
  call void @srand(i32 %36) #4, !dbg !294
  %37 = bitcast i32* %6 to i8*, !dbg !295
  call void @register_variable(i8* %37, i64 4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i64 0, i64 0)), !dbg !296
  %38 = bitcast i32* %7 to i8*, !dbg !297
  call void @register_variable(i8* %38, i64 4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i64 0, i64 0)), !dbg !298
  %39 = bitcast i32* %8 to i8*, !dbg !299
  call void @register_variable(i8* %39, i64 4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i64 0, i64 0)), !dbg !300
  %40 = bitcast %struct._matrix* %9 to i8*, !dbg !301
  call void @llvm.lifetime.start.p0i8(i64 24, i8* %40) #4, !dbg !301
  call void @llvm.dbg.declare(metadata %struct._matrix* %9, metadata !271, metadata !DIExpression()), !dbg !302
  %41 = load i32, i32* %6, align 4, !dbg !303, !tbaa !105
  %42 = load i32, i32* %7, align 4, !dbg !304, !tbaa !105
  call void @create_matrix(%struct._matrix* sret %9, i32 %41, i32 %42, i1 zeroext true), !dbg !305
  %43 = bitcast %struct._matrix* %10 to i8*, !dbg !306
  call void @llvm.lifetime.start.p0i8(i64 24, i8* %43) #4, !dbg !306
  call void @llvm.dbg.declare(metadata %struct._matrix* %10, metadata !272, metadata !DIExpression()), !dbg !307
  %44 = load i32, i32* %7, align 4, !dbg !308, !tbaa !105
  %45 = load i32, i32* %8, align 4, !dbg !309, !tbaa !105
  call void @create_matrix(%struct._matrix* sret %10, i32 %44, i32 %45, i1 zeroext true), !dbg !310
  %46 = bitcast %struct._matrix* %11 to i8*, !dbg !311
  call void @llvm.lifetime.start.p0i8(i64 24, i8* %46) #4, !dbg !311
  call void @llvm.dbg.declare(metadata %struct._matrix* %11, metadata !273, metadata !DIExpression()), !dbg !312
  call void @mat_mul(%struct._matrix* sret %11, %struct._matrix* %9, %struct._matrix* %10), !dbg !313
  %47 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !314, !tbaa !34
  %48 = getelementptr inbounds %struct._matrix, %struct._matrix* %11, i32 0, i32 2, !dbg !315
  %49 = load double*, double** %48, align 8, !dbg !315, !tbaa !129
  %50 = getelementptr inbounds double, double* %49, i64 0, !dbg !316
  %51 = load double, double* %50, align 8, !dbg !316, !tbaa !152
  %52 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %47, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.9, i64 0, i64 0), double %51), !dbg !317
  %53 = getelementptr inbounds %struct._matrix, %struct._matrix* %9, i32 0, i32 2, !dbg !318
  %54 = load double*, double** %53, align 8, !dbg !318, !tbaa !129
  %55 = bitcast double* %54 to i8*, !dbg !319
  call void @free(i8* %55) #4, !dbg !320
  %56 = getelementptr inbounds %struct._matrix, %struct._matrix* %10, i32 0, i32 2, !dbg !321
  %57 = load double*, double** %56, align 8, !dbg !321, !tbaa !129
  %58 = bitcast double* %57 to i8*, !dbg !322
  call void @free(i8* %58) #4, !dbg !323
  %59 = getelementptr inbounds %struct._matrix, %struct._matrix* %11, i32 0, i32 2, !dbg !324
  %60 = load double*, double** %59, align 8, !dbg !324, !tbaa !129
  %61 = bitcast double* %60 to i8*, !dbg !325
  call void @free(i8* %61) #4, !dbg !326
  %62 = bitcast %struct._matrix* %11 to i8*, !dbg !327
  call void @llvm.lifetime.end.p0i8(i64 24, i8* %62) #4, !dbg !327
  %63 = bitcast %struct._matrix* %10 to i8*, !dbg !327
  call void @llvm.lifetime.end.p0i8(i64 24, i8* %63) #4, !dbg !327
  %64 = bitcast %struct._matrix* %9 to i8*, !dbg !327
  call void @llvm.lifetime.end.p0i8(i64 24, i8* %64) #4, !dbg !327
  %65 = bitcast i32* %8 to i8*, !dbg !327
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %65) #4, !dbg !327
  %66 = bitcast i32* %7 to i8*, !dbg !327
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %66) #4, !dbg !327
  %67 = bitcast i32* %6 to i8*, !dbg !327
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %67) #4, !dbg !327
  ret i32 0, !dbg !328
}

; Function Attrs: nounwind
declare void @llvm.var.annotation(i8*, i8*, i8*, i32) #4

; Function Attrs: noreturn nounwind
declare dso_local void @__assert_fail(i8*, i8*, i32, i8*) #6

; Function Attrs: inlinehint nounwind readonly uwtable
define available_externally dso_local i32 @atoi(i8* nonnull) #7 !dbg !329 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8, !tbaa !34
  call void @llvm.dbg.declare(metadata i8** %2, metadata !334, metadata !DIExpression()), !dbg !335
  %3 = load i8*, i8** %2, align 8, !dbg !336, !tbaa !34
  %4 = call i64 @strtol(i8* %3, i8** null, i32 10) #4, !dbg !337
  %5 = trunc i64 %4 to i32, !dbg !338
  ret i32 %5, !dbg !339
}

; Function Attrs: nounwind
declare dso_local void @srand(i32) #5

; Function Attrs: nounwind
declare dso_local i64 @time(i64*) #5

; Function Attrs: nounwind
declare dso_local void @free(i8*) #5

; Function Attrs: nounwind
declare dso_local i64 @strtol(i8*, i8**, i32) #5

attributes #0 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { argmemonly nounwind }
attributes #4 = { nounwind }
attributes #5 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #6 = { noreturn nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #7 = { inlinehint nounwind readonly uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #8 = { noreturn nounwind }
attributes #9 = { nounwind readonly }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!17, !18, !19}
!llvm.ident = !{!20}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !3, nameTableKind: None)
!1 = !DIFile(filename: "tests/dfsan-unit/matmul.c", directory: "/home/mcopik/projects/ETH/extrap/rebuild/perf-taint")
!2 = !{}
!3 = !{!4, !10, !12, !13, !16}
!4 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !5, size: 64)
!5 = !DIDerivedType(tag: DW_TAG_typedef, name: "int8_t", file: !6, line: 24, baseType: !7)
!6 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-intn.h", directory: "")
!7 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int8_t", file: !8, line: 36, baseType: !9)
!8 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "")
!9 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!10 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !11, size: 64)
!11 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!12 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!13 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !14, size: 64)
!14 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !15, size: 64)
!15 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!16 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!17 = !{i32 2, !"Dwarf Version", i32 4}
!18 = !{i32 2, !"Debug Info Version", i32 3}
!19 = !{i32 1, !"wchar_size", i32 4}
!20 = !{!"clang version 9.0.0 (tags/RELEASE_900/final)"}
!21 = distinct !DISubprogram(name: "register_variable", scope: !22, file: !22, line: 19, type: !23, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !30)
!22 = !DIFile(filename: "include/ExtraPInstrumenter.h", directory: "/home/mcopik/projects/ETH/extrap/rebuild/perf-taint")
!23 = !DISubroutineType(types: !24)
!24 = !{null, !16, !25, !28}
!25 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !26, line: 46, baseType: !27)
!26 = !DIFile(filename: "clang_llvm/llvm-9.0/build-9.0/lib/clang/9.0.0/include/stddef.h", directory: "/home/mcopik/projects")
!27 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!28 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !29, size: 64)
!29 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !15)
!30 = !{!31, !32, !33}
!31 = !DILocalVariable(name: "ptr", arg: 1, scope: !21, file: !22, line: 19, type: !16)
!32 = !DILocalVariable(name: "size", arg: 2, scope: !21, file: !22, line: 19, type: !25)
!33 = !DILocalVariable(name: "name", arg: 3, scope: !21, file: !22, line: 19, type: !28)
!34 = !{!35, !35, i64 0}
!35 = !{!"any pointer", !36, i64 0}
!36 = !{!"omnipotent char", !37, i64 0}
!37 = !{!"Simple C/C++ TBAA"}
!38 = !DILocation(line: 19, column: 31, scope: !21)
!39 = !{!40, !40, i64 0}
!40 = !{!"long", !36, i64 0}
!41 = !DILocation(line: 19, column: 43, scope: !21)
!42 = !DILocation(line: 19, column: 62, scope: !21)
!43 = !DILocation(line: 22, column: 13, scope: !21)
!44 = !DILocation(line: 22, column: 5, scope: !21)
!45 = !DILocation(line: 24, column: 41, scope: !21)
!46 = !DILocation(line: 24, column: 46, scope: !21)
!47 = !DILocation(line: 24, column: 52, scope: !21)
!48 = !DILocation(line: 24, column: 5, scope: !21)
!49 = !DILocation(line: 25, column: 1, scope: !21)
!50 = distinct !DISubprogram(name: "register_variables", scope: !22, file: !22, line: 43, type: !51, scopeLine: 44, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !53)
!51 = !DISubroutineType(types: !52)
!52 = !{null, !28, !25, null}
!53 = !{!54, !55, !56}
!54 = !DILocalVariable(name: "name", arg: 1, scope: !50, file: !22, line: 43, type: !28)
!55 = !DILocalVariable(name: "count", arg: 2, scope: !50, file: !22, line: 43, type: !25)
!56 = !DILocalVariable(name: "args", scope: !50, file: !22, line: 45, type: !57)
!57 = !DIDerivedType(tag: DW_TAG_typedef, name: "va_list", file: !58, line: 46, baseType: !59)
!58 = !DIFile(filename: "/usr/include/stdio.h", directory: "")
!59 = !DIDerivedType(tag: DW_TAG_typedef, name: "__gnuc_va_list", file: !60, line: 32, baseType: !61)
!60 = !DIFile(filename: "clang_llvm/llvm-9.0/build-9.0/lib/clang/9.0.0/include/stdarg.h", directory: "/home/mcopik/projects")
!61 = !DIDerivedType(tag: DW_TAG_typedef, name: "__builtin_va_list", file: !1, line: 45, baseType: !62)
!62 = !DICompositeType(tag: DW_TAG_array_type, baseType: !63, size: 192, elements: !70)
!63 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__va_list_tag", file: !1, line: 45, size: 192, elements: !64)
!64 = !{!65, !67, !68, !69}
!65 = !DIDerivedType(tag: DW_TAG_member, name: "gp_offset", scope: !63, file: !1, line: 45, baseType: !66, size: 32)
!66 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!67 = !DIDerivedType(tag: DW_TAG_member, name: "fp_offset", scope: !63, file: !1, line: 45, baseType: !66, size: 32, offset: 32)
!68 = !DIDerivedType(tag: DW_TAG_member, name: "overflow_arg_area", scope: !63, file: !1, line: 45, baseType: !16, size: 64, offset: 64)
!69 = !DIDerivedType(tag: DW_TAG_member, name: "reg_save_area", scope: !63, file: !1, line: 45, baseType: !16, size: 64, offset: 128)
!70 = !{!71}
!71 = !DISubrange(count: 1)
!72 = !DILocation(line: 43, column: 38, scope: !50)
!73 = !DILocation(line: 43, column: 51, scope: !50)
!74 = !DILocation(line: 45, column: 5, scope: !50)
!75 = !DILocation(line: 45, column: 13, scope: !50)
!76 = !DILocation(line: 52, column: 5, scope: !50)
!77 = !DILocation(line: 54, column: 13, scope: !50)
!78 = !DILocation(line: 54, column: 49, scope: !50)
!79 = !DILocation(line: 54, column: 5, scope: !50)
!80 = !DILocation(line: 56, column: 32, scope: !50)
!81 = !DILocation(line: 56, column: 38, scope: !50)
!82 = !DILocation(line: 56, column: 45, scope: !50)
!83 = !DILocation(line: 56, column: 5, scope: !50)
!84 = !DILocation(line: 58, column: 1, scope: !50)
!85 = distinct !DISubprogram(name: "create_matrix", scope: !1, file: !1, line: 17, type: !86, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !95)
!86 = !DISubroutineType(types: !87)
!87 = !{!88, !12, !12, !94}
!88 = !DIDerivedType(tag: DW_TAG_typedef, name: "matrix", file: !1, line: 15, baseType: !89)
!89 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_matrix", file: !1, line: 10, size: 192, elements: !90)
!90 = !{!91, !92, !93}
!91 = !DIDerivedType(tag: DW_TAG_member, name: "rows", scope: !89, file: !1, line: 12, baseType: !25, size: 64)
!92 = !DIDerivedType(tag: DW_TAG_member, name: "cols", scope: !89, file: !1, line: 13, baseType: !25, size: 64, offset: 64)
!93 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !89, file: !1, line: 14, baseType: !10, size: 64, offset: 128)
!94 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!95 = !{!96, !97, !98, !99, !100, !103}
!96 = !DILocalVariable(name: "rows", arg: 1, scope: !85, file: !1, line: 17, type: !12)
!97 = !DILocalVariable(name: "cols", arg: 2, scope: !85, file: !1, line: 17, type: !12)
!98 = !DILocalVariable(name: "init", arg: 3, scope: !85, file: !1, line: 17, type: !94)
!99 = !DILocalVariable(name: "m", scope: !85, file: !1, line: 19, type: !88)
!100 = !DILocalVariable(name: "size", scope: !101, file: !1, line: 24, type: !25)
!101 = distinct !DILexicalBlock(scope: !102, file: !1, line: 23, column: 14)
!102 = distinct !DILexicalBlock(scope: !85, file: !1, line: 23, column: 8)
!103 = !DILocalVariable(name: "i", scope: !104, file: !1, line: 25, type: !25)
!104 = distinct !DILexicalBlock(scope: !101, file: !1, line: 25, column: 9)
!105 = !{!106, !106, i64 0}
!106 = !{!"int", !36, i64 0}
!107 = !DILocation(line: 17, column: 26, scope: !85)
!108 = !DILocation(line: 17, column: 36, scope: !85)
!109 = !{!110, !110, i64 0}
!110 = !{!"_Bool", !36, i64 0}
!111 = !DILocation(line: 17, column: 47, scope: !85)
!112 = !DILocation(line: 19, column: 12, scope: !85)
!113 = !DILocation(line: 20, column: 14, scope: !85)
!114 = !DILocation(line: 20, column: 7, scope: !85)
!115 = !DILocation(line: 20, column: 12, scope: !85)
!116 = !{!117, !40, i64 0}
!117 = !{!"_matrix", !40, i64 0, !40, i64 8, !35, i64 16}
!118 = !DILocation(line: 21, column: 14, scope: !85)
!119 = !DILocation(line: 21, column: 7, scope: !85)
!120 = !DILocation(line: 21, column: 12, scope: !85)
!121 = !{!117, !40, i64 8}
!122 = !DILocation(line: 22, column: 31, scope: !85)
!123 = !DILocation(line: 22, column: 38, scope: !85)
!124 = !DILocation(line: 22, column: 36, scope: !85)
!125 = !DILocation(line: 22, column: 24, scope: !85)
!126 = !DILocation(line: 22, column: 14, scope: !85)
!127 = !DILocation(line: 22, column: 7, scope: !85)
!128 = !DILocation(line: 22, column: 12, scope: !85)
!129 = !{!117, !35, i64 16}
!130 = !DILocation(line: 23, column: 8, scope: !102)
!131 = !{i8 0, i8 2}
!132 = !DILocation(line: 23, column: 8, scope: !85)
!133 = !DILocation(line: 24, column: 9, scope: !101)
!134 = !DILocation(line: 24, column: 16, scope: !101)
!135 = !DILocation(line: 24, column: 23, scope: !101)
!136 = !DILocation(line: 24, column: 30, scope: !101)
!137 = !DILocation(line: 24, column: 28, scope: !101)
!138 = !DILocation(line: 25, column: 13, scope: !104)
!139 = !DILocation(line: 25, column: 20, scope: !104)
!140 = !DILocation(line: 25, column: 27, scope: !141)
!141 = distinct !DILexicalBlock(scope: !104, file: !1, line: 25, column: 9)
!142 = !DILocation(line: 25, column: 31, scope: !141)
!143 = !DILocation(line: 25, column: 29, scope: !141)
!144 = !DILocation(line: 25, column: 9, scope: !104)
!145 = !DILocation(line: 25, column: 9, scope: !141)
!146 = !DILocation(line: 26, column: 25, scope: !141)
!147 = !DILocation(line: 26, column: 32, scope: !141)
!148 = !DILocation(line: 26, column: 15, scope: !141)
!149 = !DILocation(line: 26, column: 20, scope: !141)
!150 = !DILocation(line: 26, column: 13, scope: !141)
!151 = !DILocation(line: 26, column: 23, scope: !141)
!152 = !{!153, !153, i64 0}
!153 = !{!"double", !36, i64 0}
!154 = !DILocation(line: 25, column: 37, scope: !141)
!155 = distinct !{!155, !144, !156}
!156 = !DILocation(line: 26, column: 34, scope: !104)
!157 = !DILocation(line: 27, column: 5, scope: !102)
!158 = !DILocation(line: 27, column: 5, scope: !101)
!159 = !DILocation(line: 28, column: 5, scope: !85)
!160 = distinct !DISubprogram(name: "mat_mul", scope: !1, file: !1, line: 31, type: !161, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !164)
!161 = !DISubroutineType(types: !162)
!162 = !{!88, !163, !163}
!163 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !88, size: 64)
!164 = !{!165, !166, !167, !168, !169, !170, !171, !173, !177, !180}
!165 = !DILocalVariable(name: "left", arg: 1, scope: !160, file: !1, line: 31, type: !163)
!166 = !DILocalVariable(name: "right", arg: 2, scope: !160, file: !1, line: 31, type: !163)
!167 = !DILocalVariable(name: "m", scope: !160, file: !1, line: 33, type: !25)
!168 = !DILocalVariable(name: "n", scope: !160, file: !1, line: 33, type: !25)
!169 = !DILocalVariable(name: "k", scope: !160, file: !1, line: 33, type: !25)
!170 = !DILocalVariable(name: "res", scope: !160, file: !1, line: 34, type: !88)
!171 = !DILocalVariable(name: "i", scope: !172, file: !1, line: 36, type: !25)
!172 = distinct !DILexicalBlock(scope: !160, file: !1, line: 36, column: 5)
!173 = !DILocalVariable(name: "j", scope: !174, file: !1, line: 37, type: !25)
!174 = distinct !DILexicalBlock(scope: !175, file: !1, line: 37, column: 9)
!175 = distinct !DILexicalBlock(scope: !176, file: !1, line: 36, column: 35)
!176 = distinct !DILexicalBlock(scope: !172, file: !1, line: 36, column: 5)
!177 = !DILocalVariable(name: "scalar_product", scope: !178, file: !1, line: 38, type: !11)
!178 = distinct !DILexicalBlock(scope: !179, file: !1, line: 37, column: 39)
!179 = distinct !DILexicalBlock(scope: !174, file: !1, line: 37, column: 9)
!180 = !DILocalVariable(name: "kk", scope: !181, file: !1, line: 39, type: !25)
!181 = distinct !DILexicalBlock(scope: !178, file: !1, line: 39, column: 13)
!182 = !DILocation(line: 31, column: 25, scope: !160)
!183 = !DILocation(line: 31, column: 40, scope: !160)
!184 = !DILocation(line: 33, column: 5, scope: !160)
!185 = !DILocation(line: 33, column: 12, scope: !160)
!186 = !DILocation(line: 33, column: 16, scope: !160)
!187 = !DILocation(line: 33, column: 22, scope: !160)
!188 = !DILocation(line: 33, column: 28, scope: !160)
!189 = !DILocation(line: 33, column: 32, scope: !160)
!190 = !DILocation(line: 33, column: 38, scope: !160)
!191 = !DILocation(line: 33, column: 44, scope: !160)
!192 = !DILocation(line: 33, column: 48, scope: !160)
!193 = !DILocation(line: 33, column: 55, scope: !160)
!194 = !DILocation(line: 34, column: 12, scope: !160)
!195 = !DILocation(line: 34, column: 32, scope: !160)
!196 = !DILocation(line: 34, column: 35, scope: !160)
!197 = !DILocation(line: 34, column: 18, scope: !160)
!198 = !DILocation(line: 36, column: 9, scope: !172)
!199 = !DILocation(line: 36, column: 16, scope: !172)
!200 = !DILocation(line: 36, column: 23, scope: !176)
!201 = !DILocation(line: 36, column: 27, scope: !176)
!202 = !DILocation(line: 36, column: 25, scope: !176)
!203 = !DILocation(line: 36, column: 5, scope: !172)
!204 = !DILocation(line: 36, column: 5, scope: !176)
!205 = !DILocation(line: 37, column: 13, scope: !174)
!206 = !DILocation(line: 37, column: 20, scope: !174)
!207 = !DILocation(line: 37, column: 27, scope: !179)
!208 = !DILocation(line: 37, column: 31, scope: !179)
!209 = !DILocation(line: 37, column: 29, scope: !179)
!210 = !DILocation(line: 37, column: 9, scope: !174)
!211 = !DILocation(line: 37, column: 9, scope: !179)
!212 = !DILocation(line: 38, column: 13, scope: !178)
!213 = !DILocation(line: 38, column: 20, scope: !178)
!214 = !DILocation(line: 39, column: 17, scope: !181)
!215 = !DILocation(line: 39, column: 24, scope: !181)
!216 = !DILocation(line: 39, column: 32, scope: !217)
!217 = distinct !DILexicalBlock(scope: !181, file: !1, line: 39, column: 13)
!218 = !DILocation(line: 39, column: 37, scope: !217)
!219 = !DILocation(line: 39, column: 35, scope: !217)
!220 = !DILocation(line: 39, column: 13, scope: !181)
!221 = !DILocation(line: 39, column: 13, scope: !217)
!222 = !DILocation(line: 40, column: 35, scope: !223)
!223 = distinct !DILexicalBlock(scope: !217, file: !1, line: 39, column: 46)
!224 = !DILocation(line: 40, column: 41, scope: !223)
!225 = !DILocation(line: 40, column: 46, scope: !223)
!226 = !DILocation(line: 40, column: 48, scope: !223)
!227 = !DILocation(line: 40, column: 47, scope: !223)
!228 = !DILocation(line: 40, column: 52, scope: !223)
!229 = !DILocation(line: 40, column: 50, scope: !223)
!230 = !DILocation(line: 40, column: 58, scope: !223)
!231 = !DILocation(line: 40, column: 65, scope: !223)
!232 = !DILocation(line: 40, column: 70, scope: !223)
!233 = !DILocation(line: 40, column: 73, scope: !223)
!234 = !DILocation(line: 40, column: 72, scope: !223)
!235 = !DILocation(line: 40, column: 77, scope: !223)
!236 = !DILocation(line: 40, column: 75, scope: !223)
!237 = !DILocation(line: 40, column: 56, scope: !223)
!238 = !DILocation(line: 40, column: 32, scope: !223)
!239 = !DILocation(line: 41, column: 13, scope: !223)
!240 = !DILocation(line: 39, column: 40, scope: !217)
!241 = distinct !{!241, !220, !242}
!242 = !DILocation(line: 41, column: 13, scope: !181)
!243 = !DILocation(line: 42, column: 33, scope: !178)
!244 = !DILocation(line: 42, column: 17, scope: !178)
!245 = !DILocation(line: 42, column: 22, scope: !178)
!246 = !DILocation(line: 42, column: 24, scope: !178)
!247 = !DILocation(line: 42, column: 23, scope: !178)
!248 = !DILocation(line: 42, column: 28, scope: !178)
!249 = !DILocation(line: 42, column: 26, scope: !178)
!250 = !DILocation(line: 42, column: 13, scope: !178)
!251 = !DILocation(line: 42, column: 31, scope: !178)
!252 = !DILocation(line: 43, column: 9, scope: !179)
!253 = !DILocation(line: 43, column: 9, scope: !178)
!254 = !DILocation(line: 37, column: 34, scope: !179)
!255 = distinct !{!255, !210, !256}
!256 = !DILocation(line: 43, column: 9, scope: !174)
!257 = !DILocation(line: 44, column: 5, scope: !175)
!258 = !DILocation(line: 36, column: 30, scope: !176)
!259 = distinct !{!259, !203, !260}
!260 = !DILocation(line: 44, column: 5, scope: !172)
!261 = !DILocation(line: 47, column: 1, scope: !160)
!262 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 49, type: !263, scopeLine: 50, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !265)
!263 = !DISubroutineType(types: !264)
!264 = !{!12, !12, !13}
!265 = !{!266, !267, !268, !269, !270, !271, !272, !273}
!266 = !DILocalVariable(name: "argc", arg: 1, scope: !262, file: !1, line: 49, type: !12)
!267 = !DILocalVariable(name: "argv", arg: 2, scope: !262, file: !1, line: 49, type: !13)
!268 = !DILocalVariable(name: "m", scope: !262, file: !1, line: 51, type: !12)
!269 = !DILocalVariable(name: "n", scope: !262, file: !1, line: 51, type: !12)
!270 = !DILocalVariable(name: "k", scope: !262, file: !1, line: 51, type: !12)
!271 = !DILocalVariable(name: "left", scope: !262, file: !1, line: 61, type: !88)
!272 = !DILocalVariable(name: "right", scope: !262, file: !1, line: 62, type: !88)
!273 = !DILocalVariable(name: "res", scope: !262, file: !1, line: 63, type: !88)
!274 = !DILocation(line: 49, column: 14, scope: !262)
!275 = !DILocation(line: 49, column: 28, scope: !262)
!276 = !DILocation(line: 51, column: 5, scope: !262)
!277 = !DILocation(line: 51, column: 9, scope: !262)
!278 = !DILocation(line: 51, column: 19, scope: !262)
!279 = !DILocation(line: 51, column: 29, scope: !262)
!280 = !DILocation(line: 52, column: 5, scope: !281)
!281 = distinct !DILexicalBlock(scope: !282, file: !1, line: 52, column: 5)
!282 = distinct !DILexicalBlock(scope: !262, file: !1, line: 52, column: 5)
!283 = !DILocation(line: 52, column: 5, scope: !282)
!284 = !DILocation(line: 53, column: 14, scope: !262)
!285 = !DILocation(line: 53, column: 9, scope: !262)
!286 = !DILocation(line: 53, column: 7, scope: !262)
!287 = !DILocation(line: 54, column: 14, scope: !262)
!288 = !DILocation(line: 54, column: 9, scope: !262)
!289 = !DILocation(line: 54, column: 7, scope: !262)
!290 = !DILocation(line: 55, column: 14, scope: !262)
!291 = !DILocation(line: 55, column: 9, scope: !262)
!292 = !DILocation(line: 55, column: 7, scope: !262)
!293 = !DILocation(line: 56, column: 11, scope: !262)
!294 = !DILocation(line: 56, column: 5, scope: !262)
!295 = !DILocation(line: 57, column: 23, scope: !262)
!296 = !DILocation(line: 57, column: 5, scope: !262)
!297 = !DILocation(line: 58, column: 23, scope: !262)
!298 = !DILocation(line: 58, column: 5, scope: !262)
!299 = !DILocation(line: 59, column: 23, scope: !262)
!300 = !DILocation(line: 59, column: 5, scope: !262)
!301 = !DILocation(line: 61, column: 5, scope: !262)
!302 = !DILocation(line: 61, column: 12, scope: !262)
!303 = !DILocation(line: 61, column: 33, scope: !262)
!304 = !DILocation(line: 61, column: 36, scope: !262)
!305 = !DILocation(line: 61, column: 19, scope: !262)
!306 = !DILocation(line: 62, column: 5, scope: !262)
!307 = !DILocation(line: 62, column: 12, scope: !262)
!308 = !DILocation(line: 62, column: 34, scope: !262)
!309 = !DILocation(line: 62, column: 37, scope: !262)
!310 = !DILocation(line: 62, column: 20, scope: !262)
!311 = !DILocation(line: 63, column: 5, scope: !262)
!312 = !DILocation(line: 63, column: 12, scope: !262)
!313 = !DILocation(line: 63, column: 18, scope: !262)
!314 = !DILocation(line: 65, column: 13, scope: !262)
!315 = !DILocation(line: 65, column: 33, scope: !262)
!316 = !DILocation(line: 65, column: 29, scope: !262)
!317 = !DILocation(line: 65, column: 5, scope: !262)
!318 = !DILocation(line: 67, column: 15, scope: !262)
!319 = !DILocation(line: 67, column: 10, scope: !262)
!320 = !DILocation(line: 67, column: 5, scope: !262)
!321 = !DILocation(line: 68, column: 16, scope: !262)
!322 = !DILocation(line: 68, column: 10, scope: !262)
!323 = !DILocation(line: 68, column: 5, scope: !262)
!324 = !DILocation(line: 69, column: 14, scope: !262)
!325 = !DILocation(line: 69, column: 10, scope: !262)
!326 = !DILocation(line: 69, column: 5, scope: !262)
!327 = !DILocation(line: 72, column: 1, scope: !262)
!328 = !DILocation(line: 71, column: 5, scope: !262)
!329 = distinct !DISubprogram(name: "atoi", scope: !330, file: !330, line: 361, type: !331, scopeLine: 362, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !333)
!330 = !DIFile(filename: "/usr/include/stdlib.h", directory: "")
!331 = !DISubroutineType(types: !332)
!332 = !{!12, !28}
!333 = !{!334}
!334 = !DILocalVariable(name: "__nptr", arg: 1, scope: !329, file: !330, line: 361, type: !28)
!335 = !DILocation(line: 361, column: 1, scope: !329)
!336 = !DILocation(line: 363, column: 24, scope: !329)
!337 = !DILocation(line: 363, column: 16, scope: !329)
!338 = !DILocation(line: 363, column: 10, scope: !329)
!339 = !DILocation(line: 363, column: 3, scope: !329)
