;; : opt %dfsan -S < %s 2> /dev/null | llc %llcparams - -o %t1 && clang++ %link %omplink %t1 -o %t2 && OMP_NUM_THREADS=1 %execparams %t2 10 10 10 | diff -w %s.json -
;; : %jsonconvert %s.json | diff -w %s.processed.json -

; ModuleID = 'tests/dfsan-instr/cpp_class_openmp.cpp'
source_filename = "tests/dfsan-instr/cpp_class_openmp.cpp"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.ident_t = type { i32, i32, i32, i32, i8* }
%class.Grid = type { i32, i32, i32, double* }

$_Z17register_variableIiEvPT_PKc = comdat any

$_ZN4GridC2Eiii = comdat any

$_ZN4Grid11update_gridEd = comdat any

$_ZN4Grid15update_constantEd = comdat any

$_ZN4Grid8update_yEd = comdat any

$_ZN4Grid11update_dataEd = comdat any

$_ZN4Grid8update_zEd = comdat any

$_ZN4GridD2Ev = comdat any

@.str = private unnamed_addr constant [7 x i8] c"extrap\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [39 x i8] c"tests/dfsan-instr/cpp_class_openmp.cpp\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [7 x i8] c"size_x\00", align 1
@.str.3 = private unnamed_addr constant [7 x i8] c"size_y\00", align 1
@.str.4 = private unnamed_addr constant [23 x i8] c";unknown;unknown;0;0;;\00", align 1
@0 = private unnamed_addr global %struct.ident_t { i32 0, i32 2, i32 0, i32 0, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str.4, i32 0, i32 0) }, align 8
@1 = private unnamed_addr constant [66 x i8] c";tests/dfsan-instr/cpp_class_openmp.cpp;Grid::update_grid;26;17;;\00", align 1
@2 = private unnamed_addr constant [70 x i8] c";tests/dfsan-instr/cpp_class_openmp.cpp;Grid::update_constant;34;17;;\00", align 1
@3 = private unnamed_addr constant [63 x i8] c";tests/dfsan-instr/cpp_class_openmp.cpp;Grid::update_y;51;17;;\00", align 1
@4 = private unnamed_addr constant [66 x i8] c";tests/dfsan-instr/cpp_class_openmp.cpp;Grid::update_data;43;17;;\00", align 1
@5 = private unnamed_addr constant [63 x i8] c";tests/dfsan-instr/cpp_class_openmp.cpp;Grid::update_z;59;17;;\00", align 1

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
  call void @llvm.var.annotation(i8* %12, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([39 x i8], [39 x i8]* @.str.1, i32 0, i32 0), i32 67), !dbg !288
  %13 = load i8**, i8*** %5, align 8, !dbg !289
  %14 = getelementptr inbounds i8*, i8** %13, i64 1, !dbg !289
  %15 = load i8*, i8** %14, align 8, !dbg !289
  %16 = call i32 @atoi(i8* %15) #11, !dbg !290
  store i32 %16, i32* %6, align 4, !dbg !287
  call void @llvm.dbg.declare(metadata i32* %7, metadata !291, metadata !DIExpression()), !dbg !292
  %17 = bitcast i32* %7 to i8*, !dbg !293
  call void @llvm.var.annotation(i8* %17, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([39 x i8], [39 x i8]* @.str.1, i32 0, i32 0), i32 68), !dbg !293
  %18 = load i8**, i8*** %5, align 8, !dbg !294
  %19 = getelementptr inbounds i8*, i8** %18, i64 2, !dbg !294
  %20 = load i8*, i8** %19, align 8, !dbg !294
  %21 = call i32 @atoi(i8* %20) #11, !dbg !295
  store i32 %21, i32* %7, align 4, !dbg !292
  call void @llvm.dbg.declare(metadata i32* %8, metadata !296, metadata !DIExpression()), !dbg !297
  %22 = bitcast i32* %8 to i8*, !dbg !298
  call void @llvm.var.annotation(i8* %22, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([39 x i8], [39 x i8]* @.str.1, i32 0, i32 0), i32 69), !dbg !298
  %23 = load i8**, i8*** %5, align 8, !dbg !299
  %24 = getelementptr inbounds i8*, i8** %23, i64 3, !dbg !299
  %25 = load i8*, i8** %24, align 8, !dbg !299
  %26 = call i32 @atoi(i8* %25) #11, !dbg !300
  store i32 %26, i32* %8, align 4, !dbg !297
  call void @llvm.dbg.declare(metadata %class.Grid** %9, metadata !301, metadata !DIExpression()), !dbg !324
  call void @_Z17register_variableIiEvPT_PKc(i32* %6, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i32 0, i32 0)), !dbg !325
  call void @_Z17register_variableIiEvPT_PKc(i32* %7, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.3, i32 0, i32 0)), !dbg !326
  %27 = call i8* @_Znwm(i64 24) #12, !dbg !327
  %28 = bitcast i8* %27 to %class.Grid*, !dbg !327
  %29 = load i32, i32* %6, align 4, !dbg !328
  %30 = load i32, i32* %7, align 4, !dbg !329
  %31 = load i32, i32* %8, align 4, !dbg !330
  invoke void @_ZN4GridC2Eiii(%class.Grid* %28, i32 %29, i32 %30, i32 %31)
          to label %32 unwind label %43, !dbg !331

; <label>:32:                                     ; preds = %2
  store %class.Grid* %28, %class.Grid** %9, align 8, !dbg !332
  %33 = load %class.Grid*, %class.Grid** %9, align 8, !dbg !333
  call void @_ZN4Grid11update_gridEd(%class.Grid* %33, double 2.000000e+00), !dbg !334
  %34 = load %class.Grid*, %class.Grid** %9, align 8, !dbg !335
  call void @_ZN4Grid15update_constantEd(%class.Grid* %34, double 1.500000e+00), !dbg !336
  %35 = load %class.Grid*, %class.Grid** %9, align 8, !dbg !337
  call void @_ZN4Grid8update_yEd(%class.Grid* %35, double 1.500000e+00), !dbg !338
  %36 = load %class.Grid*, %class.Grid** %9, align 8, !dbg !339
  call void @_ZN4Grid11update_dataEd(%class.Grid* %36, double 1.500000e+00), !dbg !340
  %37 = load %class.Grid*, %class.Grid** %9, align 8, !dbg !341
  call void @_ZN4Grid8update_zEd(%class.Grid* %37, double 1.500000e+00), !dbg !342
  %38 = load %class.Grid*, %class.Grid** %9, align 8, !dbg !343
  %39 = icmp eq %class.Grid* %38, null, !dbg !344
  br i1 %39, label %42, label %40, !dbg !344

; <label>:40:                                     ; preds = %32
  call void @_ZN4GridD2Ev(%class.Grid* %38) #2, !dbg !344
  %41 = bitcast %class.Grid* %38 to i8*, !dbg !344
  call void @_ZdlPv(i8* %41) #13, !dbg !344
  br label %42, !dbg !344

; <label>:42:                                     ; preds = %40, %32
  ret i32 0, !dbg !345

; <label>:43:                                     ; preds = %2
  %44 = landingpad { i8*, i32 }
          cleanup, !dbg !346
  %45 = extractvalue { i8*, i32 } %44, 0, !dbg !346
  store i8* %45, i8** %10, align 8, !dbg !346
  %46 = extractvalue { i8*, i32 } %44, 1, !dbg !346
  store i32 %46, i32* %11, align 4, !dbg !346
  call void @_ZdlPv(i8* %27) #13, !dbg !327
  br label %47, !dbg !327

; <label>:47:                                     ; preds = %43
  %48 = load i8*, i8** %10, align 8, !dbg !327
  %49 = load i32, i32* %11, align 4, !dbg !327
  %50 = insertvalue { i8*, i32 } undef, i8* %48, 0, !dbg !327
  %51 = insertvalue { i8*, i32 } %50, i32 %49, 1, !dbg !327
  resume { i8*, i32 } %51, !dbg !327
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind
declare void @llvm.var.annotation(i8*, i8*, i8*, i32) #2

; Function Attrs: nounwind readonly
declare dso_local i32 @atoi(i8*) #3

; Function Attrs: noinline optnone uwtable
define linkonce_odr dso_local void @_Z17register_variableIiEvPT_PKc(i32*, i8*) #4 comdat !dbg !347 {
  %3 = alloca i32*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca i32, align 4
  store i32* %0, i32** %3, align 8
  call void @llvm.dbg.declare(metadata i32** %3, metadata !354, metadata !DIExpression()), !dbg !355
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !356, metadata !DIExpression()), !dbg !357
  call void @llvm.dbg.declare(metadata i32* %5, metadata !358, metadata !DIExpression()), !dbg !359
  %6 = call i32 @__dfsw_EXTRAP_VAR_ID(), !dbg !360
  store i32 %6, i32* %5, align 4, !dbg !359
  %7 = load i32*, i32** %3, align 8, !dbg !361
  %8 = bitcast i32* %7 to i8*, !dbg !362
  %9 = load i32, i32* %5, align 4, !dbg !363
  %10 = add nsw i32 %9, 1, !dbg !363
  store i32 %10, i32* %5, align 4, !dbg !363
  %11 = load i8*, i8** %4, align 8, !dbg !364
  call void @__dfsw_EXTRAP_STORE_LABEL(i8* %8, i32 4, i32 %9, i8* %11), !dbg !365
  ret void, !dbg !366
}

; Function Attrs: nobuiltin
declare dso_local noalias i8* @_Znwm(i64) #5

