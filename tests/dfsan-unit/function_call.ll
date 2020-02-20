; RUN: opt %dfsan -S < %s 2> /dev/null | llc %llcparams - -o %t1 && clang++ %link %t1 -o %t2 && %execparams %t2 10 10 | diff -w %s.json -
; ModuleID = 'tests/dfsan-instr/function_call.cpp'
source_filename = "tests/dfsan-instr/function_call.cpp"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

$_Z17register_variableIiEvPT_PKc = comdat any

@global = dso_local global i32 100, align 4, !dbg !0
@.str = private unnamed_addr constant [7 x i8] c"extrap\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [36 x i8] c"tests/dfsan-instr/function_call.cpp\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [3 x i8] c"x1\00", align 1
@.str.3 = private unnamed_addr constant [3 x i8] c"x2\00", align 1
@.str.4 = private unnamed_addr constant [7 x i8] c"global\00", align 1
@llvm.global.annotations = appending global [1 x { i8*, i8*, i8*, i32 }] [{ i8*, i8*, i8*, i32 } { i8* bitcast (i32* @global to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([36 x i8], [36 x i8]* @.str.1, i32 0, i32 0), i32 6 }], section "llvm.metadata"

; Function Attrs: nounwind uwtable
define dso_local i32 @_Z1fii(i32, i32) #0 !dbg !594 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i32 %0, i32* %3, align 4, !tbaa !603
  call void @llvm.dbg.declare(metadata i32* %3, metadata !598, metadata !DIExpression()), !dbg !607
  store i32 %1, i32* %4, align 4, !tbaa !603
  call void @llvm.dbg.declare(metadata i32* %4, metadata !599, metadata !DIExpression()), !dbg !608
  %7 = bitcast i32* %5 to i8*, !dbg !609
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %7) #5, !dbg !609
  call void @llvm.dbg.declare(metadata i32* %5, metadata !600, metadata !DIExpression()), !dbg !610
  store i32 0, i32* %5, align 4, !dbg !610, !tbaa !603
  %8 = bitcast i32* %6 to i8*, !dbg !611
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %8) #5, !dbg !611
  call void @llvm.dbg.declare(metadata i32* %6, metadata !601, metadata !DIExpression()), !dbg !612
  %9 = load i32, i32* %3, align 4, !dbg !613, !tbaa !603
  store i32 %9, i32* %6, align 4, !dbg !612, !tbaa !603
  br label %10, !dbg !611

10:                                               ; preds = %20, %2
  %11 = load i32, i32* %6, align 4, !dbg !614, !tbaa !603
  %12 = load i32, i32* %4, align 4, !dbg !616, !tbaa !603
  %13 = icmp slt i32 %11, %12, !dbg !617
  br i1 %13, label %16, label %14, !dbg !618

14:                                               ; preds = %10
  %15 = bitcast i32* %6 to i8*, !dbg !619
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %15) #5, !dbg !619
  br label %23

16:                                               ; preds = %10
  %17 = load i32, i32* %6, align 4, !dbg !620, !tbaa !603
  %18 = load i32, i32* %5, align 4, !dbg !621, !tbaa !603
  %19 = add nsw i32 %18, %17, !dbg !621
  store i32 %19, i32* %5, align 4, !dbg !621, !tbaa !603
  br label %20, !dbg !622

20:                                               ; preds = %16
  %21 = load i32, i32* %6, align 4, !dbg !623, !tbaa !603
  %22 = add nsw i32 %21, 1, !dbg !623
  store i32 %22, i32* %6, align 4, !dbg !623, !tbaa !603
  br label %10, !dbg !619, !llvm.loop !624

23:                                               ; preds = %14
  %24 = load i32, i32* %5, align 4, !dbg !626, !tbaa !603
  %25 = mul nsw i32 %24, 10, !dbg !627
  %26 = load i32, i32* %3, align 4, !dbg !628, !tbaa !603
  %27 = mul nsw i32 %25, %26, !dbg !629
  %28 = load i32, i32* %4, align 4, !dbg !630, !tbaa !603
  %29 = sdiv i32 %28, 2, !dbg !631
  %30 = add nsw i32 %27, %29, !dbg !632
  %31 = bitcast i32* %5 to i8*, !dbg !633
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %31) #5, !dbg !633
  ret i32 %30, !dbg !634
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: nounwind uwtable
define dso_local i32 @_Z1hi(i32) #0 !dbg !635 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, i32* %2, align 4, !tbaa !603
  call void @llvm.dbg.declare(metadata i32* %2, metadata !639, metadata !DIExpression()), !dbg !643
  %5 = bitcast i32* %3 to i8*, !dbg !644
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %5) #5, !dbg !644
  call void @llvm.dbg.declare(metadata i32* %3, metadata !640, metadata !DIExpression()), !dbg !645
  store i32 0, i32* %3, align 4, !dbg !645, !tbaa !603
  %6 = bitcast i32* %4 to i8*, !dbg !646
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %6) #5, !dbg !646
  call void @llvm.dbg.declare(metadata i32* %4, metadata !641, metadata !DIExpression()), !dbg !647
  %7 = load i32, i32* %2, align 4, !dbg !648, !tbaa !603
  store i32 %7, i32* %4, align 4, !dbg !647, !tbaa !603
  br label %8, !dbg !646

8:                                                ; preds = %17, %1
  %9 = load i32, i32* %4, align 4, !dbg !649, !tbaa !603
  %10 = icmp slt i32 %9, 100, !dbg !651
  br i1 %10, label %13, label %11, !dbg !652

11:                                               ; preds = %8
  %12 = bitcast i32* %4 to i8*, !dbg !653
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %12) #5, !dbg !653
  br label %20

13:                                               ; preds = %8
  %14 = load i32, i32* %4, align 4, !dbg !654, !tbaa !603
  %15 = load i32, i32* %3, align 4, !dbg !655, !tbaa !603
  %16 = add nsw i32 %15, %14, !dbg !655
  store i32 %16, i32* %3, align 4, !dbg !655, !tbaa !603
  br label %17, !dbg !656

17:                                               ; preds = %13
  %18 = load i32, i32* %4, align 4, !dbg !657, !tbaa !603
  %19 = add nsw i32 %18, 1, !dbg !657
  store i32 %19, i32* %4, align 4, !dbg !657, !tbaa !603
  br label %8, !dbg !653, !llvm.loop !658

20:                                               ; preds = %11
  %21 = load i32, i32* %2, align 4, !dbg !660, !tbaa !603
  %22 = mul nsw i32 100, %21, !dbg !661
  %23 = sitofp i32 %22 to double, !dbg !662
  %24 = load i32, i32* %2, align 4, !dbg !663, !tbaa !603
  %25 = sitofp i32 %24 to double, !dbg !663
  %26 = call double @log(double %25) #5, !dbg !664
  %27 = fmul double %23, %26, !dbg !665
  %28 = fptosi double %27 to i32, !dbg !662
  %29 = bitcast i32* %3 to i8*, !dbg !666
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %29) #5, !dbg !666
  ret i32 %28, !dbg !667
}

; Function Attrs: nounwind
declare dso_local double @log(double) #3

; Function Attrs: nounwind uwtable
define dso_local i32 @_Z1gi(i32) #0 !dbg !668 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4, !tbaa !603
  call void @llvm.dbg.declare(metadata i32* %2, metadata !670, metadata !DIExpression()), !dbg !671
  %3 = load i32, i32* @global, align 4, !dbg !672, !tbaa !603
  %4 = icmp ne i32 %3, 0, !dbg !672
  br i1 %4, label %5, label %15, !dbg !672

5:                                                ; preds = %1
  %6 = load i32, i32* %2, align 4, !dbg !673, !tbaa !603
  %7 = add nsw i32 100, %6, !dbg !674
  %8 = sitofp i32 %7 to double, !dbg !675
  %9 = load i32, i32* @global, align 4, !dbg !676, !tbaa !603
  %10 = sitofp i32 %9 to double, !dbg !676
  %11 = call double @pow(double %10, double 3.000000e+00) #5, !dbg !677
  %12 = fadd double %8, %11, !dbg !678
  %13 = fptosi double %12 to i32, !dbg !675
  %14 = call i32 @_Z1hi(i32 %13), !dbg !679
  br label %16, !dbg !672

15:                                               ; preds = %1
  br label %16, !dbg !672

16:                                               ; preds = %15, %5
  %17 = phi i32 [ %14, %5 ], [ 1, %15 ], !dbg !672
  ret i32 %17, !dbg !680
}

; Function Attrs: nounwind
declare dso_local double @pow(double, double) #3

