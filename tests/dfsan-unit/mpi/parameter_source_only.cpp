#include <stdio.h>
#include <stdlib.h>
#define OMPI_SKIP_MPICXX
//https://github.com/open-mpi/ompi/blob/master/ompi/include/mpi.h.in#L2749
#include <mpi.h>

#include "ExtraPInstrumenter.hpp"

int source()
{
  int size EXTRAP;
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
