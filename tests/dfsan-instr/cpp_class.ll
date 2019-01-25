; RUN: opt %dfsan -S < %s 2> /dev/null | llc %llcparams - -o %t1 && clang++ %link %t1 -o %t2 && %execparams %t2 10 10 10 | diff -w %s.json -
; RUN: %jsonconvert %s.json | diff -w %s.processed.json -
; ModuleID = 'tests/dfsan-instr/cpp_class.cpp'
source_filename = "tests/dfsan-instr/cpp_class.cpp"
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
@.str.1 = private unnamed_addr constant [32 x i8] c"tests/dfsan-instr/cpp_class.cpp\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [7 x i8] c"size_x\00", align 1
@.str.3 = private unnamed_addr constant [7 x i8] c"size_y\00", align 1

; Function Attrs: noinline norecurse optnone uwtable
define dso_local i32 @main(i32, i8**) #0 personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) !dbg !279 {
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
  store i32 %0, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !282, metadata !DIExpression()), !dbg !283
  store i8** %1, i8*** %5, align 8
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !284, metadata !DIExpression()), !dbg !285
  call void @llvm.dbg.declare(metadata i32* %6, metadata !286, metadata !DIExpression()), !dbg !287
  %12 = bitcast i32* %6 to i8*, !dbg !288
  call void @llvm.var.annotation(i8* %12, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.1, i32 0, i32 0), i32 55), !dbg !288
  %13 = load i8**, i8*** %5, align 8, !dbg !289
  %14 = getelementptr inbounds i8*, i8** %13, i64 1, !dbg !289
  %15 = load i8*, i8** %14, align 8, !dbg !289
  %16 = call i32 @atoi(i8* %15) #10, !dbg !290
  store i32 %16, i32* %6, align 4, !dbg !287
  call void @llvm.dbg.declare(metadata i32* %7, metadata !291, metadata !DIExpression()), !dbg !292
  %17 = bitcast i32* %7 to i8*, !dbg !293
  call void @llvm.var.annotation(i8* %17, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.1, i32 0, i32 0), i32 56), !dbg !293
  %18 = load i8**, i8*** %5, align 8, !dbg !294
  %19 = getelementptr inbounds i8*, i8** %18, i64 2, !dbg !294
  %20 = load i8*, i8** %19, align 8, !dbg !294
  %21 = call i32 @atoi(i8* %20) #10, !dbg !295
  store i32 %21, i32* %7, align 4, !dbg !292
  call void @llvm.dbg.declare(metadata i32* %8, metadata !296, metadata !DIExpression()), !dbg !297
  %22 = bitcast i32* %8 to i8*, !dbg !298
  call void @llvm.var.annotation(i8* %22, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.1, i32 0, i32 0), i32 57), !dbg !298
  %23 = load i8**, i8*** %5, align 8, !dbg !299
  %24 = getelementptr inbounds i8*, i8** %23, i64 3, !dbg !299
  %25 = load i8*, i8** %24, align 8, !dbg !299
  %26 = call i32 @atoi(i8* %25) #10, !dbg !300
  store i32 %26, i32* %8, align 4, !dbg !297
  call void @llvm.dbg.declare(metadata %class.Grid** %9, metadata !301, metadata !DIExpression()), !dbg !323
  call void @_Z17register_variableIiEvPT_PKc(i32* %6, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0)), !dbg !324
  call void @_Z17register_variableIiEvPT_PKc(i32* %7, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.3, i32 0, i32 0)), !dbg !325
  %27 = call i8* @_Znwm(i64 24) #11, !dbg !326
  %28 = bitcast i8* %27 to %class.Grid*, !dbg !326
  %29 = load i32, i32* %6, align 4, !dbg !327
  %30 = load i32, i32* %7, align 4, !dbg !328
  %31 = load i32, i32* %8, align 4, !dbg !329
  invoke void @_ZN4GridC2Eiii(%class.Grid* %28, i32 %29, i32 %30, i32 %31)
          to label %32 unwind label %42, !dbg !330

; <label>:32:                                     ; preds = %2
  store %class.Grid* %28, %class.Grid** %9, align 8, !dbg !331
  %33 = load %class.Grid*, %class.Grid** %9, align 8, !dbg !332
  call void @_ZN4Grid11update_gridEd(%class.Grid* %33, double 2.000000e+00), !dbg !333
  %34 = load %class.Grid*, %class.Grid** %9, align 8, !dbg !334
  call void @_ZN4Grid15update_constantEd(%class.Grid* %34, double 1.500000e+00), !dbg !335
  %35 = load %class.Grid*, %class.Grid** %9, align 8, !dbg !336
  call void @_ZN4Grid11update_dataEd(%class.Grid* %35, double 1.500000e+00), !dbg !337
  %36 = load %class.Grid*, %class.Grid** %9, align 8, !dbg !338
  call void @_ZN4Grid8update_zEd(%class.Grid* %36, double 1.500000e+00), !dbg !339
  %37 = load %class.Grid*, %class.Grid** %9, align 8, !dbg !340
  %38 = icmp eq %class.Grid* %37, null, !dbg !341
  br i1 %38, label %41, label %39, !dbg !341

; <label>:39:                                     ; preds = %32
  call void @_ZN4GridD2Ev(%class.Grid* %37) #2, !dbg !341
  %40 = bitcast %class.Grid* %37 to i8*, !dbg !341
  call void @_ZdlPv(i8* %40) #12, !dbg !341
  br label %41, !dbg !341

; <label>:41:                                     ; preds = %39, %32
  ret i32 0, !dbg !342

; <label>:42:                                     ; preds = %2
  %43 = landingpad { i8*, i32 }
          cleanup, !dbg !343
  %44 = extractvalue { i8*, i32 } %43, 0, !dbg !343
  store i8* %44, i8** %10, align 8, !dbg !343
  %45 = extractvalue { i8*, i32 } %43, 1, !dbg !343
  store i32 %45, i32* %11, align 4, !dbg !343
  call void @_ZdlPv(i8* %27) #12, !dbg !326
  br label %46, !dbg !326

; <label>:46:                                     ; preds = %42
  %47 = load i8*, i8** %10, align 8, !dbg !326
  %48 = load i32, i32* %11, align 4, !dbg !326
  %49 = insertvalue { i8*, i32 } undef, i8* %47, 0, !dbg !326
  %50 = insertvalue { i8*, i32 } %49, i32 %48, 1, !dbg !326
  resume { i8*, i32 } %50, !dbg !326
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind
declare void @llvm.var.annotation(i8*, i8*, i8*, i32) #2

; Function Attrs: nounwind readonly
declare dso_local i32 @atoi(i8*) #3

; Function Attrs: noinline optnone uwtable
define linkonce_odr dso_local void @_Z17register_variableIiEvPT_PKc(i32*, i8*) #4 comdat !dbg !344 {
  %3 = alloca i32*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca i32, align 4
  store i32* %0, i32** %3, align 8
  call void @llvm.dbg.declare(metadata i32** %3, metadata !351, metadata !DIExpression()), !dbg !352
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !353, metadata !DIExpression()), !dbg !354
  call void @llvm.dbg.declare(metadata i32* %5, metadata !355, metadata !DIExpression()), !dbg !356
  %6 = call i32 @__dfsw_EXTRAP_VAR_ID(), !dbg !357
  store i32 %6, i32* %5, align 4, !dbg !356
  %7 = load i32*, i32** %3, align 8, !dbg !358
  %8 = bitcast i32* %7 to i8*, !dbg !359
  %9 = load i32, i32* %5, align 4, !dbg !360
  %10 = add nsw i32 %9, 1, !dbg !360
  store i32 %10, i32* %5, align 4, !dbg !360
  %11 = load i8*, i8** %4, align 8, !dbg !361
  call void @__dfsw_EXTRAP_STORE_LABEL(i8* %8, i32 4, i32 %9, i8* %11), !dbg !362
  ret void, !dbg !363
}

