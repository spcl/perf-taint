; RUN: opt %dfsan -S < %s 2> /dev/null | llc %llcparams - -o %t1 && clang++ %link %t1 -o %t2 && %execparams %t2 50 30 40 | diff -w %s.json -
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

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @register_variable(i8*, i64, i8*) #0 !dbg !16 {
  %4 = alloca i8*, align 8
  %5 = alloca i64, align 8
  %6 = alloca i8*, align 8
  %7 = alloca i32, align 4
  store i8* %0, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !27, metadata !DIExpression()), !dbg !28
  store i64 %1, i64* %5, align 8
  call void @llvm.dbg.declare(metadata i64* %5, metadata !29, metadata !DIExpression()), !dbg !30
  store i8* %2, i8** %6, align 8
  call void @llvm.dbg.declare(metadata i8** %6, metadata !31, metadata !DIExpression()), !dbg !32
  call void @llvm.dbg.declare(metadata i32* %7, metadata !33, metadata !DIExpression()), !dbg !37
  %8 = call i32 (...) @__dfsw_EXTRAP_VAR_ID(), !dbg !38
  store i32 %8, i32* %7, align 4, !dbg !37
  %9 = load i8*, i8** %4, align 8, !dbg !39
  %10 = load i64, i64* %5, align 8, !dbg !40
  %11 = trunc i64 %10 to i32, !dbg !40
  %12 = load i32, i32* %7, align 4, !dbg !41
  %13 = add nsw i32 %12, 1, !dbg !41
  store i32 %13, i32* %7, align 4, !dbg !41
  %14 = load i8*, i8** %6, align 8, !dbg !42
  call void @__dfsw_EXTRAP_STORE_LABEL(i8* %9, i32 %11, i32 %12, i8* %14), !dbg !43
  ret void, !dbg !44
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

declare dso_local i32 @__dfsw_EXTRAP_VAR_ID(...) #2

declare dso_local void @__dfsw_EXTRAP_STORE_LABEL(i8*, i32, i32, i8*) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @create_matrix(%struct._matrix* noalias sret, i32, i32, i1 zeroext) #0 !dbg !45 {
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i8, align 1
  %8 = alloca i64, align 8
  %9 = alloca i64, align 8
  store i32 %1, i32* %5, align 4
  call void @llvm.dbg.declare(metadata i32* %5, metadata !55, metadata !DIExpression()), !dbg !56
  store i32 %2, i32* %6, align 4
  call void @llvm.dbg.declare(metadata i32* %6, metadata !57, metadata !DIExpression()), !dbg !58
  %10 = zext i1 %3 to i8
  store i8 %10, i8* %7, align 1
  call void @llvm.dbg.declare(metadata i8* %7, metadata !59, metadata !DIExpression()), !dbg !60
  call void @llvm.dbg.declare(metadata %struct._matrix* %0, metadata !61, metadata !DIExpression()), !dbg !62
  %11 = load i32, i32* %5, align 4, !dbg !63
  %12 = sext i32 %11 to i64, !dbg !63
  %13 = getelementptr inbounds %struct._matrix, %struct._matrix* %0, i32 0, i32 0, !dbg !64
  store i64 %12, i64* %13, align 8, !dbg !65
  %14 = load i32, i32* %6, align 4, !dbg !66
  %15 = sext i32 %14 to i64, !dbg !66
  %16 = getelementptr inbounds %struct._matrix, %struct._matrix* %0, i32 0, i32 1, !dbg !67
  store i64 %15, i64* %16, align 8, !dbg !68
  %17 = load i32, i32* %5, align 4, !dbg !69
  %18 = load i32, i32* %6, align 4, !dbg !70
  %19 = mul nsw i32 %17, %18, !dbg !71
  %20 = sext i32 %19 to i64, !dbg !69
  %21 = call noalias i8* @calloc(i64 %20, i64 8) #4, !dbg !72
  %22 = bitcast i8* %21 to double*, !dbg !73
  %23 = getelementptr inbounds %struct._matrix, %struct._matrix* %0, i32 0, i32 2, !dbg !74
  store double* %22, double** %23, align 8, !dbg !75
  %24 = load i8, i8* %7, align 1, !dbg !76
  %25 = trunc i8 %24 to i1, !dbg !76
  br i1 %25, label %26, label %47, !dbg !78

; <label>:26:                                     ; preds = %4
  call void @llvm.dbg.declare(metadata i64* %8, metadata !79, metadata !DIExpression()), !dbg !81
  %27 = load i32, i32* %5, align 4, !dbg !82
  %28 = load i32, i32* %6, align 4, !dbg !83
  %29 = mul nsw i32 %27, %28, !dbg !84
  %30 = sext i32 %29 to i64, !dbg !82
  store i64 %30, i64* %8, align 8, !dbg !81
  call void @llvm.dbg.declare(metadata i64* %9, metadata !85, metadata !DIExpression()), !dbg !87
  store i64 0, i64* %9, align 8, !dbg !87
  br label %31, !dbg !88

; <label>:31:                                     ; preds = %43, %26
  %32 = load i64, i64* %9, align 8, !dbg !89
  %33 = load i64, i64* %8, align 8, !dbg !91
  %34 = icmp ult i64 %32, %33, !dbg !92
  br i1 %34, label %35, label %46, !dbg !93

