
#include <cmath>
#include <cstdlib>

#include "ExtraPInstrumenter.hpp"

int global EXTRAP = 100;

int h(int x)
{
    int tmp = 0;
    for(int i = x; i < 100; ++i)
        tmp += i;
    return 100 * tmp * std::log((double)x);
}

int f(int x, int y)
{
    int tmp = 0;
    for(int i = x; i < y; ++i)
        tmp += i;
    return 10*x + h(y/2) + tmp;
}

int g(int x)
{
    int tmp = 0;
    for(int i = x; i < global; ++i)
        tmp += i;
    return h(100 + x + tmp + std::pow((double)global, 3.0));
}

int i(int x1, int x2, int x3)
{
    int tmp = 0;
    for(int i = x1; i < x2 + 1; i += x3)
        tmp += i*1.1;
    return f(global, x1) * x1 * x2 + tmp + h(x3) * f(2, 5);
}

int main(int argc, char ** argv)
{
    int x1 EXTRAP = atoi(argv[1]);
    int x2 EXTRAP= atoi(argv[2]);
    register_variable(&x1, VARIABLE_NAME(x1));
    register_variable(&x2, VARIABLE_NAME(x2));
    register_variable(&global, VARIABLE_NAME(global));
    int y = 2*x1 + 1;

    // pass param, pass global
    f(global, x1);
    f(x2, 100);
    // pass nothing, access global
    g(100);
    // pass nothing, access nothing
    h(x2);
    h(100);
    // pass each arg separetely
    i(x2, x1, 15*global);

    return 0;
}
