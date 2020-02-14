#include <cmath>
#include <cstdlib>

#include "ExtraPInstrumenter.hpp"

// This test verifies that functions are correctly detected
// according to usage of local and global parameters.

int global EXTRAP = 100;

int f(int x, int y)
{
    int tmp = 0;
    for(int i = x; i < y; ++i)
        tmp += i;
    return tmp*10*x + y/2;
}

int h(int x)
{
    int tmp = 0;
    for(int i = x; i < 100; ++i)
        tmp += i;
    return 100 * x * std::log((double)x);
}

int g(int x)
{
    return global ? h(100 + x + std::pow((double)global, 3.0)) : 1;
}

int i(int x1, int x2, int x3)
{
    int tmp = 0;
    for(int i = x1; i < x2; i += x3)
        tmp += i*1.1;
    return 100 * x1 * x2 + x3 * 2;
}

int main(int argc, char ** argv)
{
    int x1 EXTRAP = atoi(argv[1]);
    int x2 EXTRAP = atoi(argv[2]);
    register_variable(&x1, VARIABLE_NAME(x1));
    register_variable(&x2, VARIABLE_NAME(x2));
    register_variable(&global, VARIABLE_NAME(global));
    int y = 2*x1 + 1;

    // pass param, pass global
    f(global, x1);
    // pass nothing, access global
    g(100);
    // pass nothing, access nothing
    h(x2);
    h(100);
    // pass two args, pass arg, nothing
    i(y + x2, x1, 15);

    return 0;
}
