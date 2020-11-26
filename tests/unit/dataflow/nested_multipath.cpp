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


// second level loops does not contribute anything
int nest_const(int x, int y)
{
    int tmp = 0;
    for(int i = x; i < global; ++i) {
        for(int j = 0; j < 10; ++j)
            tmp += i;
        for(int j = 0; j < global; ++j)
            tmp += i;
    }
    return tmp;
}

int nest_partial(int x, int y)
{
    int tmp = 0;
    // x
    for(int i = x; i < global; ++i) {

        // y
        for(int j = 0; j < y; ++j)
            tmp += i;

        // empty
        for(int j = 0; j < global; ++j)
            tmp += i;

        // y, x
        for(int j = x; j < global; j += y)
            tmp += i;
    }
    return tmp;
}

// two loops with different depths
int double_nest_partial(int x, int y)
{
    int tmp = 0;
    // x, y
    for(int i = x; i < global; i += y) {

        // empty
        for(int j = 0; j < 100; ++j)
            tmp += i;

        // x
        for(int j = x; j < global; ++j)
            tmp += i;

        // y 
        for(int j = 0; j < global; j += y)
            tmp += i;
    }

    // x
    for(int i = x; i < global; ++i) {

        // y
        for(int j = 0; j < y; ++j)
            tmp += i;

        // empty
        for(int j = 0; j < global; ++j)
            tmp += i;

        // y, x
        for(int j = x; j < global; j += y)
            tmp += i;
    }
    return tmp;
}

// triple nested
int nest_triple(int x, int y)
{
    int tmp = 0;
    // x
    for(int i = x; i < global; ++i) {

        // y
        for(int j = 0; j < y; ++j) {
            // x, y
            for(int k = y; k < global; k += x)
                tmp += k;
        }

        // empty
        for(int j = 0; j < 10; ++j) {
            // x, y
            for(int k = x; k < global; k += y)
                tmp += k;
            // y
            for(int k = 0; k < y; k++)
                tmp += k;
        }
    }
    return tmp;
}

// two triple nested
int double_nest_triple(int x, int y)
{
    int tmp = 0;
    // y
    for(int i = y; i < global; ++i) {
        // y
        for(int j = 0; j < y; ++j) {
            // y, x
            for(int k = y; k < global; k += x)
                tmp += i;
        }

        // empty
        for(int j = 0; j < 10; ++j) {
            // x, y
            for(int k = x; k < global; k += y)
                tmp += i;
            // y
            for(int k = 0; k < y; k++)
                tmp += i;
        }
    }

    // x
    for(int i = x; i < global; ++i) {
        // y
        for(int j = 0; j < y; ++j) {
            // x, y
            for(int k = y; k < global; k += x)
                tmp += i;
            // y
            for(int k = 0; k < y; k++)
                tmp += i;
        }

        // empty
        for(int j = 0; j < 10; ++j) {
            // x, y
            for(int k = x; k < global; k += y)
                tmp += i;
            // y
            for(int k = 0; k < y; k++)
                tmp += i;
        }
        // y
        for(int j = 0; j < global*10; j += y)
            tmp += i;

    }

    // should generate new output with y
    nest_triple(10, y);

    return tmp;
}

int three_loops(int x, int y)
{
    int tmp = 0;
    // empty
    for(int i = 0; i < global; ++i) {
        for(int j = 0; j < global; ++j) {
            for(int k = 0; k < 10; k++)
                tmp += i;
        }
    }

    // x
    for(int i = x; i < global; ++i) {
        // y
        for(int j = 0; j < y; ++j) {
            // x, y
            for(int k = y; k < global; k += x)
                tmp += i;
            // y
            for(int k = 0; k < y; k++)
                tmp += i;
        }
    }

    // x
    for(int i = x; i < global; ++i)
        // y
        for(int j = 0; j < y; ++j)
            tmp += i;

    // should appear aggregated as another callstack
    nest_partial(x, y);

    return tmp;
}

int main(int argc, char ** argv)
{
    int x1 EXTRAP = atoi(argv[1]);
    int x2 EXTRAP = atoi(argv[2]);
    int x3 = atoi(argv[3]);
    register_variable(&x1, VARIABLE_NAME(x1));
    register_variable(&x2, VARIABLE_NAME(x2));

    nest_const(x1, x2);
    //// should appear only once
    nest_partial(x1, x2);
    nest_partial(x1, x2);
    double_nest_partial(x1, x2);
    nest_triple(x1, x2);
    // should generate a new output with x
    nest_triple(x1, x3);
    double_nest_triple(x1, x2);
    three_loops(x1, x2);

    return 0;
}
