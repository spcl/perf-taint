; RUN: opt %dfsan -S < %s 2> /dev/null | llc %llcparams - -o %t1 && clang++ %t1 -o %t2 %link && %execparams %t2 50 30 40 | diff -w %s.json -
; ModuleID = 'tests/dfsan-instr/matmul.c'
source_filename = "tests/dfsan-instr/matmul.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }
%struct._matrix = type { i64, i64, double* }

@.str = private unnamed_addr constant [7 x i8] c"extrap\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [27 x i8] c"tests/dfsan-instr/matmul.c\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [10 x i8] c"argc == 4\00", align 1
@.str.3 = private unnamed_addr constant [27 x i8] c"tests/dfsan-instr/matmul.c\00", align 1
@__PRETTY_FUNCTION__.main = private unnamed_addr constant [23 x i8] c"int main(int, char **)\00", align 1
@.str.4 = private unnamed_addr constant [2 x i8] c"m\00", align 1
@.str.5 = private unnamed_addr constant [2 x i8] c"n\00", align 1
@.str.6 = private unnamed_addr constant [2 x i8] c"k\00", align 1
@stderr = external dso_local global %struct._IO_FILE*, align 8
@.str.7 = private unnamed_addr constant [4 x i8] c"%f\0A\00", align 1

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
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %8) #5, !dbg !46
  call void @llvm.dbg.declare(metadata i32* %7, metadata !34, metadata !DIExpression()), !dbg !47
  %9 = call i32 (...) @__dfsw_EXTRAP_VAR_ID(), !dbg !48
  store i32 %9, i32* %7, align 4, !dbg !47, !tbaa !49
  %10 = load i8*, i8** %4, align 8, !dbg !51, !tbaa !37
  %11 = load i64, i64* %5, align 8, !dbg !52, !tbaa !42
  %12 = trunc i64 %11 to i32, !dbg !52
  %13 = load i32, i32* %7, align 4, !dbg !53, !tbaa !49
  %14 = add nsw i32 %13, 1, !dbg !53
  store i32 %14, i32* %7, align 4, !dbg !53, !tbaa !49
  %15 = load i8*, i8** %6, align 8, !dbg !54, !tbaa !37
  call void @__dfsw_EXTRAP_STORE_LABEL(i8* %10, i32 %12, i32 %13, i8* %15), !dbg !55
  %16 = bitcast i32* %7 to i8*, !dbg !56
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %16) #5, !dbg !56
  ret void, !dbg !56
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #2

declare dso_local i32 @__dfsw_EXTRAP_VAR_ID(...) #3

declare dso_local void @__dfsw_EXTRAP_STORE_LABEL(i8*, i32, i32, i8*) #3

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: nounwind uwtable
define dso_local void @create_matrix(%struct._matrix* noalias sret, i32, i32, i1 zeroext) #0 !dbg !57 {
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i8, align 1
  %8 = alloca i64, align 8
  %9 = alloca i64, align 8
  store i32 %1, i32* %5, align 4, !tbaa !49
  call void @llvm.dbg.declare(metadata i32* %5, metadata !68, metadata !DIExpression()), !dbg !77
  store i32 %2, i32* %6, align 4, !tbaa !49
  call void @llvm.dbg.declare(metadata i32* %6, metadata !69, metadata !DIExpression()), !dbg !78
  %10 = zext i1 %3 to i8
  store i8 %10, i8* %7, align 1, !tbaa !79
  call void @llvm.dbg.declare(metadata i8* %7, metadata !70, metadata !DIExpression()), !dbg !81
  call void @llvm.dbg.declare(metadata %struct._matrix* %0, metadata !71, metadata !DIExpression()), !dbg !82
  %11 = load i32, i32* %5, align 4, !dbg !83, !tbaa !49
  %12 = sext i32 %11 to i64, !dbg !83
  %13 = getelementptr inbounds %struct._matrix, %struct._matrix* %0, i32 0, i32 0, !dbg !84
  store i64 %12, i64* %13, align 8, !dbg !85, !tbaa !86
  %14 = load i32, i32* %6, align 4, !dbg !88, !tbaa !49
  %15 = sext i32 %14 to i64, !dbg !88
  %16 = getelementptr inbounds %struct._matrix, %struct._matrix* %0, i32 0, i32 1, !dbg !89
  store i64 %15, i64* %16, align 8, !dbg !90, !tbaa !91
  %17 = load i32, i32* %5, align 4, !dbg !92, !tbaa !49
  %18 = load i32, i32* %6, align 4, !dbg !93, !tbaa !49
  %19 = mul nsw i32 %17, %18, !dbg !94
  %20 = sext i32 %19 to i64, !dbg !92
  %21 = call noalias i8* @calloc(i64 %20, i64 8) #5, !dbg !95
  %22 = bitcast i8* %21 to double*, !dbg !96
  %23 = getelementptr inbounds %struct._matrix, %struct._matrix* %0, i32 0, i32 2, !dbg !97
  store double* %22, double** %23, align 8, !dbg !98, !tbaa !99
  %24 = load i8, i8* %7, align 1, !dbg !100, !tbaa !79, !range !101
  %25 = trunc i8 %24 to i1, !dbg !100
  br i1 %25, label %26, label %52, !dbg !102

26:                                               ; preds = %4
  %27 = bitcast i64* %8 to i8*, !dbg !103
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %27) #5, !dbg !103
  call void @llvm.dbg.declare(metadata i64* %8, metadata !72, metadata !DIExpression()), !dbg !104
  %28 = load i32, i32* %5, align 4, !dbg !105, !tbaa !49
  %29 = load i32, i32* %6, align 4, !dbg !106, !tbaa !49
  %30 = mul nsw i32 %28, %29, !dbg !107
  %31 = sext i32 %30 to i64, !dbg !105
  store i64 %31, i64* %8, align 8, !dbg !104, !tbaa !42
  %32 = bitcast i64* %9 to i8*, !dbg !108
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %32) #5, !dbg !108
  call void @llvm.dbg.declare(metadata i64* %9, metadata !75, metadata !DIExpression()), !dbg !109
  store i64 0, i64* %9, align 8, !dbg !109, !tbaa !42
  br label %33, !dbg !108

