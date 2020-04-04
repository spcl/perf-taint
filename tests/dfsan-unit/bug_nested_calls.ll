; RUN: opt %dfsan -S < %s 2> /dev/null | llc %llcparams - -o %t1 && clang++ %link %t1 -o %t2 && %execparams %t2 10 10 | diff -w %s.json -
; RUN: %jsonconvert %s.json 2> /dev/null | diff -w %s.processed.json -
; ModuleID = 'tests/dfsan-unit/bug_nested_calls.cpp'
source_filename = "tests/dfsan-unit/bug_nested_calls.cpp"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

$_Z17register_variableIiEvPT_PKc = comdat any

@.str = private unnamed_addr constant [7 x i8] c"extrap\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [38 x i8] c"tests/dfsan-unit/bug_nested_calls.cpp\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [3 x i8] c"x1\00", align 1
@.str.3 = private unnamed_addr constant [3 x i8] c"x2\00", align 1

; Function Attrs: nounwind uwtable
define dso_local void @_Z2f1ii(i32, i32) #0 !dbg !591 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i32 %0, i32* %3, align 4, !tbaa !600
  call void @llvm.dbg.declare(metadata i32* %3, metadata !595, metadata !DIExpression()), !dbg !604
  store i32 %1, i32* %4, align 4, !tbaa !600
  call void @llvm.dbg.declare(metadata i32* %4, metadata !596, metadata !DIExpression()), !dbg !605
  %7 = bitcast i32* %5 to i8*, !dbg !606
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %7) #4, !dbg !606
  call void @llvm.dbg.declare(metadata i32* %5, metadata !597, metadata !DIExpression()), !dbg !607
  store i32 0, i32* %5, align 4, !dbg !607, !tbaa !600
  %8 = bitcast i32* %6 to i8*, !dbg !608
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %8) #4, !dbg !608
  call void @llvm.dbg.declare(metadata i32* %6, metadata !598, metadata !DIExpression()), !dbg !609
  store i32 0, i32* %6, align 4, !dbg !609, !tbaa !600
  br label %9, !dbg !608

9:                                                ; preds = %22, %2
  %10 = load i32, i32* %6, align 4, !dbg !610, !tbaa !600
  %11 = icmp slt i32 %10, 100, !dbg !612
  br i1 %11, label %14, label %12, !dbg !613

12:                                               ; preds = %9
  %13 = bitcast i32* %6 to i8*, !dbg !614
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %13) #4, !dbg !614
  br label %25

14:                                               ; preds = %9
  %15 = load i32, i32* %6, align 4, !dbg !615, !tbaa !600
  %16 = sitofp i32 %15 to double, !dbg !615
  %17 = fmul double %16, 1.100000e+00, !dbg !617
  %18 = load i32, i32* %5, align 4, !dbg !618, !tbaa !600
  %19 = sitofp i32 %18 to double, !dbg !618
  %20 = fadd double %19, %17, !dbg !618
  %21 = fptosi double %20 to i32, !dbg !618
  store i32 %21, i32* %5, align 4, !dbg !618, !tbaa !600
  br label %22, !dbg !619

22:                                               ; preds = %14
  %23 = load i32, i32* %6, align 4, !dbg !620, !tbaa !600
  %24 = add nsw i32 %23, 1, !dbg !620
  store i32 %24, i32* %6, align 4, !dbg !620, !tbaa !600
  br label %9, !dbg !614, !llvm.loop !621

25:                                               ; preds = %12
  %26 = bitcast i32* %5 to i8*, !dbg !623
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %26) #4, !dbg !623
  ret void, !dbg !623
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: nounwind uwtable
define dso_local void @_Z2f2ii(i32, i32) #0 !dbg !624 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i32 %0, i32* %3, align 4, !tbaa !600
  call void @llvm.dbg.declare(metadata i32* %3, metadata !626, metadata !DIExpression()), !dbg !631
  store i32 %1, i32* %4, align 4, !tbaa !600
  call void @llvm.dbg.declare(metadata i32* %4, metadata !627, metadata !DIExpression()), !dbg !632
  %7 = bitcast i32* %5 to i8*, !dbg !633
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %7) #4, !dbg !633
  call void @llvm.dbg.declare(metadata i32* %5, metadata !628, metadata !DIExpression()), !dbg !634
  store i32 0, i32* %5, align 4, !dbg !634, !tbaa !600
  %8 = bitcast i32* %6 to i8*, !dbg !635
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %8) #4, !dbg !635
  call void @llvm.dbg.declare(metadata i32* %6, metadata !629, metadata !DIExpression()), !dbg !636
  %9 = load i32, i32* %3, align 4, !dbg !637, !tbaa !600
  store i32 %9, i32* %6, align 4, !dbg !636, !tbaa !600
  br label %10, !dbg !635

10:                                               ; preds = %24, %2
  %11 = load i32, i32* %6, align 4, !dbg !638, !tbaa !600
  %12 = load i32, i32* %4, align 4, !dbg !640, !tbaa !600
  %13 = icmp slt i32 %11, %12, !dbg !641
  br i1 %13, label %16, label %14, !dbg !642

14:                                               ; preds = %10
  %15 = bitcast i32* %6 to i8*, !dbg !643
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %15) #4, !dbg !643
  br label %27

16:                                               ; preds = %10
  %17 = load i32, i32* %6, align 4, !dbg !644, !tbaa !600
  %18 = sitofp i32 %17 to double, !dbg !644
  %19 = fmul double %18, 1.100000e+00, !dbg !645
  %20 = load i32, i32* %5, align 4, !dbg !646, !tbaa !600
  %21 = sitofp i32 %20 to double, !dbg !646
  %22 = fadd double %21, %19, !dbg !646
  %23 = fptosi double %22 to i32, !dbg !646
  store i32 %23, i32* %5, align 4, !dbg !646, !tbaa !600
  br label %24, !dbg !647

24:                                               ; preds = %16
  %25 = load i32, i32* %6, align 4, !dbg !648, !tbaa !600
  %26 = add nsw i32 %25, 1, !dbg !648
  store i32 %26, i32* %6, align 4, !dbg !648, !tbaa !600
  br label %10, !dbg !643, !llvm.loop !649

27:                                               ; preds = %14
  %28 = bitcast i32* %5 to i8*, !dbg !651
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %28) #4, !dbg !651
  ret void, !dbg !651
}

; Function Attrs: nounwind uwtable
define dso_local void @_Z2f3ii(i32, i32) #0 !dbg !652 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i32 %0, i32* %3, align 4, !tbaa !600
  call void @llvm.dbg.declare(metadata i32* %3, metadata !654, metadata !DIExpression()), !dbg !659
  store i32 %1, i32* %4, align 4, !tbaa !600
  call void @llvm.dbg.declare(metadata i32* %4, metadata !655, metadata !DIExpression()), !dbg !660
  %7 = bitcast i32* %5 to i8*, !dbg !661
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %7) #4, !dbg !661
  call void @llvm.dbg.declare(metadata i32* %5, metadata !656, metadata !DIExpression()), !dbg !662
  store i32 0, i32* %5, align 4, !dbg !662, !tbaa !600
  %8 = bitcast i32* %6 to i8*, !dbg !663
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %8) #4, !dbg !663
  call void @llvm.dbg.declare(metadata i32* %6, metadata !657, metadata !DIExpression()), !dbg !664
  %9 = load i32, i32* %3, align 4, !dbg !665, !tbaa !600
  store i32 %9, i32* %6, align 4, !dbg !664, !tbaa !600
  br label %10, !dbg !663

10:                                               ; preds = %23, %2
  %11 = load i32, i32* %6, align 4, !dbg !666, !tbaa !600
  %12 = icmp slt i32 %11, 20, !dbg !668
  br i1 %12, label %15, label %13, !dbg !669

13:                                               ; preds = %10
  %14 = bitcast i32* %6 to i8*, !dbg !670
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %14) #4, !dbg !670
  br label %26

15:                                               ; preds = %10
  %16 = load i32, i32* %6, align 4, !dbg !671, !tbaa !600
  %17 = sitofp i32 %16 to double, !dbg !671
  %18 = fmul double %17, 1.100000e+00, !dbg !672
  %19 = load i32, i32* %5, align 4, !dbg !673, !tbaa !600
  %20 = sitofp i32 %19 to double, !dbg !673
  %21 = fadd double %20, %18, !dbg !673
  %22 = fptosi double %21 to i32, !dbg !673
  store i32 %22, i32* %5, align 4, !dbg !673, !tbaa !600
  br label %23, !dbg !674

23:                                               ; preds = %15
  %24 = load i32, i32* %6, align 4, !dbg !675, !tbaa !600
  %25 = add nsw i32 %24, 1, !dbg !675
  store i32 %25, i32* %6, align 4, !dbg !675, !tbaa !600
  br label %10, !dbg !670, !llvm.loop !676

26:                                               ; preds = %13
  %27 = bitcast i32* %5 to i8*, !dbg !678
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %27) #4, !dbg !678
  ret void, !dbg !678
}

; Function Attrs: nounwind uwtable
define dso_local void @_Z1gii(i32, i32) #0 !dbg !679 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, i32* %3, align 4, !tbaa !600
  call void @llvm.dbg.declare(metadata i32* %3, metadata !681, metadata !DIExpression()), !dbg !683
  store i32 %1, i32* %4, align 4, !tbaa !600
  call void @llvm.dbg.declare(metadata i32* %4, metadata !682, metadata !DIExpression()), !dbg !684
  %5 = load i32, i32* %3, align 4, !dbg !685, !tbaa !600
  %6 = load i32, i32* %4, align 4, !dbg !686, !tbaa !600
  call void @_Z2f1ii(i32 %5, i32 %6), !dbg !687
  %7 = load i32, i32* %3, align 4, !dbg !688, !tbaa !600
  %8 = load i32, i32* %4, align 4, !dbg !689, !tbaa !600
  call void @_Z2f2ii(i32 %7, i32 %8), !dbg !690
  %9 = load i32, i32* %3, align 4, !dbg !691, !tbaa !600
  %10 = load i32, i32* %4, align 4, !dbg !692, !tbaa !600
  call void @_Z2f3ii(i32 %9, i32 %10), !dbg !693
  ret void, !dbg !694
}

