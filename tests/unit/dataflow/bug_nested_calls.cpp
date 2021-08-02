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
// RUN: %jsonconvert %t1.json > %t4.json
// RUN: diff -w %s.processed.json %t4.json

#include <cmath>
#include <cstdlib>

#include "perf-taint/PerfTaint.hpp"

// Test reproducing a bug where multiple nested calls appear in the same function.
// When a series of calls to important functions is made, the order of call
// registration must be: first nested calls in loop in the order of invocation,
// then calls outside of a loop.
// There was a bug where this registration calls were done in a reverse order,
// preventing `g` and `g2` calls inside of a loop to show up.

void f1(int x1, int x2)
{
  int tmp = 0;
  for(int i = 0; i < 100; i += 1) {
    tmp += i*1.1;
  }
}
void f2(int x1, int x2)
{
  int tmp = 0;
  for(int i = x1; i < x2; i += 1)
    tmp += i*1.1;

}
void f3(int x1, int x2)
{
  int tmp = 0;
  for(int i = x1; i < 20; i += 1) 
    tmp += i*1.1;
}

void g(int x1, int x2)
{
  f1(x1, x2);
  f2(x1, x2);
  f3(x1, x2);
}
void g2(int x1, int x2)
{
  f1(x1, x2);
  f2(x1, x2);
  f3(x1, x2);
}
void g3(int x1, int x2)
{
  f1(x1, x2);
  f2(x1, x2);
  f3(x1, x2);
}

int f(int x1, int x2)
{
  int tmp = 0;
  for(int i = 0; i < x2; i += 1) {
    tmp += i*1.1;
    for(int j = 0; j < x1; j += 1)
      g(x1, x2);
    g2(x2, x1);
  }
  g(x1, 100);
  return 100 * x1 * x2 + 2;
}

int main(int argc, char ** argv)
{
  int x1 EXTRAP = atoi(argv[1]);
  int x2 EXTRAP = 2*atoi(argv[2]);
  perf_taint::register_variable(&x1, VARIABLE_NAME(x1));
  perf_taint::register_variable(&x2, VARIABLE_NAME(x2));
  f(x1, x2);

  return 0;
}
