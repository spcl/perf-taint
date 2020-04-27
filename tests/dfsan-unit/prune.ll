; RUN: opt %dfsan -S < %s 2> /dev/null | llc %llcparams - -o %t1 && clang++ %link %t1 -o %t2 && echo 10 | %execparams %t2 10 > %t2.json && diff -w %s.json %t2.json
; RUN: %jsonconvert %s.json 2> /dev/null | diff -w %s.processed.json -
; ModuleID = 'tests/dfsan-unit/prune.cpp'
source_filename = "tests/dfsan-unit/prune.cpp"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%"class.std::__1::basic_istream" = type { i32 (...)**, i64, %"class.std::__1::basic_ios.base" }
%"class.std::__1::basic_ios.base" = type <{ %"class.std::__1::ios_base", %"class.std::__1::basic_ostream"*, i32 }>
%"class.std::__1::ios_base" = type { i32 (...)**, i32, i64, i64, i32, i32, i8*, i8*, void (i32, %"class.std::__1::ios_base"*, i32)**, i32*, i64, i64, i64*, i64, i64, i8**, i64, i64 }
%"class.std::__1::basic_ostream" = type { i32 (...)**, %"class.std::__1::basic_ios.base" }

$_Z17register_variableIiEvPT_PKc = comdat any

$_Z17register_variableIdEvPT_PKc = comdat any

@global = dso_local global i32 100, align 4, !dbg !0
@global2 = dso_local global double 3.140000e+00, align 8, !dbg !18
@.str = private unnamed_addr constant [7 x i8] c"extrap\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [27 x i8] c"tests/dfsan-unit/prune.cpp\00", section "llvm.metadata"
@_ZNSt3__13cinE = external dso_local global %"class.std::__1::basic_istream", align 8
@.str.2 = private unnamed_addr constant [3 x i8] c"x1\00", align 1
@.str.3 = private unnamed_addr constant [3 x i8] c"x2\00", align 1
@.str.4 = private unnamed_addr constant [7 x i8] c"global\00", align 1
@.str.5 = private unnamed_addr constant [8 x i8] c"global2\00", align 1
@llvm.global.annotations = appending global [2 x { i8*, i8*, i8*, i32 }] [{ i8*, i8*, i8*, i32 } { i8* bitcast (i32* @global to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([27 x i8], [27 x i8]* @.str.1, i32 0, i32 0), i32 8 }, { i8*, i8*, i8*, i32 } { i8* bitcast (double* @global2 to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([27 x i8], [27 x i8]* @.str.1, i32 0, i32 0), i32 9 }], section "llvm.metadata"

; Function Attrs: nounwind uwtable
define dso_local i32 @_Z1hi(i32) #0 !dbg !1303 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, i32* %2, align 4, !tbaa !1309
  call void @llvm.dbg.declare(metadata i32* %2, metadata !1305, metadata !DIExpression()), !dbg !1313
  %5 = bitcast i32* %3 to i8*, !dbg !1314
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %5) #5, !dbg !1314
  call void @llvm.dbg.declare(metadata i32* %3, metadata !1306, metadata !DIExpression()), !dbg !1315
  store i32 0, i32* %3, align 4, !dbg !1315, !tbaa !1309
  %6 = bitcast i32* %4 to i8*, !dbg !1316
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %6) #5, !dbg !1316
  call void @llvm.dbg.declare(metadata i32* %4, metadata !1307, metadata !DIExpression()), !dbg !1317
  store i32 0, i32* %4, align 4, !dbg !1317, !tbaa !1309
  br label %7, !dbg !1316

7:                                                ; preds = %19, %1
  %8 = load i32, i32* %4, align 4, !dbg !1318, !tbaa !1309
  %9 = load i32, i32* %2, align 4, !dbg !1320, !tbaa !1309
  %10 = mul nsw i32 2, %9, !dbg !1321
  %11 = add nsw i32 %10, 1, !dbg !1322
  %12 = icmp slt i32 %8, %11, !dbg !1323
  br i1 %12, label %15, label %13, !dbg !1324

13:                                               ; preds = %7
  %14 = bitcast i32* %4 to i8*, !dbg !1325
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %14) #5, !dbg !1325
  br label %22

15:                                               ; preds = %7
  %16 = load i32, i32* %4, align 4, !dbg !1326, !tbaa !1309
  %17 = load i32, i32* %3, align 4, !dbg !1327, !tbaa !1309
  %18 = add nsw i32 %17, %16, !dbg !1327
  store i32 %18, i32* %3, align 4, !dbg !1327, !tbaa !1309
  br label %19, !dbg !1328

19:                                               ; preds = %15
  %20 = load i32, i32* %4, align 4, !dbg !1329, !tbaa !1309
  %21 = add nsw i32 %20, 1, !dbg !1329
  store i32 %21, i32* %4, align 4, !dbg !1329, !tbaa !1309
  br label %7, !dbg !1325, !llvm.loop !1330

22:                                               ; preds = %13
  %23 = load i32, i32* @global, align 4, !dbg !1332, !tbaa !1309
  %24 = mul nsw i32 2, %23, !dbg !1333
  %25 = load i32, i32* %3, align 4, !dbg !1334, !tbaa !1309
  %26 = add nsw i32 %24, %25, !dbg !1335
  %27 = bitcast i32* %3 to i8*, !dbg !1336
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %27) #5, !dbg !1336
  ret i32 %26, !dbg !1337
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: nounwind uwtable
define dso_local i32 @_Z7g_prunei(i32) #0 !dbg !1338 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4, !tbaa !1309
  call void @llvm.dbg.declare(metadata i32* %2, metadata !1340, metadata !DIExpression()), !dbg !1341
  %3 = load i32, i32* @global, align 4, !dbg !1342, !tbaa !1309
  %4 = load i32, i32* %2, align 4, !dbg !1343, !tbaa !1309
  %5 = sitofp i32 %4 to double, !dbg !1343
  %6 = load i32, i32* %2, align 4, !dbg !1344, !tbaa !1309
  %7 = sitofp i32 %6 to double, !dbg !1344
  %8 = load double, double* @global2, align 8, !dbg !1345, !tbaa !1346
  %9 = call double @exp(double %8) #5, !dbg !1348
  %10 = call double @pow(double %7, double %9) #5, !dbg !1349
  %11 = fadd double %5, %10, !dbg !1350
  %12 = fptosi double %11 to i32, !dbg !1343
  %13 = call i32 @_Z1hi(i32 %12), !dbg !1351
  %14 = mul nsw i32 %3, %13, !dbg !1352
  ret i32 %14, !dbg !1353
}

; Function Attrs: nounwind
declare dso_local double @pow(double, double) #3

; Function Attrs: nounwind
declare dso_local double @exp(double) #3

; Function Attrs: nounwind uwtable
define dso_local i32 @_Z11g_not_prunei(i32) #0 !dbg !1354 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i32 %0, i32* %3, align 4, !tbaa !1309
  call void @llvm.dbg.declare(metadata i32* %3, metadata !1356, metadata !DIExpression()), !dbg !1360
  %7 = bitcast i32* %4 to i8*, !dbg !1361
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %7) #5, !dbg !1361
  call void @llvm.dbg.declare(metadata i32* %4, metadata !1357, metadata !DIExpression()), !dbg !1362
  store i32 0, i32* %4, align 4, !dbg !1362, !tbaa !1309
  %8 = bitcast i32* %5 to i8*, !dbg !1363
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %8) #5, !dbg !1363
  call void @llvm.dbg.declare(metadata i32* %5, metadata !1358, metadata !DIExpression()), !dbg !1364
  store i32 0, i32* %5, align 4, !dbg !1364, !tbaa !1309
  br label %9, !dbg !1363

9:                                                ; preds = %19, %1
  %10 = load i32, i32* %5, align 4, !dbg !1365, !tbaa !1309
  %11 = load i32, i32* %3, align 4, !dbg !1367, !tbaa !1309
  %12 = icmp slt i32 %10, %11, !dbg !1368
  br i1 %12, label %15, label %13, !dbg !1369

13:                                               ; preds = %9
  %14 = bitcast i32* %5 to i8*, !dbg !1370
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %14) #5, !dbg !1370
  br label %22

15:                                               ; preds = %9
  %16 = load i32, i32* %5, align 4, !dbg !1371, !tbaa !1309
  %17 = load i32, i32* %4, align 4, !dbg !1372, !tbaa !1309
  %18 = add nsw i32 %17, %16, !dbg !1372
  store i32 %18, i32* %4, align 4, !dbg !1372, !tbaa !1309
  br label %19, !dbg !1373

19:                                               ; preds = %15
  %20 = load i32, i32* %5, align 4, !dbg !1374, !tbaa !1309
  %21 = add nsw i32 %20, 1, !dbg !1374
  store i32 %21, i32* %5, align 4, !dbg !1374, !tbaa !1309
  br label %9, !dbg !1370, !llvm.loop !1375

22:                                               ; preds = %13
  %23 = load double, double* @global2, align 8, !dbg !1377, !tbaa !1346
  %24 = fadd double %23, 1.000000e+00, !dbg !1379
  %25 = fcmp olt double %24, 0.000000e+00, !dbg !1380
  br i1 %25, label %26, label %36, !dbg !1381

26:                                               ; preds = %22
  %27 = load i32, i32* %4, align 4, !dbg !1382, !tbaa !1309
  %28 = add nsw i32 100, %27, !dbg !1383
  %29 = sitofp i32 %28 to double, !dbg !1384
  %30 = load i32, i32* @global, align 4, !dbg !1385, !tbaa !1309
  %31 = sitofp i32 %30 to double, !dbg !1385
  %32 = call double @pow(double %31, double 3.000000e+00) #5, !dbg !1386
  %33 = fadd double %29, %32, !dbg !1387
  %34 = fptosi double %33 to i32, !dbg !1384
  %35 = call i32 @_Z1hi(i32 %34), !dbg !1388
  store i32 %35, i32* %2, align 4, !dbg !1389
  store i32 1, i32* %6, align 4
  br label %46, !dbg !1389

36:                                               ; preds = %22
  %37 = load i32, i32* @global, align 4, !dbg !1390, !tbaa !1309
  %38 = mul nsw i32 200, %37, !dbg !1391
  %39 = sitofp i32 %38 to double, !dbg !1392
  %40 = load i32, i32* %3, align 4, !dbg !1393, !tbaa !1309
  %41 = sitofp i32 %40 to double, !dbg !1393
  %42 = call double @pow(double %41, double 3.000000e+00) #5, !dbg !1394
  %43 = fadd double %39, %42, !dbg !1395
  %44 = fptosi double %43 to i32, !dbg !1392
  %45 = call i32 @_Z1hi(i32 %44), !dbg !1396
  store i32 %45, i32* %2, align 4, !dbg !1397
  store i32 1, i32* %6, align 4
  br label %46, !dbg !1397

46:                                               ; preds = %36, %26
  %47 = bitcast i32* %4 to i8*, !dbg !1398
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %47) #5, !dbg !1398
  %48 = load i32, i32* %2, align 4, !dbg !1398
  ret i32 %48, !dbg !1398
}

; Function Attrs: nounwind uwtable
define dso_local i32 @_Z7f_pruneii(i32, i32) #0 !dbg !1399 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, i32* %3, align 4, !tbaa !1309
  call void @llvm.dbg.declare(metadata i32* %3, metadata !1403, metadata !DIExpression()), !dbg !1405
  store i32 %1, i32* %4, align 4, !tbaa !1309
  call void @llvm.dbg.declare(metadata i32* %4, metadata !1404, metadata !DIExpression()), !dbg !1406
  %5 = load i32, i32* %3, align 4, !dbg !1407, !tbaa !1309
  %6 = call i32 @_Z7g_prunei(i32 %5), !dbg !1408
  %7 = load i32, i32* %4, align 4, !dbg !1409, !tbaa !1309
  %8 = call i32 @_Z11g_not_prunei(i32 %7), !dbg !1410
  %9 = load i32, i32* %4, align 4, !dbg !1411, !tbaa !1309
  %10 = call i32 @_Z1hi(i32 %9), !dbg !1412
  ret i32 %10, !dbg !1413
}

; Function Attrs: nounwind uwtable
define dso_local i32 @_Z11f_not_pruneii(i32, i32) #0 !dbg !1414 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  store i32 %0, i32* %3, align 4, !tbaa !1309
  call void @llvm.dbg.declare(metadata i32* %3, metadata !1416, metadata !DIExpression()), !dbg !1421
  store i32 %1, i32* %4, align 4, !tbaa !1309
  call void @llvm.dbg.declare(metadata i32* %4, metadata !1417, metadata !DIExpression()), !dbg !1422
  %7 = bitcast i32* %5 to i8*, !dbg !1423
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %7) #5, !dbg !1423
  call void @llvm.dbg.declare(metadata i32* %5, metadata !1418, metadata !DIExpression()), !dbg !1424
  store i32 0, i32* %5, align 4, !dbg !1424, !tbaa !1309
  %8 = bitcast i32* %6 to i8*, !dbg !1425
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %8) #5, !dbg !1425
  call void @llvm.dbg.declare(metadata i32* %6, metadata !1419, metadata !DIExpression()), !dbg !1426
  %9 = load i32, i32* %4, align 4, !dbg !1427, !tbaa !1309
  store i32 %9, i32* %6, align 4, !dbg !1426, !tbaa !1309
  br label %10, !dbg !1425

10:                                               ; preds = %19, %2
  %11 = load i32, i32* %6, align 4, !dbg !1428, !tbaa !1309
  %12 = icmp slt i32 %11, 10, !dbg !1430
  br i1 %12, label %15, label %13, !dbg !1431

13:                                               ; preds = %10
  %14 = bitcast i32* %6 to i8*, !dbg !1432
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %14) #5, !dbg !1432
  br label %22

15:                                               ; preds = %10
  %16 = load i32, i32* %6, align 4, !dbg !1433, !tbaa !1309
  %17 = load i32, i32* %5, align 4, !dbg !1434, !tbaa !1309
  %18 = add nsw i32 %17, %16, !dbg !1434
  store i32 %18, i32* %5, align 4, !dbg !1434, !tbaa !1309
  br label %19, !dbg !1435

19:                                               ; preds = %15
  %20 = load i32, i32* %6, align 4, !dbg !1436, !tbaa !1309
  %21 = add nsw i32 %20, 1, !dbg !1436
  store i32 %21, i32* %6, align 4, !dbg !1436, !tbaa !1309
  br label %10, !dbg !1432, !llvm.loop !1437

22:                                               ; preds = %13
  %23 = load i32, i32* %3, align 4, !dbg !1439, !tbaa !1309
  %24 = call i32 @_Z7g_prunei(i32 %23), !dbg !1440
  %25 = load i32, i32* %4, align 4, !dbg !1441, !tbaa !1309
  %26 = call i32 @_Z11g_not_prunei(i32 %25), !dbg !1442
  %27 = load i32, i32* %5, align 4, !dbg !1443, !tbaa !1309
  %28 = load i32, i32* %4, align 4, !dbg !1444, !tbaa !1309
  %29 = add nsw i32 %27, %28, !dbg !1445
  %30 = call i32 @_Z1hi(i32 %29), !dbg !1446
  %31 = bitcast i32* %5 to i8*, !dbg !1447
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %31) #5, !dbg !1447
  ret i32 %30, !dbg !1448
}

