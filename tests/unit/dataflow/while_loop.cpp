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

// The simplest possible example.

int while_loop(int x, int y)
{
    int tmp = 0;
    int i = x;
    while(i < y) {
      tmp += i;
      ++i;
    }
    return tmp*10*x + y/2;
}

int while_infinite(int x, int y)
{
    int tmp = 0;
    int i = x;
    while(true) {
      if(i >= y)
        break;
      tmp += i;
      ++i;
    }
    return tmp*10*x + y/2;
}

int while_infinite_const(int x, int y)
{
    int tmp = 0;
    int i = x;
    while(true) {
      if(i >= 100)
        break;
      tmp += i;
      ++i;
    }
    return tmp*10*x + y/2;
}

int main(int argc, char ** argv)
{
    int x1 EXTRAP = atoi(argv[1]);
    int x2 EXTRAP = 2*atoi(argv[2]);
    perf_taint::register_variable(&x1, VARIABLE_NAME(x1));
    perf_taint::register_variable(&x2, VARIABLE_NAME(x2));

    // x1,x2 - loop never executes but branch is evaluated
    while_loop(x2, x1);
    // x1
    while_loop(0, x1);
    // x2
    while_loop(0, x2);
    // nothing
    while_loop(0, 10);

    // x1, x2
    while_infinite(x2, x1);
    // x1
    while_infinite(0, x1);
    // x2
    while_infinite(0, x2);
    // nothing
    while_infinite(0, 10);

    // generates x1
    while_infinite_const(x1, x2);
    // generates x2
    while_infinite_const(x2, x1);
    // nothing
    while_infinite_const(0, x1);
    // x2 + x1
    while_infinite_const(x2 + x1, 0);
    // nothing
    while_infinite_const(0, 10);


    return 0;
}