; Function Attrs: noinline optnone uwtable
define linkonce_odr dso_local void @_ZN4GridC2Eiii(%class.Grid*, i32, i32, i32) unnamed_addr #4 comdat align 2 !dbg !367 {
  %5 = alloca %class.Grid*, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store %class.Grid* %0, %class.Grid** %5, align 8
  call void @llvm.dbg.declare(metadata %class.Grid** %5, metadata !368, metadata !DIExpression()), !dbg !369
  store i32 %1, i32* %6, align 4
  call void @llvm.dbg.declare(metadata i32* %6, metadata !370, metadata !DIExpression()), !dbg !371
  store i32 %2, i32* %7, align 4
  call void @llvm.dbg.declare(metadata i32* %7, metadata !372, metadata !DIExpression()), !dbg !373
  store i32 %3, i32* %8, align 4
  call void @llvm.dbg.declare(metadata i32* %8, metadata !374, metadata !DIExpression()), !dbg !375
  %9 = load %class.Grid*, %class.Grid** %5, align 8
  %10 = getelementptr inbounds %class.Grid, %class.Grid* %9, i32 0, i32 0, !dbg !376
  %11 = load i32, i32* %6, align 4, !dbg !377
  store i32 %11, i32* %10, align 8, !dbg !376
  %12 = getelementptr inbounds %class.Grid, %class.Grid* %9, i32 0, i32 1, !dbg !378
  %13 = load i32, i32* %7, align 4, !dbg !379
  store i32 %13, i32* %12, align 4, !dbg !378
  %14 = getelementptr inbounds %class.Grid, %class.Grid* %9, i32 0, i32 2, !dbg !380
  %15 = load i32, i32* %8, align 4, !dbg !381
  store i32 %15, i32* %14, align 8, !dbg !380
  %16 = getelementptr inbounds %class.Grid, %class.Grid* %9, i32 0, i32 3, !dbg !382
  %17 = getelementptr inbounds %class.Grid, %class.Grid* %9, i32 0, i32 0, !dbg !383
  %18 = load i32, i32* %17, align 8, !dbg !383
  %19 = getelementptr inbounds %class.Grid, %class.Grid* %9, i32 0, i32 1, !dbg !384
  %20 = load i32, i32* %19, align 4, !dbg !384
  %21 = mul nsw i32 %18, %20, !dbg !385
  %22 = sext i32 %21 to i64, !dbg !383
  %23 = call { i64, i1 } @llvm.umul.with.overflow.i64(i64 %22, i64 8), !dbg !386
  %24 = extractvalue { i64, i1 } %23, 1, !dbg !386
  %25 = extractvalue { i64, i1 } %23, 0, !dbg !386
  %26 = select i1 %24, i64 -1, i64 %25, !dbg !386
  %27 = call i8* @_Znam(i64 %26) #12, !dbg !386
  %28 = bitcast i8* %27 to double*, !dbg !386
  store double* %28, double** %16, align 8, !dbg !382
  ret void, !dbg !387
}

declare dso_local i32 @__gxx_personality_v0(...)

; Function Attrs: nobuiltin nounwind
declare dso_local void @_ZdlPv(i8*) #6

; Function Attrs: noinline optnone uwtable
define linkonce_odr dso_local void @_ZN4Grid11update_gridEd(%class.Grid*, double) #4 comdat align 2 !dbg !388 {
  %3 = alloca %class.Grid*, align 8
  %4 = alloca double, align 8
  %5 = alloca %struct.ident_t, align 8
  %6 = bitcast %struct.ident_t* %5 to i8*
  %7 = bitcast %struct.ident_t* @0 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %6, i8* align 8 %7, i64 24, i1 false)
  store %class.Grid* %0, %class.Grid** %3, align 8
  call void @llvm.dbg.declare(metadata %class.Grid** %3, metadata !389, metadata !DIExpression()), !dbg !390
  store double %1, double* %4, align 8
  call void @llvm.dbg.declare(metadata double* %4, metadata !391, metadata !DIExpression()), !dbg !392
  %8 = load %class.Grid*, %class.Grid** %3, align 8
  %9 = getelementptr inbounds %struct.ident_t, %struct.ident_t* %5, i32 0, i32 4, !dbg !393
  store i8* getelementptr inbounds ([66 x i8], [66 x i8]* @1, i32 0, i32 0), i8** %9, align 8, !dbg !393
  call void (%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...) @__kmpc_fork_call(%struct.ident_t* %5, i32 2, void (i32*, i32*, ...)* bitcast (void (i32*, i32*, %class.Grid*, double*)* @.omp_outlined. to void (i32*, i32*, ...)*), %class.Grid* %8, double* %4), !dbg !393
  ret void, !dbg !394
}

; Function Attrs: noinline optnone uwtable
define linkonce_odr dso_local void @_ZN4Grid15update_constantEd(%class.Grid*, double) #4 comdat align 2 !dbg !395 {
  %3 = alloca %class.Grid*, align 8
  %4 = alloca double, align 8
  %5 = alloca %struct.ident_t, align 8
  %6 = bitcast %struct.ident_t* %5 to i8*
  %7 = bitcast %struct.ident_t* @0 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %6, i8* align 8 %7, i64 24, i1 false)
  store %class.Grid* %0, %class.Grid** %3, align 8
  call void @llvm.dbg.declare(metadata %class.Grid** %3, metadata !396, metadata !DIExpression()), !dbg !397
  store double %1, double* %4, align 8
  call void @llvm.dbg.declare(metadata double* %4, metadata !398, metadata !DIExpression()), !dbg !399
  %8 = load %class.Grid*, %class.Grid** %3, align 8
  %9 = load double, double* %4, align 8, !dbg !400
  %10 = fmul double 2.000000e+00, %9, !dbg !401
  %11 = getelementptr inbounds %class.Grid, %class.Grid* %8, i32 0, i32 3, !dbg !402
  %12 = load double*, double** %11, align 8, !dbg !402
  %13 = getelementptr inbounds double, double* %12, i64 0, !dbg !402
  %14 = load double, double* %13, align 8, !dbg !403
  %15 = fadd double %14, %10, !dbg !403
  store double %15, double* %13, align 8, !dbg !403
  %16 = getelementptr inbounds %struct.ident_t, %struct.ident_t* %5, i32 0, i32 4, !dbg !404
  store i8* getelementptr inbounds ([70 x i8], [70 x i8]* @2, i32 0, i32 0), i8** %16, align 8, !dbg !404
  call void (%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...) @__kmpc_fork_call(%struct.ident_t* %5, i32 2, void (i32*, i32*, ...)* bitcast (void (i32*, i32*, %class.Grid*, double*)* @.omp_outlined..6 to void (i32*, i32*, ...)*), %class.Grid* %8, double* %4), !dbg !404
  ret void, !dbg !405
}

; Function Attrs: noinline optnone uwtable
define linkonce_odr dso_local void @_ZN4Grid8update_yEd(%class.Grid*, double) #4 comdat align 2 !dbg !406 {
  %3 = alloca %class.Grid*, align 8
  %4 = alloca double, align 8
  %5 = alloca %struct.ident_t, align 8
  %6 = bitcast %struct.ident_t* %5 to i8*
  %7 = bitcast %struct.ident_t* @0 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %6, i8* align 8 %7, i64 24, i1 false)
  store %class.Grid* %0, %class.Grid** %3, align 8
  call void @llvm.dbg.declare(metadata %class.Grid** %3, metadata !407, metadata !DIExpression()), !dbg !408
  store double %1, double* %4, align 8
  call void @llvm.dbg.declare(metadata double* %4, metadata !409, metadata !DIExpression()), !dbg !410
  %8 = load %class.Grid*, %class.Grid** %3, align 8
  %9 = getelementptr inbounds %struct.ident_t, %struct.ident_t* %5, i32 0, i32 4, !dbg !411
  store i8* getelementptr inbounds ([63 x i8], [63 x i8]* @3, i32 0, i32 0), i8** %9, align 8, !dbg !411
  call void (%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...) @__kmpc_fork_call(%struct.ident_t* %5, i32 2, void (i32*, i32*, ...)* bitcast (void (i32*, i32*, %class.Grid*, double*)* @.omp_outlined..8 to void (i32*, i32*, ...)*), %class.Grid* %8, double* %4), !dbg !411
  ret void, !dbg !412
}

; Function Attrs: noinline optnone uwtable
define linkonce_odr dso_local void @_ZN4Grid11update_dataEd(%class.Grid*, double) #4 comdat align 2 !dbg !413 {
  %3 = alloca %class.Grid*, align 8
  %4 = alloca double, align 8
  %5 = alloca %struct.ident_t, align 8
  %6 = bitcast %struct.ident_t* %5 to i8*
  %7 = bitcast %struct.ident_t* @0 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %6, i8* align 8 %7, i64 24, i1 false)
  store %class.Grid* %0, %class.Grid** %3, align 8
  call void @llvm.dbg.declare(metadata %class.Grid** %3, metadata !414, metadata !DIExpression()), !dbg !415
  store double %1, double* %4, align 8
  call void @llvm.dbg.declare(metadata double* %4, metadata !416, metadata !DIExpression()), !dbg !417
  %8 = load %class.Grid*, %class.Grid** %3, align 8
  %9 = load double, double* %4, align 8, !dbg !418
  %10 = fmul double 2.000000e+00, %9, !dbg !419
  %11 = getelementptr inbounds %class.Grid, %class.Grid* %8, i32 0, i32 3, !dbg !420
  %12 = load double*, double** %11, align 8, !dbg !420
  %13 = getelementptr inbounds double, double* %12, i64 0, !dbg !420
  %14 = load double, double* %13, align 8, !dbg !421
  %15 = fadd double %14, %10, !dbg !421
  store double %15, double* %13, align 8, !dbg !421
  %16 = getelementptr inbounds %struct.ident_t, %struct.ident_t* %5, i32 0, i32 4, !dbg !422
  store i8* getelementptr inbounds ([66 x i8], [66 x i8]* @4, i32 0, i32 0), i8** %16, align 8, !dbg !422
  call void (%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...) @__kmpc_fork_call(%struct.ident_t* %5, i32 2, void (i32*, i32*, ...)* bitcast (void (i32*, i32*, %class.Grid*, double*)* @.omp_outlined..10 to void (i32*, i32*, ...)*), %class.Grid* %8, double* %4), !dbg !422
  ret void, !dbg !423
}

