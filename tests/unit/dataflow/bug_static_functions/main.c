
// RUN: %clang %c_flags %s -emit-llvm -o %t1.bc
// RUN: %clang %c_flags %S/test.c -emit-llvm -o %t2.bc
// RUN: %llvm_link %t1.bc %t2.bc -o %t3.bc
// RUN: %opt %opt_flags < %t3.bc 2> /dev/null > %t3.tainted.bc
// RUN: %llc %llc_flags < %t3.tainted.bc > %t3.tainted.o
// RUN: %clangxx %link_flags %t3.tainted.o -o %t3.exe
// RUN: %execparams %t3.exe 10 10 > %t3.json
// RUN: diff -w %s.json %t3.json

#include <stdlib.h>
#include <stdio.h>

#include "test.h"

#include "perf-taint/PerfTaint.h"

// When a static function is present in two translation units,
// there will be two copies of the same function, and linking
// will generate multiple versions with different name.
// This test case verifies that we merge those functions,
// and `f` appears in the output only once.

void test1(int);

int main(int argc, char ** argv)
{
  int x1 EXTRAP = atoi(argv[1]);
  perf_taint_register_variable(&x1, sizeof(x1), VARIABLE_NAME(x1));
  test1(x1);
  f(x1);
  return 0;
}
