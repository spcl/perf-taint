; RUN: opt %dfsan -S < %s 2> /dev/null | llc %llcparams - -o %t1 && clang++ %link %t1 -o %t2 && %execparams %t2 10 10 | diff -w %s.json -
; ModuleID = 'tests/dfsan-instr/function_retval.cpp'
source_filename = "tests/dfsan-instr/function_retval.cpp"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.test = type { i32, i32 }

$_ZN4test6lengthEv = comdat any

$_Z17register_variableIiEvPT_PKc = comdat any

$_ZN4testC2Eii = comdat any

@global = dso_local global i32 100, align 4, !dbg !0
@.str = private unnamed_addr constant [7 x i8] c"extrap\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [38 x i8] c"tests/dfsan-instr/function_retval.cpp\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [3 x i8] c"x1\00", align 1
@.str.3 = private unnamed_addr constant [3 x i8] c"x2\00", align 1
@.str.4 = private unnamed_addr constant [7 x i8] c"global\00", align 1
@llvm.global.annotations = appending global [1 x { i8*, i8*, i8*, i32 }] [{ i8*, i8*, i8*, i32 } { i8* bitcast (i32* @global to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([38 x i8], [38 x i8]* @.str.1, i32 0, i32 0), i32 7 }], section "llvm.metadata"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @_Z1gii(i32, i32) #0 !dbg !521 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  call void @llvm.dbg.declare(metadata i32* %3, metadata !524, metadata !DIExpression()), !dbg !525
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !526, metadata !DIExpression()), !dbg !527
  %5 = load i32, i32* %3, align 4, !dbg !528
  %6 = icmp ne i32 %5, 0, !dbg !528
  br i1 %6, label %7, label %10, !dbg !528

; <label>:7:                                      ; preds = %2
  %8 = load i32, i32* %4, align 4, !dbg !529
  %9 = mul nsw i32 2, %8, !dbg !530
  br label %13, !dbg !528

; <label>:10:                                     ; preds = %2
  %11 = load i32, i32* %4, align 4, !dbg !531
  %12 = add nsw i32 %11, 1, !dbg !532
  br label %13, !dbg !528

; <label>:13:                                     ; preds = %10, %7
  %14 = phi i32 [ %9, %7 ], [ %12, %10 ], !dbg !528
  ret i32 %14, !dbg !533
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @_Z2g2ii(i32, i32) #0 !dbg !534 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  call void @llvm.dbg.declare(metadata i32* %3, metadata !535, metadata !DIExpression()), !dbg !536
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !537, metadata !DIExpression()), !dbg !538
  %5 = load i32, i32* %3, align 4, !dbg !539
  %6 = load i32, i32* %4, align 4, !dbg !540
  %7 = add nsw i32 %5, %6, !dbg !541
  %8 = load i32, i32* @global, align 4, !dbg !542
  %9 = add nsw i32 %7, %8, !dbg !543
  ret i32 %9, !dbg !544
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @_Z1fii(i32, i32) #0 !dbg !545 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  call void @llvm.dbg.declare(metadata i32* %3, metadata !546, metadata !DIExpression()), !dbg !547
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !548, metadata !DIExpression()), !dbg !549
  call void @llvm.dbg.declare(metadata i32* %5, metadata !550, metadata !DIExpression()), !dbg !551
  store i32 1, i32* %5, align 4, !dbg !551
  call void @llvm.dbg.declare(metadata i32* %6, metadata !552, metadata !DIExpression()), !dbg !554
  store i32 0, i32* %6, align 4, !dbg !554
  br label %7, !dbg !555

; <label>:7:                                      ; preds = %18, %2
  %8 = load i32, i32* %6, align 4, !dbg !556
  %9 = load i32, i32* %3, align 4, !dbg !558
  %10 = load i32, i32* %4, align 4, !dbg !559
  %11 = add nsw i32 %9, %10, !dbg !560
  %12 = call i32 @_Z1gii(i32 %11, i32 1), !dbg !561
  %13 = icmp slt i32 %8, %12, !dbg !562
  br i1 %13, label %14, label %21, !dbg !563

; <label>:14:                                     ; preds = %7
  %15 = load i32, i32* %6, align 4, !dbg !564
  %16 = load i32, i32* %5, align 4, !dbg !566
  %17 = add nsw i32 %16, %15, !dbg !566
  store i32 %17, i32* %5, align 4, !dbg !566
  br label %18, !dbg !567

; <label>:18:                                     ; preds = %14
  %19 = load i32, i32* %6, align 4, !dbg !568
  %20 = add nsw i32 %19, 1, !dbg !568
  store i32 %20, i32* %6, align 4, !dbg !568
  br label %7, !dbg !569, !llvm.loop !570

; <label>:21:                                     ; preds = %7
  %22 = load i32, i32* %5, align 4, !dbg !572
  ret i32 %22, !dbg !573
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @_Z1hii(i32, i32) #0 !dbg !574 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  call void @llvm.dbg.declare(metadata i32* %3, metadata !575, metadata !DIExpression()), !dbg !576
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !577, metadata !DIExpression()), !dbg !578
  call void @llvm.dbg.declare(metadata i32* %5, metadata !579, metadata !DIExpression()), !dbg !580
  store i32 1, i32* %5, align 4, !dbg !580
  call void @llvm.dbg.declare(metadata i32* %6, metadata !581, metadata !DIExpression()), !dbg !583
  store i32 0, i32* %6, align 4, !dbg !583
  br label %7, !dbg !584

; <label>:7:                                      ; preds = %16, %2
  %8 = load i32, i32* %6, align 4, !dbg !585
  %9 = load i32, i32* %4, align 4, !dbg !587
  %10 = call i32 @_Z2g2ii(i32 %9, i32 1), !dbg !588
  %11 = icmp slt i32 %8, %10, !dbg !589
  br i1 %11, label %12, label %19, !dbg !590

; <label>:12:                                     ; preds = %7
  %13 = load i32, i32* %6, align 4, !dbg !591
  %14 = load i32, i32* %5, align 4, !dbg !593
  %15 = add nsw i32 %14, %13, !dbg !593
  store i32 %15, i32* %5, align 4, !dbg !593
  br label %16, !dbg !594

; <label>:16:                                     ; preds = %12
  %17 = load i32, i32* %6, align 4, !dbg !595
  %18 = add nsw i32 %17, 1, !dbg !595
  store i32 %18, i32* %6, align 4, !dbg !595
  br label %7, !dbg !596, !llvm.loop !597

; <label>:19:                                     ; preds = %7
  %20 = load i32, i32* %5, align 4, !dbg !599
  ret i32 %20, !dbg !600
}

; Function Attrs: noinline optnone uwtable
define dso_local i32 @_Z1iP4test(%struct.test*) #2 !dbg !601 {
  %2 = alloca %struct.test*, align 8
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store %struct.test* %0, %struct.test** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.test** %2, metadata !616, metadata !DIExpression()), !dbg !617
  call void @llvm.dbg.declare(metadata i32* %3, metadata !618, metadata !DIExpression()), !dbg !619
  store i32 1, i32* %3, align 4, !dbg !619
  call void @llvm.dbg.declare(metadata i32* %4, metadata !620, metadata !DIExpression()), !dbg !622
  store i32 0, i32* %4, align 4, !dbg !622
  br label %5, !dbg !623

; <label>:5:                                      ; preds = %14, %1
  %6 = load i32, i32* %4, align 4, !dbg !624
  %7 = load %struct.test*, %struct.test** %2, align 8, !dbg !626
  %8 = call i32 @_ZN4test6lengthEv(%struct.test* %7), !dbg !627
  %9 = icmp slt i32 %6, %8, !dbg !628
  br i1 %9, label %10, label %17, !dbg !629

; <label>:10:                                     ; preds = %5
  %11 = load i32, i32* %4, align 4, !dbg !630
  %12 = load i32, i32* %3, align 4, !dbg !632
  %13 = add nsw i32 %12, %11, !dbg !632
  store i32 %13, i32* %3, align 4, !dbg !632
  br label %14, !dbg !633

; <label>:14:                                     ; preds = %10
  %15 = load i32, i32* %4, align 4, !dbg !634
  %16 = add nsw i32 %15, 1, !dbg !634
  store i32 %16, i32* %4, align 4, !dbg !634
  br label %5, !dbg !635, !llvm.loop !636

; <label>:17:                                     ; preds = %5
  %18 = load i32, i32* %3, align 4, !dbg !638
  ret i32 %18, !dbg !639
}

; Function Attrs: noinline nounwind optnone uwtable
define linkonce_odr dso_local i32 @_ZN4test6lengthEv(%struct.test*) #0 comdat align 2 !dbg !640 {
  %2 = alloca %struct.test*, align 8
  store %struct.test* %0, %struct.test** %2, align 8
  call void @llvm.dbg.declare(metadata %struct.test** %2, metadata !641, metadata !DIExpression()), !dbg !642
  %3 = load %struct.test*, %struct.test** %2, align 8
  %4 = getelementptr inbounds %struct.test, %struct.test* %3, i32 0, i32 0, !dbg !643
  %5 = load i32, i32* %4, align 4, !dbg !643
  ret i32 %5, !dbg !644
}

