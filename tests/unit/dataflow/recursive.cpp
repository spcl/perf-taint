// RUN: %clangxx %cxx_flags %s -emit-llvm -o %t1.bc
// RUN: %opt %opt_flags < %t1.bc 2> /dev/null > %t1.tainted.bc
// RUN: %llc %llc_flags < %t1.tainted.bc > %t1.tainted.o
// RUN: %clangxx %link_flags %t1.tainted.o -o %t1.exe
// RUN: %execparams %t1.exe 10 10 > %t1.json
// RUN: diff -w %s.json %t1.json
// RUN: %jsonconvert %t1.json > %t2.json
// RUN: diff -w %s.processed.json %t2.json

// RUN: %opt %opt_flags %opt_cfsan < %t1.bc 2> /dev/null > %t2.tainted.bc
// RUN: %llc %llc_flags < %t2.tainted.bc > %t2.tainted.o
// RUN: %clangxx %link_flags %t2.tainted.o -o %t2.exe
// RUN: %execparams %t2.exe 10 10 > %t3.json
// RUN: diff -w %s.json %t3.json
// RUN: %jsonconvert %t3.json > %t4.json
// RUN: diff -w %s.processed.json %t4.json

#include <cmath>
#include <cstdlib>

#include "perf-taint/PerfTaint.hpp"

int recurse_proxy(int x, int y);

int proxy(int x, int y)
{
  return y > x ? recurse_proxy(x, y - 1) : 0;
}

int recurse_proxy(int x, int y)
{
  int sum = 0;
  for(int i = x; i < y; ++i)
    sum += i;
  return sum + proxy(x, y);
}

// This function should perform 0 iterations and have no parameter
// tainting in the first call. It should, however, have tainting
// from recurse calls.
// perf-taint should merge into one tainted loop.
int recurse_first_call_empty(int x, int y)
{
  int sum = 0;
  if(x != y)
    for(int i = x; i < y; ++i)
      sum += i;
  return sum + x > 0 ? recurse_first_call_empty(x - 1, y) : 0;
}

int recurse_two_params(int x, int y)
{
  int sum = 0;
  for(int i = x; i < y; ++i)
    sum += i;
  return sum + y > x ? recurse_two_params(x, y - 1) : 0;
}

int recurse(int x)
{
  int sum = 0;
  for(int i = 0; i < x; ++i)
    sum += i;
  return sum + x > 0 ? recurse(x - 1) : 0;
}

int main(int argc, char ** argv)
{
  int x1 EXTRAP = atoi(argv[1]);
  int x2 EXTRAP = 2*atoi(argv[2]);
  perf_taint::register_variable(&x1, VARIABLE_NAME(x1));
  perf_taint::register_variable(&x2, VARIABLE_NAME(x2));

  // Should generate a loop that depends only on x1
  recurse(x1);
  // Should generate a loop that depends only on x2
  recurse(x2);
  // Should generate a loop that depends on x1 & x2
  recurse_two_params(x1, x2);

  // Should generate a loop that depends only on x1
  recurse_first_call_empty(x1, x1);

  // Should generate a loop that depends on x1 & x2
  recurse_proxy(x1, x2);

  return 0;
}
