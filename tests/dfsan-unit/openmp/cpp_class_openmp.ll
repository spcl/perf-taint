; RUN: opt %dfsan -S < %s 2> /dev/null | llc %llcparams - -o %t1 && clang++ %link %omplink %t1 -o %t2 && OMP_NUM_THREADS=1 %execparams %t2 10 10 10 | diff -w %s.json -
; RUN: %jsonconvert %s.json | diff -w %s.processed.json -
; ModuleID = 'tests/dfsan-unit/openmp/cpp_class_openmp.cpp'
source_filename = "tests/dfsan-unit/openmp/cpp_class_openmp.cpp"
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
@.str.1 = private unnamed_addr constant [45 x i8] c"tests/dfsan-unit/openmp/cpp_class_openmp.cpp\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [7 x i8] c"size_x\00", align 1
@.str.3 = private unnamed_addr constant [7 x i8] c"size_y\00", align 1
@.str.4 = private unnamed_addr constant [23 x i8] c";unknown;unknown;0;0;;\00", align 1
@0 = private unnamed_addr global %struct.ident_t { i32 0, i32 2, i32 0, i32 0, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str.4, i32 0, i32 0) }, align 8
@1 = private unnamed_addr constant [71 x i8] c";tests/dfsan-unit/openmp/cpp_class_openmp.cpp;Grid::update_grid;26;9;;\00", align 1
@2 = private unnamed_addr constant [75 x i8] c";tests/dfsan-unit/openmp/cpp_class_openmp.cpp;Grid::update_constant;34;9;;\00", align 1
@3 = private unnamed_addr constant [68 x i8] c";tests/dfsan-unit/openmp/cpp_class_openmp.cpp;Grid::update_y;51;9;;\00", align 1
@4 = private unnamed_addr constant [71 x i8] c";tests/dfsan-unit/openmp/cpp_class_openmp.cpp;Grid::update_data;43;9;;\00", align 1
@5 = private unnamed_addr constant [68 x i8] c";tests/dfsan-unit/openmp/cpp_class_openmp.cpp;Grid::update_z;59;9;;\00", align 1

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
  store i32 %0, i32* %4, align 4, !tbaa !325
  call void @llvm.dbg.declare(metadata i32* %4, metadata !297, metadata !DIExpression()), !dbg !329
  store i8** %1, i8*** %5, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !298, metadata !DIExpression()), !dbg !332
  %12 = bitcast i32* %6 to i8*, !dbg !333
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %12) #3, !dbg !333
  call void @llvm.dbg.declare(metadata i32* %6, metadata !299, metadata !DIExpression()), !dbg !334
  %13 = bitcast i32* %6 to i8*, !dbg !333
  call void @llvm.var.annotation(i8* %13, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([45 x i8], [45 x i8]* @.str.1, i32 0, i32 0), i32 67), !dbg !333
  %14 = load i8**, i8*** %5, align 8, !dbg !335, !tbaa !330
  %15 = getelementptr inbounds i8*, i8** %14, i64 1, !dbg !335
  %16 = load i8*, i8** %15, align 8, !dbg !335, !tbaa !330
  %17 = call i32 @atoi(i8* %16) #12, !dbg !336
  store i32 %17, i32* %6, align 4, !dbg !334, !tbaa !325
  %18 = bitcast i32* %7 to i8*, !dbg !337
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %18) #3, !dbg !337
  call void @llvm.dbg.declare(metadata i32* %7, metadata !300, metadata !DIExpression()), !dbg !338
  %19 = bitcast i32* %7 to i8*, !dbg !337
  call void @llvm.var.annotation(i8* %19, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([45 x i8], [45 x i8]* @.str.1, i32 0, i32 0), i32 68), !dbg !337
  %20 = load i8**, i8*** %5, align 8, !dbg !339, !tbaa !330
  %21 = getelementptr inbounds i8*, i8** %20, i64 2, !dbg !339
  %22 = load i8*, i8** %21, align 8, !dbg !339, !tbaa !330
  %23 = call i32 @atoi(i8* %22) #12, !dbg !340
  store i32 %23, i32* %7, align 4, !dbg !338, !tbaa !325
  %24 = bitcast i32* %8 to i8*, !dbg !341
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %24) #3, !dbg !341
  call void @llvm.dbg.declare(metadata i32* %8, metadata !301, metadata !DIExpression()), !dbg !342
  %25 = bitcast i32* %8 to i8*, !dbg !341
  call void @llvm.var.annotation(i8* %25, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([45 x i8], [45 x i8]* @.str.1, i32 0, i32 0), i32 69), !dbg !341
  %26 = load i8**, i8*** %5, align 8, !dbg !343, !tbaa !330
  %27 = getelementptr inbounds i8*, i8** %26, i64 3, !dbg !343
  %28 = load i8*, i8** %27, align 8, !dbg !343, !tbaa !330
  %29 = call i32 @atoi(i8* %28) #12, !dbg !344
  store i32 %29, i32* %8, align 4, !dbg !342, !tbaa !325
  %30 = bitcast %class.Grid** %9 to i8*, !dbg !345
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %30) #3, !dbg !345
  call void @llvm.dbg.declare(metadata %class.Grid** %9, metadata !302, metadata !DIExpression()), !dbg !346
  call void @_Z17register_variableIiEvPT_PKc(i32* %6, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.2, i64 0, i64 0)), !dbg !347
  call void @_Z17register_variableIiEvPT_PKc(i32* %7, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.3, i64 0, i64 0)), !dbg !348
  %31 = call i8* @_Znwm(i64 24) #13, !dbg !349
  %32 = bitcast i8* %31 to %class.Grid*, !dbg !349
  %33 = load i32, i32* %6, align 4, !dbg !350, !tbaa !325
  %34 = load i32, i32* %7, align 4, !dbg !351, !tbaa !325
  %35 = load i32, i32* %8, align 4, !dbg !352, !tbaa !325
  invoke void @_ZN4GridC2Eiii(%class.Grid* %32, i32 %33, i32 %34, i32 %35)
          to label %36 unwind label %51, !dbg !353

36:                                               ; preds = %2
  store %class.Grid* %32, %class.Grid** %9, align 8, !dbg !354, !tbaa !330
  %37 = load %class.Grid*, %class.Grid** %9, align 8, !dbg !355, !tbaa !330
  call void @_ZN4Grid11update_gridEd(%class.Grid* %37, double 2.000000e+00), !dbg !356
  %38 = load %class.Grid*, %class.Grid** %9, align 8, !dbg !357, !tbaa !330
  call void @_ZN4Grid15update_constantEd(%class.Grid* %38, double 1.500000e+00), !dbg !358
  %39 = load %class.Grid*, %class.Grid** %9, align 8, !dbg !359, !tbaa !330
  call void @_ZN4Grid8update_yEd(%class.Grid* %39, double 1.500000e+00), !dbg !360
  %40 = load %class.Grid*, %class.Grid** %9, align 8, !dbg !361, !tbaa !330
  call void @_ZN4Grid11update_dataEd(%class.Grid* %40, double 1.500000e+00), !dbg !362
  %41 = load %class.Grid*, %class.Grid** %9, align 8, !dbg !363, !tbaa !330
  call void @_ZN4Grid8update_zEd(%class.Grid* %41, double 1.500000e+00), !dbg !364
  %42 = load %class.Grid*, %class.Grid** %9, align 8, !dbg !365, !tbaa !330
  %43 = icmp eq %class.Grid* %42, null, !dbg !366
  br i1 %43, label %46, label %44, !dbg !366

44:                                               ; preds = %36
  call void @_ZN4GridD2Ev(%class.Grid* %42) #3, !dbg !366
  %45 = bitcast %class.Grid* %42 to i8*, !dbg !366
  call void @_ZdlPv(i8* %45) #14, !dbg !366
  br label %46, !dbg !366

46:                                               ; preds = %44, %36
  %47 = bitcast %class.Grid** %9 to i8*, !dbg !367
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %47) #3, !dbg !367
  %48 = bitcast i32* %8 to i8*, !dbg !367
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %48) #3, !dbg !367
  %49 = bitcast i32* %7 to i8*, !dbg !367
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %49) #3, !dbg !367
  %50 = bitcast i32* %6 to i8*, !dbg !367
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %50) #3, !dbg !367
  ret i32 0, !dbg !368

51:                                               ; preds = %2
  %52 = landingpad { i8*, i32 }
          cleanup, !dbg !367
  %53 = extractvalue { i8*, i32 } %52, 0, !dbg !367
  store i8* %53, i8** %10, align 8, !dbg !367
  %54 = extractvalue { i8*, i32 } %52, 1, !dbg !367
  store i32 %54, i32* %11, align 4, !dbg !367
  call void @_ZdlPv(i8* %31) #14, !dbg !349
  %55 = bitcast %class.Grid** %9 to i8*, !dbg !367
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %55) #3, !dbg !367
  %56 = bitcast i32* %8 to i8*, !dbg !367
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %56) #3, !dbg !367
  %57 = bitcast i32* %7 to i8*, !dbg !367
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %57) #3, !dbg !367
  %58 = bitcast i32* %6 to i8*, !dbg !367
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %58) #3, !dbg !367
  br label %59, !dbg !367

59:                                               ; preds = %51
  %60 = load i8*, i8** %10, align 8, !dbg !367
  %61 = load i32, i32* %11, align 4, !dbg !367
  %62 = insertvalue { i8*, i32 } undef, i8* %60, 0, !dbg !367
  %63 = insertvalue { i8*, i32 } %62, i32 %61, 1, !dbg !367
  resume { i8*, i32 } %63, !dbg !367
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
  store i8* %0, i8** %2, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata i8** %2, metadata !132, metadata !DIExpression()), !dbg !369
  %3 = load i8*, i8** %2, align 8, !dbg !370, !tbaa !330
  %4 = call i64 @strtol(i8* %3, i8** null, i32 10) #3, !dbg !371
  %5 = trunc i64 %4 to i32, !dbg !371
  ret i32 %5, !dbg !372
}

