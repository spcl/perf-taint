; RUN: opt %dfsan -S < %s 2> /dev/null | llc %llcparams - -o %t1 && clang++ %link %t1 -o %t2 && %execparams %t2 10 10 10 | diff -w %s.json -
; ModuleID = 'tests/dfsan-instr/nested_function_call.cpp'
source_filename = "tests/dfsan-instr/nested_function_call.cpp"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

$_Z17register_variableIiEvPT_PKc = comdat any

@global = dso_local global i32 12, align 4, !dbg !0
@.str = private unnamed_addr constant [7 x i8] c"extrap\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [43 x i8] c"tests/dfsan-instr/nested_function_call.cpp\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [3 x i8] c"x1\00", align 1
@.str.3 = private unnamed_addr constant [3 x i8] c"x2\00", align 1

; Function Attrs: nounwind uwtable
define dso_local i32 @_Z1fi(i32) #0 !dbg !296 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, i32* %2, align 4, !tbaa !304
  call void @llvm.dbg.declare(metadata i32* %2, metadata !300, metadata !DIExpression()), !dbg !308
  %5 = bitcast i32* %3 to i8*, !dbg !309
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %5) #4, !dbg !309
  call void @llvm.dbg.declare(metadata i32* %3, metadata !301, metadata !DIExpression()), !dbg !310
  store i32 0, i32* %3, align 4, !dbg !310, !tbaa !304
  %6 = bitcast i32* %4 to i8*, !dbg !311
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %6) #4, !dbg !311
  call void @llvm.dbg.declare(metadata i32* %4, metadata !302, metadata !DIExpression()), !dbg !312
  store i32 0, i32* %4, align 4, !dbg !312, !tbaa !304
  br label %7, !dbg !311

7:                                                ; preds = %17, %1
  %8 = load i32, i32* %4, align 4, !dbg !313, !tbaa !304
  %9 = load i32, i32* %2, align 4, !dbg !315, !tbaa !304
  %10 = icmp slt i32 %8, %9, !dbg !316
  br i1 %10, label %13, label %11, !dbg !317

11:                                               ; preds = %7
  %12 = bitcast i32* %4 to i8*, !dbg !318
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %12) #4, !dbg !318
  br label %20

13:                                               ; preds = %7
  %14 = load i32, i32* %4, align 4, !dbg !319, !tbaa !304
  %15 = load i32, i32* %3, align 4, !dbg !320, !tbaa !304
  %16 = add nsw i32 %15, %14, !dbg !320
  store i32 %16, i32* %3, align 4, !dbg !320, !tbaa !304
  br label %17, !dbg !321

17:                                               ; preds = %13
  %18 = load i32, i32* %4, align 4, !dbg !322, !tbaa !304
  %19 = add nsw i32 %18, 1, !dbg !322
  store i32 %19, i32* %4, align 4, !dbg !322, !tbaa !304
  br label %7, !dbg !318, !llvm.loop !323

20:                                               ; preds = %11
  %21 = load i32, i32* %3, align 4, !dbg !325, !tbaa !304
  %22 = bitcast i32* %3 to i8*, !dbg !326
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %22) #4, !dbg !326
  ret i32 %21, !dbg !327
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: nounwind uwtable
define dso_local i32 @_Z1gi(i32) #0 !dbg !328 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, i32* %2, align 4, !tbaa !304
  call void @llvm.dbg.declare(metadata i32* %2, metadata !330, metadata !DIExpression()), !dbg !334
  %5 = bitcast i32* %3 to i8*, !dbg !335
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %5) #4, !dbg !335
  call void @llvm.dbg.declare(metadata i32* %3, metadata !331, metadata !DIExpression()), !dbg !336
  store i32 0, i32* %3, align 4, !dbg !336, !tbaa !304
  %6 = bitcast i32* %4 to i8*, !dbg !337
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %6) #4, !dbg !337
  call void @llvm.dbg.declare(metadata i32* %4, metadata !332, metadata !DIExpression()), !dbg !338
  store i32 0, i32* %4, align 4, !dbg !338, !tbaa !304
  br label %7, !dbg !337

7:                                                ; preds = %18, %1
  %8 = load i32, i32* %4, align 4, !dbg !339, !tbaa !304
  %9 = load i32, i32* %2, align 4, !dbg !341, !tbaa !304
  %10 = icmp slt i32 %8, %9, !dbg !342
  br i1 %10, label %13, label %11, !dbg !343

11:                                               ; preds = %7
  %12 = bitcast i32* %4 to i8*, !dbg !344
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %12) #4, !dbg !344
  br label %21

13:                                               ; preds = %7
  %14 = load i32, i32* %2, align 4, !dbg !345, !tbaa !304
  %15 = call i32 @_Z1fi(i32 %14), !dbg !346
  %16 = load i32, i32* %3, align 4, !dbg !347, !tbaa !304
  %17 = add nsw i32 %16, %15, !dbg !347
  store i32 %17, i32* %3, align 4, !dbg !347, !tbaa !304
  br label %18, !dbg !348

18:                                               ; preds = %13
  %19 = load i32, i32* %4, align 4, !dbg !349, !tbaa !304
  %20 = add nsw i32 %19, 1, !dbg !349
  store i32 %20, i32* %4, align 4, !dbg !349, !tbaa !304
  br label %7, !dbg !344, !llvm.loop !350

21:                                               ; preds = %11
  %22 = load i32, i32* %3, align 4, !dbg !352, !tbaa !304
  %23 = bitcast i32* %3 to i8*, !dbg !353
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %23) #4, !dbg !353
  ret i32 %22, !dbg !354
}

; Function Attrs: nounwind uwtable
define dso_local i32 @_Z11single_nestii(i32, i32) #0 !dbg !355 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store i32 %0, i32* %3, align 4, !tbaa !304
  call void @llvm.dbg.declare(metadata i32* %3, metadata !359, metadata !DIExpression()), !dbg !367
  store i32 %1, i32* %4, align 4, !tbaa !304
  call void @llvm.dbg.declare(metadata i32* %4, metadata !360, metadata !DIExpression()), !dbg !368
  %9 = bitcast i32* %5 to i8*, !dbg !369
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %9) #4, !dbg !369
  call void @llvm.dbg.declare(metadata i32* %5, metadata !361, metadata !DIExpression()), !dbg !370
  store i32 0, i32* %5, align 4, !dbg !370, !tbaa !304
  %10 = bitcast i32* %6 to i8*, !dbg !371
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %10) #4, !dbg !371
  call void @llvm.dbg.declare(metadata i32* %6, metadata !362, metadata !DIExpression()), !dbg !372
  %11 = load i32, i32* %3, align 4, !dbg !373, !tbaa !304
  store i32 %11, i32* %6, align 4, !dbg !372, !tbaa !304
  br label %12, !dbg !371

12:                                               ; preds = %35, %2
  %13 = load i32, i32* %6, align 4, !dbg !374, !tbaa !304
  %14 = load i32, i32* @global, align 4, !dbg !375, !tbaa !304
  %15 = icmp slt i32 %13, %14, !dbg !376
  br i1 %15, label %18, label %16, !dbg !377

16:                                               ; preds = %12
  store i32 2, i32* %7, align 4
  %17 = bitcast i32* %6 to i8*, !dbg !378
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %17) #4, !dbg !378
  br label %38

18:                                               ; preds = %12
  %19 = bitcast i32* %8 to i8*, !dbg !379
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %19) #4, !dbg !379
  call void @llvm.dbg.declare(metadata i32* %8, metadata !364, metadata !DIExpression()), !dbg !380
  store i32 0, i32* %8, align 4, !dbg !380, !tbaa !304
  br label %20, !dbg !379

20:                                               ; preds = %31, %18
  %21 = load i32, i32* %8, align 4, !dbg !381, !tbaa !304
  %22 = load i32, i32* %4, align 4, !dbg !383, !tbaa !304
  %23 = icmp slt i32 %21, %22, !dbg !384
  br i1 %23, label %26, label %24, !dbg !385

24:                                               ; preds = %20
  store i32 5, i32* %7, align 4
  %25 = bitcast i32* %8 to i8*, !dbg !386
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %25) #4, !dbg !386
  br label %34

26:                                               ; preds = %20
  %27 = load i32, i32* %6, align 4, !dbg !387, !tbaa !304
  %28 = call i32 @_Z1fi(i32 %27), !dbg !388
  %29 = load i32, i32* %5, align 4, !dbg !389, !tbaa !304
  %30 = add nsw i32 %29, %28, !dbg !389
  store i32 %30, i32* %5, align 4, !dbg !389, !tbaa !304
  br label %31, !dbg !390

31:                                               ; preds = %26
  %32 = load i32, i32* %8, align 4, !dbg !391, !tbaa !304
  %33 = add nsw i32 %32, 1, !dbg !391
  store i32 %33, i32* %8, align 4, !dbg !391, !tbaa !304
  br label %20, !dbg !386, !llvm.loop !392

34:                                               ; preds = %24
  br label %35, !dbg !393

35:                                               ; preds = %34
  %36 = load i32, i32* %6, align 4, !dbg !394, !tbaa !304
  %37 = add nsw i32 %36, 1, !dbg !394
  store i32 %37, i32* %6, align 4, !dbg !394, !tbaa !304
  br label %12, !dbg !378, !llvm.loop !395

38:                                               ; preds = %16
  %39 = load i32, i32* %5, align 4, !dbg !397, !tbaa !304
  store i32 1, i32* %7, align 4
  %40 = bitcast i32* %5 to i8*, !dbg !398
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %40) #4, !dbg !398
  ret i32 %39, !dbg !399
}

