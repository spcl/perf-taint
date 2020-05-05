; RUN: opt %dfsan -S < %s 2> /dev/null | llc %llcparams - -o %t1 && clang++ %t1 -o %t2 %link && %execparams %t2 50 30 40 > %t2.json && diff -w %s.json %t2.json
; RUN: opt %cfsan -S < %s 2> /dev/null | llc %llcparams - -o %t1 && clang++ %t1 -o %t2 %link && %execparams %t2 50 30 40 > %t2.json && diff -w %s.json %t2.json
; RUN: %jsonconvert %s.json 2> /dev/null | diff -w %s.processed.json -
; ModuleID = 'tests/dfsan-unit/matmul.c'
source_filename = "tests/dfsan-unit/matmul.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
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
define dso_local void @register_variable(i8* %0, i64 %1, i8* %2) #0 !dbg !38 {
  %4 = alloca i8*, align 8
  %5 = alloca i64, align 8
  %6 = alloca i8*, align 8
  store i8* %0, i8** %4, align 8, !tbaa !51
  call void @llvm.dbg.declare(metadata i8** %4, metadata !48, metadata !DIExpression()), !dbg !55
  store i64 %1, i64* %5, align 8, !tbaa !56
  call void @llvm.dbg.declare(metadata i64* %5, metadata !49, metadata !DIExpression()), !dbg !58
  store i8* %2, i8** %6, align 8, !tbaa !51
  call void @llvm.dbg.declare(metadata i8** %6, metadata !50, metadata !DIExpression()), !dbg !59
  %7 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !60, !tbaa !51
  %8 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %7, i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str, i64 0, i64 0)), !dbg !61
  %9 = load i8*, i8** %4, align 8, !dbg !62, !tbaa !51
  %10 = load i64, i64* %5, align 8, !dbg !63, !tbaa !56
  %11 = trunc i64 %10 to i32, !dbg !63
  %12 = load i8*, i8** %6, align 8, !dbg !64, !tbaa !51
  call void @__dfsw_EXTRAP_WRITE_LABEL(i8* %9, i32 %11, i8* %12), !dbg !65
  ret void, !dbg !66
}
; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1
declare dso_local i32 @fprintf(%struct._IO_FILE*, i8*, ...) #2
declare dso_local void @__dfsw_EXTRAP_WRITE_LABEL(i8*, i32, i8*) #2
; Function Attrs: nounwind uwtable
define dso_local void @register_variables(i8* %0, i64 %1, ...) #0 !dbg !67 {
  %3 = alloca i8*, align 8
  %4 = alloca i64, align 8
  %5 = alloca [1 x %struct.__va_list_tag], align 16
  store i8* %0, i8** %3, align 8, !tbaa !51
  call void @llvm.dbg.declare(metadata i8** %3, metadata !71, metadata !DIExpression()), !dbg !88
  store i64 %1, i64* %4, align 8, !tbaa !56
  call void @llvm.dbg.declare(metadata i64* %4, metadata !72, metadata !DIExpression()), !dbg !89
  %6 = bitcast [1 x %struct.__va_list_tag]* %5 to i8*, !dbg !90
  call void @llvm.lifetime.start.p0i8(i64 24, i8* %6) #4, !dbg !90
  call void @llvm.dbg.declare(metadata [1 x %struct.__va_list_tag]* %5, metadata !73, metadata !DIExpression()), !dbg !91
  %7 = getelementptr inbounds [1 x %struct.__va_list_tag], [1 x %struct.__va_list_tag]* %5, i64 0, i64 0, !dbg !92
  %8 = bitcast %struct.__va_list_tag* %7 to i8*, !dbg !92
  call void @llvm.va_start(i8* %8), !dbg !92
  %9 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !93, !tbaa !51
  %10 = load i64, i64* %4, align 8, !dbg !94, !tbaa !56
  %11 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %9, i8* getelementptr inbounds ([24 x i8], [24 x i8]* @.str.1, i64 0, i64 0), i64 %10), !dbg !95
  %12 = load i8*, i8** %3, align 8, !dbg !96, !tbaa !51
  %13 = load i64, i64* %4, align 8, !dbg !97, !tbaa !56
  %14 = getelementptr inbounds [1 x %struct.__va_list_tag], [1 x %struct.__va_list_tag]* %5, i64 0, i64 0, !dbg !98
  call void @__dfsw_EXTRAP_WRITE_LABELS(i8* %12, i64 %13, %struct.__va_list_tag* %14), !dbg !99
  %15 = bitcast [1 x %struct.__va_list_tag]* %5 to i8*, !dbg !100
  call void @llvm.lifetime.end.p0i8(i64 24, i8* %15) #4, !dbg !100
  ret void, !dbg !100
}
; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #3
; Function Attrs: nounwind
declare void @llvm.va_start(i8*) #4
declare dso_local void @__dfsw_EXTRAP_WRITE_LABELS(i8*, i64, %struct.__va_list_tag*) #2
; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #3
; Function Attrs: nounwind uwtable
define dso_local void @create_matrix(%struct._matrix* noalias sret %0, i32 %1, i32 %2, i1 zeroext %3) #0 !dbg !101 {
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i8, align 1
  %8 = alloca i64, align 8
  %9 = alloca i64, align 8
  store i32 %1, i32* %5, align 4, !tbaa !121
  call void @llvm.dbg.declare(metadata i32* %5, metadata !112, metadata !DIExpression()), !dbg !123
  store i32 %2, i32* %6, align 4, !tbaa !121
  call void @llvm.dbg.declare(metadata i32* %6, metadata !113, metadata !DIExpression()), !dbg !124
  %10 = zext i1 %3 to i8
  store i8 %10, i8* %7, align 1, !tbaa !125
  call void @llvm.dbg.declare(metadata i8* %7, metadata !114, metadata !DIExpression()), !dbg !127
  call void @llvm.dbg.declare(metadata %struct._matrix* %0, metadata !115, metadata !DIExpression()), !dbg !128
  %11 = load i32, i32* %5, align 4, !dbg !129, !tbaa !121
  %12 = sext i32 %11 to i64, !dbg !129
  %13 = getelementptr inbounds %struct._matrix, %struct._matrix* %0, i32 0, i32 0, !dbg !130
  store i64 %12, i64* %13, align 8, !dbg !131, !tbaa !132
  %14 = load i32, i32* %6, align 4, !dbg !134, !tbaa !121
  %15 = sext i32 %14 to i64, !dbg !134
  %16 = getelementptr inbounds %struct._matrix, %struct._matrix* %0, i32 0, i32 1, !dbg !135
  store i64 %15, i64* %16, align 8, !dbg !136, !tbaa !137
  %17 = load i32, i32* %5, align 4, !dbg !138, !tbaa !121
  %18 = load i32, i32* %6, align 4, !dbg !139, !tbaa !121
  %19 = mul nsw i32 %17, %18, !dbg !140
  %20 = sext i32 %19 to i64, !dbg !138
  %21 = call noalias i8* @calloc(i64 %20, i64 8) #4, !dbg !141
  %22 = bitcast i8* %21 to double*, !dbg !142
  %23 = getelementptr inbounds %struct._matrix, %struct._matrix* %0, i32 0, i32 2, !dbg !143
  store double* %22, double** %23, align 8, !dbg !144, !tbaa !145
  %24 = load i8, i8* %7, align 1, !dbg !146, !tbaa !125, !range !147
  %25 = trunc i8 %24 to i1, !dbg !146
  br i1 %25, label %26, label %52, !dbg !148