; Function Attrs: norecurse uwtable
define dso_local i32 @main(i32, i8**) #4 !dbg !1449 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  %6 = alloca i32, align 4
  %7 = alloca i32, align 4
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4, !tbaa !1309
  call void @llvm.dbg.declare(metadata i32* %4, metadata !1453, metadata !DIExpression()), !dbg !1457
  store i8** %1, i8*** %5, align 8, !tbaa !1458
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !1454, metadata !DIExpression()), !dbg !1460
  %8 = bitcast i32* %6 to i8*, !dbg !1461
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %8) #5, !dbg !1461
  call void @llvm.dbg.declare(metadata i32* %6, metadata !1455, metadata !DIExpression()), !dbg !1462
  %9 = bitcast i32* %6 to i8*, !dbg !1461
  call void @llvm.var.annotation(i8* %9, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([27 x i8], [27 x i8]* @.str.1, i32 0, i32 0), i32 57), !dbg !1461
  %10 = load i8**, i8*** %5, align 8, !dbg !1463, !tbaa !1458
  %11 = getelementptr inbounds i8*, i8** %10, i64 1, !dbg !1463
  %12 = load i8*, i8** %11, align 8, !dbg !1463, !tbaa !1458
  %13 = call i32 @atoi(i8* %12) #9, !dbg !1464
  store i32 %13, i32* %6, align 4, !dbg !1462, !tbaa !1309
  %14 = bitcast i32* %7 to i8*, !dbg !1465
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %14) #5, !dbg !1465
  call void @llvm.dbg.declare(metadata i32* %7, metadata !1456, metadata !DIExpression()), !dbg !1466
  %15 = bitcast i32* %7 to i8*, !dbg !1465
  call void @llvm.var.annotation(i8* %15, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([27 x i8], [27 x i8]* @.str.1, i32 0, i32 0), i32 58), !dbg !1465
  %16 = call dereferenceable(168) %"class.std::__1::basic_istream"* @_ZNSt3__113basic_istreamIcNS_11char_traitsIcEEErsERi(%"class.std::__1::basic_istream"* @_ZNSt3__13cinE, i32* dereferenceable(4) %7), !dbg !1467
  call void @_Z17register_variableIiEvPT_PKc(i32* %6, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.2, i64 0, i64 0)), !dbg !1468
  call void @_Z17register_variableIiEvPT_PKc(i32* %7, i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.3, i64 0, i64 0)), !dbg !1469
  call void @_Z17register_variableIiEvPT_PKc(i32* @global, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.4, i64 0, i64 0)), !dbg !1470
  call void @_Z17register_variableIdEvPT_PKc(double* @global2, i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.5, i64 0, i64 0)), !dbg !1471
  %17 = call i32 @_Z7f_pruneii(i32 1, i32 2), !dbg !1472
  %18 = call i32 @_Z11f_not_pruneii(i32 1, i32 2), !dbg !1473
  %19 = load i32, i32* %6, align 4, !dbg !1474, !tbaa !1309
  %20 = load i32, i32* %6, align 4, !dbg !1475, !tbaa !1309
  %21 = mul nsw i32 2, %20, !dbg !1476
  %22 = load i32, i32* %7, align 4, !dbg !1477, !tbaa !1309
  %23 = add nsw i32 %21, %22, !dbg !1478
  %24 = sub nsw i32 %23, 1, !dbg !1479
  %25 = call i32 @_Z7f_pruneii(i32 %19, i32 %24), !dbg !1480
  %26 = load i32, i32* %6, align 4, !dbg !1481, !tbaa !1309
  %27 = load i32, i32* %6, align 4, !dbg !1482, !tbaa !1309
  %28 = mul nsw i32 2, %27, !dbg !1483
  %29 = load i32, i32* %7, align 4, !dbg !1484, !tbaa !1309
  %30 = add nsw i32 %28, %29, !dbg !1485
  %31 = sub nsw i32 %30, 1, !dbg !1486
  %32 = call i32 @_Z11f_not_pruneii(i32 %26, i32 %31), !dbg !1487
  %33 = bitcast i32* %7 to i8*, !dbg !1488
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %33) #5, !dbg !1488
  %34 = bitcast i32* %6 to i8*, !dbg !1488
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %34) #5, !dbg !1488
  ret i32 0, !dbg !1489
}

; Function Attrs: nounwind
declare void @llvm.var.annotation(i8*, i8*, i8*, i32) #5

; Function Attrs: inlinehint nounwind readonly uwtable
define available_externally dso_local i32 @atoi(i8* nonnull) #6 !dbg !366 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8, !tbaa !1458
  call void @llvm.dbg.declare(metadata i8** %2, metadata !370, metadata !DIExpression()), !dbg !1490
  %3 = load i8*, i8** %2, align 8, !dbg !1491, !tbaa !1458
  %4 = call i64 @strtol(i8* %3, i8** null, i32 10) #5, !dbg !1492
  %5 = trunc i64 %4 to i32, !dbg !1492
  ret i32 %5, !dbg !1493
}

declare dso_local dereferenceable(168) %"class.std::__1::basic_istream"* @_ZNSt3__113basic_istreamIcNS_11char_traitsIcEEErsERi(%"class.std::__1::basic_istream"*, i32* dereferenceable(4)) #7

; Function Attrs: uwtable
define linkonce_odr dso_local void @_Z17register_variableIiEvPT_PKc(i32*, i8*) #8 comdat !dbg !1494 {
  %3 = alloca i32*, align 8
  %4 = alloca i8*, align 8
  store i32* %0, i32** %3, align 8, !tbaa !1458
  call void @llvm.dbg.declare(metadata i32** %3, metadata !1499, metadata !DIExpression()), !dbg !1503
  store i8* %1, i8** %4, align 8, !tbaa !1458
  call void @llvm.dbg.declare(metadata i8** %4, metadata !1500, metadata !DIExpression()), !dbg !1504
  %5 = load i32*, i32** %3, align 8, !dbg !1505, !tbaa !1458
  %6 = bitcast i32* %5 to i8*, !dbg !1506
  %7 = load i8*, i8** %4, align 8, !dbg !1507, !tbaa !1458
  call void @__dfsw_EXTRAP_WRITE_LABEL(i8* %6, i32 4, i8* %7), !dbg !1508
  ret void, !dbg !1509
}

; Function Attrs: uwtable
define linkonce_odr dso_local void @_Z17register_variableIdEvPT_PKc(double*, i8*) #8 comdat !dbg !1510 {
  %3 = alloca double*, align 8
  %4 = alloca i8*, align 8
  store double* %0, double** %3, align 8, !tbaa !1458
  call void @llvm.dbg.declare(metadata double** %3, metadata !1515, metadata !DIExpression()), !dbg !1519
  store i8* %1, i8** %4, align 8, !tbaa !1458
  call void @llvm.dbg.declare(metadata i8** %4, metadata !1516, metadata !DIExpression()), !dbg !1520
  %5 = load double*, double** %3, align 8, !dbg !1521, !tbaa !1458
  %6 = bitcast double* %5 to i8*, !dbg !1522
  %7 = load i8*, i8** %4, align 8, !dbg !1523, !tbaa !1458
  call void @__dfsw_EXTRAP_WRITE_LABEL(i8* %6, i32 8, i8* %7), !dbg !1524
  ret void, !dbg !1525
}

; Function Attrs: nounwind
declare dso_local i64 @strtol(i8*, i8**, i32) #3

declare dso_local void @__dfsw_EXTRAP_WRITE_LABEL(i8*, i32, i8*) #7

