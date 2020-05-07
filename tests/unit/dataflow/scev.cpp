// RUN: %clangxx %cxx_flags %s -emit-llvm -o %t1.bc
// RUN: %opt %opt_flags -perf-taint-scev -perf-taint-pass-stats=%t1.scev.json \
// RUN: %t1.bc 2> /dev/null > %t1.tainted.bc
// RUN: diff -w %s.pass.json %t1.scev.json

// RUN: %llc %llc_flags < %t1.tainted.bc > %t1.tainted.o
// RUN: %clangxx %link_flags %t1.tainted.o -o %t1.exe
// RUN: %execparams %t1.exe 10 10 > %t1.json
// RUN: diff -w %s.json %t1.json

#include <cstdlib>

#include <perf-taint/PerfTaint.hpp>

// This test verifies that using LLVM SCEV helps to prune some loops.

int empty_function(int x1, int x2)
{
  return x1 + x2;
}

int constant_loop(int x1, int x2)
{
  int tmp = 0;
  for(int i = 0; i < 100; ++i)
      tmp += i;
  return tmp + x1 + x2;
}

int nonconstant_loop(int x1, int x2)
{
  int tmp = 0;
  for(int i = 0; i < x1; ++i)
      tmp += i;
  return tmp + x1 + x2;
}

int mixed_loop(int x1, int x2)
{
  int tmp = 0;
  for(int i = 0; i < x1; ++i)
      tmp += i;
  for(int i = 10; i < 93; i += 2)
      tmp += i;
  return tmp + x1 + x2;
}

// constant (compile-time)
// instrumented (tainted) three variants
int nonconstant_loop_variants(int x1, int x2)
{
  int tmp = 0;
  for(int i = 10; i < 93; i += 2)
      tmp += i;
  for(int i = 0; i < x1; ++i)
      tmp += i;
  for(int i = x1; i < 100; ++i)
      tmp += i;
  for(int i = 0; i < 100; i += x1)
      tmp += i;
  return tmp;
}

// constant (compile-time)
// instrumented (tainted)
// instrumented (constant)
// instrumented (tainted)
int mixed_loop_large(int x1, int x2, int x3)
{
  int tmp = 0;
  for(int i = 10; i < 93; i += 2)
      tmp += i;
  for(int i = 0; i < x1; ++i)
      tmp += i;
  for(int i = x1; i < x3; ++i)
      tmp += i;
  for(int i = x1; i < x2; i++)
      tmp += i;
  return tmp + x1 + x2;
}

int main(int argc, char ** argv)
{
  int x1 EXTRAP = atoi(argv[1]);
  int x2 EXTRAP = 2*atoi(argv[2]);
  register_variable(&x1, "x1");
  register_variable(&x2, "x2");

  empty_function(x1, x2);
  constant_loop(x1, x2);
  nonconstant_loop(x1, x2);
  nonconstant_loop_variants(x1, x2);
  mixed_loop(x1, x2);
  mixed_loop_large(x1, x2, 100);

  return 0;
}
