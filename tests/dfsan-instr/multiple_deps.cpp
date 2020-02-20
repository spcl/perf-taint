
#include <cmath>
#include <cstdlib>

#include "ExtraPInstrumenter.hpp"

int global EXTRAP = 100;

int mul(int x, int y)
{
    return x + y;
}

struct test
{
    int x1, x2, x3;

    test(int _x1, int _x2, int _x3):
        x1(_x1),
        x2(_x2),
        x3(_x3)
    {}

    int length()
    {
        return x1 + x3;
    }
};

// just pair dependency
int f(int x1, int x2)
{
    int tmp = 1;
    for(int i = 0; i < mul(x1 + x2, 1); ++i) {
        tmp += i;
    }
    return tmp;
}

// pair dependency plus usual dependency as an addition
int g(int x1, int x2)
{
    int tmp = 1;
    for(int i = 0; i < mul(x1, x2); ++i) {
        tmp += i;
    }
    return tmp;
}

// pair dependency in function w/o global
int h(test * t)
{
    int tmp = 1;
    for(int i = 0; i < t->length(); ++i) {
        tmp += i;
    }
    return tmp;
}

int main(int argc, char ** argv)
{
    int x1 EXTRAP = atoi(argv[1]);
    int x2 EXTRAP = atoi(argv[2]);
    register_variable(&x1, VARIABLE_NAME(x1));
    register_variable(&x2, VARIABLE_NAME(x2));
    register_variable(&global, VARIABLE_NAME(global));
    int y = 2*x1 + 1;
    test t{10, global, y + x2};

    f(x2, y);
    g(x1, x2);
    g(10, y);
    h(&t);

    return 0;
}