33:                                               ; preds = %47, %26
  %34 = load i64, i64* %9, align 8, !dbg !110, !tbaa !42
  %35 = load i64, i64* %8, align 8, !dbg !112, !tbaa !42
  %36 = icmp ult i64 %34, %35, !dbg !113
  br i1 %36, label %39, label %37, !dbg !114

37:                                               ; preds = %33
  %38 = bitcast i64* %9 to i8*, !dbg !115
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %38) #5, !dbg !115
  br label %50

39:                                               ; preds = %33
  %40 = call i32 @rand() #5, !dbg !116
  %41 = srem i32 %40, 100, !dbg !117
  %42 = sitofp i32 %41 to double, !dbg !116
  %43 = getelementptr inbounds %struct._matrix, %struct._matrix* %0, i32 0, i32 2, !dbg !118
  %44 = load double*, double** %43, align 8, !dbg !118, !tbaa !99
  %45 = load i64, i64* %9, align 8, !dbg !119, !tbaa !42
  %46 = getelementptr inbounds double, double* %44, i64 %45, !dbg !120
  store double %42, double* %46, align 8, !dbg !121, !tbaa !122
  br label %47, !dbg !120

47:                                               ; preds = %39
  %48 = load i64, i64* %9, align 8, !dbg !124, !tbaa !42
  %49 = add i64 %48, 1, !dbg !124
  store i64 %49, i64* %9, align 8, !dbg !124, !tbaa !42
  br label %33, !dbg !115, !llvm.loop !125

50:                                               ; preds = %37
  %51 = bitcast i64* %8 to i8*, !dbg !127
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %51) #5, !dbg !127
  br label %52, !dbg !128

52:                                               ; preds = %50, %4
  ret void, !dbg !129
}

; Function Attrs: nounwind
declare dso_local noalias i8* @calloc(i64, i64) #4

; Function Attrs: nounwind
declare dso_local i32 @rand() #4

; Function Attrs: nounwind uwtable
define dso_local void @mat_mul(%struct._matrix* noalias sret, %struct._matrix*, %struct._matrix*) #0 !dbg !130 {
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
  call void @llvm.dbg.declare(metadata %struct._matrix** %4, metadata !135, metadata !DIExpression()), !dbg !152
  store %struct._matrix* %2, %struct._matrix** %5, align 8, !tbaa !37
  call void @llvm.dbg.declare(metadata %struct._matrix** %5, metadata !136, metadata !DIExpression()), !dbg !153
  %14 = bitcast i64* %6 to i8*, !dbg !154
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %14) #5, !dbg !154
  call void @llvm.dbg.declare(metadata i64* %6, metadata !137, metadata !DIExpression()), !dbg !155
  %15 = load %struct._matrix*, %struct._matrix** %4, align 8, !dbg !156, !tbaa !37
  %16 = getelementptr inbounds %struct._matrix, %struct._matrix* %15, i32 0, i32 0, !dbg !157
  %17 = load i64, i64* %16, align 8, !dbg !157, !tbaa !86
  store i64 %17, i64* %6, align 8, !dbg !155, !tbaa !42
  %18 = bitcast i64* %7 to i8*, !dbg !154
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %18) #5, !dbg !154
  call void @llvm.dbg.declare(metadata i64* %7, metadata !138, metadata !DIExpression()), !dbg !158
  %19 = load %struct._matrix*, %struct._matrix** %4, align 8, !dbg !159, !tbaa !37
  %20 = getelementptr inbounds %struct._matrix, %struct._matrix* %19, i32 0, i32 1, !dbg !160
  %21 = load i64, i64* %20, align 8, !dbg !160, !tbaa !91
  store i64 %21, i64* %7, align 8, !dbg !158, !tbaa !42
  %22 = bitcast i64* %8 to i8*, !dbg !154
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %22) #5, !dbg !154
  call void @llvm.dbg.declare(metadata i64* %8, metadata !139, metadata !DIExpression()), !dbg !161
  %23 = load %struct._matrix*, %struct._matrix** %5, align 8, !dbg !162, !tbaa !37
  %24 = getelementptr inbounds %struct._matrix, %struct._matrix* %23, i32 0, i32 1, !dbg !163
  %25 = load i64, i64* %24, align 8, !dbg !163, !tbaa !91
  store i64 %25, i64* %8, align 8, !dbg !161, !tbaa !42
  call void @llvm.dbg.declare(metadata %struct._matrix* %0, metadata !140, metadata !DIExpression()), !dbg !164
  %26 = load i64, i64* %6, align 8, !dbg !165, !tbaa !42
  %27 = trunc i64 %26 to i32, !dbg !165
  %28 = load i64, i64* %8, align 8, !dbg !166, !tbaa !42
  %29 = trunc i64 %28 to i32, !dbg !166
  call void @create_matrix(%struct._matrix* sret %0, i32 %27, i32 %29, i1 zeroext false), !dbg !167
  %30 = bitcast i64* %9 to i8*, !dbg !168
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %30) #5, !dbg !168
  call void @llvm.dbg.declare(metadata i64* %9, metadata !141, metadata !DIExpression()), !dbg !169
  store i64 0, i64* %9, align 8, !dbg !169, !tbaa !42
  br label %31, !dbg !168

31:                                               ; preds = %96, %3
  %32 = load i64, i64* %9, align 8, !dbg !170, !tbaa !42
  %33 = load i64, i64* %6, align 8, !dbg !171, !tbaa !42
  %34 = icmp ult i64 %32, %33, !dbg !172
  br i1 %34, label %37, label %35, !dbg !173

35:                                               ; preds = %31
  store i32 2, i32* %10, align 4
  %36 = bitcast i64* %9 to i8*, !dbg !174
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %36) #5, !dbg !174
  br label %99

37:                                               ; preds = %31
  %38 = bitcast i64* %11 to i8*, !dbg !175
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %38) #5, !dbg !175
  call void @llvm.dbg.declare(metadata i64* %11, metadata !143, metadata !DIExpression()), !dbg !176
  store i64 0, i64* %11, align 8, !dbg !176, !tbaa !42
  br label %39, !dbg !175