; Function Attrs: uwtable
define linkonce_odr dso_local void @_Z17register_variableIiEvPT_PKc(i32*, i8*) #5 comdat !dbg !373 {
  %3 = alloca i32*, align 8
  %4 = alloca i8*, align 8
  store i32* %0, i32** %3, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata i32** %3, metadata !379, metadata !DIExpression()), !dbg !383
  store i8* %1, i8** %4, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata i8** %4, metadata !380, metadata !DIExpression()), !dbg !384
  %5 = load i32*, i32** %3, align 8, !dbg !385, !tbaa !330
  %6 = bitcast i32* %5 to i8*, !dbg !386
  %7 = load i8*, i8** %4, align 8, !dbg !387, !tbaa !330
  call void @__dfsw_EXTRAP_WRITE_LABEL(i8* %6, i32 4, i8* %7), !dbg !388
  ret void, !dbg !389
}

; Function Attrs: nobuiltin
declare dso_local noalias i8* @_Znwm(i64) #6

; Function Attrs: uwtable
define linkonce_odr dso_local void @_ZN4GridC2Eiii(%class.Grid*, i32, i32, i32) unnamed_addr #5 comdat align 2 !dbg !390 {
  %5 = alloca %class.Grid*, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store %class.Grid* %0, %class.Grid** %5, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata %class.Grid** %5, metadata !392, metadata !DIExpression()), !dbg !396
  store i32 %1, i32* %6, align 4, !tbaa !325
  call void @llvm.dbg.declare(metadata i32* %6, metadata !393, metadata !DIExpression()), !dbg !397
  store i32 %2, i32* %7, align 4, !tbaa !325
  call void @llvm.dbg.declare(metadata i32* %7, metadata !394, metadata !DIExpression()), !dbg !398
  store i32 %3, i32* %8, align 4, !tbaa !325
  call void @llvm.dbg.declare(metadata i32* %8, metadata !395, metadata !DIExpression()), !dbg !399
  %9 = load %class.Grid*, %class.Grid** %5, align 8
  %10 = getelementptr inbounds %class.Grid, %class.Grid* %9, i32 0, i32 0, !dbg !400
  %11 = load i32, i32* %6, align 4, !dbg !401, !tbaa !325
  store i32 %11, i32* %10, align 8, !dbg !400, !tbaa !402
  %12 = getelementptr inbounds %class.Grid, %class.Grid* %9, i32 0, i32 1, !dbg !404
  %13 = load i32, i32* %7, align 4, !dbg !405, !tbaa !325
  store i32 %13, i32* %12, align 4, !dbg !404, !tbaa !406
  %14 = getelementptr inbounds %class.Grid, %class.Grid* %9, i32 0, i32 2, !dbg !407
  %15 = load i32, i32* %8, align 4, !dbg !408, !tbaa !325
  store i32 %15, i32* %14, align 8, !dbg !407, !tbaa !409
  %16 = getelementptr inbounds %class.Grid, %class.Grid* %9, i32 0, i32 3, !dbg !410
  %17 = getelementptr inbounds %class.Grid, %class.Grid* %9, i32 0, i32 0, !dbg !411
  %18 = load i32, i32* %17, align 8, !dbg !411, !tbaa !402
  %19 = getelementptr inbounds %class.Grid, %class.Grid* %9, i32 0, i32 1, !dbg !412
  %20 = load i32, i32* %19, align 4, !dbg !412, !tbaa !406
  %21 = mul nsw i32 %18, %20, !dbg !413
  %22 = sext i32 %21 to i64, !dbg !411
  %23 = call { i64, i1 } @llvm.umul.with.overflow.i64(i64 %22, i64 8), !dbg !414
  %24 = extractvalue { i64, i1 } %23, 1, !dbg !414
  %25 = extractvalue { i64, i1 } %23, 0, !dbg !414
  %26 = select i1 %24, i64 -1, i64 %25, !dbg !414
  %27 = call i8* @_Znam(i64 %26) #13, !dbg !414
  %28 = bitcast i8* %27 to double*, !dbg !414
  store double* %28, double** %16, align 8, !dbg !410, !tbaa !415
  ret void, !dbg !416
}

declare dso_local i32 @__gxx_personality_v0(...)

; Function Attrs: nobuiltin nounwind
declare dso_local void @_ZdlPv(i8*) #7

; Function Attrs: uwtable
define linkonce_odr dso_local void @_ZN4Grid11update_gridEd(%class.Grid*, double) #5 comdat align 2 !dbg !417 {
  %3 = alloca %class.Grid*, align 8
  %4 = alloca double, align 8
  %5 = alloca %struct.ident_t, align 8
  %6 = bitcast %struct.ident_t* %5 to i8*
  %7 = bitcast %struct.ident_t* @0 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %6, i8* align 8 %7, i64 24, i1 false)
  store %class.Grid* %0, %class.Grid** %3, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata %class.Grid** %3, metadata !419, metadata !DIExpression()), !dbg !421
  store double %1, double* %4, align 8, !tbaa !422
  call void @llvm.dbg.declare(metadata double* %4, metadata !420, metadata !DIExpression()), !dbg !424
  %8 = load %class.Grid*, %class.Grid** %3, align 8
  %9 = getelementptr inbounds %struct.ident_t, %struct.ident_t* %5, i32 0, i32 4, !dbg !425
  store i8* getelementptr inbounds ([71 x i8], [71 x i8]* @1, i32 0, i32 0), i8** %9, align 8, !dbg !425, !tbaa !426
  call void (%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...) @__kmpc_fork_call(%struct.ident_t* %5, i32 2, void (i32*, i32*, ...)* bitcast (void (i32*, i32*, %class.Grid*, double*)* @.omp_outlined. to void (i32*, i32*, ...)*), %class.Grid* %8, double* %4), !dbg !425
  ret void, !dbg !428
}

; Function Attrs: uwtable
define linkonce_odr dso_local void @_ZN4Grid15update_constantEd(%class.Grid*, double) #5 comdat align 2 !dbg !429 {
  %3 = alloca %class.Grid*, align 8
  %4 = alloca double, align 8
  %5 = alloca %struct.ident_t, align 8
  %6 = bitcast %struct.ident_t* %5 to i8*
  %7 = bitcast %struct.ident_t* @0 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %6, i8* align 8 %7, i64 24, i1 false)
  store %class.Grid* %0, %class.Grid** %3, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata %class.Grid** %3, metadata !431, metadata !DIExpression()), !dbg !433
  store double %1, double* %4, align 8, !tbaa !422
  call void @llvm.dbg.declare(metadata double* %4, metadata !432, metadata !DIExpression()), !dbg !434
  %8 = load %class.Grid*, %class.Grid** %3, align 8
  %9 = load double, double* %4, align 8, !dbg !435, !tbaa !422
  %10 = fmul double 2.000000e+00, %9, !dbg !436
  %11 = getelementptr inbounds %class.Grid, %class.Grid* %8, i32 0, i32 3, !dbg !437
  %12 = load double*, double** %11, align 8, !dbg !437, !tbaa !415
  %13 = getelementptr inbounds double, double* %12, i64 0, !dbg !437
  %14 = load double, double* %13, align 8, !dbg !438, !tbaa !422
  %15 = fadd double %14, %10, !dbg !438
  store double %15, double* %13, align 8, !dbg !438, !tbaa !422
  %16 = getelementptr inbounds %struct.ident_t, %struct.ident_t* %5, i32 0, i32 4, !dbg !439
  store i8* getelementptr inbounds ([75 x i8], [75 x i8]* @2, i32 0, i32 0), i8** %16, align 8, !dbg !439, !tbaa !426
  call void (%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...) @__kmpc_fork_call(%struct.ident_t* %5, i32 2, void (i32*, i32*, ...)* bitcast (void (i32*, i32*, %class.Grid*, double*)* @.omp_outlined..6 to void (i32*, i32*, ...)*), %class.Grid* %8, double* %4), !dbg !439
  ret void, !dbg !440
}

; Function Attrs: uwtable
define linkonce_odr dso_local void @_ZN4Grid8update_yEd(%class.Grid*, double) #5 comdat align 2 !dbg !441 {
  %3 = alloca %class.Grid*, align 8
  %4 = alloca double, align 8
  %5 = alloca %struct.ident_t, align 8
  %6 = bitcast %struct.ident_t* %5 to i8*
  %7 = bitcast %struct.ident_t* @0 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %6, i8* align 8 %7, i64 24, i1 false)
  store %class.Grid* %0, %class.Grid** %3, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata %class.Grid** %3, metadata !443, metadata !DIExpression()), !dbg !445
  store double %1, double* %4, align 8, !tbaa !422
  call void @llvm.dbg.declare(metadata double* %4, metadata !444, metadata !DIExpression()), !dbg !446
  %8 = load %class.Grid*, %class.Grid** %3, align 8
  %9 = getelementptr inbounds %struct.ident_t, %struct.ident_t* %5, i32 0, i32 4, !dbg !447
  store i8* getelementptr inbounds ([68 x i8], [68 x i8]* @3, i32 0, i32 0), i8** %9, align 8, !dbg !447, !tbaa !426
  call void (%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...) @__kmpc_fork_call(%struct.ident_t* %5, i32 2, void (i32*, i32*, ...)* bitcast (void (i32*, i32*, %class.Grid*, double*)* @.omp_outlined..8 to void (i32*, i32*, ...)*), %class.Grid* %8, double* %4), !dbg !447
  ret void, !dbg !448
}

