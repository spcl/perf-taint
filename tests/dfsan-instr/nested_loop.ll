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

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @_Z15perf_nest_constii(i32, i32) #0 !dbg !296 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  call void @llvm.dbg.declare(metadata i32* %3, metadata !299, metadata !DIExpression()), !dbg !300
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !301, metadata !DIExpression()), !dbg !302
  call void @llvm.dbg.declare(metadata i32* %5, metadata !303, metadata !DIExpression()), !dbg !304
  store i32 0, i32* %5, align 4, !dbg !304
  call void @llvm.dbg.declare(metadata i32* %6, metadata !305, metadata !DIExpression()), !dbg !307
  %8 = load i32, i32* %3, align 4, !dbg !308
  store i32 %8, i32* %6, align 4, !dbg !307
  br label %9, !dbg !309

; <label>:9:                                      ; preds = %25, %2
  %10 = load i32, i32* %6, align 4, !dbg !310
  %11 = load i32, i32* @global, align 4, !dbg !312
  %12 = icmp slt i32 %10, %11, !dbg !313
  br i1 %12, label %13, label %28, !dbg !314

; <label>:13:                                     ; preds = %9
  call void @llvm.dbg.declare(metadata i32* %7, metadata !315, metadata !DIExpression()), !dbg !317
  store i32 0, i32* %7, align 4, !dbg !317
  br label %14, !dbg !318

; <label>:14:                                     ; preds = %21, %13
  %15 = load i32, i32* %7, align 4, !dbg !319
  %16 = icmp slt i32 %15, 10, !dbg !321
  br i1 %16, label %17, label %24, !dbg !322

; <label>:17:                                     ; preds = %14
  %18 = load i32, i32* %6, align 4, !dbg !323
  %19 = load i32, i32* %5, align 4, !dbg !324
  %20 = add nsw i32 %19, %18, !dbg !324
  store i32 %20, i32* %5, align 4, !dbg !324
  br label %21, !dbg !325

; <label>:21:                                     ; preds = %17
  %22 = load i32, i32* %7, align 4, !dbg !326
  %23 = add nsw i32 %22, 1, !dbg !326
  store i32 %23, i32* %7, align 4, !dbg !326
  br label %14, !dbg !327, !llvm.loop !328

; <label>:24:                                     ; preds = %14
  br label %25, !dbg !329

; <label>:25:                                     ; preds = %24
  %26 = load i32, i32* %6, align 4, !dbg !330
  %27 = add nsw i32 %26, 1, !dbg !330
  store i32 %27, i32* %6, align 4, !dbg !330
  br label %9, !dbg !331, !llvm.loop !332

; <label>:28:                                     ; preds = %9
  %29 = load i32, i32* %5, align 4, !dbg !334
  ret i32 %29, !dbg !335
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @_Z16perf_nest_linearii(i32, i32) #0 !dbg !336 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  call void @llvm.dbg.declare(metadata i32* %3, metadata !337, metadata !DIExpression()), !dbg !338
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !339, metadata !DIExpression()), !dbg !340
  call void @llvm.dbg.declare(metadata i32* %5, metadata !341, metadata !DIExpression()), !dbg !342
  store i32 0, i32* %5, align 4, !dbg !342
  call void @llvm.dbg.declare(metadata i32* %6, metadata !343, metadata !DIExpression()), !dbg !345
  %8 = load i32, i32* %3, align 4, !dbg !346
  store i32 %8, i32* %6, align 4, !dbg !345
  br label %9, !dbg !347

; <label>:9:                                      ; preds = %26, %2
  %10 = load i32, i32* %6, align 4, !dbg !348
  %11 = load i32, i32* @global, align 4, !dbg !350
  %12 = icmp slt i32 %10, %11, !dbg !351
  br i1 %12, label %13, label %29, !dbg !352

; <label>:13:                                     ; preds = %9
  call void @llvm.dbg.declare(metadata i32* %7, metadata !353, metadata !DIExpression()), !dbg !355
  store i32 0, i32* %7, align 4, !dbg !355
  br label %14, !dbg !356

; <label>:14:                                     ; preds = %22, %13
  %15 = load i32, i32* %7, align 4, !dbg !357
  %16 = load i32, i32* @global, align 4, !dbg !359
  %17 = icmp slt i32 %15, %16, !dbg !360
  br i1 %17, label %18, label %25, !dbg !361

; <label>:18:                                     ; preds = %14
  %19 = load i32, i32* %6, align 4, !dbg !362
  %20 = load i32, i32* %5, align 4, !dbg !363
  %21 = add nsw i32 %20, %19, !dbg !363
  store i32 %21, i32* %5, align 4, !dbg !363
  br label %22, !dbg !364

; <label>:22:                                     ; preds = %18
  %23 = load i32, i32* %7, align 4, !dbg !365
  %24 = add nsw i32 %23, 1, !dbg !365
  store i32 %24, i32* %7, align 4, !dbg !365
  br label %14, !dbg !366, !llvm.loop !367

; <label>:25:                                     ; preds = %14
  br label %26, !dbg !368

; <label>:26:                                     ; preds = %25
  %27 = load i32, i32* %6, align 4, !dbg !369
  %28 = add nsw i32 %27, 1, !dbg !369
  store i32 %28, i32* %6, align 4, !dbg !369
  br label %9, !dbg !370, !llvm.loop !371

; <label>:29:                                     ; preds = %9
  %30 = load i32, i32* %5, align 4, !dbg !373
  ret i32 %30, !dbg !374
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @_Z15perf_nest_quadrii(i32, i32) #0 !dbg !375 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  call void @llvm.dbg.declare(metadata i32* %3, metadata !376, metadata !DIExpression()), !dbg !377
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !378, metadata !DIExpression()), !dbg !379
  call void @llvm.dbg.declare(metadata i32* %5, metadata !380, metadata !DIExpression()), !dbg !381
  store i32 0, i32* %5, align 4, !dbg !381
  call void @llvm.dbg.declare(metadata i32* %6, metadata !382, metadata !DIExpression()), !dbg !384
  %8 = load i32, i32* %3, align 4, !dbg !385
  store i32 %8, i32* %6, align 4, !dbg !384
  br label %9, !dbg !386

; <label>:9:                                      ; preds = %26, %2
  %10 = load i32, i32* %6, align 4, !dbg !387
  %11 = load i32, i32* @global, align 4, !dbg !389
  %12 = icmp slt i32 %10, %11, !dbg !390
  br i1 %12, label %13, label %29, !dbg !391

; <label>:13:                                     ; preds = %9
  call void @llvm.dbg.declare(metadata i32* %7, metadata !392, metadata !DIExpression()), !dbg !394
  store i32 0, i32* %7, align 4, !dbg !394
  br label %14, !dbg !395

