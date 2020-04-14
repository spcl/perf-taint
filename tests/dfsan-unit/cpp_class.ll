; RUN: opt %dfsan -S < %s 2> /dev/null | llc %llcparams - -o %t1 && clang++ %link %t1 -o %t2 && %execparams %t2 10 10 10 | diff -w %s.json -
; ModuleID = 'tests/dfsan-unit/cpp_class.cpp'
source_filename = "tests/dfsan-unit/cpp_class.cpp"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%class.Grid = type { i32, i32, i32, double* }

$_Z17register_variableIiEvPT_PKc = comdat any

$_ZN4GridC2Eiii = comdat any

$_ZN4Grid11update_gridEd = comdat any

$_ZN4Grid15update_constantEd = comdat any

$_ZN4Grid11update_dataEd = comdat any

$_ZN4Grid8update_zEd = comdat any

$_ZN4GridD2Ev = comdat any

@.str = private unnamed_addr constant [7 x i8] c"extrap\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [31 x i8] c"tests/dfsan-unit/cpp_class.cpp\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [7 x i8] c"size_x\00", align 1
@.str.3 = private unnamed_addr constant [7 x i8] c"size_y\00", align 1

; Function Attrs: norecurse uwtable
define dso_local i32 @main(i32, i8**) #0 personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) !dbg !293 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca %class.Grid*, align 8
  %10 = alloca i8*
  %11 = alloca i32
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4, !tbaa !324
  call void @llvm.dbg.declare(metadata i32* %4, metadata !297, metadata !DIExpression()), !dbg !328
  store i8** %1, i8*** %5, align 8, !tbaa !329
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !298, metadata !DIExpression()), !dbg !331
  %12 = bitcast i32* %6 to i8*, !dbg !332
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %12) #3, !dbg !332
  call void @llvm.dbg.declare(metadata i32* %6, metadata !299, metadata !DIExpression()), !dbg !333
  %13 = bitcast i32* %6 to i8*, !dbg !332
  call void @llvm.var.annotation(i8* %13, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([31 x i8], [31 x i8]* @.str.1, i32 0, i32 0), i32 55), !dbg !332
  %14 = load i8**, i8*** %5, align 8, !dbg !334, !tbaa !329
  %15 = getelementptr inbounds i8*, i8** %14, i64 1, !dbg !334
  %16 = load i8*, i8** %15, align 8, !dbg !334, !tbaa !329
  %17 = call i32 @atoi(i8* %16) #11, !dbg !335
  store i32 %17, i32* %6, align 4, !dbg !333, !tbaa !324
  %18 = bitcast i32* %7 to i8*, !dbg !336
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %18) #3, !dbg !336
  call void @llvm.dbg.declare(metadata i32* %7, metadata !300, metadata !DIExpression()), !dbg !337
  %19 = bitcast i32* %7 to i8*, !dbg !336
  call void @llvm.var.annotation(i8* %19, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([31 x i8], [31 x i8]* @.str.1, i32 0, i32 0), i32 56), !dbg !336
  %20 = load i8**, i8*** %5, align 8, !dbg !338, !tbaa !329
  %21 = getelementptr inbounds i8*, i8** %20, i64 2, !dbg !338
  %22 = load i8*, i8** %21, align 8, !dbg !338, !tbaa !329
  %23 = call i32 @atoi(i8* %22) #11, !dbg !339
  store i32 %23, i32* %7, align 4, !dbg !337, !tbaa !324
  %24 = bitcast i32* %8 to i8*, !dbg !340
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %24) #3, !dbg !340
  call void @llvm.dbg.declare(metadata i32* %8, metadata !301, metadata !DIExpression()), !dbg !341
  %25 = bitcast i32* %8 to i8*, !dbg !340
  call void @llvm.var.annotation(i8* %25, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([31 x i8], [31 x i8]* @.str.1, i32 0, i32 0), i32 57), !dbg !340
  %26 = load i8**, i8*** %5, align 8, !dbg !342, !tbaa !329
  %27 = getelementptr inbounds i8*, i8** %26, i64 3, !dbg !342
  %28 = load i8*, i8** %27, align 8, !dbg !342, !tbaa !329
  %29 = call i32 @atoi(i8* %28) #11, !dbg !343
  store i32 %29, i32* %8, align 4, !dbg !341, !tbaa !324
  %30 = bitcast %class.Grid** %9 to i8*, !dbg !344
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %30) #3, !dbg !344
  call void @llvm.dbg.declare(metadata %class.Grid** %9, metadata !302, metadata !DIExpression()), !dbg !345
  call void @_Z17register_variableIiEvPT_PKc(i32* %6, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i64 0, i64 0)), !dbg !346
  call void @_Z17register_variableIiEvPT_PKc(i32* %7, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.3, i64 0, i64 0)), !dbg !347
  %31 = call i8* @_Znwm(i64 24) #12, !dbg !348
  %32 = bitcast i8* %31 to %class.Grid*, !dbg !348
  %33 = load i32, i32* %6, align 4, !dbg !349, !tbaa !324
  %34 = load i32, i32* %7, align 4, !dbg !350, !tbaa !324
  %35 = load i32, i32* %8, align 4, !dbg !351, !tbaa !324
  invoke void @_ZN4GridC2Eiii(%class.Grid* %32, i32 %33, i32 %34, i32 %35)
          to label %36 unwind label %50, !dbg !352

36:                                               ; preds = %2
  store %class.Grid* %32, %class.Grid** %9, align 8, !dbg !353, !tbaa !329
  %37 = load %class.Grid*, %class.Grid** %9, align 8, !dbg !354, !tbaa !329
  call void @_ZN4Grid11update_gridEd(%class.Grid* %37, double 2.000000e+00), !dbg !355
  %38 = load %class.Grid*, %class.Grid** %9, align 8, !dbg !356, !tbaa !329
  call void @_ZN4Grid15update_constantEd(%class.Grid* %38, double 1.500000e+00), !dbg !357
  %39 = load %class.Grid*, %class.Grid** %9, align 8, !dbg !358, !tbaa !329
  call void @_ZN4Grid11update_dataEd(%class.Grid* %39, double 1.500000e+00), !dbg !359
  %40 = load %class.Grid*, %class.Grid** %9, align 8, !dbg !360, !tbaa !329
  call void @_ZN4Grid8update_zEd(%class.Grid* %40, double 1.500000e+00), !dbg !361
  %41 = load %class.Grid*, %class.Grid** %9, align 8, !dbg !362, !tbaa !329
  %42 = icmp eq %class.Grid* %41, null, !dbg !363
  br i1 %42, label %45, label %43, !dbg !363

43:                                               ; preds = %36
  call void @_ZN4GridD2Ev(%class.Grid* %41) #3, !dbg !363
  %44 = bitcast %class.Grid* %41 to i8*, !dbg !363
  call void @_ZdlPv(i8* %44) #13, !dbg !363
  br label %45, !dbg !363

45:                                               ; preds = %43, %36
  %46 = bitcast %class.Grid** %9 to i8*, !dbg !364
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %46) #3, !dbg !364
  %47 = bitcast i32* %8 to i8*, !dbg !364
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %47) #3, !dbg !364
  %48 = bitcast i32* %7 to i8*, !dbg !364
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %48) #3, !dbg !364
  %49 = bitcast i32* %6 to i8*, !dbg !364
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %49) #3, !dbg !364
  ret i32 0, !dbg !365

50:                                               ; preds = %2
  %51 = landingpad { i8*, i32 }
          cleanup, !dbg !364
  %52 = extractvalue { i8*, i32 } %51, 0, !dbg !364
  store i8* %52, i8** %10, align 8, !dbg !364
  %53 = extractvalue { i8*, i32 } %51, 1, !dbg !364
  store i32 %53, i32* %11, align 4, !dbg !364
  call void @_ZdlPv(i8* %31) #13, !dbg !348
  %54 = bitcast %class.Grid** %9 to i8*, !dbg !364
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %54) #3, !dbg !364
  %55 = bitcast i32* %8 to i8*, !dbg !364
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %55) #3, !dbg !364
  %56 = bitcast i32* %7 to i8*, !dbg !364
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %56) #3, !dbg !364
  %57 = bitcast i32* %6 to i8*, !dbg !364
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %57) #3, !dbg !364
  br label %58, !dbg !364