; <label>:35:                                     ; preds = %31
  %36 = call i32 @rand() #4, !dbg !94
  %37 = srem i32 %36, 100, !dbg !95
  %38 = sitofp i32 %37 to double, !dbg !94
  %39 = getelementptr inbounds %struct._matrix, %struct._matrix* %0, i32 0, i32 2, !dbg !96
  %40 = load double*, double** %39, align 8, !dbg !96
  %41 = load i64, i64* %9, align 8, !dbg !97
  %42 = getelementptr inbounds double, double* %40, i64 %41, !dbg !98
  store double %38, double* %42, align 8, !dbg !99
  br label %43, !dbg !98

; <label>:43:                                     ; preds = %35
  %44 = load i64, i64* %9, align 8, !dbg !100
  %45 = add i64 %44, 1, !dbg !100
  store i64 %45, i64* %9, align 8, !dbg !100
  br label %31, !dbg !101, !llvm.loop !102

; <label>:46:                                     ; preds = %31
  br label %47, !dbg !104

; <label>:47:                                     ; preds = %46, %4
  ret void, !dbg !105
}

; Function Attrs: nounwind
declare dso_local noalias i8* @calloc(i64, i64) #3

; Function Attrs: nounwind
declare dso_local i32 @rand() #3

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @mat_mul(%struct._matrix* noalias sret, %struct._matrix*, %struct._matrix*) #0 !dbg !106 {
  %4 = alloca %struct._matrix*, align 8
  %5 = alloca %struct._matrix*, align 8
  %6 = alloca i64, align 8
  %7 = alloca i64, align 8
  %8 = alloca i64, align 8
  %9 = alloca i64, align 8
  %10 = alloca i64, align 8
  %11 = alloca double, align 8
  %12 = alloca i64, align 8
  store %struct._matrix* %1, %struct._matrix** %4, align 8
  call void @llvm.dbg.declare(metadata %struct._matrix** %4, metadata !110, metadata !DIExpression()), !dbg !111
  store %struct._matrix* %2, %struct._matrix** %5, align 8
  call void @llvm.dbg.declare(metadata %struct._matrix** %5, metadata !112, metadata !DIExpression()), !dbg !113
  call void @llvm.dbg.declare(metadata i64* %6, metadata !114, metadata !DIExpression()), !dbg !115
  %13 = load %struct._matrix*, %struct._matrix** %4, align 8, !dbg !116
  %14 = getelementptr inbounds %struct._matrix, %struct._matrix* %13, i32 0, i32 0, !dbg !117
  %15 = load i64, i64* %14, align 8, !dbg !117
  store i64 %15, i64* %6, align 8, !dbg !115
  call void @llvm.dbg.declare(metadata i64* %7, metadata !118, metadata !DIExpression()), !dbg !119
  %16 = load %struct._matrix*, %struct._matrix** %4, align 8, !dbg !120
  %17 = getelementptr inbounds %struct._matrix, %struct._matrix* %16, i32 0, i32 1, !dbg !121
  %18 = load i64, i64* %17, align 8, !dbg !121
  store i64 %18, i64* %7, align 8, !dbg !119
  call void @llvm.dbg.declare(metadata i64* %8, metadata !122, metadata !DIExpression()), !dbg !123
  %19 = load %struct._matrix*, %struct._matrix** %5, align 8, !dbg !124
  %20 = getelementptr inbounds %struct._matrix, %struct._matrix* %19, i32 0, i32 1, !dbg !125
  %21 = load i64, i64* %20, align 8, !dbg !125
  store i64 %21, i64* %8, align 8, !dbg !123
  call void @llvm.dbg.declare(metadata %struct._matrix* %0, metadata !126, metadata !DIExpression()), !dbg !127
  %22 = load i64, i64* %6, align 8, !dbg !128
  %23 = trunc i64 %22 to i32, !dbg !128
  %24 = load i64, i64* %8, align 8, !dbg !129
  %25 = trunc i64 %24 to i32, !dbg !129
  call void @create_matrix(%struct._matrix* sret %0, i32 %23, i32 %25, i1 zeroext false), !dbg !130
  call void @llvm.dbg.declare(metadata i64* %9, metadata !131, metadata !DIExpression()), !dbg !133
  store i64 0, i64* %9, align 8, !dbg !133
  br label %26, !dbg !134

; <label>:26:                                     ; preds = %81, %3
  %27 = load i64, i64* %9, align 8, !dbg !135
  %28 = load i64, i64* %6, align 8, !dbg !137
  %29 = icmp ult i64 %27, %28, !dbg !138
  br i1 %29, label %30, label %84, !dbg !139

; <label>:30:                                     ; preds = %26
  call void @llvm.dbg.declare(metadata i64* %10, metadata !140, metadata !DIExpression()), !dbg !143
  store i64 0, i64* %10, align 8, !dbg !143
  br label %31, !dbg !144

; <label>:31:                                     ; preds = %77, %30
  %32 = load i64, i64* %10, align 8, !dbg !145
  %33 = load i64, i64* %8, align 8, !dbg !147
  %34 = icmp ult i64 %32, %33, !dbg !148
  br i1 %34, label %35, label %80, !dbg !149