; Function Attrs: noinline norecurse optnone uwtable
define dso_local i32 @main(i32, i8**) #3 !dbg !645 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca %struct.test, align 4
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !648, metadata !DIExpression()), !dbg !649
  store i8** %1, i8*** %5, align 8
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !650, metadata !DIExpression()), !dbg !651
  call void @llvm.dbg.declare(metadata i32* %6, metadata !652, metadata !DIExpression()), !dbg !653
  %10 = bitcast i32* %6 to i8*, !dbg !654
  call void @llvm.var.annotation(i8* %10, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([38 x i8], [38 x i8]* @.str.1, i32 0, i32 0), i32 70), !dbg !654
  %11 = load i8**, i8*** %5, align 8, !dbg !655
  %12 = getelementptr inbounds i8*, i8** %11, i64 1, !dbg !655
  %13 = load i8*, i8** %12, align 8, !dbg !655
  %14 = call i32 @atoi(i8* %13) #7, !dbg !656
  store i32 %14, i32* %6, align 4, !dbg !653
  call void @llvm.dbg.declare(metadata i32* %7, metadata !657, metadata !DIExpression()), !dbg !658
  %15 = bitcast i32* %7 to i8*, !dbg !659
  call void @llvm.var.annotation(i8* %15, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([38 x i8], [38 x i8]* @.str.1, i32 0, i32 0), i32 71), !dbg !659
  %16 = load i8**, i8*** %5, align 8, !dbg !660
  %17 = getelementptr inbounds i8*, i8** %16, i64 2, !dbg !660
  %18 = load i8*, i8** %17, align 8, !dbg !660
  %19 = call i32 @atoi(i8* %18) #7, !dbg !661
  store i32 %19, i32* %7, align 4, !dbg !658
  call void @_Z17register_variableIiEvPT_PKc(i32* %6, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.2, i32 0, i32 0)), !dbg !662
  call void @_Z17register_variableIiEvPT_PKc(i32* %7, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.3, i32 0, i32 0)), !dbg !663
  call void @_Z17register_variableIiEvPT_PKc(i32* @global, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.4, i32 0, i32 0)), !dbg !664
  call void @llvm.dbg.declare(metadata i32* %8, metadata !665, metadata !DIExpression()), !dbg !666
  %20 = load i32, i32* %6, align 4, !dbg !667
  %21 = mul nsw i32 2, %20, !dbg !668
  %22 = add nsw i32 %21, 1, !dbg !669
  store i32 %22, i32* %8, align 4, !dbg !666
  call void @llvm.dbg.declare(metadata %struct.test* %9, metadata !670, metadata !DIExpression()), !dbg !671
  %23 = load i32, i32* %6, align 4, !dbg !672
  %24 = load i32, i32* %7, align 4, !dbg !673
  call void @_ZN4testC2Eii(%struct.test* %9, i32 %23, i32 %24), !dbg !671
  %25 = load i32, i32* @global, align 4, !dbg !674
  %26 = load i32, i32* %6, align 4, !dbg !675
  %27 = call i32 @_Z1fii(i32 %25, i32 %26), !dbg !676
  %28 = load i32, i32* %6, align 4, !dbg !677
  %29 = load i32, i32* %7, align 4, !dbg !678
  %30 = add nsw i32 %28, %29, !dbg !679
  %31 = call i32 @_Z1fii(i32 %30, i32 2), !dbg !680
  %32 = load i32, i32* %6, align 4, !dbg !681
  %33 = call i32 @_Z1hii(i32 %32, i32 10), !dbg !682
  %34 = call i32 @_Z1hii(i32 10, i32 10), !dbg !683
  %35 = call i32 @_Z1iP4test(%struct.test* %9), !dbg !684
  ret i32 0, !dbg !685
}

; Function Attrs: nounwind
declare void @llvm.var.annotation(i8*, i8*, i8*, i32) #4

; Function Attrs: nounwind readonly
declare dso_local i32 @atoi(i8*) #5

; Function Attrs: noinline optnone uwtable
define linkonce_odr dso_local void @_Z17register_variableIiEvPT_PKc(i32*, i8*) #2 comdat !dbg !686 {
  %3 = alloca i32*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca i32, align 4
  store i32* %0, i32** %3, align 8
  call void @llvm.dbg.declare(metadata i32** %3, metadata !692, metadata !DIExpression()), !dbg !693
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !694, metadata !DIExpression()), !dbg !695
  call void @llvm.dbg.declare(metadata i32* %5, metadata !696, metadata !DIExpression()), !dbg !699
  %6 = call i32 @__dfsw_EXTRAP_VAR_ID(), !dbg !700
  store i32 %6, i32* %5, align 4, !dbg !699
  %7 = load i32*, i32** %3, align 8, !dbg !701
  %8 = bitcast i32* %7 to i8*, !dbg !702
  %9 = load i32, i32* %5, align 4, !dbg !703
  %10 = add nsw i32 %9, 1, !dbg !703
  store i32 %10, i32* %5, align 4, !dbg !703
  %11 = load i8*, i8** %4, align 8, !dbg !704
  call void @__dfsw_EXTRAP_STORE_LABEL(i8* %8, i32 4, i32 %9, i8* %11), !dbg !705
  ret void, !dbg !706
}

; Function Attrs: noinline nounwind optnone uwtable
define linkonce_odr dso_local void @_ZN4testC2Eii(%struct.test*, i32, i32) unnamed_addr #0 comdat align 2 !dbg !707 {
  %4 = alloca %struct.test*, align 8
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store %struct.test* %0, %struct.test** %4, align 8
  call void @llvm.dbg.declare(metadata %struct.test** %4, metadata !708, metadata !DIExpression()), !dbg !709
  store i32 %1, i32* %5, align 4
  call void @llvm.dbg.declare(metadata i32* %5, metadata !710, metadata !DIExpression()), !dbg !711
  store i32 %2, i32* %6, align 4
  call void @llvm.dbg.declare(metadata i32* %6, metadata !712, metadata !DIExpression()), !dbg !713
  %7 = load %struct.test*, %struct.test** %4, align 8
  %8 = getelementptr inbounds %struct.test, %struct.test* %7, i32 0, i32 0, !dbg !714
  %9 = load i32, i32* %5, align 4, !dbg !715
  store i32 %9, i32* %8, align 4, !dbg !714
  %10 = getelementptr inbounds %struct.test, %struct.test* %7, i32 0, i32 1, !dbg !716
  %11 = load i32, i32* %6, align 4, !dbg !717
  store i32 %11, i32* %10, align 4, !dbg !716
  ret void, !dbg !718
}

declare dso_local i32 @__dfsw_EXTRAP_VAR_ID() #6