39:                                               ; preds = %92, %37
  %40 = load i64, i64* %11, align 8, !dbg !177, !tbaa !42
  %41 = load i64, i64* %8, align 8, !dbg !178, !tbaa !42
  %42 = icmp ult i64 %40, %41, !dbg !179
  br i1 %42, label %45, label %43, !dbg !180

43:                                               ; preds = %39
  store i32 5, i32* %10, align 4
  %44 = bitcast i64* %11 to i8*, !dbg !181
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %44) #5, !dbg !181
  br label %95

45:                                               ; preds = %39
  %46 = bitcast double* %12 to i8*, !dbg !182
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %46) #5, !dbg !182
  call void @llvm.dbg.declare(metadata double* %12, metadata !147, metadata !DIExpression()), !dbg !183
  store double 0.000000e+00, double* %12, align 8, !dbg !183, !tbaa !122
  %47 = bitcast i64* %13 to i8*, !dbg !184
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %47) #5, !dbg !184
  call void @llvm.dbg.declare(metadata i64* %13, metadata !150, metadata !DIExpression()), !dbg !185
  store i64 0, i64* %13, align 8, !dbg !185, !tbaa !42
  br label %48, !dbg !184

48:                                               ; preds = %78, %45
  %49 = load i64, i64* %13, align 8, !dbg !186, !tbaa !42
  %50 = load i64, i64* %7, align 8, !dbg !188, !tbaa !42
  %51 = icmp ult i64 %49, %50, !dbg !189
  br i1 %51, label %54, label %52, !dbg !190

52:                                               ; preds = %48
  store i32 8, i32* %10, align 4
  %53 = bitcast i64* %13 to i8*, !dbg !191
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %53) #5, !dbg !191
  br label %81

54:                                               ; preds = %48
  %55 = load %struct._matrix*, %struct._matrix** %4, align 8, !dbg !192, !tbaa !37
  %56 = getelementptr inbounds %struct._matrix, %struct._matrix* %55, i32 0, i32 2, !dbg !194
  %57 = load double*, double** %56, align 8, !dbg !194, !tbaa !99
  %58 = load i64, i64* %9, align 8, !dbg !195, !tbaa !42
  %59 = load i64, i64* %7, align 8, !dbg !196, !tbaa !42
  %60 = mul i64 %58, %59, !dbg !197
  %61 = load i64, i64* %13, align 8, !dbg !198, !tbaa !42
  %62 = add i64 %60, %61, !dbg !199
  %63 = getelementptr inbounds double, double* %57, i64 %62, !dbg !192
  %64 = load double, double* %63, align 8, !dbg !192, !tbaa !122
  %65 = load %struct._matrix*, %struct._matrix** %5, align 8, !dbg !200, !tbaa !37
  %66 = getelementptr inbounds %struct._matrix, %struct._matrix* %65, i32 0, i32 2, !dbg !201
  %67 = load double*, double** %66, align 8, !dbg !201, !tbaa !99
  %68 = load i64, i64* %13, align 8, !dbg !202, !tbaa !42
  %69 = load i64, i64* %8, align 8, !dbg !203, !tbaa !42
  %70 = mul i64 %68, %69, !dbg !204
  %71 = load i64, i64* %11, align 8, !dbg !205, !tbaa !42
  %72 = add i64 %70, %71, !dbg !206
  %73 = getelementptr inbounds double, double* %67, i64 %72, !dbg !200
  %74 = load double, double* %73, align 8, !dbg !200, !tbaa !122
  %75 = fmul double %64, %74, !dbg !207
  %76 = load double, double* %12, align 8, !dbg !208, !tbaa !122
  %77 = fadd double %76, %75, !dbg !208
  store double %77, double* %12, align 8, !dbg !208, !tbaa !122
  br label %78, !dbg !209

78:                                               ; preds = %54
  %79 = load i64, i64* %13, align 8, !dbg !210, !tbaa !42
  %80 = add i64 %79, 1, !dbg !210
  store i64 %80, i64* %13, align 8, !dbg !210, !tbaa !42
  br label %48, !dbg !191, !llvm.loop !211

81:                                               ; preds = %52
  %82 = load double, double* %12, align 8, !dbg !213, !tbaa !122
  %83 = getelementptr inbounds %struct._matrix, %struct._matrix* %0, i32 0, i32 2, !dbg !214
  %84 = load double*, double** %83, align 8, !dbg !214, !tbaa !99
  %85 = load i64, i64* %9, align 8, !dbg !215, !tbaa !42
  %86 = load i64, i64* %8, align 8, !dbg !216, !tbaa !42
  %87 = mul i64 %85, %86, !dbg !217
  %88 = load i64, i64* %11, align 8, !dbg !218, !tbaa !42
  %89 = add i64 %87, %88, !dbg !219
  %90 = getelementptr inbounds double, double* %84, i64 %89, !dbg !220
  store double %82, double* %90, align 8, !dbg !221, !tbaa !122
  %91 = bitcast double* %12 to i8*, !dbg !222
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %91) #5, !dbg !222
  br label %92, !dbg !223

92:                                               ; preds = %81
  %93 = load i64, i64* %11, align 8, !dbg !224, !tbaa !42
  %94 = add i64 %93, 1, !dbg !224
  store i64 %94, i64* %11, align 8, !dbg !224, !tbaa !42
  br label %39, !dbg !181, !llvm.loop !225

95:                                               ; preds = %43
  br label %96, !dbg !227

96:                                               ; preds = %95
  %97 = load i64, i64* %9, align 8, !dbg !228, !tbaa !42
  %98 = add i64 %97, 1, !dbg !228
  store i64 %98, i64* %9, align 8, !dbg !228, !tbaa !42
  br label %31, !dbg !174, !llvm.loop !229

99:                                               ; preds = %35
  store i32 1, i32* %10, align 4
  %100 = bitcast i64* %8 to i8*, !dbg !231
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %100) #5, !dbg !231
  %101 = bitcast i64* %7 to i8*, !dbg !231
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %101) #5, !dbg !231
  %102 = bitcast i64* %6 to i8*, !dbg !231
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %102) #5, !dbg !231
  ret void, !dbg !231
}