; <label>:14:                                     ; preds = %22, %13
  %15 = load i32, i32* %7, align 4, !dbg !396
  %16 = load i32, i32* %4, align 4, !dbg !398
  %17 = icmp slt i32 %15, %16, !dbg !399
  br i1 %17, label %18, label %25, !dbg !400

; <label>:18:                                     ; preds = %14
  %19 = load i32, i32* %6, align 4, !dbg !401
  %20 = load i32, i32* %5, align 4, !dbg !402
  %21 = add nsw i32 %20, %19, !dbg !402
  store i32 %21, i32* %5, align 4, !dbg !402
  br label %22, !dbg !403

; <label>:22:                                     ; preds = %18
  %23 = load i32, i32* %7, align 4, !dbg !404
  %24 = add nsw i32 %23, 1, !dbg !404
  store i32 %24, i32* %7, align 4, !dbg !404
  br label %14, !dbg !405, !llvm.loop !406

; <label>:25:                                     ; preds = %14
  br label %26, !dbg !407

; <label>:26:                                     ; preds = %25
  %27 = load i32, i32* %6, align 4, !dbg !408
  %28 = add nsw i32 %27, 1, !dbg !408
  store i32 %28, i32* %6, align 4, !dbg !408
  br label %9, !dbg !409, !llvm.loop !410

; <label>:29:                                     ; preds = %9
  %30 = load i32, i32* %5, align 4, !dbg !412
  ret i32 %30, !dbg !413
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @_Z24perf_nest_multiple_quadrii(i32, i32) #0 !dbg !414 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  call void @llvm.dbg.declare(metadata i32* %3, metadata !415, metadata !DIExpression()), !dbg !416
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !417, metadata !DIExpression()), !dbg !418
  call void @llvm.dbg.declare(metadata i32* %5, metadata !419, metadata !DIExpression()), !dbg !420
  store i32 0, i32* %5, align 4, !dbg !420
  call void @llvm.dbg.declare(metadata i32* %6, metadata !421, metadata !DIExpression()), !dbg !423
  %8 = load i32, i32* %3, align 4, !dbg !424
  store i32 %8, i32* %6, align 4, !dbg !423
  br label %9, !dbg !425

; <label>:9:                                      ; preds = %26, %2
  %10 = load i32, i32* %6, align 4, !dbg !426
  %11 = load i32, i32* @global, align 4, !dbg !428
  %12 = icmp slt i32 %10, %11, !dbg !429
  br i1 %12, label %13, label %30, !dbg !430

; <label>:13:                                     ; preds = %9
  call void @llvm.dbg.declare(metadata i32* %7, metadata !431, metadata !DIExpression()), !dbg !433
  store i32 0, i32* %7, align 4, !dbg !433
  br label %14, !dbg !434

; <label>:14:                                     ; preds = %22, %13
  %15 = load i32, i32* %7, align 4, !dbg !435
  %16 = load i32, i32* %4, align 4, !dbg !437
  %17 = icmp slt i32 %15, %16, !dbg !438
  br i1 %17, label %18, label %25, !dbg !439

; <label>:18:                                     ; preds = %14
  %19 = load i32, i32* %6, align 4, !dbg !440
  %20 = load i32, i32* %5, align 4, !dbg !441
  %21 = add nsw i32 %20, %19, !dbg !441
  store i32 %21, i32* %5, align 4, !dbg !441
  br label %22, !dbg !442

; <label>:22:                                     ; preds = %18
  %23 = load i32, i32* %7, align 4, !dbg !443
  %24 = add nsw i32 %23, 1, !dbg !443
  store i32 %24, i32* %7, align 4, !dbg !443
  br label %14, !dbg !444, !llvm.loop !445

; <label>:25:                                     ; preds = %14
  br label %26, !dbg !446

; <label>:26:                                     ; preds = %25
  %27 = load i32, i32* %4, align 4, !dbg !447
  %28 = load i32, i32* %6, align 4, !dbg !448
  %29 = add nsw i32 %28, %27, !dbg !448
  store i32 %29, i32* %6, align 4, !dbg !448
  br label %9, !dbg !449, !llvm.loop !450

; <label>:30:                                     ; preds = %9
  %31 = load i32, i32* %5, align 4, !dbg !452
  ret i32 %31, !dbg !453
}

; Function Attrs: noinline norecurse optnone uwtable
define dso_local i32 @main(i32, i8**) #2 !dbg !454 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !457, metadata !DIExpression()), !dbg !458
  store i8** %1, i8*** %5, align 8
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !459, metadata !DIExpression()), !dbg !460
  call void @llvm.dbg.declare(metadata i32* %6, metadata !461, metadata !DIExpression()), !dbg !462
  %8 = bitcast i32* %6 to i8*, !dbg !463
  call void @llvm.var.annotation(i8* %8, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.1, i32 0, i32 0), i32 51), !dbg !463
  %9 = load i8**, i8*** %5, align 8, !dbg !464
  %10 = getelementptr inbounds i8*, i8** %9, i64 1, !dbg !464
  %11 = load i8*, i8** %10, align 8, !dbg !464
  %12 = call i32 @atoi(i8* %11) #7, !dbg !465
  store i32 %12, i32* %6, align 4, !dbg !462
  call void @llvm.dbg.declare(metadata i32* %7, metadata !466, metadata !DIExpression()), !dbg !467
  %13 = bitcast i32* %7 to i8*, !dbg !468
  call void @llvm.var.annotation(i8* %13, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.1, i32 0, i32 0), i32 52), !dbg !468
  %14 = load i8**, i8*** %5, align 8, !dbg !469
  %15 = getelementptr inbounds i8*, i8** %14, i64 2, !dbg !469
  %16 = load i8*, i8** %15, align 8, !dbg !469
  %17 = call i32 @atoi(i8* %16) #7, !dbg !470
  store i32 %17, i32* %7, align 4, !dbg !467
  call void @_Z17register_variableIiEvPT_PKc(i32* %6, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.2, i32 0, i32 0)), !dbg !471
  call void @_Z17register_variableIiEvPT_PKc(i32* %7, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.3, i32 0, i32 0)), !dbg !472
  %18 = load i32, i32* %6, align 4, !dbg !473
  %19 = load i32, i32* %7, align 4, !dbg !474
  %20 = call i32 @_Z15perf_nest_constii(i32 %18, i32 %19), !dbg !475
  %21 = load i32, i32* %6, align 4, !dbg !476
  %22 = load i32, i32* %7, align 4, !dbg !477
  %23 = call i32 @_Z15perf_nest_constii(i32 %21, i32 %22), !dbg !478
  %24 = load i32, i32* %6, align 4, !dbg !479
  %25 = load i32, i32* %7, align 4, !dbg !480
  %26 = call i32 @_Z16perf_nest_linearii(i32 %24, i32 %25), !dbg !481
  %27 = load i32, i32* %7, align 4, !dbg !482
  %28 = load i32, i32* %7, align 4, !dbg !483
  %29 = call i32 @_Z16perf_nest_linearii(i32 %27, i32 %28), !dbg !484
  %30 = load i32, i32* %6, align 4, !dbg !485
  %31 = load i32, i32* %7, align 4, !dbg !486
  %32 = call i32 @_Z15perf_nest_quadrii(i32 %30, i32 %31), !dbg !487
  %33 = load i32, i32* %7, align 4, !dbg !488
  %34 = load i32, i32* %6, align 4, !dbg !489
  %35 = call i32 @_Z15perf_nest_quadrii(i32 %33, i32 %34), !dbg !490
  %36 = load i32, i32* %6, align 4, !dbg !491
  %37 = load i32, i32* %7, align 4, !dbg !492
  %38 = call i32 @_Z24perf_nest_multiple_quadrii(i32 %36, i32 %37), !dbg !493
  ret i32 0, !dbg !494
}