; Function Attrs: noinline optnone uwtable
define linkonce_odr dso_local void @_ZN4Grid8update_zEd(%class.Grid*, double) #4 comdat align 2 !dbg !424 {
  %3 = alloca %class.Grid*, align 8
  %4 = alloca double, align 8
  %5 = alloca %struct.ident_t, align 8
  %6 = bitcast %struct.ident_t* %5 to i8*
  %7 = bitcast %struct.ident_t* @0 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %6, i8* align 8 %7, i64 24, i1 false)
  store %class.Grid* %0, %class.Grid** %3, align 8
  call void @llvm.dbg.declare(metadata %class.Grid** %3, metadata !425, metadata !DIExpression()), !dbg !426
  store double %1, double* %4, align 8
  call void @llvm.dbg.declare(metadata double* %4, metadata !427, metadata !DIExpression()), !dbg !428
  %8 = load %class.Grid*, %class.Grid** %3, align 8
  %9 = getelementptr inbounds %struct.ident_t, %struct.ident_t* %5, i32 0, i32 4, !dbg !429
  store i8* getelementptr inbounds ([63 x i8], [63 x i8]* @5, i32 0, i32 0), i8** %9, align 8, !dbg !429
  call void (%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...) @__kmpc_fork_call(%struct.ident_t* %5, i32 2, void (i32*, i32*, ...)* bitcast (void (i32*, i32*, %class.Grid*, double*)* @.omp_outlined..12 to void (i32*, i32*, ...)*), %class.Grid* %8, double* %4), !dbg !429
  ret void, !dbg !430
}

; Function Attrs: noinline nounwind optnone uwtable
define linkonce_odr dso_local void @_ZN4GridD2Ev(%class.Grid*) unnamed_addr #7 comdat align 2 !dbg !431 {
  %2 = alloca %class.Grid*, align 8
  store %class.Grid* %0, %class.Grid** %2, align 8
  call void @llvm.dbg.declare(metadata %class.Grid** %2, metadata !432, metadata !DIExpression()), !dbg !433
  %3 = load %class.Grid*, %class.Grid** %2, align 8
  %4 = getelementptr inbounds %class.Grid, %class.Grid* %3, i32 0, i32 3, !dbg !434
  %5 = load double*, double** %4, align 8, !dbg !434
  %6 = icmp eq double* %5, null, !dbg !436
  br i1 %6, label %9, label %7, !dbg !436

; <label>:7:                                      ; preds = %1
  %8 = bitcast double* %5 to i8*, !dbg !436
  call void @_ZdaPv(i8* %8) #13, !dbg !436
  br label %9, !dbg !436

; <label>:9:                                      ; preds = %7, %1
  ret void, !dbg !437
}

; Function Attrs: nounwind readnone speculatable
declare { i64, i1 } @llvm.umul.with.overflow.i64(i64, i64) #1

; Function Attrs: nobuiltin
declare dso_local noalias i8* @_Znam(i64) #5

; Function Attrs: noinline norecurse nounwind optnone uwtable
define internal void @.omp_outlined._debug__(i32* noalias, i32* noalias, %class.Grid*, double* dereferenceable(8)) #8 !dbg !438 {
  %5 = alloca i32*, align 8
  %6 = alloca i32*, align 8
  %7 = alloca %class.Grid*, align 8
  %8 = alloca double*, align 8
  %9 = alloca i32, align 4
  store i32* %0, i32** %5, align 8
  call void @llvm.dbg.declare(metadata i32** %5, metadata !446, metadata !DIExpression()), !dbg !447
  store i32* %1, i32** %6, align 8
  call void @llvm.dbg.declare(metadata i32** %6, metadata !448, metadata !DIExpression()), !dbg !447
  store %class.Grid* %2, %class.Grid** %7, align 8
  call void @llvm.dbg.declare(metadata %class.Grid** %7, metadata !449, metadata !DIExpression()), !dbg !450
  store double* %3, double** %8, align 8
  call void @llvm.dbg.declare(metadata double** %8, metadata !451, metadata !DIExpression()), !dbg !452
  %10 = load %class.Grid*, %class.Grid** %7, align 8, !dbg !453
  %11 = load double*, double** %8, align 8, !dbg !453
  call void @llvm.dbg.declare(metadata i32* %9, metadata !454, metadata !DIExpression()), !dbg !456
  store i32 0, i32* %9, align 4, !dbg !456
  br label %12, !dbg !457

; <label>:12:                                     ; preds = %29, %4
  %13 = load i32, i32* %9, align 4, !dbg !458
  %14 = getelementptr inbounds %class.Grid, %class.Grid* %10, i32 0, i32 0, !dbg !460
  %15 = load i32, i32* %14, align 8, !dbg !460
  %16 = getelementptr inbounds %class.Grid, %class.Grid* %10, i32 0, i32 1, !dbg !461
  %17 = load i32, i32* %16, align 4, !dbg !461
  %18 = mul nsw i32 %15, %17, !dbg !462
  %19 = icmp slt i32 %13, %18, !dbg !463
  br i1 %19, label %20, label %32, !dbg !464

; <label>:20:                                     ; preds = %12
  %21 = load double, double* %11, align 8, !dbg !465
  %22 = getelementptr inbounds %class.Grid, %class.Grid* %10, i32 0, i32 3, !dbg !466
  %23 = load double*, double** %22, align 8, !dbg !466
  %24 = load i32, i32* %9, align 4, !dbg !467
  %25 = sext i32 %24 to i64, !dbg !466
  %26 = getelementptr inbounds double, double* %23, i64 %25, !dbg !466
  %27 = load double, double* %26, align 8, !dbg !468
  %28 = fadd double %27, %21, !dbg !468
  store double %28, double* %26, align 8, !dbg !468
  br label %29, !dbg !466

; <label>:29:                                     ; preds = %20
  %30 = load i32, i32* %9, align 4, !dbg !469
  %31 = add nsw i32 %30, 1, !dbg !469
  store i32 %31, i32* %9, align 4, !dbg !469
  br label %12, !dbg !470, !llvm.loop !471

; <label>:32:                                     ; preds = %12
  ret void, !dbg !473
}

; Function Attrs: noinline norecurse nounwind optnone uwtable
define internal void @.omp_outlined.(i32* noalias, i32* noalias, %class.Grid*, double* dereferenceable(8)) #8 !dbg !474 {
  %5 = alloca i32*, align 8
  %6 = alloca i32*, align 8
  %7 = alloca %class.Grid*, align 8
  %8 = alloca double*, align 8
  store i32* %0, i32** %5, align 8
  call void @llvm.dbg.declare(metadata i32** %5, metadata !475, metadata !DIExpression()), !dbg !476
  store i32* %1, i32** %6, align 8
  call void @llvm.dbg.declare(metadata i32** %6, metadata !477, metadata !DIExpression()), !dbg !476
  store %class.Grid* %2, %class.Grid** %7, align 8
  call void @llvm.dbg.declare(metadata %class.Grid** %7, metadata !478, metadata !DIExpression()), !dbg !476
  store double* %3, double** %8, align 8
  call void @llvm.dbg.declare(metadata double** %8, metadata !479, metadata !DIExpression()), !dbg !476
  %9 = load %class.Grid*, %class.Grid** %7, align 8, !dbg !480
  %10 = load double*, double** %8, align 8, !dbg !480
  %11 = load i32*, i32** %5, align 8, !dbg !480
  %12 = load i32*, i32** %6, align 8, !dbg !480
  %13 = load %class.Grid*, %class.Grid** %7, align 8, !dbg !480
  %14 = load double*, double** %8, align 8, !dbg !480
  call void @.omp_outlined._debug__(i32* %11, i32* %12, %class.Grid* %13, double* %14) #2, !dbg !480
  ret void, !dbg !480
}

; Function Attrs: argmemonly nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i1) #9

declare dso_local void @__kmpc_fork_call(%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...)

; Function Attrs: noinline norecurse nounwind optnone uwtable
define internal void @.omp_outlined._debug__.5(i32* noalias, i32* noalias, %class.Grid*, double* dereferenceable(8)) #8 !dbg !481 {
  %5 = alloca i32*, align 8
  %6 = alloca i32*, align 8
  %7 = alloca %class.Grid*, align 8
  %8 = alloca double*, align 8
  %9 = alloca i32, align 4
  store i32* %0, i32** %5, align 8
  call void @llvm.dbg.declare(metadata i32** %5, metadata !482, metadata !DIExpression()), !dbg !483
  store i32* %1, i32** %6, align 8
  call void @llvm.dbg.declare(metadata i32** %6, metadata !484, metadata !DIExpression()), !dbg !483
  store %class.Grid* %2, %class.Grid** %7, align 8
  call void @llvm.dbg.declare(metadata %class.Grid** %7, metadata !485, metadata !DIExpression()), !dbg !486
  store double* %3, double** %8, align 8
  call void @llvm.dbg.declare(metadata double** %8, metadata !487, metadata !DIExpression()), !dbg !488
  %10 = load %class.Grid*, %class.Grid** %7, align 8, !dbg !489
  %11 = load double*, double** %8, align 8, !dbg !489
  call void @llvm.dbg.declare(metadata i32* %9, metadata !490, metadata !DIExpression()), !dbg !492
  store i32 1, i32* %9, align 4, !dbg !492
  br label %12, !dbg !493