58:                                               ; preds = %50
  %59 = load i8*, i8** %10, align 8, !dbg !364
  %60 = load i32, i32* %11, align 4, !dbg !364
  %61 = insertvalue { i8*, i32 } undef, i8* %59, 0, !dbg !364
  %62 = insertvalue { i8*, i32 } %61, i32 %60, 1, !dbg !364
  resume { i8*, i32 } %62, !dbg !364
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: nounwind
declare void @llvm.var.annotation(i8*, i8*, i8*, i32) #3

; Function Attrs: inlinehint nounwind readonly uwtable
define available_externally dso_local i32 @atoi(i8* nonnull) #4 !dbg !128 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8, !tbaa !329
  call void @llvm.dbg.declare(metadata i8** %2, metadata !132, metadata !DIExpression()), !dbg !366
  %3 = load i8*, i8** %2, align 8, !dbg !367, !tbaa !329
  %4 = call i64 @strtol(i8* %3, i8** null, i32 10) #3, !dbg !368
  %5 = trunc i64 %4 to i32, !dbg !368
  ret i32 %5, !dbg !369
}

; Function Attrs: uwtable
define linkonce_odr dso_local void @_Z17register_variableIiEvPT_PKc(i32*, i8*) #5 comdat !dbg !370 {
  %3 = alloca i32*, align 8
  %4 = alloca i8*, align 8
  store i32* %0, i32** %3, align 8, !tbaa !329
  call void @llvm.dbg.declare(metadata i32** %3, metadata !376, metadata !DIExpression()), !dbg !380
  store i8* %1, i8** %4, align 8, !tbaa !329
  call void @llvm.dbg.declare(metadata i8** %4, metadata !377, metadata !DIExpression()), !dbg !381
  %5 = load i32*, i32** %3, align 8, !dbg !382, !tbaa !329
  %6 = bitcast i32* %5 to i8*, !dbg !383
  %7 = load i8*, i8** %4, align 8, !dbg !384, !tbaa !329
  call void @__dfsw_EXTRAP_WRITE_LABEL(i8* %6, i32 4, i8* %7), !dbg !385
  ret void, !dbg !386
}

; Function Attrs: nobuiltin
declare dso_local noalias i8* @_Znwm(i64) #6

; Function Attrs: uwtable
define linkonce_odr dso_local void @_ZN4GridC2Eiii(%class.Grid*, i32, i32, i32) unnamed_addr #5 comdat align 2 !dbg !387 {
  %5 = alloca %class.Grid*, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store %class.Grid* %0, %class.Grid** %5, align 8, !tbaa !329
  call void @llvm.dbg.declare(metadata %class.Grid** %5, metadata !389, metadata !DIExpression()), !dbg !393
  store i32 %1, i32* %6, align 4, !tbaa !324
  call void @llvm.dbg.declare(metadata i32* %6, metadata !390, metadata !DIExpression()), !dbg !394
  store i32 %2, i32* %7, align 4, !tbaa !324
  call void @llvm.dbg.declare(metadata i32* %7, metadata !391, metadata !DIExpression()), !dbg !395
  store i32 %3, i32* %8, align 4, !tbaa !324
  call void @llvm.dbg.declare(metadata i32* %8, metadata !392, metadata !DIExpression()), !dbg !396
  %9 = load %class.Grid*, %class.Grid** %5, align 8
  %10 = getelementptr inbounds %class.Grid, %class.Grid* %9, i32 0, i32 0, !dbg !397
  %11 = load i32, i32* %6, align 4, !dbg !398, !tbaa !324
  store i32 %11, i32* %10, align 8, !dbg !397, !tbaa !399
  %12 = getelementptr inbounds %class.Grid, %class.Grid* %9, i32 0, i32 1, !dbg !401
  %13 = load i32, i32* %7, align 4, !dbg !402, !tbaa !324
  store i32 %13, i32* %12, align 4, !dbg !401, !tbaa !403
  %14 = getelementptr inbounds %class.Grid, %class.Grid* %9, i32 0, i32 2, !dbg !404
  %15 = load i32, i32* %8, align 4, !dbg !405, !tbaa !324
  store i32 %15, i32* %14, align 8, !dbg !404, !tbaa !406
  %16 = getelementptr inbounds %class.Grid, %class.Grid* %9, i32 0, i32 3, !dbg !407
  %17 = getelementptr inbounds %class.Grid, %class.Grid* %9, i32 0, i32 0, !dbg !408
  %18 = load i32, i32* %17, align 8, !dbg !408, !tbaa !399
  %19 = getelementptr inbounds %class.Grid, %class.Grid* %9, i32 0, i32 1, !dbg !409
  %20 = load i32, i32* %19, align 4, !dbg !409, !tbaa !403
  %21 = mul nsw i32 %18, %20, !dbg !410
  %22 = sext i32 %21 to i64, !dbg !408
  %23 = call { i64, i1 } @llvm.umul.with.overflow.i64(i64 %22, i64 8), !dbg !411
  %24 = extractvalue { i64, i1 } %23, 1, !dbg !411
  %25 = extractvalue { i64, i1 } %23, 0, !dbg !411
  %26 = select i1 %24, i64 -1, i64 %25, !dbg !411
  %27 = call i8* @_Znam(i64 %26) #12, !dbg !411
  %28 = bitcast i8* %27 to double*, !dbg !411
  %29 = bitcast double* %28 to i8*, !dbg !411
  call void @llvm.memset.p0i8.i64(i8* align 8 %29, i8 0, i64 %26, i1 false), !dbg !411
  store double* %28, double** %16, align 8, !dbg !407, !tbaa !412
  ret void, !dbg !413
}

declare dso_local i32 @__gxx_personality_v0(...)

; Function Attrs: nobuiltin nounwind
declare dso_local void @_ZdlPv(i8*) #7

; Function Attrs: nounwind uwtable
define linkonce_odr dso_local void @_ZN4Grid11update_gridEd(%class.Grid*, double) #8 comdat align 2 !dbg !414 {
  %3 = alloca %class.Grid*, align 8
  %4 = alloca double, align 8
  %5 = alloca i32, align 4
  store %class.Grid* %0, %class.Grid** %3, align 8, !tbaa !329
  call void @llvm.dbg.declare(metadata %class.Grid** %3, metadata !416, metadata !DIExpression()), !dbg !420
  store double %1, double* %4, align 8, !tbaa !421
  call void @llvm.dbg.declare(metadata double* %4, metadata !417, metadata !DIExpression()), !dbg !423
  %6 = load %class.Grid*, %class.Grid** %3, align 8
  %7 = bitcast i32* %5 to i8*, !dbg !424
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %7) #3, !dbg !424
  call void @llvm.dbg.declare(metadata i32* %5, metadata !418, metadata !DIExpression()), !dbg !425
  store i32 0, i32* %5, align 4, !dbg !425, !tbaa !324
  br label %8, !dbg !424

8:                                                ; preds = %27, %2
  %9 = load i32, i32* %5, align 4, !dbg !426, !tbaa !324
  %10 = getelementptr inbounds %class.Grid, %class.Grid* %6, i32 0, i32 0, !dbg !428
  %11 = load i32, i32* %10, align 8, !dbg !428, !tbaa !399
  %12 = getelementptr inbounds %class.Grid, %class.Grid* %6, i32 0, i32 1, !dbg !429
  %13 = load i32, i32* %12, align 4, !dbg !429, !tbaa !403
  %14 = mul nsw i32 %11, %13, !dbg !430
  %15 = icmp slt i32 %9, %14, !dbg !431
  br i1 %15, label %18, label %16, !dbg !432

16:                                               ; preds = %8
  %17 = bitcast i32* %5 to i8*, !dbg !433
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %17) #3, !dbg !433
  br label %30

18:                                               ; preds = %8
  %19 = load double, double* %4, align 8, !dbg !434, !tbaa !421
  %20 = getelementptr inbounds %class.Grid, %class.Grid* %6, i32 0, i32 3, !dbg !435
  %21 = load double*, double** %20, align 8, !dbg !435, !tbaa !412
  %22 = load i32, i32* %5, align 4, !dbg !436, !tbaa !324
  %23 = sext i32 %22 to i64, !dbg !435
  %24 = getelementptr inbounds double, double* %21, i64 %23, !dbg !435
  %25 = load double, double* %24, align 8, !dbg !437, !tbaa !421
  %26 = fadd double %25, %19, !dbg !437
  store double %26, double* %24, align 8, !dbg !437, !tbaa !421
  br label %27, !dbg !435

