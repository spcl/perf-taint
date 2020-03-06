; RUN: opt %dfsan -S < %s 2> /dev/null | llc %llcparams - -o %t1 && clang++ %t1 -o %t2 %link && %execparams %t2 50 30 40 | diff -w %s.json -
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
@.str.1 = private unnamed_addr constant [23 x i8] c"Register %d variables\0A\00", align 1
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
  %7 = alloca i32, align 4
  store i8* %0, i8** %4, align 8, !tbaa !37
  call void @llvm.dbg.declare(metadata i8** %4, metadata !31, metadata !DIExpression()), !dbg !41
  store i64 %1, i64* %5, align 8, !tbaa !42
  call void @llvm.dbg.declare(metadata i64* %5, metadata !32, metadata !DIExpression()), !dbg !44
  store i8* %2, i8** %6, align 8, !tbaa !37
  call void @llvm.dbg.declare(metadata i8** %6, metadata !33, metadata !DIExpression()), !dbg !45
  %8 = bitcast i32* %7 to i8*, !dbg !46
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %8) #4, !dbg !46
  call void @llvm.dbg.declare(metadata i32* %7, metadata !34, metadata !DIExpression()), !dbg !47
  %9 = call i32 (...) @__dfsw_EXTRAP_VAR_ID(), !dbg !48
  store i32 %9, i32* %7, align 4, !dbg !47, !tbaa !49
  %10 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !51, !tbaa !37
  %11 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %10, i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str, i64 0, i64 0)), !dbg !52
  %12 = load i8*, i8** %4, align 8, !dbg !53, !tbaa !37
  %13 = load i64, i64* %5, align 8, !dbg !54, !tbaa !42
  %14 = trunc i64 %13 to i32, !dbg !54
  %15 = load i32, i32* %7, align 4, !dbg !55, !tbaa !49
  %16 = add nsw i32 %15, 1, !dbg !55
  store i32 %16, i32* %7, align 4, !dbg !55, !tbaa !49
  %17 = load i8*, i8** %6, align 8, !dbg !56, !tbaa !37
  call void @__dfsw_EXTRAP_STORE_LABEL(i8* %12, i32 %14, i32 %15, i8* %17), !dbg !57
  %18 = bitcast i32* %7 to i8*, !dbg !58
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %18) #4, !dbg !58
  ret void, !dbg !58
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #2

declare dso_local i32 @__dfsw_EXTRAP_VAR_ID(...) #3

declare dso_local i32 @fprintf(%struct._IO_FILE*, i8*, ...) #3

declare dso_local void @__dfsw_EXTRAP_STORE_LABEL(i8*, i32, i32, i8*) #3

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: nounwind uwtable
define dso_local void @register_variables(i8*, i64, ...) #0 !dbg !59 {
  %3 = alloca i8*, align 8
  %4 = alloca i64, align 8
  %5 = alloca [1 x %struct.__va_list_tag], align 16
  %6 = alloca i32, align 4
  store i8* %0, i8** %3, align 8, !tbaa !37
  call void @llvm.dbg.declare(metadata i8** %3, metadata !63, metadata !DIExpression()), !dbg !82
  store i64 %1, i64* %4, align 8, !tbaa !42
  call void @llvm.dbg.declare(metadata i64* %4, metadata !64, metadata !DIExpression()), !dbg !83
  %7 = bitcast [1 x %struct.__va_list_tag]* %5 to i8*, !dbg !84
  call void @llvm.lifetime.start.p0i8(i64 24, i8* %7) #4, !dbg !84
  call void @llvm.dbg.declare(metadata [1 x %struct.__va_list_tag]* %5, metadata !65, metadata !DIExpression()), !dbg !85
  %8 = getelementptr inbounds [1 x %struct.__va_list_tag], [1 x %struct.__va_list_tag]* %5, i64 0, i64 0, !dbg !86
  %9 = bitcast %struct.__va_list_tag* %8 to i8*, !dbg !86
  call void @llvm.va_start(i8* %9), !dbg !86
  %10 = bitcast i32* %6 to i8*, !dbg !87
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %10) #4, !dbg !87
  call void @llvm.dbg.declare(metadata i32* %6, metadata !81, metadata !DIExpression()), !dbg !88
  %11 = call i32 (...) @__dfsw_EXTRAP_VAR_ID(), !dbg !89
  store i32 %11, i32* %6, align 4, !dbg !88, !tbaa !49
  %12 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !90, !tbaa !37
  %13 = load i64, i64* %4, align 8, !dbg !91, !tbaa !42
  %14 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %12, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str.1, i64 0, i64 0), i64 %13), !dbg !92
  %15 = load i8*, i8** %3, align 8, !dbg !93, !tbaa !37
  %16 = load i32, i32* %6, align 4, !dbg !94, !tbaa !49
  %17 = load i64, i64* %4, align 8, !dbg !95, !tbaa !42
  %18 = getelementptr inbounds [1 x %struct.__va_list_tag], [1 x %struct.__va_list_tag]* %5, i64 0, i64 0, !dbg !96
  call void @__dfsw_EXTRAP_STORE_LABELS(i8* %15, i32 %16, i64 %17, %struct.__va_list_tag* %18), !dbg !97
  %19 = bitcast i32* %6 to i8*, !dbg !98
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %19) #4, !dbg !98
  %20 = bitcast [1 x %struct.__va_list_tag]* %5 to i8*, !dbg !98
  call void @llvm.lifetime.end.p0i8(i64 24, i8* %20) #4, !dbg !98
  ret void, !dbg !98
}

; Function Attrs: nounwind
declare void @llvm.va_start(i8*) #4

declare dso_local void @__dfsw_EXTRAP_STORE_LABELS(i8*, i32, i64, %struct.__va_list_tag*) #3

