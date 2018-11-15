
#include <cmath>
#include <cstdlib>
#include <fstream>

#define EXTRAP __attribute__(( annotate("extrap") )) 

int global EXTRAP = 100;
double global2 EXTRAP = 3.14;

int h(int x)
{
    return 2*x*global;
}

int g_prune(int x)
{
    return h(global2 + x + std::pow((double)x, 3.0));
}

int g_not_prune(int x)
{
    // Three bugs to test
    // 1) Don't prune since x is used outside of call
    // 2) Bug - h is called with doubled id from x since it appears twice in the argument
    // Solution: SmallVector -> SmallSet in FunctionParameters
    // 3) Bug - h is called w/o parameters for some reason when x involves parameters (they are gone).
    // Solution: FunctionParameters created from a callsite which was already moved in insert_callsite
    return global2 * h(100 + x + std::pow((double)x, 3.0));
}

int f_prune(int x, int y)
{
    g_prune(x);
    g_not_prune(y);
    return h(y);
}

int f_not_prune(int x, int y)
{
    int c = x + 2*y;
    g_prune(x);
    g_not_prune(y);
    return c + h(y);
}

int main(int argc, char ** argv)
{
    std::ifstream file;
    int x1 EXTRAP = atoi(argv[1]);
    int x2 EXTRAP;
    file >> x2;

    f_prune(1, 2);
    f_not_prune(1, 2);
    
    //f_prune(x1, 2);
    //f_not_prune(x1, 2);
    //
    //f_prune(x1, x2);
    //f_not_prune(x1, x2);
    //
    //f_prune(x1, 2*x1 + x2 - 1);
    //f_not_prune(x1, 2*x1 + x2 - 1);

    return 0;
}