; Function Attrs: nounwind
declare void @llvm.var.annotation(i8*, i8*, i8*, i32) #3

; Function Attrs: nounwind readonly
declare dso_local i32 @atoi(i8*) #4

; Function Attrs: noinline optnone uwtable
define linkonce_odr dso_local void @_Z17register_variableIiEvPT_PKc(i32*, i8*) #5 comdat !dbg !495 {
  %3 = alloca i32*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca i32, align 4
  store i32* %0, i32** %3, align 8
  call void @llvm.dbg.declare(metadata i32** %3, metadata !502, metadata !DIExpression()), !dbg !503
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !504, metadata !DIExpression()), !dbg !505
  call void @llvm.dbg.declare(metadata i32* %5, metadata !506, metadata !DIExpression()), !dbg !507
  %6 = call i32 @__dfsw_EXTRAP_VAR_ID(), !dbg !508
  store i32 %6, i32* %5, align 4, !dbg !507
  %7 = load i32*, i32** %3, align 8, !dbg !509
  %8 = bitcast i32* %7 to i8*, !dbg !510
  %9 = load i32, i32* %5, align 4, !dbg !511
  %10 = add nsw i32 %9, 1, !dbg !511
  store i32 %10, i32* %5, align 4, !dbg !511
  %11 = load i8*, i8** %4, align 8, !dbg !512
  call void @__dfsw_EXTRAP_STORE_LABEL(i8* %8, i32 4, i32 %9, i8* %11), !dbg !513
  ret void, !dbg !514
}

declare dso_local i32 @__dfsw_EXTRAP_VAR_ID() #6