; Function Attrs: uwtable
define linkonce_odr dso_local void @_ZN4Grid11update_dataEd(%class.Grid*, double) #5 comdat align 2 !dbg !449 {
  %3 = alloca %class.Grid*, align 8
  %4 = alloca double, align 8
  %5 = alloca %struct.ident_t, align 8
  %6 = bitcast %struct.ident_t* %5 to i8*
  %7 = bitcast %struct.ident_t* @0 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %6, i8* align 8 %7, i64 24, i1 false)
  store %class.Grid* %0, %class.Grid** %3, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata %class.Grid** %3, metadata !451, metadata !DIExpression()), !dbg !453
  store double %1, double* %4, align 8, !tbaa !422
  call void @llvm.dbg.declare(metadata double* %4, metadata !452, metadata !DIExpression()), !dbg !454
  %8 = load %class.Grid*, %class.Grid** %3, align 8
  %9 = load double, double* %4, align 8, !dbg !455, !tbaa !422
  %10 = fmul double 2.000000e+00, %9, !dbg !456
  %11 = getelementptr inbounds %class.Grid, %class.Grid* %8, i32 0, i32 3, !dbg !457
  %12 = load double*, double** %11, align 8, !dbg !457, !tbaa !415
  %13 = getelementptr inbounds double, double* %12, i64 0, !dbg !457
  %14 = load double, double* %13, align 8, !dbg !458, !tbaa !422
  %15 = fadd double %14, %10, !dbg !458
  store double %15, double* %13, align 8, !dbg !458, !tbaa !422
  %16 = getelementptr inbounds %struct.ident_t, %struct.ident_t* %5, i32 0, i32 4, !dbg !459
  store i8* getelementptr inbounds ([71 x i8], [71 x i8]* @4, i32 0, i32 0), i8** %16, align 8, !dbg !459, !tbaa !426
  call void (%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...) @__kmpc_fork_call(%struct.ident_t* %5, i32 2, void (i32*, i32*, ...)* bitcast (void (i32*, i32*, %class.Grid*, double*)* @.omp_outlined..10 to void (i32*, i32*, ...)*), %class.Grid* %8, double* %4), !dbg !459
  ret void, !dbg !460
}

; Function Attrs: uwtable
define linkonce_odr dso_local void @_ZN4Grid8update_zEd(%class.Grid*, double) #5 comdat align 2 !dbg !461 {
  %3 = alloca %class.Grid*, align 8
  %4 = alloca double, align 8
  %5 = alloca %struct.ident_t, align 8
  %6 = bitcast %struct.ident_t* %5 to i8*
  %7 = bitcast %struct.ident_t* @0 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %6, i8* align 8 %7, i64 24, i1 false)
  store %class.Grid* %0, %class.Grid** %3, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata %class.Grid** %3, metadata !463, metadata !DIExpression()), !dbg !465
  store double %1, double* %4, align 8, !tbaa !422
  call void @llvm.dbg.declare(metadata double* %4, metadata !464, metadata !DIExpression()), !dbg !466
  %8 = load %class.Grid*, %class.Grid** %3, align 8
  %9 = getelementptr inbounds %struct.ident_t, %struct.ident_t* %5, i32 0, i32 4, !dbg !467
  store i8* getelementptr inbounds ([68 x i8], [68 x i8]* @5, i32 0, i32 0), i8** %9, align 8, !dbg !467, !tbaa !426
  call void (%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...) @__kmpc_fork_call(%struct.ident_t* %5, i32 2, void (i32*, i32*, ...)* bitcast (void (i32*, i32*, %class.Grid*, double*)* @.omp_outlined..12 to void (i32*, i32*, ...)*), %class.Grid* %8, double* %4), !dbg !467
  ret void, !dbg !468
}

; Function Attrs: nounwind uwtable
define linkonce_odr dso_local void @_ZN4GridD2Ev(%class.Grid*) unnamed_addr #8 comdat align 2 !dbg !469 {
  %2 = alloca %class.Grid*, align 8
  store %class.Grid* %0, %class.Grid** %2, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata %class.Grid** %2, metadata !471, metadata !DIExpression()), !dbg !472
  %3 = load %class.Grid*, %class.Grid** %2, align 8
  %4 = getelementptr inbounds %class.Grid, %class.Grid* %3, i32 0, i32 3, !dbg !473
  %5 = load double*, double** %4, align 8, !dbg !473, !tbaa !415
  %6 = icmp eq double* %5, null, !dbg !475
  br i1 %6, label %9, label %7, !dbg !475

7:                                                ; preds = %1
  %8 = bitcast double* %5 to i8*, !dbg !475
  call void @_ZdaPv(i8* %8) #14, !dbg !475
  br label %9, !dbg !475

9:                                                ; preds = %7, %1
  ret void, !dbg !476
}

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: nounwind
declare dso_local i64 @strtol(i8*, i8**, i32) #9

; Function Attrs: nounwind readnone speculatable
declare { i64, i1 } @llvm.umul.with.overflow.i64(i64, i64) #1

; Function Attrs: nobuiltin
declare dso_local noalias i8* @_Znam(i64) #6

; Function Attrs: norecurse nounwind uwtable
define internal void @.omp_outlined._debug__(i32* noalias, i32* noalias, %class.Grid*, double* dereferenceable(8)) #10 !dbg !477 {
  %5 = alloca i32*, align 8
  %6 = alloca i32*, align 8
  %7 = alloca %class.Grid*, align 8
  %8 = alloca double*, align 8
  %9 = alloca i32, align 4
  store i32* %0, i32** %5, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata i32** %5, metadata !486, metadata !DIExpression()), !dbg !492
  store i32* %1, i32** %6, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata i32** %6, metadata !487, metadata !DIExpression()), !dbg !492
  store %class.Grid* %2, %class.Grid** %7, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata %class.Grid** %7, metadata !488, metadata !DIExpression()), !dbg !493
  store double* %3, double** %8, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata double** %8, metadata !489, metadata !DIExpression()), !dbg !494
  %10 = load %class.Grid*, %class.Grid** %7, align 8, !dbg !495, !tbaa !330
  %11 = load double*, double** %8, align 8, !dbg !495, !tbaa !330
  %12 = bitcast i32* %9 to i8*, !dbg !496
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %12) #3, !dbg !496
  call void @llvm.dbg.declare(metadata i32* %9, metadata !490, metadata !DIExpression()), !dbg !497
  store i32 0, i32* %9, align 4, !dbg !497, !tbaa !325
  br label %13, !dbg !496

13:                                               ; preds = %32, %4
  %14 = load i32, i32* %9, align 4, !dbg !498, !tbaa !325
  %15 = getelementptr inbounds %class.Grid, %class.Grid* %10, i32 0, i32 0, !dbg !500
  %16 = load i32, i32* %15, align 8, !dbg !500, !tbaa !402
  %17 = getelementptr inbounds %class.Grid, %class.Grid* %10, i32 0, i32 1, !dbg !501
  %18 = load i32, i32* %17, align 4, !dbg !501, !tbaa !406
  %19 = mul nsw i32 %16, %18, !dbg !502
  %20 = icmp slt i32 %14, %19, !dbg !503
  br i1 %20, label %23, label %21, !dbg !504

21:                                               ; preds = %13
  %22 = bitcast i32* %9 to i8*, !dbg !505
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %22) #3, !dbg !505
  br label %35

23:                                               ; preds = %13
  %24 = load double, double* %11, align 8, !dbg !506, !tbaa !422
  %25 = getelementptr inbounds %class.Grid, %class.Grid* %10, i32 0, i32 3, !dbg !507
  %26 = load double*, double** %25, align 8, !dbg !507, !tbaa !415
  %27 = load i32, i32* %9, align 4, !dbg !508, !tbaa !325
  %28 = sext i32 %27 to i64, !dbg !507
  %29 = getelementptr inbounds double, double* %26, i64 %28, !dbg !507
  %30 = load double, double* %29, align 8, !dbg !509, !tbaa !422
  %31 = fadd double %30, %24, !dbg !509
  store double %31, double* %29, align 8, !dbg !509, !tbaa !422
  br label %32, !dbg !507

32:                                               ; preds = %23
  %33 = load i32, i32* %9, align 4, !dbg !510, !tbaa !325
  %34 = add nsw i32 %33, 1, !dbg !510
  store i32 %34, i32* %9, align 4, !dbg !510, !tbaa !325
  br label %13, !dbg !505, !llvm.loop !511

35:                                               ; preds = %21
  ret void, !dbg !513
}

; Function Attrs: norecurse nounwind uwtable
define internal void @.omp_outlined.(i32* noalias, i32* noalias, %class.Grid*, double* dereferenceable(8)) #10 !dbg !514 {
  %5 = alloca i32*, align 8
  %6 = alloca i32*, align 8
  %7 = alloca %class.Grid*, align 8
  %8 = alloca double*, align 8
  store i32* %0, i32** %5, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata i32** %5, metadata !516, metadata !DIExpression()), !dbg !520
  store i32* %1, i32** %6, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata i32** %6, metadata !517, metadata !DIExpression()), !dbg !520
  store %class.Grid* %2, %class.Grid** %7, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata %class.Grid** %7, metadata !518, metadata !DIExpression()), !dbg !520
  store double* %3, double** %8, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata double** %8, metadata !519, metadata !DIExpression()), !dbg !520
  %9 = load %class.Grid*, %class.Grid** %7, align 8, !dbg !521, !tbaa !330
  %10 = load double*, double** %8, align 8, !dbg !521, !tbaa !330
  %11 = load i32*, i32** %5, align 8, !dbg !521, !tbaa !330
  %12 = load i32*, i32** %6, align 8, !dbg !521, !tbaa !330
  %13 = load %class.Grid*, %class.Grid** %7, align 8, !dbg !521, !tbaa !330
  %14 = load double*, double** %8, align 8, !dbg !521, !tbaa !330
  call void @.omp_outlined._debug__(i32* %11, i32* %12, %class.Grid* %13, double* %14) #3, !dbg !521
  ret void, !dbg !521
}

; Function Attrs: argmemonly nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i1 immarg) #2

declare !callback !522 dso_local void @__kmpc_fork_call(%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...)

