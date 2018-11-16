
#include <cmath>
#include <cstdlib>

#define EXTRAP __attribute__(( annotate("extrap") )) 
#define EXTRAP __attribute__(( annotate("extrap") )) 

int global EXTRAP = 100;

int f(int x, int y)
{
    return 10*x + y/2;
}

int h(int x)
{
    return 100 * x * std::log((double)x);
}

int g(int x)
{
    return global ? h(100 + x + std::pow((double)global, 3.0)) : 1;
}

int i(int x1, int x2, int x3)
{
    return 100 * x1 * x2 + x3 * 2;
}

int main(int argc, char ** argv)
{
    int x1 EXTRAP = atoi(argv[1]);
    int x2 EXTRAP = atoi(argv[2]);
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
