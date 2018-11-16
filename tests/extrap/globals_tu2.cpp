#include <cmath>

#define EXTRAP __attribute__(( annotate("extrap") )) 

extern int global;
double global2 EXTRAP = 200;

int h(int x);

// only dependency on global, no dependency on global2
int g(int x)
{
    int x2 = 0;
    for(int i = 0; i < global; ++i)
        x2 += h(100 + x + std::pow((double)global, 3.0));
    return x2;
}