; <label>:12:                                     ; preds = %24, %4
  %13 = load i32, i32* %9, align 4, !dbg !494
  %14 = icmp slt i32 %13, 5, !dbg !496
  br i1 %14, label %15, label %27, !dbg !497

; <label>:15:                                     ; preds = %12
  %16 = load double, double* %11, align 8, !dbg !498
  %17 = getelementptr inbounds %class.Grid, %class.Grid* %10, i32 0, i32 3, !dbg !499
  %18 = load double*, double** %17, align 8, !dbg !499
  %19 = load i32, i32* %9, align 4, !dbg !500
  %20 = sext i32 %19 to i64, !dbg !499
  %21 = getelementptr inbounds double, double* %18, i64 %20, !dbg !499
  %22 = load double, double* %21, align 8, !dbg !501
  %23 = fadd double %22, %16, !dbg !501
  store double %23, double* %21, align 8, !dbg !501
  br label %24, !dbg !499

; <label>:24:                                     ; preds = %15
  %25 = load i32, i32* %9, align 4, !dbg !502
  %26 = add nsw i32 %25, 1, !dbg !502
  store i32 %26, i32* %9, align 4, !dbg !502
  br label %12, !dbg !503, !llvm.loop !504

; <label>:27:                                     ; preds = %12
  ret void, !dbg !506
}

; Function Attrs: noinline norecurse nounwind optnone uwtable
define internal void @.omp_outlined..6(i32* noalias, i32* noalias, %class.Grid*, double* dereferenceable(8)) #8 !dbg !507 {
  %5 = alloca i32*, align 8
  %6 = alloca i32*, align 8
  %7 = alloca %class.Grid*, align 8
  %8 = alloca double*, align 8
  store i32* %0, i32** %5, align 8
  call void @llvm.dbg.declare(metadata i32** %5, metadata !508, metadata !DIExpression()), !dbg !509
  store i32* %1, i32** %6, align 8
  call void @llvm.dbg.declare(metadata i32** %6, metadata !510, metadata !DIExpression()), !dbg !509
  store %class.Grid* %2, %class.Grid** %7, align 8
  call void @llvm.dbg.declare(metadata %class.Grid** %7, metadata !511, metadata !DIExpression()), !dbg !509
  store double* %3, double** %8, align 8
  call void @llvm.dbg.declare(metadata double** %8, metadata !512, metadata !DIExpression()), !dbg !509
  %9 = load %class.Grid*, %class.Grid** %7, align 8, !dbg !513
  %10 = load double*, double** %8, align 8, !dbg !513
  %11 = load i32*, i32** %5, align 8, !dbg !513
  %12 = load i32*, i32** %6, align 8, !dbg !513
  %13 = load %class.Grid*, %class.Grid** %7, align 8, !dbg !513
  %14 = load double*, double** %8, align 8, !dbg !513
  call void @.omp_outlined._debug__.5(i32* %11, i32* %12, %class.Grid* %13, double* %14) #2, !dbg !513
  ret void, !dbg !513
}

; Function Attrs: noinline norecurse nounwind optnone uwtable
define internal void @.omp_outlined._debug__.7(i32* noalias, i32* noalias, %class.Grid*, double* dereferenceable(8)) #8 !dbg !514 {
  %5 = alloca i32*, align 8
  %6 = alloca i32*, align 8
  %7 = alloca %class.Grid*, align 8
  %8 = alloca double*, align 8
  %9 = alloca i32, align 4
  store i32* %0, i32** %5, align 8
  call void @llvm.dbg.declare(metadata i32** %5, metadata !515, metadata !DIExpression()), !dbg !516
  store i32* %1, i32** %6, align 8
  call void @llvm.dbg.declare(metadata i32** %6, metadata !517, metadata !DIExpression()), !dbg !516
  store %class.Grid* %2, %class.Grid** %7, align 8
  call void @llvm.dbg.declare(metadata %class.Grid** %7, metadata !518, metadata !DIExpression()), !dbg !519
  store double* %3, double** %8, align 8
  call void @llvm.dbg.declare(metadata double** %8, metadata !520, metadata !DIExpression()), !dbg !521
  %10 = load %class.Grid*, %class.Grid** %7, align 8, !dbg !522
  %11 = load double*, double** %8, align 8, !dbg !522
  call void @llvm.dbg.declare(metadata i32* %9, metadata !523, metadata !DIExpression()), !dbg !525
  store i32 0, i32* %9, align 4, !dbg !525
  br label %12, !dbg !526

; <label>:12:                                     ; preds = %24, %4
  %13 = load i32, i32* %9, align 4, !dbg !527
  %14 = icmp slt i32 %13, 100, !dbg !529
  br i1 %14, label %15, label %29, !dbg !530

; <label>:15:                                     ; preds = %12
  %16 = load double, double* %11, align 8, !dbg !531
  %17 = getelementptr inbounds %class.Grid, %class.Grid* %10, i32 0, i32 3, !dbg !532
  %18 = load double*, double** %17, align 8, !dbg !532
  %19 = load i32, i32* %9, align 4, !dbg !533
  %20 = sext i32 %19 to i64, !dbg !532
  %21 = getelementptr inbounds double, double* %18, i64 %20, !dbg !532
  %22 = load double, double* %21, align 8, !dbg !534
  %23 = fadd double %22, %16, !dbg !534
  store double %23, double* %21, align 8, !dbg !534
  br label %24, !dbg !532

; <label>:24:                                     ; preds = %15
  %25 = getelementptr inbounds %class.Grid, %class.Grid* %10, i32 0, i32 1, !dbg !535
  %26 = load i32, i32* %25, align 4, !dbg !535
  %27 = load i32, i32* %9, align 4, !dbg !536
  %28 = add nsw i32 %27, %26, !dbg !536
  store i32 %28, i32* %9, align 4, !dbg !536
  br label %12, !dbg !537, !llvm.loop !538

; <label>:29:                                     ; preds = %12
  ret void, !dbg !540
}

; Function Attrs: noinline norecurse nounwind optnone uwtable
define internal void @.omp_outlined..8(i32* noalias, i32* noalias, %class.Grid*, double* dereferenceable(8)) #8 !dbg !541 {
  %5 = alloca i32*, align 8
  %6 = alloca i32*, align 8
  %7 = alloca %class.Grid*, align 8
  %8 = alloca double*, align 8
  store i32* %0, i32** %5, align 8
  call void @llvm.dbg.declare(metadata i32** %5, metadata !542, metadata !DIExpression()), !dbg !543
  store i32* %1, i32** %6, align 8
  call void @llvm.dbg.declare(metadata i32** %6, metadata !544, metadata !DIExpression()), !dbg !543
  store %class.Grid* %2, %class.Grid** %7, align 8
  call void @llvm.dbg.declare(metadata %class.Grid** %7, metadata !545, metadata !DIExpression()), !dbg !543
  store double* %3, double** %8, align 8
  call void @llvm.dbg.declare(metadata double** %8, metadata !546, metadata !DIExpression()), !dbg !543
  %9 = load %class.Grid*, %class.Grid** %7, align 8, !dbg !547
  %10 = load double*, double** %8, align 8, !dbg !547
  %11 = load i32*, i32** %5, align 8, !dbg !547
  %12 = load i32*, i32** %6, align 8, !dbg !547
  %13 = load %class.Grid*, %class.Grid** %7, align 8, !dbg !547
  %14 = load double*, double** %8, align 8, !dbg !547
  call void @.omp_outlined._debug__.7(i32* %11, i32* %12, %class.Grid* %13, double* %14) #2, !dbg !547
  ret void, !dbg !547
}

; Function Attrs: noinline norecurse nounwind optnone uwtable
define internal void @.omp_outlined._debug__.9(i32* noalias, i32* noalias, %class.Grid*, double* dereferenceable(8)) #8 !dbg !548 {
  %5 = alloca i32*, align 8
  %6 = alloca i32*, align 8
  %7 = alloca %class.Grid*, align 8
  %8 = alloca double*, align 8
  %9 = alloca i32, align 4
  store i32* %0, i32** %5, align 8
  call void @llvm.dbg.declare(metadata i32** %5, metadata !549, metadata !DIExpression()), !dbg !550
  store i32* %1, i32** %6, align 8
  call void @llvm.dbg.declare(metadata i32** %6, metadata !551, metadata !DIExpression()), !dbg !550
  store %class.Grid* %2, %class.Grid** %7, align 8
  call void @llvm.dbg.declare(metadata %class.Grid** %7, metadata !552, metadata !DIExpression()), !dbg !553
  store double* %3, double** %8, align 8
  call void @llvm.dbg.declare(metadata double** %8, metadata !554, metadata !DIExpression()), !dbg !555
  %10 = load %class.Grid*, %class.Grid** %7, align 8, !dbg !556
  %11 = load double*, double** %8, align 8, !dbg !556
  call void @llvm.dbg.declare(metadata i32* %9, metadata !557, metadata !DIExpression()), !dbg !559
  %12 = getelementptr inbounds %class.Grid, %class.Grid* %10, i32 0, i32 3, !dbg !560
  %13 = load double*, double** %12, align 8, !dbg !560
  %14 = getelementptr inbounds double, double* %13, i64 0, !dbg !560
  %15 = load double, double* %14, align 8, !dbg !560
  %16 = fptosi double %15 to i32, !dbg !560
  store i32 %16, i32* %9, align 4, !dbg !559
  br label %17, !dbg !561

