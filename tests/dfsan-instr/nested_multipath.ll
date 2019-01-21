; RUN: opt %dfsan -S < %s 2> /dev/null | llc %llcparams - -o %t1 && clang++ %link %t1 -o %t2 && %execparams %t2 10 10 10 | diff -w %s.json -
; RUN: %jsonconvert %s.json | diff -w %s.processed.json -
; ModuleID = 'tests/dfsan-instr/nested_multipath.cpp'
source_filename = "tests/dfsan-instr/nested_multipath.cpp"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

$_Z17register_variableIiEvPT_PKc = comdat any

@global = dso_local global i32 100, align 4, !dbg !0
@.str = private unnamed_addr constant [7 x i8] c"extrap\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [39 x i8] c"tests/dfsan-instr/nested_multipath.cpp\00", section "llvm.metadata"
@.str.2 = private unnamed_addr constant [3 x i8] c"x1\00", align 1
@.str.3 = private unnamed_addr constant [3 x i8] c"x2\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @_Z10nest_constii(i32, i32) #0 !dbg !296 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  call void @llvm.dbg.declare(metadata i32* %3, metadata !299, metadata !DIExpression()), !dbg !300
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !301, metadata !DIExpression()), !dbg !302
  call void @llvm.dbg.declare(metadata i32* %5, metadata !303, metadata !DIExpression()), !dbg !304
  store i32 0, i32* %5, align 4, !dbg !304
  call void @llvm.dbg.declare(metadata i32* %6, metadata !305, metadata !DIExpression()), !dbg !307
  %9 = load i32, i32* %3, align 4, !dbg !308
  store i32 %9, i32* %6, align 4, !dbg !307
  br label %10, !dbg !309

; <label>:10:                                     ; preds = %38, %2
  %11 = load i32, i32* %6, align 4, !dbg !310
  %12 = load i32, i32* @global, align 4, !dbg !312
  %13 = icmp slt i32 %11, %12, !dbg !313
  br i1 %13, label %14, label %41, !dbg !314

; <label>:14:                                     ; preds = %10
  call void @llvm.dbg.declare(metadata i32* %7, metadata !315, metadata !DIExpression()), !dbg !318
  store i32 0, i32* %7, align 4, !dbg !318
  br label %15, !dbg !319

; <label>:15:                                     ; preds = %22, %14
  %16 = load i32, i32* %7, align 4, !dbg !320
  %17 = icmp slt i32 %16, 10, !dbg !322
  br i1 %17, label %18, label %25, !dbg !323

; <label>:18:                                     ; preds = %15
  %19 = load i32, i32* %6, align 4, !dbg !324
  %20 = load i32, i32* %5, align 4, !dbg !325
  %21 = add nsw i32 %20, %19, !dbg !325
  store i32 %21, i32* %5, align 4, !dbg !325
  br label %22, !dbg !326

; <label>:22:                                     ; preds = %18
  %23 = load i32, i32* %7, align 4, !dbg !327
  %24 = add nsw i32 %23, 1, !dbg !327
  store i32 %24, i32* %7, align 4, !dbg !327
  br label %15, !dbg !328, !llvm.loop !329

; <label>:25:                                     ; preds = %15
  call void @llvm.dbg.declare(metadata i32* %8, metadata !331, metadata !DIExpression()), !dbg !333
  store i32 0, i32* %8, align 4, !dbg !333
  br label %26, !dbg !334

; <label>:26:                                     ; preds = %34, %25
  %27 = load i32, i32* %8, align 4, !dbg !335
  %28 = load i32, i32* @global, align 4, !dbg !337
  %29 = icmp slt i32 %27, %28, !dbg !338
  br i1 %29, label %30, label %37, !dbg !339

; <label>:30:                                     ; preds = %26
  %31 = load i32, i32* %6, align 4, !dbg !340
  %32 = load i32, i32* %5, align 4, !dbg !341
  %33 = add nsw i32 %32, %31, !dbg !341
  store i32 %33, i32* %5, align 4, !dbg !341
  br label %34, !dbg !342

; <label>:34:                                     ; preds = %30
  %35 = load i32, i32* %8, align 4, !dbg !343
  %36 = add nsw i32 %35, 1, !dbg !343
  store i32 %36, i32* %8, align 4, !dbg !343
  br label %26, !dbg !344, !llvm.loop !345

; <label>:37:                                     ; preds = %26
  br label %38, !dbg !347

; <label>:38:                                     ; preds = %37
  %39 = load i32, i32* %6, align 4, !dbg !348
  %40 = add nsw i32 %39, 1, !dbg !348
  store i32 %40, i32* %6, align 4, !dbg !348
  br label %10, !dbg !349, !llvm.loop !350

; <label>:41:                                     ; preds = %10
  %42 = load i32, i32* %5, align 4, !dbg !352
  ret i32 %42, !dbg !353
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @_Z12nest_partialii(i32, i32) #0 !dbg !354 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  call void @llvm.dbg.declare(metadata i32* %3, metadata !355, metadata !DIExpression()), !dbg !356
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !357, metadata !DIExpression()), !dbg !358
  call void @llvm.dbg.declare(metadata i32* %5, metadata !359, metadata !DIExpression()), !dbg !360
  store i32 0, i32* %5, align 4, !dbg !360
  call void @llvm.dbg.declare(metadata i32* %6, metadata !361, metadata !DIExpression()), !dbg !363
  %10 = load i32, i32* %3, align 4, !dbg !364
  store i32 %10, i32* %6, align 4, !dbg !363
  br label %11, !dbg !365

; <label>:11:                                     ; preds = %54, %2
  %12 = load i32, i32* %6, align 4, !dbg !366
  %13 = load i32, i32* @global, align 4, !dbg !368
  %14 = icmp slt i32 %12, %13, !dbg !369
  br i1 %14, label %15, label %57, !dbg !370

; <label>:15:                                     ; preds = %11
  call void @llvm.dbg.declare(metadata i32* %7, metadata !371, metadata !DIExpression()), !dbg !374
  store i32 0, i32* %7, align 4, !dbg !374
  br label %16, !dbg !375

; <label>:16:                                     ; preds = %24, %15
  %17 = load i32, i32* %7, align 4, !dbg !376
  %18 = load i32, i32* %4, align 4, !dbg !378
  %19 = icmp slt i32 %17, %18, !dbg !379
  br i1 %19, label %20, label %27, !dbg !380

; <label>:20:                                     ; preds = %16
  %21 = load i32, i32* %6, align 4, !dbg !381
  %22 = load i32, i32* %5, align 4, !dbg !382
  %23 = add nsw i32 %22, %21, !dbg !382
  store i32 %23, i32* %5, align 4, !dbg !382
  br label %24, !dbg !383

; <label>:24:                                     ; preds = %20
  %25 = load i32, i32* %7, align 4, !dbg !384
  %26 = add nsw i32 %25, 1, !dbg !384
  store i32 %26, i32* %7, align 4, !dbg !384
  br label %16, !dbg !385, !llvm.loop !386

; <label>:27:                                     ; preds = %16
  call void @llvm.dbg.declare(metadata i32* %8, metadata !388, metadata !DIExpression()), !dbg !390
  store i32 0, i32* %8, align 4, !dbg !390
  br label %28, !dbg !391

; <label>:28:                                     ; preds = %36, %27
  %29 = load i32, i32* %8, align 4, !dbg !392
  %30 = load i32, i32* @global, align 4, !dbg !394
  %31 = icmp slt i32 %29, %30, !dbg !395
  br i1 %31, label %32, label %39, !dbg !396

; <label>:32:                                     ; preds = %28
  %33 = load i32, i32* %6, align 4, !dbg !397
  %34 = load i32, i32* %5, align 4, !dbg !398
  %35 = add nsw i32 %34, %33, !dbg !398
  store i32 %35, i32* %5, align 4, !dbg !398
  br label %36, !dbg !399

; <label>:36:                                     ; preds = %32
  %37 = load i32, i32* %8, align 4, !dbg !400
  %38 = add nsw i32 %37, 1, !dbg !400
  store i32 %38, i32* %8, align 4, !dbg !400
  br label %28, !dbg !401, !llvm.loop !402

; <label>:39:                                     ; preds = %28
  call void @llvm.dbg.declare(metadata i32* %9, metadata !404, metadata !DIExpression()), !dbg !406
  %40 = load i32, i32* %3, align 4, !dbg !407
  store i32 %40, i32* %9, align 4, !dbg !406
  br label %41, !dbg !408

; <label>:41:                                     ; preds = %49, %39
  %42 = load i32, i32* %9, align 4, !dbg !409
  %43 = load i32, i32* @global, align 4, !dbg !411
  %44 = icmp slt i32 %42, %43, !dbg !412
  br i1 %44, label %45, label %53, !dbg !413

; <label>:45:                                     ; preds = %41
  %46 = load i32, i32* %6, align 4, !dbg !414
  %47 = load i32, i32* %5, align 4, !dbg !415
  %48 = add nsw i32 %47, %46, !dbg !415
  store i32 %48, i32* %5, align 4, !dbg !415
  br label %49, !dbg !416

; <label>:49:                                     ; preds = %45
  %50 = load i32, i32* %4, align 4, !dbg !417
  %51 = load i32, i32* %9, align 4, !dbg !418
  %52 = add nsw i32 %51, %50, !dbg !418
  store i32 %52, i32* %9, align 4, !dbg !418
  br label %41, !dbg !419, !llvm.loop !420

; <label>:53:                                     ; preds = %41
  br label %54, !dbg !422

; <label>:54:                                     ; preds = %53
  %55 = load i32, i32* %6, align 4, !dbg !423
  %56 = add nsw i32 %55, 1, !dbg !423
  store i32 %56, i32* %6, align 4, !dbg !423
  br label %11, !dbg !424, !llvm.loop !425

; <label>:57:                                     ; preds = %11
  %58 = load i32, i32* %5, align 4, !dbg !427
  ret i32 %58, !dbg !428
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @_Z19double_nest_partialii(i32, i32) #0 !dbg !429 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  call void @llvm.dbg.declare(metadata i32* %3, metadata !430, metadata !DIExpression()), !dbg !431
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !432, metadata !DIExpression()), !dbg !433
  call void @llvm.dbg.declare(metadata i32* %5, metadata !434, metadata !DIExpression()), !dbg !435
  store i32 0, i32* %5, align 4, !dbg !435
  call void @llvm.dbg.declare(metadata i32* %6, metadata !436, metadata !DIExpression()), !dbg !438
  %14 = load i32, i32* %3, align 4, !dbg !439
  store i32 %14, i32* %6, align 4, !dbg !438
  br label %15, !dbg !440

; <label>:15:                                     ; preds = %57, %2
  %16 = load i32, i32* %6, align 4, !dbg !441
  %17 = load i32, i32* @global, align 4, !dbg !443
  %18 = icmp slt i32 %16, %17, !dbg !444
  br i1 %18, label %19, label %61, !dbg !445

; <label>:19:                                     ; preds = %15
  call void @llvm.dbg.declare(metadata i32* %7, metadata !446, metadata !DIExpression()), !dbg !449
  store i32 0, i32* %7, align 4, !dbg !449
  br label %20, !dbg !450

; <label>:20:                                     ; preds = %27, %19
  %21 = load i32, i32* %7, align 4, !dbg !451
  %22 = icmp slt i32 %21, 100, !dbg !453
  br i1 %22, label %23, label %30, !dbg !454

; <label>:23:                                     ; preds = %20
  %24 = load i32, i32* %6, align 4, !dbg !455
  %25 = load i32, i32* %5, align 4, !dbg !456
  %26 = add nsw i32 %25, %24, !dbg !456
  store i32 %26, i32* %5, align 4, !dbg !456
  br label %27, !dbg !457

; <label>:27:                                     ; preds = %23
  %28 = load i32, i32* %7, align 4, !dbg !458
  %29 = add nsw i32 %28, 1, !dbg !458
  store i32 %29, i32* %7, align 4, !dbg !458
  br label %20, !dbg !459, !llvm.loop !460

; <label>:30:                                     ; preds = %20
  call void @llvm.dbg.declare(metadata i32* %8, metadata !462, metadata !DIExpression()), !dbg !464
  %31 = load i32, i32* %3, align 4, !dbg !465
  store i32 %31, i32* %8, align 4, !dbg !464
  br label %32, !dbg !466

; <label>:32:                                     ; preds = %40, %30
  %33 = load i32, i32* %8, align 4, !dbg !467
  %34 = load i32, i32* @global, align 4, !dbg !469
  %35 = icmp slt i32 %33, %34, !dbg !470
  br i1 %35, label %36, label %43, !dbg !471

; <label>:36:                                     ; preds = %32
  %37 = load i32, i32* %6, align 4, !dbg !472
  %38 = load i32, i32* %5, align 4, !dbg !473
  %39 = add nsw i32 %38, %37, !dbg !473
  store i32 %39, i32* %5, align 4, !dbg !473
  br label %40, !dbg !474

; <label>:40:                                     ; preds = %36
  %41 = load i32, i32* %8, align 4, !dbg !475
  %42 = add nsw i32 %41, 1, !dbg !475
  store i32 %42, i32* %8, align 4, !dbg !475
  br label %32, !dbg !476, !llvm.loop !477

; <label>:43:                                     ; preds = %32
  call void @llvm.dbg.declare(metadata i32* %9, metadata !479, metadata !DIExpression()), !dbg !481
  store i32 0, i32* %9, align 4, !dbg !481
  br label %44, !dbg !482

; <label>:44:                                     ; preds = %52, %43
  %45 = load i32, i32* %9, align 4, !dbg !483
  %46 = load i32, i32* @global, align 4, !dbg !485
  %47 = icmp slt i32 %45, %46, !dbg !486
  br i1 %47, label %48, label %56, !dbg !487

; <label>:48:                                     ; preds = %44
  %49 = load i32, i32* %6, align 4, !dbg !488
  %50 = load i32, i32* %5, align 4, !dbg !489
  %51 = add nsw i32 %50, %49, !dbg !489
  store i32 %51, i32* %5, align 4, !dbg !489
  br label %52, !dbg !490

; <label>:52:                                     ; preds = %48
  %53 = load i32, i32* %4, align 4, !dbg !491
  %54 = load i32, i32* %9, align 4, !dbg !492
  %55 = add nsw i32 %54, %53, !dbg !492
  store i32 %55, i32* %9, align 4, !dbg !492
  br label %44, !dbg !493, !llvm.loop !494

; <label>:56:                                     ; preds = %44
  br label %57, !dbg !496

; <label>:57:                                     ; preds = %56
  %58 = load i32, i32* %4, align 4, !dbg !497
  %59 = load i32, i32* %6, align 4, !dbg !498
  %60 = add nsw i32 %59, %58, !dbg !498
  store i32 %60, i32* %6, align 4, !dbg !498
  br label %15, !dbg !499, !llvm.loop !500

; <label>:61:                                     ; preds = %15
  call void @llvm.dbg.declare(metadata i32* %10, metadata !502, metadata !DIExpression()), !dbg !504
  %62 = load i32, i32* %3, align 4, !dbg !505
  store i32 %62, i32* %10, align 4, !dbg !504
  br label %63, !dbg !506