; Function Attrs: nobuiltin
declare dso_local noalias i8* @_Znwm(i64) #5

; Function Attrs: noinline optnone uwtable
define linkonce_odr dso_local void @_ZN4GridC2Eiii(%class.Grid*, i32, i32, i32) unnamed_addr #4 comdat align 2 !dbg !364 {
  %5 = alloca %class.Grid*, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store %class.Grid* %0, %class.Grid** %5, align 8
  call void @llvm.dbg.declare(metadata %class.Grid** %5, metadata !365, metadata !DIExpression()), !dbg !366
  store i32 %1, i32* %6, align 4
  call void @llvm.dbg.declare(metadata i32* %6, metadata !367, metadata !DIExpression()), !dbg !368
  store i32 %2, i32* %7, align 4
  call void @llvm.dbg.declare(metadata i32* %7, metadata !369, metadata !DIExpression()), !dbg !370
  store i32 %3, i32* %8, align 4
  call void @llvm.dbg.declare(metadata i32* %8, metadata !371, metadata !DIExpression()), !dbg !372
  %9 = load %class.Grid*, %class.Grid** %5, align 8
  %10 = getelementptr inbounds %class.Grid, %class.Grid* %9, i32 0, i32 0, !dbg !373
  %11 = load i32, i32* %6, align 4, !dbg !374
  store i32 %11, i32* %10, align 8, !dbg !373
  %12 = getelementptr inbounds %class.Grid, %class.Grid* %9, i32 0, i32 1, !dbg !375
  %13 = load i32, i32* %7, align 4, !dbg !376
  store i32 %13, i32* %12, align 4, !dbg !375
  %14 = getelementptr inbounds %class.Grid, %class.Grid* %9, i32 0, i32 2, !dbg !377
  %15 = load i32, i32* %8, align 4, !dbg !378
  store i32 %15, i32* %14, align 8, !dbg !377
  %16 = getelementptr inbounds %class.Grid, %class.Grid* %9, i32 0, i32 3, !dbg !379
  %17 = getelementptr inbounds %class.Grid, %class.Grid* %9, i32 0, i32 0, !dbg !380
  %18 = load i32, i32* %17, align 8, !dbg !380
  %19 = getelementptr inbounds %class.Grid, %class.Grid* %9, i32 0, i32 1, !dbg !381
  %20 = load i32, i32* %19, align 4, !dbg !381
  %21 = mul nsw i32 %18, %20, !dbg !382
  %22 = sext i32 %21 to i64, !dbg !380
  %23 = call { i64, i1 } @llvm.umul.with.overflow.i64(i64 %22, i64 8), !dbg !383
  %24 = extractvalue { i64, i1 } %23, 1, !dbg !383
  %25 = extractvalue { i64, i1 } %23, 0, !dbg !383
  %26 = select i1 %24, i64 -1, i64 %25, !dbg !383
  %27 = call i8* @_Znam(i64 %26) #11, !dbg !383
  %28 = bitcast i8* %27 to double*, !dbg !383
  %29 = bitcast double* %28 to i8*, !dbg !383
  call void @llvm.memset.p0i8.i64(i8* align 8 %29, i8 0, i64 %26, i1 false), !dbg !383
  store double* %28, double** %16, align 8, !dbg !379
  ret void, !dbg !384
}

declare dso_local i32 @__gxx_personality_v0(...)

; Function Attrs: nobuiltin nounwind
declare dso_local void @_ZdlPv(i8*) #6

; Function Attrs: noinline nounwind optnone uwtable
define linkonce_odr dso_local void @_ZN4Grid11update_gridEd(%class.Grid*, double) #7 comdat align 2 !dbg !385 {
  %3 = alloca %class.Grid*, align 8
  %4 = alloca double, align 8
  %5 = alloca i32, align 4
  store %class.Grid* %0, %class.Grid** %3, align 8
  call void @llvm.dbg.declare(metadata %class.Grid** %3, metadata !386, metadata !DIExpression()), !dbg !387
  store double %1, double* %4, align 8
  call void @llvm.dbg.declare(metadata double* %4, metadata !388, metadata !DIExpression()), !dbg !389
  %6 = load %class.Grid*, %class.Grid** %3, align 8
  call void @llvm.dbg.declare(metadata i32* %5, metadata !390, metadata !DIExpression()), !dbg !392
  store i32 0, i32* %5, align 4, !dbg !392
  br label %7, !dbg !393

; <label>:7:                                      ; preds = %24, %2
  %8 = load i32, i32* %5, align 4, !dbg !394
  %9 = getelementptr inbounds %class.Grid, %class.Grid* %6, i32 0, i32 0, !dbg !396
  %10 = load i32, i32* %9, align 8, !dbg !396
  %11 = getelementptr inbounds %class.Grid, %class.Grid* %6, i32 0, i32 1, !dbg !397
  %12 = load i32, i32* %11, align 4, !dbg !397
  %13 = mul nsw i32 %10, %12, !dbg !398
  %14 = icmp slt i32 %8, %13, !dbg !399
  br i1 %14, label %15, label %27, !dbg !400

; <label>:15:                                     ; preds = %7
  %16 = load double, double* %4, align 8, !dbg !401
  %17 = getelementptr inbounds %class.Grid, %class.Grid* %6, i32 0, i32 3, !dbg !402
  %18 = load double*, double** %17, align 8, !dbg !402
  %19 = load i32, i32* %5, align 4, !dbg !403
  %20 = sext i32 %19 to i64, !dbg !402
  %21 = getelementptr inbounds double, double* %18, i64 %20, !dbg !402
  %22 = load double, double* %21, align 8, !dbg !404
  %23 = fadd double %22, %16, !dbg !404
  store double %23, double* %21, align 8, !dbg !404
  br label %24, !dbg !402

; <label>:24:                                     ; preds = %15
  %25 = load i32, i32* %5, align 4, !dbg !405
  %26 = add nsw i32 %25, 1, !dbg !405
  store i32 %26, i32* %5, align 4, !dbg !405
  br label %7, !dbg !406, !llvm.loop !407

; <label>:27:                                     ; preds = %7
  ret void, !dbg !409
}

; Function Attrs: noinline nounwind optnone uwtable
define linkonce_odr dso_local void @_ZN4Grid15update_constantEd(%class.Grid*, double) #7 comdat align 2 !dbg !410 {
  %3 = alloca %class.Grid*, align 8
  %4 = alloca double, align 8
  %5 = alloca i32, align 4
  store %class.Grid* %0, %class.Grid** %3, align 8
  call void @llvm.dbg.declare(metadata %class.Grid** %3, metadata !411, metadata !DIExpression()), !dbg !412
  store double %1, double* %4, align 8
  call void @llvm.dbg.declare(metadata double* %4, metadata !413, metadata !DIExpression()), !dbg !414
  %6 = load %class.Grid*, %class.Grid** %3, align 8
  %7 = load double, double* %4, align 8, !dbg !415
  %8 = fmul double 2.000000e+00, %7, !dbg !416
  %9 = getelementptr inbounds %class.Grid, %class.Grid* %6, i32 0, i32 3, !dbg !417
  %10 = load double*, double** %9, align 8, !dbg !417
  %11 = getelementptr inbounds double, double* %10, i64 0, !dbg !417
  %12 = load double, double* %11, align 8, !dbg !418
  %13 = fadd double %12, %8, !dbg !418
  store double %13, double* %11, align 8, !dbg !418
  call void @llvm.dbg.declare(metadata i32* %5, metadata !419, metadata !DIExpression()), !dbg !421
  store i32 1, i32* %5, align 4, !dbg !421
  br label %14, !dbg !422