26:                                               ; preds = %4
  %27 = bitcast i64* %8 to i8*, !dbg !149
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %27) #4, !dbg !149
  call void @llvm.dbg.declare(metadata i64* %8, metadata !116, metadata !DIExpression()), !dbg !150
  %28 = load i32, i32* %5, align 4, !dbg !151, !tbaa !121
  %29 = load i32, i32* %6, align 4, !dbg !152, !tbaa !121
  %30 = mul nsw i32 %28, %29, !dbg !153
  %31 = sext i32 %30 to i64, !dbg !151
  store i64 %31, i64* %8, align 8, !dbg !150, !tbaa !56
  %32 = bitcast i64* %9 to i8*, !dbg !154
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %32) #4, !dbg !154
  call void @llvm.dbg.declare(metadata i64* %9, metadata !119, metadata !DIExpression()), !dbg !155
  store i64 0, i64* %9, align 8, !dbg !155, !tbaa !56
  br label %33, !dbg !154

33:                                               ; preds = %47, %26
  %34 = load i64, i64* %9, align 8, !dbg !156, !tbaa !56
  %35 = load i64, i64* %8, align 8, !dbg !158, !tbaa !56
  %36 = icmp ult i64 %34, %35, !dbg !159
  br i1 %36, label %39, label %37, !dbg !160

37:                                               ; preds = %33
  %38 = bitcast i64* %9 to i8*, !dbg !161
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %38) #4, !dbg !161
  br label %50

39:                                               ; preds = %33
  %40 = call i32 @rand() #4, !dbg !162
  %41 = srem i32 %40, 100, !dbg !163
  %42 = sitofp i32 %41 to double, !dbg !162
  %43 = getelementptr inbounds %struct._matrix, %struct._matrix* %0, i32 0, i32 2, !dbg !164
  %44 = load double*, double** %43, align 8, !dbg !164, !tbaa !145
  %45 = load i64, i64* %9, align 8, !dbg !165, !tbaa !56
  %46 = getelementptr inbounds double, double* %44, i64 %45, !dbg !166
  store double %42, double* %46, align 8, !dbg !167, !tbaa !168
  br label %47, !dbg !166

47:                                               ; preds = %39
  %48 = load i64, i64* %9, align 8, !dbg !170, !tbaa !56
  %49 = add i64 %48, 1, !dbg !170
  store i64 %49, i64* %9, align 8, !dbg !170, !tbaa !56
  br label %33, !dbg !161, !llvm.loop !171

50:                                               ; preds = %37
  %51 = bitcast i64* %8 to i8*, !dbg !173
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %51) #4, !dbg !173
  br label %52, !dbg !174

52:                                               ; preds = %50, %4
  ret void, !dbg !175
}
; Function Attrs: nounwind
declare dso_local noalias i8* @calloc(i64, i64) #5
; Function Attrs: nounwind
declare !dbg !12 dso_local i32 @rand() #5
; Function Attrs: nounwind uwtable
define dso_local void @mat_mul(%struct._matrix* noalias sret %0, %struct._matrix* %1, %struct._matrix* %2) #0 !dbg !176 {
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
  store %struct._matrix* %1, %struct._matrix** %4, align 8, !tbaa !51
  call void @llvm.dbg.declare(metadata %struct._matrix** %4, metadata !181, metadata !DIExpression()), !dbg !198
  store %struct._matrix* %2, %struct._matrix** %5, align 8, !tbaa !51
  call void @llvm.dbg.declare(metadata %struct._matrix** %5, metadata !182, metadata !DIExpression()), !dbg !199
  %14 = bitcast i64* %6 to i8*, !dbg !200
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %14) #4, !dbg !200
  call void @llvm.dbg.declare(metadata i64* %6, metadata !183, metadata !DIExpression()), !dbg !201
  %15 = load %struct._matrix*, %struct._matrix** %4, align 8, !dbg !202, !tbaa !51
  %16 = getelementptr inbounds %struct._matrix, %struct._matrix* %15, i32 0, i32 0, !dbg !203
  %17 = load i64, i64* %16, align 8, !dbg !203, !tbaa !132
  store i64 %17, i64* %6, align 8, !dbg !201, !tbaa !56
  %18 = bitcast i64* %7 to i8*, !dbg !200
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %18) #4, !dbg !200
  call void @llvm.dbg.declare(metadata i64* %7, metadata !184, metadata !DIExpression()), !dbg !204
  %19 = load %struct._matrix*, %struct._matrix** %4, align 8, !dbg !205, !tbaa !51
  %20 = getelementptr inbounds %struct._matrix, %struct._matrix* %19, i32 0, i32 1, !dbg !206
  %21 = load i64, i64* %20, align 8, !dbg !206, !tbaa !137
  store i64 %21, i64* %7, align 8, !dbg !204, !tbaa !56
  %22 = bitcast i64* %8 to i8*, !dbg !200
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %22) #4, !dbg !200
  call void @llvm.dbg.declare(metadata i64* %8, metadata !185, metadata !DIExpression()), !dbg !207
  %23 = load %struct._matrix*, %struct._matrix** %5, align 8, !dbg !208, !tbaa !51
  %24 = getelementptr inbounds %struct._matrix, %struct._matrix* %23, i32 0, i32 1, !dbg !209
  %25 = load i64, i64* %24, align 8, !dbg !209, !tbaa !137
  store i64 %25, i64* %8, align 8, !dbg !207, !tbaa !56
  call void @llvm.dbg.declare(metadata %struct._matrix* %0, metadata !186, metadata !DIExpression()), !dbg !210
  %26 = load i64, i64* %6, align 8, !dbg !211, !tbaa !56
  %27 = trunc i64 %26 to i32, !dbg !211
  %28 = load i64, i64* %8, align 8, !dbg !212, !tbaa !56
  %29 = trunc i64 %28 to i32, !dbg !212
  call void @create_matrix(%struct._matrix* sret %0, i32 %27, i32 %29, i1 zeroext false), !dbg !213
  %30 = bitcast i64* %9 to i8*, !dbg !214
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %30) #4, !dbg !214
  call void @llvm.dbg.declare(metadata i64* %9, metadata !187, metadata !DIExpression()), !dbg !215
  store i64 0, i64* %9, align 8, !dbg !215, !tbaa !56
  br label %31, !dbg !214

31:                                               ; preds = %96, %3
  %32 = load i64, i64* %9, align 8, !dbg !216, !tbaa !56
  %33 = load i64, i64* %6, align 8, !dbg !217, !tbaa !56
  %34 = icmp ult i64 %32, %33, !dbg !218
  br i1 %34, label %37, label %35, !dbg !219