; <label>:63:                                     ; preds = %106, %61
  %64 = load i32, i32* %10, align 4, !dbg !507
  %65 = load i32, i32* @global, align 4, !dbg !509
  %66 = icmp slt i32 %64, %65, !dbg !510
  br i1 %66, label %67, label %109, !dbg !511

; <label>:67:                                     ; preds = %63
  call void @llvm.dbg.declare(metadata i32* %11, metadata !512, metadata !DIExpression()), !dbg !515
  store i32 0, i32* %11, align 4, !dbg !515
  br label %68, !dbg !516

; <label>:68:                                     ; preds = %76, %67
  %69 = load i32, i32* %11, align 4, !dbg !517
  %70 = load i32, i32* %4, align 4, !dbg !519
  %71 = icmp slt i32 %69, %70, !dbg !520
  br i1 %71, label %72, label %79, !dbg !521

; <label>:72:                                     ; preds = %68
  %73 = load i32, i32* %10, align 4, !dbg !522
  %74 = load i32, i32* %5, align 4, !dbg !523
  %75 = add nsw i32 %74, %73, !dbg !523
  store i32 %75, i32* %5, align 4, !dbg !523
  br label %76, !dbg !524

; <label>:76:                                     ; preds = %72
  %77 = load i32, i32* %11, align 4, !dbg !525
  %78 = add nsw i32 %77, 1, !dbg !525
  store i32 %78, i32* %11, align 4, !dbg !525
  br label %68, !dbg !526, !llvm.loop !527

; <label>:79:                                     ; preds = %68
  call void @llvm.dbg.declare(metadata i32* %12, metadata !529, metadata !DIExpression()), !dbg !531
  store i32 0, i32* %12, align 4, !dbg !531
  br label %80, !dbg !532

; <label>:80:                                     ; preds = %88, %79
  %81 = load i32, i32* %12, align 4, !dbg !533
  %82 = load i32, i32* @global, align 4, !dbg !535
  %83 = icmp slt i32 %81, %82, !dbg !536
  br i1 %83, label %84, label %91, !dbg !537

; <label>:84:                                     ; preds = %80
  %85 = load i32, i32* %10, align 4, !dbg !538
  %86 = load i32, i32* %5, align 4, !dbg !539
  %87 = add nsw i32 %86, %85, !dbg !539
  store i32 %87, i32* %5, align 4, !dbg !539
  br label %88, !dbg !540

; <label>:88:                                     ; preds = %84
  %89 = load i32, i32* %12, align 4, !dbg !541
  %90 = add nsw i32 %89, 1, !dbg !541
  store i32 %90, i32* %12, align 4, !dbg !541
  br label %80, !dbg !542, !llvm.loop !543

; <label>:91:                                     ; preds = %80
  call void @llvm.dbg.declare(metadata i32* %13, metadata !545, metadata !DIExpression()), !dbg !547
  %92 = load i32, i32* %3, align 4, !dbg !548
  store i32 %92, i32* %13, align 4, !dbg !547
  br label %93, !dbg !549

; <label>:93:                                     ; preds = %101, %91
  %94 = load i32, i32* %13, align 4, !dbg !550
  %95 = load i32, i32* @global, align 4, !dbg !552
  %96 = icmp slt i32 %94, %95, !dbg !553
  br i1 %96, label %97, label %105, !dbg !554

; <label>:97:                                     ; preds = %93
  %98 = load i32, i32* %10, align 4, !dbg !555
  %99 = load i32, i32* %5, align 4, !dbg !556
  %100 = add nsw i32 %99, %98, !dbg !556
  store i32 %100, i32* %5, align 4, !dbg !556
  br label %101, !dbg !557

; <label>:101:                                    ; preds = %97
  %102 = load i32, i32* %4, align 4, !dbg !558
  %103 = load i32, i32* %13, align 4, !dbg !559
  %104 = add nsw i32 %103, %102, !dbg !559
  store i32 %104, i32* %13, align 4, !dbg !559
  br label %93, !dbg !560, !llvm.loop !561

; <label>:105:                                    ; preds = %93
  br label %106, !dbg !563

; <label>:106:                                    ; preds = %105
  %107 = load i32, i32* %10, align 4, !dbg !564
  %108 = add nsw i32 %107, 1, !dbg !564
  store i32 %108, i32* %10, align 4, !dbg !564
  br label %63, !dbg !565, !llvm.loop !566

; <label>:109:                                    ; preds = %63
  %110 = load i32, i32* %5, align 4, !dbg !568
  ret i32 %110, !dbg !569
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @_Z11nest_tripleii(i32, i32) #0 !dbg !570 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  call void @llvm.dbg.declare(metadata i32* %3, metadata !571, metadata !DIExpression()), !dbg !572
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !573, metadata !DIExpression()), !dbg !574
  call void @llvm.dbg.declare(metadata i32* %5, metadata !575, metadata !DIExpression()), !dbg !576
  store i32 0, i32* %5, align 4, !dbg !576
  call void @llvm.dbg.declare(metadata i32* %6, metadata !577, metadata !DIExpression()), !dbg !579
  %12 = load i32, i32* %3, align 4, !dbg !580
  store i32 %12, i32* %6, align 4, !dbg !579
  br label %13, !dbg !581

; <label>:13:                                     ; preds = %75, %2
  %14 = load i32, i32* %6, align 4, !dbg !582
  %15 = load i32, i32* @global, align 4, !dbg !584
  %16 = icmp slt i32 %14, %15, !dbg !585
  br i1 %16, label %17, label %78, !dbg !586

; <label>:17:                                     ; preds = %13
  call void @llvm.dbg.declare(metadata i32* %7, metadata !587, metadata !DIExpression()), !dbg !590
  store i32 0, i32* %7, align 4, !dbg !590
  br label %18, !dbg !591

; <label>:18:                                     ; preds = %37, %17
  %19 = load i32, i32* %7, align 4, !dbg !592
  %20 = load i32, i32* %4, align 4, !dbg !594
  %21 = icmp slt i32 %19, %20, !dbg !595
  br i1 %21, label %22, label %40, !dbg !596

; <label>:22:                                     ; preds = %18
  call void @llvm.dbg.declare(metadata i32* %8, metadata !597, metadata !DIExpression()), !dbg !600
  %23 = load i32, i32* %4, align 4, !dbg !601
  store i32 %23, i32* %8, align 4, !dbg !600
  br label %24, !dbg !602

; <label>:24:                                     ; preds = %32, %22
  %25 = load i32, i32* %8, align 4, !dbg !603
  %26 = load i32, i32* @global, align 4, !dbg !605
  %27 = icmp slt i32 %25, %26, !dbg !606
  br i1 %27, label %28, label %36, !dbg !607

; <label>:28:                                     ; preds = %24
  %29 = load i32, i32* %8, align 4, !dbg !608
  %30 = load i32, i32* %5, align 4, !dbg !609
  %31 = add nsw i32 %30, %29, !dbg !609
  store i32 %31, i32* %5, align 4, !dbg !609
  br label %32, !dbg !610

; <label>:32:                                     ; preds = %28
  %33 = load i32, i32* %3, align 4, !dbg !611
  %34 = load i32, i32* %8, align 4, !dbg !612
  %35 = add nsw i32 %34, %33, !dbg !612
  store i32 %35, i32* %8, align 4, !dbg !612
  br label %24, !dbg !613, !llvm.loop !614

; <label>:36:                                     ; preds = %24
  br label %37, !dbg !616

; <label>:37:                                     ; preds = %36
  %38 = load i32, i32* %7, align 4, !dbg !617
  %39 = add nsw i32 %38, 1, !dbg !617
  store i32 %39, i32* %7, align 4, !dbg !617
  br label %18, !dbg !618, !llvm.loop !619

; <label>:40:                                     ; preds = %18
  call void @llvm.dbg.declare(metadata i32* %9, metadata !621, metadata !DIExpression()), !dbg !623
  store i32 0, i32* %9, align 4, !dbg !623
  br label %41, !dbg !624

; <label>:41:                                     ; preds = %71, %40
  %42 = load i32, i32* %9, align 4, !dbg !625
  %43 = icmp slt i32 %42, 10, !dbg !627
  br i1 %43, label %44, label %74, !dbg !628

; <label>:44:                                     ; preds = %41
  call void @llvm.dbg.declare(metadata i32* %10, metadata !629, metadata !DIExpression()), !dbg !632
  %45 = load i32, i32* %3, align 4, !dbg !633
  store i32 %45, i32* %10, align 4, !dbg !632
  br label %46, !dbg !634

; <label>:46:                                     ; preds = %54, %44
  %47 = load i32, i32* %10, align 4, !dbg !635
  %48 = load i32, i32* @global, align 4, !dbg !637
  %49 = icmp slt i32 %47, %48, !dbg !638
  br i1 %49, label %50, label %58, !dbg !639

; <label>:50:                                     ; preds = %46
  %51 = load i32, i32* %10, align 4, !dbg !640
  %52 = load i32, i32* %5, align 4, !dbg !641
  %53 = add nsw i32 %52, %51, !dbg !641
  store i32 %53, i32* %5, align 4, !dbg !641
  br label %54, !dbg !642

; <label>:54:                                     ; preds = %50
  %55 = load i32, i32* %4, align 4, !dbg !643
  %56 = load i32, i32* %10, align 4, !dbg !644
  %57 = add nsw i32 %56, %55, !dbg !644
  store i32 %57, i32* %10, align 4, !dbg !644
  br label %46, !dbg !645, !llvm.loop !646

; <label>:58:                                     ; preds = %46
  call void @llvm.dbg.declare(metadata i32* %11, metadata !648, metadata !DIExpression()), !dbg !650
  store i32 0, i32* %11, align 4, !dbg !650
  br label %59, !dbg !651

; <label>:59:                                     ; preds = %67, %58
  %60 = load i32, i32* %11, align 4, !dbg !652
  %61 = load i32, i32* %4, align 4, !dbg !654
  %62 = icmp slt i32 %60, %61, !dbg !655
  br i1 %62, label %63, label %70, !dbg !656

; <label>:63:                                     ; preds = %59
  %64 = load i32, i32* %11, align 4, !dbg !657
  %65 = load i32, i32* %5, align 4, !dbg !658
  %66 = add nsw i32 %65, %64, !dbg !658
  store i32 %66, i32* %5, align 4, !dbg !658
  br label %67, !dbg !659

; <label>:67:                                     ; preds = %63
  %68 = load i32, i32* %11, align 4, !dbg !660
  %69 = add nsw i32 %68, 1, !dbg !660
  store i32 %69, i32* %11, align 4, !dbg !660
  br label %59, !dbg !661, !llvm.loop !662

; <label>:70:                                     ; preds = %59
  br label %71, !dbg !664

; <label>:71:                                     ; preds = %70
  %72 = load i32, i32* %9, align 4, !dbg !665
  %73 = add nsw i32 %72, 1, !dbg !665
  store i32 %73, i32* %9, align 4, !dbg !665
  br label %41, !dbg !666, !llvm.loop !667

; <label>:74:                                     ; preds = %41
  br label %75, !dbg !669

; <label>:75:                                     ; preds = %74
  %76 = load i32, i32* %6, align 4, !dbg !670
  %77 = add nsw i32 %76, 1, !dbg !670
  store i32 %77, i32* %6, align 4, !dbg !670
  br label %13, !dbg !671, !llvm.loop !672

; <label>:78:                                     ; preds = %13
  %79 = load i32, i32* %5, align 4, !dbg !674
  ret i32 %79, !dbg !675
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @_Z18double_nest_tripleii(i32, i32) #0 !dbg !676 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca i32, align 4
  %15 = alloca i32, align 4
  %16 = alloca i32, align 4
  %17 = alloca i32, align 4
  %18 = alloca i32, align 4
  %19 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  call void @llvm.dbg.declare(metadata i32* %3, metadata !677, metadata !DIExpression()), !dbg !678
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !679, metadata !DIExpression()), !dbg !680
  call void @llvm.dbg.declare(metadata i32* %5, metadata !681, metadata !DIExpression()), !dbg !682
  store i32 0, i32* %5, align 4, !dbg !682
  call void @llvm.dbg.declare(metadata i32* %6, metadata !683, metadata !DIExpression()), !dbg !685
  %20 = load i32, i32* %4, align 4, !dbg !686
  store i32 %20, i32* %6, align 4, !dbg !685
  br label %21, !dbg !687

; <label>:21:                                     ; preds = %83, %2
  %22 = load i32, i32* %6, align 4, !dbg !688
  %23 = load i32, i32* @global, align 4, !dbg !690
  %24 = icmp slt i32 %22, %23, !dbg !691
  br i1 %24, label %25, label %86, !dbg !692

; <label>:25:                                     ; preds = %21
  call void @llvm.dbg.declare(metadata i32* %7, metadata !693, metadata !DIExpression()), !dbg !696
  store i32 0, i32* %7, align 4, !dbg !696
  br label %26, !dbg !697

; <label>:26:                                     ; preds = %45, %25
  %27 = load i32, i32* %7, align 4, !dbg !698
  %28 = load i32, i32* %4, align 4, !dbg !700
  %29 = icmp slt i32 %27, %28, !dbg !701
  br i1 %29, label %30, label %48, !dbg !702

; <label>:30:                                     ; preds = %26
  call void @llvm.dbg.declare(metadata i32* %8, metadata !703, metadata !DIExpression()), !dbg !706
  %31 = load i32, i32* %4, align 4, !dbg !707
  store i32 %31, i32* %8, align 4, !dbg !706
  br label %32, !dbg !708

; <label>:32:                                     ; preds = %40, %30
  %33 = load i32, i32* %8, align 4, !dbg !709
  %34 = load i32, i32* @global, align 4, !dbg !711
  %35 = icmp slt i32 %33, %34, !dbg !712
  br i1 %35, label %36, label %44, !dbg !713

; <label>:36:                                     ; preds = %32
  %37 = load i32, i32* %6, align 4, !dbg !714
  %38 = load i32, i32* %5, align 4, !dbg !715
  %39 = add nsw i32 %38, %37, !dbg !715
  store i32 %39, i32* %5, align 4, !dbg !715
  br label %40, !dbg !716

; <label>:40:                                     ; preds = %36
  %41 = load i32, i32* %3, align 4, !dbg !717
  %42 = load i32, i32* %8, align 4, !dbg !718
  %43 = add nsw i32 %42, %41, !dbg !718
  store i32 %43, i32* %8, align 4, !dbg !718
  br label %32, !dbg !719, !llvm.loop !720

; <label>:44:                                     ; preds = %32
  br label %45, !dbg !722

; <label>:45:                                     ; preds = %44
  %46 = load i32, i32* %7, align 4, !dbg !723
  %47 = add nsw i32 %46, 1, !dbg !723
  store i32 %47, i32* %7, align 4, !dbg !723
  br label %26, !dbg !724, !llvm.loop !725

; <label>:48:                                     ; preds = %26
  call void @llvm.dbg.declare(metadata i32* %9, metadata !727, metadata !DIExpression()), !dbg !729
  store i32 0, i32* %9, align 4, !dbg !729
  br label %49, !dbg !730

