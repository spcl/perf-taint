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

#include "perf-taint/PerfTaint.hpp"

void prepare(int rank, int * send_value, int * rcv_value, MPI_Request * send, MPI_Request * rcv)
{
  MPI_Irecv(rcv_value, 1, MPI_INT, 1 - rank, 0, MPI_COMM_WORLD, rcv);
  MPI_Isend(send_value, 1, MPI_INT, 1 - rank, 0, MPI_COMM_WORLD, send);
}

void wait(MPI_Request send, MPI_Request rcv)
{
  MPI_Wait(&rcv, MPI_STATUS_IGNORE);
  MPI_Wait(&send, MPI_STATUS_IGNORE);
}

int main(int argc, char ** argv)
{
  MPI_Init(&argc, &argv);
  int ranks, rank_id;
  MPI_Comm_size(MPI_COMM_WORLD, &ranks);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank_id);

  int rcv_val = 0, send_val = 1;
  MPI_Request send, rcv;
  prepare(rank_id, &send_val, &rcv_val, &send, &rcv);
  wait(send, rcv);

  MPI_Finalize();
  return 0;
}
