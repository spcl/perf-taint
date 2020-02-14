#include <stdio.h>
#include <stdlib.h>
#define OMPI_SKIP_MPICXX
//https://github.com/open-mpi/ompi/blob/master/ompi/include/mpi.h.in#L2749
#include <mpi.h>

#include "ExtraPInstrumenter.hpp"

void f(double * b, size_t size)
{
    while(size--) {
        *b += 2;
        ++b;
    }
}

double h_multiple_loops(double * data, size_t size)
{
    for(int i = 0; i < size; ++i)
        data[i]++;
    double acc_rcv = data[0];
    MPI_Reduce(data, &acc_rcv, 1, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);
    return acc_rcv;
}

double h(double * data)
{
    double acc_rcv = data[0];
    MPI_Reduce(data, &acc_rcv, 1, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);
    return acc_rcv;
}

void h_nested(double * data, size_t size)
{
    for(int i = 0; i < size; ++i) {
        h(&data[i]);
    }
}

int main(int argc, char ** argv)
{
    MPI_Init(&argc, &argv);
    int size EXTRAP = atoi(argv[1]);
    register_variable(&size, VARIABLE_NAME(size));
    int ranks EXTRAP = 1, rank_id;
    MPI_Comm_size(MPI_COMM_WORLD, &ranks);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank_id);
    // here we want ranks and p seperately
    register_variable(&ranks, "ranks");

    size /= ranks;
    int start = size * rank_id;
    double * data = (double*) calloc(size, sizeof(double));
    f(data, size);
    double acc_rcv = h_multiple_loops(data, size);
    h_nested(data, size);
    if(rank_id == 0)
        printf("%f\n", acc_rcv);
    MPI_Barrier(MPI_COMM_WORLD);
    free(data);
    MPI_Finalize();
    return 0;
}