; <label>:49:                                     ; preds = %79, %48
  %50 = load i32, i32* %9, align 4, !dbg !731
  %51 = icmp slt i32 %50, 10, !dbg !733
  br i1 %51, label %52, label %82, !dbg !734

; <label>:52:                                     ; preds = %49
  call void @llvm.dbg.declare(metadata i32* %10, metadata !735, metadata !DIExpression()), !dbg !738
  %53 = load i32, i32* %3, align 4, !dbg !739
  store i32 %53, i32* %10, align 4, !dbg !738
  br label %54, !dbg !740

; <label>:54:                                     ; preds = %62, %52
  %55 = load i32, i32* %10, align 4, !dbg !741
  %56 = load i32, i32* @global, align 4, !dbg !743
  %57 = icmp slt i32 %55, %56, !dbg !744
  br i1 %57, label %58, label %66, !dbg !745

; <label>:58:                                     ; preds = %54
  %59 = load i32, i32* %6, align 4, !dbg !746
  %60 = load i32, i32* %5, align 4, !dbg !747
  %61 = add nsw i32 %60, %59, !dbg !747
  store i32 %61, i32* %5, align 4, !dbg !747
  br label %62, !dbg !748

; <label>:62:                                     ; preds = %58
  %63 = load i32, i32* %4, align 4, !dbg !749
  %64 = load i32, i32* %10, align 4, !dbg !750
  %65 = add nsw i32 %64, %63, !dbg !750
  store i32 %65, i32* %10, align 4, !dbg !750
  br label %54, !dbg !751, !llvm.loop !752

; <label>:66:                                     ; preds = %54
  call void @llvm.dbg.declare(metadata i32* %11, metadata !754, metadata !DIExpression()), !dbg !756
  store i32 0, i32* %11, align 4, !dbg !756
  br label %67, !dbg !757

; <label>:67:                                     ; preds = %75, %66
  %68 = load i32, i32* %11, align 4, !dbg !758
  %69 = load i32, i32* %4, align 4, !dbg !760
  %70 = icmp slt i32 %68, %69, !dbg !761
  br i1 %70, label %71, label %78, !dbg !762

; <label>:71:                                     ; preds = %67
  %72 = load i32, i32* %6, align 4, !dbg !763
  %73 = load i32, i32* %5, align 4, !dbg !764
  %74 = add nsw i32 %73, %72, !dbg !764
  store i32 %74, i32* %5, align 4, !dbg !764
  br label %75, !dbg !765

; <label>:75:                                     ; preds = %71
  %76 = load i32, i32* %11, align 4, !dbg !766
  %77 = add nsw i32 %76, 1, !dbg !766
  store i32 %77, i32* %11, align 4, !dbg !766
  br label %67, !dbg !767, !llvm.loop !768

; <label>:78:                                     ; preds = %67
  br label %79, !dbg !770

; <label>:79:                                     ; preds = %78
  %80 = load i32, i32* %9, align 4, !dbg !771
  %81 = add nsw i32 %80, 1, !dbg !771
  store i32 %81, i32* %9, align 4, !dbg !771
  br label %49, !dbg !772, !llvm.loop !773

; <label>:82:                                     ; preds = %49
  br label %83, !dbg !775

; <label>:83:                                     ; preds = %82
  %84 = load i32, i32* %6, align 4, !dbg !776
  %85 = add nsw i32 %84, 1, !dbg !776
  store i32 %85, i32* %6, align 4, !dbg !776
  br label %21, !dbg !777, !llvm.loop !778

; <label>:86:                                     ; preds = %21
  call void @llvm.dbg.declare(metadata i32* %12, metadata !780, metadata !DIExpression()), !dbg !782
  %87 = load i32, i32* %3, align 4, !dbg !783
  store i32 %87, i32* %12, align 4, !dbg !782
  br label %88, !dbg !784

; <label>:88:                                     ; preds = %176, %86
  %89 = load i32, i32* %12, align 4, !dbg !785
  %90 = load i32, i32* @global, align 4, !dbg !787
  %91 = icmp slt i32 %89, %90, !dbg !788
  br i1 %91, label %92, label %179, !dbg !789

; <label>:92:                                     ; preds = %88
  call void @llvm.dbg.declare(metadata i32* %13, metadata !790, metadata !DIExpression()), !dbg !793
  store i32 0, i32* %13, align 4, !dbg !793
  br label %93, !dbg !794

; <label>:93:                                     ; preds = %124, %92
  %94 = load i32, i32* %13, align 4, !dbg !795
  %95 = load i32, i32* %4, align 4, !dbg !797
  %96 = icmp slt i32 %94, %95, !dbg !798
  br i1 %96, label %97, label %127, !dbg !799

; <label>:97:                                     ; preds = %93
  call void @llvm.dbg.declare(metadata i32* %14, metadata !800, metadata !DIExpression()), !dbg !803
  %98 = load i32, i32* %4, align 4, !dbg !804
  store i32 %98, i32* %14, align 4, !dbg !803
  br label %99, !dbg !805

; <label>:99:                                     ; preds = %107, %97
  %100 = load i32, i32* %14, align 4, !dbg !806
  %101 = load i32, i32* @global, align 4, !dbg !808
  %102 = icmp slt i32 %100, %101, !dbg !809
  br i1 %102, label %103, label %111, !dbg !810

; <label>:103:                                    ; preds = %99
  %104 = load i32, i32* %12, align 4, !dbg !811
  %105 = load i32, i32* %5, align 4, !dbg !812
  %106 = add nsw i32 %105, %104, !dbg !812
  store i32 %106, i32* %5, align 4, !dbg !812
  br label %107, !dbg !813

; <label>:107:                                    ; preds = %103
  %108 = load i32, i32* %3, align 4, !dbg !814
  %109 = load i32, i32* %14, align 4, !dbg !815
  %110 = add nsw i32 %109, %108, !dbg !815
  store i32 %110, i32* %14, align 4, !dbg !815
  br label %99, !dbg !816, !llvm.loop !817

; <label>:111:                                    ; preds = %99
  call void @llvm.dbg.declare(metadata i32* %15, metadata !819, metadata !DIExpression()), !dbg !821
  store i32 0, i32* %15, align 4, !dbg !821
  br label %112, !dbg !822

; <label>:112:                                    ; preds = %120, %111
  %113 = load i32, i32* %15, align 4, !dbg !823
  %114 = load i32, i32* %4, align 4, !dbg !825
  %115 = icmp slt i32 %113, %114, !dbg !826
  br i1 %115, label %116, label %123, !dbg !827

; <label>:116:                                    ; preds = %112
  %117 = load i32, i32* %12, align 4, !dbg !828
  %118 = load i32, i32* %5, align 4, !dbg !829
  %119 = add nsw i32 %118, %117, !dbg !829
  store i32 %119, i32* %5, align 4, !dbg !829
  br label %120, !dbg !830

; <label>:120:                                    ; preds = %116
  %121 = load i32, i32* %15, align 4, !dbg !831
  %122 = add nsw i32 %121, 1, !dbg !831
  store i32 %122, i32* %15, align 4, !dbg !831
  br label %112, !dbg !832, !llvm.loop !833

; <label>:123:                                    ; preds = %112
  br label %124, !dbg !835

; <label>:124:                                    ; preds = %123
  %125 = load i32, i32* %13, align 4, !dbg !836
  %126 = add nsw i32 %125, 1, !dbg !836
  store i32 %126, i32* %13, align 4, !dbg !836
  br label %93, !dbg !837, !llvm.loop !838

; <label>:127:                                    ; preds = %93
  call void @llvm.dbg.declare(metadata i32* %16, metadata !840, metadata !DIExpression()), !dbg !842
  store i32 0, i32* %16, align 4, !dbg !842
  br label %128, !dbg !843

; <label>:128:                                    ; preds = %158, %127
  %129 = load i32, i32* %16, align 4, !dbg !844
  %130 = icmp slt i32 %129, 10, !dbg !846
  br i1 %130, label %131, label %161, !dbg !847

; <label>:131:                                    ; preds = %128
  call void @llvm.dbg.declare(metadata i32* %17, metadata !848, metadata !DIExpression()), !dbg !851
  %132 = load i32, i32* %3, align 4, !dbg !852
  store i32 %132, i32* %17, align 4, !dbg !851
  br label %133, !dbg !853

; <label>:133:                                    ; preds = %141, %131
  %134 = load i32, i32* %17, align 4, !dbg !854
  %135 = load i32, i32* @global, align 4, !dbg !856
  %136 = icmp slt i32 %134, %135, !dbg !857
  br i1 %136, label %137, label %145, !dbg !858

; <label>:137:                                    ; preds = %133
  %138 = load i32, i32* %12, align 4, !dbg !859
  %139 = load i32, i32* %5, align 4, !dbg !860
  %140 = add nsw i32 %139, %138, !dbg !860
  store i32 %140, i32* %5, align 4, !dbg !860
  br label %141, !dbg !861

; <label>:141:                                    ; preds = %137
  %142 = load i32, i32* %4, align 4, !dbg !862
  %143 = load i32, i32* %17, align 4, !dbg !863
  %144 = add nsw i32 %143, %142, !dbg !863
  store i32 %144, i32* %17, align 4, !dbg !863
  br label %133, !dbg !864, !llvm.loop !865

; <label>:145:                                    ; preds = %133
  call void @llvm.dbg.declare(metadata i32* %18, metadata !867, metadata !DIExpression()), !dbg !869
  store i32 0, i32* %18, align 4, !dbg !869
  br label %146, !dbg !870

; <label>:146:                                    ; preds = %154, %145
  %147 = load i32, i32* %18, align 4, !dbg !871
  %148 = load i32, i32* %4, align 4, !dbg !873
  %149 = icmp slt i32 %147, %148, !dbg !874
  br i1 %149, label %150, label %157, !dbg !875

; <label>:150:                                    ; preds = %146
  %151 = load i32, i32* %12, align 4, !dbg !876
  %152 = load i32, i32* %5, align 4, !dbg !877
  %153 = add nsw i32 %152, %151, !dbg !877
  store i32 %153, i32* %5, align 4, !dbg !877
  br label %154, !dbg !878

; <label>:154:                                    ; preds = %150
  %155 = load i32, i32* %18, align 4, !dbg !879
  %156 = add nsw i32 %155, 1, !dbg !879
  store i32 %156, i32* %18, align 4, !dbg !879
  br label %146, !dbg !880, !llvm.loop !881

; <label>:157:                                    ; preds = %146
  br label %158, !dbg !883

; <label>:158:                                    ; preds = %157
  %159 = load i32, i32* %16, align 4, !dbg !884
  %160 = add nsw i32 %159, 1, !dbg !884
  store i32 %160, i32* %16, align 4, !dbg !884
  br label %128, !dbg !885, !llvm.loop !886

; <label>:161:                                    ; preds = %128
  call void @llvm.dbg.declare(metadata i32* %19, metadata !888, metadata !DIExpression()), !dbg !890
  store i32 0, i32* %19, align 4, !dbg !890
  br label %162, !dbg !891

; <label>:162:                                    ; preds = %171, %161
  %163 = load i32, i32* %19, align 4, !dbg !892
  %164 = load i32, i32* @global, align 4, !dbg !894
  %165 = mul nsw i32 %164, 10, !dbg !895
  %166 = icmp slt i32 %163, %165, !dbg !896
  br i1 %166, label %167, label %175, !dbg !897

; <label>:167:                                    ; preds = %162
  %168 = load i32, i32* %12, align 4, !dbg !898
  %169 = load i32, i32* %5, align 4, !dbg !899
  %170 = add nsw i32 %169, %168, !dbg !899
  store i32 %170, i32* %5, align 4, !dbg !899
  br label %171, !dbg !900

; <label>:171:                                    ; preds = %167
  %172 = load i32, i32* %4, align 4, !dbg !901
  %173 = load i32, i32* %19, align 4, !dbg !902
  %174 = add nsw i32 %173, %172, !dbg !902
  store i32 %174, i32* %19, align 4, !dbg !902
  br label %162, !dbg !903, !llvm.loop !904

; <label>:175:                                    ; preds = %162
  br label %176, !dbg !906

; <label>:176:                                    ; preds = %175
  %177 = load i32, i32* %12, align 4, !dbg !907
  %178 = add nsw i32 %177, 1, !dbg !907
  store i32 %178, i32* %12, align 4, !dbg !907
  br label %88, !dbg !908, !llvm.loop !909

; <label>:179:                                    ; preds = %88
  %180 = load i32, i32* %4, align 4, !dbg !911
  %181 = call i32 @_Z11nest_tripleii(i32 10, i32 %180), !dbg !912
  %182 = load i32, i32* %5, align 4, !dbg !913
  ret i32 %182, !dbg !914
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @_Z11three_loopsii(i32, i32) #0 !dbg !915 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca i32, align 4
  %12 = alloca i32, align 4
  %13 = alloca i32, align 4
  %14 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  call void @llvm.dbg.declare(metadata i32* %3, metadata !916, metadata !DIExpression()), !dbg !917
  store i32 %1, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !918, metadata !DIExpression()), !dbg !919
  call void @llvm.dbg.declare(metadata i32* %5, metadata !920, metadata !DIExpression()), !dbg !921
  store i32 0, i32* %5, align 4, !dbg !921
  call void @llvm.dbg.declare(metadata i32* %6, metadata !922, metadata !DIExpression()), !dbg !924
  store i32 0, i32* %6, align 4, !dbg !924
  br label %15, !dbg !925

; <label>:15:                                     ; preds = %40, %2
  %16 = load i32, i32* %6, align 4, !dbg !926
  %17 = load i32, i32* @global, align 4, !dbg !928
  %18 = icmp slt i32 %16, %17, !dbg !929
  br i1 %18, label %19, label %43, !dbg !930

; <label>:19:                                     ; preds = %15
  call void @llvm.dbg.declare(metadata i32* %7, metadata !931, metadata !DIExpression()), !dbg !934
  store i32 0, i32* %7, align 4, !dbg !934
  br label %20, !dbg !935

; <label>:20:                                     ; preds = %36, %19
  %21 = load i32, i32* %7, align 4, !dbg !936
  %22 = load i32, i32* @global, align 4, !dbg !938
  %23 = icmp slt i32 %21, %22, !dbg !939
  br i1 %23, label %24, label %39, !dbg !940

; <label>:24:                                     ; preds = %20
  call void @llvm.dbg.declare(metadata i32* %8, metadata !941, metadata !DIExpression()), !dbg !944
  store i32 0, i32* %8, align 4, !dbg !944
  br label %25, !dbg !945

; <label>:25:                                     ; preds = %32, %24
  %26 = load i32, i32* %8, align 4, !dbg !946
  %27 = icmp slt i32 %26, 10, !dbg !948
  br i1 %27, label %28, label %35, !dbg !949

; <label>:28:                                     ; preds = %25
  %29 = load i32, i32* %6, align 4, !dbg !950
  %30 = load i32, i32* %5, align 4, !dbg !951
  %31 = add nsw i32 %30, %29, !dbg !951
  store i32 %31, i32* %5, align 4, !dbg !951
  br label %32, !dbg !952