35:                                               ; preds = %31
  store i32 2, i32* %10, align 4
  %36 = bitcast i64* %9 to i8*, !dbg !220
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %36) #4, !dbg !220
  br label %99

37:                                               ; preds = %31
  %38 = bitcast i64* %11 to i8*, !dbg !221
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %38) #4, !dbg !221
  call void @llvm.dbg.declare(metadata i64* %11, metadata !189, metadata !DIExpression()), !dbg !222
  store i64 0, i64* %11, align 8, !dbg !222, !tbaa !56
  br label %39, !dbg !221

39:                                               ; preds = %92, %37
  %40 = load i64, i64* %11, align 8, !dbg !223, !tbaa !56
  %41 = load i64, i64* %8, align 8, !dbg !224, !tbaa !56
  %42 = icmp ult i64 %40, %41, !dbg !225
  br i1 %42, label %45, label %43, !dbg !226

43:                                               ; preds = %39
  store i32 5, i32* %10, align 4
  %44 = bitcast i64* %11 to i8*, !dbg !227
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %44) #4, !dbg !227
  br label %95

45:                                               ; preds = %39
  %46 = bitcast double* %12 to i8*, !dbg !228
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %46) #4, !dbg !228
  call void @llvm.dbg.declare(metadata double* %12, metadata !193, metadata !DIExpression()), !dbg !229
  store double 0.000000e+00, double* %12, align 8, !dbg !229, !tbaa !168
  %47 = bitcast i64* %13 to i8*, !dbg !230
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %47) #4, !dbg !230
  call void @llvm.dbg.declare(metadata i64* %13, metadata !196, metadata !DIExpression()), !dbg !231
  store i64 0, i64* %13, align 8, !dbg !231, !tbaa !56
  br label %48, !dbg !230

48:                                               ; preds = %78, %45
  %49 = load i64, i64* %13, align 8, !dbg !232, !tbaa !56
  %50 = load i64, i64* %7, align 8, !dbg !234, !tbaa !56
  %51 = icmp ult i64 %49, %50, !dbg !235
  br i1 %51, label %54, label %52, !dbg !236

52:                                               ; preds = %48
  store i32 8, i32* %10, align 4
  %53 = bitcast i64* %13 to i8*, !dbg !237
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %53) #4, !dbg !237
  br label %81

54:                                               ; preds = %48
  %55 = load %struct._matrix*, %struct._matrix** %4, align 8, !dbg !238, !tbaa !51
  %56 = getelementptr inbounds %struct._matrix, %struct._matrix* %55, i32 0, i32 2, !dbg !240
  %57 = load double*, double** %56, align 8, !dbg !240, !tbaa !145
  %58 = load i64, i64* %9, align 8, !dbg !241, !tbaa !56
  %59 = load i64, i64* %7, align 8, !dbg !242, !tbaa !56
  %60 = mul i64 %58, %59, !dbg !243
  %61 = load i64, i64* %13, align 8, !dbg !244, !tbaa !56
  %62 = add i64 %60, %61, !dbg !245
  %63 = getelementptr inbounds double, double* %57, i64 %62, !dbg !238
  %64 = load double, double* %63, align 8, !dbg !238, !tbaa !168
  %65 = load %struct._matrix*, %struct._matrix** %5, align 8, !dbg !246, !tbaa !51
  %66 = getelementptr inbounds %struct._matrix, %struct._matrix* %65, i32 0, i32 2, !dbg !247
  %67 = load double*, double** %66, align 8, !dbg !247, !tbaa !145
  %68 = load i64, i64* %13, align 8, !dbg !248, !tbaa !56
  %69 = load i64, i64* %8, align 8, !dbg !249, !tbaa !56
  %70 = mul i64 %68, %69, !dbg !250
  %71 = load i64, i64* %11, align 8, !dbg !251, !tbaa !56
  %72 = add i64 %70, %71, !dbg !252
  %73 = getelementptr inbounds double, double* %67, i64 %72, !dbg !246
  %74 = load double, double* %73, align 8, !dbg !246, !tbaa !168
  %75 = fmul double %64, %74, !dbg !253
  %76 = load double, double* %12, align 8, !dbg !254, !tbaa !168
  %77 = fadd double %76, %75, !dbg !254
  store double %77, double* %12, align 8, !dbg !254, !tbaa !168
  br label %78, !dbg !255

78:                                               ; preds = %54
  %79 = load i64, i64* %13, align 8, !dbg !256, !tbaa !56
  %80 = add i64 %79, 1, !dbg !256
  store i64 %80, i64* %13, align 8, !dbg !256, !tbaa !56
  br label %48, !dbg !237, !llvm.loop !257

81:                                               ; preds = %52
  %82 = load double, double* %12, align 8, !dbg !259, !tbaa !168
  %83 = getelementptr inbounds %struct._matrix, %struct._matrix* %0, i32 0, i32 2, !dbg !260
  %84 = load double*, double** %83, align 8, !dbg !260, !tbaa !145
  %85 = load i64, i64* %9, align 8, !dbg !261, !tbaa !56
  %86 = load i64, i64* %8, align 8, !dbg !262, !tbaa !56
  %87 = mul i64 %85, %86, !dbg !263
  %88 = load i64, i64* %11, align 8, !dbg !264, !tbaa !56
  %89 = add i64 %87, %88, !dbg !265
  %90 = getelementptr inbounds double, double* %84, i64 %89, !dbg !266
  store double %82, double* %90, align 8, !dbg !267, !tbaa !168
  %91 = bitcast double* %12 to i8*, !dbg !268
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %91) #4, !dbg !268
  br label %92, !dbg !269

92:                                               ; preds = %81
  %93 = load i64, i64* %11, align 8, !dbg !270, !tbaa !56
  %94 = add i64 %93, 1, !dbg !270
  store i64 %94, i64* %11, align 8, !dbg !270, !tbaa !56
  br label %39, !dbg !227, !llvm.loop !271

95:                                               ; preds = %43
  br label %96, !dbg !273

96:                                               ; preds = %95
  %97 = load i64, i64* %9, align 8, !dbg !274, !tbaa !56
  %98 = add i64 %97, 1, !dbg !274
  store i64 %98, i64* %9, align 8, !dbg !274, !tbaa !56
  br label %31, !dbg !220, !llvm.loop !275