declare dso_local void @__dfsw_EXTRAP_STORE_LABEL(i8*, i32, i32, i8*) #6

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { noinline optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { noinline norecurse optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind }
attributes #5 = { nounwind readonly "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #6 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #7 = { nounwind readonly }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!517, !518, !519}
!llvm.ident = !{!520}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "global", scope: !2, file: !3, line: 7, type: !80, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !3, producer: "clang version 8.0.0 (git@github.com:llvm-mirror/clang.git fd01d8b9288b3558a597daeb0cb4481b37c5bf68) (git@github.com:llvm-mirror/LLVM.git 7135d8b482d3d0d1a8c50111eebb9b207e92a8bc)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !5, globals: !12, imports: !13, nameTableKind: None)
!3 = !DIFile(filename: "tests/dfsan-instr/function_retval.cpp", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!4 = !{}
!5 = !{!6}
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!7 = !DIDerivedType(tag: DW_TAG_typedef, name: "int8_t", file: !8, line: 24, baseType: !9)
!8 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-intn.h", directory: "")
!9 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int8_t", file: !10, line: 36, baseType: !11)
!10 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "")
!11 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!12 = !{!0}
!13 = !{!14, !21, !24, !27, !35, !37, !41, !44, !48, !53, !55, !57, !61, !63, !65, !67, !69, !71, !73, !75, !81, !85, !87, !89, !94, !99, !101, !103, !105, !107, !109, !111, !113, !115, !117, !119, !121, !123, !125, !127, !129, !131, !135, !137, !139, !141, !145, !147, !152, !154, !156, !158, !160, !164, !166, !173, !177, !179, !181, !185, !187, !191, !193, !195, !199, !201, !203, !205, !207, !209, !211, !215, !217, !219, !221, !223, !225, !227, !229, !233, !237, !239, !241, !243, !245, !247, !249, !251, !253, !255, !257, !259, !261, !263, !265, !267, !269, !271, !273, !275, !279, !281, !283, !285, !289, !291, !295, !297, !299, !301, !303, !307, !309, !313, !315, !317, !319, !321, !325, !327, !329, !333, !335, !337, !339, !341, !345, !351, !357, !359, !363, !367, !371, !379, !383, !387, !391, !395, !399, !404, !408, !413, !418, !422, !426, !430, !434, !439, !443, !445, !449, !451, !461, !465, !470, !474, !476, !480, !484, !486, !490, !497, !501, !505, !513, !515}
!14 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !17, file: !20, line: 50)
!15 = !DINamespace(name: "__1", scope: !16, exportSymbols: true)
!16 = !DINamespace(name: "std", scope: null)
!17 = !DIDerivedType(tag: DW_TAG_typedef, name: "ptrdiff_t", file: !18, line: 149, baseType: !19)
!18 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7/include/stddef.h", directory: "")
!19 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!20 = !DIFile(filename: "clang_llvm/build_dfsan_full/include/c++/v1/cstddef", directory: "/home/mcopik/projects")
!21 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !22, file: !20, line: 51)
!22 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !18, line: 216, baseType: !23)
!23 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!24 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !25, file: !20, line: 56)
!25 = !DIDerivedType(tag: DW_TAG_typedef, name: "max_align_t", file: !18, line: 437, baseType: !26)
!26 = !DICompositeType(tag: DW_TAG_structure_type, file: !18, line: 426, flags: DIFlagFwdDecl, identifier: "_ZTS11max_align_t")
!27 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !28, file: !34, line: 317)
!28 = !DISubprogram(name: "isinf", linkageName: "_Z5isinfe", scope: !29, file: !29, line: 497, type: !30, flags: DIFlagPrototyped, spFlags: 0)
!29 = !DIFile(filename: "clang_llvm/build_dfsan_full/include/c++/v1/math.h", directory: "/home/mcopik/projects")
!30 = !DISubroutineType(types: !31)
!31 = !{!32, !33}
!32 = !DIBasicType(name: "bool", size: 8, encoding: DW_ATE_boolean)
!33 = !DIBasicType(name: "long double", size: 128, encoding: DW_ATE_float)
!34 = !DIFile(filename: "clang_llvm/build_dfsan_full/include/c++/v1/cmath", directory: "/home/mcopik/projects")
!35 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !36, file: !34, line: 318)
!36 = !DISubprogram(name: "isnan", linkageName: "_Z5isnane", scope: !29, file: !29, line: 541, type: !30, flags: DIFlagPrototyped, spFlags: 0)
!37 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !38, file: !34, line: 328)
!38 = !DIDerivedType(tag: DW_TAG_typedef, name: "float_t", file: !39, line: 149, baseType: !40)
!39 = !DIFile(filename: "/usr/include/math.h", directory: "")
!40 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!41 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !42, file: !34, line: 329)
!42 = !DIDerivedType(tag: DW_TAG_typedef, name: "double_t", file: !39, line: 150, baseType: !43)
!43 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!44 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !45, file: !34, line: 332)
!45 = !DISubprogram(name: "abs", linkageName: "_Z3abse", scope: !29, file: !29, line: 769, type: !46, flags: DIFlagPrototyped, spFlags: 0)
!46 = !DISubroutineType(types: !47)
!47 = !{!33, !33}
!48 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !49, file: !34, line: 336)
!49 = !DISubprogram(name: "acosf", scope: !50, file: !50, line: 53, type: !51, flags: DIFlagPrototyped, spFlags: 0)
!50 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/mathcalls.h", directory: "")
!51 = !DISubroutineType(types: !52)
!52 = !{!40, !40}
!53 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !54, file: !34, line: 338)
!54 = !DISubprogram(name: "asinf", scope: !50, file: !50, line: 55, type: !51, flags: DIFlagPrototyped, spFlags: 0)
!55 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !56, file: !34, line: 340)
!56 = !DISubprogram(name: "atanf", scope: !50, file: !50, line: 57, type: !51, flags: DIFlagPrototyped, spFlags: 0)
!57 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !58, file: !34, line: 342)
!58 = !DISubprogram(name: "atan2f", scope: !50, file: !50, line: 59, type: !59, flags: DIFlagPrototyped, spFlags: 0)
!59 = !DISubroutineType(types: !60)
!60 = !{!40, !40, !40}
!61 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !62, file: !34, line: 344)
!62 = !DISubprogram(name: "ceilf", scope: !50, file: !50, line: 159, type: !51, flags: DIFlagPrototyped, spFlags: 0)
!63 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !64, file: !34, line: 346)
!64 = !DISubprogram(name: "cosf", scope: !50, file: !50, line: 62, type: !51, flags: DIFlagPrototyped, spFlags: 0)
!65 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !66, file: !34, line: 348)
!66 = !DISubprogram(name: "coshf", scope: !50, file: !50, line: 71, type: !51, flags: DIFlagPrototyped, spFlags: 0)
!67 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !68, file: !34, line: 351)
!68 = !DISubprogram(name: "expf", scope: !50, file: !50, line: 95, type: !51, flags: DIFlagPrototyped, spFlags: 0)
!69 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !70, file: !34, line: 354)
!70 = !DISubprogram(name: "fabsf", scope: !50, file: !50, line: 162, type: !51, flags: DIFlagPrototyped, spFlags: 0)
!71 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !72, file: !34, line: 356)
!72 = !DISubprogram(name: "floorf", scope: !50, file: !50, line: 165, type: !51, flags: DIFlagPrototyped, spFlags: 0)
!73 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !74, file: !34, line: 359)
!74 = !DISubprogram(name: "fmodf", scope: !50, file: !50, line: 168, type: !59, flags: DIFlagPrototyped, spFlags: 0)
!75 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !76, file: !34, line: 362)
!76 = !DISubprogram(name: "frexpf", scope: !50, file: !50, line: 98, type: !77, flags: DIFlagPrototyped, spFlags: 0)
!77 = !DISubroutineType(types: !78)
!78 = !{!40, !40, !79}
!79 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !80, size: 64)
!80 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!81 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !82, file: !34, line: 364)
!82 = !DISubprogram(name: "ldexpf", scope: !50, file: !50, line: 101, type: !83, flags: DIFlagPrototyped, spFlags: 0)
!83 = !DISubroutineType(types: !84)
!84 = !{!40, !40, !80}
!85 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !86, file: !34, line: 367)
!86 = !DISubprogram(name: "logf", scope: !50, file: !50, line: 104, type: !51, flags: DIFlagPrototyped, spFlags: 0)
!87 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !88, file: !34, line: 370)
!88 = !DISubprogram(name: "log10f", scope: !50, file: !50, line: 107, type: !51, flags: DIFlagPrototyped, spFlags: 0)
!89 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !90, file: !34, line: 371)
!90 = !DISubprogram(name: "modf", linkageName: "_Z4modfePe", scope: !29, file: !29, line: 978, type: !91, flags: DIFlagPrototyped, spFlags: 0)
!91 = !DISubroutineType(types: !92)
!92 = !{!33, !33, !93}
!93 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !33, size: 64)
!94 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !95, file: !34, line: 372)
!95 = !DISubprogram(name: "modff", scope: !50, file: !50, line: 110, type: !96, flags: DIFlagPrototyped, spFlags: 0)
!96 = !DISubroutineType(types: !97)
!97 = !{!40, !40, !98}
!98 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !40, size: 64)
!99 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !100, file: !34, line: 375)
!100 = !DISubprogram(name: "powf", scope: !50, file: !50, line: 140, type: !59, flags: DIFlagPrototyped, spFlags: 0)
!101 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !102, file: !34, line: 378)
!102 = !DISubprogram(name: "sinf", scope: !50, file: !50, line: 64, type: !51, flags: DIFlagPrototyped, spFlags: 0)
!103 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !104, file: !34, line: 380)
!104 = !DISubprogram(name: "sinhf", scope: !50, file: !50, line: 73, type: !51, flags: DIFlagPrototyped, spFlags: 0)
!105 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !106, file: !34, line: 383)
!106 = !DISubprogram(name: "sqrtf", scope: !50, file: !50, line: 143, type: !51, flags: DIFlagPrototyped, spFlags: 0)
!107 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !108, file: !34, line: 385)
!108 = !DISubprogram(name: "tanf", scope: !50, file: !50, line: 66, type: !51, flags: DIFlagPrototyped, spFlags: 0)
!109 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !110, file: !34, line: 388)
!110 = !DISubprogram(name: "tanhf", scope: !50, file: !50, line: 75, type: !51, flags: DIFlagPrototyped, spFlags: 0)
!111 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !112, file: !34, line: 391)
!112 = !DISubprogram(name: "acoshf", scope: !50, file: !50, line: 85, type: !51, flags: DIFlagPrototyped, spFlags: 0)
!113 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !114, file: !34, line: 393)
!114 = !DISubprogram(name: "asinhf", scope: !50, file: !50, line: 87, type: !51, flags: DIFlagPrototyped, spFlags: 0)
!115 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !116, file: !34, line: 395)
!116 = !DISubprogram(name: "atanhf", scope: !50, file: !50, line: 89, type: !51, flags: DIFlagPrototyped, spFlags: 0)
!117 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !118, file: !34, line: 397)
!118 = !DISubprogram(name: "cbrtf", scope: !50, file: !50, line: 152, type: !51, flags: DIFlagPrototyped, spFlags: 0)
!119 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !120, file: !34, line: 400)
!120 = !DISubprogram(name: "copysignf", scope: !50, file: !50, line: 196, type: !59, flags: DIFlagPrototyped, spFlags: 0)
!121 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !122, file: !34, line: 403)
!122 = !DISubprogram(name: "erff", scope: !50, file: !50, line: 228, type: !51, flags: DIFlagPrototyped, spFlags: 0)
!123 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !124, file: !34, line: 405)
!124 = !DISubprogram(name: "erfcf", scope: !50, file: !50, line: 229, type: !51, flags: DIFlagPrototyped, spFlags: 0)
!125 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !126, file: !34, line: 407)
!126 = !DISubprogram(name: "exp2f", scope: !50, file: !50, line: 130, type: !51, flags: DIFlagPrototyped, spFlags: 0)
!127 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !128, file: !34, line: 409)
!128 = !DISubprogram(name: "expm1f", scope: !50, file: !50, line: 119, type: !51, flags: DIFlagPrototyped, spFlags: 0)
!129 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !130, file: !34, line: 411)
!130 = !DISubprogram(name: "fdimf", scope: !50, file: !50, line: 326, type: !59, flags: DIFlagPrototyped, spFlags: 0)
!131 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !132, file: !34, line: 412)
!132 = !DISubprogram(name: "fmaf", scope: !50, file: !50, line: 335, type: !133, flags: DIFlagPrototyped, spFlags: 0)
!133 = !DISubroutineType(types: !134)
!134 = !{!40, !40, !40, !40}
!135 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !136, file: !34, line: 415)
!136 = !DISubprogram(name: "fmaxf", scope: !50, file: !50, line: 329, type: !59, flags: DIFlagPrototyped, spFlags: 0)
!137 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !138, file: !34, line: 417)
!138 = !DISubprogram(name: "fminf", scope: !50, file: !50, line: 332, type: !59, flags: DIFlagPrototyped, spFlags: 0)
!139 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !140, file: !34, line: 419)
!140 = !DISubprogram(name: "hypotf", scope: !50, file: !50, line: 147, type: !59, flags: DIFlagPrototyped, spFlags: 0)
!141 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !142, file: !34, line: 421)
!142 = !DISubprogram(name: "ilogbf", scope: !50, file: !50, line: 280, type: !143, flags: DIFlagPrototyped, spFlags: 0)
!143 = !DISubroutineType(types: !144)
!144 = !{!80, !40}
!145 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !146, file: !34, line: 423)
!146 = !DISubprogram(name: "lgammaf", scope: !50, file: !50, line: 230, type: !51, flags: DIFlagPrototyped, spFlags: 0)
!147 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !148, file: !34, line: 425)
!148 = !DISubprogram(name: "llrintf", scope: !50, file: !50, line: 316, type: !149, flags: DIFlagPrototyped, spFlags: 0)
!149 = !DISubroutineType(types: !150)
!150 = !{!151, !40}
!151 = !DIBasicType(name: "long long int", size: 64, encoding: DW_ATE_signed)
!152 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !153, file: !34, line: 427)
!153 = !DISubprogram(name: "llroundf", scope: !50, file: !50, line: 322, type: !149, flags: DIFlagPrototyped, spFlags: 0)
!154 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !155, file: !34, line: 429)
!155 = !DISubprogram(name: "log1pf", scope: !50, file: !50, line: 122, type: !51, flags: DIFlagPrototyped, spFlags: 0)
!156 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !157, file: !34, line: 431)
!157 = !DISubprogram(name: "log2f", scope: !50, file: !50, line: 133, type: !51, flags: DIFlagPrototyped, spFlags: 0)
!158 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !159, file: !34, line: 433)
!159 = !DISubprogram(name: "logbf", scope: !50, file: !50, line: 125, type: !51, flags: DIFlagPrototyped, spFlags: 0)
!160 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !161, file: !34, line: 435)
!161 = !DISubprogram(name: "lrintf", scope: !50, file: !50, line: 314, type: !162, flags: DIFlagPrototyped, spFlags: 0)
!162 = !DISubroutineType(types: !163)
!163 = !{!19, !40}
!164 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !165, file: !34, line: 437)
!165 = !DISubprogram(name: "lroundf", scope: !50, file: !50, line: 320, type: !162, flags: DIFlagPrototyped, spFlags: 0)
!166 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !167, file: !34, line: 439)
!167 = !DISubprogram(name: "nan", scope: !50, file: !50, line: 201, type: !168, flags: DIFlagPrototyped, spFlags: 0)
!168 = !DISubroutineType(types: !169)
!169 = !{!43, !170}
!170 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !171, size: 64)
!171 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !172)
!172 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!173 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !174, file: !34, line: 440)
!174 = !DISubprogram(name: "nanf", scope: !50, file: !50, line: 201, type: !175, flags: DIFlagPrototyped, spFlags: 0)
!175 = !DISubroutineType(types: !176)
!176 = !{!40, !170}
!177 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !178, file: !34, line: 443)
!178 = !DISubprogram(name: "nearbyintf", scope: !50, file: !50, line: 294, type: !51, flags: DIFlagPrototyped, spFlags: 0)
!179 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !180, file: !34, line: 445)
!180 = !DISubprogram(name: "nextafterf", scope: !50, file: !50, line: 259, type: !59, flags: DIFlagPrototyped, spFlags: 0)
!181 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !182, file: !34, line: 447)
!182 = !DISubprogram(name: "nexttowardf", scope: !50, file: !50, line: 261, type: !183, flags: DIFlagPrototyped, spFlags: 0)
!183 = !DISubroutineType(types: !184)
!184 = !{!40, !40, !33}
!185 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !186, file: !34, line: 449)
!186 = !DISubprogram(name: "remainderf", scope: !50, file: !50, line: 272, type: !59, flags: DIFlagPrototyped, spFlags: 0)
!187 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !188, file: !34, line: 451)
!188 = !DISubprogram(name: "remquof", scope: !50, file: !50, line: 307, type: !189, flags: DIFlagPrototyped, spFlags: 0)
!189 = !DISubroutineType(types: !190)
!190 = !{!40, !40, !40, !79}
!191 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !192, file: !34, line: 453)
!192 = !DISubprogram(name: "rintf", scope: !50, file: !50, line: 256, type: !51, flags: DIFlagPrototyped, spFlags: 0)
!193 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !194, file: !34, line: 455)
!194 = !DISubprogram(name: "roundf", scope: !50, file: !50, line: 298, type: !51, flags: DIFlagPrototyped, spFlags: 0)
!195 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !196, file: !34, line: 457)
!196 = !DISubprogram(name: "scalblnf", scope: !50, file: !50, line: 290, type: !197, flags: DIFlagPrototyped, spFlags: 0)
!197 = !DISubroutineType(types: !198)
!198 = !{!40, !40, !19}
!199 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !200, file: !34, line: 459)
!200 = !DISubprogram(name: "scalbnf", scope: !50, file: !50, line: 276, type: !83, flags: DIFlagPrototyped, spFlags: 0)
!201 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !202, file: !34, line: 461)
!202 = !DISubprogram(name: "tgammaf", scope: !50, file: !50, line: 235, type: !51, flags: DIFlagPrototyped, spFlags: 0)
!203 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !204, file: !34, line: 463)
!204 = !DISubprogram(name: "truncf", scope: !50, file: !50, line: 302, type: !51, flags: DIFlagPrototyped, spFlags: 0)
!205 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !206, file: !34, line: 465)
!206 = !DISubprogram(name: "acosl", scope: !50, file: !50, line: 53, type: !46, flags: DIFlagPrototyped, spFlags: 0)
!207 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !208, file: !34, line: 466)
!208 = !DISubprogram(name: "asinl", scope: !50, file: !50, line: 55, type: !46, flags: DIFlagPrototyped, spFlags: 0)
!209 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !210, file: !34, line: 467)
!210 = !DISubprogram(name: "atanl", scope: !50, file: !50, line: 57, type: !46, flags: DIFlagPrototyped, spFlags: 0)
!211 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !212, file: !34, line: 468)
!212 = !DISubprogram(name: "atan2l", scope: !50, file: !50, line: 59, type: !213, flags: DIFlagPrototyped, spFlags: 0)
!213 = !DISubroutineType(types: !214)
!214 = !{!33, !33, !33}
!215 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !216, file: !34, line: 469)
!216 = !DISubprogram(name: "ceill", scope: !50, file: !50, line: 159, type: !46, flags: DIFlagPrototyped, spFlags: 0)
!217 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !218, file: !34, line: 470)
!218 = !DISubprogram(name: "cosl", scope: !50, file: !50, line: 62, type: !46, flags: DIFlagPrototyped, spFlags: 0)
!219 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !220, file: !34, line: 471)
!220 = !DISubprogram(name: "coshl", scope: !50, file: !50, line: 71, type: !46, flags: DIFlagPrototyped, spFlags: 0)
!221 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !222, file: !34, line: 472)
!222 = !DISubprogram(name: "expl", scope: !50, file: !50, line: 95, type: !46, flags: DIFlagPrototyped, spFlags: 0)
!223 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !224, file: !34, line: 473)
!224 = !DISubprogram(name: "fabsl", scope: !50, file: !50, line: 162, type: !46, flags: DIFlagPrototyped, spFlags: 0)
!225 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !226, file: !34, line: 474)
!226 = !DISubprogram(name: "floorl", scope: !50, file: !50, line: 165, type: !46, flags: DIFlagPrototyped, spFlags: 0)
!227 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !228, file: !34, line: 475)
!228 = !DISubprogram(name: "fmodl", scope: !50, file: !50, line: 168, type: !213, flags: DIFlagPrototyped, spFlags: 0)
!229 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !230, file: !34, line: 476)
!230 = !DISubprogram(name: "frexpl", scope: !50, file: !50, line: 98, type: !231, flags: DIFlagPrototyped, spFlags: 0)
!231 = !DISubroutineType(types: !232)
!232 = !{!33, !33, !79}
!233 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !234, file: !34, line: 477)
!234 = !DISubprogram(name: "ldexpl", scope: !50, file: !50, line: 101, type: !235, flags: DIFlagPrototyped, spFlags: 0)
!235 = !DISubroutineType(types: !236)
!236 = !{!33, !33, !80}
!237 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !238, file: !34, line: 478)
!238 = !DISubprogram(name: "logl", scope: !50, file: !50, line: 104, type: !46, flags: DIFlagPrototyped, spFlags: 0)
!239 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !240, file: !34, line: 479)
!240 = !DISubprogram(name: "log10l", scope: !50, file: !50, line: 107, type: !46, flags: DIFlagPrototyped, spFlags: 0)
!241 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !242, file: !34, line: 480)
!242 = !DISubprogram(name: "modfl", scope: !50, file: !50, line: 110, type: !91, flags: DIFlagPrototyped, spFlags: 0)
!243 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !244, file: !34, line: 481)
!244 = !DISubprogram(name: "powl", scope: !50, file: !50, line: 140, type: !213, flags: DIFlagPrototyped, spFlags: 0)
!245 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !246, file: !34, line: 482)
!246 = !DISubprogram(name: "sinl", scope: !50, file: !50, line: 64, type: !46, flags: DIFlagPrototyped, spFlags: 0)
!247 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !248, file: !34, line: 483)
!248 = !DISubprogram(name: "sinhl", scope: !50, file: !50, line: 73, type: !46, flags: DIFlagPrototyped, spFlags: 0)
!249 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !250, file: !34, line: 484)
!250 = !DISubprogram(name: "sqrtl", scope: !50, file: !50, line: 143, type: !46, flags: DIFlagPrototyped, spFlags: 0)
!251 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !252, file: !34, line: 485)
!252 = !DISubprogram(name: "tanl", scope: !50, file: !50, line: 66, type: !46, flags: DIFlagPrototyped, spFlags: 0)
!253 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !254, file: !34, line: 487)
!254 = !DISubprogram(name: "tanhl", scope: !50, file: !50, line: 75, type: !46, flags: DIFlagPrototyped, spFlags: 0)
!255 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !256, file: !34, line: 488)
!256 = !DISubprogram(name: "acoshl", scope: !50, file: !50, line: 85, type: !46, flags: DIFlagPrototyped, spFlags: 0)
!257 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !258, file: !34, line: 489)
!258 = !DISubprogram(name: "asinhl", scope: !50, file: !50, line: 87, type: !46, flags: DIFlagPrototyped, spFlags: 0)
!259 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !260, file: !34, line: 490)
!260 = !DISubprogram(name: "atanhl", scope: !50, file: !50, line: 89, type: !46, flags: DIFlagPrototyped, spFlags: 0)
!261 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !262, file: !34, line: 491)
!262 = !DISubprogram(name: "cbrtl", scope: !50, file: !50, line: 152, type: !46, flags: DIFlagPrototyped, spFlags: 0)
!263 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !264, file: !34, line: 493)
!264 = !DISubprogram(name: "copysignl", scope: !50, file: !50, line: 196, type: !213, flags: DIFlagPrototyped, spFlags: 0)
!265 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !266, file: !34, line: 495)
!266 = !DISubprogram(name: "erfl", scope: !50, file: !50, line: 228, type: !46, flags: DIFlagPrototyped, spFlags: 0)
!267 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !268, file: !34, line: 496)
!268 = !DISubprogram(name: "erfcl", scope: !50, file: !50, line: 229, type: !46, flags: DIFlagPrototyped, spFlags: 0)
!269 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !270, file: !34, line: 497)
!270 = !DISubprogram(name: "exp2l", scope: !50, file: !50, line: 130, type: !46, flags: DIFlagPrototyped, spFlags: 0)
!271 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !272, file: !34, line: 498)
!272 = !DISubprogram(name: "expm1l", scope: !50, file: !50, line: 119, type: !46, flags: DIFlagPrototyped, spFlags: 0)
!273 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !274, file: !34, line: 499)
!274 = !DISubprogram(name: "fdiml", scope: !50, file: !50, line: 326, type: !213, flags: DIFlagPrototyped, spFlags: 0)
!275 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !276, file: !34, line: 500)
!276 = !DISubprogram(name: "fmal", scope: !50, file: !50, line: 335, type: !277, flags: DIFlagPrototyped, spFlags: 0)
!277 = !DISubroutineType(types: !278)
!278 = !{!33, !33, !33, !33}
!279 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !280, file: !34, line: 501)
!280 = !DISubprogram(name: "fmaxl", scope: !50, file: !50, line: 329, type: !213, flags: DIFlagPrototyped, spFlags: 0)
!281 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !282, file: !34, line: 502)
!282 = !DISubprogram(name: "fminl", scope: !50, file: !50, line: 332, type: !213, flags: DIFlagPrototyped, spFlags: 0)
!283 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !284, file: !34, line: 503)
!284 = !DISubprogram(name: "hypotl", scope: !50, file: !50, line: 147, type: !213, flags: DIFlagPrototyped, spFlags: 0)
!285 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !286, file: !34, line: 504)
!286 = !DISubprogram(name: "ilogbl", scope: !50, file: !50, line: 280, type: !287, flags: DIFlagPrototyped, spFlags: 0)
!287 = !DISubroutineType(types: !288)
!288 = !{!80, !33}
!289 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !290, file: !34, line: 505)
!290 = !DISubprogram(name: "lgammal", scope: !50, file: !50, line: 230, type: !46, flags: DIFlagPrototyped, spFlags: 0)
!291 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !292, file: !34, line: 506)
!292 = !DISubprogram(name: "llrintl", scope: !50, file: !50, line: 316, type: !293, flags: DIFlagPrototyped, spFlags: 0)
!293 = !DISubroutineType(types: !294)
!294 = !{!151, !33}
!295 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !296, file: !34, line: 507)
!296 = !DISubprogram(name: "llroundl", scope: !50, file: !50, line: 322, type: !293, flags: DIFlagPrototyped, spFlags: 0)
!297 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !298, file: !34, line: 508)
!298 = !DISubprogram(name: "log1pl", scope: !50, file: !50, line: 122, type: !46, flags: DIFlagPrototyped, spFlags: 0)
!299 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !300, file: !34, line: 509)
!300 = !DISubprogram(name: "log2l", scope: !50, file: !50, line: 133, type: !46, flags: DIFlagPrototyped, spFlags: 0)
!301 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !302, file: !34, line: 510)
!302 = !DISubprogram(name: "logbl", scope: !50, file: !50, line: 125, type: !46, flags: DIFlagPrototyped, spFlags: 0)
!303 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !304, file: !34, line: 511)
!304 = !DISubprogram(name: "lrintl", scope: !50, file: !50, line: 314, type: !305, flags: DIFlagPrototyped, spFlags: 0)
!305 = !DISubroutineType(types: !306)
!306 = !{!19, !33}
!307 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !308, file: !34, line: 512)
!308 = !DISubprogram(name: "lroundl", scope: !50, file: !50, line: 320, type: !305, flags: DIFlagPrototyped, spFlags: 0)
!309 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !310, file: !34, line: 513)
!310 = !DISubprogram(name: "nanl", scope: !50, file: !50, line: 201, type: !311, flags: DIFlagPrototyped, spFlags: 0)
!311 = !DISubroutineType(types: !312)
!312 = !{!33, !170}
!313 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !314, file: !34, line: 514)
!314 = !DISubprogram(name: "nearbyintl", scope: !50, file: !50, line: 294, type: !46, flags: DIFlagPrototyped, spFlags: 0)
!315 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !316, file: !34, line: 515)
!316 = !DISubprogram(name: "nextafterl", scope: !50, file: !50, line: 259, type: !213, flags: DIFlagPrototyped, spFlags: 0)
!317 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !318, file: !34, line: 516)
!318 = !DISubprogram(name: "nexttowardl", scope: !50, file: !50, line: 261, type: !213, flags: DIFlagPrototyped, spFlags: 0)
!319 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !320, file: !34, line: 517)
!320 = !DISubprogram(name: "remainderl", scope: !50, file: !50, line: 272, type: !213, flags: DIFlagPrototyped, spFlags: 0)
!321 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !322, file: !34, line: 518)
!322 = !DISubprogram(name: "remquol", scope: !50, file: !50, line: 307, type: !323, flags: DIFlagPrototyped, spFlags: 0)
!323 = !DISubroutineType(types: !324)
!324 = !{!33, !33, !33, !79}
!325 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !326, file: !34, line: 519)
!326 = !DISubprogram(name: "rintl", scope: !50, file: !50, line: 256, type: !46, flags: DIFlagPrototyped, spFlags: 0)
!327 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !328, file: !34, line: 520)
!328 = !DISubprogram(name: "roundl", scope: !50, file: !50, line: 298, type: !46, flags: DIFlagPrototyped, spFlags: 0)
!329 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !330, file: !34, line: 521)
!330 = !DISubprogram(name: "scalblnl", scope: !50, file: !50, line: 290, type: !331, flags: DIFlagPrototyped, spFlags: 0)
!331 = !DISubroutineType(types: !332)
!332 = !{!33, !33, !19}
!333 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !334, file: !34, line: 522)
!334 = !DISubprogram(name: "scalbnl", scope: !50, file: !50, line: 276, type: !235, flags: DIFlagPrototyped, spFlags: 0)
!335 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !336, file: !34, line: 523)
!336 = !DISubprogram(name: "tgammal", scope: !50, file: !50, line: 235, type: !46, flags: DIFlagPrototyped, spFlags: 0)
!337 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !338, file: !34, line: 524)
!338 = !DISubprogram(name: "truncl", scope: !50, file: !50, line: 302, type: !46, flags: DIFlagPrototyped, spFlags: 0)
!339 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !22, file: !340, line: 100)
!340 = !DIFile(filename: "clang_llvm/build_dfsan_full/include/c++/v1/cstdlib", directory: "/home/mcopik/projects")
!341 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !342, file: !340, line: 101)
!342 = !DIDerivedType(tag: DW_TAG_typedef, name: "div_t", file: !343, line: 62, baseType: !344)
!343 = !DIFile(filename: "/usr/include/stdlib.h", directory: "")
!344 = !DICompositeType(tag: DW_TAG_structure_type, file: !343, line: 58, flags: DIFlagFwdDecl, identifier: "_ZTS5div_t")
!345 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !346, file: !340, line: 102)
!346 = !DIDerivedType(tag: DW_TAG_typedef, name: "ldiv_t", file: !343, line: 70, baseType: !347)
!347 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !343, line: 66, size: 128, flags: DIFlagTypePassByValue | DIFlagTrivial, elements: !348, identifier: "_ZTS6ldiv_t")
!348 = !{!349, !350}
!349 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !347, file: !343, line: 68, baseType: !19, size: 64)
!350 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !347, file: !343, line: 69, baseType: !19, size: 64, offset: 64)
!351 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !352, file: !340, line: 104)
!352 = !DIDerivedType(tag: DW_TAG_typedef, name: "lldiv_t", file: !343, line: 80, baseType: !353)
!353 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !343, line: 76, size: 128, flags: DIFlagTypePassByValue | DIFlagTrivial, elements: !354, identifier: "_ZTS7lldiv_t")
!354 = !{!355, !356}
!355 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !353, file: !343, line: 78, baseType: !151, size: 64)
!356 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !353, file: !343, line: 79, baseType: !151, size: 64, offset: 64)
!357 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !358, file: !340, line: 106)
!358 = !DISubprogram(name: "atof", scope: !343, file: !343, line: 101, type: !168, flags: DIFlagPrototyped, spFlags: 0)
!359 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !360, file: !340, line: 107)
!360 = !DISubprogram(name: "atoi", scope: !343, file: !343, line: 104, type: !361, flags: DIFlagPrototyped, spFlags: 0)
!361 = !DISubroutineType(types: !362)
!362 = !{!80, !170}
!363 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !364, file: !340, line: 108)
!364 = !DISubprogram(name: "atol", scope: !343, file: !343, line: 107, type: !365, flags: DIFlagPrototyped, spFlags: 0)
!365 = !DISubroutineType(types: !366)
!366 = !{!19, !170}
!367 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !368, file: !340, line: 110)
!368 = !DISubprogram(name: "atoll", scope: !343, file: !343, line: 112, type: !369, flags: DIFlagPrototyped, spFlags: 0)
!369 = !DISubroutineType(types: !370)
!370 = !{!151, !170}
!371 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !372, file: !340, line: 112)
!372 = !DISubprogram(name: "strtod", scope: !343, file: !343, line: 117, type: !373, flags: DIFlagPrototyped, spFlags: 0)
!373 = !DISubroutineType(types: !374)
!374 = !{!43, !375, !376}
!375 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !170)
!376 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !377)
!377 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !378, size: 64)
!378 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !172, size: 64)
!379 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !380, file: !340, line: 113)
!380 = !DISubprogram(name: "strtof", scope: !343, file: !343, line: 123, type: !381, flags: DIFlagPrototyped, spFlags: 0)
!381 = !DISubroutineType(types: !382)
!382 = !{!40, !375, !376}
!383 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !384, file: !340, line: 114)
!384 = !DISubprogram(name: "strtold", scope: !343, file: !343, line: 126, type: !385, flags: DIFlagPrototyped, spFlags: 0)
!385 = !DISubroutineType(types: !386)
!386 = !{!33, !375, !376}
!387 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !388, file: !340, line: 115)
!388 = !DISubprogram(name: "strtol", scope: !343, file: !343, line: 176, type: !389, flags: DIFlagPrototyped, spFlags: 0)
!389 = !DISubroutineType(types: !390)
!390 = !{!19, !375, !376, !80}
!391 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !392, file: !340, line: 117)
!392 = !DISubprogram(name: "strtoll", scope: !343, file: !343, line: 200, type: !393, flags: DIFlagPrototyped, spFlags: 0)
!393 = !DISubroutineType(types: !394)
!394 = !{!151, !375, !376, !80}
!395 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !396, file: !340, line: 119)
!396 = !DISubprogram(name: "strtoul", scope: !343, file: !343, line: 180, type: !397, flags: DIFlagPrototyped, spFlags: 0)
!397 = !DISubroutineType(types: !398)
!398 = !{!23, !375, !376, !80}
!399 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !400, file: !340, line: 121)
!400 = !DISubprogram(name: "strtoull", scope: !343, file: !343, line: 205, type: !401, flags: DIFlagPrototyped, spFlags: 0)
!401 = !DISubroutineType(types: !402)
!402 = !{!403, !375, !376, !80}
!403 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!404 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !405, file: !340, line: 123)
!405 = !DISubprogram(name: "rand", scope: !343, file: !343, line: 453, type: !406, flags: DIFlagPrototyped, spFlags: 0)
!406 = !DISubroutineType(types: !407)
!407 = !{!80}
!408 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !409, file: !340, line: 124)
!409 = !DISubprogram(name: "srand", scope: !343, file: !343, line: 455, type: !410, flags: DIFlagPrototyped, spFlags: 0)
!410 = !DISubroutineType(types: !411)
!411 = !{null, !412}
!412 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!413 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !414, file: !340, line: 125)
!414 = !DISubprogram(name: "calloc", scope: !343, file: !343, line: 541, type: !415, flags: DIFlagPrototyped, spFlags: 0)
!415 = !DISubroutineType(types: !416)
!416 = !{!417, !22, !22}
!417 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!418 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !419, file: !340, line: 126)
!419 = !DISubprogram(name: "free", scope: !343, file: !343, line: 563, type: !420, flags: DIFlagPrototyped, spFlags: 0)
!420 = !DISubroutineType(types: !421)
!421 = !{null, !417}
!422 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !423, file: !340, line: 127)
!423 = !DISubprogram(name: "malloc", scope: !343, file: !343, line: 539, type: !424, flags: DIFlagPrototyped, spFlags: 0)
!424 = !DISubroutineType(types: !425)
!425 = !{!417, !22}
!426 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !427, file: !340, line: 128)
!427 = !DISubprogram(name: "realloc", scope: !343, file: !343, line: 549, type: !428, flags: DIFlagPrototyped, spFlags: 0)
!428 = !DISubroutineType(types: !429)
!429 = !{!417, !417, !22}
!430 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !431, file: !340, line: 129)
!431 = !DISubprogram(name: "abort", scope: !343, file: !343, line: 588, type: !432, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!432 = !DISubroutineType(types: !433)
!433 = !{null}
!434 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !435, file: !340, line: 130)
!435 = !DISubprogram(name: "atexit", scope: !343, file: !343, line: 592, type: !436, flags: DIFlagPrototyped, spFlags: 0)
!436 = !DISubroutineType(types: !437)
!437 = !{!80, !438}
!438 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !432, size: 64)
!439 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !440, file: !340, line: 131)
!440 = !DISubprogram(name: "exit", scope: !343, file: !343, line: 614, type: !441, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!441 = !DISubroutineType(types: !442)
!442 = !{null, !80}
!443 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !444, file: !340, line: 132)
!444 = !DISubprogram(name: "_Exit", scope: !343, file: !343, line: 626, type: !441, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!445 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !446, file: !340, line: 134)
!446 = !DISubprogram(name: "getenv", scope: !343, file: !343, line: 631, type: !447, flags: DIFlagPrototyped, spFlags: 0)
!447 = !DISubroutineType(types: !448)
!448 = !{!378, !170}
!449 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !450, file: !340, line: 135)
!450 = !DISubprogram(name: "system", scope: !343, file: !343, line: 781, type: !361, flags: DIFlagPrototyped, spFlags: 0)
!451 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !452, file: !340, line: 137)
!452 = !DISubprogram(name: "bsearch", scope: !343, file: !343, line: 817, type: !453, flags: DIFlagPrototyped, spFlags: 0)
!453 = !DISubroutineType(types: !454)
!454 = !{!417, !455, !455, !22, !22, !457}
!455 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !456, size: 64)
!456 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!457 = !DIDerivedType(tag: DW_TAG_typedef, name: "__compar_fn_t", file: !343, line: 805, baseType: !458)
!458 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !459, size: 64)
!459 = !DISubroutineType(types: !460)
!460 = !{!80, !455, !455}
!461 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !462, file: !340, line: 138)
!462 = !DISubprogram(name: "qsort", scope: !343, file: !343, line: 827, type: !463, flags: DIFlagPrototyped, spFlags: 0)
!463 = !DISubroutineType(types: !464)
!464 = !{null, !417, !22, !22, !457}
!465 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !466, file: !340, line: 139)
!466 = !DISubprogram(name: "abs", linkageName: "_Z3absx", scope: !467, file: !467, line: 113, type: !468, flags: DIFlagPrototyped, spFlags: 0)
!467 = !DIFile(filename: "clang_llvm/build_dfsan_full/include/c++/v1/stdlib.h", directory: "/home/mcopik/projects")
!468 = !DISubroutineType(types: !469)
!469 = !{!151, !151}
!470 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !471, file: !340, line: 140)
!471 = !DISubprogram(name: "labs", scope: !343, file: !343, line: 838, type: !472, flags: DIFlagPrototyped, spFlags: 0)
!472 = !DISubroutineType(types: !473)
!473 = !{!19, !19}
!474 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !475, file: !340, line: 142)
!475 = !DISubprogram(name: "llabs", scope: !343, file: !343, line: 841, type: !468, flags: DIFlagPrototyped, spFlags: 0)
!476 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !477, file: !340, line: 144)
!477 = !DISubprogram(name: "div", linkageName: "_Z3divxx", scope: !467, file: !467, line: 118, type: !478, flags: DIFlagPrototyped, spFlags: 0)
!478 = !DISubroutineType(types: !479)
!479 = !{!352, !151, !151}
!480 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !481, file: !340, line: 145)
!481 = !DISubprogram(name: "ldiv", scope: !343, file: !343, line: 851, type: !482, flags: DIFlagPrototyped, spFlags: 0)
!482 = !DISubroutineType(types: !483)
!483 = !{!346, !19, !19}
!484 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !485, file: !340, line: 147)
!485 = !DISubprogram(name: "lldiv", scope: !343, file: !343, line: 855, type: !478, flags: DIFlagPrototyped, spFlags: 0)
!486 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !487, file: !340, line: 149)
!487 = !DISubprogram(name: "mblen", scope: !343, file: !343, line: 919, type: !488, flags: DIFlagPrototyped, spFlags: 0)
!488 = !DISubroutineType(types: !489)
!489 = !{!80, !170, !22}
!490 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !491, file: !340, line: 150)
!491 = !DISubprogram(name: "mbtowc", scope: !343, file: !343, line: 922, type: !492, flags: DIFlagPrototyped, spFlags: 0)
!492 = !DISubroutineType(types: !493)
!493 = !{!80, !494, !375, !22}
!494 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !495)
!495 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !496, size: 64)
!496 = !DIBasicType(name: "wchar_t", size: 32, encoding: DW_ATE_signed)
!497 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !498, file: !340, line: 151)
!498 = !DISubprogram(name: "wctomb", scope: !343, file: !343, line: 926, type: !499, flags: DIFlagPrototyped, spFlags: 0)
!499 = !DISubroutineType(types: !500)
!500 = !{!80, !378, !496}
!501 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !502, file: !340, line: 152)
!502 = !DISubprogram(name: "mbstowcs", scope: !343, file: !343, line: 930, type: !503, flags: DIFlagPrototyped, spFlags: 0)
!503 = !DISubroutineType(types: !504)
!504 = !{!22, !494, !375, !22}
!505 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !506, file: !340, line: 153)
!506 = !DISubprogram(name: "wcstombs", scope: !343, file: !343, line: 933, type: !507, flags: DIFlagPrototyped, spFlags: 0)
!507 = !DISubroutineType(types: !508)
!508 = !{!22, !509, !510, !22}
!509 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !378)
!510 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !511)
!511 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !512, size: 64)
!512 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !496)
!513 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !514, file: !340, line: 155)
!514 = !DISubprogram(name: "at_quick_exit", scope: !343, file: !343, line: 597, type: !436, flags: DIFlagPrototyped, spFlags: 0)
!515 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !516, file: !340, line: 156)
!516 = !DISubprogram(name: "quick_exit", scope: !343, file: !343, line: 620, type: !441, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!517 = !{i32 2, !"Dwarf Version", i32 4}
!518 = !{i32 2, !"Debug Info Version", i32 3}
!519 = !{i32 1, !"wchar_size", i32 4}
!520 = !{!"clang version 8.0.0 (git@github.com:llvm-mirror/clang.git fd01d8b9288b3558a597daeb0cb4481b37c5bf68) (git@github.com:llvm-mirror/LLVM.git 7135d8b482d3d0d1a8c50111eebb9b207e92a8bc)"}
!521 = distinct !DISubprogram(name: "g", linkageName: "_Z1gii", scope: !3, file: !3, line: 9, type: !522, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!522 = !DISubroutineType(types: !523)
!523 = !{!80, !80, !80}
!524 = !DILocalVariable(name: "x", arg: 1, scope: !521, file: !3, line: 9, type: !80)
!525 = !DILocation(line: 9, column: 11, scope: !521)
!526 = !DILocalVariable(name: "y", arg: 2, scope: !521, file: !3, line: 9, type: !80)
!527 = !DILocation(line: 9, column: 18, scope: !521)
!528 = !DILocation(line: 11, column: 12, scope: !521)
!529 = !DILocation(line: 11, column: 20, scope: !521)
!530 = !DILocation(line: 11, column: 18, scope: !521)
!531 = !DILocation(line: 11, column: 24, scope: !521)
!532 = !DILocation(line: 11, column: 26, scope: !521)
!533 = !DILocation(line: 11, column: 5, scope: !521)
!534 = distinct !DISubprogram(name: "g2", linkageName: "_Z2g2ii", scope: !3, file: !3, line: 14, type: !522, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!535 = !DILocalVariable(name: "x", arg: 1, scope: !534, file: !3, line: 14, type: !80)
!536 = !DILocation(line: 14, column: 12, scope: !534)
!537 = !DILocalVariable(name: "y", arg: 2, scope: !534, file: !3, line: 14, type: !80)
!538 = !DILocation(line: 14, column: 19, scope: !534)
!539 = !DILocation(line: 16, column: 12, scope: !534)
!540 = !DILocation(line: 16, column: 16, scope: !534)
!541 = !DILocation(line: 16, column: 14, scope: !534)
!542 = !DILocation(line: 16, column: 20, scope: !534)
!543 = !DILocation(line: 16, column: 18, scope: !534)
!544 = !DILocation(line: 16, column: 5, scope: !534)
!545 = distinct !DISubprogram(name: "f", linkageName: "_Z1fii", scope: !3, file: !3, line: 36, type: !522, scopeLine: 37, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!546 = !DILocalVariable(name: "x1", arg: 1, scope: !545, file: !3, line: 36, type: !80)
!547 = !DILocation(line: 36, column: 11, scope: !545)
!548 = !DILocalVariable(name: "x2", arg: 2, scope: !545, file: !3, line: 36, type: !80)
!549 = !DILocation(line: 36, column: 19, scope: !545)
!550 = !DILocalVariable(name: "tmp", scope: !545, file: !3, line: 38, type: !80)
!551 = !DILocation(line: 38, column: 9, scope: !545)
!552 = !DILocalVariable(name: "i", scope: !553, file: !3, line: 39, type: !80)
!553 = distinct !DILexicalBlock(scope: !545, file: !3, line: 39, column: 5)
!554 = !DILocation(line: 39, column: 13, scope: !553)
!555 = !DILocation(line: 39, column: 9, scope: !553)
!556 = !DILocation(line: 39, column: 20, scope: !557)
!557 = distinct !DILexicalBlock(scope: !553, file: !3, line: 39, column: 5)
!558 = !DILocation(line: 39, column: 26, scope: !557)
!559 = !DILocation(line: 39, column: 31, scope: !557)
!560 = !DILocation(line: 39, column: 29, scope: !557)
!561 = !DILocation(line: 39, column: 24, scope: !557)
!562 = !DILocation(line: 39, column: 22, scope: !557)
!563 = !DILocation(line: 39, column: 5, scope: !553)
!564 = !DILocation(line: 40, column: 16, scope: !565)
!565 = distinct !DILexicalBlock(scope: !557, file: !3, line: 39, column: 44)
!566 = !DILocation(line: 40, column: 13, scope: !565)
!567 = !DILocation(line: 41, column: 5, scope: !565)
!568 = !DILocation(line: 39, column: 39, scope: !557)
!569 = !DILocation(line: 39, column: 5, scope: !557)
!570 = distinct !{!570, !563, !571}
!571 = !DILocation(line: 41, column: 5, scope: !553)
!572 = !DILocation(line: 42, column: 12, scope: !545)
!573 = !DILocation(line: 42, column: 5, scope: !545)
!574 = distinct !DISubprogram(name: "h", linkageName: "_Z1hii", scope: !3, file: !3, line: 47, type: !522, scopeLine: 48, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!575 = !DILocalVariable(name: "x1", arg: 1, scope: !574, file: !3, line: 47, type: !80)
!576 = !DILocation(line: 47, column: 11, scope: !574)
!577 = !DILocalVariable(name: "x2", arg: 2, scope: !574, file: !3, line: 47, type: !80)
!578 = !DILocation(line: 47, column: 19, scope: !574)
!579 = !DILocalVariable(name: "tmp", scope: !574, file: !3, line: 49, type: !80)
!580 = !DILocation(line: 49, column: 9, scope: !574)
!581 = !DILocalVariable(name: "i", scope: !582, file: !3, line: 50, type: !80)
!582 = distinct !DILexicalBlock(scope: !574, file: !3, line: 50, column: 5)
!583 = !DILocation(line: 50, column: 13, scope: !582)
!584 = !DILocation(line: 50, column: 9, scope: !582)
!585 = !DILocation(line: 50, column: 20, scope: !586)
!586 = distinct !DILexicalBlock(scope: !582, file: !3, line: 50, column: 5)
!587 = !DILocation(line: 50, column: 27, scope: !586)
!588 = !DILocation(line: 50, column: 24, scope: !586)
!589 = !DILocation(line: 50, column: 22, scope: !586)
!590 = !DILocation(line: 50, column: 5, scope: !582)
!591 = !DILocation(line: 51, column: 16, scope: !592)
!592 = distinct !DILexicalBlock(scope: !586, file: !3, line: 50, column: 40)
!593 = !DILocation(line: 51, column: 13, scope: !592)
!594 = !DILocation(line: 52, column: 5, scope: !592)
!595 = !DILocation(line: 50, column: 35, scope: !586)
!596 = !DILocation(line: 50, column: 5, scope: !586)
!597 = distinct !{!597, !590, !598}
!598 = !DILocation(line: 52, column: 5, scope: !582)
!599 = !DILocation(line: 53, column: 12, scope: !574)
!600 = !DILocation(line: 53, column: 5, scope: !574)
!601 = distinct !DISubprogram(name: "i", linkageName: "_Z1iP4test", scope: !3, file: !3, line: 58, type: !602, scopeLine: 59, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!602 = !DISubroutineType(types: !603)
!603 = !{!80, !604}
!604 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !605, size: 64)
!605 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "test", file: !3, line: 19, size: 64, flags: DIFlagTypePassByValue, elements: !606, identifier: "_ZTS4test")
!606 = !{!607, !608, !609, !613}
!607 = !DIDerivedType(tag: DW_TAG_member, name: "x1", scope: !605, file: !3, line: 21, baseType: !80, size: 32)
!608 = !DIDerivedType(tag: DW_TAG_member, name: "x2", scope: !605, file: !3, line: 21, baseType: !80, size: 32, offset: 32)
!609 = !DISubprogram(name: "test", scope: !605, file: !3, line: 23, type: !610, scopeLine: 23, flags: DIFlagPrototyped, spFlags: 0)
!610 = !DISubroutineType(types: !611)
!611 = !{null, !612, !80, !80}
!612 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !605, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!613 = !DISubprogram(name: "length", linkageName: "_ZN4test6lengthEv", scope: !605, file: !3, line: 28, type: !614, scopeLine: 28, flags: DIFlagPrototyped, spFlags: 0)
!614 = !DISubroutineType(types: !615)
!615 = !{!80, !612}
!616 = !DILocalVariable(name: "t", arg: 1, scope: !601, file: !3, line: 58, type: !604)
!617 = !DILocation(line: 58, column: 14, scope: !601)
!618 = !DILocalVariable(name: "tmp", scope: !601, file: !3, line: 60, type: !80)
!619 = !DILocation(line: 60, column: 9, scope: !601)
!620 = !DILocalVariable(name: "i", scope: !621, file: !3, line: 61, type: !80)
!621 = distinct !DILexicalBlock(scope: !601, file: !3, line: 61, column: 5)
!622 = !DILocation(line: 61, column: 13, scope: !621)
!623 = !DILocation(line: 61, column: 9, scope: !621)
!624 = !DILocation(line: 61, column: 20, scope: !625)
!625 = distinct !DILexicalBlock(scope: !621, file: !3, line: 61, column: 5)
!626 = !DILocation(line: 61, column: 24, scope: !625)
!627 = !DILocation(line: 61, column: 27, scope: !625)
!628 = !DILocation(line: 61, column: 22, scope: !625)
!629 = !DILocation(line: 61, column: 5, scope: !621)
!630 = !DILocation(line: 62, column: 16, scope: !631)
!631 = distinct !DILexicalBlock(scope: !625, file: !3, line: 61, column: 42)
!632 = !DILocation(line: 62, column: 13, scope: !631)
!633 = !DILocation(line: 63, column: 5, scope: !631)
!634 = !DILocation(line: 61, column: 37, scope: !625)
!635 = !DILocation(line: 61, column: 5, scope: !625)
!636 = distinct !{!636, !629, !637}
!637 = !DILocation(line: 63, column: 5, scope: !621)
!638 = !DILocation(line: 64, column: 12, scope: !601)
!639 = !DILocation(line: 64, column: 5, scope: !601)
!640 = distinct !DISubprogram(name: "length", linkageName: "_ZN4test6lengthEv", scope: !605, file: !3, line: 28, type: !614, scopeLine: 29, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, declaration: !613, retainedNodes: !4)
!641 = !DILocalVariable(name: "this", arg: 1, scope: !640, type: !604, flags: DIFlagArtificial | DIFlagObjectPointer)
!642 = !DILocation(line: 0, scope: !640)
!643 = !DILocation(line: 30, column: 16, scope: !640)
!644 = !DILocation(line: 30, column: 9, scope: !640)
!645 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 68, type: !646, scopeLine: 69, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!646 = !DISubroutineType(types: !647)
!647 = !{!80, !80, !377}
!648 = !DILocalVariable(name: "argc", arg: 1, scope: !645, file: !3, line: 68, type: !80)
!649 = !DILocation(line: 68, column: 14, scope: !645)
!650 = !DILocalVariable(name: "argv", arg: 2, scope: !645, file: !3, line: 68, type: !377)
!651 = !DILocation(line: 68, column: 28, scope: !645)
!652 = !DILocalVariable(name: "x1", scope: !645, file: !3, line: 70, type: !80)
!653 = !DILocation(line: 70, column: 9, scope: !645)
!654 = !DILocation(line: 70, column: 5, scope: !645)
!655 = !DILocation(line: 70, column: 26, scope: !645)
!656 = !DILocation(line: 70, column: 21, scope: !645)
!657 = !DILocalVariable(name: "x2", scope: !645, file: !3, line: 71, type: !80)
!658 = !DILocation(line: 71, column: 9, scope: !645)
!659 = !DILocation(line: 71, column: 5, scope: !645)
!660 = !DILocation(line: 71, column: 26, scope: !645)
!661 = !DILocation(line: 71, column: 21, scope: !645)
!662 = !DILocation(line: 72, column: 5, scope: !645)
!663 = !DILocation(line: 73, column: 5, scope: !645)
!664 = !DILocation(line: 74, column: 5, scope: !645)
!665 = !DILocalVariable(name: "y", scope: !645, file: !3, line: 75, type: !80)
!666 = !DILocation(line: 75, column: 9, scope: !645)
!667 = !DILocation(line: 75, column: 15, scope: !645)
!668 = !DILocation(line: 75, column: 14, scope: !645)
!669 = !DILocation(line: 75, column: 18, scope: !645)
!670 = !DILocalVariable(name: "t", scope: !645, file: !3, line: 76, type: !605)
!671 = !DILocation(line: 76, column: 10, scope: !645)
!672 = !DILocation(line: 76, column: 12, scope: !645)
!673 = !DILocation(line: 76, column: 16, scope: !645)
!674 = !DILocation(line: 79, column: 7, scope: !645)
!675 = !DILocation(line: 79, column: 15, scope: !645)
!676 = !DILocation(line: 79, column: 5, scope: !645)
!677 = !DILocation(line: 80, column: 7, scope: !645)
!678 = !DILocation(line: 80, column: 12, scope: !645)
!679 = !DILocation(line: 80, column: 10, scope: !645)
!680 = !DILocation(line: 80, column: 5, scope: !645)
!681 = !DILocation(line: 82, column: 7, scope: !645)
!682 = !DILocation(line: 82, column: 5, scope: !645)
!683 = !DILocation(line: 83, column: 5, scope: !645)
!684 = !DILocation(line: 85, column: 5, scope: !645)
!685 = !DILocation(line: 87, column: 5, scope: !645)
!686 = distinct !DISubprogram(name: "register_variable<int>", linkageName: "_Z17register_variableIiEvPT_PKc", scope: !687, file: !687, line: 13, type: !688, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, templateParams: !690, retainedNodes: !4)
!687 = !DIFile(filename: "include/ExtrapInstrumenter.hpp", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!688 = !DISubroutineType(types: !689)
!689 = !{null, !79, !170}
!690 = !{!691}
!691 = !DITemplateTypeParameter(name: "T", type: !80)
!692 = !DILocalVariable(name: "ptr", arg: 1, scope: !686, file: !687, line: 13, type: !79)
!693 = !DILocation(line: 13, column: 28, scope: !686)
!694 = !DILocalVariable(name: "name", arg: 2, scope: !686, file: !687, line: 13, type: !170)
!695 = !DILocation(line: 13, column: 46, scope: !686)
!696 = !DILocalVariable(name: "param_id", scope: !686, file: !687, line: 15, type: !697)
!697 = !DIDerivedType(tag: DW_TAG_typedef, name: "int32_t", file: !8, line: 26, baseType: !698)
!698 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int32_t", file: !10, line: 40, baseType: !80)
!699 = !DILocation(line: 15, column: 13, scope: !686)
!700 = !DILocation(line: 15, column: 24, scope: !686)
!701 = !DILocation(line: 16, column: 57, scope: !686)
!702 = !DILocation(line: 16, column: 31, scope: !686)
!703 = !DILocation(line: 16, column: 82, scope: !686)
!704 = !DILocation(line: 16, column: 86, scope: !686)
!705 = !DILocation(line: 16, column: 5, scope: !686)
!706 = !DILocation(line: 17, column: 1, scope: !686)
!707 = distinct !DISubprogram(name: "test", linkageName: "_ZN4testC2Eii", scope: !605, file: !3, line: 23, type: !610, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, declaration: !609, retainedNodes: !4)
!708 = !DILocalVariable(name: "this", arg: 1, scope: !707, type: !604, flags: DIFlagArtificial | DIFlagObjectPointer)
!709 = !DILocation(line: 0, scope: !707)
!710 = !DILocalVariable(name: "_x1", arg: 2, scope: !707, file: !3, line: 23, type: !80)
!711 = !DILocation(line: 23, column: 14, scope: !707)
!712 = !DILocalVariable(name: "_x2", arg: 3, scope: !707, file: !3, line: 23, type: !80)
!713 = !DILocation(line: 23, column: 23, scope: !707)
!714 = !DILocation(line: 24, column: 9, scope: !707)
!715 = !DILocation(line: 24, column: 12, scope: !707)
!716 = !DILocation(line: 25, column: 9, scope: !707)
!717 = !DILocation(line: 25, column: 12, scope: !707)
!718 = !DILocation(line: 26, column: 6, scope: !707)