; <label>:35:                                     ; preds = %31
  call void @llvm.dbg.declare(metadata double* %11, metadata !150, metadata !DIExpression()), !dbg !152
  store double 0.000000e+00, double* %11, align 8, !dbg !152
  call void @llvm.dbg.declare(metadata i64* %12, metadata !153, metadata !DIExpression()), !dbg !155
  store i64 0, i64* %12, align 8, !dbg !155
  br label %36, !dbg !156

; <label>:36:                                     ; preds = %64, %35
  %37 = load i64, i64* %12, align 8, !dbg !157
  %38 = load i64, i64* %7, align 8, !dbg !159
  %39 = icmp ult i64 %37, %38, !dbg !160
  br i1 %39, label %40, label %67, !dbg !161

; <label>:40:                                     ; preds = %36
  %41 = load %struct._matrix*, %struct._matrix** %4, align 8, !dbg !162
  %42 = getelementptr inbounds %struct._matrix, %struct._matrix* %41, i32 0, i32 2, !dbg !164
  %43 = load double*, double** %42, align 8, !dbg !164
  %44 = load i64, i64* %9, align 8, !dbg !165
  %45 = load i64, i64* %7, align 8, !dbg !166
  %46 = mul i64 %44, %45, !dbg !167
  %47 = load i64, i64* %12, align 8, !dbg !168
  %48 = add i64 %46, %47, !dbg !169
  %49 = getelementptr inbounds double, double* %43, i64 %48, !dbg !162
  %50 = load double, double* %49, align 8, !dbg !162
  %51 = load %struct._matrix*, %struct._matrix** %5, align 8, !dbg !170
  %52 = getelementptr inbounds %struct._matrix, %struct._matrix* %51, i32 0, i32 2, !dbg !171
  %53 = load double*, double** %52, align 8, !dbg !171
  %54 = load i64, i64* %12, align 8, !dbg !172
  %55 = load i64, i64* %8, align 8, !dbg !173
  %56 = mul i64 %54, %55, !dbg !174
  %57 = load i64, i64* %10, align 8, !dbg !175
  %58 = add i64 %56, %57, !dbg !176
  %59 = getelementptr inbounds double, double* %53, i64 %58, !dbg !170
  %60 = load double, double* %59, align 8, !dbg !170
  %61 = fmul double %50, %60, !dbg !177
  %62 = load double, double* %11, align 8, !dbg !178
  %63 = fadd double %62, %61, !dbg !178
  store double %63, double* %11, align 8, !dbg !178
  br label %64, !dbg !179

; <label>:64:                                     ; preds = %40
  %65 = load i64, i64* %12, align 8, !dbg !180
  %66 = add i64 %65, 1, !dbg !180
  store i64 %66, i64* %12, align 8, !dbg !180
  br label %36, !dbg !181, !llvm.loop !182

; <label>:67:                                     ; preds = %36
  %68 = load double, double* %11, align 8, !dbg !184
  %69 = getelementptr inbounds %struct._matrix, %struct._matrix* %0, i32 0, i32 2, !dbg !185
  %70 = load double*, double** %69, align 8, !dbg !185
  %71 = load i64, i64* %9, align 8, !dbg !186
  %72 = load i64, i64* %8, align 8, !dbg !187
  %73 = mul i64 %71, %72, !dbg !188
  %74 = load i64, i64* %10, align 8, !dbg !189
  %75 = add i64 %73, %74, !dbg !190
  %76 = getelementptr inbounds double, double* %70, i64 %75, !dbg !191
  store double %68, double* %76, align 8, !dbg !192
  br label %77, !dbg !193

; <label>:77:                                     ; preds = %67
  %78 = load i64, i64* %10, align 8, !dbg !194
  %79 = add i64 %78, 1, !dbg !194
  store i64 %79, i64* %10, align 8, !dbg !194
  br label %31, !dbg !195, !llvm.loop !196

; <label>:80:                                     ; preds = %31
  br label %81, !dbg !198

; <label>:81:                                     ; preds = %80
  %82 = load i64, i64* %9, align 8, !dbg !199
  %83 = add i64 %82, 1, !dbg !199
  store i64 %83, i64* %9, align 8, !dbg !199
  br label %26, !dbg !200, !llvm.loop !201

; <label>:84:                                     ; preds = %26
  ret void, !dbg !203
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main(i32, i8**) #0 !dbg !204 {
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
  store i32 %0, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !209, metadata !DIExpression()), !dbg !210
  store i8** %1, i8*** %5, align 8
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !211, metadata !DIExpression()), !dbg !212
  call void @llvm.dbg.declare(metadata i32* %6, metadata !213, metadata !DIExpression()), !dbg !214
  %12 = bitcast i32* %6 to i8*, !dbg !215
  call void @llvm.var.annotation(i8* %12, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([27 x i8], [27 x i8]* @.str.1, i32 0, i32 0), i32 51), !dbg !215
  call void @llvm.dbg.declare(metadata i32* %7, metadata !216, metadata !DIExpression()), !dbg !217
  %13 = bitcast i32* %7 to i8*, !dbg !215
  call void @llvm.var.annotation(i8* %13, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([27 x i8], [27 x i8]* @.str.1, i32 0, i32 0), i32 51), !dbg !215
  call void @llvm.dbg.declare(metadata i32* %8, metadata !218, metadata !DIExpression()), !dbg !219
  %14 = bitcast i32* %8 to i8*, !dbg !215
  call void @llvm.var.annotation(i8* %14, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([27 x i8], [27 x i8]* @.str.1, i32 0, i32 0), i32 51), !dbg !215
  %15 = load i32, i32* %4, align 4, !dbg !220
  %16 = icmp eq i32 %15, 4, !dbg !220
  br i1 %16, label %17, label %18, !dbg !223

