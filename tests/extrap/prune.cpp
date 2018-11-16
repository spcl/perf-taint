
#include <cmath>
#include <cstdlib>
#include <fstream>

#define EXTRAP __attribute__(( annotate("extrap") )) 

int global EXTRAP = 100;
double global2 EXTRAP = 3.14;

// Show because passed with global/global2 not because it is accessed
int h(int x)
{
    return 2*x*global;
}

// Can be pruned since global is accessed only in the function call
int g_prune(int x)
{
    return global * h(x + std::pow((double)x, std::exp(global2)));
}

int g_not_prune(int x)
{
    // Three bugs to test
    // 1) Don't prune since global is used
    // 2) Bug - h is called with doubled id from x since it appears twice in the argument
    // Solution: SmallVector -> SmallSet in FunctionParameters
    // 3) Bug - h is called w/o parameters for some reason when x involves parameters (they are gone).
    // Solution: FunctionParameters created from a callsite which was already moved in insert_callsite
    if(global2 + 1 < 0)
        return h(100 + x + std::pow((double)global, 3.0));
    else
        return h(200*global + std::pow((double)x, 3.0));
}

int f_prune(int x, int y)
{
    g_prune(x);
    g_not_prune(y);
    return h(y);
}

// Don't prune since x is used outside of call
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