; Function Attrs: nounwind uwtable
define dso_local i32 @main(i32, i8**) #0 !dbg !232 {
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
  call void @llvm.dbg.declare(metadata i32* %4, metadata !236, metadata !DIExpression()), !dbg !244
  store i8** %1, i8*** %5, align 8, !tbaa !37
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !237, metadata !DIExpression()), !dbg !245
  %12 = bitcast i32* %6 to i8*, !dbg !246
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %12) #5, !dbg !246
  call void @llvm.dbg.declare(metadata i32* %6, metadata !238, metadata !DIExpression()), !dbg !247
  %13 = bitcast i32* %6 to i8*, !dbg !246
  call void @llvm.var.annotation(i8* %13, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([27 x i8], [27 x i8]* @.str.1, i32 0, i32 0), i32 51), !dbg !246
  %14 = bitcast i32* %7 to i8*, !dbg !246
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %14) #5, !dbg !246
  call void @llvm.dbg.declare(metadata i32* %7, metadata !239, metadata !DIExpression()), !dbg !248
  %15 = bitcast i32* %7 to i8*, !dbg !246
  call void @llvm.var.annotation(i8* %15, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([27 x i8], [27 x i8]* @.str.1, i32 0, i32 0), i32 51), !dbg !246
  %16 = bitcast i32* %8 to i8*, !dbg !246
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %16) #5, !dbg !246
  call void @llvm.dbg.declare(metadata i32* %8, metadata !240, metadata !DIExpression()), !dbg !249
  %17 = bitcast i32* %8 to i8*, !dbg !246
  call void @llvm.var.annotation(i8* %17, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([27 x i8], [27 x i8]* @.str.1, i32 0, i32 0), i32 51), !dbg !246
  %18 = load i32, i32* %4, align 4, !dbg !250, !tbaa !49
  %19 = icmp eq i32 %18, 4, !dbg !250
  br i1 %19, label %20, label %21, !dbg !253

20:                                               ; preds = %2
  br label %22, !dbg !253

21:                                               ; preds = %2
  call void @__assert_fail(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.2, i64 0, i64 0), i8* getelementptr inbounds ([27 x i8], [27 x i8]* @.str.3, i64 0, i64 0), i32 52, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.main, i64 0, i64 0)) #8, !dbg !250
  unreachable, !dbg !250

22:                                               ; preds = %20
  %23 = load i8**, i8*** %5, align 8, !dbg !254, !tbaa !37
  %24 = getelementptr inbounds i8*, i8** %23, i64 1, !dbg !254
  %25 = load i8*, i8** %24, align 8, !dbg !254, !tbaa !37
  %26 = call i32 @atoi(i8* %25) #9, !dbg !255
  store i32 %26, i32* %6, align 4, !dbg !256, !tbaa !49
  %27 = load i8**, i8*** %5, align 8, !dbg !257, !tbaa !37
  %28 = getelementptr inbounds i8*, i8** %27, i64 2, !dbg !257
  %29 = load i8*, i8** %28, align 8, !dbg !257, !tbaa !37
  %30 = call i32 @atoi(i8* %29) #9, !dbg !258
  store i32 %30, i32* %7, align 4, !dbg !259, !tbaa !49
  %31 = load i8**, i8*** %5, align 8, !dbg !260, !tbaa !37
  %32 = getelementptr inbounds i8*, i8** %31, i64 3, !dbg !260
  %33 = load i8*, i8** %32, align 8, !dbg !260, !tbaa !37
  %34 = call i32 @atoi(i8* %33) #9, !dbg !261
  store i32 %34, i32* %8, align 4, !dbg !262, !tbaa !49
  %35 = call i64 @time(i64* null) #5, !dbg !263
  %36 = trunc i64 %35 to i32, !dbg !263
  call void @srand(i32 %36) #5, !dbg !264
  %37 = bitcast i32* %6 to i8*, !dbg !265
  call void @register_variable(i8* %37, i64 4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i64 0, i64 0)), !dbg !266
  %38 = bitcast i32* %7 to i8*, !dbg !267
  call void @register_variable(i8* %38, i64 4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i64 0, i64 0)), !dbg !268
  %39 = bitcast i32* %8 to i8*, !dbg !269
  call void @register_variable(i8* %39, i64 4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i64 0, i64 0)), !dbg !270
  %40 = bitcast %struct._matrix* %9 to i8*, !dbg !271
  call void @llvm.lifetime.start.p0i8(i64 24, i8* %40) #5, !dbg !271
  call void @llvm.dbg.declare(metadata %struct._matrix* %9, metadata !241, metadata !DIExpression()), !dbg !272
  %41 = load i32, i32* %6, align 4, !dbg !273, !tbaa !49
  %42 = load i32, i32* %7, align 4, !dbg !274, !tbaa !49
  call void @create_matrix(%struct._matrix* sret %9, i32 %41, i32 %42, i1 zeroext true), !dbg !275
  %43 = bitcast %struct._matrix* %10 to i8*, !dbg !276
  call void @llvm.lifetime.start.p0i8(i64 24, i8* %43) #5, !dbg !276
  call void @llvm.dbg.declare(metadata %struct._matrix* %10, metadata !242, metadata !DIExpression()), !dbg !277
  %44 = load i32, i32* %7, align 4, !dbg !278, !tbaa !49
  %45 = load i32, i32* %8, align 4, !dbg !279, !tbaa !49
  call void @create_matrix(%struct._matrix* sret %10, i32 %44, i32 %45, i1 zeroext true), !dbg !280
  %46 = bitcast %struct._matrix* %11 to i8*, !dbg !281
  call void @llvm.lifetime.start.p0i8(i64 24, i8* %46) #5, !dbg !281
  call void @llvm.dbg.declare(metadata %struct._matrix* %11, metadata !243, metadata !DIExpression()), !dbg !282
  call void @mat_mul(%struct._matrix* sret %11, %struct._matrix* %9, %struct._matrix* %10), !dbg !283
  %47 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !284, !tbaa !37
  %48 = getelementptr inbounds %struct._matrix, %struct._matrix* %11, i32 0, i32 2, !dbg !285
  %49 = load double*, double** %48, align 8, !dbg !285, !tbaa !99
  %50 = getelementptr inbounds double, double* %49, i64 0, !dbg !286
  %51 = load double, double* %50, align 8, !dbg !286, !tbaa !122
  %52 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %47, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.7, i64 0, i64 0), double %51), !dbg !287
  %53 = getelementptr inbounds %struct._matrix, %struct._matrix* %9, i32 0, i32 2, !dbg !288
  %54 = load double*, double** %53, align 8, !dbg !288, !tbaa !99
  %55 = bitcast double* %54 to i8*, !dbg !289
  call void @free(i8* %55) #5, !dbg !290
  %56 = getelementptr inbounds %struct._matrix, %struct._matrix* %10, i32 0, i32 2, !dbg !291
  %57 = load double*, double** %56, align 8, !dbg !291, !tbaa !99
  %58 = bitcast double* %57 to i8*, !dbg !292
  call void @free(i8* %58) #5, !dbg !293
  %59 = getelementptr inbounds %struct._matrix, %struct._matrix* %11, i32 0, i32 2, !dbg !294
  %60 = load double*, double** %59, align 8, !dbg !294, !tbaa !99
  %61 = bitcast double* %60 to i8*, !dbg !295
  call void @free(i8* %61) #5, !dbg !296
  %62 = bitcast %struct._matrix* %11 to i8*, !dbg !297
  call void @llvm.lifetime.end.p0i8(i64 24, i8* %62) #5, !dbg !297
  %63 = bitcast %struct._matrix* %10 to i8*, !dbg !297
  call void @llvm.lifetime.end.p0i8(i64 24, i8* %63) #5, !dbg !297
  %64 = bitcast %struct._matrix* %9 to i8*, !dbg !297
  call void @llvm.lifetime.end.p0i8(i64 24, i8* %64) #5, !dbg !297
  %65 = bitcast i32* %8 to i8*, !dbg !297
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %65) #5, !dbg !297
  %66 = bitcast i32* %7 to i8*, !dbg !297
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %66) #5, !dbg !297
  %67 = bitcast i32* %6 to i8*, !dbg !297
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %67) #5, !dbg !297
  ret i32 0, !dbg !298
}

