; RUN: opt %dfsan -S < %s 2> /dev/null | llc %llcparams - -o %t1 | clang++ %link %s.o -o %t1 | %execparams %t1 10 10 10 | diff -w %s.json -

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

$_ZZ17register_variableIiEvPT_PKcE8param_id = comdat any

@.str = private unnamed_addr constant [7 x i8] c"extrap\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [32 x i8] c"tests/dfsan-instr/cpp_class.cpp\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [7 x i8] c"size_x\00", align 1
@.str.3 = private unnamed_addr constant [7 x i8] c"size_y\00", align 1
@_ZZ17register_variableIiEvPT_PKcE8param_id = linkonce_odr dso_local global i32 0, comdat, align 4, !dbg !0

; Function Attrs: noinline norecurse optnone uwtable
define dso_local i32 @main(i32, i8**) #0 personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) !dbg !289 {
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
  call void @llvm.dbg.declare(metadata i32* %4, metadata !292, metadata !DIExpression()), !dbg !293
  store i8** %1, i8*** %5, align 8
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !294, metadata !DIExpression()), !dbg !295
  call void @llvm.dbg.declare(metadata i32* %6, metadata !296, metadata !DIExpression()), !dbg !297
  %12 = bitcast i32* %6 to i8*, !dbg !298
  call void @llvm.var.annotation(i8* %12, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.1, i32 0, i32 0), i32 55), !dbg !298
  %13 = load i8**, i8*** %5, align 8, !dbg !299
  %14 = getelementptr inbounds i8*, i8** %13, i64 1, !dbg !299
  %15 = load i8*, i8** %14, align 8, !dbg !299
  %16 = call i32 @atoi(i8* %15) #9, !dbg !300
  store i32 %16, i32* %6, align 4, !dbg !297
  call void @llvm.dbg.declare(metadata i32* %7, metadata !301, metadata !DIExpression()), !dbg !302
  %17 = bitcast i32* %7 to i8*, !dbg !303
  call void @llvm.var.annotation(i8* %17, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.1, i32 0, i32 0), i32 56), !dbg !303
  %18 = load i8**, i8*** %5, align 8, !dbg !304
  %19 = getelementptr inbounds i8*, i8** %18, i64 2, !dbg !304
  %20 = load i8*, i8** %19, align 8, !dbg !304
  %21 = call i32 @atoi(i8* %20) #9, !dbg !305
  store i32 %21, i32* %7, align 4, !dbg !302
  call void @llvm.dbg.declare(metadata i32* %8, metadata !306, metadata !DIExpression()), !dbg !307
  %22 = bitcast i32* %8 to i8*, !dbg !308
  call void @llvm.var.annotation(i8* %22, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.1, i32 0, i32 0), i32 57), !dbg !308
  %23 = load i8**, i8*** %5, align 8, !dbg !309
  %24 = getelementptr inbounds i8*, i8** %23, i64 3, !dbg !309
  %25 = load i8*, i8** %24, align 8, !dbg !309
  %26 = call i32 @atoi(i8* %25) #9, !dbg !310
  store i32 %26, i32* %8, align 4, !dbg !307
  call void @llvm.dbg.declare(metadata %class.Grid** %9, metadata !311, metadata !DIExpression()), !dbg !333
  call void @_Z17register_variableIiEvPT_PKc(i32* %6, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0)), !dbg !334
  call void @_Z17register_variableIiEvPT_PKc(i32* %7, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.3, i32 0, i32 0)), !dbg !335
  %27 = call i8* @_Znwm(i64 24) #10, !dbg !336
  %28 = bitcast i8* %27 to %class.Grid*, !dbg !336
  %29 = load i32, i32* %6, align 4, !dbg !337
  %30 = load i32, i32* %7, align 4, !dbg !338
  %31 = load i32, i32* %8, align 4, !dbg !339
  invoke void @_ZN4GridC2Eiii(%class.Grid* %28, i32 %29, i32 %30, i32 %31)
          to label %32 unwind label %42, !dbg !340

; <label>:32:                                     ; preds = %2
  store %class.Grid* %28, %class.Grid** %9, align 8, !dbg !341
  %33 = load %class.Grid*, %class.Grid** %9, align 8, !dbg !342
  call void @_ZN4Grid11update_gridEd(%class.Grid* %33, double 2.000000e+00), !dbg !343
  %34 = load %class.Grid*, %class.Grid** %9, align 8, !dbg !344
  call void @_ZN4Grid15update_constantEd(%class.Grid* %34, double 1.500000e+00), !dbg !345
  %35 = load %class.Grid*, %class.Grid** %9, align 8, !dbg !346
  call void @_ZN4Grid11update_dataEd(%class.Grid* %35, double 1.500000e+00), !dbg !347
  %36 = load %class.Grid*, %class.Grid** %9, align 8, !dbg !348
  call void @_ZN4Grid8update_zEd(%class.Grid* %36, double 1.500000e+00), !dbg !349
  %37 = load %class.Grid*, %class.Grid** %9, align 8, !dbg !350
  %38 = icmp eq %class.Grid* %37, null, !dbg !351
  br i1 %38, label %41, label %39, !dbg !351

; <label>:39:                                     ; preds = %32
  call void @_ZN4GridD2Ev(%class.Grid* %37) #2, !dbg !351
  %40 = bitcast %class.Grid* %37 to i8*, !dbg !351
  call void @_ZdlPv(i8* %40) #11, !dbg !351
  br label %41, !dbg !351