; Function Attrs: norecurse nounwind uwtable
define internal void @.omp_outlined._debug__.5(i32* noalias, i32* noalias, %class.Grid*, double* dereferenceable(8)) #10 !dbg !524 {
  %5 = alloca i32*, align 8
  %6 = alloca i32*, align 8
  %7 = alloca %class.Grid*, align 8
  %8 = alloca double*, align 8
  %9 = alloca i32, align 4
  store i32* %0, i32** %5, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata i32** %5, metadata !526, metadata !DIExpression()), !dbg !532
  store i32* %1, i32** %6, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata i32** %6, metadata !527, metadata !DIExpression()), !dbg !532
  store %class.Grid* %2, %class.Grid** %7, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata %class.Grid** %7, metadata !528, metadata !DIExpression()), !dbg !533
  store double* %3, double** %8, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata double** %8, metadata !529, metadata !DIExpression()), !dbg !534
  %10 = load %class.Grid*, %class.Grid** %7, align 8, !dbg !535, !tbaa !330
  %11 = load double*, double** %8, align 8, !dbg !535, !tbaa !330
  %12 = bitcast i32* %9 to i8*, !dbg !536
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %12) #3, !dbg !536
  call void @llvm.dbg.declare(metadata i32* %9, metadata !530, metadata !DIExpression()), !dbg !537
  store i32 1, i32* %9, align 4, !dbg !537, !tbaa !325
  br label %13, !dbg !536

13:                                               ; preds = %27, %4
  %14 = load i32, i32* %9, align 4, !dbg !538, !tbaa !325
  %15 = icmp slt i32 %14, 5, !dbg !540
  br i1 %15, label %18, label %16, !dbg !541

16:                                               ; preds = %13
  %17 = bitcast i32* %9 to i8*, !dbg !542
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %17) #3, !dbg !542
  br label %30

18:                                               ; preds = %13
  %19 = load double, double* %11, align 8, !dbg !543, !tbaa !422
  %20 = getelementptr inbounds %class.Grid, %class.Grid* %10, i32 0, i32 3, !dbg !544
  %21 = load double*, double** %20, align 8, !dbg !544, !tbaa !415
  %22 = load i32, i32* %9, align 4, !dbg !545, !tbaa !325
  %23 = sext i32 %22 to i64, !dbg !544
  %24 = getelementptr inbounds double, double* %21, i64 %23, !dbg !544
  %25 = load double, double* %24, align 8, !dbg !546, !tbaa !422
  %26 = fadd double %25, %19, !dbg !546
  store double %26, double* %24, align 8, !dbg !546, !tbaa !422
  br label %27, !dbg !544

27:                                               ; preds = %18
  %28 = load i32, i32* %9, align 4, !dbg !547, !tbaa !325
  %29 = add nsw i32 %28, 1, !dbg !547
  store i32 %29, i32* %9, align 4, !dbg !547, !tbaa !325
  br label %13, !dbg !542, !llvm.loop !548

30:                                               ; preds = %16
  ret void, !dbg !550
}

; Function Attrs: norecurse nounwind uwtable
define internal void @.omp_outlined..6(i32* noalias, i32* noalias, %class.Grid*, double* dereferenceable(8)) #10 !dbg !551 {
  %5 = alloca i32*, align 8
  %6 = alloca i32*, align 8
  %7 = alloca %class.Grid*, align 8
  %8 = alloca double*, align 8
  store i32* %0, i32** %5, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata i32** %5, metadata !553, metadata !DIExpression()), !dbg !557
  store i32* %1, i32** %6, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata i32** %6, metadata !554, metadata !DIExpression()), !dbg !557
  store %class.Grid* %2, %class.Grid** %7, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata %class.Grid** %7, metadata !555, metadata !DIExpression()), !dbg !557
  store double* %3, double** %8, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata double** %8, metadata !556, metadata !DIExpression()), !dbg !557
  %9 = load %class.Grid*, %class.Grid** %7, align 8, !dbg !558, !tbaa !330
  %10 = load double*, double** %8, align 8, !dbg !558, !tbaa !330
  %11 = load i32*, i32** %5, align 8, !dbg !558, !tbaa !330
  %12 = load i32*, i32** %6, align 8, !dbg !558, !tbaa !330
  %13 = load %class.Grid*, %class.Grid** %7, align 8, !dbg !558, !tbaa !330
  %14 = load double*, double** %8, align 8, !dbg !558, !tbaa !330
  call void @.omp_outlined._debug__.5(i32* %11, i32* %12, %class.Grid* %13, double* %14) #3, !dbg !558
  ret void, !dbg !558
}

; Function Attrs: norecurse nounwind uwtable
define internal void @.omp_outlined._debug__.7(i32* noalias, i32* noalias, %class.Grid*, double* dereferenceable(8)) #10 !dbg !559 {
  %5 = alloca i32*, align 8
  %6 = alloca i32*, align 8
  %7 = alloca %class.Grid*, align 8
  %8 = alloca double*, align 8
  %9 = alloca i32, align 4
  store i32* %0, i32** %5, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata i32** %5, metadata !561, metadata !DIExpression()), !dbg !567
  store i32* %1, i32** %6, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata i32** %6, metadata !562, metadata !DIExpression()), !dbg !567
  store %class.Grid* %2, %class.Grid** %7, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata %class.Grid** %7, metadata !563, metadata !DIExpression()), !dbg !568
  store double* %3, double** %8, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata double** %8, metadata !564, metadata !DIExpression()), !dbg !569
  %10 = load %class.Grid*, %class.Grid** %7, align 8, !dbg !570, !tbaa !330
  %11 = load double*, double** %8, align 8, !dbg !570, !tbaa !330
  %12 = bitcast i32* %9 to i8*, !dbg !571
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %12) #3, !dbg !571
  call void @llvm.dbg.declare(metadata i32* %9, metadata !565, metadata !DIExpression()), !dbg !572
  store i32 0, i32* %9, align 4, !dbg !572, !tbaa !325
  br label %13, !dbg !571

13:                                               ; preds = %27, %4
  %14 = load i32, i32* %9, align 4, !dbg !573, !tbaa !325
  %15 = icmp slt i32 %14, 100, !dbg !575
  br i1 %15, label %18, label %16, !dbg !576

16:                                               ; preds = %13
  %17 = bitcast i32* %9 to i8*, !dbg !577
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %17) #3, !dbg !577
  br label %32

18:                                               ; preds = %13
  %19 = load double, double* %11, align 8, !dbg !578, !tbaa !422
  %20 = getelementptr inbounds %class.Grid, %class.Grid* %10, i32 0, i32 3, !dbg !579
  %21 = load double*, double** %20, align 8, !dbg !579, !tbaa !415
  %22 = load i32, i32* %9, align 4, !dbg !580, !tbaa !325
  %23 = sext i32 %22 to i64, !dbg !579
  %24 = getelementptr inbounds double, double* %21, i64 %23, !dbg !579
  %25 = load double, double* %24, align 8, !dbg !581, !tbaa !422
  %26 = fadd double %25, %19, !dbg !581
  store double %26, double* %24, align 8, !dbg !581, !tbaa !422
  br label %27, !dbg !579

27:                                               ; preds = %18
  %28 = getelementptr inbounds %class.Grid, %class.Grid* %10, i32 0, i32 1, !dbg !582
  %29 = load i32, i32* %28, align 4, !dbg !582, !tbaa !406
  %30 = load i32, i32* %9, align 4, !dbg !583, !tbaa !325
  %31 = add nsw i32 %30, %29, !dbg !583
  store i32 %31, i32* %9, align 4, !dbg !583, !tbaa !325
  br label %13, !dbg !577, !llvm.loop !584

32:                                               ; preds = %16
  ret void, !dbg !586
}

; Function Attrs: norecurse nounwind uwtable
define internal void @.omp_outlined..8(i32* noalias, i32* noalias, %class.Grid*, double* dereferenceable(8)) #10 !dbg !587 {
  %5 = alloca i32*, align 8
  %6 = alloca i32*, align 8
  %7 = alloca %class.Grid*, align 8
  %8 = alloca double*, align 8
  store i32* %0, i32** %5, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata i32** %5, metadata !589, metadata !DIExpression()), !dbg !593
  store i32* %1, i32** %6, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata i32** %6, metadata !590, metadata !DIExpression()), !dbg !593
  store %class.Grid* %2, %class.Grid** %7, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata %class.Grid** %7, metadata !591, metadata !DIExpression()), !dbg !593
  store double* %3, double** %8, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata double** %8, metadata !592, metadata !DIExpression()), !dbg !593
  %9 = load %class.Grid*, %class.Grid** %7, align 8, !dbg !594, !tbaa !330
  %10 = load double*, double** %8, align 8, !dbg !594, !tbaa !330
  %11 = load i32*, i32** %5, align 8, !dbg !594, !tbaa !330
  %12 = load i32*, i32** %6, align 8, !dbg !594, !tbaa !330
  %13 = load %class.Grid*, %class.Grid** %7, align 8, !dbg !594, !tbaa !330
  %14 = load double*, double** %8, align 8, !dbg !594, !tbaa !330
  call void @.omp_outlined._debug__.7(i32* %11, i32* %12, %class.Grid* %13, double* %14) #3, !dbg !594
  ret void, !dbg !594
}

; Function Attrs: norecurse nounwind uwtable
define internal void @.omp_outlined._debug__.9(i32* noalias, i32* noalias, %class.Grid*, double* dereferenceable(8)) #10 !dbg !595 {
  %5 = alloca i32*, align 8
  %6 = alloca i32*, align 8
  %7 = alloca %class.Grid*, align 8
  %8 = alloca double*, align 8
  %9 = alloca i32, align 4
  store i32* %0, i32** %5, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata i32** %5, metadata !597, metadata !DIExpression()), !dbg !603
  store i32* %1, i32** %6, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata i32** %6, metadata !598, metadata !DIExpression()), !dbg !603
  store %class.Grid* %2, %class.Grid** %7, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata %class.Grid** %7, metadata !599, metadata !DIExpression()), !dbg !604
  store double* %3, double** %8, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata double** %8, metadata !600, metadata !DIExpression()), !dbg !605
  %10 = load %class.Grid*, %class.Grid** %7, align 8, !dbg !606, !tbaa !330
  %11 = load double*, double** %8, align 8, !dbg !606, !tbaa !330
  %12 = bitcast i32* %9 to i8*, !dbg !607
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %12) #3, !dbg !607
  call void @llvm.dbg.declare(metadata i32* %9, metadata !601, metadata !DIExpression()), !dbg !608
  %13 = getelementptr inbounds %class.Grid, %class.Grid* %10, i32 0, i32 3, !dbg !609
  %14 = load double*, double** %13, align 8, !dbg !609, !tbaa !415
  %15 = getelementptr inbounds double, double* %14, i64 0, !dbg !609
  %16 = load double, double* %15, align 8, !dbg !609, !tbaa !422
  %17 = fptosi double %16 to i32, !dbg !609
  store i32 %17, i32* %9, align 4, !dbg !608, !tbaa !325
  br label %18, !dbg !607

