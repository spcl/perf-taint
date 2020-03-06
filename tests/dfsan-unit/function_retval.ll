; RUN: opt %dfsan -S < %s 2> /dev/null | llc %llcparams - -o %t1 && clang++ %link %t1 -o %t2 && %execparams %t2 10 10 | diff -w %s.json -
; ModuleID = 'tests/dfsan-unit/function_retval.cpp'
source_filename = "tests/dfsan-unit/function_retval.cpp"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.test = type { i32, i32 }

$_ZN4test6lengthEv = comdat any

$_Z17register_variableIiEvPT_PKc = comdat any

$_ZN4testC2Eii = comdat any

@global = dso_local global i32 100, align 4, !dbg !0
@.str = private unnamed_addr constant [7 x i8] c"extrap\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [37 x i8] c"tests/dfsan-unit/function_retval.cpp\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [3 x i8] c"x1\00", align 1
@.str.3 = private unnamed_addr constant [3 x i8] c"x2\00", align 1
@.str.4 = private unnamed_addr constant [7 x i8] c"global\00", align 1
@llvm.global.annotations = appending global [1 x { i8*, i8*, i8*, i32 }] [{ i8*, i8*, i8*, i32 } { i8* bitcast (i32* @global to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([37 x i8], [37 x i8]* @.str.1, i32 0, i32 0), i32 7 }], section "llvm.metadata"

; Function Attrs: nounwind uwtable
define dso_local i32 @_Z1gii(i32, i32) #0 !dbg !594 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, i32* %3, align 4, !tbaa !600
  call void @llvm.dbg.declare(metadata i32* %3, metadata !598, metadata !DIExpression()), !dbg !604
  store i32 %1, i32* %4, align 4, !tbaa !600
  call void @llvm.dbg.declare(metadata i32* %4, metadata !599, metadata !DIExpression()), !dbg !605
  %5 = load i32, i32* %3, align 4, !dbg !606, !tbaa !600
  %6 = icmp ne i32 %5, 0, !dbg !606
  br i1 %6, label %7, label %10, !dbg !606

7:                                                ; preds = %2
  %8 = load i32, i32* %4, align 4, !dbg !607, !tbaa !600
  %9 = mul nsw i32 2, %8, !dbg !608
  br label %13, !dbg !606

10:                                               ; preds = %2
  %11 = load i32, i32* %4, align 4, !dbg !609, !tbaa !600
  %12 = add nsw i32 %11, 1, !dbg !610
  br label %13, !dbg !606

13:                                               ; preds = %10, %7
  %14 = phi i32 [ %9, %7 ], [ %12, %10 ], !dbg !606
  ret i32 %14, !dbg !611
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind uwtable
define dso_local i32 @_Z2g2ii(i32, i32) #0 !dbg !612 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, i32* %3, align 4, !tbaa !600
  call void @llvm.dbg.declare(metadata i32* %3, metadata !614, metadata !DIExpression()), !dbg !616
  store i32 %1, i32* %4, align 4, !tbaa !600
  call void @llvm.dbg.declare(metadata i32* %4, metadata !615, metadata !DIExpression()), !dbg !617
  %5 = load i32, i32* %3, align 4, !dbg !618, !tbaa !600
  %6 = load i32, i32* %4, align 4, !dbg !619, !tbaa !600
  %7 = add nsw i32 %5, %6, !dbg !620
  %8 = load i32, i32* @global, align 4, !dbg !621, !tbaa !600
  %9 = add nsw i32 %7, %8, !dbg !622
  ret i32 %9, !dbg !623
}

; Function Attrs: nounwind uwtable
define dso_local i32 @_Z1fii(i32, i32) #0 !dbg !624 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i32 %0, i32* %3, align 4, !tbaa !600
  call void @llvm.dbg.declare(metadata i32* %3, metadata !626, metadata !DIExpression()), !dbg !631
  store i32 %1, i32* %4, align 4, !tbaa !600
  call void @llvm.dbg.declare(metadata i32* %4, metadata !627, metadata !DIExpression()), !dbg !632
  %7 = bitcast i32* %5 to i8*, !dbg !633
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %7) #5, !dbg !633
  call void @llvm.dbg.declare(metadata i32* %5, metadata !628, metadata !DIExpression()), !dbg !634
  store i32 1, i32* %5, align 4, !dbg !634, !tbaa !600
  %8 = bitcast i32* %6 to i8*, !dbg !635
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %8) #5, !dbg !635
  call void @llvm.dbg.declare(metadata i32* %6, metadata !629, metadata !DIExpression()), !dbg !636
  store i32 0, i32* %6, align 4, !dbg !636, !tbaa !600
  br label %9, !dbg !635

9:                                                ; preds = %22, %2
  %10 = load i32, i32* %6, align 4, !dbg !637, !tbaa !600
  %11 = load i32, i32* %3, align 4, !dbg !639, !tbaa !600
  %12 = load i32, i32* %4, align 4, !dbg !640, !tbaa !600
  %13 = add nsw i32 %11, %12, !dbg !641
  %14 = call i32 @_Z1gii(i32 %13, i32 1), !dbg !642
  %15 = icmp slt i32 %10, %14, !dbg !643
  br i1 %15, label %18, label %16, !dbg !644

16:                                               ; preds = %9
  %17 = bitcast i32* %6 to i8*, !dbg !645
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %17) #5, !dbg !645
  br label %25

18:                                               ; preds = %9
  %19 = load i32, i32* %6, align 4, !dbg !646, !tbaa !600
  %20 = load i32, i32* %5, align 4, !dbg !648, !tbaa !600
  %21 = add nsw i32 %20, %19, !dbg !648
  store i32 %21, i32* %5, align 4, !dbg !648, !tbaa !600
  br label %22, !dbg !649

22:                                               ; preds = %18
  %23 = load i32, i32* %6, align 4, !dbg !650, !tbaa !600
  %24 = add nsw i32 %23, 1, !dbg !650
  store i32 %24, i32* %6, align 4, !dbg !650, !tbaa !600
  br label %9, !dbg !645, !llvm.loop !651

25:                                               ; preds = %16
  %26 = load i32, i32* %5, align 4, !dbg !653, !tbaa !600
  %27 = bitcast i32* %5 to i8*, !dbg !654
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %27) #5, !dbg !654
  ret i32 %26, !dbg !655
}

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: nounwind uwtable
define dso_local i32 @_Z1hii(i32, i32) #0 !dbg !656 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i32 %0, i32* %3, align 4, !tbaa !600
  call void @llvm.dbg.declare(metadata i32* %3, metadata !658, metadata !DIExpression()), !dbg !663
  store i32 %1, i32* %4, align 4, !tbaa !600
  call void @llvm.dbg.declare(metadata i32* %4, metadata !659, metadata !DIExpression()), !dbg !664
  %7 = bitcast i32* %5 to i8*, !dbg !665
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %7) #5, !dbg !665
  call void @llvm.dbg.declare(metadata i32* %5, metadata !660, metadata !DIExpression()), !dbg !666
  store i32 1, i32* %5, align 4, !dbg !666, !tbaa !600
  %8 = bitcast i32* %6 to i8*, !dbg !667
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %8) #5, !dbg !667
  call void @llvm.dbg.declare(metadata i32* %6, metadata !661, metadata !DIExpression()), !dbg !668
  store i32 0, i32* %6, align 4, !dbg !668, !tbaa !600
  br label %9, !dbg !667

9:                                                ; preds = %20, %2
  %10 = load i32, i32* %6, align 4, !dbg !669, !tbaa !600
  %11 = load i32, i32* %4, align 4, !dbg !671, !tbaa !600
  %12 = call i32 @_Z2g2ii(i32 %11, i32 1), !dbg !672
  %13 = icmp slt i32 %10, %12, !dbg !673
  br i1 %13, label %16, label %14, !dbg !674

14:                                               ; preds = %9
  %15 = bitcast i32* %6 to i8*, !dbg !675
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %15) #5, !dbg !675
  br label %23

16:                                               ; preds = %9
  %17 = load i32, i32* %6, align 4, !dbg !676, !tbaa !600
  %18 = load i32, i32* %5, align 4, !dbg !678, !tbaa !600
  %19 = add nsw i32 %18, %17, !dbg !678
  store i32 %19, i32* %5, align 4, !dbg !678, !tbaa !600
  br label %20, !dbg !679

20:                                               ; preds = %16
  %21 = load i32, i32* %6, align 4, !dbg !680, !tbaa !600
  %22 = add nsw i32 %21, 1, !dbg !680
  store i32 %22, i32* %6, align 4, !dbg !680, !tbaa !600
  br label %9, !dbg !675, !llvm.loop !681

23:                                               ; preds = %14
  %24 = load i32, i32* %5, align 4, !dbg !683, !tbaa !600
  %25 = bitcast i32* %5 to i8*, !dbg !684
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %25) #5, !dbg !684
  ret i32 %24, !dbg !685
}

; Function Attrs: uwtable
define dso_local i32 @_Z1iP4test(%struct.test*) #3 !dbg !686 {
  %2 = alloca %struct.test*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store %struct.test* %0, %struct.test** %2, align 8, !tbaa !706
  call void @llvm.dbg.declare(metadata %struct.test** %2, metadata !702, metadata !DIExpression()), !dbg !708
  %5 = bitcast i32* %3 to i8*, !dbg !709
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %5) #5, !dbg !709
  call void @llvm.dbg.declare(metadata i32* %3, metadata !703, metadata !DIExpression()), !dbg !710
  store i32 1, i32* %3, align 4, !dbg !710, !tbaa !600
  %6 = bitcast i32* %4 to i8*, !dbg !711
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %6) #5, !dbg !711
  call void @llvm.dbg.declare(metadata i32* %4, metadata !704, metadata !DIExpression()), !dbg !712
  store i32 0, i32* %4, align 4, !dbg !712, !tbaa !600
  br label %7, !dbg !711

