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

void bcast(int rank, int size)
{
  int data = 0;
  int s = 1;
  // no dependency
  MPI_Bcast(&data, s, MPI_INT, 0, MPI_COMM_WORLD);
  // dependency
  MPI_Bcast(&data, size, MPI_INT, 1, MPI_COMM_WORLD);
}

void alltoall(int rank, int size, int size2)
{
  int send_data[] = {0, 0};
  int rcv_data[] = {0, 0};
  int s = 2;

  // no dependency
  MPI_Alltoall(send_data, s, MPI_INT, rcv_data, s, MPI_INT, MPI_COMM_WORLD);
  // send buffer dep
  MPI_Alltoall(send_data, size + 1, MPI_INT, rcv_data, s, MPI_INT, MPI_COMM_WORLD);
  // rcv buffer dep
  MPI_Alltoall(send_data, s, MPI_INT, rcv_data, size2 + 1, MPI_INT, MPI_COMM_WORLD);
  // send, rcv buffer dep
  MPI_Alltoall(send_data, size + 1, MPI_INT, rcv_data, size2 + 1, MPI_INT, MPI_COMM_WORLD);
}

void allgather(int rank, int size, int size2)
{
  int send_data[] = {0};
  int rcv_data[] = {0, 0, 0, 0};
  int s = 1;

  // no dependency
  MPI_Allgather(send_data, s, MPI_INT, rcv_data, s, MPI_INT, MPI_COMM_WORLD);
  // send buffer dep
  MPI_Allgather(send_data, size, MPI_INT, rcv_data, s, MPI_INT, MPI_COMM_WORLD);
  // rcv buffer dep
  MPI_Allgather(send_data, s, MPI_INT, rcv_data, size2, MPI_INT, MPI_COMM_WORLD);
  // send, rcv buffer dep
  MPI_Allgather(send_data, size, MPI_INT, rcv_data, size2, MPI_INT, MPI_COMM_WORLD);
}

void scan(int rank, int size)
{
  int send_data[] = {0};
  int rcv_data[] = {0};
  int s = 1;

  // no dependency
  MPI_Scan(send_data, rcv_data, s, MPI_INT, MPI_SUM, MPI_COMM_WORLD);
  // send buffer dep
  MPI_Scan(send_data, rcv_data, size, MPI_INT, MPI_SUM, MPI_COMM_WORLD);
}

void reduce(int rank, int size)
{
  int send_data[] = {0};
  int rcv_data[] = {0};
  int s = 1;

  // no dependency
  MPI_Reduce(send_data, rcv_data, s, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);
  // send buffer dep
  MPI_Reduce(send_data, rcv_data, size, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);
}

void allreduce(int rank, int size)
{
  int send_data[] = {0};
  int rcv_data[] = {0, 0};
  int s = 1;

  // no dependency
  MPI_Allreduce(send_data, rcv_data, s, MPI_INT, MPI_SUM, MPI_COMM_WORLD);
  // send buffer dep
  MPI_Allreduce(send_data, rcv_data, size, MPI_INT, MPI_SUM, MPI_COMM_WORLD);
}


int main(int argc, char ** argv)
{
  int param EXTRAP = 1, param2 EXTRAP = 1;
  MPI_Init(&argc, &argv);
  int ranks, rank_id;
  MPI_Comm_size(MPI_COMM_WORLD, &ranks);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank_id);
  register_variable(&param, "param");
  register_variable(&param2, "param2");

  bcast(rank_id, param);
  alltoall(rank_id, param, param2);
  allgather(rank_id, param, param2);
  scan(rank_id, param);
  reduce(rank_id, param);
  allreduce(rank_id, param);

  MPI_Finalize();
  return 0;
}
