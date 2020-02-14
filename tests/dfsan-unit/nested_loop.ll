; RUN: opt %dfsan -S < %s 2> /dev/null | llc %llcparams - -o %t1 && clang++ %link %t1 -o %t2 && %execparams %t2 10 10 10 | diff -w %s.json -
; ModuleID = 'tests/dfsan-instr/nested_loop.cpp'
source_filename = "tests/dfsan-instr/nested_loop.cpp"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

$_Z17register_variableIiEvPT_PKc = comdat any

@global = dso_local global i32 100, align 4, !dbg !0
@.str = private unnamed_addr constant [7 x i8] c"extrap\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [34 x i8] c"tests/dfsan-instr/nested_loop.cpp\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [3 x i8] c"x1\00", align 1
@.str.3 = private unnamed_addr constant [3 x i8] c"x2\00", align 1

; Function Attrs: nounwind uwtable
define dso_local i32 @_Z17perf_nest_unknownii(i32, i32) #0 !dbg !296 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store i32 %0, i32* %3, align 4, !tbaa !308
  call void @llvm.dbg.declare(metadata i32* %3, metadata !300, metadata !DIExpression()), !dbg !312
  store i32 %1, i32* %4, align 4, !tbaa !308
  call void @llvm.dbg.declare(metadata i32* %4, metadata !301, metadata !DIExpression()), !dbg !313
  %9 = bitcast i32* %5 to i8*, !dbg !314
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %9) #4, !dbg !314
  call void @llvm.dbg.declare(metadata i32* %5, metadata !302, metadata !DIExpression()), !dbg !315
  store i32 0, i32* %5, align 4, !dbg !315, !tbaa !308
  %10 = bitcast i32* %6 to i8*, !dbg !316
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %10) #4, !dbg !316
  call void @llvm.dbg.declare(metadata i32* %6, metadata !303, metadata !DIExpression()), !dbg !317
  %11 = load i32, i32* %3, align 4, !dbg !318, !tbaa !308
  store i32 %11, i32* %6, align 4, !dbg !317, !tbaa !308
  br label %12, !dbg !316

12:                                               ; preds = %34, %2
  %13 = load i32, i32* %6, align 4, !dbg !319, !tbaa !308
  %14 = load i32, i32* @global, align 4, !dbg !320, !tbaa !308
  %15 = icmp slt i32 %13, %14, !dbg !321
  br i1 %15, label %18, label %16, !dbg !322

16:                                               ; preds = %12
  store i32 2, i32* %7, align 4
  %17 = bitcast i32* %6 to i8*, !dbg !323
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %17) #4, !dbg !323
  br label %37

18:                                               ; preds = %12
  %19 = bitcast i32* %8 to i8*, !dbg !324
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %19) #4, !dbg !324
  call void @llvm.dbg.declare(metadata i32* %8, metadata !305, metadata !DIExpression()), !dbg !325
  store i32 0, i32* %8, align 4, !dbg !325, !tbaa !308
  br label %20, !dbg !324

20:                                               ; preds = %30, %18
  %21 = load i32, i32* %8, align 4, !dbg !326, !tbaa !308
  %22 = load i32, i32* %4, align 4, !dbg !328, !tbaa !308
  %23 = icmp slt i32 %21, %22, !dbg !329
  br i1 %23, label %26, label %24, !dbg !330

24:                                               ; preds = %20
  store i32 5, i32* %7, align 4
  %25 = bitcast i32* %8 to i8*, !dbg !331
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %25) #4, !dbg !331
  br label %33

26:                                               ; preds = %20
  %27 = load i32, i32* %6, align 4, !dbg !332, !tbaa !308
  %28 = load i32, i32* %5, align 4, !dbg !333, !tbaa !308
  %29 = add nsw i32 %28, %27, !dbg !333
  store i32 %29, i32* %5, align 4, !dbg !333, !tbaa !308
  br label %30, !dbg !334

30:                                               ; preds = %26
  %31 = load i32, i32* %8, align 4, !dbg !335, !tbaa !308
  %32 = add nsw i32 %31, 1, !dbg !335
  store i32 %32, i32* %8, align 4, !dbg !335, !tbaa !308
  br label %20, !dbg !331, !llvm.loop !336

33:                                               ; preds = %24
  br label %34, !dbg !337

34:                                               ; preds = %33
  %35 = load i32, i32* %6, align 4, !dbg !338, !tbaa !308
  %36 = add nsw i32 %35, 1, !dbg !338
  store i32 %36, i32* %6, align 4, !dbg !338, !tbaa !308
  br label %12, !dbg !323, !llvm.loop !339

37:                                               ; preds = %16
  %38 = load i32, i32* %5, align 4, !dbg !341, !tbaa !308
  store i32 1, i32* %7, align 4
  %39 = bitcast i32* %5 to i8*, !dbg !342
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %39) #4, !dbg !342
  ret i32 %38, !dbg !343
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: nounwind uwtable
define dso_local i32 @_Z15perf_nest_constii(i32, i32) #0 !dbg !344 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store i32 %0, i32* %3, align 4, !tbaa !308
  call void @llvm.dbg.declare(metadata i32* %3, metadata !346, metadata !DIExpression()), !dbg !354
  store i32 %1, i32* %4, align 4, !tbaa !308
  call void @llvm.dbg.declare(metadata i32* %4, metadata !347, metadata !DIExpression()), !dbg !355
  %9 = bitcast i32* %5 to i8*, !dbg !356
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %9) #4, !dbg !356
  call void @llvm.dbg.declare(metadata i32* %5, metadata !348, metadata !DIExpression()), !dbg !357
  store i32 0, i32* %5, align 4, !dbg !357, !tbaa !308
  %10 = bitcast i32* %6 to i8*, !dbg !358
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %10) #4, !dbg !358
  call void @llvm.dbg.declare(metadata i32* %6, metadata !349, metadata !DIExpression()), !dbg !359
  %11 = load i32, i32* %3, align 4, !dbg !360, !tbaa !308
  store i32 %11, i32* %6, align 4, !dbg !359, !tbaa !308
  br label %12, !dbg !358

12:                                               ; preds = %33, %2
  %13 = load i32, i32* %6, align 4, !dbg !361, !tbaa !308
  %14 = load i32, i32* @global, align 4, !dbg !362, !tbaa !308
  %15 = icmp slt i32 %13, %14, !dbg !363
  br i1 %15, label %18, label %16, !dbg !364

16:                                               ; preds = %12
  store i32 2, i32* %7, align 4
  %17 = bitcast i32* %6 to i8*, !dbg !365
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %17) #4, !dbg !365
  br label %36

18:                                               ; preds = %12
  %19 = bitcast i32* %8 to i8*, !dbg !366
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %19) #4, !dbg !366
  call void @llvm.dbg.declare(metadata i32* %8, metadata !351, metadata !DIExpression()), !dbg !367
  store i32 0, i32* %8, align 4, !dbg !367, !tbaa !308
  br label %20, !dbg !366

20:                                               ; preds = %29, %18
  %21 = load i32, i32* %8, align 4, !dbg !368, !tbaa !308
  %22 = icmp slt i32 %21, 10, !dbg !370
  br i1 %22, label %25, label %23, !dbg !371

23:                                               ; preds = %20
  store i32 5, i32* %7, align 4
  %24 = bitcast i32* %8 to i8*, !dbg !372
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %24) #4, !dbg !372
  br label %32

25:                                               ; preds = %20
  %26 = load i32, i32* %6, align 4, !dbg !373, !tbaa !308
  %27 = load i32, i32* %5, align 4, !dbg !374, !tbaa !308
  %28 = add nsw i32 %27, %26, !dbg !374
  store i32 %28, i32* %5, align 4, !dbg !374, !tbaa !308
  br label %29, !dbg !375

29:                                               ; preds = %25
  %30 = load i32, i32* %8, align 4, !dbg !376, !tbaa !308
  %31 = add nsw i32 %30, 1, !dbg !376
  store i32 %31, i32* %8, align 4, !dbg !376, !tbaa !308
  br label %20, !dbg !372, !llvm.loop !377

32:                                               ; preds = %23
  br label %33, !dbg !378

33:                                               ; preds = %32
  %34 = load i32, i32* %6, align 4, !dbg !379, !tbaa !308
  %35 = add nsw i32 %34, 1, !dbg !379
  store i32 %35, i32* %6, align 4, !dbg !379, !tbaa !308
  br label %12, !dbg !365, !llvm.loop !380

36:                                               ; preds = %16
  %37 = load i32, i32* %5, align 4, !dbg !382, !tbaa !308
  store i32 1, i32* %7, align 4
  %38 = bitcast i32* %5 to i8*, !dbg !383
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %38) #4, !dbg !383
  ret i32 %37, !dbg !384
}

