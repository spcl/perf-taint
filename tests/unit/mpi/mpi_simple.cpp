// RUN: %clangxx %cxx_flags %mpi_flags %s -emit-llvm -o %t1.bc
// RUN: %opt %opt_flags %opt_mpi -perf-taint-out-name=%t3 < %t1.bc \
// RUN:     2> /dev/null > %t1.tainted.bc
// RUN: %llc %llc_flags < %t1.tainted.bc > %t1.tainted.o
// RUN: %clangxx %link_flags %t1.tainted.o -o %t1.exe
// RUN: %execparams mpiexec -n 2 %t1.exe 10 10 10
// RUN: diff -w %s.json %t3_0.json
// RUN: diff -w %s.json %t3_1.json
// RUN: %jsonconvert %t3_0.json > %t4_0.json
// RUN: diff -w %s.processed.json %t4_0.json

// RUN: %opt %opt_flags %opt_mpi %opt_cfsan -perf-taint-out-name=%t4 \
// RUN:     < %t1.bc 2> /dev/null > %t2.tainted.bc
// RUN: %llc %llc_flags < %t2.tainted.bc > %t2.tainted.o
// RUN: %clangxx %link_flags %t2.tainted.o -o %t2.exe
// RUN: %execparams mpiexec -n 2 %t2.exe 10 10
// RUN: diff -w %s.json %t4_0.json
// RUN: diff -w %s.json %t4_1.json
// RUN: %jsonconvert %t4_0.json > %t5_0.json
// RUN: diff -w %s.processed.json %t5_0.json

#include <stdio.h>
#include <stdlib.h>
#define OMPI_SKIP_MPICXX
//https://github.com/open-mpi/ompi/blob/master/ompi/include/mpi.h.in#L2749
#include <mpi.h>

#include "perf-taint/PerfTaint.hpp"

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
    perf_taint::register_variable(&size, VARIABLE_NAME(size));
    int ranks EXTRAP = 1, rank_id;
    MPI_Comm_size(MPI_COMM_WORLD, &ranks);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank_id);
    // here we want ranks and p seperately
    perf_taint::register_variable(&ranks, "ranks");

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
