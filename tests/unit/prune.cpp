// RUN: %clangxx %cxx_flags %s -emit-llvm -o %t1.bc
// RUN: %opt %opt_flags < %t1.bc 2> /dev/null > %t1.tainted.bc
// RUN: %llc %llc_flags < %t1.tainted.bc > %t1.tainted.o
// RUN: %clangxx %link_flags %t1.tainted.o -o %t1.exe
// RUN: echo 10 | %execparams %t1.exe 10 > %t1.json
// RUN: diff -w %s.json %t1.json

// RUN: %opt %opt_flags %opt_cfsan < %t1.bc 2> /dev/null > %t2.tainted.bc
// RUN: %llc %llc_flags < %t2.tainted.bc > %t2.tainted.o
// RUN: %clangxx %link_flags %t2.tainted.o -o %t2.exe
// RUN: echo 10 | %execparams %t2.exe 10 > %t2.json
// RUN: diff -w %s.json %t2.json

#include <cmath>
#include <cstdlib>
#include <iostream>

#include "ExtraPInstrumenter.hpp"

int global EXTRAP = 100;
double global2 EXTRAP = 3.14;

// Show because passed with global/global2 not because it is accessed
int h(int x)
{
    int t = 0;
    for(int i = 0; i < (2*x + 1); ++i)
        t += i;
    return 2*global + t;
}

// Can be pruned since global is accessed only in the function call
int g_prune(int x)
{
    return global * h(x + std::pow((double)x, std::exp(global2)));
}

int g_not_prune(int x)
{
    int tmp = 0;
    for(int i = 0; i < x; ++i)
        tmp += i;
    if(global2 + 1 < 0)
        return h(100 + tmp + std::pow((double)global, 3.0));
    else
        return h(200*global + std::pow((double)x, 3.0));
}

int f_prune(int x, int y)
{
    g_prune(x);
    g_not_prune(y);
    return h(y);
}

// Don't prune since x is used outside of call
int f_not_prune(int x, int y)
{
    int tmp = 0;
    for(int i = y; i < 10; ++i)
        tmp += i;
    g_prune(x);
    g_not_prune(y);
    return h(tmp + y);
}

int main(int argc, char ** argv)
{
    int x1 EXTRAP = atoi(argv[1]);
    int x2 EXTRAP;
    std::cin >> x2;
    register_variable(&x1, VARIABLE_NAME(x1));
    register_variable(&x2, VARIABLE_NAME(x2));
    register_variable(&global, VARIABLE_NAME(global));
    register_variable(&global2, VARIABLE_NAME(global2));

    f_prune(1, 2);
    f_not_prune(1, 2);

    f_prune(x1, 2*x1 + x2 - 1);
    f_not_prune(x1, 2*x1 + x2 - 1);

    return 0;
}