; Function Attrs: nounwind uwtable
define dso_local i32 @_Z16perf_nest_linearii(i32, i32) #0 !dbg !385 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store i32 %0, i32* %3, align 4, !tbaa !308
  call void @llvm.dbg.declare(metadata i32* %3, metadata !387, metadata !DIExpression()), !dbg !395
  store i32 %1, i32* %4, align 4, !tbaa !308
  call void @llvm.dbg.declare(metadata i32* %4, metadata !388, metadata !DIExpression()), !dbg !396
  %9 = bitcast i32* %5 to i8*, !dbg !397
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %9) #4, !dbg !397
  call void @llvm.dbg.declare(metadata i32* %5, metadata !389, metadata !DIExpression()), !dbg !398
  store i32 0, i32* %5, align 4, !dbg !398, !tbaa !308
  %10 = bitcast i32* %6 to i8*, !dbg !399
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %10) #4, !dbg !399
  call void @llvm.dbg.declare(metadata i32* %6, metadata !390, metadata !DIExpression()), !dbg !400
  %11 = load i32, i32* %3, align 4, !dbg !401, !tbaa !308
  store i32 %11, i32* %6, align 4, !dbg !400, !tbaa !308
  br label %12, !dbg !399

12:                                               ; preds = %34, %2
  %13 = load i32, i32* %6, align 4, !dbg !402, !tbaa !308
  %14 = load i32, i32* @global, align 4, !dbg !403, !tbaa !308
  %15 = icmp slt i32 %13, %14, !dbg !404
  br i1 %15, label %18, label %16, !dbg !405

16:                                               ; preds = %12
  store i32 2, i32* %7, align 4
  %17 = bitcast i32* %6 to i8*, !dbg !406
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %17) #4, !dbg !406
  br label %37

18:                                               ; preds = %12
  %19 = bitcast i32* %8 to i8*, !dbg !407
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %19) #4, !dbg !407
  call void @llvm.dbg.declare(metadata i32* %8, metadata !392, metadata !DIExpression()), !dbg !408
  store i32 0, i32* %8, align 4, !dbg !408, !tbaa !308
  br label %20, !dbg !407

20:                                               ; preds = %30, %18
  %21 = load i32, i32* %8, align 4, !dbg !409, !tbaa !308
  %22 = load i32, i32* @global, align 4, !dbg !411, !tbaa !308
  %23 = icmp slt i32 %21, %22, !dbg !412
  br i1 %23, label %26, label %24, !dbg !413

24:                                               ; preds = %20
  store i32 5, i32* %7, align 4
  %25 = bitcast i32* %8 to i8*, !dbg !414
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %25) #4, !dbg !414
  br label %33

26:                                               ; preds = %20
  %27 = load i32, i32* %6, align 4, !dbg !415, !tbaa !308
  %28 = load i32, i32* %5, align 4, !dbg !416, !tbaa !308
  %29 = add nsw i32 %28, %27, !dbg !416
  store i32 %29, i32* %5, align 4, !dbg !416, !tbaa !308
  br label %30, !dbg !417

30:                                               ; preds = %26
  %31 = load i32, i32* %8, align 4, !dbg !418, !tbaa !308
  %32 = add nsw i32 %31, 1, !dbg !418
  store i32 %32, i32* %8, align 4, !dbg !418, !tbaa !308
  br label %20, !dbg !414, !llvm.loop !419

33:                                               ; preds = %24
  br label %34, !dbg !420

34:                                               ; preds = %33
  %35 = load i32, i32* %6, align 4, !dbg !421, !tbaa !308
  %36 = add nsw i32 %35, 1, !dbg !421
  store i32 %36, i32* %6, align 4, !dbg !421, !tbaa !308
  br label %12, !dbg !406, !llvm.loop !422

37:                                               ; preds = %16
  %38 = load i32, i32* %5, align 4, !dbg !424, !tbaa !308
  store i32 1, i32* %7, align 4
  %39 = bitcast i32* %5 to i8*, !dbg !425
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %39) #4, !dbg !425
  ret i32 %38, !dbg !426
}

; Function Attrs: nounwind uwtable
define dso_local i32 @_Z15perf_nest_quadrii(i32, i32) #0 !dbg !427 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store i32 %0, i32* %3, align 4, !tbaa !308
  call void @llvm.dbg.declare(metadata i32* %3, metadata !429, metadata !DIExpression()), !dbg !437
  store i32 %1, i32* %4, align 4, !tbaa !308
  call void @llvm.dbg.declare(metadata i32* %4, metadata !430, metadata !DIExpression()), !dbg !438
  %9 = bitcast i32* %5 to i8*, !dbg !439
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %9) #4, !dbg !439
  call void @llvm.dbg.declare(metadata i32* %5, metadata !431, metadata !DIExpression()), !dbg !440
  store i32 0, i32* %5, align 4, !dbg !440, !tbaa !308
  %10 = bitcast i32* %6 to i8*, !dbg !441
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %10) #4, !dbg !441
  call void @llvm.dbg.declare(metadata i32* %6, metadata !432, metadata !DIExpression()), !dbg !442
  %11 = load i32, i32* %3, align 4, !dbg !443, !tbaa !308
  store i32 %11, i32* %6, align 4, !dbg !442, !tbaa !308
  br label %12, !dbg !441

12:                                               ; preds = %34, %2
  %13 = load i32, i32* %6, align 4, !dbg !444, !tbaa !308
  %14 = load i32, i32* @global, align 4, !dbg !445, !tbaa !308
  %15 = icmp slt i32 %13, %14, !dbg !446
  br i1 %15, label %18, label %16, !dbg !447

16:                                               ; preds = %12
  store i32 2, i32* %7, align 4
  %17 = bitcast i32* %6 to i8*, !dbg !448
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %17) #4, !dbg !448
  br label %37

18:                                               ; preds = %12
  %19 = bitcast i32* %8 to i8*, !dbg !449
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %19) #4, !dbg !449
  call void @llvm.dbg.declare(metadata i32* %8, metadata !434, metadata !DIExpression()), !dbg !450
  store i32 0, i32* %8, align 4, !dbg !450, !tbaa !308
  br label %20, !dbg !449

20:                                               ; preds = %30, %18
  %21 = load i32, i32* %8, align 4, !dbg !451, !tbaa !308
  %22 = load i32, i32* %4, align 4, !dbg !453, !tbaa !308
  %23 = icmp slt i32 %21, %22, !dbg !454
  br i1 %23, label %26, label %24, !dbg !455

24:                                               ; preds = %20
  store i32 5, i32* %7, align 4
  %25 = bitcast i32* %8 to i8*, !dbg !456
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %25) #4, !dbg !456
  br label %33

26:                                               ; preds = %20
  %27 = load i32, i32* %6, align 4, !dbg !457, !tbaa !308
  %28 = load i32, i32* %5, align 4, !dbg !458, !tbaa !308
  %29 = add nsw i32 %28, %27, !dbg !458
  store i32 %29, i32* %5, align 4, !dbg !458, !tbaa !308
  br label %30, !dbg !459

30:                                               ; preds = %26
  %31 = load i32, i32* %8, align 4, !dbg !460, !tbaa !308
  %32 = add nsw i32 %31, 1, !dbg !460
  store i32 %32, i32* %8, align 4, !dbg !460, !tbaa !308
  br label %20, !dbg !456, !llvm.loop !461

33:                                               ; preds = %24
  br label %34, !dbg !462

34:                                               ; preds = %33
  %35 = load i32, i32* %6, align 4, !dbg !463, !tbaa !308
  %36 = add nsw i32 %35, 1, !dbg !463
  store i32 %36, i32* %6, align 4, !dbg !463, !tbaa !308
  br label %12, !dbg !448, !llvm.loop !464

37:                                               ; preds = %16
  %38 = load i32, i32* %5, align 4, !dbg !466, !tbaa !308
  store i32 1, i32* %7, align 4
  %39 = bitcast i32* %5 to i8*, !dbg !467
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %39) #4, !dbg !467
  ret i32 %38, !dbg !468
}

; Function Attrs: nounwind uwtable
define dso_local i32 @_Z24perf_nest_multiple_quadrii(i32, i32) #0 !dbg !469 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store i32 %0, i32* %3, align 4, !tbaa !308
  call void @llvm.dbg.declare(metadata i32* %3, metadata !471, metadata !DIExpression()), !dbg !479
  store i32 %1, i32* %4, align 4, !tbaa !308
  call void @llvm.dbg.declare(metadata i32* %4, metadata !472, metadata !DIExpression()), !dbg !480
  %9 = bitcast i32* %5 to i8*, !dbg !481
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %9) #4, !dbg !481
  call void @llvm.dbg.declare(metadata i32* %5, metadata !473, metadata !DIExpression()), !dbg !482
  store i32 0, i32* %5, align 4, !dbg !482, !tbaa !308
  %10 = bitcast i32* %6 to i8*, !dbg !483
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %10) #4, !dbg !483
  call void @llvm.dbg.declare(metadata i32* %6, metadata !474, metadata !DIExpression()), !dbg !484
  %11 = load i32, i32* %3, align 4, !dbg !485, !tbaa !308
  store i32 %11, i32* %6, align 4, !dbg !484, !tbaa !308
  br label %12, !dbg !483