18:                                               ; preds = %32, %4
  %19 = load i32, i32* %9, align 4, !dbg !610, !tbaa !325
  %20 = icmp slt i32 %19, 5, !dbg !612
  br i1 %20, label %23, label %21, !dbg !613

21:                                               ; preds = %18
  %22 = bitcast i32* %9 to i8*, !dbg !614
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %22) #3, !dbg !614
  br label %35

23:                                               ; preds = %18
  %24 = load double, double* %11, align 8, !dbg !615, !tbaa !422
  %25 = getelementptr inbounds %class.Grid, %class.Grid* %10, i32 0, i32 3, !dbg !616
  %26 = load double*, double** %25, align 8, !dbg !616, !tbaa !415
  %27 = load i32, i32* %9, align 4, !dbg !617, !tbaa !325
  %28 = sext i32 %27 to i64, !dbg !616
  %29 = getelementptr inbounds double, double* %26, i64 %28, !dbg !616
  %30 = load double, double* %29, align 8, !dbg !618, !tbaa !422
  %31 = fadd double %30, %24, !dbg !618
  store double %31, double* %29, align 8, !dbg !618, !tbaa !422
  br label %32, !dbg !616

32:                                               ; preds = %23
  %33 = load i32, i32* %9, align 4, !dbg !619, !tbaa !325
  %34 = add nsw i32 %33, 1, !dbg !619
  store i32 %34, i32* %9, align 4, !dbg !619, !tbaa !325
  br label %18, !dbg !614, !llvm.loop !620

35:                                               ; preds = %21
  ret void, !dbg !622
}

; Function Attrs: norecurse nounwind uwtable
define internal void @.omp_outlined..10(i32* noalias, i32* noalias, %class.Grid*, double* dereferenceable(8)) #10 !dbg !623 {
  %5 = alloca i32*, align 8
  %6 = alloca i32*, align 8
  %7 = alloca %class.Grid*, align 8
  %8 = alloca double*, align 8
  store i32* %0, i32** %5, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata i32** %5, metadata !625, metadata !DIExpression()), !dbg !629
  store i32* %1, i32** %6, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata i32** %6, metadata !626, metadata !DIExpression()), !dbg !629
  store %class.Grid* %2, %class.Grid** %7, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata %class.Grid** %7, metadata !627, metadata !DIExpression()), !dbg !629
  store double* %3, double** %8, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata double** %8, metadata !628, metadata !DIExpression()), !dbg !629
  %9 = load %class.Grid*, %class.Grid** %7, align 8, !dbg !630, !tbaa !330
  %10 = load double*, double** %8, align 8, !dbg !630, !tbaa !330
  %11 = load i32*, i32** %5, align 8, !dbg !630, !tbaa !330
  %12 = load i32*, i32** %6, align 8, !dbg !630, !tbaa !330
  %13 = load %class.Grid*, %class.Grid** %7, align 8, !dbg !630, !tbaa !330
  %14 = load double*, double** %8, align 8, !dbg !630, !tbaa !330
  call void @.omp_outlined._debug__.9(i32* %11, i32* %12, %class.Grid* %13, double* %14) #3, !dbg !630
  ret void, !dbg !630
}

; Function Attrs: norecurse nounwind uwtable
define internal void @.omp_outlined._debug__.11(i32* noalias, i32* noalias, %class.Grid*, double* dereferenceable(8)) #10 !dbg !631 {
  %5 = alloca i32*, align 8
  %6 = alloca i32*, align 8
  %7 = alloca %class.Grid*, align 8
  %8 = alloca double*, align 8
  %9 = alloca i32, align 4
  store i32* %0, i32** %5, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata i32** %5, metadata !633, metadata !DIExpression()), !dbg !639
  store i32* %1, i32** %6, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata i32** %6, metadata !634, metadata !DIExpression()), !dbg !639
  store %class.Grid* %2, %class.Grid** %7, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata %class.Grid** %7, metadata !635, metadata !DIExpression()), !dbg !640
  store double* %3, double** %8, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata double** %8, metadata !636, metadata !DIExpression()), !dbg !641
  %10 = load %class.Grid*, %class.Grid** %7, align 8, !dbg !642, !tbaa !330
  %11 = load double*, double** %8, align 8, !dbg !642, !tbaa !330
  %12 = bitcast i32* %9 to i8*, !dbg !643
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %12) #3, !dbg !643
  call void @llvm.dbg.declare(metadata i32* %9, metadata !637, metadata !DIExpression()), !dbg !644
  store i32 0, i32* %9, align 4, !dbg !644, !tbaa !325
  br label %13, !dbg !643

13:                                               ; preds = %29, %4
  %14 = load i32, i32* %9, align 4, !dbg !645, !tbaa !325
  %15 = getelementptr inbounds %class.Grid, %class.Grid* %10, i32 0, i32 2, !dbg !647
  %16 = load i32, i32* %15, align 8, !dbg !647, !tbaa !409
  %17 = icmp slt i32 %14, %16, !dbg !648
  br i1 %17, label %20, label %18, !dbg !649

18:                                               ; preds = %13
  %19 = bitcast i32* %9 to i8*, !dbg !650
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %19) #3, !dbg !650
  br label %32

20:                                               ; preds = %13
  %21 = load double, double* %11, align 8, !dbg !651, !tbaa !422
  %22 = getelementptr inbounds %class.Grid, %class.Grid* %10, i32 0, i32 3, !dbg !652
  %23 = load double*, double** %22, align 8, !dbg !652, !tbaa !415
  %24 = load i32, i32* %9, align 4, !dbg !653, !tbaa !325
  %25 = sext i32 %24 to i64, !dbg !652
  %26 = getelementptr inbounds double, double* %23, i64 %25, !dbg !652
  %27 = load double, double* %26, align 8, !dbg !654, !tbaa !422
  %28 = fadd double %27, %21, !dbg !654
  store double %28, double* %26, align 8, !dbg !654, !tbaa !422
  br label %29, !dbg !652

29:                                               ; preds = %20
  %30 = load i32, i32* %9, align 4, !dbg !655, !tbaa !325
  %31 = add nsw i32 %30, 1, !dbg !655
  store i32 %31, i32* %9, align 4, !dbg !655, !tbaa !325
  br label %13, !dbg !650, !llvm.loop !656

32:                                               ; preds = %18
  ret void, !dbg !658
}

; Function Attrs: norecurse nounwind uwtable
define internal void @.omp_outlined..12(i32* noalias, i32* noalias, %class.Grid*, double* dereferenceable(8)) #10 !dbg !659 {
  %5 = alloca i32*, align 8
  %6 = alloca i32*, align 8
  %7 = alloca %class.Grid*, align 8
  %8 = alloca double*, align 8
  store i32* %0, i32** %5, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata i32** %5, metadata !661, metadata !DIExpression()), !dbg !665
  store i32* %1, i32** %6, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata i32** %6, metadata !662, metadata !DIExpression()), !dbg !665
  store %class.Grid* %2, %class.Grid** %7, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata %class.Grid** %7, metadata !663, metadata !DIExpression()), !dbg !665
  store double* %3, double** %8, align 8, !tbaa !330
  call void @llvm.dbg.declare(metadata double** %8, metadata !664, metadata !DIExpression()), !dbg !665
  %9 = load %class.Grid*, %class.Grid** %7, align 8, !dbg !666, !tbaa !330
  %10 = load double*, double** %8, align 8, !dbg !666, !tbaa !330
  %11 = load i32*, i32** %5, align 8, !dbg !666, !tbaa !330
  %12 = load i32*, i32** %6, align 8, !dbg !666, !tbaa !330
  %13 = load %class.Grid*, %class.Grid** %7, align 8, !dbg !666, !tbaa !330
  %14 = load double*, double** %8, align 8, !dbg !666, !tbaa !330
  call void @.omp_outlined._debug__.11(i32* %11, i32* %12, %class.Grid* %13, double* %14) #3, !dbg !666
  ret void, !dbg !666
}

; Function Attrs: nobuiltin nounwind
declare dso_local void @_ZdaPv(i8*) #7

