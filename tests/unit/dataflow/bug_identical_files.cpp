// RUN: pushd %S && %clangxx %cxx_flags $(basename %s) -emit-llvm -o %t1.bc && popd
// RUN: pushd %S/bug_identical_files_subdirectory && %clangxx %cxx_flags $(basename %s) -emit-llvm -o %t2.bc && popd
// RUN: %llvm_link %t1.bc %t2.bc -o %t3.bc
// RUN: %opt %opt_flags < %t3.bc 2> /dev/null > %t1.tainted.bc
// RUN: %llc %llc_flags < %t1.tainted.bc > %t1.tainted.o
// RUN: %clangxx %link_flags %t1.tainted.o -o %t1.exe
// RUN: %execparams %t1.exe 10 10 10 > %t1.json
// RUN: diff -w %s.json %t1.json
// RUN: %jsonconvert %t1.json > %t2.json
// RUN: diff -w %s.processed.json %t2.json

#include <cmath>
#include <cstdlib>

#include "perf-taint/PerfTaint.hpp"

// Reproduce a bug caused by functions with the same filename.
// This happens in systems where the compilation is conducted by recursively visiting
// subdirectories in a repository.
// Users can have a TU with the same filename but placed in different directories.

int g(int x1, int x2);

int f(int x1, int x2)
{
    int tmp = 1;
    // First exit condition - depends on x1, x2
    for(int i = 0; i < x1 * x2; ++i) {
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

    f(x1, x2);
    g(x1, x2);

    return 0;
}