; <label>:32:                                     ; preds = %28
  %33 = load i32, i32* %8, align 4, !dbg !953
  %34 = add nsw i32 %33, 1, !dbg !953
  store i32 %34, i32* %8, align 4, !dbg !953
  br label %25, !dbg !954, !llvm.loop !955

; <label>:35:                                     ; preds = %25
  br label %36, !dbg !957

; <label>:36:                                     ; preds = %35
  %37 = load i32, i32* %7, align 4, !dbg !958
  %38 = add nsw i32 %37, 1, !dbg !958
  store i32 %38, i32* %7, align 4, !dbg !958
  br label %20, !dbg !959, !llvm.loop !960

; <label>:39:                                     ; preds = %20
  br label %40, !dbg !962

; <label>:40:                                     ; preds = %39
  %41 = load i32, i32* %6, align 4, !dbg !963
  %42 = add nsw i32 %41, 1, !dbg !963
  store i32 %42, i32* %6, align 4, !dbg !963
  br label %15, !dbg !964, !llvm.loop !965

; <label>:43:                                     ; preds = %15
  call void @llvm.dbg.declare(metadata i32* %9, metadata !967, metadata !DIExpression()), !dbg !969
  %44 = load i32, i32* %3, align 4, !dbg !970
  store i32 %44, i32* %9, align 4, !dbg !969
  br label %45, !dbg !971

; <label>:45:                                     ; preds = %85, %43
  %46 = load i32, i32* %9, align 4, !dbg !972
  %47 = load i32, i32* @global, align 4, !dbg !974
  %48 = icmp slt i32 %46, %47, !dbg !975
  br i1 %48, label %49, label %88, !dbg !976

; <label>:49:                                     ; preds = %45
  call void @llvm.dbg.declare(metadata i32* %10, metadata !977, metadata !DIExpression()), !dbg !980
  store i32 0, i32* %10, align 4, !dbg !980
  br label %50, !dbg !981

; <label>:50:                                     ; preds = %81, %49
  %51 = load i32, i32* %10, align 4, !dbg !982
  %52 = load i32, i32* %4, align 4, !dbg !984
  %53 = icmp slt i32 %51, %52, !dbg !985
  br i1 %53, label %54, label %84, !dbg !986

; <label>:54:                                     ; preds = %50
  call void @llvm.dbg.declare(metadata i32* %11, metadata !987, metadata !DIExpression()), !dbg !990
  %55 = load i32, i32* %4, align 4, !dbg !991
  store i32 %55, i32* %11, align 4, !dbg !990
  br label %56, !dbg !992

; <label>:56:                                     ; preds = %64, %54
  %57 = load i32, i32* %11, align 4, !dbg !993
  %58 = load i32, i32* @global, align 4, !dbg !995
  %59 = icmp slt i32 %57, %58, !dbg !996
  br i1 %59, label %60, label %68, !dbg !997

; <label>:60:                                     ; preds = %56
  %61 = load i32, i32* %9, align 4, !dbg !998
  %62 = load i32, i32* %5, align 4, !dbg !999
  %63 = add nsw i32 %62, %61, !dbg !999
  store i32 %63, i32* %5, align 4, !dbg !999
  br label %64, !dbg !1000

; <label>:64:                                     ; preds = %60
  %65 = load i32, i32* %3, align 4, !dbg !1001
  %66 = load i32, i32* %11, align 4, !dbg !1002
  %67 = add nsw i32 %66, %65, !dbg !1002
  store i32 %67, i32* %11, align 4, !dbg !1002
  br label %56, !dbg !1003, !llvm.loop !1004

; <label>:68:                                     ; preds = %56
  call void @llvm.dbg.declare(metadata i32* %12, metadata !1006, metadata !DIExpression()), !dbg !1008
  store i32 0, i32* %12, align 4, !dbg !1008
  br label %69, !dbg !1009

; <label>:69:                                     ; preds = %77, %68
  %70 = load i32, i32* %12, align 4, !dbg !1010
  %71 = load i32, i32* %4, align 4, !dbg !1012
  %72 = icmp slt i32 %70, %71, !dbg !1013
  br i1 %72, label %73, label %80, !dbg !1014

; <label>:73:                                     ; preds = %69
  %74 = load i32, i32* %9, align 4, !dbg !1015
  %75 = load i32, i32* %5, align 4, !dbg !1016
  %76 = add nsw i32 %75, %74, !dbg !1016
  store i32 %76, i32* %5, align 4, !dbg !1016
  br label %77, !dbg !1017

; <label>:77:                                     ; preds = %73
  %78 = load i32, i32* %12, align 4, !dbg !1018
  %79 = add nsw i32 %78, 1, !dbg !1018
  store i32 %79, i32* %12, align 4, !dbg !1018
  br label %69, !dbg !1019, !llvm.loop !1020

; <label>:80:                                     ; preds = %69
  br label %81, !dbg !1022

; <label>:81:                                     ; preds = %80
  %82 = load i32, i32* %10, align 4, !dbg !1023
  %83 = add nsw i32 %82, 1, !dbg !1023
  store i32 %83, i32* %10, align 4, !dbg !1023
  br label %50, !dbg !1024, !llvm.loop !1025

; <label>:84:                                     ; preds = %50
  br label %85, !dbg !1027

; <label>:85:                                     ; preds = %84
  %86 = load i32, i32* %9, align 4, !dbg !1028
  %87 = add nsw i32 %86, 1, !dbg !1028
  store i32 %87, i32* %9, align 4, !dbg !1028
  br label %45, !dbg !1029, !llvm.loop !1030

; <label>:88:                                     ; preds = %45
  call void @llvm.dbg.declare(metadata i32* %13, metadata !1032, metadata !DIExpression()), !dbg !1034
  %89 = load i32, i32* %3, align 4, !dbg !1035
  store i32 %89, i32* %13, align 4, !dbg !1034
  br label %90, !dbg !1036

; <label>:90:                                     ; preds = %107, %88
  %91 = load i32, i32* %13, align 4, !dbg !1037
  %92 = load i32, i32* @global, align 4, !dbg !1039
  %93 = icmp slt i32 %91, %92, !dbg !1040
  br i1 %93, label %94, label %110, !dbg !1041

; <label>:94:                                     ; preds = %90
  call void @llvm.dbg.declare(metadata i32* %14, metadata !1042, metadata !DIExpression()), !dbg !1044
  store i32 0, i32* %14, align 4, !dbg !1044
  br label %95, !dbg !1045

; <label>:95:                                     ; preds = %103, %94
  %96 = load i32, i32* %14, align 4, !dbg !1046
  %97 = load i32, i32* %4, align 4, !dbg !1048
  %98 = icmp slt i32 %96, %97, !dbg !1049
  br i1 %98, label %99, label %106, !dbg !1050

; <label>:99:                                     ; preds = %95
  %100 = load i32, i32* %13, align 4, !dbg !1051
  %101 = load i32, i32* %5, align 4, !dbg !1052
  %102 = add nsw i32 %101, %100, !dbg !1052
  store i32 %102, i32* %5, align 4, !dbg !1052
  br label %103, !dbg !1053

; <label>:103:                                    ; preds = %99
  %104 = load i32, i32* %14, align 4, !dbg !1054
  %105 = add nsw i32 %104, 1, !dbg !1054
  store i32 %105, i32* %14, align 4, !dbg !1054
  br label %95, !dbg !1055, !llvm.loop !1056

; <label>:106:                                    ; preds = %95
  br label %107, !dbg !1057

; <label>:107:                                    ; preds = %106
  %108 = load i32, i32* %13, align 4, !dbg !1058
  %109 = add nsw i32 %108, 1, !dbg !1058
  store i32 %109, i32* %13, align 4, !dbg !1058
  br label %90, !dbg !1059, !llvm.loop !1060

; <label>:110:                                    ; preds = %90
  %111 = load i32, i32* %3, align 4, !dbg !1062
  %112 = load i32, i32* %4, align 4, !dbg !1063
  %113 = call i32 @_Z12nest_partialii(i32 %111, i32 %112), !dbg !1064
  %114 = load i32, i32* %5, align 4, !dbg !1065
  ret i32 %114, !dbg !1066
}

; Function Attrs: noinline norecurse optnone uwtable
define dso_local i32 @main(i32, i8**) #2 !dbg !1067 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4
  call void @llvm.dbg.declare(metadata i32* %4, metadata !1070, metadata !DIExpression()), !dbg !1071
  store i8** %1, i8*** %5, align 8
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !1072, metadata !DIExpression()), !dbg !1073
  call void @llvm.dbg.declare(metadata i32* %6, metadata !1074, metadata !DIExpression()), !dbg !1075
  %9 = bitcast i32* %6 to i8*, !dbg !1076
  call void @llvm.var.annotation(i8* %9, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([39 x i8], [39 x i8]* @.str.1, i32 0, i32 0), i32 203), !dbg !1076
  %10 = load i8**, i8*** %5, align 8, !dbg !1077
  %11 = getelementptr inbounds i8*, i8** %10, i64 1, !dbg !1077
  %12 = load i8*, i8** %11, align 8, !dbg !1077
  %13 = call i32 @atoi(i8* %12) #7, !dbg !1078
  store i32 %13, i32* %6, align 4, !dbg !1075
  call void @llvm.dbg.declare(metadata i32* %7, metadata !1079, metadata !DIExpression()), !dbg !1080
  %14 = bitcast i32* %7 to i8*, !dbg !1081
  call void @llvm.var.annotation(i8* %14, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([39 x i8], [39 x i8]* @.str.1, i32 0, i32 0), i32 204), !dbg !1081
  %15 = load i8**, i8*** %5, align 8, !dbg !1082
  %16 = getelementptr inbounds i8*, i8** %15, i64 2, !dbg !1082
  %17 = load i8*, i8** %16, align 8, !dbg !1082
  %18 = call i32 @atoi(i8* %17) #7, !dbg !1083
  store i32 %18, i32* %7, align 4, !dbg !1080
  call void @llvm.dbg.declare(metadata i32* %8, metadata !1084, metadata !DIExpression()), !dbg !1085
  %19 = load i8**, i8*** %5, align 8, !dbg !1086
  %20 = getelementptr inbounds i8*, i8** %19, i64 3, !dbg !1086
  %21 = load i8*, i8** %20, align 8, !dbg !1086
  %22 = call i32 @atoi(i8* %21) #7, !dbg !1087
  store i32 %22, i32* %8, align 4, !dbg !1085
  call void @_Z17register_variableIiEvPT_PKc(i32* %6, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.2, i32 0, i32 0)), !dbg !1088
  call void @_Z17register_variableIiEvPT_PKc(i32* %7, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.3, i32 0, i32 0)), !dbg !1089
  %23 = load i32, i32* %6, align 4, !dbg !1090
  %24 = load i32, i32* %7, align 4, !dbg !1091
  %25 = call i32 @_Z10nest_constii(i32 %23, i32 %24), !dbg !1092
  %26 = load i32, i32* %6, align 4, !dbg !1093
  %27 = load i32, i32* %7, align 4, !dbg !1094
  %28 = call i32 @_Z12nest_partialii(i32 %26, i32 %27), !dbg !1095
  %29 = load i32, i32* %6, align 4, !dbg !1096
  %30 = load i32, i32* %7, align 4, !dbg !1097
  %31 = call i32 @_Z12nest_partialii(i32 %29, i32 %30), !dbg !1098
  %32 = load i32, i32* %6, align 4, !dbg !1099
  %33 = load i32, i32* %7, align 4, !dbg !1100
  %34 = call i32 @_Z19double_nest_partialii(i32 %32, i32 %33), !dbg !1101
  %35 = load i32, i32* %6, align 4, !dbg !1102
  %36 = load i32, i32* %7, align 4, !dbg !1103
  %37 = call i32 @_Z11nest_tripleii(i32 %35, i32 %36), !dbg !1104
  %38 = load i32, i32* %6, align 4, !dbg !1105
  %39 = load i32, i32* %8, align 4, !dbg !1106
  %40 = call i32 @_Z11nest_tripleii(i32 %38, i32 %39), !dbg !1107
  %41 = load i32, i32* %6, align 4, !dbg !1108
  %42 = load i32, i32* %7, align 4, !dbg !1109
  %43 = call i32 @_Z18double_nest_tripleii(i32 %41, i32 %42), !dbg !1110
  %44 = load i32, i32* %6, align 4, !dbg !1111
  %45 = load i32, i32* %7, align 4, !dbg !1112
  %46 = call i32 @_Z11three_loopsii(i32 %44, i32 %45), !dbg !1113
  ret i32 0, !dbg !1114
}

; Function Attrs: nounwind
declare void @llvm.var.annotation(i8*, i8*, i8*, i32) #3

; Function Attrs: nounwind readonly
declare dso_local i32 @atoi(i8*) #4