12:                                               ; preds = %34, %2
  %13 = load i32, i32* %6, align 4, !dbg !486, !tbaa !308
  %14 = load i32, i32* @global, align 4, !dbg !487, !tbaa !308
  %15 = icmp slt i32 %13, %14, !dbg !488
  br i1 %15, label %18, label %16, !dbg !489

16:                                               ; preds = %12
  store i32 2, i32* %7, align 4
  %17 = bitcast i32* %6 to i8*, !dbg !490
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %17) #4, !dbg !490
  br label %38

18:                                               ; preds = %12
  %19 = bitcast i32* %8 to i8*, !dbg !491
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %19) #4, !dbg !491
  call void @llvm.dbg.declare(metadata i32* %8, metadata !476, metadata !DIExpression()), !dbg !492
  store i32 0, i32* %8, align 4, !dbg !492, !tbaa !308
  br label %20, !dbg !491

20:                                               ; preds = %30, %18
  %21 = load i32, i32* %8, align 4, !dbg !493, !tbaa !308
  %22 = load i32, i32* %4, align 4, !dbg !495, !tbaa !308
  %23 = icmp slt i32 %21, %22, !dbg !496
  br i1 %23, label %26, label %24, !dbg !497

24:                                               ; preds = %20
  store i32 5, i32* %7, align 4
  %25 = bitcast i32* %8 to i8*, !dbg !498
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %25) #4, !dbg !498
  br label %33

26:                                               ; preds = %20
  %27 = load i32, i32* %6, align 4, !dbg !499, !tbaa !308
  %28 = load i32, i32* %5, align 4, !dbg !500, !tbaa !308
  %29 = add nsw i32 %28, %27, !dbg !500
  store i32 %29, i32* %5, align 4, !dbg !500, !tbaa !308
  br label %30, !dbg !501

30:                                               ; preds = %26
  %31 = load i32, i32* %8, align 4, !dbg !502, !tbaa !308
  %32 = add nsw i32 %31, 1, !dbg !502
  store i32 %32, i32* %8, align 4, !dbg !502, !tbaa !308
  br label %20, !dbg !498, !llvm.loop !503

33:                                               ; preds = %24
  br label %34, !dbg !504

34:                                               ; preds = %33
  %35 = load i32, i32* %4, align 4, !dbg !505, !tbaa !308
  %36 = load i32, i32* %6, align 4, !dbg !506, !tbaa !308
  %37 = add nsw i32 %36, %35, !dbg !506
  store i32 %37, i32* %6, align 4, !dbg !506, !tbaa !308
  br label %12, !dbg !490, !llvm.loop !507

38:                                               ; preds = %16
  %39 = load i32, i32* %5, align 4, !dbg !509, !tbaa !308
  store i32 1, i32* %7, align 4
  %40 = bitcast i32* %5 to i8*, !dbg !510
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %40) #4, !dbg !510
  ret i32 %39, !dbg !511
}

; Function Attrs: norecurse uwtable
define dso_local i32 @main(i32, i8**) #3 !dbg !512 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4, !tbaa !308
  call void @llvm.dbg.declare(metadata i32* %4, metadata !516, metadata !DIExpression()), !dbg !521
  store i8** %1, i8*** %5, align 8, !tbaa !522
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !517, metadata !DIExpression()), !dbg !524
  %9 = bitcast i32* %6 to i8*, !dbg !525
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %9) #4, !dbg !525
  call void @llvm.dbg.declare(metadata i32* %6, metadata !518, metadata !DIExpression()), !dbg !526
  %10 = bitcast i32* %6 to i8*, !dbg !525
  call void @llvm.var.annotation(i8* %10, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.1, i32 0, i32 0), i32 60), !dbg !525
  %11 = load i8**, i8*** %5, align 8, !dbg !527, !tbaa !522
  %12 = getelementptr inbounds i8*, i8** %11, i64 1, !dbg !527
  %13 = load i8*, i8** %12, align 8, !dbg !527, !tbaa !522
  %14 = call i32 @atoi(i8* %13) #9, !dbg !528
  store i32 %14, i32* %6, align 4, !dbg !526, !tbaa !308
  %15 = bitcast i32* %7 to i8*, !dbg !529
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %15) #4, !dbg !529
  call void @llvm.dbg.declare(metadata i32* %7, metadata !519, metadata !DIExpression()), !dbg !530
  %16 = bitcast i32* %7 to i8*, !dbg !529
  call void @llvm.var.annotation(i8* %16, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.1, i32 0, i32 0), i32 61), !dbg !529
  %17 = load i8**, i8*** %5, align 8, !dbg !531, !tbaa !522
  %18 = getelementptr inbounds i8*, i8** %17, i64 2, !dbg !531
  %19 = load i8*, i8** %18, align 8, !dbg !531, !tbaa !522
  %20 = call i32 @atoi(i8* %19) #9, !dbg !532
  store i32 %20, i32* %7, align 4, !dbg !530, !tbaa !308
  %21 = bitcast i32* %8 to i8*, !dbg !533
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %21) #4, !dbg !533
  call void @llvm.dbg.declare(metadata i32* %8, metadata !520, metadata !DIExpression()), !dbg !534
  %22 = load i8**, i8*** %5, align 8, !dbg !535, !tbaa !522
  %23 = getelementptr inbounds i8*, i8** %22, i64 3, !dbg !535
  %24 = load i8*, i8** %23, align 8, !dbg !535, !tbaa !522
  %25 = call i32 @atoi(i8* %24) #9, !dbg !536
  store i32 %25, i32* %8, align 4, !dbg !534, !tbaa !308
  call void @_Z17register_variableIiEvPT_PKc(i32* %6, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.2, i64 0, i64 0)), !dbg !537
  call void @_Z17register_variableIiEvPT_PKc(i32* %7, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.3, i64 0, i64 0)), !dbg !538
  %26 = load i32, i32* @global, align 4, !dbg !539, !tbaa !308
  %27 = call i32 @_Z17perf_nest_unknownii(i32 %26, i32 10), !dbg !540
  %28 = load i32, i32* %8, align 4, !dbg !541, !tbaa !308
  %29 = call i32 @_Z17perf_nest_unknownii(i32 10, i32 %28), !dbg !542
  %30 = load i32, i32* %6, align 4, !dbg !543, !tbaa !308
  %31 = load i32, i32* %7, align 4, !dbg !544, !tbaa !308
  %32 = call i32 @_Z15perf_nest_constii(i32 %30, i32 %31), !dbg !545
  %33 = load i32, i32* %6, align 4, !dbg !546, !tbaa !308
  %34 = load i32, i32* %7, align 4, !dbg !547, !tbaa !308
  %35 = call i32 @_Z15perf_nest_constii(i32 %33, i32 %34), !dbg !548
  %36 = load i32, i32* %6, align 4, !dbg !549, !tbaa !308
  %37 = load i32, i32* %7, align 4, !dbg !550, !tbaa !308
  %38 = call i32 @_Z16perf_nest_linearii(i32 %36, i32 %37), !dbg !551
  %39 = load i32, i32* %7, align 4, !dbg !552, !tbaa !308
  %40 = load i32, i32* %7, align 4, !dbg !553, !tbaa !308
  %41 = call i32 @_Z16perf_nest_linearii(i32 %39, i32 %40), !dbg !554
  %42 = load i32, i32* %6, align 4, !dbg !555, !tbaa !308
  %43 = load i32, i32* %7, align 4, !dbg !556, !tbaa !308
  %44 = call i32 @_Z15perf_nest_quadrii(i32 %42, i32 %43), !dbg !557
  %45 = load i32, i32* %7, align 4, !dbg !558, !tbaa !308
  %46 = load i32, i32* %6, align 4, !dbg !559, !tbaa !308
  %47 = call i32 @_Z15perf_nest_quadrii(i32 %45, i32 %46), !dbg !560
  %48 = load i32, i32* %6, align 4, !dbg !561, !tbaa !308
  %49 = load i32, i32* %7, align 4, !dbg !562, !tbaa !308
  %50 = call i32 @_Z24perf_nest_multiple_quadrii(i32 %48, i32 %49), !dbg !563
  %51 = bitcast i32* %8 to i8*, !dbg !564
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %51) #4, !dbg !564
  %52 = bitcast i32* %7 to i8*, !dbg !564
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %52) #4, !dbg !564
  %53 = bitcast i32* %6 to i8*, !dbg !564
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %53) #4, !dbg !564
  ret i32 0, !dbg !565
}

