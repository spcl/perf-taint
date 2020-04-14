#include <stdio.h>
#include <stdlib.h>
#define OMPI_SKIP_MPICXX
//https://github.com/open-mpi/ompi/blob/master/ompi/include/mpi.h.in#L2749
#include <mpi.h>

#include "ExtraPInstrumenter.hpp"

void send(int rank, int size, int * send_value)
{
  MPI_Request r1, r2;
  // no dependency
  MPI_Isend(send_value, 1, MPI_INT, 1 - rank, 0, MPI_COMM_WORLD, &r1);
  // size dependency, no p dependency
  MPI_Isend(send_value, size, MPI_INT, 1 - rank, 1, MPI_COMM_WORLD, &r2);
  // no size dependency, p dependency
  MPI_Send(send_value, 1, MPI_INT, 1 - rank, 2, MPI_COMM_WORLD);
  // size dependency, p dependency
  MPI_Send(send_value, size, MPI_INT, 1 - rank, 3, MPI_COMM_WORLD);
  MPI_Wait(&r1, MPI_STATUS_IGNORE);
  MPI_Wait(&r2, MPI_STATUS_IGNORE);
}

void rcv(int rank, int size, int *rcv_value)
{
  MPI_Request r1, r2;
  // no dependency
  MPI_Irecv(rcv_value, 1, MPI_INT, 1 - rank, 0, MPI_COMM_WORLD, &r1);
  // size dependency, no p dependency
  MPI_Irecv(rcv_value, size, MPI_INT, 1 - rank, 1, MPI_COMM_WORLD, &r2);
  // no size dependency, p dependency
  MPI_Recv(rcv_value, 1, MPI_INT, 1 - rank, 2, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
  // size dependency, p dependency
  MPI_Recv(rcv_value, size, MPI_INT, 1 - rank, 3, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
  MPI_Wait(&r1, MPI_STATUS_IGNORE);
  MPI_Wait(&r2, MPI_STATUS_IGNORE);
}

int main(int argc, char ** argv)
{
  int param EXTRAP = 1;
  MPI_Init(&argc, &argv);
  int ranks, rank_id;
  MPI_Comm_size(MPI_COMM_WORLD, &ranks);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank_id);
  register_variable(&param, "param");

  int rcv_val = 0, send_val = 1;
  send(rank_id, param, &send_val);
  rcv(rank_id, param, &send_val);

  MPI_Finalize();
  return 0;
}
