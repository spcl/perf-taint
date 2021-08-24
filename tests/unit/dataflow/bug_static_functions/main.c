
// RUN: %clang %c_flags %s -emit-llvm -o %t1.bc
// RUN: %clang %c_flags %S/test.c -emit-llvm -o %t2.bc
// RUN: %clang %c_flags %S/test2.c -emit-llvm -o %t3.bc
// RUN: %llvm_link %t1.bc %t2.bc %t3.bc -o %t4.bc
// RUN: %opt %opt_flags -perf-taint-remove-duplicates < %t4.bc 2> /dev/null > %t4.tainted.bc
// RUN: %llc %llc_flags < %t4.tainted.bc > %t4.tainted.o
// RUN: %clangxx %link_flags %t4.tainted.o -o %t4.exe
// RUN: %execparams %t4.exe 10 10 > %t4.json
// RUN: diff -w %s.json %t4.json

#include <stdlib.h>
#include <stdio.h>

#include "test.h"

#include "perf-taint/PerfTaint.h"

// When a static function is present in two translation units,
// there will be two copies of the same function, and linking
// will generate multiple versions with different name.
// This test case verifies that we merge those functions,
// and both 'test1' and 'f' appear in the output only once.

void test1(int);
void test2(int);

int main(int argc, char ** argv)
{
  int x1 EXTRAP = atoi(argv[1]);
  int x2 EXTRAP = atoi(argv[1]);
  perf_taint_register_variable(&x1, sizeof(x1), VARIABLE_NAME(x1));
  perf_taint_register_variable(&x2, sizeof(x2), VARIABLE_NAME(x2));
  test1(x1);
  test2(x1);
  f(x2);
  return 0;
}