7:                                                ; preds = %18, %1
  %8 = load i32, i32* %4, align 4, !dbg !713, !tbaa !600
  %9 = load %struct.test*, %struct.test** %2, align 8, !dbg !715, !tbaa !706
  %10 = call i32 @_ZN4test6lengthEv(%struct.test* %9), !dbg !716
  %11 = icmp slt i32 %8, %10, !dbg !717
  br i1 %11, label %14, label %12, !dbg !718

12:                                               ; preds = %7
  %13 = bitcast i32* %4 to i8*, !dbg !719
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %13) #5, !dbg !719
  br label %21

14:                                               ; preds = %7
  %15 = load i32, i32* %4, align 4, !dbg !720, !tbaa !600
  %16 = load i32, i32* %3, align 4, !dbg !722, !tbaa !600
  %17 = add nsw i32 %16, %15, !dbg !722
  store i32 %17, i32* %3, align 4, !dbg !722, !tbaa !600
  br label %18, !dbg !723

18:                                               ; preds = %14
  %19 = load i32, i32* %4, align 4, !dbg !724, !tbaa !600
  %20 = add nsw i32 %19, 1, !dbg !724
  store i32 %20, i32* %4, align 4, !dbg !724, !tbaa !600
  br label %7, !dbg !719, !llvm.loop !725

21:                                               ; preds = %12
  %22 = load i32, i32* %3, align 4, !dbg !727, !tbaa !600
  %23 = bitcast i32* %3 to i8*, !dbg !728
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %23) #5, !dbg !728
  ret i32 %22, !dbg !729
}

; Function Attrs: nounwind uwtable
define linkonce_odr dso_local i32 @_ZN4test6lengthEv(%struct.test*) #0 comdat align 2 !dbg !730 {
  %2 = alloca %struct.test*, align 8
  store %struct.test* %0, %struct.test** %2, align 8, !tbaa !706
  call void @llvm.dbg.declare(metadata %struct.test** %2, metadata !732, metadata !DIExpression()), !dbg !733
  %3 = load %struct.test*, %struct.test** %2, align 8
  %4 = getelementptr inbounds %struct.test, %struct.test* %3, i32 0, i32 0, !dbg !734
  %5 = load i32, i32* %4, align 4, !dbg !734, !tbaa !735
  ret i32 %5, !dbg !737
}

; Function Attrs: norecurse uwtable
define dso_local i32 @main(i32, i8**) #4 !dbg !738 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca %struct.test, align 4
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4, !tbaa !600
  call void @llvm.dbg.declare(metadata i32* %4, metadata !742, metadata !DIExpression()), !dbg !748
  store i8** %1, i8*** %5, align 8, !tbaa !706
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !743, metadata !DIExpression()), !dbg !749
  %10 = bitcast i32* %6 to i8*, !dbg !750
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %10) #5, !dbg !750
  call void @llvm.dbg.declare(metadata i32* %6, metadata !744, metadata !DIExpression()), !dbg !751
  %11 = bitcast i32* %6 to i8*, !dbg !750
  call void @llvm.var.annotation(i8* %11, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([37 x i8], [37 x i8]* @.str.1, i32 0, i32 0), i32 70), !dbg !750
  %12 = load i8**, i8*** %5, align 8, !dbg !752, !tbaa !706
  %13 = getelementptr inbounds i8*, i8** %12, i64 1, !dbg !752
  %14 = load i8*, i8** %13, align 8, !dbg !752, !tbaa !706
  %15 = call i32 @atoi(i8* %14) #9, !dbg !753
  store i32 %15, i32* %6, align 4, !dbg !751, !tbaa !600
  %16 = bitcast i32* %7 to i8*, !dbg !754
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %16) #5, !dbg !754
  call void @llvm.dbg.declare(metadata i32* %7, metadata !745, metadata !DIExpression()), !dbg !755
  %17 = bitcast i32* %7 to i8*, !dbg !754
  call void @llvm.var.annotation(i8* %17, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([37 x i8], [37 x i8]* @.str.1, i32 0, i32 0), i32 71), !dbg !754
  %18 = load i8**, i8*** %5, align 8, !dbg !756, !tbaa !706
  %19 = getelementptr inbounds i8*, i8** %18, i64 2, !dbg !756
  %20 = load i8*, i8** %19, align 8, !dbg !756, !tbaa !706
  %21 = call i32 @atoi(i8* %20) #9, !dbg !757
  store i32 %21, i32* %7, align 4, !dbg !755, !tbaa !600
  call void @_Z17register_variableIiEvPT_PKc(i32* %6, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.2, i64 0, i64 0)), !dbg !758
  call void @_Z17register_variableIiEvPT_PKc(i32* %7, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.3, i64 0, i64 0)), !dbg !759
  call void @_Z17register_variableIiEvPT_PKc(i32* @global, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.4, i64 0, i64 0)), !dbg !760
  %22 = bitcast i32* %8 to i8*, !dbg !761
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %22) #5, !dbg !761
  call void @llvm.dbg.declare(metadata i32* %8, metadata !746, metadata !DIExpression()), !dbg !762
  %23 = load i32, i32* %6, align 4, !dbg !763, !tbaa !600
  %24 = mul nsw i32 2, %23, !dbg !764
  %25 = add nsw i32 %24, 1, !dbg !765
  store i32 %25, i32* %8, align 4, !dbg !762, !tbaa !600
  %26 = bitcast %struct.test* %9 to i8*, !dbg !766
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %26) #5, !dbg !766
  call void @llvm.dbg.declare(metadata %struct.test* %9, metadata !747, metadata !DIExpression()), !dbg !767
  %27 = load i32, i32* %6, align 4, !dbg !768, !tbaa !600
  %28 = load i32, i32* %7, align 4, !dbg !769, !tbaa !600
  call void @_ZN4testC2Eii(%struct.test* %9, i32 %27, i32 %28), !dbg !767
  %29 = load i32, i32* @global, align 4, !dbg !770, !tbaa !600
  %30 = load i32, i32* %6, align 4, !dbg !771, !tbaa !600
  %31 = call i32 @_Z1fii(i32 %29, i32 %30), !dbg !772
  %32 = load i32, i32* %6, align 4, !dbg !773, !tbaa !600
  %33 = load i32, i32* %7, align 4, !dbg !774, !tbaa !600
  %34 = add nsw i32 %32, %33, !dbg !775
  %35 = call i32 @_Z1fii(i32 %34, i32 2), !dbg !776
  %36 = load i32, i32* %6, align 4, !dbg !777, !tbaa !600
  %37 = call i32 @_Z1hii(i32 %36, i32 10), !dbg !778
  %38 = call i32 @_Z1hii(i32 10, i32 10), !dbg !779
  %39 = call i32 @_Z1iP4test(%struct.test* %9), !dbg !780
  %40 = bitcast %struct.test* %9 to i8*, !dbg !781
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %40) #5, !dbg !781
  %41 = bitcast i32* %8 to i8*, !dbg !781
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %41) #5, !dbg !781
  %42 = bitcast i32* %7 to i8*, !dbg !781
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %42) #5, !dbg !781
  %43 = bitcast i32* %6 to i8*, !dbg !781
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %43) #5, !dbg !781
  ret i32 0, !dbg !782
}

; Function Attrs: nounwind
declare void @llvm.var.annotation(i8*, i8*, i8*, i32) #5

; Function Attrs: inlinehint nounwind readonly uwtable
define available_externally dso_local i32 @atoi(i8* nonnull) #6 !dbg !364 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8, !tbaa !706
  call void @llvm.dbg.declare(metadata i8** %2, metadata !368, metadata !DIExpression()), !dbg !783
  %3 = load i8*, i8** %2, align 8, !dbg !784, !tbaa !706
  %4 = call i64 @strtol(i8* %3, i8** null, i32 10) #5, !dbg !785
  %5 = trunc i64 %4 to i32, !dbg !785
  ret i32 %5, !dbg !786
}

; Function Attrs: uwtable
define linkonce_odr dso_local void @_Z17register_variableIiEvPT_PKc(i32*, i8*) #3 comdat !dbg !787 {
  %3 = alloca i32*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca i32, align 4
  store i32* %0, i32** %3, align 8, !tbaa !706
  call void @llvm.dbg.declare(metadata i32** %3, metadata !792, metadata !DIExpression()), !dbg !797
  store i8* %1, i8** %4, align 8, !tbaa !706
  call void @llvm.dbg.declare(metadata i8** %4, metadata !793, metadata !DIExpression()), !dbg !798
  %6 = bitcast i32* %5 to i8*, !dbg !799
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %6) #5, !dbg !799
  call void @llvm.dbg.declare(metadata i32* %5, metadata !794, metadata !DIExpression()), !dbg !800
  %7 = call i32 @__dfsw_EXTRAP_VAR_ID(), !dbg !801
  store i32 %7, i32* %5, align 4, !dbg !800, !tbaa !600
  %8 = load i32*, i32** %3, align 8, !dbg !802, !tbaa !706
  %9 = bitcast i32* %8 to i8*, !dbg !803
  %10 = load i32, i32* %5, align 4, !dbg !804, !tbaa !600
  %11 = add nsw i32 %10, 1, !dbg !804
  store i32 %11, i32* %5, align 4, !dbg !804, !tbaa !600
  %12 = load i8*, i8** %4, align 8, !dbg !805, !tbaa !706
  call void @__dfsw_EXTRAP_STORE_LABEL(i8* %9, i32 4, i32 %10, i8* %12), !dbg !806
  %13 = bitcast i32* %5 to i8*, !dbg !807
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %13) #5, !dbg !807
  ret void, !dbg !807
}

