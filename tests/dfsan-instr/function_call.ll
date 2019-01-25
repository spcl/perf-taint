; RUN: opt %dfsan -S < %s 2> /dev/null | llc %llcparams - -o %t1 && clang++ %link %t1 -o %t2 && %execparams %t2 10 10 | diff -w %s.json -
; RUN: %jsonconvert %s.json | diff -w %s.processed.json -
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

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @_Z1fii(i32, i32) #0 !dbg !592 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  call void @llvm.dbg.declare(metadata i32* %3, metadata !595, metadata !DIExpression()), !dbg !596
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !597, metadata !DIExpression()), !dbg !598
  call void @llvm.dbg.declare(metadata i32* %5, metadata !599, metadata !DIExpression()), !dbg !600
  store i32 0, i32* %5, align 4, !dbg !600
  call void @llvm.dbg.declare(metadata i32* %6, metadata !601, metadata !DIExpression()), !dbg !603
  %7 = load i32, i32* %3, align 4, !dbg !604
  store i32 %7, i32* %6, align 4, !dbg !603
  br label %8, !dbg !605

; <label>:8:                                      ; preds = %16, %2
  %9 = load i32, i32* %6, align 4, !dbg !606
  %10 = load i32, i32* %4, align 4, !dbg !608
  %11 = icmp slt i32 %9, %10, !dbg !609
  br i1 %11, label %12, label %19, !dbg !610

; <label>:12:                                     ; preds = %8
  %13 = load i32, i32* %6, align 4, !dbg !611
  %14 = load i32, i32* %5, align 4, !dbg !612
  %15 = add nsw i32 %14, %13, !dbg !612
  store i32 %15, i32* %5, align 4, !dbg !612
  br label %16, !dbg !613

; <label>:16:                                     ; preds = %12
  %17 = load i32, i32* %6, align 4, !dbg !614
  %18 = add nsw i32 %17, 1, !dbg !614
  store i32 %18, i32* %6, align 4, !dbg !614
  br label %8, !dbg !615, !llvm.loop !616

; <label>:19:                                     ; preds = %8
  %20 = load i32, i32* %5, align 4, !dbg !618
  %21 = mul nsw i32 %20, 10, !dbg !619
  %22 = load i32, i32* %3, align 4, !dbg !620
  %23 = mul nsw i32 %21, %22, !dbg !621
  %24 = load i32, i32* %4, align 4, !dbg !622
  %25 = sdiv i32 %24, 2, !dbg !623
  %26 = add nsw i32 %23, %25, !dbg !624
  ret i32 %26, !dbg !625
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @_Z1hi(i32) #0 !dbg !626 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !629, metadata !DIExpression()), !dbg !630
  call void @llvm.dbg.declare(metadata i32* %3, metadata !631, metadata !DIExpression()), !dbg !632
  store i32 0, i32* %3, align 4, !dbg !632
  call void @llvm.dbg.declare(metadata i32* %4, metadata !633, metadata !DIExpression()), !dbg !635
  %5 = load i32, i32* %2, align 4, !dbg !636
  store i32 %5, i32* %4, align 4, !dbg !635
  br label %6, !dbg !637

; <label>:6:                                      ; preds = %13, %1
  %7 = load i32, i32* %4, align 4, !dbg !638
  %8 = icmp slt i32 %7, 100, !dbg !640
  br i1 %8, label %9, label %16, !dbg !641

; <label>:9:                                      ; preds = %6
  %10 = load i32, i32* %4, align 4, !dbg !642
  %11 = load i32, i32* %3, align 4, !dbg !643
  %12 = add nsw i32 %11, %10, !dbg !643
  store i32 %12, i32* %3, align 4, !dbg !643
  br label %13, !dbg !644

; <label>:13:                                     ; preds = %9
  %14 = load i32, i32* %4, align 4, !dbg !645
  %15 = add nsw i32 %14, 1, !dbg !645
  store i32 %15, i32* %4, align 4, !dbg !645
  br label %6, !dbg !646, !llvm.loop !647

; <label>:16:                                     ; preds = %6
  %17 = load i32, i32* %2, align 4, !dbg !649
  %18 = mul nsw i32 100, %17, !dbg !650
  %19 = sitofp i32 %18 to double, !dbg !651
  %20 = load i32, i32* %2, align 4, !dbg !652
  %21 = sitofp i32 %20 to double, !dbg !652
  %22 = call double @log(double %21) #4, !dbg !653
  %23 = fmul double %19, %22, !dbg !654
  %24 = fptosi double %23 to i32, !dbg !651
  ret i32 %24, !dbg !655
}

; Function Attrs: nounwind
declare dso_local double @log(double) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @_Z1gi(i32) #0 !dbg !656 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4
  call void @llvm.dbg.declare(metadata i32* %2, metadata !657, metadata !DIExpression()), !dbg !658
  %3 = load i32, i32* @global, align 4, !dbg !659
  %4 = icmp ne i32 %3, 0, !dbg !659
  br i1 %4, label %5, label %15, !dbg !659

; <label>:5:                                      ; preds = %1
  %6 = load i32, i32* %2, align 4, !dbg !660
  %7 = add nsw i32 100, %6, !dbg !661
  %8 = sitofp i32 %7 to double, !dbg !662
  %9 = load i32, i32* @global, align 4, !dbg !663
  %10 = sitofp i32 %9 to double, !dbg !663
  %11 = call double @pow(double %10, double 3.000000e+00) #4, !dbg !664
  %12 = fadd double %8, %11, !dbg !665
  %13 = fptosi double %12 to i32, !dbg !662
  %14 = call i32 @_Z1hi(i32 %13), !dbg !666
  br label %16, !dbg !659

; <label>:15:                                     ; preds = %1
  br label %16, !dbg !659

; <label>:16:                                     ; preds = %15, %5
  %17 = phi i32 [ %14, %5 ], [ 1, %15 ], !dbg !659
  ret i32 %17, !dbg !667
}

; Function Attrs: nounwind
declare dso_local double @pow(double, double) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @_Z1iiii(i32, i32, i32) #0 !dbg !668 {
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store i32 %0, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !671, metadata !DIExpression()), !dbg !672
  store i32 %1, i32* %5, align 4
  call void @llvm.dbg.declare(metadata i32* %5, metadata !673, metadata !DIExpression()), !dbg !674
  store i32 %2, i32* %6, align 4
  call void @llvm.dbg.declare(metadata i32* %6, metadata !675, metadata !DIExpression()), !dbg !676
  call void @llvm.dbg.declare(metadata i32* %7, metadata !677, metadata !DIExpression()), !dbg !678
  store i32 0, i32* %7, align 4, !dbg !678
  call void @llvm.dbg.declare(metadata i32* %8, metadata !679, metadata !DIExpression()), !dbg !681
  %9 = load i32, i32* %4, align 4, !dbg !682
  store i32 %9, i32* %8, align 4, !dbg !681
  br label %10, !dbg !683

; <label>:10:                                     ; preds = %22, %3
  %11 = load i32, i32* %8, align 4, !dbg !684
  %12 = load i32, i32* %5, align 4, !dbg !686
  %13 = icmp slt i32 %11, %12, !dbg !687
  br i1 %13, label %14, label %26, !dbg !688

; <label>:14:                                     ; preds = %10
  %15 = load i32, i32* %8, align 4, !dbg !689
  %16 = sitofp i32 %15 to double, !dbg !689
  %17 = fmul double %16, 1.100000e+00, !dbg !690
  %18 = load i32, i32* %7, align 4, !dbg !691
  %19 = sitofp i32 %18 to double, !dbg !691
  %20 = fadd double %19, %17, !dbg !691
  %21 = fptosi double %20 to i32, !dbg !691
  store i32 %21, i32* %7, align 4, !dbg !691
  br label %22, !dbg !692

; <label>:22:                                     ; preds = %14
  %23 = load i32, i32* %6, align 4, !dbg !693
  %24 = load i32, i32* %8, align 4, !dbg !694
  %25 = add nsw i32 %24, %23, !dbg !694
  store i32 %25, i32* %8, align 4, !dbg !694
  br label %10, !dbg !695, !llvm.loop !696

; <label>:26:                                     ; preds = %10
  %27 = load i32, i32* %4, align 4, !dbg !698
  %28 = mul nsw i32 100, %27, !dbg !699
  %29 = load i32, i32* %5, align 4, !dbg !700
  %30 = mul nsw i32 %28, %29, !dbg !701
  %31 = load i32, i32* %6, align 4, !dbg !702
  %32 = mul nsw i32 %31, 2, !dbg !703
  %33 = add nsw i32 %30, %32, !dbg !704
  ret i32 %33, !dbg !705
}