27:                                               ; preds = %18
  %28 = load i32, i32* %5, align 4, !dbg !438, !tbaa !324
  %29 = add nsw i32 %28, 1, !dbg !438
  store i32 %29, i32* %5, align 4, !dbg !438, !tbaa !324
  br label %8, !dbg !433, !llvm.loop !439

30:                                               ; preds = %16
  ret void, !dbg !441
}

; Function Attrs: nounwind uwtable
define linkonce_odr dso_local void @_ZN4Grid15update_constantEd(%class.Grid*, double) #8 comdat align 2 !dbg !442 {
  %3 = alloca %class.Grid*, align 8
  %4 = alloca double, align 8
  %5 = alloca i32, align 4
  store %class.Grid* %0, %class.Grid** %3, align 8, !tbaa !329
  call void @llvm.dbg.declare(metadata %class.Grid** %3, metadata !444, metadata !DIExpression()), !dbg !448
  store double %1, double* %4, align 8, !tbaa !421
  call void @llvm.dbg.declare(metadata double* %4, metadata !445, metadata !DIExpression()), !dbg !449
  %6 = load %class.Grid*, %class.Grid** %3, align 8
  %7 = load double, double* %4, align 8, !dbg !450, !tbaa !421
  %8 = fmul double 2.000000e+00, %7, !dbg !451
  %9 = getelementptr inbounds %class.Grid, %class.Grid* %6, i32 0, i32 3, !dbg !452
  %10 = load double*, double** %9, align 8, !dbg !452, !tbaa !412
  %11 = getelementptr inbounds double, double* %10, i64 0, !dbg !452
  %12 = load double, double* %11, align 8, !dbg !453, !tbaa !421
  %13 = fadd double %12, %8, !dbg !453
  store double %13, double* %11, align 8, !dbg !453, !tbaa !421
  %14 = bitcast i32* %5 to i8*, !dbg !454
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %14) #3, !dbg !454
  call void @llvm.dbg.declare(metadata i32* %5, metadata !446, metadata !DIExpression()), !dbg !455
  store i32 1, i32* %5, align 4, !dbg !455, !tbaa !324
  br label %15, !dbg !454

15:                                               ; preds = %29, %2
  %16 = load i32, i32* %5, align 4, !dbg !456, !tbaa !324
  %17 = icmp slt i32 %16, 5, !dbg !458
  br i1 %17, label %20, label %18, !dbg !459

18:                                               ; preds = %15
  %19 = bitcast i32* %5 to i8*, !dbg !460
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %19) #3, !dbg !460
  br label %32

20:                                               ; preds = %15
  %21 = load double, double* %4, align 8, !dbg !461, !tbaa !421
  %22 = getelementptr inbounds %class.Grid, %class.Grid* %6, i32 0, i32 3, !dbg !462
  %23 = load double*, double** %22, align 8, !dbg !462, !tbaa !412
  %24 = load i32, i32* %5, align 4, !dbg !463, !tbaa !324
  %25 = sext i32 %24 to i64, !dbg !462
  %26 = getelementptr inbounds double, double* %23, i64 %25, !dbg !462
  %27 = load double, double* %26, align 8, !dbg !464, !tbaa !421
  %28 = fadd double %27, %21, !dbg !464
  store double %28, double* %26, align 8, !dbg !464, !tbaa !421
  br label %29, !dbg !462

29:                                               ; preds = %20
  %30 = load i32, i32* %5, align 4, !dbg !465, !tbaa !324
  %31 = add nsw i32 %30, 1, !dbg !465
  store i32 %31, i32* %5, align 4, !dbg !465, !tbaa !324
  br label %15, !dbg !460, !llvm.loop !466

32:                                               ; preds = %18
  ret void, !dbg !468
}

; Function Attrs: nounwind uwtable
define linkonce_odr dso_local void @_ZN4Grid11update_dataEd(%class.Grid*, double) #8 comdat align 2 !dbg !469 {
  %3 = alloca %class.Grid*, align 8
  %4 = alloca double, align 8
  %5 = alloca i32, align 4
  store %class.Grid* %0, %class.Grid** %3, align 8, !tbaa !329
  call void @llvm.dbg.declare(metadata %class.Grid** %3, metadata !471, metadata !DIExpression()), !dbg !475
  store double %1, double* %4, align 8, !tbaa !421
  call void @llvm.dbg.declare(metadata double* %4, metadata !472, metadata !DIExpression()), !dbg !476
  %6 = load %class.Grid*, %class.Grid** %3, align 8
  %7 = load double, double* %4, align 8, !dbg !477, !tbaa !421
  %8 = fmul double 2.000000e+00, %7, !dbg !478
  %9 = getelementptr inbounds %class.Grid, %class.Grid* %6, i32 0, i32 3, !dbg !479
  %10 = load double*, double** %9, align 8, !dbg !479, !tbaa !412
  %11 = getelementptr inbounds double, double* %10, i64 0, !dbg !479
  %12 = load double, double* %11, align 8, !dbg !480, !tbaa !421
  %13 = fadd double %12, %8, !dbg !480
  store double %13, double* %11, align 8, !dbg !480, !tbaa !421
  %14 = bitcast i32* %5 to i8*, !dbg !481
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %14) #3, !dbg !481
  call void @llvm.dbg.declare(metadata i32* %5, metadata !473, metadata !DIExpression()), !dbg !482
  %15 = getelementptr inbounds %class.Grid, %class.Grid* %6, i32 0, i32 3, !dbg !483
  %16 = load double*, double** %15, align 8, !dbg !483, !tbaa !412
  %17 = getelementptr inbounds double, double* %16, i64 0, !dbg !483
  %18 = load double, double* %17, align 8, !dbg !483, !tbaa !421
  %19 = fptosi double %18 to i32, !dbg !483
  store i32 %19, i32* %5, align 4, !dbg !482, !tbaa !324
  br label %20, !dbg !481

20:                                               ; preds = %34, %2
  %21 = load i32, i32* %5, align 4, !dbg !484, !tbaa !324
  %22 = icmp slt i32 %21, 5, !dbg !486
  br i1 %22, label %25, label %23, !dbg !487

23:                                               ; preds = %20
  %24 = bitcast i32* %5 to i8*, !dbg !488
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %24) #3, !dbg !488
  br label %37

25:                                               ; preds = %20
  %26 = load double, double* %4, align 8, !dbg !489, !tbaa !421
  %27 = getelementptr inbounds %class.Grid, %class.Grid* %6, i32 0, i32 3, !dbg !490
  %28 = load double*, double** %27, align 8, !dbg !490, !tbaa !412
  %29 = load i32, i32* %5, align 4, !dbg !491, !tbaa !324
  %30 = sext i32 %29 to i64, !dbg !490
  %31 = getelementptr inbounds double, double* %28, i64 %30, !dbg !490
  %32 = load double, double* %31, align 8, !dbg !492, !tbaa !421
  %33 = fadd double %32, %26, !dbg !492
  store double %33, double* %31, align 8, !dbg !492, !tbaa !421
  br label %34, !dbg !490

34:                                               ; preds = %25
  %35 = load i32, i32* %5, align 4, !dbg !493, !tbaa !324
  %36 = add nsw i32 %35, 1, !dbg !493
  store i32 %36, i32* %5, align 4, !dbg !493, !tbaa !324
  br label %20, !dbg !488, !llvm.loop !494

37:                                               ; preds = %23
  ret void, !dbg !496
}

