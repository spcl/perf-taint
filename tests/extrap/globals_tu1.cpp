
#include <cmath>
#include <cstdlib>

#define EXTRAP __attribute__(( annotate("extrap") )) 

int global EXTRAP = 100;
extern double global2;

int g(int);

int h(int x)
{
    return 100 * x * std::log((double)global2);
}

int f(int x, int y)
{
    return 10*x + h(global * y);
}

int i(int x1, int x2, int x3)
{
    int c = global2 + 1;
    g(c);
    return f(x2, x1) * x2 + x3 * f(2, 5) + global;
}

int main(int argc, char ** argv)
{
    int x1 = atoi(argv[1]);
    int x2 = atoi(argv[2]);

    // pass param, pass global
    f(x1, global2);
    f(x2, 100);
    // pass nothing, access global
    g(100);
    // pass nothing, access nothing
    h(200);
    h(100);
    // pass two args, pass arg, nothing
    i(100, 15, x2*x1);

    return 0;
}