99:                                               ; preds = %35
  store i32 1, i32* %10, align 4
  %100 = bitcast i64* %8 to i8*, !dbg !277
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %100) #4, !dbg !277
  %101 = bitcast i64* %7 to i8*, !dbg !277
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %101) #4, !dbg !277
  %102 = bitcast i64* %6 to i8*, !dbg !277
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %102) #4, !dbg !277
  ret void, !dbg !277
}
; Function Attrs: nounwind uwtable
define dso_local i32 @main(i32 %0, i8** %1) #0 !dbg !278 {
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
  store i32 %0, i32* %4, align 4, !tbaa !121
  call void @llvm.dbg.declare(metadata i32* %4, metadata !282, metadata !DIExpression()), !dbg !290
  store i8** %1, i8*** %5, align 8, !tbaa !51
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !283, metadata !DIExpression()), !dbg !291
  %12 = bitcast i32* %6 to i8*, !dbg !292
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %12) #4, !dbg !292
  call void @llvm.dbg.declare(metadata i32* %6, metadata !284, metadata !DIExpression()), !dbg !293
  %13 = bitcast i32* %6 to i8*, !dbg !292
  call void @llvm.var.annotation(i8* %13, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.3, i32 0, i32 0), i32 51), !dbg !292
  %14 = bitcast i32* %7 to i8*, !dbg !292
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %14) #4, !dbg !292
  call void @llvm.dbg.declare(metadata i32* %7, metadata !285, metadata !DIExpression()), !dbg !294
  %15 = bitcast i32* %7 to i8*, !dbg !292
  call void @llvm.var.annotation(i8* %15, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.3, i32 0, i32 0), i32 51), !dbg !292
  %16 = bitcast i32* %8 to i8*, !dbg !292
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %16) #4, !dbg !292
  call void @llvm.dbg.declare(metadata i32* %8, metadata !286, metadata !DIExpression()), !dbg !295
  %17 = bitcast i32* %8 to i8*, !dbg !292
  call void @llvm.var.annotation(i8* %17, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.3, i32 0, i32 0), i32 51), !dbg !292
  %18 = load i32, i32* %4, align 4, !dbg !296, !tbaa !121
  %19 = icmp eq i32 %18, 4, !dbg !296
  br i1 %19, label %20, label %21, !dbg !299

20:                                               ; preds = %2
  br label %22, !dbg !299

21:                                               ; preds = %2
  call void @__assert_fail(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.4, i64 0, i64 0), i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.5, i64 0, i64 0), i32 52, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #9, !dbg !296
  unreachable, !dbg !296

22:                                               ; preds = %20
  %23 = load i8**, i8*** %5, align 8, !dbg !300, !tbaa !51
  %24 = getelementptr inbounds i8*, i8** %23, i64 1, !dbg !300
  %25 = load i8*, i8** %24, align 8, !dbg !300, !tbaa !51
  %26 = call i32 @atoi(i8* %25) #10, !dbg !301
  store i32 %26, i32* %6, align 4, !dbg !302, !tbaa !121
  %27 = load i8**, i8*** %5, align 8, !dbg !303, !tbaa !51
  %28 = getelementptr inbounds i8*, i8** %27, i64 2, !dbg !303
  %29 = load i8*, i8** %28, align 8, !dbg !303, !tbaa !51
  %30 = call i32 @atoi(i8* %29) #10, !dbg !304
  store i32 %30, i32* %7, align 4, !dbg !305, !tbaa !121
  %31 = load i8**, i8*** %5, align 8, !dbg !306, !tbaa !51
  %32 = getelementptr inbounds i8*, i8** %31, i64 3, !dbg !306
  %33 = load i8*, i8** %32, align 8, !dbg !306, !tbaa !51
  %34 = call i32 @atoi(i8* %33) #10, !dbg !307
  store i32 %34, i32* %8, align 4, !dbg !308, !tbaa !121
  %35 = call i64 @time(i64* null) #4, !dbg !309
  %36 = trunc i64 %35 to i32, !dbg !309
  call void @srand(i32 %36) #4, !dbg !310
  %37 = bitcast i32* %6 to i8*, !dbg !311
  call void @register_variable(i8* %37, i64 4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i64 0, i64 0)), !dbg !312
  %38 = bitcast i32* %7 to i8*, !dbg !313
  call void @register_variable(i8* %38, i64 4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i64 0, i64 0)), !dbg !314
  %39 = bitcast i32* %8 to i8*, !dbg !315
  call void @register_variable(i8* %39, i64 4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i64 0, i64 0)), !dbg !316
  %40 = bitcast %struct._matrix* %9 to i8*, !dbg !317
  call void @llvm.lifetime.start.p0i8(i64 24, i8* %40) #4, !dbg !317
  call void @llvm.dbg.declare(metadata %struct._matrix* %9, metadata !287, metadata !DIExpression()), !dbg !318
  %41 = load i32, i32* %6, align 4, !dbg !319, !tbaa !121
  %42 = load i32, i32* %7, align 4, !dbg !320, !tbaa !121
  call void @create_matrix(%struct._matrix* sret %9, i32 %41, i32 %42, i1 zeroext true), !dbg !321
  %43 = bitcast %struct._matrix* %10 to i8*, !dbg !322
  call void @llvm.lifetime.start.p0i8(i64 24, i8* %43) #4, !dbg !322
  call void @llvm.dbg.declare(metadata %struct._matrix* %10, metadata !288, metadata !DIExpression()), !dbg !323
  %44 = load i32, i32* %7, align 4, !dbg !324, !tbaa !121
  %45 = load i32, i32* %8, align 4, !dbg !325, !tbaa !121
  call void @create_matrix(%struct._matrix* sret %10, i32 %44, i32 %45, i1 zeroext true), !dbg !326
  %46 = bitcast %struct._matrix* %11 to i8*, !dbg !327
  call void @llvm.lifetime.start.p0i8(i64 24, i8* %46) #4, !dbg !327
  call void @llvm.dbg.declare(metadata %struct._matrix* %11, metadata !289, metadata !DIExpression()), !dbg !328
  call void @mat_mul(%struct._matrix* sret %11, %struct._matrix* %9, %struct._matrix* %10), !dbg !329
  %47 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !330, !tbaa !51
  %48 = getelementptr inbounds %struct._matrix, %struct._matrix* %11, i32 0, i32 2, !dbg !331
  %49 = load double*, double** %48, align 8, !dbg !331, !tbaa !145
  %50 = getelementptr inbounds double, double* %49, i64 0, !dbg !332
  %51 = load double, double* %50, align 8, !dbg !332, !tbaa !168
  %52 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %47, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.9, i64 0, i64 0), double %51), !dbg !333
  %53 = getelementptr inbounds %struct._matrix, %struct._matrix* %9, i32 0, i32 2, !dbg !334
  %54 = load double*, double** %53, align 8, !dbg !334, !tbaa !145
  %55 = bitcast double* %54 to i8*, !dbg !335
  call void @free(i8* %55) #4, !dbg !336
  %56 = getelementptr inbounds %struct._matrix, %struct._matrix* %10, i32 0, i32 2, !dbg !337
  %57 = load double*, double** %56, align 8, !dbg !337, !tbaa !145
  %58 = bitcast double* %57 to i8*, !dbg !338
  call void @free(i8* %58) #4, !dbg !339
  %59 = getelementptr inbounds %struct._matrix, %struct._matrix* %11, i32 0, i32 2, !dbg !340
  %60 = load double*, double** %59, align 8, !dbg !340, !tbaa !145
  %61 = bitcast double* %60 to i8*, !dbg !341
  call void @free(i8* %61) #4, !dbg !342
  %62 = bitcast %struct._matrix* %11 to i8*, !dbg !343
  call void @llvm.lifetime.end.p0i8(i64 24, i8* %62) #4, !dbg !343
  %63 = bitcast %struct._matrix* %10 to i8*, !dbg !343
  call void @llvm.lifetime.end.p0i8(i64 24, i8* %63) #4, !dbg !343
  %64 = bitcast %struct._matrix* %9 to i8*, !dbg !343
  call void @llvm.lifetime.end.p0i8(i64 24, i8* %64) #4, !dbg !343
  %65 = bitcast i32* %8 to i8*, !dbg !343
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %65) #4, !dbg !343
  %66 = bitcast i32* %7 to i8*, !dbg !343
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %66) #4, !dbg !343
  %67 = bitcast i32* %6 to i8*, !dbg !343
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %67) #4, !dbg !343
  ret i32 0, !dbg !344
}
; Function Attrs: nounwind willreturn
declare void @llvm.var.annotation(i8*, i8*, i8*, i32) #6
; Function Attrs: noreturn nounwind
declare dso_local void @__assert_fail(i8*, i8*, i32, i8*) #7
; Function Attrs: inlinehint nounwind readonly uwtable
define available_externally dso_local i32 @atoi(i8* nonnull %0) #8 !dbg !345 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8, !tbaa !51
  call void @llvm.dbg.declare(metadata i8** %2, metadata !349, metadata !DIExpression()), !dbg !350
  %3 = load i8*, i8** %2, align 8, !dbg !351, !tbaa !51
  %4 = call i64 @strtol(i8* %3, i8** null, i32 10) #4, !dbg !352
  %5 = trunc i64 %4 to i32, !dbg !353
  ret i32 %5, !dbg !354
}
; Function Attrs: nounwind
declare !dbg !23 dso_local void @srand(i32) #5
; Function Attrs: nounwind
declare !dbg !17 dso_local i64 @time(i64*) #5
; Function Attrs: nounwind
declare !dbg !27 dso_local void @free(i8*) #5
; Function Attrs: nounwind
declare dso_local i64 @strtol(i8*, i8**, i32) #5

