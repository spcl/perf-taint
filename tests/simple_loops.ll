; RUN: opt %loadpass  -o /dev/null -extrap-extractor-polly-scev=false < %s | diff -w %s.scev.json -
; RUN: opt %loadpass  -o /dev/null -extrap-extractor-scev=false < %s | diff -w %s.pollyscev.json -
; RUN: opt %loadpass  -o /dev/null -extrap-extractor-polly-scev=false -extrap-extractor-scev=false < %s | diff -w %s.json -

define double @_Z1fii(i32, i32) {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca double, align 8
  %6 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  store i32 %1, i32* %4, align 4
  %7 = bitcast double* %5 to i8*
  store double 0.000000e+00, double* %5, align 8
  %8 = bitcast i32* %6 to i8*
  store i32 0, i32* %6, align 4
  br label %9

; <label>:9:                                      ; preds = %21, %2
  %10 = load i32, i32* %6, align 4
  %11 = load i32, i32* %3, align 4
  %12 = icmp slt i32 %10, %11
  br i1 %12, label %15, label %13

; <label>:13:                                     ; preds = %9
  %14 = bitcast i32* %6 to i8*
  br label %24

; <label>:15:                                     ; preds = %9
  %16 = load i32, i32* %6, align 4
  %17 = sitofp i32 %16 to double
  %18 = fmul double %17, 1.100000e+00
  %19 = load double, double* %5, align 8
  %20 = fadd double %19, %18
  store double %20, double* %5, align 8
  br label %21

; <label>:21:                                     ; preds = %15
  %22 = load i32, i32* %6, align 4
  %23 = add nsw i32 %22, 1
  store i32 %23, i32* %6, align 4
  br label %9

; <label>:24:                                     ; preds = %13
  %25 = load double, double* %5, align 8
  %26 = bitcast double* %5 to i8*
  ret double %25
}

define double @_Z1gii(i32, i32) {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca double, align 8
  %6 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  store i32 %1, i32* %4, align 4
  %7 = bitcast double* %5 to i8*
  store double 0.000000e+00, double* %5, align 8
  %8 = bitcast i32* %6 to i8*
  %9 = load i32, i32* %4, align 4
  store i32 %9, i32* %6, align 4
  br label %10

; <label>:10:                                     ; preds = %21, %2
  %11 = load i32, i32* %6, align 4
  %12 = icmp slt i32 %11, 200
  br i1 %12, label %15, label %13

; <label>:13:                                     ; preds = %10
  %14 = bitcast i32* %6 to i8*
  br label %24

; <label>:15:                                     ; preds = %10
  %16 = load i32, i32* %6, align 4
  %17 = sitofp i32 %16 to double
  %18 = fmul double %17, 1.100000e+00
  %19 = load double, double* %5, align 8
  %20 = fadd double %19, %18
  store double %20, double* %5, align 8
  br label %21

; <label>:21:                                     ; preds = %15
  %22 = load i32, i32* %6, align 4
  %23 = add nsw i32 %22, 1
  store i32 %23, i32* %6, align 4
  br label %10

; <label>:24:                                     ; preds = %13
  %25 = load double, double* %5, align 8
  %26 = bitcast double* %5 to i8*
  ret double %25
}

define double @_Z1hii(i32, i32) {
  %3 = alloca i32, align 4
  %4 = alloca i32, align 4
  %5 = alloca double, align 8
  %6 = alloca i32, align 4
  store i32 %0, i32* %3, align 4
  store i32 %1, i32* %4, align 4
  %7 = bitcast double* %5 to i8*
  store double 0.000000e+00, double* %5, align 8
  %8 = bitcast i32* %6 to i8*
  store i32 0, i32* %6, align 4
  br label %9

; <label>:9:                                      ; preds = %20, %2
  %10 = load i32, i32* %6, align 4
  %11 = icmp slt i32 %10, 200
  br i1 %11, label %14, label %12

; <label>:12:                                     ; preds = %9
  %13 = bitcast i32* %6 to i8*
  br label %24

; <label>:14:                                     ; preds = %9
  %15 = load i32, i32* %6, align 4
  %16 = sitofp i32 %15 to double
  %17 = fmul double %16, 1.100000e+00
  %18 = load double, double* %5, align 8
  %19 = fadd double %18, %17
  store double %19, double* %5, align 8
  br label %20

; <label>:20:                                     ; preds = %14
  %21 = load i32, i32* %4, align 4
  %22 = load i32, i32* %6, align 4
  %23 = add nsw i32 %22, %21
  store i32 %23, i32* %6, align 4
  br label %9

; <label>:24:                                     ; preds = %12
  %25 = load double, double* %5, align 8
  %26 = bitcast double* %5 to i8*
  ret double %25
}