; Function Attrs: nounwind uwtable
define dso_local i32 @_Z11double_nestii(i32, i32) #0 !dbg !400 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store i32 %0, i32* %3, align 4, !tbaa !304
  call void @llvm.dbg.declare(metadata i32* %3, metadata !402, metadata !DIExpression()), !dbg !410
  store i32 %1, i32* %4, align 4, !tbaa !304
  call void @llvm.dbg.declare(metadata i32* %4, metadata !403, metadata !DIExpression()), !dbg !411
  %9 = bitcast i32* %5 to i8*, !dbg !412
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %9) #4, !dbg !412
  call void @llvm.dbg.declare(metadata i32* %5, metadata !404, metadata !DIExpression()), !dbg !413
  store i32 0, i32* %5, align 4, !dbg !413, !tbaa !304
  %10 = bitcast i32* %6 to i8*, !dbg !414
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %10) #4, !dbg !414
  call void @llvm.dbg.declare(metadata i32* %6, metadata !405, metadata !DIExpression()), !dbg !415
  %11 = load i32, i32* %3, align 4, !dbg !416, !tbaa !304
  store i32 %11, i32* %6, align 4, !dbg !415, !tbaa !304
  br label %12, !dbg !414

12:                                               ; preds = %36, %2
  %13 = load i32, i32* %6, align 4, !dbg !417, !tbaa !304
  %14 = load i32, i32* @global, align 4, !dbg !418, !tbaa !304
  %15 = icmp slt i32 %13, %14, !dbg !419
  br i1 %15, label %18, label %16, !dbg !420

16:                                               ; preds = %12
  store i32 2, i32* %7, align 4
  %17 = bitcast i32* %6 to i8*, !dbg !421
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %17) #4, !dbg !421
  br label %39

18:                                               ; preds = %12
  %19 = bitcast i32* %8 to i8*, !dbg !422
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %19) #4, !dbg !422
  call void @llvm.dbg.declare(metadata i32* %8, metadata !407, metadata !DIExpression()), !dbg !423
  %20 = load i32, i32* %4, align 4, !dbg !424, !tbaa !304
  store i32 %20, i32* %8, align 4, !dbg !423, !tbaa !304
  br label %21, !dbg !422

21:                                               ; preds = %32, %18
  %22 = load i32, i32* %8, align 4, !dbg !425, !tbaa !304
  %23 = load i32, i32* @global, align 4, !dbg !427, !tbaa !304
  %24 = icmp slt i32 %22, %23, !dbg !428
  br i1 %24, label %27, label %25, !dbg !429

25:                                               ; preds = %21
  store i32 5, i32* %7, align 4
  %26 = bitcast i32* %8 to i8*, !dbg !430
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %26) #4, !dbg !430
  br label %35

27:                                               ; preds = %21
  %28 = load i32, i32* %8, align 4, !dbg !431, !tbaa !304
  %29 = call i32 @_Z1gi(i32 %28), !dbg !432
  %30 = load i32, i32* %5, align 4, !dbg !433, !tbaa !304
  %31 = add nsw i32 %30, %29, !dbg !433
  store i32 %31, i32* %5, align 4, !dbg !433, !tbaa !304
  br label %32, !dbg !434

32:                                               ; preds = %27
  %33 = load i32, i32* %8, align 4, !dbg !435, !tbaa !304
  %34 = add nsw i32 %33, 1, !dbg !435
  store i32 %34, i32* %8, align 4, !dbg !435, !tbaa !304
  br label %21, !dbg !430, !llvm.loop !436

35:                                               ; preds = %25
  br label %36, !dbg !437

36:                                               ; preds = %35
  %37 = load i32, i32* %6, align 4, !dbg !438, !tbaa !304
  %38 = add nsw i32 %37, 1, !dbg !438
  store i32 %38, i32* %6, align 4, !dbg !438, !tbaa !304
  br label %12, !dbg !421, !llvm.loop !439

39:                                               ; preds = %16
  %40 = load i32, i32* %5, align 4, !dbg !441, !tbaa !304
  store i32 1, i32* %7, align 4
  %41 = bitcast i32* %5 to i8*, !dbg !442
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %41) #4, !dbg !442
  ret i32 %40, !dbg !443
}

; Function Attrs: nounwind uwtable
define dso_local i32 @_Z19double_nest_outsideii(i32, i32) #0 !dbg !444 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store i32 %0, i32* %3, align 4, !tbaa !304
  call void @llvm.dbg.declare(metadata i32* %3, metadata !446, metadata !DIExpression()), !dbg !454
  store i32 %1, i32* %4, align 4, !tbaa !304
  call void @llvm.dbg.declare(metadata i32* %4, metadata !447, metadata !DIExpression()), !dbg !455
  %9 = bitcast i32* %5 to i8*, !dbg !456
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %9) #4, !dbg !456
  call void @llvm.dbg.declare(metadata i32* %5, metadata !448, metadata !DIExpression()), !dbg !457
  %10 = load i32, i32* %3, align 4, !dbg !458, !tbaa !304
  %11 = call i32 @_Z1gi(i32 %10), !dbg !459
  store i32 %11, i32* %5, align 4, !dbg !457, !tbaa !304
  %12 = bitcast i32* %6 to i8*, !dbg !460
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %12) #4, !dbg !460
  call void @llvm.dbg.declare(metadata i32* %6, metadata !449, metadata !DIExpression()), !dbg !461
  %13 = load i32, i32* %3, align 4, !dbg !462, !tbaa !304
  store i32 %13, i32* %6, align 4, !dbg !461, !tbaa !304
  br label %14, !dbg !460

14:                                               ; preds = %36, %2
  %15 = load i32, i32* %6, align 4, !dbg !463, !tbaa !304
  %16 = load i32, i32* @global, align 4, !dbg !464, !tbaa !304
  %17 = icmp slt i32 %15, %16, !dbg !465
  br i1 %17, label %20, label %18, !dbg !466

18:                                               ; preds = %14
  store i32 2, i32* %7, align 4
  %19 = bitcast i32* %6 to i8*, !dbg !467
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %19) #4, !dbg !467
  br label %39

20:                                               ; preds = %14
  %21 = bitcast i32* %8 to i8*, !dbg !468
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %21) #4, !dbg !468
  call void @llvm.dbg.declare(metadata i32* %8, metadata !451, metadata !DIExpression()), !dbg !469
  store i32 0, i32* %8, align 4, !dbg !469, !tbaa !304
  br label %22, !dbg !468

22:                                               ; preds = %32, %20
  %23 = load i32, i32* %8, align 4, !dbg !470, !tbaa !304
  %24 = load i32, i32* %4, align 4, !dbg !472, !tbaa !304
  %25 = icmp slt i32 %23, %24, !dbg !473
  br i1 %25, label %28, label %26, !dbg !474

26:                                               ; preds = %22
  store i32 5, i32* %7, align 4
  %27 = bitcast i32* %8 to i8*, !dbg !475
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %27) #4, !dbg !475
  br label %35

28:                                               ; preds = %22
  %29 = load i32, i32* %6, align 4, !dbg !476, !tbaa !304
  %30 = load i32, i32* %5, align 4, !dbg !477, !tbaa !304
  %31 = add nsw i32 %30, %29, !dbg !477
  store i32 %31, i32* %5, align 4, !dbg !477, !tbaa !304
  br label %32, !dbg !478

32:                                               ; preds = %28
  %33 = load i32, i32* %8, align 4, !dbg !479, !tbaa !304
  %34 = add nsw i32 %33, 1, !dbg !479
  store i32 %34, i32* %8, align 4, !dbg !479, !tbaa !304
  br label %22, !dbg !475, !llvm.loop !480

35:                                               ; preds = %26
  br label %36, !dbg !481

36:                                               ; preds = %35
  %37 = load i32, i32* %6, align 4, !dbg !482, !tbaa !304
  %38 = add nsw i32 %37, 1, !dbg !482
  store i32 %38, i32* %6, align 4, !dbg !482, !tbaa !304
  br label %14, !dbg !467, !llvm.loop !483

39:                                               ; preds = %18
  %40 = load i32, i32* %5, align 4, !dbg !485, !tbaa !304
  store i32 1, i32* %7, align 4
  %41 = bitcast i32* %5 to i8*, !dbg !486
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %41) #4, !dbg !486
  ret i32 %40, !dbg !487
}

; Function Attrs: nounwind uwtable
define dso_local i32 @_Z14multipath_nestii(i32, i32) #0 !dbg !488 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store i32 %0, i32* %3, align 4, !tbaa !304
  call void @llvm.dbg.declare(metadata i32* %3, metadata !490, metadata !DIExpression()), !dbg !499
  store i32 %1, i32* %4, align 4, !tbaa !304
  call void @llvm.dbg.declare(metadata i32* %4, metadata !491, metadata !DIExpression()), !dbg !500
  %9 = bitcast i32* %5 to i8*, !dbg !501
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %9) #4, !dbg !501
  call void @llvm.dbg.declare(metadata i32* %5, metadata !492, metadata !DIExpression()), !dbg !502
  store i32 0, i32* %5, align 4, !dbg !502, !tbaa !304
  %10 = bitcast i32* %6 to i8*, !dbg !503
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %10) #4, !dbg !503
  call void @llvm.dbg.declare(metadata i32* %6, metadata !493, metadata !DIExpression()), !dbg !504
  %11 = load i32, i32* %3, align 4, !dbg !505, !tbaa !304
  store i32 %11, i32* %6, align 4, !dbg !504, !tbaa !304
  br label %12, !dbg !503

12:                                               ; preds = %42, %2
  %13 = load i32, i32* %6, align 4, !dbg !506, !tbaa !304
  %14 = load i32, i32* @global, align 4, !dbg !507, !tbaa !304
  %15 = icmp slt i32 %13, %14, !dbg !508
  br i1 %15, label %18, label %16, !dbg !509

16:                                               ; preds = %12
  store i32 2, i32* %7, align 4
  %17 = bitcast i32* %6 to i8*, !dbg !510
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %17) #4, !dbg !510
  br label %45

18:                                               ; preds = %12
  %19 = load i32, i32* %3, align 4, !dbg !511, !tbaa !304
  %20 = call i32 @_Z1gi(i32 %19), !dbg !512
  %21 = load i32, i32* %5, align 4, !dbg !513, !tbaa !304
  %22 = add nsw i32 %21, %20, !dbg !513
  store i32 %22, i32* %5, align 4, !dbg !513, !tbaa !304
  %23 = bitcast i32* %8 to i8*, !dbg !514
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %23) #4, !dbg !514
  call void @llvm.dbg.declare(metadata i32* %8, metadata !495, metadata !DIExpression()), !dbg !515
  store i32 0, i32* %8, align 4, !dbg !515, !tbaa !304
  br label %24, !dbg !514

