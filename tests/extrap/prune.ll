; RUN: opt %loadpass  -o /dev/null < %s 2> /dev/null | diff -w %s.json -
; ModuleID = 'tests/extrap/prune.cpp'
source_filename = "tests/extrap/prune.cpp"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%"class.std::basic_ifstream" = type { %"class.std::basic_istream.base", %"class.std::basic_filebuf", %"class.std::basic_ios" }
%"class.std::basic_istream.base" = type { i32 (...)**, i64 }
%"class.std::basic_filebuf" = type { %"class.std::basic_streambuf", %union.pthread_mutex_t, %"class.std::__basic_file", i32, %struct.__mbstate_t, %struct.__mbstate_t, %struct.__mbstate_t, i8*, i64, i8, i8, i8, i8, i8*, i8*, i8, %"class.std::codecvt"*, i8*, i64, i8*, i8* }
%"class.std::basic_streambuf" = type { i32 (...)**, i8*, i8*, i8*, i8*, i8*, i8*, %"class.std::locale" }
%"class.std::locale" = type { %"class.std::locale::_Impl"* }
%"class.std::locale::_Impl" = type { i32, %"class.std::locale::facet"**, i64, %"class.std::locale::facet"**, i8** }
%"class.std::locale::facet" = type <{ i32 (...)**, i32, [4 x i8] }>
%union.pthread_mutex_t = type { %struct.__pthread_mutex_s }
%struct.__pthread_mutex_s = type { i32, i32, i32, i32, i32, i16, i16, %struct.__pthread_internal_list }
%struct.__pthread_internal_list = type { %struct.__pthread_internal_list*, %struct.__pthread_internal_list* }
%"class.std::__basic_file" = type <{ %struct._IO_FILE*, i8, [7 x i8] }>
%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, i8*, i8*, i8*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type { %struct._IO_marker*, %struct._IO_FILE*, i32 }
%struct.__mbstate_t = type { i32, %union.anon }
%union.anon = type { i32 }
%"class.std::codecvt" = type { %"class.std::__codecvt_abstract_base.base", %struct.__locale_struct* }
%"class.std::__codecvt_abstract_base.base" = type { %"class.std::locale::facet.base" }
%"class.std::locale::facet.base" = type <{ i32 (...)**, i32 }>
%struct.__locale_struct = type { [13 x %struct.__locale_data*], i16*, i32*, i32*, [13 x i8*] }
%struct.__locale_data = type opaque
%"class.std::basic_ios" = type { %"class.std::ios_base", %"class.std::basic_ostream"*, i8, i8, %"class.std::basic_streambuf"*, %"class.std::ctype"*, %"class.std::num_put"*, %"class.std::num_get"* }
%"class.std::ios_base" = type { i32 (...)**, i64, i64, i32, i32, i32, %"struct.std::ios_base::_Callback_list"*, %"struct.std::ios_base::_Words", [8 x %"struct.std::ios_base::_Words"], i32, %"struct.std::ios_base::_Words"*, %"class.std::locale" }
%"struct.std::ios_base::_Callback_list" = type { %"struct.std::ios_base::_Callback_list"*, void (i32, %"class.std::ios_base"*, i32)*, i32, i32 }
%"struct.std::ios_base::_Words" = type { i8*, i64 }
%"class.std::basic_ostream" = type { i32 (...)**, %"class.std::basic_ios" }
%"class.std::ctype" = type <{ %"class.std::locale::facet.base", [4 x i8], %struct.__locale_struct*, i8, [7 x i8], i32*, i32*, i16*, i8, [256 x i8], [256 x i8], i8, [6 x i8] }>
%"class.std::num_put" = type { %"class.std::locale::facet.base", [4 x i8] }
%"class.std::num_get" = type { %"class.std::locale::facet.base", [4 x i8] }
%"class.std::basic_istream" = type { i32 (...)**, i64, %"class.std::basic_ios" }

@global = dso_local global i32 100, align 4, !dbg !0
@.str = private unnamed_addr constant [7 x i8] c"extrap\00", section "llvm.metadata"
@.str.1 = private unnamed_addr constant [23 x i8] c"tests/extrap/prune.cpp\00", section "llvm.metadata"
@global2 = dso_local global double 3.140000e+00, align 8, !dbg !18
@_ZTVSt14basic_ifstreamIcSt11char_traitsIcEE = external dso_local unnamed_addr constant { [5 x i8*], [5 x i8*] }, align 8
@_ZTTSt14basic_ifstreamIcSt11char_traitsIcEE = external unnamed_addr constant [4 x i8*], align 8
@_ZTVSt9basic_iosIcSt11char_traitsIcEE = external dso_local unnamed_addr constant { [4 x i8*] }, align 8
@_ZTVSt13basic_filebufIcSt11char_traitsIcEE = external dso_local unnamed_addr constant { [16 x i8*] }, align 8
@_ZTVSt15basic_streambufIcSt11char_traitsIcEE = external dso_local unnamed_addr constant { [16 x i8*] }, align 8
@llvm.global.annotations = appending global [2 x { i8*, i8*, i8*, i32 }] [{ i8*, i8*, i8*, i32 } { i8* bitcast (i32* @global to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str.1, i32 0, i32 0), i32 8 }, { i8*, i8*, i8*, i32 } { i8* bitcast (double* @global2 to i8*), i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str.1, i32 0, i32 0), i32 9 }], section "llvm.metadata"

; Function Attrs: nounwind uwtable
define dso_local i32 @_Z1hi(i32) #0 !dbg !1281 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4, !tbaa !1284
  call void @llvm.dbg.declare(metadata i32* %2, metadata !1283, metadata !DIExpression()), !dbg !1288
  %3 = load i32, i32* %2, align 4, !dbg !1289, !tbaa !1284
  %4 = mul nsw i32 2, %3, !dbg !1290
  %5 = load i32, i32* @global, align 4, !dbg !1291, !tbaa !1284
  %6 = mul nsw i32 %4, %5, !dbg !1292
  ret i32 %6, !dbg !1293
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind uwtable
define dso_local i32 @_Z7g_prunei(i32) #0 !dbg !1294 {
  %2 = alloca i32, align 4
  store i32 %0, i32* %2, align 4, !tbaa !1284
  call void @llvm.dbg.declare(metadata i32* %2, metadata !1296, metadata !DIExpression()), !dbg !1297
  %3 = load i32, i32* @global, align 4, !dbg !1298, !tbaa !1284
  %4 = load i32, i32* %2, align 4, !dbg !1299, !tbaa !1284
  %5 = sitofp i32 %4 to double, !dbg !1299
  %6 = load i32, i32* %2, align 4, !dbg !1300, !tbaa !1284
  %7 = sitofp i32 %6 to double, !dbg !1300
  %8 = load double, double* @global2, align 8, !dbg !1301, !tbaa !1302
  %9 = call double @exp(double %8) #6, !dbg !1304
  %10 = call double @pow(double %7, double %9) #6, !dbg !1305
  %11 = fadd double %5, %10, !dbg !1306
  %12 = fptosi double %11 to i32, !dbg !1299
  %13 = call i32 @_Z1hi(i32 %12), !dbg !1307
  %14 = mul nsw i32 %3, %13, !dbg !1308
  ret i32 %14, !dbg !1309
}

; Function Attrs: nounwind
declare dso_local double @pow(double, double) #2

; Function Attrs: nounwind
declare dso_local double @exp(double) #2

; Function Attrs: nounwind uwtable
define dso_local i32 @_Z11g_not_prunei(i32) #0 !dbg !1310 {
  %2 = alloca i32, align 4
  %3 = alloca i32, align 4
  store i32 %0, i32* %3, align 4, !tbaa !1284
  call void @llvm.dbg.declare(metadata i32* %3, metadata !1312, metadata !DIExpression()), !dbg !1313
  %4 = load double, double* @global2, align 8, !dbg !1314, !tbaa !1302
  %5 = fadd double %4, 1.000000e+00, !dbg !1316
  %6 = fcmp olt double %5, 0.000000e+00, !dbg !1317
  br i1 %6, label %7, label %17, !dbg !1318

; <label>:7:                                      ; preds = %1
  %8 = load i32, i32* %3, align 4, !dbg !1319, !tbaa !1284
  %9 = add nsw i32 100, %8, !dbg !1320
  %10 = sitofp i32 %9 to double, !dbg !1321
  %11 = load i32, i32* @global, align 4, !dbg !1322, !tbaa !1284
  %12 = sitofp i32 %11 to double, !dbg !1322
  %13 = call double @pow(double %12, double 3.000000e+00) #6, !dbg !1323
  %14 = fadd double %10, %13, !dbg !1324
  %15 = fptosi double %14 to i32, !dbg !1321
  %16 = call i32 @_Z1hi(i32 %15), !dbg !1325
  store i32 %16, i32* %2, align 4, !dbg !1326
  br label %27, !dbg !1326

; <label>:17:                                     ; preds = %1
  %18 = load i32, i32* @global, align 4, !dbg !1327, !tbaa !1284
  %19 = mul nsw i32 200, %18, !dbg !1328
  %20 = sitofp i32 %19 to double, !dbg !1329
  %21 = load i32, i32* %3, align 4, !dbg !1330, !tbaa !1284
  %22 = sitofp i32 %21 to double, !dbg !1330
  %23 = call double @pow(double %22, double 3.000000e+00) #6, !dbg !1331
  %24 = fadd double %20, %23, !dbg !1332
  %25 = fptosi double %24 to i32, !dbg !1329
  %26 = call i32 @_Z1hi(i32 %25), !dbg !1333
  store i32 %26, i32* %2, align 4, !dbg !1334
  br label %27, !dbg !1334

; <label>:27:                                     ; preds = %17, %7
  %28 = load i32, i32* %2, align 4, !dbg !1335
  ret i32 %28, !dbg !1335
}

; Function Attrs: nounwind uwtable
define dso_local i32 @_Z7f_pruneii(i32, i32) #0 !dbg !1336 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  store i32 %0, i32* %3, align 4, !tbaa !1284
  call void @llvm.dbg.declare(metadata i32* %3, metadata !1340, metadata !DIExpression()), !dbg !1342
  store i32 %1, i32* %4, align 4, !tbaa !1284
  call void @llvm.dbg.declare(metadata i32* %4, metadata !1341, metadata !DIExpression()), !dbg !1343
  %5 = load i32, i32* %3, align 4, !dbg !1344, !tbaa !1284
  %6 = call i32 @_Z7g_prunei(i32 %5), !dbg !1345
  %7 = load i32, i32* %4, align 4, !dbg !1346, !tbaa !1284
  %8 = call i32 @_Z11g_not_prunei(i32 %7), !dbg !1347
  %9 = load i32, i32* %4, align 4, !dbg !1348, !tbaa !1284
  %10 = call i32 @_Z1hi(i32 %9), !dbg !1349
  ret i32 %10, !dbg !1350
}

; Function Attrs: nounwind uwtable
define dso_local i32 @_Z11f_not_pruneii(i32, i32) #0 !dbg !1351 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store i32 %0, i32* %3, align 4, !tbaa !1284
  call void @llvm.dbg.declare(metadata i32* %3, metadata !1353, metadata !DIExpression()), !dbg !1356
  store i32 %1, i32* %4, align 4, !tbaa !1284
  call void @llvm.dbg.declare(metadata i32* %4, metadata !1354, metadata !DIExpression()), !dbg !1357
  %6 = bitcast i32* %5 to i8*, !dbg !1358
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %6) #6, !dbg !1358
  call void @llvm.dbg.declare(metadata i32* %5, metadata !1355, metadata !DIExpression()), !dbg !1359
  %7 = load i32, i32* %3, align 4, !dbg !1360, !tbaa !1284
  %8 = load i32, i32* %4, align 4, !dbg !1361, !tbaa !1284
  %9 = mul nsw i32 2, %8, !dbg !1362
  %10 = add nsw i32 %7, %9, !dbg !1363
  store i32 %10, i32* %5, align 4, !dbg !1359, !tbaa !1284
  %11 = load i32, i32* %3, align 4, !dbg !1364, !tbaa !1284
  %12 = call i32 @_Z7g_prunei(i32 %11), !dbg !1365
  %13 = load i32, i32* %4, align 4, !dbg !1366, !tbaa !1284
  %14 = call i32 @_Z11g_not_prunei(i32 %13), !dbg !1367
  %15 = load i32, i32* %5, align 4, !dbg !1368, !tbaa !1284
  %16 = load i32, i32* %4, align 4, !dbg !1369, !tbaa !1284
  %17 = call i32 @_Z1hi(i32 %16), !dbg !1370
  %18 = add nsw i32 %15, %17, !dbg !1371
  %19 = bitcast i32* %5 to i8*, !dbg !1372
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %19) #6, !dbg !1372
  ret i32 %18, !dbg !1373
}

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) #3

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) #3

; Function Attrs: norecurse uwtable
define dso_local i32 @main(i32, i8**) #4 personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) !dbg !1374 {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca i8**, align 8
  %6 = alloca %"class.std::basic_ifstream", align 8
  %7 = alloca i32, align 4
  %8 = alloca i32, align 4
  %9 = alloca i8*
  %10 = alloca i32
  store i32 0, i32* %3, align 4
  store i32 %0, i32* %4, align 4, !tbaa !1284
  call void @llvm.dbg.declare(metadata i32* %4, metadata !1378, metadata !DIExpression()), !dbg !1387
  store i8** %1, i8*** %5, align 8, !tbaa !1388
  call void @llvm.dbg.declare(metadata i8*** %5, metadata !1379, metadata !DIExpression()), !dbg !1390
  %11 = bitcast %"class.std::basic_ifstream"* %6 to i8*, !dbg !1391
  call void @llvm.lifetime.start.p0i8(i64 520, i8* %11) #6, !dbg !1391
  call void @llvm.dbg.declare(metadata %"class.std::basic_ifstream"* %6, metadata !1380, metadata !DIExpression()), !dbg !1392
  call void @_ZNSt14basic_ifstreamIcSt11char_traitsIcEEC1Ev(%"class.std::basic_ifstream"* %6), !dbg !1392
  %12 = bitcast i32* %7 to i8*, !dbg !1393
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %12) #6, !dbg !1393
  call void @llvm.dbg.declare(metadata i32* %7, metadata !1385, metadata !DIExpression()), !dbg !1394
  %13 = bitcast i32* %7 to i8*, !dbg !1393
  call void @llvm.var.annotation(i8* %13, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str.1, i32 0, i32 0), i32 56), !dbg !1393
  %14 = load i8**, i8*** %5, align 8, !dbg !1395, !tbaa !1388
  %15 = getelementptr inbounds i8*, i8** %14, i64 1, !dbg !1395
  %16 = load i8*, i8** %15, align 8, !dbg !1395, !tbaa !1388
  %17 = call i32 @atoi(i8* %16) #9, !dbg !1396
  store i32 %17, i32* %7, align 4, !dbg !1394, !tbaa !1284
  %18 = bitcast i32* %8 to i8*, !dbg !1397
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %18) #6, !dbg !1397
  call void @llvm.dbg.declare(metadata i32* %8, metadata !1386, metadata !DIExpression()), !dbg !1398
  %19 = bitcast i32* %8 to i8*, !dbg !1397
  call void @llvm.var.annotation(i8* %19, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str, i32 0, i32 0), i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str.1, i32 0, i32 0), i32 57), !dbg !1397
  %20 = bitcast %"class.std::basic_ifstream"* %6 to %"class.std::basic_istream"*, !dbg !1399
  %21 = invoke dereferenceable(280) %"class.std::basic_istream"* @_ZNSirsERi(%"class.std::basic_istream"* %20, i32* dereferenceable(4) %8)
          to label %22 unwind label %31, !dbg !1400

; <label>:22:                                     ; preds = %2
  %23 = invoke i32 @_Z7f_pruneii(i32 1, i32 2)
          to label %24 unwind label %31, !dbg !1401

; <label>:24:                                     ; preds = %22
  %25 = invoke i32 @_Z11f_not_pruneii(i32 1, i32 2)
          to label %26 unwind label %31, !dbg !1402

; <label>:26:                                     ; preds = %24
  store i32 0, i32* %3, align 4, !dbg !1403
  %27 = bitcast i32* %8 to i8*, !dbg !1404
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %27) #6, !dbg !1404
  %28 = bitcast i32* %7 to i8*, !dbg !1404
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %28) #6, !dbg !1404
  call void @_ZNSt14basic_ifstreamIcSt11char_traitsIcEED1Ev(%"class.std::basic_ifstream"* %6) #6, !dbg !1404
  %29 = bitcast %"class.std::basic_ifstream"* %6 to i8*, !dbg !1404
  call void @llvm.lifetime.end.p0i8(i64 520, i8* %29) #6, !dbg !1404
  %30 = load i32, i32* %3, align 4, !dbg !1404
  ret i32 %30, !dbg !1404

; <label>:31:                                     ; preds = %24, %22, %2
  %32 = landingpad { i8*, i32 }
          cleanup, !dbg !1404
  %33 = extractvalue { i8*, i32 } %32, 0, !dbg !1404
  store i8* %33, i8** %9, align 8, !dbg !1404
  %34 = extractvalue { i8*, i32 } %32, 1, !dbg !1404
  store i32 %34, i32* %10, align 4, !dbg !1404
  %35 = bitcast i32* %8 to i8*, !dbg !1404
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %35) #6, !dbg !1404
  %36 = bitcast i32* %7 to i8*, !dbg !1404
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %36) #6, !dbg !1404
  call void @_ZNSt14basic_ifstreamIcSt11char_traitsIcEED1Ev(%"class.std::basic_ifstream"* %6) #6, !dbg !1404
  %37 = bitcast %"class.std::basic_ifstream"* %6 to i8*, !dbg !1404
  call void @llvm.lifetime.end.p0i8(i64 520, i8* %37) #6, !dbg !1404
  br label %38, !dbg !1404

; <label>:38:                                     ; preds = %31
  %39 = load i8*, i8** %9, align 8, !dbg !1404
  %40 = load i32, i32* %10, align 4, !dbg !1404
  %41 = insertvalue { i8*, i32 } undef, i8* %39, 0, !dbg !1404
  %42 = insertvalue { i8*, i32 } %41, i32 %40, 1, !dbg !1404
  resume { i8*, i32 } %42, !dbg !1404
}

; Function Attrs: uwtable
define available_externally dso_local void @_ZNSt14basic_ifstreamIcSt11char_traitsIcEEC1Ev(%"class.std::basic_ifstream"*) unnamed_addr #5 align 2 personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) !dbg !1405 {
  %2 = alloca %"class.std::basic_ifstream"*, align 8
  %3 = alloca i8*
  %4 = alloca i32
  store %"class.std::basic_ifstream"* %0, %"class.std::basic_ifstream"** %2, align 8, !tbaa !1388
  call void @llvm.dbg.declare(metadata %"class.std::basic_ifstream"** %2, metadata !1412, metadata !DIExpression()), !dbg !1414
  %5 = load %"class.std::basic_ifstream"*, %"class.std::basic_ifstream"** %2, align 8
  %6 = bitcast %"class.std::basic_ifstream"* %5 to i8*, !dbg !1415
  %7 = getelementptr inbounds i8, i8* %6, i64 256, !dbg !1415
  %8 = bitcast i8* %7 to %"class.std::basic_ios"*, !dbg !1415
  call void @_ZNSt9basic_iosIcSt11char_traitsIcEEC2Ev(%"class.std::basic_ios"* %8), !dbg !1416
  %9 = bitcast %"class.std::basic_ifstream"* %5 to %"class.std::basic_istream"*, !dbg !1415
  invoke void @_ZNSiC2Ev(%"class.std::basic_istream"* %9, i8** getelementptr inbounds ([4 x i8*], [4 x i8*]* @_ZTTSt14basic_ifstreamIcSt11char_traitsIcEE, i64 0, i64 1))
          to label %10 unwind label %28, !dbg !1417

; <label>:10:                                     ; preds = %1
  %11 = bitcast %"class.std::basic_ifstream"* %5 to i32 (...)***, !dbg !1415
  store i32 (...)** bitcast (i8** getelementptr inbounds ({ [5 x i8*], [5 x i8*] }, { [5 x i8*], [5 x i8*] }* @_ZTVSt14basic_ifstreamIcSt11char_traitsIcEE, i32 0, inrange i32 0, i32 3) to i32 (...)**), i32 (...)*** %11, align 8, !dbg !1415, !tbaa !1418
  %12 = bitcast %"class.std::basic_ifstream"* %5 to i8*, !dbg !1415
  %13 = getelementptr inbounds i8, i8* %12, i64 256, !dbg !1415
  %14 = bitcast i8* %13 to i32 (...)***, !dbg !1415
  store i32 (...)** bitcast (i8** getelementptr inbounds ({ [5 x i8*], [5 x i8*] }, { [5 x i8*], [5 x i8*] }* @_ZTVSt14basic_ifstreamIcSt11char_traitsIcEE, i32 0, inrange i32 1, i32 3) to i32 (...)**), i32 (...)*** %14, align 8, !dbg !1415, !tbaa !1418
  %15 = getelementptr inbounds %"class.std::basic_ifstream", %"class.std::basic_ifstream"* %5, i32 0, i32 1, !dbg !1420
  invoke void @_ZNSt13basic_filebufIcSt11char_traitsIcEEC1Ev(%"class.std::basic_filebuf"* %15)
          to label %16 unwind label %32, !dbg !1420

