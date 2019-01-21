; RUN: opt %dfsan -S < %s 2> /dev/null | llc %llcparams - -o %t1 && clang++ %link %t1 -o %t2 && %execparams %t2 10 10 | diff -w %s.json -
; RUN: %jsonconvert %s.json | diff -w %s.processed.json -
; ModuleID = 'tests/dfsan-instr/function_call_nested.cpp'
source_filename = "tests/dfsan-instr/function_call_nested.cpp"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

$_Z17register_variableIiEvPT_PKc = comdat any

$_ZZ17register_variableIiEvPT_PKcE8param_id = comdat any

@global = dso_local global i32 100, align 4, !dbg !0
@.str = private unnamed_addr constant [7 x i8] c"extrap\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [43 x i8] c"tests/dfsan-instr/function_call_nested.cpp\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [3 x i8] c"x1\00", align 1
@.str.3 = private unnamed_addr constant [3 x i8] c"x2\00", align 1
@.str.4 = private unnamed_addr constant [7 x i8] c"global\00", align 1
@_ZZ17register_variableIiEvPT_PKcE8param_id = linkonce_odr dso_local global i32 0, comdat, align 4, !dbg !14
@llvm.global.annotations = appending global [1 x { i8*, i8*, i8*, i32 }] [{ i8*, i8*, i8*, i32 } { i8* bitcast (i32* @global to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([43 x i8], [43 x i8]* @.str.1, i32 0, i32 0), i32 7 }], section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @_Z1hi(i32) #0 !dbg !531 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !534, metadata !DIExpression()), !dbg !535
  call void @llvm.dbg.declare(metadata i32* %3, metadata !536, metadata !DIExpression()), !dbg !537
  store i32 0, i32* %3, align 4, !dbg !537
  call void @llvm.dbg.declare(metadata i32* %4, metadata !538, metadata !DIExpression()), !dbg !540
  %5 = load i32, i32* %2, align 4, !dbg !541
  store i32 %5, i32* %4, align 4, !dbg !540
  br label %6, !dbg !542

; <label>:6:                                      ; preds = %13, %1
  %7 = load i32, i32* %4, align 4, !dbg !543
  %8 = icmp slt i32 %7, 100, !dbg !545
  br i1 %8, label %9, label %16, !dbg !546

; <label>:9:                                      ; preds = %6
  %10 = load i32, i32* %4, align 4, !dbg !547
  %11 = load i32, i32* %3, align 4, !dbg !548
  %12 = add nsw i32 %11, %10, !dbg !548
  store i32 %12, i32* %3, align 4, !dbg !548
  br label %13, !dbg !549

; <label>:13:                                     ; preds = %9
  %14 = load i32, i32* %4, align 4, !dbg !550
  %15 = add nsw i32 %14, 1, !dbg !550
  store i32 %15, i32* %4, align 4, !dbg !550
  br label %6, !dbg !551, !llvm.loop !552

; <label>:16:                                     ; preds = %6
  %17 = load i32, i32* %3, align 4, !dbg !554
  %18 = mul nsw i32 100, %17, !dbg !555
  %19 = sitofp i32 %18 to double, !dbg !556
  %20 = load i32, i32* %2, align 4, !dbg !557
  %21 = sitofp i32 %20 to double, !dbg !557
  %22 = call double @log(double %21) #4, !dbg !558
  %23 = fmul double %19, %22, !dbg !559
  %24 = fptosi double %23 to i32, !dbg !556
  ret i32 %24, !dbg !560
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind
declare dso_local double @log(double) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @_Z1fii(i32, i32) #0 !dbg !561 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  call void @llvm.dbg.declare(metadata i32* %3, metadata !564, metadata !DIExpression()), !dbg !565
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !566, metadata !DIExpression()), !dbg !567
  call void @llvm.dbg.declare(metadata i32* %5, metadata !568, metadata !DIExpression()), !dbg !569
  store i32 0, i32* %5, align 4, !dbg !569
  call void @llvm.dbg.declare(metadata i32* %6, metadata !570, metadata !DIExpression()), !dbg !572
  %7 = load i32, i32* %3, align 4, !dbg !573
  store i32 %7, i32* %6, align 4, !dbg !572
  br label %8, !dbg !574

; <label>:8:                                      ; preds = %16, %2
  %9 = load i32, i32* %6, align 4, !dbg !575
  %10 = load i32, i32* %4, align 4, !dbg !577
  %11 = icmp slt i32 %9, %10, !dbg !578
  br i1 %11, label %12, label %19, !dbg !579

; <label>:12:                                     ; preds = %8
  %13 = load i32, i32* %6, align 4, !dbg !580
  %14 = load i32, i32* %5, align 4, !dbg !581
  %15 = add nsw i32 %14, %13, !dbg !581
  store i32 %15, i32* %5, align 4, !dbg !581
  br label %16, !dbg !582

; <label>:16:                                     ; preds = %12
  %17 = load i32, i32* %6, align 4, !dbg !583
  %18 = add nsw i32 %17, 1, !dbg !583
  store i32 %18, i32* %6, align 4, !dbg !583
  br label %8, !dbg !584, !llvm.loop !585

; <label>:19:                                     ; preds = %8
  %20 = load i32, i32* %3, align 4, !dbg !587
  %21 = mul nsw i32 10, %20, !dbg !588
  %22 = load i32, i32* %4, align 4, !dbg !589
  %23 = sdiv i32 %22, 2, !dbg !590
  %24 = call i32 @_Z1hi(i32 %23), !dbg !591
  %25 = add nsw i32 %21, %24, !dbg !592
  %26 = load i32, i32* %5, align 4, !dbg !593
  %27 = add nsw i32 %25, %26, !dbg !594
  ret i32 %27, !dbg !595
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @_Z1gi(i32) #0 !dbg !596 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !597, metadata !DIExpression()), !dbg !598
  call void @llvm.dbg.declare(metadata i32* %3, metadata !599, metadata !DIExpression()), !dbg !600
  store i32 0, i32* %3, align 4, !dbg !600
  call void @llvm.dbg.declare(metadata i32* %4, metadata !601, metadata !DIExpression()), !dbg !603
  %5 = load i32, i32* %2, align 4, !dbg !604
  store i32 %5, i32* %4, align 4, !dbg !603
  br label %6, !dbg !605

; <label>:6:                                      ; preds = %14, %1
  %7 = load i32, i32* %4, align 4, !dbg !606
  %8 = load i32, i32* @global, align 4, !dbg !608
  %9 = icmp slt i32 %7, %8, !dbg !609
  br i1 %9, label %10, label %17, !dbg !610

; <label>:10:                                     ; preds = %6
  %11 = load i32, i32* %4, align 4, !dbg !611
  %12 = load i32, i32* %3, align 4, !dbg !612
  %13 = add nsw i32 %12, %11, !dbg !612
  store i32 %13, i32* %3, align 4, !dbg !612
  br label %14, !dbg !613

; <label>:14:                                     ; preds = %10
  %15 = load i32, i32* %4, align 4, !dbg !614
  %16 = add nsw i32 %15, 1, !dbg !614
  store i32 %16, i32* %4, align 4, !dbg !614
  br label %6, !dbg !615, !llvm.loop !616

; <label>:17:                                     ; preds = %6
  %18 = load i32, i32* %2, align 4, !dbg !618
  %19 = add nsw i32 100, %18, !dbg !619
  %20 = load i32, i32* %3, align 4, !dbg !620
  %21 = add nsw i32 %19, %20, !dbg !621
  %22 = sitofp i32 %21 to double, !dbg !622
  %23 = load i32, i32* @global, align 4, !dbg !623
  %24 = sitofp i32 %23 to double, !dbg !623
  %25 = call double @pow(double %24, double 3.000000e+00) #4, !dbg !624
  %26 = fadd double %22, %25, !dbg !625
  %27 = fptosi double %26 to i32, !dbg !622
  %28 = call i32 @_Z1hi(i32 %27), !dbg !626
  ret i32 %28, !dbg !627
}

; Function Attrs: nounwind
declare dso_local double @pow(double, double) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @_Z1iiii(i32, i32, i32) #0 !dbg !628 {
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store i32 %0, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !631, metadata !DIExpression()), !dbg !632
  store i32 %1, i32* %5, align 4
  call void @llvm.dbg.declare(metadata i32* %5, metadata !633, metadata !DIExpression()), !dbg !634
  store i32 %2, i32* %6, align 4
  call void @llvm.dbg.declare(metadata i32* %6, metadata !635, metadata !DIExpression()), !dbg !636
  call void @llvm.dbg.declare(metadata i32* %7, metadata !637, metadata !DIExpression()), !dbg !638
  store i32 0, i32* %7, align 4, !dbg !638
  call void @llvm.dbg.declare(metadata i32* %8, metadata !639, metadata !DIExpression()), !dbg !641
  %9 = load i32, i32* %4, align 4, !dbg !642
  store i32 %9, i32* %8, align 4, !dbg !641
  br label %10, !dbg !643

; <label>:10:                                     ; preds = %23, %3
  %11 = load i32, i32* %8, align 4, !dbg !644
  %12 = load i32, i32* %5, align 4, !dbg !646
  %13 = add nsw i32 %12, 1, !dbg !647
  %14 = icmp slt i32 %11, %13, !dbg !648
  br i1 %14, label %15, label %27, !dbg !649