; <label>:17:                                     ; preds = %2
  br label %19, !dbg !223

; <label>:18:                                     ; preds = %2
  call void @__assert_fail(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @.str.2, i32 0, i32 0), i8* getelementptr inbounds ([27 x i8], [27 x i8]* @.str.3, i32 0, i32 0), i32 52, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @__PRETTY_FUNCTION__.main, i32 0, i32 0)) #7, !dbg !220
  unreachable, !dbg !220

; <label>:19:                                     ; preds = %17
  %20 = load i8**, i8*** %5, align 8, !dbg !224
  %21 = getelementptr inbounds i8*, i8** %20, i64 1, !dbg !224
  %22 = load i8*, i8** %21, align 8, !dbg !224
  %23 = call i32 @atoi(i8* %22) #8, !dbg !225
  store i32 %23, i32* %6, align 4, !dbg !226
  %24 = load i8**, i8*** %5, align 8, !dbg !227
  %25 = getelementptr inbounds i8*, i8** %24, i64 2, !dbg !227
  %26 = load i8*, i8** %25, align 8, !dbg !227
  %27 = call i32 @atoi(i8* %26) #8, !dbg !228
  store i32 %27, i32* %7, align 4, !dbg !229
  %28 = load i8**, i8*** %5, align 8, !dbg !230
  %29 = getelementptr inbounds i8*, i8** %28, i64 3, !dbg !230
  %30 = load i8*, i8** %29, align 8, !dbg !230
  %31 = call i32 @atoi(i8* %30) #8, !dbg !231
  store i32 %31, i32* %8, align 4, !dbg !232
  %32 = call i64 @time(i64* null) #4, !dbg !233
  %33 = trunc i64 %32 to i32, !dbg !233
  call void @srand(i32 %33) #4, !dbg !234
  %34 = bitcast i32* %6 to i8*, !dbg !235
  call void @register_variable(i8* %34, i64 4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.4, i32 0, i32 0)), !dbg !236
  %35 = bitcast i32* %7 to i8*, !dbg !237
  call void @register_variable(i8* %35, i64 4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.5, i32 0, i32 0)), !dbg !238
  %36 = bitcast i32* %8 to i8*, !dbg !239
  call void @register_variable(i8* %36, i64 4, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.6, i32 0, i32 0)), !dbg !240
  call void @llvm.dbg.declare(metadata %struct._matrix* %9, metadata !241, metadata !DIExpression()), !dbg !242
  %37 = load i32, i32* %6, align 4, !dbg !243
  %38 = load i32, i32* %7, align 4, !dbg !244
  call void @create_matrix(%struct._matrix* sret %9, i32 %37, i32 %38, i1 zeroext true), !dbg !245
  call void @llvm.dbg.declare(metadata %struct._matrix* %10, metadata !246, metadata !DIExpression()), !dbg !247
  %39 = load i32, i32* %7, align 4, !dbg !248
  %40 = load i32, i32* %8, align 4, !dbg !249
  call void @create_matrix(%struct._matrix* sret %10, i32 %39, i32 %40, i1 zeroext true), !dbg !250
  call void @llvm.dbg.declare(metadata %struct._matrix* %11, metadata !251, metadata !DIExpression()), !dbg !252
  call void @mat_mul(%struct._matrix* sret %11, %struct._matrix* %9, %struct._matrix* %10), !dbg !253
  %41 = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8, !dbg !254
  %42 = getelementptr inbounds %struct._matrix, %struct._matrix* %11, i32 0, i32 2, !dbg !255
  %43 = load double*, double** %42, align 8, !dbg !255
  %44 = getelementptr inbounds double, double* %43, i64 0, !dbg !256
  %45 = load double, double* %44, align 8, !dbg !256
  %46 = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %41, i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.7, i32 0, i32 0), double %45), !dbg !257
  %47 = getelementptr inbounds %struct._matrix, %struct._matrix* %9, i32 0, i32 2, !dbg !258
  %48 = load double*, double** %47, align 8, !dbg !258
  %49 = bitcast double* %48 to i8*, !dbg !259
  call void @free(i8* %49) #4, !dbg !260
  %50 = getelementptr inbounds %struct._matrix, %struct._matrix* %10, i32 0, i32 2, !dbg !261
  %51 = load double*, double** %50, align 8, !dbg !261
  %52 = bitcast double* %51 to i8*, !dbg !262
  call void @free(i8* %52) #4, !dbg !263
  %53 = getelementptr inbounds %struct._matrix, %struct._matrix* %11, i32 0, i32 2, !dbg !264
  %54 = load double*, double** %53, align 8, !dbg !264
  %55 = bitcast double* %54 to i8*, !dbg !265
  call void @free(i8* %55) #4, !dbg !266
  ret i32 0, !dbg !267
}