; Function Attrs: nounwind uwtable
define linkonce_odr dso_local void @_ZN4Grid8update_zEd(%class.Grid*, double) #8 comdat align 2 !dbg !497 {
  %3 = alloca %class.Grid*, align 8
  %4 = alloca double, align 8
  %5 = alloca i32, align 4
  store %class.Grid* %0, %class.Grid** %3, align 8, !tbaa !329
  call void @llvm.dbg.declare(metadata %class.Grid** %3, metadata !499, metadata !DIExpression()), !dbg !503
  store double %1, double* %4, align 8, !tbaa !421
  call void @llvm.dbg.declare(metadata double* %4, metadata !500, metadata !DIExpression()), !dbg !504
  %6 = load %class.Grid*, %class.Grid** %3, align 8
  %7 = bitcast i32* %5 to i8*, !dbg !505
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %7) #3, !dbg !505
  call void @llvm.dbg.declare(metadata i32* %5, metadata !501, metadata !DIExpression()), !dbg !506
  store i32 0, i32* %5, align 4, !dbg !506, !tbaa !324
  br label %8, !dbg !505

8:                                                ; preds = %24, %2
  %9 = load i32, i32* %5, align 4, !dbg !507, !tbaa !324
  %10 = getelementptr inbounds %class.Grid, %class.Grid* %6, i32 0, i32 2, !dbg !509
  %11 = load i32, i32* %10, align 8, !dbg !509, !tbaa !406
  %12 = icmp slt i32 %9, %11, !dbg !510
  br i1 %12, label %15, label %13, !dbg !511

13:                                               ; preds = %8
  %14 = bitcast i32* %5 to i8*, !dbg !512
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %14) #3, !dbg !512
  br label %27

15:                                               ; preds = %8
  %16 = load double, double* %4, align 8, !dbg !513, !tbaa !421
  %17 = getelementptr inbounds %class.Grid, %class.Grid* %6, i32 0, i32 3, !dbg !514
  %18 = load double*, double** %17, align 8, !dbg !514, !tbaa !412
  %19 = load i32, i32* %5, align 4, !dbg !515, !tbaa !324
  %20 = sext i32 %19 to i64, !dbg !514
  %21 = getelementptr inbounds double, double* %18, i64 %20, !dbg !514
  %22 = load double, double* %21, align 8, !dbg !516, !tbaa !421
  %23 = fadd double %22, %16, !dbg !516
  store double %23, double* %21, align 8, !dbg !516, !tbaa !421
  br label %24, !dbg !514

24:                                               ; preds = %15
  %25 = load i32, i32* %5, align 4, !dbg !517, !tbaa !324
  %26 = add nsw i32 %25, 1, !dbg !517
  store i32 %26, i32* %5, align 4, !dbg !517, !tbaa !324
  br label %8, !dbg !512, !llvm.loop !518

27:                                               ; preds = %13
  ret void, !dbg !520
}

; Function Attrs: nounwind uwtable
define linkonce_odr dso_local void @_ZN4GridD2Ev(%class.Grid*) unnamed_addr #8 comdat align 2 !dbg !521 {
  %2 = alloca %class.Grid*, align 8
  store %class.Grid* %0, %class.Grid** %2, align 8, !tbaa !329
  call void @llvm.dbg.declare(metadata %class.Grid** %2, metadata !523, metadata !DIExpression()), !dbg !524
  %3 = load %class.Grid*, %class.Grid** %2, align 8
  %4 = getelementptr inbounds %class.Grid, %class.Grid* %3, i32 0, i32 3, !dbg !525
  %5 = load double*, double** %4, align 8, !dbg !525, !tbaa !412
  %6 = icmp eq double* %5, null, !dbg !527
  br i1 %6, label %9, label %7, !dbg !527

7:                                                ; preds = %1
  %8 = bitcast double* %5 to i8*, !dbg !527
  call void @_ZdaPv(i8* %8) #13, !dbg !527
  br label %9, !dbg !527

9:                                                ; preds = %7, %1
  ret void, !dbg !528
}

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: nounwind
declare dso_local i64 @strtol(i8*, i8**, i32) #9

; Function Attrs: nounwind readnone speculatable
declare { i64, i1 } @llvm.umul.with.overflow.i64(i64, i64) #1

; Function Attrs: nobuiltin
declare dso_local noalias i8* @_Znam(i64) #6

; Function Attrs: argmemonly nounwind
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #2

; Function Attrs: nobuiltin nounwind
declare dso_local void @_ZdaPv(i8*) #7

declare dso_local void @__dfsw_EXTRAP_WRITE_LABEL(i8*, i32, i8*) #10