declare dso_local void @__dfsw_EXTRAP_STORE_LABEL(i8*, i32, i32, i8*) #6

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { noinline norecurse optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind }
attributes #4 = { nounwind readonly "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { noinline optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #6 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #7 = { nounwind readonly }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!292, !293, !294}
!llvm.ident = !{!295}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "global", scope: !2, file: !3, line: 6, type: !20, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !3, producer: "clang version 8.0.0 (git@github.com:llvm-mirror/clang.git fd01d8b9288b3558a597daeb0cb4481b37c5bf68) (git@github.com:llvm-mirror/LLVM.git 7135d8b482d3d0d1a8c50111eebb9b207e92a8bc)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !5, globals: !12, imports: !13, nameTableKind: None)
!3 = !DIFile(filename: "tests/dfsan-instr/nested_loop.cpp", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!4 = !{}
!5 = !{!6}
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!7 = !DIDerivedType(tag: DW_TAG_typedef, name: "int8_t", file: !8, line: 24, baseType: !9)
!8 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-intn.h", directory: "")
!9 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int8_t", file: !10, line: 36, baseType: !11)
!10 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "")
!11 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!12 = !{!0}
!13 = !{!14, !22, !26, !33, !37, !42, !44, !52, !56, !60, !74, !78, !82, !86, !90, !95, !99, !103, !107, !111, !119, !123, !127, !129, !133, !137, !142, !148, !152, !156, !158, !166, !170, !178, !180, !184, !188, !192, !196, !201, !206, !211, !212, !213, !214, !216, !217, !218, !219, !220, !221, !222, !224, !228, !231, !234, !237, !239, !241, !243, !245, !247, !249, !251, !254, !256, !261, !265, !268, !271, !273, !275, !277, !279, !281, !283, !285, !287, !290}
!14 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !16, file: !21, line: 52)
!15 = !DINamespace(name: "std", scope: null)
!16 = !DISubprogram(name: "abs", scope: !17, file: !17, line: 837, type: !18, flags: DIFlagPrototyped, spFlags: 0)
!17 = !DIFile(filename: "/usr/include/stdlib.h", directory: "")
!18 = !DISubroutineType(types: !19)
!19 = !{!20, !20}
!20 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!21 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.3.0/../../../../include/c++/7.3.0/bits/std_abs.h", directory: "")
!22 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !23, file: !25, line: 127)
!23 = !DIDerivedType(tag: DW_TAG_typedef, name: "div_t", file: !17, line: 62, baseType: !24)
!24 = !DICompositeType(tag: DW_TAG_structure_type, file: !17, line: 58, flags: DIFlagFwdDecl, identifier: "_ZTS5div_t")
!25 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.3.0/../../../../include/c++/7.3.0/cstdlib", directory: "")
!26 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !27, file: !25, line: 128)
!27 = !DIDerivedType(tag: DW_TAG_typedef, name: "ldiv_t", file: !17, line: 70, baseType: !28)
!28 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !17, line: 66, size: 128, flags: DIFlagTypePassByValue | DIFlagTrivial, elements: !29, identifier: "_ZTS6ldiv_t")
!29 = !{!30, !32}
!30 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !28, file: !17, line: 68, baseType: !31, size: 64)
!31 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!32 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !28, file: !17, line: 69, baseType: !31, size: 64, offset: 64)
!33 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !34, file: !25, line: 130)
!34 = !DISubprogram(name: "abort", scope: !17, file: !17, line: 588, type: !35, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!35 = !DISubroutineType(types: !36)
!36 = !{null}
!37 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !38, file: !25, line: 134)
!38 = !DISubprogram(name: "atexit", scope: !17, file: !17, line: 592, type: !39, flags: DIFlagPrototyped, spFlags: 0)
!39 = !DISubroutineType(types: !40)
!40 = !{!20, !41}
!41 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !35, size: 64)
!42 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !43, file: !25, line: 137)
!43 = !DISubprogram(name: "at_quick_exit", scope: !17, file: !17, line: 597, type: !39, flags: DIFlagPrototyped, spFlags: 0)
!44 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !45, file: !25, line: 140)
!45 = !DISubprogram(name: "atof", scope: !17, file: !17, line: 101, type: !46, flags: DIFlagPrototyped, spFlags: 0)
!46 = !DISubroutineType(types: !47)
!47 = !{!48, !49}
!48 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!49 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !50, size: 64)
!50 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !51)
!51 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!52 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !53, file: !25, line: 141)
!53 = !DISubprogram(name: "atoi", scope: !17, file: !17, line: 104, type: !54, flags: DIFlagPrototyped, spFlags: 0)
!54 = !DISubroutineType(types: !55)
!55 = !{!20, !49}
!56 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !57, file: !25, line: 142)
!57 = !DISubprogram(name: "atol", scope: !17, file: !17, line: 107, type: !58, flags: DIFlagPrototyped, spFlags: 0)
!58 = !DISubroutineType(types: !59)
!59 = !{!31, !49}
!60 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !61, file: !25, line: 143)
!61 = !DISubprogram(name: "bsearch", scope: !17, file: !17, line: 817, type: !62, flags: DIFlagPrototyped, spFlags: 0)
!62 = !DISubroutineType(types: !63)
!63 = !{!64, !65, !65, !67, !67, !70}
!64 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!65 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !66, size: 64)
!66 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!67 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !68, line: 62, baseType: !69)
!68 = !DIFile(filename: "clang_llvm/build_release/lib/clang/8.0.0/include/stddef.h", directory: "/home/mcopik/projects")
!69 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!70 = !DIDerivedType(tag: DW_TAG_typedef, name: "__compar_fn_t", file: !17, line: 805, baseType: !71)
!71 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !72, size: 64)
!72 = !DISubroutineType(types: !73)
!73 = !{!20, !65, !65}
!74 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !75, file: !25, line: 144)
!75 = !DISubprogram(name: "calloc", scope: !17, file: !17, line: 541, type: !76, flags: DIFlagPrototyped, spFlags: 0)
!76 = !DISubroutineType(types: !77)
!77 = !{!64, !67, !67}
!78 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !79, file: !25, line: 145)
!79 = !DISubprogram(name: "div", scope: !17, file: !17, line: 849, type: !80, flags: DIFlagPrototyped, spFlags: 0)
!80 = !DISubroutineType(types: !81)
!81 = !{!23, !20, !20}
!82 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !83, file: !25, line: 146)
!83 = !DISubprogram(name: "exit", scope: !17, file: !17, line: 614, type: !84, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!84 = !DISubroutineType(types: !85)
!85 = !{null, !20}
!86 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !87, file: !25, line: 147)
!87 = !DISubprogram(name: "free", scope: !17, file: !17, line: 563, type: !88, flags: DIFlagPrototyped, spFlags: 0)
!88 = !DISubroutineType(types: !89)
!89 = !{null, !64}
!90 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !91, file: !25, line: 148)
!91 = !DISubprogram(name: "getenv", scope: !17, file: !17, line: 631, type: !92, flags: DIFlagPrototyped, spFlags: 0)
!92 = !DISubroutineType(types: !93)
!93 = !{!94, !49}
!94 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !51, size: 64)
!95 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !96, file: !25, line: 149)
!96 = !DISubprogram(name: "labs", scope: !17, file: !17, line: 838, type: !97, flags: DIFlagPrototyped, spFlags: 0)
!97 = !DISubroutineType(types: !98)
!98 = !{!31, !31}
!99 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !100, file: !25, line: 150)
!100 = !DISubprogram(name: "ldiv", scope: !17, file: !17, line: 851, type: !101, flags: DIFlagPrototyped, spFlags: 0)
!101 = !DISubroutineType(types: !102)
!102 = !{!27, !31, !31}
!103 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !104, file: !25, line: 151)
!104 = !DISubprogram(name: "malloc", scope: !17, file: !17, line: 539, type: !105, flags: DIFlagPrototyped, spFlags: 0)
!105 = !DISubroutineType(types: !106)
!106 = !{!64, !67}
!107 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !108, file: !25, line: 153)
!108 = !DISubprogram(name: "mblen", scope: !17, file: !17, line: 919, type: !109, flags: DIFlagPrototyped, spFlags: 0)
!109 = !DISubroutineType(types: !110)
!110 = !{!20, !49, !67}
!111 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !112, file: !25, line: 154)
!112 = !DISubprogram(name: "mbstowcs", scope: !17, file: !17, line: 930, type: !113, flags: DIFlagPrototyped, spFlags: 0)
!113 = !DISubroutineType(types: !114)
!114 = !{!67, !115, !118, !67}
!115 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !116)
!116 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !117, size: 64)
!117 = !DIBasicType(name: "wchar_t", size: 32, encoding: DW_ATE_signed)
!118 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !49)
!119 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !120, file: !25, line: 155)
!120 = !DISubprogram(name: "mbtowc", scope: !17, file: !17, line: 922, type: !121, flags: DIFlagPrototyped, spFlags: 0)
!121 = !DISubroutineType(types: !122)
!122 = !{!20, !115, !118, !67}
!123 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !124, file: !25, line: 157)
!124 = !DISubprogram(name: "qsort", scope: !17, file: !17, line: 827, type: !125, flags: DIFlagPrototyped, spFlags: 0)
!125 = !DISubroutineType(types: !126)
!126 = !{null, !64, !67, !67, !70}
!127 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !128, file: !25, line: 160)
!128 = !DISubprogram(name: "quick_exit", scope: !17, file: !17, line: 620, type: !84, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!129 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !130, file: !25, line: 163)
!130 = !DISubprogram(name: "rand", scope: !17, file: !17, line: 453, type: !131, flags: DIFlagPrototyped, spFlags: 0)
!131 = !DISubroutineType(types: !132)
!132 = !{!20}
!133 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !134, file: !25, line: 164)
!134 = !DISubprogram(name: "realloc", scope: !17, file: !17, line: 549, type: !135, flags: DIFlagPrototyped, spFlags: 0)
!135 = !DISubroutineType(types: !136)
!136 = !{!64, !64, !67}
!137 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !138, file: !25, line: 165)
!138 = !DISubprogram(name: "srand", scope: !17, file: !17, line: 455, type: !139, flags: DIFlagPrototyped, spFlags: 0)
!139 = !DISubroutineType(types: !140)
!140 = !{null, !141}
!141 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!142 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !143, file: !25, line: 166)
!143 = !DISubprogram(name: "strtod", scope: !17, file: !17, line: 117, type: !144, flags: DIFlagPrototyped, spFlags: 0)
!144 = !DISubroutineType(types: !145)
!145 = !{!48, !118, !146}
!146 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !147)
!147 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !94, size: 64)
!148 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !149, file: !25, line: 167)
!149 = !DISubprogram(name: "strtol", scope: !17, file: !17, line: 176, type: !150, flags: DIFlagPrototyped, spFlags: 0)
!150 = !DISubroutineType(types: !151)
!151 = !{!31, !118, !146, !20}
!152 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !153, file: !25, line: 168)
!153 = !DISubprogram(name: "strtoul", scope: !17, file: !17, line: 180, type: !154, flags: DIFlagPrototyped, spFlags: 0)
!154 = !DISubroutineType(types: !155)
!155 = !{!69, !118, !146, !20}
!156 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !157, file: !25, line: 169)
!157 = !DISubprogram(name: "system", scope: !17, file: !17, line: 781, type: !54, flags: DIFlagPrototyped, spFlags: 0)
!158 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !159, file: !25, line: 171)
!159 = !DISubprogram(name: "wcstombs", scope: !17, file: !17, line: 933, type: !160, flags: DIFlagPrototyped, spFlags: 0)
!160 = !DISubroutineType(types: !161)
!161 = !{!67, !162, !163, !67}
!162 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !94)
!163 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !164)
!164 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !165, size: 64)
!165 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !117)
!166 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !167, file: !25, line: 172)
!167 = !DISubprogram(name: "wctomb", scope: !17, file: !17, line: 926, type: !168, flags: DIFlagPrototyped, spFlags: 0)
!168 = !DISubroutineType(types: !169)
!169 = !{!20, !94, !117}
!170 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !171, entity: !172, file: !25, line: 200)
!171 = !DINamespace(name: "__gnu_cxx", scope: null)
!172 = !DIDerivedType(tag: DW_TAG_typedef, name: "lldiv_t", file: !17, line: 80, baseType: !173)
!173 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !17, line: 76, size: 128, flags: DIFlagTypePassByValue | DIFlagTrivial, elements: !174, identifier: "_ZTS7lldiv_t")
!174 = !{!175, !177}
!175 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !173, file: !17, line: 78, baseType: !176, size: 64)
!176 = !DIBasicType(name: "long long int", size: 64, encoding: DW_ATE_signed)
!177 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !173, file: !17, line: 79, baseType: !176, size: 64, offset: 64)
!178 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !171, entity: !179, file: !25, line: 206)
!179 = !DISubprogram(name: "_Exit", scope: !17, file: !17, line: 626, type: !84, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: 0)
!180 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !171, entity: !181, file: !25, line: 210)
!181 = !DISubprogram(name: "llabs", scope: !17, file: !17, line: 841, type: !182, flags: DIFlagPrototyped, spFlags: 0)
!182 = !DISubroutineType(types: !183)
!183 = !{!176, !176}
!184 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !171, entity: !185, file: !25, line: 216)
!185 = !DISubprogram(name: "lldiv", scope: !17, file: !17, line: 855, type: !186, flags: DIFlagPrototyped, spFlags: 0)
!186 = !DISubroutineType(types: !187)
!187 = !{!172, !176, !176}
!188 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !171, entity: !189, file: !25, line: 227)
!189 = !DISubprogram(name: "atoll", scope: !17, file: !17, line: 112, type: !190, flags: DIFlagPrototyped, spFlags: 0)
!190 = !DISubroutineType(types: !191)
!191 = !{!176, !49}
!192 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !171, entity: !193, file: !25, line: 228)
!193 = !DISubprogram(name: "strtoll", scope: !17, file: !17, line: 200, type: !194, flags: DIFlagPrototyped, spFlags: 0)
!194 = !DISubroutineType(types: !195)
!195 = !{!176, !118, !146, !20}
!196 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !171, entity: !197, file: !25, line: 229)
!197 = !DISubprogram(name: "strtoull", scope: !17, file: !17, line: 205, type: !198, flags: DIFlagPrototyped, spFlags: 0)
!198 = !DISubroutineType(types: !199)
!199 = !{!200, !118, !146, !20}
!200 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!201 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !171, entity: !202, file: !25, line: 231)
!202 = !DISubprogram(name: "strtof", scope: !17, file: !17, line: 123, type: !203, flags: DIFlagPrototyped, spFlags: 0)
!203 = !DISubroutineType(types: !204)
!204 = !{!205, !118, !146}
!205 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!206 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !171, entity: !207, file: !25, line: 232)
!207 = !DISubprogram(name: "strtold", scope: !17, file: !17, line: 126, type: !208, flags: DIFlagPrototyped, spFlags: 0)
!208 = !DISubroutineType(types: !209)
!209 = !{!210, !118, !146}
!210 = !DIBasicType(name: "long double", size: 128, encoding: DW_ATE_float)
!211 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !172, file: !25, line: 240)
!212 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !179, file: !25, line: 242)
!213 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !181, file: !25, line: 244)
!214 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !215, file: !25, line: 245)
!215 = !DISubprogram(name: "div", linkageName: "_ZN9__gnu_cxx3divExx", scope: !171, file: !25, line: 213, type: !186, flags: DIFlagPrototyped, spFlags: 0)
!216 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !185, file: !25, line: 246)
!217 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !189, file: !25, line: 248)
!218 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !202, file: !25, line: 249)
!219 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !193, file: !25, line: 250)
!220 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !197, file: !25, line: 251)
!221 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !207, file: !25, line: 252)
!222 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !7, file: !223, line: 48)
!223 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.3.0/../../../../include/c++/7.3.0/cstdint", directory: "")
!224 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !225, file: !223, line: 49)
!225 = !DIDerivedType(tag: DW_TAG_typedef, name: "int16_t", file: !8, line: 25, baseType: !226)
!226 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int16_t", file: !10, line: 38, baseType: !227)
!227 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!228 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !229, file: !223, line: 50)
!229 = !DIDerivedType(tag: DW_TAG_typedef, name: "int32_t", file: !8, line: 26, baseType: !230)
!230 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int32_t", file: !10, line: 40, baseType: !20)
!231 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !232, file: !223, line: 51)
!232 = !DIDerivedType(tag: DW_TAG_typedef, name: "int64_t", file: !8, line: 27, baseType: !233)
!233 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int64_t", file: !10, line: 43, baseType: !31)
!234 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !235, file: !223, line: 53)
!235 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast8_t", file: !236, line: 68, baseType: !11)
!236 = !DIFile(filename: "/usr/include/stdint.h", directory: "")
!237 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !238, file: !223, line: 54)
!238 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast16_t", file: !236, line: 70, baseType: !31)
!239 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !240, file: !223, line: 55)
!240 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast32_t", file: !236, line: 71, baseType: !31)
!241 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !242, file: !223, line: 56)
!242 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast64_t", file: !236, line: 72, baseType: !31)
!243 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !244, file: !223, line: 58)
!244 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least8_t", file: !236, line: 43, baseType: !11)
!245 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !246, file: !223, line: 59)
!246 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least16_t", file: !236, line: 44, baseType: !227)
!247 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !248, file: !223, line: 60)
!248 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least32_t", file: !236, line: 45, baseType: !20)
!249 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !250, file: !223, line: 61)
!250 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least64_t", file: !236, line: 47, baseType: !31)
!251 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !252, file: !223, line: 63)
!252 = !DIDerivedType(tag: DW_TAG_typedef, name: "intmax_t", file: !236, line: 111, baseType: !253)
!253 = !DIDerivedType(tag: DW_TAG_typedef, name: "__intmax_t", file: !10, line: 61, baseType: !31)
!254 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !255, file: !223, line: 64)
!255 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !236, line: 97, baseType: !31)
!256 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !257, file: !223, line: 66)
!257 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint8_t", file: !258, line: 24, baseType: !259)
!258 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "")
!259 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint8_t", file: !10, line: 37, baseType: !260)
!260 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!261 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !262, file: !223, line: 67)
!262 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint16_t", file: !258, line: 25, baseType: !263)
!263 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint16_t", file: !10, line: 39, baseType: !264)
!264 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!265 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !266, file: !223, line: 68)
!266 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !258, line: 26, baseType: !267)
!267 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !10, line: 41, baseType: !141)
!268 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !269, file: !223, line: 69)
!269 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", file: !258, line: 27, baseType: !270)
!270 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint64_t", file: !10, line: 44, baseType: !69)
!271 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !272, file: !223, line: 71)
!272 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast8_t", file: !236, line: 81, baseType: !260)
!273 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !274, file: !223, line: 72)
!274 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast16_t", file: !236, line: 83, baseType: !69)
!275 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !276, file: !223, line: 73)
!276 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast32_t", file: !236, line: 84, baseType: !69)
!277 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !278, file: !223, line: 74)
!278 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast64_t", file: !236, line: 85, baseType: !69)
!279 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !280, file: !223, line: 76)
!280 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least8_t", file: !236, line: 54, baseType: !260)
!281 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !282, file: !223, line: 77)
!282 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least16_t", file: !236, line: 55, baseType: !264)
!283 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !284, file: !223, line: 78)
!284 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least32_t", file: !236, line: 56, baseType: !141)
!285 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !286, file: !223, line: 79)
!286 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least64_t", file: !236, line: 58, baseType: !69)
!287 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !288, file: !223, line: 81)
!288 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintmax_t", file: !236, line: 112, baseType: !289)
!289 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uintmax_t", file: !10, line: 62, baseType: !69)
!290 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !15, entity: !291, file: !223, line: 82)
!291 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !236, line: 100, baseType: !69)
!292 = !{i32 2, !"Dwarf Version", i32 4}
!293 = !{i32 2, !"Debug Info Version", i32 3}
!294 = !{i32 1, !"wchar_size", i32 4}
!295 = !{!"clang version 8.0.0 (git@github.com:llvm-mirror/clang.git fd01d8b9288b3558a597daeb0cb4481b37c5bf68) (git@github.com:llvm-mirror/LLVM.git 7135d8b482d3d0d1a8c50111eebb9b207e92a8bc)"}
!296 = distinct !DISubprogram(name: "perf_nest_const", linkageName: "_Z15perf_nest_constii", scope: !3, file: !3, line: 9, type: !297, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!297 = !DISubroutineType(types: !298)
!298 = !{!20, !20, !20}
!299 = !DILocalVariable(name: "x", arg: 1, scope: !296, file: !3, line: 9, type: !20)
!300 = !DILocation(line: 9, column: 25, scope: !296)
!301 = !DILocalVariable(name: "y", arg: 2, scope: !296, file: !3, line: 9, type: !20)
!302 = !DILocation(line: 9, column: 32, scope: !296)
!303 = !DILocalVariable(name: "tmp", scope: !296, file: !3, line: 11, type: !20)
!304 = !DILocation(line: 11, column: 9, scope: !296)
!305 = !DILocalVariable(name: "i", scope: !306, file: !3, line: 12, type: !20)
!306 = distinct !DILexicalBlock(scope: !296, file: !3, line: 12, column: 5)
!307 = !DILocation(line: 12, column: 13, scope: !306)
!308 = !DILocation(line: 12, column: 17, scope: !306)
!309 = !DILocation(line: 12, column: 9, scope: !306)
!310 = !DILocation(line: 12, column: 20, scope: !311)
!311 = distinct !DILexicalBlock(scope: !306, file: !3, line: 12, column: 5)
!312 = !DILocation(line: 12, column: 24, scope: !311)
!313 = !DILocation(line: 12, column: 22, scope: !311)
!314 = !DILocation(line: 12, column: 5, scope: !306)
!315 = !DILocalVariable(name: "j", scope: !316, file: !3, line: 13, type: !20)
!316 = distinct !DILexicalBlock(scope: !311, file: !3, line: 13, column: 9)
!317 = !DILocation(line: 13, column: 17, scope: !316)
!318 = !DILocation(line: 13, column: 13, scope: !316)
!319 = !DILocation(line: 13, column: 24, scope: !320)
!320 = distinct !DILexicalBlock(scope: !316, file: !3, line: 13, column: 9)
!321 = !DILocation(line: 13, column: 26, scope: !320)
!322 = !DILocation(line: 13, column: 9, scope: !316)
!323 = !DILocation(line: 14, column: 20, scope: !320)
!324 = !DILocation(line: 14, column: 17, scope: !320)
!325 = !DILocation(line: 14, column: 13, scope: !320)
!326 = !DILocation(line: 13, column: 32, scope: !320)
!327 = !DILocation(line: 13, column: 9, scope: !320)
!328 = distinct !{!328, !322, !329}
!329 = !DILocation(line: 14, column: 20, scope: !316)
!330 = !DILocation(line: 12, column: 32, scope: !311)
!331 = !DILocation(line: 12, column: 5, scope: !311)
!332 = distinct !{!332, !314, !333}
!333 = !DILocation(line: 14, column: 20, scope: !306)
!334 = !DILocation(line: 15, column: 12, scope: !296)
!335 = !DILocation(line: 15, column: 5, scope: !296)
!336 = distinct !DISubprogram(name: "perf_nest_linear", linkageName: "_Z16perf_nest_linearii", scope: !3, file: !3, line: 19, type: !297, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!337 = !DILocalVariable(name: "x", arg: 1, scope: !336, file: !3, line: 19, type: !20)
!338 = !DILocation(line: 19, column: 26, scope: !336)
!339 = !DILocalVariable(name: "y", arg: 2, scope: !336, file: !3, line: 19, type: !20)
!340 = !DILocation(line: 19, column: 33, scope: !336)
!341 = !DILocalVariable(name: "tmp", scope: !336, file: !3, line: 21, type: !20)
!342 = !DILocation(line: 21, column: 9, scope: !336)
!343 = !DILocalVariable(name: "i", scope: !344, file: !3, line: 22, type: !20)
!344 = distinct !DILexicalBlock(scope: !336, file: !3, line: 22, column: 5)
!345 = !DILocation(line: 22, column: 13, scope: !344)
!346 = !DILocation(line: 22, column: 17, scope: !344)
!347 = !DILocation(line: 22, column: 9, scope: !344)
!348 = !DILocation(line: 22, column: 20, scope: !349)
!349 = distinct !DILexicalBlock(scope: !344, file: !3, line: 22, column: 5)
!350 = !DILocation(line: 22, column: 24, scope: !349)
!351 = !DILocation(line: 22, column: 22, scope: !349)
!352 = !DILocation(line: 22, column: 5, scope: !344)
!353 = !DILocalVariable(name: "j", scope: !354, file: !3, line: 23, type: !20)
!354 = distinct !DILexicalBlock(scope: !349, file: !3, line: 23, column: 9)
!355 = !DILocation(line: 23, column: 17, scope: !354)
!356 = !DILocation(line: 23, column: 13, scope: !354)
!357 = !DILocation(line: 23, column: 24, scope: !358)
!358 = distinct !DILexicalBlock(scope: !354, file: !3, line: 23, column: 9)
!359 = !DILocation(line: 23, column: 28, scope: !358)
!360 = !DILocation(line: 23, column: 26, scope: !358)
!361 = !DILocation(line: 23, column: 9, scope: !354)
!362 = !DILocation(line: 24, column: 20, scope: !358)
!363 = !DILocation(line: 24, column: 17, scope: !358)
!364 = !DILocation(line: 24, column: 13, scope: !358)
!365 = !DILocation(line: 23, column: 36, scope: !358)
!366 = !DILocation(line: 23, column: 9, scope: !358)
!367 = distinct !{!367, !361, !368}
!368 = !DILocation(line: 24, column: 20, scope: !354)
!369 = !DILocation(line: 22, column: 32, scope: !349)
!370 = !DILocation(line: 22, column: 5, scope: !349)
!371 = distinct !{!371, !352, !372}
!372 = !DILocation(line: 24, column: 20, scope: !344)
!373 = !DILocation(line: 25, column: 12, scope: !336)
!374 = !DILocation(line: 25, column: 5, scope: !336)
!375 = distinct !DISubprogram(name: "perf_nest_quadr", linkageName: "_Z15perf_nest_quadrii", scope: !3, file: !3, line: 29, type: !297, scopeLine: 30, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!376 = !DILocalVariable(name: "x", arg: 1, scope: !375, file: !3, line: 29, type: !20)
!377 = !DILocation(line: 29, column: 25, scope: !375)
!378 = !DILocalVariable(name: "y", arg: 2, scope: !375, file: !3, line: 29, type: !20)
!379 = !DILocation(line: 29, column: 32, scope: !375)
!380 = !DILocalVariable(name: "tmp", scope: !375, file: !3, line: 31, type: !20)
!381 = !DILocation(line: 31, column: 9, scope: !375)
!382 = !DILocalVariable(name: "i", scope: !383, file: !3, line: 32, type: !20)
!383 = distinct !DILexicalBlock(scope: !375, file: !3, line: 32, column: 5)
!384 = !DILocation(line: 32, column: 13, scope: !383)
!385 = !DILocation(line: 32, column: 17, scope: !383)
!386 = !DILocation(line: 32, column: 9, scope: !383)
!387 = !DILocation(line: 32, column: 20, scope: !388)
!388 = distinct !DILexicalBlock(scope: !383, file: !3, line: 32, column: 5)
!389 = !DILocation(line: 32, column: 24, scope: !388)
!390 = !DILocation(line: 32, column: 22, scope: !388)
!391 = !DILocation(line: 32, column: 5, scope: !383)
!392 = !DILocalVariable(name: "j", scope: !393, file: !3, line: 33, type: !20)
!393 = distinct !DILexicalBlock(scope: !388, file: !3, line: 33, column: 9)
!394 = !DILocation(line: 33, column: 17, scope: !393)
!395 = !DILocation(line: 33, column: 13, scope: !393)
!396 = !DILocation(line: 33, column: 24, scope: !397)
!397 = distinct !DILexicalBlock(scope: !393, file: !3, line: 33, column: 9)
!398 = !DILocation(line: 33, column: 28, scope: !397)
!399 = !DILocation(line: 33, column: 26, scope: !397)
!400 = !DILocation(line: 33, column: 9, scope: !393)
!401 = !DILocation(line: 34, column: 20, scope: !397)
!402 = !DILocation(line: 34, column: 17, scope: !397)
!403 = !DILocation(line: 34, column: 13, scope: !397)
!404 = !DILocation(line: 33, column: 31, scope: !397)
!405 = !DILocation(line: 33, column: 9, scope: !397)
!406 = distinct !{!406, !400, !407}
!407 = !DILocation(line: 34, column: 20, scope: !393)
!408 = !DILocation(line: 32, column: 32, scope: !388)
!409 = !DILocation(line: 32, column: 5, scope: !388)
!410 = distinct !{!410, !391, !411}
!411 = !DILocation(line: 34, column: 20, scope: !383)
!412 = !DILocation(line: 35, column: 12, scope: !375)
!413 = !DILocation(line: 35, column: 5, scope: !375)
!414 = distinct !DISubprogram(name: "perf_nest_multiple_quadr", linkageName: "_Z24perf_nest_multiple_quadrii", scope: !3, file: !3, line: 40, type: !297, scopeLine: 41, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!415 = !DILocalVariable(name: "x", arg: 1, scope: !414, file: !3, line: 40, type: !20)
!416 = !DILocation(line: 40, column: 34, scope: !414)
!417 = !DILocalVariable(name: "y", arg: 2, scope: !414, file: !3, line: 40, type: !20)
!418 = !DILocation(line: 40, column: 41, scope: !414)
!419 = !DILocalVariable(name: "tmp", scope: !414, file: !3, line: 42, type: !20)
!420 = !DILocation(line: 42, column: 9, scope: !414)
!421 = !DILocalVariable(name: "i", scope: !422, file: !3, line: 43, type: !20)
!422 = distinct !DILexicalBlock(scope: !414, file: !3, line: 43, column: 5)
!423 = !DILocation(line: 43, column: 13, scope: !422)
!424 = !DILocation(line: 43, column: 17, scope: !422)
!425 = !DILocation(line: 43, column: 9, scope: !422)
!426 = !DILocation(line: 43, column: 20, scope: !427)
!427 = distinct !DILexicalBlock(scope: !422, file: !3, line: 43, column: 5)
!428 = !DILocation(line: 43, column: 24, scope: !427)
!429 = !DILocation(line: 43, column: 22, scope: !427)
!430 = !DILocation(line: 43, column: 5, scope: !422)
!431 = !DILocalVariable(name: "j", scope: !432, file: !3, line: 44, type: !20)
!432 = distinct !DILexicalBlock(scope: !427, file: !3, line: 44, column: 9)
!433 = !DILocation(line: 44, column: 17, scope: !432)
!434 = !DILocation(line: 44, column: 13, scope: !432)
!435 = !DILocation(line: 44, column: 24, scope: !436)
!436 = distinct !DILexicalBlock(scope: !432, file: !3, line: 44, column: 9)
!437 = !DILocation(line: 44, column: 28, scope: !436)
!438 = !DILocation(line: 44, column: 26, scope: !436)
!439 = !DILocation(line: 44, column: 9, scope: !432)
!440 = !DILocation(line: 45, column: 20, scope: !436)
!441 = !DILocation(line: 45, column: 17, scope: !436)
!442 = !DILocation(line: 45, column: 13, scope: !436)
!443 = !DILocation(line: 44, column: 31, scope: !436)
!444 = !DILocation(line: 44, column: 9, scope: !436)
!445 = distinct !{!445, !439, !446}
!446 = !DILocation(line: 45, column: 20, scope: !432)
!447 = !DILocation(line: 43, column: 37, scope: !427)
!448 = !DILocation(line: 43, column: 34, scope: !427)
!449 = !DILocation(line: 43, column: 5, scope: !427)
!450 = distinct !{!450, !430, !451}
!451 = !DILocation(line: 45, column: 20, scope: !422)
!452 = !DILocation(line: 46, column: 12, scope: !414)
!453 = !DILocation(line: 46, column: 5, scope: !414)
!454 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 49, type: !455, scopeLine: 50, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!455 = !DISubroutineType(types: !456)
!456 = !{!20, !20, !147}
!457 = !DILocalVariable(name: "argc", arg: 1, scope: !454, file: !3, line: 49, type: !20)
!458 = !DILocation(line: 49, column: 14, scope: !454)
!459 = !DILocalVariable(name: "argv", arg: 2, scope: !454, file: !3, line: 49, type: !147)
!460 = !DILocation(line: 49, column: 28, scope: !454)
!461 = !DILocalVariable(name: "x1", scope: !454, file: !3, line: 51, type: !20)
!462 = !DILocation(line: 51, column: 9, scope: !454)
!463 = !DILocation(line: 51, column: 5, scope: !454)
!464 = !DILocation(line: 51, column: 26, scope: !454)
!465 = !DILocation(line: 51, column: 21, scope: !454)
!466 = !DILocalVariable(name: "x2", scope: !454, file: !3, line: 52, type: !20)
!467 = !DILocation(line: 52, column: 9, scope: !454)
!468 = !DILocation(line: 52, column: 5, scope: !454)
!469 = !DILocation(line: 52, column: 26, scope: !454)
!470 = !DILocation(line: 52, column: 21, scope: !454)
!471 = !DILocation(line: 53, column: 5, scope: !454)
!472 = !DILocation(line: 54, column: 5, scope: !454)
!473 = !DILocation(line: 57, column: 21, scope: !454)
!474 = !DILocation(line: 57, column: 25, scope: !454)
!475 = !DILocation(line: 57, column: 5, scope: !454)
!476 = !DILocation(line: 58, column: 21, scope: !454)
!477 = !DILocation(line: 58, column: 25, scope: !454)
!478 = !DILocation(line: 58, column: 5, scope: !454)
!479 = !DILocation(line: 60, column: 22, scope: !454)
!480 = !DILocation(line: 60, column: 26, scope: !454)
!481 = !DILocation(line: 60, column: 5, scope: !454)
!482 = !DILocation(line: 61, column: 22, scope: !454)
!483 = !DILocation(line: 61, column: 26, scope: !454)
!484 = !DILocation(line: 61, column: 5, scope: !454)
!485 = !DILocation(line: 63, column: 21, scope: !454)
!486 = !DILocation(line: 63, column: 25, scope: !454)
!487 = !DILocation(line: 63, column: 5, scope: !454)
!488 = !DILocation(line: 64, column: 21, scope: !454)
!489 = !DILocation(line: 64, column: 25, scope: !454)
!490 = !DILocation(line: 64, column: 5, scope: !454)
!491 = !DILocation(line: 65, column: 30, scope: !454)
!492 = !DILocation(line: 65, column: 34, scope: !454)
!493 = !DILocation(line: 65, column: 5, scope: !454)
!494 = !DILocation(line: 67, column: 5, scope: !454)
!495 = distinct !DISubprogram(name: "register_variable<int>", linkageName: "_Z17register_variableIiEvPT_PKc", scope: !496, file: !496, line: 14, type: !497, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, templateParams: !500, retainedNodes: !4)
!496 = !DIFile(filename: "include/ExtraPInstrumenter.hpp", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!497 = !DISubroutineType(types: !498)
!498 = !{null, !499, !49}
!499 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !20, size: 64)
!500 = !{!501}
!501 = !DITemplateTypeParameter(name: "T", type: !20)
!502 = !DILocalVariable(name: "ptr", arg: 1, scope: !495, file: !496, line: 14, type: !499)
!503 = !DILocation(line: 14, column: 28, scope: !495)
!504 = !DILocalVariable(name: "name", arg: 2, scope: !495, file: !496, line: 14, type: !49)
!505 = !DILocation(line: 14, column: 46, scope: !495)
!506 = !DILocalVariable(name: "param_id", scope: !495, file: !496, line: 16, type: !229)
!507 = !DILocation(line: 16, column: 13, scope: !495)
!508 = !DILocation(line: 16, column: 24, scope: !495)
!509 = !DILocation(line: 17, column: 57, scope: !495)
!510 = !DILocation(line: 17, column: 31, scope: !495)
!511 = !DILocation(line: 18, column: 21, scope: !495)
!512 = !DILocation(line: 18, column: 25, scope: !495)
!513 = !DILocation(line: 17, column: 5, scope: !495)
!514 = !DILocation(line: 19, column: 1, scope: !495)