; Function Attrs: noinline norecurse optnone uwtable
define dso_local i32 @main(i32, i8**) #3 !dbg !706 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !709, metadata !DIExpression()), !dbg !710
  store i8** %1, i8*** %5, align 8
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !711, metadata !DIExpression()), !dbg !712
  call void @llvm.dbg.declare(metadata i32* %6, metadata !713, metadata !DIExpression()), !dbg !714
  %9 = bitcast i32* %6 to i8*, !dbg !715
  call void @llvm.var.annotation(i8* %9, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([36 x i8], [36 x i8]* @.str.1, i32 0, i32 0), i32 39), !dbg !715
  %10 = load i8**, i8*** %5, align 8, !dbg !716
  %11 = getelementptr inbounds i8*, i8** %10, i64 1, !dbg !716
  %12 = load i8*, i8** %11, align 8, !dbg !716
  %13 = call i32 @atoi(i8* %12) #8, !dbg !717
  store i32 %13, i32* %6, align 4, !dbg !714
  call void @llvm.dbg.declare(metadata i32* %7, metadata !718, metadata !DIExpression()), !dbg !719
  %14 = bitcast i32* %7 to i8*, !dbg !720
  call void @llvm.var.annotation(i8* %14, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([36 x i8], [36 x i8]* @.str.1, i32 0, i32 0), i32 40), !dbg !720
  %15 = load i8**, i8*** %5, align 8, !dbg !721
  %16 = getelementptr inbounds i8*, i8** %15, i64 2, !dbg !721
  %17 = load i8*, i8** %16, align 8, !dbg !721
  %18 = call i32 @atoi(i8* %17) #8, !dbg !722
  store i32 %18, i32* %7, align 4, !dbg !719
  call void @_Z17register_variableIiEvPT_PKc(i32* %6, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.2, i32 0, i32 0)), !dbg !723
  call void @_Z17register_variableIiEvPT_PKc(i32* %7, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.3, i32 0, i32 0)), !dbg !724
  call void @_Z17register_variableIiEvPT_PKc(i32* @global, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.4, i32 0, i32 0)), !dbg !725
  call void @llvm.dbg.declare(metadata i32* %8, metadata !726, metadata !DIExpression()), !dbg !727
  %19 = load i32, i32* %6, align 4, !dbg !728
  %20 = mul nsw i32 2, %19, !dbg !729
  %21 = add nsw i32 %20, 1, !dbg !730
  store i32 %21, i32* %8, align 4, !dbg !727
  %22 = load i32, i32* @global, align 4, !dbg !731
  %23 = load i32, i32* %6, align 4, !dbg !732
  %24 = call i32 @_Z1fii(i32 %22, i32 %23), !dbg !733
  %25 = call i32 @_Z1gi(i32 100), !dbg !734
  %26 = load i32, i32* %7, align 4, !dbg !735
  %27 = call i32 @_Z1hi(i32 %26), !dbg !736
  %28 = call i32 @_Z1hi(i32 100), !dbg !737
  %29 = load i32, i32* %8, align 4, !dbg !738
  %30 = load i32, i32* %7, align 4, !dbg !739
  %31 = add nsw i32 %29, %30, !dbg !740
  %32 = load i32, i32* %6, align 4, !dbg !741
  %33 = call i32 @_Z1iiii(i32 %31, i32 %32, i32 15), !dbg !742
  ret i32 0, !dbg !743
}

; Function Attrs: nounwind
declare void @llvm.var.annotation(i8*, i8*, i8*, i32) #4

; Function Attrs: nounwind readonly
declare dso_local i32 @atoi(i8*) #5

; Function Attrs: noinline optnone uwtable
define linkonce_odr dso_local void @_Z17register_variableIiEvPT_PKc(i32*, i8*) #6 comdat !dbg !744 {
  %3 = alloca i32*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca i32, align 4
  store i32* %0, i32** %3, align 8
  call void @llvm.dbg.declare(metadata i32** %3, metadata !750, metadata !DIExpression()), !dbg !751
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !752, metadata !DIExpression()), !dbg !753
  call void @llvm.dbg.declare(metadata i32* %5, metadata !754, metadata !DIExpression()), !dbg !755
  %6 = call i32 @__dfsw_EXTRAP_VAR_ID(), !dbg !756
  store i32 %6, i32* %5, align 4, !dbg !755
  %7 = load i32*, i32** %3, align 8, !dbg !757
  %8 = bitcast i32* %7 to i8*, !dbg !758
  %9 = load i32, i32* %5, align 4, !dbg !759
  %10 = add nsw i32 %9, 1, !dbg !759
  store i32 %10, i32* %5, align 4, !dbg !759
  %11 = load i8*, i8** %4, align 8, !dbg !760
  call void @__dfsw_EXTRAP_STORE_LABEL(i8* %8, i32 4, i32 %9, i8* %11), !dbg !761
  ret void, !dbg !762
}