; Function Attrs: nounwind uwtable
define linkonce_odr dso_local void @_ZN4testC2Eii(%struct.test*, i32, i32) unnamed_addr #0 comdat align 2 !dbg !808 {
  %4 = alloca %struct.test*, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store %struct.test* %0, %struct.test** %4, align 8, !tbaa !706
  call void @llvm.dbg.declare(metadata %struct.test** %4, metadata !810, metadata !DIExpression()), !dbg !813
  store i32 %1, i32* %5, align 4, !tbaa !600
  call void @llvm.dbg.declare(metadata i32* %5, metadata !811, metadata !DIExpression()), !dbg !814
  store i32 %2, i32* %6, align 4, !tbaa !600
  call void @llvm.dbg.declare(metadata i32* %6, metadata !812, metadata !DIExpression()), !dbg !815
  %7 = load %struct.test*, %struct.test** %4, align 8
  %8 = getelementptr inbounds %struct.test, %struct.test* %7, i32 0, i32 0, !dbg !816
  %9 = load i32, i32* %5, align 4, !dbg !817, !tbaa !600
  store i32 %9, i32* %8, align 4, !dbg !816, !tbaa !735
  %10 = getelementptr inbounds %struct.test, %struct.test* %7, i32 0, i32 1, !dbg !818
  %11 = load i32, i32* %6, align 4, !dbg !819, !tbaa !600
  store i32 %11, i32* %10, align 4, !dbg !818, !tbaa !820
  ret void, !dbg !821
}

; Function Attrs: nounwind
declare dso_local i64 @strtol(i8*, i8**, i32) #7

declare dso_local i32 @__dfsw_EXTRAP_VAR_ID() #8

declare dso_local void @__dfsw_EXTRAP_STORE_LABEL(i8*, i32, i32, i8*) #8