attributes #0 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable willreturn }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { argmemonly nounwind willreturn }
attributes #4 = { nounwind }
attributes #5 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #6 = { nounwind willreturn }
attributes #7 = { noreturn nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #8 = { inlinehint nounwind readonly uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #9 = { noreturn nounwind }
attributes #10 = { nounwind readonly }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!34, !35, !36}
!llvm.ident = !{!37}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 10.0.0 (git@github.com:nwicki/llvm-project.git 455932f59aea0de5af4606ebf15d6df72f4c0136)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !3, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "tests/dfsan-unit/matmul.c", directory: "/home/mcopik/projects/ETH/extrap/rebuild/perf-taint")
!2 = !{}
!3 = !{!4, !10, !12, !17, !23, !27, !16, !31, !30}
!4 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !5, size: 64)
!5 = !DIDerivedType(tag: DW_TAG_typedef, name: "int8_t", file: !6, line: 24, baseType: !7)
!6 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-intn.h", directory: "")
!7 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int8_t", file: !8, line: 36, baseType: !9)
!8 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "")
!9 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!10 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !11, size: 64)
!11 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!12 = !DISubprogram(name: "rand", scope: !13, file: !13, line: 453, type: !14, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized, retainedNodes: !2)
!13 = !DIFile(filename: "/usr/include/stdlib.h", directory: "")
!14 = !DISubroutineType(types: !15)
!15 = !{!16}
!16 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!17 = !DISubprogram(name: "time", scope: !18, file: !18, line: 75, type: !19, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized, retainedNodes: !2)
!18 = !DIFile(filename: "/usr/include/time.h", directory: "")
!19 = !DISubroutineType(types: !20)
!20 = !{!21, !22}
!21 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!22 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !21, size: 64)
!23 = !DISubprogram(name: "srand", scope: !13, file: !13, line: 455, type: !24, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized, retainedNodes: !2)
!24 = !DISubroutineType(types: !25)
!25 = !{null, !26}
!26 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!27 = !DISubprogram(name: "free", scope: !13, file: !13, line: 563, type: !28, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized, retainedNodes: !2)
!28 = !DISubroutineType(types: !29)
!29 = !{null, !30}
!30 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!31 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !32, size: 64)
!32 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !33, size: 64)
!33 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!34 = !{i32 7, !"Dwarf Version", i32 4}
!35 = !{i32 2, !"Debug Info Version", i32 3}
!36 = !{i32 1, !"wchar_size", i32 4}
!37 = !{!"clang version 10.0.0 (git@github.com:nwicki/llvm-project.git 455932f59aea0de5af4606ebf15d6df72f4c0136)"}
!38 = distinct !DISubprogram(name: "register_variable", scope: !39, file: !39, line: 19, type: !40, scopeLine: 20, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !47)
!39 = !DIFile(filename: "include/ExtraPInstrumenter.h", directory: "/home/mcopik/projects/ETH/extrap/rebuild/perf-taint")
!40 = !DISubroutineType(types: !41)
!41 = !{null, !30, !42, !45}
!42 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !43, line: 46, baseType: !44)
!43 = !DIFile(filename: "llvm_cfsan/install/lib/clang/10.0.0/include/stddef.h", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!44 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!45 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !46, size: 64)
!46 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !33)
!47 = !{!48, !49, !50}
!48 = !DILocalVariable(name: "ptr", arg: 1, scope: !38, file: !39, line: 19, type: !30)
!49 = !DILocalVariable(name: "size", arg: 2, scope: !38, file: !39, line: 19, type: !42)
!50 = !DILocalVariable(name: "name", arg: 3, scope: !38, file: !39, line: 19, type: !45)
!51 = !{!52, !52, i64 0}
!52 = !{!"any pointer", !53, i64 0}
!53 = !{!"omnipotent char", !54, i64 0}
!54 = !{!"Simple C/C++ TBAA"}
!55 = !DILocation(line: 19, column: 31, scope: !38)
!56 = !{!57, !57, i64 0}
!57 = !{!"long", !53, i64 0}
!58 = !DILocation(line: 19, column: 43, scope: !38)
!59 = !DILocation(line: 19, column: 62, scope: !38)
!60 = !DILocation(line: 22, column: 13, scope: !38)
!61 = !DILocation(line: 22, column: 5, scope: !38)
!62 = !DILocation(line: 24, column: 41, scope: !38)
!63 = !DILocation(line: 24, column: 46, scope: !38)
!64 = !DILocation(line: 24, column: 52, scope: !38)
!65 = !DILocation(line: 24, column: 5, scope: !38)
!66 = !DILocation(line: 25, column: 1, scope: !38)
!67 = distinct !DISubprogram(name: "register_variables", scope: !39, file: !39, line: 43, type: !68, scopeLine: 44, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !70)
!68 = !DISubroutineType(types: !69)
!69 = !{null, !45, !42, null}
!70 = !{!71, !72, !73}
!71 = !DILocalVariable(name: "name", arg: 1, scope: !67, file: !39, line: 43, type: !45)
!72 = !DILocalVariable(name: "count", arg: 2, scope: !67, file: !39, line: 43, type: !42)
!73 = !DILocalVariable(name: "args", scope: !67, file: !39, line: 45, type: !74)
!74 = !DIDerivedType(tag: DW_TAG_typedef, name: "va_list", file: !75, line: 46, baseType: !76)
!75 = !DIFile(filename: "/usr/include/stdio.h", directory: "")
!76 = !DIDerivedType(tag: DW_TAG_typedef, name: "__gnuc_va_list", file: !77, line: 32, baseType: !78)
!77 = !DIFile(filename: "llvm_cfsan/install/lib/clang/10.0.0/include/stdarg.h", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!78 = !DIDerivedType(tag: DW_TAG_typedef, name: "__builtin_va_list", file: !1, line: 45, baseType: !79)
!79 = !DICompositeType(tag: DW_TAG_array_type, baseType: !80, size: 192, elements: !86)
!80 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__va_list_tag", file: !1, line: 45, size: 192, elements: !81)
!81 = !{!82, !83, !84, !85}
!82 = !DIDerivedType(tag: DW_TAG_member, name: "gp_offset", scope: !80, file: !1, line: 45, baseType: !26, size: 32)
!83 = !DIDerivedType(tag: DW_TAG_member, name: "fp_offset", scope: !80, file: !1, line: 45, baseType: !26, size: 32, offset: 32)
!84 = !DIDerivedType(tag: DW_TAG_member, name: "overflow_arg_area", scope: !80, file: !1, line: 45, baseType: !30, size: 64, offset: 64)
!85 = !DIDerivedType(tag: DW_TAG_member, name: "reg_save_area", scope: !80, file: !1, line: 45, baseType: !30, size: 64, offset: 128)
!86 = !{!87}
!87 = !DISubrange(count: 1)
!88 = !DILocation(line: 43, column: 38, scope: !67)
!89 = !DILocation(line: 43, column: 51, scope: !67)
!90 = !DILocation(line: 45, column: 5, scope: !67)
!91 = !DILocation(line: 45, column: 13, scope: !67)
!92 = !DILocation(line: 52, column: 5, scope: !67)
!93 = !DILocation(line: 54, column: 13, scope: !67)
!94 = !DILocation(line: 54, column: 49, scope: !67)
!95 = !DILocation(line: 54, column: 5, scope: !67)
!96 = !DILocation(line: 56, column: 32, scope: !67)
!97 = !DILocation(line: 56, column: 38, scope: !67)
!98 = !DILocation(line: 56, column: 45, scope: !67)
!99 = !DILocation(line: 56, column: 5, scope: !67)
!100 = !DILocation(line: 58, column: 1, scope: !67)
!101 = distinct !DISubprogram(name: "create_matrix", scope: !1, file: !1, line: 17, type: !102, scopeLine: 18, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !111)
!102 = !DISubroutineType(types: !103)
!103 = !{!104, !16, !16, !110}
!104 = !DIDerivedType(tag: DW_TAG_typedef, name: "matrix", file: !1, line: 15, baseType: !105)
!105 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_matrix", file: !1, line: 10, size: 192, elements: !106)
!106 = !{!107, !108, !109}
!107 = !DIDerivedType(tag: DW_TAG_member, name: "rows", scope: !105, file: !1, line: 12, baseType: !42, size: 64)
!108 = !DIDerivedType(tag: DW_TAG_member, name: "cols", scope: !105, file: !1, line: 13, baseType: !42, size: 64, offset: 64)
!109 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !105, file: !1, line: 14, baseType: !10, size: 64, offset: 128)
!110 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!111 = !{!112, !113, !114, !115, !116, !119}
!112 = !DILocalVariable(name: "rows", arg: 1, scope: !101, file: !1, line: 17, type: !16)
!113 = !DILocalVariable(name: "cols", arg: 2, scope: !101, file: !1, line: 17, type: !16)
!114 = !DILocalVariable(name: "init", arg: 3, scope: !101, file: !1, line: 17, type: !110)
!115 = !DILocalVariable(name: "m", scope: !101, file: !1, line: 19, type: !104)
!116 = !DILocalVariable(name: "size", scope: !117, file: !1, line: 24, type: !42)
!117 = distinct !DILexicalBlock(scope: !118, file: !1, line: 23, column: 14)
!118 = distinct !DILexicalBlock(scope: !101, file: !1, line: 23, column: 8)
!119 = !DILocalVariable(name: "i", scope: !120, file: !1, line: 25, type: !42)
!120 = distinct !DILexicalBlock(scope: !117, file: !1, line: 25, column: 9)
!121 = !{!122, !122, i64 0}
!122 = !{!"int", !53, i64 0}
!123 = !DILocation(line: 17, column: 26, scope: !101)
!124 = !DILocation(line: 17, column: 36, scope: !101)
!125 = !{!126, !126, i64 0}
!126 = !{!"_Bool", !53, i64 0}
!127 = !DILocation(line: 17, column: 47, scope: !101)
!128 = !DILocation(line: 19, column: 12, scope: !101)
!129 = !DILocation(line: 20, column: 14, scope: !101)
!130 = !DILocation(line: 20, column: 7, scope: !101)
!131 = !DILocation(line: 20, column: 12, scope: !101)
!132 = !{!133, !57, i64 0}
!133 = !{!"_matrix", !57, i64 0, !57, i64 8, !52, i64 16}
!134 = !DILocation(line: 21, column: 14, scope: !101)
!135 = !DILocation(line: 21, column: 7, scope: !101)
!136 = !DILocation(line: 21, column: 12, scope: !101)
!137 = !{!133, !57, i64 8}
!138 = !DILocation(line: 22, column: 31, scope: !101)
!139 = !DILocation(line: 22, column: 38, scope: !101)
!140 = !DILocation(line: 22, column: 36, scope: !101)
!141 = !DILocation(line: 22, column: 24, scope: !101)
!142 = !DILocation(line: 22, column: 14, scope: !101)
!143 = !DILocation(line: 22, column: 7, scope: !101)
!144 = !DILocation(line: 22, column: 12, scope: !101)
!145 = !{!133, !52, i64 16}
!146 = !DILocation(line: 23, column: 8, scope: !118)
!147 = !{i8 0, i8 2}
!148 = !DILocation(line: 23, column: 8, scope: !101)
!149 = !DILocation(line: 24, column: 9, scope: !117)
!150 = !DILocation(line: 24, column: 16, scope: !117)
!151 = !DILocation(line: 24, column: 23, scope: !117)
!152 = !DILocation(line: 24, column: 30, scope: !117)
!153 = !DILocation(line: 24, column: 28, scope: !117)
!154 = !DILocation(line: 25, column: 13, scope: !120)
!155 = !DILocation(line: 25, column: 20, scope: !120)
!156 = !DILocation(line: 25, column: 27, scope: !157)
!157 = distinct !DILexicalBlock(scope: !120, file: !1, line: 25, column: 9)
!158 = !DILocation(line: 25, column: 31, scope: !157)
!159 = !DILocation(line: 25, column: 29, scope: !157)
!160 = !DILocation(line: 25, column: 9, scope: !120)
!161 = !DILocation(line: 25, column: 9, scope: !157)
!162 = !DILocation(line: 26, column: 25, scope: !157)
!163 = !DILocation(line: 26, column: 32, scope: !157)
!164 = !DILocation(line: 26, column: 15, scope: !157)
!165 = !DILocation(line: 26, column: 20, scope: !157)
!166 = !DILocation(line: 26, column: 13, scope: !157)
!167 = !DILocation(line: 26, column: 23, scope: !157)
!168 = !{!169, !169, i64 0}
!169 = !{!"double", !53, i64 0}
!170 = !DILocation(line: 25, column: 37, scope: !157)
!171 = distinct !{!171, !160, !172}
!172 = !DILocation(line: 26, column: 34, scope: !120)
!173 = !DILocation(line: 27, column: 5, scope: !118)
!174 = !DILocation(line: 27, column: 5, scope: !117)
!175 = !DILocation(line: 28, column: 5, scope: !101)
!176 = distinct !DISubprogram(name: "mat_mul", scope: !1, file: !1, line: 31, type: !177, scopeLine: 32, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !180)
!177 = !DISubroutineType(types: !178)
!178 = !{!104, !179, !179}
!179 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !104, size: 64)
!180 = !{!181, !182, !183, !184, !185, !186, !187, !189, !193, !196}
!181 = !DILocalVariable(name: "left", arg: 1, scope: !176, file: !1, line: 31, type: !179)
!182 = !DILocalVariable(name: "right", arg: 2, scope: !176, file: !1, line: 31, type: !179)
!183 = !DILocalVariable(name: "m", scope: !176, file: !1, line: 33, type: !42)
!184 = !DILocalVariable(name: "n", scope: !176, file: !1, line: 33, type: !42)
!185 = !DILocalVariable(name: "k", scope: !176, file: !1, line: 33, type: !42)
!186 = !DILocalVariable(name: "res", scope: !176, file: !1, line: 34, type: !104)
!187 = !DILocalVariable(name: "i", scope: !188, file: !1, line: 36, type: !42)
!188 = distinct !DILexicalBlock(scope: !176, file: !1, line: 36, column: 5)
!189 = !DILocalVariable(name: "j", scope: !190, file: !1, line: 37, type: !42)
!190 = distinct !DILexicalBlock(scope: !191, file: !1, line: 37, column: 9)
!191 = distinct !DILexicalBlock(scope: !192, file: !1, line: 36, column: 35)
!192 = distinct !DILexicalBlock(scope: !188, file: !1, line: 36, column: 5)
!193 = !DILocalVariable(name: "scalar_product", scope: !194, file: !1, line: 38, type: !11)
!194 = distinct !DILexicalBlock(scope: !195, file: !1, line: 37, column: 39)
!195 = distinct !DILexicalBlock(scope: !190, file: !1, line: 37, column: 9)
!196 = !DILocalVariable(name: "kk", scope: !197, file: !1, line: 39, type: !42)
!197 = distinct !DILexicalBlock(scope: !194, file: !1, line: 39, column: 13)
!198 = !DILocation(line: 31, column: 25, scope: !176)
!199 = !DILocation(line: 31, column: 40, scope: !176)
!200 = !DILocation(line: 33, column: 5, scope: !176)
!201 = !DILocation(line: 33, column: 12, scope: !176)
!202 = !DILocation(line: 33, column: 16, scope: !176)
!203 = !DILocation(line: 33, column: 22, scope: !176)
!204 = !DILocation(line: 33, column: 28, scope: !176)
!205 = !DILocation(line: 33, column: 32, scope: !176)
!206 = !DILocation(line: 33, column: 38, scope: !176)
!207 = !DILocation(line: 33, column: 44, scope: !176)
!208 = !DILocation(line: 33, column: 48, scope: !176)
!209 = !DILocation(line: 33, column: 55, scope: !176)
!210 = !DILocation(line: 34, column: 12, scope: !176)
!211 = !DILocation(line: 34, column: 32, scope: !176)
!212 = !DILocation(line: 34, column: 35, scope: !176)
!213 = !DILocation(line: 34, column: 18, scope: !176)
!214 = !DILocation(line: 36, column: 9, scope: !188)
!215 = !DILocation(line: 36, column: 16, scope: !188)
!216 = !DILocation(line: 36, column: 23, scope: !192)
!217 = !DILocation(line: 36, column: 27, scope: !192)
!218 = !DILocation(line: 36, column: 25, scope: !192)
!219 = !DILocation(line: 36, column: 5, scope: !188)
!220 = !DILocation(line: 36, column: 5, scope: !192)
!221 = !DILocation(line: 37, column: 13, scope: !190)
!222 = !DILocation(line: 37, column: 20, scope: !190)
!223 = !DILocation(line: 37, column: 27, scope: !195)
!224 = !DILocation(line: 37, column: 31, scope: !195)
!225 = !DILocation(line: 37, column: 29, scope: !195)
!226 = !DILocation(line: 37, column: 9, scope: !190)
!227 = !DILocation(line: 37, column: 9, scope: !195)
!228 = !DILocation(line: 38, column: 13, scope: !194)
!229 = !DILocation(line: 38, column: 20, scope: !194)
!230 = !DILocation(line: 39, column: 17, scope: !197)
!231 = !DILocation(line: 39, column: 24, scope: !197)
!232 = !DILocation(line: 39, column: 32, scope: !233)
!233 = distinct !DILexicalBlock(scope: !197, file: !1, line: 39, column: 13)
!234 = !DILocation(line: 39, column: 37, scope: !233)
!235 = !DILocation(line: 39, column: 35, scope: !233)
!236 = !DILocation(line: 39, column: 13, scope: !197)
!237 = !DILocation(line: 39, column: 13, scope: !233)
!238 = !DILocation(line: 40, column: 35, scope: !239)
!239 = distinct !DILexicalBlock(scope: !233, file: !1, line: 39, column: 46)
!240 = !DILocation(line: 40, column: 41, scope: !239)
!241 = !DILocation(line: 40, column: 46, scope: !239)
!242 = !DILocation(line: 40, column: 48, scope: !239)
!243 = !DILocation(line: 40, column: 47, scope: !239)
!244 = !DILocation(line: 40, column: 52, scope: !239)
!245 = !DILocation(line: 40, column: 50, scope: !239)
!246 = !DILocation(line: 40, column: 58, scope: !239)
!247 = !DILocation(line: 40, column: 65, scope: !239)
!248 = !DILocation(line: 40, column: 70, scope: !239)
!249 = !DILocation(line: 40, column: 73, scope: !239)
!250 = !DILocation(line: 40, column: 72, scope: !239)
!251 = !DILocation(line: 40, column: 77, scope: !239)
!252 = !DILocation(line: 40, column: 75, scope: !239)
!253 = !DILocation(line: 40, column: 56, scope: !239)
!254 = !DILocation(line: 40, column: 32, scope: !239)
!255 = !DILocation(line: 41, column: 13, scope: !239)
!256 = !DILocation(line: 39, column: 40, scope: !233)
!257 = distinct !{!257, !236, !258}
!258 = !DILocation(line: 41, column: 13, scope: !197)
!259 = !DILocation(line: 42, column: 33, scope: !194)
!260 = !DILocation(line: 42, column: 17, scope: !194)
!261 = !DILocation(line: 42, column: 22, scope: !194)
!262 = !DILocation(line: 42, column: 24, scope: !194)
!263 = !DILocation(line: 42, column: 23, scope: !194)
!264 = !DILocation(line: 42, column: 28, scope: !194)
!265 = !DILocation(line: 42, column: 26, scope: !194)
!266 = !DILocation(line: 42, column: 13, scope: !194)
!267 = !DILocation(line: 42, column: 31, scope: !194)
!268 = !DILocation(line: 43, column: 9, scope: !195)
!269 = !DILocation(line: 43, column: 9, scope: !194)
!270 = !DILocation(line: 37, column: 34, scope: !195)
!271 = distinct !{!271, !226, !272}
!272 = !DILocation(line: 43, column: 9, scope: !190)
!273 = !DILocation(line: 44, column: 5, scope: !191)
!274 = !DILocation(line: 36, column: 30, scope: !192)
!275 = distinct !{!275, !219, !276}
!276 = !DILocation(line: 44, column: 5, scope: !188)
!277 = !DILocation(line: 47, column: 1, scope: !176)
!278 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 49, type: !279, scopeLine: 50, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !281)
!279 = !DISubroutineType(types: !280)
!280 = !{!16, !16, !31}
!281 = !{!282, !283, !284, !285, !286, !287, !288, !289}
!282 = !DILocalVariable(name: "argc", arg: 1, scope: !278, file: !1, line: 49, type: !16)
!283 = !DILocalVariable(name: "argv", arg: 2, scope: !278, file: !1, line: 49, type: !31)
!284 = !DILocalVariable(name: "m", scope: !278, file: !1, line: 51, type: !16)
!285 = !DILocalVariable(name: "n", scope: !278, file: !1, line: 51, type: !16)
!286 = !DILocalVariable(name: "k", scope: !278, file: !1, line: 51, type: !16)
!287 = !DILocalVariable(name: "left", scope: !278, file: !1, line: 61, type: !104)
!288 = !DILocalVariable(name: "right", scope: !278, file: !1, line: 62, type: !104)
!289 = !DILocalVariable(name: "res", scope: !278, file: !1, line: 63, type: !104)
!290 = !DILocation(line: 49, column: 14, scope: !278)
!291 = !DILocation(line: 49, column: 28, scope: !278)
!292 = !DILocation(line: 51, column: 5, scope: !278)
!293 = !DILocation(line: 51, column: 9, scope: !278)
!294 = !DILocation(line: 51, column: 19, scope: !278)
!295 = !DILocation(line: 51, column: 29, scope: !278)
!296 = !DILocation(line: 52, column: 5, scope: !297)
!297 = distinct !DILexicalBlock(scope: !298, file: !1, line: 52, column: 5)
!298 = distinct !DILexicalBlock(scope: !278, file: !1, line: 52, column: 5)
!299 = !DILocation(line: 52, column: 5, scope: !298)
!300 = !DILocation(line: 53, column: 14, scope: !278)
!301 = !DILocation(line: 53, column: 9, scope: !278)
!302 = !DILocation(line: 53, column: 7, scope: !278)
!303 = !DILocation(line: 54, column: 14, scope: !278)
!304 = !DILocation(line: 54, column: 9, scope: !278)
!305 = !DILocation(line: 54, column: 7, scope: !278)
!306 = !DILocation(line: 55, column: 14, scope: !278)
!307 = !DILocation(line: 55, column: 9, scope: !278)
!308 = !DILocation(line: 55, column: 7, scope: !278)
!309 = !DILocation(line: 56, column: 11, scope: !278)
!310 = !DILocation(line: 56, column: 5, scope: !278)
!311 = !DILocation(line: 57, column: 23, scope: !278)
!312 = !DILocation(line: 57, column: 5, scope: !278)
!313 = !DILocation(line: 58, column: 23, scope: !278)
!314 = !DILocation(line: 58, column: 5, scope: !278)
!315 = !DILocation(line: 59, column: 23, scope: !278)
!316 = !DILocation(line: 59, column: 5, scope: !278)
!317 = !DILocation(line: 61, column: 5, scope: !278)
!318 = !DILocation(line: 61, column: 12, scope: !278)
!319 = !DILocation(line: 61, column: 33, scope: !278)
!320 = !DILocation(line: 61, column: 36, scope: !278)
!321 = !DILocation(line: 61, column: 19, scope: !278)
!322 = !DILocation(line: 62, column: 5, scope: !278)
!323 = !DILocation(line: 62, column: 12, scope: !278)
!324 = !DILocation(line: 62, column: 34, scope: !278)
!325 = !DILocation(line: 62, column: 37, scope: !278)
!326 = !DILocation(line: 62, column: 20, scope: !278)
!327 = !DILocation(line: 63, column: 5, scope: !278)
!328 = !DILocation(line: 63, column: 12, scope: !278)
!329 = !DILocation(line: 63, column: 18, scope: !278)
!330 = !DILocation(line: 65, column: 13, scope: !278)
!331 = !DILocation(line: 65, column: 33, scope: !278)
!332 = !DILocation(line: 65, column: 29, scope: !278)
!333 = !DILocation(line: 65, column: 5, scope: !278)
!334 = !DILocation(line: 67, column: 15, scope: !278)
!335 = !DILocation(line: 67, column: 10, scope: !278)
!336 = !DILocation(line: 67, column: 5, scope: !278)
!337 = !DILocation(line: 68, column: 16, scope: !278)
!338 = !DILocation(line: 68, column: 10, scope: !278)
!339 = !DILocation(line: 68, column: 5, scope: !278)
!340 = !DILocation(line: 69, column: 14, scope: !278)
!341 = !DILocation(line: 69, column: 10, scope: !278)
!342 = !DILocation(line: 69, column: 5, scope: !278)
!343 = !DILocation(line: 72, column: 1, scope: !278)
!344 = !DILocation(line: 71, column: 5, scope: !278)
!345 = distinct !DISubprogram(name: "atoi", scope: !13, file: !13, line: 361, type: !346, scopeLine: 362, flags: DIFlagPrototyped | DIFlagAllCallsDescribed, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !348)
!346 = !DISubroutineType(types: !347)
!347 = !{!16, !45}
!348 = !{!349}
!349 = !DILocalVariable(name: "__nptr", arg: 1, scope: !345, file: !13, line: 361, type: !45)
!350 = !DILocation(line: 361, column: 1, scope: !345)
!351 = !DILocation(line: 363, column: 24, scope: !345)
!352 = !DILocation(line: 363, column: 16, scope: !345)
!353 = !DILocation(line: 363, column: 10, scope: !345)
!354 = !DILocation(line: 363, column: 3, scope: !345)