24:                                               ; preds = %34, %18
  %25 = load i32, i32* %8, align 4, !dbg !516, !tbaa !304
  %26 = load i32, i32* %4, align 4, !dbg !518, !tbaa !304
  %27 = icmp slt i32 %25, %26, !dbg !519
  br i1 %27, label %30, label %28, !dbg !520

28:                                               ; preds = %24
  store i32 5, i32* %7, align 4
  %29 = bitcast i32* %8 to i8*, !dbg !521
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %29) #4, !dbg !521
  br label %37

30:                                               ; preds = %24
  %31 = load i32, i32* %6, align 4, !dbg !522, !tbaa !304
  %32 = load i32, i32* %5, align 4, !dbg !523, !tbaa !304
  %33 = add nsw i32 %32, %31, !dbg !523
  store i32 %33, i32* %5, align 4, !dbg !523, !tbaa !304
  br label %34, !dbg !524

34:                                               ; preds = %30
  %35 = load i32, i32* %8, align 4, !dbg !525, !tbaa !304
  %36 = add nsw i32 %35, 1, !dbg !525
  store i32 %36, i32* %8, align 4, !dbg !525, !tbaa !304
  br label %24, !dbg !521, !llvm.loop !526

37:                                               ; preds = %28
  %38 = load i32, i32* %4, align 4, !dbg !528, !tbaa !304
  %39 = call i32 @_Z1fi(i32 %38), !dbg !529
  %40 = load i32, i32* %5, align 4, !dbg !530, !tbaa !304
  %41 = add nsw i32 %40, %39, !dbg !530
  store i32 %41, i32* %5, align 4, !dbg !530, !tbaa !304
  br label %42, !dbg !531

42:                                               ; preds = %37
  %43 = load i32, i32* %6, align 4, !dbg !532, !tbaa !304
  %44 = add nsw i32 %43, 1, !dbg !532
  store i32 %44, i32* %6, align 4, !dbg !532, !tbaa !304
  br label %12, !dbg !510, !llvm.loop !533

45:                                               ; preds = %16
  %46 = load i32, i32* %5, align 4, !dbg !535, !tbaa !304
  store i32 1, i32* %7, align 4
  %47 = bitcast i32* %5 to i8*, !dbg !536
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %47) #4, !dbg !536
  ret i32 %46, !dbg !537
}

; Function Attrs: nounwind uwtable
define dso_local i32 @_Z14multipath_nestiii(i32, i32, i32) #0 !dbg !538 {
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  store i32 %0, i32* %4, align 4, !tbaa !304
  call void @llvm.dbg.declare(metadata i32* %4, metadata !542, metadata !DIExpression()), !dbg !552
  store i32 %1, i32* %5, align 4, !tbaa !304
  call void @llvm.dbg.declare(metadata i32* %5, metadata !543, metadata !DIExpression()), !dbg !553
  store i32 %2, i32* %6, align 4, !tbaa !304
  call void @llvm.dbg.declare(metadata i32* %6, metadata !544, metadata !DIExpression()), !dbg !554
  %11 = bitcast i32* %7 to i8*, !dbg !555
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %11) #4, !dbg !555
  call void @llvm.dbg.declare(metadata i32* %7, metadata !545, metadata !DIExpression()), !dbg !556
  store i32 0, i32* %7, align 4, !dbg !556, !tbaa !304
  %12 = bitcast i32* %8 to i8*, !dbg !557
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %12) #4, !dbg !557
  call void @llvm.dbg.declare(metadata i32* %8, metadata !546, metadata !DIExpression()), !dbg !558
  %13 = load i32, i32* %4, align 4, !dbg !559, !tbaa !304
  store i32 %13, i32* %8, align 4, !dbg !558, !tbaa !304
  br label %14, !dbg !557

14:                                               ; preds = %40, %3
  %15 = load i32, i32* %8, align 4, !dbg !560, !tbaa !304
  %16 = load i32, i32* @global, align 4, !dbg !561, !tbaa !304
  %17 = icmp slt i32 %15, %16, !dbg !562
  br i1 %17, label %20, label %18, !dbg !563

18:                                               ; preds = %14
  store i32 2, i32* %9, align 4
  %19 = bitcast i32* %8 to i8*, !dbg !564
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %19) #4, !dbg !564
  br label %43

20:                                               ; preds = %14
  %21 = load i32, i32* %6, align 4, !dbg !565, !tbaa !304
  %22 = call i32 @_Z1gi(i32 %21), !dbg !566
  %23 = load i32, i32* %7, align 4, !dbg !567, !tbaa !304
  %24 = add nsw i32 %23, %22, !dbg !567
  store i32 %24, i32* %7, align 4, !dbg !567, !tbaa !304
  %25 = bitcast i32* %10 to i8*, !dbg !568
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %25) #4, !dbg !568
  call void @llvm.dbg.declare(metadata i32* %10, metadata !548, metadata !DIExpression()), !dbg !569
  store i32 0, i32* %10, align 4, !dbg !569, !tbaa !304
  br label %26, !dbg !568

26:                                               ; preds = %36, %20
  %27 = load i32, i32* %10, align 4, !dbg !570, !tbaa !304
  %28 = load i32, i32* %5, align 4, !dbg !572, !tbaa !304
  %29 = icmp slt i32 %27, %28, !dbg !573
  br i1 %29, label %32, label %30, !dbg !574

30:                                               ; preds = %26
  store i32 5, i32* %9, align 4
  %31 = bitcast i32* %10 to i8*, !dbg !575
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %31) #4, !dbg !575
  br label %39

32:                                               ; preds = %26
  %33 = load i32, i32* %8, align 4, !dbg !576, !tbaa !304
  %34 = load i32, i32* %7, align 4, !dbg !577, !tbaa !304
  %35 = add nsw i32 %34, %33, !dbg !577
  store i32 %35, i32* %7, align 4, !dbg !577, !tbaa !304
  br label %36, !dbg !578

36:                                               ; preds = %32
  %37 = load i32, i32* %10, align 4, !dbg !579, !tbaa !304
  %38 = add nsw i32 %37, 1, !dbg !579
  store i32 %38, i32* %10, align 4, !dbg !579, !tbaa !304
  br label %26, !dbg !575, !llvm.loop !580

39:                                               ; preds = %30
  br label %40, !dbg !582

40:                                               ; preds = %39
  %41 = load i32, i32* %8, align 4, !dbg !583, !tbaa !304
  %42 = add nsw i32 %41, 1, !dbg !583
  store i32 %42, i32* %8, align 4, !dbg !583, !tbaa !304
  br label %14, !dbg !564, !llvm.loop !584

43:                                               ; preds = %18
  %44 = load i32, i32* %7, align 4, !dbg !586, !tbaa !304
  store i32 1, i32* %9, align 4
  %45 = bitcast i32* %7 to i8*, !dbg !587
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %45) #4, !dbg !587
  ret i32 %44, !dbg !588
}

; Function Attrs: nounwind uwtable
define dso_local i32 @_Z14aggregate_nestii(i32, i32) #0 !dbg !589 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  store i32 %0, i32* %3, align 4, !tbaa !304
  call void @llvm.dbg.declare(metadata i32* %3, metadata !591, metadata !DIExpression()), !dbg !601
  store i32 %1, i32* %4, align 4, !tbaa !304
  call void @llvm.dbg.declare(metadata i32* %4, metadata !592, metadata !DIExpression()), !dbg !602
  %10 = bitcast i32* %5 to i8*, !dbg !603
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %10) #4, !dbg !603
  call void @llvm.dbg.declare(metadata i32* %5, metadata !593, metadata !DIExpression()), !dbg !604
  store i32 0, i32* %5, align 4, !dbg !604, !tbaa !304
  %11 = bitcast i32* %6 to i8*, !dbg !605
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %11) #4, !dbg !605
  call void @llvm.dbg.declare(metadata i32* %6, metadata !594, metadata !DIExpression()), !dbg !606
  %12 = load i32, i32* %3, align 4, !dbg !607, !tbaa !304
  store i32 %12, i32* %6, align 4, !dbg !606, !tbaa !304
  br label %13, !dbg !605

13:                                               ; preds = %52, %2
  %14 = load i32, i32* %6, align 4, !dbg !608, !tbaa !304
  %15 = load i32, i32* @global, align 4, !dbg !609, !tbaa !304
  %16 = icmp slt i32 %14, %15, !dbg !610
  br i1 %16, label %19, label %17, !dbg !611

17:                                               ; preds = %13
  store i32 2, i32* %7, align 4
  %18 = bitcast i32* %6 to i8*, !dbg !612
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %18) #4, !dbg !612
  br label %55

19:                                               ; preds = %13
  %20 = bitcast i32* %8 to i8*, !dbg !613
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %20) #4, !dbg !613
  call void @llvm.dbg.declare(metadata i32* %8, metadata !596, metadata !DIExpression()), !dbg !614
  %21 = load i32, i32* %6, align 4, !dbg !615, !tbaa !304
  %22 = load i32, i32* %3, align 4, !dbg !616, !tbaa !304
  %23 = icmp eq i32 %21, %22, !dbg !617
  br i1 %23, label %24, label %26, !dbg !615

24:                                               ; preds = %19
  %25 = load i32, i32* %3, align 4, !dbg !618, !tbaa !304
  br label %30, !dbg !615

26:                                               ; preds = %19
  %27 = load i32, i32* %3, align 4, !dbg !619, !tbaa !304
  %28 = load i32, i32* %4, align 4, !dbg !620, !tbaa !304
  %29 = add nsw i32 %27, %28, !dbg !621
  br label %30, !dbg !615