declare dso_local i32 @__dfsw_EXTRAP_VAR_ID() #7

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
!llvm.module.flags = !{!588, !589, !590}
!llvm.ident = !{!591}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "global", scope: !2, file: !3, line: 6, type: !81, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !3, producer: "clang version 8.0.0 (git@github.com:llvm-mirror/clang.git fd01d8b9288b3558a597daeb0cb4481b37c5bf68) (git@github.com:llvm-mirror/LLVM.git 7135d8b482d3d0d1a8c50111eebb9b207e92a8bc)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !5, globals: !13, imports: !14, nameTableKind: None)
!3 = !DIFile(filename: "tests/dfsan-instr/function_call.cpp", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!4 = !{}
!5 = !{!6, !7}
!6 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!7 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !8, size: 64)
!8 = !DIDerivedType(tag: DW_TAG_typedef, name: "int8_t", file: !9, line: 24, baseType: !10)
!9 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-intn.h", directory: "")
!10 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int8_t", file: !11, line: 36, baseType: !12)
!11 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "")
!12 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!13 = !{!0}
!14 = !{!15, !22, !25, !29, !37, !39, !43, !45, !49, !54, !56, !58, !62, !64, !66, !68, !70, !72, !74, !76, !82, !86, !88, !90, !95, !100, !102, !104, !106, !108, !110, !112, !114, !116, !118, !120, !122, !124, !126, !128, !130, !132, !136, !138, !140, !142, !146, !148, !153, !155, !157, !159, !161, !165, !167, !174, !178, !180, !182, !186, !188, !192, !194, !196, !200, !202, !204, !206, !208, !210, !212, !216, !218, !220, !222, !224, !226, !228, !230, !234, !238, !240, !242, !244, !246, !248, !250, !252, !254, !256, !258, !260, !262, !264, !266, !268, !270, !272, !274, !276, !280, !282, !284, !286, !290, !292, !296, !298, !300, !302, !304, !308, !310, !314, !316, !318, !320, !322, !326, !328, !330, !334, !336, !338, !340, !342, !346, !352, !358, !360, !364, !368, !372, !380, !384, !388, !392, !396, !400, !405, !409, !414, !419, !423, !427, !431, !435, !440, !444, !446, !450, !452, !462, !466, !471, !475, !477, !481, !485, !487, !491, !498, !502, !506, !514, !516, !518, !520, !524, !527, !530, !535, !539, !542, !545, !548, !550, !552, !554, !556, !558, !560, !562, !564, !566, !568, !570, !572, !574, !576, !578, !580, !582, !585}
!15 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !18, file: !21, line: 50)
!16 = !DINamespace(name: "__1", scope: !17, exportSymbols: true)
!17 = !DINamespace(name: "std", scope: null)
!18 = !DIDerivedType(tag: DW_TAG_typedef, name: "ptrdiff_t", file: !19, line: 51, baseType: !20)
!19 = !DIFile(filename: "clang_llvm/build_release/lib/clang/8.0.0/include/stddef.h", directory: "/home/mcopik/projects")
!20 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!21 = !DIFile(filename: "clang_llvm/build_dfsan_full/include/c++/v1/cstddef", directory: "/home/mcopik/projects")
!22 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !23, file: !21, line: 51)
!23 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !19, line: 62, baseType: !24)
!24 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!25 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !26, file: !21, line: 56)
!26 = !DIDerivedType(tag: DW_TAG_typedef, name: "max_align_t", file: !27, line: 40, baseType: !28)
!27 = !DIFile(filename: "clang_llvm/build_release/lib/clang/8.0.0/include/__stddef_max_align_t.h", directory: "/home/mcopik/projects")
!28 = !DICompositeType(tag: DW_TAG_structure_type, file: !27, line: 35, flags: DIFlagFwdDecl, identifier: "_ZTS11max_align_t")
!29 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !30, file: !36, line: 317)
!30 = !DISubprogram(name: "isinf", linkageName: "_Z5isinfe", scope: !31, file: !31, line: 497, type: !32, flags: DIFlagPrototyped, spFlags: 0)
!31 = !DIFile(filename: "clang_llvm/build_dfsan_full/include/c++/v1/math.h", directory: "/home/mcopik/projects")
!32 = !DISubroutineType(types: !33)
!33 = !{!34, !35}
!34 = !DIBasicType(name: "bool", size: 8, encoding: DW_ATE_boolean)
!35 = !DIBasicType(name: "long double", size: 128, encoding: DW_ATE_float)
!36 = !DIFile(filename: "clang_llvm/build_dfsan_full/include/c++/v1/cmath", directory: "/home/mcopik/projects")
!37 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !38, file: !36, line: 318)
!38 = !DISubprogram(name: "isnan", linkageName: "_Z5isnane", scope: !31, file: !31, line: 541, type: !32, flags: DIFlagPrototyped, spFlags: 0)
!39 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !40, file: !36, line: 328)
!40 = !DIDerivedType(tag: DW_TAG_typedef, name: "float_t", file: !41, line: 149, baseType: !42)
!41 = !DIFile(filename: "/usr/include/math.h", directory: "")
!42 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!43 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !44, file: !36, line: 329)
!44 = !DIDerivedType(tag: DW_TAG_typedef, name: "double_t", file: !41, line: 150, baseType: !6)
!45 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !46, file: !36, line: 332)
!46 = !DISubprogram(name: "abs", linkageName: "_Z3abse", scope: !31, file: !31, line: 769, type: !47, flags: DIFlagPrototyped, spFlags: 0)
!47 = !DISubroutineType(types: !48)
!48 = !{!35, !35}
!49 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !50, file: !36, line: 336)
!50 = !DISubprogram(name: "acosf", scope: !51, file: !51, line: 53, type: !52, flags: DIFlagPrototyped, spFlags: 0)
!51 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/mathcalls.h", directory: "")
!52 = !DISubroutineType(types: !53)
!53 = !{!42, !42}
!54 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !55, file: !36, line: 338)
!55 = !DISubprogram(name: "asinf", scope: !51, file: !51, line: 55, type: !52, flags: DIFlagPrototyped, spFlags: 0)
!56 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !57, file: !36, line: 340)
!57 = !DISubprogram(name: "atanf", scope: !51, file: !51, line: 57, type: !52, flags: DIFlagPrototyped, spFlags: 0)
!58 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !59, file: !36, line: 342)
!59 = !DISubprogram(name: "atan2f", scope: !51, file: !51, line: 59, type: !60, flags: DIFlagPrototyped, spFlags: 0)
!60 = !DISubroutineType(types: !61)
!61 = !{!42, !42, !42}
!62 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !63, file: !36, line: 344)
!63 = !DISubprogram(name: "ceilf", scope: !51, file: !51, line: 159, type: !52, flags: DIFlagPrototyped, spFlags: 0)
!64 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !65, file: !36, line: 346)
!65 = !DISubprogram(name: "cosf", scope: !51, file: !51, line: 62, type: !52, flags: DIFlagPrototyped, spFlags: 0)
!66 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !67, file: !36, line: 348)
!67 = !DISubprogram(name: "coshf", scope: !51, file: !51, line: 71, type: !52, flags: DIFlagPrototyped, spFlags: 0)
!68 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !69, file: !36, line: 351)
!69 = !DISubprogram(name: "expf", scope: !51, file: !51, line: 95, type: !52, flags: DIFlagPrototyped, spFlags: 0)
!70 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !71, file: !36, line: 354)
!71 = !DISubprogram(name: "fabsf", scope: !51, file: !51, line: 162, type: !52, flags: DIFlagPrototyped, spFlags: 0)
!72 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !73, file: !36, line: 356)
!73 = !DISubprogram(name: "floorf", scope: !51, file: !51, line: 165, type: !52, flags: DIFlagPrototyped, spFlags: 0)
!74 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !75, file: !36, line: 359)
!75 = !DISubprogram(name: "fmodf", scope: !51, file: !51, line: 168, type: !60, flags: DIFlagPrototyped, spFlags: 0)
!76 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !77, file: !36, line: 362)
!77 = !DISubprogram(name: "frexpf", scope: !51, file: !51, line: 98, type: !78, flags: DIFlagPrototyped, spFlags: 0)
!78 = !DISubroutineType(types: !79)
!79 = !{!42, !42, !80}
!80 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !81, size: 64)
!81 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!82 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !83, file: !36, line: 364)
!83 = !DISubprogram(name: "ldexpf", scope: !51, file: !51, line: 101, type: !84, flags: DIFlagPrototyped, spFlags: 0)
!84 = !DISubroutineType(types: !85)
!85 = !{!42, !42, !81}
!86 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !87, file: !36, line: 367)
!87 = !DISubprogram(name: "logf", scope: !51, file: !51, line: 104, type: !52, flags: DIFlagPrototyped, spFlags: 0)
!88 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !89, file: !36, line: 370)
!89 = !DISubprogram(name: "log10f", scope: !51, file: !51, line: 107, type: !52, flags: DIFlagPrototyped, spFlags: 0)
!90 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !91, file: !36, line: 371)
!91 = !DISubprogram(name: "modf", linkageName: "_Z4modfePe", scope: !31, file: !31, line: 978, type: !92, flags: DIFlagPrototyped, spFlags: 0)
!92 = !DISubroutineType(types: !93)
!93 = !{!35, !35, !94}
!94 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !35, size: 64)
!95 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !96, file: !36, line: 372)
!96 = !DISubprogram(name: "modff", scope: !51, file: !51, line: 110, type: !97, flags: DIFlagPrototyped, spFlags: 0)
!97 = !DISubroutineType(types: !98)
!98 = !{!42, !42, !99}
!99 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !42, size: 64)
!100 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !101, file: !36, line: 375)
!101 = !DISubprogram(name: "powf", scope: !51, file: !51, line: 140, type: !60, flags: DIFlagPrototyped, spFlags: 0)
!102 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !103, file: !36, line: 378)
!103 = !DISubprogram(name: "sinf", scope: !51, file: !51, line: 64, type: !52, flags: DIFlagPrototyped, spFlags: 0)
!104 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !105, file: !36, line: 380)
!105 = !DISubprogram(name: "sinhf", scope: !51, file: !51, line: 73, type: !52, flags: DIFlagPrototyped, spFlags: 0)
!106 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !107, file: !36, line: 383)
!107 = !DISubprogram(name: "sqrtf", scope: !51, file: !51, line: 143, type: !52, flags: DIFlagPrototyped, spFlags: 0)
!108 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !109, file: !36, line: 385)
!109 = !DISubprogram(name: "tanf", scope: !51, file: !51, line: 66, type: !52, flags: DIFlagPrototyped, spFlags: 0)
!110 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !111, file: !36, line: 388)
!111 = !DISubprogram(name: "tanhf", scope: !51, file: !51, line: 75, type: !52, flags: DIFlagPrototyped, spFlags: 0)
!112 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !113, file: !36, line: 391)
!113 = !DISubprogram(name: "acoshf", scope: !51, file: !51, line: 85, type: !52, flags: DIFlagPrototyped, spFlags: 0)
!114 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !115, file: !36, line: 393)
!115 = !DISubprogram(name: "asinhf", scope: !51, file: !51, line: 87, type: !52, flags: DIFlagPrototyped, spFlags: 0)
!116 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !117, file: !36, line: 395)
!117 = !DISubprogram(name: "atanhf", scope: !51, file: !51, line: 89, type: !52, flags: DIFlagPrototyped, spFlags: 0)
!118 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !119, file: !36, line: 397)
!119 = !DISubprogram(name: "cbrtf", scope: !51, file: !51, line: 152, type: !52, flags: DIFlagPrototyped, spFlags: 0)
!120 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !121, file: !36, line: 400)
!121 = !DISubprogram(name: "copysignf", scope: !51, file: !51, line: 196, type: !60, flags: DIFlagPrototyped, spFlags: 0)
!122 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !123, file: !36, line: 403)
!123 = !DISubprogram(name: "erff", scope: !51, file: !51, line: 228, type: !52, flags: DIFlagPrototyped, spFlags: 0)
!124 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !125, file: !36, line: 405)
!125 = !DISubprogram(name: "erfcf", scope: !51, file: !51, line: 229, type: !52, flags: DIFlagPrototyped, spFlags: 0)
!126 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !127, file: !36, line: 407)
!127 = !DISubprogram(name: "exp2f", scope: !51, file: !51, line: 130, type: !52, flags: DIFlagPrototyped, spFlags: 0)
!128 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !129, file: !36, line: 409)
!129 = !DISubprogram(name: "expm1f", scope: !51, file: !51, line: 119, type: !52, flags: DIFlagPrototyped, spFlags: 0)
!130 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !131, file: !36, line: 411)
!131 = !DISubprogram(name: "fdimf", scope: !51, file: !51, line: 326, type: !60, flags: DIFlagPrototyped, spFlags: 0)
!132 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !133, file: !36, line: 412)
!133 = !DISubprogram(name: "fmaf", scope: !51, file: !51, line: 335, type: !134, flags: DIFlagPrototyped, spFlags: 0)
!134 = !DISubroutineType(types: !135)
!135 = !{!42, !42, !42, !42}
!136 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !137, file: !36, line: 415)
!137 = !DISubprogram(name: "fmaxf", scope: !51, file: !51, line: 329, type: !60, flags: DIFlagPrototyped, spFlags: 0)
!138 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !139, file: !36, line: 417)
!139 = !DISubprogram(name: "fminf", scope: !51, file: !51, line: 332, type: !60, flags: DIFlagPrototyped, spFlags: 0)
!140 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !141, file: !36, line: 419)
!141 = !DISubprogram(name: "hypotf", scope: !51, file: !51, line: 147, type: !60, flags: DIFlagPrototyped, spFlags: 0)
!142 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !143, file: !36, line: 421)
!143 = !DISubprogram(name: "ilogbf", scope: !51, file: !51, line: 280, type: !144, flags: DIFlagPrototyped, spFlags: 0)
!144 = !DISubroutineType(types: !145)
!145 = !{!81, !42}
!146 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !147, file: !36, line: 423)
!147 = !DISubprogram(name: "lgammaf", scope: !51, file: !51, line: 230, type: !52, flags: DIFlagPrototyped, spFlags: 0)
!148 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !149, file: !36, line: 425)
!149 = !DISubprogram(name: "llrintf", scope: !51, file: !51, line: 316, type: !150, flags: DIFlagPrototyped, spFlags: 0)
!150 = !DISubroutineType(types: !151)
!151 = !{!152, !42}
!152 = !DIBasicType(name: "long long int", size: 64, encoding: DW_ATE_signed)
!153 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !154, file: !36, line: 427)
!154 = !DISubprogram(name: "llroundf", scope: !51, file: !51, line: 322, type: !150, flags: DIFlagPrototyped, spFlags: 0)
!155 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !156, file: !36, line: 429)
!156 = !DISubprogram(name: "log1pf", scope: !51, file: !51, line: 122, type: !52, flags: DIFlagPrototyped, spFlags: 0)
!157 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !158, file: !36, line: 431)
!158 = !DISubprogram(name: "log2f", scope: !51, file: !51, line: 133, type: !52, flags: DIFlagPrototyped, spFlags: 0)
!159 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !160, file: !36, line: 433)
!160 = !DISubprogram(name: "logbf", scope: !51, file: !51, line: 125, type: !52, flags: DIFlagPrototyped, spFlags: 0)
!161 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !162, file: !36, line: 435)
!162 = !DISubprogram(name: "lrintf", scope: !51, file: !51, line: 314, type: !163, flags: DIFlagPrototyped, spFlags: 0)
!163 = !DISubroutineType(types: !164)
!164 = !{!20, !42}
!165 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !166, file: !36, line: 437)
!166 = !DISubprogram(name: "lroundf", scope: !51, file: !51, line: 320, type: !163, flags: DIFlagPrototyped, spFlags: 0)
!167 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !168, file: !36, line: 439)
!168 = !DISubprogram(name: "nan", scope: !51, file: !51, line: 201, type: !169, flags: DIFlagPrototyped, spFlags: 0)
!169 = !DISubroutineType(types: !170)
!170 = !{!6, !171}
!171 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !172, size: 64)
!172 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !173)
!173 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!174 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !175, file: !36, line: 440)
!175 = !DISubprogram(name: "nanf", scope: !51, file: !51, line: 201, type: !176, flags: DIFlagPrototyped, spFlags: 0)
!176 = !DISubroutineType(types: !177)
!177 = !{!42, !171}
!178 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !179, file: !36, line: 443)
!179 = !DISubprogram(name: "nearbyintf", scope: !51, file: !51, line: 294, type: !52, flags: DIFlagPrototyped, spFlags: 0)
!180 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !181, file: !36, line: 445)
!181 = !DISubprogram(name: "nextafterf", scope: !51, file: !51, line: 259, type: !60, flags: DIFlagPrototyped, spFlags: 0)
!182 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !183, file: !36, line: 447)
!183 = !DISubprogram(name: "nexttowardf", scope: !51, file: !51, line: 261, type: !184, flags: DIFlagPrototyped, spFlags: 0)
!184 = !DISubroutineType(types: !185)
!185 = !{!42, !42, !35}
!186 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !187, file: !36, line: 449)
!187 = !DISubprogram(name: "remainderf", scope: !51, file: !51, line: 272, type: !60, flags: DIFlagPrototyped, spFlags: 0)
!188 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !189, file: !36, line: 451)
!189 = !DISubprogram(name: "remquof", scope: !51, file: !51, line: 307, type: !190, flags: DIFlagPrototyped, spFlags: 0)
!190 = !DISubroutineType(types: !191)
!191 = !{!42, !42, !42, !80}
!192 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !193, file: !36, line: 453)
!193 = !DISubprogram(name: "rintf", scope: !51, file: !51, line: 256, type: !52, flags: DIFlagPrototyped, spFlags: 0)
!194 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !195, file: !36, line: 455)
!195 = !DISubprogram(name: "roundf", scope: !51, file: !51, line: 298, type: !52, flags: DIFlagPrototyped, spFlags: 0)
!196 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !197, file: !36, line: 457)
!197 = !DISubprogram(name: "scalblnf", scope: !51, file: !51, line: 290, type: !198, flags: DIFlagPrototyped, spFlags: 0)
!198 = !DISubroutineType(types: !199)
!199 = !{!42, !42, !20}
!200 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !201, file: !36, line: 459)
!201 = !DISubprogram(name: "scalbnf", scope: !51, file: !51, line: 276, type: !84, flags: DIFlagPrototyped, spFlags: 0)
!202 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !203, file: !36, line: 461)
!203 = !DISubprogram(name: "tgammaf", scope: !51, file: !51, line: 235, type: !52, flags: DIFlagPrototyped, spFlags: 0)
!204 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !205, file: !36, line: 463)
!205 = !DISubprogram(name: "truncf", scope: !51, file: !51, line: 302, type: !52, flags: DIFlagPrototyped, spFlags: 0)
!206 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !207, file: !36, line: 465)
!207 = !DISubprogram(name: "acosl", scope: !51, file: !51, line: 53, type: !47, flags: DIFlagPrototyped, spFlags: 0)
!208 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !209, file: !36, line: 466)
!209 = !DISubprogram(name: "asinl", scope: !51, file: !51, line: 55, type: !47, flags: DIFlagPrototyped, spFlags: 0)
!210 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !211, file: !36, line: 467)
!211 = !DISubprogram(name: "atanl", scope: !51, file: !51, line: 57, type: !47, flags: DIFlagPrototyped, spFlags: 0)
!212 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !213, file: !36, line: 468)
!213 = !DISubprogram(name: "atan2l", scope: !51, file: !51, line: 59, type: !214, flags: DIFlagPrototyped, spFlags: 0)
!214 = !DISubroutineType(types: !215)
!215 = !{!35, !35, !35}
!216 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !217, file: !36, line: 469)
!217 = !DISubprogram(name: "ceill", scope: !51, file: !51, line: 159, type: !47, flags: DIFlagPrototyped, spFlags: 0)
!218 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !219, file: !36, line: 470)
!219 = !DISubprogram(name: "cosl", scope: !51, file: !51, line: 62, type: !47, flags: DIFlagPrototyped, spFlags: 0)
!220 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !221, file: !36, line: 471)
!221 = !DISubprogram(name: "coshl", scope: !51, file: !51, line: 71, type: !47, flags: DIFlagPrototyped, spFlags: 0)
!222 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !223, file: !36, line: 472)
!223 = !DISubprogram(name: "expl", scope: !51, file: !51, line: 95, type: !47, flags: DIFlagPrototyped, spFlags: 0)
!224 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !225, file: !36, line: 473)
!225 = !DISubprogram(name: "fabsl", scope: !51, file: !51, line: 162, type: !47, flags: DIFlagPrototyped, spFlags: 0)
!226 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !227, file: !36, line: 474)
!227 = !DISubprogram(name: "floorl", scope: !51, file: !51, line: 165, type: !47, flags: DIFlagPrototyped, spFlags: 0)
!228 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !229, file: !36, line: 475)
!229 = !DISubprogram(name: "fmodl", scope: !51, file: !51, line: 168, type: !214, flags: DIFlagPrototyped, spFlags: 0)
!230 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !231, file: !36, line: 476)
!231 = !DISubprogram(name: "frexpl", scope: !51, file: !51, line: 98, type: !232, flags: DIFlagPrototyped, spFlags: 0)
!232 = !DISubroutineType(types: !233)
!233 = !{!35, !35, !80}
!234 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !235, file: !36, line: 477)
!235 = !DISubprogram(name: "ldexpl", scope: !51, file: !51, line: 101, type: !236, flags: DIFlagPrototyped, spFlags: 0)
!236 = !DISubroutineType(types: !237)
!237 = !{!35, !35, !81}
!238 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !239, file: !36, line: 478)
!239 = !DISubprogram(name: "logl", scope: !51, file: !51, line: 104, type: !47, flags: DIFlagPrototyped, spFlags: 0)
!240 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !241, file: !36, line: 479)
!241 = !DISubprogram(name: "log10l", scope: !51, file: !51, line: 107, type: !47, flags: DIFlagPrototyped, spFlags: 0)
!242 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !243, file: !36, line: 480)
!243 = !DISubprogram(name: "modfl", scope: !51, file: !51, line: 110, type: !92, flags: DIFlagPrototyped, spFlags: 0)
!244 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !245, file: !36, line: 481)
!245 = !DISubprogram(name: "powl", scope: !51, file: !51, line: 140, type: !214, flags: DIFlagPrototyped, spFlags: 0)
!246 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !247, file: !36, line: 482)
!247 = !DISubprogram(name: "sinl", scope: !51, file: !51, line: 64, type: !47, flags: DIFlagPrototyped, spFlags: 0)
!248 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !249, file: !36, line: 483)
!249 = !DISubprogram(name: "sinhl", scope: !51, file: !51, line: 73, type: !47, flags: DIFlagPrototyped, spFlags: 0)
!250 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !251, file: !36, line: 484)
!251 = !DISubprogram(name: "sqrtl", scope: !51, file: !51, line: 143, type: !47, flags: DIFlagPrototyped, spFlags: 0)
!252 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !253, file: !36, line: 485)
!253 = !DISubprogram(name: "tanl", scope: !51, file: !51, line: 66, type: !47, flags: DIFlagPrototyped, spFlags: 0)
!254 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !255, file: !36, line: 487)
!255 = !DISubprogram(name: "tanhl", scope: !51, file: !51, line: 75, type: !47, flags: DIFlagPrototyped, spFlags: 0)
!256 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !257, file: !36, line: 488)
!257 = !DISubprogram(name: "acoshl", scope: !51, file: !51, line: 85, type: !47, flags: DIFlagPrototyped, spFlags: 0)
!258 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !259, file: !36, line: 489)
!259 = !DISubprogram(name: "asinhl", scope: !51, file: !51, line: 87, type: !47, flags: DIFlagPrototyped, spFlags: 0)
!260 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !261, file: !36, line: 490)
!261 = !DISubprogram(name: "atanhl", scope: !51, file: !51, line: 89, type: !47, flags: DIFlagPrototyped, spFlags: 0)
!262 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !263, file: !36, line: 491)
!263 = !DISubprogram(name: "cbrtl", scope: !51, file: !51, line: 152, type: !47, flags: DIFlagPrototyped, spFlags: 0)
!264 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !265, file: !36, line: 493)
!265 = !DISubprogram(name: "copysignl", scope: !51, file: !51, line: 196, type: !214, flags: DIFlagPrototyped, spFlags: 0)
!266 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !267, file: !36, line: 495)
!267 = !DISubprogram(name: "erfl", scope: !51, file: !51, line: 228, type: !47, flags: DIFlagPrototyped, spFlags: 0)
!268 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !269, file: !36, line: 496)
!269 = !DISubprogram(name: "erfcl", scope: !51, file: !51, line: 229, type: !47, flags: DIFlagPrototyped, spFlags: 0)
!270 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !271, file: !36, line: 497)
!271 = !DISubprogram(name: "exp2l", scope: !51, file: !51, line: 130, type: !47, flags: DIFlagPrototyped, spFlags: 0)
!272 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !273, file: !36, line: 498)
!273 = !DISubprogram(name: "expm1l", scope: !51, file: !51, line: 119, type: !47, flags: DIFlagPrototyped, spFlags: 0)
!274 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !275, file: !36, line: 499)
!275 = !DISubprogram(name: "fdiml", scope: !51, file: !51, line: 326, type: !214, flags: DIFlagPrototyped, spFlags: 0)
!276 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !277, file: !36, line: 500)
!277 = !DISubprogram(name: "fmal", scope: !51, file: !51, line: 335, type: !278, flags: DIFlagPrototyped, spFlags: 0)
!278 = !DISubroutineType(types: !279)
!279 = !{!35, !35, !35, !35}
!280 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !281, file: !36, line: 501)
!281 = !DISubprogram(name: "fmaxl", scope: !51, file: !51, line: 329, type: !214, flags: DIFlagPrototyped, spFlags: 0)
!282 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !283, file: !36, line: 502)
!283 = !DISubprogram(name: "fminl", scope: !51, file: !51, line: 332, type: !214, flags: DIFlagPrototyped, spFlags: 0)
!284 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !285, file: !36, line: 503)
!285 = !DISubprogram(name: "hypotl", scope: !51, file: !51, line: 147, type: !214, flags: DIFlagPrototyped, spFlags: 0)
!286 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !287, file: !36, line: 504)
!287 = !DISubprogram(name: "ilogbl", scope: !51, file: !51, line: 280, type: !288, flags: DIFlagPrototyped, spFlags: 0)
!288 = !DISubroutineType(types: !289)
!289 = !{!81, !35}
!290 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !291, file: !36, line: 505)
!291 = !DISubprogram(name: "lgammal", scope: !51, file: !51, line: 230, type: !47, flags: DIFlagPrototyped, spFlags: 0)
!292 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !293, file: !36, line: 506)
!293 = !DISubprogram(name: "llrintl", scope: !51, file: !51, line: 316, type: !294, flags: DIFlagPrototyped, spFlags: 0)
!294 = !DISubroutineType(types: !295)
!295 = !{!152, !35}
!296 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !297, file: !36, line: 507)
!297 = !DISubprogram(name: "llroundl", scope: !51, file: !51, line: 322, type: !294, flags: DIFlagPrototyped, spFlags: 0)
!298 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !299, file: !36, line: 508)
!299 = !DISubprogram(name: "log1pl", scope: !51, file: !51, line: 122, type: !47, flags: DIFlagPrototyped, spFlags: 0)
!300 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !301, file: !36, line: 509)
!301 = !DISubprogram(name: "log2l", scope: !51, file: !51, line: 133, type: !47, flags: DIFlagPrototyped, spFlags: 0)
!302 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !303, file: !36, line: 510)
!303 = !DISubprogram(name: "logbl", scope: !51, file: !51, line: 125, type: !47, flags: DIFlagPrototyped, spFlags: 0)
!304 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !305, file: !36, line: 511)
!305 = !DISubprogram(name: "lrintl", scope: !51, file: !51, line: 314, type: !306, flags: DIFlagPrototyped, spFlags: 0)
!306 = !DISubroutineType(types: !307)
!307 = !{!20, !35}
!308 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !309, file: !36, line: 512)
!309 = !DISubprogram(name: "lroundl", scope: !51, file: !51, line: 320, type: !306, flags: DIFlagPrototyped, spFlags: 0)
!310 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !311, file: !36, line: 513)
!311 = !DISubprogram(name: "nanl", scope: !51, file: !51, line: 201, type: !312, flags: DIFlagPrototyped, spFlags: 0)
!312 = !DISubroutineType(types: !313)
!313 = !{!35, !171}
!314 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !315, file: !36, line: 514)
!315 = !DISubprogram(name: "nearbyintl", scope: !51, file: !51, line: 294, type: !47, flags: DIFlagPrototyped, spFlags: 0)
!316 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !317, file: !36, line: 515)
!317 = !DISubprogram(name: "nextafterl", scope: !51, file: !51, line: 259, type: !214, flags: DIFlagPrototyped, spFlags: 0)
!318 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !319, file: !36, line: 516)
!319 = !DISubprogram(name: "nexttowardl", scope: !51, file: !51, line: 261, type: !214, flags: DIFlagPrototyped, spFlags: 0)
!320 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !321, file: !36, line: 517)
!321 = !DISubprogram(name: "remainderl", scope: !51, file: !51, line: 272, type: !214, flags: DIFlagPrototyped, spFlags: 0)
!322 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !323, file: !36, line: 518)
!323 = !DISubprogram(name: "remquol", scope: !51, file: !51, line: 307, type: !324, flags: DIFlagPrototyped, spFlags: 0)
!324 = !DISubroutineType(types: !325)
!325 = !{!35, !35, !35, !80}
!326 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !327, file: !36, line: 519)
!327 = !DISubprogram(name: "rintl", scope: !51, file: !51, line: 256, type: !47, flags: DIFlagPrototyped, spFlags: 0)
!328 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !329, file: !36, line: 520)
!329 = !DISubprogram(name: "roundl", scope: !51, file: !51, line: 298, type: !47, flags: DIFlagPrototyped, spFlags: 0)
!330 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !331, file: !36, line: 521)
!331 = !DISubprogram(name: "scalblnl", scope: !51, file: !51, line: 290, type: !332, flags: DIFlagPrototyped, spFlags: 0)
!332 = !DISubroutineType(types: !333)
!333 = !{!35, !35, !20}
!334 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !335, file: !36, line: 522)
!335 = !DISubprogram(name: "scalbnl", scope: !51, file: !51, line: 276, type: !236, flags: DIFlagPrototyped, spFlags: 0)
!336 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !337, file: !36, line: 523)
!337 = !DISubprogram(name: "tgammal", scope: !51, file: !51, line: 235, type: !47, flags: DIFlagPrototyped, spFlags: 0)
!338 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !339, file: !36, line: 524)
!339 = !DISubprogram(name: "truncl", scope: !51, file: !51, line: 302, type: !47, flags: DIFlagPrototyped, spFlags: 0)
!340 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !23, file: !341, line: 100)
!341 = !DIFile(filename: "clang_llvm/build_dfsan_full/include/c++/v1/cstdlib", directory: "/home/mcopik/projects")
!342 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !343, file: !341, line: 101)
!343 = !DIDerivedType(tag: DW_TAG_typedef, name: "div_t", file: !344, line: 62, baseType: !345)
!344 = !DIFile(filename: "/usr/include/stdlib.h", directory: "")
!345 = !DICompositeType(tag: DW_TAG_structure_type, file: !344, line: 58, flags: DIFlagFwdDecl, identifier: "_ZTS5div_t")
!346 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !347, file: !341, line: 102)
!347 = !DIDerivedType(tag: DW_TAG_typedef, name: "ldiv_t", file: !344, line: 70, baseType: !348)
!348 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !344, line: 66, size: 128, flags: DIFlagTypePassByValue | DIFlagTrivial, elements: !349, identifier: "_ZTS6ldiv_t")
!349 = !{!350, !351}
!350 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !348, file: !344, line: 68, baseType: !20, size: 64)
!351 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !348, file: !344, line: 69, baseType: !20, size: 64, offset: 64)
!352 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !353, file: !341, line: 104)
!353 = !DIDerivedType(tag: DW_TAG_typedef, name: "lldiv_t", file: !344, line: 80, baseType: !354)
!354 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !344, line: 76, size: 128, flags: DIFlagTypePassByValue | DIFlagTrivial, elements: !355, identifier: "_ZTS7lldiv_t")
!355 = !{!356, !357}
!356 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !354, file: !344, line: 78, baseType: !152, size: 64)
!357 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !354, file: !344, line: 79, baseType: !152, size: 64, offset: 64)
!358 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !359, file: !341, line: 106)
!359 = !DISubprogram(name: "atof", scope: !344, file: !344, line: 101, type: !169, flags: DIFlagPrototyped, spFlags: 0)
!360 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !361, file: !341, line: 107)
!361 = !DISubprogram(name: "atoi", scope: !344, file: !344, line: 104, type: !362, flags: DIFlagPrototyped, spFlags: 0)
!362 = !DISubroutineType(types: !363)
!363 = !{!81, !171}
!364 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !365, file: !341, line: 108)
!365 = !DISubprogram(name: "atol", scope: !344, file: !344, line: 107, type: !366, flags: DIFlagPrototyped, spFlags: 0)
!366 = !DISubroutineType(types: !367)
!367 = !{!20, !171}
!368 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !369, file: !341, line: 110)
!369 = !DISubprogram(name: "atoll", scope: !344, file: !344, line: 112, type: !370, flags: DIFlagPrototyped, spFlags: 0)
!370 = !DISubroutineType(types: !371)
!371 = !{!152, !171}
!372 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !373, file: !341, line: 112)
!373 = !DISubprogram(name: "strtod", scope: !344, file: !344, line: 117, type: !374, flags: DIFlagPrototyped, spFlags: 0)
!374 = !DISubroutineType(types: !375)
!375 = !{!6, !376, !377}
!376 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !171)
!377 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !378)
!378 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !379, size: 64)
!379 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !173, size: 64)
!380 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !381, file: !341, line: 113)
!381 = !DISubprogram(name: "strtof", scope: !344, file: !344, line: 123, type: !382, flags: DIFlagPrototyped, spFlags: 0)
!382 = !DISubroutineType(types: !383)
!383 = !{!42, !376, !377}
!384 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !385, file: !341, line: 114)
!385 = !DISubprogram(name: "strtold", scope: !344, file: !344, line: 126, type: !386, flags: DIFlagPrototyped, spFlags: 0)
!386 = !DISubroutineType(types: !387)
!387 = !{!35, !376, !377}
!388 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !389, file: !341, line: 115)
!389 = !DISubprogram(name: "strtol", scope: !344, file: !344, line: 176, type: !390, flags: DIFlagPrototyped, spFlags: 0)
!390 = !DISubroutineType(types: !391)
!391 = !{!20, !376, !377, !81}
!392 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !393, file: !341, line: 117)
!393 = !DISubprogram(name: "strtoll", scope: !344, file: !344, line: 200, type: !394, flags: DIFlagPrototyped, spFlags: 0)
!394 = !DISubroutineType(types: !395)
!395 = !{!152, !376, !377, !81}
!396 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !397, file: !341, line: 119)
!397 = !DISubprogram(name: "strtoul", scope: !344, file: !344, line: 180, type: !398, flags: DIFlagPrototyped, spFlags: 0)
!398 = !DISubroutineType(types: !399)
!399 = !{!24, !376, !377, !81}
!400 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !401, file: !341, line: 121)
!401 = !DISubprogram(name: "strtoull", scope: !344, file: !344, line: 205, type: !402, flags: DIFlagPrototyped, spFlags: 0)
!402 = !DISubroutineType(types: !403)
!403 = !{!404, !376, !377, !81}
!404 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!405 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !406, file: !341, line: 123)
!406 = !DISubprogram(name: "rand", scope: !344, file: !344, line: 453, type: !407, flags: DIFlagPrototyped, spFlags: 0)
!407 = !DISubroutineType(types: !408)
!408 = !{!81}
!409 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !410, file: !341, line: 124)
!410 = !DISubprogram(name: "srand", scope: !344, file: !344, line: 455, type: !411, flags: DIFlagPrototyped, spFlags: 0)
!411 = !DISubroutineType(types: !412)
!412 = !{null, !413}
!413 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!414 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !415, file: !341, line: 125)
!415 = !DISubprogram(name: "calloc", scope: !344, file: !344, line: 541, type: !416, flags: DIFlagPrototyped, spFlags: 0)
!416 = !DISubroutineType(types: !417)
!417 = !{!418, !23, !23}
!418 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!419 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !420, file: !341, line: 126)
!420 = !DISubprogram(name: "free", scope: !344, file: !344, line: 563, type: !421, flags: DIFlagPrototyped, spFlags: 0)
!421 = !DISubroutineType(types: !422)
!422 = !{null, !418}
!423 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !424, file: !341, line: 127)
!424 = !DISubprogram(name: "malloc", scope: !344, file: !344, line: 539, type: !425, flags: DIFlagPrototyped, spFlags: 0)
!425 = !DISubroutineType(types: !426)
!426 = !{!418, !23}
!427 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !428, file: !341, line: 128)
!428 = !DISubprogram(name: "realloc", scope: !344, file: !344, line: 549, type: !429, flags: DIFlagPrototyped, spFlags: 0)
!429 = !DISubroutineType(types: !430)
!430 = !{!418, !418, !23}
!431 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !432, file: !341, line: 129)
!432 = !DISubprogram(name: "abort", scope: !344, file: !344, line: 588, type: !433, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!433 = !DISubroutineType(types: !434)
!434 = !{null}
!435 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !436, file: !341, line: 130)
!436 = !DISubprogram(name: "atexit", scope: !344, file: !344, line: 592, type: !437, flags: DIFlagPrototyped, spFlags: 0)
!437 = !DISubroutineType(types: !438)
!438 = !{!81, !439}
!439 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !433, size: 64)
!440 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !441, file: !341, line: 131)
!441 = !DISubprogram(name: "exit", scope: !344, file: !344, line: 614, type: !442, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!442 = !DISubroutineType(types: !443)
!443 = !{null, !81}
!444 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !445, file: !341, line: 132)
!445 = !DISubprogram(name: "_Exit", scope: !344, file: !344, line: 626, type: !442, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!446 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !447, file: !341, line: 134)
!447 = !DISubprogram(name: "getenv", scope: !344, file: !344, line: 631, type: !448, flags: DIFlagPrototyped, spFlags: 0)
!448 = !DISubroutineType(types: !449)
!449 = !{!379, !171}
!450 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !451, file: !341, line: 135)
!451 = !DISubprogram(name: "system", scope: !344, file: !344, line: 781, type: !362, flags: DIFlagPrototyped, spFlags: 0)
!452 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !453, file: !341, line: 137)
!453 = !DISubprogram(name: "bsearch", scope: !344, file: !344, line: 817, type: !454, flags: DIFlagPrototyped, spFlags: 0)
!454 = !DISubroutineType(types: !455)
!455 = !{!418, !456, !456, !23, !23, !458}
!456 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !457, size: 64)
!457 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!458 = !DIDerivedType(tag: DW_TAG_typedef, name: "__compar_fn_t", file: !344, line: 805, baseType: !459)
!459 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !460, size: 64)
!460 = !DISubroutineType(types: !461)
!461 = !{!81, !456, !456}
!462 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !463, file: !341, line: 138)
!463 = !DISubprogram(name: "qsort", scope: !344, file: !344, line: 827, type: !464, flags: DIFlagPrototyped, spFlags: 0)
!464 = !DISubroutineType(types: !465)
!465 = !{null, !418, !23, !23, !458}
!466 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !467, file: !341, line: 139)
!467 = !DISubprogram(name: "abs", linkageName: "_Z3absx", scope: !468, file: !468, line: 113, type: !469, flags: DIFlagPrototyped, spFlags: 0)
!468 = !DIFile(filename: "clang_llvm/build_dfsan_full/include/c++/v1/stdlib.h", directory: "/home/mcopik/projects")
!469 = !DISubroutineType(types: !470)
!470 = !{!152, !152}
!471 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !472, file: !341, line: 140)
!472 = !DISubprogram(name: "labs", scope: !344, file: !344, line: 838, type: !473, flags: DIFlagPrototyped, spFlags: 0)
!473 = !DISubroutineType(types: !474)
!474 = !{!20, !20}
!475 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !476, file: !341, line: 142)
!476 = !DISubprogram(name: "llabs", scope: !344, file: !344, line: 841, type: !469, flags: DIFlagPrototyped, spFlags: 0)
!477 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !478, file: !341, line: 144)
!478 = !DISubprogram(name: "div", linkageName: "_Z3divxx", scope: !468, file: !468, line: 118, type: !479, flags: DIFlagPrototyped, spFlags: 0)
!479 = !DISubroutineType(types: !480)
!480 = !{!353, !152, !152}
!481 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !482, file: !341, line: 145)
!482 = !DISubprogram(name: "ldiv", scope: !344, file: !344, line: 851, type: !483, flags: DIFlagPrototyped, spFlags: 0)
!483 = !DISubroutineType(types: !484)
!484 = !{!347, !20, !20}
!485 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !486, file: !341, line: 147)
!486 = !DISubprogram(name: "lldiv", scope: !344, file: !344, line: 855, type: !479, flags: DIFlagPrototyped, spFlags: 0)
!487 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !488, file: !341, line: 149)
!488 = !DISubprogram(name: "mblen", scope: !344, file: !344, line: 919, type: !489, flags: DIFlagPrototyped, spFlags: 0)
!489 = !DISubroutineType(types: !490)
!490 = !{!81, !171, !23}
!491 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !492, file: !341, line: 150)
!492 = !DISubprogram(name: "mbtowc", scope: !344, file: !344, line: 922, type: !493, flags: DIFlagPrototyped, spFlags: 0)
!493 = !DISubroutineType(types: !494)
!494 = !{!81, !495, !376, !23}
!495 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !496)
!496 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !497, size: 64)
!497 = !DIBasicType(name: "wchar_t", size: 32, encoding: DW_ATE_signed)
!498 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !499, file: !341, line: 151)
!499 = !DISubprogram(name: "wctomb", scope: !344, file: !344, line: 926, type: !500, flags: DIFlagPrototyped, spFlags: 0)
!500 = !DISubroutineType(types: !501)
!501 = !{!81, !379, !497}
!502 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !503, file: !341, line: 152)
!503 = !DISubprogram(name: "mbstowcs", scope: !344, file: !344, line: 930, type: !504, flags: DIFlagPrototyped, spFlags: 0)
!504 = !DISubroutineType(types: !505)
!505 = !{!23, !495, !376, !23}
!506 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !507, file: !341, line: 153)
!507 = !DISubprogram(name: "wcstombs", scope: !344, file: !344, line: 933, type: !508, flags: DIFlagPrototyped, spFlags: 0)
!508 = !DISubroutineType(types: !509)
!509 = !{!23, !510, !511, !23}
!510 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !379)
!511 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !512)
!512 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !513, size: 64)
!513 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !497)
!514 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !515, file: !341, line: 155)
!515 = !DISubprogram(name: "at_quick_exit", scope: !344, file: !344, line: 597, type: !437, flags: DIFlagPrototyped, spFlags: 0)
!516 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !517, file: !341, line: 156)
!517 = !DISubprogram(name: "quick_exit", scope: !344, file: !344, line: 620, type: !442, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!518 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !8, file: !519, line: 153)
!519 = !DIFile(filename: "clang_llvm/build_dfsan_full/include/c++/v1/cstdint", directory: "/home/mcopik/projects")
!520 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !521, file: !519, line: 154)
!521 = !DIDerivedType(tag: DW_TAG_typedef, name: "int16_t", file: !9, line: 25, baseType: !522)
!522 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int16_t", file: !11, line: 38, baseType: !523)
!523 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!524 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !525, file: !519, line: 155)
!525 = !DIDerivedType(tag: DW_TAG_typedef, name: "int32_t", file: !9, line: 26, baseType: !526)
!526 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int32_t", file: !11, line: 40, baseType: !81)
!527 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !528, file: !519, line: 156)
!528 = !DIDerivedType(tag: DW_TAG_typedef, name: "int64_t", file: !9, line: 27, baseType: !529)
!529 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int64_t", file: !11, line: 43, baseType: !20)
!530 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !531, file: !519, line: 158)
!531 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint8_t", file: !532, line: 24, baseType: !533)
!532 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "")
!533 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint8_t", file: !11, line: 37, baseType: !534)
!534 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!535 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !536, file: !519, line: 159)
!536 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint16_t", file: !532, line: 25, baseType: !537)
!537 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint16_t", file: !11, line: 39, baseType: !538)
!538 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!539 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !540, file: !519, line: 160)
!540 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !532, line: 26, baseType: !541)
!541 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !11, line: 41, baseType: !413)
!542 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !543, file: !519, line: 161)
!543 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", file: !532, line: 27, baseType: !544)
!544 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint64_t", file: !11, line: 44, baseType: !24)
!545 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !546, file: !519, line: 163)
!546 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least8_t", file: !547, line: 43, baseType: !12)
!547 = !DIFile(filename: "/usr/include/stdint.h", directory: "")
!548 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !549, file: !519, line: 164)
!549 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least16_t", file: !547, line: 44, baseType: !523)
!550 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !551, file: !519, line: 165)
!551 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least32_t", file: !547, line: 45, baseType: !81)
!552 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !553, file: !519, line: 166)
!553 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least64_t", file: !547, line: 47, baseType: !20)
!554 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !555, file: !519, line: 168)
!555 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least8_t", file: !547, line: 54, baseType: !534)
!556 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !557, file: !519, line: 169)
!557 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least16_t", file: !547, line: 55, baseType: !538)
!558 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !559, file: !519, line: 170)
!559 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least32_t", file: !547, line: 56, baseType: !413)
!560 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !561, file: !519, line: 171)
!561 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least64_t", file: !547, line: 58, baseType: !24)
!562 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !563, file: !519, line: 173)
!563 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast8_t", file: !547, line: 68, baseType: !12)
!564 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !565, file: !519, line: 174)
!565 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast16_t", file: !547, line: 70, baseType: !20)
!566 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !567, file: !519, line: 175)
!567 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast32_t", file: !547, line: 71, baseType: !20)
!568 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !569, file: !519, line: 176)
!569 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast64_t", file: !547, line: 72, baseType: !20)
!570 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !571, file: !519, line: 178)
!571 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast8_t", file: !547, line: 81, baseType: !534)
!572 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !573, file: !519, line: 179)
!573 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast16_t", file: !547, line: 83, baseType: !24)
!574 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !575, file: !519, line: 180)
!575 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast32_t", file: !547, line: 84, baseType: !24)
!576 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !577, file: !519, line: 181)
!577 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast64_t", file: !547, line: 85, baseType: !24)
!578 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !579, file: !519, line: 183)
!579 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !547, line: 97, baseType: !20)
!580 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !581, file: !519, line: 184)
!581 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !547, line: 100, baseType: !24)
!582 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !583, file: !519, line: 186)
!583 = !DIDerivedType(tag: DW_TAG_typedef, name: "intmax_t", file: !547, line: 111, baseType: !584)
!584 = !DIDerivedType(tag: DW_TAG_typedef, name: "__intmax_t", file: !11, line: 61, baseType: !20)
!585 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !16, entity: !586, file: !519, line: 187)
!586 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintmax_t", file: !547, line: 112, baseType: !587)
!587 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uintmax_t", file: !11, line: 62, baseType: !24)
!588 = !{i32 2, !"Dwarf Version", i32 4}
!589 = !{i32 2, !"Debug Info Version", i32 3}
!590 = !{i32 1, !"wchar_size", i32 4}
!591 = !{!"clang version 8.0.0 (git@github.com:llvm-mirror/clang.git fd01d8b9288b3558a597daeb0cb4481b37c5bf68) (git@github.com:llvm-mirror/LLVM.git 7135d8b482d3d0d1a8c50111eebb9b207e92a8bc)"}
!592 = distinct !DISubprogram(name: "f", linkageName: "_Z1fii", scope: !3, file: !3, line: 8, type: !593, scopeLine: 9, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!593 = !DISubroutineType(types: !594)
!594 = !{!81, !81, !81}
!595 = !DILocalVariable(name: "x", arg: 1, scope: !592, file: !3, line: 8, type: !81)
!596 = !DILocation(line: 8, column: 11, scope: !592)
!597 = !DILocalVariable(name: "y", arg: 2, scope: !592, file: !3, line: 8, type: !81)
!598 = !DILocation(line: 8, column: 18, scope: !592)
!599 = !DILocalVariable(name: "tmp", scope: !592, file: !3, line: 10, type: !81)
!600 = !DILocation(line: 10, column: 9, scope: !592)
!601 = !DILocalVariable(name: "i", scope: !602, file: !3, line: 11, type: !81)
!602 = distinct !DILexicalBlock(scope: !592, file: !3, line: 11, column: 5)
!603 = !DILocation(line: 11, column: 13, scope: !602)
!604 = !DILocation(line: 11, column: 17, scope: !602)
!605 = !DILocation(line: 11, column: 9, scope: !602)
!606 = !DILocation(line: 11, column: 20, scope: !607)
!607 = distinct !DILexicalBlock(scope: !602, file: !3, line: 11, column: 5)
!608 = !DILocation(line: 11, column: 24, scope: !607)
!609 = !DILocation(line: 11, column: 22, scope: !607)
!610 = !DILocation(line: 11, column: 5, scope: !602)
!611 = !DILocation(line: 12, column: 16, scope: !607)
!612 = !DILocation(line: 12, column: 13, scope: !607)
!613 = !DILocation(line: 12, column: 9, scope: !607)
!614 = !DILocation(line: 11, column: 27, scope: !607)
!615 = !DILocation(line: 11, column: 5, scope: !607)
!616 = distinct !{!616, !610, !617}
!617 = !DILocation(line: 12, column: 16, scope: !602)
!618 = !DILocation(line: 13, column: 12, scope: !592)
!619 = !DILocation(line: 13, column: 15, scope: !592)
!620 = !DILocation(line: 13, column: 19, scope: !592)
!621 = !DILocation(line: 13, column: 18, scope: !592)
!622 = !DILocation(line: 13, column: 23, scope: !592)
!623 = !DILocation(line: 13, column: 24, scope: !592)
!624 = !DILocation(line: 13, column: 21, scope: !592)
!625 = !DILocation(line: 13, column: 5, scope: !592)
!626 = distinct !DISubprogram(name: "h", linkageName: "_Z1hi", scope: !3, file: !3, line: 16, type: !627, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!627 = !DISubroutineType(types: !628)
!628 = !{!81, !81}
!629 = !DILocalVariable(name: "x", arg: 1, scope: !626, file: !3, line: 16, type: !81)
!630 = !DILocation(line: 16, column: 11, scope: !626)
!631 = !DILocalVariable(name: "tmp", scope: !626, file: !3, line: 18, type: !81)
!632 = !DILocation(line: 18, column: 9, scope: !626)
!633 = !DILocalVariable(name: "i", scope: !634, file: !3, line: 19, type: !81)
!634 = distinct !DILexicalBlock(scope: !626, file: !3, line: 19, column: 5)
!635 = !DILocation(line: 19, column: 13, scope: !634)
!636 = !DILocation(line: 19, column: 17, scope: !634)
!637 = !DILocation(line: 19, column: 9, scope: !634)
!638 = !DILocation(line: 19, column: 20, scope: !639)
!639 = distinct !DILexicalBlock(scope: !634, file: !3, line: 19, column: 5)
!640 = !DILocation(line: 19, column: 22, scope: !639)
!641 = !DILocation(line: 19, column: 5, scope: !634)
!642 = !DILocation(line: 20, column: 16, scope: !639)
!643 = !DILocation(line: 20, column: 13, scope: !639)
!644 = !DILocation(line: 20, column: 9, scope: !639)
!645 = !DILocation(line: 19, column: 29, scope: !639)
!646 = !DILocation(line: 19, column: 5, scope: !639)
!647 = distinct !{!647, !641, !648}
!648 = !DILocation(line: 20, column: 16, scope: !634)
!649 = !DILocation(line: 21, column: 18, scope: !626)
!650 = !DILocation(line: 21, column: 16, scope: !626)
!651 = !DILocation(line: 21, column: 12, scope: !626)
!652 = !DILocation(line: 21, column: 39, scope: !626)
!653 = !DILocation(line: 21, column: 22, scope: !626)
!654 = !DILocation(line: 21, column: 20, scope: !626)
!655 = !DILocation(line: 21, column: 5, scope: !626)
!656 = distinct !DISubprogram(name: "g", linkageName: "_Z1gi", scope: !3, file: !3, line: 24, type: !627, scopeLine: 25, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!657 = !DILocalVariable(name: "x", arg: 1, scope: !656, file: !3, line: 24, type: !81)
!658 = !DILocation(line: 24, column: 11, scope: !656)
!659 = !DILocation(line: 26, column: 12, scope: !656)
!660 = !DILocation(line: 26, column: 29, scope: !656)
!661 = !DILocation(line: 26, column: 27, scope: !656)
!662 = !DILocation(line: 26, column: 23, scope: !656)
!663 = !DILocation(line: 26, column: 50, scope: !656)
!664 = !DILocation(line: 26, column: 33, scope: !656)
!665 = !DILocation(line: 26, column: 31, scope: !656)
!666 = !DILocation(line: 26, column: 21, scope: !656)
!667 = !DILocation(line: 26, column: 5, scope: !656)
!668 = distinct !DISubprogram(name: "i", linkageName: "_Z1iiii", scope: !3, file: !3, line: 29, type: !669, scopeLine: 30, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!669 = !DISubroutineType(types: !670)
!670 = !{!81, !81, !81, !81}
!671 = !DILocalVariable(name: "x1", arg: 1, scope: !668, file: !3, line: 29, type: !81)
!672 = !DILocation(line: 29, column: 11, scope: !668)
!673 = !DILocalVariable(name: "x2", arg: 2, scope: !668, file: !3, line: 29, type: !81)
!674 = !DILocation(line: 29, column: 19, scope: !668)
!675 = !DILocalVariable(name: "x3", arg: 3, scope: !668, file: !3, line: 29, type: !81)
!676 = !DILocation(line: 29, column: 27, scope: !668)
!677 = !DILocalVariable(name: "tmp", scope: !668, file: !3, line: 31, type: !81)
!678 = !DILocation(line: 31, column: 9, scope: !668)
!679 = !DILocalVariable(name: "i", scope: !680, file: !3, line: 32, type: !81)
!680 = distinct !DILexicalBlock(scope: !668, file: !3, line: 32, column: 5)
!681 = !DILocation(line: 32, column: 13, scope: !680)
!682 = !DILocation(line: 32, column: 17, scope: !680)
!683 = !DILocation(line: 32, column: 9, scope: !680)
!684 = !DILocation(line: 32, column: 21, scope: !685)
!685 = distinct !DILexicalBlock(scope: !680, file: !3, line: 32, column: 5)
!686 = !DILocation(line: 32, column: 25, scope: !685)
!687 = !DILocation(line: 32, column: 23, scope: !685)
!688 = !DILocation(line: 32, column: 5, scope: !680)
!689 = !DILocation(line: 33, column: 16, scope: !685)
!690 = !DILocation(line: 33, column: 17, scope: !685)
!691 = !DILocation(line: 33, column: 13, scope: !685)
!692 = !DILocation(line: 33, column: 9, scope: !685)
!693 = !DILocation(line: 32, column: 34, scope: !685)
!694 = !DILocation(line: 32, column: 31, scope: !685)
!695 = !DILocation(line: 32, column: 5, scope: !685)
!696 = distinct !{!696, !688, !697}
!697 = !DILocation(line: 33, column: 18, scope: !680)
!698 = !DILocation(line: 34, column: 18, scope: !668)
!699 = !DILocation(line: 34, column: 16, scope: !668)
!700 = !DILocation(line: 34, column: 23, scope: !668)
!701 = !DILocation(line: 34, column: 21, scope: !668)
!702 = !DILocation(line: 34, column: 28, scope: !668)
!703 = !DILocation(line: 34, column: 31, scope: !668)
!704 = !DILocation(line: 34, column: 26, scope: !668)
!705 = !DILocation(line: 34, column: 5, scope: !668)
!706 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 37, type: !707, scopeLine: 38, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!707 = !DISubroutineType(types: !708)
!708 = !{!81, !81, !378}
!709 = !DILocalVariable(name: "argc", arg: 1, scope: !706, file: !3, line: 37, type: !81)
!710 = !DILocation(line: 37, column: 14, scope: !706)
!711 = !DILocalVariable(name: "argv", arg: 2, scope: !706, file: !3, line: 37, type: !378)
!712 = !DILocation(line: 37, column: 28, scope: !706)
!713 = !DILocalVariable(name: "x1", scope: !706, file: !3, line: 39, type: !81)
!714 = !DILocation(line: 39, column: 9, scope: !706)
!715 = !DILocation(line: 39, column: 5, scope: !706)
!716 = !DILocation(line: 39, column: 26, scope: !706)
!717 = !DILocation(line: 39, column: 21, scope: !706)
!718 = !DILocalVariable(name: "x2", scope: !706, file: !3, line: 40, type: !81)
!719 = !DILocation(line: 40, column: 9, scope: !706)
!720 = !DILocation(line: 40, column: 5, scope: !706)
!721 = !DILocation(line: 40, column: 26, scope: !706)
!722 = !DILocation(line: 40, column: 21, scope: !706)
!723 = !DILocation(line: 41, column: 5, scope: !706)
!724 = !DILocation(line: 42, column: 5, scope: !706)
!725 = !DILocation(line: 43, column: 5, scope: !706)
!726 = !DILocalVariable(name: "y", scope: !706, file: !3, line: 44, type: !81)
!727 = !DILocation(line: 44, column: 9, scope: !706)
!728 = !DILocation(line: 44, column: 15, scope: !706)
!729 = !DILocation(line: 44, column: 14, scope: !706)
!730 = !DILocation(line: 44, column: 18, scope: !706)
!731 = !DILocation(line: 47, column: 7, scope: !706)
!732 = !DILocation(line: 47, column: 15, scope: !706)
!733 = !DILocation(line: 47, column: 5, scope: !706)
!734 = !DILocation(line: 49, column: 5, scope: !706)
!735 = !DILocation(line: 51, column: 7, scope: !706)
!736 = !DILocation(line: 51, column: 5, scope: !706)
!737 = !DILocation(line: 52, column: 5, scope: !706)
!738 = !DILocation(line: 54, column: 7, scope: !706)
!739 = !DILocation(line: 54, column: 11, scope: !706)
!740 = !DILocation(line: 54, column: 9, scope: !706)
!741 = !DILocation(line: 54, column: 15, scope: !706)
!742 = !DILocation(line: 54, column: 5, scope: !706)
!743 = !DILocation(line: 56, column: 5, scope: !706)
!744 = distinct !DISubprogram(name: "register_variable<int>", linkageName: "_Z17register_variableIiEvPT_PKc", scope: !745, file: !745, line: 14, type: !746, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, templateParams: !748, retainedNodes: !4)
!745 = !DIFile(filename: "include/ExtraPInstrumenter.hpp", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!746 = !DISubroutineType(types: !747)
!747 = !{null, !80, !171}
!748 = !{!749}
!749 = !DITemplateTypeParameter(name: "T", type: !81)
!750 = !DILocalVariable(name: "ptr", arg: 1, scope: !744, file: !745, line: 14, type: !80)
!751 = !DILocation(line: 14, column: 28, scope: !744)
!752 = !DILocalVariable(name: "name", arg: 2, scope: !744, file: !745, line: 14, type: !171)
!753 = !DILocation(line: 14, column: 46, scope: !744)
!754 = !DILocalVariable(name: "param_id", scope: !744, file: !745, line: 16, type: !525)
!755 = !DILocation(line: 16, column: 13, scope: !744)
!756 = !DILocation(line: 16, column: 24, scope: !744)
!757 = !DILocation(line: 17, column: 57, scope: !744)
!758 = !DILocation(line: 17, column: 31, scope: !744)
!759 = !DILocation(line: 18, column: 21, scope: !744)
!760 = !DILocation(line: 18, column: 25, scope: !744)
!761 = !DILocation(line: 17, column: 5, scope: !744)
!762 = !DILocation(line: 19, column: 1, scope: !744)