; Function Attrs: nounwind uwtable
define dso_local void @_Z2g2ii(i32, i32) #0 !dbg !695 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, i32* %3, align 4, !tbaa !600
  call void @llvm.dbg.declare(metadata i32* %3, metadata !697, metadata !DIExpression()), !dbg !699
  store i32 %1, i32* %4, align 4, !tbaa !600
  call void @llvm.dbg.declare(metadata i32* %4, metadata !698, metadata !DIExpression()), !dbg !700
  %5 = load i32, i32* %3, align 4, !dbg !701, !tbaa !600
  %6 = load i32, i32* %4, align 4, !dbg !702, !tbaa !600
  call void @_Z2f1ii(i32 %5, i32 %6), !dbg !703
  %7 = load i32, i32* %3, align 4, !dbg !704, !tbaa !600
  %8 = load i32, i32* %4, align 4, !dbg !705, !tbaa !600
  call void @_Z2f2ii(i32 %7, i32 %8), !dbg !706
  %9 = load i32, i32* %3, align 4, !dbg !707, !tbaa !600
  %10 = load i32, i32* %4, align 4, !dbg !708, !tbaa !600
  call void @_Z2f3ii(i32 %9, i32 %10), !dbg !709
  ret void, !dbg !710
}

; Function Attrs: nounwind uwtable
define dso_local void @_Z2g3ii(i32, i32) #0 !dbg !711 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, i32* %3, align 4, !tbaa !600
  call void @llvm.dbg.declare(metadata i32* %3, metadata !713, metadata !DIExpression()), !dbg !715
  store i32 %1, i32* %4, align 4, !tbaa !600
  call void @llvm.dbg.declare(metadata i32* %4, metadata !714, metadata !DIExpression()), !dbg !716
  %5 = load i32, i32* %3, align 4, !dbg !717, !tbaa !600
  %6 = load i32, i32* %4, align 4, !dbg !718, !tbaa !600
  call void @_Z2f1ii(i32 %5, i32 %6), !dbg !719
  %7 = load i32, i32* %3, align 4, !dbg !720, !tbaa !600
  %8 = load i32, i32* %4, align 4, !dbg !721, !tbaa !600
  call void @_Z2f2ii(i32 %7, i32 %8), !dbg !722
  %9 = load i32, i32* %3, align 4, !dbg !723, !tbaa !600
  %10 = load i32, i32* %4, align 4, !dbg !724, !tbaa !600
  call void @_Z2f3ii(i32 %9, i32 %10), !dbg !725
  ret void, !dbg !726
}

; Function Attrs: nounwind uwtable
define dso_local i32 @_Z1fii(i32, i32) #0 !dbg !727 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store i32 %0, i32* %3, align 4, !tbaa !600
  call void @llvm.dbg.declare(metadata i32* %3, metadata !731, metadata !DIExpression()), !dbg !740
  store i32 %1, i32* %4, align 4, !tbaa !600
  call void @llvm.dbg.declare(metadata i32* %4, metadata !732, metadata !DIExpression()), !dbg !741
  %9 = bitcast i32* %5 to i8*, !dbg !742
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %9) #4, !dbg !742
  call void @llvm.dbg.declare(metadata i32* %5, metadata !733, metadata !DIExpression()), !dbg !743
  store i32 0, i32* %5, align 4, !dbg !743, !tbaa !600
  %10 = bitcast i32* %6 to i8*, !dbg !744
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %10) #4, !dbg !744
  call void @llvm.dbg.declare(metadata i32* %6, metadata !734, metadata !DIExpression()), !dbg !745
  store i32 0, i32* %6, align 4, !dbg !745, !tbaa !600
  br label %11, !dbg !744

11:                                               ; preds = %41, %2
  %12 = load i32, i32* %6, align 4, !dbg !746, !tbaa !600
  %13 = load i32, i32* %4, align 4, !dbg !747, !tbaa !600
  %14 = icmp slt i32 %12, %13, !dbg !748
  br i1 %14, label %17, label %15, !dbg !749

15:                                               ; preds = %11
  store i32 2, i32* %7, align 4
  %16 = bitcast i32* %6 to i8*, !dbg !750
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %16) #4, !dbg !750
  br label %44

17:                                               ; preds = %11
  %18 = load i32, i32* %6, align 4, !dbg !751, !tbaa !600
  %19 = sitofp i32 %18 to double, !dbg !751
  %20 = fmul double %19, 1.100000e+00, !dbg !752
  %21 = load i32, i32* %5, align 4, !dbg !753, !tbaa !600
  %22 = sitofp i32 %21 to double, !dbg !753
  %23 = fadd double %22, %20, !dbg !753
  %24 = fptosi double %23 to i32, !dbg !753
  store i32 %24, i32* %5, align 4, !dbg !753, !tbaa !600
  %25 = bitcast i32* %8 to i8*, !dbg !754
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %25) #4, !dbg !754
  call void @llvm.dbg.declare(metadata i32* %8, metadata !736, metadata !DIExpression()), !dbg !755
  store i32 0, i32* %8, align 4, !dbg !755, !tbaa !600
  br label %26, !dbg !754

26:                                               ; preds = %35, %17
  %27 = load i32, i32* %8, align 4, !dbg !756, !tbaa !600
  %28 = load i32, i32* %3, align 4, !dbg !758, !tbaa !600
  %29 = icmp slt i32 %27, %28, !dbg !759
  br i1 %29, label %32, label %30, !dbg !760

30:                                               ; preds = %26
  store i32 5, i32* %7, align 4
  %31 = bitcast i32* %8 to i8*, !dbg !761
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %31) #4, !dbg !761
  br label %38

32:                                               ; preds = %26
  %33 = load i32, i32* %3, align 4, !dbg !762, !tbaa !600
  %34 = load i32, i32* %4, align 4, !dbg !763, !tbaa !600
  call void @_Z1gii(i32 %33, i32 %34), !dbg !764
  br label %35, !dbg !764

35:                                               ; preds = %32
  %36 = load i32, i32* %8, align 4, !dbg !765, !tbaa !600
  %37 = add nsw i32 %36, 1, !dbg !765
  store i32 %37, i32* %8, align 4, !dbg !765, !tbaa !600
  br label %26, !dbg !761, !llvm.loop !766

38:                                               ; preds = %30
  %39 = load i32, i32* %4, align 4, !dbg !768, !tbaa !600
  %40 = load i32, i32* %3, align 4, !dbg !769, !tbaa !600
  call void @_Z2g2ii(i32 %39, i32 %40), !dbg !770
  br label %41, !dbg !771

41:                                               ; preds = %38
  %42 = load i32, i32* %6, align 4, !dbg !772, !tbaa !600
  %43 = add nsw i32 %42, 1, !dbg !772
  store i32 %43, i32* %6, align 4, !dbg !772, !tbaa !600
  br label %11, !dbg !750, !llvm.loop !773

44:                                               ; preds = %15
  %45 = load i32, i32* %3, align 4, !dbg !775, !tbaa !600
  call void @_Z1gii(i32 %45, i32 100), !dbg !776
  %46 = load i32, i32* %3, align 4, !dbg !777, !tbaa !600
  %47 = mul nsw i32 100, %46, !dbg !778
  %48 = load i32, i32* %4, align 4, !dbg !779, !tbaa !600
  %49 = mul nsw i32 %47, %48, !dbg !780
  %50 = add nsw i32 %49, 2, !dbg !781
  store i32 1, i32* %7, align 4
  %51 = bitcast i32* %5 to i8*, !dbg !782
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %51) #4, !dbg !782
  ret i32 %50, !dbg !783
}

; Function Attrs: norecurse uwtable
define dso_local i32 @main(i32, i8**) #3 !dbg !784 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4, !tbaa !600
  call void @llvm.dbg.declare(metadata i32* %4, metadata !788, metadata !DIExpression()), !dbg !792
  store i8** %1, i8*** %5, align 8, !tbaa !793
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !789, metadata !DIExpression()), !dbg !795
  %8 = bitcast i32* %6 to i8*, !dbg !796
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %8) #4, !dbg !796
  call void @llvm.dbg.declare(metadata i32* %6, metadata !790, metadata !DIExpression()), !dbg !797
  %9 = bitcast i32* %6 to i8*, !dbg !796
  call void @llvm.var.annotation(i8* %9, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([38 x i8], [38 x i8]* @.str.1, i32 0, i32 0), i32 68), !dbg !796
  %10 = load i8**, i8*** %5, align 8, !dbg !798, !tbaa !793
  %11 = getelementptr inbounds i8*, i8** %10, i64 1, !dbg !798
  %12 = load i8*, i8** %11, align 8, !dbg !798, !tbaa !793
  %13 = call i32 @atoi(i8* %12) #9, !dbg !799
  store i32 %13, i32* %6, align 4, !dbg !797, !tbaa !600
  %14 = bitcast i32* %7 to i8*, !dbg !800
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %14) #4, !dbg !800
  call void @llvm.dbg.declare(metadata i32* %7, metadata !791, metadata !DIExpression()), !dbg !801
  %15 = bitcast i32* %7 to i8*, !dbg !800
  call void @llvm.var.annotation(i8* %15, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([38 x i8], [38 x i8]* @.str.1, i32 0, i32 0), i32 69), !dbg !800
  %16 = load i8**, i8*** %5, align 8, !dbg !802, !tbaa !793
  %17 = getelementptr inbounds i8*, i8** %16, i64 2, !dbg !802
  %18 = load i8*, i8** %17, align 8, !dbg !802, !tbaa !793
  %19 = call i32 @atoi(i8* %18) #9, !dbg !803
  %20 = mul nsw i32 2, %19, !dbg !804
  store i32 %20, i32* %7, align 4, !dbg !801, !tbaa !600
  call void @_Z17register_variableIiEvPT_PKc(i32* %6, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.2, i64 0, i64 0)), !dbg !805
  call void @_Z17register_variableIiEvPT_PKc(i32* %7, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.3, i64 0, i64 0)), !dbg !806
  %21 = load i32, i32* %6, align 4, !dbg !807, !tbaa !600
  %22 = load i32, i32* %7, align 4, !dbg !808, !tbaa !600
  %23 = call i32 @_Z1fii(i32 %21, i32 %22), !dbg !809
  %24 = bitcast i32* %7 to i8*, !dbg !810
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %24) #4, !dbg !810
  %25 = bitcast i32* %6 to i8*, !dbg !810
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %25) #4, !dbg !810
  ret i32 0, !dbg !811
}