30:                                               ; preds = %26, %24
  %31 = phi i32 [ %25, %24 ], [ %29, %26 ], !dbg !615
  store i32 %31, i32* %8, align 4, !dbg !614, !tbaa !304
  %32 = load i32, i32* %8, align 4, !dbg !622, !tbaa !304
  %33 = call i32 @_Z1gi(i32 %32), !dbg !623
  %34 = load i32, i32* %5, align 4, !dbg !624, !tbaa !304
  %35 = add nsw i32 %34, %33, !dbg !624
  store i32 %35, i32* %5, align 4, !dbg !624, !tbaa !304
  %36 = bitcast i32* %9 to i8*, !dbg !625
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %36) #4, !dbg !625
  call void @llvm.dbg.declare(metadata i32* %9, metadata !599, metadata !DIExpression()), !dbg !626
  store i32 0, i32* %9, align 4, !dbg !626, !tbaa !304
  br label %37, !dbg !625

37:                                               ; preds = %47, %30
  %38 = load i32, i32* %9, align 4, !dbg !627, !tbaa !304
  %39 = load i32, i32* %4, align 4, !dbg !629, !tbaa !304
  %40 = icmp slt i32 %38, %39, !dbg !630
  br i1 %40, label %43, label %41, !dbg !631

41:                                               ; preds = %37
  store i32 5, i32* %7, align 4
  %42 = bitcast i32* %9 to i8*, !dbg !632
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %42) #4, !dbg !632
  br label %50

43:                                               ; preds = %37
  %44 = load i32, i32* %6, align 4, !dbg !633, !tbaa !304
  %45 = load i32, i32* %5, align 4, !dbg !634, !tbaa !304
  %46 = add nsw i32 %45, %44, !dbg !634
  store i32 %46, i32* %5, align 4, !dbg !634, !tbaa !304
  br label %47, !dbg !635

47:                                               ; preds = %43
  %48 = load i32, i32* %9, align 4, !dbg !636, !tbaa !304
  %49 = add nsw i32 %48, 1, !dbg !636
  store i32 %49, i32* %9, align 4, !dbg !636, !tbaa !304
  br label %37, !dbg !632, !llvm.loop !637

50:                                               ; preds = %41
  %51 = bitcast i32* %8 to i8*, !dbg !639
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %51) #4, !dbg !639
  br label %52, !dbg !640

52:                                               ; preds = %50
  %53 = load i32, i32* %6, align 4, !dbg !641, !tbaa !304
  %54 = add nsw i32 %53, 1, !dbg !641
  store i32 %54, i32* %6, align 4, !dbg !641, !tbaa !304
  br label %13, !dbg !612, !llvm.loop !642

55:                                               ; preds = %17
  %56 = load i32, i32* %5, align 4, !dbg !644, !tbaa !304
  store i32 1, i32* %7, align 4
  %57 = bitcast i32* %5 to i8*, !dbg !645
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %57) #4, !dbg !645
  ret i32 %56, !dbg !646
}

; Function Attrs: nounwind uwtable
define dso_local i32 @_Z20unimportant_functioni(i32) #0 !dbg !647 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4, !tbaa !304
  call void @llvm.dbg.declare(metadata i32* %2, metadata !649, metadata !DIExpression()), !dbg !650
  %3 = load i32, i32* %2, align 4, !dbg !651, !tbaa !304
  %4 = call i32 @_Z1fi(i32 %3), !dbg !652
  %5 = mul nsw i32 2, %4, !dbg !653
  ret i32 %5, !dbg !654
}

; Function Attrs: nounwind uwtable
define dso_local i32 @_Z25call_unimportant_functionii(i32, i32) #0 !dbg !655 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i32 %0, i32* %3, align 4, !tbaa !304
  call void @llvm.dbg.declare(metadata i32* %3, metadata !657, metadata !DIExpression()), !dbg !662
  store i32 %1, i32* %4, align 4, !tbaa !304
  call void @llvm.dbg.declare(metadata i32* %4, metadata !658, metadata !DIExpression()), !dbg !663
  %7 = bitcast i32* %5 to i8*, !dbg !664
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %7) #4, !dbg !664
  call void @llvm.dbg.declare(metadata i32* %5, metadata !659, metadata !DIExpression()), !dbg !665
  store i32 0, i32* %5, align 4, !dbg !665, !tbaa !304
  %8 = bitcast i32* %6 to i8*, !dbg !666
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %8) #4, !dbg !666
  call void @llvm.dbg.declare(metadata i32* %6, metadata !660, metadata !DIExpression()), !dbg !667
  %9 = load i32, i32* %3, align 4, !dbg !668, !tbaa !304
  store i32 %9, i32* %6, align 4, !dbg !667, !tbaa !304
  br label %10, !dbg !666

10:                                               ; preds = %20, %2
  %11 = load i32, i32* %6, align 4, !dbg !669, !tbaa !304
  %12 = load i32, i32* @global, align 4, !dbg !671, !tbaa !304
  %13 = icmp slt i32 %11, %12, !dbg !672
  br i1 %13, label %16, label %14, !dbg !673

14:                                               ; preds = %10
  %15 = bitcast i32* %6 to i8*, !dbg !674
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %15) #4, !dbg !674
  br label %23

16:                                               ; preds = %10
  %17 = load i32, i32* %6, align 4, !dbg !675, !tbaa !304
  %18 = load i32, i32* %5, align 4, !dbg !677, !tbaa !304
  %19 = add nsw i32 %18, %17, !dbg !677
  store i32 %19, i32* %5, align 4, !dbg !677, !tbaa !304
  br label %20, !dbg !678

20:                                               ; preds = %16
  %21 = load i32, i32* %6, align 4, !dbg !679, !tbaa !304
  %22 = add nsw i32 %21, 1, !dbg !679
  store i32 %22, i32* %6, align 4, !dbg !679, !tbaa !304
  br label %10, !dbg !674, !llvm.loop !680

23:                                               ; preds = %14
  %24 = load i32, i32* %3, align 4, !dbg !682, !tbaa !304
  %25 = load i32, i32* %4, align 4, !dbg !683, !tbaa !304
  %26 = add nsw i32 %24, %25, !dbg !684
  %27 = call i32 @_Z20unimportant_functioni(i32 %26), !dbg !685
  %28 = load i32, i32* %5, align 4, !dbg !686, !tbaa !304
  %29 = add nsw i32 %28, %27, !dbg !686
  store i32 %29, i32* %5, align 4, !dbg !686, !tbaa !304
  %30 = load i32, i32* %5, align 4, !dbg !687, !tbaa !304
  %31 = bitcast i32* %5 to i8*, !dbg !688
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %31) #4, !dbg !688
  ret i32 %30, !dbg !689
}

; Function Attrs: norecurse uwtable
define dso_local i32 @main(i32, i8**) #3 !dbg !690 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4, !tbaa !304
  call void @llvm.dbg.declare(metadata i32* %4, metadata !694, metadata !DIExpression()), !dbg !699
  store i8** %1, i8*** %5, align 8, !tbaa !700
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !695, metadata !DIExpression()), !dbg !702
  %9 = bitcast i32* %6 to i8*, !dbg !703
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %9) #4, !dbg !703
  call void @llvm.dbg.declare(metadata i32* %6, metadata !696, metadata !DIExpression()), !dbg !704
  %10 = bitcast i32* %6 to i8*, !dbg !703
  call void @llvm.var.annotation(i8* %10, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([43 x i8], [43 x i8]* @.str.1, i32 0, i32 0), i32 112), !dbg !703
  %11 = load i8**, i8*** %5, align 8, !dbg !705, !tbaa !700
  %12 = getelementptr inbounds i8*, i8** %11, i64 1, !dbg !705
  %13 = load i8*, i8** %12, align 8, !dbg !705, !tbaa !700
  %14 = call i32 @atoi(i8* %13) #9, !dbg !706
  store i32 %14, i32* %6, align 4, !dbg !704, !tbaa !304
  %15 = bitcast i32* %7 to i8*, !dbg !707
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %15) #4, !dbg !707
  call void @llvm.dbg.declare(metadata i32* %7, metadata !697, metadata !DIExpression()), !dbg !708
  %16 = bitcast i32* %7 to i8*, !dbg !707
  call void @llvm.var.annotation(i8* %16, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([43 x i8], [43 x i8]* @.str.1, i32 0, i32 0), i32 113), !dbg !707
  %17 = load i8**, i8*** %5, align 8, !dbg !709, !tbaa !700
  %18 = getelementptr inbounds i8*, i8** %17, i64 2, !dbg !709
  %19 = load i8*, i8** %18, align 8, !dbg !709, !tbaa !700
  %20 = call i32 @atoi(i8* %19) #9, !dbg !710
  store i32 %20, i32* %7, align 4, !dbg !708, !tbaa !304
  %21 = bitcast i32* %8 to i8*, !dbg !711
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %21) #4, !dbg !711
  call void @llvm.dbg.declare(metadata i32* %8, metadata !698, metadata !DIExpression()), !dbg !712
  %22 = load i8**, i8*** %5, align 8, !dbg !713, !tbaa !700
  %23 = getelementptr inbounds i8*, i8** %22, i64 3, !dbg !713
  %24 = load i8*, i8** %23, align 8, !dbg !713, !tbaa !700
  %25 = call i32 @atoi(i8* %24) #9, !dbg !714
  store i32 %25, i32* %8, align 4, !dbg !712, !tbaa !304
  call void @_Z17register_variableIiEvPT_PKc(i32* %6, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.2, i64 0, i64 0)), !dbg !715
  call void @_Z17register_variableIiEvPT_PKc(i32* %7, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.3, i64 0, i64 0)), !dbg !716
  %26 = load i32, i32* %6, align 4, !dbg !717, !tbaa !304
  %27 = load i32, i32* %7, align 4, !dbg !718, !tbaa !304
  %28 = call i32 @_Z11single_nestii(i32 %26, i32 %27), !dbg !719
  %29 = load i32, i32* %6, align 4, !dbg !720, !tbaa !304
  %30 = load i32, i32* %7, align 4, !dbg !721, !tbaa !304
  %31 = call i32 @_Z11double_nestii(i32 %29, i32 %30), !dbg !722
  %32 = load i32, i32* %6, align 4, !dbg !723, !tbaa !304
  %33 = load i32, i32* %7, align 4, !dbg !724, !tbaa !304
  %34 = call i32 @_Z19double_nest_outsideii(i32 %32, i32 %33), !dbg !725
  %35 = load i32, i32* %6, align 4, !dbg !726, !tbaa !304
  %36 = load i32, i32* %7, align 4, !dbg !727, !tbaa !304
  %37 = call i32 @_Z14multipath_nestii(i32 %35, i32 %36), !dbg !728
  %38 = load i32, i32* %6, align 4, !dbg !729, !tbaa !304
  %39 = load i32, i32* %7, align 4, !dbg !730, !tbaa !304
  %40 = load i32, i32* %6, align 4, !dbg !731, !tbaa !304
  %41 = load i32, i32* %7, align 4, !dbg !732, !tbaa !304
  %42 = add nsw i32 %40, %41, !dbg !733
  %43 = call i32 @_Z14multipath_nestiii(i32 %38, i32 %39, i32 %42), !dbg !734
  %44 = load i32, i32* %6, align 4, !dbg !735, !tbaa !304
  %45 = load i32, i32* %7, align 4, !dbg !736, !tbaa !304
  %46 = load i32, i32* %8, align 4, !dbg !737, !tbaa !304
  %47 = call i32 @_Z14multipath_nestiii(i32 %44, i32 %45, i32 %46), !dbg !738
  %48 = load i32, i32* %6, align 4, !dbg !739, !tbaa !304
  %49 = load i32, i32* %7, align 4, !dbg !740, !tbaa !304
  %50 = call i32 @_Z14aggregate_nestii(i32 %48, i32 %49), !dbg !741
  %51 = load i32, i32* %6, align 4, !dbg !742, !tbaa !304
  %52 = load i32, i32* %7, align 4, !dbg !743, !tbaa !304
  %53 = call i32 @_Z25call_unimportant_functionii(i32 %51, i32 %52), !dbg !744
  %54 = bitcast i32* %8 to i8*, !dbg !745
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %54) #4, !dbg !745
  %55 = bitcast i32* %7 to i8*, !dbg !745
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %55) #4, !dbg !745
  %56 = bitcast i32* %6 to i8*, !dbg !745
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %56) #4, !dbg !745
  ret i32 0, !dbg !746
}