; <label>:41:                                     ; preds = %39, %32
  ret i32 0, !dbg !352

; <label>:42:                                     ; preds = %2
  %43 = landingpad { i8*, i32 }
          cleanup, !dbg !353
  %44 = extractvalue { i8*, i32 } %43, 0, !dbg !353
  store i8* %44, i8** %10, align 8, !dbg !353
  %45 = extractvalue { i8*, i32 } %43, 1, !dbg !353
  store i32 %45, i32* %11, align 4, !dbg !353
  call void @_ZdlPv(i8* %27) #11, !dbg !336
  br label %46, !dbg !336

; <label>:46:                                     ; preds = %42
  %47 = load i8*, i8** %10, align 8, !dbg !336
  %48 = load i32, i32* %11, align 4, !dbg !336
  %49 = insertvalue { i8*, i32 } undef, i8* %47, 0, !dbg !336
  %50 = insertvalue { i8*, i32 } %49, i32 %48, 1, !dbg !336
  resume { i8*, i32 } %50, !dbg !336
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind
declare void @llvm.var.annotation(i8*, i8*, i8*, i32) #2

; Function Attrs: nounwind readonly
declare dso_local i32 @atoi(i8*) #3

; Function Attrs: noinline optnone uwtable
define linkonce_odr dso_local void @_Z17register_variableIiEvPT_PKc(i32*, i8*) #4 comdat !dbg !2 {
  %3 = alloca i32*, align 8
  %4 = alloca i8*, align 8
  store i32* %0, i32** %3, align 8
  call void @llvm.dbg.declare(metadata i32** %3, metadata !354, metadata !DIExpression()), !dbg !355
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !356, metadata !DIExpression()), !dbg !357
  %5 = load i32*, i32** %3, align 8, !dbg !358
  %6 = bitcast i32* %5 to i8*, !dbg !359
  %7 = load i32, i32* @_ZZ17register_variableIiEvPT_PKcE8param_id, align 4, !dbg !360
  %8 = add nsw i32 %7, 1, !dbg !360
  store i32 %8, i32* @_ZZ17register_variableIiEvPT_PKcE8param_id, align 4, !dbg !360
  %9 = load i8*, i8** %4, align 8, !dbg !361
  call void @__dfsw_EXTRAP_STORE_LABEL(i8* %6, i32 4, i32 %7, i8* %9), !dbg !362
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
  %27 = call i8* @_Znam(i64 %26) #10, !dbg !383
  %28 = bitcast i8* %27 to double*, !dbg !383
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
  call void @_ZdaPv(i8* %8) #11, !dbg !491
  br label %9, !dbg !491

; <label>:9:                                      ; preds = %7, %1
  ret void, !dbg !492
}

; Function Attrs: nounwind readnone speculatable
declare { i64, i1 } @llvm.umul.with.overflow.i64(i64, i64) #1

; Function Attrs: nobuiltin
declare dso_local noalias i8* @_Znam(i64) #5

; Function Attrs: nobuiltin nounwind
declare dso_local void @_ZdaPv(i8*) #6

declare dso_local void @__dfsw_EXTRAP_STORE_LABEL(i8*, i32, i32, i8*) #8

attributes #0 = { noinline norecurse optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { nounwind }
attributes #3 = { nounwind readonly "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { noinline optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { nobuiltin "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #6 = { nobuiltin nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #7 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #8 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #9 = { nounwind readonly }
attributes #10 = { builtin }
attributes #11 = { builtin nounwind }