; Function Attrs: nounwind
declare void @llvm.var.annotation(i8*, i8*, i8*, i32) #4

; Function Attrs: inlinehint nounwind readonly uwtable
define available_externally dso_local i32 @atoi(i8* nonnull) #5 !dbg !361 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8, !tbaa !793
  call void @llvm.dbg.declare(metadata i8** %2, metadata !365, metadata !DIExpression()), !dbg !812
  %3 = load i8*, i8** %2, align 8, !dbg !813, !tbaa !793
  %4 = call i64 @strtol(i8* %3, i8** null, i32 10) #4, !dbg !814
  %5 = trunc i64 %4 to i32, !dbg !814
  ret i32 %5, !dbg !815
}

; Function Attrs: uwtable
define linkonce_odr dso_local void @_Z17register_variableIiEvPT_PKc(i32*, i8*) #6 comdat !dbg !816 {
  %3 = alloca i32*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca i32, align 4
  store i32* %0, i32** %3, align 8, !tbaa !793
  call void @llvm.dbg.declare(metadata i32** %3, metadata !821, metadata !DIExpression()), !dbg !826
  store i8* %1, i8** %4, align 8, !tbaa !793
  call void @llvm.dbg.declare(metadata i8** %4, metadata !822, metadata !DIExpression()), !dbg !827
  %6 = bitcast i32* %5 to i8*, !dbg !828
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %6) #4, !dbg !828
  call void @llvm.dbg.declare(metadata i32* %5, metadata !823, metadata !DIExpression()), !dbg !829
  %7 = call i32 @__dfsw_EXTRAP_VAR_ID(), !dbg !830
  store i32 %7, i32* %5, align 4, !dbg !829, !tbaa !600
  %8 = load i32*, i32** %3, align 8, !dbg !831, !tbaa !793
  %9 = bitcast i32* %8 to i8*, !dbg !832
  %10 = load i32, i32* %5, align 4, !dbg !833, !tbaa !600
  %11 = add nsw i32 %10, 1, !dbg !833
  store i32 %11, i32* %5, align 4, !dbg !833, !tbaa !600
  %12 = load i8*, i8** %4, align 8, !dbg !834, !tbaa !793
  call void @__dfsw_EXTRAP_STORE_LABEL(i8* %9, i32 4, i32 %10, i8* %12), !dbg !835
  %13 = bitcast i32* %5 to i8*, !dbg !836
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %13) #4, !dbg !836
  ret void, !dbg !836
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

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!587, !588, !589}
!llvm.ident = !{!590}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !1, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !3, imports: !14, nameTableKind: None)
!1 = !DIFile(filename: "tests/dfsan-unit/bug_nested_calls.cpp", directory: "/home/mcopik/projects/ETH/extrap/rebuild/perf-taint")
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
!14 = !{!15, !22, !25, !29, !37, !39, !43, !46, !50, !55, !57, !59, !63, !65, !67, !69, !71, !73, !75, !77, !82, !86, !88, !90, !95, !100, !102, !104, !106, !108, !110, !112, !114, !116, !118, !120, !122, !124, !126, !128, !130, !132, !136, !138, !140, !142, !146, !148, !153, !155, !157, !159, !161, !165, !167, !173, !177, !179, !181, !185, !187, !191, !193, !195, !199, !201, !203, !205, !207, !209, !211, !215, !217, !219, !221, !223, !225, !227, !229, !233, !237, !239, !241, !243, !245, !247, !249, !251, !253, !255, !257, !259, !261, !263, !265, !267, !269, !271, !273, !275, !279, !281, !283, !285, !289, !291, !295, !297, !299, !301, !303, !307, !309, !313, !315, !317, !319, !321, !325, !327, !329, !333, !335, !337, !339, !341, !345, !351, !357, !360, !366, !370, !374, !380, !384, !388, !392, !396, !400, !405, !409, !414, !419, !423, !427, !431, !435, !440, !444, !446, !450, !452, !463, !467, !468, !472, !476, !480, !484, !486, !490, !497, !501, !505, !513, !515, !517, !519, !523, !526, !529, !534, !538, !541, !544, !547, !549, !551, !553, !555, !557, !559, !561, !563, !565, !567, !569, !571, !573, !575, !577, !579, !581, !584}
!15 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !18, file: !21, line: 49)
!16 = !DINamespace(name: "__1", scope: !17, exportSymbols: true)
!17 = !DINamespace(name: "std", scope: null)
!18 = !DIDerivedType(tag: DW_TAG_typedef, name: "ptrdiff_t", file: !19, line: 35, baseType: !20)
!19 = !DIFile(filename: "clang_llvm/llvm-9.0/build-9.0/lib/clang/9.0.0/include/stddef.h", directory: "/home/mcopik/projects")
!20 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!21 = !DIFile(filename: "build_tool/../usr/include/c++/v1/cstddef", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!22 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !23, file: !21, line: 50)
!23 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !19, line: 46, baseType: !24)
!24 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!25 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !26, file: !21, line: 55)
!26 = !DIDerivedType(tag: DW_TAG_typedef, name: "max_align_t", file: !27, line: 24, baseType: !28)
!27 = !DIFile(filename: "clang_llvm/llvm-9.0/build-9.0/lib/clang/9.0.0/include/__stddef_max_align_t.h", directory: "/home/mcopik/projects")
!28 = !DICompositeType(tag: DW_TAG_structure_type, file: !27, line: 19, flags: DIFlagFwdDecl, identifier: "_ZTS11max_align_t")
!29 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !30, file: !36, line: 316)
!30 = !DISubprogram(name: "isinf", linkageName: "_Z5isinfe", scope: !31, file: !31, line: 499, type: !32, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!31 = !DIFile(filename: "build_tool/../usr/include/c++/v1/math.h", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!32 = !DISubroutineType(types: !33)
!33 = !{!34, !35}
!34 = !DIBasicType(name: "bool", size: 8, encoding: DW_ATE_boolean)
!35 = !DIBasicType(name: "long double", size: 128, encoding: DW_ATE_float)
!36 = !DIFile(filename: "build_tool/../usr/include/c++/v1/cmath", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!37 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !38, file: !36, line: 317)
!38 = !DISubprogram(name: "isnan", linkageName: "_Z5isnane", scope: !31, file: !31, line: 543, type: !32, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!39 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !40, file: !36, line: 327)
!40 = !DIDerivedType(tag: DW_TAG_typedef, name: "float_t", file: !41, line: 149, baseType: !42)
!41 = !DIFile(filename: "/usr/include/math.h", directory: "")
!42 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!43 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !44, file: !36, line: 328)
!44 = !DIDerivedType(tag: DW_TAG_typedef, name: "double_t", file: !41, line: 150, baseType: !45)
!45 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!46 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !47, file: !36, line: 331)
!47 = !DISubprogram(name: "abs", linkageName: "_Z3abse", scope: !31, file: !31, line: 789, type: !48, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!48 = !DISubroutineType(types: !49)
!49 = !{!35, !35}
!50 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !51, file: !36, line: 335)
!51 = !DISubprogram(name: "acosf", scope: !52, file: !52, line: 53, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!52 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/mathcalls.h", directory: "")
!53 = !DISubroutineType(types: !54)
!54 = !{!42, !42}
!55 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !56, file: !36, line: 337)
!56 = !DISubprogram(name: "asinf", scope: !52, file: !52, line: 55, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!57 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !58, file: !36, line: 339)
!58 = !DISubprogram(name: "atanf", scope: !52, file: !52, line: 57, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!59 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !60, file: !36, line: 341)
!60 = !DISubprogram(name: "atan2f", scope: !52, file: !52, line: 59, type: !61, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!61 = !DISubroutineType(types: !62)
!62 = !{!42, !42, !42}
!63 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !64, file: !36, line: 343)
!64 = !DISubprogram(name: "ceilf", scope: !52, file: !52, line: 159, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!65 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !66, file: !36, line: 345)
!66 = !DISubprogram(name: "cosf", scope: !52, file: !52, line: 62, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!67 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !68, file: !36, line: 347)
!68 = !DISubprogram(name: "coshf", scope: !52, file: !52, line: 71, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!69 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !70, file: !36, line: 350)
!70 = !DISubprogram(name: "expf", scope: !52, file: !52, line: 95, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!71 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !72, file: !36, line: 353)
!72 = !DISubprogram(name: "fabsf", scope: !52, file: !52, line: 162, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!73 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !74, file: !36, line: 355)
!74 = !DISubprogram(name: "floorf", scope: !52, file: !52, line: 165, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!75 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !76, file: !36, line: 358)
!76 = !DISubprogram(name: "fmodf", scope: !52, file: !52, line: 168, type: !61, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!77 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !78, file: !36, line: 361)
!78 = !DISubprogram(name: "frexpf", scope: !52, file: !52, line: 98, type: !79, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!79 = !DISubroutineType(types: !80)
!80 = !{!42, !42, !81}
!81 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !4, size: 64)
!82 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !83, file: !36, line: 363)
!83 = !DISubprogram(name: "ldexpf", scope: !52, file: !52, line: 101, type: !84, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!84 = !DISubroutineType(types: !85)
!85 = !{!42, !42, !4}
!86 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !87, file: !36, line: 366)
!87 = !DISubprogram(name: "logf", scope: !52, file: !52, line: 104, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!88 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !89, file: !36, line: 369)
!89 = !DISubprogram(name: "log10f", scope: !52, file: !52, line: 107, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!90 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !91, file: !36, line: 370)
!91 = !DISubprogram(name: "modf", linkageName: "_Z4modfePe", scope: !31, file: !31, line: 1021, type: !92, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!92 = !DISubroutineType(types: !93)
!93 = !{!35, !35, !94}
!94 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !35, size: 64)
!95 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !96, file: !36, line: 371)
!96 = !DISubprogram(name: "modff", scope: !52, file: !52, line: 110, type: !97, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!97 = !DISubroutineType(types: !98)
!98 = !{!42, !42, !99}
!99 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !42, size: 64)
!100 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !101, file: !36, line: 374)
!101 = !DISubprogram(name: "powf", scope: !52, file: !52, line: 140, type: !61, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!102 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !103, file: !36, line: 377)
!103 = !DISubprogram(name: "sinf", scope: !52, file: !52, line: 64, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!104 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !105, file: !36, line: 379)
!105 = !DISubprogram(name: "sinhf", scope: !52, file: !52, line: 73, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!106 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !107, file: !36, line: 382)
!107 = !DISubprogram(name: "sqrtf", scope: !52, file: !52, line: 143, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!108 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !109, file: !36, line: 384)
!109 = !DISubprogram(name: "tanf", scope: !52, file: !52, line: 66, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!110 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !111, file: !36, line: 387)
!111 = !DISubprogram(name: "tanhf", scope: !52, file: !52, line: 75, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!112 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !113, file: !36, line: 390)
!113 = !DISubprogram(name: "acoshf", scope: !52, file: !52, line: 85, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!114 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !115, file: !36, line: 392)
!115 = !DISubprogram(name: "asinhf", scope: !52, file: !52, line: 87, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!116 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !117, file: !36, line: 394)
!117 = !DISubprogram(name: "atanhf", scope: !52, file: !52, line: 89, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!118 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !119, file: !36, line: 396)
!119 = !DISubprogram(name: "cbrtf", scope: !52, file: !52, line: 152, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!120 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !121, file: !36, line: 399)
!121 = !DISubprogram(name: "copysignf", scope: !52, file: !52, line: 196, type: !61, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!122 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !123, file: !36, line: 402)
!123 = !DISubprogram(name: "erff", scope: !52, file: !52, line: 228, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!124 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !125, file: !36, line: 404)
!125 = !DISubprogram(name: "erfcf", scope: !52, file: !52, line: 229, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!126 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !127, file: !36, line: 406)
!127 = !DISubprogram(name: "exp2f", scope: !52, file: !52, line: 130, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!128 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !129, file: !36, line: 408)
!129 = !DISubprogram(name: "expm1f", scope: !52, file: !52, line: 119, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!130 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !131, file: !36, line: 410)
!131 = !DISubprogram(name: "fdimf", scope: !52, file: !52, line: 326, type: !61, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!132 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !133, file: !36, line: 411)
!133 = !DISubprogram(name: "fmaf", scope: !52, file: !52, line: 335, type: !134, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!134 = !DISubroutineType(types: !135)
!135 = !{!42, !42, !42, !42}
!136 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !137, file: !36, line: 414)
!137 = !DISubprogram(name: "fmaxf", scope: !52, file: !52, line: 329, type: !61, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!138 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !139, file: !36, line: 416)
!139 = !DISubprogram(name: "fminf", scope: !52, file: !52, line: 332, type: !61, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!140 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !141, file: !36, line: 418)
!141 = !DISubprogram(name: "hypotf", scope: !52, file: !52, line: 147, type: !61, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!142 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !143, file: !36, line: 420)
!143 = !DISubprogram(name: "ilogbf", scope: !52, file: !52, line: 280, type: !144, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!144 = !DISubroutineType(types: !145)
!145 = !{!4, !42}
!146 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !147, file: !36, line: 422)
!147 = !DISubprogram(name: "lgammaf", scope: !52, file: !52, line: 230, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!148 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !149, file: !36, line: 424)
!149 = !DISubprogram(name: "llrintf", scope: !52, file: !52, line: 316, type: !150, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!150 = !DISubroutineType(types: !151)
!151 = !{!152, !42}
!152 = !DIBasicType(name: "long long int", size: 64, encoding: DW_ATE_signed)
!153 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !154, file: !36, line: 426)
!154 = !DISubprogram(name: "llroundf", scope: !52, file: !52, line: 322, type: !150, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!155 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !156, file: !36, line: 428)
!156 = !DISubprogram(name: "log1pf", scope: !52, file: !52, line: 122, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!157 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !158, file: !36, line: 430)
!158 = !DISubprogram(name: "log2f", scope: !52, file: !52, line: 133, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!159 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !160, file: !36, line: 432)
!160 = !DISubprogram(name: "logbf", scope: !52, file: !52, line: 125, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!161 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !162, file: !36, line: 434)
!162 = !DISubprogram(name: "lrintf", scope: !52, file: !52, line: 314, type: !163, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!163 = !DISubroutineType(types: !164)
!164 = !{!20, !42}
!165 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !166, file: !36, line: 436)
!166 = !DISubprogram(name: "lroundf", scope: !52, file: !52, line: 320, type: !163, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!167 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !168, file: !36, line: 438)
!168 = !DISubprogram(name: "nan", scope: !52, file: !52, line: 201, type: !169, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!169 = !DISubroutineType(types: !170)
!170 = !{!45, !171}
!171 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !172, size: 64)
!172 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !7)
!173 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !174, file: !36, line: 439)
!174 = !DISubprogram(name: "nanf", scope: !52, file: !52, line: 201, type: !175, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!175 = !DISubroutineType(types: !176)
!176 = !{!42, !171}
!177 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !178, file: !36, line: 442)
!178 = !DISubprogram(name: "nearbyintf", scope: !52, file: !52, line: 294, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!179 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !180, file: !36, line: 444)
!180 = !DISubprogram(name: "nextafterf", scope: !52, file: !52, line: 259, type: !61, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!181 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !182, file: !36, line: 446)
!182 = !DISubprogram(name: "nexttowardf", scope: !52, file: !52, line: 261, type: !183, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!183 = !DISubroutineType(types: !184)
!184 = !{!42, !42, !35}
!185 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !186, file: !36, line: 448)
!186 = !DISubprogram(name: "remainderf", scope: !52, file: !52, line: 272, type: !61, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!187 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !188, file: !36, line: 450)
!188 = !DISubprogram(name: "remquof", scope: !52, file: !52, line: 307, type: !189, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!189 = !DISubroutineType(types: !190)
!190 = !{!42, !42, !42, !81}
!191 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !192, file: !36, line: 452)
!192 = !DISubprogram(name: "rintf", scope: !52, file: !52, line: 256, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!193 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !194, file: !36, line: 454)
!194 = !DISubprogram(name: "roundf", scope: !52, file: !52, line: 298, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!195 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !196, file: !36, line: 456)
!196 = !DISubprogram(name: "scalblnf", scope: !52, file: !52, line: 290, type: !197, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!197 = !DISubroutineType(types: !198)
!198 = !{!42, !42, !20}
!199 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !200, file: !36, line: 458)
!200 = !DISubprogram(name: "scalbnf", scope: !52, file: !52, line: 276, type: !84, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!201 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !202, file: !36, line: 460)
!202 = !DISubprogram(name: "tgammaf", scope: !52, file: !52, line: 235, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!203 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !204, file: !36, line: 462)
!204 = !DISubprogram(name: "truncf", scope: !52, file: !52, line: 302, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!205 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !206, file: !36, line: 464)
!206 = !DISubprogram(name: "acosl", scope: !52, file: !52, line: 53, type: !48, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!207 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !208, file: !36, line: 465)
!208 = !DISubprogram(name: "asinl", scope: !52, file: !52, line: 55, type: !48, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!209 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !210, file: !36, line: 466)
!210 = !DISubprogram(name: "atanl", scope: !52, file: !52, line: 57, type: !48, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!211 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !212, file: !36, line: 467)
!212 = !DISubprogram(name: "atan2l", scope: !52, file: !52, line: 59, type: !213, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!213 = !DISubroutineType(types: !214)
!214 = !{!35, !35, !35}
!215 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !216, file: !36, line: 468)
!216 = !DISubprogram(name: "ceill", scope: !52, file: !52, line: 159, type: !48, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!217 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !218, file: !36, line: 469)
!218 = !DISubprogram(name: "cosl", scope: !52, file: !52, line: 62, type: !48, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!219 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !220, file: !36, line: 470)
!220 = !DISubprogram(name: "coshl", scope: !52, file: !52, line: 71, type: !48, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!221 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !222, file: !36, line: 471)
!222 = !DISubprogram(name: "expl", scope: !52, file: !52, line: 95, type: !48, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!223 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !224, file: !36, line: 472)
!224 = !DISubprogram(name: "fabsl", scope: !52, file: !52, line: 162, type: !48, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!225 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !226, file: !36, line: 473)
!226 = !DISubprogram(name: "floorl", scope: !52, file: !52, line: 165, type: !48, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!227 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !228, file: !36, line: 474)
!228 = !DISubprogram(name: "fmodl", scope: !52, file: !52, line: 168, type: !213, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!229 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !230, file: !36, line: 475)
!230 = !DISubprogram(name: "frexpl", scope: !52, file: !52, line: 98, type: !231, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!231 = !DISubroutineType(types: !232)
!232 = !{!35, !35, !81}
!233 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !234, file: !36, line: 476)
!234 = !DISubprogram(name: "ldexpl", scope: !52, file: !52, line: 101, type: !235, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!235 = !DISubroutineType(types: !236)
!236 = !{!35, !35, !4}
!237 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !238, file: !36, line: 477)
!238 = !DISubprogram(name: "logl", scope: !52, file: !52, line: 104, type: !48, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!239 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !240, file: !36, line: 478)
!240 = !DISubprogram(name: "log10l", scope: !52, file: !52, line: 107, type: !48, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!241 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !242, file: !36, line: 479)
!242 = !DISubprogram(name: "modfl", scope: !52, file: !52, line: 110, type: !92, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!243 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !244, file: !36, line: 480)
!244 = !DISubprogram(name: "powl", scope: !52, file: !52, line: 140, type: !213, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!245 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !246, file: !36, line: 481)
!246 = !DISubprogram(name: "sinl", scope: !52, file: !52, line: 64, type: !48, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!247 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !248, file: !36, line: 482)
!248 = !DISubprogram(name: "sinhl", scope: !52, file: !52, line: 73, type: !48, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!249 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !250, file: !36, line: 483)
!250 = !DISubprogram(name: "sqrtl", scope: !52, file: !52, line: 143, type: !48, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!251 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !252, file: !36, line: 484)
!252 = !DISubprogram(name: "tanl", scope: !52, file: !52, line: 66, type: !48, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!253 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !254, file: !36, line: 486)
!254 = !DISubprogram(name: "tanhl", scope: !52, file: !52, line: 75, type: !48, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!255 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !256, file: !36, line: 487)
!256 = !DISubprogram(name: "acoshl", scope: !52, file: !52, line: 85, type: !48, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!257 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !258, file: !36, line: 488)
!258 = !DISubprogram(name: "asinhl", scope: !52, file: !52, line: 87, type: !48, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!259 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !260, file: !36, line: 489)
!260 = !DISubprogram(name: "atanhl", scope: !52, file: !52, line: 89, type: !48, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!261 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !262, file: !36, line: 490)
!262 = !DISubprogram(name: "cbrtl", scope: !52, file: !52, line: 152, type: !48, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!263 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !264, file: !36, line: 492)
!264 = !DISubprogram(name: "copysignl", scope: !52, file: !52, line: 196, type: !213, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!265 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !266, file: !36, line: 494)
!266 = !DISubprogram(name: "erfl", scope: !52, file: !52, line: 228, type: !48, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!267 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !268, file: !36, line: 495)
!268 = !DISubprogram(name: "erfcl", scope: !52, file: !52, line: 229, type: !48, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!269 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !270, file: !36, line: 496)
!270 = !DISubprogram(name: "exp2l", scope: !52, file: !52, line: 130, type: !48, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!271 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !272, file: !36, line: 497)
!272 = !DISubprogram(name: "expm1l", scope: !52, file: !52, line: 119, type: !48, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!273 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !274, file: !36, line: 498)
!274 = !DISubprogram(name: "fdiml", scope: !52, file: !52, line: 326, type: !213, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!275 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !276, file: !36, line: 499)
!276 = !DISubprogram(name: "fmal", scope: !52, file: !52, line: 335, type: !277, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!277 = !DISubroutineType(types: !278)
!278 = !{!35, !35, !35, !35}
!279 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !280, file: !36, line: 500)
!280 = !DISubprogram(name: "fmaxl", scope: !52, file: !52, line: 329, type: !213, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!281 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !282, file: !36, line: 501)
!282 = !DISubprogram(name: "fminl", scope: !52, file: !52, line: 332, type: !213, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!283 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !284, file: !36, line: 502)
!284 = !DISubprogram(name: "hypotl", scope: !52, file: !52, line: 147, type: !213, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!285 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !286, file: !36, line: 503)
!286 = !DISubprogram(name: "ilogbl", scope: !52, file: !52, line: 280, type: !287, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!287 = !DISubroutineType(types: !288)
!288 = !{!4, !35}
!289 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !290, file: !36, line: 504)
!290 = !DISubprogram(name: "lgammal", scope: !52, file: !52, line: 230, type: !48, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!291 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !292, file: !36, line: 505)
!292 = !DISubprogram(name: "llrintl", scope: !52, file: !52, line: 316, type: !293, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!293 = !DISubroutineType(types: !294)
!294 = !{!152, !35}
!295 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !296, file: !36, line: 506)
!296 = !DISubprogram(name: "llroundl", scope: !52, file: !52, line: 322, type: !293, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!297 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !298, file: !36, line: 507)
!298 = !DISubprogram(name: "log1pl", scope: !52, file: !52, line: 122, type: !48, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!299 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !300, file: !36, line: 508)
!300 = !DISubprogram(name: "log2l", scope: !52, file: !52, line: 133, type: !48, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!301 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !302, file: !36, line: 509)
!302 = !DISubprogram(name: "logbl", scope: !52, file: !52, line: 125, type: !48, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!303 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !304, file: !36, line: 510)
!304 = !DISubprogram(name: "lrintl", scope: !52, file: !52, line: 314, type: !305, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!305 = !DISubroutineType(types: !306)
!306 = !{!20, !35}
!307 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !308, file: !36, line: 511)
!308 = !DISubprogram(name: "lroundl", scope: !52, file: !52, line: 320, type: !305, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!309 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !310, file: !36, line: 512)
!310 = !DISubprogram(name: "nanl", scope: !52, file: !52, line: 201, type: !311, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!311 = !DISubroutineType(types: !312)
!312 = !{!35, !171}
!313 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !314, file: !36, line: 513)
!314 = !DISubprogram(name: "nearbyintl", scope: !52, file: !52, line: 294, type: !48, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!315 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !316, file: !36, line: 514)
!316 = !DISubprogram(name: "nextafterl", scope: !52, file: !52, line: 259, type: !213, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!317 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !318, file: !36, line: 515)
!318 = !DISubprogram(name: "nexttowardl", scope: !52, file: !52, line: 261, type: !213, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!319 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !320, file: !36, line: 516)
!320 = !DISubprogram(name: "remainderl", scope: !52, file: !52, line: 272, type: !213, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!321 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !322, file: !36, line: 517)
!322 = !DISubprogram(name: "remquol", scope: !52, file: !52, line: 307, type: !323, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!323 = !DISubroutineType(types: !324)
!324 = !{!35, !35, !35, !81}
!325 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !326, file: !36, line: 518)
!326 = !DISubprogram(name: "rintl", scope: !52, file: !52, line: 256, type: !48, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!327 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !328, file: !36, line: 519)
!328 = !DISubprogram(name: "roundl", scope: !52, file: !52, line: 298, type: !48, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!329 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !330, file: !36, line: 520)
!330 = !DISubprogram(name: "scalblnl", scope: !52, file: !52, line: 290, type: !331, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!331 = !DISubroutineType(types: !332)
!332 = !{!35, !35, !20}
!333 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !334, file: !36, line: 521)
!334 = !DISubprogram(name: "scalbnl", scope: !52, file: !52, line: 276, type: !235, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!335 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !336, file: !36, line: 522)
!336 = !DISubprogram(name: "tgammal", scope: !52, file: !52, line: 235, type: !48, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!337 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !338, file: !36, line: 523)
!338 = !DISubprogram(name: "truncl", scope: !52, file: !52, line: 302, type: !48, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!339 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !23, file: !340, line: 99)
!340 = !DIFile(filename: "build_tool/../usr/include/c++/v1/cstdlib", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!341 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !342, file: !340, line: 100)
!342 = !DIDerivedType(tag: DW_TAG_typedef, name: "div_t", file: !343, line: 62, baseType: !344)
!343 = !DIFile(filename: "/usr/include/stdlib.h", directory: "")
!344 = !DICompositeType(tag: DW_TAG_structure_type, file: !343, line: 58, flags: DIFlagFwdDecl, identifier: "_ZTS5div_t")
!345 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !346, file: !340, line: 101)
!346 = !DIDerivedType(tag: DW_TAG_typedef, name: "ldiv_t", file: !343, line: 70, baseType: !347)
!347 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !343, line: 66, size: 128, flags: DIFlagTypePassByValue, elements: !348, identifier: "_ZTS6ldiv_t")
!348 = !{!349, !350}
!349 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !347, file: !343, line: 68, baseType: !20, size: 64)
!350 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !347, file: !343, line: 69, baseType: !20, size: 64, offset: 64)
!351 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !352, file: !340, line: 103)
!352 = !DIDerivedType(tag: DW_TAG_typedef, name: "lldiv_t", file: !343, line: 80, baseType: !353)
!353 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !343, line: 76, size: 128, flags: DIFlagTypePassByValue, elements: !354, identifier: "_ZTS7lldiv_t")
!354 = !{!355, !356}
!355 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !353, file: !343, line: 78, baseType: !152, size: 64)
!356 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !353, file: !343, line: 79, baseType: !152, size: 64, offset: 64)
!357 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !358, file: !340, line: 105)
!358 = !DISubprogram(name: "atof", scope: !359, file: !359, line: 25, type: !169, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!359 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdlib-float.h", directory: "")
!360 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !361, file: !340, line: 106)
!361 = distinct !DISubprogram(name: "atoi", scope: !343, file: !343, line: 361, type: !362, scopeLine: 362, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !364)
!362 = !DISubroutineType(types: !363)
!363 = !{!4, !171}
!364 = !{!365}
!365 = !DILocalVariable(name: "__nptr", arg: 1, scope: !361, file: !343, line: 361, type: !171)
!366 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !367, file: !340, line: 107)
!367 = !DISubprogram(name: "atol", scope: !343, file: !343, line: 366, type: !368, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!368 = !DISubroutineType(types: !369)
!369 = !{!20, !171}
!370 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !371, file: !340, line: 109)
!371 = !DISubprogram(name: "atoll", scope: !343, file: !343, line: 373, type: !372, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!372 = !DISubroutineType(types: !373)
!373 = !{!152, !171}
!374 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !375, file: !340, line: 111)
!375 = !DISubprogram(name: "strtod", scope: !343, file: !343, line: 117, type: !376, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!376 = !DISubroutineType(types: !377)
!377 = !{!45, !378, !379}
!378 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !171)
!379 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !5)
!380 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !381, file: !340, line: 112)
!381 = !DISubprogram(name: "strtof", scope: !343, file: !343, line: 123, type: !382, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!382 = !DISubroutineType(types: !383)
!383 = !{!42, !378, !379}
!384 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !385, file: !340, line: 113)
!385 = !DISubprogram(name: "strtold", scope: !343, file: !343, line: 126, type: !386, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!386 = !DISubroutineType(types: !387)
!387 = !{!35, !378, !379}
!388 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !389, file: !340, line: 114)
!389 = !DISubprogram(name: "strtol", scope: !343, file: !343, line: 176, type: !390, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!390 = !DISubroutineType(types: !391)
!391 = !{!20, !378, !379, !4}
!392 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !393, file: !340, line: 116)
!393 = !DISubprogram(name: "strtoll", scope: !343, file: !343, line: 200, type: !394, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!394 = !DISubroutineType(types: !395)
!395 = !{!152, !378, !379, !4}
!396 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !397, file: !340, line: 118)
!397 = !DISubprogram(name: "strtoul", scope: !343, file: !343, line: 180, type: !398, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!398 = !DISubroutineType(types: !399)
!399 = !{!24, !378, !379, !4}
!400 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !401, file: !340, line: 120)
!401 = !DISubprogram(name: "strtoull", scope: !343, file: !343, line: 205, type: !402, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!402 = !DISubroutineType(types: !403)
!403 = !{!404, !378, !379, !4}
!404 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!405 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !406, file: !340, line: 122)
!406 = !DISubprogram(name: "rand", scope: !343, file: !343, line: 453, type: !407, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!407 = !DISubroutineType(types: !408)
!408 = !{!4}
!409 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !410, file: !340, line: 123)
!410 = !DISubprogram(name: "srand", scope: !343, file: !343, line: 455, type: !411, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!411 = !DISubroutineType(types: !412)
!412 = !{null, !413}
!413 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!414 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !415, file: !340, line: 124)
!415 = !DISubprogram(name: "calloc", scope: !343, file: !343, line: 541, type: !416, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!416 = !DISubroutineType(types: !417)
!417 = !{!418, !23, !23}
!418 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!419 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !420, file: !340, line: 125)
!420 = !DISubprogram(name: "free", scope: !343, file: !343, line: 563, type: !421, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!421 = !DISubroutineType(types: !422)
!422 = !{null, !418}
!423 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !424, file: !340, line: 126)
!424 = !DISubprogram(name: "malloc", scope: !343, file: !343, line: 539, type: !425, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!425 = !DISubroutineType(types: !426)
!426 = !{!418, !23}
!427 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !428, file: !340, line: 127)
!428 = !DISubprogram(name: "realloc", scope: !343, file: !343, line: 549, type: !429, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!429 = !DISubroutineType(types: !430)
!430 = !{!418, !418, !23}
!431 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !432, file: !340, line: 128)
!432 = !DISubprogram(name: "abort", scope: !343, file: !343, line: 588, type: !433, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!433 = !DISubroutineType(types: !434)
!434 = !{null}
!435 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !436, file: !340, line: 129)
!436 = !DISubprogram(name: "atexit", scope: !343, file: !343, line: 592, type: !437, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!437 = !DISubroutineType(types: !438)
!438 = !{!4, !439}
!439 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !433, size: 64)
!440 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !441, file: !340, line: 130)
!441 = !DISubprogram(name: "exit", scope: !343, file: !343, line: 614, type: !442, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!442 = !DISubroutineType(types: !443)
!443 = !{null, !4}
!444 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !445, file: !340, line: 131)
!445 = !DISubprogram(name: "_Exit", scope: !343, file: !343, line: 626, type: !442, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!446 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !447, file: !340, line: 133)
!447 = !DISubprogram(name: "getenv", scope: !343, file: !343, line: 631, type: !448, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!448 = !DISubroutineType(types: !449)
!449 = !{!6, !171}
!450 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !451, file: !340, line: 134)
!451 = !DISubprogram(name: "system", scope: !343, file: !343, line: 781, type: !362, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!452 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !453, file: !340, line: 136)
!453 = !DISubprogram(name: "bsearch", scope: !454, file: !454, line: 20, type: !455, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!454 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdlib-bsearch.h", directory: "")
!455 = !DISubroutineType(types: !456)
!456 = !{!418, !457, !457, !23, !23, !459}
!457 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !458, size: 64)
!458 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!459 = !DIDerivedType(tag: DW_TAG_typedef, name: "__compar_fn_t", file: !343, line: 805, baseType: !460)
!460 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !461, size: 64)
!461 = !DISubroutineType(types: !462)
!462 = !{!4, !457, !457}
!463 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !464, file: !340, line: 137)
!464 = !DISubprogram(name: "qsort", scope: !343, file: !343, line: 827, type: !465, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!465 = !DISubroutineType(types: !466)
!466 = !{null, !418, !23, !23, !459}
!467 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !47, file: !340, line: 138)
!468 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !469, file: !340, line: 139)
!469 = !DISubprogram(name: "labs", scope: !343, file: !343, line: 838, type: !470, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!470 = !DISubroutineType(types: !471)
!471 = !{!20, !20}
!472 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !473, file: !340, line: 141)
!473 = !DISubprogram(name: "llabs", scope: !343, file: !343, line: 841, type: !474, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!474 = !DISubroutineType(types: !475)
!475 = !{!152, !152}
!476 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !477, file: !340, line: 143)
!477 = !DISubprogram(name: "div", linkageName: "_Z3divxx", scope: !31, file: !31, line: 808, type: !478, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!478 = !DISubroutineType(types: !479)
!479 = !{!352, !152, !152}
!480 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !481, file: !340, line: 144)
!481 = !DISubprogram(name: "ldiv", scope: !343, file: !343, line: 851, type: !482, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!482 = !DISubroutineType(types: !483)
!483 = !{!346, !20, !20}
!484 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !485, file: !340, line: 146)
!485 = !DISubprogram(name: "lldiv", scope: !343, file: !343, line: 855, type: !478, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!486 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !487, file: !340, line: 148)
!487 = !DISubprogram(name: "mblen", scope: !343, file: !343, line: 919, type: !488, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!488 = !DISubroutineType(types: !489)
!489 = !{!4, !171, !23}
!490 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !491, file: !340, line: 149)
!491 = !DISubprogram(name: "mbtowc", scope: !343, file: !343, line: 922, type: !492, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!492 = !DISubroutineType(types: !493)
!493 = !{!4, !494, !378, !23}
!494 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !495)
!495 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !496, size: 64)
!496 = !DIBasicType(name: "wchar_t", size: 32, encoding: DW_ATE_signed)
!497 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !498, file: !340, line: 150)
!498 = !DISubprogram(name: "wctomb", scope: !343, file: !343, line: 926, type: !499, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!499 = !DISubroutineType(types: !500)
!500 = !{!4, !6, !496}
!501 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !502, file: !340, line: 151)
!502 = !DISubprogram(name: "mbstowcs", scope: !343, file: !343, line: 930, type: !503, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!503 = !DISubroutineType(types: !504)
!504 = !{!23, !494, !378, !23}
!505 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !506, file: !340, line: 152)
!506 = !DISubprogram(name: "wcstombs", scope: !343, file: !343, line: 933, type: !507, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!507 = !DISubroutineType(types: !508)
!508 = !{!23, !509, !510, !23}
!509 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !6)
!510 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !511)
!511 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !512, size: 64)
!512 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !496)
!513 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !514, file: !340, line: 154)
!514 = !DISubprogram(name: "at_quick_exit", scope: !343, file: !343, line: 597, type: !437, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!515 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !516, file: !340, line: 155)
!516 = !DISubprogram(name: "quick_exit", scope: !343, file: !343, line: 620, type: !442, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!517 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !9, file: !518, line: 152)
!518 = !DIFile(filename: "build_tool/../usr/include/c++/v1/cstdint", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!519 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !520, file: !518, line: 153)
!520 = !DIDerivedType(tag: DW_TAG_typedef, name: "int16_t", file: !10, line: 25, baseType: !521)
!521 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int16_t", file: !12, line: 38, baseType: !522)
!522 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!523 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !524, file: !518, line: 154)
!524 = !DIDerivedType(tag: DW_TAG_typedef, name: "int32_t", file: !10, line: 26, baseType: !525)
!525 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int32_t", file: !12, line: 40, baseType: !4)
!526 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !527, file: !518, line: 155)
!527 = !DIDerivedType(tag: DW_TAG_typedef, name: "int64_t", file: !10, line: 27, baseType: !528)
!528 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int64_t", file: !12, line: 43, baseType: !20)
!529 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !530, file: !518, line: 157)
!530 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint8_t", file: !531, line: 24, baseType: !532)
!531 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "")
!532 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint8_t", file: !12, line: 37, baseType: !533)
!533 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!534 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !535, file: !518, line: 158)
!535 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint16_t", file: !531, line: 25, baseType: !536)
!536 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint16_t", file: !12, line: 39, baseType: !537)
!537 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!538 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !539, file: !518, line: 159)
!539 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !531, line: 26, baseType: !540)
!540 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !12, line: 41, baseType: !413)
!541 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !542, file: !518, line: 160)
!542 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", file: !531, line: 27, baseType: !543)
!543 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint64_t", file: !12, line: 44, baseType: !24)
!544 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !545, file: !518, line: 162)
!545 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least8_t", file: !546, line: 43, baseType: !13)
!546 = !DIFile(filename: "/usr/include/stdint.h", directory: "")
!547 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !548, file: !518, line: 163)
!548 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least16_t", file: !546, line: 44, baseType: !522)
!549 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !550, file: !518, line: 164)
!550 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least32_t", file: !546, line: 45, baseType: !4)
!551 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !552, file: !518, line: 165)
!552 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least64_t", file: !546, line: 47, baseType: !20)
!553 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !554, file: !518, line: 167)
!554 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least8_t", file: !546, line: 54, baseType: !533)
!555 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !556, file: !518, line: 168)
!556 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least16_t", file: !546, line: 55, baseType: !537)
!557 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !558, file: !518, line: 169)
!558 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least32_t", file: !546, line: 56, baseType: !413)
!559 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !560, file: !518, line: 170)
!560 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least64_t", file: !546, line: 58, baseType: !24)
!561 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !562, file: !518, line: 172)
!562 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast8_t", file: !546, line: 68, baseType: !13)
!563 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !564, file: !518, line: 173)
!564 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast16_t", file: !546, line: 70, baseType: !20)
!565 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !566, file: !518, line: 174)
!566 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast32_t", file: !546, line: 71, baseType: !20)
!567 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !568, file: !518, line: 175)
!568 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast64_t", file: !546, line: 72, baseType: !20)
!569 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !570, file: !518, line: 177)
!570 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast8_t", file: !546, line: 81, baseType: !533)
!571 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !572, file: !518, line: 178)
!572 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast16_t", file: !546, line: 83, baseType: !24)
!573 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !574, file: !518, line: 179)
!574 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast32_t", file: !546, line: 84, baseType: !24)
!575 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !576, file: !518, line: 180)
!576 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast64_t", file: !546, line: 85, baseType: !24)
!577 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !578, file: !518, line: 182)
!578 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !546, line: 97, baseType: !20)
!579 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !580, file: !518, line: 183)
!580 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !546, line: 100, baseType: !24)
!581 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !582, file: !518, line: 185)
!582 = !DIDerivedType(tag: DW_TAG_typedef, name: "intmax_t", file: !546, line: 111, baseType: !583)
!583 = !DIDerivedType(tag: DW_TAG_typedef, name: "__intmax_t", file: !12, line: 61, baseType: !20)
!584 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !585, file: !518, line: 186)
!585 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintmax_t", file: !546, line: 112, baseType: !586)
!586 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uintmax_t", file: !12, line: 62, baseType: !24)
!587 = !{i32 2, !"Dwarf Version", i32 4}
!588 = !{i32 2, !"Debug Info Version", i32 3}
!589 = !{i32 1, !"wchar_size", i32 4}
!590 = !{!"clang version 9.0.0 (tags/RELEASE_900/final)"}
!591 = distinct !DISubprogram(name: "f1", linkageName: "_Z2f1ii", scope: !1, file: !1, line: 13, type: !592, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !594)
!592 = !DISubroutineType(types: !593)
!593 = !{null, !4, !4}
!594 = !{!595, !596, !597, !598}
!595 = !DILocalVariable(name: "x1", arg: 1, scope: !591, file: !1, line: 13, type: !4)
!596 = !DILocalVariable(name: "x2", arg: 2, scope: !591, file: !1, line: 13, type: !4)
!597 = !DILocalVariable(name: "tmp", scope: !591, file: !1, line: 15, type: !4)
!598 = !DILocalVariable(name: "i", scope: !599, file: !1, line: 16, type: !4)
!599 = distinct !DILexicalBlock(scope: !591, file: !1, line: 16, column: 3)
!600 = !{!601, !601, i64 0}
!601 = !{!"int", !602, i64 0}
!602 = !{!"omnipotent char", !603, i64 0}
!603 = !{!"Simple C++ TBAA"}
!604 = !DILocation(line: 13, column: 13, scope: !591)
!605 = !DILocation(line: 13, column: 21, scope: !591)
!606 = !DILocation(line: 15, column: 3, scope: !591)
!607 = !DILocation(line: 15, column: 7, scope: !591)
!608 = !DILocation(line: 16, column: 7, scope: !599)
!609 = !DILocation(line: 16, column: 11, scope: !599)
!610 = !DILocation(line: 16, column: 18, scope: !611)
!611 = distinct !DILexicalBlock(scope: !599, file: !1, line: 16, column: 3)
!612 = !DILocation(line: 16, column: 20, scope: !611)
!613 = !DILocation(line: 16, column: 3, scope: !599)
!614 = !DILocation(line: 16, column: 3, scope: !611)
!615 = !DILocation(line: 17, column: 12, scope: !616)
!616 = distinct !DILexicalBlock(scope: !611, file: !1, line: 16, column: 35)
!617 = !DILocation(line: 17, column: 13, scope: !616)
!618 = !DILocation(line: 17, column: 9, scope: !616)
!619 = !DILocation(line: 18, column: 3, scope: !616)
!620 = !DILocation(line: 16, column: 29, scope: !611)
!621 = distinct !{!621, !613, !622}
!622 = !DILocation(line: 18, column: 3, scope: !599)
!623 = !DILocation(line: 19, column: 1, scope: !591)
!624 = distinct !DISubprogram(name: "f2", linkageName: "_Z2f2ii", scope: !1, file: !1, line: 20, type: !592, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !625)
!625 = !{!626, !627, !628, !629}
!626 = !DILocalVariable(name: "x1", arg: 1, scope: !624, file: !1, line: 20, type: !4)
!627 = !DILocalVariable(name: "x2", arg: 2, scope: !624, file: !1, line: 20, type: !4)
!628 = !DILocalVariable(name: "tmp", scope: !624, file: !1, line: 22, type: !4)
!629 = !DILocalVariable(name: "i", scope: !630, file: !1, line: 23, type: !4)
!630 = distinct !DILexicalBlock(scope: !624, file: !1, line: 23, column: 3)
!631 = !DILocation(line: 20, column: 13, scope: !624)
!632 = !DILocation(line: 20, column: 21, scope: !624)
!633 = !DILocation(line: 22, column: 3, scope: !624)
!634 = !DILocation(line: 22, column: 7, scope: !624)
!635 = !DILocation(line: 23, column: 7, scope: !630)
!636 = !DILocation(line: 23, column: 11, scope: !630)
!637 = !DILocation(line: 23, column: 15, scope: !630)
!638 = !DILocation(line: 23, column: 19, scope: !639)
!639 = distinct !DILexicalBlock(scope: !630, file: !1, line: 23, column: 3)
!640 = !DILocation(line: 23, column: 23, scope: !639)
!641 = !DILocation(line: 23, column: 21, scope: !639)
!642 = !DILocation(line: 23, column: 3, scope: !630)
!643 = !DILocation(line: 23, column: 3, scope: !639)
!644 = !DILocation(line: 24, column: 12, scope: !639)
!645 = !DILocation(line: 24, column: 13, scope: !639)
!646 = !DILocation(line: 24, column: 9, scope: !639)
!647 = !DILocation(line: 24, column: 5, scope: !639)
!648 = !DILocation(line: 23, column: 29, scope: !639)
!649 = distinct !{!649, !642, !650}
!650 = !DILocation(line: 24, column: 14, scope: !630)
!651 = !DILocation(line: 26, column: 1, scope: !624)
!652 = distinct !DISubprogram(name: "f3", linkageName: "_Z2f3ii", scope: !1, file: !1, line: 27, type: !592, scopeLine: 28, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !653)
!653 = !{!654, !655, !656, !657}
!654 = !DILocalVariable(name: "x1", arg: 1, scope: !652, file: !1, line: 27, type: !4)
!655 = !DILocalVariable(name: "x2", arg: 2, scope: !652, file: !1, line: 27, type: !4)
!656 = !DILocalVariable(name: "tmp", scope: !652, file: !1, line: 29, type: !4)
!657 = !DILocalVariable(name: "i", scope: !658, file: !1, line: 30, type: !4)
!658 = distinct !DILexicalBlock(scope: !652, file: !1, line: 30, column: 3)
!659 = !DILocation(line: 27, column: 13, scope: !652)
!660 = !DILocation(line: 27, column: 21, scope: !652)
!661 = !DILocation(line: 29, column: 3, scope: !652)
!662 = !DILocation(line: 29, column: 7, scope: !652)
!663 = !DILocation(line: 30, column: 7, scope: !658)
!664 = !DILocation(line: 30, column: 11, scope: !658)
!665 = !DILocation(line: 30, column: 15, scope: !658)
!666 = !DILocation(line: 30, column: 19, scope: !667)
!667 = distinct !DILexicalBlock(scope: !658, file: !1, line: 30, column: 3)
!668 = !DILocation(line: 30, column: 21, scope: !667)
!669 = !DILocation(line: 30, column: 3, scope: !658)
!670 = !DILocation(line: 30, column: 3, scope: !667)
!671 = !DILocation(line: 31, column: 12, scope: !667)
!672 = !DILocation(line: 31, column: 13, scope: !667)
!673 = !DILocation(line: 31, column: 9, scope: !667)
!674 = !DILocation(line: 31, column: 5, scope: !667)
!675 = !DILocation(line: 30, column: 29, scope: !667)
!676 = distinct !{!676, !669, !677}
!677 = !DILocation(line: 31, column: 14, scope: !658)
!678 = !DILocation(line: 32, column: 1, scope: !652)
!679 = distinct !DISubprogram(name: "g", linkageName: "_Z1gii", scope: !1, file: !1, line: 34, type: !592, scopeLine: 35, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !680)
!680 = !{!681, !682}
!681 = !DILocalVariable(name: "x1", arg: 1, scope: !679, file: !1, line: 34, type: !4)
!682 = !DILocalVariable(name: "x2", arg: 2, scope: !679, file: !1, line: 34, type: !4)
!683 = !DILocation(line: 34, column: 12, scope: !679)
!684 = !DILocation(line: 34, column: 20, scope: !679)
!685 = !DILocation(line: 36, column: 6, scope: !679)
!686 = !DILocation(line: 36, column: 10, scope: !679)
!687 = !DILocation(line: 36, column: 3, scope: !679)
!688 = !DILocation(line: 37, column: 6, scope: !679)
!689 = !DILocation(line: 37, column: 10, scope: !679)
!690 = !DILocation(line: 37, column: 3, scope: !679)
!691 = !DILocation(line: 38, column: 6, scope: !679)
!692 = !DILocation(line: 38, column: 10, scope: !679)
!693 = !DILocation(line: 38, column: 3, scope: !679)
!694 = !DILocation(line: 39, column: 1, scope: !679)
!695 = distinct !DISubprogram(name: "g2", linkageName: "_Z2g2ii", scope: !1, file: !1, line: 40, type: !592, scopeLine: 41, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !696)
!696 = !{!697, !698}
!697 = !DILocalVariable(name: "x1", arg: 1, scope: !695, file: !1, line: 40, type: !4)
!698 = !DILocalVariable(name: "x2", arg: 2, scope: !695, file: !1, line: 40, type: !4)
!699 = !DILocation(line: 40, column: 13, scope: !695)
!700 = !DILocation(line: 40, column: 21, scope: !695)
!701 = !DILocation(line: 42, column: 6, scope: !695)
!702 = !DILocation(line: 42, column: 10, scope: !695)
!703 = !DILocation(line: 42, column: 3, scope: !695)
!704 = !DILocation(line: 43, column: 6, scope: !695)
!705 = !DILocation(line: 43, column: 10, scope: !695)
!706 = !DILocation(line: 43, column: 3, scope: !695)
!707 = !DILocation(line: 44, column: 6, scope: !695)
!708 = !DILocation(line: 44, column: 10, scope: !695)
!709 = !DILocation(line: 44, column: 3, scope: !695)
!710 = !DILocation(line: 45, column: 1, scope: !695)
!711 = distinct !DISubprogram(name: "g3", linkageName: "_Z2g3ii", scope: !1, file: !1, line: 46, type: !592, scopeLine: 47, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !712)
!712 = !{!713, !714}
!713 = !DILocalVariable(name: "x1", arg: 1, scope: !711, file: !1, line: 46, type: !4)
!714 = !DILocalVariable(name: "x2", arg: 2, scope: !711, file: !1, line: 46, type: !4)
!715 = !DILocation(line: 46, column: 13, scope: !711)
!716 = !DILocation(line: 46, column: 21, scope: !711)
!717 = !DILocation(line: 48, column: 6, scope: !711)
!718 = !DILocation(line: 48, column: 10, scope: !711)
!719 = !DILocation(line: 48, column: 3, scope: !711)
!720 = !DILocation(line: 49, column: 6, scope: !711)
!721 = !DILocation(line: 49, column: 10, scope: !711)
!722 = !DILocation(line: 49, column: 3, scope: !711)
!723 = !DILocation(line: 50, column: 6, scope: !711)
!724 = !DILocation(line: 50, column: 10, scope: !711)
!725 = !DILocation(line: 50, column: 3, scope: !711)
!726 = !DILocation(line: 51, column: 1, scope: !711)
!727 = distinct !DISubprogram(name: "f", linkageName: "_Z1fii", scope: !1, file: !1, line: 53, type: !728, scopeLine: 54, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !730)
!728 = !DISubroutineType(types: !729)
!729 = !{!4, !4, !4}
!730 = !{!731, !732, !733, !734, !736}
!731 = !DILocalVariable(name: "x1", arg: 1, scope: !727, file: !1, line: 53, type: !4)
!732 = !DILocalVariable(name: "x2", arg: 2, scope: !727, file: !1, line: 53, type: !4)
!733 = !DILocalVariable(name: "tmp", scope: !727, file: !1, line: 55, type: !4)
!734 = !DILocalVariable(name: "i", scope: !735, file: !1, line: 56, type: !4)
!735 = distinct !DILexicalBlock(scope: !727, file: !1, line: 56, column: 3)
!736 = !DILocalVariable(name: "j", scope: !737, file: !1, line: 58, type: !4)
!737 = distinct !DILexicalBlock(scope: !738, file: !1, line: 58, column: 5)
!738 = distinct !DILexicalBlock(scope: !739, file: !1, line: 56, column: 34)
!739 = distinct !DILexicalBlock(scope: !735, file: !1, line: 56, column: 3)
!740 = !DILocation(line: 53, column: 11, scope: !727)
!741 = !DILocation(line: 53, column: 19, scope: !727)
!742 = !DILocation(line: 55, column: 3, scope: !727)
!743 = !DILocation(line: 55, column: 7, scope: !727)
!744 = !DILocation(line: 56, column: 7, scope: !735)
!745 = !DILocation(line: 56, column: 11, scope: !735)
!746 = !DILocation(line: 56, column: 18, scope: !739)
!747 = !DILocation(line: 56, column: 22, scope: !739)
!748 = !DILocation(line: 56, column: 20, scope: !739)
!749 = !DILocation(line: 56, column: 3, scope: !735)
!750 = !DILocation(line: 56, column: 3, scope: !739)
!751 = !DILocation(line: 57, column: 12, scope: !738)
!752 = !DILocation(line: 57, column: 13, scope: !738)
!753 = !DILocation(line: 57, column: 9, scope: !738)
!754 = !DILocation(line: 58, column: 9, scope: !737)
!755 = !DILocation(line: 58, column: 13, scope: !737)
!756 = !DILocation(line: 58, column: 20, scope: !757)
!757 = distinct !DILexicalBlock(scope: !737, file: !1, line: 58, column: 5)
!758 = !DILocation(line: 58, column: 24, scope: !757)
!759 = !DILocation(line: 58, column: 22, scope: !757)
!760 = !DILocation(line: 58, column: 5, scope: !737)
!761 = !DILocation(line: 58, column: 5, scope: !757)
!762 = !DILocation(line: 59, column: 9, scope: !757)
!763 = !DILocation(line: 59, column: 13, scope: !757)
!764 = !DILocation(line: 59, column: 7, scope: !757)
!765 = !DILocation(line: 58, column: 30, scope: !757)
!766 = distinct !{!766, !760, !767}
!767 = !DILocation(line: 59, column: 15, scope: !737)
!768 = !DILocation(line: 60, column: 8, scope: !738)
!769 = !DILocation(line: 60, column: 12, scope: !738)
!770 = !DILocation(line: 60, column: 5, scope: !738)
!771 = !DILocation(line: 61, column: 3, scope: !738)
!772 = !DILocation(line: 56, column: 28, scope: !739)
!773 = distinct !{!773, !749, !774}
!774 = !DILocation(line: 61, column: 3, scope: !735)
!775 = !DILocation(line: 62, column: 5, scope: !727)
!776 = !DILocation(line: 62, column: 3, scope: !727)
!777 = !DILocation(line: 63, column: 16, scope: !727)
!778 = !DILocation(line: 63, column: 14, scope: !727)
!779 = !DILocation(line: 63, column: 21, scope: !727)
!780 = !DILocation(line: 63, column: 19, scope: !727)
!781 = !DILocation(line: 63, column: 24, scope: !727)
!782 = !DILocation(line: 64, column: 1, scope: !727)
!783 = !DILocation(line: 63, column: 3, scope: !727)
!784 = distinct !DISubprogram(name: "main", scope: !1, file: !1, line: 66, type: !785, scopeLine: 67, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !787)
!785 = !DISubroutineType(types: !786)
!786 = !{!4, !4, !5}
!787 = !{!788, !789, !790, !791}
!788 = !DILocalVariable(name: "argc", arg: 1, scope: !784, file: !1, line: 66, type: !4)
!789 = !DILocalVariable(name: "argv", arg: 2, scope: !784, file: !1, line: 66, type: !5)
!790 = !DILocalVariable(name: "x1", scope: !784, file: !1, line: 68, type: !4)
!791 = !DILocalVariable(name: "x2", scope: !784, file: !1, line: 69, type: !4)
!792 = !DILocation(line: 66, column: 14, scope: !784)
!793 = !{!794, !794, i64 0}
!794 = !{!"any pointer", !602, i64 0}
!795 = !DILocation(line: 66, column: 28, scope: !784)
!796 = !DILocation(line: 68, column: 3, scope: !784)
!797 = !DILocation(line: 68, column: 7, scope: !784)
!798 = !DILocation(line: 68, column: 24, scope: !784)
!799 = !DILocation(line: 68, column: 19, scope: !784)
!800 = !DILocation(line: 69, column: 3, scope: !784)
!801 = !DILocation(line: 69, column: 7, scope: !784)
!802 = !DILocation(line: 69, column: 26, scope: !784)
!803 = !DILocation(line: 69, column: 21, scope: !784)
!804 = !DILocation(line: 69, column: 20, scope: !784)
!805 = !DILocation(line: 70, column: 3, scope: !784)
!806 = !DILocation(line: 71, column: 3, scope: !784)
!807 = !DILocation(line: 72, column: 5, scope: !784)
!808 = !DILocation(line: 72, column: 9, scope: !784)
!809 = !DILocation(line: 72, column: 3, scope: !784)
!810 = !DILocation(line: 75, column: 1, scope: !784)
!811 = !DILocation(line: 74, column: 3, scope: !784)
!812 = !DILocation(line: 361, column: 1, scope: !361)
!813 = !DILocation(line: 363, column: 24, scope: !361)
!814 = !DILocation(line: 363, column: 16, scope: !361)
!815 = !DILocation(line: 363, column: 3, scope: !361)
!816 = distinct !DISubprogram(name: "register_variable<int>", linkageName: "_Z17register_variableIiEvPT_PKc", scope: !817, file: !817, line: 14, type: !818, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, templateParams: !824, retainedNodes: !820)
!817 = !DIFile(filename: "include/ExtraPInstrumenter.hpp", directory: "/home/mcopik/projects/ETH/extrap/rebuild/perf-taint")
!818 = !DISubroutineType(types: !819)
!819 = !{null, !81, !171}
!820 = !{!821, !822, !823}
!821 = !DILocalVariable(name: "ptr", arg: 1, scope: !816, file: !817, line: 14, type: !81)
!822 = !DILocalVariable(name: "name", arg: 2, scope: !816, file: !817, line: 14, type: !171)
!823 = !DILocalVariable(name: "param_id", scope: !816, file: !817, line: 16, type: !524)
!824 = !{!825}
!825 = !DITemplateTypeParameter(name: "T", type: !4)
!826 = !DILocation(line: 14, column: 28, scope: !816)
!827 = !DILocation(line: 14, column: 46, scope: !816)
!828 = !DILocation(line: 16, column: 5, scope: !816)
!829 = !DILocation(line: 16, column: 13, scope: !816)
!830 = !DILocation(line: 16, column: 24, scope: !816)
!831 = !DILocation(line: 17, column: 57, scope: !816)
!832 = !DILocation(line: 17, column: 31, scope: !816)
!833 = !DILocation(line: 18, column: 21, scope: !816)
!834 = !DILocation(line: 18, column: 25, scope: !816)
!835 = !DILocation(line: 17, column: 5, scope: !816)
!836 = !DILocation(line: 19, column: 1, scope: !816)
