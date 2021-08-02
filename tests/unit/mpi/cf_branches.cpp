// RUN: %clangxx %cxx_flags %mpi_flags %s -emit-llvm -o %t1.bc
// RUN: %opt %opt_flags %opt_mpi -perf-taint-branches-enable -perf-taint-out-name=%t3 < %t1.bc 2> /dev/null > %t1.tainted.bc
// RUN: %llc %llc_flags < %t1.tainted.bc > %t1.tainted.o
// RUN: %clangxx %link_flags %t1.tainted.o -o %t1.exe
// RUN: %execparams mpiexec -n 2 %t1.exe 10 10 10
// RUN: diff -w %s.json %t3_0.json
// RUN: diff -w %s.json %t3_1.json
// RUN: %jsonconvert %t3_0.json > %t4_0.json
// RUN: diff -w %s.processed.json %t4_0.json

// RUN: %opt %opt_flags %opt_cfsan %opt_mpi -perf-taint-branches-enable -perf-taint-out-name=%t4 < %t1.bc 2> /dev/null > %t2.tainted.bc
// RUN: %llc %llc_flags < %t2.tainted.bc > %t2.tainted.o
// RUN: %clangxx %link_flags %t2.tainted.o -o %t2.exe
// RUN: %execparams mpiexec -n 2 %t2.exe 10 10
// RUN: diff -w %s.json %t4_0.json
// RUN: diff -w %s.json %t4_1.json
// RUN: %jsonconvert %t4_0.json > %t5_0.json
// RUN: diff -w %s.processed.json %t5_0.json

#include <cmath>
#include <cstdlib>
#define OMPI_SKIP_MPICXX
//https://github.com/open-mpi/ompi/blob/master/ompi/include/mpi.h.in#L2749
#include <mpi.h>

#include "perf-taint/PerfTaint.hpp"

int f(int x1, int x2, int x3)
{
  
    int tmp = 1;
    for(int i = 0; i < x2; ++i) {
      tmp += 2*i;
    }
    for(int i = 0; i < x1 + x2; ++i) {
      if(x3 > 5)
        tmp += i;
      else
        tmp += 2*i;
    }
    for(int i = 0; i < x1; ++i) {
      tmp += 2*i;
    }
    int tmp_rcv;
    MPI_Reduce(&tmp, &tmp_rcv, 1, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);
    return tmp_rcv;
}

int g(int x1, int x2, int x3)
{
  int tmp = 1;
  for(int j = x1; j < x2; ++j) {
    for(int i = 0; i < x2; ++i) {
      if(x2 > 5)
        tmp += i;
      else
        tmp += 2*i;
    }
    for(int i = 0; i < x1 + x2; ++i) {
      tmp += 2*i;
    }
    if(x1 == 0)
      tmp += j;
    else
      tmp += 2*j;
  }
  return tmp;
}

int m(int x1, int x2, int x3)
{
  int tmp = 1;
  for(int j = 0; j < x1 + x2; ++j) {
    for(int i = 0; i < x2; ++i) {
      if(x2 > 5)
        tmp += i;
      else
        tmp += 2*i;
      for(int k = 0; k < x1 + x2; ++k) {
        if(x3 > 5)
          tmp += i;
        else
          tmp += 2*i;

        if(x1 < 11)
          tmp += i;
        else
          tmp += 2*i;
      }
      for(int k = 0; k < x1 + x2; ++k) {
        tmp += 2;
      }
    }
  }
  MPI_Barrier(MPI_COMM_WORLD);
  return tmp;
}

int main(int argc, char ** argv)
{
    MPI_Init(&argc, &argv);
    int x1 EXTRAP = atoi(argv[1]);
    int x2 EXTRAP = atoi(argv[2]);
    perf_taint::register_variable(&x1, VARIABLE_NAME(x1));
    perf_taint::register_variable(&x2, VARIABLE_NAME(x2));
    int y = 2*x1 + 1;

    f(x2, y, 10);
    f(x2, y, x1);

    g(x2, y, 10);
    g(x2, y, x1);

    m(x1, x2, 10);
    m(x1, x2, x1 + x2);

    MPI_Finalize();
    return 0;
}
