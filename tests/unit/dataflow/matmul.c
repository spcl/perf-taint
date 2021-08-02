// RUN: %clang %c_flags %s -emit-llvm -o %t1.bc
// RUN: %opt %opt_flags < %t1.bc 2> /dev/null > %t1.tainted.bc
// RUN: %llc %llc_flags < %t1.tainted.bc > %t1.tainted.o
// RUN: %clangxx %link_flags %t1.tainted.o -o %t1.exe
// RUN: %execparams %t1.exe 50 30 40 > %t1.json
// RUN: diff -w %s.json %t1.json
// RUN: %jsonconvert %t1.json > %t2.json
// RUN: diff -w %s.processed.json %t2.json

// RUN: %opt %opt_flags %opt_cfsan < %t1.bc 2> /dev/null > %t2.tainted.bc
// RUN: %llc %llc_flags < %t2.tainted.bc > %t2.tainted.o
// RUN: %clangxx %link_flags %t2.tainted.o -o %t2.exe
// RUN: %execparams %t2.exe 50 30 40 > %t3.json
// RUN: diff -w %s.json %t3.json
// RUN: %jsonconvert %t3.json > %t4.json
// RUN: diff -w %s.processed.json %t4.json

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <stdbool.h>
#include <assert.h>

#include "perf-taint/PerfTaint.h"

typedef struct _matrix
{
    size_t rows;
    size_t cols;
    double * data;
} matrix;

matrix create_matrix(int rows, int cols, bool init)
{
    matrix m;
    m.rows = rows;
    m.cols = cols;
    m.data = (double*) calloc(rows * cols, sizeof(double));
    if(init) {
        size_t size = rows * cols;
        for(size_t i = 0; i < size; ++i)
            m.data[i] = rand() % 100;
    }
    return m;
}

matrix mat_mul(matrix * left, matrix * right)
{
    size_t m = left->rows, n = left->cols, k = right->cols;
    matrix res = create_matrix(m, k, false);

    for(size_t i = 0; i < m; ++i) {
        for(size_t j = 0; j < k; ++j) {
            double scalar_product = 0.0;
            for(size_t kk = 0; kk < n; ++kk) {
                scalar_product += left->data[i*n + kk] * right->data[kk*k + j];
            }
            res.data[i*k + j] = scalar_product;
        }
    }

    return res;
}

int main(int argc, char ** argv)
{
    int m EXTRAP, n EXTRAP, k EXTRAP;
    assert(argc == 4);
    m = atoi(argv[1]);
    n = atoi(argv[2]);
    k = atoi(argv[3]);
    srand(time(NULL));
    perf_taint_register_variable(&m, sizeof(m), VARIABLE_NAME(m));
    perf_taint_register_variable(&n, sizeof(n), VARIABLE_NAME(n));
    perf_taint_register_variable(&k, sizeof(k), VARIABLE_NAME(k));

    matrix left = create_matrix(m, n, true);
    matrix right = create_matrix(n, k, true);
    matrix res = mat_mul(&left, &right);

    fprintf(stderr, "%f\n", res.data[0]);

    free(left.data);
    free(right.data);
    free(res.data);

    return 0;
}