; Function Attrs: nounwind uwtable
define dso_local void @create_matrix(%struct._matrix* noalias sret, i32, i32, i1 zeroext) #0 !dbg !99 {
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i8, align 1
  %8 = alloca i64, align 8
  %9 = alloca i64, align 8
  store i32 %1, i32* %5, align 4, !tbaa !49
  call void @llvm.dbg.declare(metadata i32* %5, metadata !110, metadata !DIExpression()), !dbg !119
  store i32 %2, i32* %6, align 4, !tbaa !49
  call void @llvm.dbg.declare(metadata i32* %6, metadata !111, metadata !DIExpression()), !dbg !120
  %10 = zext i1 %3 to i8
  store i8 %10, i8* %7, align 1, !tbaa !121
  call void @llvm.dbg.declare(metadata i8* %7, metadata !112, metadata !DIExpression()), !dbg !123
  call void @llvm.dbg.declare(metadata %struct._matrix* %0, metadata !113, metadata !DIExpression()), !dbg !124
  %11 = load i32, i32* %5, align 4, !dbg !125, !tbaa !49
  %12 = sext i32 %11 to i64, !dbg !125
  %13 = getelementptr inbounds %struct._matrix, %struct._matrix* %0, i32 0, i32 0, !dbg !126
  store i64 %12, i64* %13, align 8, !dbg !127, !tbaa !128
  %14 = load i32, i32* %6, align 4, !dbg !130, !tbaa !49
  %15 = sext i32 %14 to i64, !dbg !130
  %16 = getelementptr inbounds %struct._matrix, %struct._matrix* %0, i32 0, i32 1, !dbg !131
  store i64 %15, i64* %16, align 8, !dbg !132, !tbaa !133
  %17 = load i32, i32* %5, align 4, !dbg !134, !tbaa !49
  %18 = load i32, i32* %6, align 4, !dbg !135, !tbaa !49
  %19 = mul nsw i32 %17, %18, !dbg !136
  %20 = sext i32 %19 to i64, !dbg !134
  %21 = call noalias i8* @calloc(i64 %20, i64 8) #4, !dbg !137
  %22 = bitcast i8* %21 to double*, !dbg !138
  %23 = getelementptr inbounds %struct._matrix, %struct._matrix* %0, i32 0, i32 2, !dbg !139
  store double* %22, double** %23, align 8, !dbg !140, !tbaa !141
  %24 = load i8, i8* %7, align 1, !dbg !142, !tbaa !121, !range !143
  %25 = trunc i8 %24 to i1, !dbg !142
  br i1 %25, label %26, label %52, !dbg !144

26:                                               ; preds = %4
  %27 = bitcast i64* %8 to i8*, !dbg !145
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %27) #4, !dbg !145
  call void @llvm.dbg.declare(metadata i64* %8, metadata !114, metadata !DIExpression()), !dbg !146
  %28 = load i32, i32* %5, align 4, !dbg !147, !tbaa !49
  %29 = load i32, i32* %6, align 4, !dbg !148, !tbaa !49
  %30 = mul nsw i32 %28, %29, !dbg !149
  %31 = sext i32 %30 to i64, !dbg !147
  store i64 %31, i64* %8, align 8, !dbg !146, !tbaa !42
  %32 = bitcast i64* %9 to i8*, !dbg !150
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %32) #4, !dbg !150
  call void @llvm.dbg.declare(metadata i64* %9, metadata !117, metadata !DIExpression()), !dbg !151
  store i64 0, i64* %9, align 8, !dbg !151, !tbaa !42
  br label %33, !dbg !150

33:                                               ; preds = %47, %26
  %34 = load i64, i64* %9, align 8, !dbg !152, !tbaa !42
  %35 = load i64, i64* %8, align 8, !dbg !154, !tbaa !42
  %36 = icmp ult i64 %34, %35, !dbg !155
  br i1 %36, label %39, label %37, !dbg !156

37:                                               ; preds = %33
  %38 = bitcast i64* %9 to i8*, !dbg !157
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %38) #4, !dbg !157
  br label %50

39:                                               ; preds = %33
  %40 = call i32 @rand() #4, !dbg !158
  %41 = srem i32 %40, 100, !dbg !159
  %42 = sitofp i32 %41 to double, !dbg !158
  %43 = getelementptr inbounds %struct._matrix, %struct._matrix* %0, i32 0, i32 2, !dbg !160
  %44 = load double*, double** %43, align 8, !dbg !160, !tbaa !141
  %45 = load i64, i64* %9, align 8, !dbg !161, !tbaa !42
  %46 = getelementptr inbounds double, double* %44, i64 %45, !dbg !162
  store double %42, double* %46, align 8, !dbg !163, !tbaa !164
  br label %47, !dbg !162

47:                                               ; preds = %39
  %48 = load i64, i64* %9, align 8, !dbg !166, !tbaa !42
  %49 = add i64 %48, 1, !dbg !166
  store i64 %49, i64* %9, align 8, !dbg !166, !tbaa !42
  br label %33, !dbg !157, !llvm.loop !167

50:                                               ; preds = %37
  %51 = bitcast i64* %8 to i8*, !dbg !169
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %51) #4, !dbg !169
  br label %52, !dbg !170

52:                                               ; preds = %50, %4
  ret void, !dbg !171
}

; Function Attrs: nounwind
declare dso_local noalias i8* @calloc(i64, i64) #5

; Function Attrs: nounwind
declare dso_local i32 @rand() #5

; Function Attrs: nounwind uwtable
define dso_local void @mat_mul(%struct._matrix* noalias sret, %struct._matrix*, %struct._matrix*) #0 !dbg !172 {
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
  store %struct._matrix* %1, %struct._matrix** %4, align 8, !tbaa !37
  call void @llvm.dbg.declare(metadata %struct._matrix** %4, metadata !177, metadata !DIExpression()), !dbg !194
  store %struct._matrix* %2, %struct._matrix** %5, align 8, !tbaa !37
  call void @llvm.dbg.declare(metadata %struct._matrix** %5, metadata !178, metadata !DIExpression()), !dbg !195
  %14 = bitcast i64* %6 to i8*, !dbg !196
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %14) #4, !dbg !196
  call void @llvm.dbg.declare(metadata i64* %6, metadata !179, metadata !DIExpression()), !dbg !197
  %15 = load %struct._matrix*, %struct._matrix** %4, align 8, !dbg !198, !tbaa !37
  %16 = getelementptr inbounds %struct._matrix, %struct._matrix* %15, i32 0, i32 0, !dbg !199
  %17 = load i64, i64* %16, align 8, !dbg !199, !tbaa !128
  store i64 %17, i64* %6, align 8, !dbg !197, !tbaa !42
  %18 = bitcast i64* %7 to i8*, !dbg !196
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %18) #4, !dbg !196
  call void @llvm.dbg.declare(metadata i64* %7, metadata !180, metadata !DIExpression()), !dbg !200
  %19 = load %struct._matrix*, %struct._matrix** %4, align 8, !dbg !201, !tbaa !37
  %20 = getelementptr inbounds %struct._matrix, %struct._matrix* %19, i32 0, i32 1, !dbg !202
  %21 = load i64, i64* %20, align 8, !dbg !202, !tbaa !133
  store i64 %21, i64* %7, align 8, !dbg !200, !tbaa !42
  %22 = bitcast i64* %8 to i8*, !dbg !196
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %22) #4, !dbg !196
  call void @llvm.dbg.declare(metadata i64* %8, metadata !181, metadata !DIExpression()), !dbg !203
  %23 = load %struct._matrix*, %struct._matrix** %5, align 8, !dbg !204, !tbaa !37
  %24 = getelementptr inbounds %struct._matrix, %struct._matrix* %23, i32 0, i32 1, !dbg !205
  %25 = load i64, i64* %24, align 8, !dbg !205, !tbaa !133
  store i64 %25, i64* %8, align 8, !dbg !203, !tbaa !42
  call void @llvm.dbg.declare(metadata %struct._matrix* %0, metadata !182, metadata !DIExpression()), !dbg !206
  %26 = load i64, i64* %6, align 8, !dbg !207, !tbaa !42
  %27 = trunc i64 %26 to i32, !dbg !207
  %28 = load i64, i64* %8, align 8, !dbg !208, !tbaa !42
  %29 = trunc i64 %28 to i32, !dbg !208
  call void @create_matrix(%struct._matrix* sret %0, i32 %27, i32 %29, i1 zeroext false), !dbg !209
  %30 = bitcast i64* %9 to i8*, !dbg !210
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %30) #4, !dbg !210
  call void @llvm.dbg.declare(metadata i64* %9, metadata !183, metadata !DIExpression()), !dbg !211
  store i64 0, i64* %9, align 8, !dbg !211, !tbaa !42
  br label %31, !dbg !210

