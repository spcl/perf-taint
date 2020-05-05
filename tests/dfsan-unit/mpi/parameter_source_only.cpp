// RUN: %clangxx %cxx_flags %mpi_flags %s -emit-llvm -o %t1.bc
// RUN: %opt %opt_flags %opt_mpi -extrap-extractor-out-name=%t3 < %t1.bc \
// RUN:     2> /dev/null > %t1.tainted.bc
// RUN: %llc %llc_flags < %t1.tainted.bc > %t1.tainted.o
// RUN: %clangxx %link_flags %t1.tainted.o -o %t1.exe
// RUN: %execparams mpiexec -n 2 %t1.exe
// RUN: diff -w %s.json %t3_0.json
// RUN: diff -w %s.json %t3_1.json

// RUN: %opt %opt_flags %opt_mpi %opt_cfsan -extrap-extractor-out-name=%t4 \
// RUN:     < %t1.bc 2> /dev/null > %t2.tainted.bc
// RUN: %llc %llc_flags < %t2.tainted.bc > %t2.tainted.o
// RUN: %clangxx %link_flags %t2.tainted.o -o %t2.exe
// RUN: %execparams mpiexec -n 2 %t2.exe
// RUN: diff -w %s.json %t4_0.json
// RUN: diff -w %s.json %t4_1.json

#include <stdio.h>
#include <stdlib.h>
#define OMPI_SKIP_MPICXX
//https://github.com/open-mpi/ompi/blob/master/ompi/include/mpi.h.in#L2749
#include <mpi.h>

#include "ExtraPInstrumenter.hpp"

int source()
{
  int size;
  MPI_Comm_size(MPI_COMM_WORLD, &size);
  return size;
}

int test_implicit_parameter1()
{
  int size, sum;
  MPI_Comm_size(MPI_COMM_WORLD, &size);
  for(int i = 0; i < size; ++i)
    sum += i;
  return sum;
}

int test_implicit_parameter2(int size)
{
  int sum;
  for(int i = 0; i < size; ++i)
    sum += i;
  return sum;
}
int main(int argc, char ** argv)
{
  MPI_Init(&argc, &argv);

  test_implicit_parameter1();
  test_implicit_parameter2(source());

  MPI_Finalize();
  return 0;
}
