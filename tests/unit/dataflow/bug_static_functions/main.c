
// RUN: %clang %c_flags %s -emit-llvm -o %t1.bc
// RUN: %clang %c_flags %S/helpers/test.c -emit-llvm -o %t2.bc
// RUN: %clang %c_flags %S/helpers/test2.c -emit-llvm -o %t3.bc
// RUN: %llvm_link %t1.bc %t2.bc %t3.bc -o %t4.bc
//
// RUN: %opt %opt_flags -perf-taint-remove-duplicates < %t4.bc 2> /dev/null > %t4.tainted.bc
// RUN: %llc %llc_flags < %t4.tainted.bc > %t4.tainted.o
// RUN: %clangxx %link_flags %t4.tainted.o -o %t4.exe
// RUN: %execparams %t4.exe 10 10 > %t4.json
// RUN: diff -w %s.merge.json %t4.json
//
// RUN: %opt %opt_flags -perf-taint-remove-duplicates-experimental < %t4.bc 2> /dev/null > %t5.tainted.bc
// RUN: %llc %llc_flags < %t5.tainted.bc > %t5.tainted.o
// RUN: %clangxx %link_flags %t5.tainted.o -o %t5.exe
// RUN: %execparams %t5.exe 10 10 > %t5.json
// RUN: diff -w %s.experimental.json %t5.json

#include <stdlib.h>
#include <stdio.h>

#include "helpers/test.h"

#include "perf-taint/PerfTaint.h"

// When a static function is present in two translation units,
// there will be two copies of the same function, and linking
// will generate multiple versions with different name.
// This test case verifies that we merge those functions.
//
// 'f' should appear in the output only once.
// 'test1' should appear in the output only once if we use the LLVM infrastructure to merge functions.
// The experimental implementation will not merge functions becasue they exist in different places.

void test1(int);
void test2(int);

int main(int argc, char ** argv)
{
  int x1 EXTRAP = atoi(argv[1]);
  int x2 EXTRAP = atoi(argv[1]);
  perf_taint_register_variable(&x1, sizeof(x1), VARIABLE_NAME(x1));
  perf_taint_register_variable(&x2, sizeof(x2), VARIABLE_NAME(x2));
  test1(x1);
  test2(x2);
  f(x2);
  return 0;
}