; <label>:17:                                     ; preds = %29, %4
  %18 = load i32, i32* %9, align 4, !dbg !562
  %19 = icmp slt i32 %18, 5, !dbg !564
  br i1 %19, label %20, label %32, !dbg !565

; <label>:20:                                     ; preds = %17
  %21 = load double, double* %11, align 8, !dbg !566
  %22 = getelementptr inbounds %class.Grid, %class.Grid* %10, i32 0, i32 3, !dbg !567
  %23 = load double*, double** %22, align 8, !dbg !567
  %24 = load i32, i32* %9, align 4, !dbg !568
  %25 = sext i32 %24 to i64, !dbg !567
  %26 = getelementptr inbounds double, double* %23, i64 %25, !dbg !567
  %27 = load double, double* %26, align 8, !dbg !569
  %28 = fadd double %27, %21, !dbg !569
  store double %28, double* %26, align 8, !dbg !569
  br label %29, !dbg !567

; <label>:29:                                     ; preds = %20
  %30 = load i32, i32* %9, align 4, !dbg !570
  %31 = add nsw i32 %30, 1, !dbg !570
  store i32 %31, i32* %9, align 4, !dbg !570
  br label %17, !dbg !571, !llvm.loop !572

; <label>:32:                                     ; preds = %17
  ret void, !dbg !574
}

; Function Attrs: noinline norecurse nounwind optnone uwtable
define internal void @.omp_outlined..10(i32* noalias, i32* noalias, %class.Grid*, double* dereferenceable(8)) #8 !dbg !575 {
  %5 = alloca i32*, align 8
  %6 = alloca i32*, align 8
  %7 = alloca %class.Grid*, align 8
  %8 = alloca double*, align 8
  store i32* %0, i32** %5, align 8
  call void @llvm.dbg.declare(metadata i32** %5, metadata !576, metadata !DIExpression()), !dbg !577
  store i32* %1, i32** %6, align 8
  call void @llvm.dbg.declare(metadata i32** %6, metadata !578, metadata !DIExpression()), !dbg !577
  store %class.Grid* %2, %class.Grid** %7, align 8
  call void @llvm.dbg.declare(metadata %class.Grid** %7, metadata !579, metadata !DIExpression()), !dbg !577
  store double* %3, double** %8, align 8
  call void @llvm.dbg.declare(metadata double** %8, metadata !580, metadata !DIExpression()), !dbg !577
  %9 = load %class.Grid*, %class.Grid** %7, align 8, !dbg !581
  %10 = load double*, double** %8, align 8, !dbg !581
  %11 = load i32*, i32** %5, align 8, !dbg !581
  %12 = load i32*, i32** %6, align 8, !dbg !581
  %13 = load %class.Grid*, %class.Grid** %7, align 8, !dbg !581
  %14 = load double*, double** %8, align 8, !dbg !581
  call void @.omp_outlined._debug__.9(i32* %11, i32* %12, %class.Grid* %13, double* %14) #2, !dbg !581
  ret void, !dbg !581
}

; Function Attrs: noinline norecurse nounwind optnone uwtable
define internal void @.omp_outlined._debug__.11(i32* noalias, i32* noalias, %class.Grid*, double* dereferenceable(8)) #8 !dbg !582 {
  %5 = alloca i32*, align 8
  %6 = alloca i32*, align 8
  %7 = alloca %class.Grid*, align 8
  %8 = alloca double*, align 8
  %9 = alloca i32, align 4
  store i32* %0, i32** %5, align 8
  call void @llvm.dbg.declare(metadata i32** %5, metadata !583, metadata !DIExpression()), !dbg !584
  store i32* %1, i32** %6, align 8
  call void @llvm.dbg.declare(metadata i32** %6, metadata !585, metadata !DIExpression()), !dbg !584
  store %class.Grid* %2, %class.Grid** %7, align 8
  call void @llvm.dbg.declare(metadata %class.Grid** %7, metadata !586, metadata !DIExpression()), !dbg !587
  store double* %3, double** %8, align 8
  call void @llvm.dbg.declare(metadata double** %8, metadata !588, metadata !DIExpression()), !dbg !589
  %10 = load %class.Grid*, %class.Grid** %7, align 8, !dbg !590
  %11 = load double*, double** %8, align 8, !dbg !590
  call void @llvm.dbg.declare(metadata i32* %9, metadata !591, metadata !DIExpression()), !dbg !593
  store i32 0, i32* %9, align 4, !dbg !593
  br label %12, !dbg !594

; <label>:12:                                     ; preds = %26, %4
  %13 = load i32, i32* %9, align 4, !dbg !595
  %14 = getelementptr inbounds %class.Grid, %class.Grid* %10, i32 0, i32 2, !dbg !597
  %15 = load i32, i32* %14, align 8, !dbg !597
  %16 = icmp slt i32 %13, %15, !dbg !598
  br i1 %16, label %17, label %29, !dbg !599

; <label>:17:                                     ; preds = %12
  %18 = load double, double* %11, align 8, !dbg !600
  %19 = getelementptr inbounds %class.Grid, %class.Grid* %10, i32 0, i32 3, !dbg !601
  %20 = load double*, double** %19, align 8, !dbg !601
  %21 = load i32, i32* %9, align 4, !dbg !602
  %22 = sext i32 %21 to i64, !dbg !601
  %23 = getelementptr inbounds double, double* %20, i64 %22, !dbg !601
  %24 = load double, double* %23, align 8, !dbg !603
  %25 = fadd double %24, %18, !dbg !603
  store double %25, double* %23, align 8, !dbg !603
  br label %26, !dbg !601

; <label>:26:                                     ; preds = %17
  %27 = load i32, i32* %9, align 4, !dbg !604
  %28 = add nsw i32 %27, 1, !dbg !604
  store i32 %28, i32* %9, align 4, !dbg !604
  br label %12, !dbg !605, !llvm.loop !606

; <label>:29:                                     ; preds = %12
  ret void, !dbg !608
}

; Function Attrs: noinline norecurse nounwind optnone uwtable
define internal void @.omp_outlined..12(i32* noalias, i32* noalias, %class.Grid*, double* dereferenceable(8)) #8 !dbg !609 {
  %5 = alloca i32*, align 8
  %6 = alloca i32*, align 8
  %7 = alloca %class.Grid*, align 8
  %8 = alloca double*, align 8
  store i32* %0, i32** %5, align 8
  call void @llvm.dbg.declare(metadata i32** %5, metadata !610, metadata !DIExpression()), !dbg !611
  store i32* %1, i32** %6, align 8
  call void @llvm.dbg.declare(metadata i32** %6, metadata !612, metadata !DIExpression()), !dbg !611
  store %class.Grid* %2, %class.Grid** %7, align 8
  call void @llvm.dbg.declare(metadata %class.Grid** %7, metadata !613, metadata !DIExpression()), !dbg !611
  store double* %3, double** %8, align 8
  call void @llvm.dbg.declare(metadata double** %8, metadata !614, metadata !DIExpression()), !dbg !611
  %9 = load %class.Grid*, %class.Grid** %7, align 8, !dbg !615
  %10 = load double*, double** %8, align 8, !dbg !615
  %11 = load i32*, i32** %5, align 8, !dbg !615
  %12 = load i32*, i32** %6, align 8, !dbg !615
  %13 = load %class.Grid*, %class.Grid** %7, align 8, !dbg !615
  %14 = load double*, double** %8, align 8, !dbg !615
  call void @.omp_outlined._debug__.11(i32* %11, i32* %12, %class.Grid* %13, double* %14) #2, !dbg !615
  ret void, !dbg !615
}

; Function Attrs: nobuiltin nounwind
declare dso_local void @_ZdaPv(i8*) #6

declare dso_local i32 @__dfsw_EXTRAP_VAR_ID() #10

declare dso_local void @__dfsw_EXTRAP_STORE_LABEL(i8*, i32, i32, i8*) #10