; Function Attrs: nounwind
declare void @llvm.var.annotation(i8*, i8*, i8*, i32) #5

; Function Attrs: noreturn nounwind
declare dso_local void @__assert_fail(i8*, i8*, i32, i8*) #6

; Function Attrs: inlinehint nounwind readonly uwtable
define available_externally dso_local i32 @atoi(i8* nonnull) #7 !dbg !299 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8, !tbaa !37
  call void @llvm.dbg.declare(metadata i8** %2, metadata !304, metadata !DIExpression()), !dbg !305
  %3 = load i8*, i8** %2, align 8, !dbg !306, !tbaa !37
  %4 = call i64 @strtol(i8* %3, i8** null, i32 10) #5, !dbg !307
  %5 = trunc i64 %4 to i32, !dbg !308
  ret i32 %5, !dbg !309
}

; Function Attrs: nounwind
declare dso_local void @srand(i32) #4

; Function Attrs: nounwind
declare dso_local i64 @time(i64*) #4

declare dso_local i32 @fprintf(%struct._IO_FILE*, i8*, ...) #3

; Function Attrs: nounwind
declare dso_local void @free(i8*) #4

; Function Attrs: nounwind
declare dso_local i64 @strtol(i8*, i8**, i32) #4

attributes #0 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { argmemonly nounwind }
attributes #3 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { nounwind }
attributes #6 = { noreturn nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #7 = { inlinehint nounwind readonly uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #8 = { noreturn nounwind }
attributes #9 = { nounwind readonly }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!17, !18, !19}
!llvm.ident = !{!20}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !3, nameTableKind: None)
!1 = !DIFile(filename: "tests/dfsan-instr/matmul.c", directory: "/home/mcopik/projects/ETH/extrap/rebuild/extrap-tool")
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
!21 = distinct !DISubprogram(name: "register_variable", scope: !22, file: !22, line: 12, type: !23, scopeLine: 13, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !30)
!22 = !DIFile(filename: "include/ExtraPInstrumenter.h", directory: "/home/mcopik/projects/ETH/extrap/rebuild/extrap-tool")
!23 = !DISubroutineType(types: !24)
!24 = !{null, !16, !25, !28}
!25 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !26, line: 46, baseType: !27)
!26 = !DIFile(filename: "clang_llvm/llvm-9.0/build-9.0/lib/clang/9.0.0/include/stddef.h", directory: "/home/mcopik/projects")
!27 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!28 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !29, size: 64)
!29 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !15)
!30 = !{!31, !32, !33, !34}
!31 = !DILocalVariable(name: "ptr", arg: 1, scope: !21, file: !22, line: 12, type: !16)
!32 = !DILocalVariable(name: "size", arg: 2, scope: !21, file: !22, line: 12, type: !25)
!33 = !DILocalVariable(name: "name", arg: 3, scope: !21, file: !22, line: 12, type: !28)
!34 = !DILocalVariable(name: "param_id", scope: !21, file: !22, line: 14, type: !35)
!35 = !DIDerivedType(tag: DW_TAG_typedef, name: "int32_t", file: !6, line: 26, baseType: !36)
!36 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int32_t", file: !8, line: 40, baseType: !12)
!37 = !{!38, !38, i64 0}
!38 = !{!"any pointer", !39, i64 0}
!39 = !{!"omnipotent char", !40, i64 0}
!40 = !{!"Simple C/C++ TBAA"}
!41 = !DILocation(line: 12, column: 31, scope: !21)
!42 = !{!43, !43, i64 0}
!43 = !{!"long", !39, i64 0}
!44 = !DILocation(line: 12, column: 43, scope: !21)
!45 = !DILocation(line: 12, column: 62, scope: !21)
!46 = !DILocation(line: 14, column: 5, scope: !21)
!47 = !DILocation(line: 14, column: 13, scope: !21)
!48 = !DILocation(line: 14, column: 24, scope: !21)
!49 = !{!50, !50, i64 0}
!50 = !{!"int", !39, i64 0}
!51 = !DILocation(line: 15, column: 41, scope: !21)
!52 = !DILocation(line: 15, column: 46, scope: !21)
!53 = !DILocation(line: 15, column: 60, scope: !21)
!54 = !DILocation(line: 15, column: 64, scope: !21)
!55 = !DILocation(line: 15, column: 5, scope: !21)
!56 = !DILocation(line: 16, column: 1, scope: !21)
!57 = distinct !DISubprogram(name: "create_matrix", scope: !1, file: !1, line: 17, type: !58, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !67)
!58 = !DISubroutineType(types: !59)
!59 = !{!60, !12, !12, !66}
!60 = !DIDerivedType(tag: DW_TAG_typedef, name: "matrix", file: !1, line: 15, baseType: !61)
!61 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_matrix", file: !1, line: 10, size: 192, elements: !62)
!62 = !{!63, !64, !65}
!63 = !DIDerivedType(tag: DW_TAG_member, name: "rows", scope: !61, file: !1, line: 12, baseType: !25, size: 64)
!64 = !DIDerivedType(tag: DW_TAG_member, name: "cols", scope: !61, file: !1, line: 13, baseType: !25, size: 64, offset: 64)
!65 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !61, file: !1, line: 14, baseType: !10, size: 64, offset: 128)
!66 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!67 = !{!68, !69, !70, !71, !72, !75}
!68 = !DILocalVariable(name: "rows", arg: 1, scope: !57, file: !1, line: 17, type: !12)
!69 = !DILocalVariable(name: "cols", arg: 2, scope: !57, file: !1, line: 17, type: !12)
!70 = !DILocalVariable(name: "init", arg: 3, scope: !57, file: !1, line: 17, type: !66)
!71 = !DILocalVariable(name: "m", scope: !57, file: !1, line: 19, type: !60)
!72 = !DILocalVariable(name: "size", scope: !73, file: !1, line: 24, type: !25)
!73 = distinct !DILexicalBlock(scope: !74, file: !1, line: 23, column: 14)
!74 = distinct !DILexicalBlock(scope: !57, file: !1, line: 23, column: 8)
!75 = !DILocalVariable(name: "i", scope: !76, file: !1, line: 25, type: !25)
!76 = distinct !DILexicalBlock(scope: !73, file: !1, line: 25, column: 9)
!77 = !DILocation(line: 17, column: 26, scope: !57)
!78 = !DILocation(line: 17, column: 36, scope: !57)
!79 = !{!80, !80, i64 0}
!80 = !{!"_Bool", !39, i64 0}
!81 = !DILocation(line: 17, column: 47, scope: !57)
!82 = !DILocation(line: 19, column: 12, scope: !57)
!83 = !DILocation(line: 20, column: 14, scope: !57)
!84 = !DILocation(line: 20, column: 7, scope: !57)
!85 = !DILocation(line: 20, column: 12, scope: !57)
!86 = !{!87, !43, i64 0}
!87 = !{!"_matrix", !43, i64 0, !43, i64 8, !38, i64 16}
!88 = !DILocation(line: 21, column: 14, scope: !57)
!89 = !DILocation(line: 21, column: 7, scope: !57)
!90 = !DILocation(line: 21, column: 12, scope: !57)
!91 = !{!87, !43, i64 8}
!92 = !DILocation(line: 22, column: 31, scope: !57)
!93 = !DILocation(line: 22, column: 38, scope: !57)
!94 = !DILocation(line: 22, column: 36, scope: !57)
!95 = !DILocation(line: 22, column: 24, scope: !57)
!96 = !DILocation(line: 22, column: 14, scope: !57)
!97 = !DILocation(line: 22, column: 7, scope: !57)
!98 = !DILocation(line: 22, column: 12, scope: !57)
!99 = !{!87, !38, i64 16}
!100 = !DILocation(line: 23, column: 8, scope: !74)
!101 = !{i8 0, i8 2}
!102 = !DILocation(line: 23, column: 8, scope: !57)
!103 = !DILocation(line: 24, column: 9, scope: !73)
!104 = !DILocation(line: 24, column: 16, scope: !73)
!105 = !DILocation(line: 24, column: 23, scope: !73)
!106 = !DILocation(line: 24, column: 30, scope: !73)
!107 = !DILocation(line: 24, column: 28, scope: !73)
!108 = !DILocation(line: 25, column: 13, scope: !76)
!109 = !DILocation(line: 25, column: 20, scope: !76)
!110 = !DILocation(line: 25, column: 27, scope: !111)
!111 = distinct !DILexicalBlock(scope: !76, file: !1, line: 25, column: 9)
!112 = !DILocation(line: 25, column: 31, scope: !111)
!113 = !DILocation(line: 25, column: 29, scope: !111)
!114 = !DILocation(line: 25, column: 9, scope: !76)
!115 = !DILocation(line: 25, column: 9, scope: !111)
!116 = !DILocation(line: 26, column: 25, scope: !111)
!117 = !DILocation(line: 26, column: 32, scope: !111)
!118 = !DILocation(line: 26, column: 15, scope: !111)
!119 = !DILocation(line: 26, column: 20, scope: !111)
!120 = !DILocation(line: 26, column: 13, scope: !111)
!121 = !DILocation(line: 26, column: 23, scope: !111)
!122 = !{!123, !123, i64 0}
!123 = !{!"double", !39, i64 0}
!124 = !DILocation(line: 25, column: 37, scope: !111)
!125 = distinct !{!125, !114, !126}
!126 = !DILocation(line: 26, column: 34, scope: !76)
!127 = !DILocation(line: 27, column: 5, scope: !74)
!128 = !DILocation(line: 27, column: 5, scope: !73)
!129 = !DILocation(line: 28, column: 5, scope: !57)
!130 = distinct !DISubprogram(name: "mat_mul", scope: !1, file: !1, line: 31, type: !131, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !134)
!131 = !DISubroutineType(types: !132)
!132 = !{!60, !133, !133}
!133 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !60, size: 64)
!134 = !{!135, !136, !137, !138, !139, !140, !141, !143, !147, !150}
!135 = !DILocalVariable(name: "left", arg: 1, scope: !130, file: !1, line: 31, type: !133)
!136 = !DILocalVariable(name: "right", arg: 2, scope: !130, file: !1, line: 31, type: !133)
!137 = !DILocalVariable(name: "m", scope: !130, file: !1, line: 33, type: !25)
!138 = !DILocalVariable(name: "n", scope: !130, file: !1, line: 33, type: !25)
!139 = !DILocalVariable(name: "k", scope: !130, file: !1, line: 33, type: !25)
!140 = !DILocalVariable(name: "res", scope: !130, file: !1, line: 34, type: !60)
!141 = !DILocalVariable(name: "i", scope: !142, file: !1, line: 36, type: !25)
!142 = distinct !DILexicalBlock(scope: !130, file: !1, line: 36, column: 5)
!143 = !DILocalVariable(name: "j", scope: !144, file: !1, line: 37, type: !25)
!144 = distinct !DILexicalBlock(scope: !145, file: !1, line: 37, column: 9)
!145 = distinct !DILexicalBlock(scope: !146, file: !1, line: 36, column: 35)
!146 = distinct !DILexicalBlock(scope: !142, file: !1, line: 36, column: 5)
!147 = !DILocalVariable(name: "scalar_product", scope: !148, file: !1, line: 38, type: !11)
!148 = distinct !DILexicalBlock(scope: !149, file: !1, line: 37, column: 39)
!149 = distinct !DILexicalBlock(scope: !144, file: !1, line: 37, column: 9)
!150 = !DILocalVariable(name: "kk", scope: !151, file: !1, line: 39, type: !25)
!151 = distinct !DILexicalBlock(scope: !148, file: !1, line: 39, column: 13)
!152 = !DILocation(line: 31, column: 25, scope: !130)
!153 = !DILocation(line: 31, column: 40, scope: !130)
!154 = !DILocation(line: 33, column: 5, scope: !130)
!155 = !DILocation(line: 33, column: 12, scope: !130)
!156 = !DILocation(line: 33, column: 16, scope: !130)
!157 = !DILocation(line: 33, column: 22, scope: !130)
!158 = !DILocation(line: 33, column: 28, scope: !130)
!159 = !DILocation(line: 33, column: 32, scope: !130)
!160 = !DILocation(line: 33, column: 38, scope: !130)
!161 = !DILocation(line: 33, column: 44, scope: !130)
!162 = !DILocation(line: 33, column: 48, scope: !130)
!163 = !DILocation(line: 33, column: 55, scope: !130)
!164 = !DILocation(line: 34, column: 12, scope: !130)
!165 = !DILocation(line: 34, column: 32, scope: !130)
!166 = !DILocation(line: 34, column: 35, scope: !130)
!167 = !DILocation(line: 34, column: 18, scope: !130)
!168 = !DILocation(line: 36, column: 9, scope: !142)
!169 = !DILocation(line: 36, column: 16, scope: !142)
!170 = !DILocation(line: 36, column: 23, scope: !146)
!171 = !DILocation(line: 36, column: 27, scope: !146)
!172 = !DILocation(line: 36, column: 25, scope: !146)
!173 = !DILocation(line: 36, column: 5, scope: !142)
!174 = !DILocation(line: 36, column: 5, scope: !146)
!175 = !DILocation(line: 37, column: 13, scope: !144)
!176 = !DILocation(line: 37, column: 20, scope: !144)
!177 = !DILocation(line: 37, column: 27, scope: !149)
!178 = !DILocation(line: 37, column: 31, scope: !149)
!179 = !DILocation(line: 37, column: 29, scope: !149)
!180 = !DILocation(line: 37, column: 9, scope: !144)
!181 = !DILocation(line: 37, column: 9, scope: !149)
!182 = !DILocation(line: 38, column: 13, scope: !148)
!183 = !DILocation(line: 38, column: 20, scope: !148)
!184 = !DILocation(line: 39, column: 17, scope: !151)
!185 = !DILocation(line: 39, column: 24, scope: !151)
!186 = !DILocation(line: 39, column: 32, scope: !187)
!187 = distinct !DILexicalBlock(scope: !151, file: !1, line: 39, column: 13)
!188 = !DILocation(line: 39, column: 37, scope: !187)
!189 = !DILocation(line: 39, column: 35, scope: !187)
!190 = !DILocation(line: 39, column: 13, scope: !151)
!191 = !DILocation(line: 39, column: 13, scope: !187)
!192 = !DILocation(line: 40, column: 35, scope: !193)
!193 = distinct !DILexicalBlock(scope: !187, file: !1, line: 39, column: 46)
!194 = !DILocation(line: 40, column: 41, scope: !193)
!195 = !DILocation(line: 40, column: 46, scope: !193)
!196 = !DILocation(line: 40, column: 48, scope: !193)
!197 = !DILocation(line: 40, column: 47, scope: !193)
!198 = !DILocation(line: 40, column: 52, scope: !193)
!199 = !DILocation(line: 40, column: 50, scope: !193)
!200 = !DILocation(line: 40, column: 58, scope: !193)
!201 = !DILocation(line: 40, column: 65, scope: !193)
!202 = !DILocation(line: 40, column: 70, scope: !193)
!203 = !DILocation(line: 40, column: 73, scope: !193)
!204 = !DILocation(line: 40, column: 72, scope: !193)
!205 = !DILocation(line: 40, column: 77, scope: !193)
!206 = !DILocation(line: 40, column: 75, scope: !193)
!207 = !DILocation(line: 40, column: 56, scope: !193)
!208 = !DILocation(line: 40, column: 32, scope: !193)
!209 = !DILocation(line: 41, column: 13, scope: !193)
!210 = !DILocation(line: 39, column: 40, scope: !187)
!211 = distinct !{!211, !190, !212}
!212 = !DILocation(line: 41, column: 13, scope: !151)
!213 = !DILocation(line: 42, column: 33, scope: !148)
!214 = !DILocation(line: 42, column: 17, scope: !148)
!215 = !DILocation(line: 42, column: 22, scope: !148)
!216 = !DILocation(line: 42, column: 24, scope: !148)
!217 = !DILocation(line: 42, column: 23, scope: !148)
!218 = !DILocation(line: 42, column: 28, scope: !148)
!219 = !DILocation(line: 42, column: 26, scope: !148)
!220 = !DILocation(line: 42, column: 13, scope: !148)
!221 = !DILocation(line: 42, column: 31, scope: !148)
!222 = !DILocation(line: 43, column: 9, scope: !149)
!223 = !DILocation(line: 43, column: 9, scope: !148)
!224 = !DILocation(line: 37, column: 34, scope: !149)
!225 = distinct !{!225, !180, !226}
!226 = !DILocation(line: 43, column: 9, scope: !144)
!227 = !DILocation(line: 44, column: 5, scope: !145)
!228 = !DILocation(line: 36, column: 30, scope: !146)
!229 = distinct !{!229, !173, !230}
!230 = !DILocation(line: 44, column: 5, scope: !142)
!231 = !DILocation(line: 47, column: 1, scope: !130)
!232 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 49, type: !233, scopeLine: 50, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !235)
!233 = !DISubroutineType(types: !234)
!234 = !{!12, !12, !13}
!235 = !{!236, !237, !238, !239, !240, !241, !242, !243}
!236 = !DILocalVariable(name: "argc", arg: 1, scope: !232, file: !1, line: 49, type: !12)
!237 = !DILocalVariable(name: "argv", arg: 2, scope: !232, file: !1, line: 49, type: !13)
!238 = !DILocalVariable(name: "m", scope: !232, file: !1, line: 51, type: !12)
!239 = !DILocalVariable(name: "n", scope: !232, file: !1, line: 51, type: !12)
!240 = !DILocalVariable(name: "k", scope: !232, file: !1, line: 51, type: !12)
!241 = !DILocalVariable(name: "left", scope: !232, file: !1, line: 61, type: !60)
!242 = !DILocalVariable(name: "right", scope: !232, file: !1, line: 62, type: !60)
!243 = !DILocalVariable(name: "res", scope: !232, file: !1, line: 63, type: !60)
!244 = !DILocation(line: 49, column: 14, scope: !232)
!245 = !DILocation(line: 49, column: 28, scope: !232)
!246 = !DILocation(line: 51, column: 5, scope: !232)
!247 = !DILocation(line: 51, column: 9, scope: !232)
!248 = !DILocation(line: 51, column: 19, scope: !232)
!249 = !DILocation(line: 51, column: 29, scope: !232)
!250 = !DILocation(line: 52, column: 5, scope: !251)
!251 = distinct !DILexicalBlock(scope: !252, file: !1, line: 52, column: 5)
!252 = distinct !DILexicalBlock(scope: !232, file: !1, line: 52, column: 5)
!253 = !DILocation(line: 52, column: 5, scope: !252)
!254 = !DILocation(line: 53, column: 14, scope: !232)
!255 = !DILocation(line: 53, column: 9, scope: !232)
!256 = !DILocation(line: 53, column: 7, scope: !232)
!257 = !DILocation(line: 54, column: 14, scope: !232)
!258 = !DILocation(line: 54, column: 9, scope: !232)
!259 = !DILocation(line: 54, column: 7, scope: !232)
!260 = !DILocation(line: 55, column: 14, scope: !232)
!261 = !DILocation(line: 55, column: 9, scope: !232)
!262 = !DILocation(line: 55, column: 7, scope: !232)
!263 = !DILocation(line: 56, column: 11, scope: !232)
!264 = !DILocation(line: 56, column: 5, scope: !232)
!265 = !DILocation(line: 57, column: 23, scope: !232)
!266 = !DILocation(line: 57, column: 5, scope: !232)
!267 = !DILocation(line: 58, column: 23, scope: !232)
!268 = !DILocation(line: 58, column: 5, scope: !232)
!269 = !DILocation(line: 59, column: 23, scope: !232)
!270 = !DILocation(line: 59, column: 5, scope: !232)
!271 = !DILocation(line: 61, column: 5, scope: !232)
!272 = !DILocation(line: 61, column: 12, scope: !232)
!273 = !DILocation(line: 61, column: 33, scope: !232)
!274 = !DILocation(line: 61, column: 36, scope: !232)
!275 = !DILocation(line: 61, column: 19, scope: !232)
!276 = !DILocation(line: 62, column: 5, scope: !232)
!277 = !DILocation(line: 62, column: 12, scope: !232)
!278 = !DILocation(line: 62, column: 34, scope: !232)
!279 = !DILocation(line: 62, column: 37, scope: !232)
!280 = !DILocation(line: 62, column: 20, scope: !232)
!281 = !DILocation(line: 63, column: 5, scope: !232)
!282 = !DILocation(line: 63, column: 12, scope: !232)
!283 = !DILocation(line: 63, column: 18, scope: !232)
!284 = !DILocation(line: 65, column: 13, scope: !232)
!285 = !DILocation(line: 65, column: 33, scope: !232)
!286 = !DILocation(line: 65, column: 29, scope: !232)
!287 = !DILocation(line: 65, column: 5, scope: !232)
!288 = !DILocation(line: 67, column: 15, scope: !232)
!289 = !DILocation(line: 67, column: 10, scope: !232)
!290 = !DILocation(line: 67, column: 5, scope: !232)
!291 = !DILocation(line: 68, column: 16, scope: !232)
!292 = !DILocation(line: 68, column: 10, scope: !232)
!293 = !DILocation(line: 68, column: 5, scope: !232)
!294 = !DILocation(line: 69, column: 14, scope: !232)
!295 = !DILocation(line: 69, column: 10, scope: !232)
!296 = !DILocation(line: 69, column: 5, scope: !232)
!297 = !DILocation(line: 72, column: 1, scope: !232)
!298 = !DILocation(line: 71, column: 5, scope: !232)
!299 = distinct !DISubprogram(name: "atoi", scope: !300, file: !300, line: 361, type: !301, scopeLine: 362, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !303)
!300 = !DIFile(filename: "/usr/include/stdlib.h", directory: "")
!301 = !DISubroutineType(types: !302)
!302 = !{!12, !28}
!303 = !{!304}
!304 = !DILocalVariable(name: "__nptr", arg: 1, scope: !299, file: !300, line: 361, type: !28)
!305 = !DILocation(line: 361, column: 1, scope: !299)
!306 = !DILocation(line: 363, column: 24, scope: !299)
!307 = !DILocation(line: 363, column: 16, scope: !299)
!308 = !DILocation(line: 363, column: 10, scope: !299)
!309 = !DILocation(line: 363, column: 3, scope: !299)