; <label>:15:                                     ; preds = %10
  %16 = load i32, i32* %8, align 4, !dbg !650
  %17 = sitofp i32 %16 to double, !dbg !650
  %18 = fmul double %17, 1.100000e+00, !dbg !651
  %19 = load i32, i32* %7, align 4, !dbg !652
  %20 = sitofp i32 %19 to double, !dbg !652
  %21 = fadd double %20, %18, !dbg !652
  %22 = fptosi double %21 to i32, !dbg !652
  store i32 %22, i32* %7, align 4, !dbg !652
  br label %23, !dbg !653

; <label>:23:                                     ; preds = %15
  %24 = load i32, i32* %6, align 4, !dbg !654
  %25 = load i32, i32* %8, align 4, !dbg !655
  %26 = add nsw i32 %25, %24, !dbg !655
  store i32 %26, i32* %8, align 4, !dbg !655
  br label %10, !dbg !656, !llvm.loop !657

; <label>:27:                                     ; preds = %10
  %28 = load i32, i32* @global, align 4, !dbg !659
  %29 = load i32, i32* %4, align 4, !dbg !660
  %30 = call i32 @_Z1fii(i32 %28, i32 %29), !dbg !661
  %31 = load i32, i32* %4, align 4, !dbg !662
  %32 = mul nsw i32 %30, %31, !dbg !663
  %33 = load i32, i32* %5, align 4, !dbg !664
  %34 = mul nsw i32 %32, %33, !dbg !665
  %35 = load i32, i32* %7, align 4, !dbg !666
  %36 = add nsw i32 %34, %35, !dbg !667
  %37 = load i32, i32* %6, align 4, !dbg !668
  %38 = call i32 @_Z1hi(i32 %37), !dbg !669
  %39 = call i32 @_Z1fii(i32 2, i32 5), !dbg !670
  %40 = mul nsw i32 %38, %39, !dbg !671
  %41 = add nsw i32 %36, %40, !dbg !672
  ret i32 %41, !dbg !673
}

; Function Attrs: noinline norecurse optnone uwtable
define dso_local i32 @main(i32, i8**) #3 !dbg !674 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !677, metadata !DIExpression()), !dbg !678
  store i8** %1, i8*** %5, align 8
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !679, metadata !DIExpression()), !dbg !680
  call void @llvm.dbg.declare(metadata i32* %6, metadata !681, metadata !DIExpression()), !dbg !682
  %9 = bitcast i32* %6 to i8*, !dbg !683
  call void @llvm.var.annotation(i8* %9, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([43 x i8], [43 x i8]* @.str.1, i32 0, i32 0), i32 43), !dbg !683
  %10 = load i8**, i8*** %5, align 8, !dbg !684
  %11 = getelementptr inbounds i8*, i8** %10, i64 1, !dbg !684
  %12 = load i8*, i8** %11, align 8, !dbg !684
  %13 = call i32 @atoi(i8* %12) #8, !dbg !685
  store i32 %13, i32* %6, align 4, !dbg !682
  call void @llvm.dbg.declare(metadata i32* %7, metadata !686, metadata !DIExpression()), !dbg !687
  %14 = bitcast i32* %7 to i8*, !dbg !688
  call void @llvm.var.annotation(i8* %14, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([43 x i8], [43 x i8]* @.str.1, i32 0, i32 0), i32 44), !dbg !688
  %15 = load i8**, i8*** %5, align 8, !dbg !689
  %16 = getelementptr inbounds i8*, i8** %15, i64 2, !dbg !689
  %17 = load i8*, i8** %16, align 8, !dbg !689
  %18 = call i32 @atoi(i8* %17) #8, !dbg !690
  store i32 %18, i32* %7, align 4, !dbg !687
  call void @_Z17register_variableIiEvPT_PKc(i32* %6, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.2, i32 0, i32 0)), !dbg !691
  call void @_Z17register_variableIiEvPT_PKc(i32* %7, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.3, i32 0, i32 0)), !dbg !692
  call void @_Z17register_variableIiEvPT_PKc(i32* @global, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.4, i32 0, i32 0)), !dbg !693
  call void @llvm.dbg.declare(metadata i32* %8, metadata !694, metadata !DIExpression()), !dbg !695
  %19 = load i32, i32* %6, align 4, !dbg !696
  %20 = mul nsw i32 2, %19, !dbg !697
  %21 = add nsw i32 %20, 1, !dbg !698
  store i32 %21, i32* %8, align 4, !dbg !695
  %22 = load i32, i32* @global, align 4, !dbg !699
  %23 = load i32, i32* %6, align 4, !dbg !700
  %24 = call i32 @_Z1fii(i32 %22, i32 %23), !dbg !701
  %25 = load i32, i32* %7, align 4, !dbg !702
  %26 = call i32 @_Z1fii(i32 %25, i32 100), !dbg !703
  %27 = call i32 @_Z1gi(i32 100), !dbg !704
  %28 = load i32, i32* %7, align 4, !dbg !705
  %29 = call i32 @_Z1hi(i32 %28), !dbg !706
  %30 = call i32 @_Z1hi(i32 100), !dbg !707
  %31 = load i32, i32* %7, align 4, !dbg !708
  %32 = load i32, i32* %6, align 4, !dbg !709
  %33 = load i32, i32* @global, align 4, !dbg !710
  %34 = mul nsw i32 15, %33, !dbg !711
  %35 = call i32 @_Z1iiii(i32 %31, i32 %32, i32 %34), !dbg !712
  ret i32 0, !dbg !713
}

; Function Attrs: nounwind
declare void @llvm.var.annotation(i8*, i8*, i8*, i32) #4

; Function Attrs: nounwind readonly
declare dso_local i32 @atoi(i8*) #5

; Function Attrs: noinline optnone uwtable
define linkonce_odr dso_local void @_Z17register_variableIiEvPT_PKc(i32*, i8*) #6 comdat !dbg !16 {
  %3 = alloca i32*, align 8
  %4 = alloca i8*, align 8
  store i32* %0, i32** %3, align 8
  call void @llvm.dbg.declare(metadata i32** %3, metadata !714, metadata !DIExpression()), !dbg !715
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !716, metadata !DIExpression()), !dbg !717
  %5 = load i32*, i32** %3, align 8, !dbg !718
  %6 = bitcast i32* %5 to i8*, !dbg !719
  %7 = load i32, i32* @_ZZ17register_variableIiEvPT_PKcE8param_id, align 4, !dbg !720
  %8 = add nsw i32 %7, 1, !dbg !720
  store i32 %8, i32* @_ZZ17register_variableIiEvPT_PKcE8param_id, align 4, !dbg !720
  %9 = load i8*, i8** %4, align 8, !dbg !721
  call void @__dfsw_EXTRAP_STORE_LABEL(i8* %6, i32 4, i32 %7, i8* %9), !dbg !722
  ret void, !dbg !723
}

