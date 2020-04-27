#include <cmath>
#include <cstdlib>

#include "ExtraPInstrumenter.hpp"

// The simplest possible example.

int f(int x, int y)
{
    int tmp = 0;
    for(int i = x; i < y; ++i)
        tmp += i;
    return tmp*10*x + y/2;
}

int main(int argc, char ** argv)
{
    int x1 EXTRAP = atoi(argv[1]);
    int x2 EXTRAP = 2*atoi(argv[2]);
    register_variable(&x1, VARIABLE_NAME(x1));
    register_variable(&x2, VARIABLE_NAME(x2));

    f(x1, x2);
    f(x2, x1);
    f(0, x1);
    f(0, x2);
    f(0, 10);

    return 0;
}