; Function Attrs: nounwind
declare void @llvm.var.annotation(i8*, i8*, i8*, i32) #4

; Function Attrs: inlinehint nounwind readonly uwtable
define available_externally dso_local i32 @atoi(i8* nonnull) #5 !dbg !60 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8, !tbaa !522
  call void @llvm.dbg.declare(metadata i8** %2, metadata !64, metadata !DIExpression()), !dbg !566
  %3 = load i8*, i8** %2, align 8, !dbg !567, !tbaa !522
  %4 = call i64 @strtol(i8* %3, i8** null, i32 10) #4, !dbg !568
  %5 = trunc i64 %4 to i32, !dbg !568
  ret i32 %5, !dbg !569
}

; Function Attrs: uwtable
define linkonce_odr dso_local void @_Z17register_variableIiEvPT_PKc(i32*, i8*) #6 comdat !dbg !570 {
  %3 = alloca i32*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca i32, align 4
  store i32* %0, i32** %3, align 8, !tbaa !522
  call void @llvm.dbg.declare(metadata i32** %3, metadata !576, metadata !DIExpression()), !dbg !581
  store i8* %1, i8** %4, align 8, !tbaa !522
  call void @llvm.dbg.declare(metadata i8** %4, metadata !577, metadata !DIExpression()), !dbg !582
  %6 = bitcast i32* %5 to i8*, !dbg !583
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %6) #4, !dbg !583
  call void @llvm.dbg.declare(metadata i32* %5, metadata !578, metadata !DIExpression()), !dbg !584
  %7 = call i32 @__dfsw_EXTRAP_VAR_ID(), !dbg !585
  store i32 %7, i32* %5, align 4, !dbg !584, !tbaa !308
  %8 = load i32*, i32** %3, align 8, !dbg !586, !tbaa !522
  %9 = bitcast i32* %8 to i8*, !dbg !587
  %10 = load i32, i32* %5, align 4, !dbg !588, !tbaa !308
  %11 = add nsw i32 %10, 1, !dbg !588
  store i32 %11, i32* %5, align 4, !dbg !588, !tbaa !308
  %12 = load i8*, i8** %4, align 8, !dbg !589, !tbaa !522
  call void @__dfsw_EXTRAP_STORE_LABEL(i8* %9, i32 4, i32 %10, i8* %12), !dbg !590
  %13 = bitcast i32* %5 to i8*, !dbg !591
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %13) #4, !dbg !591
  ret void, !dbg !591
}

; Function Attrs: nounwind
declare dso_local i64 @strtol(i8*, i8**, i32) #7

declare dso_local i32 @__dfsw_EXTRAP_VAR_ID() #8

declare dso_local void @__dfsw_EXTRAP_STORE_LABEL(i8*, i32, i32, i8*) #8