31:                                               ; preds = %96, %3
  %32 = load i64, i64* %9, align 8, !dbg !212, !tbaa !42
  %33 = load i64, i64* %6, align 8, !dbg !213, !tbaa !42
  %34 = icmp ult i64 %32, %33, !dbg !214
  br i1 %34, label %37, label %35, !dbg !215

35:                                               ; preds = %31
  store i32 2, i32* %10, align 4
  %36 = bitcast i64* %9 to i8*, !dbg !216
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %36) #4, !dbg !216
  br label %99

37:                                               ; preds = %31
  %38 = bitcast i64* %11 to i8*, !dbg !217
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %38) #4, !dbg !217
  call void @llvm.dbg.declare(metadata i64* %11, metadata !185, metadata !DIExpression()), !dbg !218
  store i64 0, i64* %11, align 8, !dbg !218, !tbaa !42
  br label %39, !dbg !217

39:                                               ; preds = %92, %37
  %40 = load i64, i64* %11, align 8, !dbg !219, !tbaa !42
  %41 = load i64, i64* %8, align 8, !dbg !220, !tbaa !42
  %42 = icmp ult i64 %40, %41, !dbg !221
  br i1 %42, label %45, label %43, !dbg !222

43:                                               ; preds = %39
  store i32 5, i32* %10, align 4
  %44 = bitcast i64* %11 to i8*, !dbg !223
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %44) #4, !dbg !223
  br label %95

45:                                               ; preds = %39
  %46 = bitcast double* %12 to i8*, !dbg !224
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %46) #4, !dbg !224
  call void @llvm.dbg.declare(metadata double* %12, metadata !189, metadata !DIExpression()), !dbg !225
  store double 0.000000e+00, double* %12, align 8, !dbg !225, !tbaa !164
  %47 = bitcast i64* %13 to i8*, !dbg !226
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %47) #4, !dbg !226
  call void @llvm.dbg.declare(metadata i64* %13, metadata !192, metadata !DIExpression()), !dbg !227
  store i64 0, i64* %13, align 8, !dbg !227, !tbaa !42
  br label %48, !dbg !226

48:                                               ; preds = %78, %45
  %49 = load i64, i64* %13, align 8, !dbg !228, !tbaa !42
  %50 = load i64, i64* %7, align 8, !dbg !230, !tbaa !42
  %51 = icmp ult i64 %49, %50, !dbg !231
  br i1 %51, label %54, label %52, !dbg !232

52:                                               ; preds = %48
  store i32 8, i32* %10, align 4
  %53 = bitcast i64* %13 to i8*, !dbg !233
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %53) #4, !dbg !233
  br label %81

54:                                               ; preds = %48
  %55 = load %struct._matrix*, %struct._matrix** %4, align 8, !dbg !234, !tbaa !37
  %56 = getelementptr inbounds %struct._matrix, %struct._matrix* %55, i32 0, i32 2, !dbg !236
  %57 = load double*, double** %56, align 8, !dbg !236, !tbaa !141
  %58 = load i64, i64* %9, align 8, !dbg !237, !tbaa !42
  %59 = load i64, i64* %7, align 8, !dbg !238, !tbaa !42
  %60 = mul i64 %58, %59, !dbg !239
  %61 = load i64, i64* %13, align 8, !dbg !240, !tbaa !42
  %62 = add i64 %60, %61, !dbg !241
  %63 = getelementptr inbounds double, double* %57, i64 %62, !dbg !234
  %64 = load double, double* %63, align 8, !dbg !234, !tbaa !164
  %65 = load %struct._matrix*, %struct._matrix** %5, align 8, !dbg !242, !tbaa !37
  %66 = getelementptr inbounds %struct._matrix, %struct._matrix* %65, i32 0, i32 2, !dbg !243
  %67 = load double*, double** %66, align 8, !dbg !243, !tbaa !141
  %68 = load i64, i64* %13, align 8, !dbg !244, !tbaa !42
  %69 = load i64, i64* %8, align 8, !dbg !245, !tbaa !42
  %70 = mul i64 %68, %69, !dbg !246
  %71 = load i64, i64* %11, align 8, !dbg !247, !tbaa !42
  %72 = add i64 %70, %71, !dbg !248
  %73 = getelementptr inbounds double, double* %67, i64 %72, !dbg !242
  %74 = load double, double* %73, align 8, !dbg !242, !tbaa !164
  %75 = fmul double %64, %74, !dbg !249
  %76 = load double, double* %12, align 8, !dbg !250, !tbaa !164
  %77 = fadd double %76, %75, !dbg !250
  store double %77, double* %12, align 8, !dbg !250, !tbaa !164
  br label %78, !dbg !251

78:                                               ; preds = %54
  %79 = load i64, i64* %13, align 8, !dbg !252, !tbaa !42
  %80 = add i64 %79, 1, !dbg !252
  store i64 %80, i64* %13, align 8, !dbg !252, !tbaa !42
  br label %48, !dbg !233, !llvm.loop !253

81:                                               ; preds = %52
  %82 = load double, double* %12, align 8, !dbg !255, !tbaa !164
  %83 = getelementptr inbounds %struct._matrix, %struct._matrix* %0, i32 0, i32 2, !dbg !256
  %84 = load double*, double** %83, align 8, !dbg !256, !tbaa !141
  %85 = load i64, i64* %9, align 8, !dbg !257, !tbaa !42
  %86 = load i64, i64* %8, align 8, !dbg !258, !tbaa !42
  %87 = mul i64 %85, %86, !dbg !259
  %88 = load i64, i64* %11, align 8, !dbg !260, !tbaa !42
  %89 = add i64 %87, %88, !dbg !261
  %90 = getelementptr inbounds double, double* %84, i64 %89, !dbg !262
  store double %82, double* %90, align 8, !dbg !263, !tbaa !164
  %91 = bitcast double* %12 to i8*, !dbg !264
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %91) #4, !dbg !264
  br label %92, !dbg !265

92:                                               ; preds = %81
  %93 = load i64, i64* %11, align 8, !dbg !266, !tbaa !42
  %94 = add i64 %93, 1, !dbg !266
  store i64 %94, i64* %11, align 8, !dbg !266, !tbaa !42
  br label %39, !dbg !223, !llvm.loop !267

