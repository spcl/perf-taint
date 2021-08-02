// RUN: %clangxx %cxx_flags %s -emit-llvm -o %t1.bc
// RUN: %opt %opt_flags < %t1.bc 2> /dev/null > %t1.tainted.bc
// RUN: %llc %llc_flags < %t1.tainted.bc > %t1.tainted.o
// RUN: %clangxx %link_flags %t1.tainted.o -o %t1.exe
// RUN: %execparams %t1.exe 10 10 > %t1.json
// RUN: diff -w %s.json %t1.json
// RUN: %jsonconvert %t1.json > %t2.json
// RUN: diff -w %s.processed.json %t2.json
// RUN: %jsonconvert --no-accumulate-nonloop-dependencies %t1.json > %t2.json
// RUN: diff -w %s.processed2.json %t2.json

// RUN: %opt %opt_flags %opt_cfsan < %t1.bc 2> /dev/null > %t2.tainted.bc
// RUN: %llc %llc_flags < %t2.tainted.bc > %t2.tainted.o
// RUN: %clangxx %link_flags %t2.tainted.o -o %t2.exe
// RUN: %execparams %t2.exe 10 10 > %t3.json
// RUN: diff -w %s.json %t3.json
// RUN: %jsonconvert %t3.json > %t4.json
// RUN: diff -w %s.processed.json %t4.json
// RUN: %jsonconvert --no-accumulate-nonloop-dependencies %t3.json > %t4.json
// RUN: diff -w %s.processed2.json %t4.json

#include <cmath>
#include <cstdlib>

#include "perf-taint/PerfTaint.hpp"

// This test verifies that functions are correctly pruned and we
// detect each callstack seperately.

int global EXTRAP = 100;

int h(int x)
{
    int tmp = 0;
    for(int i = x; i < 100; ++i)
        tmp += i;
    return 100 * tmp * std::log((double)x);
}

int f(int x, int y)
{
    int tmp = 0;
    for(int i = x; i < y; ++i)
        tmp += i;
    return 10*x + h(y/2) + tmp;
}

int g(int x)
{
    int tmp = 0;
    for(int i = x; i < global; ++i)
        tmp += i;
    return h(100 + x + tmp + std::pow((double)global, 3.0));
}

int i(int x1, int x2, int x3)
{
    int tmp = 0;
    for(int i = x1; i < x2 + 1; i += x3)
        tmp += i*1.1;
    return f(global, x1) * x1 * x2 + tmp + h(x3) * f(2, 5);
}

int main(int argc, char ** argv)
{
    int x1 EXTRAP = atoi(argv[1]);
    int x2 EXTRAP = atoi(argv[2]);
    perf_taint::register_variable(&x1, VARIABLE_NAME(x1));
    perf_taint::register_variable(&x2, VARIABLE_NAME(x2));
    perf_taint::register_variable(&global, VARIABLE_NAME(global));
    int y = 2*x1 + 1;

    // pass param, pass global
    f(global, x1);
    f(x2, 100);
    // pass nothing, access global
    g(100);
    // pass nothing, access nothing
    h(x2);
    h(100);
    // pass each arg separetely
    i(x2, x1, 15*global);

    return 0;
}