attributes #0 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { argmemonly nounwind }
attributes #3 = { norecurse uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind }
attributes #5 = { inlinehint nounwind readonly uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #6 = { uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #7 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #8 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #9 = { nounwind readonly }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!292, !293, !294}
!llvm.ident = !{!295}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "global", scope: !2, file: !3, line: 6, type: !6, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !3, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !5, globals: !16, imports: !17, nameTableKind: None)
!3 = !DIFile(filename: "tests/dfsan-instr/nested_loop.cpp", directory: "/home/mcopik/projects/ETH/extrap/rebuild/extrap-tool")
!4 = !{}
!5 = !{!6, !7, !10}
!6 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!7 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !8, size: 64)
!8 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !9, size: 64)
!9 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!10 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !11, size: 64)
!11 = !DIDerivedType(tag: DW_TAG_typedef, name: "int8_t", file: !12, line: 24, baseType: !13)
!12 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-intn.h", directory: "")
!13 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int8_t", file: !14, line: 36, baseType: !15)
!14 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "")
!15 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!16 = !{!0}
!17 = !{!18, !25, !28, !32, !34, !38, !44, !51, !59, !65, !69, !73, !79, !84, !89, !93, !97, !101, !106, !110, !115, !120, !124, !128, !132, !136, !141, !145, !147, !151, !153, !164, !168, !173, !177, !181, !185, !189, !191, !195, !202, !206, !210, !218, !220, !222, !224, !228, !231, !234, !239, !243, !246, !249, !252, !254, !256, !258, !260, !262, !264, !266, !268, !270, !272, !274, !276, !278, !280, !282, !284, !286, !289}
!18 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !21, file: !24, line: 49)
!19 = !DINamespace(name: "__1", scope: !20, exportSymbols: true)
!20 = !DINamespace(name: "std", scope: null)
!21 = !DIDerivedType(tag: DW_TAG_typedef, name: "ptrdiff_t", file: !22, line: 35, baseType: !23)
!22 = !DIFile(filename: "clang_llvm/llvm-9.0/build-9.0/lib/clang/9.0.0/include/stddef.h", directory: "/home/mcopik/projects")
!23 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!24 = !DIFile(filename: "build_tool/../usr/include/c++/v1/cstddef", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!25 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !26, file: !24, line: 50)
!26 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !22, line: 46, baseType: !27)
!27 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!28 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !29, file: !24, line: 55)
!29 = !DIDerivedType(tag: DW_TAG_typedef, name: "max_align_t", file: !30, line: 24, baseType: !31)
!30 = !DIFile(filename: "clang_llvm/llvm-9.0/build-9.0/lib/clang/9.0.0/include/__stddef_max_align_t.h", directory: "/home/mcopik/projects")
!31 = !DICompositeType(tag: DW_TAG_structure_type, file: !30, line: 19, flags: DIFlagFwdDecl, identifier: "_ZTS11max_align_t")
!32 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !26, file: !33, line: 99)
!33 = !DIFile(filename: "build_tool/../usr/include/c++/v1/cstdlib", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!34 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !35, file: !33, line: 100)
!35 = !DIDerivedType(tag: DW_TAG_typedef, name: "div_t", file: !36, line: 62, baseType: !37)
!36 = !DIFile(filename: "/usr/include/stdlib.h", directory: "")
!37 = !DICompositeType(tag: DW_TAG_structure_type, file: !36, line: 58, flags: DIFlagFwdDecl, identifier: "_ZTS5div_t")
!38 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !39, file: !33, line: 101)
!39 = !DIDerivedType(tag: DW_TAG_typedef, name: "ldiv_t", file: !36, line: 70, baseType: !40)
!40 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !36, line: 66, size: 128, flags: DIFlagTypePassByValue, elements: !41, identifier: "_ZTS6ldiv_t")
!41 = !{!42, !43}
!42 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !40, file: !36, line: 68, baseType: !23, size: 64)
!43 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !40, file: !36, line: 69, baseType: !23, size: 64, offset: 64)
!44 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !45, file: !33, line: 103)
!45 = !DIDerivedType(tag: DW_TAG_typedef, name: "lldiv_t", file: !36, line: 80, baseType: !46)
!46 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !36, line: 76, size: 128, flags: DIFlagTypePassByValue, elements: !47, identifier: "_ZTS7lldiv_t")
!47 = !{!48, !50}
!48 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !46, file: !36, line: 78, baseType: !49, size: 64)
!49 = !DIBasicType(name: "long long int", size: 64, encoding: DW_ATE_signed)
!50 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !46, file: !36, line: 79, baseType: !49, size: 64, offset: 64)
!51 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !52, file: !33, line: 105)
!52 = !DISubprogram(name: "atof", scope: !53, file: !53, line: 25, type: !54, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!53 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdlib-float.h", directory: "")
!54 = !DISubroutineType(types: !55)
!55 = !{!56, !57}
!56 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!57 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !58, size: 64)
!58 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !9)
!59 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !60, file: !33, line: 106)
!60 = distinct !DISubprogram(name: "atoi", scope: !36, file: !36, line: 361, type: !61, scopeLine: 362, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !63)
!61 = !DISubroutineType(types: !62)
!62 = !{!6, !57}
!63 = !{!64}
!64 = !DILocalVariable(name: "__nptr", arg: 1, scope: !60, file: !36, line: 361, type: !57)
!65 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !66, file: !33, line: 107)
!66 = !DISubprogram(name: "atol", scope: !36, file: !36, line: 366, type: !67, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!67 = !DISubroutineType(types: !68)
!68 = !{!23, !57}
!69 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !70, file: !33, line: 109)
!70 = !DISubprogram(name: "atoll", scope: !36, file: !36, line: 373, type: !71, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!71 = !DISubroutineType(types: !72)
!72 = !{!49, !57}
!73 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !74, file: !33, line: 111)
!74 = !DISubprogram(name: "strtod", scope: !36, file: !36, line: 117, type: !75, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!75 = !DISubroutineType(types: !76)
!76 = !{!56, !77, !78}
!77 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !57)
!78 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !7)
!79 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !80, file: !33, line: 112)
!80 = !DISubprogram(name: "strtof", scope: !36, file: !36, line: 123, type: !81, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!81 = !DISubroutineType(types: !82)
!82 = !{!83, !77, !78}
!83 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!84 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !85, file: !33, line: 113)
!85 = !DISubprogram(name: "strtold", scope: !36, file: !36, line: 126, type: !86, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!86 = !DISubroutineType(types: !87)
!87 = !{!88, !77, !78}
!88 = !DIBasicType(name: "long double", size: 128, encoding: DW_ATE_float)
!89 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !90, file: !33, line: 114)
!90 = !DISubprogram(name: "strtol", scope: !36, file: !36, line: 176, type: !91, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!91 = !DISubroutineType(types: !92)
!92 = !{!23, !77, !78, !6}
!93 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !94, file: !33, line: 116)
!94 = !DISubprogram(name: "strtoll", scope: !36, file: !36, line: 200, type: !95, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!95 = !DISubroutineType(types: !96)
!96 = !{!49, !77, !78, !6}
!97 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !98, file: !33, line: 118)
!98 = !DISubprogram(name: "strtoul", scope: !36, file: !36, line: 180, type: !99, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!99 = !DISubroutineType(types: !100)
!100 = !{!27, !77, !78, !6}
!101 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !102, file: !33, line: 120)
!102 = !DISubprogram(name: "strtoull", scope: !36, file: !36, line: 205, type: !103, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!103 = !DISubroutineType(types: !104)
!104 = !{!105, !77, !78, !6}
!105 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!106 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !107, file: !33, line: 122)
!107 = !DISubprogram(name: "rand", scope: !36, file: !36, line: 453, type: !108, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!108 = !DISubroutineType(types: !109)
!109 = !{!6}
!110 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !111, file: !33, line: 123)
!111 = !DISubprogram(name: "srand", scope: !36, file: !36, line: 455, type: !112, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!112 = !DISubroutineType(types: !113)
!113 = !{null, !114}
!114 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!115 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !116, file: !33, line: 124)
!116 = !DISubprogram(name: "calloc", scope: !36, file: !36, line: 541, type: !117, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!117 = !DISubroutineType(types: !118)
!118 = !{!119, !26, !26}
!119 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!120 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !121, file: !33, line: 125)
!121 = !DISubprogram(name: "free", scope: !36, file: !36, line: 563, type: !122, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!122 = !DISubroutineType(types: !123)
!123 = !{null, !119}
!124 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !125, file: !33, line: 126)
!125 = !DISubprogram(name: "malloc", scope: !36, file: !36, line: 539, type: !126, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!126 = !DISubroutineType(types: !127)
!127 = !{!119, !26}
!128 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !129, file: !33, line: 127)
!129 = !DISubprogram(name: "realloc", scope: !36, file: !36, line: 549, type: !130, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!130 = !DISubroutineType(types: !131)
!131 = !{!119, !119, !26}
!132 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !133, file: !33, line: 128)
!133 = !DISubprogram(name: "abort", scope: !36, file: !36, line: 588, type: !134, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!134 = !DISubroutineType(types: !135)
!135 = !{null}
!136 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !137, file: !33, line: 129)
!137 = !DISubprogram(name: "atexit", scope: !36, file: !36, line: 592, type: !138, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!138 = !DISubroutineType(types: !139)
!139 = !{!6, !140}
!140 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !134, size: 64)
!141 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !142, file: !33, line: 130)
!142 = !DISubprogram(name: "exit", scope: !36, file: !36, line: 614, type: !143, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!143 = !DISubroutineType(types: !144)
!144 = !{null, !6}
!145 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !146, file: !33, line: 131)
!146 = !DISubprogram(name: "_Exit", scope: !36, file: !36, line: 626, type: !143, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!147 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !148, file: !33, line: 133)
!148 = !DISubprogram(name: "getenv", scope: !36, file: !36, line: 631, type: !149, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!149 = !DISubroutineType(types: !150)
!150 = !{!8, !57}
!151 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !152, file: !33, line: 134)
!152 = !DISubprogram(name: "system", scope: !36, file: !36, line: 781, type: !61, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!153 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !154, file: !33, line: 136)
!154 = !DISubprogram(name: "bsearch", scope: !155, file: !155, line: 20, type: !156, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!155 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdlib-bsearch.h", directory: "")
!156 = !DISubroutineType(types: !157)
!157 = !{!119, !158, !158, !26, !26, !160}
!158 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !159, size: 64)
!159 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!160 = !DIDerivedType(tag: DW_TAG_typedef, name: "__compar_fn_t", file: !36, line: 805, baseType: !161)
!161 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !162, size: 64)
!162 = !DISubroutineType(types: !163)
!163 = !{!6, !158, !158}
!164 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !165, file: !33, line: 137)
!165 = !DISubprogram(name: "qsort", scope: !36, file: !36, line: 827, type: !166, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!166 = !DISubroutineType(types: !167)
!167 = !{null, !119, !26, !26, !160}
!168 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !169, file: !33, line: 138)
!169 = !DISubprogram(name: "abs", linkageName: "_Z3abse", scope: !170, file: !170, line: 789, type: !171, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!170 = !DIFile(filename: "build_tool/../usr/include/c++/v1/math.h", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!171 = !DISubroutineType(types: !172)
!172 = !{!88, !88}
!173 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !174, file: !33, line: 139)
!174 = !DISubprogram(name: "labs", scope: !36, file: !36, line: 838, type: !175, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!175 = !DISubroutineType(types: !176)
!176 = !{!23, !23}
!177 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !178, file: !33, line: 141)
!178 = !DISubprogram(name: "llabs", scope: !36, file: !36, line: 841, type: !179, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!179 = !DISubroutineType(types: !180)
!180 = !{!49, !49}
!181 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !182, file: !33, line: 143)
!182 = !DISubprogram(name: "div", linkageName: "_Z3divxx", scope: !170, file: !170, line: 808, type: !183, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!183 = !DISubroutineType(types: !184)
!184 = !{!45, !49, !49}
!185 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !186, file: !33, line: 144)
!186 = !DISubprogram(name: "ldiv", scope: !36, file: !36, line: 851, type: !187, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!187 = !DISubroutineType(types: !188)
!188 = !{!39, !23, !23}
!189 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !190, file: !33, line: 146)
!190 = !DISubprogram(name: "lldiv", scope: !36, file: !36, line: 855, type: !183, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!191 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !192, file: !33, line: 148)
!192 = !DISubprogram(name: "mblen", scope: !36, file: !36, line: 919, type: !193, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!193 = !DISubroutineType(types: !194)
!194 = !{!6, !57, !26}
!195 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !196, file: !33, line: 149)
!196 = !DISubprogram(name: "mbtowc", scope: !36, file: !36, line: 922, type: !197, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!197 = !DISubroutineType(types: !198)
!198 = !{!6, !199, !77, !26}
!199 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !200)
!200 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !201, size: 64)
!201 = !DIBasicType(name: "wchar_t", size: 32, encoding: DW_ATE_signed)
!202 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !203, file: !33, line: 150)
!203 = !DISubprogram(name: "wctomb", scope: !36, file: !36, line: 926, type: !204, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!204 = !DISubroutineType(types: !205)
!205 = !{!6, !8, !201}
!206 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !207, file: !33, line: 151)
!207 = !DISubprogram(name: "mbstowcs", scope: !36, file: !36, line: 930, type: !208, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!208 = !DISubroutineType(types: !209)
!209 = !{!26, !199, !77, !26}
!210 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !211, file: !33, line: 152)
!211 = !DISubprogram(name: "wcstombs", scope: !36, file: !36, line: 933, type: !212, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!212 = !DISubroutineType(types: !213)
!213 = !{!26, !214, !215, !26}
!214 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !8)
!215 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !216)
!216 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !217, size: 64)
!217 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !201)
!218 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !219, file: !33, line: 154)
!219 = !DISubprogram(name: "at_quick_exit", scope: !36, file: !36, line: 597, type: !138, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!220 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !221, file: !33, line: 155)
!221 = !DISubprogram(name: "quick_exit", scope: !36, file: !36, line: 620, type: !143, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!222 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !11, file: !223, line: 152)
!223 = !DIFile(filename: "build_tool/../usr/include/c++/v1/cstdint", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!224 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !225, file: !223, line: 153)
!225 = !DIDerivedType(tag: DW_TAG_typedef, name: "int16_t", file: !12, line: 25, baseType: !226)
!226 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int16_t", file: !14, line: 38, baseType: !227)
!227 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!228 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !229, file: !223, line: 154)
!229 = !DIDerivedType(tag: DW_TAG_typedef, name: "int32_t", file: !12, line: 26, baseType: !230)
!230 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int32_t", file: !14, line: 40, baseType: !6)
!231 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !232, file: !223, line: 155)
!232 = !DIDerivedType(tag: DW_TAG_typedef, name: "int64_t", file: !12, line: 27, baseType: !233)
!233 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int64_t", file: !14, line: 43, baseType: !23)
!234 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !235, file: !223, line: 157)
!235 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint8_t", file: !236, line: 24, baseType: !237)
!236 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "")
!237 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint8_t", file: !14, line: 37, baseType: !238)
!238 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!239 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !240, file: !223, line: 158)
!240 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint16_t", file: !236, line: 25, baseType: !241)
!241 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint16_t", file: !14, line: 39, baseType: !242)
!242 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!243 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !244, file: !223, line: 159)
!244 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !236, line: 26, baseType: !245)
!245 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !14, line: 41, baseType: !114)
!246 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !247, file: !223, line: 160)
!247 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", file: !236, line: 27, baseType: !248)
!248 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint64_t", file: !14, line: 44, baseType: !27)
!249 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !250, file: !223, line: 162)
!250 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least8_t", file: !251, line: 43, baseType: !15)
!251 = !DIFile(filename: "/usr/include/stdint.h", directory: "")
!252 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !253, file: !223, line: 163)
!253 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least16_t", file: !251, line: 44, baseType: !227)
!254 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !255, file: !223, line: 164)
!255 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least32_t", file: !251, line: 45, baseType: !6)
!256 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !257, file: !223, line: 165)
!257 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least64_t", file: !251, line: 47, baseType: !23)
!258 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !259, file: !223, line: 167)
!259 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least8_t", file: !251, line: 54, baseType: !238)
!260 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !261, file: !223, line: 168)
!261 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least16_t", file: !251, line: 55, baseType: !242)
!262 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !263, file: !223, line: 169)
!263 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least32_t", file: !251, line: 56, baseType: !114)
!264 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !265, file: !223, line: 170)
!265 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least64_t", file: !251, line: 58, baseType: !27)
!266 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !267, file: !223, line: 172)
!267 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast8_t", file: !251, line: 68, baseType: !15)
!268 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !269, file: !223, line: 173)
!269 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast16_t", file: !251, line: 70, baseType: !23)
!270 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !271, file: !223, line: 174)
!271 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast32_t", file: !251, line: 71, baseType: !23)
!272 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !273, file: !223, line: 175)
!273 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast64_t", file: !251, line: 72, baseType: !23)
!274 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !275, file: !223, line: 177)
!275 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast8_t", file: !251, line: 81, baseType: !238)
!276 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !277, file: !223, line: 178)
!277 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast16_t", file: !251, line: 83, baseType: !27)
!278 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !279, file: !223, line: 179)
!279 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast32_t", file: !251, line: 84, baseType: !27)
!280 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !281, file: !223, line: 180)
!281 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast64_t", file: !251, line: 85, baseType: !27)
!282 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !283, file: !223, line: 182)
!283 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !251, line: 97, baseType: !23)
!284 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !285, file: !223, line: 183)
!285 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !251, line: 100, baseType: !27)
!286 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !287, file: !223, line: 185)
!287 = !DIDerivedType(tag: DW_TAG_typedef, name: "intmax_t", file: !251, line: 111, baseType: !288)
!288 = !DIDerivedType(tag: DW_TAG_typedef, name: "__intmax_t", file: !14, line: 61, baseType: !23)
!289 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !290, file: !223, line: 186)
!290 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintmax_t", file: !251, line: 112, baseType: !291)
!291 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uintmax_t", file: !14, line: 62, baseType: !27)
!292 = !{i32 2, !"Dwarf Version", i32 4}
!293 = !{i32 2, !"Debug Info Version", i32 3}
!294 = !{i32 1, !"wchar_size", i32 4}
!295 = !{!"clang version 9.0.0 (tags/RELEASE_900/final)"}
!296 = distinct !DISubprogram(name: "perf_nest_unknown", linkageName: "_Z17perf_nest_unknownii", scope: !3, file: !3, line: 8, type: !297, scopeLine: 9, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !299)
!297 = !DISubroutineType(types: !298)
!298 = !{!6, !6, !6}
!299 = !{!300, !301, !302, !303, !305}
!300 = !DILocalVariable(name: "x", arg: 1, scope: !296, file: !3, line: 8, type: !6)
!301 = !DILocalVariable(name: "y", arg: 2, scope: !296, file: !3, line: 8, type: !6)
!302 = !DILocalVariable(name: "tmp", scope: !296, file: !3, line: 10, type: !6)
!303 = !DILocalVariable(name: "i", scope: !304, file: !3, line: 11, type: !6)
!304 = distinct !DILexicalBlock(scope: !296, file: !3, line: 11, column: 5)
!305 = !DILocalVariable(name: "j", scope: !306, file: !3, line: 12, type: !6)
!306 = distinct !DILexicalBlock(scope: !307, file: !3, line: 12, column: 9)
!307 = distinct !DILexicalBlock(scope: !304, file: !3, line: 11, column: 5)
!308 = !{!309, !309, i64 0}
!309 = !{!"int", !310, i64 0}
!310 = !{!"omnipotent char", !311, i64 0}
!311 = !{!"Simple C++ TBAA"}
!312 = !DILocation(line: 8, column: 27, scope: !296)
!313 = !DILocation(line: 8, column: 34, scope: !296)
!314 = !DILocation(line: 10, column: 5, scope: !296)
!315 = !DILocation(line: 10, column: 9, scope: !296)
!316 = !DILocation(line: 11, column: 9, scope: !304)
!317 = !DILocation(line: 11, column: 13, scope: !304)
!318 = !DILocation(line: 11, column: 17, scope: !304)
!319 = !DILocation(line: 11, column: 20, scope: !307)
!320 = !DILocation(line: 11, column: 24, scope: !307)
!321 = !DILocation(line: 11, column: 22, scope: !307)
!322 = !DILocation(line: 11, column: 5, scope: !304)
!323 = !DILocation(line: 11, column: 5, scope: !307)
!324 = !DILocation(line: 12, column: 13, scope: !306)
!325 = !DILocation(line: 12, column: 17, scope: !306)
!326 = !DILocation(line: 12, column: 24, scope: !327)
!327 = distinct !DILexicalBlock(scope: !306, file: !3, line: 12, column: 9)
!328 = !DILocation(line: 12, column: 28, scope: !327)
!329 = !DILocation(line: 12, column: 26, scope: !327)
!330 = !DILocation(line: 12, column: 9, scope: !306)
!331 = !DILocation(line: 12, column: 9, scope: !327)
!332 = !DILocation(line: 13, column: 20, scope: !327)
!333 = !DILocation(line: 13, column: 17, scope: !327)
!334 = !DILocation(line: 13, column: 13, scope: !327)
!335 = !DILocation(line: 12, column: 31, scope: !327)
!336 = distinct !{!336, !330, !337}
!337 = !DILocation(line: 13, column: 20, scope: !306)
!338 = !DILocation(line: 11, column: 32, scope: !307)
!339 = distinct !{!339, !322, !340}
!340 = !DILocation(line: 13, column: 20, scope: !304)
!341 = !DILocation(line: 14, column: 12, scope: !296)
!342 = !DILocation(line: 15, column: 1, scope: !296)
!343 = !DILocation(line: 14, column: 5, scope: !296)
!344 = distinct !DISubprogram(name: "perf_nest_const", linkageName: "_Z15perf_nest_constii", scope: !3, file: !3, line: 18, type: !297, scopeLine: 19, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !345)
!345 = !{!346, !347, !348, !349, !351}
!346 = !DILocalVariable(name: "x", arg: 1, scope: !344, file: !3, line: 18, type: !6)
!347 = !DILocalVariable(name: "y", arg: 2, scope: !344, file: !3, line: 18, type: !6)
!348 = !DILocalVariable(name: "tmp", scope: !344, file: !3, line: 20, type: !6)
!349 = !DILocalVariable(name: "i", scope: !350, file: !3, line: 21, type: !6)
!350 = distinct !DILexicalBlock(scope: !344, file: !3, line: 21, column: 5)
!351 = !DILocalVariable(name: "j", scope: !352, file: !3, line: 22, type: !6)
!352 = distinct !DILexicalBlock(scope: !353, file: !3, line: 22, column: 9)
!353 = distinct !DILexicalBlock(scope: !350, file: !3, line: 21, column: 5)
!354 = !DILocation(line: 18, column: 25, scope: !344)
!355 = !DILocation(line: 18, column: 32, scope: !344)
!356 = !DILocation(line: 20, column: 5, scope: !344)
!357 = !DILocation(line: 20, column: 9, scope: !344)
!358 = !DILocation(line: 21, column: 9, scope: !350)
!359 = !DILocation(line: 21, column: 13, scope: !350)
!360 = !DILocation(line: 21, column: 17, scope: !350)
!361 = !DILocation(line: 21, column: 20, scope: !353)
!362 = !DILocation(line: 21, column: 24, scope: !353)
!363 = !DILocation(line: 21, column: 22, scope: !353)
!364 = !DILocation(line: 21, column: 5, scope: !350)
!365 = !DILocation(line: 21, column: 5, scope: !353)
!366 = !DILocation(line: 22, column: 13, scope: !352)
!367 = !DILocation(line: 22, column: 17, scope: !352)
!368 = !DILocation(line: 22, column: 24, scope: !369)
!369 = distinct !DILexicalBlock(scope: !352, file: !3, line: 22, column: 9)
!370 = !DILocation(line: 22, column: 26, scope: !369)
!371 = !DILocation(line: 22, column: 9, scope: !352)
!372 = !DILocation(line: 22, column: 9, scope: !369)
!373 = !DILocation(line: 23, column: 20, scope: !369)
!374 = !DILocation(line: 23, column: 17, scope: !369)
!375 = !DILocation(line: 23, column: 13, scope: !369)
!376 = !DILocation(line: 22, column: 32, scope: !369)
!377 = distinct !{!377, !371, !378}
!378 = !DILocation(line: 23, column: 20, scope: !352)
!379 = !DILocation(line: 21, column: 32, scope: !353)
!380 = distinct !{!380, !364, !381}
!381 = !DILocation(line: 23, column: 20, scope: !350)
!382 = !DILocation(line: 24, column: 12, scope: !344)
!383 = !DILocation(line: 25, column: 1, scope: !344)
!384 = !DILocation(line: 24, column: 5, scope: !344)
!385 = distinct !DISubprogram(name: "perf_nest_linear", linkageName: "_Z16perf_nest_linearii", scope: !3, file: !3, line: 28, type: !297, scopeLine: 29, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !386)
!386 = !{!387, !388, !389, !390, !392}
!387 = !DILocalVariable(name: "x", arg: 1, scope: !385, file: !3, line: 28, type: !6)
!388 = !DILocalVariable(name: "y", arg: 2, scope: !385, file: !3, line: 28, type: !6)
!389 = !DILocalVariable(name: "tmp", scope: !385, file: !3, line: 30, type: !6)
!390 = !DILocalVariable(name: "i", scope: !391, file: !3, line: 31, type: !6)
!391 = distinct !DILexicalBlock(scope: !385, file: !3, line: 31, column: 5)
!392 = !DILocalVariable(name: "j", scope: !393, file: !3, line: 32, type: !6)
!393 = distinct !DILexicalBlock(scope: !394, file: !3, line: 32, column: 9)
!394 = distinct !DILexicalBlock(scope: !391, file: !3, line: 31, column: 5)
!395 = !DILocation(line: 28, column: 26, scope: !385)
!396 = !DILocation(line: 28, column: 33, scope: !385)
!397 = !DILocation(line: 30, column: 5, scope: !385)
!398 = !DILocation(line: 30, column: 9, scope: !385)
!399 = !DILocation(line: 31, column: 9, scope: !391)
!400 = !DILocation(line: 31, column: 13, scope: !391)
!401 = !DILocation(line: 31, column: 17, scope: !391)
!402 = !DILocation(line: 31, column: 20, scope: !394)
!403 = !DILocation(line: 31, column: 24, scope: !394)
!404 = !DILocation(line: 31, column: 22, scope: !394)
!405 = !DILocation(line: 31, column: 5, scope: !391)
!406 = !DILocation(line: 31, column: 5, scope: !394)
!407 = !DILocation(line: 32, column: 13, scope: !393)
!408 = !DILocation(line: 32, column: 17, scope: !393)
!409 = !DILocation(line: 32, column: 24, scope: !410)
!410 = distinct !DILexicalBlock(scope: !393, file: !3, line: 32, column: 9)
!411 = !DILocation(line: 32, column: 28, scope: !410)
!412 = !DILocation(line: 32, column: 26, scope: !410)
!413 = !DILocation(line: 32, column: 9, scope: !393)
!414 = !DILocation(line: 32, column: 9, scope: !410)
!415 = !DILocation(line: 33, column: 20, scope: !410)
!416 = !DILocation(line: 33, column: 17, scope: !410)
!417 = !DILocation(line: 33, column: 13, scope: !410)
!418 = !DILocation(line: 32, column: 36, scope: !410)
!419 = distinct !{!419, !413, !420}
!420 = !DILocation(line: 33, column: 20, scope: !393)
!421 = !DILocation(line: 31, column: 32, scope: !394)
!422 = distinct !{!422, !405, !423}
!423 = !DILocation(line: 33, column: 20, scope: !391)
!424 = !DILocation(line: 34, column: 12, scope: !385)
!425 = !DILocation(line: 35, column: 1, scope: !385)
!426 = !DILocation(line: 34, column: 5, scope: !385)
!427 = distinct !DISubprogram(name: "perf_nest_quadr", linkageName: "_Z15perf_nest_quadrii", scope: !3, file: !3, line: 38, type: !297, scopeLine: 39, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !428)
!428 = !{!429, !430, !431, !432, !434}
!429 = !DILocalVariable(name: "x", arg: 1, scope: !427, file: !3, line: 38, type: !6)
!430 = !DILocalVariable(name: "y", arg: 2, scope: !427, file: !3, line: 38, type: !6)
!431 = !DILocalVariable(name: "tmp", scope: !427, file: !3, line: 40, type: !6)
!432 = !DILocalVariable(name: "i", scope: !433, file: !3, line: 41, type: !6)
!433 = distinct !DILexicalBlock(scope: !427, file: !3, line: 41, column: 5)
!434 = !DILocalVariable(name: "j", scope: !435, file: !3, line: 42, type: !6)
!435 = distinct !DILexicalBlock(scope: !436, file: !3, line: 42, column: 9)
!436 = distinct !DILexicalBlock(scope: !433, file: !3, line: 41, column: 5)
!437 = !DILocation(line: 38, column: 25, scope: !427)
!438 = !DILocation(line: 38, column: 32, scope: !427)
!439 = !DILocation(line: 40, column: 5, scope: !427)
!440 = !DILocation(line: 40, column: 9, scope: !427)
!441 = !DILocation(line: 41, column: 9, scope: !433)
!442 = !DILocation(line: 41, column: 13, scope: !433)
!443 = !DILocation(line: 41, column: 17, scope: !433)
!444 = !DILocation(line: 41, column: 20, scope: !436)
!445 = !DILocation(line: 41, column: 24, scope: !436)
!446 = !DILocation(line: 41, column: 22, scope: !436)
!447 = !DILocation(line: 41, column: 5, scope: !433)
!448 = !DILocation(line: 41, column: 5, scope: !436)
!449 = !DILocation(line: 42, column: 13, scope: !435)
!450 = !DILocation(line: 42, column: 17, scope: !435)
!451 = !DILocation(line: 42, column: 24, scope: !452)
!452 = distinct !DILexicalBlock(scope: !435, file: !3, line: 42, column: 9)
!453 = !DILocation(line: 42, column: 28, scope: !452)
!454 = !DILocation(line: 42, column: 26, scope: !452)
!455 = !DILocation(line: 42, column: 9, scope: !435)
!456 = !DILocation(line: 42, column: 9, scope: !452)
!457 = !DILocation(line: 43, column: 20, scope: !452)
!458 = !DILocation(line: 43, column: 17, scope: !452)
!459 = !DILocation(line: 43, column: 13, scope: !452)
!460 = !DILocation(line: 42, column: 31, scope: !452)
!461 = distinct !{!461, !455, !462}
!462 = !DILocation(line: 43, column: 20, scope: !435)
!463 = !DILocation(line: 41, column: 32, scope: !436)
!464 = distinct !{!464, !447, !465}
!465 = !DILocation(line: 43, column: 20, scope: !433)
!466 = !DILocation(line: 44, column: 12, scope: !427)
!467 = !DILocation(line: 45, column: 1, scope: !427)
!468 = !DILocation(line: 44, column: 5, scope: !427)
!469 = distinct !DISubprogram(name: "perf_nest_multiple_quadr", linkageName: "_Z24perf_nest_multiple_quadrii", scope: !3, file: !3, line: 49, type: !297, scopeLine: 50, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !470)
!470 = !{!471, !472, !473, !474, !476}
!471 = !DILocalVariable(name: "x", arg: 1, scope: !469, file: !3, line: 49, type: !6)
!472 = !DILocalVariable(name: "y", arg: 2, scope: !469, file: !3, line: 49, type: !6)
!473 = !DILocalVariable(name: "tmp", scope: !469, file: !3, line: 51, type: !6)
!474 = !DILocalVariable(name: "i", scope: !475, file: !3, line: 52, type: !6)
!475 = distinct !DILexicalBlock(scope: !469, file: !3, line: 52, column: 5)
!476 = !DILocalVariable(name: "j", scope: !477, file: !3, line: 53, type: !6)
!477 = distinct !DILexicalBlock(scope: !478, file: !3, line: 53, column: 9)
!478 = distinct !DILexicalBlock(scope: !475, file: !3, line: 52, column: 5)
!479 = !DILocation(line: 49, column: 34, scope: !469)
!480 = !DILocation(line: 49, column: 41, scope: !469)
!481 = !DILocation(line: 51, column: 5, scope: !469)
!482 = !DILocation(line: 51, column: 9, scope: !469)
!483 = !DILocation(line: 52, column: 9, scope: !475)
!484 = !DILocation(line: 52, column: 13, scope: !475)
!485 = !DILocation(line: 52, column: 17, scope: !475)
!486 = !DILocation(line: 52, column: 20, scope: !478)
!487 = !DILocation(line: 52, column: 24, scope: !478)
!488 = !DILocation(line: 52, column: 22, scope: !478)
!489 = !DILocation(line: 52, column: 5, scope: !475)
!490 = !DILocation(line: 52, column: 5, scope: !478)
!491 = !DILocation(line: 53, column: 13, scope: !477)
!492 = !DILocation(line: 53, column: 17, scope: !477)
!493 = !DILocation(line: 53, column: 24, scope: !494)
!494 = distinct !DILexicalBlock(scope: !477, file: !3, line: 53, column: 9)
!495 = !DILocation(line: 53, column: 28, scope: !494)
!496 = !DILocation(line: 53, column: 26, scope: !494)
!497 = !DILocation(line: 53, column: 9, scope: !477)
!498 = !DILocation(line: 53, column: 9, scope: !494)
!499 = !DILocation(line: 54, column: 20, scope: !494)
!500 = !DILocation(line: 54, column: 17, scope: !494)
!501 = !DILocation(line: 54, column: 13, scope: !494)
!502 = !DILocation(line: 53, column: 31, scope: !494)
!503 = distinct !{!503, !497, !504}
!504 = !DILocation(line: 54, column: 20, scope: !477)
!505 = !DILocation(line: 52, column: 37, scope: !478)
!506 = !DILocation(line: 52, column: 34, scope: !478)
!507 = distinct !{!507, !489, !508}
!508 = !DILocation(line: 54, column: 20, scope: !475)
!509 = !DILocation(line: 55, column: 12, scope: !469)
!510 = !DILocation(line: 56, column: 1, scope: !469)
!511 = !DILocation(line: 55, column: 5, scope: !469)
!512 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 58, type: !513, scopeLine: 59, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !515)
!513 = !DISubroutineType(types: !514)
!514 = !{!6, !6, !7}
!515 = !{!516, !517, !518, !519, !520}
!516 = !DILocalVariable(name: "argc", arg: 1, scope: !512, file: !3, line: 58, type: !6)
!517 = !DILocalVariable(name: "argv", arg: 2, scope: !512, file: !3, line: 58, type: !7)
!518 = !DILocalVariable(name: "x1", scope: !512, file: !3, line: 60, type: !6)
!519 = !DILocalVariable(name: "x2", scope: !512, file: !3, line: 61, type: !6)
!520 = !DILocalVariable(name: "x3", scope: !512, file: !3, line: 62, type: !6)
!521 = !DILocation(line: 58, column: 14, scope: !512)
!522 = !{!523, !523, i64 0}
!523 = !{!"any pointer", !310, i64 0}
!524 = !DILocation(line: 58, column: 28, scope: !512)
!525 = !DILocation(line: 60, column: 5, scope: !512)
!526 = !DILocation(line: 60, column: 9, scope: !512)
!527 = !DILocation(line: 60, column: 26, scope: !512)
!528 = !DILocation(line: 60, column: 21, scope: !512)
!529 = !DILocation(line: 61, column: 5, scope: !512)
!530 = !DILocation(line: 61, column: 9, scope: !512)
!531 = !DILocation(line: 61, column: 26, scope: !512)
!532 = !DILocation(line: 61, column: 21, scope: !512)
!533 = !DILocation(line: 62, column: 5, scope: !512)
!534 = !DILocation(line: 62, column: 9, scope: !512)
!535 = !DILocation(line: 62, column: 19, scope: !512)
!536 = !DILocation(line: 62, column: 14, scope: !512)
!537 = !DILocation(line: 63, column: 5, scope: !512)
!538 = !DILocation(line: 64, column: 5, scope: !512)
!539 = !DILocation(line: 67, column: 23, scope: !512)
!540 = !DILocation(line: 67, column: 5, scope: !512)
!541 = !DILocation(line: 68, column: 27, scope: !512)
!542 = !DILocation(line: 68, column: 5, scope: !512)
!543 = !DILocation(line: 70, column: 21, scope: !512)
!544 = !DILocation(line: 70, column: 25, scope: !512)
!545 = !DILocation(line: 70, column: 5, scope: !512)
!546 = !DILocation(line: 71, column: 21, scope: !512)
!547 = !DILocation(line: 71, column: 25, scope: !512)
!548 = !DILocation(line: 71, column: 5, scope: !512)
!549 = !DILocation(line: 73, column: 22, scope: !512)
!550 = !DILocation(line: 73, column: 26, scope: !512)
!551 = !DILocation(line: 73, column: 5, scope: !512)
!552 = !DILocation(line: 74, column: 22, scope: !512)
!553 = !DILocation(line: 74, column: 26, scope: !512)
!554 = !DILocation(line: 74, column: 5, scope: !512)
!555 = !DILocation(line: 76, column: 21, scope: !512)
!556 = !DILocation(line: 76, column: 25, scope: !512)
!557 = !DILocation(line: 76, column: 5, scope: !512)
!558 = !DILocation(line: 77, column: 21, scope: !512)
!559 = !DILocation(line: 77, column: 25, scope: !512)
!560 = !DILocation(line: 77, column: 5, scope: !512)
!561 = !DILocation(line: 78, column: 30, scope: !512)
!562 = !DILocation(line: 78, column: 34, scope: !512)
!563 = !DILocation(line: 78, column: 5, scope: !512)
!564 = !DILocation(line: 81, column: 1, scope: !512)
!565 = !DILocation(line: 80, column: 5, scope: !512)
!566 = !DILocation(line: 361, column: 1, scope: !60)
!567 = !DILocation(line: 363, column: 24, scope: !60)
!568 = !DILocation(line: 363, column: 16, scope: !60)
!569 = !DILocation(line: 363, column: 3, scope: !60)
!570 = distinct !DISubprogram(name: "register_variable<int>", linkageName: "_Z17register_variableIiEvPT_PKc", scope: !571, file: !571, line: 14, type: !572, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, templateParams: !579, retainedNodes: !575)
!571 = !DIFile(filename: "include/ExtraPInstrumenter.hpp", directory: "/home/mcopik/projects/ETH/extrap/rebuild/extrap-tool")
!572 = !DISubroutineType(types: !573)
!573 = !{null, !574, !57}
!574 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !6, size: 64)
!575 = !{!576, !577, !578}
!576 = !DILocalVariable(name: "ptr", arg: 1, scope: !570, file: !571, line: 14, type: !574)
!577 = !DILocalVariable(name: "name", arg: 2, scope: !570, file: !571, line: 14, type: !57)
!578 = !DILocalVariable(name: "param_id", scope: !570, file: !571, line: 16, type: !229)
!579 = !{!580}
!580 = !DITemplateTypeParameter(name: "T", type: !6)
!581 = !DILocation(line: 14, column: 28, scope: !570)
!582 = !DILocation(line: 14, column: 46, scope: !570)
!583 = !DILocation(line: 16, column: 5, scope: !570)
!584 = !DILocation(line: 16, column: 13, scope: !570)
!585 = !DILocation(line: 16, column: 24, scope: !570)
!586 = !DILocation(line: 17, column: 57, scope: !570)
!587 = !DILocation(line: 17, column: 31, scope: !570)
!588 = !DILocation(line: 18, column: 21, scope: !570)
!589 = !DILocation(line: 18, column: 25, scope: !570)
!590 = !DILocation(line: 17, column: 5, scope: !570)
!591 = !DILocation(line: 19, column: 1, scope: !570)
