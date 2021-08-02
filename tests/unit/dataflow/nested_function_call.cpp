// RUN: %clangxx %cxx_flags %s -emit-llvm -o %t1.bc
// RUN: %opt %opt_flags < %t1.bc 2> /dev/null > %t1.tainted.bc
// RUN: %llc %llc_flags < %t1.tainted.bc > %t1.tainted.o
// RUN: %clangxx %link_flags %t1.tainted.o -o %t1.exe
// RUN: %execparams %t1.exe 10 10 10 > %t1.json
// RUN: diff -w %s.json %t1.json
// RUN: %jsonconvert %t1.json > %t2.json
// RUN: diff -w %s.processed.json %t2.json

// RUN: %opt %opt_flags %opt_cfsan < %t1.bc 2> /dev/null > %t2.tainted.bc
// RUN: %llc %llc_flags < %t2.tainted.bc > %t2.tainted.o
// RUN: %clangxx %link_flags %t2.tainted.o -o %t2.exe
// RUN: %execparams %t2.exe 10 10 10 > %t3.json
// RUN: diff -w %s.json %t3.json
// RUN: %jsonconvert %t3.json > %t4.json
// RUN: diff -w %s.processed.json %t4.json

#include <cstdlib>

#include "perf-taint/PerfTaint.hpp"

int global = 12;

int f(int x)
{
    int tmp = 0;
    for(int i = 0; i < x; ++i)
        tmp += i;
    return tmp;
}

int g(int x)
{
    int tmp = 0;
    for(int i = 0; i < x; ++i)
        tmp += f(x);
    return tmp;
}

// simply adds a third loop level
int single_nest(int x, int y)
{
    int tmp = 0;
    for(int i = x; i < global; ++i)
        for(int j = 0; j < y; ++j)
            tmp += f(i);
    return tmp;
}

// effectively create a 4d loop
// g should appear as 2d loop
// and f should appear as 1d loop
int double_nest(int x, int y)
{
    int tmp = 0;
    for(int i = x; i < global; ++i)
        for(int j = y; j < global; ++j)
            tmp += g(j);
    return tmp;
}

//// function call outside of loop
//// add as a multipath
int double_nest_outside(int x, int y)
{
    int tmp = g(x);
    for(int i = x; i < global; ++i)
        for(int j = 0; j < y; ++j)
            tmp += i;
    return tmp;
}

// add two loops as multipath and two calls in the same function (diff func)
int multipath_nest(int x, int y)
{
    int tmp = 0;
    for(int i = x; i < global; ++i) {
        tmp += g(x);
        for(int j = 0; j < y; ++j)
            tmp += i;
        tmp += f(y);
    }
    return tmp;
}

// create two instances - one where g is called with param and one without
int multipath_nest(int x, int y, int z)
{
    int tmp = 0;
    for(int i = x; i < global; ++i) {
        tmp += g(z);
        for(int j = 0; j < y; ++j)
            tmp += i;
    }
    return tmp;
}

// aggregate two loops
int aggregate_nest(int x, int y)
{
    int tmp = 0;
    for(int i = x; i < global; ++i) {
        int val = i == x ? x : x + y;
        tmp += g(val);
        for(int j = 0; j < y; ++j)
            tmp += i;
    }
    return tmp;
}

int unimportant_function(int x)
{
    return 2 * f(x);
}

int call_unimportant_function(int x, int y)
{
    int tmp = 0;
    for(int i = x; i < global; ++i) {
        tmp += i;
    }
    tmp += unimportant_function(x + y);
    return tmp;
}

int main(int argc, char ** argv)
{
    int x1 EXTRAP = atoi(argv[1]);
    int x2 EXTRAP = atoi(argv[2]);
    int x3 = atoi(argv[3]);
    perf_taint::register_variable(&x1, VARIABLE_NAME(x1));
    perf_taint::register_variable(&x2, VARIABLE_NAME(x2));

    single_nest(x1, x2);
    double_nest(x1, x2);
    double_nest_outside(x1, x2);
    multipath_nest(x1, x2);
    multipath_nest(x1, x2, x1 + x2);
    multipath_nest(x1, x2, x3);
    aggregate_nest(x1, x2);
    call_unimportant_function(x1, x2);

    return 0;
}
