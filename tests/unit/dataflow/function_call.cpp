// RUN: %clangxx %cxx_flags %s -emit-llvm -o %t1.bc
// RUN: %opt %opt_flags < %t1.bc 2> /dev/null > %t1.tainted.bc
// RUN: %llc %llc_flags < %t1.tainted.bc > %t1.tainted.o
// RUN: %clangxx %link_flags %t1.tainted.o -o %t1.exe
// RUN: %execparams %t1.exe 10 10 > %t1.json
// RUN: diff -w %s.json %t1.json

// RUN: %opt %opt_flags %opt_cfsan < %t1.bc 2> /dev/null > %t2.tainted.bc
// RUN: %llc %llc_flags < %t2.tainted.bc > %t2.tainted.o
// RUN: %clangxx %link_flags %t2.tainted.o -o %t2.exe
// RUN: %execparams %t2.exe 10 10 > %t2.json
// RUN: diff -w %s.json %t2.json

#include <cmath>
#include <cstdlib>

#include "perf-taint/PerfTaint.hpp"

// This test verifies that functions are correctly detected
// according to usage of local and global parameters.

int global EXTRAP = 100;

int f(int x, int y)
{
    int tmp = 0;
    for(int i = x; i < y; ++i)
        tmp += i;
    return tmp*10*x + y/2;
}

int h(int x)
{
    int tmp = 0;
    for(int i = x; i < 100; ++i)
        tmp += i;
    return 100 * x * std::log((double)x);
}

int g(int x)
{
    return global ? h(100 + x + std::pow((double)global, 3.0)) : 1;
}

int i(int x1, int x2, int x3)
{
    int tmp = 0;
    for(int i = x1; i < x2; i += x3)
        tmp += i*1.1;
    return 100 * x1 * x2 + x3 * 2;
}

int main(int argc, char ** argv)
{
    int x1 EXTRAP = atoi(argv[1]);
    int x2 EXTRAP = atoi(argv[2]);
    register_variable(&x1, VARIABLE_NAME(x1));
    register_variable(&x2, VARIABLE_NAME(x2));
    register_variable(&global, VARIABLE_NAME(global));
    int y = 2*x1 + 1;

    // pass param, pass global
    f(global, x1);
    // pass nothing, access global
    g(100);
    // pass nothing, access nothing
    h(x2);
    h(100);
    // pass two args, pass arg, nothing
    i(y + x2, x1, 15);

    return 0;
}