; <label>:16:                                     ; preds = %10
  %17 = bitcast %"class.std::basic_ifstream"* %5 to i8**, !dbg !1421
  %18 = load i8*, i8** %17, align 8, !dbg !1421, !tbaa !1418
  %19 = getelementptr i8, i8* %18, i64 -24, !dbg !1421
  %20 = bitcast i8* %19 to i64*, !dbg !1421
  %21 = load i64, i64* %20, align 8, !dbg !1421
  %22 = bitcast %"class.std::basic_ifstream"* %5 to i8*, !dbg !1421
  %23 = getelementptr inbounds i8, i8* %22, i64 %21, !dbg !1421
  %24 = bitcast i8* %23 to %"class.std::basic_ios"*, !dbg !1421
  %25 = getelementptr inbounds %"class.std::basic_ifstream", %"class.std::basic_ifstream"* %5, i32 0, i32 1, !dbg !1423
  %26 = bitcast %"class.std::basic_filebuf"* %25 to %"class.std::basic_streambuf"*, !dbg !1424
  invoke void @_ZNSt9basic_iosIcSt11char_traitsIcEE4initEPSt15basic_streambufIcS1_E(%"class.std::basic_ios"* %24, %"class.std::basic_streambuf"* %26)
          to label %27 unwind label %36, !dbg !1421

; <label>:27:                                     ; preds = %16
  ret void, !dbg !1425

; <label>:28:                                     ; preds = %1
  %29 = landingpad { i8*, i32 }
          cleanup, !dbg !1425
  %30 = extractvalue { i8*, i32 } %29, 0, !dbg !1425
  store i8* %30, i8** %3, align 8, !dbg !1425
  %31 = extractvalue { i8*, i32 } %29, 1, !dbg !1425
  store i32 %31, i32* %4, align 4, !dbg !1425
  br label %42, !dbg !1425

; <label>:32:                                     ; preds = %10
  %33 = landingpad { i8*, i32 }
          cleanup, !dbg !1425
  %34 = extractvalue { i8*, i32 } %33, 0, !dbg !1425
  store i8* %34, i8** %3, align 8, !dbg !1425
  %35 = extractvalue { i8*, i32 } %33, 1, !dbg !1425
  store i32 %35, i32* %4, align 4, !dbg !1425
  br label %40, !dbg !1425

; <label>:36:                                     ; preds = %16
  %37 = landingpad { i8*, i32 }
          cleanup, !dbg !1426
  %38 = extractvalue { i8*, i32 } %37, 0, !dbg !1426
  store i8* %38, i8** %3, align 8, !dbg !1426
  %39 = extractvalue { i8*, i32 } %37, 1, !dbg !1426
  store i32 %39, i32* %4, align 4, !dbg !1426
  call void @_ZNSt13basic_filebufIcSt11char_traitsIcEED2Ev(%"class.std::basic_filebuf"* %15) #6, !dbg !1426
  br label %40, !dbg !1426

; <label>:40:                                     ; preds = %36, %32
  %41 = bitcast %"class.std::basic_ifstream"* %5 to %"class.std::basic_istream"*, !dbg !1426
  call void @_ZNSiD2Ev(%"class.std::basic_istream"* %41, i8** getelementptr inbounds ([4 x i8*], [4 x i8*]* @_ZTTSt14basic_ifstreamIcSt11char_traitsIcEE, i64 0, i64 1)) #6, !dbg !1426
  br label %42, !dbg !1426

; <label>:42:                                     ; preds = %40, %28
  %43 = bitcast %"class.std::basic_ifstream"* %5 to i8*, !dbg !1426
  %44 = getelementptr inbounds i8, i8* %43, i64 256, !dbg !1426
  %45 = bitcast i8* %44 to %"class.std::basic_ios"*, !dbg !1426
  call void @_ZNSt9basic_iosIcSt11char_traitsIcEED2Ev(%"class.std::basic_ios"* %45) #6, !dbg !1426
  br label %46, !dbg !1426

; <label>:46:                                     ; preds = %42
  %47 = load i8*, i8** %3, align 8, !dbg !1426
  %48 = load i32, i32* %4, align 4, !dbg !1426
  %49 = insertvalue { i8*, i32 } undef, i8* %47, 0, !dbg !1426
  %50 = insertvalue { i8*, i32 } %49, i32 %48, 1, !dbg !1426
  resume { i8*, i32 } %50, !dbg !1426
}

; Function Attrs: nounwind
declare void @llvm.var.annotation(i8*, i8*, i8*, i32) #6

; Function Attrs: inlinehint nounwind readonly uwtable
define available_externally dso_local i32 @atoi(i8* nonnull) #7 !dbg !388 {
  %2 = alloca i8*, align 8
  store i8* %0, i8** %2, align 8, !tbaa !1388
  call void @llvm.dbg.declare(metadata i8** %2, metadata !392, metadata !DIExpression()), !dbg !1427
  %3 = load i8*, i8** %2, align 8, !dbg !1428, !tbaa !1388
  %4 = call i64 @strtol(i8* %3, i8** null, i32 10) #6, !dbg !1429
  %5 = trunc i64 %4 to i32, !dbg !1429
  ret i32 %5, !dbg !1430
}

declare dso_local dereferenceable(280) %"class.std::basic_istream"* @_ZNSirsERi(%"class.std::basic_istream"*, i32* dereferenceable(4)) #8

declare dso_local i32 @__gxx_personality_v0(...)

; Function Attrs: nounwind uwtable
define available_externally dso_local void @_ZNSt14basic_ifstreamIcSt11char_traitsIcEED1Ev(%"class.std::basic_ifstream"*) unnamed_addr #0 align 2 !dbg !1431 {
  %2 = alloca %"class.std::basic_ifstream"*, align 8
  store %"class.std::basic_ifstream"* %0, %"class.std::basic_ifstream"** %2, align 8, !tbaa !1388
  call void @llvm.dbg.declare(metadata %"class.std::basic_ifstream"** %2, metadata !1434, metadata !DIExpression()), !dbg !1435
  %3 = load %"class.std::basic_ifstream"*, %"class.std::basic_ifstream"** %2, align 8
  call void @_ZNSt14basic_ifstreamIcSt11char_traitsIcEED2Ev(%"class.std::basic_ifstream"* %3, i8** getelementptr inbounds ([4 x i8*], [4 x i8*]* @_ZTTSt14basic_ifstreamIcSt11char_traitsIcEE, i64 0, i64 0)) #6, !dbg !1436
  %4 = bitcast %"class.std::basic_ifstream"* %3 to i8*, !dbg !1436
  %5 = getelementptr inbounds i8, i8* %4, i64 256, !dbg !1436
  %6 = bitcast i8* %5 to %"class.std::basic_ios"*, !dbg !1436
  call void @_ZNSt9basic_iosIcSt11char_traitsIcEED2Ev(%"class.std::basic_ios"* %6) #6, !dbg !1436
  ret void, !dbg !1437
}

; Function Attrs: nounwind
declare dso_local i64 @strtol(i8*, i8**, i32) #2

; Function Attrs: nounwind uwtable
define available_externally dso_local void @_ZNSt9basic_iosIcSt11char_traitsIcEEC2Ev(%"class.std::basic_ios"*) unnamed_addr #0 align 2 !dbg !1438 {
  %2 = alloca %"class.std::basic_ios"*, align 8
  store %"class.std::basic_ios"* %0, %"class.std::basic_ios"** %2, align 8, !tbaa !1388
  call void @llvm.dbg.declare(metadata %"class.std::basic_ios"** %2, metadata !1447, metadata !DIExpression()), !dbg !1449
  %3 = load %"class.std::basic_ios"*, %"class.std::basic_ios"** %2, align 8
  %4 = bitcast %"class.std::basic_ios"* %3 to %"class.std::ios_base"*, !dbg !1450
  call void @_ZNSt8ios_baseC2Ev(%"class.std::ios_base"* %4) #6, !dbg !1451
  %5 = bitcast %"class.std::basic_ios"* %3 to i32 (...)***, !dbg !1450
  store i32 (...)** bitcast (i8** getelementptr inbounds ({ [4 x i8*] }, { [4 x i8*] }* @_ZTVSt9basic_iosIcSt11char_traitsIcEE, i32 0, inrange i32 0, i32 2) to i32 (...)**), i32 (...)*** %5, align 8, !dbg !1450, !tbaa !1418
  %6 = getelementptr inbounds %"class.std::basic_ios", %"class.std::basic_ios"* %3, i32 0, i32 1, !dbg !1452
  store %"class.std::basic_ostream"* null, %"class.std::basic_ostream"** %6, align 8, !dbg !1452, !tbaa !1453
  %7 = getelementptr inbounds %"class.std::basic_ios", %"class.std::basic_ios"* %3, i32 0, i32 2, !dbg !1456
  store i8 0, i8* %7, align 8, !dbg !1456, !tbaa !1457
  %8 = getelementptr inbounds %"class.std::basic_ios", %"class.std::basic_ios"* %3, i32 0, i32 3, !dbg !1458
  store i8 0, i8* %8, align 1, !dbg !1458, !tbaa !1459
  %9 = getelementptr inbounds %"class.std::basic_ios", %"class.std::basic_ios"* %3, i32 0, i32 4, !dbg !1460
  store %"class.std::basic_streambuf"* null, %"class.std::basic_streambuf"** %9, align 8, !dbg !1460, !tbaa !1461
  %10 = getelementptr inbounds %"class.std::basic_ios", %"class.std::basic_ios"* %3, i32 0, i32 5, !dbg !1462
  store %"class.std::ctype"* null, %"class.std::ctype"** %10, align 8, !dbg !1462, !tbaa !1463
  %11 = getelementptr inbounds %"class.std::basic_ios", %"class.std::basic_ios"* %3, i32 0, i32 6, !dbg !1464
  store %"class.std::num_put"* null, %"class.std::num_put"** %11, align 8, !dbg !1464, !tbaa !1465
  %12 = getelementptr inbounds %"class.std::basic_ios", %"class.std::basic_ios"* %3, i32 0, i32 7, !dbg !1466
  store %"class.std::num_get"* null, %"class.std::num_get"** %12, align 8, !dbg !1466, !tbaa !1467
  ret void, !dbg !1468
}

; Function Attrs: uwtable
define available_externally dso_local void @_ZNSiC2Ev(%"class.std::basic_istream"*, i8**) unnamed_addr #5 align 2 !dbg !1469 {
  %3 = alloca %"class.std::basic_istream"*, align 8
  %4 = alloca i8**, align 8
  store %"class.std::basic_istream"* %0, %"class.std::basic_istream"** %3, align 8, !tbaa !1388
  call void @llvm.dbg.declare(metadata %"class.std::basic_istream"** %3, metadata !1478, metadata !DIExpression()), !dbg !1482
  store i8** %1, i8*** %4, align 8, !tbaa !1388
  call void @llvm.dbg.declare(metadata i8*** %4, metadata !1480, metadata !DIExpression()), !dbg !1482
  %5 = load %"class.std::basic_istream"*, %"class.std::basic_istream"** %3, align 8
  %6 = load i8**, i8*** %4, align 8
  %7 = load i8*, i8** %6, align 8, !dbg !1483
  %8 = bitcast %"class.std::basic_istream"* %5 to i32 (...)***, !dbg !1483
  %9 = bitcast i8* %7 to i32 (...)**, !dbg !1483
  store i32 (...)** %9, i32 (...)*** %8, align 8, !dbg !1483, !tbaa !1418
  %10 = getelementptr inbounds i8*, i8** %6, i64 1, !dbg !1483
  %11 = load i8*, i8** %10, align 8, !dbg !1483
  %12 = bitcast %"class.std::basic_istream"* %5 to i8**, !dbg !1483
  %13 = load i8*, i8** %12, align 8, !dbg !1483, !tbaa !1418
  %14 = getelementptr i8, i8* %13, i64 -24, !dbg !1483
  %15 = bitcast i8* %14 to i64*, !dbg !1483
  %16 = load i64, i64* %15, align 8, !dbg !1483
  %17 = bitcast %"class.std::basic_istream"* %5 to i8*, !dbg !1483
  %18 = getelementptr inbounds i8, i8* %17, i64 %16, !dbg !1483
  %19 = bitcast i8* %18 to i32 (...)***, !dbg !1483
  %20 = bitcast i8* %11 to i32 (...)**, !dbg !1483
  store i32 (...)** %20, i32 (...)*** %19, align 8, !dbg !1483, !tbaa !1418
  %21 = getelementptr inbounds %"class.std::basic_istream", %"class.std::basic_istream"* %5, i32 0, i32 1, !dbg !1484
  store i64 0, i64* %21, align 8, !dbg !1484, !tbaa !1485
  %22 = bitcast %"class.std::basic_istream"* %5 to i8**, !dbg !1488
  %23 = load i8*, i8** %22, align 8, !dbg !1488, !tbaa !1418
  %24 = getelementptr i8, i8* %23, i64 -24, !dbg !1488
  %25 = bitcast i8* %24 to i64*, !dbg !1488
  %26 = load i64, i64* %25, align 8, !dbg !1488
  %27 = bitcast %"class.std::basic_istream"* %5 to i8*, !dbg !1488
  %28 = getelementptr inbounds i8, i8* %27, i64 %26, !dbg !1488
  %29 = bitcast i8* %28 to %"class.std::basic_ios"*, !dbg !1488
  call void @_ZNSt9basic_iosIcSt11char_traitsIcEE4initEPSt15basic_streambufIcS1_E(%"class.std::basic_ios"* %29, %"class.std::basic_streambuf"* null), !dbg !1488
  ret void, !dbg !1490
}

declare dso_local void @_ZNSt13basic_filebufIcSt11char_traitsIcEEC1Ev(%"class.std::basic_filebuf"*) unnamed_addr #8

declare dso_local void @_ZNSt9basic_iosIcSt11char_traitsIcEE4initEPSt15basic_streambufIcS1_E(%"class.std::basic_ios"*, %"class.std::basic_streambuf"*) #8

; Function Attrs: nounwind uwtable
define available_externally dso_local void @_ZNSt13basic_filebufIcSt11char_traitsIcEED2Ev(%"class.std::basic_filebuf"*) unnamed_addr #0 align 2 personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) !dbg !1491 {
  %2 = alloca %"class.std::basic_filebuf"*, align 8
  %3 = alloca i8*
  %4 = alloca i32
  store %"class.std::basic_filebuf"* %0, %"class.std::basic_filebuf"** %2, align 8, !tbaa !1388
  call void @llvm.dbg.declare(metadata %"class.std::basic_filebuf"** %2, metadata !1498, metadata !DIExpression()), !dbg !1500
  %5 = load %"class.std::basic_filebuf"*, %"class.std::basic_filebuf"** %2, align 8
  %6 = bitcast %"class.std::basic_filebuf"* %5 to i32 (...)***, !dbg !1501
  store i32 (...)** bitcast (i8** getelementptr inbounds ({ [16 x i8*] }, { [16 x i8*] }* @_ZTVSt13basic_filebufIcSt11char_traitsIcEE, i32 0, inrange i32 0, i32 2) to i32 (...)**), i32 (...)*** %6, align 8, !dbg !1501, !tbaa !1418
  %7 = invoke %"class.std::basic_filebuf"* @_ZNSt13basic_filebufIcSt11char_traitsIcEE5closeEv(%"class.std::basic_filebuf"* %5)
          to label %8 unwind label %11, !dbg !1502

; <label>:8:                                      ; preds = %1
  %9 = getelementptr inbounds %"class.std::basic_filebuf", %"class.std::basic_filebuf"* %5, i32 0, i32 2, !dbg !1504
  call void @_ZNSt12__basic_fileIcED1Ev(%"class.std::__basic_file"* %9) #6, !dbg !1504
  %10 = bitcast %"class.std::basic_filebuf"* %5 to %"class.std::basic_streambuf"*, !dbg !1504
  call void @_ZNSt15basic_streambufIcSt11char_traitsIcEED2Ev(%"class.std::basic_streambuf"* %10) #6, !dbg !1504
  ret void, !dbg !1505

; <label>:11:                                     ; preds = %1
  %12 = landingpad { i8*, i32 }
          cleanup
          filter [0 x i8*] zeroinitializer, !dbg !1504
  %13 = extractvalue { i8*, i32 } %12, 0, !dbg !1504
  store i8* %13, i8** %3, align 8, !dbg !1504
  %14 = extractvalue { i8*, i32 } %12, 1, !dbg !1504
  store i32 %14, i32* %4, align 4, !dbg !1504
  %15 = getelementptr inbounds %"class.std::basic_filebuf", %"class.std::basic_filebuf"* %5, i32 0, i32 2, !dbg !1504
  call void @_ZNSt12__basic_fileIcED1Ev(%"class.std::__basic_file"* %15) #6, !dbg !1504
  %16 = bitcast %"class.std::basic_filebuf"* %5 to %"class.std::basic_streambuf"*, !dbg !1504
  call void @_ZNSt15basic_streambufIcSt11char_traitsIcEED2Ev(%"class.std::basic_streambuf"* %16) #6, !dbg !1504
  br label %17, !dbg !1504

; <label>:17:                                     ; preds = %11
  %18 = load i8*, i8** %3, align 8, !dbg !1505
  call void @__cxa_call_unexpected(i8* %18) #10, !dbg !1505
  unreachable, !dbg !1505
}

; Function Attrs: nounwind uwtable
define available_externally dso_local void @_ZNSiD2Ev(%"class.std::basic_istream"*, i8**) unnamed_addr #0 align 2 !dbg !1506 {
  %3 = alloca %"class.std::basic_istream"*, align 8
  %4 = alloca i8**, align 8
  store %"class.std::basic_istream"* %0, %"class.std::basic_istream"** %3, align 8, !tbaa !1388
  call void @llvm.dbg.declare(metadata %"class.std::basic_istream"** %3, metadata !1509, metadata !DIExpression()), !dbg !1511
  store i8** %1, i8*** %4, align 8, !tbaa !1388
  call void @llvm.dbg.declare(metadata i8*** %4, metadata !1510, metadata !DIExpression()), !dbg !1511
  %5 = load %"class.std::basic_istream"*, %"class.std::basic_istream"** %3, align 8
  %6 = load i8**, i8*** %4, align 8
  %7 = load i8*, i8** %6, align 8, !dbg !1512
  %8 = bitcast %"class.std::basic_istream"* %5 to i32 (...)***, !dbg !1512
  %9 = bitcast i8* %7 to i32 (...)**, !dbg !1512
  store i32 (...)** %9, i32 (...)*** %8, align 8, !dbg !1512, !tbaa !1418
  %10 = getelementptr inbounds i8*, i8** %6, i64 1, !dbg !1512
  %11 = load i8*, i8** %10, align 8, !dbg !1512
  %12 = bitcast %"class.std::basic_istream"* %5 to i8**, !dbg !1512
  %13 = load i8*, i8** %12, align 8, !dbg !1512, !tbaa !1418
  %14 = getelementptr i8, i8* %13, i64 -24, !dbg !1512
  %15 = bitcast i8* %14 to i64*, !dbg !1512
  %16 = load i64, i64* %15, align 8, !dbg !1512
  %17 = bitcast %"class.std::basic_istream"* %5 to i8*, !dbg !1512
  %18 = getelementptr inbounds i8, i8* %17, i64 %16, !dbg !1512
  %19 = bitcast i8* %18 to i32 (...)***, !dbg !1512
  %20 = bitcast i8* %11 to i32 (...)**, !dbg !1512
  store i32 (...)** %20, i32 (...)*** %19, align 8, !dbg !1512, !tbaa !1418
  %21 = getelementptr inbounds %"class.std::basic_istream", %"class.std::basic_istream"* %5, i32 0, i32 1, !dbg !1513
  store i64 0, i64* %21, align 8, !dbg !1515, !tbaa !1485
  ret void, !dbg !1516
}

; Function Attrs: nounwind uwtable
define available_externally dso_local void @_ZNSt9basic_iosIcSt11char_traitsIcEED2Ev(%"class.std::basic_ios"*) unnamed_addr #0 align 2 !dbg !1517 {
  %2 = alloca %"class.std::basic_ios"*, align 8
  store %"class.std::basic_ios"* %0, %"class.std::basic_ios"** %2, align 8, !tbaa !1388
  call void @llvm.dbg.declare(metadata %"class.std::basic_ios"** %2, metadata !1520, metadata !DIExpression()), !dbg !1521
  %3 = load %"class.std::basic_ios"*, %"class.std::basic_ios"** %2, align 8
  %4 = bitcast %"class.std::basic_ios"* %3 to %"class.std::ios_base"*, !dbg !1522
  call void @_ZNSt8ios_baseD2Ev(%"class.std::ios_base"* %4) #6, !dbg !1522
  ret void, !dbg !1524
}

; Function Attrs: nounwind
declare dso_local void @_ZNSt8ios_baseC2Ev(%"class.std::ios_base"*) unnamed_addr #2

declare dso_local %"class.std::basic_filebuf"* @_ZNSt13basic_filebufIcSt11char_traitsIcEE5closeEv(%"class.std::basic_filebuf"*) #8

; Function Attrs: nounwind
declare dso_local void @_ZNSt12__basic_fileIcED1Ev(%"class.std::__basic_file"*) unnamed_addr #2

