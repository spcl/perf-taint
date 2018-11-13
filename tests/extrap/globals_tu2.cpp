#include <cmath>

#define EXTRAP __attribute__(( annotate("extrap") )) 

extern int global;
double global2 EXTRAP = 200;

int h(int x);

int g(int x)
{
    return h(100 + x + std::pow((double)global, 3.0));
}