attributes #0 = { noinline norecurse optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { nounwind }
attributes #3 = { nounwind readonly "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { noinline optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { nobuiltin "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #6 = { nobuiltin nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #7 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #8 = { noinline norecurse nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #9 = { argmemonly nounwind }
attributes #10 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #11 = { nounwind readonly }
attributes #12 = { builtin }
attributes #13 = { builtin nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!275, !276, !277}
!llvm.ident = !{!278}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !1, producer: "clang version 8.0.0 (git@github.com:llvm-mirror/clang.git fd01d8b9288b3558a597daeb0cb4481b37c5bf68) (git@github.com:llvm-mirror/LLVM.git 7135d8b482d3d0d1a8c50111eebb9b207e92a8bc)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !3, imports: !10, nameTableKind: None)
!1 = !DIFile(filename: "tests/dfsan-instr/cpp_class_openmp.cpp", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
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
!88 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !89, line: 216, baseType: !43)
!89 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7/include/stddef.h", directory: "")
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
!279 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 65, type: !280, scopeLine: 66, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!280 = !DISubroutineType(types: !281)
!281 = !{!22, !22, !134}
!282 = !DILocalVariable(name: "argc", arg: 1, scope: !279, file: !1, line: 65, type: !22)
!283 = !DILocation(line: 65, column: 14, scope: !279)
!284 = !DILocalVariable(name: "argv", arg: 2, scope: !279, file: !1, line: 65, type: !134)
!285 = !DILocation(line: 65, column: 28, scope: !279)
!286 = !DILocalVariable(name: "size_x", scope: !279, file: !1, line: 67, type: !22)
!287 = !DILocation(line: 67, column: 9, scope: !279)
!288 = !DILocation(line: 67, column: 5, scope: !279)
!289 = !DILocation(line: 67, column: 30, scope: !279)
!290 = !DILocation(line: 67, column: 25, scope: !279)
!291 = !DILocalVariable(name: "size_y", scope: !279, file: !1, line: 68, type: !22)
!292 = !DILocation(line: 68, column: 9, scope: !279)
!293 = !DILocation(line: 68, column: 5, scope: !279)
!294 = !DILocation(line: 68, column: 30, scope: !279)
!295 = !DILocation(line: 68, column: 25, scope: !279)
!296 = !DILocalVariable(name: "size_z", scope: !279, file: !1, line: 69, type: !22)
!297 = !DILocation(line: 69, column: 9, scope: !279)
!298 = !DILocation(line: 69, column: 5, scope: !279)
!299 = !DILocation(line: 69, column: 30, scope: !279)
!300 = !DILocation(line: 69, column: 25, scope: !279)
!301 = !DILocalVariable(name: "g", scope: !279, file: !1, line: 71, type: !302)
!302 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !303, size: 64)
!303 = distinct !DICompositeType(tag: DW_TAG_class_type, name: "Grid", file: !1, line: 8, size: 192, flags: DIFlagTypePassByReference, elements: !304, identifier: "_ZTS4Grid")
!304 = !{!305, !306, !307, !308, !310, !314, !317, !320, !321, !322, !323}
!305 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !303, file: !1, line: 10, baseType: !22, size: 32)
!306 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !303, file: !1, line: 10, baseType: !22, size: 32, offset: 32)
!307 = !DIDerivedType(tag: DW_TAG_member, name: "z", scope: !303, file: !1, line: 10, baseType: !22, size: 32, offset: 64)
!308 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !303, file: !1, line: 11, baseType: !309, size: 64, offset: 128)
!309 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !112, size: 64)
!310 = !DISubprogram(name: "Grid", scope: !303, file: !1, line: 13, type: !311, scopeLine: 13, flags: DIFlagPublic | DIFlagPrototyped, spFlags: 0)
!311 = !DISubroutineType(types: !312)
!312 = !{null, !313, !22, !22, !22}
!313 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !303, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!314 = !DISubprogram(name: "~Grid", scope: !303, file: !1, line: 19, type: !315, scopeLine: 19, flags: DIFlagPublic | DIFlagPrototyped, spFlags: 0)
!315 = !DISubroutineType(types: !316)
!316 = !{null, !313}
!317 = !DISubprogram(name: "update_grid", linkageName: "_ZN4Grid11update_gridEd", scope: !303, file: !1, line: 24, type: !318, scopeLine: 24, flags: DIFlagPublic | DIFlagPrototyped, spFlags: 0)
!318 = !DISubroutineType(types: !319)
!319 = !{null, !313, !112}
!320 = !DISubprogram(name: "update_constant", linkageName: "_ZN4Grid15update_constantEd", scope: !303, file: !1, line: 31, type: !318, scopeLine: 31, flags: DIFlagPublic | DIFlagPrototyped, spFlags: 0)
!321 = !DISubprogram(name: "update_data", linkageName: "_ZN4Grid11update_dataEd", scope: !303, file: !1, line: 40, type: !318, scopeLine: 40, flags: DIFlagPublic | DIFlagPrototyped, spFlags: 0)
!322 = !DISubprogram(name: "update_y", linkageName: "_ZN4Grid8update_yEd", scope: !303, file: !1, line: 49, type: !318, scopeLine: 49, flags: DIFlagPublic | DIFlagPrototyped, spFlags: 0)
!323 = !DISubprogram(name: "update_z", linkageName: "_ZN4Grid8update_zEd", scope: !303, file: !1, line: 57, type: !318, scopeLine: 57, flags: DIFlagPublic | DIFlagPrototyped, spFlags: 0)
!324 = !DILocation(line: 71, column: 12, scope: !279)
!325 = !DILocation(line: 72, column: 5, scope: !279)
!326 = !DILocation(line: 73, column: 5, scope: !279)
!327 = !DILocation(line: 74, column: 9, scope: !279)
!328 = !DILocation(line: 74, column: 18, scope: !279)
!329 = !DILocation(line: 74, column: 26, scope: !279)
!330 = !DILocation(line: 74, column: 34, scope: !279)
!331 = !DILocation(line: 74, column: 13, scope: !279)
!332 = !DILocation(line: 74, column: 7, scope: !279)
!333 = !DILocation(line: 76, column: 5, scope: !279)
!334 = !DILocation(line: 76, column: 8, scope: !279)
!335 = !DILocation(line: 77, column: 5, scope: !279)
!336 = !DILocation(line: 77, column: 8, scope: !279)
!337 = !DILocation(line: 78, column: 5, scope: !279)
!338 = !DILocation(line: 78, column: 8, scope: !279)
!339 = !DILocation(line: 79, column: 5, scope: !279)
!340 = !DILocation(line: 79, column: 8, scope: !279)
!341 = !DILocation(line: 80, column: 5, scope: !279)
!342 = !DILocation(line: 80, column: 8, scope: !279)
!343 = !DILocation(line: 82, column: 12, scope: !279)
!344 = !DILocation(line: 82, column: 5, scope: !279)
!345 = !DILocation(line: 83, column: 5, scope: !279)
!346 = !DILocation(line: 84, column: 1, scope: !279)
!347 = distinct !DISubprogram(name: "register_variable<int>", linkageName: "_Z17register_variableIiEvPT_PKc", scope: !348, file: !348, line: 13, type: !349, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, templateParams: !352, retainedNodes: !2)
!348 = !DIFile(filename: "include/ExtrapInstrumenter.hpp", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!349 = !DISubroutineType(types: !350)
!350 = !{null, !351, !113}
!351 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !22, size: 64)
!352 = !{!353}
!353 = !DITemplateTypeParameter(name: "T", type: !22)
!354 = !DILocalVariable(name: "ptr", arg: 1, scope: !347, file: !348, line: 13, type: !351)
!355 = !DILocation(line: 13, column: 28, scope: !347)
!356 = !DILocalVariable(name: "name", arg: 2, scope: !347, file: !348, line: 13, type: !113)
!357 = !DILocation(line: 13, column: 46, scope: !347)
!358 = !DILocalVariable(name: "param_id", scope: !347, file: !348, line: 15, type: !20)
!359 = !DILocation(line: 15, column: 13, scope: !347)
!360 = !DILocation(line: 15, column: 24, scope: !347)
!361 = !DILocation(line: 16, column: 57, scope: !347)
!362 = !DILocation(line: 16, column: 31, scope: !347)
!363 = !DILocation(line: 16, column: 82, scope: !347)
!364 = !DILocation(line: 16, column: 86, scope: !347)
!365 = !DILocation(line: 16, column: 5, scope: !347)
!366 = !DILocation(line: 17, column: 1, scope: !347)
!367 = distinct !DISubprogram(name: "Grid", linkageName: "_ZN4GridC2Eiii", scope: !303, file: !1, line: 13, type: !311, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, declaration: !310, retainedNodes: !2)
!368 = !DILocalVariable(name: "this", arg: 1, scope: !367, type: !302, flags: DIFlagArtificial | DIFlagObjectPointer)
!369 = !DILocation(line: 0, scope: !367)
!370 = !DILocalVariable(name: "_x", arg: 2, scope: !367, file: !1, line: 13, type: !22)
!371 = !DILocation(line: 13, column: 14, scope: !367)
!372 = !DILocalVariable(name: "_y", arg: 3, scope: !367, file: !1, line: 13, type: !22)
!373 = !DILocation(line: 13, column: 22, scope: !367)
!374 = !DILocalVariable(name: "_z", arg: 4, scope: !367, file: !1, line: 13, type: !22)
!375 = !DILocation(line: 13, column: 30, scope: !367)
!376 = !DILocation(line: 14, column: 9, scope: !367)
!377 = !DILocation(line: 14, column: 11, scope: !367)
!378 = !DILocation(line: 15, column: 9, scope: !367)
!379 = !DILocation(line: 15, column: 11, scope: !367)
!380 = !DILocation(line: 16, column: 9, scope: !367)
!381 = !DILocation(line: 16, column: 11, scope: !367)
!382 = !DILocation(line: 17, column: 9, scope: !367)
!383 = !DILocation(line: 17, column: 25, scope: !367)
!384 = !DILocation(line: 17, column: 27, scope: !367)
!385 = !DILocation(line: 17, column: 26, scope: !367)
!386 = !DILocation(line: 17, column: 14, scope: !367)
!387 = !DILocation(line: 18, column: 10, scope: !367)
!388 = distinct !DISubprogram(name: "update_grid", linkageName: "_ZN4Grid11update_gridEd", scope: !303, file: !1, line: 24, type: !318, scopeLine: 25, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, declaration: !317, retainedNodes: !2)
!389 = !DILocalVariable(name: "this", arg: 1, scope: !388, type: !302, flags: DIFlagArtificial | DIFlagObjectPointer)
!390 = !DILocation(line: 0, scope: !388)
!391 = !DILocalVariable(name: "shift", arg: 2, scope: !388, file: !1, line: 24, type: !112)
!392 = !DILocation(line: 24, column: 29, scope: !388)
!393 = !DILocation(line: 26, column: 17, scope: !388)
!394 = !DILocation(line: 29, column: 5, scope: !388)
!395 = distinct !DISubprogram(name: "update_constant", linkageName: "_ZN4Grid15update_constantEd", scope: !303, file: !1, line: 31, type: !318, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, declaration: !320, retainedNodes: !2)
!396 = !DILocalVariable(name: "this", arg: 1, scope: !395, type: !302, flags: DIFlagArtificial | DIFlagObjectPointer)
!397 = !DILocation(line: 0, scope: !395)
!398 = !DILocalVariable(name: "shift", arg: 2, scope: !395, file: !1, line: 31, type: !112)
!399 = !DILocation(line: 31, column: 33, scope: !395)
!400 = !DILocation(line: 33, column: 22, scope: !395)
!401 = !DILocation(line: 33, column: 21, scope: !395)
!402 = !DILocation(line: 33, column: 9, scope: !395)
!403 = !DILocation(line: 33, column: 17, scope: !395)
!404 = !DILocation(line: 34, column: 17, scope: !395)
!405 = !DILocation(line: 37, column: 5, scope: !395)
!406 = distinct !DISubprogram(name: "update_y", linkageName: "_ZN4Grid8update_yEd", scope: !303, file: !1, line: 49, type: !318, scopeLine: 50, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, declaration: !322, retainedNodes: !2)
!407 = !DILocalVariable(name: "this", arg: 1, scope: !406, type: !302, flags: DIFlagArtificial | DIFlagObjectPointer)
!408 = !DILocation(line: 0, scope: !406)
!409 = !DILocalVariable(name: "shift", arg: 2, scope: !406, file: !1, line: 49, type: !112)
!410 = !DILocation(line: 49, column: 26, scope: !406)
!411 = !DILocation(line: 51, column: 17, scope: !406)
!412 = !DILocation(line: 54, column: 5, scope: !406)
!413 = distinct !DISubprogram(name: "update_data", linkageName: "_ZN4Grid11update_dataEd", scope: !303, file: !1, line: 40, type: !318, scopeLine: 41, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, declaration: !321, retainedNodes: !2)
!414 = !DILocalVariable(name: "this", arg: 1, scope: !413, type: !302, flags: DIFlagArtificial | DIFlagObjectPointer)
!415 = !DILocation(line: 0, scope: !413)
!416 = !DILocalVariable(name: "shift", arg: 2, scope: !413, file: !1, line: 40, type: !112)
!417 = !DILocation(line: 40, column: 29, scope: !413)
!418 = !DILocation(line: 42, column: 22, scope: !413)
!419 = !DILocation(line: 42, column: 21, scope: !413)
!420 = !DILocation(line: 42, column: 9, scope: !413)
!421 = !DILocation(line: 42, column: 17, scope: !413)
!422 = !DILocation(line: 43, column: 17, scope: !413)
!423 = !DILocation(line: 46, column: 5, scope: !413)
!424 = distinct !DISubprogram(name: "update_z", linkageName: "_ZN4Grid8update_zEd", scope: !303, file: !1, line: 57, type: !318, scopeLine: 58, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, declaration: !323, retainedNodes: !2)
!425 = !DILocalVariable(name: "this", arg: 1, scope: !424, type: !302, flags: DIFlagArtificial | DIFlagObjectPointer)
!426 = !DILocation(line: 0, scope: !424)
!427 = !DILocalVariable(name: "shift", arg: 2, scope: !424, file: !1, line: 57, type: !112)
!428 = !DILocation(line: 57, column: 26, scope: !424)
!429 = !DILocation(line: 59, column: 17, scope: !424)
!430 = !DILocation(line: 62, column: 5, scope: !424)
!431 = distinct !DISubprogram(name: "~Grid", linkageName: "_ZN4GridD2Ev", scope: !303, file: !1, line: 19, type: !315, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, declaration: !314, retainedNodes: !2)
!432 = !DILocalVariable(name: "this", arg: 1, scope: !431, type: !302, flags: DIFlagArtificial | DIFlagObjectPointer)
!433 = !DILocation(line: 0, scope: !431)
!434 = !DILocation(line: 21, column: 18, scope: !435)
!435 = distinct !DILexicalBlock(scope: !431, file: !1, line: 20, column: 5)
!436 = !DILocation(line: 21, column: 9, scope: !435)
!437 = !DILocation(line: 22, column: 5, scope: !431)
!438 = distinct !DISubprogram(name: ".omp_outlined._debug__", scope: !1, file: !1, line: 27, type: !439, scopeLine: 27, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !2)
!439 = !DISubroutineType(types: !440)
!440 = !{null, !441, !441, !302, !445}
!441 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !442)
!442 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !443)
!443 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !444, size: 64)
!444 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !22)
!445 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !112, size: 64)
!446 = !DILocalVariable(name: ".global_tid.", arg: 1, scope: !438, type: !441, flags: DIFlagArtificial)
!447 = !DILocation(line: 0, scope: !438)
!448 = !DILocalVariable(name: ".bound_tid.", arg: 2, scope: !438, type: !441, flags: DIFlagArtificial)
!449 = !DILocalVariable(name: "this", arg: 3, scope: !438, file: !1, line: 27, type: !302)
!450 = !DILocation(line: 27, column: 28, scope: !438)
!451 = !DILocalVariable(name: "shift", arg: 4, scope: !438, file: !1, line: 24, type: !445)
!452 = !DILocation(line: 24, column: 29, scope: !438)
!453 = !DILocation(line: 27, column: 9, scope: !438)
!454 = !DILocalVariable(name: "i", scope: !455, file: !1, line: 27, type: !22)
!455 = distinct !DILexicalBlock(scope: !438, file: !1, line: 27, column: 9)
!456 = !DILocation(line: 27, column: 17, scope: !455)
!457 = !DILocation(line: 27, column: 13, scope: !455)
!458 = !DILocation(line: 27, column: 24, scope: !459)
!459 = distinct !DILexicalBlock(scope: !455, file: !1, line: 27, column: 9)
!460 = !DILocation(line: 27, column: 28, scope: !459)
!461 = !DILocation(line: 27, column: 30, scope: !459)
!462 = !DILocation(line: 27, column: 29, scope: !459)
!463 = !DILocation(line: 27, column: 26, scope: !459)
!464 = !DILocation(line: 27, column: 9, scope: !455)
!465 = !DILocation(line: 28, column: 24, scope: !459)
!466 = !DILocation(line: 28, column: 13, scope: !459)
!467 = !DILocation(line: 28, column: 18, scope: !459)
!468 = !DILocation(line: 28, column: 21, scope: !459)
!469 = !DILocation(line: 27, column: 32, scope: !459)
!470 = !DILocation(line: 27, column: 9, scope: !459)
!471 = distinct !{!471, !464, !472}
!472 = !DILocation(line: 28, column: 24, scope: !455)
!473 = !DILocation(line: 28, column: 24, scope: !438)
!474 = distinct !DISubprogram(name: ".omp_outlined.", scope: !1, file: !1, line: 27, type: !439, scopeLine: 27, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !2)
!475 = !DILocalVariable(name: ".global_tid.", arg: 1, scope: !474, type: !441, flags: DIFlagArtificial)
!476 = !DILocation(line: 0, scope: !474)
!477 = !DILocalVariable(name: ".bound_tid.", arg: 2, scope: !474, type: !441, flags: DIFlagArtificial)
!478 = !DILocalVariable(name: "this", arg: 3, scope: !474, type: !302, flags: DIFlagArtificial)
!479 = !DILocalVariable(name: "shift", arg: 4, scope: !474, type: !445, flags: DIFlagArtificial)
!480 = !DILocation(line: 27, column: 9, scope: !474)
!481 = distinct !DISubprogram(name: ".omp_outlined._debug__.5", scope: !1, file: !1, line: 35, type: !439, scopeLine: 35, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !2)
!482 = !DILocalVariable(name: ".global_tid.", arg: 1, scope: !481, type: !441, flags: DIFlagArtificial)
!483 = !DILocation(line: 0, scope: !481)
!484 = !DILocalVariable(name: ".bound_tid.", arg: 2, scope: !481, type: !441, flags: DIFlagArtificial)
!485 = !DILocalVariable(name: "this", arg: 3, scope: !481, file: !1, line: 36, type: !302)
!486 = !DILocation(line: 36, column: 13, scope: !481)
!487 = !DILocalVariable(name: "shift", arg: 4, scope: !481, file: !1, line: 31, type: !445)
!488 = !DILocation(line: 31, column: 33, scope: !481)
!489 = !DILocation(line: 35, column: 9, scope: !481)
!490 = !DILocalVariable(name: "i", scope: !491, file: !1, line: 35, type: !22)
!491 = distinct !DILexicalBlock(scope: !481, file: !1, line: 35, column: 9)
!492 = !DILocation(line: 35, column: 17, scope: !491)
!493 = !DILocation(line: 35, column: 13, scope: !491)
!494 = !DILocation(line: 35, column: 24, scope: !495)
!495 = distinct !DILexicalBlock(scope: !491, file: !1, line: 35, column: 9)
!496 = !DILocation(line: 35, column: 26, scope: !495)
!497 = !DILocation(line: 35, column: 9, scope: !491)
!498 = !DILocation(line: 36, column: 24, scope: !495)
!499 = !DILocation(line: 36, column: 13, scope: !495)
!500 = !DILocation(line: 36, column: 18, scope: !495)
!501 = !DILocation(line: 36, column: 21, scope: !495)
!502 = !DILocation(line: 35, column: 30, scope: !495)
!503 = !DILocation(line: 35, column: 9, scope: !495)
!504 = distinct !{!504, !497, !505}
!505 = !DILocation(line: 36, column: 24, scope: !491)
!506 = !DILocation(line: 36, column: 24, scope: !481)
!507 = distinct !DISubprogram(name: ".omp_outlined..6", scope: !1, file: !1, line: 35, type: !439, scopeLine: 35, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !2)
!508 = !DILocalVariable(name: ".global_tid.", arg: 1, scope: !507, type: !441, flags: DIFlagArtificial)
!509 = !DILocation(line: 0, scope: !507)
!510 = !DILocalVariable(name: ".bound_tid.", arg: 2, scope: !507, type: !441, flags: DIFlagArtificial)
!511 = !DILocalVariable(name: "this", arg: 3, scope: !507, type: !302, flags: DIFlagArtificial)
!512 = !DILocalVariable(name: "shift", arg: 4, scope: !507, type: !445, flags: DIFlagArtificial)
!513 = !DILocation(line: 35, column: 9, scope: !507)
!514 = distinct !DISubprogram(name: ".omp_outlined._debug__.7", scope: !1, file: !1, line: 52, type: !439, scopeLine: 52, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !2)
!515 = !DILocalVariable(name: ".global_tid.", arg: 1, scope: !514, type: !441, flags: DIFlagArtificial)
!516 = !DILocation(line: 0, scope: !514)
!517 = !DILocalVariable(name: ".bound_tid.", arg: 2, scope: !514, type: !441, flags: DIFlagArtificial)
!518 = !DILocalVariable(name: "this", arg: 3, scope: !514, file: !1, line: 52, type: !302)
!519 = !DILocation(line: 52, column: 38, scope: !514)
!520 = !DILocalVariable(name: "shift", arg: 4, scope: !514, file: !1, line: 49, type: !445)
!521 = !DILocation(line: 49, column: 26, scope: !514)
!522 = !DILocation(line: 52, column: 9, scope: !514)
!523 = !DILocalVariable(name: "i", scope: !524, file: !1, line: 52, type: !22)
!524 = distinct !DILexicalBlock(scope: !514, file: !1, line: 52, column: 9)
!525 = !DILocation(line: 52, column: 17, scope: !524)
!526 = !DILocation(line: 52, column: 13, scope: !524)
!527 = !DILocation(line: 52, column: 24, scope: !528)
!528 = distinct !DILexicalBlock(scope: !524, file: !1, line: 52, column: 9)
!529 = !DILocation(line: 52, column: 26, scope: !528)
!530 = !DILocation(line: 52, column: 9, scope: !524)
!531 = !DILocation(line: 53, column: 24, scope: !528)
!532 = !DILocation(line: 53, column: 13, scope: !528)
!533 = !DILocation(line: 53, column: 18, scope: !528)
!534 = !DILocation(line: 53, column: 21, scope: !528)
!535 = !DILocation(line: 52, column: 38, scope: !528)
!536 = !DILocation(line: 52, column: 35, scope: !528)
!537 = !DILocation(line: 52, column: 9, scope: !528)
!538 = distinct !{!538, !530, !539}
!539 = !DILocation(line: 53, column: 24, scope: !524)
!540 = !DILocation(line: 53, column: 24, scope: !514)
!541 = distinct !DISubprogram(name: ".omp_outlined..8", scope: !1, file: !1, line: 52, type: !439, scopeLine: 52, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !2)
!542 = !DILocalVariable(name: ".global_tid.", arg: 1, scope: !541, type: !441, flags: DIFlagArtificial)
!543 = !DILocation(line: 0, scope: !541)
!544 = !DILocalVariable(name: ".bound_tid.", arg: 2, scope: !541, type: !441, flags: DIFlagArtificial)
!545 = !DILocalVariable(name: "this", arg: 3, scope: !541, type: !302, flags: DIFlagArtificial)
!546 = !DILocalVariable(name: "shift", arg: 4, scope: !541, type: !445, flags: DIFlagArtificial)
!547 = !DILocation(line: 52, column: 9, scope: !541)
!548 = distinct !DISubprogram(name: ".omp_outlined._debug__.9", scope: !1, file: !1, line: 44, type: !439, scopeLine: 44, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !2)
!549 = !DILocalVariable(name: ".global_tid.", arg: 1, scope: !548, type: !441, flags: DIFlagArtificial)
!550 = !DILocation(line: 0, scope: !548)
!551 = !DILocalVariable(name: ".bound_tid.", arg: 2, scope: !548, type: !441, flags: DIFlagArtificial)
!552 = !DILocalVariable(name: "this", arg: 3, scope: !548, file: !1, line: 44, type: !302)
!553 = !DILocation(line: 44, column: 21, scope: !548)
!554 = !DILocalVariable(name: "shift", arg: 4, scope: !548, file: !1, line: 40, type: !445)
!555 = !DILocation(line: 40, column: 29, scope: !548)
!556 = !DILocation(line: 44, column: 9, scope: !548)
!557 = !DILocalVariable(name: "i", scope: !558, file: !1, line: 44, type: !22)
!558 = distinct !DILexicalBlock(scope: !548, file: !1, line: 44, column: 9)
!559 = !DILocation(line: 44, column: 17, scope: !558)
!560 = !DILocation(line: 44, column: 21, scope: !558)
!561 = !DILocation(line: 44, column: 13, scope: !558)
!562 = !DILocation(line: 44, column: 30, scope: !563)
!563 = distinct !DILexicalBlock(scope: !558, file: !1, line: 44, column: 9)
!564 = !DILocation(line: 44, column: 32, scope: !563)
!565 = !DILocation(line: 44, column: 9, scope: !558)
!566 = !DILocation(line: 45, column: 24, scope: !563)
!567 = !DILocation(line: 45, column: 13, scope: !563)
!568 = !DILocation(line: 45, column: 18, scope: !563)
!569 = !DILocation(line: 45, column: 21, scope: !563)
!570 = !DILocation(line: 44, column: 36, scope: !563)
!571 = !DILocation(line: 44, column: 9, scope: !563)
!572 = distinct !{!572, !565, !573}
!573 = !DILocation(line: 45, column: 24, scope: !558)
!574 = !DILocation(line: 45, column: 24, scope: !548)
!575 = distinct !DISubprogram(name: ".omp_outlined..10", scope: !1, file: !1, line: 44, type: !439, scopeLine: 44, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !2)
!576 = !DILocalVariable(name: ".global_tid.", arg: 1, scope: !575, type: !441, flags: DIFlagArtificial)
!577 = !DILocation(line: 0, scope: !575)
!578 = !DILocalVariable(name: ".bound_tid.", arg: 2, scope: !575, type: !441, flags: DIFlagArtificial)
!579 = !DILocalVariable(name: "this", arg: 3, scope: !575, type: !302, flags: DIFlagArtificial)
!580 = !DILocalVariable(name: "shift", arg: 4, scope: !575, type: !445, flags: DIFlagArtificial)
!581 = !DILocation(line: 44, column: 9, scope: !575)
!582 = distinct !DISubprogram(name: ".omp_outlined._debug__.11", scope: !1, file: !1, line: 60, type: !439, scopeLine: 60, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !2)
!583 = !DILocalVariable(name: ".global_tid.", arg: 1, scope: !582, type: !441, flags: DIFlagArtificial)
!584 = !DILocation(line: 0, scope: !582)
!585 = !DILocalVariable(name: ".bound_tid.", arg: 2, scope: !582, type: !441, flags: DIFlagArtificial)
!586 = !DILocalVariable(name: "this", arg: 3, scope: !582, file: !1, line: 60, type: !302)
!587 = !DILocation(line: 60, column: 28, scope: !582)
!588 = !DILocalVariable(name: "shift", arg: 4, scope: !582, file: !1, line: 57, type: !445)
!589 = !DILocation(line: 57, column: 26, scope: !582)
!590 = !DILocation(line: 60, column: 9, scope: !582)
!591 = !DILocalVariable(name: "i", scope: !592, file: !1, line: 60, type: !22)
!592 = distinct !DILexicalBlock(scope: !582, file: !1, line: 60, column: 9)
!593 = !DILocation(line: 60, column: 17, scope: !592)
!594 = !DILocation(line: 60, column: 13, scope: !592)
!595 = !DILocation(line: 60, column: 24, scope: !596)
!596 = distinct !DILexicalBlock(scope: !592, file: !1, line: 60, column: 9)
!597 = !DILocation(line: 60, column: 28, scope: !596)
!598 = !DILocation(line: 60, column: 26, scope: !596)
!599 = !DILocation(line: 60, column: 9, scope: !592)
!600 = !DILocation(line: 61, column: 24, scope: !596)
!601 = !DILocation(line: 61, column: 13, scope: !596)
!602 = !DILocation(line: 61, column: 18, scope: !596)
!603 = !DILocation(line: 61, column: 21, scope: !596)
!604 = !DILocation(line: 60, column: 30, scope: !596)
!605 = !DILocation(line: 60, column: 9, scope: !596)
!606 = distinct !{!606, !599, !607}
!607 = !DILocation(line: 61, column: 24, scope: !592)
!608 = !DILocation(line: 61, column: 24, scope: !582)
!609 = distinct !DISubprogram(name: ".omp_outlined..12", scope: !1, file: !1, line: 60, type: !439, scopeLine: 60, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition, unit: !0, retainedNodes: !2)
!610 = !DILocalVariable(name: ".global_tid.", arg: 1, scope: !609, type: !441, flags: DIFlagArtificial)
!611 = !DILocation(line: 0, scope: !609)
!612 = !DILocalVariable(name: ".bound_tid.", arg: 2, scope: !609, type: !441, flags: DIFlagArtificial)
!613 = !DILocalVariable(name: "this", arg: 3, scope: !609, type: !302, flags: DIFlagArtificial)
!614 = !DILocalVariable(name: "shift", arg: 4, scope: !609, type: !445, flags: DIFlagArtificial)
!615 = !DILocation(line: 60, column: 9, scope: !609)