; Function Attrs: nounwind uwtable
define available_externally dso_local void @_ZNSt15basic_streambufIcSt11char_traitsIcEED2Ev(%"class.std::basic_streambuf"*) unnamed_addr #0 align 2 !dbg !1525 {
  %2 = alloca %"class.std::basic_streambuf"*, align 8
  store %"class.std::basic_streambuf"* %0, %"class.std::basic_streambuf"** %2, align 8, !tbaa !1388
  call void @llvm.dbg.declare(metadata %"class.std::basic_streambuf"** %2, metadata !1534, metadata !DIExpression()), !dbg !1536
  %3 = load %"class.std::basic_streambuf"*, %"class.std::basic_streambuf"** %2, align 8
  %4 = bitcast %"class.std::basic_streambuf"* %3 to i32 (...)***, !dbg !1537
  store i32 (...)** bitcast (i8** getelementptr inbounds ({ [16 x i8*] }, { [16 x i8*] }* @_ZTVSt15basic_streambufIcSt11char_traitsIcEE, i32 0, inrange i32 0, i32 2) to i32 (...)**), i32 (...)*** %4, align 8, !dbg !1537, !tbaa !1418
  %5 = getelementptr inbounds %"class.std::basic_streambuf", %"class.std::basic_streambuf"* %3, i32 0, i32 7, !dbg !1538
  call void @_ZNSt6localeD1Ev(%"class.std::locale"* %5) #6, !dbg !1538
  ret void, !dbg !1540
}

declare dso_local void @__cxa_call_unexpected(i8*)

; Function Attrs: nounwind
declare dso_local void @_ZNSt6localeD1Ev(%"class.std::locale"*) unnamed_addr #2

; Function Attrs: nounwind
declare dso_local void @_ZNSt8ios_baseD2Ev(%"class.std::ios_base"*) unnamed_addr #2

; Function Attrs: nounwind uwtable
define available_externally dso_local void @_ZNSt14basic_ifstreamIcSt11char_traitsIcEED2Ev(%"class.std::basic_ifstream"*, i8**) unnamed_addr #0 align 2 !dbg !1541 {
  %3 = alloca %"class.std::basic_ifstream"*, align 8
  %4 = alloca i8**, align 8
  store %"class.std::basic_ifstream"* %0, %"class.std::basic_ifstream"** %3, align 8, !tbaa !1388
  call void @llvm.dbg.declare(metadata %"class.std::basic_ifstream"** %3, metadata !1543, metadata !DIExpression()), !dbg !1545
  store i8** %1, i8*** %4, align 8, !tbaa !1388
  call void @llvm.dbg.declare(metadata i8*** %4, metadata !1544, metadata !DIExpression()), !dbg !1545
  %5 = load %"class.std::basic_ifstream"*, %"class.std::basic_ifstream"** %3, align 8
  %6 = load i8**, i8*** %4, align 8
  %7 = load i8*, i8** %6, align 8, !dbg !1546
  %8 = bitcast %"class.std::basic_ifstream"* %5 to i32 (...)***, !dbg !1546
  %9 = bitcast i8* %7 to i32 (...)**, !dbg !1546
  store i32 (...)** %9, i32 (...)*** %8, align 8, !dbg !1546, !tbaa !1418
  %10 = getelementptr inbounds i8*, i8** %6, i64 3, !dbg !1546
  %11 = load i8*, i8** %10, align 8, !dbg !1546
  %12 = bitcast %"class.std::basic_ifstream"* %5 to i8**, !dbg !1546
  %13 = load i8*, i8** %12, align 8, !dbg !1546, !tbaa !1418
  %14 = getelementptr i8, i8* %13, i64 -24, !dbg !1546
  %15 = bitcast i8* %14 to i64*, !dbg !1546
  %16 = load i64, i64* %15, align 8, !dbg !1546
  %17 = bitcast %"class.std::basic_ifstream"* %5 to i8*, !dbg !1546
  %18 = getelementptr inbounds i8, i8* %17, i64 %16, !dbg !1546
  %19 = bitcast i8* %18 to i32 (...)***, !dbg !1546
  %20 = bitcast i8* %11 to i32 (...)**, !dbg !1546
  store i32 (...)** %20, i32 (...)*** %19, align 8, !dbg !1546, !tbaa !1418
  %21 = getelementptr inbounds %"class.std::basic_ifstream", %"class.std::basic_ifstream"* %5, i32 0, i32 1, !dbg !1547
  call void @_ZNSt13basic_filebufIcSt11char_traitsIcEED2Ev(%"class.std::basic_filebuf"* %21) #6, !dbg !1547
  %22 = bitcast %"class.std::basic_ifstream"* %5 to %"class.std::basic_istream"*, !dbg !1547
  %23 = getelementptr inbounds i8*, i8** %6, i64 1, !dbg !1547
  call void @_ZNSiD2Ev(%"class.std::basic_istream"* %22, i8** %23) #6, !dbg !1547
  ret void, !dbg !1549
}

; Function Attrs: nounwind uwtable
define available_externally dso_local void @_ZTv0_n24_NSt14basic_ifstreamIcSt11char_traitsIcEED1Ev(%"class.std::basic_ifstream"*) unnamed_addr #0 align 2 !dbg !1550 {
  %2 = alloca %"class.std::basic_ifstream"*, align 8
  store %"class.std::basic_ifstream"* %0, %"class.std::basic_ifstream"** %2, align 8, !tbaa !1388
  call void @llvm.dbg.declare(metadata %"class.std::basic_ifstream"** %2, metadata !1553, metadata !DIExpression()), !dbg !1554
  %3 = load %"class.std::basic_ifstream"*, %"class.std::basic_ifstream"** %2, align 8, !dbg !1554
  %4 = bitcast %"class.std::basic_ifstream"* %3 to i8*, !dbg !1554
  %5 = bitcast i8* %4 to i8**, !dbg !1554
  %6 = load i8*, i8** %5, align 8, !dbg !1554
  %7 = getelementptr inbounds i8, i8* %6, i64 -24, !dbg !1554
  %8 = bitcast i8* %7 to i64*, !dbg !1554
  %9 = load i64, i64* %8, align 8, !dbg !1554
  %10 = getelementptr inbounds i8, i8* %4, i64 %9, !dbg !1554
  %11 = bitcast i8* %10 to %"class.std::basic_ifstream"*, !dbg !1554
  tail call void @_ZNSt14basic_ifstreamIcSt11char_traitsIcEED1Ev(%"class.std::basic_ifstream"* %11) #6, !dbg !1554
  ret void, !dbg !1554
}

attributes #0 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone speculatable }
attributes #2 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { argmemonly nounwind }
attributes #4 = { norecurse uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #6 = { nounwind }
attributes #7 = { inlinehint nounwind readonly uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #8 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #9 = { nounwind readonly }
attributes #10 = { noreturn }