; Function Attrs: nounwind
declare void @llvm.var.annotation(i8*, i8*, i8*, i32) #4

; Function Attrs: noreturn nounwind
declare dso_local void @__assert_fail(i8*, i8*, i32, i8*) #5

; Function Attrs: nounwind readonly
declare dso_local i32 @atoi(i8*) #6

; Function Attrs: nounwind
declare dso_local void @srand(i32) #3

; Function Attrs: nounwind
declare dso_local i64 @time(i64*) #3

declare dso_local i32 @fprintf(%struct._IO_FILE*, i8*, ...) #2

; Function Attrs: nounwind
declare dso_local void @free(i8*) #3

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind }
attributes #5 = { noreturn nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #6 = { nounwind readonly "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #7 = { noreturn nounwind }
attributes #8 = { nounwind readonly }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!12, !13, !14}
!llvm.ident = !{!15}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 8.0.0 (git@github.com:llvm-mirror/clang.git fd01d8b9288b3558a597daeb0cb4481b37c5bf68) (git@github.com:llvm-mirror/LLVM.git 7135d8b482d3d0d1a8c50111eebb9b207e92a8bc)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !3, nameTableKind: None)
!1 = !DIFile(filename: "tests/dfsan-instr/matmul.c", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!2 = !{}
!3 = !{!4, !10}
!4 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !5, size: 64)
!5 = !DIDerivedType(tag: DW_TAG_typedef, name: "int8_t", file: !6, line: 24, baseType: !7)
!6 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-intn.h", directory: "")
!7 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int8_t", file: !8, line: 36, baseType: !9)
!8 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "")
!9 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!10 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !11, size: 64)
!11 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!12 = !{i32 2, !"Dwarf Version", i32 4}
!13 = !{i32 2, !"Debug Info Version", i32 3}
!14 = !{i32 1, !"wchar_size", i32 4}
!15 = !{!"clang version 8.0.0 (git@github.com:llvm-mirror/clang.git fd01d8b9288b3558a597daeb0cb4481b37c5bf68) (git@github.com:llvm-mirror/LLVM.git 7135d8b482d3d0d1a8c50111eebb9b207e92a8bc)"}
!16 = distinct !DISubprogram(name: "register_variable", scope: !17, file: !17, line: 12, type: !18, scopeLine: 13, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!17 = !DIFile(filename: "include/ExtraPInstrumenter.h", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!18 = !DISubroutineType(types: !19)
!19 = !{null, !20, !21, !24}
!20 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !22, line: 62, baseType: !23)
!22 = !DIFile(filename: "clang_llvm/build_release/lib/clang/8.0.0/include/stddef.h", directory: "/home/mcopik/projects")
!23 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!24 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !25, size: 64)
!25 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !26)
!26 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!27 = !DILocalVariable(name: "ptr", arg: 1, scope: !16, file: !17, line: 12, type: !20)
!28 = !DILocation(line: 12, column: 31, scope: !16)
!29 = !DILocalVariable(name: "size", arg: 2, scope: !16, file: !17, line: 12, type: !21)
!30 = !DILocation(line: 12, column: 43, scope: !16)
!31 = !DILocalVariable(name: "name", arg: 3, scope: !16, file: !17, line: 12, type: !24)
!32 = !DILocation(line: 12, column: 62, scope: !16)
!33 = !DILocalVariable(name: "param_id", scope: !16, file: !17, line: 14, type: !34)
!34 = !DIDerivedType(tag: DW_TAG_typedef, name: "int32_t", file: !6, line: 26, baseType: !35)
!35 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int32_t", file: !8, line: 40, baseType: !36)
!36 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!37 = !DILocation(line: 14, column: 13, scope: !16)
!38 = !DILocation(line: 14, column: 24, scope: !16)
!39 = !DILocation(line: 15, column: 41, scope: !16)
!40 = !DILocation(line: 15, column: 46, scope: !16)
!41 = !DILocation(line: 15, column: 60, scope: !16)
!42 = !DILocation(line: 15, column: 64, scope: !16)
!43 = !DILocation(line: 15, column: 5, scope: !16)
!44 = !DILocation(line: 16, column: 1, scope: !16)
!45 = distinct !DISubprogram(name: "create_matrix", scope: !1, file: !1, line: 17, type: !46, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!46 = !DISubroutineType(types: !47)
!47 = !{!48, !36, !36, !54}
!48 = !DIDerivedType(tag: DW_TAG_typedef, name: "matrix", file: !1, line: 15, baseType: !49)
!49 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_matrix", file: !1, line: 10, size: 192, elements: !50)
!50 = !{!51, !52, !53}
!51 = !DIDerivedType(tag: DW_TAG_member, name: "rows", scope: !49, file: !1, line: 12, baseType: !21, size: 64)
!52 = !DIDerivedType(tag: DW_TAG_member, name: "cols", scope: !49, file: !1, line: 13, baseType: !21, size: 64, offset: 64)
!53 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !49, file: !1, line: 14, baseType: !10, size: 64, offset: 128)
!54 = !DIBasicType(name: "_Bool", size: 8, encoding: DW_ATE_boolean)
!55 = !DILocalVariable(name: "rows", arg: 1, scope: !45, file: !1, line: 17, type: !36)
!56 = !DILocation(line: 17, column: 26, scope: !45)
!57 = !DILocalVariable(name: "cols", arg: 2, scope: !45, file: !1, line: 17, type: !36)
!58 = !DILocation(line: 17, column: 36, scope: !45)
!59 = !DILocalVariable(name: "init", arg: 3, scope: !45, file: !1, line: 17, type: !54)
!60 = !DILocation(line: 17, column: 47, scope: !45)
!61 = !DILocalVariable(name: "m", scope: !45, file: !1, line: 19, type: !48)
!62 = !DILocation(line: 19, column: 12, scope: !45)
!63 = !DILocation(line: 20, column: 14, scope: !45)
!64 = !DILocation(line: 20, column: 7, scope: !45)
!65 = !DILocation(line: 20, column: 12, scope: !45)
!66 = !DILocation(line: 21, column: 14, scope: !45)
!67 = !DILocation(line: 21, column: 7, scope: !45)
!68 = !DILocation(line: 21, column: 12, scope: !45)
!69 = !DILocation(line: 22, column: 31, scope: !45)
!70 = !DILocation(line: 22, column: 38, scope: !45)
!71 = !DILocation(line: 22, column: 36, scope: !45)
!72 = !DILocation(line: 22, column: 24, scope: !45)
!73 = !DILocation(line: 22, column: 14, scope: !45)
!74 = !DILocation(line: 22, column: 7, scope: !45)
!75 = !DILocation(line: 22, column: 12, scope: !45)
!76 = !DILocation(line: 23, column: 8, scope: !77)
!77 = distinct !DILexicalBlock(scope: !45, file: !1, line: 23, column: 8)
!78 = !DILocation(line: 23, column: 8, scope: !45)
!79 = !DILocalVariable(name: "size", scope: !80, file: !1, line: 24, type: !21)
!80 = distinct !DILexicalBlock(scope: !77, file: !1, line: 23, column: 14)
!81 = !DILocation(line: 24, column: 16, scope: !80)
!82 = !DILocation(line: 24, column: 23, scope: !80)
!83 = !DILocation(line: 24, column: 30, scope: !80)
!84 = !DILocation(line: 24, column: 28, scope: !80)
!85 = !DILocalVariable(name: "i", scope: !86, file: !1, line: 25, type: !21)
!86 = distinct !DILexicalBlock(scope: !80, file: !1, line: 25, column: 9)
!87 = !DILocation(line: 25, column: 20, scope: !86)
!88 = !DILocation(line: 25, column: 13, scope: !86)
!89 = !DILocation(line: 25, column: 27, scope: !90)
!90 = distinct !DILexicalBlock(scope: !86, file: !1, line: 25, column: 9)
!91 = !DILocation(line: 25, column: 31, scope: !90)
!92 = !DILocation(line: 25, column: 29, scope: !90)
!93 = !DILocation(line: 25, column: 9, scope: !86)
!94 = !DILocation(line: 26, column: 25, scope: !90)
!95 = !DILocation(line: 26, column: 32, scope: !90)
!96 = !DILocation(line: 26, column: 15, scope: !90)
!97 = !DILocation(line: 26, column: 20, scope: !90)
!98 = !DILocation(line: 26, column: 13, scope: !90)
!99 = !DILocation(line: 26, column: 23, scope: !90)
!100 = !DILocation(line: 25, column: 37, scope: !90)
!101 = !DILocation(line: 25, column: 9, scope: !90)
!102 = distinct !{!102, !93, !103}
!103 = !DILocation(line: 26, column: 34, scope: !86)
!104 = !DILocation(line: 27, column: 5, scope: !80)
!105 = !DILocation(line: 28, column: 5, scope: !45)
!106 = distinct !DISubprogram(name: "mat_mul", scope: !1, file: !1, line: 31, type: !107, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!107 = !DISubroutineType(types: !108)
!108 = !{!48, !109, !109}
!109 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !48, size: 64)
!110 = !DILocalVariable(name: "left", arg: 1, scope: !106, file: !1, line: 31, type: !109)
!111 = !DILocation(line: 31, column: 25, scope: !106)
!112 = !DILocalVariable(name: "right", arg: 2, scope: !106, file: !1, line: 31, type: !109)
!113 = !DILocation(line: 31, column: 40, scope: !106)
!114 = !DILocalVariable(name: "m", scope: !106, file: !1, line: 33, type: !21)
!115 = !DILocation(line: 33, column: 12, scope: !106)
!116 = !DILocation(line: 33, column: 16, scope: !106)
!117 = !DILocation(line: 33, column: 22, scope: !106)
!118 = !DILocalVariable(name: "n", scope: !106, file: !1, line: 33, type: !21)
!119 = !DILocation(line: 33, column: 28, scope: !106)
!120 = !DILocation(line: 33, column: 32, scope: !106)
!121 = !DILocation(line: 33, column: 38, scope: !106)
!122 = !DILocalVariable(name: "k", scope: !106, file: !1, line: 33, type: !21)
!123 = !DILocation(line: 33, column: 44, scope: !106)
!124 = !DILocation(line: 33, column: 48, scope: !106)
!125 = !DILocation(line: 33, column: 55, scope: !106)
!126 = !DILocalVariable(name: "res", scope: !106, file: !1, line: 34, type: !48)
!127 = !DILocation(line: 34, column: 12, scope: !106)
!128 = !DILocation(line: 34, column: 32, scope: !106)
!129 = !DILocation(line: 34, column: 35, scope: !106)
!130 = !DILocation(line: 34, column: 18, scope: !106)
!131 = !DILocalVariable(name: "i", scope: !132, file: !1, line: 36, type: !21)
!132 = distinct !DILexicalBlock(scope: !106, file: !1, line: 36, column: 5)
!133 = !DILocation(line: 36, column: 16, scope: !132)
!134 = !DILocation(line: 36, column: 9, scope: !132)
!135 = !DILocation(line: 36, column: 23, scope: !136)
!136 = distinct !DILexicalBlock(scope: !132, file: !1, line: 36, column: 5)
!137 = !DILocation(line: 36, column: 27, scope: !136)
!138 = !DILocation(line: 36, column: 25, scope: !136)
!139 = !DILocation(line: 36, column: 5, scope: !132)
!140 = !DILocalVariable(name: "j", scope: !141, file: !1, line: 37, type: !21)
!141 = distinct !DILexicalBlock(scope: !142, file: !1, line: 37, column: 9)
!142 = distinct !DILexicalBlock(scope: !136, file: !1, line: 36, column: 35)
!143 = !DILocation(line: 37, column: 20, scope: !141)
!144 = !DILocation(line: 37, column: 13, scope: !141)
!145 = !DILocation(line: 37, column: 27, scope: !146)
!146 = distinct !DILexicalBlock(scope: !141, file: !1, line: 37, column: 9)
!147 = !DILocation(line: 37, column: 31, scope: !146)
!148 = !DILocation(line: 37, column: 29, scope: !146)
!149 = !DILocation(line: 37, column: 9, scope: !141)
!150 = !DILocalVariable(name: "scalar_product", scope: !151, file: !1, line: 38, type: !11)
!151 = distinct !DILexicalBlock(scope: !146, file: !1, line: 37, column: 39)
!152 = !DILocation(line: 38, column: 20, scope: !151)
!153 = !DILocalVariable(name: "kk", scope: !154, file: !1, line: 39, type: !21)
!154 = distinct !DILexicalBlock(scope: !151, file: !1, line: 39, column: 13)
!155 = !DILocation(line: 39, column: 24, scope: !154)
!156 = !DILocation(line: 39, column: 17, scope: !154)
!157 = !DILocation(line: 39, column: 32, scope: !158)
!158 = distinct !DILexicalBlock(scope: !154, file: !1, line: 39, column: 13)
!159 = !DILocation(line: 39, column: 37, scope: !158)
!160 = !DILocation(line: 39, column: 35, scope: !158)
!161 = !DILocation(line: 39, column: 13, scope: !154)
!162 = !DILocation(line: 40, column: 35, scope: !163)
!163 = distinct !DILexicalBlock(scope: !158, file: !1, line: 39, column: 46)
!164 = !DILocation(line: 40, column: 41, scope: !163)
!165 = !DILocation(line: 40, column: 46, scope: !163)
!166 = !DILocation(line: 40, column: 48, scope: !163)
!167 = !DILocation(line: 40, column: 47, scope: !163)
!168 = !DILocation(line: 40, column: 52, scope: !163)
!169 = !DILocation(line: 40, column: 50, scope: !163)
!170 = !DILocation(line: 40, column: 58, scope: !163)
!171 = !DILocation(line: 40, column: 65, scope: !163)
!172 = !DILocation(line: 40, column: 70, scope: !163)
!173 = !DILocation(line: 40, column: 73, scope: !163)
!174 = !DILocation(line: 40, column: 72, scope: !163)
!175 = !DILocation(line: 40, column: 77, scope: !163)
!176 = !DILocation(line: 40, column: 75, scope: !163)
!177 = !DILocation(line: 40, column: 56, scope: !163)
!178 = !DILocation(line: 40, column: 32, scope: !163)
!179 = !DILocation(line: 41, column: 13, scope: !163)
!180 = !DILocation(line: 39, column: 40, scope: !158)
!181 = !DILocation(line: 39, column: 13, scope: !158)
!182 = distinct !{!182, !161, !183}
!183 = !DILocation(line: 41, column: 13, scope: !154)
!184 = !DILocation(line: 42, column: 33, scope: !151)
!185 = !DILocation(line: 42, column: 17, scope: !151)
!186 = !DILocation(line: 42, column: 22, scope: !151)
!187 = !DILocation(line: 42, column: 24, scope: !151)
!188 = !DILocation(line: 42, column: 23, scope: !151)
!189 = !DILocation(line: 42, column: 28, scope: !151)
!190 = !DILocation(line: 42, column: 26, scope: !151)
!191 = !DILocation(line: 42, column: 13, scope: !151)
!192 = !DILocation(line: 42, column: 31, scope: !151)
!193 = !DILocation(line: 43, column: 9, scope: !151)
!194 = !DILocation(line: 37, column: 34, scope: !146)
!195 = !DILocation(line: 37, column: 9, scope: !146)
!196 = distinct !{!196, !149, !197}
!197 = !DILocation(line: 43, column: 9, scope: !141)
!198 = !DILocation(line: 44, column: 5, scope: !142)
!199 = !DILocation(line: 36, column: 30, scope: !136)
!200 = !DILocation(line: 36, column: 5, scope: !136)
!201 = distinct !{!201, !139, !202}
!202 = !DILocation(line: 44, column: 5, scope: !132)
!203 = !DILocation(line: 46, column: 5, scope: !106)
!204 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 49, type: !205, scopeLine: 50, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!205 = !DISubroutineType(types: !206)
!206 = !{!36, !36, !207}
!207 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !208, size: 64)
!208 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !26, size: 64)
!209 = !DILocalVariable(name: "argc", arg: 1, scope: !204, file: !1, line: 49, type: !36)
!210 = !DILocation(line: 49, column: 14, scope: !204)
!211 = !DILocalVariable(name: "argv", arg: 2, scope: !204, file: !1, line: 49, type: !207)
!212 = !DILocation(line: 49, column: 28, scope: !204)
!213 = !DILocalVariable(name: "m", scope: !204, file: !1, line: 51, type: !36)
!214 = !DILocation(line: 51, column: 9, scope: !204)
!215 = !DILocation(line: 51, column: 5, scope: !204)
!216 = !DILocalVariable(name: "n", scope: !204, file: !1, line: 51, type: !36)
!217 = !DILocation(line: 51, column: 19, scope: !204)
!218 = !DILocalVariable(name: "k", scope: !204, file: !1, line: 51, type: !36)
!219 = !DILocation(line: 51, column: 29, scope: !204)
!220 = !DILocation(line: 52, column: 5, scope: !221)
!221 = distinct !DILexicalBlock(scope: !222, file: !1, line: 52, column: 5)
!222 = distinct !DILexicalBlock(scope: !204, file: !1, line: 52, column: 5)
!223 = !DILocation(line: 52, column: 5, scope: !222)
!224 = !DILocation(line: 53, column: 14, scope: !204)
!225 = !DILocation(line: 53, column: 9, scope: !204)
!226 = !DILocation(line: 53, column: 7, scope: !204)
!227 = !DILocation(line: 54, column: 14, scope: !204)
!228 = !DILocation(line: 54, column: 9, scope: !204)
!229 = !DILocation(line: 54, column: 7, scope: !204)
!230 = !DILocation(line: 55, column: 14, scope: !204)
!231 = !DILocation(line: 55, column: 9, scope: !204)
!232 = !DILocation(line: 55, column: 7, scope: !204)
!233 = !DILocation(line: 56, column: 11, scope: !204)
!234 = !DILocation(line: 56, column: 5, scope: !204)
!235 = !DILocation(line: 57, column: 23, scope: !204)
!236 = !DILocation(line: 57, column: 5, scope: !204)
!237 = !DILocation(line: 58, column: 23, scope: !204)
!238 = !DILocation(line: 58, column: 5, scope: !204)
!239 = !DILocation(line: 59, column: 23, scope: !204)
!240 = !DILocation(line: 59, column: 5, scope: !204)
!241 = !DILocalVariable(name: "left", scope: !204, file: !1, line: 61, type: !48)
!242 = !DILocation(line: 61, column: 12, scope: !204)
!243 = !DILocation(line: 61, column: 33, scope: !204)
!244 = !DILocation(line: 61, column: 36, scope: !204)
!245 = !DILocation(line: 61, column: 19, scope: !204)
!246 = !DILocalVariable(name: "right", scope: !204, file: !1, line: 62, type: !48)
!247 = !DILocation(line: 62, column: 12, scope: !204)
!248 = !DILocation(line: 62, column: 34, scope: !204)
!249 = !DILocation(line: 62, column: 37, scope: !204)
!250 = !DILocation(line: 62, column: 20, scope: !204)
!251 = !DILocalVariable(name: "res", scope: !204, file: !1, line: 63, type: !48)
!252 = !DILocation(line: 63, column: 12, scope: !204)
!253 = !DILocation(line: 63, column: 18, scope: !204)
!254 = !DILocation(line: 65, column: 13, scope: !204)
!255 = !DILocation(line: 65, column: 33, scope: !204)
!256 = !DILocation(line: 65, column: 29, scope: !204)
!257 = !DILocation(line: 65, column: 5, scope: !204)
!258 = !DILocation(line: 67, column: 15, scope: !204)
!259 = !DILocation(line: 67, column: 10, scope: !204)
!260 = !DILocation(line: 67, column: 5, scope: !204)
!261 = !DILocation(line: 68, column: 16, scope: !204)
!262 = !DILocation(line: 68, column: 10, scope: !204)
!263 = !DILocation(line: 68, column: 5, scope: !204)
!264 = !DILocation(line: 69, column: 14, scope: !204)
!265 = !DILocation(line: 69, column: 10, scope: !204)
!266 = !DILocation(line: 69, column: 5, scope: !204)
!267 = !DILocation(line: 71, column: 5, scope: !204)
