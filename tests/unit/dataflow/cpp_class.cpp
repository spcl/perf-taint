// RUN: %clangxx %cxx_flags %s -emit-llvm -o %t1.bc
// RUN: %opt %opt_flags < %t1.bc 2> /dev/null > %t1.tainted.bc
// RUN: %llc %llc_flags < %t1.tainted.bc > %t1.tainted.o
// RUN: %clangxx %link_flags %t1.tainted.o -o %t1.exe
// RUN: %execparams %t1.exe 10 10 10 > %t1.json
// RUN: diff -w %s.json %t1.json
// RUN: %jsonconvert %t1.json > %t2.json
// RUN: diff -w %s.processed.json %t2.json

#include <cstdint>
#include <cstdlib>

#include "perf-taint/PerfTaint.hpp"

class Grid
{
    int x, y, z;
    double * data;
public:
    Grid(int _x, int _y, int _z):
        x(_x),
        y(_y),
        z(_z),
        data(new double[x*y]())
        {}
    ~Grid()
    {
        delete[] data;
    }

    // important
    void update_grid(double shift)
    {
        for(int i = 0; i < x*y;++i)
            data[i] += shift;
    }

    // not important  - const loop
    void update_constant(double shift)
    {
        data[0] += 2*shift;
        for(int i = 1; i < 5;++i)
            data[i] += shift;
    }

    // not important - data is not influenced by label
    void update_data(double shift)
    {
        data[0] += 2*shift;
        for(int i = data[0]; i < 5;++i)
            data[i] += shift;
    }

    // not important - third field z is not labelled
    void update_z(double shift)
    {
        for(int i = 0; i < z;++i)
            data[i] += shift;
    }
};

int main(int argc, char ** argv)
{
    int size_x EXTRAP = atoi(argv[1]);
    int size_y EXTRAP = atoi(argv[2]);
    int size_z EXTRAP = atoi(argv[3]);

    Grid * g;
    perf_taint::register_variable(&size_x, VARIABLE_NAME(size_x));
    perf_taint::register_variable(&size_y, VARIABLE_NAME(size_y));
    // verify that labels are propagated to class fields
    g = new Grid(size_x, size_y, size_z);

    g->update_grid(2.0);
    g->update_constant(1.5);
    g->update_data(1.5);
    g->update_z(1.5);

    delete g;
    return 0;
}