!llvm.dbg.cu = !{!2}
!llvm.module.flags = !{!1277, !1278, !1279}
!llvm.ident = !{!1280}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "global", scope: !2, file: !3, line: 8, type: !7, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !3, producer: "clang version 8.0.0 (git@github.com:llvm-mirror/clang.git e3e8f2a67bc17cb4f751b22e53e16d7c39b371d0) (git@github.com:llvm-mirror/LLVM.git 48e9774b6791c48760d18775039eefa6d824522d)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !4, retainedTypes: !5, globals: !17, imports: !20, nameTableKind: None)
!3 = !DIFile(filename: "tests/extrap/prune.cpp", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!4 = !{}
!5 = !{!6, !7, !8, !11}
!6 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!7 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!8 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !9, size: 64)
!9 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !10, size: 64)
!10 = !DIBasicType(name: "char", size: 8, encoding: DW_ATE_signed_char)
!11 = !DIDerivedType(tag: DW_TAG_typedef, name: "streamsize", scope: !13, file: !12, line: 98, baseType: !14)
!12 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.3.0/../../../../include/c++/7.3.0/bits/postypes.h", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!13 = !DINamespace(name: "std", scope: null)
!14 = !DIDerivedType(tag: DW_TAG_typedef, name: "ptrdiff_t", scope: !13, file: !15, line: 232, baseType: !16)
!15 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.3.0/../../../../include/x86_64-linux-gnu/c++/7.3.0/bits/c++config.h", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!16 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!17 = !{!0, !18}
!18 = !DIGlobalVariableExpression(var: !19, expr: !DIExpression())
!19 = distinct !DIGlobalVariable(name: "global2", scope: !2, file: !3, line: 9, type: !6, isLocal: false, isDefinition: true)
!20 = !{!21, !27, !33, !35, !37, !41, !43, !45, !47, !49, !51, !53, !55, !60, !64, !66, !68, !73, !75, !77, !79, !81, !83, !85, !88, !91, !93, !97, !102, !104, !106, !108, !110, !112, !114, !116, !118, !120, !122, !126, !130, !132, !134, !136, !138, !140, !142, !144, !146, !148, !150, !152, !154, !156, !158, !160, !164, !168, !172, !174, !176, !178, !180, !182, !184, !186, !188, !190, !194, !198, !202, !204, !206, !208, !213, !217, !221, !223, !225, !227, !229, !231, !233, !235, !237, !239, !241, !243, !245, !249, !253, !257, !259, !261, !263, !269, !273, !277, !279, !281, !283, !285, !287, !289, !293, !297, !299, !301, !303, !305, !309, !313, !317, !319, !321, !323, !325, !327, !329, !333, !337, !341, !343, !347, !351, !353, !355, !357, !359, !361, !363, !367, !373, !377, !382, !384, !387, !393, !397, !412, !416, !420, !424, !428, !432, !436, !440, !444, !448, !456, !460, !464, !466, !470, !474, !479, !484, !488, !492, !494, !502, !506, !513, !515, !519, !523, !527, !531, !536, !540, !544, !545, !546, !547, !549, !550, !551, !552, !553, !554, !555, !572, !575, !580, !635, !640, !644, !648, !652, !656, !658, !660, !664, !670, !674, !680, !686, !688, !692, !696, !700, !704, !715, !717, !721, !725, !729, !731, !735, !739, !743, !745, !747, !751, !759, !763, !767, !771, !773, !779, !781, !787, !791, !795, !799, !803, !807, !811, !813, !815, !819, !823, !827, !829, !833, !837, !839, !841, !845, !849, !853, !857, !858, !859, !860, !861, !862, !863, !864, !865, !866, !867, !922, !926, !930, !935, !939, !942, !945, !948, !950, !952, !954, !956, !958, !960, !962, !965, !967, !972, !975, !978, !981, !983, !985, !987, !989, !991, !993, !995, !997, !1000, !1002, !1006, !1010, !1015, !1019, !1021, !1023, !1025, !1027, !1029, !1031, !1033, !1035, !1037, !1039, !1041, !1043, !1045, !1048, !1049, !1053, !1059, !1064, !1068, !1070, !1072, !1074, !1076, !1083, !1087, !1091, !1095, !1099, !1103, !1108, !1112, !1114, !1118, !1124, !1128, !1133, !1135, !1138, !1142, !1146, !1148, !1150, !1152, !1154, !1158, !1160, !1162, !1166, !1170, !1174, !1178, !1182, !1186, !1188, !1192, !1196, !1200, !1204, !1206, !1208, !1212, !1216, !1217, !1218, !1219, !1220, !1221, !1227, !1230, !1231, !1233, !1235, !1237, !1239, !1243, !1245, !1247, !1249, !1251, !1253, !1255, !1257, !1259, !1263, !1267, !1269, !1273}
!21 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !22, file: !26, line: 52)
!22 = !DISubprogram(name: "abs", scope: !23, file: !23, line: 837, type: !24, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!23 = !DIFile(filename: "/usr/include/stdlib.h", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!24 = !DISubroutineType(types: !25)
!25 = !{!7, !7}
!26 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.3.0/../../../../include/c++/7.3.0/bits/std_abs.h", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!27 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !28, file: !32, line: 83)
!28 = !DISubprogram(name: "acos", scope: !29, file: !29, line: 53, type: !30, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!29 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/mathcalls.h", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!30 = !DISubroutineType(types: !31)
!31 = !{!6, !6}
!32 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.3.0/../../../../include/c++/7.3.0/cmath", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!33 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !34, file: !32, line: 102)
!34 = !DISubprogram(name: "asin", scope: !29, file: !29, line: 55, type: !30, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!35 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !36, file: !32, line: 121)
!36 = !DISubprogram(name: "atan", scope: !29, file: !29, line: 57, type: !30, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!37 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !38, file: !32, line: 140)
!38 = !DISubprogram(name: "atan2", scope: !29, file: !29, line: 59, type: !39, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!39 = !DISubroutineType(types: !40)
!40 = !{!6, !6, !6}
!41 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !42, file: !32, line: 161)
!42 = !DISubprogram(name: "ceil", scope: !29, file: !29, line: 159, type: !30, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!43 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !44, file: !32, line: 180)
!44 = !DISubprogram(name: "cos", scope: !29, file: !29, line: 62, type: !30, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!45 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !46, file: !32, line: 199)
!46 = !DISubprogram(name: "cosh", scope: !29, file: !29, line: 71, type: !30, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!47 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !48, file: !32, line: 218)
!48 = !DISubprogram(name: "exp", scope: !29, file: !29, line: 95, type: !30, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!49 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !50, file: !32, line: 237)
!50 = !DISubprogram(name: "fabs", scope: !29, file: !29, line: 162, type: !30, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!51 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !52, file: !32, line: 256)
!52 = !DISubprogram(name: "floor", scope: !29, file: !29, line: 165, type: !30, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!53 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !54, file: !32, line: 275)
!54 = !DISubprogram(name: "fmod", scope: !29, file: !29, line: 168, type: !39, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!55 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !56, file: !32, line: 296)
!56 = !DISubprogram(name: "frexp", scope: !29, file: !29, line: 98, type: !57, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!57 = !DISubroutineType(types: !58)
!58 = !{!6, !6, !59}
!59 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!60 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !61, file: !32, line: 315)
!61 = !DISubprogram(name: "ldexp", scope: !29, file: !29, line: 101, type: !62, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!62 = !DISubroutineType(types: !63)
!63 = !{!6, !6, !7}
!64 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !65, file: !32, line: 334)
!65 = !DISubprogram(name: "log", scope: !29, file: !29, line: 104, type: !30, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!66 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !67, file: !32, line: 353)
!67 = !DISubprogram(name: "log10", scope: !29, file: !29, line: 107, type: !30, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!68 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !69, file: !32, line: 372)
!69 = !DISubprogram(name: "modf", scope: !29, file: !29, line: 110, type: !70, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!70 = !DISubroutineType(types: !71)
!71 = !{!6, !6, !72}
!72 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !6, size: 64)
!73 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !74, file: !32, line: 384)
!74 = !DISubprogram(name: "pow", scope: !29, file: !29, line: 140, type: !39, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!75 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !76, file: !32, line: 421)
!76 = !DISubprogram(name: "sin", scope: !29, file: !29, line: 64, type: !30, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!77 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !78, file: !32, line: 440)
!78 = !DISubprogram(name: "sinh", scope: !29, file: !29, line: 73, type: !30, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!79 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !80, file: !32, line: 459)
!80 = !DISubprogram(name: "sqrt", scope: !29, file: !29, line: 143, type: !30, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!81 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !82, file: !32, line: 478)
!82 = !DISubprogram(name: "tan", scope: !29, file: !29, line: 66, type: !30, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!83 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !84, file: !32, line: 497)
!84 = !DISubprogram(name: "tanh", scope: !29, file: !29, line: 75, type: !30, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!85 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !86, file: !32, line: 1080)
!86 = !DIDerivedType(tag: DW_TAG_typedef, name: "double_t", file: !87, line: 150, baseType: !6)
!87 = !DIFile(filename: "/usr/include/math.h", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!88 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !89, file: !32, line: 1081)
!89 = !DIDerivedType(tag: DW_TAG_typedef, name: "float_t", file: !87, line: 149, baseType: !90)
!90 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!91 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !92, file: !32, line: 1084)
!92 = !DISubprogram(name: "acosh", scope: !29, file: !29, line: 85, type: !30, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!93 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !94, file: !32, line: 1085)
!94 = !DISubprogram(name: "acoshf", scope: !29, file: !29, line: 85, type: !95, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!95 = !DISubroutineType(types: !96)
!96 = !{!90, !90}
!97 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !98, file: !32, line: 1086)
!98 = !DISubprogram(name: "acoshl", scope: !29, file: !29, line: 85, type: !99, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!99 = !DISubroutineType(types: !100)
!100 = !{!101, !101}
!101 = !DIBasicType(name: "long double", size: 128, encoding: DW_ATE_float)
!102 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !103, file: !32, line: 1088)
!103 = !DISubprogram(name: "asinh", scope: !29, file: !29, line: 87, type: !30, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!104 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !105, file: !32, line: 1089)
!105 = !DISubprogram(name: "asinhf", scope: !29, file: !29, line: 87, type: !95, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!106 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !107, file: !32, line: 1090)
!107 = !DISubprogram(name: "asinhl", scope: !29, file: !29, line: 87, type: !99, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!108 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !109, file: !32, line: 1092)
!109 = !DISubprogram(name: "atanh", scope: !29, file: !29, line: 89, type: !30, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!110 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !111, file: !32, line: 1093)
!111 = !DISubprogram(name: "atanhf", scope: !29, file: !29, line: 89, type: !95, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!112 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !113, file: !32, line: 1094)
!113 = !DISubprogram(name: "atanhl", scope: !29, file: !29, line: 89, type: !99, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!114 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !115, file: !32, line: 1096)
!115 = !DISubprogram(name: "cbrt", scope: !29, file: !29, line: 152, type: !30, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!116 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !117, file: !32, line: 1097)
!117 = !DISubprogram(name: "cbrtf", scope: !29, file: !29, line: 152, type: !95, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!118 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !119, file: !32, line: 1098)
!119 = !DISubprogram(name: "cbrtl", scope: !29, file: !29, line: 152, type: !99, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!120 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !121, file: !32, line: 1100)
!121 = !DISubprogram(name: "copysign", scope: !29, file: !29, line: 196, type: !39, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!122 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !123, file: !32, line: 1101)
!123 = !DISubprogram(name: "copysignf", scope: !29, file: !29, line: 196, type: !124, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!124 = !DISubroutineType(types: !125)
!125 = !{!90, !90, !90}
!126 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !127, file: !32, line: 1102)
!127 = !DISubprogram(name: "copysignl", scope: !29, file: !29, line: 196, type: !128, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!128 = !DISubroutineType(types: !129)
!129 = !{!101, !101, !101}
!130 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !131, file: !32, line: 1104)
!131 = !DISubprogram(name: "erf", scope: !29, file: !29, line: 228, type: !30, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!132 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !133, file: !32, line: 1105)
!133 = !DISubprogram(name: "erff", scope: !29, file: !29, line: 228, type: !95, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!134 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !135, file: !32, line: 1106)
!135 = !DISubprogram(name: "erfl", scope: !29, file: !29, line: 228, type: !99, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!136 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !137, file: !32, line: 1108)
!137 = !DISubprogram(name: "erfc", scope: !29, file: !29, line: 229, type: !30, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!138 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !139, file: !32, line: 1109)
!139 = !DISubprogram(name: "erfcf", scope: !29, file: !29, line: 229, type: !95, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!140 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !141, file: !32, line: 1110)
!141 = !DISubprogram(name: "erfcl", scope: !29, file: !29, line: 229, type: !99, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!142 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !143, file: !32, line: 1112)
!143 = !DISubprogram(name: "exp2", scope: !29, file: !29, line: 130, type: !30, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!144 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !145, file: !32, line: 1113)
!145 = !DISubprogram(name: "exp2f", scope: !29, file: !29, line: 130, type: !95, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!146 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !147, file: !32, line: 1114)
!147 = !DISubprogram(name: "exp2l", scope: !29, file: !29, line: 130, type: !99, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!148 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !149, file: !32, line: 1116)
!149 = !DISubprogram(name: "expm1", scope: !29, file: !29, line: 119, type: !30, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!150 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !151, file: !32, line: 1117)
!151 = !DISubprogram(name: "expm1f", scope: !29, file: !29, line: 119, type: !95, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!152 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !153, file: !32, line: 1118)
!153 = !DISubprogram(name: "expm1l", scope: !29, file: !29, line: 119, type: !99, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!154 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !155, file: !32, line: 1120)
!155 = !DISubprogram(name: "fdim", scope: !29, file: !29, line: 326, type: !39, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!156 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !157, file: !32, line: 1121)
!157 = !DISubprogram(name: "fdimf", scope: !29, file: !29, line: 326, type: !124, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!158 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !159, file: !32, line: 1122)
!159 = !DISubprogram(name: "fdiml", scope: !29, file: !29, line: 326, type: !128, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!160 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !161, file: !32, line: 1124)
!161 = !DISubprogram(name: "fma", scope: !29, file: !29, line: 335, type: !162, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!162 = !DISubroutineType(types: !163)
!163 = !{!6, !6, !6, !6}
!164 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !165, file: !32, line: 1125)
!165 = !DISubprogram(name: "fmaf", scope: !29, file: !29, line: 335, type: !166, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!166 = !DISubroutineType(types: !167)
!167 = !{!90, !90, !90, !90}
!168 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !169, file: !32, line: 1126)
!169 = !DISubprogram(name: "fmal", scope: !29, file: !29, line: 335, type: !170, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!170 = !DISubroutineType(types: !171)
!171 = !{!101, !101, !101, !101}
!172 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !173, file: !32, line: 1128)
!173 = !DISubprogram(name: "fmax", scope: !29, file: !29, line: 329, type: !39, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!174 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !175, file: !32, line: 1129)
!175 = !DISubprogram(name: "fmaxf", scope: !29, file: !29, line: 329, type: !124, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!176 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !177, file: !32, line: 1130)
!177 = !DISubprogram(name: "fmaxl", scope: !29, file: !29, line: 329, type: !128, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!178 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !179, file: !32, line: 1132)
!179 = !DISubprogram(name: "fmin", scope: !29, file: !29, line: 332, type: !39, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!180 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !181, file: !32, line: 1133)
!181 = !DISubprogram(name: "fminf", scope: !29, file: !29, line: 332, type: !124, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!182 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !183, file: !32, line: 1134)
!183 = !DISubprogram(name: "fminl", scope: !29, file: !29, line: 332, type: !128, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!184 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !185, file: !32, line: 1136)
!185 = !DISubprogram(name: "hypot", scope: !29, file: !29, line: 147, type: !39, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!186 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !187, file: !32, line: 1137)
!187 = !DISubprogram(name: "hypotf", scope: !29, file: !29, line: 147, type: !124, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!188 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !189, file: !32, line: 1138)
!189 = !DISubprogram(name: "hypotl", scope: !29, file: !29, line: 147, type: !128, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!190 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !191, file: !32, line: 1140)
!191 = !DISubprogram(name: "ilogb", scope: !29, file: !29, line: 280, type: !192, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!192 = !DISubroutineType(types: !193)
!193 = !{!7, !6}
!194 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !195, file: !32, line: 1141)
!195 = !DISubprogram(name: "ilogbf", scope: !29, file: !29, line: 280, type: !196, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!196 = !DISubroutineType(types: !197)
!197 = !{!7, !90}
!198 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !199, file: !32, line: 1142)
!199 = !DISubprogram(name: "ilogbl", scope: !29, file: !29, line: 280, type: !200, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!200 = !DISubroutineType(types: !201)
!201 = !{!7, !101}
!202 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !203, file: !32, line: 1144)
!203 = !DISubprogram(name: "lgamma", scope: !29, file: !29, line: 230, type: !30, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!204 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !205, file: !32, line: 1145)
!205 = !DISubprogram(name: "lgammaf", scope: !29, file: !29, line: 230, type: !95, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!206 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !207, file: !32, line: 1146)
!207 = !DISubprogram(name: "lgammal", scope: !29, file: !29, line: 230, type: !99, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!208 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !209, file: !32, line: 1149)
!209 = !DISubprogram(name: "llrint", scope: !29, file: !29, line: 316, type: !210, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!210 = !DISubroutineType(types: !211)
!211 = !{!212, !6}
!212 = !DIBasicType(name: "long long int", size: 64, encoding: DW_ATE_signed)
!213 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !214, file: !32, line: 1150)
!214 = !DISubprogram(name: "llrintf", scope: !29, file: !29, line: 316, type: !215, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!215 = !DISubroutineType(types: !216)
!216 = !{!212, !90}
!217 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !218, file: !32, line: 1151)
!218 = !DISubprogram(name: "llrintl", scope: !29, file: !29, line: 316, type: !219, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!219 = !DISubroutineType(types: !220)
!220 = !{!212, !101}
!221 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !222, file: !32, line: 1153)
!222 = !DISubprogram(name: "llround", scope: !29, file: !29, line: 322, type: !210, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!223 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !224, file: !32, line: 1154)
!224 = !DISubprogram(name: "llroundf", scope: !29, file: !29, line: 322, type: !215, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!225 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !226, file: !32, line: 1155)
!226 = !DISubprogram(name: "llroundl", scope: !29, file: !29, line: 322, type: !219, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!227 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !228, file: !32, line: 1158)
!228 = !DISubprogram(name: "log1p", scope: !29, file: !29, line: 122, type: !30, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!229 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !230, file: !32, line: 1159)
!230 = !DISubprogram(name: "log1pf", scope: !29, file: !29, line: 122, type: !95, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!231 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !232, file: !32, line: 1160)
!232 = !DISubprogram(name: "log1pl", scope: !29, file: !29, line: 122, type: !99, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!233 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !234, file: !32, line: 1162)
!234 = !DISubprogram(name: "log2", scope: !29, file: !29, line: 133, type: !30, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!235 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !236, file: !32, line: 1163)
!236 = !DISubprogram(name: "log2f", scope: !29, file: !29, line: 133, type: !95, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!237 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !238, file: !32, line: 1164)
!238 = !DISubprogram(name: "log2l", scope: !29, file: !29, line: 133, type: !99, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!239 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !240, file: !32, line: 1166)
!240 = !DISubprogram(name: "logb", scope: !29, file: !29, line: 125, type: !30, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!241 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !242, file: !32, line: 1167)
!242 = !DISubprogram(name: "logbf", scope: !29, file: !29, line: 125, type: !95, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!243 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !244, file: !32, line: 1168)
!244 = !DISubprogram(name: "logbl", scope: !29, file: !29, line: 125, type: !99, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!245 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !246, file: !32, line: 1170)
!246 = !DISubprogram(name: "lrint", scope: !29, file: !29, line: 314, type: !247, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!247 = !DISubroutineType(types: !248)
!248 = !{!16, !6}
!249 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !250, file: !32, line: 1171)
!250 = !DISubprogram(name: "lrintf", scope: !29, file: !29, line: 314, type: !251, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!251 = !DISubroutineType(types: !252)
!252 = !{!16, !90}
!253 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !254, file: !32, line: 1172)
!254 = !DISubprogram(name: "lrintl", scope: !29, file: !29, line: 314, type: !255, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!255 = !DISubroutineType(types: !256)
!256 = !{!16, !101}
!257 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !258, file: !32, line: 1174)
!258 = !DISubprogram(name: "lround", scope: !29, file: !29, line: 320, type: !247, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!259 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !260, file: !32, line: 1175)
!260 = !DISubprogram(name: "lroundf", scope: !29, file: !29, line: 320, type: !251, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!261 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !262, file: !32, line: 1176)
!262 = !DISubprogram(name: "lroundl", scope: !29, file: !29, line: 320, type: !255, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!263 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !264, file: !32, line: 1178)
!264 = !DISubprogram(name: "nan", scope: !29, file: !29, line: 201, type: !265, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!265 = !DISubroutineType(types: !266)
!266 = !{!6, !267}
!267 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !268, size: 64)
!268 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !10)
!269 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !270, file: !32, line: 1179)
!270 = !DISubprogram(name: "nanf", scope: !29, file: !29, line: 201, type: !271, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!271 = !DISubroutineType(types: !272)
!272 = !{!90, !267}
!273 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !274, file: !32, line: 1180)
!274 = !DISubprogram(name: "nanl", scope: !29, file: !29, line: 201, type: !275, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!275 = !DISubroutineType(types: !276)
!276 = !{!101, !267}
!277 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !278, file: !32, line: 1182)
!278 = !DISubprogram(name: "nearbyint", scope: !29, file: !29, line: 294, type: !30, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!279 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !280, file: !32, line: 1183)
!280 = !DISubprogram(name: "nearbyintf", scope: !29, file: !29, line: 294, type: !95, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!281 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !282, file: !32, line: 1184)
!282 = !DISubprogram(name: "nearbyintl", scope: !29, file: !29, line: 294, type: !99, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!283 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !284, file: !32, line: 1186)
!284 = !DISubprogram(name: "nextafter", scope: !29, file: !29, line: 259, type: !39, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!285 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !286, file: !32, line: 1187)
!286 = !DISubprogram(name: "nextafterf", scope: !29, file: !29, line: 259, type: !124, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!287 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !288, file: !32, line: 1188)
!288 = !DISubprogram(name: "nextafterl", scope: !29, file: !29, line: 259, type: !128, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!289 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !290, file: !32, line: 1190)
!290 = !DISubprogram(name: "nexttoward", scope: !29, file: !29, line: 261, type: !291, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!291 = !DISubroutineType(types: !292)
!292 = !{!6, !6, !101}
!293 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !294, file: !32, line: 1191)
!294 = !DISubprogram(name: "nexttowardf", scope: !29, file: !29, line: 261, type: !295, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!295 = !DISubroutineType(types: !296)
!296 = !{!90, !90, !101}
!297 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !298, file: !32, line: 1192)
!298 = !DISubprogram(name: "nexttowardl", scope: !29, file: !29, line: 261, type: !128, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!299 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !300, file: !32, line: 1194)
!300 = !DISubprogram(name: "remainder", scope: !29, file: !29, line: 272, type: !39, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!301 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !302, file: !32, line: 1195)
!302 = !DISubprogram(name: "remainderf", scope: !29, file: !29, line: 272, type: !124, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!303 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !304, file: !32, line: 1196)
!304 = !DISubprogram(name: "remainderl", scope: !29, file: !29, line: 272, type: !128, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!305 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !306, file: !32, line: 1198)
!306 = !DISubprogram(name: "remquo", scope: !29, file: !29, line: 307, type: !307, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!307 = !DISubroutineType(types: !308)
!308 = !{!6, !6, !6, !59}
!309 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !310, file: !32, line: 1199)
!310 = !DISubprogram(name: "remquof", scope: !29, file: !29, line: 307, type: !311, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!311 = !DISubroutineType(types: !312)
!312 = !{!90, !90, !90, !59}
!313 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !314, file: !32, line: 1200)
!314 = !DISubprogram(name: "remquol", scope: !29, file: !29, line: 307, type: !315, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!315 = !DISubroutineType(types: !316)
!316 = !{!101, !101, !101, !59}
!317 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !318, file: !32, line: 1202)
!318 = !DISubprogram(name: "rint", scope: !29, file: !29, line: 256, type: !30, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!319 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !320, file: !32, line: 1203)
!320 = !DISubprogram(name: "rintf", scope: !29, file: !29, line: 256, type: !95, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!321 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !322, file: !32, line: 1204)
!322 = !DISubprogram(name: "rintl", scope: !29, file: !29, line: 256, type: !99, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!323 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !324, file: !32, line: 1206)
!324 = !DISubprogram(name: "round", scope: !29, file: !29, line: 298, type: !30, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!325 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !326, file: !32, line: 1207)
!326 = !DISubprogram(name: "roundf", scope: !29, file: !29, line: 298, type: !95, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!327 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !328, file: !32, line: 1208)
!328 = !DISubprogram(name: "roundl", scope: !29, file: !29, line: 298, type: !99, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!329 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !330, file: !32, line: 1210)
!330 = !DISubprogram(name: "scalbln", scope: !29, file: !29, line: 290, type: !331, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!331 = !DISubroutineType(types: !332)
!332 = !{!6, !6, !16}
!333 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !334, file: !32, line: 1211)
!334 = !DISubprogram(name: "scalblnf", scope: !29, file: !29, line: 290, type: !335, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!335 = !DISubroutineType(types: !336)
!336 = !{!90, !90, !16}
!337 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !338, file: !32, line: 1212)
!338 = !DISubprogram(name: "scalblnl", scope: !29, file: !29, line: 290, type: !339, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!339 = !DISubroutineType(types: !340)
!340 = !{!101, !101, !16}
!341 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !342, file: !32, line: 1214)
!342 = !DISubprogram(name: "scalbn", scope: !29, file: !29, line: 276, type: !62, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!343 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !344, file: !32, line: 1215)
!344 = !DISubprogram(name: "scalbnf", scope: !29, file: !29, line: 276, type: !345, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!345 = !DISubroutineType(types: !346)
!346 = !{!90, !90, !7}
!347 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !348, file: !32, line: 1216)
!348 = !DISubprogram(name: "scalbnl", scope: !29, file: !29, line: 276, type: !349, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!349 = !DISubroutineType(types: !350)
!350 = !{!101, !101, !7}
!351 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !352, file: !32, line: 1218)
!352 = !DISubprogram(name: "tgamma", scope: !29, file: !29, line: 235, type: !30, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!353 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !354, file: !32, line: 1219)
!354 = !DISubprogram(name: "tgammaf", scope: !29, file: !29, line: 235, type: !95, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!355 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !356, file: !32, line: 1220)
!356 = !DISubprogram(name: "tgammal", scope: !29, file: !29, line: 235, type: !99, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!357 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !358, file: !32, line: 1222)
!358 = !DISubprogram(name: "trunc", scope: !29, file: !29, line: 302, type: !30, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!359 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !360, file: !32, line: 1223)
!360 = !DISubprogram(name: "truncf", scope: !29, file: !29, line: 302, type: !95, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!361 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !362, file: !32, line: 1224)
!362 = !DISubprogram(name: "truncl", scope: !29, file: !29, line: 302, type: !99, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!363 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !364, file: !366, line: 127)
!364 = !DIDerivedType(tag: DW_TAG_typedef, name: "div_t", file: !23, line: 62, baseType: !365)
!365 = !DICompositeType(tag: DW_TAG_structure_type, file: !23, line: 58, flags: DIFlagFwdDecl, identifier: "_ZTS5div_t")
!366 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.3.0/../../../../include/c++/7.3.0/cstdlib", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!367 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !368, file: !366, line: 128)
!368 = !DIDerivedType(tag: DW_TAG_typedef, name: "ldiv_t", file: !23, line: 70, baseType: !369)
!369 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !23, line: 66, size: 128, flags: DIFlagTypePassByValue | DIFlagTrivial, elements: !370, identifier: "_ZTS6ldiv_t")
!370 = !{!371, !372}
!371 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !369, file: !23, line: 68, baseType: !16, size: 64)
!372 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !369, file: !23, line: 69, baseType: !16, size: 64, offset: 64)
!373 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !374, file: !366, line: 130)
!374 = !DISubprogram(name: "abort", scope: !23, file: !23, line: 588, type: !375, isLocal: false, isDefinition: false, flags: DIFlagPrototyped | DIFlagNoReturn, isOptimized: true)
!375 = !DISubroutineType(types: !376)
!376 = !{null}
!377 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !378, file: !366, line: 134)
!378 = !DISubprogram(name: "atexit", scope: !23, file: !23, line: 592, type: !379, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!379 = !DISubroutineType(types: !380)
!380 = !{!7, !381}
!381 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !375, size: 64)
!382 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !383, file: !366, line: 137)
!383 = !DISubprogram(name: "at_quick_exit", scope: !23, file: !23, line: 597, type: !379, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!384 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !385, file: !366, line: 140)
!385 = !DISubprogram(name: "atof", scope: !386, file: !386, line: 25, type: !265, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!386 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdlib-float.h", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!387 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !388, file: !366, line: 141)
!388 = distinct !DISubprogram(name: "atoi", scope: !23, file: !23, line: 361, type: !389, isLocal: false, isDefinition: true, scopeLine: 362, flags: DIFlagPrototyped, isOptimized: true, unit: !2, retainedNodes: !391)
!389 = !DISubroutineType(types: !390)
!390 = !{!7, !267}
!391 = !{!392}
!392 = !DILocalVariable(name: "__nptr", arg: 1, scope: !388, file: !23, line: 361, type: !267)
!393 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !394, file: !366, line: 142)
!394 = !DISubprogram(name: "atol", scope: !23, file: !23, line: 366, type: !395, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!395 = !DISubroutineType(types: !396)
!396 = !{!16, !267}
!397 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !398, file: !366, line: 143)
!398 = !DISubprogram(name: "bsearch", scope: !399, file: !399, line: 20, type: !400, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!399 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdlib-bsearch.h", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!400 = !DISubroutineType(types: !401)
!401 = !{!402, !403, !403, !405, !405, !408}
!402 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: null, size: 64)
!403 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !404, size: 64)
!404 = !DIDerivedType(tag: DW_TAG_const_type, baseType: null)
!405 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", file: !406, line: 62, baseType: !407)
!406 = !DIFile(filename: "/home/mcopik/projects/clang_llvm/build_release/lib/clang/8.0.0/include/stddef.h", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!407 = !DIBasicType(name: "long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!408 = !DIDerivedType(tag: DW_TAG_typedef, name: "__compar_fn_t", file: !23, line: 805, baseType: !409)
!409 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !410, size: 64)
!410 = !DISubroutineType(types: !411)
!411 = !{!7, !403, !403}
!412 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !413, file: !366, line: 144)
!413 = !DISubprogram(name: "calloc", scope: !23, file: !23, line: 541, type: !414, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!414 = !DISubroutineType(types: !415)
!415 = !{!402, !405, !405}
!416 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !417, file: !366, line: 145)
!417 = !DISubprogram(name: "div", scope: !23, file: !23, line: 849, type: !418, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!418 = !DISubroutineType(types: !419)
!419 = !{!364, !7, !7}
!420 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !421, file: !366, line: 146)
!421 = !DISubprogram(name: "exit", scope: !23, file: !23, line: 614, type: !422, isLocal: false, isDefinition: false, flags: DIFlagPrototyped | DIFlagNoReturn, isOptimized: true)
!422 = !DISubroutineType(types: !423)
!423 = !{null, !7}
!424 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !425, file: !366, line: 147)
!425 = !DISubprogram(name: "free", scope: !23, file: !23, line: 563, type: !426, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!426 = !DISubroutineType(types: !427)
!427 = !{null, !402}
!428 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !429, file: !366, line: 148)
!429 = !DISubprogram(name: "getenv", scope: !23, file: !23, line: 631, type: !430, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!430 = !DISubroutineType(types: !431)
!431 = !{!9, !267}
!432 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !433, file: !366, line: 149)
!433 = !DISubprogram(name: "labs", scope: !23, file: !23, line: 838, type: !434, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!434 = !DISubroutineType(types: !435)
!435 = !{!16, !16}
!436 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !437, file: !366, line: 150)
!437 = !DISubprogram(name: "ldiv", scope: !23, file: !23, line: 851, type: !438, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!438 = !DISubroutineType(types: !439)
!439 = !{!368, !16, !16}
!440 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !441, file: !366, line: 151)
!441 = !DISubprogram(name: "malloc", scope: !23, file: !23, line: 539, type: !442, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!442 = !DISubroutineType(types: !443)
!443 = !{!402, !405}
!444 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !445, file: !366, line: 153)
!445 = !DISubprogram(name: "mblen", scope: !23, file: !23, line: 919, type: !446, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!446 = !DISubroutineType(types: !447)
!447 = !{!7, !267, !405}
!448 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !449, file: !366, line: 154)
!449 = !DISubprogram(name: "mbstowcs", scope: !23, file: !23, line: 930, type: !450, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!450 = !DISubroutineType(types: !451)
!451 = !{!405, !452, !455, !405}
!452 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !453)
!453 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !454, size: 64)
!454 = !DIBasicType(name: "wchar_t", size: 32, encoding: DW_ATE_signed)
!455 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !267)
!456 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !457, file: !366, line: 155)
!457 = !DISubprogram(name: "mbtowc", scope: !23, file: !23, line: 922, type: !458, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!458 = !DISubroutineType(types: !459)
!459 = !{!7, !452, !455, !405}
!460 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !461, file: !366, line: 157)
!461 = !DISubprogram(name: "qsort", scope: !23, file: !23, line: 827, type: !462, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!462 = !DISubroutineType(types: !463)
!463 = !{null, !402, !405, !405, !408}
!464 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !465, file: !366, line: 160)
!465 = !DISubprogram(name: "quick_exit", scope: !23, file: !23, line: 620, type: !422, isLocal: false, isDefinition: false, flags: DIFlagPrototyped | DIFlagNoReturn, isOptimized: true)
!466 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !467, file: !366, line: 163)
!467 = !DISubprogram(name: "rand", scope: !23, file: !23, line: 453, type: !468, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!468 = !DISubroutineType(types: !469)
!469 = !{!7}
!470 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !471, file: !366, line: 164)
!471 = !DISubprogram(name: "realloc", scope: !23, file: !23, line: 549, type: !472, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!472 = !DISubroutineType(types: !473)
!473 = !{!402, !402, !405}
!474 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !475, file: !366, line: 165)
!475 = !DISubprogram(name: "srand", scope: !23, file: !23, line: 455, type: !476, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!476 = !DISubroutineType(types: !477)
!477 = !{null, !478}
!478 = !DIBasicType(name: "unsigned int", size: 32, encoding: DW_ATE_unsigned)
!479 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !480, file: !366, line: 166)
!480 = !DISubprogram(name: "strtod", scope: !23, file: !23, line: 117, type: !481, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!481 = !DISubroutineType(types: !482)
!482 = !{!6, !455, !483}
!483 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !8)
!484 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !485, file: !366, line: 167)
!485 = !DISubprogram(name: "strtol", scope: !23, file: !23, line: 176, type: !486, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!486 = !DISubroutineType(types: !487)
!487 = !{!16, !455, !483, !7}
!488 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !489, file: !366, line: 168)
!489 = !DISubprogram(name: "strtoul", scope: !23, file: !23, line: 180, type: !490, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!490 = !DISubroutineType(types: !491)
!491 = !{!407, !455, !483, !7}
!492 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !493, file: !366, line: 169)
!493 = !DISubprogram(name: "system", scope: !23, file: !23, line: 781, type: !389, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!494 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !495, file: !366, line: 171)
!495 = !DISubprogram(name: "wcstombs", scope: !23, file: !23, line: 933, type: !496, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!496 = !DISubroutineType(types: !497)
!497 = !{!405, !498, !499, !405}
!498 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !9)
!499 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !500)
!500 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !501, size: 64)
!501 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !454)
!502 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !503, file: !366, line: 172)
!503 = !DISubprogram(name: "wctomb", scope: !23, file: !23, line: 926, type: !504, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!504 = !DISubroutineType(types: !505)
!505 = !{!7, !9, !454}
!506 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !507, entity: !508, file: !366, line: 200)
!507 = !DINamespace(name: "__gnu_cxx", scope: null)
!508 = !DIDerivedType(tag: DW_TAG_typedef, name: "lldiv_t", file: !23, line: 80, baseType: !509)
!509 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !23, line: 76, size: 128, flags: DIFlagTypePassByValue | DIFlagTrivial, elements: !510, identifier: "_ZTS7lldiv_t")
!510 = !{!511, !512}
!511 = !DIDerivedType(tag: DW_TAG_member, name: "quot", scope: !509, file: !23, line: 78, baseType: !212, size: 64)
!512 = !DIDerivedType(tag: DW_TAG_member, name: "rem", scope: !509, file: !23, line: 79, baseType: !212, size: 64, offset: 64)
!513 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !507, entity: !514, file: !366, line: 206)
!514 = !DISubprogram(name: "_Exit", scope: !23, file: !23, line: 626, type: !422, isLocal: false, isDefinition: false, flags: DIFlagPrototyped | DIFlagNoReturn, isOptimized: true)
!515 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !507, entity: !516, file: !366, line: 210)
!516 = !DISubprogram(name: "llabs", scope: !23, file: !23, line: 841, type: !517, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!517 = !DISubroutineType(types: !518)
!518 = !{!212, !212}
!519 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !507, entity: !520, file: !366, line: 216)
!520 = !DISubprogram(name: "lldiv", scope: !23, file: !23, line: 855, type: !521, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!521 = !DISubroutineType(types: !522)
!522 = !{!508, !212, !212}
!523 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !507, entity: !524, file: !366, line: 227)
!524 = !DISubprogram(name: "atoll", scope: !23, file: !23, line: 373, type: !525, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!525 = !DISubroutineType(types: !526)
!526 = !{!212, !267}
!527 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !507, entity: !528, file: !366, line: 228)
!528 = !DISubprogram(name: "strtoll", scope: !23, file: !23, line: 200, type: !529, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!529 = !DISubroutineType(types: !530)
!530 = !{!212, !455, !483, !7}
!531 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !507, entity: !532, file: !366, line: 229)
!532 = !DISubprogram(name: "strtoull", scope: !23, file: !23, line: 205, type: !533, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!533 = !DISubroutineType(types: !534)
!534 = !{!535, !455, !483, !7}
!535 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!536 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !507, entity: !537, file: !366, line: 231)
!537 = !DISubprogram(name: "strtof", scope: !23, file: !23, line: 123, type: !538, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!538 = !DISubroutineType(types: !539)
!539 = !{!90, !455, !483}
!540 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !507, entity: !541, file: !366, line: 232)
!541 = !DISubprogram(name: "strtold", scope: !23, file: !23, line: 126, type: !542, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!542 = !DISubroutineType(types: !543)
!543 = !{!101, !455, !483}
!544 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !508, file: !366, line: 240)
!545 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !514, file: !366, line: 242)
!546 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !516, file: !366, line: 244)
!547 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !548, file: !366, line: 245)
!548 = !DISubprogram(name: "div", linkageName: "_ZN9__gnu_cxx3divExx", scope: !507, file: !366, line: 213, type: !521, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!549 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !520, file: !366, line: 246)
!550 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !524, file: !366, line: 248)
!551 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !537, file: !366, line: 249)
!552 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !528, file: !366, line: 250)
!553 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !532, file: !366, line: 251)
!554 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !541, file: !366, line: 252)
!555 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !556, file: !571, line: 64)
!556 = !DIDerivedType(tag: DW_TAG_typedef, name: "mbstate_t", file: !557, line: 6, baseType: !558)
!557 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/mbstate_t.h", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!558 = !DIDerivedType(tag: DW_TAG_typedef, name: "__mbstate_t", file: !559, line: 21, baseType: !560)
!559 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/__mbstate_t.h", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!560 = distinct !DICompositeType(tag: DW_TAG_structure_type, file: !559, line: 13, size: 64, flags: DIFlagTypePassByValue | DIFlagTrivial, elements: !561, identifier: "_ZTS11__mbstate_t")
!561 = !{!562, !563}
!562 = !DIDerivedType(tag: DW_TAG_member, name: "__count", scope: !560, file: !559, line: 15, baseType: !7, size: 32)
!563 = !DIDerivedType(tag: DW_TAG_member, name: "__value", scope: !560, file: !559, line: 20, baseType: !564, size: 32, offset: 32)
!564 = distinct !DICompositeType(tag: DW_TAG_union_type, scope: !560, file: !559, line: 16, size: 32, flags: DIFlagTypePassByValue | DIFlagTrivial, elements: !565, identifier: "_ZTSN11__mbstate_tUt_E")
!565 = !{!566, !567}
!566 = !DIDerivedType(tag: DW_TAG_member, name: "__wch", scope: !564, file: !559, line: 18, baseType: !478, size: 32)
!567 = !DIDerivedType(tag: DW_TAG_member, name: "__wchb", scope: !564, file: !559, line: 19, baseType: !568, size: 32)
!568 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 32, elements: !569)
!569 = !{!570}
!570 = !DISubrange(count: 4)
!571 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.3.0/../../../../include/c++/7.3.0/cwchar", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!572 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !573, file: !571, line: 139)
!573 = !DIDerivedType(tag: DW_TAG_typedef, name: "wint_t", file: !574, line: 20, baseType: !478)
!574 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/wint_t.h", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!575 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !576, file: !571, line: 141)
!576 = !DISubprogram(name: "btowc", scope: !577, file: !577, line: 318, type: !578, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!577 = !DIFile(filename: "/usr/include/wchar.h", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!578 = !DISubroutineType(types: !579)
!579 = !{!573, !7}
!580 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !581, file: !571, line: 142)
!581 = !DISubprogram(name: "fgetwc", scope: !577, file: !577, line: 727, type: !582, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!582 = !DISubroutineType(types: !583)
!583 = !{!573, !584}
!584 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !585, size: 64)
!585 = !DIDerivedType(tag: DW_TAG_typedef, name: "__FILE", file: !586, line: 5, baseType: !587)
!586 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/__FILE.h", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!587 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_FILE", file: !588, line: 245, size: 1728, flags: DIFlagTypePassByValue | DIFlagTrivial, elements: !589, identifier: "_ZTS8_IO_FILE")
!588 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/libio.h", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!589 = !{!590, !591, !592, !593, !594, !595, !596, !597, !598, !599, !600, !601, !602, !605, !607, !608, !609, !612, !614, !616, !620, !623, !625, !626, !627, !628, !629, !630, !631}
!590 = !DIDerivedType(tag: DW_TAG_member, name: "_flags", scope: !587, file: !588, line: 246, baseType: !7, size: 32)
!591 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_read_ptr", scope: !587, file: !588, line: 251, baseType: !9, size: 64, offset: 64)
!592 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_read_end", scope: !587, file: !588, line: 252, baseType: !9, size: 64, offset: 128)
!593 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_read_base", scope: !587, file: !588, line: 253, baseType: !9, size: 64, offset: 192)
!594 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_write_base", scope: !587, file: !588, line: 254, baseType: !9, size: 64, offset: 256)
!595 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_write_ptr", scope: !587, file: !588, line: 255, baseType: !9, size: 64, offset: 320)
!596 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_write_end", scope: !587, file: !588, line: 256, baseType: !9, size: 64, offset: 384)
!597 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_buf_base", scope: !587, file: !588, line: 257, baseType: !9, size: 64, offset: 448)
!598 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_buf_end", scope: !587, file: !588, line: 258, baseType: !9, size: 64, offset: 512)
!599 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_save_base", scope: !587, file: !588, line: 260, baseType: !9, size: 64, offset: 576)
!600 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_backup_base", scope: !587, file: !588, line: 261, baseType: !9, size: 64, offset: 640)
!601 = !DIDerivedType(tag: DW_TAG_member, name: "_IO_save_end", scope: !587, file: !588, line: 262, baseType: !9, size: 64, offset: 704)
!602 = !DIDerivedType(tag: DW_TAG_member, name: "_markers", scope: !587, file: !588, line: 264, baseType: !603, size: 64, offset: 768)
!603 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !604, size: 64)
!604 = !DICompositeType(tag: DW_TAG_structure_type, name: "_IO_marker", file: !588, line: 160, flags: DIFlagFwdDecl, identifier: "_ZTS10_IO_marker")
!605 = !DIDerivedType(tag: DW_TAG_member, name: "_chain", scope: !587, file: !588, line: 266, baseType: !606, size: 64, offset: 832)
!606 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !587, size: 64)
!607 = !DIDerivedType(tag: DW_TAG_member, name: "_fileno", scope: !587, file: !588, line: 268, baseType: !7, size: 32, offset: 896)
!608 = !DIDerivedType(tag: DW_TAG_member, name: "_flags2", scope: !587, file: !588, line: 272, baseType: !7, size: 32, offset: 928)
!609 = !DIDerivedType(tag: DW_TAG_member, name: "_old_offset", scope: !587, file: !588, line: 274, baseType: !610, size: 64, offset: 960)
!610 = !DIDerivedType(tag: DW_TAG_typedef, name: "__off_t", file: !611, line: 140, baseType: !16)
!611 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types.h", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!612 = !DIDerivedType(tag: DW_TAG_member, name: "_cur_column", scope: !587, file: !588, line: 278, baseType: !613, size: 16, offset: 1024)
!613 = !DIBasicType(name: "unsigned short", size: 16, encoding: DW_ATE_unsigned)
!614 = !DIDerivedType(tag: DW_TAG_member, name: "_vtable_offset", scope: !587, file: !588, line: 279, baseType: !615, size: 8, offset: 1040)
!615 = !DIBasicType(name: "signed char", size: 8, encoding: DW_ATE_signed_char)
!616 = !DIDerivedType(tag: DW_TAG_member, name: "_shortbuf", scope: !587, file: !588, line: 280, baseType: !617, size: 8, offset: 1048)
!617 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 8, elements: !618)
!618 = !{!619}
!619 = !DISubrange(count: 1)
!620 = !DIDerivedType(tag: DW_TAG_member, name: "_lock", scope: !587, file: !588, line: 284, baseType: !621, size: 64, offset: 1088)
!621 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !622, size: 64)
!622 = !DIDerivedType(tag: DW_TAG_typedef, name: "_IO_lock_t", file: !588, line: 154, baseType: null)
!623 = !DIDerivedType(tag: DW_TAG_member, name: "_offset", scope: !587, file: !588, line: 293, baseType: !624, size: 64, offset: 1152)
!624 = !DIDerivedType(tag: DW_TAG_typedef, name: "__off64_t", file: !611, line: 141, baseType: !16)
!625 = !DIDerivedType(tag: DW_TAG_member, name: "__pad1", scope: !587, file: !588, line: 301, baseType: !402, size: 64, offset: 1216)
!626 = !DIDerivedType(tag: DW_TAG_member, name: "__pad2", scope: !587, file: !588, line: 302, baseType: !402, size: 64, offset: 1280)
!627 = !DIDerivedType(tag: DW_TAG_member, name: "__pad3", scope: !587, file: !588, line: 303, baseType: !402, size: 64, offset: 1344)
!628 = !DIDerivedType(tag: DW_TAG_member, name: "__pad4", scope: !587, file: !588, line: 304, baseType: !402, size: 64, offset: 1408)
!629 = !DIDerivedType(tag: DW_TAG_member, name: "__pad5", scope: !587, file: !588, line: 306, baseType: !405, size: 64, offset: 1472)
!630 = !DIDerivedType(tag: DW_TAG_member, name: "_mode", scope: !587, file: !588, line: 307, baseType: !7, size: 32, offset: 1536)
!631 = !DIDerivedType(tag: DW_TAG_member, name: "_unused2", scope: !587, file: !588, line: 309, baseType: !632, size: 160, offset: 1568)
!632 = !DICompositeType(tag: DW_TAG_array_type, baseType: !10, size: 160, elements: !633)
!633 = !{!634}
!634 = !DISubrange(count: 20)
!635 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !636, file: !571, line: 143)
!636 = !DISubprogram(name: "fgetws", scope: !577, file: !577, line: 756, type: !637, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!637 = !DISubroutineType(types: !638)
!638 = !{!453, !452, !7, !639}
!639 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !584)
!640 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !641, file: !571, line: 144)
!641 = !DISubprogram(name: "fputwc", scope: !577, file: !577, line: 741, type: !642, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!642 = !DISubroutineType(types: !643)
!643 = !{!573, !454, !584}
!644 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !645, file: !571, line: 145)
!645 = !DISubprogram(name: "fputws", scope: !577, file: !577, line: 763, type: !646, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!646 = !DISubroutineType(types: !647)
!647 = !{!7, !499, !639}
!648 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !649, file: !571, line: 146)
!649 = !DISubprogram(name: "fwide", scope: !577, file: !577, line: 573, type: !650, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!650 = !DISubroutineType(types: !651)
!651 = !{!7, !584, !7}
!652 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !653, file: !571, line: 147)
!653 = !DISubprogram(name: "fwprintf", scope: !577, file: !577, line: 580, type: !654, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!654 = !DISubroutineType(types: !655)
!655 = !{!7, !639, !499, null}
!656 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !657, file: !571, line: 148)
!657 = !DISubprogram(name: "fwscanf", scope: !577, file: !577, line: 621, type: !654, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!658 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !659, file: !571, line: 149)
!659 = !DISubprogram(name: "getwc", scope: !577, file: !577, line: 728, type: !582, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!660 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !661, file: !571, line: 150)
!661 = !DISubprogram(name: "getwchar", scope: !577, file: !577, line: 734, type: !662, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!662 = !DISubroutineType(types: !663)
!663 = !{!573}
!664 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !665, file: !571, line: 151)
!665 = !DISubprogram(name: "mbrlen", scope: !577, file: !577, line: 329, type: !666, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!666 = !DISubroutineType(types: !667)
!667 = !{!405, !455, !405, !668}
!668 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !669)
!669 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !556, size: 64)
!670 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !671, file: !571, line: 152)
!671 = !DISubprogram(name: "mbrtowc", scope: !577, file: !577, line: 296, type: !672, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!672 = !DISubroutineType(types: !673)
!673 = !{!405, !452, !455, !405, !668}
!674 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !675, file: !571, line: 153)
!675 = !DISubprogram(name: "mbsinit", scope: !577, file: !577, line: 292, type: !676, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!676 = !DISubroutineType(types: !677)
!677 = !{!7, !678}
!678 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !679, size: 64)
!679 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !556)
!680 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !681, file: !571, line: 154)
!681 = !DISubprogram(name: "mbsrtowcs", scope: !577, file: !577, line: 337, type: !682, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!682 = !DISubroutineType(types: !683)
!683 = !{!405, !452, !684, !405, !668}
!684 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !685)
!685 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !267, size: 64)
!686 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !687, file: !571, line: 155)
!687 = !DISubprogram(name: "putwc", scope: !577, file: !577, line: 742, type: !642, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!688 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !689, file: !571, line: 156)
!689 = !DISubprogram(name: "putwchar", scope: !577, file: !577, line: 748, type: !690, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!690 = !DISubroutineType(types: !691)
!691 = !{!573, !454}
!692 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !693, file: !571, line: 158)
!693 = !DISubprogram(name: "swprintf", scope: !577, file: !577, line: 590, type: !694, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!694 = !DISubroutineType(types: !695)
!695 = !{!7, !452, !405, !499, null}
!696 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !697, file: !571, line: 160)
!697 = !DISubprogram(name: "swscanf", scope: !577, file: !577, line: 631, type: !698, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!698 = !DISubroutineType(types: !699)
!699 = !{!7, !499, !499, null}
!700 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !701, file: !571, line: 161)
!701 = !DISubprogram(name: "ungetwc", scope: !577, file: !577, line: 771, type: !702, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!702 = !DISubroutineType(types: !703)
!703 = !{!573, !573, !584}
!704 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !705, file: !571, line: 162)
!705 = !DISubprogram(name: "vfwprintf", scope: !577, file: !577, line: 598, type: !706, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!706 = !DISubroutineType(types: !707)
!707 = !{!7, !639, !499, !708}
!708 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !709, size: 64)
!709 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "__va_list_tag", file: !3, size: 192, flags: DIFlagTypePassByValue | DIFlagTrivial, elements: !710, identifier: "_ZTS13__va_list_tag")
!710 = !{!711, !712, !713, !714}
!711 = !DIDerivedType(tag: DW_TAG_member, name: "gp_offset", scope: !709, file: !3, baseType: !478, size: 32)
!712 = !DIDerivedType(tag: DW_TAG_member, name: "fp_offset", scope: !709, file: !3, baseType: !478, size: 32, offset: 32)
!713 = !DIDerivedType(tag: DW_TAG_member, name: "overflow_arg_area", scope: !709, file: !3, baseType: !402, size: 64, offset: 64)
!714 = !DIDerivedType(tag: DW_TAG_member, name: "reg_save_area", scope: !709, file: !3, baseType: !402, size: 64, offset: 128)
!715 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !716, file: !571, line: 164)
!716 = !DISubprogram(name: "vfwscanf", scope: !577, file: !577, line: 673, type: !706, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!717 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !718, file: !571, line: 167)
!718 = !DISubprogram(name: "vswprintf", scope: !577, file: !577, line: 611, type: !719, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!719 = !DISubroutineType(types: !720)
!720 = !{!7, !452, !405, !499, !708}
!721 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !722, file: !571, line: 170)
!722 = !DISubprogram(name: "vswscanf", scope: !577, file: !577, line: 685, type: !723, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!723 = !DISubroutineType(types: !724)
!724 = !{!7, !499, !499, !708}
!725 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !726, file: !571, line: 172)
!726 = !DISubprogram(name: "vwprintf", scope: !577, file: !577, line: 606, type: !727, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!727 = !DISubroutineType(types: !728)
!728 = !{!7, !499, !708}
!729 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !730, file: !571, line: 174)
!730 = !DISubprogram(name: "vwscanf", scope: !577, file: !577, line: 681, type: !727, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!731 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !732, file: !571, line: 176)
!732 = !DISubprogram(name: "wcrtomb", scope: !577, file: !577, line: 301, type: !733, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!733 = !DISubroutineType(types: !734)
!734 = !{!405, !498, !454, !668}
!735 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !736, file: !571, line: 177)
!736 = !DISubprogram(name: "wcscat", scope: !577, file: !577, line: 97, type: !737, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!737 = !DISubroutineType(types: !738)
!738 = !{!453, !452, !499}
!739 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !740, file: !571, line: 178)
!740 = !DISubprogram(name: "wcscmp", scope: !577, file: !577, line: 106, type: !741, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!741 = !DISubroutineType(types: !742)
!742 = !{!7, !500, !500}
!743 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !744, file: !571, line: 179)
!744 = !DISubprogram(name: "wcscoll", scope: !577, file: !577, line: 131, type: !741, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!745 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !746, file: !571, line: 180)
!746 = !DISubprogram(name: "wcscpy", scope: !577, file: !577, line: 87, type: !737, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!747 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !748, file: !571, line: 181)
!748 = !DISubprogram(name: "wcscspn", scope: !577, file: !577, line: 187, type: !749, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!749 = !DISubroutineType(types: !750)
!750 = !{!405, !500, !500}
!751 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !752, file: !571, line: 182)
!752 = !DISubprogram(name: "wcsftime", scope: !577, file: !577, line: 835, type: !753, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!753 = !DISubroutineType(types: !754)
!754 = !{!405, !452, !405, !499, !755}
!755 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !756)
!756 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !757, size: 64)
!757 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !758)
!758 = !DICompositeType(tag: DW_TAG_structure_type, name: "tm", file: !577, line: 83, flags: DIFlagFwdDecl, identifier: "_ZTS2tm")
!759 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !760, file: !571, line: 183)
!760 = !DISubprogram(name: "wcslen", scope: !577, file: !577, line: 222, type: !761, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!761 = !DISubroutineType(types: !762)
!762 = !{!405, !500}
!763 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !764, file: !571, line: 184)
!764 = !DISubprogram(name: "wcsncat", scope: !577, file: !577, line: 101, type: !765, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!765 = !DISubroutineType(types: !766)
!766 = !{!453, !452, !499, !405}
!767 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !768, file: !571, line: 185)
!768 = !DISubprogram(name: "wcsncmp", scope: !577, file: !577, line: 109, type: !769, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!769 = !DISubroutineType(types: !770)
!770 = !{!7, !500, !500, !405}
!771 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !772, file: !571, line: 186)
!772 = !DISubprogram(name: "wcsncpy", scope: !577, file: !577, line: 92, type: !765, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!773 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !774, file: !571, line: 187)
!774 = !DISubprogram(name: "wcsrtombs", scope: !577, file: !577, line: 343, type: !775, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!775 = !DISubroutineType(types: !776)
!776 = !{!405, !498, !777, !405, !668}
!777 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !778)
!778 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !500, size: 64)
!779 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !780, file: !571, line: 188)
!780 = !DISubprogram(name: "wcsspn", scope: !577, file: !577, line: 191, type: !749, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!781 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !782, file: !571, line: 189)
!782 = !DISubprogram(name: "wcstod", scope: !577, file: !577, line: 377, type: !783, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!783 = !DISubroutineType(types: !784)
!784 = !{!6, !499, !785}
!785 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !786)
!786 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !453, size: 64)
!787 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !788, file: !571, line: 191)
!788 = !DISubprogram(name: "wcstof", scope: !577, file: !577, line: 382, type: !789, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!789 = !DISubroutineType(types: !790)
!790 = !{!90, !499, !785}
!791 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !792, file: !571, line: 193)
!792 = !DISubprogram(name: "wcstok", scope: !577, file: !577, line: 217, type: !793, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!793 = !DISubroutineType(types: !794)
!794 = !{!453, !452, !499, !785}
!795 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !796, file: !571, line: 194)
!796 = !DISubprogram(name: "wcstol", scope: !577, file: !577, line: 428, type: !797, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!797 = !DISubroutineType(types: !798)
!798 = !{!16, !499, !785, !7}
!799 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !800, file: !571, line: 195)
!800 = !DISubprogram(name: "wcstoul", scope: !577, file: !577, line: 433, type: !801, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!801 = !DISubroutineType(types: !802)
!802 = !{!407, !499, !785, !7}
!803 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !804, file: !571, line: 196)
!804 = !DISubprogram(name: "wcsxfrm", scope: !577, file: !577, line: 135, type: !805, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!805 = !DISubroutineType(types: !806)
!806 = !{!405, !452, !499, !405}
!807 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !808, file: !571, line: 197)
!808 = !DISubprogram(name: "wctob", scope: !577, file: !577, line: 324, type: !809, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!809 = !DISubroutineType(types: !810)
!810 = !{!7, !573}
!811 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !812, file: !571, line: 198)
!812 = !DISubprogram(name: "wmemcmp", scope: !577, file: !577, line: 258, type: !769, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!813 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !814, file: !571, line: 199)
!814 = !DISubprogram(name: "wmemcpy", scope: !577, file: !577, line: 262, type: !765, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!815 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !816, file: !571, line: 200)
!816 = !DISubprogram(name: "wmemmove", scope: !577, file: !577, line: 267, type: !817, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!817 = !DISubroutineType(types: !818)
!818 = !{!453, !453, !500, !405}
!819 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !820, file: !571, line: 201)
!820 = !DISubprogram(name: "wmemset", scope: !577, file: !577, line: 271, type: !821, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!821 = !DISubroutineType(types: !822)
!822 = !{!453, !453, !454, !405}
!823 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !824, file: !571, line: 202)
!824 = !DISubprogram(name: "wprintf", scope: !577, file: !577, line: 587, type: !825, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!825 = !DISubroutineType(types: !826)
!826 = !{!7, !499, null}
!827 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !828, file: !571, line: 203)
!828 = !DISubprogram(name: "wscanf", scope: !577, file: !577, line: 628, type: !825, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!829 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !830, file: !571, line: 204)
!830 = !DISubprogram(name: "wcschr", scope: !577, file: !577, line: 164, type: !831, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!831 = !DISubroutineType(types: !832)
!832 = !{!453, !500, !454}
!833 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !834, file: !571, line: 205)
!834 = !DISubprogram(name: "wcspbrk", scope: !577, file: !577, line: 201, type: !835, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!835 = !DISubroutineType(types: !836)
!836 = !{!453, !500, !500}
!837 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !838, file: !571, line: 206)
!838 = !DISubprogram(name: "wcsrchr", scope: !577, file: !577, line: 174, type: !831, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!839 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !840, file: !571, line: 207)
!840 = !DISubprogram(name: "wcsstr", scope: !577, file: !577, line: 212, type: !835, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!841 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !842, file: !571, line: 208)
!842 = !DISubprogram(name: "wmemchr", scope: !577, file: !577, line: 253, type: !843, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!843 = !DISubroutineType(types: !844)
!844 = !{!453, !500, !454, !405}
!845 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !507, entity: !846, file: !571, line: 248)
!846 = !DISubprogram(name: "wcstold", scope: !577, file: !577, line: 384, type: !847, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!847 = !DISubroutineType(types: !848)
!848 = !{!101, !499, !785}
!849 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !507, entity: !850, file: !571, line: 257)
!850 = !DISubprogram(name: "wcstoll", scope: !577, file: !577, line: 441, type: !851, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!851 = !DISubroutineType(types: !852)
!852 = !{!212, !499, !785, !7}
!853 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !507, entity: !854, file: !571, line: 258)
!854 = !DISubprogram(name: "wcstoull", scope: !577, file: !577, line: 448, type: !855, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!855 = !DISubroutineType(types: !856)
!856 = !{!535, !499, !785, !7}
!857 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !846, file: !571, line: 264)
!858 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !850, file: !571, line: 265)
!859 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !854, file: !571, line: 266)
!860 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !788, file: !571, line: 280)
!861 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !716, file: !571, line: 283)
!862 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !722, file: !571, line: 286)
!863 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !730, file: !571, line: 289)
!864 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !846, file: !571, line: 293)
!865 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !850, file: !571, line: 294)
!866 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !854, file: !571, line: 295)
!867 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !868, file: !869, line: 57)
!868 = distinct !DICompositeType(tag: DW_TAG_class_type, name: "exception_ptr", scope: !870, file: !869, line: 79, size: 64, flags: DIFlagTypePassByReference, elements: !871, identifier: "_ZTSNSt15__exception_ptr13exception_ptrE")
!869 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.3.0/../../../../include/c++/7.3.0/bits/exception_ptr.h", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!870 = !DINamespace(name: "__exception_ptr", scope: !13)
!871 = !{!872, !873, !877, !880, !881, !886, !887, !891, !896, !900, !904, !907, !908, !911, !915}
!872 = !DIDerivedType(tag: DW_TAG_member, name: "_M_exception_object", scope: !868, file: !869, line: 81, baseType: !402, size: 64)
!873 = !DISubprogram(name: "exception_ptr", scope: !868, file: !869, line: 83, type: !874, isLocal: false, isDefinition: false, scopeLine: 83, flags: DIFlagExplicit | DIFlagPrototyped, isOptimized: true)
!874 = !DISubroutineType(types: !875)
!875 = !{null, !876, !402}
!876 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !868, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!877 = !DISubprogram(name: "_M_addref", linkageName: "_ZNSt15__exception_ptr13exception_ptr9_M_addrefEv", scope: !868, file: !869, line: 85, type: !878, isLocal: false, isDefinition: false, scopeLine: 85, flags: DIFlagPrototyped, isOptimized: true)
!878 = !DISubroutineType(types: !879)
!879 = !{null, !876}
!880 = !DISubprogram(name: "_M_release", linkageName: "_ZNSt15__exception_ptr13exception_ptr10_M_releaseEv", scope: !868, file: !869, line: 86, type: !878, isLocal: false, isDefinition: false, scopeLine: 86, flags: DIFlagPrototyped, isOptimized: true)
!881 = !DISubprogram(name: "_M_get", linkageName: "_ZNKSt15__exception_ptr13exception_ptr6_M_getEv", scope: !868, file: !869, line: 88, type: !882, isLocal: false, isDefinition: false, scopeLine: 88, flags: DIFlagPrototyped, isOptimized: true)
!882 = !DISubroutineType(types: !883)
!883 = !{!402, !884}
!884 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !885, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!885 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !868)
!886 = !DISubprogram(name: "exception_ptr", scope: !868, file: !869, line: 96, type: !878, isLocal: false, isDefinition: false, scopeLine: 96, flags: DIFlagPublic | DIFlagPrototyped, isOptimized: true)
!887 = !DISubprogram(name: "exception_ptr", scope: !868, file: !869, line: 98, type: !888, isLocal: false, isDefinition: false, scopeLine: 98, flags: DIFlagPublic | DIFlagPrototyped, isOptimized: true)
!888 = !DISubroutineType(types: !889)
!889 = !{null, !876, !890}
!890 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !885, size: 64)
!891 = !DISubprogram(name: "exception_ptr", scope: !868, file: !869, line: 101, type: !892, isLocal: false, isDefinition: false, scopeLine: 101, flags: DIFlagPublic | DIFlagPrototyped, isOptimized: true)
!892 = !DISubroutineType(types: !893)
!893 = !{null, !876, !894}
!894 = !DIDerivedType(tag: DW_TAG_typedef, name: "nullptr_t", scope: !13, file: !15, line: 235, baseType: !895)
!895 = !DIBasicType(tag: DW_TAG_unspecified_type, name: "decltype(nullptr)")
!896 = !DISubprogram(name: "exception_ptr", scope: !868, file: !869, line: 105, type: !897, isLocal: false, isDefinition: false, scopeLine: 105, flags: DIFlagPublic | DIFlagPrototyped, isOptimized: true)
!897 = !DISubroutineType(types: !898)
!898 = !{null, !876, !899}
!899 = !DIDerivedType(tag: DW_TAG_rvalue_reference_type, baseType: !868, size: 64)
!900 = !DISubprogram(name: "operator=", linkageName: "_ZNSt15__exception_ptr13exception_ptraSERKS0_", scope: !868, file: !869, line: 118, type: !901, isLocal: false, isDefinition: false, scopeLine: 118, flags: DIFlagPublic | DIFlagPrototyped, isOptimized: true)
!901 = !DISubroutineType(types: !902)
!902 = !{!903, !876, !890}
!903 = !DIDerivedType(tag: DW_TAG_reference_type, baseType: !868, size: 64)
!904 = !DISubprogram(name: "operator=", linkageName: "_ZNSt15__exception_ptr13exception_ptraSEOS0_", scope: !868, file: !869, line: 122, type: !905, isLocal: false, isDefinition: false, scopeLine: 122, flags: DIFlagPublic | DIFlagPrototyped, isOptimized: true)
!905 = !DISubroutineType(types: !906)
!906 = !{!903, !876, !899}
!907 = !DISubprogram(name: "~exception_ptr", scope: !868, file: !869, line: 129, type: !878, isLocal: false, isDefinition: false, scopeLine: 129, flags: DIFlagPublic | DIFlagPrototyped, isOptimized: true)
!908 = !DISubprogram(name: "swap", linkageName: "_ZNSt15__exception_ptr13exception_ptr4swapERS0_", scope: !868, file: !869, line: 132, type: !909, isLocal: false, isDefinition: false, scopeLine: 132, flags: DIFlagPublic | DIFlagPrototyped, isOptimized: true)
!909 = !DISubroutineType(types: !910)
!910 = !{null, !876, !903}
!911 = !DISubprogram(name: "operator bool", linkageName: "_ZNKSt15__exception_ptr13exception_ptrcvbEv", scope: !868, file: !869, line: 144, type: !912, isLocal: false, isDefinition: false, scopeLine: 144, flags: DIFlagPublic | DIFlagExplicit | DIFlagPrototyped, isOptimized: true)
!912 = !DISubroutineType(types: !913)
!913 = !{!914, !884}
!914 = !DIBasicType(name: "bool", size: 8, encoding: DW_ATE_boolean)
!915 = !DISubprogram(name: "__cxa_exception_type", linkageName: "_ZNKSt15__exception_ptr13exception_ptr20__cxa_exception_typeEv", scope: !868, file: !869, line: 153, type: !916, isLocal: false, isDefinition: false, scopeLine: 153, flags: DIFlagPublic | DIFlagPrototyped, isOptimized: true)
!916 = !DISubroutineType(types: !917)
!917 = !{!918, !884}
!918 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !919, size: 64)
!919 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !920)
!920 = !DICompositeType(tag: DW_TAG_class_type, name: "type_info", scope: !13, file: !921, line: 88, flags: DIFlagFwdDecl, identifier: "_ZTSSt9type_info")
!921 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.3.0/../../../../include/c++/7.3.0/typeinfo", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!922 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !870, entity: !923, file: !869, line: 73)
!923 = !DISubprogram(name: "rethrow_exception", linkageName: "_ZSt17rethrow_exceptionNSt15__exception_ptr13exception_ptrE", scope: !13, file: !869, line: 69, type: !924, isLocal: false, isDefinition: false, flags: DIFlagPrototyped | DIFlagNoReturn, isOptimized: true)
!924 = !DISubroutineType(types: !925)
!925 = !{null, !868}
!926 = !DIImportedEntity(tag: DW_TAG_imported_module, scope: !927, entity: !928, file: !929, line: 58)
!927 = !DINamespace(name: "__gnu_debug", scope: null)
!928 = !DINamespace(name: "__debug", scope: !13)
!929 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.3.0/../../../../include/c++/7.3.0/debug/debug.h", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!930 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !931, file: !934, line: 48)
!931 = !DIDerivedType(tag: DW_TAG_typedef, name: "int8_t", file: !932, line: 24, baseType: !933)
!932 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-intn.h", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!933 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int8_t", file: !611, line: 36, baseType: !615)
!934 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.3.0/../../../../include/c++/7.3.0/cstdint", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!935 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !936, file: !934, line: 49)
!936 = !DIDerivedType(tag: DW_TAG_typedef, name: "int16_t", file: !932, line: 25, baseType: !937)
!937 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int16_t", file: !611, line: 38, baseType: !938)
!938 = !DIBasicType(name: "short", size: 16, encoding: DW_ATE_signed)
!939 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !940, file: !934, line: 50)
!940 = !DIDerivedType(tag: DW_TAG_typedef, name: "int32_t", file: !932, line: 26, baseType: !941)
!941 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int32_t", file: !611, line: 40, baseType: !7)
!942 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !943, file: !934, line: 51)
!943 = !DIDerivedType(tag: DW_TAG_typedef, name: "int64_t", file: !932, line: 27, baseType: !944)
!944 = !DIDerivedType(tag: DW_TAG_typedef, name: "__int64_t", file: !611, line: 43, baseType: !16)
!945 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !946, file: !934, line: 53)
!946 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast8_t", file: !947, line: 68, baseType: !615)
!947 = !DIFile(filename: "/usr/include/stdint.h", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!948 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !949, file: !934, line: 54)
!949 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast16_t", file: !947, line: 70, baseType: !16)
!950 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !951, file: !934, line: 55)
!951 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast32_t", file: !947, line: 71, baseType: !16)
!952 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !953, file: !934, line: 56)
!953 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_fast64_t", file: !947, line: 72, baseType: !16)
!954 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !955, file: !934, line: 58)
!955 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least8_t", file: !947, line: 43, baseType: !615)
!956 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !957, file: !934, line: 59)
!957 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least16_t", file: !947, line: 44, baseType: !938)
!958 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !959, file: !934, line: 60)
!959 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least32_t", file: !947, line: 45, baseType: !7)
!960 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !961, file: !934, line: 61)
!961 = !DIDerivedType(tag: DW_TAG_typedef, name: "int_least64_t", file: !947, line: 47, baseType: !16)
!962 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !963, file: !934, line: 63)
!963 = !DIDerivedType(tag: DW_TAG_typedef, name: "intmax_t", file: !947, line: 111, baseType: !964)
!964 = !DIDerivedType(tag: DW_TAG_typedef, name: "__intmax_t", file: !611, line: 61, baseType: !16)
!965 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !966, file: !934, line: 64)
!966 = !DIDerivedType(tag: DW_TAG_typedef, name: "intptr_t", file: !947, line: 97, baseType: !16)
!967 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !968, file: !934, line: 66)
!968 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint8_t", file: !969, line: 24, baseType: !970)
!969 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdint-uintn.h", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!970 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint8_t", file: !611, line: 37, baseType: !971)
!971 = !DIBasicType(name: "unsigned char", size: 8, encoding: DW_ATE_unsigned_char)
!972 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !973, file: !934, line: 67)
!973 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint16_t", file: !969, line: 25, baseType: !974)
!974 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint16_t", file: !611, line: 39, baseType: !613)
!975 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !976, file: !934, line: 68)
!976 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint32_t", file: !969, line: 26, baseType: !977)
!977 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint32_t", file: !611, line: 41, baseType: !478)
!978 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !979, file: !934, line: 69)
!979 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint64_t", file: !969, line: 27, baseType: !980)
!980 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uint64_t", file: !611, line: 44, baseType: !407)
!981 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !982, file: !934, line: 71)
!982 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast8_t", file: !947, line: 81, baseType: !971)
!983 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !984, file: !934, line: 72)
!984 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast16_t", file: !947, line: 83, baseType: !407)
!985 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !986, file: !934, line: 73)
!986 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast32_t", file: !947, line: 84, baseType: !407)
!987 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !988, file: !934, line: 74)
!988 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_fast64_t", file: !947, line: 85, baseType: !407)
!989 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !990, file: !934, line: 76)
!990 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least8_t", file: !947, line: 54, baseType: !971)
!991 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !992, file: !934, line: 77)
!992 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least16_t", file: !947, line: 55, baseType: !613)
!993 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !994, file: !934, line: 78)
!994 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least32_t", file: !947, line: 56, baseType: !478)
!995 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !996, file: !934, line: 79)
!996 = !DIDerivedType(tag: DW_TAG_typedef, name: "uint_least64_t", file: !947, line: 58, baseType: !407)
!997 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !998, file: !934, line: 81)
!998 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintmax_t", file: !947, line: 112, baseType: !999)
!999 = !DIDerivedType(tag: DW_TAG_typedef, name: "__uintmax_t", file: !611, line: 62, baseType: !407)
!1000 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1001, file: !934, line: 82)
!1001 = !DIDerivedType(tag: DW_TAG_typedef, name: "uintptr_t", file: !947, line: 100, baseType: !407)
!1002 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1003, file: !1005, line: 53)
!1003 = !DICompositeType(tag: DW_TAG_structure_type, name: "lconv", file: !1004, line: 51, flags: DIFlagFwdDecl, identifier: "_ZTS5lconv")
!1004 = !DIFile(filename: "/usr/include/locale.h", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!1005 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.3.0/../../../../include/c++/7.3.0/clocale", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!1006 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1007, file: !1005, line: 54)
!1007 = !DISubprogram(name: "setlocale", scope: !1004, file: !1004, line: 122, type: !1008, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1008 = !DISubroutineType(types: !1009)
!1009 = !{!9, !7, !267}
!1010 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1011, file: !1005, line: 55)
!1011 = !DISubprogram(name: "localeconv", scope: !1004, file: !1004, line: 125, type: !1012, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1012 = !DISubroutineType(types: !1013)
!1013 = !{!1014}
!1014 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1003, size: 64)
!1015 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1016, file: !1018, line: 64)
!1016 = !DISubprogram(name: "isalnum", scope: !1017, file: !1017, line: 108, type: !24, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1017 = !DIFile(filename: "/usr/include/ctype.h", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!1018 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.3.0/../../../../include/c++/7.3.0/cctype", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!1019 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1020, file: !1018, line: 65)
!1020 = !DISubprogram(name: "isalpha", scope: !1017, file: !1017, line: 109, type: !24, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1021 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1022, file: !1018, line: 66)
!1022 = !DISubprogram(name: "iscntrl", scope: !1017, file: !1017, line: 110, type: !24, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1023 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1024, file: !1018, line: 67)
!1024 = !DISubprogram(name: "isdigit", scope: !1017, file: !1017, line: 111, type: !24, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1025 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1026, file: !1018, line: 68)
!1026 = !DISubprogram(name: "isgraph", scope: !1017, file: !1017, line: 113, type: !24, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1027 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1028, file: !1018, line: 69)
!1028 = !DISubprogram(name: "islower", scope: !1017, file: !1017, line: 112, type: !24, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1029 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1030, file: !1018, line: 70)
!1030 = !DISubprogram(name: "isprint", scope: !1017, file: !1017, line: 114, type: !24, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1031 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1032, file: !1018, line: 71)
!1032 = !DISubprogram(name: "ispunct", scope: !1017, file: !1017, line: 115, type: !24, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1033 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1034, file: !1018, line: 72)
!1034 = !DISubprogram(name: "isspace", scope: !1017, file: !1017, line: 116, type: !24, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1035 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1036, file: !1018, line: 73)
!1036 = !DISubprogram(name: "isupper", scope: !1017, file: !1017, line: 117, type: !24, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1037 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1038, file: !1018, line: 74)
!1038 = !DISubprogram(name: "isxdigit", scope: !1017, file: !1017, line: 118, type: !24, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1039 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1040, file: !1018, line: 75)
!1040 = !DISubprogram(name: "tolower", scope: !1017, file: !1017, line: 122, type: !24, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1041 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1042, file: !1018, line: 76)
!1042 = !DISubprogram(name: "toupper", scope: !1017, file: !1017, line: 125, type: !24, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1043 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1044, file: !1018, line: 87)
!1044 = !DISubprogram(name: "isblank", scope: !1017, file: !1017, line: 130, type: !24, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1045 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !507, entity: !1046, file: !1047, line: 44)
!1046 = !DIDerivedType(tag: DW_TAG_typedef, name: "size_t", scope: !13, file: !15, line: 231, baseType: !407)
!1047 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.3.0/../../../../include/c++/7.3.0/ext/new_allocator.h", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!1048 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !507, entity: !14, file: !1047, line: 45)
!1049 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1050, file: !1052, line: 98)
!1050 = !DIDerivedType(tag: DW_TAG_typedef, name: "FILE", file: !1051, line: 7, baseType: !587)
!1051 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/types/FILE.h", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!1052 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.3.0/../../../../include/c++/7.3.0/cstdio", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!1053 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1054, file: !1052, line: 99)
!1054 = !DIDerivedType(tag: DW_TAG_typedef, name: "fpos_t", file: !1055, line: 78, baseType: !1056)
!1055 = !DIFile(filename: "/usr/include/stdio.h", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!1056 = !DIDerivedType(tag: DW_TAG_typedef, name: "_G_fpos_t", file: !1057, line: 30, baseType: !1058)
!1057 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/_G_config.h", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!1058 = !DICompositeType(tag: DW_TAG_structure_type, file: !1057, line: 26, flags: DIFlagFwdDecl, identifier: "_ZTS9_G_fpos_t")
!1059 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1060, file: !1052, line: 101)
!1060 = !DISubprogram(name: "clearerr", scope: !1055, file: !1055, line: 757, type: !1061, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1061 = !DISubroutineType(types: !1062)
!1062 = !{null, !1063}
!1063 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1050, size: 64)
!1064 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1065, file: !1052, line: 102)
!1065 = !DISubprogram(name: "fclose", scope: !1055, file: !1055, line: 199, type: !1066, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1066 = !DISubroutineType(types: !1067)
!1067 = !{!7, !1063}
!1068 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1069, file: !1052, line: 103)
!1069 = !DISubprogram(name: "feof", scope: !1055, file: !1055, line: 759, type: !1066, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1070 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1071, file: !1052, line: 104)
!1071 = !DISubprogram(name: "ferror", scope: !1055, file: !1055, line: 761, type: !1066, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1072 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1073, file: !1052, line: 105)
!1073 = !DISubprogram(name: "fflush", scope: !1055, file: !1055, line: 204, type: !1066, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1074 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1075, file: !1052, line: 106)
!1075 = !DISubprogram(name: "fgetc", scope: !1055, file: !1055, line: 477, type: !1066, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1076 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1077, file: !1052, line: 107)
!1077 = !DISubprogram(name: "fgetpos", scope: !1055, file: !1055, line: 731, type: !1078, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1078 = !DISubroutineType(types: !1079)
!1079 = !{!7, !1080, !1081}
!1080 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !1063)
!1081 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !1082)
!1082 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1054, size: 64)
!1083 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1084, file: !1052, line: 108)
!1084 = !DISubprogram(name: "fgets", scope: !1055, file: !1055, line: 564, type: !1085, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1085 = !DISubroutineType(types: !1086)
!1086 = !{!9, !498, !7, !1080}
!1087 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1088, file: !1052, line: 109)
!1088 = !DISubprogram(name: "fopen", scope: !1055, file: !1055, line: 232, type: !1089, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1089 = !DISubroutineType(types: !1090)
!1090 = !{!1063, !455, !455}
!1091 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1092, file: !1052, line: 110)
!1092 = !DISubprogram(name: "fprintf", scope: !1055, file: !1055, line: 312, type: !1093, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1093 = !DISubroutineType(types: !1094)
!1094 = !{!7, !1080, !455, null}
!1095 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1096, file: !1052, line: 111)
!1096 = !DISubprogram(name: "fputc", scope: !1055, file: !1055, line: 517, type: !1097, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1097 = !DISubroutineType(types: !1098)
!1098 = !{!7, !7, !1063}
!1099 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1100, file: !1052, line: 112)
!1100 = !DISubprogram(name: "fputs", scope: !1055, file: !1055, line: 626, type: !1101, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1101 = !DISubroutineType(types: !1102)
!1102 = !{!7, !455, !1080}
!1103 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1104, file: !1052, line: 113)
!1104 = !DISubprogram(name: "fread", scope: !1055, file: !1055, line: 646, type: !1105, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1105 = !DISubroutineType(types: !1106)
!1106 = !{!405, !1107, !405, !405, !1080}
!1107 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !402)
!1108 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1109, file: !1052, line: 114)
!1109 = !DISubprogram(name: "freopen", scope: !1055, file: !1055, line: 238, type: !1110, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1110 = !DISubroutineType(types: !1111)
!1111 = !{!1063, !455, !455, !1080}
!1112 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1113, file: !1052, line: 115)
!1113 = !DISubprogram(name: "fscanf", scope: !1055, file: !1055, line: 377, type: !1093, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1114 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1115, file: !1052, line: 116)
!1115 = !DISubprogram(name: "fseek", scope: !1055, file: !1055, line: 684, type: !1116, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1116 = !DISubroutineType(types: !1117)
!1117 = !{!7, !1063, !16, !7}
!1118 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1119, file: !1052, line: 117)
!1119 = !DISubprogram(name: "fsetpos", scope: !1055, file: !1055, line: 736, type: !1120, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1120 = !DISubroutineType(types: !1121)
!1121 = !{!7, !1063, !1122}
!1122 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1123, size: 64)
!1123 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !1054)
!1124 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1125, file: !1052, line: 118)
!1125 = !DISubprogram(name: "ftell", scope: !1055, file: !1055, line: 689, type: !1126, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1126 = !DISubroutineType(types: !1127)
!1127 = !{!16, !1063}
!1128 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1129, file: !1052, line: 119)
!1129 = !DISubprogram(name: "fwrite", scope: !1055, file: !1055, line: 652, type: !1130, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1130 = !DISubroutineType(types: !1131)
!1131 = !{!405, !1132, !405, !405, !1080}
!1132 = !DIDerivedType(tag: DW_TAG_restrict_type, baseType: !403)
!1133 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1134, file: !1052, line: 120)
!1134 = !DISubprogram(name: "getc", scope: !1055, file: !1055, line: 478, type: !1066, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1135 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1136, file: !1052, line: 121)
!1136 = !DISubprogram(name: "getchar", scope: !1137, file: !1137, line: 44, type: !468, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1137 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/stdio.h", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!1138 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1139, file: !1052, line: 126)
!1139 = !DISubprogram(name: "perror", scope: !1055, file: !1055, line: 775, type: !1140, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1140 = !DISubroutineType(types: !1141)
!1141 = !{null, !267}
!1142 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1143, file: !1052, line: 127)
!1143 = !DISubprogram(name: "printf", scope: !1055, file: !1055, line: 318, type: !1144, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1144 = !DISubroutineType(types: !1145)
!1145 = !{!7, !455, null}
!1146 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1147, file: !1052, line: 128)
!1147 = !DISubprogram(name: "putc", scope: !1055, file: !1055, line: 518, type: !1097, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1148 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1149, file: !1052, line: 129)
!1149 = !DISubprogram(name: "putchar", scope: !1137, file: !1137, line: 79, type: !24, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1150 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1151, file: !1052, line: 130)
!1151 = !DISubprogram(name: "puts", scope: !1055, file: !1055, line: 632, type: !389, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1152 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1153, file: !1052, line: 131)
!1153 = !DISubprogram(name: "remove", scope: !1055, file: !1055, line: 144, type: !389, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1154 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1155, file: !1052, line: 132)
!1155 = !DISubprogram(name: "rename", scope: !1055, file: !1055, line: 146, type: !1156, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1156 = !DISubroutineType(types: !1157)
!1157 = !{!7, !267, !267}
!1158 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1159, file: !1052, line: 133)
!1159 = !DISubprogram(name: "rewind", scope: !1055, file: !1055, line: 694, type: !1061, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1160 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1161, file: !1052, line: 134)
!1161 = !DISubprogram(name: "scanf", scope: !1055, file: !1055, line: 383, type: !1144, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1162 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1163, file: !1052, line: 135)
!1163 = !DISubprogram(name: "setbuf", scope: !1055, file: !1055, line: 290, type: !1164, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1164 = !DISubroutineType(types: !1165)
!1165 = !{null, !1080, !498}
!1166 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1167, file: !1052, line: 136)
!1167 = !DISubprogram(name: "setvbuf", scope: !1055, file: !1055, line: 294, type: !1168, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1168 = !DISubroutineType(types: !1169)
!1169 = !{!7, !1080, !498, !7, !405}
!1170 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1171, file: !1052, line: 137)
!1171 = !DISubprogram(name: "sprintf", scope: !1055, file: !1055, line: 320, type: !1172, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1172 = !DISubroutineType(types: !1173)
!1173 = !{!7, !498, !455, null}
!1174 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1175, file: !1052, line: 138)
!1175 = !DISubprogram(name: "sscanf", scope: !1055, file: !1055, line: 385, type: !1176, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1176 = !DISubroutineType(types: !1177)
!1177 = !{!7, !455, !455, null}
!1178 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1179, file: !1052, line: 139)
!1179 = !DISubprogram(name: "tmpfile", scope: !1055, file: !1055, line: 159, type: !1180, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1180 = !DISubroutineType(types: !1181)
!1181 = !{!1063}
!1182 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1183, file: !1052, line: 141)
!1183 = !DISubprogram(name: "tmpnam", scope: !1055, file: !1055, line: 173, type: !1184, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1184 = !DISubroutineType(types: !1185)
!1185 = !{!9, !9}
!1186 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1187, file: !1052, line: 143)
!1187 = !DISubprogram(name: "ungetc", scope: !1055, file: !1055, line: 639, type: !1097, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1188 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1189, file: !1052, line: 144)
!1189 = !DISubprogram(name: "vfprintf", scope: !1055, file: !1055, line: 327, type: !1190, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1190 = !DISubroutineType(types: !1191)
!1191 = !{!7, !1080, !455, !708}
!1192 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1193, file: !1052, line: 145)
!1193 = !DISubprogram(name: "vprintf", scope: !1137, file: !1137, line: 36, type: !1194, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1194 = !DISubroutineType(types: !1195)
!1195 = !{!7, !455, !708}
!1196 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1197, file: !1052, line: 146)
!1197 = !DISubprogram(name: "vsprintf", scope: !1055, file: !1055, line: 335, type: !1198, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1198 = !DISubroutineType(types: !1199)
!1199 = !{!7, !498, !455, !708}
!1200 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !507, entity: !1201, file: !1052, line: 175)
!1201 = !DISubprogram(name: "snprintf", scope: !1055, file: !1055, line: 340, type: !1202, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1202 = !DISubroutineType(types: !1203)
!1203 = !{!7, !498, !405, !455, null}
!1204 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !507, entity: !1205, file: !1052, line: 176)
!1205 = !DISubprogram(name: "vfscanf", scope: !1055, file: !1055, line: 420, type: !1190, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1206 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !507, entity: !1207, file: !1052, line: 177)
!1207 = !DISubprogram(name: "vscanf", scope: !1055, file: !1055, line: 428, type: !1194, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1208 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !507, entity: !1209, file: !1052, line: 178)
!1209 = !DISubprogram(name: "vsnprintf", scope: !1055, file: !1055, line: 344, type: !1210, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1210 = !DISubroutineType(types: !1211)
!1211 = !{!7, !498, !405, !455, !708}
!1212 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !507, entity: !1213, file: !1052, line: 179)
!1213 = !DISubprogram(name: "vsscanf", scope: !1055, file: !1055, line: 432, type: !1214, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1214 = !DISubroutineType(types: !1215)
!1215 = !{!7, !455, !455, !708}
!1216 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1201, file: !1052, line: 185)
!1217 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1205, file: !1052, line: 186)
!1218 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1207, file: !1052, line: 187)
!1219 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1209, file: !1052, line: 188)
!1220 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1213, file: !1052, line: 189)
!1221 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1222, file: !1226, line: 82)
!1222 = !DIDerivedType(tag: DW_TAG_typedef, name: "wctrans_t", file: !1223, line: 48, baseType: !1224)
!1223 = !DIFile(filename: "/usr/include/wctype.h", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!1224 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1225, size: 64)
!1225 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !941)
!1226 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.3.0/../../../../include/c++/7.3.0/cwctype", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!1227 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1228, file: !1226, line: 83)
!1228 = !DIDerivedType(tag: DW_TAG_typedef, name: "wctype_t", file: !1229, line: 38, baseType: !407)
!1229 = !DIFile(filename: "/usr/include/x86_64-linux-gnu/bits/wctype-wchar.h", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!1230 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !573, file: !1226, line: 84)
!1231 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1232, file: !1226, line: 86)
!1232 = !DISubprogram(name: "iswalnum", scope: !1229, file: !1229, line: 95, type: !809, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1233 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1234, file: !1226, line: 87)
!1234 = !DISubprogram(name: "iswalpha", scope: !1229, file: !1229, line: 101, type: !809, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1235 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1236, file: !1226, line: 89)
!1236 = !DISubprogram(name: "iswblank", scope: !1229, file: !1229, line: 146, type: !809, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1237 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1238, file: !1226, line: 91)
!1238 = !DISubprogram(name: "iswcntrl", scope: !1229, file: !1229, line: 104, type: !809, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1239 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1240, file: !1226, line: 92)
!1240 = !DISubprogram(name: "iswctype", scope: !1229, file: !1229, line: 159, type: !1241, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1241 = !DISubroutineType(types: !1242)
!1242 = !{!7, !573, !1228}
!1243 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1244, file: !1226, line: 93)
!1244 = !DISubprogram(name: "iswdigit", scope: !1229, file: !1229, line: 108, type: !809, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1245 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1246, file: !1226, line: 94)
!1246 = !DISubprogram(name: "iswgraph", scope: !1229, file: !1229, line: 112, type: !809, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1247 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1248, file: !1226, line: 95)
!1248 = !DISubprogram(name: "iswlower", scope: !1229, file: !1229, line: 117, type: !809, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1249 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1250, file: !1226, line: 96)
!1250 = !DISubprogram(name: "iswprint", scope: !1229, file: !1229, line: 120, type: !809, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1251 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1252, file: !1226, line: 97)
!1252 = !DISubprogram(name: "iswpunct", scope: !1229, file: !1229, line: 125, type: !809, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1253 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1254, file: !1226, line: 98)
!1254 = !DISubprogram(name: "iswspace", scope: !1229, file: !1229, line: 130, type: !809, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1255 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1256, file: !1226, line: 99)
!1256 = !DISubprogram(name: "iswupper", scope: !1229, file: !1229, line: 135, type: !809, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1257 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1258, file: !1226, line: 100)
!1258 = !DISubprogram(name: "iswxdigit", scope: !1229, file: !1229, line: 140, type: !809, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1259 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1260, file: !1226, line: 101)
!1260 = !DISubprogram(name: "towctrans", scope: !1223, file: !1223, line: 55, type: !1261, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1261 = !DISubroutineType(types: !1262)
!1262 = !{!573, !573, !1222}
!1263 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1264, file: !1226, line: 102)
!1264 = !DISubprogram(name: "towlower", scope: !1229, file: !1229, line: 166, type: !1265, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1265 = !DISubroutineType(types: !1266)
!1266 = !{!573, !573}
!1267 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1268, file: !1226, line: 103)
!1268 = !DISubprogram(name: "towupper", scope: !1229, file: !1229, line: 169, type: !1265, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1269 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1270, file: !1226, line: 104)
!1270 = !DISubprogram(name: "wctrans", scope: !1223, file: !1223, line: 52, type: !1271, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1271 = !DISubroutineType(types: !1272)
!1272 = !{!1222, !267}
!1273 = !DIImportedEntity(tag: DW_TAG_imported_declaration, scope: !13, entity: !1274, file: !1226, line: 105)
!1274 = !DISubprogram(name: "wctype", scope: !1229, file: !1229, line: 155, type: !1275, isLocal: false, isDefinition: false, flags: DIFlagPrototyped, isOptimized: true)
!1275 = !DISubroutineType(types: !1276)
!1276 = !{!1228, !267}
!1277 = !{i32 2, !"Dwarf Version", i32 4}
!1278 = !{i32 2, !"Debug Info Version", i32 3}
!1279 = !{i32 1, !"wchar_size", i32 4}
!1280 = !{!"clang version 8.0.0 (git@github.com:llvm-mirror/clang.git e3e8f2a67bc17cb4f751b22e53e16d7c39b371d0) (git@github.com:llvm-mirror/LLVM.git 48e9774b6791c48760d18775039eefa6d824522d)"}
!1281 = distinct !DISubprogram(name: "h", linkageName: "_Z1hi", scope: !3, file: !3, line: 12, type: !24, isLocal: false, isDefinition: true, scopeLine: 13, flags: DIFlagPrototyped, isOptimized: true, unit: !2, retainedNodes: !1282)
!1282 = !{!1283}
!1283 = !DILocalVariable(name: "x", arg: 1, scope: !1281, file: !3, line: 12, type: !7)
!1284 = !{!1285, !1285, i64 0}
!1285 = !{!"int", !1286, i64 0}
!1286 = !{!"omnipotent char", !1287, i64 0}
!1287 = !{!"Simple C++ TBAA"}
!1288 = !DILocation(line: 12, column: 11, scope: !1281)
!1289 = !DILocation(line: 14, column: 14, scope: !1281)
!1290 = !DILocation(line: 14, column: 13, scope: !1281)
!1291 = !DILocation(line: 14, column: 16, scope: !1281)
!1292 = !DILocation(line: 14, column: 15, scope: !1281)
!1293 = !DILocation(line: 14, column: 5, scope: !1281)
!1294 = distinct !DISubprogram(name: "g_prune", linkageName: "_Z7g_prunei", scope: !3, file: !3, line: 18, type: !24, isLocal: false, isDefinition: true, scopeLine: 19, flags: DIFlagPrototyped, isOptimized: true, unit: !2, retainedNodes: !1295)
!1295 = !{!1296}
!1296 = !DILocalVariable(name: "x", arg: 1, scope: !1294, file: !3, line: 18, type: !7)
!1297 = !DILocation(line: 18, column: 17, scope: !1294)
!1298 = !DILocation(line: 20, column: 12, scope: !1294)
!1299 = !DILocation(line: 20, column: 23, scope: !1294)
!1300 = !DILocation(line: 20, column: 44, scope: !1294)
!1301 = !DILocation(line: 20, column: 56, scope: !1294)
!1302 = !{!1303, !1303, i64 0}
!1303 = !{!"double", !1286, i64 0}
!1304 = !DILocation(line: 20, column: 47, scope: !1294)
!1305 = !DILocation(line: 20, column: 27, scope: !1294)
!1306 = !DILocation(line: 20, column: 25, scope: !1294)
!1307 = !DILocation(line: 20, column: 21, scope: !1294)
!1308 = !DILocation(line: 20, column: 19, scope: !1294)
!1309 = !DILocation(line: 20, column: 5, scope: !1294)
!1310 = distinct !DISubprogram(name: "g_not_prune", linkageName: "_Z11g_not_prunei", scope: !3, file: !3, line: 23, type: !24, isLocal: false, isDefinition: true, scopeLine: 24, flags: DIFlagPrototyped, isOptimized: true, unit: !2, retainedNodes: !1311)
!1311 = !{!1312}
!1312 = !DILocalVariable(name: "x", arg: 1, scope: !1310, file: !3, line: 23, type: !7)
!1313 = !DILocation(line: 23, column: 21, scope: !1310)
!1314 = !DILocation(line: 31, column: 8, scope: !1315)
!1315 = distinct !DILexicalBlock(scope: !1310, file: !3, line: 31, column: 8)
!1316 = !DILocation(line: 31, column: 16, scope: !1315)
!1317 = !DILocation(line: 31, column: 20, scope: !1315)
!1318 = !DILocation(line: 31, column: 8, scope: !1310)
!1319 = !DILocation(line: 32, column: 24, scope: !1315)
!1320 = !DILocation(line: 32, column: 22, scope: !1315)
!1321 = !DILocation(line: 32, column: 18, scope: !1315)
!1322 = !DILocation(line: 32, column: 45, scope: !1315)
!1323 = !DILocation(line: 32, column: 28, scope: !1315)
!1324 = !DILocation(line: 32, column: 26, scope: !1315)
!1325 = !DILocation(line: 32, column: 16, scope: !1315)
!1326 = !DILocation(line: 32, column: 9, scope: !1315)
!1327 = !DILocation(line: 34, column: 22, scope: !1315)
!1328 = !DILocation(line: 34, column: 21, scope: !1315)
!1329 = !DILocation(line: 34, column: 18, scope: !1315)
!1330 = !DILocation(line: 34, column: 48, scope: !1315)
!1331 = !DILocation(line: 34, column: 31, scope: !1315)
!1332 = !DILocation(line: 34, column: 29, scope: !1315)
!1333 = !DILocation(line: 34, column: 16, scope: !1315)
!1334 = !DILocation(line: 34, column: 9, scope: !1315)
!1335 = !DILocation(line: 35, column: 1, scope: !1310)
!1336 = distinct !DISubprogram(name: "f_prune", linkageName: "_Z7f_pruneii", scope: !3, file: !3, line: 37, type: !1337, isLocal: false, isDefinition: true, scopeLine: 38, flags: DIFlagPrototyped, isOptimized: true, unit: !2, retainedNodes: !1339)
!1337 = !DISubroutineType(types: !1338)
!1338 = !{!7, !7, !7}
!1339 = !{!1340, !1341}
!1340 = !DILocalVariable(name: "x", arg: 1, scope: !1336, file: !3, line: 37, type: !7)
!1341 = !DILocalVariable(name: "y", arg: 2, scope: !1336, file: !3, line: 37, type: !7)
!1342 = !DILocation(line: 37, column: 17, scope: !1336)
!1343 = !DILocation(line: 37, column: 24, scope: !1336)
!1344 = !DILocation(line: 39, column: 13, scope: !1336)
!1345 = !DILocation(line: 39, column: 5, scope: !1336)
!1346 = !DILocation(line: 40, column: 17, scope: !1336)
!1347 = !DILocation(line: 40, column: 5, scope: !1336)
!1348 = !DILocation(line: 41, column: 14, scope: !1336)
!1349 = !DILocation(line: 41, column: 12, scope: !1336)
!1350 = !DILocation(line: 41, column: 5, scope: !1336)
!1351 = distinct !DISubprogram(name: "f_not_prune", linkageName: "_Z11f_not_pruneii", scope: !3, file: !3, line: 45, type: !1337, isLocal: false, isDefinition: true, scopeLine: 46, flags: DIFlagPrototyped, isOptimized: true, unit: !2, retainedNodes: !1352)
!1352 = !{!1353, !1354, !1355}
!1353 = !DILocalVariable(name: "x", arg: 1, scope: !1351, file: !3, line: 45, type: !7)
!1354 = !DILocalVariable(name: "y", arg: 2, scope: !1351, file: !3, line: 45, type: !7)
!1355 = !DILocalVariable(name: "c", scope: !1351, file: !3, line: 47, type: !7)
!1356 = !DILocation(line: 45, column: 21, scope: !1351)
!1357 = !DILocation(line: 45, column: 28, scope: !1351)
!1358 = !DILocation(line: 47, column: 5, scope: !1351)
!1359 = !DILocation(line: 47, column: 9, scope: !1351)
!1360 = !DILocation(line: 47, column: 13, scope: !1351)
!1361 = !DILocation(line: 47, column: 19, scope: !1351)
!1362 = !DILocation(line: 47, column: 18, scope: !1351)
!1363 = !DILocation(line: 47, column: 15, scope: !1351)
!1364 = !DILocation(line: 48, column: 13, scope: !1351)
!1365 = !DILocation(line: 48, column: 5, scope: !1351)
!1366 = !DILocation(line: 49, column: 17, scope: !1351)
!1367 = !DILocation(line: 49, column: 5, scope: !1351)
!1368 = !DILocation(line: 50, column: 12, scope: !1351)
!1369 = !DILocation(line: 50, column: 18, scope: !1351)
!1370 = !DILocation(line: 50, column: 16, scope: !1351)
!1371 = !DILocation(line: 50, column: 14, scope: !1351)
!1372 = !DILocation(line: 51, column: 1, scope: !1351)
!1373 = !DILocation(line: 50, column: 5, scope: !1351)
!1374 = distinct !DISubprogram(name: "main", scope: !3, file: !3, line: 53, type: !1375, isLocal: false, isDefinition: true, scopeLine: 54, flags: DIFlagPrototyped, isOptimized: true, unit: !2, retainedNodes: !1377)
!1375 = !DISubroutineType(types: !1376)
!1376 = !{!7, !7, !8}
!1377 = !{!1378, !1379, !1380, !1385, !1386}
!1378 = !DILocalVariable(name: "argc", arg: 1, scope: !1374, file: !3, line: 53, type: !7)
!1379 = !DILocalVariable(name: "argv", arg: 2, scope: !1374, file: !3, line: 53, type: !8)
!1380 = !DILocalVariable(name: "file", scope: !1374, file: !3, line: 55, type: !1381)
!1381 = !DIDerivedType(tag: DW_TAG_typedef, name: "ifstream", scope: !13, file: !1382, line: 162, baseType: !1383)
!1382 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.3.0/../../../../include/c++/7.3.0/iosfwd", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!1383 = !DICompositeType(tag: DW_TAG_class_type, name: "basic_ifstream<char, std::char_traits<char> >", scope: !13, file: !1384, line: 1054, flags: DIFlagFwdDecl, identifier: "_ZTSSt14basic_ifstreamIcSt11char_traitsIcEE")
!1384 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.3.0/../../../../include/c++/7.3.0/bits/fstream.tcc", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!1385 = !DILocalVariable(name: "x1", scope: !1374, file: !3, line: 56, type: !7)
!1386 = !DILocalVariable(name: "x2", scope: !1374, file: !3, line: 57, type: !7)
!1387 = !DILocation(line: 53, column: 14, scope: !1374)
!1388 = !{!1389, !1389, i64 0}
!1389 = !{!"any pointer", !1286, i64 0}
!1390 = !DILocation(line: 53, column: 28, scope: !1374)
!1391 = !DILocation(line: 55, column: 5, scope: !1374)
!1392 = !DILocation(line: 55, column: 19, scope: !1374)
!1393 = !DILocation(line: 56, column: 5, scope: !1374)
!1394 = !DILocation(line: 56, column: 9, scope: !1374)
!1395 = !DILocation(line: 56, column: 26, scope: !1374)
!1396 = !DILocation(line: 56, column: 21, scope: !1374)
!1397 = !DILocation(line: 57, column: 5, scope: !1374)
!1398 = !DILocation(line: 57, column: 9, scope: !1374)
!1399 = !DILocation(line: 58, column: 5, scope: !1374)
!1400 = !DILocation(line: 58, column: 10, scope: !1374)
!1401 = !DILocation(line: 60, column: 5, scope: !1374)
!1402 = !DILocation(line: 61, column: 5, scope: !1374)
!1403 = !DILocation(line: 72, column: 5, scope: !1374)
!1404 = !DILocation(line: 73, column: 1, scope: !1374)
!1405 = distinct !DISubprogram(name: "basic_ifstream", linkageName: "_ZNSt14basic_ifstreamIcSt11char_traitsIcEEC1Ev", scope: !1383, file: !1406, line: 481, type: !1407, isLocal: false, isDefinition: true, scopeLine: 482, flags: DIFlagPrototyped, isOptimized: true, unit: !2, declaration: !1410, retainedNodes: !1411)
!1406 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.3.0/../../../../include/c++/7.3.0/fstream", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!1407 = !DISubroutineType(types: !1408)
!1408 = !{null, !1409}
!1409 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1383, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!1410 = !DISubprogram(name: "basic_ifstream", scope: !1383, file: !1406, line: 481, type: !1407, isLocal: false, isDefinition: false, scopeLine: 481, flags: DIFlagPublic | DIFlagPrototyped, isOptimized: true)
!1411 = !{!1412}
!1412 = !DILocalVariable(name: "this", arg: 1, scope: !1405, type: !1413, flags: DIFlagArtificial | DIFlagObjectPointer)
!1413 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1383, size: 64)
!1414 = !DILocation(line: 0, scope: !1405)
!1415 = !DILocation(line: 482, column: 7, scope: !1405)
!1416 = !DILocation(line: 481, column: 7, scope: !1405)
!1417 = !DILocation(line: 481, column: 26, scope: !1405)
!1418 = !{!1419, !1419, i64 0}
!1419 = !{!"vtable pointer", !1287, i64 0}
!1420 = !DILocation(line: 481, column: 44, scope: !1405)
!1421 = !DILocation(line: 482, column: 15, scope: !1422)
!1422 = distinct !DILexicalBlock(scope: !1405, file: !1406, line: 482, column: 7)
!1423 = !DILocation(line: 482, column: 21, scope: !1422)
!1424 = !DILocation(line: 482, column: 20, scope: !1422)
!1425 = !DILocation(line: 482, column: 34, scope: !1405)
!1426 = !DILocation(line: 482, column: 34, scope: !1422)
!1427 = !DILocation(line: 361, column: 1, scope: !388)
!1428 = !DILocation(line: 363, column: 24, scope: !388)
!1429 = !DILocation(line: 363, column: 16, scope: !388)
!1430 = !DILocation(line: 363, column: 3, scope: !388)
!1431 = distinct !DISubprogram(name: "~basic_ifstream", linkageName: "_ZNSt14basic_ifstreamIcSt11char_traitsIcEED1Ev", scope: !1383, file: !1406, line: 533, type: !1407, isLocal: false, isDefinition: true, scopeLine: 534, flags: DIFlagPrototyped, isOptimized: true, unit: !2, declaration: !1432, retainedNodes: !1433)
!1432 = !DISubprogram(name: "~basic_ifstream", scope: !1383, file: !1406, line: 533, type: !1407, isLocal: false, isDefinition: false, scopeLine: 533, containingType: !1383, virtuality: DW_VIRTUALITY_virtual, virtualIndex: 0, flags: DIFlagPublic | DIFlagPrototyped, isOptimized: true)
!1433 = !{!1434}
!1434 = !DILocalVariable(name: "this", arg: 1, scope: !1431, type: !1413, flags: DIFlagArtificial | DIFlagObjectPointer)
!1435 = !DILocation(line: 0, scope: !1431)
!1436 = !DILocation(line: 534, column: 7, scope: !1431)
!1437 = !DILocation(line: 534, column: 9, scope: !1431)
!1438 = distinct !DISubprogram(name: "basic_ios", linkageName: "_ZNSt9basic_iosIcSt11char_traitsIcEEC2Ev", scope: !1440, file: !1439, line: 460, type: !1442, isLocal: false, isDefinition: true, scopeLine: 463, flags: DIFlagPrototyped, isOptimized: true, unit: !2, declaration: !1445, retainedNodes: !1446)
!1439 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.3.0/../../../../include/c++/7.3.0/bits/basic_ios.h", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!1440 = !DICompositeType(tag: DW_TAG_class_type, name: "basic_ios<char, std::char_traits<char> >", scope: !13, file: !1441, line: 178, flags: DIFlagFwdDecl, identifier: "_ZTSSt9basic_iosIcSt11char_traitsIcEE")
!1441 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.3.0/../../../../include/c++/7.3.0/bits/basic_ios.tcc", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!1442 = !DISubroutineType(types: !1443)
!1443 = !{null, !1444}
!1444 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1440, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!1445 = !DISubprogram(name: "basic_ios", scope: !1440, file: !1439, line: 460, type: !1442, isLocal: false, isDefinition: false, scopeLine: 460, flags: DIFlagProtected | DIFlagPrototyped, isOptimized: true)
!1446 = !{!1447}
!1447 = !DILocalVariable(name: "this", arg: 1, scope: !1438, type: !1448, flags: DIFlagArtificial | DIFlagObjectPointer)
!1448 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1440, size: 64)
!1449 = !DILocation(line: 0, scope: !1438)
!1450 = !DILocation(line: 463, column: 7, scope: !1438)
!1451 = !DILocation(line: 461, column: 9, scope: !1438)
!1452 = !DILocation(line: 461, column: 21, scope: !1438)
!1453 = !{!1454, !1389, i64 216}
!1454 = !{!"_ZTSSt9basic_iosIcSt11char_traitsIcEE", !1389, i64 216, !1286, i64 224, !1455, i64 225, !1389, i64 232, !1389, i64 240, !1389, i64 248, !1389, i64 256}
!1455 = !{!"bool", !1286, i64 0}
!1456 = !DILocation(line: 461, column: 32, scope: !1438)
!1457 = !{!1454, !1286, i64 224}
!1458 = !DILocation(line: 461, column: 54, scope: !1438)
!1459 = !{!1454, !1455, i64 225}
!1460 = !DILocation(line: 462, column: 2, scope: !1438)
!1461 = !{!1454, !1389, i64 232}
!1462 = !DILocation(line: 462, column: 19, scope: !1438)
!1463 = !{!1454, !1389, i64 240}
!1464 = !DILocation(line: 462, column: 32, scope: !1438)
!1465 = !{!1454, !1389, i64 248}
!1466 = !DILocation(line: 462, column: 47, scope: !1438)
!1467 = !{!1454, !1389, i64 256}
!1468 = !DILocation(line: 463, column: 9, scope: !1438)
!1469 = distinct !DISubprogram(name: "basic_istream", linkageName: "_ZNSiC2Ev", scope: !1471, file: !1470, line: 606, type: !1473, isLocal: false, isDefinition: true, scopeLine: 608, flags: DIFlagPrototyped, isOptimized: true, unit: !2, declaration: !1476, retainedNodes: !1477)
!1470 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.3.0/../../../../include/c++/7.3.0/istream", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!1471 = !DICompositeType(tag: DW_TAG_class_type, name: "basic_istream<char, std::char_traits<char> >", scope: !13, file: !1472, line: 1048, flags: DIFlagFwdDecl, identifier: "_ZTSSi")
!1472 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.3.0/../../../../include/c++/7.3.0/bits/istream.tcc", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!1473 = !DISubroutineType(types: !1474)
!1474 = !{null, !1475}
!1475 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1471, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!1476 = !DISubprogram(name: "basic_istream", scope: !1471, file: !1470, line: 606, type: !1473, isLocal: false, isDefinition: false, scopeLine: 606, flags: DIFlagProtected | DIFlagPrototyped, isOptimized: true)
!1477 = !{!1478, !1480}
!1478 = !DILocalVariable(name: "this", arg: 1, scope: !1469, type: !1479, flags: DIFlagArtificial | DIFlagObjectPointer)
!1479 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1471, size: 64)
!1480 = !DILocalVariable(name: "vtt", arg: 2, scope: !1469, type: !1481, flags: DIFlagArtificial)
!1481 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !402, size: 64)
!1482 = !DILocation(line: 0, scope: !1469)
!1483 = !DILocation(line: 608, column: 7, scope: !1469)
!1484 = !DILocation(line: 607, column: 9, scope: !1469)
!1485 = !{!1486, !1487, i64 8}
!1486 = !{!"_ZTSSi", !1487, i64 8}
!1487 = !{!"long", !1286, i64 0}
!1488 = !DILocation(line: 608, column: 15, scope: !1489)
!1489 = distinct !DILexicalBlock(scope: !1469, file: !1470, line: 608, column: 7)
!1490 = !DILocation(line: 608, column: 24, scope: !1469)
!1491 = distinct !DISubprogram(name: "~basic_filebuf", linkageName: "_ZNSt13basic_filebufIcSt11char_traitsIcEED2Ev", scope: !1492, file: !1406, line: 238, type: !1493, isLocal: false, isDefinition: true, scopeLine: 239, flags: DIFlagPrototyped, isOptimized: true, unit: !2, declaration: !1496, retainedNodes: !1497)
!1492 = !DICompositeType(tag: DW_TAG_class_type, name: "basic_filebuf<char, std::char_traits<char> >", scope: !13, file: !1384, line: 1053, flags: DIFlagFwdDecl, identifier: "_ZTSSt13basic_filebufIcSt11char_traitsIcEE")
!1493 = !DISubroutineType(types: !1494)
!1494 = !{null, !1495}
!1495 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1492, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!1496 = !DISubprogram(name: "~basic_filebuf", scope: !1492, file: !1406, line: 238, type: !1493, isLocal: false, isDefinition: false, scopeLine: 238, containingType: !1492, virtuality: DW_VIRTUALITY_virtual, virtualIndex: 0, flags: DIFlagPublic | DIFlagPrototyped, isOptimized: true)
!1497 = !{!1498}
!1498 = !DILocalVariable(name: "this", arg: 1, scope: !1491, type: !1499, flags: DIFlagArtificial | DIFlagObjectPointer)
!1499 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1492, size: 64)
!1500 = !DILocation(line: 0, scope: !1491)
!1501 = !DILocation(line: 239, column: 7, scope: !1491)
!1502 = !DILocation(line: 239, column: 15, scope: !1503)
!1503 = distinct !DILexicalBlock(scope: !1491, file: !1406, line: 239, column: 7)
!1504 = !DILocation(line: 239, column: 24, scope: !1503)
!1505 = !DILocation(line: 239, column: 24, scope: !1491)
!1506 = distinct !DISubprogram(name: "~basic_istream", linkageName: "_ZNSiD2Ev", scope: !1471, file: !1470, line: 103, type: !1473, isLocal: false, isDefinition: true, scopeLine: 104, flags: DIFlagPrototyped, isOptimized: true, unit: !2, declaration: !1507, retainedNodes: !1508)
!1507 = !DISubprogram(name: "~basic_istream", scope: !1471, file: !1470, line: 103, type: !1473, isLocal: false, isDefinition: false, scopeLine: 103, containingType: !1471, virtuality: DW_VIRTUALITY_virtual, virtualIndex: 0, flags: DIFlagPublic | DIFlagPrototyped, isOptimized: true)
!1508 = !{!1509, !1510}
!1509 = !DILocalVariable(name: "this", arg: 1, scope: !1506, type: !1479, flags: DIFlagArtificial | DIFlagObjectPointer)
!1510 = !DILocalVariable(name: "vtt", arg: 2, scope: !1506, type: !1481, flags: DIFlagArtificial)
!1511 = !DILocation(line: 0, scope: !1506)
!1512 = !DILocation(line: 104, column: 7, scope: !1506)
!1513 = !DILocation(line: 104, column: 9, scope: !1514)
!1514 = distinct !DILexicalBlock(scope: !1506, file: !1470, line: 104, column: 7)
!1515 = !DILocation(line: 104, column: 19, scope: !1514)
!1516 = !DILocation(line: 104, column: 36, scope: !1506)
!1517 = distinct !DISubprogram(name: "~basic_ios", linkageName: "_ZNSt9basic_iosIcSt11char_traitsIcEED2Ev", scope: !1440, file: !1439, line: 282, type: !1442, isLocal: false, isDefinition: true, scopeLine: 282, flags: DIFlagPrototyped, isOptimized: true, unit: !2, declaration: !1518, retainedNodes: !1519)
!1518 = !DISubprogram(name: "~basic_ios", scope: !1440, file: !1439, line: 282, type: !1442, isLocal: false, isDefinition: false, scopeLine: 282, containingType: !1440, virtuality: DW_VIRTUALITY_virtual, virtualIndex: 0, flags: DIFlagPublic | DIFlagPrototyped, isOptimized: true)
!1519 = !{!1520}
!1520 = !DILocalVariable(name: "this", arg: 1, scope: !1517, type: !1448, flags: DIFlagArtificial | DIFlagObjectPointer)
!1521 = !DILocation(line: 0, scope: !1517)
!1522 = !DILocation(line: 282, column: 22, scope: !1523)
!1523 = distinct !DILexicalBlock(scope: !1517, file: !1439, line: 282, column: 20)
!1524 = !DILocation(line: 282, column: 22, scope: !1517)
!1525 = distinct !DISubprogram(name: "~basic_streambuf", linkageName: "_ZNSt15basic_streambufIcSt11char_traitsIcEED2Ev", scope: !1527, file: !1526, line: 197, type: !1529, isLocal: false, isDefinition: true, scopeLine: 198, flags: DIFlagPrototyped, isOptimized: true, unit: !2, declaration: !1532, retainedNodes: !1533)
!1526 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.3.0/../../../../include/c++/7.3.0/streambuf", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!1527 = !DICompositeType(tag: DW_TAG_class_type, name: "basic_streambuf<char, std::char_traits<char> >", scope: !13, file: !1528, line: 149, flags: DIFlagFwdDecl, identifier: "_ZTSSt15basic_streambufIcSt11char_traitsIcEE")
!1528 = !DIFile(filename: "/usr/lib/gcc/x86_64-linux-gnu/7.3.0/../../../../include/c++/7.3.0/bits/streambuf.tcc", directory: "/home/mcopik/projects/ETH/extrap/llvm_pass/extrap-tool")
!1529 = !DISubroutineType(types: !1530)
!1530 = !{null, !1531}
!1531 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1527, size: 64, flags: DIFlagArtificial | DIFlagObjectPointer)
!1532 = !DISubprogram(name: "~basic_streambuf", scope: !1527, file: !1526, line: 197, type: !1529, isLocal: false, isDefinition: false, scopeLine: 197, containingType: !1527, virtuality: DW_VIRTUALITY_virtual, virtualIndex: 0, flags: DIFlagPublic | DIFlagPrototyped, isOptimized: true)
!1533 = !{!1534}
!1534 = !DILocalVariable(name: "this", arg: 1, scope: !1525, type: !1535, flags: DIFlagArtificial | DIFlagObjectPointer)
!1535 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !1527, size: 64)
!1536 = !DILocation(line: 0, scope: !1525)
!1537 = !DILocation(line: 198, column: 7, scope: !1525)
!1538 = !DILocation(line: 198, column: 9, scope: !1539)
!1539 = distinct !DILexicalBlock(scope: !1525, file: !1526, line: 198, column: 7)
!1540 = !DILocation(line: 198, column: 9, scope: !1525)
!1541 = distinct !DISubprogram(name: "~basic_ifstream", linkageName: "_ZNSt14basic_ifstreamIcSt11char_traitsIcEED2Ev", scope: !1383, file: !1406, line: 533, type: !1407, isLocal: false, isDefinition: true, scopeLine: 534, flags: DIFlagPrototyped, isOptimized: true, unit: !2, declaration: !1432, retainedNodes: !1542)
!1542 = !{!1543, !1544}
!1543 = !DILocalVariable(name: "this", arg: 1, scope: !1541, type: !1413, flags: DIFlagArtificial | DIFlagObjectPointer)
!1544 = !DILocalVariable(name: "vtt", arg: 2, scope: !1541, type: !1481, flags: DIFlagArtificial)
!1545 = !DILocation(line: 0, scope: !1541)
!1546 = !DILocation(line: 534, column: 7, scope: !1541)
!1547 = !DILocation(line: 534, column: 9, scope: !1548)
!1548 = distinct !DILexicalBlock(scope: !1541, file: !1406, line: 534, column: 7)
!1549 = !DILocation(line: 534, column: 9, scope: !1541)
!1550 = distinct !DISubprogram(linkageName: "_ZTv0_n24_NSt14basic_ifstreamIcSt11char_traitsIcEED1Ev", scope: !1406, file: !1406, line: 533, type: !1551, isLocal: false, isDefinition: true, flags: DIFlagArtificial | DIFlagThunk, isOptimized: true, unit: !2, retainedNodes: !1552)
!1551 = !DISubroutineType(types: !4)
!1552 = !{!1553}
!1553 = !DILocalVariable(name: "this", arg: 1, scope: !1550, type: !1413, flags: DIFlagArtificial | DIFlagObjectPointer)
!1554 = !DILocation(line: 0, scope: !1550)