; Function Attrs: nounwind uwtable
define dso_local i32 @_Z1iiii(i32, i32, i32) #0 !dbg !681 {
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store i32 %0, i32* %4, align 4, !tbaa !603
  call void @llvm.dbg.declare(metadata i32* %4, metadata !685, metadata !DIExpression()), !dbg !691
  store i32 %1, i32* %5, align 4, !tbaa !603
  call void @llvm.dbg.declare(metadata i32* %5, metadata !686, metadata !DIExpression()), !dbg !692
  store i32 %2, i32* %6, align 4, !tbaa !603
  call void @llvm.dbg.declare(metadata i32* %6, metadata !687, metadata !DIExpression()), !dbg !693
  %9 = bitcast i32* %7 to i8*, !dbg !694
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %9) #5, !dbg !694
  call void @llvm.dbg.declare(metadata i32* %7, metadata !688, metadata !DIExpression()), !dbg !695
  store i32 0, i32* %7, align 4, !dbg !695, !tbaa !603
  %10 = bitcast i32* %8 to i8*, !dbg !696
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %10) #5, !dbg !696
  call void @llvm.dbg.declare(metadata i32* %8, metadata !689, metadata !DIExpression()), !dbg !697
  %11 = load i32, i32* %4, align 4, !dbg !698, !tbaa !603
  store i32 %11, i32* %8, align 4, !dbg !697, !tbaa !603
  br label %12, !dbg !696

12:                                               ; preds = %26, %3
  %13 = load i32, i32* %8, align 4, !dbg !699, !tbaa !603
  %14 = load i32, i32* %5, align 4, !dbg !701, !tbaa !603
  %15 = icmp slt i32 %13, %14, !dbg !702
  br i1 %15, label %18, label %16, !dbg !703

16:                                               ; preds = %12
  %17 = bitcast i32* %8 to i8*, !dbg !704
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %17) #5, !dbg !704
  br label %30

18:                                               ; preds = %12
  %19 = load i32, i32* %8, align 4, !dbg !705, !tbaa !603
  %20 = sitofp i32 %19 to double, !dbg !705
  %21 = fmul double %20, 1.100000e+00, !dbg !706
  %22 = load i32, i32* %7, align 4, !dbg !707, !tbaa !603
  %23 = sitofp i32 %22 to double, !dbg !707
  %24 = fadd double %23, %21, !dbg !707
  %25 = fptosi double %24 to i32, !dbg !707
  store i32 %25, i32* %7, align 4, !dbg !707, !tbaa !603
  br label %26, !dbg !708

26:                                               ; preds = %18
  %27 = load i32, i32* %6, align 4, !dbg !709, !tbaa !603
  %28 = load i32, i32* %8, align 4, !dbg !710, !tbaa !603
  %29 = add nsw i32 %28, %27, !dbg !710
  store i32 %29, i32* %8, align 4, !dbg !710, !tbaa !603
  br label %12, !dbg !704, !llvm.loop !711

30:                                               ; preds = %16
  %31 = load i32, i32* %4, align 4, !dbg !713, !tbaa !603
  %32 = mul nsw i32 100, %31, !dbg !714
  %33 = load i32, i32* %5, align 4, !dbg !715, !tbaa !603
  %34 = mul nsw i32 %32, %33, !dbg !716
  %35 = load i32, i32* %6, align 4, !dbg !717, !tbaa !603
  %36 = mul nsw i32 %35, 2, !dbg !718
  %37 = add nsw i32 %34, %36, !dbg !719
  %38 = bitcast i32* %7 to i8*, !dbg !720
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %38) #5, !dbg !720
  ret i32 %37, !dbg !721
}

; Function Attrs: norecurse uwtable
define dso_local i32 @main(i32, i8**) #4 !dbg !722 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4, !tbaa !603
  call void @llvm.dbg.declare(metadata i32* %4, metadata !726, metadata !DIExpression()), !dbg !731
  store i8** %1, i8*** %5, align 8, !tbaa !732
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !727, metadata !DIExpression()), !dbg !734
  %9 = bitcast i32* %6 to i8*, !dbg !735
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %9) #5, !dbg !735
  call void @llvm.dbg.declare(metadata i32* %6, metadata !728, metadata !DIExpression()), !dbg !736
  %10 = bitcast i32* %6 to i8*, !dbg !735
  call void @llvm.var.annotation(i8* %10, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([36 x i8], [36 x i8]* @.str.1, i32 0, i32 0), i32 39), !dbg !735
  %11 = load i8**, i8*** %5, align 8, !dbg !737, !tbaa !732
  %12 = getelementptr inbounds i8*, i8** %11, i64 1, !dbg !737
  %13 = load i8*, i8** %12, align 8, !dbg !737, !tbaa !732
  %14 = call i32 @atoi(i8* %13) #9, !dbg !738
  store i32 %14, i32* %6, align 4, !dbg !736, !tbaa !603
  %15 = bitcast i32* %7 to i8*, !dbg !739
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %15) #5, !dbg !739
  call void @llvm.dbg.declare(metadata i32* %7, metadata !729, metadata !DIExpression()), !dbg !740
  %16 = bitcast i32* %7 to i8*, !dbg !739
  call void @llvm.var.annotation(i8* %16, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([36 x i8], [36 x i8]* @.str.1, i32 0, i32 0), i32 40), !dbg !739
  %17 = load i8**, i8*** %5, align 8, !dbg !741, !tbaa !732
  %18 = getelementptr inbounds i8*, i8** %17, i64 2, !dbg !741
  %19 = load i8*, i8** %18, align 8, !dbg !741, !tbaa !732
  %20 = call i32 @atoi(i8* %19) #9, !dbg !742
  store i32 %20, i32* %7, align 4, !dbg !740, !tbaa !603
  call void @_Z17register_variableIiEvPT_PKc(i32* %6, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.2, i64 0, i64 0)), !dbg !743
  call void @_Z17register_variableIiEvPT_PKc(i32* %7, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.3, i64 0, i64 0)), !dbg !744
  call void @_Z17register_variableIiEvPT_PKc(i32* @global, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.4, i64 0, i64 0)), !dbg !745
  %21 = bitcast i32* %8 to i8*, !dbg !746
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %21) #5, !dbg !746
  call void @llvm.dbg.declare(metadata i32* %8, metadata !730, metadata !DIExpression()), !dbg !747
  %22 = load i32, i32* %6, align 4, !dbg !748, !tbaa !603
  %23 = mul nsw i32 2, %22, !dbg !749
  %24 = add nsw i32 %23, 1, !dbg !750
  store i32 %24, i32* %8, align 4, !dbg !747, !tbaa !603
  %25 = load i32, i32* @global, align 4, !dbg !751, !tbaa !603
  %26 = load i32, i32* %6, align 4, !dbg !752, !tbaa !603
  %27 = call i32 @_Z1fii(i32 %25, i32 %26), !dbg !753
  %28 = call i32 @_Z1gi(i32 100), !dbg !754
  %29 = load i32, i32* %7, align 4, !dbg !755, !tbaa !603
  %30 = call i32 @_Z1hi(i32 %29), !dbg !756
  %31 = call i32 @_Z1hi(i32 100), !dbg !757
  %32 = load i32, i32* %8, align 4, !dbg !758, !tbaa !603
  %33 = load i32, i32* %7, align 4, !dbg !759, !tbaa !603
  %34 = add nsw i32 %32, %33, !dbg !760
  %35 = load i32, i32* %6, align 4, !dbg !761, !tbaa !603
  %36 = call i32 @_Z1iiii(i32 %34, i32 %35, i32 15), !dbg !762
  %37 = bitcast i32* %8 to i8*, !dbg !763
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %37) #5, !dbg !763
  %38 = bitcast i32* %7 to i8*, !dbg !763
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %38) #5, !dbg !763
  %39 = bitcast i32* %6 to i8*, !dbg !763
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %39) #5, !dbg !763
  ret i32 0, !dbg !764
}

; Function Attrs: nounwind
declare void @llvm.var.annotation(i8*, i8*, i8*, i32) #5

; Function Attrs: inlinehint nounwind readonly uwtable
define available_externally dso_local i32 @atoi(i8* nonnull) #6 !dbg !364 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8, !tbaa !732
  call void @llvm.dbg.declare(metadata i8** %2, metadata !368, metadata !DIExpression()), !dbg !765
  %3 = load i8*, i8** %2, align 8, !dbg !766, !tbaa !732
  %4 = call i64 @strtol(i8* %3, i8** null, i32 10) #5, !dbg !767
  %5 = trunc i64 %4 to i32, !dbg !767
  ret i32 %5, !dbg !768
}

; Function Attrs: uwtable
define linkonce_odr dso_local void @_Z17register_variableIiEvPT_PKc(i32*, i8*) #7 comdat !dbg !769 {
  %3 = alloca i32*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca i32, align 4
  store i32* %0, i32** %3, align 8, !tbaa !732
  call void @llvm.dbg.declare(metadata i32** %3, metadata !774, metadata !DIExpression()), !dbg !779
  store i8* %1, i8** %4, align 8, !tbaa !732
  call void @llvm.dbg.declare(metadata i8** %4, metadata !775, metadata !DIExpression()), !dbg !780
  %6 = bitcast i32* %5 to i8*, !dbg !781
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %6) #5, !dbg !781
  call void @llvm.dbg.declare(metadata i32* %5, metadata !776, metadata !DIExpression()), !dbg !782
  %7 = call i32 @__dfsw_EXTRAP_VAR_ID(), !dbg !783
  store i32 %7, i32* %5, align 4, !dbg !782, !tbaa !603
  %8 = load i32*, i32** %3, align 8, !dbg !784, !tbaa !732
  %9 = bitcast i32* %8 to i8*, !dbg !785
  %10 = load i32, i32* %5, align 4, !dbg !786, !tbaa !603
  %11 = add nsw i32 %10, 1, !dbg !786
  store i32 %11, i32* %5, align 4, !dbg !786, !tbaa !603
  %12 = load i8*, i8** %4, align 8, !dbg !787, !tbaa !732
  call void @__dfsw_EXTRAP_STORE_LABEL(i8* %9, i32 4, i32 %10, i8* %12), !dbg !788
  %13 = bitcast i32* %5 to i8*, !dbg !789
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %13) #5, !dbg !789
  ret void, !dbg !789
}