declare dso_local void @__dfsw_EXTRAP_STORE_LABEL(i8*, i32, i32, i8*) #7

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { noinline norecurse optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind }
attributes #5 = { nounwind readonly "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #6 = { noinline optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #7 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #8 = { nounwind readonly }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!527, !528, !529}
!llvm.ident = !{!530}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "global", scope: !2, file: !3, line: 7, type: !21, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !3, producer: "clang version 8.0.0 (git@github.com:llvm-mirror/clang.git fd01d8b9288b3558a597daeb0cb4481b37c5bf68) (git@github.com:llvm-mirror/LLVM.git 7135d8b482d3d0d1a8c50111eebb9b207e92a8bc)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !5, globals: !13, imports: !29, nameTableKind: None)
!3 = !DIFile(filename: "tests/dfsan-instr/function_call_nested.cpp", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!4 = !{}
!5 = !{!6, !7}
!6 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!7 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !8, size: 64)
!8 = !DIDerivedType(tag: DW_TAG_typedef, name: "int8_t", file: !9, line: 24, baseType: !10)
!9 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-intn.h", directory: "")
!10 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int8_t", file: !11, line: 36, baseType: !12)
!11 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "")
!12 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!13 = !{!0, !14}
!14 = !DIGlobalVariableExpression(var: !15, expr: !DIExpression())
!15 = distinct !DIGlobalVariable(name: "param_id", scope: !16, file: !17, line: 13, type: !27, isLocal: false, isDefinition: true)
!16 = distinct !DISubprogram(name: "register_variable<int>", linkageName: "_Z17register_variableIiEvPT_PKc", scope: !17, file: !17, line: 11, type: !18, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, templateParams: !25, retainedNodes: !4)
!17 = !DIFile(filename: "include/ExtrapInstrumenter.hpp", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!18 = !DISubroutineType(types: !19)
!19 = !{null, !20, !22}
!20 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !21, size: 64)
!21 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!22 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !23, size: 64)
!23 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !24)
!24 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!25 = !{!26}
!26 = !DITemplateTypeParameter(name: "T", type: !21)
!27 = !DIDerivedType(tag: DW_TAG_typedef, name: "int32_t", file: !9, line: 26, baseType: !28)
!28 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int32_t", file: !11, line: 40, baseType: !21)
!29 = !{!30, !37, !40, !43, !51, !53, !57, !59, !63, !68, !70, !72, !76, !78, !80, !82, !84, !86, !88, !90, !94, !98, !100, !102, !107, !112, !114, !116, !118, !120, !122, !124, !126, !128, !130, !132, !134, !136, !138, !140, !142, !144, !148, !150, !152, !154, !158, !160, !165, !167, !169, !171, !173, !177, !179, !183, !187, !189, !191, !195, !197, !201, !203, !205, !209, !211, !213, !215, !217, !219, !221, !225, !227, !229, !231, !233, !235, !237, !239, !243, !247, !249, !251, !253, !255, !257, !259, !261, !263, !265, !267, !269, !271, !273, !275, !277, !279, !281, !283, !285, !289, !291, !293, !295, !299, !301, !305, !307, !309, !311, !313, !317, !319, !323, !325, !327, !329, !331, !335, !337, !339, !343, !345, !347, !349, !351, !355, !361, !367, !369, !373, !377, !381, !389, !393, !397, !401, !405, !409, !414, !418, !423, !428, !432, !436, !440, !444, !449, !453, !455, !459, !461, !471, !475, !480, !484, !486, !490, !494, !496, !500, !507, !511, !515, !523, !525}
!30 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !33, file: !36, line: 50)
!31 = !DINamespace(name: "__1", scope: !32, exportSymbols: true)
!32 = !DINamespace(name: "std", scope: null)
!33 = !DIDerivedType(tag: DW_TAG_typedef, name: "ptrdiff_t", file: !34, line: 149, baseType: !35)
!34 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7/include/stddef.h", directory: "")
!35 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!36 = !DIFile(filename: "clang_llvm/build_dfsan_full/include/c++/v1/cstddef", directory: "/home/mcopik/projects")
!37 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !38, file: !36, line: 51)
!38 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !34, line: 216, baseType: !39)
!39 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!40 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !41, file: !36, line: 56)
!41 = !DIDerivedType(tag: DW_TAG_typedef, name: "max_align_t", file: !34, line: 437, baseType: !42)
!42 = !DICompositeType(tag: DW_TAG_structure_type, file: !34, line: 426, flags: DIFlagFwdDecl, identifier: "_ZTS11max_align_t")
!43 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !44, file: !50, line: 317)
!44 = !DISubprogram(name: "isinf", linkageName: "_Z5isinfe", scope: !45, file: !45, line: 497, type: !46, flags: DIFlagPrototyped, spFlags: 0)
!45 = !DIFile(filename: "clang_llvm/build_dfsan_full/include/c++/v1/math.h", directory: "/home/mcopik/projects")
!46 = !DISubroutineType(types: !47)
!47 = !{!48, !49}
!48 = !DIBasicType(name: "bool", size: 8, encoding: DW_ATE_boolean)
!49 = !DIBasicType(name: "long double", size: 128, encoding: DW_ATE_float)
!50 = !DIFile(filename: "clang_llvm/build_dfsan_full/include/c++/v1/cmath", directory: "/home/mcopik/projects")
!51 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !52, file: !50, line: 318)
!52 = !DISubprogram(name: "isnan", linkageName: "_Z5isnane", scope: !45, file: !45, line: 541, type: !46, flags: DIFlagPrototyped, spFlags: 0)
!53 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !54, file: !50, line: 328)
!54 = !DIDerivedType(tag: DW_TAG_typedef, name: "float_t", file: !55, line: 149, baseType: !56)
!55 = !DIFile(filename: "/usr/include/math.h", directory: "")
!56 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!57 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !58, file: !50, line: 329)
!58 = !DIDerivedType(tag: DW_TAG_typedef, name: "double_t", file: !55, line: 150, baseType: !6)
!59 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !60, file: !50, line: 332)
!60 = !DISubprogram(name: "abs", linkageName: "_Z3abse", scope: !45, file: !45, line: 769, type: !61, flags: DIFlagPrototyped, spFlags: 0)
!61 = !DISubroutineType(types: !62)
!62 = !{!49, !49}
!63 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !64, file: !50, line: 336)
!64 = !DISubprogram(name: "acosf", scope: !65, file: !65, line: 53, type: !66, flags: DIFlagPrototyped, spFlags: 0)
!65 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/mathcalls.h", directory: "")
!66 = !DISubroutineType(types: !67)
!67 = !{!56, !56}
!68 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !69, file: !50, line: 338)
!69 = !DISubprogram(name: "asinf", scope: !65, file: !65, line: 55, type: !66, flags: DIFlagPrototyped, spFlags: 0)
!70 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !71, file: !50, line: 340)
!71 = !DISubprogram(name: "atanf", scope: !65, file: !65, line: 57, type: !66, flags: DIFlagPrototyped, spFlags: 0)
!72 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !73, file: !50, line: 342)
!73 = !DISubprogram(name: "atan2f", scope: !65, file: !65, line: 59, type: !74, flags: DIFlagPrototyped, spFlags: 0)
!74 = !DISubroutineType(types: !75)
!75 = !{!56, !56, !56}
!76 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !77, file: !50, line: 344)
!77 = !DISubprogram(name: "ceilf", scope: !65, file: !65, line: 159, type: !66, flags: DIFlagPrototyped, spFlags: 0)
!78 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !79, file: !50, line: 346)
!79 = !DISubprogram(name: "cosf", scope: !65, file: !65, line: 62, type: !66, flags: DIFlagPrototyped, spFlags: 0)
!80 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !81, file: !50, line: 348)
!81 = !DISubprogram(name: "coshf", scope: !65, file: !65, line: 71, type: !66, flags: DIFlagPrototyped, spFlags: 0)
!82 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !83, file: !50, line: 351)
!83 = !DISubprogram(name: "expf", scope: !65, file: !65, line: 95, type: !66, flags: DIFlagPrototyped, spFlags: 0)
!84 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !85, file: !50, line: 354)
!85 = !DISubprogram(name: "fabsf", scope: !65, file: !65, line: 162, type: !66, flags: DIFlagPrototyped, spFlags: 0)
!86 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !87, file: !50, line: 356)
!87 = !DISubprogram(name: "floorf", scope: !65, file: !65, line: 165, type: !66, flags: DIFlagPrototyped, spFlags: 0)
!88 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !89, file: !50, line: 359)
!89 = !DISubprogram(name: "fmodf", scope: !65, file: !65, line: 168, type: !74, flags: DIFlagPrototyped, spFlags: 0)
!90 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !91, file: !50, line: 362)
!91 = !DISubprogram(name: "frexpf", scope: !65, file: !65, line: 98, type: !92, flags: DIFlagPrototyped, spFlags: 0)
!92 = !DISubroutineType(types: !93)
!93 = !{!56, !56, !20}
!94 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !95, file: !50, line: 364)
!95 = !DISubprogram(name: "ldexpf", scope: !65, file: !65, line: 101, type: !96, flags: DIFlagPrototyped, spFlags: 0)
!96 = !DISubroutineType(types: !97)
!97 = !{!56, !56, !21}
!98 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !99, file: !50, line: 367)
!99 = !DISubprogram(name: "logf", scope: !65, file: !65, line: 104, type: !66, flags: DIFlagPrototyped, spFlags: 0)
!100 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !101, file: !50, line: 370)
!101 = !DISubprogram(name: "log10f", scope: !65, file: !65, line: 107, type: !66, flags: DIFlagPrototyped, spFlags: 0)
!102 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !103, file: !50, line: 371)
!103 = !DISubprogram(name: "modf", linkageName: "_Z4modfePe", scope: !45, file: !45, line: 978, type: !104, flags: DIFlagPrototyped, spFlags: 0)
!104 = !DISubroutineType(types: !105)
!105 = !{!49, !49, !106}
!106 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !49, size: 64)
!107 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !108, file: !50, line: 372)
!108 = !DISubprogram(name: "modff", scope: !65, file: !65, line: 110, type: !109, flags: DIFlagPrototyped, spFlags: 0)
!109 = !DISubroutineType(types: !110)
!110 = !{!56, !56, !111}
!111 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !56, size: 64)
!112 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !113, file: !50, line: 375)
!113 = !DISubprogram(name: "powf", scope: !65, file: !65, line: 140, type: !74, flags: DIFlagPrototyped, spFlags: 0)
!114 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !115, file: !50, line: 378)
!115 = !DISubprogram(name: "sinf", scope: !65, file: !65, line: 64, type: !66, flags: DIFlagPrototyped, spFlags: 0)
!116 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !117, file: !50, line: 380)
!117 = !DISubprogram(name: "sinhf", scope: !65, file: !65, line: 73, type: !66, flags: DIFlagPrototyped, spFlags: 0)
!118 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !119, file: !50, line: 383)
!119 = !DISubprogram(name: "sqrtf", scope: !65, file: !65, line: 143, type: !66, flags: DIFlagPrototyped, spFlags: 0)
!120 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !121, file: !50, line: 385)
!121 = !DISubprogram(name: "tanf", scope: !65, file: !65, line: 66, type: !66, flags: DIFlagPrototyped, spFlags: 0)
!122 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !123, file: !50, line: 388)
!123 = !DISubprogram(name: "tanhf", scope: !65, file: !65, line: 75, type: !66, flags: DIFlagPrototyped, spFlags: 0)
!124 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !125, file: !50, line: 391)
!125 = !DISubprogram(name: "acoshf", scope: !65, file: !65, line: 85, type: !66, flags: DIFlagPrototyped, spFlags: 0)
!126 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !127, file: !50, line: 393)
!127 = !DISubprogram(name: "asinhf", scope: !65, file: !65, line: 87, type: !66, flags: DIFlagPrototyped, spFlags: 0)
!128 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !129, file: !50, line: 395)
!129 = !DISubprogram(name: "atanhf", scope: !65, file: !65, line: 89, type: !66, flags: DIFlagPrototyped, spFlags: 0)
!130 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !131, file: !50, line: 397)
!131 = !DISubprogram(name: "cbrtf", scope: !65, file: !65, line: 152, type: !66, flags: DIFlagPrototyped, spFlags: 0)
!132 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !133, file: !50, line: 400)
!133 = !DISubprogram(name: "copysignf", scope: !65, file: !65, line: 196, type: !74, flags: DIFlagPrototyped, spFlags: 0)
!134 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !135, file: !50, line: 403)
!135 = !DISubprogram(name: "erff", scope: !65, file: !65, line: 228, type: !66, flags: DIFlagPrototyped, spFlags: 0)
!136 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !137, file: !50, line: 405)
!137 = !DISubprogram(name: "erfcf", scope: !65, file: !65, line: 229, type: !66, flags: DIFlagPrototyped, spFlags: 0)
!138 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !139, file: !50, line: 407)
!139 = !DISubprogram(name: "exp2f", scope: !65, file: !65, line: 130, type: !66, flags: DIFlagPrototyped, spFlags: 0)
!140 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !141, file: !50, line: 409)
!141 = !DISubprogram(name: "expm1f", scope: !65, file: !65, line: 119, type: !66, flags: DIFlagPrototyped, spFlags: 0)
!142 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !143, file: !50, line: 411)
!143 = !DISubprogram(name: "fdimf", scope: !65, file: !65, line: 326, type: !74, flags: DIFlagPrototyped, spFlags: 0)
!144 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !145, file: !50, line: 412)
!145 = !DISubprogram(name: "fmaf", scope: !65, file: !65, line: 335, type: !146, flags: DIFlagPrototyped, spFlags: 0)
!146 = !DISubroutineType(types: !147)
!147 = !{!56, !56, !56, !56}
!148 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !149, file: !50, line: 415)
!149 = !DISubprogram(name: "fmaxf", scope: !65, file: !65, line: 329, type: !74, flags: DIFlagPrototyped, spFlags: 0)
!150 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !151, file: !50, line: 417)
!151 = !DISubprogram(name: "fminf", scope: !65, file: !65, line: 332, type: !74, flags: DIFlagPrototyped, spFlags: 0)
!152 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !153, file: !50, line: 419)
!153 = !DISubprogram(name: "hypotf", scope: !65, file: !65, line: 147, type: !74, flags: DIFlagPrototyped, spFlags: 0)
!154 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !155, file: !50, line: 421)
!155 = !DISubprogram(name: "ilogbf", scope: !65, file: !65, line: 280, type: !156, flags: DIFlagPrototyped, spFlags: 0)
!156 = !DISubroutineType(types: !157)
!157 = !{!21, !56}
!158 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !159, file: !50, line: 423)
!159 = !DISubprogram(name: "lgammaf", scope: !65, file: !65, line: 230, type: !66, flags: DIFlagPrototyped, spFlags: 0)
!160 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !161, file: !50, line: 425)
!161 = !DISubprogram(name: "llrintf", scope: !65, file: !65, line: 316, type: !162, flags: DIFlagPrototyped, spFlags: 0)
!162 = !DISubroutineType(types: !163)
!163 = !{!164, !56}
!164 = !DIBasicType(name: "long long int", size: 64, encoding: DW_ATE_signed)
!165 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !166, file: !50, line: 427)
!166 = !DISubprogram(name: "llroundf", scope: !65, file: !65, line: 322, type: !162, flags: DIFlagPrototyped, spFlags: 0)
!167 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !168, file: !50, line: 429)
!168 = !DISubprogram(name: "log1pf", scope: !65, file: !65, line: 122, type: !66, flags: DIFlagPrototyped, spFlags: 0)
!169 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !170, file: !50, line: 431)
!170 = !DISubprogram(name: "log2f", scope: !65, file: !65, line: 133, type: !66, flags: DIFlagPrototyped, spFlags: 0)
!171 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !172, file: !50, line: 433)
!172 = !DISubprogram(name: "logbf", scope: !65, file: !65, line: 125, type: !66, flags: DIFlagPrototyped, spFlags: 0)
!173 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !174, file: !50, line: 435)
!174 = !DISubprogram(name: "lrintf", scope: !65, file: !65, line: 314, type: !175, flags: DIFlagPrototyped, spFlags: 0)
!175 = !DISubroutineType(types: !176)
!176 = !{!35, !56}
!177 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !178, file: !50, line: 437)
!178 = !DISubprogram(name: "lroundf", scope: !65, file: !65, line: 320, type: !175, flags: DIFlagPrototyped, spFlags: 0)
!179 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !180, file: !50, line: 439)
!180 = !DISubprogram(name: "nan", scope: !65, file: !65, line: 201, type: !181, flags: DIFlagPrototyped, spFlags: 0)
!181 = !DISubroutineType(types: !182)
!182 = !{!6, !22}
!183 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !184, file: !50, line: 440)
!184 = !DISubprogram(name: "nanf", scope: !65, file: !65, line: 201, type: !185, flags: DIFlagPrototyped, spFlags: 0)
!185 = !DISubroutineType(types: !186)
!186 = !{!56, !22}
!187 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !188, file: !50, line: 443)
!188 = !DISubprogram(name: "nearbyintf", scope: !65, file: !65, line: 294, type: !66, flags: DIFlagPrototyped, spFlags: 0)
!189 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !190, file: !50, line: 445)
!190 = !DISubprogram(name: "nextafterf", scope: !65, file: !65, line: 259, type: !74, flags: DIFlagPrototyped, spFlags: 0)
!191 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !192, file: !50, line: 447)
!192 = !DISubprogram(name: "nexttowardf", scope: !65, file: !65, line: 261, type: !193, flags: DIFlagPrototyped, spFlags: 0)
!193 = !DISubroutineType(types: !194)
!194 = !{!56, !56, !49}
!195 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !196, file: !50, line: 449)
!196 = !DISubprogram(name: "remainderf", scope: !65, file: !65, line: 272, type: !74, flags: DIFlagPrototyped, spFlags: 0)
!197 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !198, file: !50, line: 451)
!198 = !DISubprogram(name: "remquof", scope: !65, file: !65, line: 307, type: !199, flags: DIFlagPrototyped, spFlags: 0)
!199 = !DISubroutineType(types: !200)
!200 = !{!56, !56, !56, !20}
!201 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !202, file: !50, line: 453)
!202 = !DISubprogram(name: "rintf", scope: !65, file: !65, line: 256, type: !66, flags: DIFlagPrototyped, spFlags: 0)
!203 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !204, file: !50, line: 455)
!204 = !DISubprogram(name: "roundf", scope: !65, file: !65, line: 298, type: !66, flags: DIFlagPrototyped, spFlags: 0)
!205 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !206, file: !50, line: 457)
!206 = !DISubprogram(name: "scalblnf", scope: !65, file: !65, line: 290, type: !207, flags: DIFlagPrototyped, spFlags: 0)
!207 = !DISubroutineType(types: !208)
!208 = !{!56, !56, !35}
!209 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !210, file: !50, line: 459)
!210 = !DISubprogram(name: "scalbnf", scope: !65, file: !65, line: 276, type: !96, flags: DIFlagPrototyped, spFlags: 0)
!211 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !212, file: !50, line: 461)
!212 = !DISubprogram(name: "tgammaf", scope: !65, file: !65, line: 235, type: !66, flags: DIFlagPrototyped, spFlags: 0)
!213 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !214, file: !50, line: 463)
!214 = !DISubprogram(name: "truncf", scope: !65, file: !65, line: 302, type: !66, flags: DIFlagPrototyped, spFlags: 0)
!215 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !216, file: !50, line: 465)
!216 = !DISubprogram(name: "acosl", scope: !65, file: !65, line: 53, type: !61, flags: DIFlagPrototyped, spFlags: 0)
!217 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !218, file: !50, line: 466)
!218 = !DISubprogram(name: "asinl", scope: !65, file: !65, line: 55, type: !61, flags: DIFlagPrototyped, spFlags: 0)
!219 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !220, file: !50, line: 467)
!220 = !DISubprogram(name: "atanl", scope: !65, file: !65, line: 57, type: !61, flags: DIFlagPrototyped, spFlags: 0)
!221 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !222, file: !50, line: 468)
!222 = !DISubprogram(name: "atan2l", scope: !65, file: !65, line: 59, type: !223, flags: DIFlagPrototyped, spFlags: 0)
!223 = !DISubroutineType(types: !224)
!224 = !{!49, !49, !49}
!225 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !226, file: !50, line: 469)
!226 = !DISubprogram(name: "ceill", scope: !65, file: !65, line: 159, type: !61, flags: DIFlagPrototyped, spFlags: 0)
!227 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !228, file: !50, line: 470)
!228 = !DISubprogram(name: "cosl", scope: !65, file: !65, line: 62, type: !61, flags: DIFlagPrototyped, spFlags: 0)
!229 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !230, file: !50, line: 471)
!230 = !DISubprogram(name: "coshl", scope: !65, file: !65, line: 71, type: !61, flags: DIFlagPrototyped, spFlags: 0)
!231 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !232, file: !50, line: 472)
!232 = !DISubprogram(name: "expl", scope: !65, file: !65, line: 95, type: !61, flags: DIFlagPrototyped, spFlags: 0)
!233 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !234, file: !50, line: 473)
!234 = !DISubprogram(name: "fabsl", scope: !65, file: !65, line: 162, type: !61, flags: DIFlagPrototyped, spFlags: 0)
!235 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !236, file: !50, line: 474)
!236 = !DISubprogram(name: "floorl", scope: !65, file: !65, line: 165, type: !61, flags: DIFlagPrototyped, spFlags: 0)
!237 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !238, file: !50, line: 475)
!238 = !DISubprogram(name: "fmodl", scope: !65, file: !65, line: 168, type: !223, flags: DIFlagPrototyped, spFlags: 0)
!239 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !240, file: !50, line: 476)
!240 = !DISubprogram(name: "frexpl", scope: !65, file: !65, line: 98, type: !241, flags: DIFlagPrototyped, spFlags: 0)
!241 = !DISubroutineType(types: !242)
!242 = !{!49, !49, !20}
!243 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !244, file: !50, line: 477)
!244 = !DISubprogram(name: "ldexpl", scope: !65, file: !65, line: 101, type: !245, flags: DIFlagPrototyped, spFlags: 0)
!245 = !DISubroutineType(types: !246)
!246 = !{!49, !49, !21}
!247 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !248, file: !50, line: 478)
!248 = !DISubprogram(name: "logl", scope: !65, file: !65, line: 104, type: !61, flags: DIFlagPrototyped, spFlags: 0)
!249 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !250, file: !50, line: 479)
!250 = !DISubprogram(name: "log10l", scope: !65, file: !65, line: 107, type: !61, flags: DIFlagPrototyped, spFlags: 0)
!251 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !252, file: !50, line: 480)
!252 = !DISubprogram(name: "modfl", scope: !65, file: !65, line: 110, type: !104, flags: DIFlagPrototyped, spFlags: 0)
!253 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !254, file: !50, line: 481)
!254 = !DISubprogram(name: "powl", scope: !65, file: !65, line: 140, type: !223, flags: DIFlagPrototyped, spFlags: 0)
!255 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !256, file: !50, line: 482)
!256 = !DISubprogram(name: "sinl", scope: !65, file: !65, line: 64, type: !61, flags: DIFlagPrototyped, spFlags: 0)
!257 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !258, file: !50, line: 483)
!258 = !DISubprogram(name: "sinhl", scope: !65, file: !65, line: 73, type: !61, flags: DIFlagPrototyped, spFlags: 0)
!259 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !260, file: !50, line: 484)
!260 = !DISubprogram(name: "sqrtl", scope: !65, file: !65, line: 143, type: !61, flags: DIFlagPrototyped, spFlags: 0)
!261 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !262, file: !50, line: 485)
!262 = !DISubprogram(name: "tanl", scope: !65, file: !65, line: 66, type: !61, flags: DIFlagPrototyped, spFlags: 0)
!263 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !264, file: !50, line: 487)
!264 = !DISubprogram(name: "tanhl", scope: !65, file: !65, line: 75, type: !61, flags: DIFlagPrototyped, spFlags: 0)
!265 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !266, file: !50, line: 488)
!266 = !DISubprogram(name: "acoshl", scope: !65, file: !65, line: 85, type: !61, flags: DIFlagPrototyped, spFlags: 0)
!267 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !268, file: !50, line: 489)
!268 = !DISubprogram(name: "asinhl", scope: !65, file: !65, line: 87, type: !61, flags: DIFlagPrototyped, spFlags: 0)
!269 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !270, file: !50, line: 490)
!270 = !DISubprogram(name: "atanhl", scope: !65, file: !65, line: 89, type: !61, flags: DIFlagPrototyped, spFlags: 0)
!271 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !272, file: !50, line: 491)
!272 = !DISubprogram(name: "cbrtl", scope: !65, file: !65, line: 152, type: !61, flags: DIFlagPrototyped, spFlags: 0)
!273 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !274, file: !50, line: 493)
!274 = !DISubprogram(name: "copysignl", scope: !65, file: !65, line: 196, type: !223, flags: DIFlagPrototyped, spFlags: 0)
!275 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !276, file: !50, line: 495)
!276 = !DISubprogram(name: "erfl", scope: !65, file: !65, line: 228, type: !61, flags: DIFlagPrototyped, spFlags: 0)
!277 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !278, file: !50, line: 496)
!278 = !DISubprogram(name: "erfcl", scope: !65, file: !65, line: 229, type: !61, flags: DIFlagPrototyped, spFlags: 0)
!279 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !280, file: !50, line: 497)
!280 = !DISubprogram(name: "exp2l", scope: !65, file: !65, line: 130, type: !61, flags: DIFlagPrototyped, spFlags: 0)
!281 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !282, file: !50, line: 498)
!282 = !DISubprogram(name: "expm1l", scope: !65, file: !65, line: 119, type: !61, flags: DIFlagPrototyped, spFlags: 0)
!283 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !284, file: !50, line: 499)
!284 = !DISubprogram(name: "fdiml", scope: !65, file: !65, line: 326, type: !223, flags: DIFlagPrototyped, spFlags: 0)
!285 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !286, file: !50, line: 500)
!286 = !DISubprogram(name: "fmal", scope: !65, file: !65, line: 335, type: !287, flags: DIFlagPrototyped, spFlags: 0)
!287 = !DISubroutineType(types: !288)
!288 = !{!49, !49, !49, !49}
!289 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !290, file: !50, line: 501)
!290 = !DISubprogram(name: "fmaxl", scope: !65, file: !65, line: 329, type: !223, flags: DIFlagPrototyped, spFlags: 0)
!291 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !292, file: !50, line: 502)
!292 = !DISubprogram(name: "fminl", scope: !65, file: !65, line: 332, type: !223, flags: DIFlagPrototyped, spFlags: 0)
!293 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !294, file: !50, line: 503)
!294 = !DISubprogram(name: "hypotl", scope: !65, file: !65, line: 147, type: !223, flags: DIFlagPrototyped, spFlags: 0)
!295 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !296, file: !50, line: 504)
!296 = !DISubprogram(name: "ilogbl", scope: !65, file: !65, line: 280, type: !297, flags: DIFlagPrototyped, spFlags: 0)
!297 = !DISubroutineType(types: !298)
!298 = !{!21, !49}
!299 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !300, file: !50, line: 505)
!300 = !DISubprogram(name: "lgammal", scope: !65, file: !65, line: 230, type: !61, flags: DIFlagPrototyped, spFlags: 0)
!301 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !302, file: !50, line: 506)
!302 = !DISubprogram(name: "llrintl", scope: !65, file: !65, line: 316, type: !303, flags: DIFlagPrototyped, spFlags: 0)
!303 = !DISubroutineType(types: !304)
!304 = !{!164, !49}
!305 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !306, file: !50, line: 507)
!306 = !DISubprogram(name: "llroundl", scope: !65, file: !65, line: 322, type: !303, flags: DIFlagPrototyped, spFlags: 0)
!307 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !308, file: !50, line: 508)
!308 = !DISubprogram(name: "log1pl", scope: !65, file: !65, line: 122, type: !61, flags: DIFlagPrototyped, spFlags: 0)
!309 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !310, file: !50, line: 509)
!310 = !DISubprogram(name: "log2l", scope: !65, file: !65, line: 133, type: !61, flags: DIFlagPrototyped, spFlags: 0)
!311 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !312, file: !50, line: 510)
!312 = !DISubprogram(name: "logbl", scope: !65, file: !65, line: 125, type: !61, flags: DIFlagPrototyped, spFlags: 0)
!313 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !314, file: !50, line: 511)
!314 = !DISubprogram(name: "lrintl", scope: !65, file: !65, line: 314, type: !315, flags: DIFlagPrototyped, spFlags: 0)
!315 = !DISubroutineType(types: !316)
!316 = !{!35, !49}
!317 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !318, file: !50, line: 512)
!318 = !DISubprogram(name: "lroundl", scope: !65, file: !65, line: 320, type: !315, flags: DIFlagPrototyped, spFlags: 0)
!319 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !320, file: !50, line: 513)
!320 = !DISubprogram(name: "nanl", scope: !65, file: !65, line: 201, type: !321, flags: DIFlagPrototyped, spFlags: 0)
!321 = !DISubroutineType(types: !322)
!322 = !{!49, !22}
!323 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !324, file: !50, line: 514)
!324 = !DISubprogram(name: "nearbyintl", scope: !65, file: !65, line: 294, type: !61, flags: DIFlagPrototyped, spFlags: 0)
!325 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !326, file: !50, line: 515)
!326 = !DISubprogram(name: "nextafterl", scope: !65, file: !65, line: 259, type: !223, flags: DIFlagPrototyped, spFlags: 0)
!327 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !328, file: !50, line: 516)
!328 = !DISubprogram(name: "nexttowardl", scope: !65, file: !65, line: 261, type: !223, flags: DIFlagPrototyped, spFlags: 0)
!329 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !330, file: !50, line: 517)
!330 = !DISubprogram(name: "remainderl", scope: !65, file: !65, line: 272, type: !223, flags: DIFlagPrototyped, spFlags: 0)
!331 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !332, file: !50, line: 518)
!332 = !DISubprogram(name: "remquol", scope: !65, file: !65, line: 307, type: !333, flags: DIFlagPrototyped, spFlags: 0)
!333 = !DISubroutineType(types: !334)
!334 = !{!49, !49, !49, !20}
!335 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !336, file: !50, line: 519)
!336 = !DISubprogram(name: "rintl", scope: !65, file: !65, line: 256, type: !61, flags: DIFlagPrototyped, spFlags: 0)
!337 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !338, file: !50, line: 520)
!338 = !DISubprogram(name: "roundl", scope: !65, file: !65, line: 298, type: !61, flags: DIFlagPrototyped, spFlags: 0)
!339 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !340, file: !50, line: 521)
!340 = !DISubprogram(name: "scalblnl", scope: !65, file: !65, line: 290, type: !341, flags: DIFlagPrototyped, spFlags: 0)
!341 = !DISubroutineType(types: !342)
!342 = !{!49, !49, !35}
!343 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !344, file: !50, line: 522)
!344 = !DISubprogram(name: "scalbnl", scope: !65, file: !65, line: 276, type: !245, flags: DIFlagPrototyped, spFlags: 0)
!345 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !346, file: !50, line: 523)
!346 = !DISubprogram(name: "tgammal", scope: !65, file: !65, line: 235, type: !61, flags: DIFlagPrototyped, spFlags: 0)
!347 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !348, file: !50, line: 524)
!348 = !DISubprogram(name: "truncl", scope: !65, file: !65, line: 302, type: !61, flags: DIFlagPrototyped, spFlags: 0)
!349 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !38, file: !350, line: 100)
!350 = !DIFile(filename: "clang_llvm/build_dfsan_full/include/c++/v1/cstdlib", directory: "/home/mcopik/projects")
!351 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !352, file: !350, line: 101)
!352 = !DIDerivedType(tag: DW_TAG_typedef, name: "div_t", file: !353, line: 62, baseType: !354)
!353 = !DIFile(filename: "/usr/include/stdlib.h", directory: "")
!354 = !DICompositeType(tag: DW_TAG_structure_type, file: !353, line: 58, flags: DIFlagFwdDecl, identifier: "_ZTS5div_t")
!355 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !356, file: !350, line: 102)
!356 = !DIDerivedType(tag: DW_TAG_typedef, name: "ldiv_t", file: !353, line: 70, baseType: !357)
!357 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !353, line: 66, size: 128, flags: DIFlagTypePassByValue | DIFlagTrivial, elements: !358, identifier: "_ZTS6ldiv_t")
!358 = !{!359, !360}
!359 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !357, file: !353, line: 68, baseType: !35, size: 64)
!360 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !357, file: !353, line: 69, baseType: !35, size: 64, offset: 64)
!361 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !362, file: !350, line: 104)
!362 = !DIDerivedType(tag: DW_TAG_typedef, name: "lldiv_t", file: !353, line: 80, baseType: !363)
!363 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !353, line: 76, size: 128, flags: DIFlagTypePassByValue | DIFlagTrivial, elements: !364, identifier: "_ZTS7lldiv_t")
!364 = !{!365, !366}
!365 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !363, file: !353, line: 78, baseType: !164, size: 64)
!366 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !363, file: !353, line: 79, baseType: !164, size: 64, offset: 64)
!367 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !368, file: !350, line: 106)
!368 = !DISubprogram(name: "atof", scope: !353, file: !353, line: 101, type: !181, flags: DIFlagPrototyped, spFlags: 0)
!369 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !370, file: !350, line: 107)
!370 = !DISubprogram(name: "atoi", scope: !353, file: !353, line: 104, type: !371, flags: DIFlagPrototyped, spFlags: 0)
!371 = !DISubroutineType(types: !372)
!372 = !{!21, !22}
!373 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !374, file: !350, line: 108)
!374 = !DISubprogram(name: "atol", scope: !353, file: !353, line: 107, type: !375, flags: DIFlagPrototyped, spFlags: 0)
!375 = !DISubroutineType(types: !376)
!376 = !{!35, !22}
!377 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !378, file: !350, line: 110)
!378 = !DISubprogram(name: "atoll", scope: !353, file: !353, line: 112, type: !379, flags: DIFlagPrototyped, spFlags: 0)
!379 = !DISubroutineType(types: !380)
!380 = !{!164, !22}
!381 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !382, file: !350, line: 112)
!382 = !DISubprogram(name: "strtod", scope: !353, file: !353, line: 117, type: !383, flags: DIFlagPrototyped, spFlags: 0)
!383 = !DISubroutineType(types: !384)
!384 = !{!6, !385, !386}
!385 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !22)
!386 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !387)
!387 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !388, size: 64)
!388 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !24, size: 64)
!389 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !390, file: !350, line: 113)
!390 = !DISubprogram(name: "strtof", scope: !353, file: !353, line: 123, type: !391, flags: DIFlagPrototyped, spFlags: 0)
!391 = !DISubroutineType(types: !392)
!392 = !{!56, !385, !386}
!393 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !394, file: !350, line: 114)
!394 = !DISubprogram(name: "strtold", scope: !353, file: !353, line: 126, type: !395, flags: DIFlagPrototyped, spFlags: 0)
!395 = !DISubroutineType(types: !396)
!396 = !{!49, !385, !386}
!397 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !398, file: !350, line: 115)
!398 = !DISubprogram(name: "strtol", scope: !353, file: !353, line: 176, type: !399, flags: DIFlagPrototyped, spFlags: 0)
!399 = !DISubroutineType(types: !400)
!400 = !{!35, !385, !386, !21}
!401 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !402, file: !350, line: 117)
!402 = !DISubprogram(name: "strtoll", scope: !353, file: !353, line: 200, type: !403, flags: DIFlagPrototyped, spFlags: 0)
!403 = !DISubroutineType(types: !404)
!404 = !{!164, !385, !386, !21}
!405 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !406, file: !350, line: 119)
!406 = !DISubprogram(name: "strtoul", scope: !353, file: !353, line: 180, type: !407, flags: DIFlagPrototyped, spFlags: 0)
!407 = !DISubroutineType(types: !408)
!408 = !{!39, !385, !386, !21}
!409 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !410, file: !350, line: 121)
!410 = !DISubprogram(name: "strtoull", scope: !353, file: !353, line: 205, type: !411, flags: DIFlagPrototyped, spFlags: 0)
!411 = !DISubroutineType(types: !412)
!412 = !{!413, !385, !386, !21}
!413 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!414 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !415, file: !350, line: 123)
!415 = !DISubprogram(name: "rand", scope: !353, file: !353, line: 453, type: !416, flags: DIFlagPrototyped, spFlags: 0)
!416 = !DISubroutineType(types: !417)
!417 = !{!21}
!418 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !419, file: !350, line: 124)
!419 = !DISubprogram(name: "srand", scope: !353, file: !353, line: 455, type: !420, flags: DIFlagPrototyped, spFlags: 0)
!420 = !DISubroutineType(types: !421)
!421 = !{null, !422}
!422 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!423 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !424, file: !350, line: 125)
!424 = !DISubprogram(name: "calloc", scope: !353, file: !353, line: 541, type: !425, flags: DIFlagPrototyped, spFlags: 0)
!425 = !DISubroutineType(types: !426)
!426 = !{!427, !38, !38}
!427 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!428 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !429, file: !350, line: 126)
!429 = !DISubprogram(name: "free", scope: !353, file: !353, line: 563, type: !430, flags: DIFlagPrototyped, spFlags: 0)
!430 = !DISubroutineType(types: !431)
!431 = !{null, !427}
!432 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !433, file: !350, line: 127)
!433 = !DISubprogram(name: "malloc", scope: !353, file: !353, line: 539, type: !434, flags: DIFlagPrototyped, spFlags: 0)
!434 = !DISubroutineType(types: !435)
!435 = !{!427, !38}
!436 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !437, file: !350, line: 128)
!437 = !DISubprogram(name: "realloc", scope: !353, file: !353, line: 549, type: !438, flags: DIFlagPrototyped, spFlags: 0)
!438 = !DISubroutineType(types: !439)
!439 = !{!427, !427, !38}
!440 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !441, file: !350, line: 129)
!441 = !DISubprogram(name: "abort", scope: !353, file: !353, line: 588, type: !442, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!442 = !DISubroutineType(types: !443)
!443 = !{null}
!444 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !445, file: !350, line: 130)
!445 = !DISubprogram(name: "atexit", scope: !353, file: !353, line: 592, type: !446, flags: DIFlagPrototyped, spFlags: 0)
!446 = !DISubroutineType(types: !447)
!447 = !{!21, !448}
!448 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !442, size: 64)
!449 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !450, file: !350, line: 131)
!450 = !DISubprogram(name: "exit", scope: !353, file: !353, line: 614, type: !451, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!451 = !DISubroutineType(types: !452)
!452 = !{null, !21}
!453 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !454, file: !350, line: 132)
!454 = !DISubprogram(name: "_Exit", scope: !353, file: !353, line: 626, type: !451, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!455 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !456, file: !350, line: 134)
!456 = !DISubprogram(name: "getenv", scope: !353, file: !353, line: 631, type: !457, flags: DIFlagPrototyped, spFlags: 0)
!457 = !DISubroutineType(types: !458)
!458 = !{!388, !22}
!459 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !460, file: !350, line: 135)
!460 = !DISubprogram(name: "system", scope: !353, file: !353, line: 781, type: !371, flags: DIFlagPrototyped, spFlags: 0)
!461 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !462, file: !350, line: 137)
!462 = !DISubprogram(name: "bsearch", scope: !353, file: !353, line: 817, type: !463, flags: DIFlagPrototyped, spFlags: 0)
!463 = !DISubroutineType(types: !464)
!464 = !{!427, !465, !465, !38, !38, !467}
!465 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !466, size: 64)
!466 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!467 = !DIDerivedType(tag: DW_TAG_typedef, name: "__compar_fn_t", file: !353, line: 805, baseType: !468)
!468 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !469, size: 64)
!469 = !DISubroutineType(types: !470)
!470 = !{!21, !465, !465}
!471 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !472, file: !350, line: 138)
!472 = !DISubprogram(name: "qsort", scope: !353, file: !353, line: 827, type: !473, flags: DIFlagPrototyped, spFlags: 0)
!473 = !DISubroutineType(types: !474)
!474 = !{null, !427, !38, !38, !467}
!475 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !476, file: !350, line: 139)
!476 = !DISubprogram(name: "abs", linkageName: "_Z3absx", scope: !477, file: !477, line: 113, type: !478, flags: DIFlagPrototyped, spFlags: 0)
!477 = !DIFile(filename: "clang_llvm/build_dfsan_full/include/c++/v1/stdlib.h", directory: "/home/mcopik/projects")
!478 = !DISubroutineType(types: !479)
!479 = !{!164, !164}
!480 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !481, file: !350, line: 140)
!481 = !DISubprogram(name: "labs", scope: !353, file: !353, line: 838, type: !482, flags: DIFlagPrototyped, spFlags: 0)
!482 = !DISubroutineType(types: !483)
!483 = !{!35, !35}
!484 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !485, file: !350, line: 142)
!485 = !DISubprogram(name: "llabs", scope: !353, file: !353, line: 841, type: !478, flags: DIFlagPrototyped, spFlags: 0)
!486 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !487, file: !350, line: 144)
!487 = !DISubprogram(name: "div", linkageName: "_Z3divxx", scope: !477, file: !477, line: 118, type: !488, flags: DIFlagPrototyped, spFlags: 0)
!488 = !DISubroutineType(types: !489)
!489 = !{!362, !164, !164}
!490 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !491, file: !350, line: 145)
!491 = !DISubprogram(name: "ldiv", scope: !353, file: !353, line: 851, type: !492, flags: DIFlagPrototyped, spFlags: 0)
!492 = !DISubroutineType(types: !493)
!493 = !{!356, !35, !35}
!494 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !495, file: !350, line: 147)
!495 = !DISubprogram(name: "lldiv", scope: !353, file: !353, line: 855, type: !488, flags: DIFlagPrototyped, spFlags: 0)
!496 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !497, file: !350, line: 149)
!497 = !DISubprogram(name: "mblen", scope: !353, file: !353, line: 919, type: !498, flags: DIFlagPrototyped, spFlags: 0)
!498 = !DISubroutineType(types: !499)
!499 = !{!21, !22, !38}
!500 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !501, file: !350, line: 150)
!501 = !DISubprogram(name: "mbtowc", scope: !353, file: !353, line: 922, type: !502, flags: DIFlagPrototyped, spFlags: 0)
!502 = !DISubroutineType(types: !503)
!503 = !{!21, !504, !385, !38}
!504 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !505)
!505 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !506, size: 64)
!506 = !DIBasicType(name: "wchar_t", size: 32, encoding: DW_ATE_signed)
!507 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !508, file: !350, line: 151)
!508 = !DISubprogram(name: "wctomb", scope: !353, file: !353, line: 926, type: !509, flags: DIFlagPrototyped, spFlags: 0)
!509 = !DISubroutineType(types: !510)
!510 = !{!21, !388, !506}
!511 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !512, file: !350, line: 152)
!512 = !DISubprogram(name: "mbstowcs", scope: !353, file: !353, line: 930, type: !513, flags: DIFlagPrototyped, spFlags: 0)
!513 = !DISubroutineType(types: !514)
!514 = !{!38, !504, !385, !38}
!515 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !516, file: !350, line: 153)
!516 = !DISubprogram(name: "wcstombs", scope: !353, file: !353, line: 933, type: !517, flags: DIFlagPrototyped, spFlags: 0)
!517 = !DISubroutineType(types: !518)
!518 = !{!38, !519, !520, !38}
!519 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !388)
!520 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !521)
!521 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !522, size: 64)
!522 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !506)
!523 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !524, file: !350, line: 155)
!524 = !DISubprogram(name: "at_quick_exit", scope: !353, file: !353, line: 597, type: !446, flags: DIFlagPrototyped, spFlags: 0)
!525 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !31, entity: !526, file: !350, line: 156)
!526 = !DISubprogram(name: "quick_exit", scope: !353, file: !353, line: 620, type: !451, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!527 = !{i32 2, !"Dwarf Version", i32 4}
!528 = !{i32 2, !"Debug Info Version", i32 3}
!529 = !{i32 1, !"wchar_size", i32 4}
!530 = !{!"clang version 8.0.0 (git@github.com:llvm-mirror/clang.git fd01d8b9288b3558a597daeb0cb4481b37c5bf68) (git@github.com:llvm-mirror/LLVM.git 7135d8b482d3d0d1a8c50111eebb9b207e92a8bc)"}
!531 = distinct !DISubprogram(name: "h", linkageName: "_Z1hi", scope: !3, file: !3, line: 9, type: !532, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!532 = !DISubroutineType(types: !533)
!533 = !{!21, !21}
!534 = !DILocalVariable(name: "x", arg: 1, scope: !531, file: !3, line: 9, type: !21)
!535 = !DILocation(line: 9, column: 11, scope: !531)
!536 = !DILocalVariable(name: "tmp", scope: !531, file: !3, line: 11, type: !21)
!537 = !DILocation(line: 11, column: 9, scope: !531)
!538 = !DILocalVariable(name: "i", scope: !539, file: !3, line: 12, type: !21)
!539 = distinct !DILexicalBlock(scope: !531, file: !3, line: 12, column: 5)
!540 = !DILocation(line: 12, column: 13, scope: !539)
!541 = !DILocation(line: 12, column: 17, scope: !539)
!542 = !DILocation(line: 12, column: 9, scope: !539)
!543 = !DILocation(line: 12, column: 20, scope: !544)
!544 = distinct !DILexicalBlock(scope: !539, file: !3, line: 12, column: 5)
!545 = !DILocation(line: 12, column: 22, scope: !544)
!546 = !DILocation(line: 12, column: 5, scope: !539)
!547 = !DILocation(line: 13, column: 16, scope: !544)
!548 = !DILocation(line: 13, column: 13, scope: !544)
!549 = !DILocation(line: 13, column: 9, scope: !544)
!550 = !DILocation(line: 12, column: 29, scope: !544)
!551 = !DILocation(line: 12, column: 5, scope: !544)
!552 = distinct !{!552, !546, !553}
!553 = !DILocation(line: 13, column: 16, scope: !539)
!554 = !DILocation(line: 14, column: 18, scope: !531)
!555 = !DILocation(line: 14, column: 16, scope: !531)
!556 = !DILocation(line: 14, column: 12, scope: !531)
!557 = !DILocation(line: 14, column: 41, scope: !531)
!558 = !DILocation(line: 14, column: 24, scope: !531)
!559 = !DILocation(line: 14, column: 22, scope: !531)
!560 = !DILocation(line: 14, column: 5, scope: !531)
!561 = distinct !DISubprogram(name: "f", linkageName: "_Z1fii", scope: !3, file: !3, line: 17, type: !562, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!562 = !DISubroutineType(types: !563)
!563 = !{!21, !21, !21}
!564 = !DILocalVariable(name: "x", arg: 1, scope: !561, file: !3, line: 17, type: !21)
!565 = !DILocation(line: 17, column: 11, scope: !561)
!566 = !DILocalVariable(name: "y", arg: 2, scope: !561, file: !3, line: 17, type: !21)
!567 = !DILocation(line: 17, column: 18, scope: !561)
!568 = !DILocalVariable(name: "tmp", scope: !561, file: !3, line: 19, type: !21)
!569 = !DILocation(line: 19, column: 9, scope: !561)
!570 = !DILocalVariable(name: "i", scope: !571, file: !3, line: 20, type: !21)
!571 = distinct !DILexicalBlock(scope: !561, file: !3, line: 20, column: 5)
!572 = !DILocation(line: 20, column: 13, scope: !571)
!573 = !DILocation(line: 20, column: 17, scope: !571)
!574 = !DILocation(line: 20, column: 9, scope: !571)
!575 = !DILocation(line: 20, column: 20, scope: !576)
!576 = distinct !DILexicalBlock(scope: !571, file: !3, line: 20, column: 5)
!577 = !DILocation(line: 20, column: 24, scope: !576)
!578 = !DILocation(line: 20, column: 22, scope: !576)
!579 = !DILocation(line: 20, column: 5, scope: !571)
!580 = !DILocation(line: 21, column: 16, scope: !576)
!581 = !DILocation(line: 21, column: 13, scope: !576)
!582 = !DILocation(line: 21, column: 9, scope: !576)
!583 = !DILocation(line: 20, column: 27, scope: !576)
!584 = !DILocation(line: 20, column: 5, scope: !576)
!585 = distinct !{!585, !579, !586}
!586 = !DILocation(line: 21, column: 16, scope: !571)
!587 = !DILocation(line: 22, column: 15, scope: !561)
!588 = !DILocation(line: 22, column: 14, scope: !561)
!589 = !DILocation(line: 22, column: 21, scope: !561)
!590 = !DILocation(line: 22, column: 22, scope: !561)
!591 = !DILocation(line: 22, column: 19, scope: !561)
!592 = !DILocation(line: 22, column: 17, scope: !561)
!593 = !DILocation(line: 22, column: 28, scope: !561)
!594 = !DILocation(line: 22, column: 26, scope: !561)
!595 = !DILocation(line: 22, column: 5, scope: !561)
!596 = distinct !DISubprogram(name: "g", linkageName: "_Z1gi", scope: !3, file: !3, line: 25, type: !532, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!597 = !DILocalVariable(name: "x", arg: 1, scope: !596, file: !3, line: 25, type: !21)
!598 = !DILocation(line: 25, column: 11, scope: !596)
!599 = !DILocalVariable(name: "tmp", scope: !596, file: !3, line: 27, type: !21)
!600 = !DILocation(line: 27, column: 9, scope: !596)
!601 = !DILocalVariable(name: "i", scope: !602, file: !3, line: 28, type: !21)
!602 = distinct !DILexicalBlock(scope: !596, file: !3, line: 28, column: 5)
!603 = !DILocation(line: 28, column: 13, scope: !602)
!604 = !DILocation(line: 28, column: 17, scope: !602)
!605 = !DILocation(line: 28, column: 9, scope: !602)
!606 = !DILocation(line: 28, column: 20, scope: !607)
!607 = distinct !DILexicalBlock(scope: !602, file: !3, line: 28, column: 5)
!608 = !DILocation(line: 28, column: 24, scope: !607)
!609 = !DILocation(line: 28, column: 22, scope: !607)
!610 = !DILocation(line: 28, column: 5, scope: !602)
!611 = !DILocation(line: 29, column: 16, scope: !607)
!612 = !DILocation(line: 29, column: 13, scope: !607)
!613 = !DILocation(line: 29, column: 9, scope: !607)
!614 = !DILocation(line: 28, column: 32, scope: !607)
!615 = !DILocation(line: 28, column: 5, scope: !607)
!616 = distinct !{!616, !610, !617}
!617 = !DILocation(line: 29, column: 16, scope: !602)
!618 = !DILocation(line: 30, column: 20, scope: !596)
!619 = !DILocation(line: 30, column: 18, scope: !596)
!620 = !DILocation(line: 30, column: 24, scope: !596)
!621 = !DILocation(line: 30, column: 22, scope: !596)
!622 = !DILocation(line: 30, column: 14, scope: !596)
!623 = !DILocation(line: 30, column: 47, scope: !596)
!624 = !DILocation(line: 30, column: 30, scope: !596)
!625 = !DILocation(line: 30, column: 28, scope: !596)
!626 = !DILocation(line: 30, column: 12, scope: !596)
!627 = !DILocation(line: 30, column: 5, scope: !596)
!628 = distinct !DISubprogram(name: "i", linkageName: "_Z1iiii", scope: !3, file: !3, line: 33, type: !629, scopeLine: 34, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!629 = !DISubroutineType(types: !630)
!630 = !{!21, !21, !21, !21}
!631 = !DILocalVariable(name: "x1", arg: 1, scope: !628, file: !3, line: 33, type: !21)
!632 = !DILocation(line: 33, column: 11, scope: !628)
!633 = !DILocalVariable(name: "x2", arg: 2, scope: !628, file: !3, line: 33, type: !21)
!634 = !DILocation(line: 33, column: 19, scope: !628)
!635 = !DILocalVariable(name: "x3", arg: 3, scope: !628, file: !3, line: 33, type: !21)
!636 = !DILocation(line: 33, column: 27, scope: !628)
!637 = !DILocalVariable(name: "tmp", scope: !628, file: !3, line: 35, type: !21)
!638 = !DILocation(line: 35, column: 9, scope: !628)
!639 = !DILocalVariable(name: "i", scope: !640, file: !3, line: 36, type: !21)
!640 = distinct !DILexicalBlock(scope: !628, file: !3, line: 36, column: 5)
!641 = !DILocation(line: 36, column: 13, scope: !640)
!642 = !DILocation(line: 36, column: 17, scope: !640)
!643 = !DILocation(line: 36, column: 9, scope: !640)
!644 = !DILocation(line: 36, column: 21, scope: !645)
!645 = distinct !DILexicalBlock(scope: !640, file: !3, line: 36, column: 5)
!646 = !DILocation(line: 36, column: 25, scope: !645)
!647 = !DILocation(line: 36, column: 28, scope: !645)
!648 = !DILocation(line: 36, column: 23, scope: !645)
!649 = !DILocation(line: 36, column: 5, scope: !640)
!650 = !DILocation(line: 37, column: 16, scope: !645)
!651 = !DILocation(line: 37, column: 17, scope: !645)
!652 = !DILocation(line: 37, column: 13, scope: !645)
!653 = !DILocation(line: 37, column: 9, scope: !645)
!654 = !DILocation(line: 36, column: 38, scope: !645)
!655 = !DILocation(line: 36, column: 35, scope: !645)
!656 = !DILocation(line: 36, column: 5, scope: !645)
!657 = distinct !{!657, !649, !658}
!658 = !DILocation(line: 37, column: 18, scope: !640)
!659 = !DILocation(line: 38, column: 14, scope: !628)
!660 = !DILocation(line: 38, column: 22, scope: !628)
!661 = !DILocation(line: 38, column: 12, scope: !628)
!662 = !DILocation(line: 38, column: 28, scope: !628)
!663 = !DILocation(line: 38, column: 26, scope: !628)
!664 = !DILocation(line: 38, column: 33, scope: !628)
!665 = !DILocation(line: 38, column: 31, scope: !628)
!666 = !DILocation(line: 38, column: 38, scope: !628)
!667 = !DILocation(line: 38, column: 36, scope: !628)
!668 = !DILocation(line: 38, column: 46, scope: !628)
!669 = !DILocation(line: 38, column: 44, scope: !628)
!670 = !DILocation(line: 38, column: 52, scope: !628)
!671 = !DILocation(line: 38, column: 50, scope: !628)
!672 = !DILocation(line: 38, column: 42, scope: !628)
!673 = !DILocation(line: 38, column: 5, scope: !628)
!674 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 41, type: !675, scopeLine: 42, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!675 = !DISubroutineType(types: !676)
!676 = !{!21, !21, !387}
!677 = !DILocalVariable(name: "argc", arg: 1, scope: !674, file: !3, line: 41, type: !21)
!678 = !DILocation(line: 41, column: 14, scope: !674)
!679 = !DILocalVariable(name: "argv", arg: 2, scope: !674, file: !3, line: 41, type: !387)
!680 = !DILocation(line: 41, column: 28, scope: !674)
!681 = !DILocalVariable(name: "x1", scope: !674, file: !3, line: 43, type: !21)
!682 = !DILocation(line: 43, column: 9, scope: !674)
!683 = !DILocation(line: 43, column: 5, scope: !674)
!684 = !DILocation(line: 43, column: 26, scope: !674)
!685 = !DILocation(line: 43, column: 21, scope: !674)
!686 = !DILocalVariable(name: "x2", scope: !674, file: !3, line: 44, type: !21)
!687 = !DILocation(line: 44, column: 9, scope: !674)
!688 = !DILocation(line: 44, column: 5, scope: !674)
!689 = !DILocation(line: 44, column: 25, scope: !674)
!690 = !DILocation(line: 44, column: 20, scope: !674)
!691 = !DILocation(line: 45, column: 5, scope: !674)
!692 = !DILocation(line: 46, column: 5, scope: !674)
!693 = !DILocation(line: 47, column: 5, scope: !674)
!694 = !DILocalVariable(name: "y", scope: !674, file: !3, line: 48, type: !21)
!695 = !DILocation(line: 48, column: 9, scope: !674)
!696 = !DILocation(line: 48, column: 15, scope: !674)
!697 = !DILocation(line: 48, column: 14, scope: !674)
!698 = !DILocation(line: 48, column: 18, scope: !674)
!699 = !DILocation(line: 51, column: 7, scope: !674)
!700 = !DILocation(line: 51, column: 15, scope: !674)
!701 = !DILocation(line: 51, column: 5, scope: !674)
!702 = !DILocation(line: 52, column: 7, scope: !674)
!703 = !DILocation(line: 52, column: 5, scope: !674)
!704 = !DILocation(line: 54, column: 5, scope: !674)
!705 = !DILocation(line: 56, column: 7, scope: !674)
!706 = !DILocation(line: 56, column: 5, scope: !674)
!707 = !DILocation(line: 57, column: 5, scope: !674)
!708 = !DILocation(line: 59, column: 7, scope: !674)
!709 = !DILocation(line: 59, column: 11, scope: !674)
!710 = !DILocation(line: 59, column: 18, scope: !674)
!711 = !DILocation(line: 59, column: 17, scope: !674)
!712 = !DILocation(line: 59, column: 5, scope: !674)
!713 = !DILocation(line: 61, column: 5, scope: !674)
!714 = !DILocalVariable(name: "ptr", arg: 1, scope: !16, file: !17, line: 11, type: !20)
!715 = !DILocation(line: 11, column: 28, scope: !16)
!716 = !DILocalVariable(name: "name", arg: 2, scope: !16, file: !17, line: 11, type: !22)
!717 = !DILocation(line: 11, column: 46, scope: !16)
!718 = !DILocation(line: 14, column: 57, scope: !16)
!719 = !DILocation(line: 14, column: 31, scope: !16)
!720 = !DILocation(line: 14, column: 82, scope: !16)
!721 = !DILocation(line: 14, column: 86, scope: !16)
!722 = !DILocation(line: 14, column: 5, scope: !16)
!723 = !DILocation(line: 15, column: 1, scope: !16)