!llvm.dbg.cu = !{!11}
!llvm.module.flags = !{!285, !286, !287}
!llvm.ident = !{!288}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "param_id", scope: !2, file: !3, line: 13, type: !32, isLocal: false, isDefinition: true)
!2 = distinct !DISubprogram(name: "register_variable<int>", linkageName: "_Z17register_variableIiEvPT_PKc", scope: !3, file: !3, line: 11, type: !4, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !11, templateParams: !283, retainedNodes: !13)
!3 = !DIFile(filename: "include/ExtrapInstrumenter.hpp", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!4 = !DISubroutineType(types: !5)
!5 = !{null, !6, !8}
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!7 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!8 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !9, size: 64)
!9 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !10)
!10 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!11 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !12, producer: "clang version 8.0.0 (git@github.com:llvm-mirror/clang.git fd01d8b9288b3558a597daeb0cb4481b37c5bf68) (git@github.com:llvm-mirror/LLVM.git 7135d8b482d3d0d1a8c50111eebb9b207e92a8bc)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !13, retainedTypes: !14, globals: !21, imports: !22, nameTableKind: None)
!12 = !DIFile(filename: "tests/dfsan-instr/cpp_class.cpp", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!13 = !{}
!14 = !{!15}
!15 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !16, size: 64)
!16 = !DIDerivedType(tag: DW_TAG_typedef, name: "int8_t", file: !17, line: 24, baseType: !18)
!17 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-intn.h", directory: "")
!18 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int8_t", file: !19, line: 36, baseType: !20)
!19 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "")
!20 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!21 = !{!0}
!22 = !{!23, !27, !31, !34, !38, !43, !47, !51, !55, !58, !60, !62, !64, !66, !68, !70, !72, !74, !76, !78, !80, !82, !84, !86, !88, !90, !92, !95, !98, !102, !106, !112, !119, !124, !128, !132, !136, !144, !149, !154, !158, !162, !166, !171, !175, !179, !184, !188, !192, !196, !200, !205, !209, !211, !215, !217, !227, !231, !236, !240, !242, !246, !250, !252, !256, !263, !267, !271, !279, !281}
!23 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !16, file: !26, line: 153)
!24 = !DINamespace(name: "__1", scope: !25, exportSymbols: true)
!25 = !DINamespace(name: "std", scope: null)
!26 = !DIFile(filename: "clang_llvm/build_dfsan_full/include/c++/v1/cstdint", directory: "/home/mcopik/projects")
!27 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !28, file: !26, line: 154)
!28 = !DIDerivedType(tag: DW_TAG_typedef, name: "int16_t", file: !17, line: 25, baseType: !29)
!29 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int16_t", file: !19, line: 38, baseType: !30)
!30 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!31 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !32, file: !26, line: 155)
!32 = !DIDerivedType(tag: DW_TAG_typedef, name: "int32_t", file: !17, line: 26, baseType: !33)
!33 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int32_t", file: !19, line: 40, baseType: !7)
!34 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !35, file: !26, line: 156)
!35 = !DIDerivedType(tag: DW_TAG_typedef, name: "int64_t", file: !17, line: 27, baseType: !36)
!36 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int64_t", file: !19, line: 43, baseType: !37)
!37 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!38 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !39, file: !26, line: 158)
!39 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint8_t", file: !40, line: 24, baseType: !41)
!40 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "")
!41 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint8_t", file: !19, line: 37, baseType: !42)
!42 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!43 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !44, file: !26, line: 159)
!44 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint16_t", file: !40, line: 25, baseType: !45)
!45 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint16_t", file: !19, line: 39, baseType: !46)
!46 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!47 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !48, file: !26, line: 160)
!48 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !40, line: 26, baseType: !49)
!49 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !19, line: 41, baseType: !50)
!50 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!51 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !52, file: !26, line: 161)
!52 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", file: !40, line: 27, baseType: !53)
!53 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint64_t", file: !19, line: 44, baseType: !54)
!54 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!55 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !56, file: !26, line: 163)
!56 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least8_t", file: !57, line: 43, baseType: !20)
!57 = !DIFile(filename: "/usr/include/stdint.h", directory: "")
!58 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !59, file: !26, line: 164)
!59 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least16_t", file: !57, line: 44, baseType: !30)
!60 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !61, file: !26, line: 165)
!61 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least32_t", file: !57, line: 45, baseType: !7)
!62 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !63, file: !26, line: 166)
!63 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least64_t", file: !57, line: 47, baseType: !37)
!64 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !65, file: !26, line: 168)
!65 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least8_t", file: !57, line: 54, baseType: !42)
!66 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !67, file: !26, line: 169)
!67 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least16_t", file: !57, line: 55, baseType: !46)
!68 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !69, file: !26, line: 170)
!69 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least32_t", file: !57, line: 56, baseType: !50)
!70 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !71, file: !26, line: 171)
!71 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least64_t", file: !57, line: 58, baseType: !54)
!72 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !73, file: !26, line: 173)
!73 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast8_t", file: !57, line: 68, baseType: !20)
!74 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !75, file: !26, line: 174)
!75 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast16_t", file: !57, line: 70, baseType: !37)
!76 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !77, file: !26, line: 175)
!77 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast32_t", file: !57, line: 71, baseType: !37)
!78 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !79, file: !26, line: 176)
!79 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast64_t", file: !57, line: 72, baseType: !37)
!80 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !81, file: !26, line: 178)
!81 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast8_t", file: !57, line: 81, baseType: !42)
!82 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !83, file: !26, line: 179)
!83 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast16_t", file: !57, line: 83, baseType: !54)
!84 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !85, file: !26, line: 180)
!85 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast32_t", file: !57, line: 84, baseType: !54)
!86 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !87, file: !26, line: 181)
!87 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast64_t", file: !57, line: 85, baseType: !54)
!88 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !89, file: !26, line: 183)
!89 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !57, line: 97, baseType: !37)
!90 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !91, file: !26, line: 184)
!91 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !57, line: 100, baseType: !54)
!92 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !93, file: !26, line: 186)
!93 = !DIDerivedType(tag: DW_TAG_typedef, name: "intmax_t", file: !57, line: 111, baseType: !94)
!94 = !DIDerivedType(tag: DW_TAG_typedef, name: "__intmax_t", file: !19, line: 61, baseType: !37)
!95 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !96, file: !26, line: 187)
!96 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintmax_t", file: !57, line: 112, baseType: !97)
!97 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uintmax_t", file: !19, line: 62, baseType: !54)
!98 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !99, file: !101, line: 100)
!99 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !100, line: 216, baseType: !54)
!100 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7/include/stddef.h", directory: "")
!101 = !DIFile(filename: "clang_llvm/build_dfsan_full/include/c++/v1/cstdlib", directory: "/home/mcopik/projects")
!102 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !103, file: !101, line: 101)
!103 = !DIDerivedType(tag: DW_TAG_typedef, name: "div_t", file: !104, line: 62, baseType: !105)
!104 = !DIFile(filename: "/usr/include/stdlib.h", directory: "")
!105 = !DICompositeType(tag: DW_TAG_structure_type, file: !104, line: 58, flags: DIFlagFwdDecl, identifier: "_ZTS5div_t")
!106 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !107, file: !101, line: 102)
!107 = !DIDerivedType(tag: DW_TAG_typedef, name: "ldiv_t", file: !104, line: 70, baseType: !108)
!108 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !104, line: 66, size: 128, flags: DIFlagTypePassByValue | DIFlagTrivial, elements: !109, identifier: "_ZTS6ldiv_t")
!109 = !{!110, !111}
!110 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !108, file: !104, line: 68, baseType: !37, size: 64)
!111 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !108, file: !104, line: 69, baseType: !37, size: 64, offset: 64)
!112 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !113, file: !101, line: 104)
!113 = !DIDerivedType(tag: DW_TAG_typedef, name: "lldiv_t", file: !104, line: 80, baseType: !114)
!114 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !104, line: 76, size: 128, flags: DIFlagTypePassByValue | DIFlagTrivial, elements: !115, identifier: "_ZTS7lldiv_t")
!115 = !{!116, !118}
!116 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !114, file: !104, line: 78, baseType: !117, size: 64)
!117 = !DIBasicType(name: "long long int", size: 64, encoding: DW_ATE_signed)
!118 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !114, file: !104, line: 79, baseType: !117, size: 64, offset: 64)
!119 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !120, file: !101, line: 106)
!120 = !DISubprogram(name: "atof", scope: !104, file: !104, line: 101, type: !121, flags: DIFlagPrototyped, spFlags: 0)
!121 = !DISubroutineType(types: !122)
!122 = !{!123, !8}
!123 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!124 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !125, file: !101, line: 107)
!125 = !DISubprogram(name: "atoi", scope: !104, file: !104, line: 104, type: !126, flags: DIFlagPrototyped, spFlags: 0)
!126 = !DISubroutineType(types: !127)
!127 = !{!7, !8}
!128 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !129, file: !101, line: 108)
!129 = !DISubprogram(name: "atol", scope: !104, file: !104, line: 107, type: !130, flags: DIFlagPrototyped, spFlags: 0)
!130 = !DISubroutineType(types: !131)
!131 = !{!37, !8}
!132 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !133, file: !101, line: 110)
!133 = !DISubprogram(name: "atoll", scope: !104, file: !104, line: 112, type: !134, flags: DIFlagPrototyped, spFlags: 0)
!134 = !DISubroutineType(types: !135)
!135 = !{!117, !8}
!136 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !137, file: !101, line: 112)
!137 = !DISubprogram(name: "strtod", scope: !104, file: !104, line: 117, type: !138, flags: DIFlagPrototyped, spFlags: 0)
!138 = !DISubroutineType(types: !139)
!139 = !{!123, !140, !141}
!140 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !8)
!141 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !142)
!142 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !143, size: 64)
!143 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !10, size: 64)
!144 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !145, file: !101, line: 113)
!145 = !DISubprogram(name: "strtof", scope: !104, file: !104, line: 123, type: !146, flags: DIFlagPrototyped, spFlags: 0)
!146 = !DISubroutineType(types: !147)
!147 = !{!148, !140, !141}
!148 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!149 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !150, file: !101, line: 114)
!150 = !DISubprogram(name: "strtold", scope: !104, file: !104, line: 126, type: !151, flags: DIFlagPrototyped, spFlags: 0)
!151 = !DISubroutineType(types: !152)
!152 = !{!153, !140, !141}
!153 = !DIBasicType(name: "long double", size: 128, encoding: DW_ATE_float)
!154 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !155, file: !101, line: 115)
!155 = !DISubprogram(name: "strtol", scope: !104, file: !104, line: 176, type: !156, flags: DIFlagPrototyped, spFlags: 0)
!156 = !DISubroutineType(types: !157)
!157 = !{!37, !140, !141, !7}
!158 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !159, file: !101, line: 117)
!159 = !DISubprogram(name: "strtoll", scope: !104, file: !104, line: 200, type: !160, flags: DIFlagPrototyped, spFlags: 0)
!160 = !DISubroutineType(types: !161)
!161 = !{!117, !140, !141, !7}
!162 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !163, file: !101, line: 119)
!163 = !DISubprogram(name: "strtoul", scope: !104, file: !104, line: 180, type: !164, flags: DIFlagPrototyped, spFlags: 0)
!164 = !DISubroutineType(types: !165)
!165 = !{!54, !140, !141, !7}
!166 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !167, file: !101, line: 121)
!167 = !DISubprogram(name: "strtoull", scope: !104, file: !104, line: 205, type: !168, flags: DIFlagPrototyped, spFlags: 0)
!168 = !DISubroutineType(types: !169)
!169 = !{!170, !140, !141, !7}
!170 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!171 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !172, file: !101, line: 123)
!172 = !DISubprogram(name: "rand", scope: !104, file: !104, line: 453, type: !173, flags: DIFlagPrototyped, spFlags: 0)
!173 = !DISubroutineType(types: !174)
!174 = !{!7}
!175 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !176, file: !101, line: 124)
!176 = !DISubprogram(name: "srand", scope: !104, file: !104, line: 455, type: !177, flags: DIFlagPrototyped, spFlags: 0)
!177 = !DISubroutineType(types: !178)
!178 = !{null, !50}
!179 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !180, file: !101, line: 125)
!180 = !DISubprogram(name: "calloc", scope: !104, file: !104, line: 541, type: !181, flags: DIFlagPrototyped, spFlags: 0)
!181 = !DISubroutineType(types: !182)
!182 = !{!183, !99, !99}
!183 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!184 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !185, file: !101, line: 126)
!185 = !DISubprogram(name: "free", scope: !104, file: !104, line: 563, type: !186, flags: DIFlagPrototyped, spFlags: 0)
!186 = !DISubroutineType(types: !187)
!187 = !{null, !183}
!188 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !189, file: !101, line: 127)
!189 = !DISubprogram(name: "malloc", scope: !104, file: !104, line: 539, type: !190, flags: DIFlagPrototyped, spFlags: 0)
!190 = !DISubroutineType(types: !191)
!191 = !{!183, !99}
!192 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !193, file: !101, line: 128)
!193 = !DISubprogram(name: "realloc", scope: !104, file: !104, line: 549, type: !194, flags: DIFlagPrototyped, spFlags: 0)
!194 = !DISubroutineType(types: !195)
!195 = !{!183, !183, !99}
!196 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !197, file: !101, line: 129)
!197 = !DISubprogram(name: "abort", scope: !104, file: !104, line: 588, type: !198, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!198 = !DISubroutineType(types: !199)
!199 = !{null}
!200 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !201, file: !101, line: 130)
!201 = !DISubprogram(name: "atexit", scope: !104, file: !104, line: 592, type: !202, flags: DIFlagPrototyped, spFlags: 0)
!202 = !DISubroutineType(types: !203)
!203 = !{!7, !204}
!204 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !198, size: 64)
!205 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !206, file: !101, line: 131)
!206 = !DISubprogram(name: "exit", scope: !104, file: !104, line: 614, type: !207, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!207 = !DISubroutineType(types: !208)
!208 = !{null, !7}
!209 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !210, file: !101, line: 132)
!210 = !DISubprogram(name: "_Exit", scope: !104, file: !104, line: 626, type: !207, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!211 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !212, file: !101, line: 134)
!212 = !DISubprogram(name: "getenv", scope: !104, file: !104, line: 631, type: !213, flags: DIFlagPrototyped, spFlags: 0)
!213 = !DISubroutineType(types: !214)
!214 = !{!143, !8}
!215 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !216, file: !101, line: 135)
!216 = !DISubprogram(name: "system", scope: !104, file: !104, line: 781, type: !126, flags: DIFlagPrototyped, spFlags: 0)
!217 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !218, file: !101, line: 137)
!218 = !DISubprogram(name: "bsearch", scope: !104, file: !104, line: 817, type: !219, flags: DIFlagPrototyped, spFlags: 0)
!219 = !DISubroutineType(types: !220)
!220 = !{!183, !221, !221, !99, !99, !223}
!221 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !222, size: 64)
!222 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!223 = !DIDerivedType(tag: DW_TAG_typedef, name: "__compar_fn_t", file: !104, line: 805, baseType: !224)
!224 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !225, size: 64)
!225 = !DISubroutineType(types: !226)
!226 = !{!7, !221, !221}
!227 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !228, file: !101, line: 138)
!228 = !DISubprogram(name: "qsort", scope: !104, file: !104, line: 827, type: !229, flags: DIFlagPrototyped, spFlags: 0)
!229 = !DISubroutineType(types: !230)
!230 = !{null, !183, !99, !99, !223}
!231 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !232, file: !101, line: 139)
!232 = !DISubprogram(name: "abs", linkageName: "_Z3absx", scope: !233, file: !233, line: 113, type: !234, flags: DIFlagPrototyped, spFlags: 0)
!233 = !DIFile(filename: "clang_llvm/build_dfsan_full/include/c++/v1/stdlib.h", directory: "/home/mcopik/projects")
!234 = !DISubroutineType(types: !235)
!235 = !{!117, !117}
!236 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !237, file: !101, line: 140)
!237 = !DISubprogram(name: "labs", scope: !104, file: !104, line: 838, type: !238, flags: DIFlagPrototyped, spFlags: 0)
!238 = !DISubroutineType(types: !239)
!239 = !{!37, !37}
!240 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !241, file: !101, line: 142)
!241 = !DISubprogram(name: "llabs", scope: !104, file: !104, line: 841, type: !234, flags: DIFlagPrototyped, spFlags: 0)
!242 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !243, file: !101, line: 144)
!243 = !DISubprogram(name: "div", linkageName: "_Z3divxx", scope: !233, file: !233, line: 118, type: !244, flags: DIFlagPrototyped, spFlags: 0)
!244 = !DISubroutineType(types: !245)
!245 = !{!113, !117, !117}
!246 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !247, file: !101, line: 145)
!247 = !DISubprogram(name: "ldiv", scope: !104, file: !104, line: 851, type: !248, flags: DIFlagPrototyped, spFlags: 0)
!248 = !DISubroutineType(types: !249)
!249 = !{!107, !37, !37}
!250 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !251, file: !101, line: 147)
!251 = !DISubprogram(name: "lldiv", scope: !104, file: !104, line: 855, type: !244, flags: DIFlagPrototyped, spFlags: 0)
!252 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !253, file: !101, line: 149)
!253 = !DISubprogram(name: "mblen", scope: !104, file: !104, line: 919, type: !254, flags: DIFlagPrototyped, spFlags: 0)
!254 = !DISubroutineType(types: !255)
!255 = !{!7, !8, !99}
!256 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !257, file: !101, line: 150)
!257 = !DISubprogram(name: "mbtowc", scope: !104, file: !104, line: 922, type: !258, flags: DIFlagPrototyped, spFlags: 0)
!258 = !DISubroutineType(types: !259)
!259 = !{!7, !260, !140, !99}
!260 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !261)
!261 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !262, size: 64)
!262 = !DIBasicType(name: "wchar_t", size: 32, encoding: DW_ATE_signed)
!263 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !264, file: !101, line: 151)
!264 = !DISubprogram(name: "wctomb", scope: !104, file: !104, line: 926, type: !265, flags: DIFlagPrototyped, spFlags: 0)
!265 = !DISubroutineType(types: !266)
!266 = !{!7, !143, !262}
!267 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !268, file: !101, line: 152)
!268 = !DISubprogram(name: "mbstowcs", scope: !104, file: !104, line: 930, type: !269, flags: DIFlagPrototyped, spFlags: 0)
!269 = !DISubroutineType(types: !270)
!270 = !{!99, !260, !140, !99}
!271 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !272, file: !101, line: 153)
!272 = !DISubprogram(name: "wcstombs", scope: !104, file: !104, line: 933, type: !273, flags: DIFlagPrototyped, spFlags: 0)
!273 = !DISubroutineType(types: !274)
!274 = !{!99, !275, !276, !99}
!275 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !143)
!276 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !277)
!277 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !278, size: 64)
!278 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !262)
!279 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !280, file: !101, line: 155)
!280 = !DISubprogram(name: "at_quick_exit", scope: !104, file: !104, line: 597, type: !202, flags: DIFlagPrototyped, spFlags: 0)
!281 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !24, entity: !282, file: !101, line: 156)
!282 = !DISubprogram(name: "quick_exit", scope: !104, file: !104, line: 620, type: !207, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!283 = !{!284}
!284 = !DITemplateTypeParameter(name: "T", type: !7)
!285 = !{i32 2, !"Dwarf Version", i32 4}
!286 = !{i32 2, !"Debug Info Version", i32 3}
!287 = !{i32 1, !"wchar_size", i32 4}
!288 = !{!"clang version 8.0.0 (git@github.com:llvm-mirror/clang.git fd01d8b9288b3558a597daeb0cb4481b37c5bf68) (git@github.com:llvm-mirror/LLVM.git 7135d8b482d3d0d1a8c50111eebb9b207e92a8bc)"}
!289 = distinct !DISubprogram(name: "main", scope: !12, file: !12, line: 53, type: !290, scopeLine: 54, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !11, retainedNodes: !13)
!290 = !DISubroutineType(types: !291)
!291 = !{!7, !7, !142}
!292 = !DILocalVariable(name: "argc", arg: 1, scope: !289, file: !12, line: 53, type: !7)
!293 = !DILocation(line: 53, column: 14, scope: !289)
!294 = !DILocalVariable(name: "argv", arg: 2, scope: !289, file: !12, line: 53, type: !142)
!295 = !DILocation(line: 53, column: 28, scope: !289)
!296 = !DILocalVariable(name: "size_x", scope: !289, file: !12, line: 55, type: !7)
!297 = !DILocation(line: 55, column: 9, scope: !289)
!298 = !DILocation(line: 55, column: 5, scope: !289)
!299 = !DILocation(line: 55, column: 30, scope: !289)
!300 = !DILocation(line: 55, column: 25, scope: !289)
!301 = !DILocalVariable(name: "size_y", scope: !289, file: !12, line: 56, type: !7)
!302 = !DILocation(line: 56, column: 9, scope: !289)
!303 = !DILocation(line: 56, column: 5, scope: !289)
!304 = !DILocation(line: 56, column: 30, scope: !289)
!305 = !DILocation(line: 56, column: 25, scope: !289)
!306 = !DILocalVariable(name: "size_z", scope: !289, file: !12, line: 57, type: !7)
!307 = !DILocation(line: 57, column: 9, scope: !289)
!308 = !DILocation(line: 57, column: 5, scope: !289)
!309 = !DILocation(line: 57, column: 30, scope: !289)
!310 = !DILocation(line: 57, column: 25, scope: !289)
!311 = !DILocalVariable(name: "g", scope: !289, file: !12, line: 59, type: !312)
!312 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !313, size: 64)
!313 = distinct !DICompositeType(tag: DW_TAG_class_type, name: "Grid", file: !12, line: 6, size: 192, flags: DIFlagTypePassByReference, elements: !314, identifier: "_ZTS4Grid")
!314 = !{!315, !316, !317, !318, !320, !324, !327, !330, !331, !332}
!315 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !313, file: !12, line: 8, baseType: !7, size: 32)
!316 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !313, file: !12, line: 8, baseType: !7, size: 32, offset: 32)
!317 = !DIDerivedType(tag: DW_TAG_member, name: "z", scope: !313, file: !12, line: 8, baseType: !7, size: 32, offset: 64)
!318 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !313, file: !12, line: 9, baseType: !319, size: 64, offset: 128)
!319 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !123, size: 64)
!320 = !DISubprogram(name: "Grid", scope: !313, file: !12, line: 11, type: !321, scopeLine: 11, flags: DIFlagPublic | DIFlagPrototyped, spFlags: 0)
!321 = !DISubroutineType(types: !322)
!322 = !{null, !323, !7, !7, !7}
!323 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !313, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!324 = !DISubprogram(name: "~Grid", scope: !313, file: !12, line: 17, type: !325, scopeLine: 17, flags: DIFlagPublic | DIFlagPrototyped, spFlags: 0)
!325 = !DISubroutineType(types: !326)
!326 = !{null, !323}
!327 = !DISubprogram(name: "update_grid", linkageName: "_ZN4Grid11update_gridEd", scope: !313, file: !12, line: 23, type: !328, scopeLine: 23, flags: DIFlagPublic | DIFlagPrototyped, spFlags: 0)
!328 = !DISubroutineType(types: !329)
!329 = !{null, !323, !123}
!330 = !DISubprogram(name: "update_constant", linkageName: "_ZN4Grid15update_constantEd", scope: !313, file: !12, line: 30, type: !328, scopeLine: 30, flags: DIFlagPublic | DIFlagPrototyped, spFlags: 0)
!331 = !DISubprogram(name: "update_data", linkageName: "_ZN4Grid11update_dataEd", scope: !313, file: !12, line: 38, type: !328, scopeLine: 38, flags: DIFlagPublic | DIFlagPrototyped, spFlags: 0)
!332 = !DISubprogram(name: "update_z", linkageName: "_ZN4Grid8update_zEd", scope: !313, file: !12, line: 46, type: !328, scopeLine: 46, flags: DIFlagPublic | DIFlagPrototyped, spFlags: 0)
!333 = !DILocation(line: 59, column: 12, scope: !289)
!334 = !DILocation(line: 60, column: 5, scope: !289)
!335 = !DILocation(line: 61, column: 5, scope: !289)
!336 = !DILocation(line: 63, column: 8, scope: !289)
!337 = !DILocation(line: 63, column: 17, scope: !289)
!338 = !DILocation(line: 63, column: 25, scope: !289)
!339 = !DILocation(line: 63, column: 33, scope: !289)
!340 = !DILocation(line: 63, column: 12, scope: !289)
!341 = !DILocation(line: 63, column: 6, scope: !289)
!342 = !DILocation(line: 65, column: 5, scope: !289)
!343 = !DILocation(line: 65, column: 8, scope: !289)
!344 = !DILocation(line: 66, column: 5, scope: !289)
!345 = !DILocation(line: 66, column: 8, scope: !289)
!346 = !DILocation(line: 67, column: 5, scope: !289)
!347 = !DILocation(line: 67, column: 8, scope: !289)
!348 = !DILocation(line: 68, column: 5, scope: !289)
!349 = !DILocation(line: 68, column: 8, scope: !289)
!350 = !DILocation(line: 70, column: 12, scope: !289)
!351 = !DILocation(line: 70, column: 5, scope: !289)
!352 = !DILocation(line: 71, column: 5, scope: !289)
!353 = !DILocation(line: 72, column: 1, scope: !289)
!354 = !DILocalVariable(name: "ptr", arg: 1, scope: !2, file: !3, line: 11, type: !6)
!355 = !DILocation(line: 11, column: 28, scope: !2)
!356 = !DILocalVariable(name: "name", arg: 2, scope: !2, file: !3, line: 11, type: !8)
!357 = !DILocation(line: 11, column: 46, scope: !2)
!358 = !DILocation(line: 14, column: 57, scope: !2)
!359 = !DILocation(line: 14, column: 31, scope: !2)
!360 = !DILocation(line: 14, column: 82, scope: !2)
!361 = !DILocation(line: 14, column: 86, scope: !2)
!362 = !DILocation(line: 14, column: 5, scope: !2)
!363 = !DILocation(line: 15, column: 1, scope: !2)
!364 = distinct !DISubprogram(name: "Grid", linkageName: "_ZN4GridC2Eiii", scope: !313, file: !12, line: 11, type: !321, scopeLine: 16, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !11, declaration: !320, retainedNodes: !13)
!365 = !DILocalVariable(name: "this", arg: 1, scope: !364, type: !312, flags: DIFlagArtificial | DIFlagObjectPointer)
!366 = !DILocation(line: 0, scope: !364)
!367 = !DILocalVariable(name: "_x", arg: 2, scope: !364, file: !12, line: 11, type: !7)
!368 = !DILocation(line: 11, column: 14, scope: !364)
!369 = !DILocalVariable(name: "_y", arg: 3, scope: !364, file: !12, line: 11, type: !7)
!370 = !DILocation(line: 11, column: 22, scope: !364)
!371 = !DILocalVariable(name: "_z", arg: 4, scope: !364, file: !12, line: 11, type: !7)
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
!385 = distinct !DISubprogram(name: "update_grid", linkageName: "_ZN4Grid11update_gridEd", scope: !313, file: !12, line: 23, type: !328, scopeLine: 24, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !11, declaration: !327, retainedNodes: !13)
!386 = !DILocalVariable(name: "this", arg: 1, scope: !385, type: !312, flags: DIFlagArtificial | DIFlagObjectPointer)
!387 = !DILocation(line: 0, scope: !385)
!388 = !DILocalVariable(name: "shift", arg: 2, scope: !385, file: !12, line: 23, type: !123)
!389 = !DILocation(line: 23, column: 29, scope: !385)
!390 = !DILocalVariable(name: "i", scope: !391, file: !12, line: 25, type: !7)
!391 = distinct !DILexicalBlock(scope: !385, file: !12, line: 25, column: 9)
!392 = !DILocation(line: 25, column: 17, scope: !391)
!393 = !DILocation(line: 25, column: 13, scope: !391)
!394 = !DILocation(line: 25, column: 24, scope: !395)
!395 = distinct !DILexicalBlock(scope: !391, file: !12, line: 25, column: 9)
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
!410 = distinct !DISubprogram(name: "update_constant", linkageName: "_ZN4Grid15update_constantEd", scope: !313, file: !12, line: 30, type: !328, scopeLine: 31, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !11, declaration: !330, retainedNodes: !13)
!411 = !DILocalVariable(name: "this", arg: 1, scope: !410, type: !312, flags: DIFlagArtificial | DIFlagObjectPointer)
!412 = !DILocation(line: 0, scope: !410)
!413 = !DILocalVariable(name: "shift", arg: 2, scope: !410, file: !12, line: 30, type: !123)
!414 = !DILocation(line: 30, column: 33, scope: !410)
!415 = !DILocation(line: 32, column: 22, scope: !410)
!416 = !DILocation(line: 32, column: 21, scope: !410)
!417 = !DILocation(line: 32, column: 9, scope: !410)
!418 = !DILocation(line: 32, column: 17, scope: !410)
!419 = !DILocalVariable(name: "i", scope: !420, file: !12, line: 33, type: !7)
!420 = distinct !DILexicalBlock(scope: !410, file: !12, line: 33, column: 9)
!421 = !DILocation(line: 33, column: 17, scope: !420)
!422 = !DILocation(line: 33, column: 13, scope: !420)
!423 = !DILocation(line: 33, column: 24, scope: !424)
!424 = distinct !DILexicalBlock(scope: !420, file: !12, line: 33, column: 9)
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
!436 = distinct !DISubprogram(name: "update_data", linkageName: "_ZN4Grid11update_dataEd", scope: !313, file: !12, line: 38, type: !328, scopeLine: 39, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !11, declaration: !331, retainedNodes: !13)
!437 = !DILocalVariable(name: "this", arg: 1, scope: !436, type: !312, flags: DIFlagArtificial | DIFlagObjectPointer)
!438 = !DILocation(line: 0, scope: !436)
!439 = !DILocalVariable(name: "shift", arg: 2, scope: !436, file: !12, line: 38, type: !123)
!440 = !DILocation(line: 38, column: 29, scope: !436)
!441 = !DILocation(line: 40, column: 22, scope: !436)
!442 = !DILocation(line: 40, column: 21, scope: !436)
!443 = !DILocation(line: 40, column: 9, scope: !436)
!444 = !DILocation(line: 40, column: 17, scope: !436)
!445 = !DILocalVariable(name: "i", scope: !446, file: !12, line: 41, type: !7)
!446 = distinct !DILexicalBlock(scope: !436, file: !12, line: 41, column: 9)
!447 = !DILocation(line: 41, column: 17, scope: !446)
!448 = !DILocation(line: 41, column: 21, scope: !446)
!449 = !DILocation(line: 41, column: 13, scope: !446)
!450 = !DILocation(line: 41, column: 30, scope: !451)
!451 = distinct !DILexicalBlock(scope: !446, file: !12, line: 41, column: 9)
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
!463 = distinct !DISubprogram(name: "update_z", linkageName: "_ZN4Grid8update_zEd", scope: !313, file: !12, line: 46, type: !328, scopeLine: 47, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !11, declaration: !332, retainedNodes: !13)
!464 = !DILocalVariable(name: "this", arg: 1, scope: !463, type: !312, flags: DIFlagArtificial | DIFlagObjectPointer)
!465 = !DILocation(line: 0, scope: !463)
!466 = !DILocalVariable(name: "shift", arg: 2, scope: !463, file: !12, line: 46, type: !123)
!467 = !DILocation(line: 46, column: 26, scope: !463)
!468 = !DILocalVariable(name: "i", scope: !469, file: !12, line: 48, type: !7)
!469 = distinct !DILexicalBlock(scope: !463, file: !12, line: 48, column: 9)
!470 = !DILocation(line: 48, column: 17, scope: !469)
!471 = !DILocation(line: 48, column: 13, scope: !469)
!472 = !DILocation(line: 48, column: 24, scope: !473)
!473 = distinct !DILexicalBlock(scope: !469, file: !12, line: 48, column: 9)
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
!486 = distinct !DISubprogram(name: "~Grid", linkageName: "_ZN4GridD2Ev", scope: !313, file: !12, line: 17, type: !325, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !11, declaration: !324, retainedNodes: !13)
!487 = !DILocalVariable(name: "this", arg: 1, scope: !486, type: !312, flags: DIFlagArtificial | DIFlagObjectPointer)
!488 = !DILocation(line: 0, scope: !486)
!489 = !DILocation(line: 19, column: 18, scope: !490)
!490 = distinct !DILexicalBlock(scope: !486, file: !12, line: 18, column: 5)
!491 = !DILocation(line: 19, column: 9, scope: !490)
!492 = !DILocation(line: 20, column: 5, scope: !486)