95:                                               ; preds = %43
  br label %96, !dbg !269

96:                                               ; preds = %95
  %97 = load i64, i64* %9, align 8, !dbg !270, !tbaa !42
  %98 = add i64 %97, 1, !dbg !270
  store i64 %98, i64* %9, align 8, !dbg !270, !tbaa !42
  br label %31, !dbg !216, !llvm.loop !271

99:                                               ; preds = %35
  store i32 1, i32* %10, align 4
  %100 = bitcast i64* %8 to i8*, !dbg !273
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %100) #4, !dbg !273
  %101 = bitcast i64* %7 to i8*, !dbg !273
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %101) #4, !dbg !273
  %102 = bitcast i64* %6 to i8*, !dbg !273
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %102) #4, !dbg !273
  ret void, !dbg !273
}

; Function Attrs: nounwind uwtable
define dso_local i32 @main(i32, i8**) #0 !dbg !274 {
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
  store i32 %0, i32* %4, align 4, !tbaa !49
  call void @llvm.dbg.declare(metadata i32* %4, metadata !278, metadata !DIExpression()), !dbg !286
  store i8** %1, i8*** %5, align 8, !tbaa !37
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !279, metadata !DIExpression()), !dbg !287
  %12 = bitcast i32* %6 to i8*, !dbg !288
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %12) #4, !dbg !288
  call void @llvm.dbg.declare(metadata i32* %6, metadata !280, metadata !DIExpression()), !dbg !289
  %13 = bitcast i32* %6 to i8*, !dbg !288
  call void @llvm.var.annotation(i8* %13, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.3, i32 0, i32 0), i32 51), !dbg !288
  %14 = bitcast i32* %7 to i8*, !dbg !288
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %14) #4, !dbg !288
  call void @llvm.dbg.declare(metadata i32* %7, metadata !281, metadata !DIExpression()), !dbg !290
  %15 = bitcast i32* %7 to i8*, !dbg !288
  call void @llvm.var.annotation(i8* %15, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.3, i32 0, i32 0), i32 51), !dbg !288
  %16 = bitcast i32* %8 to i8*, !dbg !288
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %16) #4, !dbg !288
  call void @llvm.dbg.declare(metadata i32* %8, metadata !282, metadata !DIExpression()), !dbg !291
  %17 = bitcast i32* %8 to i8*, !dbg !288
  call void @llvm.var.annotation(i8* %17, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.3, i32 0, i32 0), i32 51), !dbg !288
  %18 = load i32, i32* %4, align 4, !dbg !292, !tbaa !49
  %19 = icmp eq i32 %18, 4, !dbg !292
  br i1 %19, label %20, label %21, !dbg !295

20:                                               ; preds = %2
  br label %22, !dbg !295

21:                                               ; preds = %2
  call void @__assert_fail(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.4, i64 0, i64 0), i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.5, i64 0, i64 0), i32 52, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #8, !dbg !292
  unreachable, !dbg !292

22:                                               ; preds = %20
  %23 = load i8**, i8*** %5, align 8, !dbg !296, !tbaa !37
  %24 = getelementptr inbounds i8*, i8** %23, i64 1, !dbg !296
  %25 = load i8*, i8** %24, align 8, !dbg !296, !tbaa !37
  %26 = call i32 @atoi(i8* %25) #9, !dbg !297
  store i32 %26, i32* %6, align 4, !dbg !298, !tbaa !49
  %27 = load i8**, i8*** %5, align 8, !dbg !299, !tbaa !37
  %28 = getelementptr inbounds i8*, i8** %27, i64 2, !dbg !299
  %29 = load i8*, i8** %28, align 8, !dbg !299, !tbaa !37
  %30 = call i32 @atoi(i8* %29) #9, !dbg !300
  store i32 %30, i32* %7, align 4, !dbg !301, !tbaa !49
  %31 = load i8**, i8*** %5, align 8, !dbg !302, !tbaa !37
  %32 = getelementptr inbounds i8*, i8** %31, i64 3, !dbg !302
  %33 = load i8*, i8** %32, align 8, !dbg !302, !tbaa !37
  %34 = call i32 @atoi(i8* %33) #9, !dbg !303
  store i32 %34, i32* %8, align 4, !dbg !304, !tbaa !49
  %35 = call i64 @time(i64* null) #4, !dbg !305
  %36 = trunc i64 %35 to i32, !dbg !305
  call void @srand(i32 %36) #4, !dbg !306
  %37 = bitcast i32* %6 to i8*, !dbg !307
  call void @register_variable(i8* %37, i64 4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i64 0, i64 0)), !dbg !308
  %38 = bitcast i32* %7 to i8*, !dbg !309
  call void @register_variable(i8* %38, i64 4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.7, i64 0, i64 0)), !dbg !310
  %39 = bitcast i32* %8 to i8*, !dbg !311
  call void @register_variable(i8* %39, i64 4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.8, i64 0, i64 0)), !dbg !312
  %40 = bitcast %struct._matrix* %9 to i8*, !dbg !313
  call void @llvm.lifetime.start.p0i8(i64 24, i8* %40) #4, !dbg !313
  call void @llvm.dbg.declare(metadata %struct._matrix* %9, metadata !283, metadata !DIExpression()), !dbg !314
  %41 = load i32, i32* %6, align 4, !dbg !315, !tbaa !49
  %42 = load i32, i32* %7, align 4, !dbg !316, !tbaa !49
  call void @create_matrix(%struct._matrix* sret %9, i32 %41, i32 %42, i1 zeroext true), !dbg !317
  %43 = bitcast %struct._matrix* %10 to i8*, !dbg !318
  call void @llvm.lifetime.start.p0i8(i64 24, i8* %43) #4, !dbg !318
  call void @llvm.dbg.declare(metadata %struct._matrix* %10, metadata !284, metadata !DIExpression()), !dbg !319
  %44 = load i32, i32* %7, align 4, !dbg !320, !tbaa !49
  %45 = load i32, i32* %8, align 4, !dbg !321, !tbaa !49
  call void @create_matrix(%struct._matrix* sret %10, i32 %44, i32 %45, i1 zeroext true), !dbg !322
  %46 = bitcast %struct._matrix* %11 to i8*, !dbg !323
  call void @llvm.lifetime.start.p0i8(i64 24, i8* %46) #4, !dbg !323
  call void @llvm.dbg.declare(metadata %struct._matrix* %11, metadata !285, metadata !DIExpression()), !dbg !324
  call void @mat_mul(%struct._matrix* sret %11, %struct._matrix* %9, %struct._matrix* %10), !dbg !325
  %47 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !326, !tbaa !37
  %48 = getelementptr inbounds %struct._matrix, %struct._matrix* %11, i32 0, i32 2, !dbg !327
  %49 = load double*, double** %48, align 8, !dbg !327, !tbaa !141
  %50 = getelementptr inbounds double, double* %49, i64 0, !dbg !328
  %51 = load double, double* %50, align 8, !dbg !328, !tbaa !164
  %52 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %47, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.9, i64 0, i64 0), double %51), !dbg !329
  %53 = getelementptr inbounds %struct._matrix, %struct._matrix* %9, i32 0, i32 2, !dbg !330
  %54 = load double*, double** %53, align 8, !dbg !330, !tbaa !141
  %55 = bitcast double* %54 to i8*, !dbg !331
  call void @free(i8* %55) #4, !dbg !332
  %56 = getelementptr inbounds %struct._matrix, %struct._matrix* %10, i32 0, i32 2, !dbg !333
  %57 = load double*, double** %56, align 8, !dbg !333, !tbaa !141
  %58 = bitcast double* %57 to i8*, !dbg !334
  call void @free(i8* %58) #4, !dbg !335
  %59 = getelementptr inbounds %struct._matrix, %struct._matrix* %11, i32 0, i32 2, !dbg !336
  %60 = load double*, double** %59, align 8, !dbg !336, !tbaa !141
  %61 = bitcast double* %60 to i8*, !dbg !337
  call void @free(i8* %61) #4, !dbg !338
  %62 = bitcast %struct._matrix* %11 to i8*, !dbg !339
  call void @llvm.lifetime.end.p0i8(i64 24, i8* %62) #4, !dbg !339
  %63 = bitcast %struct._matrix* %10 to i8*, !dbg !339
  call void @llvm.lifetime.end.p0i8(i64 24, i8* %63) #4, !dbg !339
  %64 = bitcast %struct._matrix* %9 to i8*, !dbg !339
  call void @llvm.lifetime.end.p0i8(i64 24, i8* %64) #4, !dbg !339
  %65 = bitcast i32* %8 to i8*, !dbg !339
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %65) #4, !dbg !339
  %66 = bitcast i32* %7 to i8*, !dbg !339
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %66) #4, !dbg !339
  %67 = bitcast i32* %6 to i8*, !dbg !339
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %67) #4, !dbg !339
  ret i32 0, !dbg !340
}

