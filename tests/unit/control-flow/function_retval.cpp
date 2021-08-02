// RUN: %clangxx %cxx_flags %s -emit-llvm -o %t1.bc
// RUN: %opt %opt_flags %opt_cfsan < %t1.bc 2> /dev/null > %t1.tainted.bc
// RUN: %llc %llc_flags < %t1.tainted.bc > %t1.tainted.o
// RUN: %clangxx %link_flags %t1.tainted.o -o %t1.exe
// RUN: %execparams %t1.exe 10 10 > %t1.json
// RUN: diff -w %s.json %t1.json
// RUN: %jsonconvert %t1.json > %t2.json
// RUN: diff -w %s.processed.json %t2.json

#include <cmath>
#include <cstdlib>

#include "perf-taint/PerfTaint.hpp"

// With cfsan, the return value of `g` now has the taint of both `x` and `y`.

int global EXTRAP = 100;

int g(int x, int y)
{
  int ret = 0;
  if(x)
    ret = 2 * y;
  else
    ret = y + 1;
  return ret;
}

int g2(int x, int y)
{
    return x + y + global;
}

struct test
{
    int x1, x2;

    test(int _x1, int _x2) :
        x1(_x1),
        x2(_x2)
    {}

    int length()
    {
        return x1;
    }
};

// pass label and receive retval with a control-flow dependence on x1 + x2
// shouldt be reported only if control-flow tainting is enabled
int f(int x1, int x2)
{
    int tmp = 1;
    for(int i = 0; i < g(x1 + x2, 1); ++i) {
        tmp += i;
    }
    return tmp;
}

// call does not include label but retval does
// should be reported
int h(int x1, int x2)
{
    int tmp = 1;
    for(int i = 0; i < g2(x2, 1); ++i) {
        tmp += i;
    }
    return tmp;
}

// report only test,t1
// incorrect parse of function will report entire test i.e. a pair (x1, x2)
int i(test * t)
{
    int tmp = 1;
    for(int i = 0; i < t->length(); ++i) {
        tmp += i;
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
    test t{x1, x2};

    // retval doesn't include label
    f(global, x1);
    f(x1 + x2, 2);
    // retval will have global label
    h(x1, 10);
    h(10, 10);
    // pass a pair
    i(&t);

    return 0;
}
