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

#include <stdio.h>
#include <stdlib.h>
#include <perf-taint/PerfTaint.hpp>

int do_while_loop(int x, int y)
{
  int tmp = 0;
  int i = x;
  do {
    tmp += i;
    ++i;
  } while(i < y);
  return tmp*10*x + y/2;
}

int do_while_infinite(int x, int y) 
{
  int tmp = 0;
  int i = x;
  do {
    tmp += i;
    ++i;
    if (i > y) break;
  } while(true);
  return tmp*10*x + y/2;
}

int do_while_infinite_const(int x, int y) 
{
  int tmp = 0;
  int i = x;
  do {
    tmp += i;
    ++i;
    if (i > 100) break;
  } while(true);
  return tmp*10*x + y/2;
}

int main(int argc, char ** argv)
{
  int x1 EXTRAP = atoi(argv[1]);
  int x2 EXTRAP = 2*atoi(argv[2]);
  perf_taint::register_variable(&x1, VARIABLE_NAME(x1));
  perf_taint::register_variable(&x2, VARIABLE_NAME(x2));

  // generates x1,x2
  // loop is always executed at least once
  do_while_loop(x2, x1);
  // x1
  do_while_loop(0, x1);
  // x2
  do_while_loop(0, x2);
  // nothing
  do_while_loop(0, 10);

  // generates x1,x2
  // loop is always executed at least once
  do_while_infinite(x2, x1);
  // x1
  do_while_infinite(0, x1);
  // x2
  do_while_infinite(0, x2);
  // nothing
  do_while_infinite(0, 10);

  // generates x1,x2
  do_while_infinite_const(x1 + x2, x2);
  // generates x2
  do_while_infinite_const(x2, x1);
  // nothing
  do_while_infinite_const(0, x1);
  // x1
  do_while_infinite_const(x1, 0);
  // nothing
  do_while_infinite_const(0, 10);
} 