; Function Attrs: nounwind
declare void @llvm.var.annotation(i8*, i8*, i8*, i32) #4

; Function Attrs: noreturn nounwind
declare dso_local void @__assert_fail(i8*, i8*, i32, i8*) #6

; Function Attrs: inlinehint nounwind readonly uwtable
define available_externally dso_local i32 @atoi(i8* nonnull) #7 !dbg !341 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8, !tbaa !37
  call void @llvm.dbg.declare(metadata i8** %2, metadata !346, metadata !DIExpression()), !dbg !347
  %3 = load i8*, i8** %2, align 8, !dbg !348, !tbaa !37
  %4 = call i64 @strtol(i8* %3, i8** null, i32 10) #4, !dbg !349
  %5 = trunc i64 %4 to i32, !dbg !350
  ret i32 %5, !dbg !351
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
attributes #2 = { argmemonly nounwind }
attributes #3 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
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
!21 = distinct !DISubprogram(name: "register_variable", scope: !22, file: !22, line: 17, type: !23, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !30)
!22 = !DIFile(filename: "include/ExtraPInstrumenter.h", directory: "/home/mcopik/projects/ETH/extrap/rebuild/perf-taint")
!23 = !DISubroutineType(types: !24)
!24 = !{null, !16, !25, !28}
!25 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !26, line: 46, baseType: !27)
!26 = !DIFile(filename: "clang_llvm/llvm-9.0/build-9.0/lib/clang/9.0.0/include/stddef.h", directory: "/home/mcopik/projects")
!27 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!28 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !29, size: 64)
!29 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !15)
!30 = !{!31, !32, !33, !34}
!31 = !DILocalVariable(name: "ptr", arg: 1, scope: !21, file: !22, line: 17, type: !16)
!32 = !DILocalVariable(name: "size", arg: 2, scope: !21, file: !22, line: 17, type: !25)
!33 = !DILocalVariable(name: "name", arg: 3, scope: !21, file: !22, line: 17, type: !28)
!34 = !DILocalVariable(name: "param_id", scope: !21, file: !22, line: 19, type: !35)
!35 = !DIDerivedType(tag: DW_TAG_typedef, name: "int32_t", file: !6, line: 26, baseType: !36)
!36 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int32_t", file: !8, line: 40, baseType: !12)
!37 = !{!38, !38, i64 0}
!38 = !{!"any pointer", !39, i64 0}
!39 = !{!"omnipotent char", !40, i64 0}
!40 = !{!"Simple C/C++ TBAA"}
!41 = !DILocation(line: 17, column: 31, scope: !21)
!42 = !{!43, !43, i64 0}
!43 = !{!"long", !39, i64 0}
!44 = !DILocation(line: 17, column: 43, scope: !21)
!45 = !DILocation(line: 17, column: 62, scope: !21)
!46 = !DILocation(line: 19, column: 5, scope: !21)
!47 = !DILocation(line: 19, column: 13, scope: !21)
!48 = !DILocation(line: 19, column: 24, scope: !21)
!49 = !{!50, !50, i64 0}
!50 = !{!"int", !39, i64 0}
!51 = !DILocation(line: 20, column: 13, scope: !21)
!52 = !DILocation(line: 20, column: 5, scope: !21)
!53 = !DILocation(line: 21, column: 41, scope: !21)
!54 = !DILocation(line: 21, column: 46, scope: !21)
!55 = !DILocation(line: 21, column: 60, scope: !21)
!56 = !DILocation(line: 21, column: 64, scope: !21)
!57 = !DILocation(line: 21, column: 5, scope: !21)
!58 = !DILocation(line: 22, column: 1, scope: !21)
!59 = distinct !DISubprogram(name: "register_variables", scope: !22, file: !22, line: 40, type: !60, scopeLine: 41, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !62)
!60 = !DISubroutineType(types: !61)
!61 = !{null, !28, !25, null}
!62 = !{!63, !64, !65, !81}
!63 = !DILocalVariable(name: "name", arg: 1, scope: !59, file: !22, line: 40, type: !28)
!64 = !DILocalVariable(name: "count", arg: 2, scope: !59, file: !22, line: 40, type: !25)
!65 = !DILocalVariable(name: "args", scope: !59, file: !22, line: 42, type: !66)
!66 = !DIDerivedType(tag: DW_TAG_typedef, name: "va_list", file: !67, line: 46, baseType: !68)
!67 = !DIFile(filename: "/usr/include/stdio.h", directory: "")
!68 = !DIDerivedType(tag: DW_TAG_typedef, name: "__gnuc_va_list", file: !69, line: 32, baseType: !70)
!69 = !DIFile(filename: "clang_llvm/llvm-9.0/build-9.0/lib/clang/9.0.0/include/stdarg.h", directory: "/home/mcopik/projects")
!70 = !DIDerivedType(tag: DW_TAG_typedef, name: "__builtin_va_list", file: !1, line: 42, baseType: !71)
!71 = !DICompositeType(tag: DW_TAG_array_type, baseType: !72, size: 192, elements: !79)
!72 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__va_list_tag", file: !1, line: 42, size: 192, elements: !73)
!73 = !{!74, !76, !77, !78}
!74 = !DIDerivedType(tag: DW_TAG_member, name: "gp_offset", scope: !72, file: !1, line: 42, baseType: !75, size: 32)
!75 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!76 = !DIDerivedType(tag: DW_TAG_member, name: "fp_offset", scope: !72, file: !1, line: 42, baseType: !75, size: 32, offset: 32)
!77 = !DIDerivedType(tag: DW_TAG_member, name: "overflow_arg_area", scope: !72, file: !1, line: 42, baseType: !16, size: 64, offset: 64)
!78 = !DIDerivedType(tag: DW_TAG_member, name: "reg_save_area", scope: !72, file: !1, line: 42, baseType: !16, size: 64, offset: 128)
!79 = !{!80}
!80 = !DISubrange(count: 1)
!81 = !DILocalVariable(name: "param_id", scope: !59, file: !22, line: 50, type: !35)
!82 = !DILocation(line: 40, column: 38, scope: !59)
!83 = !DILocation(line: 40, column: 51, scope: !59)
!84 = !DILocation(line: 42, column: 5, scope: !59)
!85 = !DILocation(line: 42, column: 13, scope: !59)
!86 = !DILocation(line: 49, column: 5, scope: !59)
!87 = !DILocation(line: 50, column: 5, scope: !59)
!88 = !DILocation(line: 50, column: 13, scope: !59)
!89 = !DILocation(line: 50, column: 24, scope: !59)
!90 = !DILocation(line: 51, column: 13, scope: !59)
!91 = !DILocation(line: 51, column: 48, scope: !59)
!92 = !DILocation(line: 51, column: 5, scope: !59)
!93 = !DILocation(line: 52, column: 32, scope: !59)
!94 = !DILocation(line: 52, column: 38, scope: !59)
!95 = !DILocation(line: 52, column: 48, scope: !59)
!96 = !DILocation(line: 52, column: 55, scope: !59)
!97 = !DILocation(line: 52, column: 5, scope: !59)
!98 = !DILocation(line: 54, column: 1, scope: !59)
!99 = distinct !DISubprogram(name: "create_matrix", scope: !1, file: !1, line: 17, type: !100, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !109)
!100 = !DISubroutineType(types: !101)
!101 = !{!102, !12, !12, !108}
!102 = !DIDerivedType(tag: DW_TAG_typedef, name: "matrix", file: !1, line: 15, baseType: !103)
!103 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_matrix", file: !1, line: 10, size: 192, elements: !104)
!104 = !{!105, !106, !107}
!105 = !DIDerivedType(tag: DW_TAG_member, name: "rows", scope: !103, file: !1, line: 12, baseType: !25, size: 64)
!106 = !DIDerivedType(tag: DW_TAG_member, name: "cols", scope: !103, file: !1, line: 13, baseType: !25, size: 64, offset: 64)
!107 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !103, file: !1, line: 14, baseType: !10, size: 64, offset: 128)
!108 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!109 = !{!110, !111, !112, !113, !114, !117}
!110 = !DILocalVariable(name: "rows", arg: 1, scope: !99, file: !1, line: 17, type: !12)
!111 = !DILocalVariable(name: "cols", arg: 2, scope: !99, file: !1, line: 17, type: !12)
!112 = !DILocalVariable(name: "init", arg: 3, scope: !99, file: !1, line: 17, type: !108)
!113 = !DILocalVariable(name: "m", scope: !99, file: !1, line: 19, type: !102)
!114 = !DILocalVariable(name: "size", scope: !115, file: !1, line: 24, type: !25)
!115 = distinct !DILexicalBlock(scope: !116, file: !1, line: 23, column: 14)
!116 = distinct !DILexicalBlock(scope: !99, file: !1, line: 23, column: 8)
!117 = !DILocalVariable(name: "i", scope: !118, file: !1, line: 25, type: !25)
!118 = distinct !DILexicalBlock(scope: !115, file: !1, line: 25, column: 9)
!119 = !DILocation(line: 17, column: 26, scope: !99)
!120 = !DILocation(line: 17, column: 36, scope: !99)
!121 = !{!122, !122, i64 0}
!122 = !{!"_Bool", !39, i64 0}
!123 = !DILocation(line: 17, column: 47, scope: !99)
!124 = !DILocation(line: 19, column: 12, scope: !99)
!125 = !DILocation(line: 20, column: 14, scope: !99)
!126 = !DILocation(line: 20, column: 7, scope: !99)
!127 = !DILocation(line: 20, column: 12, scope: !99)
!128 = !{!129, !43, i64 0}
!129 = !{!"_matrix", !43, i64 0, !43, i64 8, !38, i64 16}
!130 = !DILocation(line: 21, column: 14, scope: !99)
!131 = !DILocation(line: 21, column: 7, scope: !99)
!132 = !DILocation(line: 21, column: 12, scope: !99)
!133 = !{!129, !43, i64 8}
!134 = !DILocation(line: 22, column: 31, scope: !99)
!135 = !DILocation(line: 22, column: 38, scope: !99)
!136 = !DILocation(line: 22, column: 36, scope: !99)
!137 = !DILocation(line: 22, column: 24, scope: !99)
!138 = !DILocation(line: 22, column: 14, scope: !99)
!139 = !DILocation(line: 22, column: 7, scope: !99)
!140 = !DILocation(line: 22, column: 12, scope: !99)
!141 = !{!129, !38, i64 16}
!142 = !DILocation(line: 23, column: 8, scope: !116)
!143 = !{i8 0, i8 2}
!144 = !DILocation(line: 23, column: 8, scope: !99)
!145 = !DILocation(line: 24, column: 9, scope: !115)
!146 = !DILocation(line: 24, column: 16, scope: !115)
!147 = !DILocation(line: 24, column: 23, scope: !115)
!148 = !DILocation(line: 24, column: 30, scope: !115)
!149 = !DILocation(line: 24, column: 28, scope: !115)
!150 = !DILocation(line: 25, column: 13, scope: !118)
!151 = !DILocation(line: 25, column: 20, scope: !118)
!152 = !DILocation(line: 25, column: 27, scope: !153)
!153 = distinct !DILexicalBlock(scope: !118, file: !1, line: 25, column: 9)
!154 = !DILocation(line: 25, column: 31, scope: !153)
!155 = !DILocation(line: 25, column: 29, scope: !153)
!156 = !DILocation(line: 25, column: 9, scope: !118)
!157 = !DILocation(line: 25, column: 9, scope: !153)
!158 = !DILocation(line: 26, column: 25, scope: !153)
!159 = !DILocation(line: 26, column: 32, scope: !153)
!160 = !DILocation(line: 26, column: 15, scope: !153)
!161 = !DILocation(line: 26, column: 20, scope: !153)
!162 = !DILocation(line: 26, column: 13, scope: !153)
!163 = !DILocation(line: 26, column: 23, scope: !153)
!164 = !{!165, !165, i64 0}
!165 = !{!"double", !39, i64 0}
!166 = !DILocation(line: 25, column: 37, scope: !153)
!167 = distinct !{!167, !156, !168}
!168 = !DILocation(line: 26, column: 34, scope: !118)
!169 = !DILocation(line: 27, column: 5, scope: !116)
!170 = !DILocation(line: 27, column: 5, scope: !115)
!171 = !DILocation(line: 28, column: 5, scope: !99)
!172 = distinct !DISubprogram(name: "mat_mul", scope: !1, file: !1, line: 31, type: !173, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !176)
!173 = !DISubroutineType(types: !174)
!174 = !{!102, !175, !175}
!175 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !102, size: 64)
!176 = !{!177, !178, !179, !180, !181, !182, !183, !185, !189, !192}
!177 = !DILocalVariable(name: "left", arg: 1, scope: !172, file: !1, line: 31, type: !175)
!178 = !DILocalVariable(name: "right", arg: 2, scope: !172, file: !1, line: 31, type: !175)
!179 = !DILocalVariable(name: "m", scope: !172, file: !1, line: 33, type: !25)
!180 = !DILocalVariable(name: "n", scope: !172, file: !1, line: 33, type: !25)
!181 = !DILocalVariable(name: "k", scope: !172, file: !1, line: 33, type: !25)
!182 = !DILocalVariable(name: "res", scope: !172, file: !1, line: 34, type: !102)
!183 = !DILocalVariable(name: "i", scope: !184, file: !1, line: 36, type: !25)
!184 = distinct !DILexicalBlock(scope: !172, file: !1, line: 36, column: 5)
!185 = !DILocalVariable(name: "j", scope: !186, file: !1, line: 37, type: !25)
!186 = distinct !DILexicalBlock(scope: !187, file: !1, line: 37, column: 9)
!187 = distinct !DILexicalBlock(scope: !188, file: !1, line: 36, column: 35)
!188 = distinct !DILexicalBlock(scope: !184, file: !1, line: 36, column: 5)
!189 = !DILocalVariable(name: "scalar_product", scope: !190, file: !1, line: 38, type: !11)
!190 = distinct !DILexicalBlock(scope: !191, file: !1, line: 37, column: 39)
!191 = distinct !DILexicalBlock(scope: !186, file: !1, line: 37, column: 9)
!192 = !DILocalVariable(name: "kk", scope: !193, file: !1, line: 39, type: !25)
!193 = distinct !DILexicalBlock(scope: !190, file: !1, line: 39, column: 13)
!194 = !DILocation(line: 31, column: 25, scope: !172)
!195 = !DILocation(line: 31, column: 40, scope: !172)
!196 = !DILocation(line: 33, column: 5, scope: !172)
!197 = !DILocation(line: 33, column: 12, scope: !172)
!198 = !DILocation(line: 33, column: 16, scope: !172)
!199 = !DILocation(line: 33, column: 22, scope: !172)
!200 = !DILocation(line: 33, column: 28, scope: !172)
!201 = !DILocation(line: 33, column: 32, scope: !172)
!202 = !DILocation(line: 33, column: 38, scope: !172)
!203 = !DILocation(line: 33, column: 44, scope: !172)
!204 = !DILocation(line: 33, column: 48, scope: !172)
!205 = !DILocation(line: 33, column: 55, scope: !172)
!206 = !DILocation(line: 34, column: 12, scope: !172)
!207 = !DILocation(line: 34, column: 32, scope: !172)
!208 = !DILocation(line: 34, column: 35, scope: !172)
!209 = !DILocation(line: 34, column: 18, scope: !172)
!210 = !DILocation(line: 36, column: 9, scope: !184)
!211 = !DILocation(line: 36, column: 16, scope: !184)
!212 = !DILocation(line: 36, column: 23, scope: !188)
!213 = !DILocation(line: 36, column: 27, scope: !188)
!214 = !DILocation(line: 36, column: 25, scope: !188)
!215 = !DILocation(line: 36, column: 5, scope: !184)
!216 = !DILocation(line: 36, column: 5, scope: !188)
!217 = !DILocation(line: 37, column: 13, scope: !186)
!218 = !DILocation(line: 37, column: 20, scope: !186)
!219 = !DILocation(line: 37, column: 27, scope: !191)
!220 = !DILocation(line: 37, column: 31, scope: !191)
!221 = !DILocation(line: 37, column: 29, scope: !191)
!222 = !DILocation(line: 37, column: 9, scope: !186)
!223 = !DILocation(line: 37, column: 9, scope: !191)
!224 = !DILocation(line: 38, column: 13, scope: !190)
!225 = !DILocation(line: 38, column: 20, scope: !190)
!226 = !DILocation(line: 39, column: 17, scope: !193)
!227 = !DILocation(line: 39, column: 24, scope: !193)
!228 = !DILocation(line: 39, column: 32, scope: !229)
!229 = distinct !DILexicalBlock(scope: !193, file: !1, line: 39, column: 13)
!230 = !DILocation(line: 39, column: 37, scope: !229)
!231 = !DILocation(line: 39, column: 35, scope: !229)
!232 = !DILocation(line: 39, column: 13, scope: !193)
!233 = !DILocation(line: 39, column: 13, scope: !229)
!234 = !DILocation(line: 40, column: 35, scope: !235)
!235 = distinct !DILexicalBlock(scope: !229, file: !1, line: 39, column: 46)
!236 = !DILocation(line: 40, column: 41, scope: !235)
!237 = !DILocation(line: 40, column: 46, scope: !235)
!238 = !DILocation(line: 40, column: 48, scope: !235)
!239 = !DILocation(line: 40, column: 47, scope: !235)
!240 = !DILocation(line: 40, column: 52, scope: !235)
!241 = !DILocation(line: 40, column: 50, scope: !235)
!242 = !DILocation(line: 40, column: 58, scope: !235)
!243 = !DILocation(line: 40, column: 65, scope: !235)
!244 = !DILocation(line: 40, column: 70, scope: !235)
!245 = !DILocation(line: 40, column: 73, scope: !235)
!246 = !DILocation(line: 40, column: 72, scope: !235)
!247 = !DILocation(line: 40, column: 77, scope: !235)
!248 = !DILocation(line: 40, column: 75, scope: !235)
!249 = !DILocation(line: 40, column: 56, scope: !235)
!250 = !DILocation(line: 40, column: 32, scope: !235)
!251 = !DILocation(line: 41, column: 13, scope: !235)
!252 = !DILocation(line: 39, column: 40, scope: !229)
!253 = distinct !{!253, !232, !254}
!254 = !DILocation(line: 41, column: 13, scope: !193)
!255 = !DILocation(line: 42, column: 33, scope: !190)
!256 = !DILocation(line: 42, column: 17, scope: !190)
!257 = !DILocation(line: 42, column: 22, scope: !190)
!258 = !DILocation(line: 42, column: 24, scope: !190)
!259 = !DILocation(line: 42, column: 23, scope: !190)
!260 = !DILocation(line: 42, column: 28, scope: !190)
!261 = !DILocation(line: 42, column: 26, scope: !190)
!262 = !DILocation(line: 42, column: 13, scope: !190)
!263 = !DILocation(line: 42, column: 31, scope: !190)
!264 = !DILocation(line: 43, column: 9, scope: !191)
!265 = !DILocation(line: 43, column: 9, scope: !190)
!266 = !DILocation(line: 37, column: 34, scope: !191)
!267 = distinct !{!267, !222, !268}
!268 = !DILocation(line: 43, column: 9, scope: !186)
!269 = !DILocation(line: 44, column: 5, scope: !187)
!270 = !DILocation(line: 36, column: 30, scope: !188)
!271 = distinct !{!271, !215, !272}
!272 = !DILocation(line: 44, column: 5, scope: !184)
!273 = !DILocation(line: 47, column: 1, scope: !172)
!274 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 49, type: !275, scopeLine: 50, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !277)
!275 = !DISubroutineType(types: !276)
!276 = !{!12, !12, !13}
!277 = !{!278, !279, !280, !281, !282, !283, !284, !285}
!278 = !DILocalVariable(name: "argc", arg: 1, scope: !274, file: !1, line: 49, type: !12)
!279 = !DILocalVariable(name: "argv", arg: 2, scope: !274, file: !1, line: 49, type: !13)
!280 = !DILocalVariable(name: "m", scope: !274, file: !1, line: 51, type: !12)
!281 = !DILocalVariable(name: "n", scope: !274, file: !1, line: 51, type: !12)
!282 = !DILocalVariable(name: "k", scope: !274, file: !1, line: 51, type: !12)
!283 = !DILocalVariable(name: "left", scope: !274, file: !1, line: 61, type: !102)
!284 = !DILocalVariable(name: "right", scope: !274, file: !1, line: 62, type: !102)
!285 = !DILocalVariable(name: "res", scope: !274, file: !1, line: 63, type: !102)
!286 = !DILocation(line: 49, column: 14, scope: !274)
!287 = !DILocation(line: 49, column: 28, scope: !274)
!288 = !DILocation(line: 51, column: 5, scope: !274)
!289 = !DILocation(line: 51, column: 9, scope: !274)
!290 = !DILocation(line: 51, column: 19, scope: !274)
!291 = !DILocation(line: 51, column: 29, scope: !274)
!292 = !DILocation(line: 52, column: 5, scope: !293)
!293 = distinct !DILexicalBlock(scope: !294, file: !1, line: 52, column: 5)
!294 = distinct !DILexicalBlock(scope: !274, file: !1, line: 52, column: 5)
!295 = !DILocation(line: 52, column: 5, scope: !294)
!296 = !DILocation(line: 53, column: 14, scope: !274)
!297 = !DILocation(line: 53, column: 9, scope: !274)
!298 = !DILocation(line: 53, column: 7, scope: !274)
!299 = !DILocation(line: 54, column: 14, scope: !274)
!300 = !DILocation(line: 54, column: 9, scope: !274)
!301 = !DILocation(line: 54, column: 7, scope: !274)
!302 = !DILocation(line: 55, column: 14, scope: !274)
!303 = !DILocation(line: 55, column: 9, scope: !274)
!304 = !DILocation(line: 55, column: 7, scope: !274)
!305 = !DILocation(line: 56, column: 11, scope: !274)
!306 = !DILocation(line: 56, column: 5, scope: !274)
!307 = !DILocation(line: 57, column: 23, scope: !274)
!308 = !DILocation(line: 57, column: 5, scope: !274)
!309 = !DILocation(line: 58, column: 23, scope: !274)
!310 = !DILocation(line: 58, column: 5, scope: !274)
!311 = !DILocation(line: 59, column: 23, scope: !274)
!312 = !DILocation(line: 59, column: 5, scope: !274)
!313 = !DILocation(line: 61, column: 5, scope: !274)
!314 = !DILocation(line: 61, column: 12, scope: !274)
!315 = !DILocation(line: 61, column: 33, scope: !274)
!316 = !DILocation(line: 61, column: 36, scope: !274)
!317 = !DILocation(line: 61, column: 19, scope: !274)
!318 = !DILocation(line: 62, column: 5, scope: !274)
!319 = !DILocation(line: 62, column: 12, scope: !274)
!320 = !DILocation(line: 62, column: 34, scope: !274)
!321 = !DILocation(line: 62, column: 37, scope: !274)
!322 = !DILocation(line: 62, column: 20, scope: !274)
!323 = !DILocation(line: 63, column: 5, scope: !274)
!324 = !DILocation(line: 63, column: 12, scope: !274)
!325 = !DILocation(line: 63, column: 18, scope: !274)
!326 = !DILocation(line: 65, column: 13, scope: !274)
!327 = !DILocation(line: 65, column: 33, scope: !274)
!328 = !DILocation(line: 65, column: 29, scope: !274)
!329 = !DILocation(line: 65, column: 5, scope: !274)
!330 = !DILocation(line: 67, column: 15, scope: !274)
!331 = !DILocation(line: 67, column: 10, scope: !274)
!332 = !DILocation(line: 67, column: 5, scope: !274)
!333 = !DILocation(line: 68, column: 16, scope: !274)
!334 = !DILocation(line: 68, column: 10, scope: !274)
!335 = !DILocation(line: 68, column: 5, scope: !274)
!336 = !DILocation(line: 69, column: 14, scope: !274)
!337 = !DILocation(line: 69, column: 10, scope: !274)
!338 = !DILocation(line: 69, column: 5, scope: !274)
!339 = !DILocation(line: 72, column: 1, scope: !274)
!340 = !DILocation(line: 71, column: 5, scope: !274)
!341 = distinct !DISubprogram(name: "atoi", scope: !342, file: !342, line: 361, type: !343, scopeLine: 362, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !345)
!342 = !DIFile(filename: "/usr/include/stdlib.h", directory: "")
!343 = !DISubroutineType(types: !344)
!344 = !{!12, !28}
!345 = !{!346}
!346 = !DILocalVariable(name: "__nptr", arg: 1, scope: !341, file: !342, line: 361, type: !28)
!347 = !DILocation(line: 361, column: 1, scope: !341)
!348 = !DILocation(line: 363, column: 24, scope: !341)
!349 = !DILocation(line: 363, column: 16, scope: !341)
!350 = !DILocation(line: 363, column: 10, scope: !341)
!351 = !DILocation(line: 363, column: 3, scope: !341)
