#include <stdio.h>
#include <stdlib.h>
#define OMPI_SKIP_MPICXX
//https://github.com/open-mpi/ompi/blob/master/ompi/include/mpi.h.in#L2749
#include <mpi.h>

#include "ExtraPInstrumenter.hpp"

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
