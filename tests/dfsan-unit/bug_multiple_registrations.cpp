#include <cmath>
#include <cstdlib>

#include "ExtraPInstrumenter.hpp"

// This test explores a scenario where variable registration is called multiple
// times. Originally it happens in MILC's setup.c file where we register variables
// after reading input which is done multiple times.
//
// The bug lead to a situation where parameter ID exceeded the size of parameter
// space and lead to buffer overruns. In MILC we observed a scenario where
// new variables incorrectly overwrote callstack.
//

void setup(int argc, char ** argv, int & x1, int & x2)
{
  x1 = atoi(argv[1]);
  x2 = atoi(argv[2]);
  register_variable(&x1, VARIABLE_NAME(x1));
  register_variable(&x2, VARIABLE_NAME(x2));
}

int i(int x1, int x2, int x3)
{
    int tmp = 0;
    for(int i = x1; i < x2; i += x3)
        tmp += i*1.1;
    return 100 * x1 * x2 + x3 * 2;
}

int main(int argc, char ** argv)
{
  int x1 EXTRAP, x2 EXTRAP;

  setup(argc, argv, x1, x2);
  i(x1, x2, 1);

  setup(argc, argv, x1, x2);
  i(x2, x1, 2);

  return 0;
}