define  double @_Z1iiii(i32, i32, i32) {
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  %6 = alloca i32, align 4
  %7 = alloca double, align 8
  %8 = alloca i32, align 4
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  store i32 %0, i32* %4, align 4
  store i32 %1, i32* %5, align 4
  store i32 %2, i32* %6, align 4
  %11 = bitcast double* %7 to i8*
  store double 0.000000e+00, double* %7, align 8
  %12 = bitcast i32* %8 to i8*
  %13 = load i32, i32* %4, align 4
  store i32 %13, i32* %8, align 4
  br label %14

; <label>:14:                                     ; preds = %26, %3
  %15 = load i32, i32* %8, align 4
  %16 = load i32, i32* %5, align 4
  %17 = icmp slt i32 %15, %16
  br i1 %17, label %20, label %18

; <label>:18:                                     ; preds = %14
  %19 = bitcast i32* %8 to i8*
  br label %29

; <label>:20:                                     ; preds = %14
  %21 = load i32, i32* %8, align 4
  %22 = sitofp i32 %21 to double
  %23 = fmul double %22, 1.100000e+00
  %24 = load double, double* %7, align 8
  %25 = fadd double %24, %23
  store double %25, double* %7, align 8
  br label %26

; <label>:26:                                     ; preds = %20
  %27 = load i32, i32* %8, align 4
  %28 = add nsw i32 %27, 1
  store i32 %28, i32* %8, align 4
  br label %14

; <label>:29:                                     ; preds = %18
  %30 = bitcast i32* %9 to i8*
  %31 = load i32, i32* %5, align 4
  store i32 %31, i32* %9, align 4
  br label %32

; <label>:32:                                     ; preds = %46, %29
  %33 = load i32, i32* %9, align 4
  %34 = load i32, i32* %4, align 4
  %35 = load i32, i32* %5, align 4
  %36 = mul nsw i32 %34, %35
  %37 = icmp slt i32 %33, %36
  br i1 %37, label %40, label %38

; <label>:38:                                     ; preds = %32
  %39 = bitcast i32* %9 to i8*
  br label %49

; <label>:40:                                     ; preds = %32
  %41 = load i32, i32* %9, align 4
  %42 = sitofp i32 %41 to double
  %43 = fmul double %42, 1.100000e+00
  %44 = load double, double* %7, align 8
  %45 = fadd double %44, %43
  store double %45, double* %7, align 8
  br label %46

; <label>:46:                                     ; preds = %40
  %47 = load i32, i32* %9, align 4
  %48 = add nsw i32 %47, 1
  store i32 %48, i32* %9, align 4
  br label %32

; <label>:49:                                     ; preds = %38
  %50 = bitcast i32* %10 to i8*
  %51 = load i32, i32* %4, align 4
  store i32 %51, i32* %10, align 4
  br label %52

; <label>:52:                                     ; preds = %67, %49
  %53 = load i32, i32* %10, align 4
  %54 = load i32, i32* %4, align 4
  %55 = mul nsw i32 2, %54
  %56 = load i32, i32* %5, align 4
  %57 = add nsw i32 %55, %56
  %58 = icmp slt i32 %53, %57
  br i1 %58, label %61, label %59

; <label>:59:                                     ; preds = %52
  %60 = bitcast i32* %10 to i8*
  br label %71

; <label>:61:                                     ; preds = %52
  %62 = load i32, i32* %10, align 4
  %63 = sitofp i32 %62 to double
  %64 = fmul double %63, 1.100000e+00
  %65 = load double, double* %7, align 8
  %66 = fadd double %65, %64
  store double %66, double* %7, align 8
  br label %67

; <label>:67:                                     ; preds = %61
  %68 = load i32, i32* %6, align 4
  %69 = load i32, i32* %10, align 4
  %70 = add nsw i32 %69, %68
  store i32 %70, i32* %10, align 4
  br label %52

; <label>:71:                                     ; preds = %59
  %72 = load double, double* %7, align 8
  %73 = bitcast double* %7 to i8*
  ret double %72
}

