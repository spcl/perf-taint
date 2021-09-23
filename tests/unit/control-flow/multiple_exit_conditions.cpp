// RUN: %clangxx %cxx_flags %s -emit-llvm -o %t1.bc
// RUN: %opt %opt_flags %opt_cfsan < %t1.bc 2> /dev/null > %t1.tainted.bc
// RUN: %llc %llc_flags < %t1.tainted.bc > %t1.tainted.o
// RUN: %clangxx %link_flags %t1.tainted.o -o %t1.exe
// RUN: %execparams %t1.exe 10 10 10 > %t1.json
// RUN: diff -w %s.json %t1.json
// RUN: %jsonconvert %t1.json > %t2.json
// RUN: diff -w %s.processed.json %t2.json

#include <cmath>
#include <cstdlib>

#include "perf-taint/PerfTaint.hpp"

int global EXTRAP = 10000;

int mul(int x, int y)
{
    return x + y;
}


// Control-flow tainting version.
// Here the exit condition influences the value of `i` through the control-flow tainting
// Thus, it influences the first condition as well.
int f(int x1, int x2)
{
    int tmp = 1;
    // First exit condition - depends on x1, x2
    for(int i = 0; i < mul(x1, x2); ++i) {
        tmp += i;
        // Second exit condition
        if(tmp > global)
          break;
    }
    return tmp;
}

int main(int argc, char ** argv)
{
    int x1 EXTRAP = atoi(argv[1]);
    int x2 EXTRAP = atoi(argv[2]);
    perf_taint::register_variable(&x1, VARIABLE_NAME(x1));
    perf_taint::register_variable(&x2, VARIABLE_NAME(x2));
    perf_taint::register_variable(&global, VARIABLE_NAME(global));
    int y = 2*x1 + 1;

    // dependency on global
    f(5, 5);
    // dependency on x1 AND global
    f(x1, 2);
    // dependency on x2 AND global
    f(x2, 3);
    // dependency on x1 x2 AND global
    f(x2, x1 + 1);
    // dependency on x1 x2 global
    // we have dependency on x1 x2 global AND global
    // but we check for label inclusion to avoid trivial duplicates
    // global is a subset of x1 x2 global - so a single label
    f(global/x2, x1 + 1);

    global += x2;
    // dependency on x1 AND x2 global
    f(2, x1 + 1);

    return 0;
}