attributes #0 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { argmemonly nounwind }
attributes #3 = { uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { norecurse uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { nounwind }
attributes #6 = { inlinehint nounwind readonly uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #7 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #8 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #9 = { nounwind readonly }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!590, !591, !592}
!llvm.ident = !{!593}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "global", scope: !2, file: !3, line: 7, type: !6, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !3, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !5, globals: !16, imports: !17, nameTableKind: None)
!3 = !DIFile(filename: "tests/dfsan-unit/function_retval.cpp", directory: "/home/mcopik/projects/ETH/extrap/rebuild/perf-taint")
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
!17 = !{!18, !25, !28, !32, !40, !42, !46, !49, !53, !58, !60, !62, !66, !68, !70, !72, !74, !76, !78, !80, !85, !89, !91, !93, !98, !103, !105, !107, !109, !111, !113, !115, !117, !119, !121, !123, !125, !127, !129, !131, !133, !135, !139, !141, !143, !145, !149, !151, !156, !158, !160, !162, !164, !168, !170, !176, !180, !182, !184, !188, !190, !194, !196, !198, !202, !204, !206, !208, !210, !212, !214, !218, !220, !222, !224, !226, !228, !230, !232, !236, !240, !242, !244, !246, !248, !250, !252, !254, !256, !258, !260, !262, !264, !266, !268, !270, !272, !274, !276, !278, !282, !284, !286, !288, !292, !294, !298, !300, !302, !304, !306, !310, !312, !316, !318, !320, !322, !324, !328, !330, !332, !336, !338, !340, !342, !344, !348, !354, !360, !363, !369, !373, !377, !383, !387, !391, !395, !399, !403, !408, !412, !417, !422, !426, !430, !434, !438, !443, !447, !449, !453, !455, !466, !470, !471, !475, !479, !483, !487, !489, !493, !500, !504, !508, !516, !518, !520, !522, !526, !529, !532, !537, !541, !544, !547, !550, !552, !554, !556, !558, !560, !562, !564, !566, !568, !570, !572, !574, !576, !578, !580, !582, !584, !587}
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
!32 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !33, file: !39, line: 316)
!33 = !DISubprogram(name: "isinf", linkageName: "_Z5isinfe", scope: !34, file: !34, line: 499, type: !35, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!34 = !DIFile(filename: "build_tool/../usr/include/c++/v1/math.h", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!35 = !DISubroutineType(types: !36)
!36 = !{!37, !38}
!37 = !DIBasicType(name: "bool", size: 8, encoding: DW_ATE_boolean)
!38 = !DIBasicType(name: "long double", size: 128, encoding: DW_ATE_float)
!39 = !DIFile(filename: "build_tool/../usr/include/c++/v1/cmath", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!40 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !41, file: !39, line: 317)
!41 = !DISubprogram(name: "isnan", linkageName: "_Z5isnane", scope: !34, file: !34, line: 543, type: !35, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!42 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !43, file: !39, line: 327)
!43 = !DIDerivedType(tag: DW_TAG_typedef, name: "float_t", file: !44, line: 149, baseType: !45)
!44 = !DIFile(filename: "/usr/include/math.h", directory: "")
!45 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!46 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !47, file: !39, line: 328)
!47 = !DIDerivedType(tag: DW_TAG_typedef, name: "double_t", file: !44, line: 150, baseType: !48)
!48 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!49 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !50, file: !39, line: 331)
!50 = !DISubprogram(name: "abs", linkageName: "_Z3abse", scope: !34, file: !34, line: 789, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!51 = !DISubroutineType(types: !52)
!52 = !{!38, !38}
!53 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !54, file: !39, line: 335)
!54 = !DISubprogram(name: "acosf", scope: !55, file: !55, line: 53, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!55 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/mathcalls.h", directory: "")
!56 = !DISubroutineType(types: !57)
!57 = !{!45, !45}
!58 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !59, file: !39, line: 337)
!59 = !DISubprogram(name: "asinf", scope: !55, file: !55, line: 55, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!60 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !61, file: !39, line: 339)
!61 = !DISubprogram(name: "atanf", scope: !55, file: !55, line: 57, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!62 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !63, file: !39, line: 341)
!63 = !DISubprogram(name: "atan2f", scope: !55, file: !55, line: 59, type: !64, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!64 = !DISubroutineType(types: !65)
!65 = !{!45, !45, !45}
!66 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !67, file: !39, line: 343)
!67 = !DISubprogram(name: "ceilf", scope: !55, file: !55, line: 159, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!68 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !69, file: !39, line: 345)
!69 = !DISubprogram(name: "cosf", scope: !55, file: !55, line: 62, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!70 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !71, file: !39, line: 347)
!71 = !DISubprogram(name: "coshf", scope: !55, file: !55, line: 71, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!72 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !73, file: !39, line: 350)
!73 = !DISubprogram(name: "expf", scope: !55, file: !55, line: 95, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!74 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !75, file: !39, line: 353)
!75 = !DISubprogram(name: "fabsf", scope: !55, file: !55, line: 162, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!76 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !77, file: !39, line: 355)
!77 = !DISubprogram(name: "floorf", scope: !55, file: !55, line: 165, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!78 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !79, file: !39, line: 358)
!79 = !DISubprogram(name: "fmodf", scope: !55, file: !55, line: 168, type: !64, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!80 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !81, file: !39, line: 361)
!81 = !DISubprogram(name: "frexpf", scope: !55, file: !55, line: 98, type: !82, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!82 = !DISubroutineType(types: !83)
!83 = !{!45, !45, !84}
!84 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !6, size: 64)
!85 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !86, file: !39, line: 363)
!86 = !DISubprogram(name: "ldexpf", scope: !55, file: !55, line: 101, type: !87, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!87 = !DISubroutineType(types: !88)
!88 = !{!45, !45, !6}
!89 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !90, file: !39, line: 366)
!90 = !DISubprogram(name: "logf", scope: !55, file: !55, line: 104, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!91 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !92, file: !39, line: 369)
!92 = !DISubprogram(name: "log10f", scope: !55, file: !55, line: 107, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!93 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !94, file: !39, line: 370)
!94 = !DISubprogram(name: "modf", linkageName: "_Z4modfePe", scope: !34, file: !34, line: 1021, type: !95, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!95 = !DISubroutineType(types: !96)
!96 = !{!38, !38, !97}
!97 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !38, size: 64)
!98 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !99, file: !39, line: 371)
!99 = !DISubprogram(name: "modff", scope: !55, file: !55, line: 110, type: !100, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!100 = !DISubroutineType(types: !101)
!101 = !{!45, !45, !102}
!102 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !45, size: 64)
!103 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !104, file: !39, line: 374)
!104 = !DISubprogram(name: "powf", scope: !55, file: !55, line: 140, type: !64, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!105 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !106, file: !39, line: 377)
!106 = !DISubprogram(name: "sinf", scope: !55, file: !55, line: 64, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!107 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !108, file: !39, line: 379)
!108 = !DISubprogram(name: "sinhf", scope: !55, file: !55, line: 73, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!109 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !110, file: !39, line: 382)
!110 = !DISubprogram(name: "sqrtf", scope: !55, file: !55, line: 143, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!111 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !112, file: !39, line: 384)
!112 = !DISubprogram(name: "tanf", scope: !55, file: !55, line: 66, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!113 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !114, file: !39, line: 387)
!114 = !DISubprogram(name: "tanhf", scope: !55, file: !55, line: 75, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!115 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !116, file: !39, line: 390)
!116 = !DISubprogram(name: "acoshf", scope: !55, file: !55, line: 85, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!117 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !118, file: !39, line: 392)
!118 = !DISubprogram(name: "asinhf", scope: !55, file: !55, line: 87, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!119 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !120, file: !39, line: 394)
!120 = !DISubprogram(name: "atanhf", scope: !55, file: !55, line: 89, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!121 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !122, file: !39, line: 396)
!122 = !DISubprogram(name: "cbrtf", scope: !55, file: !55, line: 152, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!123 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !124, file: !39, line: 399)
!124 = !DISubprogram(name: "copysignf", scope: !55, file: !55, line: 196, type: !64, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!125 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !126, file: !39, line: 402)
!126 = !DISubprogram(name: "erff", scope: !55, file: !55, line: 228, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!127 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !128, file: !39, line: 404)
!128 = !DISubprogram(name: "erfcf", scope: !55, file: !55, line: 229, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!129 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !130, file: !39, line: 406)
!130 = !DISubprogram(name: "exp2f", scope: !55, file: !55, line: 130, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!131 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !132, file: !39, line: 408)
!132 = !DISubprogram(name: "expm1f", scope: !55, file: !55, line: 119, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!133 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !134, file: !39, line: 410)
!134 = !DISubprogram(name: "fdimf", scope: !55, file: !55, line: 326, type: !64, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!135 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !136, file: !39, line: 411)
!136 = !DISubprogram(name: "fmaf", scope: !55, file: !55, line: 335, type: !137, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!137 = !DISubroutineType(types: !138)
!138 = !{!45, !45, !45, !45}
!139 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !140, file: !39, line: 414)
!140 = !DISubprogram(name: "fmaxf", scope: !55, file: !55, line: 329, type: !64, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!141 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !142, file: !39, line: 416)
!142 = !DISubprogram(name: "fminf", scope: !55, file: !55, line: 332, type: !64, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!143 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !144, file: !39, line: 418)
!144 = !DISubprogram(name: "hypotf", scope: !55, file: !55, line: 147, type: !64, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!145 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !146, file: !39, line: 420)
!146 = !DISubprogram(name: "ilogbf", scope: !55, file: !55, line: 280, type: !147, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!147 = !DISubroutineType(types: !148)
!148 = !{!6, !45}
!149 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !150, file: !39, line: 422)
!150 = !DISubprogram(name: "lgammaf", scope: !55, file: !55, line: 230, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!151 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !152, file: !39, line: 424)
!152 = !DISubprogram(name: "llrintf", scope: !55, file: !55, line: 316, type: !153, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!153 = !DISubroutineType(types: !154)
!154 = !{!155, !45}
!155 = !DIBasicType(name: "long long int", size: 64, encoding: DW_ATE_signed)
!156 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !157, file: !39, line: 426)
!157 = !DISubprogram(name: "llroundf", scope: !55, file: !55, line: 322, type: !153, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!158 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !159, file: !39, line: 428)
!159 = !DISubprogram(name: "log1pf", scope: !55, file: !55, line: 122, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!160 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !161, file: !39, line: 430)
!161 = !DISubprogram(name: "log2f", scope: !55, file: !55, line: 133, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!162 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !163, file: !39, line: 432)
!163 = !DISubprogram(name: "logbf", scope: !55, file: !55, line: 125, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!164 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !165, file: !39, line: 434)
!165 = !DISubprogram(name: "lrintf", scope: !55, file: !55, line: 314, type: !166, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!166 = !DISubroutineType(types: !167)
!167 = !{!23, !45}
!168 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !169, file: !39, line: 436)
!169 = !DISubprogram(name: "lroundf", scope: !55, file: !55, line: 320, type: !166, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!170 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !171, file: !39, line: 438)
!171 = !DISubprogram(name: "nan", scope: !55, file: !55, line: 201, type: !172, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!172 = !DISubroutineType(types: !173)
!173 = !{!48, !174}
!174 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !175, size: 64)
!175 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !9)
!176 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !177, file: !39, line: 439)
!177 = !DISubprogram(name: "nanf", scope: !55, file: !55, line: 201, type: !178, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!178 = !DISubroutineType(types: !179)
!179 = !{!45, !174}
!180 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !181, file: !39, line: 442)
!181 = !DISubprogram(name: "nearbyintf", scope: !55, file: !55, line: 294, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!182 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !183, file: !39, line: 444)
!183 = !DISubprogram(name: "nextafterf", scope: !55, file: !55, line: 259, type: !64, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!184 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !185, file: !39, line: 446)
!185 = !DISubprogram(name: "nexttowardf", scope: !55, file: !55, line: 261, type: !186, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!186 = !DISubroutineType(types: !187)
!187 = !{!45, !45, !38}
!188 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !189, file: !39, line: 448)
!189 = !DISubprogram(name: "remainderf", scope: !55, file: !55, line: 272, type: !64, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!190 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !191, file: !39, line: 450)
!191 = !DISubprogram(name: "remquof", scope: !55, file: !55, line: 307, type: !192, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!192 = !DISubroutineType(types: !193)
!193 = !{!45, !45, !45, !84}
!194 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !195, file: !39, line: 452)
!195 = !DISubprogram(name: "rintf", scope: !55, file: !55, line: 256, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!196 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !197, file: !39, line: 454)
!197 = !DISubprogram(name: "roundf", scope: !55, file: !55, line: 298, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!198 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !199, file: !39, line: 456)
!199 = !DISubprogram(name: "scalblnf", scope: !55, file: !55, line: 290, type: !200, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!200 = !DISubroutineType(types: !201)
!201 = !{!45, !45, !23}
!202 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !203, file: !39, line: 458)
!203 = !DISubprogram(name: "scalbnf", scope: !55, file: !55, line: 276, type: !87, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!204 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !205, file: !39, line: 460)
!205 = !DISubprogram(name: "tgammaf", scope: !55, file: !55, line: 235, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!206 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !207, file: !39, line: 462)
!207 = !DISubprogram(name: "truncf", scope: !55, file: !55, line: 302, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!208 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !209, file: !39, line: 464)
!209 = !DISubprogram(name: "acosl", scope: !55, file: !55, line: 53, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!210 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !211, file: !39, line: 465)
!211 = !DISubprogram(name: "asinl", scope: !55, file: !55, line: 55, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!212 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !213, file: !39, line: 466)
!213 = !DISubprogram(name: "atanl", scope: !55, file: !55, line: 57, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!214 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !215, file: !39, line: 467)
!215 = !DISubprogram(name: "atan2l", scope: !55, file: !55, line: 59, type: !216, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!216 = !DISubroutineType(types: !217)
!217 = !{!38, !38, !38}
!218 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !219, file: !39, line: 468)
!219 = !DISubprogram(name: "ceill", scope: !55, file: !55, line: 159, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!220 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !221, file: !39, line: 469)
!221 = !DISubprogram(name: "cosl", scope: !55, file: !55, line: 62, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!222 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !223, file: !39, line: 470)
!223 = !DISubprogram(name: "coshl", scope: !55, file: !55, line: 71, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!224 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !225, file: !39, line: 471)
!225 = !DISubprogram(name: "expl", scope: !55, file: !55, line: 95, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!226 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !227, file: !39, line: 472)
!227 = !DISubprogram(name: "fabsl", scope: !55, file: !55, line: 162, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!228 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !229, file: !39, line: 473)
!229 = !DISubprogram(name: "floorl", scope: !55, file: !55, line: 165, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!230 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !231, file: !39, line: 474)
!231 = !DISubprogram(name: "fmodl", scope: !55, file: !55, line: 168, type: !216, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!232 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !233, file: !39, line: 475)
!233 = !DISubprogram(name: "frexpl", scope: !55, file: !55, line: 98, type: !234, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!234 = !DISubroutineType(types: !235)
!235 = !{!38, !38, !84}
!236 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !237, file: !39, line: 476)
!237 = !DISubprogram(name: "ldexpl", scope: !55, file: !55, line: 101, type: !238, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!238 = !DISubroutineType(types: !239)
!239 = !{!38, !38, !6}
!240 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !241, file: !39, line: 477)
!241 = !DISubprogram(name: "logl", scope: !55, file: !55, line: 104, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!242 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !243, file: !39, line: 478)
!243 = !DISubprogram(name: "log10l", scope: !55, file: !55, line: 107, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!244 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !245, file: !39, line: 479)
!245 = !DISubprogram(name: "modfl", scope: !55, file: !55, line: 110, type: !95, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!246 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !247, file: !39, line: 480)
!247 = !DISubprogram(name: "powl", scope: !55, file: !55, line: 140, type: !216, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!248 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !249, file: !39, line: 481)
!249 = !DISubprogram(name: "sinl", scope: !55, file: !55, line: 64, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!250 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !251, file: !39, line: 482)
!251 = !DISubprogram(name: "sinhl", scope: !55, file: !55, line: 73, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!252 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !253, file: !39, line: 483)
!253 = !DISubprogram(name: "sqrtl", scope: !55, file: !55, line: 143, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!254 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !255, file: !39, line: 484)
!255 = !DISubprogram(name: "tanl", scope: !55, file: !55, line: 66, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!256 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !257, file: !39, line: 486)
!257 = !DISubprogram(name: "tanhl", scope: !55, file: !55, line: 75, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!258 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !259, file: !39, line: 487)
!259 = !DISubprogram(name: "acoshl", scope: !55, file: !55, line: 85, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!260 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !261, file: !39, line: 488)
!261 = !DISubprogram(name: "asinhl", scope: !55, file: !55, line: 87, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!262 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !263, file: !39, line: 489)
!263 = !DISubprogram(name: "atanhl", scope: !55, file: !55, line: 89, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!264 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !265, file: !39, line: 490)
!265 = !DISubprogram(name: "cbrtl", scope: !55, file: !55, line: 152, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!266 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !267, file: !39, line: 492)
!267 = !DISubprogram(name: "copysignl", scope: !55, file: !55, line: 196, type: !216, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!268 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !269, file: !39, line: 494)
!269 = !DISubprogram(name: "erfl", scope: !55, file: !55, line: 228, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!270 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !271, file: !39, line: 495)
!271 = !DISubprogram(name: "erfcl", scope: !55, file: !55, line: 229, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!272 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !273, file: !39, line: 496)
!273 = !DISubprogram(name: "exp2l", scope: !55, file: !55, line: 130, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!274 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !275, file: !39, line: 497)
!275 = !DISubprogram(name: "expm1l", scope: !55, file: !55, line: 119, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!276 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !277, file: !39, line: 498)
!277 = !DISubprogram(name: "fdiml", scope: !55, file: !55, line: 326, type: !216, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!278 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !279, file: !39, line: 499)
!279 = !DISubprogram(name: "fmal", scope: !55, file: !55, line: 335, type: !280, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!280 = !DISubroutineType(types: !281)
!281 = !{!38, !38, !38, !38}
!282 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !283, file: !39, line: 500)
!283 = !DISubprogram(name: "fmaxl", scope: !55, file: !55, line: 329, type: !216, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!284 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !285, file: !39, line: 501)
!285 = !DISubprogram(name: "fminl", scope: !55, file: !55, line: 332, type: !216, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!286 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !287, file: !39, line: 502)
!287 = !DISubprogram(name: "hypotl", scope: !55, file: !55, line: 147, type: !216, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!288 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !289, file: !39, line: 503)
!289 = !DISubprogram(name: "ilogbl", scope: !55, file: !55, line: 280, type: !290, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!290 = !DISubroutineType(types: !291)
!291 = !{!6, !38}
!292 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !293, file: !39, line: 504)
!293 = !DISubprogram(name: "lgammal", scope: !55, file: !55, line: 230, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!294 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !295, file: !39, line: 505)
!295 = !DISubprogram(name: "llrintl", scope: !55, file: !55, line: 316, type: !296, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!296 = !DISubroutineType(types: !297)
!297 = !{!155, !38}
!298 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !299, file: !39, line: 506)
!299 = !DISubprogram(name: "llroundl", scope: !55, file: !55, line: 322, type: !296, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!300 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !301, file: !39, line: 507)
!301 = !DISubprogram(name: "log1pl", scope: !55, file: !55, line: 122, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!302 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !303, file: !39, line: 508)
!303 = !DISubprogram(name: "log2l", scope: !55, file: !55, line: 133, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!304 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !305, file: !39, line: 509)
!305 = !DISubprogram(name: "logbl", scope: !55, file: !55, line: 125, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!306 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !307, file: !39, line: 510)
!307 = !DISubprogram(name: "lrintl", scope: !55, file: !55, line: 314, type: !308, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!308 = !DISubroutineType(types: !309)
!309 = !{!23, !38}
!310 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !311, file: !39, line: 511)
!311 = !DISubprogram(name: "lroundl", scope: !55, file: !55, line: 320, type: !308, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!312 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !313, file: !39, line: 512)
!313 = !DISubprogram(name: "nanl", scope: !55, file: !55, line: 201, type: !314, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!314 = !DISubroutineType(types: !315)
!315 = !{!38, !174}
!316 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !317, file: !39, line: 513)
!317 = !DISubprogram(name: "nearbyintl", scope: !55, file: !55, line: 294, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!318 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !319, file: !39, line: 514)
!319 = !DISubprogram(name: "nextafterl", scope: !55, file: !55, line: 259, type: !216, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!320 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !321, file: !39, line: 515)
!321 = !DISubprogram(name: "nexttowardl", scope: !55, file: !55, line: 261, type: !216, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!322 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !323, file: !39, line: 516)
!323 = !DISubprogram(name: "remainderl", scope: !55, file: !55, line: 272, type: !216, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!324 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !325, file: !39, line: 517)
!325 = !DISubprogram(name: "remquol", scope: !55, file: !55, line: 307, type: !326, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!326 = !DISubroutineType(types: !327)
!327 = !{!38, !38, !38, !84}
!328 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !329, file: !39, line: 518)
!329 = !DISubprogram(name: "rintl", scope: !55, file: !55, line: 256, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!330 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !331, file: !39, line: 519)
!331 = !DISubprogram(name: "roundl", scope: !55, file: !55, line: 298, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!332 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !333, file: !39, line: 520)
!333 = !DISubprogram(name: "scalblnl", scope: !55, file: !55, line: 290, type: !334, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!334 = !DISubroutineType(types: !335)
!335 = !{!38, !38, !23}
!336 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !337, file: !39, line: 521)
!337 = !DISubprogram(name: "scalbnl", scope: !55, file: !55, line: 276, type: !238, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!338 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !339, file: !39, line: 522)
!339 = !DISubprogram(name: "tgammal", scope: !55, file: !55, line: 235, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!340 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !341, file: !39, line: 523)
!341 = !DISubprogram(name: "truncl", scope: !55, file: !55, line: 302, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!342 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !26, file: !343, line: 99)
!343 = !DIFile(filename: "build_tool/../usr/include/c++/v1/cstdlib", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!344 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !345, file: !343, line: 100)
!345 = !DIDerivedType(tag: DW_TAG_typedef, name: "div_t", file: !346, line: 62, baseType: !347)
!346 = !DIFile(filename: "/usr/include/stdlib.h", directory: "")
!347 = !DICompositeType(tag: DW_TAG_structure_type, file: !346, line: 58, flags: DIFlagFwdDecl, identifier: "_ZTS5div_t")
!348 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !349, file: !343, line: 101)
!349 = !DIDerivedType(tag: DW_TAG_typedef, name: "ldiv_t", file: !346, line: 70, baseType: !350)
!350 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !346, line: 66, size: 128, flags: DIFlagTypePassByValue, elements: !351, identifier: "_ZTS6ldiv_t")
!351 = !{!352, !353}
!352 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !350, file: !346, line: 68, baseType: !23, size: 64)
!353 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !350, file: !346, line: 69, baseType: !23, size: 64, offset: 64)
!354 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !355, file: !343, line: 103)
!355 = !DIDerivedType(tag: DW_TAG_typedef, name: "lldiv_t", file: !346, line: 80, baseType: !356)
!356 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !346, line: 76, size: 128, flags: DIFlagTypePassByValue, elements: !357, identifier: "_ZTS7lldiv_t")
!357 = !{!358, !359}
!358 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !356, file: !346, line: 78, baseType: !155, size: 64)
!359 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !356, file: !346, line: 79, baseType: !155, size: 64, offset: 64)
!360 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !361, file: !343, line: 105)
!361 = !DISubprogram(name: "atof", scope: !362, file: !362, line: 25, type: !172, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!362 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdlib-float.h", directory: "")
!363 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !364, file: !343, line: 106)
!364 = distinct !DISubprogram(name: "atoi", scope: !346, file: !346, line: 361, type: !365, scopeLine: 362, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !367)
!365 = !DISubroutineType(types: !366)
!366 = !{!6, !174}
!367 = !{!368}
!368 = !DILocalVariable(name: "__nptr", arg: 1, scope: !364, file: !346, line: 361, type: !174)
!369 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !370, file: !343, line: 107)
!370 = !DISubprogram(name: "atol", scope: !346, file: !346, line: 366, type: !371, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!371 = !DISubroutineType(types: !372)
!372 = !{!23, !174}
!373 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !374, file: !343, line: 109)
!374 = !DISubprogram(name: "atoll", scope: !346, file: !346, line: 373, type: !375, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!375 = !DISubroutineType(types: !376)
!376 = !{!155, !174}
!377 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !378, file: !343, line: 111)
!378 = !DISubprogram(name: "strtod", scope: !346, file: !346, line: 117, type: !379, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!379 = !DISubroutineType(types: !380)
!380 = !{!48, !381, !382}
!381 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !174)
!382 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !7)
!383 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !384, file: !343, line: 112)
!384 = !DISubprogram(name: "strtof", scope: !346, file: !346, line: 123, type: !385, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!385 = !DISubroutineType(types: !386)
!386 = !{!45, !381, !382}
!387 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !388, file: !343, line: 113)
!388 = !DISubprogram(name: "strtold", scope: !346, file: !346, line: 126, type: !389, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!389 = !DISubroutineType(types: !390)
!390 = !{!38, !381, !382}
!391 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !392, file: !343, line: 114)
!392 = !DISubprogram(name: "strtol", scope: !346, file: !346, line: 176, type: !393, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!393 = !DISubroutineType(types: !394)
!394 = !{!23, !381, !382, !6}
!395 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !396, file: !343, line: 116)
!396 = !DISubprogram(name: "strtoll", scope: !346, file: !346, line: 200, type: !397, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!397 = !DISubroutineType(types: !398)
!398 = !{!155, !381, !382, !6}
!399 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !400, file: !343, line: 118)
!400 = !DISubprogram(name: "strtoul", scope: !346, file: !346, line: 180, type: !401, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!401 = !DISubroutineType(types: !402)
!402 = !{!27, !381, !382, !6}
!403 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !404, file: !343, line: 120)
!404 = !DISubprogram(name: "strtoull", scope: !346, file: !346, line: 205, type: !405, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!405 = !DISubroutineType(types: !406)
!406 = !{!407, !381, !382, !6}
!407 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!408 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !409, file: !343, line: 122)
!409 = !DISubprogram(name: "rand", scope: !346, file: !346, line: 453, type: !410, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!410 = !DISubroutineType(types: !411)
!411 = !{!6}
!412 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !413, file: !343, line: 123)
!413 = !DISubprogram(name: "srand", scope: !346, file: !346, line: 455, type: !414, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!414 = !DISubroutineType(types: !415)
!415 = !{null, !416}
!416 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!417 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !418, file: !343, line: 124)
!418 = !DISubprogram(name: "calloc", scope: !346, file: !346, line: 541, type: !419, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!419 = !DISubroutineType(types: !420)
!420 = !{!421, !26, !26}
!421 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!422 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !423, file: !343, line: 125)
!423 = !DISubprogram(name: "free", scope: !346, file: !346, line: 563, type: !424, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!424 = !DISubroutineType(types: !425)
!425 = !{null, !421}
!426 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !427, file: !343, line: 126)
!427 = !DISubprogram(name: "malloc", scope: !346, file: !346, line: 539, type: !428, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!428 = !DISubroutineType(types: !429)
!429 = !{!421, !26}
!430 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !431, file: !343, line: 127)
!431 = !DISubprogram(name: "realloc", scope: !346, file: !346, line: 549, type: !432, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!432 = !DISubroutineType(types: !433)
!433 = !{!421, !421, !26}
!434 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !435, file: !343, line: 128)
!435 = !DISubprogram(name: "abort", scope: !346, file: !346, line: 588, type: !436, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!436 = !DISubroutineType(types: !437)
!437 = !{null}
!438 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !439, file: !343, line: 129)
!439 = !DISubprogram(name: "atexit", scope: !346, file: !346, line: 592, type: !440, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!440 = !DISubroutineType(types: !441)
!441 = !{!6, !442}
!442 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !436, size: 64)
!443 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !444, file: !343, line: 130)
!444 = !DISubprogram(name: "exit", scope: !346, file: !346, line: 614, type: !445, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!445 = !DISubroutineType(types: !446)
!446 = !{null, !6}
!447 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !448, file: !343, line: 131)
!448 = !DISubprogram(name: "_Exit", scope: !346, file: !346, line: 626, type: !445, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!449 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !450, file: !343, line: 133)
!450 = !DISubprogram(name: "getenv", scope: !346, file: !346, line: 631, type: !451, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!451 = !DISubroutineType(types: !452)
!452 = !{!8, !174}
!453 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !454, file: !343, line: 134)
!454 = !DISubprogram(name: "system", scope: !346, file: !346, line: 781, type: !365, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!455 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !456, file: !343, line: 136)
!456 = !DISubprogram(name: "bsearch", scope: !457, file: !457, line: 20, type: !458, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!457 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdlib-bsearch.h", directory: "")
!458 = !DISubroutineType(types: !459)
!459 = !{!421, !460, !460, !26, !26, !462}
!460 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !461, size: 64)
!461 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!462 = !DIDerivedType(tag: DW_TAG_typedef, name: "__compar_fn_t", file: !346, line: 805, baseType: !463)
!463 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !464, size: 64)
!464 = !DISubroutineType(types: !465)
!465 = !{!6, !460, !460}
!466 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !467, file: !343, line: 137)
!467 = !DISubprogram(name: "qsort", scope: !346, file: !346, line: 827, type: !468, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!468 = !DISubroutineType(types: !469)
!469 = !{null, !421, !26, !26, !462}
!470 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !50, file: !343, line: 138)
!471 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !472, file: !343, line: 139)
!472 = !DISubprogram(name: "labs", scope: !346, file: !346, line: 838, type: !473, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!473 = !DISubroutineType(types: !474)
!474 = !{!23, !23}
!475 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !476, file: !343, line: 141)
!476 = !DISubprogram(name: "llabs", scope: !346, file: !346, line: 841, type: !477, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!477 = !DISubroutineType(types: !478)
!478 = !{!155, !155}
!479 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !480, file: !343, line: 143)
!480 = !DISubprogram(name: "div", linkageName: "_Z3divxx", scope: !34, file: !34, line: 808, type: !481, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!481 = !DISubroutineType(types: !482)
!482 = !{!355, !155, !155}
!483 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !484, file: !343, line: 144)
!484 = !DISubprogram(name: "ldiv", scope: !346, file: !346, line: 851, type: !485, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!485 = !DISubroutineType(types: !486)
!486 = !{!349, !23, !23}
!487 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !488, file: !343, line: 146)
!488 = !DISubprogram(name: "lldiv", scope: !346, file: !346, line: 855, type: !481, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!489 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !490, file: !343, line: 148)
!490 = !DISubprogram(name: "mblen", scope: !346, file: !346, line: 919, type: !491, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!491 = !DISubroutineType(types: !492)
!492 = !{!6, !174, !26}
!493 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !494, file: !343, line: 149)
!494 = !DISubprogram(name: "mbtowc", scope: !346, file: !346, line: 922, type: !495, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!495 = !DISubroutineType(types: !496)
!496 = !{!6, !497, !381, !26}
!497 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !498)
!498 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !499, size: 64)
!499 = !DIBasicType(name: "wchar_t", size: 32, encoding: DW_ATE_signed)
!500 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !501, file: !343, line: 150)
!501 = !DISubprogram(name: "wctomb", scope: !346, file: !346, line: 926, type: !502, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!502 = !DISubroutineType(types: !503)
!503 = !{!6, !8, !499}
!504 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !505, file: !343, line: 151)
!505 = !DISubprogram(name: "mbstowcs", scope: !346, file: !346, line: 930, type: !506, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!506 = !DISubroutineType(types: !507)
!507 = !{!26, !497, !381, !26}
!508 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !509, file: !343, line: 152)
!509 = !DISubprogram(name: "wcstombs", scope: !346, file: !346, line: 933, type: !510, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!510 = !DISubroutineType(types: !511)
!511 = !{!26, !512, !513, !26}
!512 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !8)
!513 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !514)
!514 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !515, size: 64)
!515 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !499)
!516 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !517, file: !343, line: 154)
!517 = !DISubprogram(name: "at_quick_exit", scope: !346, file: !346, line: 597, type: !440, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!518 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !519, file: !343, line: 155)
!519 = !DISubprogram(name: "quick_exit", scope: !346, file: !346, line: 620, type: !445, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!520 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !11, file: !521, line: 152)
!521 = !DIFile(filename: "build_tool/../usr/include/c++/v1/cstdint", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!522 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !523, file: !521, line: 153)
!523 = !DIDerivedType(tag: DW_TAG_typedef, name: "int16_t", file: !12, line: 25, baseType: !524)
!524 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int16_t", file: !14, line: 38, baseType: !525)
!525 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!526 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !527, file: !521, line: 154)
!527 = !DIDerivedType(tag: DW_TAG_typedef, name: "int32_t", file: !12, line: 26, baseType: !528)
!528 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int32_t", file: !14, line: 40, baseType: !6)
!529 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !530, file: !521, line: 155)
!530 = !DIDerivedType(tag: DW_TAG_typedef, name: "int64_t", file: !12, line: 27, baseType: !531)
!531 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int64_t", file: !14, line: 43, baseType: !23)
!532 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !533, file: !521, line: 157)
!533 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint8_t", file: !534, line: 24, baseType: !535)
!534 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "")
!535 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint8_t", file: !14, line: 37, baseType: !536)
!536 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!537 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !538, file: !521, line: 158)
!538 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint16_t", file: !534, line: 25, baseType: !539)
!539 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint16_t", file: !14, line: 39, baseType: !540)
!540 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!541 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !542, file: !521, line: 159)
!542 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !534, line: 26, baseType: !543)
!543 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !14, line: 41, baseType: !416)
!544 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !545, file: !521, line: 160)
!545 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", file: !534, line: 27, baseType: !546)
!546 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint64_t", file: !14, line: 44, baseType: !27)
!547 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !548, file: !521, line: 162)
!548 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least8_t", file: !549, line: 43, baseType: !15)
!549 = !DIFile(filename: "/usr/include/stdint.h", directory: "")
!550 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !551, file: !521, line: 163)
!551 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least16_t", file: !549, line: 44, baseType: !525)
!552 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !553, file: !521, line: 164)
!553 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least32_t", file: !549, line: 45, baseType: !6)
!554 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !555, file: !521, line: 165)
!555 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least64_t", file: !549, line: 47, baseType: !23)
!556 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !557, file: !521, line: 167)
!557 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least8_t", file: !549, line: 54, baseType: !536)
!558 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !559, file: !521, line: 168)
!559 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least16_t", file: !549, line: 55, baseType: !540)
!560 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !561, file: !521, line: 169)
!561 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least32_t", file: !549, line: 56, baseType: !416)
!562 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !563, file: !521, line: 170)
!563 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least64_t", file: !549, line: 58, baseType: !27)
!564 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !565, file: !521, line: 172)
!565 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast8_t", file: !549, line: 68, baseType: !15)
!566 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !567, file: !521, line: 173)
!567 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast16_t", file: !549, line: 70, baseType: !23)
!568 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !569, file: !521, line: 174)
!569 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast32_t", file: !549, line: 71, baseType: !23)
!570 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !571, file: !521, line: 175)
!571 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast64_t", file: !549, line: 72, baseType: !23)
!572 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !573, file: !521, line: 177)
!573 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast8_t", file: !549, line: 81, baseType: !536)
!574 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !575, file: !521, line: 178)
!575 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast16_t", file: !549, line: 83, baseType: !27)
!576 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !577, file: !521, line: 179)
!577 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast32_t", file: !549, line: 84, baseType: !27)
!578 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !579, file: !521, line: 180)
!579 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast64_t", file: !549, line: 85, baseType: !27)
!580 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !581, file: !521, line: 182)
!581 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !549, line: 97, baseType: !23)
!582 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !583, file: !521, line: 183)
!583 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !549, line: 100, baseType: !27)
!584 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !585, file: !521, line: 185)
!585 = !DIDerivedType(tag: DW_TAG_typedef, name: "intmax_t", file: !549, line: 111, baseType: !586)
!586 = !DIDerivedType(tag: DW_TAG_typedef, name: "__intmax_t", file: !14, line: 61, baseType: !23)
!587 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !19, entity: !588, file: !521, line: 186)
!588 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintmax_t", file: !549, line: 112, baseType: !589)
!589 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uintmax_t", file: !14, line: 62, baseType: !27)
!590 = !{i32 2, !"Dwarf Version", i32 4}
!591 = !{i32 2, !"Debug Info Version", i32 3}
!592 = !{i32 1, !"wchar_size", i32 4}
!593 = !{!"clang version 9.0.0 (tags/RELEASE_900/final)"}
!594 = distinct !DISubprogram(name: "g", linkageName: "_Z1gii", scope: !3, file: !3, line: 9, type: !595, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !597)
!595 = !DISubroutineType(types: !596)
!596 = !{!6, !6, !6}
!597 = !{!598, !599}
!598 = !DILocalVariable(name: "x", arg: 1, scope: !594, file: !3, line: 9, type: !6)
!599 = !DILocalVariable(name: "y", arg: 2, scope: !594, file: !3, line: 9, type: !6)
!600 = !{!601, !601, i64 0}
!601 = !{!"int", !602, i64 0}
!602 = !{!"omnipotent char", !603, i64 0}
!603 = !{!"Simple C++ TBAA"}
!604 = !DILocation(line: 9, column: 11, scope: !594)
!605 = !DILocation(line: 9, column: 18, scope: !594)
!606 = !DILocation(line: 11, column: 12, scope: !594)
!607 = !DILocation(line: 11, column: 20, scope: !594)
!608 = !DILocation(line: 11, column: 18, scope: !594)
!609 = !DILocation(line: 11, column: 24, scope: !594)
!610 = !DILocation(line: 11, column: 26, scope: !594)
!611 = !DILocation(line: 11, column: 5, scope: !594)
!612 = distinct !DISubprogram(name: "g2", linkageName: "_Z2g2ii", scope: !3, file: !3, line: 14, type: !595, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !613)
!613 = !{!614, !615}
!614 = !DILocalVariable(name: "x", arg: 1, scope: !612, file: !3, line: 14, type: !6)
!615 = !DILocalVariable(name: "y", arg: 2, scope: !612, file: !3, line: 14, type: !6)
!616 = !DILocation(line: 14, column: 12, scope: !612)
!617 = !DILocation(line: 14, column: 19, scope: !612)
!618 = !DILocation(line: 16, column: 12, scope: !612)
!619 = !DILocation(line: 16, column: 16, scope: !612)
!620 = !DILocation(line: 16, column: 14, scope: !612)
!621 = !DILocation(line: 16, column: 20, scope: !612)
!622 = !DILocation(line: 16, column: 18, scope: !612)
!623 = !DILocation(line: 16, column: 5, scope: !612)
!624 = distinct !DISubprogram(name: "f", linkageName: "_Z1fii", scope: !3, file: !3, line: 36, type: !595, scopeLine: 37, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !625)
!625 = !{!626, !627, !628, !629}
!626 = !DILocalVariable(name: "x1", arg: 1, scope: !624, file: !3, line: 36, type: !6)
!627 = !DILocalVariable(name: "x2", arg: 2, scope: !624, file: !3, line: 36, type: !6)
!628 = !DILocalVariable(name: "tmp", scope: !624, file: !3, line: 38, type: !6)
!629 = !DILocalVariable(name: "i", scope: !630, file: !3, line: 39, type: !6)
!630 = distinct !DILexicalBlock(scope: !624, file: !3, line: 39, column: 5)
!631 = !DILocation(line: 36, column: 11, scope: !624)
!632 = !DILocation(line: 36, column: 19, scope: !624)
!633 = !DILocation(line: 38, column: 5, scope: !624)
!634 = !DILocation(line: 38, column: 9, scope: !624)
!635 = !DILocation(line: 39, column: 9, scope: !630)
!636 = !DILocation(line: 39, column: 13, scope: !630)
!637 = !DILocation(line: 39, column: 20, scope: !638)
!638 = distinct !DILexicalBlock(scope: !630, file: !3, line: 39, column: 5)
!639 = !DILocation(line: 39, column: 26, scope: !638)
!640 = !DILocation(line: 39, column: 31, scope: !638)
!641 = !DILocation(line: 39, column: 29, scope: !638)
!642 = !DILocation(line: 39, column: 24, scope: !638)
!643 = !DILocation(line: 39, column: 22, scope: !638)
!644 = !DILocation(line: 39, column: 5, scope: !630)
!645 = !DILocation(line: 39, column: 5, scope: !638)
!646 = !DILocation(line: 40, column: 16, scope: !647)
!647 = distinct !DILexicalBlock(scope: !638, file: !3, line: 39, column: 44)
!648 = !DILocation(line: 40, column: 13, scope: !647)
!649 = !DILocation(line: 41, column: 5, scope: !647)
!650 = !DILocation(line: 39, column: 39, scope: !638)
!651 = distinct !{!651, !644, !652}
!652 = !DILocation(line: 41, column: 5, scope: !630)
!653 = !DILocation(line: 42, column: 12, scope: !624)
!654 = !DILocation(line: 43, column: 1, scope: !624)
!655 = !DILocation(line: 42, column: 5, scope: !624)
!656 = distinct !DISubprogram(name: "h", linkageName: "_Z1hii", scope: !3, file: !3, line: 47, type: !595, scopeLine: 48, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !657)
!657 = !{!658, !659, !660, !661}
!658 = !DILocalVariable(name: "x1", arg: 1, scope: !656, file: !3, line: 47, type: !6)
!659 = !DILocalVariable(name: "x2", arg: 2, scope: !656, file: !3, line: 47, type: !6)
!660 = !DILocalVariable(name: "tmp", scope: !656, file: !3, line: 49, type: !6)
!661 = !DILocalVariable(name: "i", scope: !662, file: !3, line: 50, type: !6)
!662 = distinct !DILexicalBlock(scope: !656, file: !3, line: 50, column: 5)
!663 = !DILocation(line: 47, column: 11, scope: !656)
!664 = !DILocation(line: 47, column: 19, scope: !656)
!665 = !DILocation(line: 49, column: 5, scope: !656)
!666 = !DILocation(line: 49, column: 9, scope: !656)
!667 = !DILocation(line: 50, column: 9, scope: !662)
!668 = !DILocation(line: 50, column: 13, scope: !662)
!669 = !DILocation(line: 50, column: 20, scope: !670)
!670 = distinct !DILexicalBlock(scope: !662, file: !3, line: 50, column: 5)
!671 = !DILocation(line: 50, column: 27, scope: !670)
!672 = !DILocation(line: 50, column: 24, scope: !670)
!673 = !DILocation(line: 50, column: 22, scope: !670)
!674 = !DILocation(line: 50, column: 5, scope: !662)
!675 = !DILocation(line: 50, column: 5, scope: !670)
!676 = !DILocation(line: 51, column: 16, scope: !677)
!677 = distinct !DILexicalBlock(scope: !670, file: !3, line: 50, column: 40)
!678 = !DILocation(line: 51, column: 13, scope: !677)
!679 = !DILocation(line: 52, column: 5, scope: !677)
!680 = !DILocation(line: 50, column: 35, scope: !670)
!681 = distinct !{!681, !674, !682}
!682 = !DILocation(line: 52, column: 5, scope: !662)
!683 = !DILocation(line: 53, column: 12, scope: !656)
!684 = !DILocation(line: 54, column: 1, scope: !656)
!685 = !DILocation(line: 53, column: 5, scope: !656)
!686 = distinct !DISubprogram(name: "i", linkageName: "_Z1iP4test", scope: !3, file: !3, line: 58, type: !687, scopeLine: 59, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !701)
!687 = !DISubroutineType(types: !688)
!688 = !{!6, !689}
!689 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !690, size: 64)
!690 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "test", file: !3, line: 19, size: 64, flags: DIFlagTypePassByValue | DIFlagNonTrivial, elements: !691, identifier: "_ZTS4test")
!691 = !{!692, !693, !694, !698}
!692 = !DIDerivedType(tag: DW_TAG_member, name: "x1", scope: !690, file: !3, line: 21, baseType: !6, size: 32)
!693 = !DIDerivedType(tag: DW_TAG_member, name: "x2", scope: !690, file: !3, line: 21, baseType: !6, size: 32, offset: 32)
!694 = !DISubprogram(name: "test", scope: !690, file: !3, line: 23, type: !695, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!695 = !DISubroutineType(types: !696)
!696 = !{null, !697, !6, !6}
!697 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !690, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!698 = !DISubprogram(name: "length", linkageName: "_ZN4test6lengthEv", scope: !690, file: !3, line: 28, type: !699, scopeLine: 28, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!699 = !DISubroutineType(types: !700)
!700 = !{!6, !697}
!701 = !{!702, !703, !704}
!702 = !DILocalVariable(name: "t", arg: 1, scope: !686, file: !3, line: 58, type: !689)
!703 = !DILocalVariable(name: "tmp", scope: !686, file: !3, line: 60, type: !6)
!704 = !DILocalVariable(name: "i", scope: !705, file: !3, line: 61, type: !6)
!705 = distinct !DILexicalBlock(scope: !686, file: !3, line: 61, column: 5)
!706 = !{!707, !707, i64 0}
!707 = !{!"any pointer", !602, i64 0}
!708 = !DILocation(line: 58, column: 14, scope: !686)
!709 = !DILocation(line: 60, column: 5, scope: !686)
!710 = !DILocation(line: 60, column: 9, scope: !686)
!711 = !DILocation(line: 61, column: 9, scope: !705)
!712 = !DILocation(line: 61, column: 13, scope: !705)
!713 = !DILocation(line: 61, column: 20, scope: !714)
!714 = distinct !DILexicalBlock(scope: !705, file: !3, line: 61, column: 5)
!715 = !DILocation(line: 61, column: 24, scope: !714)
!716 = !DILocation(line: 61, column: 27, scope: !714)
!717 = !DILocation(line: 61, column: 22, scope: !714)
!718 = !DILocation(line: 61, column: 5, scope: !705)
!719 = !DILocation(line: 61, column: 5, scope: !714)
!720 = !DILocation(line: 62, column: 16, scope: !721)
!721 = distinct !DILexicalBlock(scope: !714, file: !3, line: 61, column: 42)
!722 = !DILocation(line: 62, column: 13, scope: !721)
!723 = !DILocation(line: 63, column: 5, scope: !721)
!724 = !DILocation(line: 61, column: 37, scope: !714)
!725 = distinct !{!725, !718, !726}
!726 = !DILocation(line: 63, column: 5, scope: !705)
!727 = !DILocation(line: 64, column: 12, scope: !686)
!728 = !DILocation(line: 65, column: 1, scope: !686)
!729 = !DILocation(line: 64, column: 5, scope: !686)
!730 = distinct !DISubprogram(name: "length", linkageName: "_ZN4test6lengthEv", scope: !690, file: !3, line: 28, type: !699, scopeLine: 29, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, declaration: !698, retainedNodes: !731)
!731 = !{!732}
!732 = !DILocalVariable(name: "this", arg: 1, scope: !730, type: !689, flags: DIFlagArtificial | DIFlagObjectPointer)
!733 = !DILocation(line: 0, scope: !730)
!734 = !DILocation(line: 30, column: 16, scope: !730)
!735 = !{!736, !601, i64 0}
!736 = !{!"_ZTS4test", !601, i64 0, !601, i64 4}
!737 = !DILocation(line: 30, column: 9, scope: !730)
!738 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 68, type: !739, scopeLine: 69, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !741)
!739 = !DISubroutineType(types: !740)
!740 = !{!6, !6, !7}
!741 = !{!742, !743, !744, !745, !746, !747}
!742 = !DILocalVariable(name: "argc", arg: 1, scope: !738, file: !3, line: 68, type: !6)
!743 = !DILocalVariable(name: "argv", arg: 2, scope: !738, file: !3, line: 68, type: !7)
!744 = !DILocalVariable(name: "x1", scope: !738, file: !3, line: 70, type: !6)
!745 = !DILocalVariable(name: "x2", scope: !738, file: !3, line: 71, type: !6)
!746 = !DILocalVariable(name: "y", scope: !738, file: !3, line: 75, type: !6)
!747 = !DILocalVariable(name: "t", scope: !738, file: !3, line: 76, type: !690)
!748 = !DILocation(line: 68, column: 14, scope: !738)
!749 = !DILocation(line: 68, column: 28, scope: !738)
!750 = !DILocation(line: 70, column: 5, scope: !738)
!751 = !DILocation(line: 70, column: 9, scope: !738)
!752 = !DILocation(line: 70, column: 26, scope: !738)
!753 = !DILocation(line: 70, column: 21, scope: !738)
!754 = !DILocation(line: 71, column: 5, scope: !738)
!755 = !DILocation(line: 71, column: 9, scope: !738)
!756 = !DILocation(line: 71, column: 26, scope: !738)
!757 = !DILocation(line: 71, column: 21, scope: !738)
!758 = !DILocation(line: 72, column: 5, scope: !738)
!759 = !DILocation(line: 73, column: 5, scope: !738)
!760 = !DILocation(line: 74, column: 5, scope: !738)
!761 = !DILocation(line: 75, column: 5, scope: !738)
!762 = !DILocation(line: 75, column: 9, scope: !738)
!763 = !DILocation(line: 75, column: 15, scope: !738)
!764 = !DILocation(line: 75, column: 14, scope: !738)
!765 = !DILocation(line: 75, column: 18, scope: !738)
!766 = !DILocation(line: 76, column: 5, scope: !738)
!767 = !DILocation(line: 76, column: 10, scope: !738)
!768 = !DILocation(line: 76, column: 12, scope: !738)
!769 = !DILocation(line: 76, column: 16, scope: !738)
!770 = !DILocation(line: 79, column: 7, scope: !738)
!771 = !DILocation(line: 79, column: 15, scope: !738)
!772 = !DILocation(line: 79, column: 5, scope: !738)
!773 = !DILocation(line: 80, column: 7, scope: !738)
!774 = !DILocation(line: 80, column: 12, scope: !738)
!775 = !DILocation(line: 80, column: 10, scope: !738)
!776 = !DILocation(line: 80, column: 5, scope: !738)
!777 = !DILocation(line: 82, column: 7, scope: !738)
!778 = !DILocation(line: 82, column: 5, scope: !738)
!779 = !DILocation(line: 83, column: 5, scope: !738)
!780 = !DILocation(line: 85, column: 5, scope: !738)
!781 = !DILocation(line: 88, column: 1, scope: !738)
!782 = !DILocation(line: 87, column: 5, scope: !738)
!783 = !DILocation(line: 361, column: 1, scope: !364)
!784 = !DILocation(line: 363, column: 24, scope: !364)
!785 = !DILocation(line: 363, column: 16, scope: !364)
!786 = !DILocation(line: 363, column: 3, scope: !364)
!787 = distinct !DISubprogram(name: "register_variable<int>", linkageName: "_Z17register_variableIiEvPT_PKc", scope: !788, file: !788, line: 14, type: !789, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, templateParams: !795, retainedNodes: !791)
!788 = !DIFile(filename: "include/ExtraPInstrumenter.hpp", directory: "/home/mcopik/projects/ETH/extrap/rebuild/perf-taint")
!789 = !DISubroutineType(types: !790)
!790 = !{null, !84, !174}
!791 = !{!792, !793, !794}
!792 = !DILocalVariable(name: "ptr", arg: 1, scope: !787, file: !788, line: 14, type: !84)
!793 = !DILocalVariable(name: "name", arg: 2, scope: !787, file: !788, line: 14, type: !174)
!794 = !DILocalVariable(name: "param_id", scope: !787, file: !788, line: 16, type: !527)
!795 = !{!796}
!796 = !DITemplateTypeParameter(name: "T", type: !6)
!797 = !DILocation(line: 14, column: 28, scope: !787)
!798 = !DILocation(line: 14, column: 46, scope: !787)
!799 = !DILocation(line: 16, column: 5, scope: !787)
!800 = !DILocation(line: 16, column: 13, scope: !787)
!801 = !DILocation(line: 16, column: 24, scope: !787)
!802 = !DILocation(line: 17, column: 57, scope: !787)
!803 = !DILocation(line: 17, column: 31, scope: !787)
!804 = !DILocation(line: 18, column: 21, scope: !787)
!805 = !DILocation(line: 18, column: 25, scope: !787)
!806 = !DILocation(line: 17, column: 5, scope: !787)
!807 = !DILocation(line: 19, column: 1, scope: !787)
!808 = distinct !DISubprogram(name: "test", linkageName: "_ZN4testC2Eii", scope: !690, file: !3, line: 23, type: !695, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, declaration: !694, retainedNodes: !809)
!809 = !{!810, !811, !812}
!810 = !DILocalVariable(name: "this", arg: 1, scope: !808, type: !689, flags: DIFlagArtificial | DIFlagObjectPointer)
!811 = !DILocalVariable(name: "_x1", arg: 2, scope: !808, file: !3, line: 23, type: !6)
!812 = !DILocalVariable(name: "_x2", arg: 3, scope: !808, file: !3, line: 23, type: !6)
!813 = !DILocation(line: 0, scope: !808)
!814 = !DILocation(line: 23, column: 14, scope: !808)
!815 = !DILocation(line: 23, column: 23, scope: !808)
!816 = !DILocation(line: 24, column: 9, scope: !808)
!817 = !DILocation(line: 24, column: 12, scope: !808)
!818 = !DILocation(line: 25, column: 9, scope: !808)
!819 = !DILocation(line: 25, column: 12, scope: !808)
!820 = !{!736, !601, i64 4}
!821 = !DILocation(line: 26, column: 6, scope: !808)