attributes #0 = { norecurse uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { argmemonly nounwind }
attributes #3 = { nounwind }
attributes #4 = { inlinehint nounwind readonly uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #6 = { nobuiltin "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #7 = { nobuiltin nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #8 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #9 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #10 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #11 = { nounwind readonly }
attributes #12 = { builtin }
attributes #13 = { builtin nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!289, !290, !291}
!llvm.ident = !{!292}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !1, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !3, imports: !14, nameTableKind: None)
!1 = !DIFile(filename: "tests/dfsan-unit/cpp_class.cpp", directory: "/home/mcopik/projects/ETH/extrap/rebuild/perf-taint")
!2 = !{}
!3 = !{!4, !5, !8}
!4 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!5 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !6, size: 64)
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!7 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!8 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !9, size: 64)
!9 = !DIDerivedType(tag: DW_TAG_typedef, name: "int8_t", file: !10, line: 24, baseType: !11)
!10 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-intn.h", directory: "")
!11 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int8_t", file: !12, line: 36, baseType: !13)
!12 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "")
!13 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!14 = !{!15, !19, !23, !26, !30, !35, !39, !43, !47, !50, !52, !54, !56, !58, !60, !62, !64, !66, !68, !70, !72, !74, !76, !78, !80, !82, !84, !87, !90, !94, !96, !100, !102, !106, !112, !119, !127, !133, !137, !141, !147, !152, !157, !161, !165, !169, !174, !178, !182, !187, !191, !195, !199, !203, !208, !212, !214, !218, !220, !231, !235, !240, !244, !248, !252, !256, !258, !262, !269, !273, !277, !285, !287}
!15 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !9, file: !18, line: 152)
!16 = !DINamespace(name: "__1", scope: !17, exportSymbols: true)
!17 = !DINamespace(name: "std", scope: null)
!18 = !DIFile(filename: "build_tool/../usr/include/c++/v1/cstdint", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!19 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !20, file: !18, line: 153)
!20 = !DIDerivedType(tag: DW_TAG_typedef, name: "int16_t", file: !10, line: 25, baseType: !21)
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int16_t", file: !12, line: 38, baseType: !22)
!22 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!23 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !24, file: !18, line: 154)
!24 = !DIDerivedType(tag: DW_TAG_typedef, name: "int32_t", file: !10, line: 26, baseType: !25)
!25 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int32_t", file: !12, line: 40, baseType: !4)
!26 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !27, file: !18, line: 155)
!27 = !DIDerivedType(tag: DW_TAG_typedef, name: "int64_t", file: !10, line: 27, baseType: !28)
!28 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int64_t", file: !12, line: 43, baseType: !29)
!29 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!30 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !31, file: !18, line: 157)
!31 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint8_t", file: !32, line: 24, baseType: !33)
!32 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "")
!33 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint8_t", file: !12, line: 37, baseType: !34)
!34 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!35 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !36, file: !18, line: 158)
!36 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint16_t", file: !32, line: 25, baseType: !37)
!37 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint16_t", file: !12, line: 39, baseType: !38)
!38 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!39 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !40, file: !18, line: 159)
!40 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !32, line: 26, baseType: !41)
!41 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !12, line: 41, baseType: !42)
!42 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!43 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !44, file: !18, line: 160)
!44 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", file: !32, line: 27, baseType: !45)
!45 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint64_t", file: !12, line: 44, baseType: !46)
!46 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!47 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !48, file: !18, line: 162)
!48 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least8_t", file: !49, line: 43, baseType: !13)
!49 = !DIFile(filename: "/usr/include/stdint.h", directory: "")
!50 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !51, file: !18, line: 163)
!51 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least16_t", file: !49, line: 44, baseType: !22)
!52 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !53, file: !18, line: 164)
!53 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least32_t", file: !49, line: 45, baseType: !4)
!54 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !55, file: !18, line: 165)
!55 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least64_t", file: !49, line: 47, baseType: !29)
!56 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !57, file: !18, line: 167)
!57 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least8_t", file: !49, line: 54, baseType: !34)
!58 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !59, file: !18, line: 168)
!59 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least16_t", file: !49, line: 55, baseType: !38)
!60 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !61, file: !18, line: 169)
!61 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least32_t", file: !49, line: 56, baseType: !42)
!62 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !63, file: !18, line: 170)
!63 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least64_t", file: !49, line: 58, baseType: !46)
!64 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !65, file: !18, line: 172)
!65 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast8_t", file: !49, line: 68, baseType: !13)
!66 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !67, file: !18, line: 173)
!67 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast16_t", file: !49, line: 70, baseType: !29)
!68 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !69, file: !18, line: 174)
!69 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast32_t", file: !49, line: 71, baseType: !29)
!70 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !71, file: !18, line: 175)
!71 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast64_t", file: !49, line: 72, baseType: !29)
!72 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !73, file: !18, line: 177)
!73 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast8_t", file: !49, line: 81, baseType: !34)
!74 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !75, file: !18, line: 178)
!75 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast16_t", file: !49, line: 83, baseType: !46)
!76 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !77, file: !18, line: 179)
!77 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast32_t", file: !49, line: 84, baseType: !46)
!78 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !79, file: !18, line: 180)
!79 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast64_t", file: !49, line: 85, baseType: !46)
!80 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !81, file: !18, line: 182)
!81 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !49, line: 97, baseType: !29)
!82 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !83, file: !18, line: 183)
!83 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !49, line: 100, baseType: !46)
!84 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !85, file: !18, line: 185)
!85 = !DIDerivedType(tag: DW_TAG_typedef, name: "intmax_t", file: !49, line: 111, baseType: !86)
!86 = !DIDerivedType(tag: DW_TAG_typedef, name: "__intmax_t", file: !12, line: 61, baseType: !29)
!87 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !88, file: !18, line: 186)
!88 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintmax_t", file: !49, line: 112, baseType: !89)
!89 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uintmax_t", file: !12, line: 62, baseType: !46)
!90 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !91, file: !93, line: 49)
!91 = !DIDerivedType(tag: DW_TAG_typedef, name: "ptrdiff_t", file: !92, line: 35, baseType: !29)
!92 = !DIFile(filename: "clang_llvm/llvm-9.0/build-9.0/lib/clang/9.0.0/include/stddef.h", directory: "/home/mcopik/projects")
!93 = !DIFile(filename: "build_tool/../usr/include/c++/v1/cstddef", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!94 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !95, file: !93, line: 50)
!95 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !92, line: 46, baseType: !46)
!96 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !97, file: !93, line: 55)
!97 = !DIDerivedType(tag: DW_TAG_typedef, name: "max_align_t", file: !98, line: 24, baseType: !99)
!98 = !DIFile(filename: "clang_llvm/llvm-9.0/build-9.0/lib/clang/9.0.0/include/__stddef_max_align_t.h", directory: "/home/mcopik/projects")
!99 = !DICompositeType(tag: DW_TAG_structure_type, file: !98, line: 19, flags: DIFlagFwdDecl, identifier: "_ZTS11max_align_t")
!100 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !95, file: !101, line: 99)
!101 = !DIFile(filename: "build_tool/../usr/include/c++/v1/cstdlib", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!102 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !103, file: !101, line: 100)
!103 = !DIDerivedType(tag: DW_TAG_typedef, name: "div_t", file: !104, line: 62, baseType: !105)
!104 = !DIFile(filename: "/usr/include/stdlib.h", directory: "")
!105 = !DICompositeType(tag: DW_TAG_structure_type, file: !104, line: 58, flags: DIFlagFwdDecl, identifier: "_ZTS5div_t")
!106 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !107, file: !101, line: 101)
!107 = !DIDerivedType(tag: DW_TAG_typedef, name: "ldiv_t", file: !104, line: 70, baseType: !108)
!108 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !104, line: 66, size: 128, flags: DIFlagTypePassByValue, elements: !109, identifier: "_ZTS6ldiv_t")
!109 = !{!110, !111}
!110 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !108, file: !104, line: 68, baseType: !29, size: 64)
!111 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !108, file: !104, line: 69, baseType: !29, size: 64, offset: 64)
!112 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !113, file: !101, line: 103)
!113 = !DIDerivedType(tag: DW_TAG_typedef, name: "lldiv_t", file: !104, line: 80, baseType: !114)
!114 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !104, line: 76, size: 128, flags: DIFlagTypePassByValue, elements: !115, identifier: "_ZTS7lldiv_t")
!115 = !{!116, !118}
!116 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !114, file: !104, line: 78, baseType: !117, size: 64)
!117 = !DIBasicType(name: "long long int", size: 64, encoding: DW_ATE_signed)
!118 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !114, file: !104, line: 79, baseType: !117, size: 64, offset: 64)
!119 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !120, file: !101, line: 105)
!120 = !DISubprogram(name: "atof", scope: !121, file: !121, line: 25, type: !122, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!121 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdlib-float.h", directory: "")
!122 = !DISubroutineType(types: !123)
!123 = !{!124, !125}
!124 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!125 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !126, size: 64)
!126 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !7)
!127 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !128, file: !101, line: 106)
!128 = distinct !DISubprogram(name: "atoi", scope: !104, file: !104, line: 361, type: !129, scopeLine: 362, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !131)
!129 = !DISubroutineType(types: !130)
!130 = !{!4, !125}
!131 = !{!132}
!132 = !DILocalVariable(name: "__nptr", arg: 1, scope: !128, file: !104, line: 361, type: !125)
!133 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !134, file: !101, line: 107)
!134 = !DISubprogram(name: "atol", scope: !104, file: !104, line: 366, type: !135, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!135 = !DISubroutineType(types: !136)
!136 = !{!29, !125}
!137 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !138, file: !101, line: 109)
!138 = !DISubprogram(name: "atoll", scope: !104, file: !104, line: 373, type: !139, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!139 = !DISubroutineType(types: !140)
!140 = !{!117, !125}
!141 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !142, file: !101, line: 111)
!142 = !DISubprogram(name: "strtod", scope: !104, file: !104, line: 117, type: !143, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!143 = !DISubroutineType(types: !144)
!144 = !{!124, !145, !146}
!145 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !125)
!146 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !5)
!147 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !148, file: !101, line: 112)
!148 = !DISubprogram(name: "strtof", scope: !104, file: !104, line: 123, type: !149, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!149 = !DISubroutineType(types: !150)
!150 = !{!151, !145, !146}
!151 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!152 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !153, file: !101, line: 113)
!153 = !DISubprogram(name: "strtold", scope: !104, file: !104, line: 126, type: !154, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!154 = !DISubroutineType(types: !155)
!155 = !{!156, !145, !146}
!156 = !DIBasicType(name: "long double", size: 128, encoding: DW_ATE_float)
!157 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !158, file: !101, line: 114)
!158 = !DISubprogram(name: "strtol", scope: !104, file: !104, line: 176, type: !159, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!159 = !DISubroutineType(types: !160)
!160 = !{!29, !145, !146, !4}
!161 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !162, file: !101, line: 116)
!162 = !DISubprogram(name: "strtoll", scope: !104, file: !104, line: 200, type: !163, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!163 = !DISubroutineType(types: !164)
!164 = !{!117, !145, !146, !4}
!165 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !166, file: !101, line: 118)
!166 = !DISubprogram(name: "strtoul", scope: !104, file: !104, line: 180, type: !167, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!167 = !DISubroutineType(types: !168)
!168 = !{!46, !145, !146, !4}
!169 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !170, file: !101, line: 120)
!170 = !DISubprogram(name: "strtoull", scope: !104, file: !104, line: 205, type: !171, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!171 = !DISubroutineType(types: !172)
!172 = !{!173, !145, !146, !4}
!173 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!174 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !175, file: !101, line: 122)
!175 = !DISubprogram(name: "rand", scope: !104, file: !104, line: 453, type: !176, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!176 = !DISubroutineType(types: !177)
!177 = !{!4}
!178 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !179, file: !101, line: 123)
!179 = !DISubprogram(name: "srand", scope: !104, file: !104, line: 455, type: !180, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!180 = !DISubroutineType(types: !181)
!181 = !{null, !42}
!182 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !183, file: !101, line: 124)
!183 = !DISubprogram(name: "calloc", scope: !104, file: !104, line: 541, type: !184, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!184 = !DISubroutineType(types: !185)
!185 = !{!186, !95, !95}
!186 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!187 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !188, file: !101, line: 125)
!188 = !DISubprogram(name: "free", scope: !104, file: !104, line: 563, type: !189, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!189 = !DISubroutineType(types: !190)
!190 = !{null, !186}
!191 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !192, file: !101, line: 126)
!192 = !DISubprogram(name: "malloc", scope: !104, file: !104, line: 539, type: !193, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!193 = !DISubroutineType(types: !194)
!194 = !{!186, !95}
!195 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !196, file: !101, line: 127)
!196 = !DISubprogram(name: "realloc", scope: !104, file: !104, line: 549, type: !197, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!197 = !DISubroutineType(types: !198)
!198 = !{!186, !186, !95}
!199 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !200, file: !101, line: 128)
!200 = !DISubprogram(name: "abort", scope: !104, file: !104, line: 588, type: !201, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!201 = !DISubroutineType(types: !202)
!202 = !{null}
!203 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !204, file: !101, line: 129)
!204 = !DISubprogram(name: "atexit", scope: !104, file: !104, line: 592, type: !205, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!205 = !DISubroutineType(types: !206)
!206 = !{!4, !207}
!207 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !201, size: 64)
!208 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !209, file: !101, line: 130)
!209 = !DISubprogram(name: "exit", scope: !104, file: !104, line: 614, type: !210, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!210 = !DISubroutineType(types: !211)
!211 = !{null, !4}
!212 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !213, file: !101, line: 131)
!213 = !DISubprogram(name: "_Exit", scope: !104, file: !104, line: 626, type: !210, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!214 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !215, file: !101, line: 133)
!215 = !DISubprogram(name: "getenv", scope: !104, file: !104, line: 631, type: !216, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!216 = !DISubroutineType(types: !217)
!217 = !{!6, !125}
!218 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !219, file: !101, line: 134)
!219 = !DISubprogram(name: "system", scope: !104, file: !104, line: 781, type: !129, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!220 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !221, file: !101, line: 136)
!221 = !DISubprogram(name: "bsearch", scope: !222, file: !222, line: 20, type: !223, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!222 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdlib-bsearch.h", directory: "")
!223 = !DISubroutineType(types: !224)
!224 = !{!186, !225, !225, !95, !95, !227}
!225 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !226, size: 64)
!226 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!227 = !DIDerivedType(tag: DW_TAG_typedef, name: "__compar_fn_t", file: !104, line: 805, baseType: !228)
!228 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !229, size: 64)
!229 = !DISubroutineType(types: !230)
!230 = !{!4, !225, !225}
!231 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !232, file: !101, line: 137)
!232 = !DISubprogram(name: "qsort", scope: !104, file: !104, line: 827, type: !233, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!233 = !DISubroutineType(types: !234)
!234 = !{null, !186, !95, !95, !227}
!235 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !236, file: !101, line: 138)
!236 = !DISubprogram(name: "abs", linkageName: "_Z3abse", scope: !237, file: !237, line: 789, type: !238, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!237 = !DIFile(filename: "build_tool/../usr/include/c++/v1/math.h", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!238 = !DISubroutineType(types: !239)
!239 = !{!156, !156}
!240 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !241, file: !101, line: 139)
!241 = !DISubprogram(name: "labs", scope: !104, file: !104, line: 838, type: !242, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!242 = !DISubroutineType(types: !243)
!243 = !{!29, !29}
!244 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !245, file: !101, line: 141)
!245 = !DISubprogram(name: "llabs", scope: !104, file: !104, line: 841, type: !246, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!246 = !DISubroutineType(types: !247)
!247 = !{!117, !117}
!248 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !249, file: !101, line: 143)
!249 = !DISubprogram(name: "div", linkageName: "_Z3divxx", scope: !237, file: !237, line: 808, type: !250, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!250 = !DISubroutineType(types: !251)
!251 = !{!113, !117, !117}
!252 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !253, file: !101, line: 144)
!253 = !DISubprogram(name: "ldiv", scope: !104, file: !104, line: 851, type: !254, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!254 = !DISubroutineType(types: !255)
!255 = !{!107, !29, !29}
!256 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !257, file: !101, line: 146)
!257 = !DISubprogram(name: "lldiv", scope: !104, file: !104, line: 855, type: !250, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!258 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !259, file: !101, line: 148)
!259 = !DISubprogram(name: "mblen", scope: !104, file: !104, line: 919, type: !260, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!260 = !DISubroutineType(types: !261)
!261 = !{!4, !125, !95}
!262 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !263, file: !101, line: 149)
!263 = !DISubprogram(name: "mbtowc", scope: !104, file: !104, line: 922, type: !264, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!264 = !DISubroutineType(types: !265)
!265 = !{!4, !266, !145, !95}
!266 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !267)
!267 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !268, size: 64)
!268 = !DIBasicType(name: "wchar_t", size: 32, encoding: DW_ATE_signed)
!269 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !270, file: !101, line: 150)
!270 = !DISubprogram(name: "wctomb", scope: !104, file: !104, line: 926, type: !271, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!271 = !DISubroutineType(types: !272)
!272 = !{!4, !6, !268}
!273 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !274, file: !101, line: 151)
!274 = !DISubprogram(name: "mbstowcs", scope: !104, file: !104, line: 930, type: !275, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!275 = !DISubroutineType(types: !276)
!276 = !{!95, !266, !145, !95}
!277 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !278, file: !101, line: 152)
!278 = !DISubprogram(name: "wcstombs", scope: !104, file: !104, line: 933, type: !279, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!279 = !DISubroutineType(types: !280)
!280 = !{!95, !281, !282, !95}
!281 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !6)
!282 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !283)
!283 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !284, size: 64)
!284 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !268)
!285 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !286, file: !101, line: 154)
!286 = !DISubprogram(name: "at_quick_exit", scope: !104, file: !104, line: 597, type: !205, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!287 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !288, file: !101, line: 155)
!288 = !DISubprogram(name: "quick_exit", scope: !104, file: !104, line: 620, type: !210, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!289 = !{i32 2, !"Dwarf Version", i32 4}
!290 = !{i32 2, !"Debug Info Version", i32 3}
!291 = !{i32 1, !"wchar_size", i32 4}
!292 = !{!"clang version 9.0.0 (tags/RELEASE_900/final)"}
!293 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 53, type: !294, scopeLine: 54, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !296)
!294 = !DISubroutineType(types: !295)
!295 = !{!4, !4, !5}
!296 = !{!297, !298, !299, !300, !301, !302}
!297 = !DILocalVariable(name: "argc", arg: 1, scope: !293, file: !1, line: 53, type: !4)
!298 = !DILocalVariable(name: "argv", arg: 2, scope: !293, file: !1, line: 53, type: !5)
!299 = !DILocalVariable(name: "size_x", scope: !293, file: !1, line: 55, type: !4)
!300 = !DILocalVariable(name: "size_y", scope: !293, file: !1, line: 56, type: !4)
!301 = !DILocalVariable(name: "size_z", scope: !293, file: !1, line: 57, type: !4)
!302 = !DILocalVariable(name: "g", scope: !293, file: !1, line: 59, type: !303)
!303 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !304, size: 64)
!304 = distinct !DICompositeType(tag: DW_TAG_class_type, name: "Grid", file: !1, line: 6, size: 192, flags: DIFlagTypePassByReference | DIFlagNonTrivial, elements: !305, identifier: "_ZTS4Grid")
!305 = !{!306, !307, !308, !309, !311, !315, !318, !321, !322, !323}
!306 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !304, file: !1, line: 8, baseType: !4, size: 32)
!307 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !304, file: !1, line: 8, baseType: !4, size: 32, offset: 32)
!308 = !DIDerivedType(tag: DW_TAG_member, name: "z", scope: !304, file: !1, line: 8, baseType: !4, size: 32, offset: 64)
!309 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !304, file: !1, line: 9, baseType: !310, size: 64, offset: 128)
!310 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !124, size: 64)
!311 = !DISubprogram(name: "Grid", scope: !304, file: !1, line: 11, type: !312, scopeLine: 11, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!312 = !DISubroutineType(types: !313)
!313 = !{null, !314, !4, !4, !4}
!314 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !304, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!315 = !DISubprogram(name: "~Grid", scope: !304, file: !1, line: 17, type: !316, scopeLine: 17, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!316 = !DISubroutineType(types: !317)
!317 = !{null, !314}
!318 = !DISubprogram(name: "update_grid", linkageName: "_ZN4Grid11update_gridEd", scope: !304, file: !1, line: 23, type: !319, scopeLine: 23, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!319 = !DISubroutineType(types: !320)
!320 = !{null, !314, !124}
!321 = !DISubprogram(name: "update_constant", linkageName: "_ZN4Grid15update_constantEd", scope: !304, file: !1, line: 30, type: !319, scopeLine: 30, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!322 = !DISubprogram(name: "update_data", linkageName: "_ZN4Grid11update_dataEd", scope: !304, file: !1, line: 38, type: !319, scopeLine: 38, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!323 = !DISubprogram(name: "update_z", linkageName: "_ZN4Grid8update_zEd", scope: !304, file: !1, line: 46, type: !319, scopeLine: 46, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!324 = !{!325, !325, i64 0}
!325 = !{!"int", !326, i64 0}
!326 = !{!"omnipotent char", !327, i64 0}
!327 = !{!"Simple C++ TBAA"}
!328 = !DILocation(line: 53, column: 14, scope: !293)
!329 = !{!330, !330, i64 0}
!330 = !{!"any pointer", !326, i64 0}
!331 = !DILocation(line: 53, column: 28, scope: !293)
!332 = !DILocation(line: 55, column: 5, scope: !293)
!333 = !DILocation(line: 55, column: 9, scope: !293)
!334 = !DILocation(line: 55, column: 30, scope: !293)
!335 = !DILocation(line: 55, column: 25, scope: !293)
!336 = !DILocation(line: 56, column: 5, scope: !293)
!337 = !DILocation(line: 56, column: 9, scope: !293)
!338 = !DILocation(line: 56, column: 30, scope: !293)
!339 = !DILocation(line: 56, column: 25, scope: !293)
!340 = !DILocation(line: 57, column: 5, scope: !293)
!341 = !DILocation(line: 57, column: 9, scope: !293)
!342 = !DILocation(line: 57, column: 30, scope: !293)
!343 = !DILocation(line: 57, column: 25, scope: !293)
!344 = !DILocation(line: 59, column: 5, scope: !293)
!345 = !DILocation(line: 59, column: 12, scope: !293)
!346 = !DILocation(line: 60, column: 5, scope: !293)
!347 = !DILocation(line: 61, column: 5, scope: !293)
!348 = !DILocation(line: 63, column: 9, scope: !293)
!349 = !DILocation(line: 63, column: 18, scope: !293)
!350 = !DILocation(line: 63, column: 26, scope: !293)
!351 = !DILocation(line: 63, column: 34, scope: !293)
!352 = !DILocation(line: 63, column: 13, scope: !293)
!353 = !DILocation(line: 63, column: 7, scope: !293)
!354 = !DILocation(line: 65, column: 5, scope: !293)
!355 = !DILocation(line: 65, column: 8, scope: !293)
!356 = !DILocation(line: 66, column: 5, scope: !293)
!357 = !DILocation(line: 66, column: 8, scope: !293)
!358 = !DILocation(line: 67, column: 5, scope: !293)
!359 = !DILocation(line: 67, column: 8, scope: !293)
!360 = !DILocation(line: 68, column: 5, scope: !293)
!361 = !DILocation(line: 68, column: 8, scope: !293)
!362 = !DILocation(line: 70, column: 12, scope: !293)
!363 = !DILocation(line: 70, column: 5, scope: !293)
!364 = !DILocation(line: 72, column: 1, scope: !293)
!365 = !DILocation(line: 71, column: 5, scope: !293)
!366 = !DILocation(line: 361, column: 1, scope: !128)
!367 = !DILocation(line: 363, column: 24, scope: !128)
!368 = !DILocation(line: 363, column: 16, scope: !128)
!369 = !DILocation(line: 363, column: 3, scope: !128)
!370 = distinct !DISubprogram(name: "register_variable<int>", linkageName: "_Z17register_variableIiEvPT_PKc", scope: !371, file: !371, line: 15, type: !372, scopeLine: 16, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, templateParams: !378, retainedNodes: !375)
!371 = !DIFile(filename: "include/ExtraPInstrumenter.hpp", directory: "/home/mcopik/projects/ETH/extrap/rebuild/perf-taint")
!372 = !DISubroutineType(types: !373)
!373 = !{null, !374, !125}
!374 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !4, size: 64)
!375 = !{!376, !377}
!376 = !DILocalVariable(name: "ptr", arg: 1, scope: !370, file: !371, line: 15, type: !374)
!377 = !DILocalVariable(name: "name", arg: 2, scope: !370, file: !371, line: 15, type: !125)
!378 = !{!379}
!379 = !DITemplateTypeParameter(name: "T", type: !4)
!380 = !DILocation(line: 15, column: 28, scope: !370)
!381 = !DILocation(line: 15, column: 46, scope: !370)
!382 = !DILocation(line: 20, column: 55, scope: !370)
!383 = !DILocation(line: 20, column: 29, scope: !370)
!384 = !DILocation(line: 20, column: 72, scope: !370)
!385 = !DILocation(line: 20, column: 3, scope: !370)
!386 = !DILocation(line: 21, column: 1, scope: !370)
!387 = distinct !DISubprogram(name: "Grid", linkageName: "_ZN4GridC2Eiii", scope: !304, file: !1, line: 11, type: !312, scopeLine: 16, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, declaration: !311, retainedNodes: !388)
!388 = !{!389, !390, !391, !392}
!389 = !DILocalVariable(name: "this", arg: 1, scope: !387, type: !303, flags: DIFlagArtificial | DIFlagObjectPointer)
!390 = !DILocalVariable(name: "_x", arg: 2, scope: !387, file: !1, line: 11, type: !4)
!391 = !DILocalVariable(name: "_y", arg: 3, scope: !387, file: !1, line: 11, type: !4)
!392 = !DILocalVariable(name: "_z", arg: 4, scope: !387, file: !1, line: 11, type: !4)
!393 = !DILocation(line: 0, scope: !387)
!394 = !DILocation(line: 11, column: 14, scope: !387)
!395 = !DILocation(line: 11, column: 22, scope: !387)
!396 = !DILocation(line: 11, column: 30, scope: !387)
!397 = !DILocation(line: 12, column: 9, scope: !387)
!398 = !DILocation(line: 12, column: 11, scope: !387)
!399 = !{!400, !325, i64 0}
!400 = !{!"_ZTS4Grid", !325, i64 0, !325, i64 4, !325, i64 8, !330, i64 16}
!401 = !DILocation(line: 13, column: 9, scope: !387)
!402 = !DILocation(line: 13, column: 11, scope: !387)
!403 = !{!400, !325, i64 4}
!404 = !DILocation(line: 14, column: 9, scope: !387)
!405 = !DILocation(line: 14, column: 11, scope: !387)
!406 = !{!400, !325, i64 8}
!407 = !DILocation(line: 15, column: 9, scope: !387)
!408 = !DILocation(line: 15, column: 25, scope: !387)
!409 = !DILocation(line: 15, column: 27, scope: !387)
!410 = !DILocation(line: 15, column: 26, scope: !387)
!411 = !DILocation(line: 15, column: 14, scope: !387)
!412 = !{!400, !330, i64 16}
!413 = !DILocation(line: 16, column: 10, scope: !387)
!414 = distinct !DISubprogram(name: "update_grid", linkageName: "_ZN4Grid11update_gridEd", scope: !304, file: !1, line: 23, type: !319, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, declaration: !318, retainedNodes: !415)
!415 = !{!416, !417, !418}
!416 = !DILocalVariable(name: "this", arg: 1, scope: !414, type: !303, flags: DIFlagArtificial | DIFlagObjectPointer)
!417 = !DILocalVariable(name: "shift", arg: 2, scope: !414, file: !1, line: 23, type: !124)
!418 = !DILocalVariable(name: "i", scope: !419, file: !1, line: 25, type: !4)
!419 = distinct !DILexicalBlock(scope: !414, file: !1, line: 25, column: 9)
!420 = !DILocation(line: 0, scope: !414)
!421 = !{!422, !422, i64 0}
!422 = !{!"double", !326, i64 0}
!423 = !DILocation(line: 23, column: 29, scope: !414)
!424 = !DILocation(line: 25, column: 13, scope: !419)
!425 = !DILocation(line: 25, column: 17, scope: !419)
!426 = !DILocation(line: 25, column: 24, scope: !427)
!427 = distinct !DILexicalBlock(scope: !419, file: !1, line: 25, column: 9)
!428 = !DILocation(line: 25, column: 28, scope: !427)
!429 = !DILocation(line: 25, column: 30, scope: !427)
!430 = !DILocation(line: 25, column: 29, scope: !427)
!431 = !DILocation(line: 25, column: 26, scope: !427)
!432 = !DILocation(line: 25, column: 9, scope: !419)
!433 = !DILocation(line: 25, column: 9, scope: !427)
!434 = !DILocation(line: 26, column: 24, scope: !427)
!435 = !DILocation(line: 26, column: 13, scope: !427)
!436 = !DILocation(line: 26, column: 18, scope: !427)
!437 = !DILocation(line: 26, column: 21, scope: !427)
!438 = !DILocation(line: 25, column: 32, scope: !427)
!439 = distinct !{!439, !432, !440}
!440 = !DILocation(line: 26, column: 24, scope: !419)
!441 = !DILocation(line: 27, column: 5, scope: !414)
!442 = distinct !DISubprogram(name: "update_constant", linkageName: "_ZN4Grid15update_constantEd", scope: !304, file: !1, line: 30, type: !319, scopeLine: 31, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, declaration: !321, retainedNodes: !443)
!443 = !{!444, !445, !446}
!444 = !DILocalVariable(name: "this", arg: 1, scope: !442, type: !303, flags: DIFlagArtificial | DIFlagObjectPointer)
!445 = !DILocalVariable(name: "shift", arg: 2, scope: !442, file: !1, line: 30, type: !124)
!446 = !DILocalVariable(name: "i", scope: !447, file: !1, line: 33, type: !4)
!447 = distinct !DILexicalBlock(scope: !442, file: !1, line: 33, column: 9)
!448 = !DILocation(line: 0, scope: !442)
!449 = !DILocation(line: 30, column: 33, scope: !442)
!450 = !DILocation(line: 32, column: 22, scope: !442)
!451 = !DILocation(line: 32, column: 21, scope: !442)
!452 = !DILocation(line: 32, column: 9, scope: !442)
!453 = !DILocation(line: 32, column: 17, scope: !442)
!454 = !DILocation(line: 33, column: 13, scope: !447)
!455 = !DILocation(line: 33, column: 17, scope: !447)
!456 = !DILocation(line: 33, column: 24, scope: !457)
!457 = distinct !DILexicalBlock(scope: !447, file: !1, line: 33, column: 9)
!458 = !DILocation(line: 33, column: 26, scope: !457)
!459 = !DILocation(line: 33, column: 9, scope: !447)
!460 = !DILocation(line: 33, column: 9, scope: !457)
!461 = !DILocation(line: 34, column: 24, scope: !457)
!462 = !DILocation(line: 34, column: 13, scope: !457)
!463 = !DILocation(line: 34, column: 18, scope: !457)
!464 = !DILocation(line: 34, column: 21, scope: !457)
!465 = !DILocation(line: 33, column: 30, scope: !457)
!466 = distinct !{!466, !459, !467}
!467 = !DILocation(line: 34, column: 24, scope: !447)
!468 = !DILocation(line: 35, column: 5, scope: !442)
!469 = distinct !DISubprogram(name: "update_data", linkageName: "_ZN4Grid11update_dataEd", scope: !304, file: !1, line: 38, type: !319, scopeLine: 39, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, declaration: !322, retainedNodes: !470)
!470 = !{!471, !472, !473}
!471 = !DILocalVariable(name: "this", arg: 1, scope: !469, type: !303, flags: DIFlagArtificial | DIFlagObjectPointer)
!472 = !DILocalVariable(name: "shift", arg: 2, scope: !469, file: !1, line: 38, type: !124)
!473 = !DILocalVariable(name: "i", scope: !474, file: !1, line: 41, type: !4)
!474 = distinct !DILexicalBlock(scope: !469, file: !1, line: 41, column: 9)
!475 = !DILocation(line: 0, scope: !469)
!476 = !DILocation(line: 38, column: 29, scope: !469)
!477 = !DILocation(line: 40, column: 22, scope: !469)
!478 = !DILocation(line: 40, column: 21, scope: !469)
!479 = !DILocation(line: 40, column: 9, scope: !469)
!480 = !DILocation(line: 40, column: 17, scope: !469)
!481 = !DILocation(line: 41, column: 13, scope: !474)
!482 = !DILocation(line: 41, column: 17, scope: !474)
!483 = !DILocation(line: 41, column: 21, scope: !474)
!484 = !DILocation(line: 41, column: 30, scope: !485)
!485 = distinct !DILexicalBlock(scope: !474, file: !1, line: 41, column: 9)
!486 = !DILocation(line: 41, column: 32, scope: !485)
!487 = !DILocation(line: 41, column: 9, scope: !474)
!488 = !DILocation(line: 41, column: 9, scope: !485)
!489 = !DILocation(line: 42, column: 24, scope: !485)
!490 = !DILocation(line: 42, column: 13, scope: !485)
!491 = !DILocation(line: 42, column: 18, scope: !485)
!492 = !DILocation(line: 42, column: 21, scope: !485)
!493 = !DILocation(line: 41, column: 36, scope: !485)
!494 = distinct !{!494, !487, !495}
!495 = !DILocation(line: 42, column: 24, scope: !474)
!496 = !DILocation(line: 43, column: 5, scope: !469)
!497 = distinct !DISubprogram(name: "update_z", linkageName: "_ZN4Grid8update_zEd", scope: !304, file: !1, line: 46, type: !319, scopeLine: 47, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, declaration: !323, retainedNodes: !498)
!498 = !{!499, !500, !501}
!499 = !DILocalVariable(name: "this", arg: 1, scope: !497, type: !303, flags: DIFlagArtificial | DIFlagObjectPointer)
!500 = !DILocalVariable(name: "shift", arg: 2, scope: !497, file: !1, line: 46, type: !124)
!501 = !DILocalVariable(name: "i", scope: !502, file: !1, line: 48, type: !4)
!502 = distinct !DILexicalBlock(scope: !497, file: !1, line: 48, column: 9)
!503 = !DILocation(line: 0, scope: !497)
!504 = !DILocation(line: 46, column: 26, scope: !497)
!505 = !DILocation(line: 48, column: 13, scope: !502)
!506 = !DILocation(line: 48, column: 17, scope: !502)
!507 = !DILocation(line: 48, column: 24, scope: !508)
!508 = distinct !DILexicalBlock(scope: !502, file: !1, line: 48, column: 9)
!509 = !DILocation(line: 48, column: 28, scope: !508)
!510 = !DILocation(line: 48, column: 26, scope: !508)
!511 = !DILocation(line: 48, column: 9, scope: !502)
!512 = !DILocation(line: 48, column: 9, scope: !508)
!513 = !DILocation(line: 49, column: 24, scope: !508)
!514 = !DILocation(line: 49, column: 13, scope: !508)
!515 = !DILocation(line: 49, column: 18, scope: !508)
!516 = !DILocation(line: 49, column: 21, scope: !508)
!517 = !DILocation(line: 48, column: 30, scope: !508)
!518 = distinct !{!518, !511, !519}
!519 = !DILocation(line: 49, column: 24, scope: !502)
!520 = !DILocation(line: 50, column: 5, scope: !497)
!521 = distinct !DISubprogram(name: "~Grid", linkageName: "_ZN4GridD2Ev", scope: !304, file: !1, line: 17, type: !316, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, declaration: !315, retainedNodes: !522)
!522 = !{!523}
!523 = !DILocalVariable(name: "this", arg: 1, scope: !521, type: !303, flags: DIFlagArtificial | DIFlagObjectPointer)
!524 = !DILocation(line: 0, scope: !521)
!525 = !DILocation(line: 19, column: 18, scope: !526)
!526 = distinct !DILexicalBlock(scope: !521, file: !1, line: 18, column: 5)
!527 = !DILocation(line: 19, column: 9, scope: !526)
!528 = !DILocation(line: 20, column: 5, scope: !521)
