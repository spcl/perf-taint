
#include <cstdlib>

#include "ExtraPInstrumenter.hpp"

int global = 100;


// second level loops does not contribute anything
int nest_const(int x, int y)
{
    int tmp = 0;
    for(int i = x; i < global; ++i) {
        for(int j = 0; j < 10; ++j)
            tmp += i;
        for(int j = 0; j < global; ++j)
            tmp += i;
    }
    return tmp;
}

int nest_partial(int x, int y)
{
    int tmp = 0;
    // x
    for(int i = x; i < global; ++i) {

        // y
        for(int j = 0; j < y; ++j)
            tmp += i;

        // empty
        for(int j = 0; j < global; ++j)
            tmp += i;

        // y, x
        for(int j = x; j < global; j += y)
            tmp += i;
    }
    return tmp;
}

// two loops with different depths
int double_nest_partial(int x, int y)
{
    int tmp = 0;
    // x, y
    for(int i = x; i < global; i += y) {

        // empty
        for(int j = 0; j < 100; ++j)
            tmp += i;

        // x
        for(int j = x; j < global; ++j)
            tmp += i;

        // y 
        for(int j = 0; j < global; j += y)
            tmp += i;
    }

    // x
    for(int i = x; i < global; ++i) {

        // y
        for(int j = 0; j < y; ++j)
            tmp += i;

        // empty
        for(int j = 0; j < global; ++j)
            tmp += i;

        // y, x
        for(int j = x; j < global; j += y)
            tmp += i;
    }
    return tmp;
}

// triple nested
int nest_triple(int x, int y)
{
    int tmp = 0;
    for(int i = x; i < global; ++i) {

        // full
        for(int j = 0; j < y; ++j) {
            for(int k = y; k < global; k += x)
                tmp += k;
        }

        // second level empty, third level full
        for(int j = 0; j < 10; ++j) {
            for(int k = x; k < global; k += y)
                tmp += k;
            for(int k = 0; k < y; k++)
                tmp += k;
        }
    }
    return tmp;
}

// two triple nested
int double_nest_triple(int x, int y)
{
    int tmp = 0;
    // y
    for(int i = y; i < global; ++i) {
        // y
        for(int j = 0; j < y; ++j) {
            // y, x
            for(int k = y; k < global; k += x)
                tmp += i;
        }

        // empty
        for(int j = 0; j < 10; ++j) {
            // x, y
            for(int k = x; k < global; k += y)
                tmp += i;
            // y
            for(int k = 0; k < y; k++)
                tmp += i;
        }
    }

    // x
    for(int i = x; i < global; ++i) {
        // y
        for(int j = 0; j < y; ++j) {
            // x, y
            for(int k = y; k < global; k += x)
                tmp += i;
            // y
            for(int k = 0; k < y; k++)
                tmp += i;
        }

        // empty
        for(int j = 0; j < 10; ++j) {
            // x, y
            for(int k = x; k < global; k += y)
                tmp += i;
            // y
            for(int k = 0; k < y; k++)
                tmp += i;
        }
        // y
        for(int j = 0; j < global*10; j += y)
            tmp += i;

    }

    return tmp;
}

int three_loops(int x, int y)
{
    int tmp = 0;
    // empty
    for(int i = 0; i < global; ++i) {
        for(int j = 0; j < global; ++j) {
            for(int k = 0; k < 10; k++)
                tmp += i;
        }
    }

    // x
    for(int i = x; i < global; ++i) {
        // y
        for(int j = 0; j < y; ++j) {
            // x, y
            for(int k = y; k < global; k += x)
                tmp += i;
            // y
            for(int k = 0; k < y; k++)
                tmp += i;
        }
    }

    // x
    for(int i = x; i < global; ++i)
        // y
        for(int j = 0; j < y; ++j)
            tmp += i;

    return tmp;
}

int main(int argc, char ** argv)
{
    int x1 EXTRAP = atoi(argv[1]);
    int x2 EXTRAP = atoi(argv[2]);
    int x3 = atoi(argv[3]);
    register_variable(&x1, VARIABLE_NAME(x1));
    register_variable(&x2, VARIABLE_NAME(x2));

    nest_const(x1, x2);
    // should appear only once
    nest_partial(x1, x2);
    nest_partial(x1, x2);
    double_nest_partial(x1, x2);
    nest_triple(x1, x2);
    // should generate a new output
    nest_triple(x1, x3);
    double_nest_triple(x1, x2);
    three_loops(x1, x2);

    return 0;
}
