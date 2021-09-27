// RUN: %clangxx %cxx_flags %s -emit-llvm -o %t1.bc
// RUN: %opt %opt_flags < %t1.bc 2> /dev/null > %t1.tainted.bc
// RUN: %llc %llc_flags < %t1.tainted.bc > %t1.tainted.o
// RUN: %clangxx %link_flags %t1.tainted.o -o %t1.exe
// RUN: %execparams %t1.exe 10 10 > %t1.json
// RUN: diff -w %s.json %t1.json

#include <cmath>
#include <cstdlib>

#include "perf-taint/PerfTaint.hpp"

// No parameters and functions.
// Catches a regression when we could fail on such function.

int main(int argc, char ** argv)
{
    return 0;
}