; <label>:14:                                     ; preds = %26, %2
  %15 = load i32, i32* %5, align 4, !dbg !423
  %16 = icmp slt i32 %15, 5, !dbg !425
  br i1 %16, label %17, label %29, !dbg !426

; <label>:17:                                     ; preds = %14
  %18 = load double, double* %4, align 8, !dbg !427
  %19 = getelementptr inbounds %class.Grid, %class.Grid* %6, i32 0, i32 3, !dbg !428
  %20 = load double*, double** %19, align 8, !dbg !428
  %21 = load i32, i32* %5, align 4, !dbg !429
  %22 = sext i32 %21 to i64, !dbg !428
  %23 = getelementptr inbounds double, double* %20, i64 %22, !dbg !428
  %24 = load double, double* %23, align 8, !dbg !430
  %25 = fadd double %24, %18, !dbg !430
  store double %25, double* %23, align 8, !dbg !430
  br label %26, !dbg !428

; <label>:26:                                     ; preds = %17
  %27 = load i32, i32* %5, align 4, !dbg !431
  %28 = add nsw i32 %27, 1, !dbg !431
  store i32 %28, i32* %5, align 4, !dbg !431
  br label %14, !dbg !432, !llvm.loop !433

; <label>:29:                                     ; preds = %14
  ret void, !dbg !435
}

; Function Attrs: noinline nounwind optnone uwtable
define linkonce_odr dso_local void @_ZN4Grid11update_dataEd(%class.Grid*, double) #7 comdat align 2 !dbg !436 {
  %3 = alloca %class.Grid*, align 8
  %4 = alloca double, align 8
  %5 = alloca i32, align 4
  store %class.Grid* %0, %class.Grid** %3, align 8
  call void @llvm.dbg.declare(metadata %class.Grid** %3, metadata !437, metadata !DIExpression()), !dbg !438
  store double %1, double* %4, align 8
  call void @llvm.dbg.declare(metadata double* %4, metadata !439, metadata !DIExpression()), !dbg !440
  %6 = load %class.Grid*, %class.Grid** %3, align 8
  %7 = load double, double* %4, align 8, !dbg !441
  %8 = fmul double 2.000000e+00, %7, !dbg !442
  %9 = getelementptr inbounds %class.Grid, %class.Grid* %6, i32 0, i32 3, !dbg !443
  %10 = load double*, double** %9, align 8, !dbg !443
  %11 = getelementptr inbounds double, double* %10, i64 0, !dbg !443
  %12 = load double, double* %11, align 8, !dbg !444
  %13 = fadd double %12, %8, !dbg !444
  store double %13, double* %11, align 8, !dbg !444
  call void @llvm.dbg.declare(metadata i32* %5, metadata !445, metadata !DIExpression()), !dbg !447
  %14 = getelementptr inbounds %class.Grid, %class.Grid* %6, i32 0, i32 3, !dbg !448
  %15 = load double*, double** %14, align 8, !dbg !448
  %16 = getelementptr inbounds double, double* %15, i64 0, !dbg !448
  %17 = load double, double* %16, align 8, !dbg !448
  %18 = fptosi double %17 to i32, !dbg !448
  store i32 %18, i32* %5, align 4, !dbg !447
  br label %19, !dbg !449

; <label>:19:                                     ; preds = %31, %2
  %20 = load i32, i32* %5, align 4, !dbg !450
  %21 = icmp slt i32 %20, 5, !dbg !452
  br i1 %21, label %22, label %34, !dbg !453

; <label>:22:                                     ; preds = %19
  %23 = load double, double* %4, align 8, !dbg !454
  %24 = getelementptr inbounds %class.Grid, %class.Grid* %6, i32 0, i32 3, !dbg !455
  %25 = load double*, double** %24, align 8, !dbg !455
  %26 = load i32, i32* %5, align 4, !dbg !456
  %27 = sext i32 %26 to i64, !dbg !455
  %28 = getelementptr inbounds double, double* %25, i64 %27, !dbg !455
  %29 = load double, double* %28, align 8, !dbg !457
  %30 = fadd double %29, %23, !dbg !457
  store double %30, double* %28, align 8, !dbg !457
  br label %31, !dbg !455

; <label>:31:                                     ; preds = %22
  %32 = load i32, i32* %5, align 4, !dbg !458
  %33 = add nsw i32 %32, 1, !dbg !458
  store i32 %33, i32* %5, align 4, !dbg !458
  br label %19, !dbg !459, !llvm.loop !460

; <label>:34:                                     ; preds = %19
  ret void, !dbg !462
}

; Function Attrs: noinline nounwind optnone uwtable
define linkonce_odr dso_local void @_ZN4Grid8update_zEd(%class.Grid*, double) #7 comdat align 2 !dbg !463 {
  %3 = alloca %class.Grid*, align 8
  %4 = alloca double, align 8
  %5 = alloca i32, align 4
  store %class.Grid* %0, %class.Grid** %3, align 8
  call void @llvm.dbg.declare(metadata %class.Grid** %3, metadata !464, metadata !DIExpression()), !dbg !465
  store double %1, double* %4, align 8
  call void @llvm.dbg.declare(metadata double* %4, metadata !466, metadata !DIExpression()), !dbg !467
  %6 = load %class.Grid*, %class.Grid** %3, align 8
  call void @llvm.dbg.declare(metadata i32* %5, metadata !468, metadata !DIExpression()), !dbg !470
  store i32 0, i32* %5, align 4, !dbg !470
  br label %7, !dbg !471

; <label>:7:                                      ; preds = %21, %2
  %8 = load i32, i32* %5, align 4, !dbg !472
  %9 = getelementptr inbounds %class.Grid, %class.Grid* %6, i32 0, i32 2, !dbg !474
  %10 = load i32, i32* %9, align 8, !dbg !474
  %11 = icmp slt i32 %8, %10, !dbg !475
  br i1 %11, label %12, label %24, !dbg !476

; <label>:12:                                     ; preds = %7
  %13 = load double, double* %4, align 8, !dbg !477
  %14 = getelementptr inbounds %class.Grid, %class.Grid* %6, i32 0, i32 3, !dbg !478
  %15 = load double*, double** %14, align 8, !dbg !478
  %16 = load i32, i32* %5, align 4, !dbg !479
  %17 = sext i32 %16 to i64, !dbg !478
  %18 = getelementptr inbounds double, double* %15, i64 %17, !dbg !478
  %19 = load double, double* %18, align 8, !dbg !480
  %20 = fadd double %19, %13, !dbg !480
  store double %20, double* %18, align 8, !dbg !480
  br label %21, !dbg !478

; <label>:21:                                     ; preds = %12
  %22 = load i32, i32* %5, align 4, !dbg !481
  %23 = add nsw i32 %22, 1, !dbg !481
  store i32 %23, i32* %5, align 4, !dbg !481
  br label %7, !dbg !482, !llvm.loop !483

; <label>:24:                                     ; preds = %7
  ret void, !dbg !485
}

; Function Attrs: noinline nounwind optnone uwtable
define linkonce_odr dso_local void @_ZN4GridD2Ev(%class.Grid*) unnamed_addr #7 comdat align 2 !dbg !486 {
  %2 = alloca %class.Grid*, align 8
  store %class.Grid* %0, %class.Grid** %2, align 8
  call void @llvm.dbg.declare(metadata %class.Grid** %2, metadata !487, metadata !DIExpression()), !dbg !488
  %3 = load %class.Grid*, %class.Grid** %2, align 8
  %4 = getelementptr inbounds %class.Grid, %class.Grid* %3, i32 0, i32 3, !dbg !489
  %5 = load double*, double** %4, align 8, !dbg !489
  %6 = icmp eq double* %5, null, !dbg !491
  br i1 %6, label %9, label %7, !dbg !491

