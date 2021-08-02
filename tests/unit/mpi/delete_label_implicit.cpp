// RUN: %clangxx %cxx_flags %mpi_flags %s -emit-llvm -o %t1.bc
// RUN: %opt %opt_flags %opt_mpi -perf-taint-out-name=%t3 < %t1.bc \
// RUN:     2> /dev/null > %t1.tainted.bc
// RUN: %llc %llc_flags < %t1.tainted.bc > %t1.tainted.o
// RUN: %clangxx %link_flags %t1.tainted.o -o %t1.exe
// RUN: %execparams mpiexec -n 2 %t1.exe 10 10 10

// RUN: %opt %opt_flags %opt_mpi %opt_cfsan -perf-taint-out-name=%t4 \
// RUN:     < %t1.bc 2> /dev/null > %t2.tainted.bc
// RUN: %llc %llc_flags < %t2.tainted.bc > %t2.tainted.o
// RUN: %clangxx %link_flags %t2.tainted.o -o %t2.exe
// RUN: %execparams mpiexec -n 2 %t2.exe 10 10

#include <cmath>
#include <cstdlib>
#include <cassert>
#define OMPI_SKIP_MPICXX
//https://github.com/open-mpi/ompi/blob/master/ompi/include/mpi.h.in#L2749
#include <mpi.h>

#include "perf-taint/PerfTaint.hpp"

// The simplest possible example.

int f(int x, int y)
{
  int tmp = 0;
  for(int i = x; i < y; ++i)
      tmp += i;
  return tmp*10*x + y/2;
}

int main(int argc, char ** argv)
{
  MPI_Init(&argc, &argv);
  int x1 EXTRAP = atoi(argv[1]);
  int x2 EXTRAP = 2*atoi(argv[2]);
  int x3 EXTRAP;
  MPI_Comm_size(MPI_COMM_WORLD, &x3);
  perf_taint::register_variable(&x1, VARIABLE_NAME(x1));
  perf_taint::register_variable(&x2, VARIABLE_NAME(x2));

  int x1_x3 = x1 + x3;
  int x2_x3 = x2 + x3;
  int x1_x2_x3 = x1 + x2 + x3;

  assert(perf_taint::has_label(&x1, "x1"));
  assert(perf_taint::has_label(&x2, "x2"));
  assert(perf_taint::has_label(&x3, "p"));
  assert(perf_taint::has_label(&x1_x3, "x1"));
  assert(perf_taint::has_label(&x1_x3, "p"));
  assert(perf_taint::has_label(&x2_x3, "x2"));
  assert(perf_taint::has_label(&x2_x3, "p"));
  assert(perf_taint::has_label(&x1_x2_x3, "x1"));
  assert(perf_taint::has_label(&x1_x2_x3, "x2"));
  assert(perf_taint::has_label(&x1_x2_x3, "p"));

  // delete existing implicit label
  int x4 = x3;
  assert(perf_taint::has_label(&x4, "p"));
  perf_taint::delete_label(&x4, "p");
  assert(!perf_taint::has_label(&x4, "x1"));
  assert(!perf_taint::has_label(&x4, "x2"));
  assert(!perf_taint::has_label(&x4, "p"));

  // delete non-existing implicit label
  int x5 = x3;
  assert(perf_taint::has_label(&x5, "p"));
  perf_taint::delete_label(&x5, "x2");
  assert(perf_taint::has_label(&x5, "p"));
  assert(!perf_taint::has_label(&x5, "x2"));
  assert(!perf_taint::has_label(&x5, "x2"));

  // delete implicit out of two labels
  int x6 = x1_x3;
  assert(perf_taint::has_label(&x6, "x1"));
  assert(perf_taint::has_label(&x6, "p"));
  perf_taint::delete_label(&x6, "p");
  assert(perf_taint::has_label(&x6, "x1"));
  assert(!perf_taint::has_label(&x6, "p"));
  assert(!perf_taint::has_label(&x6, "x2"));

  // delete explicit out of two labels
  x6 = x1_x3;
  assert(perf_taint::has_label(&x6, "x1"));
  assert(perf_taint::has_label(&x6, "p"));
  perf_taint::delete_label(&x6, "x1");
  assert(perf_taint::has_label(&x6, "p"));
  assert(!perf_taint::has_label(&x6, "x1"));
  assert(!perf_taint::has_label(&x6, "x2"));

  // delete two explicit of three labels
  int x8 = x1_x2_x3;
  assert(perf_taint::has_label(&x8, "x1"));
  assert(perf_taint::has_label(&x8, "x2"));
  assert(perf_taint::has_label(&x8, "p"));
  perf_taint::delete_label(&x8, "x2");
  perf_taint::delete_label(&x8, "x1");
  assert(perf_taint::has_label(&x8, "p"));
  assert(!perf_taint::has_label(&x8, "x1"));
  assert(!perf_taint::has_label(&x8, "x2"));

  // delete implicit + explicit of three labels
  x8 = x1_x2_x3;
  assert(perf_taint::has_label(&x8, "x1"));
  assert(perf_taint::has_label(&x8, "x2"));
  assert(perf_taint::has_label(&x8, "p"));
  perf_taint::delete_label(&x8, "x2");
  perf_taint::delete_label(&x8, "p");
  assert(perf_taint::has_label(&x8, "x1"));
  assert(!perf_taint::has_label(&x8, "p"));
  assert(!perf_taint::has_label(&x8, "x2"));

  MPI_Finalize();
  return 0;
}