attributes #0 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { argmemonly nounwind }
attributes #3 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { norecurse uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { nounwind }
attributes #6 = { inlinehint nounwind readonly uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #7 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #8 = { uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #9 = { nounwind readonly }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!1299, !1300, !1301}
!llvm.ident = !{!1302}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "global", scope: !2, file: !3, line: 8, type: !7, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !3, producer: "clang version 9.0.0 (tags/RELEASE_900/final)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !5, globals: !17, imports: !20, nameTableKind: None)
!3 = !DIFile(filename: "tests/dfsan-unit/prune.cpp", directory: "/home/mcopik/projects/ETH/extrap/rebuild/perf-taint")
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
!17 = !{!0, !18}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "global2", scope: !2, file: !3, line: 9, type: !6, isLocal: false, isDefinition: true)
!20 = !{!21, !28, !31, !35, !43, !45, !49, !51, !55, !60, !62, !64, !68, !70, !72, !74, !76, !78, !80, !82, !87, !91, !93, !95, !100, !105, !107, !109, !111, !113, !115, !117, !119, !121, !123, !125, !127, !129, !131, !133, !135, !137, !141, !143, !145, !147, !151, !153, !158, !160, !162, !164, !166, !170, !172, !178, !182, !184, !186, !190, !192, !196, !198, !200, !204, !206, !208, !210, !212, !214, !216, !220, !222, !224, !226, !228, !230, !232, !234, !238, !242, !244, !246, !248, !250, !252, !254, !256, !258, !260, !262, !264, !266, !268, !270, !272, !274, !276, !278, !280, !284, !286, !288, !290, !294, !296, !300, !302, !304, !306, !308, !312, !314, !318, !320, !322, !324, !326, !330, !332, !334, !338, !340, !342, !344, !346, !350, !356, !362, !365, !371, !375, !379, !385, !389, !393, !397, !401, !405, !410, !414, !419, !424, !428, !432, !436, !440, !445, !449, !451, !455, !457, !468, !472, !473, !477, !481, !485, !489, !491, !495, !502, !506, !510, !518, !520, !522, !524, !531, !535, !539, !543, !545, !547, !551, !555, !559, !561, !565, !570, !574, !578, !582, !584, !586, !588, !590, !592, !596, !600, !602, !606, !609, !612, !617, !621, !624, !627, !630, !632, !634, !636, !638, !640, !642, !644, !646, !648, !650, !652, !654, !656, !658, !660, !662, !664, !667, !670, !719, !725, !726, !731, !733, !738, !742, !746, !748, !752, !756, !760, !771, !773, !777, !781, !785, !787, !791, !795, !799, !801, !803, !805, !809, !813, !819, !823, !829, !833, !837, !839, !841, !843, !847, !851, !855, !857, !859, !863, !867, !870, !874, !878, !880, !884, !886, !888, !892, !894, !896, !898, !900, !902, !904, !906, !908, !910, !912, !914, !916, !918, !922, !927, !930, !934, !936, !938, !940, !942, !944, !946, !948, !950, !952, !954, !956, !960, !964, !968, !970, !974, !978, !995, !996, !1011, !1012, !1013, !1022, !1024, !1028, !1032, !1036, !1040, !1042, !1046, !1050, !1054, !1058, !1062, !1066, !1068, !1070, !1074, !1080, !1084, !1088, !1092, !1096, !1100, !1104, !1108, !1112, !1114, !1116, !1120, !1122, !1126, !1130, !1134, !1138, !1140, !1142, !1146, !1150, !1154, !1156, !1160, !1162, !1164, !1168, !1172, !1179, !1183, !1185, !1191, !1197, !1201, !1205, !1211, !1217, !1221, !1225, !1229, !1233, !1235, !1237, !1242, !1243, !1247, !1248, !1253, !1257, !1262, !1267, !1271, !1277, !1281, !1283, !1287, !1292}
!21 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !24, file: !27, line: 49)
!22 = !DINamespace(name: "__1", scope: !23, exportSymbols: true)
!23 = !DINamespace(name: "std", scope: null)
!24 = !DIDerivedType(tag: DW_TAG_typedef, name: "ptrdiff_t", file: !25, line: 35, baseType: !26)
!25 = !DIFile(filename: "clang_llvm/llvm-9.0/build-9.0/lib/clang/9.0.0/include/stddef.h", directory: "/home/mcopik/projects")
!26 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!27 = !DIFile(filename: "build_tool/../usr/include/c++/v1/cstddef", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!28 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !29, file: !27, line: 50)
!29 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !25, line: 46, baseType: !30)
!30 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!31 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !32, file: !27, line: 55)
!32 = !DIDerivedType(tag: DW_TAG_typedef, name: "max_align_t", file: !33, line: 24, baseType: !34)
!33 = !DIFile(filename: "clang_llvm/llvm-9.0/build-9.0/lib/clang/9.0.0/include/__stddef_max_align_t.h", directory: "/home/mcopik/projects")
!34 = !DICompositeType(tag: DW_TAG_structure_type, file: !33, line: 19, flags: DIFlagFwdDecl, identifier: "_ZTS11max_align_t")
!35 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !36, file: !42, line: 316)
!36 = !DISubprogram(name: "isinf", linkageName: "_Z5isinfe", scope: !37, file: !37, line: 499, type: !38, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!37 = !DIFile(filename: "build_tool/../usr/include/c++/v1/math.h", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!38 = !DISubroutineType(types: !39)
!39 = !{!40, !41}
!40 = !DIBasicType(name: "bool", size: 8, encoding: DW_ATE_boolean)
!41 = !DIBasicType(name: "long double", size: 128, encoding: DW_ATE_float)
!42 = !DIFile(filename: "build_tool/../usr/include/c++/v1/cmath", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!43 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !44, file: !42, line: 317)
!44 = !DISubprogram(name: "isnan", linkageName: "_Z5isnane", scope: !37, file: !37, line: 543, type: !38, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!45 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !46, file: !42, line: 327)
!46 = !DIDerivedType(tag: DW_TAG_typedef, name: "float_t", file: !47, line: 149, baseType: !48)
!47 = !DIFile(filename: "/usr/include/math.h", directory: "")
!48 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!49 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !50, file: !42, line: 328)
!50 = !DIDerivedType(tag: DW_TAG_typedef, name: "double_t", file: !47, line: 150, baseType: !6)
!51 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !52, file: !42, line: 331)
!52 = !DISubprogram(name: "abs", linkageName: "_Z3abse", scope: !37, file: !37, line: 789, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!53 = !DISubroutineType(types: !54)
!54 = !{!41, !41}
!55 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !56, file: !42, line: 335)
!56 = !DISubprogram(name: "acosf", scope: !57, file: !57, line: 53, type: !58, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!57 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/mathcalls.h", directory: "")
!58 = !DISubroutineType(types: !59)
!59 = !{!48, !48}
!60 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !61, file: !42, line: 337)
!61 = !DISubprogram(name: "asinf", scope: !57, file: !57, line: 55, type: !58, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!62 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !63, file: !42, line: 339)
!63 = !DISubprogram(name: "atanf", scope: !57, file: !57, line: 57, type: !58, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!64 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !65, file: !42, line: 341)
!65 = !DISubprogram(name: "atan2f", scope: !57, file: !57, line: 59, type: !66, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!66 = !DISubroutineType(types: !67)
!67 = !{!48, !48, !48}
!68 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !69, file: !42, line: 343)
!69 = !DISubprogram(name: "ceilf", scope: !57, file: !57, line: 159, type: !58, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!70 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !71, file: !42, line: 345)
!71 = !DISubprogram(name: "cosf", scope: !57, file: !57, line: 62, type: !58, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!72 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !73, file: !42, line: 347)
!73 = !DISubprogram(name: "coshf", scope: !57, file: !57, line: 71, type: !58, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!74 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !75, file: !42, line: 350)
!75 = !DISubprogram(name: "expf", scope: !57, file: !57, line: 95, type: !58, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!76 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !77, file: !42, line: 353)
!77 = !DISubprogram(name: "fabsf", scope: !57, file: !57, line: 162, type: !58, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!78 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !79, file: !42, line: 355)
!79 = !DISubprogram(name: "floorf", scope: !57, file: !57, line: 165, type: !58, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!80 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !81, file: !42, line: 358)
!81 = !DISubprogram(name: "fmodf", scope: !57, file: !57, line: 168, type: !66, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!82 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !83, file: !42, line: 361)
!83 = !DISubprogram(name: "frexpf", scope: !57, file: !57, line: 98, type: !84, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!84 = !DISubroutineType(types: !85)
!85 = !{!48, !48, !86}
!86 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!87 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !88, file: !42, line: 363)
!88 = !DISubprogram(name: "ldexpf", scope: !57, file: !57, line: 101, type: !89, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!89 = !DISubroutineType(types: !90)
!90 = !{!48, !48, !7}
!91 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !92, file: !42, line: 366)
!92 = !DISubprogram(name: "logf", scope: !57, file: !57, line: 104, type: !58, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!93 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !94, file: !42, line: 369)
!94 = !DISubprogram(name: "log10f", scope: !57, file: !57, line: 107, type: !58, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!95 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !96, file: !42, line: 370)
!96 = !DISubprogram(name: "modf", linkageName: "_Z4modfePe", scope: !37, file: !37, line: 1021, type: !97, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!97 = !DISubroutineType(types: !98)
!98 = !{!41, !41, !99}
!99 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !41, size: 64)
!100 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !101, file: !42, line: 371)
!101 = !DISubprogram(name: "modff", scope: !57, file: !57, line: 110, type: !102, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!102 = !DISubroutineType(types: !103)
!103 = !{!48, !48, !104}
!104 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !48, size: 64)
!105 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !106, file: !42, line: 374)
!106 = !DISubprogram(name: "powf", scope: !57, file: !57, line: 140, type: !66, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!107 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !108, file: !42, line: 377)
!108 = !DISubprogram(name: "sinf", scope: !57, file: !57, line: 64, type: !58, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!109 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !110, file: !42, line: 379)
!110 = !DISubprogram(name: "sinhf", scope: !57, file: !57, line: 73, type: !58, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!111 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !112, file: !42, line: 382)
!112 = !DISubprogram(name: "sqrtf", scope: !57, file: !57, line: 143, type: !58, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!113 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !114, file: !42, line: 384)
!114 = !DISubprogram(name: "tanf", scope: !57, file: !57, line: 66, type: !58, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!115 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !116, file: !42, line: 387)
!116 = !DISubprogram(name: "tanhf", scope: !57, file: !57, line: 75, type: !58, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!117 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !118, file: !42, line: 390)
!118 = !DISubprogram(name: "acoshf", scope: !57, file: !57, line: 85, type: !58, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!119 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !120, file: !42, line: 392)
!120 = !DISubprogram(name: "asinhf", scope: !57, file: !57, line: 87, type: !58, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!121 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !122, file: !42, line: 394)
!122 = !DISubprogram(name: "atanhf", scope: !57, file: !57, line: 89, type: !58, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!123 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !124, file: !42, line: 396)
!124 = !DISubprogram(name: "cbrtf", scope: !57, file: !57, line: 152, type: !58, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!125 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !126, file: !42, line: 399)
!126 = !DISubprogram(name: "copysignf", scope: !57, file: !57, line: 196, type: !66, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!127 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !128, file: !42, line: 402)
!128 = !DISubprogram(name: "erff", scope: !57, file: !57, line: 228, type: !58, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!129 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !130, file: !42, line: 404)
!130 = !DISubprogram(name: "erfcf", scope: !57, file: !57, line: 229, type: !58, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!131 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !132, file: !42, line: 406)
!132 = !DISubprogram(name: "exp2f", scope: !57, file: !57, line: 130, type: !58, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!133 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !134, file: !42, line: 408)
!134 = !DISubprogram(name: "expm1f", scope: !57, file: !57, line: 119, type: !58, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!135 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !136, file: !42, line: 410)
!136 = !DISubprogram(name: "fdimf", scope: !57, file: !57, line: 326, type: !66, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!137 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !138, file: !42, line: 411)
!138 = !DISubprogram(name: "fmaf", scope: !57, file: !57, line: 335, type: !139, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!139 = !DISubroutineType(types: !140)
!140 = !{!48, !48, !48, !48}
!141 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !142, file: !42, line: 414)
!142 = !DISubprogram(name: "fmaxf", scope: !57, file: !57, line: 329, type: !66, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!143 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !144, file: !42, line: 416)
!144 = !DISubprogram(name: "fminf", scope: !57, file: !57, line: 332, type: !66, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!145 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !146, file: !42, line: 418)
!146 = !DISubprogram(name: "hypotf", scope: !57, file: !57, line: 147, type: !66, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!147 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !148, file: !42, line: 420)
!148 = !DISubprogram(name: "ilogbf", scope: !57, file: !57, line: 280, type: !149, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!149 = !DISubroutineType(types: !150)
!150 = !{!7, !48}
!151 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !152, file: !42, line: 422)
!152 = !DISubprogram(name: "lgammaf", scope: !57, file: !57, line: 230, type: !58, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!153 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !154, file: !42, line: 424)
!154 = !DISubprogram(name: "llrintf", scope: !57, file: !57, line: 316, type: !155, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!155 = !DISubroutineType(types: !156)
!156 = !{!157, !48}
!157 = !DIBasicType(name: "long long int", size: 64, encoding: DW_ATE_signed)
!158 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !159, file: !42, line: 426)
!159 = !DISubprogram(name: "llroundf", scope: !57, file: !57, line: 322, type: !155, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!160 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !161, file: !42, line: 428)
!161 = !DISubprogram(name: "log1pf", scope: !57, file: !57, line: 122, type: !58, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!162 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !163, file: !42, line: 430)
!163 = !DISubprogram(name: "log2f", scope: !57, file: !57, line: 133, type: !58, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!164 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !165, file: !42, line: 432)
!165 = !DISubprogram(name: "logbf", scope: !57, file: !57, line: 125, type: !58, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!166 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !167, file: !42, line: 434)
!167 = !DISubprogram(name: "lrintf", scope: !57, file: !57, line: 314, type: !168, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!168 = !DISubroutineType(types: !169)
!169 = !{!26, !48}
!170 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !171, file: !42, line: 436)
!171 = !DISubprogram(name: "lroundf", scope: !57, file: !57, line: 320, type: !168, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!172 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !173, file: !42, line: 438)
!173 = !DISubprogram(name: "nan", scope: !57, file: !57, line: 201, type: !174, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!174 = !DISubroutineType(types: !175)
!175 = !{!6, !176}
!176 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !177, size: 64)
!177 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !10)
!178 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !179, file: !42, line: 439)
!179 = !DISubprogram(name: "nanf", scope: !57, file: !57, line: 201, type: !180, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!180 = !DISubroutineType(types: !181)
!181 = !{!48, !176}
!182 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !183, file: !42, line: 442)
!183 = !DISubprogram(name: "nearbyintf", scope: !57, file: !57, line: 294, type: !58, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!184 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !185, file: !42, line: 444)
!185 = !DISubprogram(name: "nextafterf", scope: !57, file: !57, line: 259, type: !66, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!186 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !187, file: !42, line: 446)
!187 = !DISubprogram(name: "nexttowardf", scope: !57, file: !57, line: 261, type: !188, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!188 = !DISubroutineType(types: !189)
!189 = !{!48, !48, !41}
!190 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !191, file: !42, line: 448)
!191 = !DISubprogram(name: "remainderf", scope: !57, file: !57, line: 272, type: !66, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!192 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !193, file: !42, line: 450)
!193 = !DISubprogram(name: "remquof", scope: !57, file: !57, line: 307, type: !194, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!194 = !DISubroutineType(types: !195)
!195 = !{!48, !48, !48, !86}
!196 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !197, file: !42, line: 452)
!197 = !DISubprogram(name: "rintf", scope: !57, file: !57, line: 256, type: !58, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!198 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !199, file: !42, line: 454)
!199 = !DISubprogram(name: "roundf", scope: !57, file: !57, line: 298, type: !58, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!200 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !201, file: !42, line: 456)
!201 = !DISubprogram(name: "scalblnf", scope: !57, file: !57, line: 290, type: !202, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!202 = !DISubroutineType(types: !203)
!203 = !{!48, !48, !26}
!204 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !205, file: !42, line: 458)
!205 = !DISubprogram(name: "scalbnf", scope: !57, file: !57, line: 276, type: !89, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!206 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !207, file: !42, line: 460)
!207 = !DISubprogram(name: "tgammaf", scope: !57, file: !57, line: 235, type: !58, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!208 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !209, file: !42, line: 462)
!209 = !DISubprogram(name: "truncf", scope: !57, file: !57, line: 302, type: !58, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!210 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !211, file: !42, line: 464)
!211 = !DISubprogram(name: "acosl", scope: !57, file: !57, line: 53, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!212 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !213, file: !42, line: 465)
!213 = !DISubprogram(name: "asinl", scope: !57, file: !57, line: 55, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!214 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !215, file: !42, line: 466)
!215 = !DISubprogram(name: "atanl", scope: !57, file: !57, line: 57, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!216 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !217, file: !42, line: 467)
!217 = !DISubprogram(name: "atan2l", scope: !57, file: !57, line: 59, type: !218, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!218 = !DISubroutineType(types: !219)
!219 = !{!41, !41, !41}
!220 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !221, file: !42, line: 468)
!221 = !DISubprogram(name: "ceill", scope: !57, file: !57, line: 159, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!222 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !223, file: !42, line: 469)
!223 = !DISubprogram(name: "cosl", scope: !57, file: !57, line: 62, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!224 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !225, file: !42, line: 470)
!225 = !DISubprogram(name: "coshl", scope: !57, file: !57, line: 71, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!226 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !227, file: !42, line: 471)
!227 = !DISubprogram(name: "expl", scope: !57, file: !57, line: 95, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!228 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !229, file: !42, line: 472)
!229 = !DISubprogram(name: "fabsl", scope: !57, file: !57, line: 162, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!230 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !231, file: !42, line: 473)
!231 = !DISubprogram(name: "floorl", scope: !57, file: !57, line: 165, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!232 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !233, file: !42, line: 474)
!233 = !DISubprogram(name: "fmodl", scope: !57, file: !57, line: 168, type: !218, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!234 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !235, file: !42, line: 475)
!235 = !DISubprogram(name: "frexpl", scope: !57, file: !57, line: 98, type: !236, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!236 = !DISubroutineType(types: !237)
!237 = !{!41, !41, !86}
!238 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !239, file: !42, line: 476)
!239 = !DISubprogram(name: "ldexpl", scope: !57, file: !57, line: 101, type: !240, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!240 = !DISubroutineType(types: !241)
!241 = !{!41, !41, !7}
!242 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !243, file: !42, line: 477)
!243 = !DISubprogram(name: "logl", scope: !57, file: !57, line: 104, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!244 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !245, file: !42, line: 478)
!245 = !DISubprogram(name: "log10l", scope: !57, file: !57, line: 107, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!246 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !247, file: !42, line: 479)
!247 = !DISubprogram(name: "modfl", scope: !57, file: !57, line: 110, type: !97, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!248 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !249, file: !42, line: 480)
!249 = !DISubprogram(name: "powl", scope: !57, file: !57, line: 140, type: !218, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!250 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !251, file: !42, line: 481)
!251 = !DISubprogram(name: "sinl", scope: !57, file: !57, line: 64, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!252 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !253, file: !42, line: 482)
!253 = !DISubprogram(name: "sinhl", scope: !57, file: !57, line: 73, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!254 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !255, file: !42, line: 483)
!255 = !DISubprogram(name: "sqrtl", scope: !57, file: !57, line: 143, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!256 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !257, file: !42, line: 484)
!257 = !DISubprogram(name: "tanl", scope: !57, file: !57, line: 66, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!258 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !259, file: !42, line: 486)
!259 = !DISubprogram(name: "tanhl", scope: !57, file: !57, line: 75, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!260 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !261, file: !42, line: 487)
!261 = !DISubprogram(name: "acoshl", scope: !57, file: !57, line: 85, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!262 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !263, file: !42, line: 488)
!263 = !DISubprogram(name: "asinhl", scope: !57, file: !57, line: 87, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!264 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !265, file: !42, line: 489)
!265 = !DISubprogram(name: "atanhl", scope: !57, file: !57, line: 89, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!266 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !267, file: !42, line: 490)
!267 = !DISubprogram(name: "cbrtl", scope: !57, file: !57, line: 152, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!268 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !269, file: !42, line: 492)
!269 = !DISubprogram(name: "copysignl", scope: !57, file: !57, line: 196, type: !218, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!270 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !271, file: !42, line: 494)
!271 = !DISubprogram(name: "erfl", scope: !57, file: !57, line: 228, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!272 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !273, file: !42, line: 495)
!273 = !DISubprogram(name: "erfcl", scope: !57, file: !57, line: 229, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!274 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !275, file: !42, line: 496)
!275 = !DISubprogram(name: "exp2l", scope: !57, file: !57, line: 130, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!276 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !277, file: !42, line: 497)
!277 = !DISubprogram(name: "expm1l", scope: !57, file: !57, line: 119, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!278 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !279, file: !42, line: 498)
!279 = !DISubprogram(name: "fdiml", scope: !57, file: !57, line: 326, type: !218, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!280 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !281, file: !42, line: 499)
!281 = !DISubprogram(name: "fmal", scope: !57, file: !57, line: 335, type: !282, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!282 = !DISubroutineType(types: !283)
!283 = !{!41, !41, !41, !41}
!284 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !285, file: !42, line: 500)
!285 = !DISubprogram(name: "fmaxl", scope: !57, file: !57, line: 329, type: !218, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!286 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !287, file: !42, line: 501)
!287 = !DISubprogram(name: "fminl", scope: !57, file: !57, line: 332, type: !218, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!288 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !289, file: !42, line: 502)
!289 = !DISubprogram(name: "hypotl", scope: !57, file: !57, line: 147, type: !218, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!290 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !291, file: !42, line: 503)
!291 = !DISubprogram(name: "ilogbl", scope: !57, file: !57, line: 280, type: !292, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!292 = !DISubroutineType(types: !293)
!293 = !{!7, !41}
!294 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !295, file: !42, line: 504)
!295 = !DISubprogram(name: "lgammal", scope: !57, file: !57, line: 230, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!296 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !297, file: !42, line: 505)
!297 = !DISubprogram(name: "llrintl", scope: !57, file: !57, line: 316, type: !298, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!298 = !DISubroutineType(types: !299)
!299 = !{!157, !41}
!300 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !301, file: !42, line: 506)
!301 = !DISubprogram(name: "llroundl", scope: !57, file: !57, line: 322, type: !298, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!302 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !303, file: !42, line: 507)
!303 = !DISubprogram(name: "log1pl", scope: !57, file: !57, line: 122, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!304 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !305, file: !42, line: 508)
!305 = !DISubprogram(name: "log2l", scope: !57, file: !57, line: 133, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!306 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !307, file: !42, line: 509)
!307 = !DISubprogram(name: "logbl", scope: !57, file: !57, line: 125, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!308 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !309, file: !42, line: 510)
!309 = !DISubprogram(name: "lrintl", scope: !57, file: !57, line: 314, type: !310, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!310 = !DISubroutineType(types: !311)
!311 = !{!26, !41}
!312 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !313, file: !42, line: 511)
!313 = !DISubprogram(name: "lroundl", scope: !57, file: !57, line: 320, type: !310, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!314 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !315, file: !42, line: 512)
!315 = !DISubprogram(name: "nanl", scope: !57, file: !57, line: 201, type: !316, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!316 = !DISubroutineType(types: !317)
!317 = !{!41, !176}
!318 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !319, file: !42, line: 513)
!319 = !DISubprogram(name: "nearbyintl", scope: !57, file: !57, line: 294, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!320 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !321, file: !42, line: 514)
!321 = !DISubprogram(name: "nextafterl", scope: !57, file: !57, line: 259, type: !218, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!322 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !323, file: !42, line: 515)
!323 = !DISubprogram(name: "nexttowardl", scope: !57, file: !57, line: 261, type: !218, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!324 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !325, file: !42, line: 516)
!325 = !DISubprogram(name: "remainderl", scope: !57, file: !57, line: 272, type: !218, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!326 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !327, file: !42, line: 517)
!327 = !DISubprogram(name: "remquol", scope: !57, file: !57, line: 307, type: !328, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!328 = !DISubroutineType(types: !329)
!329 = !{!41, !41, !41, !86}
!330 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !331, file: !42, line: 518)
!331 = !DISubprogram(name: "rintl", scope: !57, file: !57, line: 256, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!332 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !333, file: !42, line: 519)
!333 = !DISubprogram(name: "roundl", scope: !57, file: !57, line: 298, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!334 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !335, file: !42, line: 520)
!335 = !DISubprogram(name: "scalblnl", scope: !57, file: !57, line: 290, type: !336, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!336 = !DISubroutineType(types: !337)
!337 = !{!41, !41, !26}
!338 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !339, file: !42, line: 521)
!339 = !DISubprogram(name: "scalbnl", scope: !57, file: !57, line: 276, type: !240, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!340 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !341, file: !42, line: 522)
!341 = !DISubprogram(name: "tgammal", scope: !57, file: !57, line: 235, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!342 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !343, file: !42, line: 523)
!343 = !DISubprogram(name: "truncl", scope: !57, file: !57, line: 302, type: !53, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!344 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !29, file: !345, line: 99)
!345 = !DIFile(filename: "build_tool/../usr/include/c++/v1/cstdlib", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!346 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !347, file: !345, line: 100)
!347 = !DIDerivedType(tag: DW_TAG_typedef, name: "div_t", file: !348, line: 62, baseType: !349)
!348 = !DIFile(filename: "/usr/include/stdlib.h", directory: "")
!349 = !DICompositeType(tag: DW_TAG_structure_type, file: !348, line: 58, flags: DIFlagFwdDecl, identifier: "_ZTS5div_t")
!350 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !351, file: !345, line: 101)
!351 = !DIDerivedType(tag: DW_TAG_typedef, name: "ldiv_t", file: !348, line: 70, baseType: !352)
!352 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !348, line: 66, size: 128, flags: DIFlagTypePassByValue, elements: !353, identifier: "_ZTS6ldiv_t")
!353 = !{!354, !355}
!354 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !352, file: !348, line: 68, baseType: !26, size: 64)
!355 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !352, file: !348, line: 69, baseType: !26, size: 64, offset: 64)
!356 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !357, file: !345, line: 103)
!357 = !DIDerivedType(tag: DW_TAG_typedef, name: "lldiv_t", file: !348, line: 80, baseType: !358)
!358 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !348, line: 76, size: 128, flags: DIFlagTypePassByValue, elements: !359, identifier: "_ZTS7lldiv_t")
!359 = !{!360, !361}
!360 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !358, file: !348, line: 78, baseType: !157, size: 64)
!361 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !358, file: !348, line: 79, baseType: !157, size: 64, offset: 64)
!362 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !363, file: !345, line: 105)
!363 = !DISubprogram(name: "atof", scope: !364, file: !364, line: 25, type: !174, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!364 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdlib-float.h", directory: "")
!365 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !366, file: !345, line: 106)
!366 = distinct !DISubprogram(name: "atoi", scope: !348, file: !348, line: 361, type: !367, scopeLine: 362, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !369)
!367 = !DISubroutineType(types: !368)
!368 = !{!7, !176}
!369 = !{!370}
!370 = !DILocalVariable(name: "__nptr", arg: 1, scope: !366, file: !348, line: 361, type: !176)
!371 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !372, file: !345, line: 107)
!372 = !DISubprogram(name: "atol", scope: !348, file: !348, line: 366, type: !373, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!373 = !DISubroutineType(types: !374)
!374 = !{!26, !176}
!375 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !376, file: !345, line: 109)
!376 = !DISubprogram(name: "atoll", scope: !348, file: !348, line: 373, type: !377, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!377 = !DISubroutineType(types: !378)
!378 = !{!157, !176}
!379 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !380, file: !345, line: 111)
!380 = !DISubprogram(name: "strtod", scope: !348, file: !348, line: 117, type: !381, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!381 = !DISubroutineType(types: !382)
!382 = !{!6, !383, !384}
!383 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !176)
!384 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !8)
!385 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !386, file: !345, line: 112)
!386 = !DISubprogram(name: "strtof", scope: !348, file: !348, line: 123, type: !387, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!387 = !DISubroutineType(types: !388)
!388 = !{!48, !383, !384}
!389 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !390, file: !345, line: 113)
!390 = !DISubprogram(name: "strtold", scope: !348, file: !348, line: 126, type: !391, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!391 = !DISubroutineType(types: !392)
!392 = !{!41, !383, !384}
!393 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !394, file: !345, line: 114)
!394 = !DISubprogram(name: "strtol", scope: !348, file: !348, line: 176, type: !395, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!395 = !DISubroutineType(types: !396)
!396 = !{!26, !383, !384, !7}
!397 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !398, file: !345, line: 116)
!398 = !DISubprogram(name: "strtoll", scope: !348, file: !348, line: 200, type: !399, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!399 = !DISubroutineType(types: !400)
!400 = !{!157, !383, !384, !7}
!401 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !402, file: !345, line: 118)
!402 = !DISubprogram(name: "strtoul", scope: !348, file: !348, line: 180, type: !403, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!403 = !DISubroutineType(types: !404)
!404 = !{!30, !383, !384, !7}
!405 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !406, file: !345, line: 120)
!406 = !DISubprogram(name: "strtoull", scope: !348, file: !348, line: 205, type: !407, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!407 = !DISubroutineType(types: !408)
!408 = !{!409, !383, !384, !7}
!409 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!410 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !411, file: !345, line: 122)
!411 = !DISubprogram(name: "rand", scope: !348, file: !348, line: 453, type: !412, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!412 = !DISubroutineType(types: !413)
!413 = !{!7}
!414 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !415, file: !345, line: 123)
!415 = !DISubprogram(name: "srand", scope: !348, file: !348, line: 455, type: !416, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!416 = !DISubroutineType(types: !417)
!417 = !{null, !418}
!418 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!419 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !420, file: !345, line: 124)
!420 = !DISubprogram(name: "calloc", scope: !348, file: !348, line: 541, type: !421, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!421 = !DISubroutineType(types: !422)
!422 = !{!423, !29, !29}
!423 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!424 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !425, file: !345, line: 125)
!425 = !DISubprogram(name: "free", scope: !348, file: !348, line: 563, type: !426, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!426 = !DISubroutineType(types: !427)
!427 = !{null, !423}
!428 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !429, file: !345, line: 126)
!429 = !DISubprogram(name: "malloc", scope: !348, file: !348, line: 539, type: !430, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!430 = !DISubroutineType(types: !431)
!431 = !{!423, !29}
!432 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !433, file: !345, line: 127)
!433 = !DISubprogram(name: "realloc", scope: !348, file: !348, line: 549, type: !434, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!434 = !DISubroutineType(types: !435)
!435 = !{!423, !423, !29}
!436 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !437, file: !345, line: 128)
!437 = !DISubprogram(name: "abort", scope: !348, file: !348, line: 588, type: !438, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!438 = !DISubroutineType(types: !439)
!439 = !{null}
!440 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !441, file: !345, line: 129)
!441 = !DISubprogram(name: "atexit", scope: !348, file: !348, line: 592, type: !442, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!442 = !DISubroutineType(types: !443)
!443 = !{!7, !444}
!444 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !438, size: 64)
!445 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !446, file: !345, line: 130)
!446 = !DISubprogram(name: "exit", scope: !348, file: !348, line: 614, type: !447, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!447 = !DISubroutineType(types: !448)
!448 = !{null, !7}
!449 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !450, file: !345, line: 131)
!450 = !DISubprogram(name: "_Exit", scope: !348, file: !348, line: 626, type: !447, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!451 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !452, file: !345, line: 133)
!452 = !DISubprogram(name: "getenv", scope: !348, file: !348, line: 631, type: !453, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!453 = !DISubroutineType(types: !454)
!454 = !{!9, !176}
!455 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !456, file: !345, line: 134)
!456 = !DISubprogram(name: "system", scope: !348, file: !348, line: 781, type: !367, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!457 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !458, file: !345, line: 136)
!458 = !DISubprogram(name: "bsearch", scope: !459, file: !459, line: 20, type: !460, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!459 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdlib-bsearch.h", directory: "")
!460 = !DISubroutineType(types: !461)
!461 = !{!423, !462, !462, !29, !29, !464}
!462 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !463, size: 64)
!463 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!464 = !DIDerivedType(tag: DW_TAG_typedef, name: "__compar_fn_t", file: !348, line: 805, baseType: !465)
!465 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !466, size: 64)
!466 = !DISubroutineType(types: !467)
!467 = !{!7, !462, !462}
!468 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !469, file: !345, line: 137)
!469 = !DISubprogram(name: "qsort", scope: !348, file: !348, line: 827, type: !470, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!470 = !DISubroutineType(types: !471)
!471 = !{null, !423, !29, !29, !464}
!472 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !52, file: !345, line: 138)
!473 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !474, file: !345, line: 139)
!474 = !DISubprogram(name: "labs", scope: !348, file: !348, line: 838, type: !475, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!475 = !DISubroutineType(types: !476)
!476 = !{!26, !26}
!477 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !478, file: !345, line: 141)
!478 = !DISubprogram(name: "llabs", scope: !348, file: !348, line: 841, type: !479, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!479 = !DISubroutineType(types: !480)
!480 = !{!157, !157}
!481 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !482, file: !345, line: 143)
!482 = !DISubprogram(name: "div", linkageName: "_Z3divxx", scope: !37, file: !37, line: 808, type: !483, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!483 = !DISubroutineType(types: !484)
!484 = !{!357, !157, !157}
!485 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !486, file: !345, line: 144)
!486 = !DISubprogram(name: "ldiv", scope: !348, file: !348, line: 851, type: !487, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!487 = !DISubroutineType(types: !488)
!488 = !{!351, !26, !26}
!489 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !490, file: !345, line: 146)
!490 = !DISubprogram(name: "lldiv", scope: !348, file: !348, line: 855, type: !483, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!491 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !492, file: !345, line: 148)
!492 = !DISubprogram(name: "mblen", scope: !348, file: !348, line: 919, type: !493, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!493 = !DISubroutineType(types: !494)
!494 = !{!7, !176, !29}
!495 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !496, file: !345, line: 149)
!496 = !DISubprogram(name: "mbtowc", scope: !348, file: !348, line: 922, type: !497, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!497 = !DISubroutineType(types: !498)
!498 = !{!7, !499, !383, !29}
!499 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !500)
!500 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !501, size: 64)
!501 = !DIBasicType(name: "wchar_t", size: 32, encoding: DW_ATE_signed)
!502 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !503, file: !345, line: 150)
!503 = !DISubprogram(name: "wctomb", scope: !348, file: !348, line: 926, type: !504, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!504 = !DISubroutineType(types: !505)
!505 = !{!7, !9, !501}
!506 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !507, file: !345, line: 151)
!507 = !DISubprogram(name: "mbstowcs", scope: !348, file: !348, line: 930, type: !508, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!508 = !DISubroutineType(types: !509)
!509 = !{!29, !499, !383, !29}
!510 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !511, file: !345, line: 152)
!511 = !DISubprogram(name: "wcstombs", scope: !348, file: !348, line: 933, type: !512, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!512 = !DISubroutineType(types: !513)
!513 = !{!29, !514, !515, !29}
!514 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !9)
!515 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !516)
!516 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !517, size: 64)
!517 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !501)
!518 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !519, file: !345, line: 154)
!519 = !DISubprogram(name: "at_quick_exit", scope: !348, file: !348, line: 597, type: !442, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!520 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !521, file: !345, line: 155)
!521 = !DISubprogram(name: "quick_exit", scope: !348, file: !348, line: 620, type: !447, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagOptimized)
!522 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !29, file: !523, line: 68)
!523 = !DIFile(filename: "build_tool/../usr/include/c++/v1/cstring", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!524 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !525, file: !523, line: 69)
!525 = !DISubprogram(name: "memcpy", scope: !526, file: !526, line: 42, type: !527, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!526 = !DIFile(filename: "/usr/include/string.h", directory: "")
!527 = !DISubroutineType(types: !528)
!528 = !{!423, !529, !530, !29}
!529 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !423)
!530 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !462)
!531 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !532, file: !523, line: 70)
!532 = !DISubprogram(name: "memmove", scope: !526, file: !526, line: 46, type: !533, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!533 = !DISubroutineType(types: !534)
!534 = !{!423, !423, !462, !29}
!535 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !536, file: !523, line: 71)
!536 = !DISubprogram(name: "strcpy", scope: !526, file: !526, line: 121, type: !537, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!537 = !DISubroutineType(types: !538)
!538 = !{!9, !514, !383}
!539 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !540, file: !523, line: 72)
!540 = !DISubprogram(name: "strncpy", scope: !526, file: !526, line: 124, type: !541, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!541 = !DISubroutineType(types: !542)
!542 = !{!9, !514, !383, !29}
!543 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !544, file: !523, line: 73)
!544 = !DISubprogram(name: "strcat", scope: !526, file: !526, line: 129, type: !537, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!545 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !546, file: !523, line: 74)
!546 = !DISubprogram(name: "strncat", scope: !526, file: !526, line: 132, type: !541, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!547 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !548, file: !523, line: 75)
!548 = !DISubprogram(name: "memcmp", scope: !526, file: !526, line: 63, type: !549, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!549 = !DISubroutineType(types: !550)
!550 = !{!7, !462, !462, !29}
!551 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !552, file: !523, line: 76)
!552 = !DISubprogram(name: "strcmp", scope: !526, file: !526, line: 136, type: !553, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!553 = !DISubroutineType(types: !554)
!554 = !{!7, !176, !176}
!555 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !556, file: !523, line: 77)
!556 = !DISubprogram(name: "strncmp", scope: !526, file: !526, line: 139, type: !557, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!557 = !DISubroutineType(types: !558)
!558 = !{!7, !176, !176, !29}
!559 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !560, file: !523, line: 78)
!560 = !DISubprogram(name: "strcoll", scope: !526, file: !526, line: 143, type: !553, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!561 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !562, file: !523, line: 79)
!562 = !DISubprogram(name: "strxfrm", scope: !526, file: !526, line: 146, type: !563, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!563 = !DISubroutineType(types: !564)
!564 = !{!29, !514, !383, !29}
!565 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !566, file: !523, line: 80)
!566 = !DISubprogram(name: "memchr", linkageName: "_Z6memchrUa9enable_ifIXLb1EEEPvim", scope: !567, file: !567, line: 98, type: !568, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!567 = !DIFile(filename: "build_tool/../usr/include/c++/v1/string.h", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!568 = !DISubroutineType(types: !569)
!569 = !{!423, !423, !7, !29}
!570 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !571, file: !523, line: 81)
!571 = !DISubprogram(name: "strchr", linkageName: "_Z6strchrUa9enable_ifIXLb1EEEPci", scope: !567, file: !567, line: 77, type: !572, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!572 = !DISubroutineType(types: !573)
!573 = !{!9, !9, !7}
!574 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !575, file: !523, line: 82)
!575 = !DISubprogram(name: "strcspn", scope: !526, file: !526, line: 272, type: !576, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!576 = !DISubroutineType(types: !577)
!577 = !{!29, !176, !176}
!578 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !579, file: !523, line: 83)
!579 = !DISubprogram(name: "strpbrk", linkageName: "_Z7strpbrkUa9enable_ifIXLb1EEEPcPKc", scope: !567, file: !567, line: 84, type: !580, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!580 = !DISubroutineType(types: !581)
!581 = !{!9, !9, !176}
!582 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !583, file: !523, line: 84)
!583 = !DISubprogram(name: "strrchr", linkageName: "_Z7strrchrUa9enable_ifIXLb1EEEPci", scope: !567, file: !567, line: 91, type: !572, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!584 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !585, file: !523, line: 85)
!585 = !DISubprogram(name: "strspn", scope: !526, file: !526, line: 276, type: !576, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!586 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !587, file: !523, line: 86)
!587 = !DISubprogram(name: "strstr", linkageName: "_Z6strstrUa9enable_ifIXLb1EEEPcPKc", scope: !567, file: !567, line: 105, type: !580, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!588 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !589, file: !523, line: 88)
!589 = !DISubprogram(name: "strtok", scope: !526, file: !526, line: 335, type: !537, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!590 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !591, file: !523, line: 90)
!591 = !DISubprogram(name: "memset", scope: !526, file: !526, line: 60, type: !568, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!592 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !593, file: !523, line: 91)
!593 = !DISubprogram(name: "strerror", scope: !526, file: !526, line: 396, type: !594, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!594 = !DISubroutineType(types: !595)
!595 = !{!9, !7}
!596 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !597, file: !523, line: 92)
!597 = !DISubprogram(name: "strlen", scope: !526, file: !526, line: 384, type: !598, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!598 = !DISubroutineType(types: !599)
!599 = !{!29, !176}
!600 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !12, file: !601, line: 152)
!601 = !DIFile(filename: "build_tool/../usr/include/c++/v1/cstdint", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!602 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !603, file: !601, line: 153)
!603 = !DIDerivedType(tag: DW_TAG_typedef, name: "int16_t", file: !13, line: 25, baseType: !604)
!604 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int16_t", file: !15, line: 38, baseType: !605)
!605 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!606 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !607, file: !601, line: 154)
!607 = !DIDerivedType(tag: DW_TAG_typedef, name: "int32_t", file: !13, line: 26, baseType: !608)
!608 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int32_t", file: !15, line: 40, baseType: !7)
!609 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !610, file: !601, line: 155)
!610 = !DIDerivedType(tag: DW_TAG_typedef, name: "int64_t", file: !13, line: 27, baseType: !611)
!611 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int64_t", file: !15, line: 43, baseType: !26)
!612 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !613, file: !601, line: 157)
!613 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint8_t", file: !614, line: 24, baseType: !615)
!614 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "")
!615 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint8_t", file: !15, line: 37, baseType: !616)
!616 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!617 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !618, file: !601, line: 158)
!618 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint16_t", file: !614, line: 25, baseType: !619)
!619 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint16_t", file: !15, line: 39, baseType: !620)
!620 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!621 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !622, file: !601, line: 159)
!622 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !614, line: 26, baseType: !623)
!623 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !15, line: 41, baseType: !418)
!624 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !625, file: !601, line: 160)
!625 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", file: !614, line: 27, baseType: !626)
!626 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint64_t", file: !15, line: 44, baseType: !30)
!627 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !628, file: !601, line: 162)
!628 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least8_t", file: !629, line: 43, baseType: !16)
!629 = !DIFile(filename: "/usr/include/stdint.h", directory: "")
!630 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !631, file: !601, line: 163)
!631 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least16_t", file: !629, line: 44, baseType: !605)
!632 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !633, file: !601, line: 164)
!633 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least32_t", file: !629, line: 45, baseType: !7)
!634 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !635, file: !601, line: 165)
!635 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least64_t", file: !629, line: 47, baseType: !26)
!636 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !637, file: !601, line: 167)
!637 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least8_t", file: !629, line: 54, baseType: !616)
!638 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !639, file: !601, line: 168)
!639 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least16_t", file: !629, line: 55, baseType: !620)
!640 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !641, file: !601, line: 169)
!641 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least32_t", file: !629, line: 56, baseType: !418)
!642 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !643, file: !601, line: 170)
!643 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least64_t", file: !629, line: 58, baseType: !30)
!644 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !645, file: !601, line: 172)
!645 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast8_t", file: !629, line: 68, baseType: !16)
!646 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !647, file: !601, line: 173)
!647 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast16_t", file: !629, line: 70, baseType: !26)
!648 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !649, file: !601, line: 174)
!649 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast32_t", file: !629, line: 71, baseType: !26)
!650 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !651, file: !601, line: 175)
!651 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast64_t", file: !629, line: 72, baseType: !26)
!652 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !653, file: !601, line: 177)
!653 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast8_t", file: !629, line: 81, baseType: !616)
!654 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !655, file: !601, line: 178)
!655 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast16_t", file: !629, line: 83, baseType: !30)
!656 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !657, file: !601, line: 179)
!657 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast32_t", file: !629, line: 84, baseType: !30)
!658 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !659, file: !601, line: 180)
!659 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast64_t", file: !629, line: 85, baseType: !30)
!660 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !661, file: !601, line: 182)
!661 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !629, line: 97, baseType: !26)
!662 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !663, file: !601, line: 183)
!663 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !629, line: 100, baseType: !30)
!664 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !665, file: !601, line: 185)
!665 = !DIDerivedType(tag: DW_TAG_typedef, name: "intmax_t", file: !629, line: 111, baseType: !666)
!666 = !DIDerivedType(tag: DW_TAG_typedef, name: "__intmax_t", file: !15, line: 61, baseType: !26)
!667 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !668, file: !601, line: 186)
!668 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintmax_t", file: !629, line: 112, baseType: !669)
!669 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uintmax_t", file: !15, line: 62, baseType: !30)
!670 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !671, file: !718, line: 107)
!671 = !DIDerivedType(tag: DW_TAG_typedef, name: "FILE", file: !672, line: 7, baseType: !673)
!672 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/FILE.h", directory: "")
!673 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_FILE", file: !674, line: 245, size: 1728, flags: DIFlagTypePassByValue, elements: !675, identifier: "_ZTS8_IO_FILE")
!674 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/libio.h", directory: "")
!675 = !{!676, !677, !678, !679, !680, !681, !682, !683, !684, !685, !686, !687, !688, !691, !693, !694, !695, !697, !698, !699, !703, !706, !708, !709, !710, !711, !712, !713, !714}
!676 = !DIDerivedType(tag: DW_TAG_member, name: "_flags", scope: !673, file: !674, line: 246, baseType: !7, size: 32)
!677 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_read_ptr", scope: !673, file: !674, line: 251, baseType: !9, size: 64, offset: 64)
!678 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_read_end", scope: !673, file: !674, line: 252, baseType: !9, size: 64, offset: 128)
!679 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_read_base", scope: !673, file: !674, line: 253, baseType: !9, size: 64, offset: 192)
!680 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_write_base", scope: !673, file: !674, line: 254, baseType: !9, size: 64, offset: 256)
!681 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_write_ptr", scope: !673, file: !674, line: 255, baseType: !9, size: 64, offset: 320)
!682 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_write_end", scope: !673, file: !674, line: 256, baseType: !9, size: 64, offset: 384)
!683 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_buf_base", scope: !673, file: !674, line: 257, baseType: !9, size: 64, offset: 448)
!684 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_buf_end", scope: !673, file: !674, line: 258, baseType: !9, size: 64, offset: 512)
!685 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_save_base", scope: !673, file: !674, line: 260, baseType: !9, size: 64, offset: 576)
!686 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_backup_base", scope: !673, file: !674, line: 261, baseType: !9, size: 64, offset: 640)
!687 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_save_end", scope: !673, file: !674, line: 262, baseType: !9, size: 64, offset: 704)
!688 = !DIDerivedType(tag: DW_TAG_member, name: "_markers", scope: !673, file: !674, line: 264, baseType: !689, size: 64, offset: 768)
!689 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !690, size: 64)
!690 = !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_marker", file: !674, line: 160, flags: DIFlagFwdDecl, identifier: "_ZTS10_IO_marker")
!691 = !DIDerivedType(tag: DW_TAG_member, name: "_chain", scope: !673, file: !674, line: 266, baseType: !692, size: 64, offset: 832)
!692 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !673, size: 64)
!693 = !DIDerivedType(tag: DW_TAG_member, name: "_fileno", scope: !673, file: !674, line: 268, baseType: !7, size: 32, offset: 896)
!694 = !DIDerivedType(tag: DW_TAG_member, name: "_flags2", scope: !673, file: !674, line: 272, baseType: !7, size: 32, offset: 928)
!695 = !DIDerivedType(tag: DW_TAG_member, name: "_old_offset", scope: !673, file: !674, line: 274, baseType: !696, size: 64, offset: 960)
!696 = !DIDerivedType(tag: DW_TAG_typedef, name: "__off_t", file: !15, line: 140, baseType: !26)
!697 = !DIDerivedType(tag: DW_TAG_member, name: "_cur_column", scope: !673, file: !674, line: 278, baseType: !620, size: 16, offset: 1024)
!698 = !DIDerivedType(tag: DW_TAG_member, name: "_vtable_offset", scope: !673, file: !674, line: 279, baseType: !16, size: 8, offset: 1040)
!699 = !DIDerivedType(tag: DW_TAG_member, name: "_shortbuf", scope: !673, file: !674, line: 280, baseType: !700, size: 8, offset: 1048)
!700 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 8, elements: !701)
!701 = !{!702}
!702 = !DISubrange(count: 1)
!703 = !DIDerivedType(tag: DW_TAG_member, name: "_lock", scope: !673, file: !674, line: 284, baseType: !704, size: 64, offset: 1088)
!704 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !705, size: 64)
!705 = !DIDerivedType(tag: DW_TAG_typedef, name: "_IO_lock_t", file: !674, line: 154, baseType: null)
!706 = !DIDerivedType(tag: DW_TAG_member, name: "_offset", scope: !673, file: !674, line: 293, baseType: !707, size: 64, offset: 1152)
!707 = !DIDerivedType(tag: DW_TAG_typedef, name: "__off64_t", file: !15, line: 141, baseType: !26)
!708 = !DIDerivedType(tag: DW_TAG_member, name: "__pad1", scope: !673, file: !674, line: 301, baseType: !423, size: 64, offset: 1216)
!709 = !DIDerivedType(tag: DW_TAG_member, name: "__pad2", scope: !673, file: !674, line: 302, baseType: !423, size: 64, offset: 1280)
!710 = !DIDerivedType(tag: DW_TAG_member, name: "__pad3", scope: !673, file: !674, line: 303, baseType: !423, size: 64, offset: 1344)
!711 = !DIDerivedType(tag: DW_TAG_member, name: "__pad4", scope: !673, file: !674, line: 304, baseType: !423, size: 64, offset: 1408)
!712 = !DIDerivedType(tag: DW_TAG_member, name: "__pad5", scope: !673, file: !674, line: 306, baseType: !29, size: 64, offset: 1472)
!713 = !DIDerivedType(tag: DW_TAG_member, name: "_mode", scope: !673, file: !674, line: 307, baseType: !7, size: 32, offset: 1536)
!714 = !DIDerivedType(tag: DW_TAG_member, name: "_unused2", scope: !673, file: !674, line: 309, baseType: !715, size: 160, offset: 1568)
!715 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 160, elements: !716)
!716 = !{!717}
!717 = !DISubrange(count: 20)
!718 = !DIFile(filename: "build_tool/../usr/include/c++/v1/cstdio", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!719 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !720, file: !718, line: 108)
!720 = !DIDerivedType(tag: DW_TAG_typedef, name: "fpos_t", file: !721, line: 78, baseType: !722)
!721 = !DIFile(filename: "/usr/include/stdio.h", directory: "")
!722 = !DIDerivedType(tag: DW_TAG_typedef, name: "_G_fpos_t", file: !723, line: 30, baseType: !724)
!723 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/_G_config.h", directory: "")
!724 = !DICompositeType(tag: DW_TAG_structure_type, file: !723, line: 26, flags: DIFlagFwdDecl, identifier: "_ZTS9_G_fpos_t")
!725 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !29, file: !718, line: 109)
!726 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !727, file: !718, line: 111)
!727 = !DISubprogram(name: "fclose", scope: !721, file: !721, line: 199, type: !728, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!728 = !DISubroutineType(types: !729)
!729 = !{!7, !730}
!730 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !671, size: 64)
!731 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !732, file: !718, line: 112)
!732 = !DISubprogram(name: "fflush", scope: !721, file: !721, line: 204, type: !728, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!733 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !734, file: !718, line: 113)
!734 = !DISubprogram(name: "setbuf", scope: !721, file: !721, line: 290, type: !735, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!735 = !DISubroutineType(types: !736)
!736 = !{null, !737, !514}
!737 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !730)
!738 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !739, file: !718, line: 114)
!739 = !DISubprogram(name: "setvbuf", scope: !721, file: !721, line: 294, type: !740, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!740 = !DISubroutineType(types: !741)
!741 = !{!7, !737, !514, !7, !29}
!742 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !743, file: !718, line: 115)
!743 = !DISubprogram(name: "fprintf", scope: !721, file: !721, line: 312, type: !744, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!744 = !DISubroutineType(types: !745)
!745 = !{!7, !737, !383, null}
!746 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !747, file: !718, line: 116)
!747 = !DISubprogram(name: "fscanf", scope: !721, file: !721, line: 377, type: !744, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!748 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !749, file: !718, line: 117)
!749 = !DISubprogram(name: "snprintf", scope: !721, file: !721, line: 340, type: !750, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!750 = !DISubroutineType(types: !751)
!751 = !{!7, !514, !29, !383, null}
!752 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !753, file: !718, line: 118)
!753 = !DISubprogram(name: "sprintf", scope: !721, file: !721, line: 320, type: !754, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!754 = !DISubroutineType(types: !755)
!755 = !{!7, !514, !383, null}
!756 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !757, file: !718, line: 119)
!757 = !DISubprogram(name: "sscanf", scope: !721, file: !721, line: 385, type: !758, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!758 = !DISubroutineType(types: !759)
!759 = !{!7, !383, !383, null}
!760 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !761, file: !718, line: 120)
!761 = !DISubprogram(name: "vfprintf", scope: !721, file: !721, line: 327, type: !762, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!762 = !DISubroutineType(types: !763)
!763 = !{!7, !737, !383, !764}
!764 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !765, size: 64)
!765 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__va_list_tag", file: !3, size: 192, flags: DIFlagTypePassByValue, elements: !766, identifier: "_ZTS13__va_list_tag")
!766 = !{!767, !768, !769, !770}
!767 = !DIDerivedType(tag: DW_TAG_member, name: "gp_offset", scope: !765, file: !3, baseType: !418, size: 32)
!768 = !DIDerivedType(tag: DW_TAG_member, name: "fp_offset", scope: !765, file: !3, baseType: !418, size: 32, offset: 32)
!769 = !DIDerivedType(tag: DW_TAG_member, name: "overflow_arg_area", scope: !765, file: !3, baseType: !423, size: 64, offset: 64)
!770 = !DIDerivedType(tag: DW_TAG_member, name: "reg_save_area", scope: !765, file: !3, baseType: !423, size: 64, offset: 128)
!771 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !772, file: !718, line: 121)
!772 = !DISubprogram(name: "vfscanf", scope: !721, file: !721, line: 420, type: !762, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!773 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !774, file: !718, line: 122)
!774 = !DISubprogram(name: "vsscanf", scope: !721, file: !721, line: 432, type: !775, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!775 = !DISubroutineType(types: !776)
!776 = !{!7, !383, !383, !764}
!777 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !778, file: !718, line: 123)
!778 = !DISubprogram(name: "vsnprintf", scope: !721, file: !721, line: 344, type: !779, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!779 = !DISubroutineType(types: !780)
!780 = !{!7, !514, !29, !383, !764}
!781 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !782, file: !718, line: 124)
!782 = !DISubprogram(name: "vsprintf", scope: !721, file: !721, line: 335, type: !783, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!783 = !DISubroutineType(types: !784)
!784 = !{!7, !514, !383, !764}
!785 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !786, file: !718, line: 125)
!786 = !DISubprogram(name: "fgetc", scope: !721, file: !721, line: 477, type: !728, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!787 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !788, file: !718, line: 126)
!788 = !DISubprogram(name: "fgets", scope: !721, file: !721, line: 564, type: !789, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!789 = !DISubroutineType(types: !790)
!790 = !{!9, !514, !7, !737}
!791 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !792, file: !718, line: 127)
!792 = !DISubprogram(name: "fputc", scope: !721, file: !721, line: 517, type: !793, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!793 = !DISubroutineType(types: !794)
!794 = !{!7, !7, !730}
!795 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !796, file: !718, line: 128)
!796 = !DISubprogram(name: "fputs", scope: !721, file: !721, line: 626, type: !797, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!797 = !DISubroutineType(types: !798)
!798 = !{!7, !383, !737}
!799 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !800, file: !718, line: 129)
!800 = !DISubprogram(name: "getc", scope: !721, file: !721, line: 478, type: !728, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!801 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !802, file: !718, line: 130)
!802 = !DISubprogram(name: "putc", scope: !721, file: !721, line: 518, type: !793, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!803 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !804, file: !718, line: 131)
!804 = !DISubprogram(name: "ungetc", scope: !721, file: !721, line: 639, type: !793, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!805 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !806, file: !718, line: 132)
!806 = !DISubprogram(name: "fread", scope: !721, file: !721, line: 646, type: !807, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!807 = !DISubroutineType(types: !808)
!808 = !{!29, !529, !29, !29, !737}
!809 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !810, file: !718, line: 133)
!810 = !DISubprogram(name: "fwrite", scope: !721, file: !721, line: 652, type: !811, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!811 = !DISubroutineType(types: !812)
!812 = !{!29, !530, !29, !29, !737}
!813 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !814, file: !718, line: 134)
!814 = !DISubprogram(name: "fgetpos", scope: !721, file: !721, line: 731, type: !815, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!815 = !DISubroutineType(types: !816)
!816 = !{!7, !737, !817}
!817 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !818)
!818 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !720, size: 64)
!819 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !820, file: !718, line: 135)
!820 = !DISubprogram(name: "fseek", scope: !721, file: !721, line: 684, type: !821, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!821 = !DISubroutineType(types: !822)
!822 = !{!7, !730, !26, !7}
!823 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !824, file: !718, line: 136)
!824 = !DISubprogram(name: "fsetpos", scope: !721, file: !721, line: 736, type: !825, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!825 = !DISubroutineType(types: !826)
!826 = !{!7, !730, !827}
!827 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !828, size: 64)
!828 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !720)
!829 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !830, file: !718, line: 137)
!830 = !DISubprogram(name: "ftell", scope: !721, file: !721, line: 689, type: !831, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!831 = !DISubroutineType(types: !832)
!832 = !{!26, !730}
!833 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !834, file: !718, line: 138)
!834 = !DISubprogram(name: "rewind", scope: !721, file: !721, line: 694, type: !835, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!835 = !DISubroutineType(types: !836)
!836 = !{null, !730}
!837 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !838, file: !718, line: 139)
!838 = !DISubprogram(name: "clearerr", scope: !721, file: !721, line: 757, type: !835, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!839 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !840, file: !718, line: 140)
!840 = !DISubprogram(name: "feof", scope: !721, file: !721, line: 759, type: !728, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!841 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !842, file: !718, line: 141)
!842 = !DISubprogram(name: "ferror", scope: !721, file: !721, line: 761, type: !728, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!843 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !844, file: !718, line: 142)
!844 = !DISubprogram(name: "perror", scope: !721, file: !721, line: 775, type: !845, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!845 = !DISubroutineType(types: !846)
!846 = !{null, !176}
!847 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !848, file: !718, line: 145)
!848 = !DISubprogram(name: "fopen", scope: !721, file: !721, line: 232, type: !849, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!849 = !DISubroutineType(types: !850)
!850 = !{!730, !383, !383}
!851 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !852, file: !718, line: 146)
!852 = !DISubprogram(name: "freopen", scope: !721, file: !721, line: 238, type: !853, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!853 = !DISubroutineType(types: !854)
!854 = !{!730, !383, !383, !737}
!855 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !856, file: !718, line: 147)
!856 = !DISubprogram(name: "remove", scope: !721, file: !721, line: 144, type: !367, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!857 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !858, file: !718, line: 148)
!858 = !DISubprogram(name: "rename", scope: !721, file: !721, line: 146, type: !553, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!859 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !860, file: !718, line: 149)
!860 = !DISubprogram(name: "tmpfile", scope: !721, file: !721, line: 159, type: !861, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!861 = !DISubroutineType(types: !862)
!862 = !{!730}
!863 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !864, file: !718, line: 150)
!864 = !DISubprogram(name: "tmpnam", scope: !721, file: !721, line: 173, type: !865, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!865 = !DISubroutineType(types: !866)
!866 = !{!9, !9}
!867 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !868, file: !718, line: 154)
!868 = !DISubprogram(name: "getchar", scope: !869, file: !869, line: 44, type: !412, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!869 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdio.h", directory: "")
!870 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !871, file: !718, line: 158)
!871 = !DISubprogram(name: "scanf", scope: !721, file: !721, line: 383, type: !872, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!872 = !DISubroutineType(types: !873)
!873 = !{!7, !383, null}
!874 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !875, file: !718, line: 159)
!875 = !DISubprogram(name: "vscanf", scope: !721, file: !721, line: 428, type: !876, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!876 = !DISubroutineType(types: !877)
!877 = !{!7, !383, !764}
!878 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !879, file: !718, line: 163)
!879 = !DISubprogram(name: "printf", scope: !721, file: !721, line: 318, type: !872, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!880 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !881, file: !718, line: 164)
!881 = !DISubprogram(name: "putchar", scope: !869, file: !869, line: 79, type: !882, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!882 = !DISubroutineType(types: !883)
!883 = !{!7, !7}
!884 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !885, file: !718, line: 165)
!885 = !DISubprogram(name: "puts", scope: !721, file: !721, line: 632, type: !367, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!886 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !887, file: !718, line: 166)
!887 = !DISubprogram(name: "vprintf", scope: !869, file: !869, line: 36, type: !876, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!888 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !889, file: !891, line: 103)
!889 = !DISubprogram(name: "isalnum", scope: !890, file: !890, line: 174, type: !882, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!890 = !DIFile(filename: "/usr/include/ctype.h", directory: "")
!891 = !DIFile(filename: "build_tool/../usr/include/c++/v1/cctype", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!892 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !893, file: !891, line: 104)
!893 = !DISubprogram(name: "isalpha", scope: !890, file: !890, line: 175, type: !882, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!894 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !895, file: !891, line: 105)
!895 = !DISubprogram(name: "isblank", scope: !890, file: !890, line: 186, type: !882, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!896 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !897, file: !891, line: 106)
!897 = !DISubprogram(name: "iscntrl", scope: !890, file: !890, line: 176, type: !882, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!898 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !899, file: !891, line: 107)
!899 = !DISubprogram(name: "isdigit", scope: !890, file: !890, line: 177, type: !882, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!900 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !901, file: !891, line: 108)
!901 = !DISubprogram(name: "isgraph", scope: !890, file: !890, line: 179, type: !882, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!902 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !903, file: !891, line: 109)
!903 = !DISubprogram(name: "islower", scope: !890, file: !890, line: 178, type: !882, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!904 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !905, file: !891, line: 110)
!905 = !DISubprogram(name: "isprint", scope: !890, file: !890, line: 180, type: !882, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!906 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !907, file: !891, line: 111)
!907 = !DISubprogram(name: "ispunct", scope: !890, file: !890, line: 181, type: !882, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!908 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !909, file: !891, line: 112)
!909 = !DISubprogram(name: "isspace", scope: !890, file: !890, line: 182, type: !882, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!910 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !911, file: !891, line: 113)
!911 = !DISubprogram(name: "isupper", scope: !890, file: !890, line: 183, type: !882, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!912 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !913, file: !891, line: 114)
!913 = !DISubprogram(name: "isxdigit", scope: !890, file: !890, line: 184, type: !882, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!914 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !915, file: !891, line: 115)
!915 = !DISubprogram(name: "tolower", scope: !890, file: !890, line: 207, type: !882, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!916 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !917, file: !891, line: 116)
!917 = !DISubprogram(name: "toupper", scope: !890, file: !890, line: 213, type: !882, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!918 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !919, file: !921, line: 62)
!919 = !DIDerivedType(tag: DW_TAG_typedef, name: "wint_t", file: !920, line: 20, baseType: !418)
!920 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/wint_t.h", directory: "")
!921 = !DIFile(filename: "build_tool/../usr/include/c++/v1/cwctype", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!922 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !923, file: !921, line: 63)
!923 = !DIDerivedType(tag: DW_TAG_typedef, name: "wctrans_t", file: !924, line: 48, baseType: !925)
!924 = !DIFile(filename: "/usr/include/wctype.h", directory: "")
!925 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !926, size: 64)
!926 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !608)
!927 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !928, file: !921, line: 64)
!928 = !DIDerivedType(tag: DW_TAG_typedef, name: "wctype_t", file: !929, line: 38, baseType: !30)
!929 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/wctype-wchar.h", directory: "")
!930 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !931, file: !921, line: 65)
!931 = !DISubprogram(name: "iswalnum", scope: !929, file: !929, line: 95, type: !932, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!932 = !DISubroutineType(types: !933)
!933 = !{!7, !919}
!934 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !935, file: !921, line: 66)
!935 = !DISubprogram(name: "iswalpha", scope: !929, file: !929, line: 101, type: !932, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!936 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !937, file: !921, line: 67)
!937 = !DISubprogram(name: "iswblank", scope: !929, file: !929, line: 146, type: !932, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!938 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !939, file: !921, line: 68)
!939 = !DISubprogram(name: "iswcntrl", scope: !929, file: !929, line: 104, type: !932, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!940 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !941, file: !921, line: 69)
!941 = !DISubprogram(name: "iswdigit", scope: !929, file: !929, line: 108, type: !932, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!942 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !943, file: !921, line: 70)
!943 = !DISubprogram(name: "iswgraph", scope: !929, file: !929, line: 112, type: !932, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!944 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !945, file: !921, line: 71)
!945 = !DISubprogram(name: "iswlower", scope: !929, file: !929, line: 117, type: !932, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!946 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !947, file: !921, line: 72)
!947 = !DISubprogram(name: "iswprint", scope: !929, file: !929, line: 120, type: !932, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!948 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !949, file: !921, line: 73)
!949 = !DISubprogram(name: "iswpunct", scope: !929, file: !929, line: 125, type: !932, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!950 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !951, file: !921, line: 74)
!951 = !DISubprogram(name: "iswspace", scope: !929, file: !929, line: 130, type: !932, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!952 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !953, file: !921, line: 75)
!953 = !DISubprogram(name: "iswupper", scope: !929, file: !929, line: 135, type: !932, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!954 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !955, file: !921, line: 76)
!955 = !DISubprogram(name: "iswxdigit", scope: !929, file: !929, line: 140, type: !932, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!956 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !957, file: !921, line: 77)
!957 = !DISubprogram(name: "iswctype", scope: !929, file: !929, line: 159, type: !958, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!958 = !DISubroutineType(types: !959)
!959 = !{!7, !919, !928}
!960 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !961, file: !921, line: 78)
!961 = !DISubprogram(name: "wctype", scope: !929, file: !929, line: 155, type: !962, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!962 = !DISubroutineType(types: !963)
!963 = !{!928, !176}
!964 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !965, file: !921, line: 79)
!965 = !DISubprogram(name: "towlower", scope: !929, file: !929, line: 166, type: !966, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!966 = !DISubroutineType(types: !967)
!967 = !{!919, !919}
!968 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !969, file: !921, line: 80)
!969 = !DISubprogram(name: "towupper", scope: !929, file: !929, line: 169, type: !966, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!970 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !971, file: !921, line: 81)
!971 = !DISubprogram(name: "towctrans", scope: !924, file: !924, line: 55, type: !972, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!972 = !DISubroutineType(types: !973)
!973 = !{!919, !919, !923}
!974 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !975, file: !921, line: 82)
!975 = !DISubprogram(name: "wctrans", scope: !924, file: !924, line: 52, type: !976, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!976 = !DISubroutineType(types: !977)
!977 = !{!923, !176}
!978 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !979, file: !994, line: 115)
!979 = !DIDerivedType(tag: DW_TAG_typedef, name: "mbstate_t", file: !980, line: 6, baseType: !981)
!980 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/mbstate_t.h", directory: "")
!981 = !DIDerivedType(tag: DW_TAG_typedef, name: "__mbstate_t", file: !982, line: 21, baseType: !983)
!982 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/__mbstate_t.h", directory: "")
!983 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !982, line: 13, size: 64, flags: DIFlagTypePassByValue, elements: !984, identifier: "_ZTS11__mbstate_t")
!984 = !{!985, !986}
!985 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !983, file: !982, line: 15, baseType: !7, size: 32)
!986 = !DIDerivedType(tag: DW_TAG_member, name: "__value", scope: !983, file: !982, line: 20, baseType: !987, size: 32, offset: 32)
!987 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !983, file: !982, line: 16, size: 32, flags: DIFlagTypePassByValue, elements: !988, identifier: "_ZTSN11__mbstate_tUt_E")
!988 = !{!989, !990}
!989 = !DIDerivedType(tag: DW_TAG_member, name: "__wch", scope: !987, file: !982, line: 18, baseType: !418, size: 32)
!990 = !DIDerivedType(tag: DW_TAG_member, name: "__wchb", scope: !987, file: !982, line: 19, baseType: !991, size: 32)
!991 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 32, elements: !992)
!992 = !{!993}
!993 = !DISubrange(count: 4)
!994 = !DIFile(filename: "build_tool/../usr/include/c++/v1/cwchar", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!995 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !29, file: !994, line: 116)
!996 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !997, file: !994, line: 117)
!997 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "tm", file: !998, line: 7, size: 448, flags: DIFlagTypePassByValue, elements: !999, identifier: "_ZTS2tm")
!998 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/struct_tm.h", directory: "")
!999 = !{!1000, !1001, !1002, !1003, !1004, !1005, !1006, !1007, !1008, !1009, !1010}
!1000 = !DIDerivedType(tag: DW_TAG_member, name: "tm_sec", scope: !997, file: !998, line: 9, baseType: !7, size: 32)
!1001 = !DIDerivedType(tag: DW_TAG_member, name: "tm_min", scope: !997, file: !998, line: 10, baseType: !7, size: 32, offset: 32)
!1002 = !DIDerivedType(tag: DW_TAG_member, name: "tm_hour", scope: !997, file: !998, line: 11, baseType: !7, size: 32, offset: 64)
!1003 = !DIDerivedType(tag: DW_TAG_member, name: "tm_mday", scope: !997, file: !998, line: 12, baseType: !7, size: 32, offset: 96)
!1004 = !DIDerivedType(tag: DW_TAG_member, name: "tm_mon", scope: !997, file: !998, line: 13, baseType: !7, size: 32, offset: 128)
!1005 = !DIDerivedType(tag: DW_TAG_member, name: "tm_year", scope: !997, file: !998, line: 14, baseType: !7, size: 32, offset: 160)
!1006 = !DIDerivedType(tag: DW_TAG_member, name: "tm_wday", scope: !997, file: !998, line: 15, baseType: !7, size: 32, offset: 192)
!1007 = !DIDerivedType(tag: DW_TAG_member, name: "tm_yday", scope: !997, file: !998, line: 16, baseType: !7, size: 32, offset: 224)
!1008 = !DIDerivedType(tag: DW_TAG_member, name: "tm_isdst", scope: !997, file: !998, line: 17, baseType: !7, size: 32, offset: 256)
!1009 = !DIDerivedType(tag: DW_TAG_member, name: "tm_gmtoff", scope: !997, file: !998, line: 20, baseType: !26, size: 64, offset: 320)
!1010 = !DIDerivedType(tag: DW_TAG_member, name: "tm_zone", scope: !997, file: !998, line: 21, baseType: !176, size: 64, offset: 384)
!1011 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !919, file: !994, line: 118)
!1012 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !671, file: !994, line: 119)
!1013 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1014, file: !994, line: 120)
!1014 = !DISubprogram(name: "fwprintf", scope: !1015, file: !1015, line: 580, type: !1016, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1015 = !DIFile(filename: "/usr/include/wchar.h", directory: "")
!1016 = !DISubroutineType(types: !1017)
!1017 = !{!7, !1018, !515, null}
!1018 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !1019)
!1019 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1020, size: 64)
!1020 = !DIDerivedType(tag: DW_TAG_typedef, name: "__FILE", file: !1021, line: 5, baseType: !673)
!1021 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/__FILE.h", directory: "")
!1022 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1023, file: !994, line: 121)
!1023 = !DISubprogram(name: "fwscanf", scope: !1015, file: !1015, line: 621, type: !1016, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1024 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1025, file: !994, line: 122)
!1025 = !DISubprogram(name: "swprintf", scope: !1015, file: !1015, line: 590, type: !1026, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1026 = !DISubroutineType(types: !1027)
!1027 = !{!7, !499, !29, !515, null}
!1028 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1029, file: !994, line: 123)
!1029 = !DISubprogram(name: "vfwprintf", scope: !1015, file: !1015, line: 598, type: !1030, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1030 = !DISubroutineType(types: !1031)
!1031 = !{!7, !1018, !515, !764}
!1032 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1033, file: !994, line: 124)
!1033 = !DISubprogram(name: "vswprintf", scope: !1015, file: !1015, line: 611, type: !1034, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1034 = !DISubroutineType(types: !1035)
!1035 = !{!7, !499, !29, !515, !764}
!1036 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1037, file: !994, line: 125)
!1037 = !DISubprogram(name: "swscanf", scope: !1015, file: !1015, line: 631, type: !1038, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1038 = !DISubroutineType(types: !1039)
!1039 = !{!7, !515, !515, null}
!1040 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1041, file: !994, line: 126)
!1041 = !DISubprogram(name: "vfwscanf", scope: !1015, file: !1015, line: 673, type: !1030, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1042 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1043, file: !994, line: 127)
!1043 = !DISubprogram(name: "vswscanf", scope: !1015, file: !1015, line: 685, type: !1044, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1044 = !DISubroutineType(types: !1045)
!1045 = !{!7, !515, !515, !764}
!1046 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1047, file: !994, line: 128)
!1047 = !DISubprogram(name: "fgetwc", scope: !1015, file: !1015, line: 727, type: !1048, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1048 = !DISubroutineType(types: !1049)
!1049 = !{!919, !1019}
!1050 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1051, file: !994, line: 129)
!1051 = !DISubprogram(name: "fgetws", scope: !1015, file: !1015, line: 756, type: !1052, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1052 = !DISubroutineType(types: !1053)
!1053 = !{!500, !499, !7, !1018}
!1054 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1055, file: !994, line: 130)
!1055 = !DISubprogram(name: "fputwc", scope: !1015, file: !1015, line: 741, type: !1056, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1056 = !DISubroutineType(types: !1057)
!1057 = !{!919, !501, !1019}
!1058 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1059, file: !994, line: 131)
!1059 = !DISubprogram(name: "fputws", scope: !1015, file: !1015, line: 763, type: !1060, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1060 = !DISubroutineType(types: !1061)
!1061 = !{!7, !515, !1018}
!1062 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1063, file: !994, line: 132)
!1063 = !DISubprogram(name: "fwide", scope: !1015, file: !1015, line: 573, type: !1064, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1064 = !DISubroutineType(types: !1065)
!1065 = !{!7, !1019, !7}
!1066 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1067, file: !994, line: 133)
!1067 = !DISubprogram(name: "getwc", scope: !1015, file: !1015, line: 728, type: !1048, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1068 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1069, file: !994, line: 134)
!1069 = !DISubprogram(name: "putwc", scope: !1015, file: !1015, line: 742, type: !1056, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1070 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1071, file: !994, line: 135)
!1071 = !DISubprogram(name: "ungetwc", scope: !1015, file: !1015, line: 771, type: !1072, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1072 = !DISubroutineType(types: !1073)
!1073 = !{!919, !919, !1019}
!1074 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1075, file: !994, line: 136)
!1075 = !DISubprogram(name: "wcstod", scope: !1015, file: !1015, line: 377, type: !1076, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1076 = !DISubroutineType(types: !1077)
!1077 = !{!6, !515, !1078}
!1078 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !1079)
!1079 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !500, size: 64)
!1080 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1081, file: !994, line: 137)
!1081 = !DISubprogram(name: "wcstof", scope: !1015, file: !1015, line: 382, type: !1082, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1082 = !DISubroutineType(types: !1083)
!1083 = !{!48, !515, !1078}
!1084 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1085, file: !994, line: 138)
!1085 = !DISubprogram(name: "wcstold", scope: !1015, file: !1015, line: 384, type: !1086, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1086 = !DISubroutineType(types: !1087)
!1087 = !{!41, !515, !1078}
!1088 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1089, file: !994, line: 139)
!1089 = !DISubprogram(name: "wcstol", scope: !1015, file: !1015, line: 428, type: !1090, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1090 = !DISubroutineType(types: !1091)
!1091 = !{!26, !515, !1078, !7}
!1092 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1093, file: !994, line: 141)
!1093 = !DISubprogram(name: "wcstoll", scope: !1015, file: !1015, line: 441, type: !1094, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1094 = !DISubroutineType(types: !1095)
!1095 = !{!157, !515, !1078, !7}
!1096 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1097, file: !994, line: 143)
!1097 = !DISubprogram(name: "wcstoul", scope: !1015, file: !1015, line: 433, type: !1098, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1098 = !DISubroutineType(types: !1099)
!1099 = !{!30, !515, !1078, !7}
!1100 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1101, file: !994, line: 145)
!1101 = !DISubprogram(name: "wcstoull", scope: !1015, file: !1015, line: 448, type: !1102, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1102 = !DISubroutineType(types: !1103)
!1103 = !{!409, !515, !1078, !7}
!1104 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1105, file: !994, line: 147)
!1105 = !DISubprogram(name: "wcscpy", scope: !1015, file: !1015, line: 87, type: !1106, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1106 = !DISubroutineType(types: !1107)
!1107 = !{!500, !499, !515}
!1108 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1109, file: !994, line: 148)
!1109 = !DISubprogram(name: "wcsncpy", scope: !1015, file: !1015, line: 92, type: !1110, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1110 = !DISubroutineType(types: !1111)
!1111 = !{!500, !499, !515, !29}
!1112 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1113, file: !994, line: 149)
!1113 = !DISubprogram(name: "wcscat", scope: !1015, file: !1015, line: 97, type: !1106, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1114 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1115, file: !994, line: 150)
!1115 = !DISubprogram(name: "wcsncat", scope: !1015, file: !1015, line: 101, type: !1110, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1116 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1117, file: !994, line: 151)
!1117 = !DISubprogram(name: "wcscmp", scope: !1015, file: !1015, line: 106, type: !1118, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1118 = !DISubroutineType(types: !1119)
!1119 = !{!7, !516, !516}
!1120 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1121, file: !994, line: 152)
!1121 = !DISubprogram(name: "wcscoll", scope: !1015, file: !1015, line: 131, type: !1118, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1122 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1123, file: !994, line: 153)
!1123 = !DISubprogram(name: "wcsncmp", scope: !1015, file: !1015, line: 109, type: !1124, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1124 = !DISubroutineType(types: !1125)
!1125 = !{!7, !516, !516, !29}
!1126 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1127, file: !994, line: 154)
!1127 = !DISubprogram(name: "wcsxfrm", scope: !1015, file: !1015, line: 135, type: !1128, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1128 = !DISubroutineType(types: !1129)
!1129 = !{!29, !499, !515, !29}
!1130 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1131, file: !994, line: 155)
!1131 = !DISubprogram(name: "wcschr", scope: !1015, file: !1015, line: 161, type: !1132, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1132 = !DISubroutineType(types: !1133)
!1133 = !{!516, !516, !501}
!1134 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1135, file: !994, line: 156)
!1135 = !DISubprogram(name: "wcspbrk", scope: !1015, file: !1015, line: 197, type: !1136, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1136 = !DISubroutineType(types: !1137)
!1137 = !{!516, !516, !516}
!1138 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1139, file: !994, line: 157)
!1139 = !DISubprogram(name: "wcsrchr", scope: !1015, file: !1015, line: 171, type: !1132, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1140 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1141, file: !994, line: 158)
!1141 = !DISubprogram(name: "wcsstr", scope: !1015, file: !1015, line: 208, type: !1136, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1142 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1143, file: !994, line: 159)
!1143 = !DISubprogram(name: "wmemchr", scope: !1015, file: !1015, line: 249, type: !1144, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1144 = !DISubroutineType(types: !1145)
!1145 = !{!516, !516, !501, !29}
!1146 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1147, file: !994, line: 160)
!1147 = !DISubprogram(name: "wcscspn", scope: !1015, file: !1015, line: 187, type: !1148, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1148 = !DISubroutineType(types: !1149)
!1149 = !{!29, !516, !516}
!1150 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1151, file: !994, line: 161)
!1151 = !DISubprogram(name: "wcslen", scope: !1015, file: !1015, line: 222, type: !1152, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1152 = !DISubroutineType(types: !1153)
!1153 = !{!29, !516}
!1154 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1155, file: !994, line: 162)
!1155 = !DISubprogram(name: "wcsspn", scope: !1015, file: !1015, line: 191, type: !1148, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1156 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1157, file: !994, line: 163)
!1157 = !DISubprogram(name: "wcstok", scope: !1015, file: !1015, line: 217, type: !1158, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1158 = !DISubroutineType(types: !1159)
!1159 = !{!500, !499, !515, !1078}
!1160 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1161, file: !994, line: 164)
!1161 = !DISubprogram(name: "wmemcmp", scope: !1015, file: !1015, line: 258, type: !1124, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1162 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1163, file: !994, line: 165)
!1163 = !DISubprogram(name: "wmemcpy", scope: !1015, file: !1015, line: 262, type: !1110, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1164 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1165, file: !994, line: 166)
!1165 = !DISubprogram(name: "wmemmove", scope: !1015, file: !1015, line: 267, type: !1166, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1166 = !DISubroutineType(types: !1167)
!1167 = !{!500, !500, !516, !29}
!1168 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1169, file: !994, line: 167)
!1169 = !DISubprogram(name: "wmemset", scope: !1015, file: !1015, line: 271, type: !1170, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1170 = !DISubroutineType(types: !1171)
!1171 = !{!500, !500, !501, !29}
!1172 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1173, file: !994, line: 168)
!1173 = !DISubprogram(name: "wcsftime", scope: !1015, file: !1015, line: 835, type: !1174, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1174 = !DISubroutineType(types: !1175)
!1175 = !{!29, !499, !29, !515, !1176}
!1176 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !1177)
!1177 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1178, size: 64)
!1178 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !997)
!1179 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1180, file: !994, line: 169)
!1180 = !DISubprogram(name: "btowc", scope: !1015, file: !1015, line: 318, type: !1181, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1181 = !DISubroutineType(types: !1182)
!1182 = !{!919, !7}
!1183 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1184, file: !994, line: 170)
!1184 = !DISubprogram(name: "wctob", scope: !1015, file: !1015, line: 324, type: !932, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1185 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1186, file: !994, line: 171)
!1186 = !DISubprogram(name: "mbsinit", scope: !1015, file: !1015, line: 292, type: !1187, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1187 = !DISubroutineType(types: !1188)
!1188 = !{!7, !1189}
!1189 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1190, size: 64)
!1190 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !979)
!1191 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1192, file: !994, line: 172)
!1192 = !DISubprogram(name: "mbrlen", scope: !1015, file: !1015, line: 329, type: !1193, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1193 = !DISubroutineType(types: !1194)
!1194 = !{!29, !383, !29, !1195}
!1195 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !1196)
!1196 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !979, size: 64)
!1197 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1198, file: !994, line: 173)
!1198 = !DISubprogram(name: "mbrtowc", scope: !1015, file: !1015, line: 296, type: !1199, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1199 = !DISubroutineType(types: !1200)
!1200 = !{!29, !499, !383, !29, !1195}
!1201 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1202, file: !994, line: 174)
!1202 = !DISubprogram(name: "wcrtomb", scope: !1015, file: !1015, line: 301, type: !1203, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1203 = !DISubroutineType(types: !1204)
!1204 = !{!29, !514, !501, !1195}
!1205 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1206, file: !994, line: 175)
!1206 = !DISubprogram(name: "mbsrtowcs", scope: !1015, file: !1015, line: 337, type: !1207, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1207 = !DISubroutineType(types: !1208)
!1208 = !{!29, !499, !1209, !29, !1195}
!1209 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !1210)
!1210 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !176, size: 64)
!1211 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1212, file: !994, line: 176)
!1212 = !DISubprogram(name: "wcsrtombs", scope: !1015, file: !1015, line: 343, type: !1213, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1213 = !DISubroutineType(types: !1214)
!1214 = !{!29, !514, !1215, !29, !1195}
!1215 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !1216)
!1216 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !516, size: 64)
!1217 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1218, file: !994, line: 179)
!1218 = !DISubprogram(name: "getwchar", scope: !1015, file: !1015, line: 734, type: !1219, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1219 = !DISubroutineType(types: !1220)
!1220 = !{!919}
!1221 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1222, file: !994, line: 180)
!1222 = !DISubprogram(name: "vwscanf", scope: !1015, file: !1015, line: 681, type: !1223, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1223 = !DISubroutineType(types: !1224)
!1224 = !{!7, !515, !764}
!1225 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1226, file: !994, line: 181)
!1226 = !DISubprogram(name: "wscanf", scope: !1015, file: !1015, line: 628, type: !1227, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1227 = !DISubroutineType(types: !1228)
!1228 = !{!7, !515, null}
!1229 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1230, file: !994, line: 185)
!1230 = !DISubprogram(name: "putwchar", scope: !1015, file: !1015, line: 748, type: !1231, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1231 = !DISubroutineType(types: !1232)
!1232 = !{!919, !501}
!1233 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1234, file: !994, line: 186)
!1234 = !DISubprogram(name: "vwprintf", scope: !1015, file: !1015, line: 606, type: !1223, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1235 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1236, file: !994, line: 187)
!1236 = !DISubprogram(name: "wprintf", scope: !1015, file: !1015, line: 587, type: !1227, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1237 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1238, file: !1241, line: 57)
!1238 = !DIDerivedType(tag: DW_TAG_typedef, name: "clock_t", file: !1239, line: 7, baseType: !1240)
!1239 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/clock_t.h", directory: "")
!1240 = !DIDerivedType(tag: DW_TAG_typedef, name: "__clock_t", file: !15, line: 144, baseType: !26)
!1241 = !DIFile(filename: "build_tool/../usr/include/c++/v1/ctime", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!1242 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !29, file: !1241, line: 58)
!1243 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1244, file: !1241, line: 59)
!1244 = !DIDerivedType(tag: DW_TAG_typedef, name: "time_t", file: !1245, line: 7, baseType: !1246)
!1245 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/time_t.h", directory: "")
!1246 = !DIDerivedType(tag: DW_TAG_typedef, name: "__time_t", file: !15, line: 148, baseType: !26)
!1247 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !997, file: !1241, line: 60)
!1248 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1249, file: !1241, line: 64)
!1249 = !DISubprogram(name: "clock", scope: !1250, file: !1250, line: 72, type: !1251, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1250 = !DIFile(filename: "/usr/include/time.h", directory: "")
!1251 = !DISubroutineType(types: !1252)
!1252 = !{!1238}
!1253 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1254, file: !1241, line: 65)
!1254 = !DISubprogram(name: "difftime", scope: !1250, file: !1250, line: 78, type: !1255, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1255 = !DISubroutineType(types: !1256)
!1256 = !{!6, !1244, !1244}
!1257 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1258, file: !1241, line: 66)
!1258 = !DISubprogram(name: "mktime", scope: !1250, file: !1250, line: 82, type: !1259, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1259 = !DISubroutineType(types: !1260)
!1260 = !{!1244, !1261}
!1261 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !997, size: 64)
!1262 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1263, file: !1241, line: 67)
!1263 = !DISubprogram(name: "time", scope: !1250, file: !1250, line: 75, type: !1264, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1264 = !DISubroutineType(types: !1265)
!1265 = !{!1244, !1266}
!1266 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1244, size: 64)
!1267 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1268, file: !1241, line: 69)
!1268 = !DISubprogram(name: "asctime", scope: !1250, file: !1250, line: 139, type: !1269, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1269 = !DISubroutineType(types: !1270)
!1270 = !{!9, !1177}
!1271 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1272, file: !1241, line: 70)
!1272 = !DISubprogram(name: "ctime", scope: !1250, file: !1250, line: 142, type: !1273, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1273 = !DISubroutineType(types: !1274)
!1274 = !{!9, !1275}
!1275 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1276, size: 64)
!1276 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !1244)
!1277 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1278, file: !1241, line: 71)
!1278 = !DISubprogram(name: "gmtime", scope: !1250, file: !1250, line: 119, type: !1279, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1279 = !DISubroutineType(types: !1280)
!1280 = !{!1261, !1275}
!1281 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1282, file: !1241, line: 72)
!1282 = !DISubprogram(name: "localtime", scope: !1250, file: !1250, line: 123, type: !1279, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1283 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1284, file: !1241, line: 74)
!1284 = !DISubprogram(name: "strftime", scope: !1250, file: !1250, line: 88, type: !1285, flags: DIFlagPrototyped, spFlags: DISPFlagOptimized)
!1285 = !DISubroutineType(types: !1286)
!1286 = !{!29, !514, !29, !383, !1176}
!1287 = !DIImportedEntity(tag: DW_TAG_imported_module, scope: !1288, entity: !1289, file: !1291, line: 2807)
!1288 = !DINamespace(name: "chrono", scope: !22)
!1289 = !DINamespace(name: "chrono_literals", scope: !1290, exportSymbols: true)
!1290 = !DINamespace(name: "literals", scope: !22, exportSymbols: true)
!1291 = !DIFile(filename: "build_tool/../usr/include/c++/v1/chrono", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!1292 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !22, entity: !1293, file: !1298, line: 43)
!1293 = !DIDerivedType(tag: DW_TAG_typedef, name: "va_list", file: !721, line: 46, baseType: !1294)
!1294 = !DIDerivedType(tag: DW_TAG_typedef, name: "__gnuc_va_list", file: !1295, line: 32, baseType: !1296)
!1295 = !DIFile(filename: "clang_llvm/llvm-9.0/build-9.0/lib/clang/9.0.0/include/stdarg.h", directory: "/home/mcopik/projects")
!1296 = !DIDerivedType(tag: DW_TAG_typedef, name: "__builtin_va_list", file: !3, baseType: !1297)
!1297 = !DICompositeType(tag: DW_TAG_array_type, baseType: !765, size: 192, elements: !701)
!1298 = !DIFile(filename: "build_tool/../usr/include/c++/v1/cstdarg", directory: "/home/mcopik/projects/ETH/extrap/rebuild")
!1299 = !{i32 2, !"Dwarf Version", i32 4}
!1300 = !{i32 2, !"Debug Info Version", i32 3}
!1301 = !{i32 1, !"wchar_size", i32 4}
!1302 = !{!"clang version 9.0.0 (tags/RELEASE_900/final)"}
!1303 = distinct !DISubprogram(name: "h", linkageName: "_Z1hi", scope: !3, file: !3, line: 12, type: !882, scopeLine: 13, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !1304)
!1304 = !{!1305, !1306, !1307}
!1305 = !DILocalVariable(name: "x", arg: 1, scope: !1303, file: !3, line: 12, type: !7)
!1306 = !DILocalVariable(name: "t", scope: !1303, file: !3, line: 14, type: !7)
!1307 = !DILocalVariable(name: "i", scope: !1308, file: !3, line: 15, type: !7)
!1308 = distinct !DILexicalBlock(scope: !1303, file: !3, line: 15, column: 5)
!1309 = !{!1310, !1310, i64 0}
!1310 = !{!"int", !1311, i64 0}
!1311 = !{!"omnipotent char", !1312, i64 0}
!1312 = !{!"Simple C++ TBAA"}
!1313 = !DILocation(line: 12, column: 11, scope: !1303)
!1314 = !DILocation(line: 14, column: 5, scope: !1303)
!1315 = !DILocation(line: 14, column: 9, scope: !1303)
!1316 = !DILocation(line: 15, column: 9, scope: !1308)
!1317 = !DILocation(line: 15, column: 13, scope: !1308)
!1318 = !DILocation(line: 15, column: 20, scope: !1319)
!1319 = distinct !DILexicalBlock(scope: !1308, file: !3, line: 15, column: 5)
!1320 = !DILocation(line: 15, column: 27, scope: !1319)
!1321 = !DILocation(line: 15, column: 26, scope: !1319)
!1322 = !DILocation(line: 15, column: 29, scope: !1319)
!1323 = !DILocation(line: 15, column: 22, scope: !1319)
!1324 = !DILocation(line: 15, column: 5, scope: !1308)
!1325 = !DILocation(line: 15, column: 5, scope: !1319)
!1326 = !DILocation(line: 16, column: 14, scope: !1319)
!1327 = !DILocation(line: 16, column: 11, scope: !1319)
!1328 = !DILocation(line: 16, column: 9, scope: !1319)
!1329 = !DILocation(line: 15, column: 35, scope: !1319)
!1330 = distinct !{!1330, !1324, !1331}
!1331 = !DILocation(line: 16, column: 14, scope: !1308)
!1332 = !DILocation(line: 17, column: 14, scope: !1303)
!1333 = !DILocation(line: 17, column: 13, scope: !1303)
!1334 = !DILocation(line: 17, column: 23, scope: !1303)
!1335 = !DILocation(line: 17, column: 21, scope: !1303)
!1336 = !DILocation(line: 18, column: 1, scope: !1303)
!1337 = !DILocation(line: 17, column: 5, scope: !1303)
!1338 = distinct !DISubprogram(name: "g_prune", linkageName: "_Z7g_prunei", scope: !3, file: !3, line: 21, type: !882, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !1339)
!1339 = !{!1340}
!1340 = !DILocalVariable(name: "x", arg: 1, scope: !1338, file: !3, line: 21, type: !7)
!1341 = !DILocation(line: 21, column: 17, scope: !1338)
!1342 = !DILocation(line: 23, column: 12, scope: !1338)
!1343 = !DILocation(line: 23, column: 23, scope: !1338)
!1344 = !DILocation(line: 23, column: 44, scope: !1338)
!1345 = !DILocation(line: 23, column: 56, scope: !1338)
!1346 = !{!1347, !1347, i64 0}
!1347 = !{!"double", !1311, i64 0}
!1348 = !DILocation(line: 23, column: 47, scope: !1338)
!1349 = !DILocation(line: 23, column: 27, scope: !1338)
!1350 = !DILocation(line: 23, column: 25, scope: !1338)
!1351 = !DILocation(line: 23, column: 21, scope: !1338)
!1352 = !DILocation(line: 23, column: 19, scope: !1338)
!1353 = !DILocation(line: 23, column: 5, scope: !1338)
!1354 = distinct !DISubprogram(name: "g_not_prune", linkageName: "_Z11g_not_prunei", scope: !3, file: !3, line: 26, type: !882, scopeLine: 27, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !1355)
!1355 = !{!1356, !1357, !1358}
!1356 = !DILocalVariable(name: "x", arg: 1, scope: !1354, file: !3, line: 26, type: !7)
!1357 = !DILocalVariable(name: "tmp", scope: !1354, file: !3, line: 28, type: !7)
!1358 = !DILocalVariable(name: "i", scope: !1359, file: !3, line: 29, type: !7)
!1359 = distinct !DILexicalBlock(scope: !1354, file: !3, line: 29, column: 5)
!1360 = !DILocation(line: 26, column: 21, scope: !1354)
!1361 = !DILocation(line: 28, column: 5, scope: !1354)
!1362 = !DILocation(line: 28, column: 9, scope: !1354)
!1363 = !DILocation(line: 29, column: 9, scope: !1359)
!1364 = !DILocation(line: 29, column: 13, scope: !1359)
!1365 = !DILocation(line: 29, column: 20, scope: !1366)
!1366 = distinct !DILexicalBlock(scope: !1359, file: !3, line: 29, column: 5)
!1367 = !DILocation(line: 29, column: 24, scope: !1366)
!1368 = !DILocation(line: 29, column: 22, scope: !1366)
!1369 = !DILocation(line: 29, column: 5, scope: !1359)
!1370 = !DILocation(line: 29, column: 5, scope: !1366)
!1371 = !DILocation(line: 30, column: 16, scope: !1366)
!1372 = !DILocation(line: 30, column: 13, scope: !1366)
!1373 = !DILocation(line: 30, column: 9, scope: !1366)
!1374 = !DILocation(line: 29, column: 27, scope: !1366)
!1375 = distinct !{!1375, !1369, !1376}
!1376 = !DILocation(line: 30, column: 16, scope: !1359)
!1377 = !DILocation(line: 31, column: 8, scope: !1378)
!1378 = distinct !DILexicalBlock(scope: !1354, file: !3, line: 31, column: 8)
!1379 = !DILocation(line: 31, column: 16, scope: !1378)
!1380 = !DILocation(line: 31, column: 20, scope: !1378)
!1381 = !DILocation(line: 31, column: 8, scope: !1354)
!1382 = !DILocation(line: 32, column: 24, scope: !1378)
!1383 = !DILocation(line: 32, column: 22, scope: !1378)
!1384 = !DILocation(line: 32, column: 18, scope: !1378)
!1385 = !DILocation(line: 32, column: 47, scope: !1378)
!1386 = !DILocation(line: 32, column: 30, scope: !1378)
!1387 = !DILocation(line: 32, column: 28, scope: !1378)
!1388 = !DILocation(line: 32, column: 16, scope: !1378)
!1389 = !DILocation(line: 32, column: 9, scope: !1378)
!1390 = !DILocation(line: 34, column: 22, scope: !1378)
!1391 = !DILocation(line: 34, column: 21, scope: !1378)
!1392 = !DILocation(line: 34, column: 18, scope: !1378)
!1393 = !DILocation(line: 34, column: 48, scope: !1378)
!1394 = !DILocation(line: 34, column: 31, scope: !1378)
!1395 = !DILocation(line: 34, column: 29, scope: !1378)
!1396 = !DILocation(line: 34, column: 16, scope: !1378)
!1397 = !DILocation(line: 34, column: 9, scope: !1378)
!1398 = !DILocation(line: 35, column: 1, scope: !1354)
!1399 = distinct !DISubprogram(name: "f_prune", linkageName: "_Z7f_pruneii", scope: !3, file: !3, line: 37, type: !1400, scopeLine: 38, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !1402)
!1400 = !DISubroutineType(types: !1401)
!1401 = !{!7, !7, !7}
!1402 = !{!1403, !1404}
!1403 = !DILocalVariable(name: "x", arg: 1, scope: !1399, file: !3, line: 37, type: !7)
!1404 = !DILocalVariable(name: "y", arg: 2, scope: !1399, file: !3, line: 37, type: !7)
!1405 = !DILocation(line: 37, column: 17, scope: !1399)
!1406 = !DILocation(line: 37, column: 24, scope: !1399)
!1407 = !DILocation(line: 39, column: 13, scope: !1399)
!1408 = !DILocation(line: 39, column: 5, scope: !1399)
!1409 = !DILocation(line: 40, column: 17, scope: !1399)
!1410 = !DILocation(line: 40, column: 5, scope: !1399)
!1411 = !DILocation(line: 41, column: 14, scope: !1399)
!1412 = !DILocation(line: 41, column: 12, scope: !1399)
!1413 = !DILocation(line: 41, column: 5, scope: !1399)
!1414 = distinct !DISubprogram(name: "f_not_prune", linkageName: "_Z11f_not_pruneii", scope: !3, file: !3, line: 45, type: !1400, scopeLine: 46, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !1415)
!1415 = !{!1416, !1417, !1418, !1419}
!1416 = !DILocalVariable(name: "x", arg: 1, scope: !1414, file: !3, line: 45, type: !7)
!1417 = !DILocalVariable(name: "y", arg: 2, scope: !1414, file: !3, line: 45, type: !7)
!1418 = !DILocalVariable(name: "tmp", scope: !1414, file: !3, line: 47, type: !7)
!1419 = !DILocalVariable(name: "i", scope: !1420, file: !3, line: 48, type: !7)
!1420 = distinct !DILexicalBlock(scope: !1414, file: !3, line: 48, column: 5)
!1421 = !DILocation(line: 45, column: 21, scope: !1414)
!1422 = !DILocation(line: 45, column: 28, scope: !1414)
!1423 = !DILocation(line: 47, column: 5, scope: !1414)
!1424 = !DILocation(line: 47, column: 9, scope: !1414)
!1425 = !DILocation(line: 48, column: 9, scope: !1420)
!1426 = !DILocation(line: 48, column: 13, scope: !1420)
!1427 = !DILocation(line: 48, column: 17, scope: !1420)
!1428 = !DILocation(line: 48, column: 20, scope: !1429)
!1429 = distinct !DILexicalBlock(scope: !1420, file: !3, line: 48, column: 5)
!1430 = !DILocation(line: 48, column: 22, scope: !1429)
!1431 = !DILocation(line: 48, column: 5, scope: !1420)
!1432 = !DILocation(line: 48, column: 5, scope: !1429)
!1433 = !DILocation(line: 49, column: 16, scope: !1429)
!1434 = !DILocation(line: 49, column: 13, scope: !1429)
!1435 = !DILocation(line: 49, column: 9, scope: !1429)
!1436 = !DILocation(line: 48, column: 28, scope: !1429)
!1437 = distinct !{!1437, !1431, !1438}
!1438 = !DILocation(line: 49, column: 16, scope: !1420)
!1439 = !DILocation(line: 50, column: 13, scope: !1414)
!1440 = !DILocation(line: 50, column: 5, scope: !1414)
!1441 = !DILocation(line: 51, column: 17, scope: !1414)
!1442 = !DILocation(line: 51, column: 5, scope: !1414)
!1443 = !DILocation(line: 52, column: 14, scope: !1414)
!1444 = !DILocation(line: 52, column: 20, scope: !1414)
!1445 = !DILocation(line: 52, column: 18, scope: !1414)
!1446 = !DILocation(line: 52, column: 12, scope: !1414)
!1447 = !DILocation(line: 53, column: 1, scope: !1414)
!1448 = !DILocation(line: 52, column: 5, scope: !1414)
!1449 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 55, type: !1450, scopeLine: 56, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, retainedNodes: !1452)
!1450 = !DISubroutineType(types: !1451)
!1451 = !{!7, !7, !8}
!1452 = !{!1453, !1454, !1455, !1456}
!1453 = !DILocalVariable(name: "argc", arg: 1, scope: !1449, file: !3, line: 55, type: !7)
!1454 = !DILocalVariable(name: "argv", arg: 2, scope: !1449, file: !3, line: 55, type: !8)
!1455 = !DILocalVariable(name: "x1", scope: !1449, file: !3, line: 57, type: !7)
!1456 = !DILocalVariable(name: "x2", scope: !1449, file: !3, line: 58, type: !7)
!1457 = !DILocation(line: 55, column: 14, scope: !1449)
!1458 = !{!1459, !1459, i64 0}
!1459 = !{!"any pointer", !1311, i64 0}
!1460 = !DILocation(line: 55, column: 28, scope: !1449)
!1461 = !DILocation(line: 57, column: 5, scope: !1449)
!1462 = !DILocation(line: 57, column: 9, scope: !1449)
!1463 = !DILocation(line: 57, column: 26, scope: !1449)
!1464 = !DILocation(line: 57, column: 21, scope: !1449)
!1465 = !DILocation(line: 58, column: 5, scope: !1449)
!1466 = !DILocation(line: 58, column: 9, scope: !1449)
!1467 = !DILocation(line: 59, column: 14, scope: !1449)
!1468 = !DILocation(line: 60, column: 5, scope: !1449)
!1469 = !DILocation(line: 61, column: 5, scope: !1449)
!1470 = !DILocation(line: 62, column: 5, scope: !1449)
!1471 = !DILocation(line: 63, column: 5, scope: !1449)
!1472 = !DILocation(line: 65, column: 5, scope: !1449)
!1473 = !DILocation(line: 66, column: 5, scope: !1449)
!1474 = !DILocation(line: 68, column: 13, scope: !1449)
!1475 = !DILocation(line: 68, column: 19, scope: !1449)
!1476 = !DILocation(line: 68, column: 18, scope: !1449)
!1477 = !DILocation(line: 68, column: 24, scope: !1449)
!1478 = !DILocation(line: 68, column: 22, scope: !1449)
!1479 = !DILocation(line: 68, column: 27, scope: !1449)
!1480 = !DILocation(line: 68, column: 5, scope: !1449)
!1481 = !DILocation(line: 69, column: 17, scope: !1449)
!1482 = !DILocation(line: 69, column: 23, scope: !1449)
!1483 = !DILocation(line: 69, column: 22, scope: !1449)
!1484 = !DILocation(line: 69, column: 28, scope: !1449)
!1485 = !DILocation(line: 69, column: 26, scope: !1449)
!1486 = !DILocation(line: 69, column: 31, scope: !1449)
!1487 = !DILocation(line: 69, column: 5, scope: !1449)
!1488 = !DILocation(line: 72, column: 1, scope: !1449)
!1489 = !DILocation(line: 71, column: 5, scope: !1449)
!1490 = !DILocation(line: 361, column: 1, scope: !366)
!1491 = !DILocation(line: 363, column: 24, scope: !366)
!1492 = !DILocation(line: 363, column: 16, scope: !366)
!1493 = !DILocation(line: 363, column: 3, scope: !366)
!1494 = distinct !DISubprogram(name: "register_variable<int>", linkageName: "_Z17register_variableIiEvPT_PKc", scope: !1495, file: !1495, line: 15, type: !1496, scopeLine: 16, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, templateParams: !1501, retainedNodes: !1498)
!1495 = !DIFile(filename: "include/ExtraPInstrumenter.hpp", directory: "/home/mcopik/projects/ETH/extrap/rebuild/perf-taint")
!1496 = !DISubroutineType(types: !1497)
!1497 = !{null, !86, !176}
!1498 = !{!1499, !1500}
!1499 = !DILocalVariable(name: "ptr", arg: 1, scope: !1494, file: !1495, line: 15, type: !86)
!1500 = !DILocalVariable(name: "name", arg: 2, scope: !1494, file: !1495, line: 15, type: !176)
!1501 = !{!1502}
!1502 = !DITemplateTypeParameter(name: "T", type: !7)
!1503 = !DILocation(line: 15, column: 28, scope: !1494)
!1504 = !DILocation(line: 15, column: 46, scope: !1494)
!1505 = !DILocation(line: 20, column: 55, scope: !1494)
!1506 = !DILocation(line: 20, column: 29, scope: !1494)
!1507 = !DILocation(line: 20, column: 72, scope: !1494)
!1508 = !DILocation(line: 20, column: 3, scope: !1494)
!1509 = !DILocation(line: 21, column: 1, scope: !1494)
!1510 = distinct !DISubprogram(name: "register_variable<double>", linkageName: "_Z17register_variableIdEvPT_PKc", scope: !1495, file: !1495, line: 15, type: !1511, scopeLine: 16, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !2, templateParams: !1517, retainedNodes: !1514)
!1511 = !DISubroutineType(types: !1512)
!1512 = !{null, !1513, !176}
!1513 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !6, size: 64)
!1514 = !{!1515, !1516}
!1515 = !DILocalVariable(name: "ptr", arg: 1, scope: !1510, file: !1495, line: 15, type: !1513)
!1516 = !DILocalVariable(name: "name", arg: 2, scope: !1510, file: !1495, line: 15, type: !176)
!1517 = !{!1518}
!1518 = !DITemplateTypeParameter(name: "T", type: !6)
!1519 = !DILocation(line: 15, column: 28, scope: !1510)
!1520 = !DILocation(line: 15, column: 46, scope: !1510)
!1521 = !DILocation(line: 20, column: 55, scope: !1510)
!1522 = !DILocation(line: 20, column: 29, scope: !1510)
!1523 = !DILocation(line: 20, column: 72, scope: !1510)
!1524 = !DILocation(line: 20, column: 3, scope: !1510)
!1525 = !DILocation(line: 21, column: 1, scope: !1510)