; Function Attrs: nounwind
declare dso_local i64 @strtol(i8*, i8**, i32) #3

declare dso_local i32 @__dfsw_EXTRAP_VAR_ID() #8

declare dso_local void @__dfsw_EXTRAP_STORE_LABEL(i8*, i32, i32, i8*) #8

attributes #0 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { argmemonly nounwind }
attributes #3 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { norecurse uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { nounwind }
attributes #6 = { inlinehint nounwind readonly uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #7 = { uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #8 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #9 = { nounwind readonly }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!590, !591, !592}
!llvm.ident = !{!593}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "global", scope: !2, file: !3, line: 6, type: !7, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !3, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !5, globals: !17, imports: !18, nameTableKind: None)
!3 = !DIFile(filename: "tests/dfsan-instr/function_call.cpp", directory: "/home/mcopik/projects/ETH/extrap/rebuild/extrap-tool")
!4 = !{}
!5 = !{!6, !7, !8, !11}
!6 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!7 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!8 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !9, size: 64)
!9 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !10, size: 64)
!10 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!11 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !12, size: 64)
!12 = !DIDerivedType(tag: DW_TAG_typedef, name: "int8_t", file: !13, line: 24, baseType: !14)
!13 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-intn.h", directory: "")
!14 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int8_t", file: !15, line: 36, baseType: !16)
!15 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "")
!16 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!17 = !{!0}
!18 = !{!19, !26, !29, !33, !41, !43, !47, !49, !53, !58, !60, !62, !66, !68, !70, !72, !74, !76, !78, !80, !85, !89, !91, !93, !98, !103, !105, !107, !109, !111, !113, !115, !117, !119, !121, !123, !125, !127, !129, !131, !133, !135, !139, !141, !143, !145, !149, !151, !156, !158, !160, !162, !164, !168, !170, !176, !180, !182, !184, !188, !190, !194, !196, !198, !202, !204, !206, !208, !210, !212, !214, !218, !220, !222, !224, !226, !228, !230, !232, !236, !240, !242, !244, !246, !248, !250, !252, !254, !256, !258, !260, !262, !264, !266, !268, !270, !272, !274, !276, !278, !282, !284, !286, !288, !292, !294, !298, !300, !302, !304, !306, !310, !312, !316, !318, !320, !322, !324, !328, !330, !332, !336, !338, !340, !342, !344, !348, !354, !360, !363, !369, !373, !377, !383, !387, !391, !395, !399, !403, !408, !412, !417, !422, !426, !430, !434, !438, !443, !447, !449, !453, !455, !466, !470, !471, !475, !479, !483, !487, !489, !493, !500, !504, !508, !516, !518, !520, !522, !526, !529, !532, !537, !541, !544, !547, !550, !552, !554, !556, !558, !560, !562, !564, !566, !568, !570, !572, !574, !576, !578, !580, !582, !584, !587}
!19 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !22, file: !25, line: 49)
!20 = !DINamespace(name: "__1", scope: !21, exportSymbols: true)
!21 = !DINamespace(name: "std", scope: null)
!22 = !DIDerivedType(tag: DW_TAG_typedef, name: "ptrdiff_t", file: !23, line: 35, baseType: !24)
!23 = !DIFile(filename: "clang_llvm/llvm-9.0/build-9.0/lib/clang/9.0.0/include/stddef.h", directory: "/home/mcopik/projects")
!24 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!25 = !DIFile(filename: "build_tool/../usr/include/c++/v1/cstddef", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!26 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !27, file: !25, line: 50)
!27 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !23, line: 46, baseType: !28)
!28 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!29 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !30, file: !25, line: 55)
!30 = !DIDerivedType(tag: DW_TAG_typedef, name: "max_align_t", file: !31, line: 24, baseType: !32)
!31 = !DIFile(filename: "clang_llvm/llvm-9.0/build-9.0/lib/clang/9.0.0/include/__stddef_max_align_t.h", directory: "/home/mcopik/projects")
!32 = !DICompositeType(tag: DW_TAG_structure_type, file: !31, line: 19, flags: DIFlagFwdDecl, identifier: "_ZTS11max_align_t")
!33 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !34, file: !40, line: 316)
!34 = !DISubprogram(name: "isinf", linkageName: "_Z5isinfe", scope: !35, file: !35, line: 499, type: !36, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!35 = !DIFile(filename: "build_tool/../usr/include/c++/v1/math.h", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!36 = !DISubroutineType(types: !37)
!37 = !{!38, !39}
!38 = !DIBasicType(name: "bool", size: 8, encoding: DW_ATE_boolean)
!39 = !DIBasicType(name: "long double", size: 128, encoding: DW_ATE_float)
!40 = !DIFile(filename: "build_tool/../usr/include/c++/v1/cmath", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!41 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !42, file: !40, line: 317)
!42 = !DISubprogram(name: "isnan", linkageName: "_Z5isnane", scope: !35, file: !35, line: 543, type: !36, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!43 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !44, file: !40, line: 327)
!44 = !DIDerivedType(tag: DW_TAG_typedef, name: "float_t", file: !45, line: 149, baseType: !46)
!45 = !DIFile(filename: "/usr/include/math.h", directory: "")
!46 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!47 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !48, file: !40, line: 328)
!48 = !DIDerivedType(tag: DW_TAG_typedef, name: "double_t", file: !45, line: 150, baseType: !6)
!49 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !50, file: !40, line: 331)
!50 = !DISubprogram(name: "abs", linkageName: "_Z3abse", scope: !35, file: !35, line: 789, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!51 = !DISubroutineType(types: !52)
!52 = !{!39, !39}
!53 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !54, file: !40, line: 335)
!54 = !DISubprogram(name: "acosf", scope: !55, file: !55, line: 53, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!55 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/mathcalls.h", directory: "")
!56 = !DISubroutineType(types: !57)
!57 = !{!46, !46}
!58 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !59, file: !40, line: 337)
!59 = !DISubprogram(name: "asinf", scope: !55, file: !55, line: 55, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!60 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !61, file: !40, line: 339)
!61 = !DISubprogram(name: "atanf", scope: !55, file: !55, line: 57, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!62 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !63, file: !40, line: 341)
!63 = !DISubprogram(name: "atan2f", scope: !55, file: !55, line: 59, type: !64, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!64 = !DISubroutineType(types: !65)
!65 = !{!46, !46, !46}
!66 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !67, file: !40, line: 343)
!67 = !DISubprogram(name: "ceilf", scope: !55, file: !55, line: 159, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!68 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !69, file: !40, line: 345)
!69 = !DISubprogram(name: "cosf", scope: !55, file: !55, line: 62, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!70 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !71, file: !40, line: 347)
!71 = !DISubprogram(name: "coshf", scope: !55, file: !55, line: 71, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!72 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !73, file: !40, line: 350)
!73 = !DISubprogram(name: "expf", scope: !55, file: !55, line: 95, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!74 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !75, file: !40, line: 353)
!75 = !DISubprogram(name: "fabsf", scope: !55, file: !55, line: 162, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!76 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !77, file: !40, line: 355)
!77 = !DISubprogram(name: "floorf", scope: !55, file: !55, line: 165, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!78 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !79, file: !40, line: 358)
!79 = !DISubprogram(name: "fmodf", scope: !55, file: !55, line: 168, type: !64, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!80 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !81, file: !40, line: 361)
!81 = !DISubprogram(name: "frexpf", scope: !55, file: !55, line: 98, type: !82, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!82 = !DISubroutineType(types: !83)
!83 = !{!46, !46, !84}
!84 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!85 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !86, file: !40, line: 363)
!86 = !DISubprogram(name: "ldexpf", scope: !55, file: !55, line: 101, type: !87, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!87 = !DISubroutineType(types: !88)
!88 = !{!46, !46, !7}
!89 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !90, file: !40, line: 366)
!90 = !DISubprogram(name: "logf", scope: !55, file: !55, line: 104, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!91 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !92, file: !40, line: 369)
!92 = !DISubprogram(name: "log10f", scope: !55, file: !55, line: 107, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!93 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !94, file: !40, line: 370)
!94 = !DISubprogram(name: "modf", linkageName: "_Z4modfePe", scope: !35, file: !35, line: 1021, type: !95, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!95 = !DISubroutineType(types: !96)
!96 = !{!39, !39, !97}
!97 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !39, size: 64)
!98 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !99, file: !40, line: 371)
!99 = !DISubprogram(name: "modff", scope: !55, file: !55, line: 110, type: !100, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!100 = !DISubroutineType(types: !101)
!101 = !{!46, !46, !102}
!102 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !46, size: 64)
!103 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !104, file: !40, line: 374)
!104 = !DISubprogram(name: "powf", scope: !55, file: !55, line: 140, type: !64, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!105 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !106, file: !40, line: 377)
!106 = !DISubprogram(name: "sinf", scope: !55, file: !55, line: 64, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!107 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !108, file: !40, line: 379)
!108 = !DISubprogram(name: "sinhf", scope: !55, file: !55, line: 73, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!109 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !110, file: !40, line: 382)
!110 = !DISubprogram(name: "sqrtf", scope: !55, file: !55, line: 143, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!111 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !112, file: !40, line: 384)
!112 = !DISubprogram(name: "tanf", scope: !55, file: !55, line: 66, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!113 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !114, file: !40, line: 387)
!114 = !DISubprogram(name: "tanhf", scope: !55, file: !55, line: 75, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!115 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !116, file: !40, line: 390)
!116 = !DISubprogram(name: "acoshf", scope: !55, file: !55, line: 85, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!117 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !118, file: !40, line: 392)
!118 = !DISubprogram(name: "asinhf", scope: !55, file: !55, line: 87, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!119 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !120, file: !40, line: 394)
!120 = !DISubprogram(name: "atanhf", scope: !55, file: !55, line: 89, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!121 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !122, file: !40, line: 396)
!122 = !DISubprogram(name: "cbrtf", scope: !55, file: !55, line: 152, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!123 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !124, file: !40, line: 399)
!124 = !DISubprogram(name: "copysignf", scope: !55, file: !55, line: 196, type: !64, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!125 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !126, file: !40, line: 402)
!126 = !DISubprogram(name: "erff", scope: !55, file: !55, line: 228, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!127 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !128, file: !40, line: 404)
!128 = !DISubprogram(name: "erfcf", scope: !55, file: !55, line: 229, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!129 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !130, file: !40, line: 406)
!130 = !DISubprogram(name: "exp2f", scope: !55, file: !55, line: 130, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!131 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !132, file: !40, line: 408)
!132 = !DISubprogram(name: "expm1f", scope: !55, file: !55, line: 119, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!133 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !134, file: !40, line: 410)
!134 = !DISubprogram(name: "fdimf", scope: !55, file: !55, line: 326, type: !64, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!135 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !136, file: !40, line: 411)
!136 = !DISubprogram(name: "fmaf", scope: !55, file: !55, line: 335, type: !137, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!137 = !DISubroutineType(types: !138)
!138 = !{!46, !46, !46, !46}
!139 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !140, file: !40, line: 414)
!140 = !DISubprogram(name: "fmaxf", scope: !55, file: !55, line: 329, type: !64, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!141 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !142, file: !40, line: 416)
!142 = !DISubprogram(name: "fminf", scope: !55, file: !55, line: 332, type: !64, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!143 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !144, file: !40, line: 418)
!144 = !DISubprogram(name: "hypotf", scope: !55, file: !55, line: 147, type: !64, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!145 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !146, file: !40, line: 420)
!146 = !DISubprogram(name: "ilogbf", scope: !55, file: !55, line: 280, type: !147, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!147 = !DISubroutineType(types: !148)
!148 = !{!7, !46}
!149 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !150, file: !40, line: 422)
!150 = !DISubprogram(name: "lgammaf", scope: !55, file: !55, line: 230, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!151 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !152, file: !40, line: 424)
!152 = !DISubprogram(name: "llrintf", scope: !55, file: !55, line: 316, type: !153, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!153 = !DISubroutineType(types: !154)
!154 = !{!155, !46}
!155 = !DIBasicType(name: "long long int", size: 64, encoding: DW_ATE_signed)
!156 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !157, file: !40, line: 426)
!157 = !DISubprogram(name: "llroundf", scope: !55, file: !55, line: 322, type: !153, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!158 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !159, file: !40, line: 428)
!159 = !DISubprogram(name: "log1pf", scope: !55, file: !55, line: 122, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!160 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !161, file: !40, line: 430)
!161 = !DISubprogram(name: "log2f", scope: !55, file: !55, line: 133, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!162 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !163, file: !40, line: 432)
!163 = !DISubprogram(name: "logbf", scope: !55, file: !55, line: 125, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!164 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !165, file: !40, line: 434)
!165 = !DISubprogram(name: "lrintf", scope: !55, file: !55, line: 314, type: !166, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!166 = !DISubroutineType(types: !167)
!167 = !{!24, !46}
!168 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !169, file: !40, line: 436)
!169 = !DISubprogram(name: "lroundf", scope: !55, file: !55, line: 320, type: !166, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!170 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !171, file: !40, line: 438)
!171 = !DISubprogram(name: "nan", scope: !55, file: !55, line: 201, type: !172, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!172 = !DISubroutineType(types: !173)
!173 = !{!6, !174}
!174 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !175, size: 64)
!175 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !10)
!176 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !177, file: !40, line: 439)
!177 = !DISubprogram(name: "nanf", scope: !55, file: !55, line: 201, type: !178, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!178 = !DISubroutineType(types: !179)
!179 = !{!46, !174}
!180 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !181, file: !40, line: 442)
!181 = !DISubprogram(name: "nearbyintf", scope: !55, file: !55, line: 294, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!182 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !183, file: !40, line: 444)
!183 = !DISubprogram(name: "nextafterf", scope: !55, file: !55, line: 259, type: !64, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!184 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !185, file: !40, line: 446)
!185 = !DISubprogram(name: "nexttowardf", scope: !55, file: !55, line: 261, type: !186, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!186 = !DISubroutineType(types: !187)
!187 = !{!46, !46, !39}
!188 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !189, file: !40, line: 448)
!189 = !DISubprogram(name: "remainderf", scope: !55, file: !55, line: 272, type: !64, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!190 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !191, file: !40, line: 450)
!191 = !DISubprogram(name: "remquof", scope: !55, file: !55, line: 307, type: !192, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!192 = !DISubroutineType(types: !193)
!193 = !{!46, !46, !46, !84}
!194 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !195, file: !40, line: 452)
!195 = !DISubprogram(name: "rintf", scope: !55, file: !55, line: 256, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!196 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !197, file: !40, line: 454)
!197 = !DISubprogram(name: "roundf", scope: !55, file: !55, line: 298, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!198 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !199, file: !40, line: 456)
!199 = !DISubprogram(name: "scalblnf", scope: !55, file: !55, line: 290, type: !200, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!200 = !DISubroutineType(types: !201)
!201 = !{!46, !46, !24}
!202 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !203, file: !40, line: 458)
!203 = !DISubprogram(name: "scalbnf", scope: !55, file: !55, line: 276, type: !87, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!204 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !205, file: !40, line: 460)
!205 = !DISubprogram(name: "tgammaf", scope: !55, file: !55, line: 235, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!206 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !207, file: !40, line: 462)
!207 = !DISubprogram(name: "truncf", scope: !55, file: !55, line: 302, type: !56, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!208 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !209, file: !40, line: 464)
!209 = !DISubprogram(name: "acosl", scope: !55, file: !55, line: 53, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!210 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !211, file: !40, line: 465)
!211 = !DISubprogram(name: "asinl", scope: !55, file: !55, line: 55, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!212 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !213, file: !40, line: 466)
!213 = !DISubprogram(name: "atanl", scope: !55, file: !55, line: 57, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!214 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !215, file: !40, line: 467)
!215 = !DISubprogram(name: "atan2l", scope: !55, file: !55, line: 59, type: !216, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!216 = !DISubroutineType(types: !217)
!217 = !{!39, !39, !39}
!218 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !219, file: !40, line: 468)
!219 = !DISubprogram(name: "ceill", scope: !55, file: !55, line: 159, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!220 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !221, file: !40, line: 469)
!221 = !DISubprogram(name: "cosl", scope: !55, file: !55, line: 62, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!222 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !223, file: !40, line: 470)
!223 = !DISubprogram(name: "coshl", scope: !55, file: !55, line: 71, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!224 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !225, file: !40, line: 471)
!225 = !DISubprogram(name: "expl", scope: !55, file: !55, line: 95, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!226 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !227, file: !40, line: 472)
!227 = !DISubprogram(name: "fabsl", scope: !55, file: !55, line: 162, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!228 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !229, file: !40, line: 473)
!229 = !DISubprogram(name: "floorl", scope: !55, file: !55, line: 165, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!230 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !231, file: !40, line: 474)
!231 = !DISubprogram(name: "fmodl", scope: !55, file: !55, line: 168, type: !216, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!232 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !233, file: !40, line: 475)
!233 = !DISubprogram(name: "frexpl", scope: !55, file: !55, line: 98, type: !234, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!234 = !DISubroutineType(types: !235)
!235 = !{!39, !39, !84}
!236 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !237, file: !40, line: 476)
!237 = !DISubprogram(name: "ldexpl", scope: !55, file: !55, line: 101, type: !238, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!238 = !DISubroutineType(types: !239)
!239 = !{!39, !39, !7}
!240 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !241, file: !40, line: 477)
!241 = !DISubprogram(name: "logl", scope: !55, file: !55, line: 104, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!242 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !243, file: !40, line: 478)
!243 = !DISubprogram(name: "log10l", scope: !55, file: !55, line: 107, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!244 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !245, file: !40, line: 479)
!245 = !DISubprogram(name: "modfl", scope: !55, file: !55, line: 110, type: !95, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!246 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !247, file: !40, line: 480)
!247 = !DISubprogram(name: "powl", scope: !55, file: !55, line: 140, type: !216, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!248 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !249, file: !40, line: 481)
!249 = !DISubprogram(name: "sinl", scope: !55, file: !55, line: 64, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!250 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !251, file: !40, line: 482)
!251 = !DISubprogram(name: "sinhl", scope: !55, file: !55, line: 73, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!252 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !253, file: !40, line: 483)
!253 = !DISubprogram(name: "sqrtl", scope: !55, file: !55, line: 143, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!254 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !255, file: !40, line: 484)
!255 = !DISubprogram(name: "tanl", scope: !55, file: !55, line: 66, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!256 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !257, file: !40, line: 486)
!257 = !DISubprogram(name: "tanhl", scope: !55, file: !55, line: 75, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!258 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !259, file: !40, line: 487)
!259 = !DISubprogram(name: "acoshl", scope: !55, file: !55, line: 85, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!260 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !261, file: !40, line: 488)
!261 = !DISubprogram(name: "asinhl", scope: !55, file: !55, line: 87, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!262 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !263, file: !40, line: 489)
!263 = !DISubprogram(name: "atanhl", scope: !55, file: !55, line: 89, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!264 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !265, file: !40, line: 490)
!265 = !DISubprogram(name: "cbrtl", scope: !55, file: !55, line: 152, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!266 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !267, file: !40, line: 492)
!267 = !DISubprogram(name: "copysignl", scope: !55, file: !55, line: 196, type: !216, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!268 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !269, file: !40, line: 494)
!269 = !DISubprogram(name: "erfl", scope: !55, file: !55, line: 228, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!270 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !271, file: !40, line: 495)
!271 = !DISubprogram(name: "erfcl", scope: !55, file: !55, line: 229, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!272 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !273, file: !40, line: 496)
!273 = !DISubprogram(name: "exp2l", scope: !55, file: !55, line: 130, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!274 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !275, file: !40, line: 497)
!275 = !DISubprogram(name: "expm1l", scope: !55, file: !55, line: 119, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!276 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !277, file: !40, line: 498)
!277 = !DISubprogram(name: "fdiml", scope: !55, file: !55, line: 326, type: !216, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!278 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !279, file: !40, line: 499)
!279 = !DISubprogram(name: "fmal", scope: !55, file: !55, line: 335, type: !280, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!280 = !DISubroutineType(types: !281)
!281 = !{!39, !39, !39, !39}
!282 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !283, file: !40, line: 500)
!283 = !DISubprogram(name: "fmaxl", scope: !55, file: !55, line: 329, type: !216, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!284 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !285, file: !40, line: 501)
!285 = !DISubprogram(name: "fminl", scope: !55, file: !55, line: 332, type: !216, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!286 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !287, file: !40, line: 502)
!287 = !DISubprogram(name: "hypotl", scope: !55, file: !55, line: 147, type: !216, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!288 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !289, file: !40, line: 503)
!289 = !DISubprogram(name: "ilogbl", scope: !55, file: !55, line: 280, type: !290, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!290 = !DISubroutineType(types: !291)
!291 = !{!7, !39}
!292 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !293, file: !40, line: 504)
!293 = !DISubprogram(name: "lgammal", scope: !55, file: !55, line: 230, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!294 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !295, file: !40, line: 505)
!295 = !DISubprogram(name: "llrintl", scope: !55, file: !55, line: 316, type: !296, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!296 = !DISubroutineType(types: !297)
!297 = !{!155, !39}
!298 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !299, file: !40, line: 506)
!299 = !DISubprogram(name: "llroundl", scope: !55, file: !55, line: 322, type: !296, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!300 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !301, file: !40, line: 507)
!301 = !DISubprogram(name: "log1pl", scope: !55, file: !55, line: 122, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!302 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !303, file: !40, line: 508)
!303 = !DISubprogram(name: "log2l", scope: !55, file: !55, line: 133, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!304 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !305, file: !40, line: 509)
!305 = !DISubprogram(name: "logbl", scope: !55, file: !55, line: 125, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!306 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !307, file: !40, line: 510)
!307 = !DISubprogram(name: "lrintl", scope: !55, file: !55, line: 314, type: !308, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!308 = !DISubroutineType(types: !309)
!309 = !{!24, !39}
!310 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !311, file: !40, line: 511)
!311 = !DISubprogram(name: "lroundl", scope: !55, file: !55, line: 320, type: !308, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!312 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !313, file: !40, line: 512)
!313 = !DISubprogram(name: "nanl", scope: !55, file: !55, line: 201, type: !314, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!314 = !DISubroutineType(types: !315)
!315 = !{!39, !174}
!316 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !317, file: !40, line: 513)
!317 = !DISubprogram(name: "nearbyintl", scope: !55, file: !55, line: 294, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!318 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !319, file: !40, line: 514)
!319 = !DISubprogram(name: "nextafterl", scope: !55, file: !55, line: 259, type: !216, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!320 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !321, file: !40, line: 515)
!321 = !DISubprogram(name: "nexttowardl", scope: !55, file: !55, line: 261, type: !216, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!322 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !323, file: !40, line: 516)
!323 = !DISubprogram(name: "remainderl", scope: !55, file: !55, line: 272, type: !216, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!324 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !325, file: !40, line: 517)
!325 = !DISubprogram(name: "remquol", scope: !55, file: !55, line: 307, type: !326, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!326 = !DISubroutineType(types: !327)
!327 = !{!39, !39, !39, !84}
!328 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !329, file: !40, line: 518)
!329 = !DISubprogram(name: "rintl", scope: !55, file: !55, line: 256, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!330 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !331, file: !40, line: 519)
!331 = !DISubprogram(name: "roundl", scope: !55, file: !55, line: 298, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!332 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !333, file: !40, line: 520)
!333 = !DISubprogram(name: "scalblnl", scope: !55, file: !55, line: 290, type: !334, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!334 = !DISubroutineType(types: !335)
!335 = !{!39, !39, !24}
!336 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !337, file: !40, line: 521)
!337 = !DISubprogram(name: "scalbnl", scope: !55, file: !55, line: 276, type: !238, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!338 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !339, file: !40, line: 522)
!339 = !DISubprogram(name: "tgammal", scope: !55, file: !55, line: 235, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!340 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !341, file: !40, line: 523)
!341 = !DISubprogram(name: "truncl", scope: !55, file: !55, line: 302, type: !51, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!342 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !27, file: !343, line: 99)
!343 = !DIFile(filename: "build_tool/../usr/include/c++/v1/cstdlib", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!344 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !345, file: !343, line: 100)
!345 = !DIDerivedType(tag: DW_TAG_typedef, name: "div_t", file: !346, line: 62, baseType: !347)
!346 = !DIFile(filename: "/usr/include/stdlib.h", directory: "")
!347 = !DICompositeType(tag: DW_TAG_structure_type, file: !346, line: 58, flags: DIFlagFwdDecl, identifier: "_ZTS5div_t")
!348 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !349, file: !343, line: 101)
!349 = !DIDerivedType(tag: DW_TAG_typedef, name: "ldiv_t", file: !346, line: 70, baseType: !350)
!350 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !346, line: 66, size: 128, flags: DIFlagTypePassByValue, elements: !351, identifier: "_ZTS6ldiv_t")
!351 = !{!352, !353}
!352 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !350, file: !346, line: 68, baseType: !24, size: 64)
!353 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !350, file: !346, line: 69, baseType: !24, size: 64, offset: 64)
!354 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !355, file: !343, line: 103)
!355 = !DIDerivedType(tag: DW_TAG_typedef, name: "lldiv_t", file: !346, line: 80, baseType: !356)
!356 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !346, line: 76, size: 128, flags: DIFlagTypePassByValue, elements: !357, identifier: "_ZTS7lldiv_t")
!357 = !{!358, !359}
!358 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !356, file: !346, line: 78, baseType: !155, size: 64)
!359 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !356, file: !346, line: 79, baseType: !155, size: 64, offset: 64)
!360 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !361, file: !343, line: 105)
!361 = !DISubprogram(name: "atof", scope: !362, file: !362, line: 25, type: !172, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!362 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdlib-float.h", directory: "")
!363 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !364, file: !343, line: 106)
!364 = distinct !DISubprogram(name: "atoi", scope: !346, file: !346, line: 361, type: !365, scopeLine: 362, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !367)
!365 = !DISubroutineType(types: !366)
!366 = !{!7, !174}
!367 = !{!368}
!368 = !DILocalVariable(name: "__nptr", arg: 1, scope: !364, file: !346, line: 361, type: !174)
!369 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !370, file: !343, line: 107)
!370 = !DISubprogram(name: "atol", scope: !346, file: !346, line: 366, type: !371, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!371 = !DISubroutineType(types: !372)
!372 = !{!24, !174}
!373 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !374, file: !343, line: 109)
!374 = !DISubprogram(name: "atoll", scope: !346, file: !346, line: 373, type: !375, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!375 = !DISubroutineType(types: !376)
!376 = !{!155, !174}
!377 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !378, file: !343, line: 111)
!378 = !DISubprogram(name: "strtod", scope: !346, file: !346, line: 117, type: !379, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!379 = !DISubroutineType(types: !380)
!380 = !{!6, !381, !382}
!381 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !174)
!382 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !8)
!383 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !384, file: !343, line: 112)
!384 = !DISubprogram(name: "strtof", scope: !346, file: !346, line: 123, type: !385, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!385 = !DISubroutineType(types: !386)
!386 = !{!46, !381, !382}
!387 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !388, file: !343, line: 113)
!388 = !DISubprogram(name: "strtold", scope: !346, file: !346, line: 126, type: !389, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!389 = !DISubroutineType(types: !390)
!390 = !{!39, !381, !382}
!391 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !392, file: !343, line: 114)
!392 = !DISubprogram(name: "strtol", scope: !346, file: !346, line: 176, type: !393, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!393 = !DISubroutineType(types: !394)
!394 = !{!24, !381, !382, !7}
!395 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !396, file: !343, line: 116)
!396 = !DISubprogram(name: "strtoll", scope: !346, file: !346, line: 200, type: !397, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!397 = !DISubroutineType(types: !398)
!398 = !{!155, !381, !382, !7}
!399 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !400, file: !343, line: 118)
!400 = !DISubprogram(name: "strtoul", scope: !346, file: !346, line: 180, type: !401, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!401 = !DISubroutineType(types: !402)
!402 = !{!28, !381, !382, !7}
!403 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !404, file: !343, line: 120)
!404 = !DISubprogram(name: "strtoull", scope: !346, file: !346, line: 205, type: !405, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!405 = !DISubroutineType(types: !406)
!406 = !{!407, !381, !382, !7}
!407 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!408 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !409, file: !343, line: 122)
!409 = !DISubprogram(name: "rand", scope: !346, file: !346, line: 453, type: !410, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!410 = !DISubroutineType(types: !411)
!411 = !{!7}
!412 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !413, file: !343, line: 123)
!413 = !DISubprogram(name: "srand", scope: !346, file: !346, line: 455, type: !414, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!414 = !DISubroutineType(types: !415)
!415 = !{null, !416}
!416 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!417 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !418, file: !343, line: 124)
!418 = !DISubprogram(name: "calloc", scope: !346, file: !346, line: 541, type: !419, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!419 = !DISubroutineType(types: !420)
!420 = !{!421, !27, !27}
!421 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!422 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !423, file: !343, line: 125)
!423 = !DISubprogram(name: "free", scope: !346, file: !346, line: 563, type: !424, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!424 = !DISubroutineType(types: !425)
!425 = !{null, !421}
!426 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !427, file: !343, line: 126)
!427 = !DISubprogram(name: "malloc", scope: !346, file: !346, line: 539, type: !428, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!428 = !DISubroutineType(types: !429)
!429 = !{!421, !27}
!430 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !431, file: !343, line: 127)
!431 = !DISubprogram(name: "realloc", scope: !346, file: !346, line: 549, type: !432, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!432 = !DISubroutineType(types: !433)
!433 = !{!421, !421, !27}
!434 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !435, file: !343, line: 128)
!435 = !DISubprogram(name: "abort", scope: !346, file: !346, line: 588, type: !436, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!436 = !DISubroutineType(types: !437)
!437 = !{null}
!438 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !439, file: !343, line: 129)
!439 = !DISubprogram(name: "atexit", scope: !346, file: !346, line: 592, type: !440, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!440 = !DISubroutineType(types: !441)
!441 = !{!7, !442}
!442 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !436, size: 64)
!443 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !444, file: !343, line: 130)
!444 = !DISubprogram(name: "exit", scope: !346, file: !346, line: 614, type: !445, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!445 = !DISubroutineType(types: !446)
!446 = !{null, !7}
!447 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !448, file: !343, line: 131)
!448 = !DISubprogram(name: "_Exit", scope: !346, file: !346, line: 626, type: !445, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!449 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !450, file: !343, line: 133)
!450 = !DISubprogram(name: "getenv", scope: !346, file: !346, line: 631, type: !451, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!451 = !DISubroutineType(types: !452)
!452 = !{!9, !174}
!453 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !454, file: !343, line: 134)
!454 = !DISubprogram(name: "system", scope: !346, file: !346, line: 781, type: !365, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!455 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !456, file: !343, line: 136)
!456 = !DISubprogram(name: "bsearch", scope: !457, file: !457, line: 20, type: !458, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!457 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdlib-bsearch.h", directory: "")
!458 = !DISubroutineType(types: !459)
!459 = !{!421, !460, !460, !27, !27, !462}
!460 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !461, size: 64)
!461 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!462 = !DIDerivedType(tag: DW_TAG_typedef, name: "__compar_fn_t", file: !346, line: 805, baseType: !463)
!463 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !464, size: 64)
!464 = !DISubroutineType(types: !465)
!465 = !{!7, !460, !460}
!466 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !467, file: !343, line: 137)
!467 = !DISubprogram(name: "qsort", scope: !346, file: !346, line: 827, type: !468, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!468 = !DISubroutineType(types: !469)
!469 = !{null, !421, !27, !27, !462}
!470 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !50, file: !343, line: 138)
!471 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !472, file: !343, line: 139)
!472 = !DISubprogram(name: "labs", scope: !346, file: !346, line: 838, type: !473, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!473 = !DISubroutineType(types: !474)
!474 = !{!24, !24}
!475 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !476, file: !343, line: 141)
!476 = !DISubprogram(name: "llabs", scope: !346, file: !346, line: 841, type: !477, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!477 = !DISubroutineType(types: !478)
!478 = !{!155, !155}
!479 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !480, file: !343, line: 143)
!480 = !DISubprogram(name: "div", linkageName: "_Z3divxx", scope: !35, file: !35, line: 808, type: !481, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!481 = !DISubroutineType(types: !482)
!482 = !{!355, !155, !155}
!483 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !484, file: !343, line: 144)
!484 = !DISubprogram(name: "ldiv", scope: !346, file: !346, line: 851, type: !485, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!485 = !DISubroutineType(types: !486)
!486 = !{!349, !24, !24}
!487 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !488, file: !343, line: 146)
!488 = !DISubprogram(name: "lldiv", scope: !346, file: !346, line: 855, type: !481, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!489 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !490, file: !343, line: 148)
!490 = !DISubprogram(name: "mblen", scope: !346, file: !346, line: 919, type: !491, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!491 = !DISubroutineType(types: !492)
!492 = !{!7, !174, !27}
!493 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !494, file: !343, line: 149)
!494 = !DISubprogram(name: "mbtowc", scope: !346, file: !346, line: 922, type: !495, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!495 = !DISubroutineType(types: !496)
!496 = !{!7, !497, !381, !27}
!497 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !498)
!498 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !499, size: 64)
!499 = !DIBasicType(name: "wchar_t", size: 32, encoding: DW_ATE_signed)
!500 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !501, file: !343, line: 150)
!501 = !DISubprogram(name: "wctomb", scope: !346, file: !346, line: 926, type: !502, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!502 = !DISubroutineType(types: !503)
!503 = !{!7, !9, !499}
!504 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !505, file: !343, line: 151)
!505 = !DISubprogram(name: "mbstowcs", scope: !346, file: !346, line: 930, type: !506, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!506 = !DISubroutineType(types: !507)
!507 = !{!27, !497, !381, !27}
!508 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !509, file: !343, line: 152)
!509 = !DISubprogram(name: "wcstombs", scope: !346, file: !346, line: 933, type: !510, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!510 = !DISubroutineType(types: !511)
!511 = !{!27, !512, !513, !27}
!512 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !9)
!513 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !514)
!514 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !515, size: 64)
!515 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !499)
!516 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !517, file: !343, line: 154)
!517 = !DISubprogram(name: "at_quick_exit", scope: !346, file: !346, line: 597, type: !440, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!518 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !519, file: !343, line: 155)
!519 = !DISubprogram(name: "quick_exit", scope: !346, file: !346, line: 620, type: !445, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!520 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !12, file: !521, line: 152)
!521 = !DIFile(filename: "build_tool/../usr/include/c++/v1/cstdint", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!522 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !523, file: !521, line: 153)
!523 = !DIDerivedType(tag: DW_TAG_typedef, name: "int16_t", file: !13, line: 25, baseType: !524)
!524 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int16_t", file: !15, line: 38, baseType: !525)
!525 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!526 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !527, file: !521, line: 154)
!527 = !DIDerivedType(tag: DW_TAG_typedef, name: "int32_t", file: !13, line: 26, baseType: !528)
!528 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int32_t", file: !15, line: 40, baseType: !7)
!529 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !530, file: !521, line: 155)
!530 = !DIDerivedType(tag: DW_TAG_typedef, name: "int64_t", file: !13, line: 27, baseType: !531)
!531 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int64_t", file: !15, line: 43, baseType: !24)
!532 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !533, file: !521, line: 157)
!533 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint8_t", file: !534, line: 24, baseType: !535)
!534 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "")
!535 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint8_t", file: !15, line: 37, baseType: !536)
!536 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!537 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !538, file: !521, line: 158)
!538 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint16_t", file: !534, line: 25, baseType: !539)
!539 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint16_t", file: !15, line: 39, baseType: !540)
!540 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!541 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !542, file: !521, line: 159)
!542 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !534, line: 26, baseType: !543)
!543 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !15, line: 41, baseType: !416)
!544 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !545, file: !521, line: 160)
!545 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", file: !534, line: 27, baseType: !546)
!546 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint64_t", file: !15, line: 44, baseType: !28)
!547 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !548, file: !521, line: 162)
!548 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least8_t", file: !549, line: 43, baseType: !16)
!549 = !DIFile(filename: "/usr/include/stdint.h", directory: "")
!550 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !551, file: !521, line: 163)
!551 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least16_t", file: !549, line: 44, baseType: !525)
!552 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !553, file: !521, line: 164)
!553 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least32_t", file: !549, line: 45, baseType: !7)
!554 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !555, file: !521, line: 165)
!555 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least64_t", file: !549, line: 47, baseType: !24)
!556 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !557, file: !521, line: 167)
!557 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least8_t", file: !549, line: 54, baseType: !536)
!558 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !559, file: !521, line: 168)
!559 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least16_t", file: !549, line: 55, baseType: !540)
!560 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !561, file: !521, line: 169)
!561 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least32_t", file: !549, line: 56, baseType: !416)
!562 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !563, file: !521, line: 170)
!563 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least64_t", file: !549, line: 58, baseType: !28)
!564 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !565, file: !521, line: 172)
!565 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast8_t", file: !549, line: 68, baseType: !16)
!566 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !567, file: !521, line: 173)
!567 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast16_t", file: !549, line: 70, baseType: !24)
!568 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !569, file: !521, line: 174)
!569 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast32_t", file: !549, line: 71, baseType: !24)
!570 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !571, file: !521, line: 175)
!571 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast64_t", file: !549, line: 72, baseType: !24)
!572 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !573, file: !521, line: 177)
!573 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast8_t", file: !549, line: 81, baseType: !536)
!574 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !575, file: !521, line: 178)
!575 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast16_t", file: !549, line: 83, baseType: !28)
!576 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !577, file: !521, line: 179)
!577 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast32_t", file: !549, line: 84, baseType: !28)
!578 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !579, file: !521, line: 180)
!579 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast64_t", file: !549, line: 85, baseType: !28)
!580 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !581, file: !521, line: 182)
!581 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !549, line: 97, baseType: !24)
!582 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !583, file: !521, line: 183)
!583 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !549, line: 100, baseType: !28)
!584 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !585, file: !521, line: 185)
!585 = !DIDerivedType(tag: DW_TAG_typedef, name: "intmax_t", file: !549, line: 111, baseType: !586)
!586 = !DIDerivedType(tag: DW_TAG_typedef, name: "__intmax_t", file: !15, line: 61, baseType: !24)
!587 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !20, entity: !588, file: !521, line: 186)
!588 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintmax_t", file: !549, line: 112, baseType: !589)
!589 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uintmax_t", file: !15, line: 62, baseType: !28)
!590 = !{i32 2, !"Dwarf Version", i32 4}
!591 = !{i32 2, !"Debug Info Version", i32 3}
!592 = !{i32 1, !"wchar_size", i32 4}
!593 = !{!"clang version 9.0.0 (tags/RELEASE_900/final)"}
!594 = distinct !DISubprogram(name: "f", linkageName: "_Z1fii", scope: !3, file: !3, line: 8, type: !595, scopeLine: 9, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !597)
!595 = !DISubroutineType(types: !596)
!596 = !{!7, !7, !7}
!597 = !{!598, !599, !600, !601}
!598 = !DILocalVariable(name: "x", arg: 1, scope: !594, file: !3, line: 8, type: !7)
!599 = !DILocalVariable(name: "y", arg: 2, scope: !594, file: !3, line: 8, type: !7)
!600 = !DILocalVariable(name: "tmp", scope: !594, file: !3, line: 10, type: !7)
!601 = !DILocalVariable(name: "i", scope: !602, file: !3, line: 11, type: !7)
!602 = distinct !DILexicalBlock(scope: !594, file: !3, line: 11, column: 5)
!603 = !{!604, !604, i64 0}
!604 = !{!"int", !605, i64 0}
!605 = !{!"omnipotent char", !606, i64 0}
!606 = !{!"Simple C++ TBAA"}
!607 = !DILocation(line: 8, column: 11, scope: !594)
!608 = !DILocation(line: 8, column: 18, scope: !594)
!609 = !DILocation(line: 10, column: 5, scope: !594)
!610 = !DILocation(line: 10, column: 9, scope: !594)
!611 = !DILocation(line: 11, column: 9, scope: !602)
!612 = !DILocation(line: 11, column: 13, scope: !602)
!613 = !DILocation(line: 11, column: 17, scope: !602)
!614 = !DILocation(line: 11, column: 20, scope: !615)
!615 = distinct !DILexicalBlock(scope: !602, file: !3, line: 11, column: 5)
!616 = !DILocation(line: 11, column: 24, scope: !615)
!617 = !DILocation(line: 11, column: 22, scope: !615)
!618 = !DILocation(line: 11, column: 5, scope: !602)
!619 = !DILocation(line: 11, column: 5, scope: !615)
!620 = !DILocation(line: 12, column: 16, scope: !615)
!621 = !DILocation(line: 12, column: 13, scope: !615)
!622 = !DILocation(line: 12, column: 9, scope: !615)
!623 = !DILocation(line: 11, column: 27, scope: !615)
!624 = distinct !{!624, !618, !625}
!625 = !DILocation(line: 12, column: 16, scope: !602)
!626 = !DILocation(line: 13, column: 12, scope: !594)
!627 = !DILocation(line: 13, column: 15, scope: !594)
!628 = !DILocation(line: 13, column: 19, scope: !594)
!629 = !DILocation(line: 13, column: 18, scope: !594)
!630 = !DILocation(line: 13, column: 23, scope: !594)
!631 = !DILocation(line: 13, column: 24, scope: !594)
!632 = !DILocation(line: 13, column: 21, scope: !594)
!633 = !DILocation(line: 14, column: 1, scope: !594)
!634 = !DILocation(line: 13, column: 5, scope: !594)
!635 = distinct !DISubprogram(name: "h", linkageName: "_Z1hi", scope: !3, file: !3, line: 16, type: !636, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !638)
!636 = !DISubroutineType(types: !637)
!637 = !{!7, !7}
!638 = !{!639, !640, !641}
!639 = !DILocalVariable(name: "x", arg: 1, scope: !635, file: !3, line: 16, type: !7)
!640 = !DILocalVariable(name: "tmp", scope: !635, file: !3, line: 18, type: !7)
!641 = !DILocalVariable(name: "i", scope: !642, file: !3, line: 19, type: !7)
!642 = distinct !DILexicalBlock(scope: !635, file: !3, line: 19, column: 5)
!643 = !DILocation(line: 16, column: 11, scope: !635)
!644 = !DILocation(line: 18, column: 5, scope: !635)
!645 = !DILocation(line: 18, column: 9, scope: !635)
!646 = !DILocation(line: 19, column: 9, scope: !642)
!647 = !DILocation(line: 19, column: 13, scope: !642)
!648 = !DILocation(line: 19, column: 17, scope: !642)
!649 = !DILocation(line: 19, column: 20, scope: !650)
!650 = distinct !DILexicalBlock(scope: !642, file: !3, line: 19, column: 5)
!651 = !DILocation(line: 19, column: 22, scope: !650)
!652 = !DILocation(line: 19, column: 5, scope: !642)
!653 = !DILocation(line: 19, column: 5, scope: !650)
!654 = !DILocation(line: 20, column: 16, scope: !650)
!655 = !DILocation(line: 20, column: 13, scope: !650)
!656 = !DILocation(line: 20, column: 9, scope: !650)
!657 = !DILocation(line: 19, column: 29, scope: !650)
!658 = distinct !{!658, !652, !659}
!659 = !DILocation(line: 20, column: 16, scope: !642)
!660 = !DILocation(line: 21, column: 18, scope: !635)
!661 = !DILocation(line: 21, column: 16, scope: !635)
!662 = !DILocation(line: 21, column: 12, scope: !635)
!663 = !DILocation(line: 21, column: 39, scope: !635)
!664 = !DILocation(line: 21, column: 22, scope: !635)
!665 = !DILocation(line: 21, column: 20, scope: !635)
!666 = !DILocation(line: 22, column: 1, scope: !635)
!667 = !DILocation(line: 21, column: 5, scope: !635)
!668 = distinct !DISubprogram(name: "g", linkageName: "_Z1gi", scope: !3, file: !3, line: 24, type: !636, scopeLine: 25, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !669)
!669 = !{!670}
!670 = !DILocalVariable(name: "x", arg: 1, scope: !668, file: !3, line: 24, type: !7)
!671 = !DILocation(line: 24, column: 11, scope: !668)
!672 = !DILocation(line: 26, column: 12, scope: !668)
!673 = !DILocation(line: 26, column: 29, scope: !668)
!674 = !DILocation(line: 26, column: 27, scope: !668)
!675 = !DILocation(line: 26, column: 23, scope: !668)
!676 = !DILocation(line: 26, column: 50, scope: !668)
!677 = !DILocation(line: 26, column: 33, scope: !668)
!678 = !DILocation(line: 26, column: 31, scope: !668)
!679 = !DILocation(line: 26, column: 21, scope: !668)
!680 = !DILocation(line: 26, column: 5, scope: !668)
!681 = distinct !DISubprogram(name: "i", linkageName: "_Z1iiii", scope: !3, file: !3, line: 29, type: !682, scopeLine: 30, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !684)
!682 = !DISubroutineType(types: !683)
!683 = !{!7, !7, !7, !7}
!684 = !{!685, !686, !687, !688, !689}
!685 = !DILocalVariable(name: "x1", arg: 1, scope: !681, file: !3, line: 29, type: !7)
!686 = !DILocalVariable(name: "x2", arg: 2, scope: !681, file: !3, line: 29, type: !7)
!687 = !DILocalVariable(name: "x3", arg: 3, scope: !681, file: !3, line: 29, type: !7)
!688 = !DILocalVariable(name: "tmp", scope: !681, file: !3, line: 31, type: !7)
!689 = !DILocalVariable(name: "i", scope: !690, file: !3, line: 32, type: !7)
!690 = distinct !DILexicalBlock(scope: !681, file: !3, line: 32, column: 5)
!691 = !DILocation(line: 29, column: 11, scope: !681)
!692 = !DILocation(line: 29, column: 19, scope: !681)
!693 = !DILocation(line: 29, column: 27, scope: !681)
!694 = !DILocation(line: 31, column: 5, scope: !681)
!695 = !DILocation(line: 31, column: 9, scope: !681)
!696 = !DILocation(line: 32, column: 9, scope: !690)
!697 = !DILocation(line: 32, column: 13, scope: !690)
!698 = !DILocation(line: 32, column: 17, scope: !690)
!699 = !DILocation(line: 32, column: 21, scope: !700)
!700 = distinct !DILexicalBlock(scope: !690, file: !3, line: 32, column: 5)
!701 = !DILocation(line: 32, column: 25, scope: !700)
!702 = !DILocation(line: 32, column: 23, scope: !700)
!703 = !DILocation(line: 32, column: 5, scope: !690)
!704 = !DILocation(line: 32, column: 5, scope: !700)
!705 = !DILocation(line: 33, column: 16, scope: !700)
!706 = !DILocation(line: 33, column: 17, scope: !700)
!707 = !DILocation(line: 33, column: 13, scope: !700)
!708 = !DILocation(line: 33, column: 9, scope: !700)
!709 = !DILocation(line: 32, column: 34, scope: !700)
!710 = !DILocation(line: 32, column: 31, scope: !700)
!711 = distinct !{!711, !703, !712}
!712 = !DILocation(line: 33, column: 18, scope: !690)
!713 = !DILocation(line: 34, column: 18, scope: !681)
!714 = !DILocation(line: 34, column: 16, scope: !681)
!715 = !DILocation(line: 34, column: 23, scope: !681)
!716 = !DILocation(line: 34, column: 21, scope: !681)
!717 = !DILocation(line: 34, column: 28, scope: !681)
!718 = !DILocation(line: 34, column: 31, scope: !681)
!719 = !DILocation(line: 34, column: 26, scope: !681)
!720 = !DILocation(line: 35, column: 1, scope: !681)
!721 = !DILocation(line: 34, column: 5, scope: !681)
!722 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 37, type: !723, scopeLine: 38, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !725)
!723 = !DISubroutineType(types: !724)
!724 = !{!7, !7, !8}
!725 = !{!726, !727, !728, !729, !730}
!726 = !DILocalVariable(name: "argc", arg: 1, scope: !722, file: !3, line: 37, type: !7)
!727 = !DILocalVariable(name: "argv", arg: 2, scope: !722, file: !3, line: 37, type: !8)
!728 = !DILocalVariable(name: "x1", scope: !722, file: !3, line: 39, type: !7)
!729 = !DILocalVariable(name: "x2", scope: !722, file: !3, line: 40, type: !7)
!730 = !DILocalVariable(name: "y", scope: !722, file: !3, line: 44, type: !7)
!731 = !DILocation(line: 37, column: 14, scope: !722)
!732 = !{!733, !733, i64 0}
!733 = !{!"any pointer", !605, i64 0}
!734 = !DILocation(line: 37, column: 28, scope: !722)
!735 = !DILocation(line: 39, column: 5, scope: !722)
!736 = !DILocation(line: 39, column: 9, scope: !722)
!737 = !DILocation(line: 39, column: 26, scope: !722)
!738 = !DILocation(line: 39, column: 21, scope: !722)
!739 = !DILocation(line: 40, column: 5, scope: !722)
!740 = !DILocation(line: 40, column: 9, scope: !722)
!741 = !DILocation(line: 40, column: 26, scope: !722)
!742 = !DILocation(line: 40, column: 21, scope: !722)
!743 = !DILocation(line: 41, column: 5, scope: !722)
!744 = !DILocation(line: 42, column: 5, scope: !722)
!745 = !DILocation(line: 43, column: 5, scope: !722)
!746 = !DILocation(line: 44, column: 5, scope: !722)
!747 = !DILocation(line: 44, column: 9, scope: !722)
!748 = !DILocation(line: 44, column: 15, scope: !722)
!749 = !DILocation(line: 44, column: 14, scope: !722)
!750 = !DILocation(line: 44, column: 18, scope: !722)
!751 = !DILocation(line: 47, column: 7, scope: !722)
!752 = !DILocation(line: 47, column: 15, scope: !722)
!753 = !DILocation(line: 47, column: 5, scope: !722)
!754 = !DILocation(line: 49, column: 5, scope: !722)
!755 = !DILocation(line: 51, column: 7, scope: !722)
!756 = !DILocation(line: 51, column: 5, scope: !722)
!757 = !DILocation(line: 52, column: 5, scope: !722)
!758 = !DILocation(line: 54, column: 7, scope: !722)
!759 = !DILocation(line: 54, column: 11, scope: !722)
!760 = !DILocation(line: 54, column: 9, scope: !722)
!761 = !DILocation(line: 54, column: 15, scope: !722)
!762 = !DILocation(line: 54, column: 5, scope: !722)
!763 = !DILocation(line: 57, column: 1, scope: !722)
!764 = !DILocation(line: 56, column: 5, scope: !722)
!765 = !DILocation(line: 361, column: 1, scope: !364)
!766 = !DILocation(line: 363, column: 24, scope: !364)
!767 = !DILocation(line: 363, column: 16, scope: !364)
!768 = !DILocation(line: 363, column: 3, scope: !364)
!769 = distinct !DISubprogram(name: "register_variable<int>", linkageName: "_Z17register_variableIiEvPT_PKc", scope: !770, file: !770, line: 14, type: !771, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, templateParams: !777, retainedNodes: !773)
!770 = !DIFile(filename: "include/ExtraPInstrumenter.hpp", directory: "/home/mcopik/projects/ETH/extrap/rebuild/extrap-tool")
!771 = !DISubroutineType(types: !772)
!772 = !{null, !84, !174}
!773 = !{!774, !775, !776}
!774 = !DILocalVariable(name: "ptr", arg: 1, scope: !769, file: !770, line: 14, type: !84)
!775 = !DILocalVariable(name: "name", arg: 2, scope: !769, file: !770, line: 14, type: !174)
!776 = !DILocalVariable(name: "param_id", scope: !769, file: !770, line: 16, type: !527)
!777 = !{!778}
!778 = !DITemplateTypeParameter(name: "T", type: !7)
!779 = !DILocation(line: 14, column: 28, scope: !769)
!780 = !DILocation(line: 14, column: 46, scope: !769)
!781 = !DILocation(line: 16, column: 5, scope: !769)
!782 = !DILocation(line: 16, column: 13, scope: !769)
!783 = !DILocation(line: 16, column: 24, scope: !769)
!784 = !DILocation(line: 17, column: 57, scope: !769)
!785 = !DILocation(line: 17, column: 31, scope: !769)
!786 = !DILocation(line: 18, column: 21, scope: !769)
!787 = !DILocation(line: 18, column: 25, scope: !769)
!788 = !DILocation(line: 17, column: 5, scope: !769)
!789 = !DILocation(line: 19, column: 1, scope: !769)