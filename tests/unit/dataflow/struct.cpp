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
#include <random>
#include <iostream>

#include "perf-taint/PerfTaint.hpp"

#define BLOCK_SIZE 64

struct Params
{
    int ranks EXTRAP;
    int block_size;
    int problem_size EXTRAP;
    double tolerance;
};

Params global_params EXTRAP = {100, 100, 100, 0.2};

// problem_size influences control flow
// global ranks accessed
double print_params(Params * params)
{
    double tmp = 0;
    for(int i = params->ranks; i < params->problem_size; ++i) {
        tmp += i*params->tolerance + global_params.problem_size;
    }
    return tmp;
}

// called with one param
int do_sth(int x, int y)
{
    int tmp = 1;
    for(int i = 0; i < x; i += y) {
        tmp *= i;
    }
    return tmp;
}

// called with nothing, pruned
// accessed unimportant global
int do_sth2(double x, int y)
{
    int tmp = global_params.tolerance;
    for(int i = 0; i < x; i += y) {
        tmp *= i;
    }
    return tmp;
}

// prunable but passes parameter further
// check that we propagate params correctly
int do_sth3(Params & params)
{
    return do_sth(params.ranks + params.problem_size, params.problem_size);
}

int main(int argc, char ** argv)
{
    Params params EXTRAP;
    params.ranks = rand() % 5;
    params.problem_size = atoi(argv[1]);
    params.block_size = BLOCK_SIZE;
    params.tolerance = atof(argv[2]);
    perf_taint::register_variable(&params.ranks, VARIABLE_NAME(params.ranks));
    perf_taint::register_variable(&params.problem_size, VARIABLE_NAME(params.problem_size));
    perf_taint::register_variable(&global_params.problem_size, VARIABLE_NAME(global_params.problem_size));
    perf_taint::register_variable(&global_params.ranks, VARIABLE_NAME(global_params.ranks));

    // check that everything is passed
    print_params(&params);

    // called only with param 1
    do_sth(params.problem_size*2 + 100, global_params.ranks + params.block_size);

    //// called with nothing
    do_sth2(params.tolerance, params.block_size);

    // called with all param
    do_sth3(params);

    return 0;
}
