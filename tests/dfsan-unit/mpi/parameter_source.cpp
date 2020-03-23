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

int test_implicit_parameter1(int size_x)
{
  int size, sum;
  MPI_Comm_size(MPI_COMM_WORLD, &size);
  for(int i = 0; i < size + size_x; ++i)
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
  int param EXTRAP = 3;
  register_variable(&param, "param");

  test_implicit_parameter1(param);
  test_implicit_parameter2(source());

  MPI_Finalize();
  return 0;
}
