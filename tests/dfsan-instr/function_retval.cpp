
#include <cmath>
#include <cstdlib>

#include "ExtraPInstrumenter.hpp"

int global EXTRAP = 100;

int g(int x, int y)
{
    return x ? 2 * y : y + 1;
}

int g2(int x, int y)
{
    return x + y + global;
}

struct test
{
    int x1, x2;

    test(int _x1, int _x2) :
        x1(_x1),
        x2(_x2)
    {}

    int length()
    {
        return x1;
    }
};

// pass label but receive unlabeled retval
// shouldn't be reported (ignore call args)
int f(int x1, int x2)
{
    int tmp = 1;
    for(int i = 0; i < g(x1 + x2, 1); ++i) {
        tmp += i;
    }
    return tmp;
}

// call does not include label but retval does
// should be reported
int h(int x1, int x2)
{
    int tmp = 1;
    for(int i = 0; i < g2(x2, 1); ++i) {
        tmp += i;
    }
    return tmp;
}

// report only test,t1
// incorrect parse of function will report entire test i.e. a pair (x1, x2)
int i(test * t)
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
    test t{x1, x2};

    // retval doesn't include label
    f(global, x1);
    f(x1 + x2, 2);
    // retval will have global label
    h(x1, 10);
    h(10, 10);
    // pass a pair
    i(&t);

    return 0;
}