declare dso_local void @__dfsw_EXTRAP_WRITE_LABEL(i8*, i32, i8*) #11

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
attributes #10 = { norecurse nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #11 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #12 = { nounwind readonly }
attributes #13 = { builtin }
attributes #14 = { builtin nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!289, !290, !291}
!llvm.ident = !{!292}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !1, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !3, imports: !14, nameTableKind: None)
!1 = !DIFile(filename: "tests/dfsan-unit/openmp/cpp_class_openmp.cpp", directory: "/home/mcopik/projects/ETH/extrap/rebuild/perf-taint")
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
!293 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 65, type: !294, scopeLine: 66, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !296)
!294 = !DISubroutineType(types: !295)
!295 = !{!4, !4, !5}
!296 = !{!297, !298, !299, !300, !301, !302}
!297 = !DILocalVariable(name: "argc", arg: 1, scope: !293, file: !1, line: 65, type: !4)
!298 = !DILocalVariable(name: "argv", arg: 2, scope: !293, file: !1, line: 65, type: !5)
!299 = !DILocalVariable(name: "size_x", scope: !293, file: !1, line: 67, type: !4)
!300 = !DILocalVariable(name: "size_y", scope: !293, file: !1, line: 68, type: !4)
!301 = !DILocalVariable(name: "size_z", scope: !293, file: !1, line: 69, type: !4)
!302 = !DILocalVariable(name: "g", scope: !293, file: !1, line: 71, type: !303)
!303 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !304, size: 64)
!304 = distinct !DICompositeType(tag: DW_TAG_class_type, name: "Grid", file: !1, line: 8, size: 192, flags: DIFlagTypePassByReference | DIFlagNonTrivial, elements: !305, identifier: "_ZTS4Grid")
!305 = !{!306, !307, !308, !309, !311, !315, !318, !321, !322, !323, !324}
!306 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !304, file: !1, line: 10, baseType: !4, size: 32)
!307 = !DIDerivedType(tag: DW_TAG_member, name: "y", scope: !304, file: !1, line: 10, baseType: !4, size: 32, offset: 32)
!308 = !DIDerivedType(tag: DW_TAG_member, name: "z", scope: !304, file: !1, line: 10, baseType: !4, size: 32, offset: 64)
!309 = !DIDerivedType(tag: DW_TAG_member, name: "data", scope: !304, file: !1, line: 11, baseType: !310, size: 64, offset: 128)
!310 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !124, size: 64)
!311 = !DISubprogram(name: "Grid", scope: !304, file: !1, line: 13, type: !312, scopeLine: 13, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!312 = !DISubroutineType(types: !313)
!313 = !{null, !314, !4, !4, !4}
!314 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !304, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!315 = !DISubprogram(name: "~Grid", scope: !304, file: !1, line: 19, type: !316, scopeLine: 19, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!316 = !DISubroutineType(types: !317)
!317 = !{null, !314}
!318 = !DISubprogram(name: "update_grid", linkageName: "_ZN4Grid11update_gridEd", scope: !304, file: !1, line: 24, type: !319, scopeLine: 24, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!319 = !DISubroutineType(types: !320)
!320 = !{null, !314, !124}
!321 = !DISubprogram(name: "update_constant", linkageName: "_ZN4Grid15update_constantEd", scope: !304, file: !1, line: 31, type: !319, scopeLine: 31, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!322 = !DISubprogram(name: "update_data", linkageName: "_ZN4Grid11update_dataEd", scope: !304, file: !1, line: 40, type: !319, scopeLine: 40, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!323 = !DISubprogram(name: "update_y", linkageName: "_ZN4Grid8update_yEd", scope: !304, file: !1, line: 49, type: !319, scopeLine: 49, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!324 = !DISubprogram(name: "update_z", linkageName: "_ZN4Grid8update_zEd", scope: !304, file: !1, line: 57, type: !319, scopeLine: 57, flags: DIFlagPublic | DIFlagPrototyped, spFlags: DISPFlagOptimized)
!325 = !{!326, !326, i64 0}
!326 = !{!"int", !327, i64 0}
!327 = !{!"omnipotent char", !328, i64 0}
!328 = !{!"Simple C++ TBAA"}
!329 = !DILocation(line: 65, column: 14, scope: !293)
!330 = !{!331, !331, i64 0}
!331 = !{!"any pointer", !327, i64 0}
!332 = !DILocation(line: 65, column: 28, scope: !293)
!333 = !DILocation(line: 67, column: 5, scope: !293)
!334 = !DILocation(line: 67, column: 9, scope: !293)
!335 = !DILocation(line: 67, column: 30, scope: !293)
!336 = !DILocation(line: 67, column: 25, scope: !293)
!337 = !DILocation(line: 68, column: 5, scope: !293)
!338 = !DILocation(line: 68, column: 9, scope: !293)
!339 = !DILocation(line: 68, column: 30, scope: !293)
!340 = !DILocation(line: 68, column: 25, scope: !293)
!341 = !DILocation(line: 69, column: 5, scope: !293)
!342 = !DILocation(line: 69, column: 9, scope: !293)
!343 = !DILocation(line: 69, column: 30, scope: !293)
!344 = !DILocation(line: 69, column: 25, scope: !293)
!345 = !DILocation(line: 71, column: 5, scope: !293)
!346 = !DILocation(line: 71, column: 12, scope: !293)
!347 = !DILocation(line: 72, column: 5, scope: !293)
!348 = !DILocation(line: 73, column: 5, scope: !293)
!349 = !DILocation(line: 74, column: 9, scope: !293)
!350 = !DILocation(line: 74, column: 18, scope: !293)
!351 = !DILocation(line: 74, column: 26, scope: !293)
!352 = !DILocation(line: 74, column: 34, scope: !293)
!353 = !DILocation(line: 74, column: 13, scope: !293)
!354 = !DILocation(line: 74, column: 7, scope: !293)
!355 = !DILocation(line: 76, column: 5, scope: !293)
!356 = !DILocation(line: 76, column: 8, scope: !293)
!357 = !DILocation(line: 77, column: 5, scope: !293)
!358 = !DILocation(line: 77, column: 8, scope: !293)
!359 = !DILocation(line: 78, column: 5, scope: !293)
!360 = !DILocation(line: 78, column: 8, scope: !293)
!361 = !DILocation(line: 79, column: 5, scope: !293)
!362 = !DILocation(line: 79, column: 8, scope: !293)
!363 = !DILocation(line: 80, column: 5, scope: !293)
!364 = !DILocation(line: 80, column: 8, scope: !293)
!365 = !DILocation(line: 82, column: 12, scope: !293)
!366 = !DILocation(line: 82, column: 5, scope: !293)
!367 = !DILocation(line: 84, column: 1, scope: !293)
!368 = !DILocation(line: 83, column: 5, scope: !293)
!369 = !DILocation(line: 361, column: 1, scope: !128)
!370 = !DILocation(line: 363, column: 24, scope: !128)
!371 = !DILocation(line: 363, column: 16, scope: !128)
!372 = !DILocation(line: 363, column: 3, scope: !128)
!373 = distinct !DISubprogram(name: "register_variable<int>", linkageName: "_Z17register_variableIiEvPT_PKc", scope: !374, file: !374, line: 15, type: !375, scopeLine: 16, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, templateParams: !381, retainedNodes: !378)
!374 = !DIFile(filename: "include/ExtraPInstrumenter.hpp", directory: "/home/mcopik/projects/ETH/extrap/rebuild/perf-taint")
!375 = !DISubroutineType(types: !376)
!376 = !{null, !377, !125}
!377 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !4, size: 64)
!378 = !{!379, !380}
!379 = !DILocalVariable(name: "ptr", arg: 1, scope: !373, file: !374, line: 15, type: !377)
!380 = !DILocalVariable(name: "name", arg: 2, scope: !373, file: !374, line: 15, type: !125)
!381 = !{!382}
!382 = !DITemplateTypeParameter(name: "T", type: !4)
!383 = !DILocation(line: 15, column: 28, scope: !373)
!384 = !DILocation(line: 15, column: 46, scope: !373)
!385 = !DILocation(line: 20, column: 55, scope: !373)
!386 = !DILocation(line: 20, column: 29, scope: !373)
!387 = !DILocation(line: 20, column: 72, scope: !373)
!388 = !DILocation(line: 20, column: 3, scope: !373)
!389 = !DILocation(line: 21, column: 1, scope: !373)
!390 = distinct !DISubprogram(name: "Grid", linkageName: "_ZN4GridC2Eiii", scope: !304, file: !1, line: 13, type: !312, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, declaration: !311, retainedNodes: !391)
!391 = !{!392, !393, !394, !395}
!392 = !DILocalVariable(name: "this", arg: 1, scope: !390, type: !303, flags: DIFlagArtificial | DIFlagObjectPointer)
!393 = !DILocalVariable(name: "_x", arg: 2, scope: !390, file: !1, line: 13, type: !4)
!394 = !DILocalVariable(name: "_y", arg: 3, scope: !390, file: !1, line: 13, type: !4)
!395 = !DILocalVariable(name: "_z", arg: 4, scope: !390, file: !1, line: 13, type: !4)
!396 = !DILocation(line: 0, scope: !390)
!397 = !DILocation(line: 13, column: 14, scope: !390)
!398 = !DILocation(line: 13, column: 22, scope: !390)
!399 = !DILocation(line: 13, column: 30, scope: !390)
!400 = !DILocation(line: 14, column: 9, scope: !390)
!401 = !DILocation(line: 14, column: 11, scope: !390)
!402 = !{!403, !326, i64 0}
!403 = !{!"_ZTS4Grid", !326, i64 0, !326, i64 4, !326, i64 8, !331, i64 16}
!404 = !DILocation(line: 15, column: 9, scope: !390)
!405 = !DILocation(line: 15, column: 11, scope: !390)
!406 = !{!403, !326, i64 4}
!407 = !DILocation(line: 16, column: 9, scope: !390)
!408 = !DILocation(line: 16, column: 11, scope: !390)
!409 = !{!403, !326, i64 8}
!410 = !DILocation(line: 17, column: 9, scope: !390)
!411 = !DILocation(line: 17, column: 25, scope: !390)
!412 = !DILocation(line: 17, column: 27, scope: !390)
!413 = !DILocation(line: 17, column: 26, scope: !390)
!414 = !DILocation(line: 17, column: 14, scope: !390)
!415 = !{!403, !331, i64 16}
!416 = !DILocation(line: 18, column: 10, scope: !390)
!417 = distinct !DISubprogram(name: "update_grid", linkageName: "_ZN4Grid11update_gridEd", scope: !304, file: !1, line: 24, type: !319, scopeLine: 25, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, declaration: !318, retainedNodes: !418)
!418 = !{!419, !420}
!419 = !DILocalVariable(name: "this", arg: 1, scope: !417, type: !303, flags: DIFlagArtificial | DIFlagObjectPointer)
!420 = !DILocalVariable(name: "shift", arg: 2, scope: !417, file: !1, line: 24, type: !124)
!421 = !DILocation(line: 0, scope: !417)
!422 = !{!423, !423, i64 0}
!423 = !{!"double", !327, i64 0}
!424 = !DILocation(line: 24, column: 29, scope: !417)
!425 = !DILocation(line: 26, column: 9, scope: !417)
!426 = !{!427, !331, i64 16}
!427 = !{!"_ZTS7ident_t", !326, i64 0, !326, i64 4, !326, i64 8, !326, i64 12, !331, i64 16}
!428 = !DILocation(line: 29, column: 5, scope: !417)
!429 = distinct !DISubprogram(name: "update_constant", linkageName: "_ZN4Grid15update_constantEd", scope: !304, file: !1, line: 31, type: !319, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, declaration: !321, retainedNodes: !430)
!430 = !{!431, !432}
!431 = !DILocalVariable(name: "this", arg: 1, scope: !429, type: !303, flags: DIFlagArtificial | DIFlagObjectPointer)
!432 = !DILocalVariable(name: "shift", arg: 2, scope: !429, file: !1, line: 31, type: !124)
!433 = !DILocation(line: 0, scope: !429)
!434 = !DILocation(line: 31, column: 33, scope: !429)
!435 = !DILocation(line: 33, column: 22, scope: !429)
!436 = !DILocation(line: 33, column: 21, scope: !429)
!437 = !DILocation(line: 33, column: 9, scope: !429)
!438 = !DILocation(line: 33, column: 17, scope: !429)
!439 = !DILocation(line: 34, column: 9, scope: !429)
!440 = !DILocation(line: 37, column: 5, scope: !429)
!441 = distinct !DISubprogram(name: "update_y", linkageName: "_ZN4Grid8update_yEd", scope: !304, file: !1, line: 49, type: !319, scopeLine: 50, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, declaration: !323, retainedNodes: !442)
!442 = !{!443, !444}
!443 = !DILocalVariable(name: "this", arg: 1, scope: !441, type: !303, flags: DIFlagArtificial | DIFlagObjectPointer)
!444 = !DILocalVariable(name: "shift", arg: 2, scope: !441, file: !1, line: 49, type: !124)
!445 = !DILocation(line: 0, scope: !441)
!446 = !DILocation(line: 49, column: 26, scope: !441)
!447 = !DILocation(line: 51, column: 9, scope: !441)
!448 = !DILocation(line: 54, column: 5, scope: !441)
!449 = distinct !DISubprogram(name: "update_data", linkageName: "_ZN4Grid11update_dataEd", scope: !304, file: !1, line: 40, type: !319, scopeLine: 41, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, declaration: !322, retainedNodes: !450)
!450 = !{!451, !452}
!451 = !DILocalVariable(name: "this", arg: 1, scope: !449, type: !303, flags: DIFlagArtificial | DIFlagObjectPointer)
!452 = !DILocalVariable(name: "shift", arg: 2, scope: !449, file: !1, line: 40, type: !124)
!453 = !DILocation(line: 0, scope: !449)
!454 = !DILocation(line: 40, column: 29, scope: !449)
!455 = !DILocation(line: 42, column: 22, scope: !449)
!456 = !DILocation(line: 42, column: 21, scope: !449)
!457 = !DILocation(line: 42, column: 9, scope: !449)
!458 = !DILocation(line: 42, column: 17, scope: !449)
!459 = !DILocation(line: 43, column: 9, scope: !449)
!460 = !DILocation(line: 46, column: 5, scope: !449)
!461 = distinct !DISubprogram(name: "update_z", linkageName: "_ZN4Grid8update_zEd", scope: !304, file: !1, line: 57, type: !319, scopeLine: 58, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, declaration: !324, retainedNodes: !462)
!462 = !{!463, !464}
!463 = !DILocalVariable(name: "this", arg: 1, scope: !461, type: !303, flags: DIFlagArtificial | DIFlagObjectPointer)
!464 = !DILocalVariable(name: "shift", arg: 2, scope: !461, file: !1, line: 57, type: !124)
!465 = !DILocation(line: 0, scope: !461)
!466 = !DILocation(line: 57, column: 26, scope: !461)
!467 = !DILocation(line: 59, column: 9, scope: !461)
!468 = !DILocation(line: 62, column: 5, scope: !461)
!469 = distinct !DISubprogram(name: "~Grid", linkageName: "_ZN4GridD2Ev", scope: !304, file: !1, line: 19, type: !316, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, declaration: !315, retainedNodes: !470)
!470 = !{!471}
!471 = !DILocalVariable(name: "this", arg: 1, scope: !469, type: !303, flags: DIFlagArtificial | DIFlagObjectPointer)
!472 = !DILocation(line: 0, scope: !469)
!473 = !DILocation(line: 21, column: 18, scope: !474)
!474 = distinct !DILexicalBlock(scope: !469, file: !1, line: 20, column: 5)
!475 = !DILocation(line: 21, column: 9, scope: !474)
!476 = !DILocation(line: 22, column: 5, scope: !469)
!477 = distinct !DISubprogram(name: ".omp_outlined._debug__", scope: !1, file: !1, line: 27, type: !478, scopeLine: 27, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !485)
!478 = !DISubroutineType(types: !479)
!479 = !{null, !480, !480, !303, !484}
!480 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !481)
!481 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !482)
!482 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !483, size: 64)
!483 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !4)
!484 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !124, size: 64)
!485 = !{!486, !487, !488, !489, !490}
!486 = !DILocalVariable(name: ".global_tid.", arg: 1, scope: !477, type: !480, flags: DIFlagArtificial)
!487 = !DILocalVariable(name: ".bound_tid.", arg: 2, scope: !477, type: !480, flags: DIFlagArtificial)
!488 = !DILocalVariable(name: "this", arg: 3, scope: !477, file: !1, line: 27, type: !303)
!489 = !DILocalVariable(name: "shift", arg: 4, scope: !477, file: !1, line: 24, type: !484)
!490 = !DILocalVariable(name: "i", scope: !491, file: !1, line: 27, type: !4)
!491 = distinct !DILexicalBlock(scope: !477, file: !1, line: 27, column: 9)
!492 = !DILocation(line: 0, scope: !477)
!493 = !DILocation(line: 27, column: 28, scope: !477)
!494 = !DILocation(line: 24, column: 29, scope: !477)
!495 = !DILocation(line: 27, column: 9, scope: !477)
!496 = !DILocation(line: 27, column: 13, scope: !491)
!497 = !DILocation(line: 27, column: 17, scope: !491)
!498 = !DILocation(line: 27, column: 24, scope: !499)
!499 = distinct !DILexicalBlock(scope: !491, file: !1, line: 27, column: 9)
!500 = !DILocation(line: 27, column: 28, scope: !499)
!501 = !DILocation(line: 27, column: 30, scope: !499)
!502 = !DILocation(line: 27, column: 29, scope: !499)
!503 = !DILocation(line: 27, column: 26, scope: !499)
!504 = !DILocation(line: 27, column: 9, scope: !491)
!505 = !DILocation(line: 27, column: 9, scope: !499)
!506 = !DILocation(line: 28, column: 24, scope: !499)
!507 = !DILocation(line: 28, column: 13, scope: !499)
!508 = !DILocation(line: 28, column: 18, scope: !499)
!509 = !DILocation(line: 28, column: 21, scope: !499)
!510 = !DILocation(line: 27, column: 32, scope: !499)
!511 = distinct !{!511, !504, !512}
!512 = !DILocation(line: 28, column: 24, scope: !491)
!513 = !DILocation(line: 28, column: 24, scope: !477)
!514 = distinct !DISubprogram(name: ".omp_outlined.", scope: !1, file: !1, line: 27, type: !478, scopeLine: 27, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !515)
!515 = !{!516, !517, !518, !519}
!516 = !DILocalVariable(name: ".global_tid.", arg: 1, scope: !514, type: !480, flags: DIFlagArtificial)
!517 = !DILocalVariable(name: ".bound_tid.", arg: 2, scope: !514, type: !480, flags: DIFlagArtificial)
!518 = !DILocalVariable(name: "this", arg: 3, scope: !514, type: !303, flags: DIFlagArtificial)
!519 = !DILocalVariable(name: "shift", arg: 4, scope: !514, type: !484, flags: DIFlagArtificial)
!520 = !DILocation(line: 0, scope: !514)
!521 = !DILocation(line: 27, column: 9, scope: !514)
!522 = !{!523}
!523 = !{i64 2, i64 -1, i64 -1, i1 true}
!524 = distinct !DISubprogram(name: ".omp_outlined._debug__.5", scope: !1, file: !1, line: 35, type: !478, scopeLine: 35, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !525)
!525 = !{!526, !527, !528, !529, !530}
!526 = !DILocalVariable(name: ".global_tid.", arg: 1, scope: !524, type: !480, flags: DIFlagArtificial)
!527 = !DILocalVariable(name: ".bound_tid.", arg: 2, scope: !524, type: !480, flags: DIFlagArtificial)
!528 = !DILocalVariable(name: "this", arg: 3, scope: !524, file: !1, line: 36, type: !303)
!529 = !DILocalVariable(name: "shift", arg: 4, scope: !524, file: !1, line: 31, type: !484)
!530 = !DILocalVariable(name: "i", scope: !531, file: !1, line: 35, type: !4)
!531 = distinct !DILexicalBlock(scope: !524, file: !1, line: 35, column: 9)
!532 = !DILocation(line: 0, scope: !524)
!533 = !DILocation(line: 36, column: 13, scope: !524)
!534 = !DILocation(line: 31, column: 33, scope: !524)
!535 = !DILocation(line: 35, column: 9, scope: !524)
!536 = !DILocation(line: 35, column: 13, scope: !531)
!537 = !DILocation(line: 35, column: 17, scope: !531)
!538 = !DILocation(line: 35, column: 24, scope: !539)
!539 = distinct !DILexicalBlock(scope: !531, file: !1, line: 35, column: 9)
!540 = !DILocation(line: 35, column: 26, scope: !539)
!541 = !DILocation(line: 35, column: 9, scope: !531)
!542 = !DILocation(line: 35, column: 9, scope: !539)
!543 = !DILocation(line: 36, column: 24, scope: !539)
!544 = !DILocation(line: 36, column: 13, scope: !539)
!545 = !DILocation(line: 36, column: 18, scope: !539)
!546 = !DILocation(line: 36, column: 21, scope: !539)
!547 = !DILocation(line: 35, column: 30, scope: !539)
!548 = distinct !{!548, !541, !549}
!549 = !DILocation(line: 36, column: 24, scope: !531)
!550 = !DILocation(line: 36, column: 24, scope: !524)
!551 = distinct !DISubprogram(name: ".omp_outlined..6", scope: !1, file: !1, line: 35, type: !478, scopeLine: 35, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !552)
!552 = !{!553, !554, !555, !556}
!553 = !DILocalVariable(name: ".global_tid.", arg: 1, scope: !551, type: !480, flags: DIFlagArtificial)
!554 = !DILocalVariable(name: ".bound_tid.", arg: 2, scope: !551, type: !480, flags: DIFlagArtificial)
!555 = !DILocalVariable(name: "this", arg: 3, scope: !551, type: !303, flags: DIFlagArtificial)
!556 = !DILocalVariable(name: "shift", arg: 4, scope: !551, type: !484, flags: DIFlagArtificial)
!557 = !DILocation(line: 0, scope: !551)
!558 = !DILocation(line: 35, column: 9, scope: !551)
!559 = distinct !DISubprogram(name: ".omp_outlined._debug__.7", scope: !1, file: !1, line: 52, type: !478, scopeLine: 52, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !560)
!560 = !{!561, !562, !563, !564, !565}
!561 = !DILocalVariable(name: ".global_tid.", arg: 1, scope: !559, type: !480, flags: DIFlagArtificial)
!562 = !DILocalVariable(name: ".bound_tid.", arg: 2, scope: !559, type: !480, flags: DIFlagArtificial)
!563 = !DILocalVariable(name: "this", arg: 3, scope: !559, file: !1, line: 52, type: !303)
!564 = !DILocalVariable(name: "shift", arg: 4, scope: !559, file: !1, line: 49, type: !484)
!565 = !DILocalVariable(name: "i", scope: !566, file: !1, line: 52, type: !4)
!566 = distinct !DILexicalBlock(scope: !559, file: !1, line: 52, column: 9)
!567 = !DILocation(line: 0, scope: !559)
!568 = !DILocation(line: 52, column: 38, scope: !559)
!569 = !DILocation(line: 49, column: 26, scope: !559)
!570 = !DILocation(line: 52, column: 9, scope: !559)
!571 = !DILocation(line: 52, column: 13, scope: !566)
!572 = !DILocation(line: 52, column: 17, scope: !566)
!573 = !DILocation(line: 52, column: 24, scope: !574)
!574 = distinct !DILexicalBlock(scope: !566, file: !1, line: 52, column: 9)
!575 = !DILocation(line: 52, column: 26, scope: !574)
!576 = !DILocation(line: 52, column: 9, scope: !566)
!577 = !DILocation(line: 52, column: 9, scope: !574)
!578 = !DILocation(line: 53, column: 24, scope: !574)
!579 = !DILocation(line: 53, column: 13, scope: !574)
!580 = !DILocation(line: 53, column: 18, scope: !574)
!581 = !DILocation(line: 53, column: 21, scope: !574)
!582 = !DILocation(line: 52, column: 38, scope: !574)
!583 = !DILocation(line: 52, column: 35, scope: !574)
!584 = distinct !{!584, !576, !585}
!585 = !DILocation(line: 53, column: 24, scope: !566)
!586 = !DILocation(line: 53, column: 24, scope: !559)
!587 = distinct !DISubprogram(name: ".omp_outlined..8", scope: !1, file: !1, line: 52, type: !478, scopeLine: 52, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !588)
!588 = !{!589, !590, !591, !592}
!589 = !DILocalVariable(name: ".global_tid.", arg: 1, scope: !587, type: !480, flags: DIFlagArtificial)
!590 = !DILocalVariable(name: ".bound_tid.", arg: 2, scope: !587, type: !480, flags: DIFlagArtificial)
!591 = !DILocalVariable(name: "this", arg: 3, scope: !587, type: !303, flags: DIFlagArtificial)
!592 = !DILocalVariable(name: "shift", arg: 4, scope: !587, type: !484, flags: DIFlagArtificial)
!593 = !DILocation(line: 0, scope: !587)
!594 = !DILocation(line: 52, column: 9, scope: !587)
!595 = distinct !DISubprogram(name: ".omp_outlined._debug__.9", scope: !1, file: !1, line: 44, type: !478, scopeLine: 44, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !596)
!596 = !{!597, !598, !599, !600, !601}
!597 = !DILocalVariable(name: ".global_tid.", arg: 1, scope: !595, type: !480, flags: DIFlagArtificial)
!598 = !DILocalVariable(name: ".bound_tid.", arg: 2, scope: !595, type: !480, flags: DIFlagArtificial)
!599 = !DILocalVariable(name: "this", arg: 3, scope: !595, file: !1, line: 44, type: !303)
!600 = !DILocalVariable(name: "shift", arg: 4, scope: !595, file: !1, line: 40, type: !484)
!601 = !DILocalVariable(name: "i", scope: !602, file: !1, line: 44, type: !4)
!602 = distinct !DILexicalBlock(scope: !595, file: !1, line: 44, column: 9)
!603 = !DILocation(line: 0, scope: !595)
!604 = !DILocation(line: 44, column: 21, scope: !595)
!605 = !DILocation(line: 40, column: 29, scope: !595)
!606 = !DILocation(line: 44, column: 9, scope: !595)
!607 = !DILocation(line: 44, column: 13, scope: !602)
!608 = !DILocation(line: 44, column: 17, scope: !602)
!609 = !DILocation(line: 44, column: 21, scope: !602)
!610 = !DILocation(line: 44, column: 30, scope: !611)
!611 = distinct !DILexicalBlock(scope: !602, file: !1, line: 44, column: 9)
!612 = !DILocation(line: 44, column: 32, scope: !611)
!613 = !DILocation(line: 44, column: 9, scope: !602)
!614 = !DILocation(line: 44, column: 9, scope: !611)
!615 = !DILocation(line: 45, column: 24, scope: !611)
!616 = !DILocation(line: 45, column: 13, scope: !611)
!617 = !DILocation(line: 45, column: 18, scope: !611)
!618 = !DILocation(line: 45, column: 21, scope: !611)
!619 = !DILocation(line: 44, column: 36, scope: !611)
!620 = distinct !{!620, !613, !621}
!621 = !DILocation(line: 45, column: 24, scope: !602)
!622 = !DILocation(line: 45, column: 24, scope: !595)
!623 = distinct !DISubprogram(name: ".omp_outlined..10", scope: !1, file: !1, line: 44, type: !478, scopeLine: 44, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !624)
!624 = !{!625, !626, !627, !628}
!625 = !DILocalVariable(name: ".global_tid.", arg: 1, scope: !623, type: !480, flags: DIFlagArtificial)
!626 = !DILocalVariable(name: ".bound_tid.", arg: 2, scope: !623, type: !480, flags: DIFlagArtificial)
!627 = !DILocalVariable(name: "this", arg: 3, scope: !623, type: !303, flags: DIFlagArtificial)
!628 = !DILocalVariable(name: "shift", arg: 4, scope: !623, type: !484, flags: DIFlagArtificial)
!629 = !DILocation(line: 0, scope: !623)
!630 = !DILocation(line: 44, column: 9, scope: !623)
!631 = distinct !DISubprogram(name: ".omp_outlined._debug__.11", scope: !1, file: !1, line: 60, type: !478, scopeLine: 60, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !632)
!632 = !{!633, !634, !635, !636, !637}
!633 = !DILocalVariable(name: ".global_tid.", arg: 1, scope: !631, type: !480, flags: DIFlagArtificial)
!634 = !DILocalVariable(name: ".bound_tid.", arg: 2, scope: !631, type: !480, flags: DIFlagArtificial)
!635 = !DILocalVariable(name: "this", arg: 3, scope: !631, file: !1, line: 60, type: !303)
!636 = !DILocalVariable(name: "shift", arg: 4, scope: !631, file: !1, line: 57, type: !484)
!637 = !DILocalVariable(name: "i", scope: !638, file: !1, line: 60, type: !4)
!638 = distinct !DILexicalBlock(scope: !631, file: !1, line: 60, column: 9)
!639 = !DILocation(line: 0, scope: !631)
!640 = !DILocation(line: 60, column: 28, scope: !631)
!641 = !DILocation(line: 57, column: 26, scope: !631)
!642 = !DILocation(line: 60, column: 9, scope: !631)
!643 = !DILocation(line: 60, column: 13, scope: !638)
!644 = !DILocation(line: 60, column: 17, scope: !638)
!645 = !DILocation(line: 60, column: 24, scope: !646)
!646 = distinct !DILexicalBlock(scope: !638, file: !1, line: 60, column: 9)
!647 = !DILocation(line: 60, column: 28, scope: !646)
!648 = !DILocation(line: 60, column: 26, scope: !646)
!649 = !DILocation(line: 60, column: 9, scope: !638)
!650 = !DILocation(line: 60, column: 9, scope: !646)
!651 = !DILocation(line: 61, column: 24, scope: !646)
!652 = !DILocation(line: 61, column: 13, scope: !646)
!653 = !DILocation(line: 61, column: 18, scope: !646)
!654 = !DILocation(line: 61, column: 21, scope: !646)
!655 = !DILocation(line: 60, column: 30, scope: !646)
!656 = distinct !{!656, !649, !657}
!657 = !DILocation(line: 61, column: 24, scope: !638)
!658 = !DILocation(line: 61, column: 24, scope: !631)
!659 = distinct !DISubprogram(name: ".omp_outlined..12", scope: !1, file: !1, line: 60, type: !478, scopeLine: 60, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !660)
!660 = !{!661, !662, !663, !664}
!661 = !DILocalVariable(name: ".global_tid.", arg: 1, scope: !659, type: !480, flags: DIFlagArtificial)
!662 = !DILocalVariable(name: ".bound_tid.", arg: 2, scope: !659, type: !480, flags: DIFlagArtificial)
!663 = !DILocalVariable(name: "this", arg: 3, scope: !659, type: !303, flags: DIFlagArtificial)
!664 = !DILocalVariable(name: "shift", arg: 4, scope: !659, type: !484, flags: DIFlagArtificial)
!665 = !DILocation(line: 0, scope: !659)
!666 = !DILocation(line: 60, column: 9, scope: !659)