; <label>:7:                                      ; preds = %1
  %8 = bitcast double* %5 to i8*, !dbg !491
  call void @_ZdaPv(i8* %8) #12, !dbg !491
  br label %9, !dbg !491

; <label>:9:                                      ; preds = %7, %1
  ret void, !dbg !492
}

; Function Attrs: nounwind readnone speculatable
declare { i64, i1 } @llvm.umul.with.overflow.i64(i64, i64) #1

; Function Attrs: nobuiltin
declare dso_local noalias i8* @_Znam(i64) #5

; Function Attrs: argmemonly nounwind
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1) #8

; Function Attrs: nobuiltin nounwind
declare dso_local void @_ZdaPv(i8*) #6

declare dso_local i32 @__dfsw_EXTRAP_VAR_ID() #9

declare dso_local void @__dfsw_EXTRAP_STORE_LABEL(i8*, i32, i32, i8*) #9

attributes #0 = { noinline norecurse optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { nounwind }
attributes #3 = { nounwind readonly "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { noinline optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { nobuiltin "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #6 = { nobuiltin nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #7 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #8 = { argmemonly nounwind }
attributes #9 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #10 = { nounwind readonly }
attributes #11 = { builtin }
attributes #12 = { builtin nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!275, !276, !277}
!llvm.ident = !{!278}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !1, producer: "clang version 8.0.0 (git@github.com:llvm-mirror/clang.git fd01d8b9288b3558a597daeb0cb4481b37c5bf68) (git@github.com:llvm-mirror/LLVM.git 7135d8b482d3d0d1a8c50111eebb9b207e92a8bc)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !3, imports: !10, nameTableKind: None)
!1 = !DIFile(filename: "tests/dfsan-instr/cpp_class.cpp", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!2 = !{}
!3 = !{!4}
!4 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !5, size: 64)
!5 = !DIDerivedType(tag: DW_TAG_typedef, name: "int8_t", file: !6, line: 24, baseType: !7)
!6 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-intn.h", directory: "")
!7 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int8_t", file: !8, line: 36, baseType: !9)
!8 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "")
!9 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!10 = !{!11, !15, !19, !23, !27, !32, !36, !40, !44, !47, !49, !51, !53, !55, !57, !59, !61, !63, !65, !67, !69, !71, !73, !75, !77, !79, !81, !84, !87, !91, !95, !101, !108, !116, !120, !124, !128, !136, !141, !146, !150, !154, !158, !163, !167, !171, !176, !180, !184, !188, !192, !197, !201, !203, !207, !209, !219, !223, !228, !232, !234, !238, !242, !244, !248, !255, !259, !263, !271, !273}
!11 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !5, file: !14, line: 153)
!12 = !DINamespace(name: "__1", scope: !13, exportSymbols: true)
!13 = !DINamespace(name: "std", scope: null)
!14 = !DIFile(filename: "clang_llvm/build_dfsan_full/include/c++/v1/cstdint", directory: "/home/mcopik/projects")
!15 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !16, file: !14, line: 154)
!16 = !DIDerivedType(tag: DW_TAG_typedef, name: "int16_t", file: !6, line: 25, baseType: !17)
!17 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int16_t", file: !8, line: 38, baseType: !18)
!18 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!19 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !20, file: !14, line: 155)
!20 = !DIDerivedType(tag: DW_TAG_typedef, name: "int32_t", file: !6, line: 26, baseType: !21)
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int32_t", file: !8, line: 40, baseType: !22)
!22 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!23 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !24, file: !14, line: 156)
!24 = !DIDerivedType(tag: DW_TAG_typedef, name: "int64_t", file: !6, line: 27, baseType: !25)
!25 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int64_t", file: !8, line: 43, baseType: !26)
!26 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!27 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !28, file: !14, line: 158)
!28 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint8_t", file: !29, line: 24, baseType: !30)
!29 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "")
!30 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint8_t", file: !8, line: 37, baseType: !31)
!31 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!32 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !33, file: !14, line: 159)
!33 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint16_t", file: !29, line: 25, baseType: !34)
!34 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint16_t", file: !8, line: 39, baseType: !35)
!35 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!36 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !37, file: !14, line: 160)
!37 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !29, line: 26, baseType: !38)
!38 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !8, line: 41, baseType: !39)
!39 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!40 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !41, file: !14, line: 161)
!41 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", file: !29, line: 27, baseType: !42)
!42 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint64_t", file: !8, line: 44, baseType: !43)
!43 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!44 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !45, file: !14, line: 163)
!45 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least8_t", file: !46, line: 43, baseType: !9)
!46 = !DIFile(filename: "/usr/include/stdint.h", directory: "")
!47 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !48, file: !14, line: 164)
!48 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least16_t", file: !46, line: 44, baseType: !18)
!49 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !50, file: !14, line: 165)
!50 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least32_t", file: !46, line: 45, baseType: !22)
!51 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !52, file: !14, line: 166)
!52 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least64_t", file: !46, line: 47, baseType: !26)
!53 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !54, file: !14, line: 168)
!54 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least8_t", file: !46, line: 54, baseType: !31)
!55 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !56, file: !14, line: 169)
!56 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least16_t", file: !46, line: 55, baseType: !35)
!57 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !58, file: !14, line: 170)
!58 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least32_t", file: !46, line: 56, baseType: !39)
!59 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !60, file: !14, line: 171)
!60 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least64_t", file: !46, line: 58, baseType: !43)
!61 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !62, file: !14, line: 173)
!62 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast8_t", file: !46, line: 68, baseType: !9)
!63 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !64, file: !14, line: 174)
!64 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast16_t", file: !46, line: 70, baseType: !26)
!65 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !66, file: !14, line: 175)
!66 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast32_t", file: !46, line: 71, baseType: !26)
!67 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !68, file: !14, line: 176)
!68 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast64_t", file: !46, line: 72, baseType: !26)
!69 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !70, file: !14, line: 178)
!70 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast8_t", file: !46, line: 81, baseType: !31)
!71 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !72, file: !14, line: 179)
!72 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast16_t", file: !46, line: 83, baseType: !43)
!73 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !74, file: !14, line: 180)
!74 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast32_t", file: !46, line: 84, baseType: !43)
!75 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !76, file: !14, line: 181)
!76 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast64_t", file: !46, line: 85, baseType: !43)
!77 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !78, file: !14, line: 183)
!78 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !46, line: 97, baseType: !26)
!79 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !80, file: !14, line: 184)
!80 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !46, line: 100, baseType: !43)
!81 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !82, file: !14, line: 186)
!82 = !DIDerivedType(tag: DW_TAG_typedef, name: "intmax_t", file: !46, line: 111, baseType: !83)
!83 = !DIDerivedType(tag: DW_TAG_typedef, name: "__intmax_t", file: !8, line: 61, baseType: !26)
!84 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !85, file: !14, line: 187)
!85 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintmax_t", file: !46, line: 112, baseType: !86)
!86 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uintmax_t", file: !8, line: 62, baseType: !43)
!87 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !88, file: !90, line: 100)
!88 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !89, line: 62, baseType: !43)
!89 = !DIFile(filename: "clang_llvm/build_release/lib/clang/8.0.0/include/stddef.h", directory: "/home/mcopik/projects")
!90 = !DIFile(filename: "clang_llvm/build_dfsan_full/include/c++/v1/cstdlib", directory: "/home/mcopik/projects")
!91 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !92, file: !90, line: 101)
!92 = !DIDerivedType(tag: DW_TAG_typedef, name: "div_t", file: !93, line: 62, baseType: !94)
!93 = !DIFile(filename: "/usr/include/stdlib.h", directory: "")
!94 = !DICompositeType(tag: DW_TAG_structure_type, file: !93, line: 58, flags: DIFlagFwdDecl, identifier: "_ZTS5div_t")
!95 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !96, file: !90, line: 102)
!96 = !DIDerivedType(tag: DW_TAG_typedef, name: "ldiv_t", file: !93, line: 70, baseType: !97)
!97 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !93, line: 66, size: 128, flags: DIFlagTypePassByValue | DIFlagTrivial, elements: !98, identifier: "_ZTS6ldiv_t")
!98 = !{!99, !100}
!99 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !97, file: !93, line: 68, baseType: !26, size: 64)
!100 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !97, file: !93, line: 69, baseType: !26, size: 64, offset: 64)
!101 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !102, file: !90, line: 104)
!102 = !DIDerivedType(tag: DW_TAG_typedef, name: "lldiv_t", file: !93, line: 80, baseType: !103)
!103 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !93, line: 76, size: 128, flags: DIFlagTypePassByValue | DIFlagTrivial, elements: !104, identifier: "_ZTS7lldiv_t")
!104 = !{!105, !107}
!105 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !103, file: !93, line: 78, baseType: !106, size: 64)
!106 = !DIBasicType(name: "long long int", size: 64, encoding: DW_ATE_signed)
!107 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !103, file: !93, line: 79, baseType: !106, size: 64, offset: 64)
!108 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !109, file: !90, line: 106)
!109 = !DISubprogram(name: "atof", scope: !93, file: !93, line: 101, type: !110, flags: DIFlagPrototyped, spFlags: 0)
!110 = !DISubroutineType(types: !111)
!111 = !{!112, !113}
!112 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!113 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !114, size: 64)
!114 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !115)
!115 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!116 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !117, file: !90, line: 107)
!117 = !DISubprogram(name: "atoi", scope: !93, file: !93, line: 104, type: !118, flags: DIFlagPrototyped, spFlags: 0)
!118 = !DISubroutineType(types: !119)
!119 = !{!22, !113}
!120 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !121, file: !90, line: 108)
!121 = !DISubprogram(name: "atol", scope: !93, file: !93, line: 107, type: !122, flags: DIFlagPrototyped, spFlags: 0)
!122 = !DISubroutineType(types: !123)
!123 = !{!26, !113}
!124 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !125, file: !90, line: 110)
!125 = !DISubprogram(name: "atoll", scope: !93, file: !93, line: 112, type: !126, flags: DIFlagPrototyped, spFlags: 0)
!126 = !DISubroutineType(types: !127)
!127 = !{!106, !113}
!128 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !129, file: !90, line: 112)
!129 = !DISubprogram(name: "strtod", scope: !93, file: !93, line: 117, type: !130, flags: DIFlagPrototyped, spFlags: 0)
!130 = !DISubroutineType(types: !131)
!131 = !{!112, !132, !133}
!132 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !113)
!133 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !134)
!134 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !135, size: 64)
!135 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !115, size: 64)
!136 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !137, file: !90, line: 113)
!137 = !DISubprogram(name: "strtof", scope: !93, file: !93, line: 123, type: !138, flags: DIFlagPrototyped, spFlags: 0)
!138 = !DISubroutineType(types: !139)
!139 = !{!140, !132, !133}
!140 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!141 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !142, file: !90, line: 114)
!142 = !DISubprogram(name: "strtold", scope: !93, file: !93, line: 126, type: !143, flags: DIFlagPrototyped, spFlags: 0)
!143 = !DISubroutineType(types: !144)
!144 = !{!145, !132, !133}
!145 = !DIBasicType(name: "long double", size: 128, encoding: DW_ATE_float)
!146 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !147, file: !90, line: 115)
!147 = !DISubprogram(name: "strtol", scope: !93, file: !93, line: 176, type: !148, flags: DIFlagPrototyped, spFlags: 0)
!148 = !DISubroutineType(types: !149)
!149 = !{!26, !132, !133, !22}
!150 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !151, file: !90, line: 117)
!151 = !DISubprogram(name: "strtoll", scope: !93, file: !93, line: 200, type: !152, flags: DIFlagPrototyped, spFlags: 0)
!152 = !DISubroutineType(types: !153)
!153 = !{!106, !132, !133, !22}
!154 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !155, file: !90, line: 119)
!155 = !DISubprogram(name: "strtoul", scope: !93, file: !93, line: 180, type: !156, flags: DIFlagPrototyped, spFlags: 0)
!156 = !DISubroutineType(types: !157)
!157 = !{!43, !132, !133, !22}
!158 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !159, file: !90, line: 121)
!159 = !DISubprogram(name: "strtoull", scope: !93, file: !93, line: 205, type: !160, flags: DIFlagPrototyped, spFlags: 0)
!160 = !DISubroutineType(types: !161)
!161 = !{!162, !132, !133, !22}
!162 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!163 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !164, file: !90, line: 123)
!164 = !DISubprogram(name: "rand", scope: !93, file: !93, line: 453, type: !165, flags: DIFlagPrototyped, spFlags: 0)
!165 = !DISubroutineType(types: !166)
!166 = !{!22}
!167 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !168, file: !90, line: 124)
!168 = !DISubprogram(name: "srand", scope: !93, file: !93, line: 455, type: !169, flags: DIFlagPrototyped, spFlags: 0)
!169 = !DISubroutineType(types: !170)
!170 = !{null, !39}
!171 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !172, file: !90, line: 125)
!172 = !DISubprogram(name: "calloc", scope: !93, file: !93, line: 541, type: !173, flags: DIFlagPrototyped, spFlags: 0)
!173 = !DISubroutineType(types: !174)
!174 = !{!175, !88, !88}
!175 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!176 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !177, file: !90, line: 126)
!177 = !DISubprogram(name: "free", scope: !93, file: !93, line: 563, type: !178, flags: DIFlagPrototyped, spFlags: 0)
!178 = !DISubroutineType(types: !179)
!179 = !{null, !175}
!180 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !181, file: !90, line: 127)
!181 = !DISubprogram(name: "malloc", scope: !93, file: !93, line: 539, type: !182, flags: DIFlagPrototyped, spFlags: 0)
!182 = !DISubroutineType(types: !183)
!183 = !{!175, !88}
!184 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !185, file: !90, line: 128)
!185 = !DISubprogram(name: "realloc", scope: !93, file: !93, line: 549, type: !186, flags: DIFlagPrototyped, spFlags: 0)
!186 = !DISubroutineType(types: !187)
!187 = !{!175, !175, !88}
!188 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !189, file: !90, line: 129)
!189 = !DISubprogram(name: "abort", scope: !93, file: !93, line: 588, type: !190, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!190 = !DISubroutineType(types: !191)
!191 = !{null}
!192 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !193, file: !90, line: 130)
!193 = !DISubprogram(name: "atexit", scope: !93, file: !93, line: 592, type: !194, flags: DIFlagPrototyped, spFlags: 0)
!194 = !DISubroutineType(types: !195)
!195 = !{!22, !196}
!196 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !190, size: 64)
!197 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !198, file: !90, line: 131)
!198 = !DISubprogram(name: "exit", scope: !93, file: !93, line: 614, type: !199, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!199 = !DISubroutineType(types: !200)
!200 = !{null, !22}
!201 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !202, file: !90, line: 132)
!202 = !DISubprogram(name: "_Exit", scope: !93, file: !93, line: 626, type: !199, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!203 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !204, file: !90, line: 134)
!204 = !DISubprogram(name: "getenv", scope: !93, file: !93, line: 631, type: !205, flags: DIFlagPrototyped, spFlags: 0)
!205 = !DISubroutineType(types: !206)
!206 = !{!135, !113}
!207 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !208, file: !90, line: 135)
!208 = !DISubprogram(name: "system", scope: !93, file: !93, line: 781, type: !118, flags: DIFlagPrototyped, spFlags: 0)
!209 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !210, file: !90, line: 137)
!210 = !DISubprogram(name: "bsearch", scope: !93, file: !93, line: 817, type: !211, flags: DIFlagPrototyped, spFlags: 0)
!211 = !DISubroutineType(types: !212)
!212 = !{!175, !213, !213, !88, !88, !215}
!213 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !214, size: 64)
!214 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!215 = !DIDerivedType(tag: DW_TAG_typedef, name: "__compar_fn_t", file: !93, line: 805, baseType: !216)
!216 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !217, size: 64)
!217 = !DISubroutineType(types: !218)
!218 = !{!22, !213, !213}
!219 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !220, file: !90, line: 138)
!220 = !DISubprogram(name: "qsort", scope: !93, file: !93, line: 827, type: !221, flags: DIFlagPrototyped, spFlags: 0)
!221 = !DISubroutineType(types: !222)
!222 = !{null, !175, !88, !88, !215}
!223 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !224, file: !90, line: 139)
!224 = !DISubprogram(name: "abs", linkageName: "_Z3absx", scope: !225, file: !225, line: 113, type: !226, flags: DIFlagPrototyped, spFlags: 0)
!225 = !DIFile(filename: "clang_llvm/build_dfsan_full/include/c++/v1/stdlib.h", directory: "/home/mcopik/projects")
!226 = !DISubroutineType(types: !227)
!227 = !{!106, !106}
!228 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !229, file: !90, line: 140)
!229 = !DISubprogram(name: "labs", scope: !93, file: !93, line: 838, type: !230, flags: DIFlagPrototyped, spFlags: 0)
!230 = !DISubroutineType(types: !231)
!231 = !{!26, !26}
!232 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !233, file: !90, line: 142)
!233 = !DISubprogram(name: "llabs", scope: !93, file: !93, line: 841, type: !226, flags: DIFlagPrototyped, spFlags: 0)
!234 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !235, file: !90, line: 144)
!235 = !DISubprogram(name: "div", linkageName: "_Z3divxx", scope: !225, file: !225, line: 118, type: !236, flags: DIFlagPrototyped, spFlags: 0)
!236 = !DISubroutineType(types: !237)
!237 = !{!102, !106, !106}
!238 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !239, file: !90, line: 145)
!239 = !DISubprogram(name: "ldiv", scope: !93, file: !93, line: 851, type: !240, flags: DIFlagPrototyped, spFlags: 0)
!240 = !DISubroutineType(types: !241)
!241 = !{!96, !26, !26}
!242 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !243, file: !90, line: 147)
!243 = !DISubprogram(name: "lldiv", scope: !93, file: !93, line: 855, type: !236, flags: DIFlagPrototyped, spFlags: 0)
!244 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !245, file: !90, line: 149)
!245 = !DISubprogram(name: "mblen", scope: !93, file: !93, line: 919, type: !246, flags: DIFlagPrototyped, spFlags: 0)
!246 = !DISubroutineType(types: !247)
!247 = !{!22, !113, !88}
!248 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !249, file: !90, line: 150)
!249 = !DISubprogram(name: "mbtowc", scope: !93, file: !93, line: 922, type: !250, flags: DIFlagPrototyped, spFlags: 0)
!250 = !DISubroutineType(types: !251)
!251 = !{!22, !252, !132, !88}
!252 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !253)
!253 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !254, size: 64)
!254 = !DIBasicType(name: "wchar_t", size: 32, encoding: DW_ATE_signed)
!255 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !256, file: !90, line: 151)
!256 = !DISubprogram(name: "wctomb", scope: !93, file: !93, line: 926, type: !257, flags: DIFlagPrototyped, spFlags: 0)
!257 = !DISubroutineType(types: !258)
!258 = !{!22, !135, !254}
!259 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !260, file: !90, line: 152)
!260 = !DISubprogram(name: "mbstowcs", scope: !93, file: !93, line: 930, type: !261, flags: DIFlagPrototyped, spFlags: 0)
!261 = !DISubroutineType(types: !262)
!262 = !{!88, !252, !132, !88}
!263 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !264, file: !90, line: 153)
!264 = !DISubprogram(name: "wcstombs", scope: !93, file: !93, line: 933, type: !265, flags: DIFlagPrototyped, spFlags: 0)
!265 = !DISubroutineType(types: !266)
!266 = !{!88, !267, !268, !88}
!267 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !135)
!268 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !269)
!269 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !270, size: 64)
!270 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !254)
!271 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !272, file: !90, line: 155)
!272 = !DISubprogram(name: "at_quick_exit", scope: !93, file: !93, line: 597, type: !194, flags: DIFlagPrototyped, spFlags: 0)
!273 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !12, entity: !274, file: !90, line: 156)
!274 = !DISubprogram(name: "quick_exit", scope: !93, file: !93, line: 620, type: !199, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!275 = !{i32 2, !"Dwarf Version", i32 4}
!276 = !{i32 2, !"Debug Info Version", i32 3}
!277 = !{i32 1, !"wchar_size", i32 4}
!278 = !{!"clang version 8.0.0 (git@github.com:llvm-mirror/clang.git fd01d8b9288b3558a597daeb0cb4481b37c5bf68) (git@github.com:llvm-mirror/LLVM.git 7135d8b482d3d0d1a8c50111eebb9b207e92a8bc)"}
!279 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 53, type: !280, scopeLine: 54, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!280 = !DISubroutineType(types: !281)
!281 = !{!22, !22, !134}
!282 = !DILocalVariable(name: "argc", arg: 1, scope: !279, file: !1, line: 53, type: !22)
!283 = !DILocation(line: 53, column: 14, scope: !279)
!284 = !DILocalVariable(name: "argv", arg: 2, scope: !279, file: !1, line: 53, type: !134)
!285 = !DILocation(line: 53, column: 28, scope: !279)
!286 = !DILocalVariable(name: "size_x", scope: !279, file: !1, line: 55, type: !22)
!287 = !DILocation(line: 55, column: 9, scope: !279)
!288 = !DILocation(line: 55, column: 5, scope: !279)
!289 = !DILocation(line: 55, column: 30, scope: !279)
!290 = !DILocation(line: 55, column: 25, scope: !279)
!291 = !DILocalVariable(name: "size_y", scope: !279, file: !1, line: 56, type: !22)
!292 = !DILocation(line: 56, column: 9, scope: !279)
!293 = !DILocation(line: 56, column: 5, scope: !279)
!294 = !DILocation(line: 56, column: 30, scope: !279)
!295 = !DILocation(line: 56, column: 25, scope: !279)
!296 = !DILocalVariable(name: "size_z", scope: !279, file: !1, line: 57, type: !22)
!297 = !DILocation(line: 57, column: 9, scope: !279)
!298 = !DILocation(line: 57, column: 5, scope: !279)
!299 = !DILocation(line: 57, column: 30, scope: !279)
!300 = !DILocation(line: 57, column: 25, scope: !279)
!301 = !DILocalVariable(name: "g", scope: !279, file: !1, line: 59, type: !302)
!302 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !303, size: 64)
!303 = distinct !DICompositeType(tag: DW_TAG_class_type, name: "Grid", file: !1, line: 6, size: 192, flags: DIFlagTypePassByReference, elements: !304, identifier: "_ZTS4Grid")
!304 = !{!305, !306, !307, !308, !310, !314, !317, !320, !321, !322}
!305 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !303, file: !1, line: 8, baseType: !22, size: 32)
!306 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !303, file: !1, line: 8, baseType: !22, size: 32, offset: 32)
!307 = !DIDerivedType(tag: DW_TAG_member, name: "z", scope: !303, file: !1, line: 8, baseType: !22, size: 32, offset: 64)
!308 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !303, file: !1, line: 9, baseType: !309, size: 64, offset: 128)
!309 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !112, size: 64)
!310 = !DISubprogram(name: "Grid", scope: !303, file: !1, line: 11, type: !311, scopeLine: 11, flags: DIFlagPublic | DIFlagPrototyped, spFlags: 0)
!311 = !DISubroutineType(types: !312)
!312 = !{null, !313, !22, !22, !22}
!313 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !303, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!314 = !DISubprogram(name: "~Grid", scope: !303, file: !1, line: 17, type: !315, scopeLine: 17, flags: DIFlagPublic | DIFlagPrototyped, spFlags: 0)
!315 = !DISubroutineType(types: !316)
!316 = !{null, !313}
!317 = !DISubprogram(name: "update_grid", linkageName: "_ZN4Grid11update_gridEd", scope: !303, file: !1, line: 23, type: !318, scopeLine: 23, flags: DIFlagPublic | DIFlagPrototyped, spFlags: 0)
!318 = !DISubroutineType(types: !319)
!319 = !{null, !313, !112}
!320 = !DISubprogram(name: "update_constant", linkageName: "_ZN4Grid15update_constantEd", scope: !303, file: !1, line: 30, type: !318, scopeLine: 30, flags: DIFlagPublic | DIFlagPrototyped, spFlags: 0)
!321 = !DISubprogram(name: "update_data", linkageName: "_ZN4Grid11update_dataEd", scope: !303, file: !1, line: 38, type: !318, scopeLine: 38, flags: DIFlagPublic | DIFlagPrototyped, spFlags: 0)
!322 = !DISubprogram(name: "update_z", linkageName: "_ZN4Grid8update_zEd", scope: !303, file: !1, line: 46, type: !318, scopeLine: 46, flags: DIFlagPublic | DIFlagPrototyped, spFlags: 0)
!323 = !DILocation(line: 59, column: 12, scope: !279)
!324 = !DILocation(line: 60, column: 5, scope: !279)
!325 = !DILocation(line: 61, column: 5, scope: !279)
!326 = !DILocation(line: 63, column: 9, scope: !279)
!327 = !DILocation(line: 63, column: 18, scope: !279)
!328 = !DILocation(line: 63, column: 26, scope: !279)
!329 = !DILocation(line: 63, column: 34, scope: !279)
!330 = !DILocation(line: 63, column: 13, scope: !279)
!331 = !DILocation(line: 63, column: 7, scope: !279)
!332 = !DILocation(line: 65, column: 5, scope: !279)
!333 = !DILocation(line: 65, column: 8, scope: !279)
!334 = !DILocation(line: 66, column: 5, scope: !279)
!335 = !DILocation(line: 66, column: 8, scope: !279)
!336 = !DILocation(line: 67, column: 5, scope: !279)
!337 = !DILocation(line: 67, column: 8, scope: !279)
!338 = !DILocation(line: 68, column: 5, scope: !279)
!339 = !DILocation(line: 68, column: 8, scope: !279)
!340 = !DILocation(line: 70, column: 12, scope: !279)
!341 = !DILocation(line: 70, column: 5, scope: !279)
!342 = !DILocation(line: 71, column: 5, scope: !279)
!343 = !DILocation(line: 72, column: 1, scope: !279)
!344 = distinct !DISubprogram(name: "register_variable<int>", linkageName: "_Z17register_variableIiEvPT_PKc", scope: !345, file: !345, line: 14, type: !346, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, templateParams: !349, retainedNodes: !2)
!345 = !DIFile(filename: "include/ExtraPInstrumenter.hpp", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!346 = !DISubroutineType(types: !347)
!347 = !{null, !348, !113}
!348 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !22, size: 64)
!349 = !{!350}
!350 = !DITemplateTypeParameter(name: "T", type: !22)
!351 = !DILocalVariable(name: "ptr", arg: 1, scope: !344, file: !345, line: 14, type: !348)
!352 = !DILocation(line: 14, column: 28, scope: !344)
!353 = !DILocalVariable(name: "name", arg: 2, scope: !344, file: !345, line: 14, type: !113)
!354 = !DILocation(line: 14, column: 46, scope: !344)
!355 = !DILocalVariable(name: "param_id", scope: !344, file: !345, line: 16, type: !20)
!356 = !DILocation(line: 16, column: 13, scope: !344)
!357 = !DILocation(line: 16, column: 24, scope: !344)
!358 = !DILocation(line: 17, column: 57, scope: !344)
!359 = !DILocation(line: 17, column: 31, scope: !344)
!360 = !DILocation(line: 18, column: 21, scope: !344)
!361 = !DILocation(line: 18, column: 25, scope: !344)
!362 = !DILocation(line: 17, column: 5, scope: !344)
!363 = !DILocation(line: 19, column: 1, scope: !344)
!364 = distinct !DISubprogram(name: "Grid", linkageName: "_ZN4GridC2Eiii", scope: !303, file: !1, line: 11, type: !311, scopeLine: 16, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, declaration: !310, retainedNodes: !2)
!365 = !DILocalVariable(name: "this", arg: 1, scope: !364, type: !302, flags: DIFlagArtificial | DIFlagObjectPointer)
!366 = !DILocation(line: 0, scope: !364)
!367 = !DILocalVariable(name: "_x", arg: 2, scope: !364, file: !1, line: 11, type: !22)
!368 = !DILocation(line: 11, column: 14, scope: !364)
!369 = !DILocalVariable(name: "_y", arg: 3, scope: !364, file: !1, line: 11, type: !22)
!370 = !DILocation(line: 11, column: 22, scope: !364)
!371 = !DILocalVariable(name: "_z", arg: 4, scope: !364, file: !1, line: 11, type: !22)
!372 = !DILocation(line: 11, column: 30, scope: !364)
!373 = !DILocation(line: 12, column: 9, scope: !364)
!374 = !DILocation(line: 12, column: 11, scope: !364)
!375 = !DILocation(line: 13, column: 9, scope: !364)
!376 = !DILocation(line: 13, column: 11, scope: !364)
!377 = !DILocation(line: 14, column: 9, scope: !364)
!378 = !DILocation(line: 14, column: 11, scope: !364)
!379 = !DILocation(line: 15, column: 9, scope: !364)
!380 = !DILocation(line: 15, column: 25, scope: !364)
!381 = !DILocation(line: 15, column: 27, scope: !364)
!382 = !DILocation(line: 15, column: 26, scope: !364)
!383 = !DILocation(line: 15, column: 14, scope: !364)
!384 = !DILocation(line: 16, column: 10, scope: !364)
!385 = distinct !DISubprogram(name: "update_grid", linkageName: "_ZN4Grid11update_gridEd", scope: !303, file: !1, line: 23, type: !318, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, declaration: !317, retainedNodes: !2)
!386 = !DILocalVariable(name: "this", arg: 1, scope: !385, type: !302, flags: DIFlagArtificial | DIFlagObjectPointer)
!387 = !DILocation(line: 0, scope: !385)
!388 = !DILocalVariable(name: "shift", arg: 2, scope: !385, file: !1, line: 23, type: !112)
!389 = !DILocation(line: 23, column: 29, scope: !385)
!390 = !DILocalVariable(name: "i", scope: !391, file: !1, line: 25, type: !22)
!391 = distinct !DILexicalBlock(scope: !385, file: !1, line: 25, column: 9)
!392 = !DILocation(line: 25, column: 17, scope: !391)
!393 = !DILocation(line: 25, column: 13, scope: !391)
!394 = !DILocation(line: 25, column: 24, scope: !395)
!395 = distinct !DILexicalBlock(scope: !391, file: !1, line: 25, column: 9)
!396 = !DILocation(line: 25, column: 28, scope: !395)
!397 = !DILocation(line: 25, column: 30, scope: !395)
!398 = !DILocation(line: 25, column: 29, scope: !395)
!399 = !DILocation(line: 25, column: 26, scope: !395)
!400 = !DILocation(line: 25, column: 9, scope: !391)
!401 = !DILocation(line: 26, column: 24, scope: !395)
!402 = !DILocation(line: 26, column: 13, scope: !395)
!403 = !DILocation(line: 26, column: 18, scope: !395)
!404 = !DILocation(line: 26, column: 21, scope: !395)
!405 = !DILocation(line: 25, column: 32, scope: !395)
!406 = !DILocation(line: 25, column: 9, scope: !395)
!407 = distinct !{!407, !400, !408}
!408 = !DILocation(line: 26, column: 24, scope: !391)
!409 = !DILocation(line: 27, column: 5, scope: !385)
!410 = distinct !DISubprogram(name: "update_constant", linkageName: "_ZN4Grid15update_constantEd", scope: !303, file: !1, line: 30, type: !318, scopeLine: 31, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, declaration: !320, retainedNodes: !2)
!411 = !DILocalVariable(name: "this", arg: 1, scope: !410, type: !302, flags: DIFlagArtificial | DIFlagObjectPointer)
!412 = !DILocation(line: 0, scope: !410)
!413 = !DILocalVariable(name: "shift", arg: 2, scope: !410, file: !1, line: 30, type: !112)
!414 = !DILocation(line: 30, column: 33, scope: !410)
!415 = !DILocation(line: 32, column: 22, scope: !410)
!416 = !DILocation(line: 32, column: 21, scope: !410)
!417 = !DILocation(line: 32, column: 9, scope: !410)
!418 = !DILocation(line: 32, column: 17, scope: !410)
!419 = !DILocalVariable(name: "i", scope: !420, file: !1, line: 33, type: !22)
!420 = distinct !DILexicalBlock(scope: !410, file: !1, line: 33, column: 9)
!421 = !DILocation(line: 33, column: 17, scope: !420)
!422 = !DILocation(line: 33, column: 13, scope: !420)
!423 = !DILocation(line: 33, column: 24, scope: !424)
!424 = distinct !DILexicalBlock(scope: !420, file: !1, line: 33, column: 9)
!425 = !DILocation(line: 33, column: 26, scope: !424)
!426 = !DILocation(line: 33, column: 9, scope: !420)
!427 = !DILocation(line: 34, column: 24, scope: !424)
!428 = !DILocation(line: 34, column: 13, scope: !424)
!429 = !DILocation(line: 34, column: 18, scope: !424)
!430 = !DILocation(line: 34, column: 21, scope: !424)
!431 = !DILocation(line: 33, column: 30, scope: !424)
!432 = !DILocation(line: 33, column: 9, scope: !424)
!433 = distinct !{!433, !426, !434}
!434 = !DILocation(line: 34, column: 24, scope: !420)
!435 = !DILocation(line: 35, column: 5, scope: !410)
!436 = distinct !DISubprogram(name: "update_data", linkageName: "_ZN4Grid11update_dataEd", scope: !303, file: !1, line: 38, type: !318, scopeLine: 39, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, declaration: !321, retainedNodes: !2)
!437 = !DILocalVariable(name: "this", arg: 1, scope: !436, type: !302, flags: DIFlagArtificial | DIFlagObjectPointer)
!438 = !DILocation(line: 0, scope: !436)
!439 = !DILocalVariable(name: "shift", arg: 2, scope: !436, file: !1, line: 38, type: !112)
!440 = !DILocation(line: 38, column: 29, scope: !436)
!441 = !DILocation(line: 40, column: 22, scope: !436)
!442 = !DILocation(line: 40, column: 21, scope: !436)
!443 = !DILocation(line: 40, column: 9, scope: !436)
!444 = !DILocation(line: 40, column: 17, scope: !436)
!445 = !DILocalVariable(name: "i", scope: !446, file: !1, line: 41, type: !22)
!446 = distinct !DILexicalBlock(scope: !436, file: !1, line: 41, column: 9)
!447 = !DILocation(line: 41, column: 17, scope: !446)
!448 = !DILocation(line: 41, column: 21, scope: !446)
!449 = !DILocation(line: 41, column: 13, scope: !446)
!450 = !DILocation(line: 41, column: 30, scope: !451)
!451 = distinct !DILexicalBlock(scope: !446, file: !1, line: 41, column: 9)
!452 = !DILocation(line: 41, column: 32, scope: !451)
!453 = !DILocation(line: 41, column: 9, scope: !446)
!454 = !DILocation(line: 42, column: 24, scope: !451)
!455 = !DILocation(line: 42, column: 13, scope: !451)
!456 = !DILocation(line: 42, column: 18, scope: !451)
!457 = !DILocation(line: 42, column: 21, scope: !451)
!458 = !DILocation(line: 41, column: 36, scope: !451)
!459 = !DILocation(line: 41, column: 9, scope: !451)
!460 = distinct !{!460, !453, !461}
!461 = !DILocation(line: 42, column: 24, scope: !446)
!462 = !DILocation(line: 43, column: 5, scope: !436)
!463 = distinct !DISubprogram(name: "update_z", linkageName: "_ZN4Grid8update_zEd", scope: !303, file: !1, line: 46, type: !318, scopeLine: 47, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, declaration: !322, retainedNodes: !2)
!464 = !DILocalVariable(name: "this", arg: 1, scope: !463, type: !302, flags: DIFlagArtificial | DIFlagObjectPointer)
!465 = !DILocation(line: 0, scope: !463)
!466 = !DILocalVariable(name: "shift", arg: 2, scope: !463, file: !1, line: 46, type: !112)
!467 = !DILocation(line: 46, column: 26, scope: !463)
!468 = !DILocalVariable(name: "i", scope: !469, file: !1, line: 48, type: !22)
!469 = distinct !DILexicalBlock(scope: !463, file: !1, line: 48, column: 9)
!470 = !DILocation(line: 48, column: 17, scope: !469)
!471 = !DILocation(line: 48, column: 13, scope: !469)
!472 = !DILocation(line: 48, column: 24, scope: !473)
!473 = distinct !DILexicalBlock(scope: !469, file: !1, line: 48, column: 9)
!474 = !DILocation(line: 48, column: 28, scope: !473)
!475 = !DILocation(line: 48, column: 26, scope: !473)
!476 = !DILocation(line: 48, column: 9, scope: !469)
!477 = !DILocation(line: 49, column: 24, scope: !473)
!478 = !DILocation(line: 49, column: 13, scope: !473)
!479 = !DILocation(line: 49, column: 18, scope: !473)
!480 = !DILocation(line: 49, column: 21, scope: !473)
!481 = !DILocation(line: 48, column: 30, scope: !473)
!482 = !DILocation(line: 48, column: 9, scope: !473)
!483 = distinct !{!483, !476, !484}
!484 = !DILocation(line: 49, column: 24, scope: !469)
!485 = !DILocation(line: 50, column: 5, scope: !463)
!486 = distinct !DISubprogram(name: "~Grid", linkageName: "_ZN4GridD2Ev", scope: !303, file: !1, line: 17, type: !315, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, declaration: !314, retainedNodes: !2)
!487 = !DILocalVariable(name: "this", arg: 1, scope: !486, type: !302, flags: DIFlagArtificial | DIFlagObjectPointer)
!488 = !DILocation(line: 0, scope: !486)
!489 = !DILocation(line: 19, column: 18, scope: !490)
!490 = distinct !DILexicalBlock(scope: !486, file: !1, line: 18, column: 5)
!491 = !DILocation(line: 19, column: 9, scope: !490)
!492 = !DILocation(line: 20, column: 5, scope: !486)