; Function Attrs: nounwind
declare void @llvm.var.annotation(i8*, i8*, i8*, i32) #4

; Function Attrs: inlinehint nounwind readonly uwtable
define available_externally dso_local i32 @atoi(i8* nonnull) #5 !dbg !60 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8, !tbaa !700
  call void @llvm.dbg.declare(metadata i8** %2, metadata !64, metadata !DIExpression()), !dbg !747
  %3 = load i8*, i8** %2, align 8, !dbg !748, !tbaa !700
  %4 = call i64 @strtol(i8* %3, i8** null, i32 10) #4, !dbg !749
  %5 = trunc i64 %4 to i32, !dbg !749
  ret i32 %5, !dbg !750
}

; Function Attrs: uwtable
define linkonce_odr dso_local void @_Z17register_variableIiEvPT_PKc(i32*, i8*) #6 comdat !dbg !751 {
  %3 = alloca i32*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca i32, align 4
  store i32* %0, i32** %3, align 8, !tbaa !700
  call void @llvm.dbg.declare(metadata i32** %3, metadata !757, metadata !DIExpression()), !dbg !762
  store i8* %1, i8** %4, align 8, !tbaa !700
  call void @llvm.dbg.declare(metadata i8** %4, metadata !758, metadata !DIExpression()), !dbg !763
  %6 = bitcast i32* %5 to i8*, !dbg !764
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %6) #4, !dbg !764
  call void @llvm.dbg.declare(metadata i32* %5, metadata !759, metadata !DIExpression()), !dbg !765
  %7 = call i32 @__dfsw_EXTRAP_VAR_ID(), !dbg !766
  store i32 %7, i32* %5, align 4, !dbg !765, !tbaa !304
  %8 = load i32*, i32** %3, align 8, !dbg !767, !tbaa !700
  %9 = bitcast i32* %8 to i8*, !dbg !768
  %10 = load i32, i32* %5, align 4, !dbg !769, !tbaa !304
  %11 = add nsw i32 %10, 1, !dbg !769
  store i32 %11, i32* %5, align 4, !dbg !769, !tbaa !304
  %12 = load i8*, i8** %4, align 8, !dbg !770, !tbaa !700
  call void @__dfsw_EXTRAP_STORE_LABEL(i8* %9, i32 4, i32 %10, i8* %12), !dbg !771
  %13 = bitcast i32* %5 to i8*, !dbg !772
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %13) #4, !dbg !772
  ret void, !dbg !772
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
!3 = !DIFile(filename: "tests/dfsan-instr/nested_function_call.cpp", directory: "/home/mcopik/projects/ETH/extrap/rebuild/extrap-tool")
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
!296 = distinct !DISubprogram(name: "f", linkageName: "_Z1fi", scope: !3, file: !3, line: 8, type: !297, scopeLine: 9, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !299)
!297 = !DISubroutineType(types: !298)
!298 = !{!6, !6}
!299 = !{!300, !301, !302}
!300 = !DILocalVariable(name: "x", arg: 1, scope: !296, file: !3, line: 8, type: !6)
!301 = !DILocalVariable(name: "tmp", scope: !296, file: !3, line: 10, type: !6)
!302 = !DILocalVariable(name: "i", scope: !303, file: !3, line: 11, type: !6)
!303 = distinct !DILexicalBlock(scope: !296, file: !3, line: 11, column: 5)
!304 = !{!305, !305, i64 0}
!305 = !{!"int", !306, i64 0}
!306 = !{!"omnipotent char", !307, i64 0}
!307 = !{!"Simple C++ TBAA"}
!308 = !DILocation(line: 8, column: 11, scope: !296)
!309 = !DILocation(line: 10, column: 5, scope: !296)
!310 = !DILocation(line: 10, column: 9, scope: !296)
!311 = !DILocation(line: 11, column: 9, scope: !303)
!312 = !DILocation(line: 11, column: 13, scope: !303)
!313 = !DILocation(line: 11, column: 20, scope: !314)
!314 = distinct !DILexicalBlock(scope: !303, file: !3, line: 11, column: 5)
!315 = !DILocation(line: 11, column: 24, scope: !314)
!316 = !DILocation(line: 11, column: 22, scope: !314)
!317 = !DILocation(line: 11, column: 5, scope: !303)
!318 = !DILocation(line: 11, column: 5, scope: !314)
!319 = !DILocation(line: 12, column: 16, scope: !314)
!320 = !DILocation(line: 12, column: 13, scope: !314)
!321 = !DILocation(line: 12, column: 9, scope: !314)
!322 = !DILocation(line: 11, column: 27, scope: !314)
!323 = distinct !{!323, !317, !324}
!324 = !DILocation(line: 12, column: 16, scope: !303)
!325 = !DILocation(line: 13, column: 12, scope: !296)
!326 = !DILocation(line: 14, column: 1, scope: !296)
!327 = !DILocation(line: 13, column: 5, scope: !296)
!328 = distinct !DISubprogram(name: "g", linkageName: "_Z1gi", scope: !3, file: !3, line: 16, type: !297, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !329)
!329 = !{!330, !331, !332}
!330 = !DILocalVariable(name: "x", arg: 1, scope: !328, file: !3, line: 16, type: !6)
!331 = !DILocalVariable(name: "tmp", scope: !328, file: !3, line: 18, type: !6)
!332 = !DILocalVariable(name: "i", scope: !333, file: !3, line: 19, type: !6)
!333 = distinct !DILexicalBlock(scope: !328, file: !3, line: 19, column: 5)
!334 = !DILocation(line: 16, column: 11, scope: !328)
!335 = !DILocation(line: 18, column: 5, scope: !328)
!336 = !DILocation(line: 18, column: 9, scope: !328)
!337 = !DILocation(line: 19, column: 9, scope: !333)
!338 = !DILocation(line: 19, column: 13, scope: !333)
!339 = !DILocation(line: 19, column: 20, scope: !340)
!340 = distinct !DILexicalBlock(scope: !333, file: !3, line: 19, column: 5)
!341 = !DILocation(line: 19, column: 24, scope: !340)
!342 = !DILocation(line: 19, column: 22, scope: !340)
!343 = !DILocation(line: 19, column: 5, scope: !333)
!344 = !DILocation(line: 19, column: 5, scope: !340)
!345 = !DILocation(line: 20, column: 18, scope: !340)
!346 = !DILocation(line: 20, column: 16, scope: !340)
!347 = !DILocation(line: 20, column: 13, scope: !340)
!348 = !DILocation(line: 20, column: 9, scope: !340)
!349 = !DILocation(line: 19, column: 27, scope: !340)
!350 = distinct !{!350, !343, !351}
!351 = !DILocation(line: 20, column: 19, scope: !333)
!352 = !DILocation(line: 21, column: 12, scope: !328)
!353 = !DILocation(line: 22, column: 1, scope: !328)
!354 = !DILocation(line: 21, column: 5, scope: !328)
!355 = distinct !DISubprogram(name: "single_nest", linkageName: "_Z11single_nestii", scope: !3, file: !3, line: 25, type: !356, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !358)
!356 = !DISubroutineType(types: !357)
!357 = !{!6, !6, !6}
!358 = !{!359, !360, !361, !362, !364}
!359 = !DILocalVariable(name: "x", arg: 1, scope: !355, file: !3, line: 25, type: !6)
!360 = !DILocalVariable(name: "y", arg: 2, scope: !355, file: !3, line: 25, type: !6)
!361 = !DILocalVariable(name: "tmp", scope: !355, file: !3, line: 27, type: !6)
!362 = !DILocalVariable(name: "i", scope: !363, file: !3, line: 28, type: !6)
!363 = distinct !DILexicalBlock(scope: !355, file: !3, line: 28, column: 5)
!364 = !DILocalVariable(name: "j", scope: !365, file: !3, line: 29, type: !6)
!365 = distinct !DILexicalBlock(scope: !366, file: !3, line: 29, column: 9)
!366 = distinct !DILexicalBlock(scope: !363, file: !3, line: 28, column: 5)
!367 = !DILocation(line: 25, column: 21, scope: !355)
!368 = !DILocation(line: 25, column: 28, scope: !355)
!369 = !DILocation(line: 27, column: 5, scope: !355)
!370 = !DILocation(line: 27, column: 9, scope: !355)
!371 = !DILocation(line: 28, column: 9, scope: !363)
!372 = !DILocation(line: 28, column: 13, scope: !363)
!373 = !DILocation(line: 28, column: 17, scope: !363)
!374 = !DILocation(line: 28, column: 20, scope: !366)
!375 = !DILocation(line: 28, column: 24, scope: !366)
!376 = !DILocation(line: 28, column: 22, scope: !366)
!377 = !DILocation(line: 28, column: 5, scope: !363)
!378 = !DILocation(line: 28, column: 5, scope: !366)
!379 = !DILocation(line: 29, column: 13, scope: !365)
!380 = !DILocation(line: 29, column: 17, scope: !365)
!381 = !DILocation(line: 29, column: 24, scope: !382)
!382 = distinct !DILexicalBlock(scope: !365, file: !3, line: 29, column: 9)
!383 = !DILocation(line: 29, column: 28, scope: !382)
!384 = !DILocation(line: 29, column: 26, scope: !382)
!385 = !DILocation(line: 29, column: 9, scope: !365)
!386 = !DILocation(line: 29, column: 9, scope: !382)
!387 = !DILocation(line: 30, column: 22, scope: !382)
!388 = !DILocation(line: 30, column: 20, scope: !382)
!389 = !DILocation(line: 30, column: 17, scope: !382)
!390 = !DILocation(line: 30, column: 13, scope: !382)
!391 = !DILocation(line: 29, column: 31, scope: !382)
!392 = distinct !{!392, !385, !393}
!393 = !DILocation(line: 30, column: 23, scope: !365)
!394 = !DILocation(line: 28, column: 32, scope: !366)
!395 = distinct !{!395, !377, !396}
!396 = !DILocation(line: 30, column: 23, scope: !363)
!397 = !DILocation(line: 31, column: 12, scope: !355)
!398 = !DILocation(line: 32, column: 1, scope: !355)
!399 = !DILocation(line: 31, column: 5, scope: !355)
!400 = distinct !DISubprogram(name: "double_nest", linkageName: "_Z11double_nestii", scope: !3, file: !3, line: 37, type: !356, scopeLine: 38, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !401)
!401 = !{!402, !403, !404, !405, !407}
!402 = !DILocalVariable(name: "x", arg: 1, scope: !400, file: !3, line: 37, type: !6)
!403 = !DILocalVariable(name: "y", arg: 2, scope: !400, file: !3, line: 37, type: !6)
!404 = !DILocalVariable(name: "tmp", scope: !400, file: !3, line: 39, type: !6)
!405 = !DILocalVariable(name: "i", scope: !406, file: !3, line: 40, type: !6)
!406 = distinct !DILexicalBlock(scope: !400, file: !3, line: 40, column: 5)
!407 = !DILocalVariable(name: "j", scope: !408, file: !3, line: 41, type: !6)
!408 = distinct !DILexicalBlock(scope: !409, file: !3, line: 41, column: 9)
!409 = distinct !DILexicalBlock(scope: !406, file: !3, line: 40, column: 5)
!410 = !DILocation(line: 37, column: 21, scope: !400)
!411 = !DILocation(line: 37, column: 28, scope: !400)
!412 = !DILocation(line: 39, column: 5, scope: !400)
!413 = !DILocation(line: 39, column: 9, scope: !400)
!414 = !DILocation(line: 40, column: 9, scope: !406)
!415 = !DILocation(line: 40, column: 13, scope: !406)
!416 = !DILocation(line: 40, column: 17, scope: !406)
!417 = !DILocation(line: 40, column: 20, scope: !409)
!418 = !DILocation(line: 40, column: 24, scope: !409)
!419 = !DILocation(line: 40, column: 22, scope: !409)
!420 = !DILocation(line: 40, column: 5, scope: !406)
!421 = !DILocation(line: 40, column: 5, scope: !409)
!422 = !DILocation(line: 41, column: 13, scope: !408)
!423 = !DILocation(line: 41, column: 17, scope: !408)
!424 = !DILocation(line: 41, column: 21, scope: !408)
!425 = !DILocation(line: 41, column: 24, scope: !426)
!426 = distinct !DILexicalBlock(scope: !408, file: !3, line: 41, column: 9)
!427 = !DILocation(line: 41, column: 28, scope: !426)
!428 = !DILocation(line: 41, column: 26, scope: !426)
!429 = !DILocation(line: 41, column: 9, scope: !408)
!430 = !DILocation(line: 41, column: 9, scope: !426)
!431 = !DILocation(line: 42, column: 22, scope: !426)
!432 = !DILocation(line: 42, column: 20, scope: !426)
!433 = !DILocation(line: 42, column: 17, scope: !426)
!434 = !DILocation(line: 42, column: 13, scope: !426)
!435 = !DILocation(line: 41, column: 36, scope: !426)
!436 = distinct !{!436, !429, !437}
!437 = !DILocation(line: 42, column: 23, scope: !408)
!438 = !DILocation(line: 40, column: 32, scope: !409)
!439 = distinct !{!439, !420, !440}
!440 = !DILocation(line: 42, column: 23, scope: !406)
!441 = !DILocation(line: 43, column: 12, scope: !400)
!442 = !DILocation(line: 44, column: 1, scope: !400)
!443 = !DILocation(line: 43, column: 5, scope: !400)
!444 = distinct !DISubprogram(name: "double_nest_outside", linkageName: "_Z19double_nest_outsideii", scope: !3, file: !3, line: 48, type: !356, scopeLine: 49, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !445)
!445 = !{!446, !447, !448, !449, !451}
!446 = !DILocalVariable(name: "x", arg: 1, scope: !444, file: !3, line: 48, type: !6)
!447 = !DILocalVariable(name: "y", arg: 2, scope: !444, file: !3, line: 48, type: !6)
!448 = !DILocalVariable(name: "tmp", scope: !444, file: !3, line: 50, type: !6)
!449 = !DILocalVariable(name: "i", scope: !450, file: !3, line: 51, type: !6)
!450 = distinct !DILexicalBlock(scope: !444, file: !3, line: 51, column: 5)
!451 = !DILocalVariable(name: "j", scope: !452, file: !3, line: 52, type: !6)
!452 = distinct !DILexicalBlock(scope: !453, file: !3, line: 52, column: 9)
!453 = distinct !DILexicalBlock(scope: !450, file: !3, line: 51, column: 5)
!454 = !DILocation(line: 48, column: 29, scope: !444)
!455 = !DILocation(line: 48, column: 36, scope: !444)
!456 = !DILocation(line: 50, column: 5, scope: !444)
!457 = !DILocation(line: 50, column: 9, scope: !444)
!458 = !DILocation(line: 50, column: 17, scope: !444)
!459 = !DILocation(line: 50, column: 15, scope: !444)
!460 = !DILocation(line: 51, column: 9, scope: !450)
!461 = !DILocation(line: 51, column: 13, scope: !450)
!462 = !DILocation(line: 51, column: 17, scope: !450)
!463 = !DILocation(line: 51, column: 20, scope: !453)
!464 = !DILocation(line: 51, column: 24, scope: !453)
!465 = !DILocation(line: 51, column: 22, scope: !453)
!466 = !DILocation(line: 51, column: 5, scope: !450)
!467 = !DILocation(line: 51, column: 5, scope: !453)
!468 = !DILocation(line: 52, column: 13, scope: !452)
!469 = !DILocation(line: 52, column: 17, scope: !452)
!470 = !DILocation(line: 52, column: 24, scope: !471)
!471 = distinct !DILexicalBlock(scope: !452, file: !3, line: 52, column: 9)
!472 = !DILocation(line: 52, column: 28, scope: !471)
!473 = !DILocation(line: 52, column: 26, scope: !471)
!474 = !DILocation(line: 52, column: 9, scope: !452)
!475 = !DILocation(line: 52, column: 9, scope: !471)
!476 = !DILocation(line: 53, column: 20, scope: !471)
!477 = !DILocation(line: 53, column: 17, scope: !471)
!478 = !DILocation(line: 53, column: 13, scope: !471)
!479 = !DILocation(line: 52, column: 31, scope: !471)
!480 = distinct !{!480, !474, !481}
!481 = !DILocation(line: 53, column: 20, scope: !452)
!482 = !DILocation(line: 51, column: 32, scope: !453)
!483 = distinct !{!483, !466, !484}
!484 = !DILocation(line: 53, column: 20, scope: !450)
!485 = !DILocation(line: 54, column: 12, scope: !444)
!486 = !DILocation(line: 55, column: 1, scope: !444)
!487 = !DILocation(line: 54, column: 5, scope: !444)
!488 = distinct !DISubprogram(name: "multipath_nest", linkageName: "_Z14multipath_nestii", scope: !3, file: !3, line: 58, type: !356, scopeLine: 59, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !489)
!489 = !{!490, !491, !492, !493, !495}
!490 = !DILocalVariable(name: "x", arg: 1, scope: !488, file: !3, line: 58, type: !6)
!491 = !DILocalVariable(name: "y", arg: 2, scope: !488, file: !3, line: 58, type: !6)
!492 = !DILocalVariable(name: "tmp", scope: !488, file: !3, line: 60, type: !6)
!493 = !DILocalVariable(name: "i", scope: !494, file: !3, line: 61, type: !6)
!494 = distinct !DILexicalBlock(scope: !488, file: !3, line: 61, column: 5)
!495 = !DILocalVariable(name: "j", scope: !496, file: !3, line: 63, type: !6)
!496 = distinct !DILexicalBlock(scope: !497, file: !3, line: 63, column: 9)
!497 = distinct !DILexicalBlock(scope: !498, file: !3, line: 61, column: 37)
!498 = distinct !DILexicalBlock(scope: !494, file: !3, line: 61, column: 5)
!499 = !DILocation(line: 58, column: 24, scope: !488)
!500 = !DILocation(line: 58, column: 31, scope: !488)
!501 = !DILocation(line: 60, column: 5, scope: !488)
!502 = !DILocation(line: 60, column: 9, scope: !488)
!503 = !DILocation(line: 61, column: 9, scope: !494)
!504 = !DILocation(line: 61, column: 13, scope: !494)
!505 = !DILocation(line: 61, column: 17, scope: !494)
!506 = !DILocation(line: 61, column: 20, scope: !498)
!507 = !DILocation(line: 61, column: 24, scope: !498)
!508 = !DILocation(line: 61, column: 22, scope: !498)
!509 = !DILocation(line: 61, column: 5, scope: !494)
!510 = !DILocation(line: 61, column: 5, scope: !498)
!511 = !DILocation(line: 62, column: 18, scope: !497)
!512 = !DILocation(line: 62, column: 16, scope: !497)
!513 = !DILocation(line: 62, column: 13, scope: !497)
!514 = !DILocation(line: 63, column: 13, scope: !496)
!515 = !DILocation(line: 63, column: 17, scope: !496)
!516 = !DILocation(line: 63, column: 24, scope: !517)
!517 = distinct !DILexicalBlock(scope: !496, file: !3, line: 63, column: 9)
!518 = !DILocation(line: 63, column: 28, scope: !517)
!519 = !DILocation(line: 63, column: 26, scope: !517)
!520 = !DILocation(line: 63, column: 9, scope: !496)
!521 = !DILocation(line: 63, column: 9, scope: !517)
!522 = !DILocation(line: 64, column: 20, scope: !517)
!523 = !DILocation(line: 64, column: 17, scope: !517)
!524 = !DILocation(line: 64, column: 13, scope: !517)
!525 = !DILocation(line: 63, column: 31, scope: !517)
!526 = distinct !{!526, !520, !527}
!527 = !DILocation(line: 64, column: 20, scope: !496)
!528 = !DILocation(line: 65, column: 18, scope: !497)
!529 = !DILocation(line: 65, column: 16, scope: !497)
!530 = !DILocation(line: 65, column: 13, scope: !497)
!531 = !DILocation(line: 66, column: 5, scope: !497)
!532 = !DILocation(line: 61, column: 32, scope: !498)
!533 = distinct !{!533, !509, !534}
!534 = !DILocation(line: 66, column: 5, scope: !494)
!535 = !DILocation(line: 67, column: 12, scope: !488)
!536 = !DILocation(line: 68, column: 1, scope: !488)
!537 = !DILocation(line: 67, column: 5, scope: !488)
!538 = distinct !DISubprogram(name: "multipath_nest", linkageName: "_Z14multipath_nestiii", scope: !3, file: !3, line: 71, type: !539, scopeLine: 72, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !541)
!539 = !DISubroutineType(types: !540)
!540 = !{!6, !6, !6, !6}
!541 = !{!542, !543, !544, !545, !546, !548}
!542 = !DILocalVariable(name: "x", arg: 1, scope: !538, file: !3, line: 71, type: !6)
!543 = !DILocalVariable(name: "y", arg: 2, scope: !538, file: !3, line: 71, type: !6)
!544 = !DILocalVariable(name: "z", arg: 3, scope: !538, file: !3, line: 71, type: !6)
!545 = !DILocalVariable(name: "tmp", scope: !538, file: !3, line: 73, type: !6)
!546 = !DILocalVariable(name: "i", scope: !547, file: !3, line: 74, type: !6)
!547 = distinct !DILexicalBlock(scope: !538, file: !3, line: 74, column: 5)
!548 = !DILocalVariable(name: "j", scope: !549, file: !3, line: 76, type: !6)
!549 = distinct !DILexicalBlock(scope: !550, file: !3, line: 76, column: 9)
!550 = distinct !DILexicalBlock(scope: !551, file: !3, line: 74, column: 37)
!551 = distinct !DILexicalBlock(scope: !547, file: !3, line: 74, column: 5)
!552 = !DILocation(line: 71, column: 24, scope: !538)
!553 = !DILocation(line: 71, column: 31, scope: !538)
!554 = !DILocation(line: 71, column: 38, scope: !538)
!555 = !DILocation(line: 73, column: 5, scope: !538)
!556 = !DILocation(line: 73, column: 9, scope: !538)
!557 = !DILocation(line: 74, column: 9, scope: !547)
!558 = !DILocation(line: 74, column: 13, scope: !547)
!559 = !DILocation(line: 74, column: 17, scope: !547)
!560 = !DILocation(line: 74, column: 20, scope: !551)
!561 = !DILocation(line: 74, column: 24, scope: !551)
!562 = !DILocation(line: 74, column: 22, scope: !551)
!563 = !DILocation(line: 74, column: 5, scope: !547)
!564 = !DILocation(line: 74, column: 5, scope: !551)
!565 = !DILocation(line: 75, column: 18, scope: !550)
!566 = !DILocation(line: 75, column: 16, scope: !550)
!567 = !DILocation(line: 75, column: 13, scope: !550)
!568 = !DILocation(line: 76, column: 13, scope: !549)
!569 = !DILocation(line: 76, column: 17, scope: !549)
!570 = !DILocation(line: 76, column: 24, scope: !571)
!571 = distinct !DILexicalBlock(scope: !549, file: !3, line: 76, column: 9)
!572 = !DILocation(line: 76, column: 28, scope: !571)
!573 = !DILocation(line: 76, column: 26, scope: !571)
!574 = !DILocation(line: 76, column: 9, scope: !549)
!575 = !DILocation(line: 76, column: 9, scope: !571)
!576 = !DILocation(line: 77, column: 20, scope: !571)
!577 = !DILocation(line: 77, column: 17, scope: !571)
!578 = !DILocation(line: 77, column: 13, scope: !571)
!579 = !DILocation(line: 76, column: 31, scope: !571)
!580 = distinct !{!580, !574, !581}
!581 = !DILocation(line: 77, column: 20, scope: !549)
!582 = !DILocation(line: 78, column: 5, scope: !550)
!583 = !DILocation(line: 74, column: 32, scope: !551)
!584 = distinct !{!584, !563, !585}
!585 = !DILocation(line: 78, column: 5, scope: !547)
!586 = !DILocation(line: 79, column: 12, scope: !538)
!587 = !DILocation(line: 80, column: 1, scope: !538)
!588 = !DILocation(line: 79, column: 5, scope: !538)
!589 = distinct !DISubprogram(name: "aggregate_nest", linkageName: "_Z14aggregate_nestii", scope: !3, file: !3, line: 83, type: !356, scopeLine: 84, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !590)
!590 = !{!591, !592, !593, !594, !596, !599}
!591 = !DILocalVariable(name: "x", arg: 1, scope: !589, file: !3, line: 83, type: !6)
!592 = !DILocalVariable(name: "y", arg: 2, scope: !589, file: !3, line: 83, type: !6)
!593 = !DILocalVariable(name: "tmp", scope: !589, file: !3, line: 85, type: !6)
!594 = !DILocalVariable(name: "i", scope: !595, file: !3, line: 86, type: !6)
!595 = distinct !DILexicalBlock(scope: !589, file: !3, line: 86, column: 5)
!596 = !DILocalVariable(name: "val", scope: !597, file: !3, line: 87, type: !6)
!597 = distinct !DILexicalBlock(scope: !598, file: !3, line: 86, column: 37)
!598 = distinct !DILexicalBlock(scope: !595, file: !3, line: 86, column: 5)
!599 = !DILocalVariable(name: "j", scope: !600, file: !3, line: 89, type: !6)
!600 = distinct !DILexicalBlock(scope: !597, file: !3, line: 89, column: 9)
!601 = !DILocation(line: 83, column: 24, scope: !589)
!602 = !DILocation(line: 83, column: 31, scope: !589)
!603 = !DILocation(line: 85, column: 5, scope: !589)
!604 = !DILocation(line: 85, column: 9, scope: !589)
!605 = !DILocation(line: 86, column: 9, scope: !595)
!606 = !DILocation(line: 86, column: 13, scope: !595)
!607 = !DILocation(line: 86, column: 17, scope: !595)
!608 = !DILocation(line: 86, column: 20, scope: !598)
!609 = !DILocation(line: 86, column: 24, scope: !598)
!610 = !DILocation(line: 86, column: 22, scope: !598)
!611 = !DILocation(line: 86, column: 5, scope: !595)
!612 = !DILocation(line: 86, column: 5, scope: !598)
!613 = !DILocation(line: 87, column: 9, scope: !597)
!614 = !DILocation(line: 87, column: 13, scope: !597)
!615 = !DILocation(line: 87, column: 19, scope: !597)
!616 = !DILocation(line: 87, column: 24, scope: !597)
!617 = !DILocation(line: 87, column: 21, scope: !597)
!618 = !DILocation(line: 87, column: 28, scope: !597)
!619 = !DILocation(line: 87, column: 32, scope: !597)
!620 = !DILocation(line: 87, column: 36, scope: !597)
!621 = !DILocation(line: 87, column: 34, scope: !597)
!622 = !DILocation(line: 88, column: 18, scope: !597)
!623 = !DILocation(line: 88, column: 16, scope: !597)
!624 = !DILocation(line: 88, column: 13, scope: !597)
!625 = !DILocation(line: 89, column: 13, scope: !600)
!626 = !DILocation(line: 89, column: 17, scope: !600)
!627 = !DILocation(line: 89, column: 24, scope: !628)
!628 = distinct !DILexicalBlock(scope: !600, file: !3, line: 89, column: 9)
!629 = !DILocation(line: 89, column: 28, scope: !628)
!630 = !DILocation(line: 89, column: 26, scope: !628)
!631 = !DILocation(line: 89, column: 9, scope: !600)
!632 = !DILocation(line: 89, column: 9, scope: !628)
!633 = !DILocation(line: 90, column: 20, scope: !628)
!634 = !DILocation(line: 90, column: 17, scope: !628)
!635 = !DILocation(line: 90, column: 13, scope: !628)
!636 = !DILocation(line: 89, column: 31, scope: !628)
!637 = distinct !{!637, !631, !638}
!638 = !DILocation(line: 90, column: 20, scope: !600)
!639 = !DILocation(line: 91, column: 5, scope: !598)
!640 = !DILocation(line: 91, column: 5, scope: !597)
!641 = !DILocation(line: 86, column: 32, scope: !598)
!642 = distinct !{!642, !611, !643}
!643 = !DILocation(line: 91, column: 5, scope: !595)
!644 = !DILocation(line: 92, column: 12, scope: !589)
!645 = !DILocation(line: 93, column: 1, scope: !589)
!646 = !DILocation(line: 92, column: 5, scope: !589)
!647 = distinct !DISubprogram(name: "unimportant_function", linkageName: "_Z20unimportant_functioni", scope: !3, file: !3, line: 95, type: !297, scopeLine: 96, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !648)
!648 = !{!649}
!649 = !DILocalVariable(name: "x", arg: 1, scope: !647, file: !3, line: 95, type: !6)
!650 = !DILocation(line: 95, column: 30, scope: !647)
!651 = !DILocation(line: 97, column: 18, scope: !647)
!652 = !DILocation(line: 97, column: 16, scope: !647)
!653 = !DILocation(line: 97, column: 14, scope: !647)
!654 = !DILocation(line: 97, column: 5, scope: !647)
!655 = distinct !DISubprogram(name: "call_unimportant_function", linkageName: "_Z25call_unimportant_functionii", scope: !3, file: !3, line: 100, type: !356, scopeLine: 101, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !656)
!656 = !{!657, !658, !659, !660}
!657 = !DILocalVariable(name: "x", arg: 1, scope: !655, file: !3, line: 100, type: !6)
!658 = !DILocalVariable(name: "y", arg: 2, scope: !655, file: !3, line: 100, type: !6)
!659 = !DILocalVariable(name: "tmp", scope: !655, file: !3, line: 102, type: !6)
!660 = !DILocalVariable(name: "i", scope: !661, file: !3, line: 103, type: !6)
!661 = distinct !DILexicalBlock(scope: !655, file: !3, line: 103, column: 5)
!662 = !DILocation(line: 100, column: 35, scope: !655)
!663 = !DILocation(line: 100, column: 42, scope: !655)
!664 = !DILocation(line: 102, column: 5, scope: !655)
!665 = !DILocation(line: 102, column: 9, scope: !655)
!666 = !DILocation(line: 103, column: 9, scope: !661)
!667 = !DILocation(line: 103, column: 13, scope: !661)
!668 = !DILocation(line: 103, column: 17, scope: !661)
!669 = !DILocation(line: 103, column: 20, scope: !670)
!670 = distinct !DILexicalBlock(scope: !661, file: !3, line: 103, column: 5)
!671 = !DILocation(line: 103, column: 24, scope: !670)
!672 = !DILocation(line: 103, column: 22, scope: !670)
!673 = !DILocation(line: 103, column: 5, scope: !661)
!674 = !DILocation(line: 103, column: 5, scope: !670)
!675 = !DILocation(line: 104, column: 16, scope: !676)
!676 = distinct !DILexicalBlock(scope: !670, file: !3, line: 103, column: 37)
!677 = !DILocation(line: 104, column: 13, scope: !676)
!678 = !DILocation(line: 105, column: 5, scope: !676)
!679 = !DILocation(line: 103, column: 32, scope: !670)
!680 = distinct !{!680, !673, !681}
!681 = !DILocation(line: 105, column: 5, scope: !661)
!682 = !DILocation(line: 106, column: 33, scope: !655)
!683 = !DILocation(line: 106, column: 37, scope: !655)
!684 = !DILocation(line: 106, column: 35, scope: !655)
!685 = !DILocation(line: 106, column: 12, scope: !655)
!686 = !DILocation(line: 106, column: 9, scope: !655)
!687 = !DILocation(line: 107, column: 12, scope: !655)
!688 = !DILocation(line: 108, column: 1, scope: !655)
!689 = !DILocation(line: 107, column: 5, scope: !655)
!690 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 110, type: !691, scopeLine: 111, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !693)
!691 = !DISubroutineType(types: !692)
!692 = !{!6, !6, !7}
!693 = !{!694, !695, !696, !697, !698}
!694 = !DILocalVariable(name: "argc", arg: 1, scope: !690, file: !3, line: 110, type: !6)
!695 = !DILocalVariable(name: "argv", arg: 2, scope: !690, file: !3, line: 110, type: !7)
!696 = !DILocalVariable(name: "x1", scope: !690, file: !3, line: 112, type: !6)
!697 = !DILocalVariable(name: "x2", scope: !690, file: !3, line: 113, type: !6)
!698 = !DILocalVariable(name: "x3", scope: !690, file: !3, line: 114, type: !6)
!699 = !DILocation(line: 110, column: 14, scope: !690)
!700 = !{!701, !701, i64 0}
!701 = !{!"any pointer", !306, i64 0}
!702 = !DILocation(line: 110, column: 28, scope: !690)
!703 = !DILocation(line: 112, column: 5, scope: !690)
!704 = !DILocation(line: 112, column: 9, scope: !690)
!705 = !DILocation(line: 112, column: 26, scope: !690)
!706 = !DILocation(line: 112, column: 21, scope: !690)
!707 = !DILocation(line: 113, column: 5, scope: !690)
!708 = !DILocation(line: 113, column: 9, scope: !690)
!709 = !DILocation(line: 113, column: 26, scope: !690)
!710 = !DILocation(line: 113, column: 21, scope: !690)
!711 = !DILocation(line: 114, column: 5, scope: !690)
!712 = !DILocation(line: 114, column: 9, scope: !690)
!713 = !DILocation(line: 114, column: 19, scope: !690)
!714 = !DILocation(line: 114, column: 14, scope: !690)
!715 = !DILocation(line: 115, column: 5, scope: !690)
!716 = !DILocation(line: 116, column: 5, scope: !690)
!717 = !DILocation(line: 118, column: 17, scope: !690)
!718 = !DILocation(line: 118, column: 21, scope: !690)
!719 = !DILocation(line: 118, column: 5, scope: !690)
!720 = !DILocation(line: 119, column: 17, scope: !690)
!721 = !DILocation(line: 119, column: 21, scope: !690)
!722 = !DILocation(line: 119, column: 5, scope: !690)
!723 = !DILocation(line: 120, column: 25, scope: !690)
!724 = !DILocation(line: 120, column: 29, scope: !690)
!725 = !DILocation(line: 120, column: 5, scope: !690)
!726 = !DILocation(line: 121, column: 20, scope: !690)
!727 = !DILocation(line: 121, column: 24, scope: !690)
!728 = !DILocation(line: 121, column: 5, scope: !690)
!729 = !DILocation(line: 122, column: 20, scope: !690)
!730 = !DILocation(line: 122, column: 24, scope: !690)
!731 = !DILocation(line: 122, column: 28, scope: !690)
!732 = !DILocation(line: 122, column: 33, scope: !690)
!733 = !DILocation(line: 122, column: 31, scope: !690)
!734 = !DILocation(line: 122, column: 5, scope: !690)
!735 = !DILocation(line: 123, column: 20, scope: !690)
!736 = !DILocation(line: 123, column: 24, scope: !690)
!737 = !DILocation(line: 123, column: 28, scope: !690)
!738 = !DILocation(line: 123, column: 5, scope: !690)
!739 = !DILocation(line: 124, column: 20, scope: !690)
!740 = !DILocation(line: 124, column: 24, scope: !690)
!741 = !DILocation(line: 124, column: 5, scope: !690)
!742 = !DILocation(line: 125, column: 31, scope: !690)
!743 = !DILocation(line: 125, column: 35, scope: !690)
!744 = !DILocation(line: 125, column: 5, scope: !690)
!745 = !DILocation(line: 128, column: 1, scope: !690)
!746 = !DILocation(line: 127, column: 5, scope: !690)
!747 = !DILocation(line: 361, column: 1, scope: !60)
!748 = !DILocation(line: 363, column: 24, scope: !60)
!749 = !DILocation(line: 363, column: 16, scope: !60)
!750 = !DILocation(line: 363, column: 3, scope: !60)
!751 = distinct !DISubprogram(name: "register_variable<int>", linkageName: "_Z17register_variableIiEvPT_PKc", scope: !752, file: !752, line: 14, type: !753, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, templateParams: !760, retainedNodes: !756)
!752 = !DIFile(filename: "include/ExtraPInstrumenter.hpp", directory: "/home/mcopik/projects/ETH/extrap/rebuild/extrap-tool")
!753 = !DISubroutineType(types: !754)
!754 = !{null, !755, !57}
!755 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !6, size: 64)
!756 = !{!757, !758, !759}
!757 = !DILocalVariable(name: "ptr", arg: 1, scope: !751, file: !752, line: 14, type: !755)
!758 = !DILocalVariable(name: "name", arg: 2, scope: !751, file: !752, line: 14, type: !57)
!759 = !DILocalVariable(name: "param_id", scope: !751, file: !752, line: 16, type: !229)
!760 = !{!761}
!761 = !DITemplateTypeParameter(name: "T", type: !6)
!762 = !DILocation(line: 14, column: 28, scope: !751)
!763 = !DILocation(line: 14, column: 46, scope: !751)
!764 = !DILocation(line: 16, column: 5, scope: !751)
!765 = !DILocation(line: 16, column: 13, scope: !751)
!766 = !DILocation(line: 16, column: 24, scope: !751)
!767 = !DILocation(line: 17, column: 57, scope: !751)
!768 = !DILocation(line: 17, column: 31, scope: !751)
!769 = !DILocation(line: 18, column: 21, scope: !751)
!770 = !DILocation(line: 18, column: 25, scope: !751)
!771 = !DILocation(line: 17, column: 5, scope: !751)
!772 = !DILocation(line: 19, column: 1, scope: !751)