; Function Attrs: noinline optnone uwtable
define linkonce_odr dso_local void @_Z17register_variableIiEvPT_PKc(i32*, i8*) #5 comdat !dbg !1115 {
  %3 = alloca i32*, align 8
  %4 = alloca i8*, align 8
  %5 = alloca i32, align 4
  store i32* %0, i32** %3, align 8
  call void @llvm.dbg.declare(metadata i32** %3, metadata !1122, metadata !DIExpression()), !dbg !1123
  store i8* %1, i8** %4, align 8
  call void @llvm.dbg.declare(metadata i8** %4, metadata !1124, metadata !DIExpression()), !dbg !1125
  call void @llvm.dbg.declare(metadata i32* %5, metadata !1126, metadata !DIExpression()), !dbg !1127
  %6 = call i32 @__dfsw_EXTRAP_VAR_ID(), !dbg !1128
  store i32 %6, i32* %5, align 4, !dbg !1127
  %7 = load i32*, i32** %3, align 8, !dbg !1129
  %8 = bitcast i32* %7 to i8*, !dbg !1130
  %9 = load i32, i32* %5, align 4, !dbg !1131
  %10 = add nsw i32 %9, 1, !dbg !1131
  store i32 %10, i32* %5, align 4, !dbg !1131
  %11 = load i8*, i8** %4, align 8, !dbg !1132
  call void @__dfsw_EXTRAP_STORE_LABEL(i8* %8, i32 4, i32 %9, i8* %11), !dbg !1133
  ret void, !dbg !1134
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
!3 = !DIFile(filename: "tests/dfsan-instr/nested_multipath.cpp", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
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
!296 = distinct !DISubprogram(name: "nest_const", linkageName: "_Z10nest_constii", scope: !3, file: !3, line: 10, type: !297, scopeLine: 11, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!297 = !DISubroutineType(types: !298)
!298 = !{!20, !20, !20}
!299 = !DILocalVariable(name: "x", arg: 1, scope: !296, file: !3, line: 10, type: !20)
!300 = !DILocation(line: 10, column: 20, scope: !296)
!301 = !DILocalVariable(name: "y", arg: 2, scope: !296, file: !3, line: 10, type: !20)
!302 = !DILocation(line: 10, column: 27, scope: !296)
!303 = !DILocalVariable(name: "tmp", scope: !296, file: !3, line: 12, type: !20)
!304 = !DILocation(line: 12, column: 9, scope: !296)
!305 = !DILocalVariable(name: "i", scope: !306, file: !3, line: 13, type: !20)
!306 = distinct !DILexicalBlock(scope: !296, file: !3, line: 13, column: 5)
!307 = !DILocation(line: 13, column: 13, scope: !306)
!308 = !DILocation(line: 13, column: 17, scope: !306)
!309 = !DILocation(line: 13, column: 9, scope: !306)
!310 = !DILocation(line: 13, column: 20, scope: !311)
!311 = distinct !DILexicalBlock(scope: !306, file: !3, line: 13, column: 5)
!312 = !DILocation(line: 13, column: 24, scope: !311)
!313 = !DILocation(line: 13, column: 22, scope: !311)
!314 = !DILocation(line: 13, column: 5, scope: !306)
!315 = !DILocalVariable(name: "j", scope: !316, file: !3, line: 14, type: !20)
!316 = distinct !DILexicalBlock(scope: !317, file: !3, line: 14, column: 9)
!317 = distinct !DILexicalBlock(scope: !311, file: !3, line: 13, column: 37)
!318 = !DILocation(line: 14, column: 17, scope: !316)
!319 = !DILocation(line: 14, column: 13, scope: !316)
!320 = !DILocation(line: 14, column: 24, scope: !321)
!321 = distinct !DILexicalBlock(scope: !316, file: !3, line: 14, column: 9)
!322 = !DILocation(line: 14, column: 26, scope: !321)
!323 = !DILocation(line: 14, column: 9, scope: !316)
!324 = !DILocation(line: 15, column: 20, scope: !321)
!325 = !DILocation(line: 15, column: 17, scope: !321)
!326 = !DILocation(line: 15, column: 13, scope: !321)
!327 = !DILocation(line: 14, column: 32, scope: !321)
!328 = !DILocation(line: 14, column: 9, scope: !321)
!329 = distinct !{!329, !323, !330}
!330 = !DILocation(line: 15, column: 20, scope: !316)
!331 = !DILocalVariable(name: "j", scope: !332, file: !3, line: 16, type: !20)
!332 = distinct !DILexicalBlock(scope: !317, file: !3, line: 16, column: 9)
!333 = !DILocation(line: 16, column: 17, scope: !332)
!334 = !DILocation(line: 16, column: 13, scope: !332)
!335 = !DILocation(line: 16, column: 24, scope: !336)
!336 = distinct !DILexicalBlock(scope: !332, file: !3, line: 16, column: 9)
!337 = !DILocation(line: 16, column: 28, scope: !336)
!338 = !DILocation(line: 16, column: 26, scope: !336)
!339 = !DILocation(line: 16, column: 9, scope: !332)
!340 = !DILocation(line: 17, column: 20, scope: !336)
!341 = !DILocation(line: 17, column: 17, scope: !336)
!342 = !DILocation(line: 17, column: 13, scope: !336)
!343 = !DILocation(line: 16, column: 36, scope: !336)
!344 = !DILocation(line: 16, column: 9, scope: !336)
!345 = distinct !{!345, !339, !346}
!346 = !DILocation(line: 17, column: 20, scope: !332)
!347 = !DILocation(line: 18, column: 5, scope: !317)
!348 = !DILocation(line: 13, column: 32, scope: !311)
!349 = !DILocation(line: 13, column: 5, scope: !311)
!350 = distinct !{!350, !314, !351}
!351 = !DILocation(line: 18, column: 5, scope: !306)
!352 = !DILocation(line: 19, column: 12, scope: !296)
!353 = !DILocation(line: 19, column: 5, scope: !296)
!354 = distinct !DISubprogram(name: "nest_partial", linkageName: "_Z12nest_partialii", scope: !3, file: !3, line: 22, type: !297, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!355 = !DILocalVariable(name: "x", arg: 1, scope: !354, file: !3, line: 22, type: !20)
!356 = !DILocation(line: 22, column: 22, scope: !354)
!357 = !DILocalVariable(name: "y", arg: 2, scope: !354, file: !3, line: 22, type: !20)
!358 = !DILocation(line: 22, column: 29, scope: !354)
!359 = !DILocalVariable(name: "tmp", scope: !354, file: !3, line: 24, type: !20)
!360 = !DILocation(line: 24, column: 9, scope: !354)
!361 = !DILocalVariable(name: "i", scope: !362, file: !3, line: 26, type: !20)
!362 = distinct !DILexicalBlock(scope: !354, file: !3, line: 26, column: 5)
!363 = !DILocation(line: 26, column: 13, scope: !362)
!364 = !DILocation(line: 26, column: 17, scope: !362)
!365 = !DILocation(line: 26, column: 9, scope: !362)
!366 = !DILocation(line: 26, column: 20, scope: !367)
!367 = distinct !DILexicalBlock(scope: !362, file: !3, line: 26, column: 5)
!368 = !DILocation(line: 26, column: 24, scope: !367)
!369 = !DILocation(line: 26, column: 22, scope: !367)
!370 = !DILocation(line: 26, column: 5, scope: !362)
!371 = !DILocalVariable(name: "j", scope: !372, file: !3, line: 29, type: !20)
!372 = distinct !DILexicalBlock(scope: !373, file: !3, line: 29, column: 9)
!373 = distinct !DILexicalBlock(scope: !367, file: !3, line: 26, column: 37)
!374 = !DILocation(line: 29, column: 17, scope: !372)
!375 = !DILocation(line: 29, column: 13, scope: !372)
!376 = !DILocation(line: 29, column: 24, scope: !377)
!377 = distinct !DILexicalBlock(scope: !372, file: !3, line: 29, column: 9)
!378 = !DILocation(line: 29, column: 28, scope: !377)
!379 = !DILocation(line: 29, column: 26, scope: !377)
!380 = !DILocation(line: 29, column: 9, scope: !372)
!381 = !DILocation(line: 30, column: 20, scope: !377)
!382 = !DILocation(line: 30, column: 17, scope: !377)
!383 = !DILocation(line: 30, column: 13, scope: !377)
!384 = !DILocation(line: 29, column: 31, scope: !377)
!385 = !DILocation(line: 29, column: 9, scope: !377)
!386 = distinct !{!386, !380, !387}
!387 = !DILocation(line: 30, column: 20, scope: !372)
!388 = !DILocalVariable(name: "j", scope: !389, file: !3, line: 33, type: !20)
!389 = distinct !DILexicalBlock(scope: !373, file: !3, line: 33, column: 9)
!390 = !DILocation(line: 33, column: 17, scope: !389)
!391 = !DILocation(line: 33, column: 13, scope: !389)
!392 = !DILocation(line: 33, column: 24, scope: !393)
!393 = distinct !DILexicalBlock(scope: !389, file: !3, line: 33, column: 9)
!394 = !DILocation(line: 33, column: 28, scope: !393)
!395 = !DILocation(line: 33, column: 26, scope: !393)
!396 = !DILocation(line: 33, column: 9, scope: !389)
!397 = !DILocation(line: 34, column: 20, scope: !393)
!398 = !DILocation(line: 34, column: 17, scope: !393)
!399 = !DILocation(line: 34, column: 13, scope: !393)
!400 = !DILocation(line: 33, column: 36, scope: !393)
!401 = !DILocation(line: 33, column: 9, scope: !393)
!402 = distinct !{!402, !396, !403}
!403 = !DILocation(line: 34, column: 20, scope: !389)
!404 = !DILocalVariable(name: "j", scope: !405, file: !3, line: 37, type: !20)
!405 = distinct !DILexicalBlock(scope: !373, file: !3, line: 37, column: 9)
!406 = !DILocation(line: 37, column: 17, scope: !405)
!407 = !DILocation(line: 37, column: 21, scope: !405)
!408 = !DILocation(line: 37, column: 13, scope: !405)
!409 = !DILocation(line: 37, column: 24, scope: !410)
!410 = distinct !DILexicalBlock(scope: !405, file: !3, line: 37, column: 9)
!411 = !DILocation(line: 37, column: 28, scope: !410)
!412 = !DILocation(line: 37, column: 26, scope: !410)
!413 = !DILocation(line: 37, column: 9, scope: !405)
!414 = !DILocation(line: 38, column: 20, scope: !410)
!415 = !DILocation(line: 38, column: 17, scope: !410)
!416 = !DILocation(line: 38, column: 13, scope: !410)
!417 = !DILocation(line: 37, column: 41, scope: !410)
!418 = !DILocation(line: 37, column: 38, scope: !410)
!419 = !DILocation(line: 37, column: 9, scope: !410)
!420 = distinct !{!420, !413, !421}
!421 = !DILocation(line: 38, column: 20, scope: !405)
!422 = !DILocation(line: 39, column: 5, scope: !373)
!423 = !DILocation(line: 26, column: 32, scope: !367)
!424 = !DILocation(line: 26, column: 5, scope: !367)
!425 = distinct !{!425, !370, !426}
!426 = !DILocation(line: 39, column: 5, scope: !362)
!427 = !DILocation(line: 40, column: 12, scope: !354)
!428 = !DILocation(line: 40, column: 5, scope: !354)
!429 = distinct !DISubprogram(name: "double_nest_partial", linkageName: "_Z19double_nest_partialii", scope: !3, file: !3, line: 44, type: !297, scopeLine: 45, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!430 = !DILocalVariable(name: "x", arg: 1, scope: !429, file: !3, line: 44, type: !20)
!431 = !DILocation(line: 44, column: 29, scope: !429)
!432 = !DILocalVariable(name: "y", arg: 2, scope: !429, file: !3, line: 44, type: !20)
!433 = !DILocation(line: 44, column: 36, scope: !429)
!434 = !DILocalVariable(name: "tmp", scope: !429, file: !3, line: 46, type: !20)
!435 = !DILocation(line: 46, column: 9, scope: !429)
!436 = !DILocalVariable(name: "i", scope: !437, file: !3, line: 48, type: !20)
!437 = distinct !DILexicalBlock(scope: !429, file: !3, line: 48, column: 5)
!438 = !DILocation(line: 48, column: 13, scope: !437)
!439 = !DILocation(line: 48, column: 17, scope: !437)
!440 = !DILocation(line: 48, column: 9, scope: !437)
!441 = !DILocation(line: 48, column: 20, scope: !442)
!442 = distinct !DILexicalBlock(scope: !437, file: !3, line: 48, column: 5)
!443 = !DILocation(line: 48, column: 24, scope: !442)
!444 = !DILocation(line: 48, column: 22, scope: !442)
!445 = !DILocation(line: 48, column: 5, scope: !437)
!446 = !DILocalVariable(name: "j", scope: !447, file: !3, line: 51, type: !20)
!447 = distinct !DILexicalBlock(scope: !448, file: !3, line: 51, column: 9)
!448 = distinct !DILexicalBlock(scope: !442, file: !3, line: 48, column: 40)
!449 = !DILocation(line: 51, column: 17, scope: !447)
!450 = !DILocation(line: 51, column: 13, scope: !447)
!451 = !DILocation(line: 51, column: 24, scope: !452)
!452 = distinct !DILexicalBlock(scope: !447, file: !3, line: 51, column: 9)
!453 = !DILocation(line: 51, column: 26, scope: !452)
!454 = !DILocation(line: 51, column: 9, scope: !447)
!455 = !DILocation(line: 52, column: 20, scope: !452)
!456 = !DILocation(line: 52, column: 17, scope: !452)
!457 = !DILocation(line: 52, column: 13, scope: !452)
!458 = !DILocation(line: 51, column: 33, scope: !452)
!459 = !DILocation(line: 51, column: 9, scope: !452)
!460 = distinct !{!460, !454, !461}
!461 = !DILocation(line: 52, column: 20, scope: !447)
!462 = !DILocalVariable(name: "j", scope: !463, file: !3, line: 55, type: !20)
!463 = distinct !DILexicalBlock(scope: !448, file: !3, line: 55, column: 9)
!464 = !DILocation(line: 55, column: 17, scope: !463)
!465 = !DILocation(line: 55, column: 21, scope: !463)
!466 = !DILocation(line: 55, column: 13, scope: !463)
!467 = !DILocation(line: 55, column: 24, scope: !468)
!468 = distinct !DILexicalBlock(scope: !463, file: !3, line: 55, column: 9)
!469 = !DILocation(line: 55, column: 28, scope: !468)
!470 = !DILocation(line: 55, column: 26, scope: !468)
!471 = !DILocation(line: 55, column: 9, scope: !463)
!472 = !DILocation(line: 56, column: 20, scope: !468)
!473 = !DILocation(line: 56, column: 17, scope: !468)
!474 = !DILocation(line: 56, column: 13, scope: !468)
!475 = !DILocation(line: 55, column: 36, scope: !468)
!476 = !DILocation(line: 55, column: 9, scope: !468)
!477 = distinct !{!477, !471, !478}
!478 = !DILocation(line: 56, column: 20, scope: !463)
!479 = !DILocalVariable(name: "j", scope: !480, file: !3, line: 59, type: !20)
!480 = distinct !DILexicalBlock(scope: !448, file: !3, line: 59, column: 9)
!481 = !DILocation(line: 59, column: 17, scope: !480)
!482 = !DILocation(line: 59, column: 13, scope: !480)
!483 = !DILocation(line: 59, column: 24, scope: !484)
!484 = distinct !DILexicalBlock(scope: !480, file: !3, line: 59, column: 9)
!485 = !DILocation(line: 59, column: 28, scope: !484)
!486 = !DILocation(line: 59, column: 26, scope: !484)
!487 = !DILocation(line: 59, column: 9, scope: !480)
!488 = !DILocation(line: 60, column: 20, scope: !484)
!489 = !DILocation(line: 60, column: 17, scope: !484)
!490 = !DILocation(line: 60, column: 13, scope: !484)
!491 = !DILocation(line: 59, column: 41, scope: !484)
!492 = !DILocation(line: 59, column: 38, scope: !484)
!493 = !DILocation(line: 59, column: 9, scope: !484)
!494 = distinct !{!494, !487, !495}
!495 = !DILocation(line: 60, column: 20, scope: !480)
!496 = !DILocation(line: 61, column: 5, scope: !448)
!497 = !DILocation(line: 48, column: 37, scope: !442)
!498 = !DILocation(line: 48, column: 34, scope: !442)
!499 = !DILocation(line: 48, column: 5, scope: !442)
!500 = distinct !{!500, !445, !501}
!501 = !DILocation(line: 61, column: 5, scope: !437)
!502 = !DILocalVariable(name: "i", scope: !503, file: !3, line: 64, type: !20)
!503 = distinct !DILexicalBlock(scope: !429, file: !3, line: 64, column: 5)
!504 = !DILocation(line: 64, column: 13, scope: !503)
!505 = !DILocation(line: 64, column: 17, scope: !503)
!506 = !DILocation(line: 64, column: 9, scope: !503)
!507 = !DILocation(line: 64, column: 20, scope: !508)
!508 = distinct !DILexicalBlock(scope: !503, file: !3, line: 64, column: 5)
!509 = !DILocation(line: 64, column: 24, scope: !508)
!510 = !DILocation(line: 64, column: 22, scope: !508)
!511 = !DILocation(line: 64, column: 5, scope: !503)
!512 = !DILocalVariable(name: "j", scope: !513, file: !3, line: 67, type: !20)
!513 = distinct !DILexicalBlock(scope: !514, file: !3, line: 67, column: 9)
!514 = distinct !DILexicalBlock(scope: !508, file: !3, line: 64, column: 37)
!515 = !DILocation(line: 67, column: 17, scope: !513)
!516 = !DILocation(line: 67, column: 13, scope: !513)
!517 = !DILocation(line: 67, column: 24, scope: !518)
!518 = distinct !DILexicalBlock(scope: !513, file: !3, line: 67, column: 9)
!519 = !DILocation(line: 67, column: 28, scope: !518)
!520 = !DILocation(line: 67, column: 26, scope: !518)
!521 = !DILocation(line: 67, column: 9, scope: !513)
!522 = !DILocation(line: 68, column: 20, scope: !518)
!523 = !DILocation(line: 68, column: 17, scope: !518)
!524 = !DILocation(line: 68, column: 13, scope: !518)
!525 = !DILocation(line: 67, column: 31, scope: !518)
!526 = !DILocation(line: 67, column: 9, scope: !518)
!527 = distinct !{!527, !521, !528}
!528 = !DILocation(line: 68, column: 20, scope: !513)
!529 = !DILocalVariable(name: "j", scope: !530, file: !3, line: 71, type: !20)
!530 = distinct !DILexicalBlock(scope: !514, file: !3, line: 71, column: 9)
!531 = !DILocation(line: 71, column: 17, scope: !530)
!532 = !DILocation(line: 71, column: 13, scope: !530)
!533 = !DILocation(line: 71, column: 24, scope: !534)
!534 = distinct !DILexicalBlock(scope: !530, file: !3, line: 71, column: 9)
!535 = !DILocation(line: 71, column: 28, scope: !534)
!536 = !DILocation(line: 71, column: 26, scope: !534)
!537 = !DILocation(line: 71, column: 9, scope: !530)
!538 = !DILocation(line: 72, column: 20, scope: !534)
!539 = !DILocation(line: 72, column: 17, scope: !534)
!540 = !DILocation(line: 72, column: 13, scope: !534)
!541 = !DILocation(line: 71, column: 36, scope: !534)
!542 = !DILocation(line: 71, column: 9, scope: !534)
!543 = distinct !{!543, !537, !544}
!544 = !DILocation(line: 72, column: 20, scope: !530)
!545 = !DILocalVariable(name: "j", scope: !546, file: !3, line: 75, type: !20)
!546 = distinct !DILexicalBlock(scope: !514, file: !3, line: 75, column: 9)
!547 = !DILocation(line: 75, column: 17, scope: !546)
!548 = !DILocation(line: 75, column: 21, scope: !546)
!549 = !DILocation(line: 75, column: 13, scope: !546)
!550 = !DILocation(line: 75, column: 24, scope: !551)
!551 = distinct !DILexicalBlock(scope: !546, file: !3, line: 75, column: 9)
!552 = !DILocation(line: 75, column: 28, scope: !551)
!553 = !DILocation(line: 75, column: 26, scope: !551)
!554 = !DILocation(line: 75, column: 9, scope: !546)
!555 = !DILocation(line: 76, column: 20, scope: !551)
!556 = !DILocation(line: 76, column: 17, scope: !551)
!557 = !DILocation(line: 76, column: 13, scope: !551)
!558 = !DILocation(line: 75, column: 41, scope: !551)
!559 = !DILocation(line: 75, column: 38, scope: !551)
!560 = !DILocation(line: 75, column: 9, scope: !551)
!561 = distinct !{!561, !554, !562}
!562 = !DILocation(line: 76, column: 20, scope: !546)
!563 = !DILocation(line: 77, column: 5, scope: !514)
!564 = !DILocation(line: 64, column: 32, scope: !508)
!565 = !DILocation(line: 64, column: 5, scope: !508)
!566 = distinct !{!566, !511, !567}
!567 = !DILocation(line: 77, column: 5, scope: !503)
!568 = !DILocation(line: 78, column: 12, scope: !429)
!569 = !DILocation(line: 78, column: 5, scope: !429)
!570 = distinct !DISubprogram(name: "nest_triple", linkageName: "_Z11nest_tripleii", scope: !3, file: !3, line: 82, type: !297, scopeLine: 83, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!571 = !DILocalVariable(name: "x", arg: 1, scope: !570, file: !3, line: 82, type: !20)
!572 = !DILocation(line: 82, column: 21, scope: !570)
!573 = !DILocalVariable(name: "y", arg: 2, scope: !570, file: !3, line: 82, type: !20)
!574 = !DILocation(line: 82, column: 28, scope: !570)
!575 = !DILocalVariable(name: "tmp", scope: !570, file: !3, line: 84, type: !20)
!576 = !DILocation(line: 84, column: 9, scope: !570)
!577 = !DILocalVariable(name: "i", scope: !578, file: !3, line: 86, type: !20)
!578 = distinct !DILexicalBlock(scope: !570, file: !3, line: 86, column: 5)
!579 = !DILocation(line: 86, column: 13, scope: !578)
!580 = !DILocation(line: 86, column: 17, scope: !578)
!581 = !DILocation(line: 86, column: 9, scope: !578)
!582 = !DILocation(line: 86, column: 20, scope: !583)
!583 = distinct !DILexicalBlock(scope: !578, file: !3, line: 86, column: 5)
!584 = !DILocation(line: 86, column: 24, scope: !583)
!585 = !DILocation(line: 86, column: 22, scope: !583)
!586 = !DILocation(line: 86, column: 5, scope: !578)
!587 = !DILocalVariable(name: "j", scope: !588, file: !3, line: 89, type: !20)
!588 = distinct !DILexicalBlock(scope: !589, file: !3, line: 89, column: 9)
!589 = distinct !DILexicalBlock(scope: !583, file: !3, line: 86, column: 37)
!590 = !DILocation(line: 89, column: 17, scope: !588)
!591 = !DILocation(line: 89, column: 13, scope: !588)
!592 = !DILocation(line: 89, column: 24, scope: !593)
!593 = distinct !DILexicalBlock(scope: !588, file: !3, line: 89, column: 9)
!594 = !DILocation(line: 89, column: 28, scope: !593)
!595 = !DILocation(line: 89, column: 26, scope: !593)
!596 = !DILocation(line: 89, column: 9, scope: !588)
!597 = !DILocalVariable(name: "k", scope: !598, file: !3, line: 91, type: !20)
!598 = distinct !DILexicalBlock(scope: !599, file: !3, line: 91, column: 13)
!599 = distinct !DILexicalBlock(scope: !593, file: !3, line: 89, column: 36)
!600 = !DILocation(line: 91, column: 21, scope: !598)
!601 = !DILocation(line: 91, column: 25, scope: !598)
!602 = !DILocation(line: 91, column: 17, scope: !598)
!603 = !DILocation(line: 91, column: 28, scope: !604)
!604 = distinct !DILexicalBlock(scope: !598, file: !3, line: 91, column: 13)
!605 = !DILocation(line: 91, column: 32, scope: !604)
!606 = !DILocation(line: 91, column: 30, scope: !604)
!607 = !DILocation(line: 91, column: 13, scope: !598)
!608 = !DILocation(line: 92, column: 24, scope: !604)
!609 = !DILocation(line: 92, column: 21, scope: !604)
!610 = !DILocation(line: 92, column: 17, scope: !604)
!611 = !DILocation(line: 91, column: 45, scope: !604)
!612 = !DILocation(line: 91, column: 42, scope: !604)
!613 = !DILocation(line: 91, column: 13, scope: !604)
!614 = distinct !{!614, !607, !615}
!615 = !DILocation(line: 92, column: 24, scope: !598)
!616 = !DILocation(line: 93, column: 9, scope: !599)
!617 = !DILocation(line: 89, column: 31, scope: !593)
!618 = !DILocation(line: 89, column: 9, scope: !593)
!619 = distinct !{!619, !596, !620}
!620 = !DILocation(line: 93, column: 9, scope: !588)
!621 = !DILocalVariable(name: "j", scope: !622, file: !3, line: 96, type: !20)
!622 = distinct !DILexicalBlock(scope: !589, file: !3, line: 96, column: 9)
!623 = !DILocation(line: 96, column: 17, scope: !622)
!624 = !DILocation(line: 96, column: 13, scope: !622)
!625 = !DILocation(line: 96, column: 24, scope: !626)
!626 = distinct !DILexicalBlock(scope: !622, file: !3, line: 96, column: 9)
!627 = !DILocation(line: 96, column: 26, scope: !626)
!628 = !DILocation(line: 96, column: 9, scope: !622)
!629 = !DILocalVariable(name: "k", scope: !630, file: !3, line: 98, type: !20)
!630 = distinct !DILexicalBlock(scope: !631, file: !3, line: 98, column: 13)
!631 = distinct !DILexicalBlock(scope: !626, file: !3, line: 96, column: 37)
!632 = !DILocation(line: 98, column: 21, scope: !630)
!633 = !DILocation(line: 98, column: 25, scope: !630)
!634 = !DILocation(line: 98, column: 17, scope: !630)
!635 = !DILocation(line: 98, column: 28, scope: !636)
!636 = distinct !DILexicalBlock(scope: !630, file: !3, line: 98, column: 13)
!637 = !DILocation(line: 98, column: 32, scope: !636)
!638 = !DILocation(line: 98, column: 30, scope: !636)
!639 = !DILocation(line: 98, column: 13, scope: !630)
!640 = !DILocation(line: 99, column: 24, scope: !636)
!641 = !DILocation(line: 99, column: 21, scope: !636)
!642 = !DILocation(line: 99, column: 17, scope: !636)
!643 = !DILocation(line: 98, column: 45, scope: !636)
!644 = !DILocation(line: 98, column: 42, scope: !636)
!645 = !DILocation(line: 98, column: 13, scope: !636)
!646 = distinct !{!646, !639, !647}
!647 = !DILocation(line: 99, column: 24, scope: !630)
!648 = !DILocalVariable(name: "k", scope: !649, file: !3, line: 101, type: !20)
!649 = distinct !DILexicalBlock(scope: !631, file: !3, line: 101, column: 13)
!650 = !DILocation(line: 101, column: 21, scope: !649)
!651 = !DILocation(line: 101, column: 17, scope: !649)
!652 = !DILocation(line: 101, column: 28, scope: !653)
!653 = distinct !DILexicalBlock(scope: !649, file: !3, line: 101, column: 13)
!654 = !DILocation(line: 101, column: 32, scope: !653)
!655 = !DILocation(line: 101, column: 30, scope: !653)
!656 = !DILocation(line: 101, column: 13, scope: !649)
!657 = !DILocation(line: 102, column: 24, scope: !653)
!658 = !DILocation(line: 102, column: 21, scope: !653)
!659 = !DILocation(line: 102, column: 17, scope: !653)
!660 = !DILocation(line: 101, column: 36, scope: !653)
!661 = !DILocation(line: 101, column: 13, scope: !653)
!662 = distinct !{!662, !656, !663}
!663 = !DILocation(line: 102, column: 24, scope: !649)
!664 = !DILocation(line: 103, column: 9, scope: !631)
!665 = !DILocation(line: 96, column: 32, scope: !626)
!666 = !DILocation(line: 96, column: 9, scope: !626)
!667 = distinct !{!667, !628, !668}
!668 = !DILocation(line: 103, column: 9, scope: !622)
!669 = !DILocation(line: 104, column: 5, scope: !589)
!670 = !DILocation(line: 86, column: 32, scope: !583)
!671 = !DILocation(line: 86, column: 5, scope: !583)
!672 = distinct !{!672, !586, !673}
!673 = !DILocation(line: 104, column: 5, scope: !578)
!674 = !DILocation(line: 105, column: 12, scope: !570)
!675 = !DILocation(line: 105, column: 5, scope: !570)
!676 = distinct !DISubprogram(name: "double_nest_triple", linkageName: "_Z18double_nest_tripleii", scope: !3, file: !3, line: 109, type: !297, scopeLine: 110, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!677 = !DILocalVariable(name: "x", arg: 1, scope: !676, file: !3, line: 109, type: !20)
!678 = !DILocation(line: 109, column: 28, scope: !676)
!679 = !DILocalVariable(name: "y", arg: 2, scope: !676, file: !3, line: 109, type: !20)
!680 = !DILocation(line: 109, column: 35, scope: !676)
!681 = !DILocalVariable(name: "tmp", scope: !676, file: !3, line: 111, type: !20)
!682 = !DILocation(line: 111, column: 9, scope: !676)
!683 = !DILocalVariable(name: "i", scope: !684, file: !3, line: 113, type: !20)
!684 = distinct !DILexicalBlock(scope: !676, file: !3, line: 113, column: 5)
!685 = !DILocation(line: 113, column: 13, scope: !684)
!686 = !DILocation(line: 113, column: 17, scope: !684)
!687 = !DILocation(line: 113, column: 9, scope: !684)
!688 = !DILocation(line: 113, column: 20, scope: !689)
!689 = distinct !DILexicalBlock(scope: !684, file: !3, line: 113, column: 5)
!690 = !DILocation(line: 113, column: 24, scope: !689)
!691 = !DILocation(line: 113, column: 22, scope: !689)
!692 = !DILocation(line: 113, column: 5, scope: !684)
!693 = !DILocalVariable(name: "j", scope: !694, file: !3, line: 115, type: !20)
!694 = distinct !DILexicalBlock(scope: !695, file: !3, line: 115, column: 9)
!695 = distinct !DILexicalBlock(scope: !689, file: !3, line: 113, column: 37)
!696 = !DILocation(line: 115, column: 17, scope: !694)
!697 = !DILocation(line: 115, column: 13, scope: !694)
!698 = !DILocation(line: 115, column: 24, scope: !699)
!699 = distinct !DILexicalBlock(scope: !694, file: !3, line: 115, column: 9)
!700 = !DILocation(line: 115, column: 28, scope: !699)
!701 = !DILocation(line: 115, column: 26, scope: !699)
!702 = !DILocation(line: 115, column: 9, scope: !694)
!703 = !DILocalVariable(name: "k", scope: !704, file: !3, line: 117, type: !20)
!704 = distinct !DILexicalBlock(scope: !705, file: !3, line: 117, column: 13)
!705 = distinct !DILexicalBlock(scope: !699, file: !3, line: 115, column: 36)
!706 = !DILocation(line: 117, column: 21, scope: !704)
!707 = !DILocation(line: 117, column: 25, scope: !704)
!708 = !DILocation(line: 117, column: 17, scope: !704)
!709 = !DILocation(line: 117, column: 28, scope: !710)
!710 = distinct !DILexicalBlock(scope: !704, file: !3, line: 117, column: 13)
!711 = !DILocation(line: 117, column: 32, scope: !710)
!712 = !DILocation(line: 117, column: 30, scope: !710)
!713 = !DILocation(line: 117, column: 13, scope: !704)
!714 = !DILocation(line: 118, column: 24, scope: !710)
!715 = !DILocation(line: 118, column: 21, scope: !710)
!716 = !DILocation(line: 118, column: 17, scope: !710)
!717 = !DILocation(line: 117, column: 45, scope: !710)
!718 = !DILocation(line: 117, column: 42, scope: !710)
!719 = !DILocation(line: 117, column: 13, scope: !710)
!720 = distinct !{!720, !713, !721}
!721 = !DILocation(line: 118, column: 24, scope: !704)
!722 = !DILocation(line: 119, column: 9, scope: !705)
!723 = !DILocation(line: 115, column: 31, scope: !699)
!724 = !DILocation(line: 115, column: 9, scope: !699)
!725 = distinct !{!725, !702, !726}
!726 = !DILocation(line: 119, column: 9, scope: !694)
!727 = !DILocalVariable(name: "j", scope: !728, file: !3, line: 122, type: !20)
!728 = distinct !DILexicalBlock(scope: !695, file: !3, line: 122, column: 9)
!729 = !DILocation(line: 122, column: 17, scope: !728)
!730 = !DILocation(line: 122, column: 13, scope: !728)
!731 = !DILocation(line: 122, column: 24, scope: !732)
!732 = distinct !DILexicalBlock(scope: !728, file: !3, line: 122, column: 9)
!733 = !DILocation(line: 122, column: 26, scope: !732)
!734 = !DILocation(line: 122, column: 9, scope: !728)
!735 = !DILocalVariable(name: "k", scope: !736, file: !3, line: 124, type: !20)
!736 = distinct !DILexicalBlock(scope: !737, file: !3, line: 124, column: 13)
!737 = distinct !DILexicalBlock(scope: !732, file: !3, line: 122, column: 37)
!738 = !DILocation(line: 124, column: 21, scope: !736)
!739 = !DILocation(line: 124, column: 25, scope: !736)
!740 = !DILocation(line: 124, column: 17, scope: !736)
!741 = !DILocation(line: 124, column: 28, scope: !742)
!742 = distinct !DILexicalBlock(scope: !736, file: !3, line: 124, column: 13)
!743 = !DILocation(line: 124, column: 32, scope: !742)
!744 = !DILocation(line: 124, column: 30, scope: !742)
!745 = !DILocation(line: 124, column: 13, scope: !736)
!746 = !DILocation(line: 125, column: 24, scope: !742)
!747 = !DILocation(line: 125, column: 21, scope: !742)
!748 = !DILocation(line: 125, column: 17, scope: !742)
!749 = !DILocation(line: 124, column: 45, scope: !742)
!750 = !DILocation(line: 124, column: 42, scope: !742)
!751 = !DILocation(line: 124, column: 13, scope: !742)
!752 = distinct !{!752, !745, !753}
!753 = !DILocation(line: 125, column: 24, scope: !736)
!754 = !DILocalVariable(name: "k", scope: !755, file: !3, line: 127, type: !20)
!755 = distinct !DILexicalBlock(scope: !737, file: !3, line: 127, column: 13)
!756 = !DILocation(line: 127, column: 21, scope: !755)
!757 = !DILocation(line: 127, column: 17, scope: !755)
!758 = !DILocation(line: 127, column: 28, scope: !759)
!759 = distinct !DILexicalBlock(scope: !755, file: !3, line: 127, column: 13)
!760 = !DILocation(line: 127, column: 32, scope: !759)
!761 = !DILocation(line: 127, column: 30, scope: !759)
!762 = !DILocation(line: 127, column: 13, scope: !755)
!763 = !DILocation(line: 128, column: 24, scope: !759)
!764 = !DILocation(line: 128, column: 21, scope: !759)
!765 = !DILocation(line: 128, column: 17, scope: !759)
!766 = !DILocation(line: 127, column: 36, scope: !759)
!767 = !DILocation(line: 127, column: 13, scope: !759)
!768 = distinct !{!768, !762, !769}
!769 = !DILocation(line: 128, column: 24, scope: !755)
!770 = !DILocation(line: 129, column: 9, scope: !737)
!771 = !DILocation(line: 122, column: 32, scope: !732)
!772 = !DILocation(line: 122, column: 9, scope: !732)
!773 = distinct !{!773, !734, !774}
!774 = !DILocation(line: 129, column: 9, scope: !728)
!775 = !DILocation(line: 130, column: 5, scope: !695)
!776 = !DILocation(line: 113, column: 32, scope: !689)
!777 = !DILocation(line: 113, column: 5, scope: !689)
!778 = distinct !{!778, !692, !779}
!779 = !DILocation(line: 130, column: 5, scope: !684)
!780 = !DILocalVariable(name: "i", scope: !781, file: !3, line: 133, type: !20)
!781 = distinct !DILexicalBlock(scope: !676, file: !3, line: 133, column: 5)
!782 = !DILocation(line: 133, column: 13, scope: !781)
!783 = !DILocation(line: 133, column: 17, scope: !781)
!784 = !DILocation(line: 133, column: 9, scope: !781)
!785 = !DILocation(line: 133, column: 20, scope: !786)
!786 = distinct !DILexicalBlock(scope: !781, file: !3, line: 133, column: 5)
!787 = !DILocation(line: 133, column: 24, scope: !786)
!788 = !DILocation(line: 133, column: 22, scope: !786)
!789 = !DILocation(line: 133, column: 5, scope: !781)
!790 = !DILocalVariable(name: "j", scope: !791, file: !3, line: 135, type: !20)
!791 = distinct !DILexicalBlock(scope: !792, file: !3, line: 135, column: 9)
!792 = distinct !DILexicalBlock(scope: !786, file: !3, line: 133, column: 37)
!793 = !DILocation(line: 135, column: 17, scope: !791)
!794 = !DILocation(line: 135, column: 13, scope: !791)
!795 = !DILocation(line: 135, column: 24, scope: !796)
!796 = distinct !DILexicalBlock(scope: !791, file: !3, line: 135, column: 9)
!797 = !DILocation(line: 135, column: 28, scope: !796)
!798 = !DILocation(line: 135, column: 26, scope: !796)
!799 = !DILocation(line: 135, column: 9, scope: !791)
!800 = !DILocalVariable(name: "k", scope: !801, file: !3, line: 137, type: !20)
!801 = distinct !DILexicalBlock(scope: !802, file: !3, line: 137, column: 13)
!802 = distinct !DILexicalBlock(scope: !796, file: !3, line: 135, column: 36)
!803 = !DILocation(line: 137, column: 21, scope: !801)
!804 = !DILocation(line: 137, column: 25, scope: !801)
!805 = !DILocation(line: 137, column: 17, scope: !801)
!806 = !DILocation(line: 137, column: 28, scope: !807)
!807 = distinct !DILexicalBlock(scope: !801, file: !3, line: 137, column: 13)
!808 = !DILocation(line: 137, column: 32, scope: !807)
!809 = !DILocation(line: 137, column: 30, scope: !807)
!810 = !DILocation(line: 137, column: 13, scope: !801)
!811 = !DILocation(line: 138, column: 24, scope: !807)
!812 = !DILocation(line: 138, column: 21, scope: !807)
!813 = !DILocation(line: 138, column: 17, scope: !807)
!814 = !DILocation(line: 137, column: 45, scope: !807)
!815 = !DILocation(line: 137, column: 42, scope: !807)
!816 = !DILocation(line: 137, column: 13, scope: !807)
!817 = distinct !{!817, !810, !818}
!818 = !DILocation(line: 138, column: 24, scope: !801)
!819 = !DILocalVariable(name: "k", scope: !820, file: !3, line: 140, type: !20)
!820 = distinct !DILexicalBlock(scope: !802, file: !3, line: 140, column: 13)
!821 = !DILocation(line: 140, column: 21, scope: !820)
!822 = !DILocation(line: 140, column: 17, scope: !820)
!823 = !DILocation(line: 140, column: 28, scope: !824)
!824 = distinct !DILexicalBlock(scope: !820, file: !3, line: 140, column: 13)
!825 = !DILocation(line: 140, column: 32, scope: !824)
!826 = !DILocation(line: 140, column: 30, scope: !824)
!827 = !DILocation(line: 140, column: 13, scope: !820)
!828 = !DILocation(line: 141, column: 24, scope: !824)
!829 = !DILocation(line: 141, column: 21, scope: !824)
!830 = !DILocation(line: 141, column: 17, scope: !824)
!831 = !DILocation(line: 140, column: 36, scope: !824)
!832 = !DILocation(line: 140, column: 13, scope: !824)
!833 = distinct !{!833, !827, !834}
!834 = !DILocation(line: 141, column: 24, scope: !820)
!835 = !DILocation(line: 142, column: 9, scope: !802)
!836 = !DILocation(line: 135, column: 31, scope: !796)
!837 = !DILocation(line: 135, column: 9, scope: !796)
!838 = distinct !{!838, !799, !839}
!839 = !DILocation(line: 142, column: 9, scope: !791)
!840 = !DILocalVariable(name: "j", scope: !841, file: !3, line: 145, type: !20)
!841 = distinct !DILexicalBlock(scope: !792, file: !3, line: 145, column: 9)
!842 = !DILocation(line: 145, column: 17, scope: !841)
!843 = !DILocation(line: 145, column: 13, scope: !841)
!844 = !DILocation(line: 145, column: 24, scope: !845)
!845 = distinct !DILexicalBlock(scope: !841, file: !3, line: 145, column: 9)
!846 = !DILocation(line: 145, column: 26, scope: !845)
!847 = !DILocation(line: 145, column: 9, scope: !841)
!848 = !DILocalVariable(name: "k", scope: !849, file: !3, line: 147, type: !20)
!849 = distinct !DILexicalBlock(scope: !850, file: !3, line: 147, column: 13)
!850 = distinct !DILexicalBlock(scope: !845, file: !3, line: 145, column: 37)
!851 = !DILocation(line: 147, column: 21, scope: !849)
!852 = !DILocation(line: 147, column: 25, scope: !849)
!853 = !DILocation(line: 147, column: 17, scope: !849)
!854 = !DILocation(line: 147, column: 28, scope: !855)
!855 = distinct !DILexicalBlock(scope: !849, file: !3, line: 147, column: 13)
!856 = !DILocation(line: 147, column: 32, scope: !855)
!857 = !DILocation(line: 147, column: 30, scope: !855)
!858 = !DILocation(line: 147, column: 13, scope: !849)
!859 = !DILocation(line: 148, column: 24, scope: !855)
!860 = !DILocation(line: 148, column: 21, scope: !855)
!861 = !DILocation(line: 148, column: 17, scope: !855)
!862 = !DILocation(line: 147, column: 45, scope: !855)
!863 = !DILocation(line: 147, column: 42, scope: !855)
!864 = !DILocation(line: 147, column: 13, scope: !855)
!865 = distinct !{!865, !858, !866}
!866 = !DILocation(line: 148, column: 24, scope: !849)
!867 = !DILocalVariable(name: "k", scope: !868, file: !3, line: 150, type: !20)
!868 = distinct !DILexicalBlock(scope: !850, file: !3, line: 150, column: 13)
!869 = !DILocation(line: 150, column: 21, scope: !868)
!870 = !DILocation(line: 150, column: 17, scope: !868)
!871 = !DILocation(line: 150, column: 28, scope: !872)
!872 = distinct !DILexicalBlock(scope: !868, file: !3, line: 150, column: 13)
!873 = !DILocation(line: 150, column: 32, scope: !872)
!874 = !DILocation(line: 150, column: 30, scope: !872)
!875 = !DILocation(line: 150, column: 13, scope: !868)
!876 = !DILocation(line: 151, column: 24, scope: !872)
!877 = !DILocation(line: 151, column: 21, scope: !872)
!878 = !DILocation(line: 151, column: 17, scope: !872)
!879 = !DILocation(line: 150, column: 36, scope: !872)
!880 = !DILocation(line: 150, column: 13, scope: !872)
!881 = distinct !{!881, !875, !882}
!882 = !DILocation(line: 151, column: 24, scope: !868)
!883 = !DILocation(line: 152, column: 9, scope: !850)
!884 = !DILocation(line: 145, column: 32, scope: !845)
!885 = !DILocation(line: 145, column: 9, scope: !845)
!886 = distinct !{!886, !847, !887}
!887 = !DILocation(line: 152, column: 9, scope: !841)
!888 = !DILocalVariable(name: "j", scope: !889, file: !3, line: 154, type: !20)
!889 = distinct !DILexicalBlock(scope: !792, file: !3, line: 154, column: 9)
!890 = !DILocation(line: 154, column: 17, scope: !889)
!891 = !DILocation(line: 154, column: 13, scope: !889)
!892 = !DILocation(line: 154, column: 24, scope: !893)
!893 = distinct !DILexicalBlock(scope: !889, file: !3, line: 154, column: 9)
!894 = !DILocation(line: 154, column: 28, scope: !893)
!895 = !DILocation(line: 154, column: 34, scope: !893)
!896 = !DILocation(line: 154, column: 26, scope: !893)
!897 = !DILocation(line: 154, column: 9, scope: !889)
!898 = !DILocation(line: 155, column: 20, scope: !893)
!899 = !DILocation(line: 155, column: 17, scope: !893)
!900 = !DILocation(line: 155, column: 13, scope: !893)
!901 = !DILocation(line: 154, column: 44, scope: !893)
!902 = !DILocation(line: 154, column: 41, scope: !893)
!903 = !DILocation(line: 154, column: 9, scope: !893)
!904 = distinct !{!904, !897, !905}
!905 = !DILocation(line: 155, column: 20, scope: !889)
!906 = !DILocation(line: 157, column: 5, scope: !792)
!907 = !DILocation(line: 133, column: 32, scope: !786)
!908 = !DILocation(line: 133, column: 5, scope: !786)
!909 = distinct !{!909, !789, !910}
!910 = !DILocation(line: 157, column: 5, scope: !781)
!911 = !DILocation(line: 160, column: 21, scope: !676)
!912 = !DILocation(line: 160, column: 5, scope: !676)
!913 = !DILocation(line: 162, column: 12, scope: !676)
!914 = !DILocation(line: 162, column: 5, scope: !676)
!915 = distinct !DISubprogram(name: "three_loops", linkageName: "_Z11three_loopsii", scope: !3, file: !3, line: 165, type: !297, scopeLine: 166, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!916 = !DILocalVariable(name: "x", arg: 1, scope: !915, file: !3, line: 165, type: !20)
!917 = !DILocation(line: 165, column: 21, scope: !915)
!918 = !DILocalVariable(name: "y", arg: 2, scope: !915, file: !3, line: 165, type: !20)
!919 = !DILocation(line: 165, column: 28, scope: !915)
!920 = !DILocalVariable(name: "tmp", scope: !915, file: !3, line: 167, type: !20)
!921 = !DILocation(line: 167, column: 9, scope: !915)
!922 = !DILocalVariable(name: "i", scope: !923, file: !3, line: 169, type: !20)
!923 = distinct !DILexicalBlock(scope: !915, file: !3, line: 169, column: 5)
!924 = !DILocation(line: 169, column: 13, scope: !923)
!925 = !DILocation(line: 169, column: 9, scope: !923)
!926 = !DILocation(line: 169, column: 20, scope: !927)
!927 = distinct !DILexicalBlock(scope: !923, file: !3, line: 169, column: 5)
!928 = !DILocation(line: 169, column: 24, scope: !927)
!929 = !DILocation(line: 169, column: 22, scope: !927)
!930 = !DILocation(line: 169, column: 5, scope: !923)
!931 = !DILocalVariable(name: "j", scope: !932, file: !3, line: 170, type: !20)
!932 = distinct !DILexicalBlock(scope: !933, file: !3, line: 170, column: 9)
!933 = distinct !DILexicalBlock(scope: !927, file: !3, line: 169, column: 37)
!934 = !DILocation(line: 170, column: 17, scope: !932)
!935 = !DILocation(line: 170, column: 13, scope: !932)
!936 = !DILocation(line: 170, column: 24, scope: !937)
!937 = distinct !DILexicalBlock(scope: !932, file: !3, line: 170, column: 9)
!938 = !DILocation(line: 170, column: 28, scope: !937)
!939 = !DILocation(line: 170, column: 26, scope: !937)
!940 = !DILocation(line: 170, column: 9, scope: !932)
!941 = !DILocalVariable(name: "k", scope: !942, file: !3, line: 171, type: !20)
!942 = distinct !DILexicalBlock(scope: !943, file: !3, line: 171, column: 13)
!943 = distinct !DILexicalBlock(scope: !937, file: !3, line: 170, column: 41)
!944 = !DILocation(line: 171, column: 21, scope: !942)
!945 = !DILocation(line: 171, column: 17, scope: !942)
!946 = !DILocation(line: 171, column: 28, scope: !947)
!947 = distinct !DILexicalBlock(scope: !942, file: !3, line: 171, column: 13)
!948 = !DILocation(line: 171, column: 30, scope: !947)
!949 = !DILocation(line: 171, column: 13, scope: !942)
!950 = !DILocation(line: 172, column: 24, scope: !947)
!951 = !DILocation(line: 172, column: 21, scope: !947)
!952 = !DILocation(line: 172, column: 17, scope: !947)
!953 = !DILocation(line: 171, column: 37, scope: !947)
!954 = !DILocation(line: 171, column: 13, scope: !947)
!955 = distinct !{!955, !949, !956}
!956 = !DILocation(line: 172, column: 24, scope: !942)
!957 = !DILocation(line: 173, column: 9, scope: !943)
!958 = !DILocation(line: 170, column: 36, scope: !937)
!959 = !DILocation(line: 170, column: 9, scope: !937)
!960 = distinct !{!960, !940, !961}
!961 = !DILocation(line: 173, column: 9, scope: !932)
!962 = !DILocation(line: 174, column: 5, scope: !933)
!963 = !DILocation(line: 169, column: 32, scope: !927)
!964 = !DILocation(line: 169, column: 5, scope: !927)
!965 = distinct !{!965, !930, !966}
!966 = !DILocation(line: 174, column: 5, scope: !923)
!967 = !DILocalVariable(name: "i", scope: !968, file: !3, line: 177, type: !20)
!968 = distinct !DILexicalBlock(scope: !915, file: !3, line: 177, column: 5)
!969 = !DILocation(line: 177, column: 13, scope: !968)
!970 = !DILocation(line: 177, column: 17, scope: !968)
!971 = !DILocation(line: 177, column: 9, scope: !968)
!972 = !DILocation(line: 177, column: 20, scope: !973)
!973 = distinct !DILexicalBlock(scope: !968, file: !3, line: 177, column: 5)
!974 = !DILocation(line: 177, column: 24, scope: !973)
!975 = !DILocation(line: 177, column: 22, scope: !973)
!976 = !DILocation(line: 177, column: 5, scope: !968)
!977 = !DILocalVariable(name: "j", scope: !978, file: !3, line: 179, type: !20)
!978 = distinct !DILexicalBlock(scope: !979, file: !3, line: 179, column: 9)
!979 = distinct !DILexicalBlock(scope: !973, file: !3, line: 177, column: 37)
!980 = !DILocation(line: 179, column: 17, scope: !978)
!981 = !DILocation(line: 179, column: 13, scope: !978)
!982 = !DILocation(line: 179, column: 24, scope: !983)
!983 = distinct !DILexicalBlock(scope: !978, file: !3, line: 179, column: 9)
!984 = !DILocation(line: 179, column: 28, scope: !983)
!985 = !DILocation(line: 179, column: 26, scope: !983)
!986 = !DILocation(line: 179, column: 9, scope: !978)
!987 = !DILocalVariable(name: "k", scope: !988, file: !3, line: 181, type: !20)
!988 = distinct !DILexicalBlock(scope: !989, file: !3, line: 181, column: 13)
!989 = distinct !DILexicalBlock(scope: !983, file: !3, line: 179, column: 36)
!990 = !DILocation(line: 181, column: 21, scope: !988)
!991 = !DILocation(line: 181, column: 25, scope: !988)
!992 = !DILocation(line: 181, column: 17, scope: !988)
!993 = !DILocation(line: 181, column: 28, scope: !994)
!994 = distinct !DILexicalBlock(scope: !988, file: !3, line: 181, column: 13)
!995 = !DILocation(line: 181, column: 32, scope: !994)
!996 = !DILocation(line: 181, column: 30, scope: !994)
!997 = !DILocation(line: 181, column: 13, scope: !988)
!998 = !DILocation(line: 182, column: 24, scope: !994)
!999 = !DILocation(line: 182, column: 21, scope: !994)
!1000 = !DILocation(line: 182, column: 17, scope: !994)
!1001 = !DILocation(line: 181, column: 45, scope: !994)
!1002 = !DILocation(line: 181, column: 42, scope: !994)
!1003 = !DILocation(line: 181, column: 13, scope: !994)
!1004 = distinct !{!1004, !997, !1005}
!1005 = !DILocation(line: 182, column: 24, scope: !988)
!1006 = !DILocalVariable(name: "k", scope: !1007, file: !3, line: 184, type: !20)
!1007 = distinct !DILexicalBlock(scope: !989, file: !3, line: 184, column: 13)
!1008 = !DILocation(line: 184, column: 21, scope: !1007)
!1009 = !DILocation(line: 184, column: 17, scope: !1007)
!1010 = !DILocation(line: 184, column: 28, scope: !1011)
!1011 = distinct !DILexicalBlock(scope: !1007, file: !3, line: 184, column: 13)
!1012 = !DILocation(line: 184, column: 32, scope: !1011)
!1013 = !DILocation(line: 184, column: 30, scope: !1011)
!1014 = !DILocation(line: 184, column: 13, scope: !1007)
!1015 = !DILocation(line: 185, column: 24, scope: !1011)
!1016 = !DILocation(line: 185, column: 21, scope: !1011)
!1017 = !DILocation(line: 185, column: 17, scope: !1011)
!1018 = !DILocation(line: 184, column: 36, scope: !1011)
!1019 = !DILocation(line: 184, column: 13, scope: !1011)
!1020 = distinct !{!1020, !1014, !1021}
!1021 = !DILocation(line: 185, column: 24, scope: !1007)
!1022 = !DILocation(line: 186, column: 9, scope: !989)
!1023 = !DILocation(line: 179, column: 31, scope: !983)
!1024 = !DILocation(line: 179, column: 9, scope: !983)
!1025 = distinct !{!1025, !986, !1026}
!1026 = !DILocation(line: 186, column: 9, scope: !978)
!1027 = !DILocation(line: 187, column: 5, scope: !979)
!1028 = !DILocation(line: 177, column: 32, scope: !973)
!1029 = !DILocation(line: 177, column: 5, scope: !973)
!1030 = distinct !{!1030, !976, !1031}
!1031 = !DILocation(line: 187, column: 5, scope: !968)
!1032 = !DILocalVariable(name: "i", scope: !1033, file: !3, line: 190, type: !20)
!1033 = distinct !DILexicalBlock(scope: !915, file: !3, line: 190, column: 5)
!1034 = !DILocation(line: 190, column: 13, scope: !1033)
!1035 = !DILocation(line: 190, column: 17, scope: !1033)
!1036 = !DILocation(line: 190, column: 9, scope: !1033)
!1037 = !DILocation(line: 190, column: 20, scope: !1038)
!1038 = distinct !DILexicalBlock(scope: !1033, file: !3, line: 190, column: 5)
!1039 = !DILocation(line: 190, column: 24, scope: !1038)
!1040 = !DILocation(line: 190, column: 22, scope: !1038)
!1041 = !DILocation(line: 190, column: 5, scope: !1033)
!1042 = !DILocalVariable(name: "j", scope: !1043, file: !3, line: 192, type: !20)
!1043 = distinct !DILexicalBlock(scope: !1038, file: !3, line: 192, column: 9)
!1044 = !DILocation(line: 192, column: 17, scope: !1043)
!1045 = !DILocation(line: 192, column: 13, scope: !1043)
!1046 = !DILocation(line: 192, column: 24, scope: !1047)
!1047 = distinct !DILexicalBlock(scope: !1043, file: !3, line: 192, column: 9)
!1048 = !DILocation(line: 192, column: 28, scope: !1047)
!1049 = !DILocation(line: 192, column: 26, scope: !1047)
!1050 = !DILocation(line: 192, column: 9, scope: !1043)
!1051 = !DILocation(line: 193, column: 20, scope: !1047)
!1052 = !DILocation(line: 193, column: 17, scope: !1047)
!1053 = !DILocation(line: 193, column: 13, scope: !1047)
!1054 = !DILocation(line: 192, column: 31, scope: !1047)
!1055 = !DILocation(line: 192, column: 9, scope: !1047)
!1056 = distinct !{!1056, !1050, !1057}
!1057 = !DILocation(line: 193, column: 20, scope: !1043)
!1058 = !DILocation(line: 190, column: 32, scope: !1038)
!1059 = !DILocation(line: 190, column: 5, scope: !1038)
!1060 = distinct !{!1060, !1041, !1061}
!1061 = !DILocation(line: 193, column: 20, scope: !1033)
!1062 = !DILocation(line: 196, column: 18, scope: !915)
!1063 = !DILocation(line: 196, column: 21, scope: !915)
!1064 = !DILocation(line: 196, column: 5, scope: !915)
!1065 = !DILocation(line: 198, column: 12, scope: !915)
!1066 = !DILocation(line: 198, column: 5, scope: !915)
!1067 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 201, type: !1068, scopeLine: 202, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !4)
!1068 = !DISubroutineType(types: !1069)
!1069 = !{!20, !20, !147}
!1070 = !DILocalVariable(name: "argc", arg: 1, scope: !1067, file: !3, line: 201, type: !20)
!1071 = !DILocation(line: 201, column: 14, scope: !1067)
!1072 = !DILocalVariable(name: "argv", arg: 2, scope: !1067, file: !3, line: 201, type: !147)
!1073 = !DILocation(line: 201, column: 28, scope: !1067)
!1074 = !DILocalVariable(name: "x1", scope: !1067, file: !3, line: 203, type: !20)
!1075 = !DILocation(line: 203, column: 9, scope: !1067)
!1076 = !DILocation(line: 203, column: 5, scope: !1067)
!1077 = !DILocation(line: 203, column: 26, scope: !1067)
!1078 = !DILocation(line: 203, column: 21, scope: !1067)
!1079 = !DILocalVariable(name: "x2", scope: !1067, file: !3, line: 204, type: !20)
!1080 = !DILocation(line: 204, column: 9, scope: !1067)
!1081 = !DILocation(line: 204, column: 5, scope: !1067)
!1082 = !DILocation(line: 204, column: 26, scope: !1067)
!1083 = !DILocation(line: 204, column: 21, scope: !1067)
!1084 = !DILocalVariable(name: "x3", scope: !1067, file: !3, line: 205, type: !20)
!1085 = !DILocation(line: 205, column: 9, scope: !1067)
!1086 = !DILocation(line: 205, column: 19, scope: !1067)
!1087 = !DILocation(line: 205, column: 14, scope: !1067)
!1088 = !DILocation(line: 206, column: 5, scope: !1067)
!1089 = !DILocation(line: 207, column: 5, scope: !1067)
!1090 = !DILocation(line: 209, column: 16, scope: !1067)
!1091 = !DILocation(line: 209, column: 20, scope: !1067)
!1092 = !DILocation(line: 209, column: 5, scope: !1067)
!1093 = !DILocation(line: 211, column: 18, scope: !1067)
!1094 = !DILocation(line: 211, column: 22, scope: !1067)
!1095 = !DILocation(line: 211, column: 5, scope: !1067)
!1096 = !DILocation(line: 212, column: 18, scope: !1067)
!1097 = !DILocation(line: 212, column: 22, scope: !1067)
!1098 = !DILocation(line: 212, column: 5, scope: !1067)
!1099 = !DILocation(line: 213, column: 25, scope: !1067)
!1100 = !DILocation(line: 213, column: 29, scope: !1067)
!1101 = !DILocation(line: 213, column: 5, scope: !1067)
!1102 = !DILocation(line: 214, column: 17, scope: !1067)
!1103 = !DILocation(line: 214, column: 21, scope: !1067)
!1104 = !DILocation(line: 214, column: 5, scope: !1067)
!1105 = !DILocation(line: 216, column: 17, scope: !1067)
!1106 = !DILocation(line: 216, column: 21, scope: !1067)
!1107 = !DILocation(line: 216, column: 5, scope: !1067)
!1108 = !DILocation(line: 217, column: 24, scope: !1067)
!1109 = !DILocation(line: 217, column: 28, scope: !1067)
!1110 = !DILocation(line: 217, column: 5, scope: !1067)
!1111 = !DILocation(line: 218, column: 17, scope: !1067)
!1112 = !DILocation(line: 218, column: 21, scope: !1067)
!1113 = !DILocation(line: 218, column: 5, scope: !1067)
!1114 = !DILocation(line: 220, column: 5, scope: !1067)
!1115 = distinct !DISubprogram(name: "register_variable<int>", linkageName: "_Z17register_variableIiEvPT_PKc", scope: !1116, file: !1116, line: 14, type: !1117, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !2, templateParams: !1120, retainedNodes: !4)
!1116 = !DIFile(filename: "include/ExtraPInstrumenter.hpp", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!1117 = !DISubroutineType(types: !1118)
!1118 = !{null, !1119, !49}
!1119 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !20, size: 64)
!1120 = !{!1121}
!1121 = !DITemplateTypeParameter(name: "T", type: !20)
!1122 = !DILocalVariable(name: "ptr", arg: 1, scope: !1115, file: !1116, line: 14, type: !1119)
!1123 = !DILocation(line: 14, column: 28, scope: !1115)
!1124 = !DILocalVariable(name: "name", arg: 2, scope: !1115, file: !1116, line: 14, type: !49)
!1125 = !DILocation(line: 14, column: 46, scope: !1115)
!1126 = !DILocalVariable(name: "param_id", scope: !1115, file: !1116, line: 16, type: !229)
!1127 = !DILocation(line: 16, column: 13, scope: !1115)
!1128 = !DILocation(line: 16, column: 24, scope: !1115)
!1129 = !DILocation(line: 17, column: 57, scope: !1115)
!1130 = !DILocation(line: 17, column: 31, scope: !1115)
!1131 = !DILocation(line: 18, column: 21, scope: !1115)
!1132 = !DILocation(line: 18, column: 25, scope: !1115)
!1133 = !DILocation(line: 17, column: 5, scope: !1115)
!1134 = !DILocation(line: 19, column: 1, scope: !1115)
