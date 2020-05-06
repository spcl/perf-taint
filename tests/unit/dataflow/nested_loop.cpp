// RUN: %clangxx %cxx_flags %s -emit-llvm -o %t1.bc
// RUN: %opt %opt_flags < %t1.bc 2> /dev/null > %t1.tainted.bc
// RUN: %llc %llc_flags < %t1.tainted.bc > %t1.tainted.o
// RUN: %clangxx %link_flags %t1.tainted.o -o %t1.exe
// RUN: %execparams %t1.exe 10 10 10 > %t1.json
// RUN: diff -w %s.json %t1.json

// RUN: %opt %opt_flags %opt_cfsan < %t1.bc 2> /dev/null > %t2.tainted.bc
// RUN: %llc %llc_flags < %t2.tainted.bc > %t2.tainted.o
// RUN: %clangxx %link_flags %t2.tainted.o -o %t2.exe
// RUN: %execparams %t2.exe 10 10 10 > %t2.json
// RUN: diff -w %s.json %t2.json

#include <cstdlib>

#include "perf-taint/PerfTaint.hpp"

int global = 100;

int perf_nest_unknown(int x, int y)
{
    int tmp = 0;
    for(int i = x; i < global; ++i)
        for(int j = 0; j < y; ++j)
            tmp += i;
    return tmp;
}

// perfectly nested - second loop is const
int perf_nest_const(int x, int y)
{
    int tmp = 0;
    for(int i = x; i < global; ++i)
        for(int j = 0; j < 10; ++j)
            tmp += i;
    return tmp;
}

// perfectly nested - second loop is does not contribute parameter complexity
int perf_nest_linear(int x, int y)
{
    int tmp = 0;
    for(int i = x; i < global; ++i)
        for(int j = 0; j < global; ++j)
            tmp += i;
    return tmp;
}

// perfectly nested - second loop contributes mul complexity
int perf_nest_quadr(int x, int y)
{
    int tmp = 0;
    for(int i = x; i < global; ++i)
        for(int j = 0; j < y; ++j)
            tmp += i;
    return tmp;
}

// perfectly nested - first loop contributes pair and second loop
// contributes mul complexity
int perf_nest_multiple_quadr(int x, int y)
{
    int tmp = 0;
    for(int i = x; i < global; i += y)
        for(int j = 0; j < y; ++j)
            tmp += i;
    return tmp;
}

int main(int argc, char ** argv)
{
    int x1 EXTRAP = atoi(argv[1]);
    int x2 EXTRAP = atoi(argv[2]);
    int x3 = atoi(argv[3]);
    register_variable(&x1, VARIABLE_NAME(x1));
    register_variable(&x2, VARIABLE_NAME(x2));

    // should never appear
    perf_nest_unknown(global, 10);
    perf_nest_unknown(10, x3);
    // should appear just once
    perf_nest_const(x1, x2);
    perf_nest_const(x1, x2);
    // should appear twice with different args
    perf_nest_linear(x1, x2);
    perf_nest_linear(x2, x2);
    // should appear twice with reversed args
    perf_nest_quadr(x1, x2);
    perf_nest_quadr(x2, x1);
    perf_nest_multiple_quadr(x1, x2);

    return 0;
}
