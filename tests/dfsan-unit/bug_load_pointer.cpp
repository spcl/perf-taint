#include <cmath>
#include <cstdlib>

#include "ExtraPInstrumenter.hpp"

// This test case reproduces a bug where loop is incorrectly marked
// as tainted in a pointer-based comparison.
// In the implementation, we used to look for labels in the loaded values used
// in comparison. When there a was a pointer based operation, the load would 
// proceed from T** address to T* value and by mistake, we would query dfsan
// for T* address instead of T**. When T* pointed to a value with taint label,
// it would be incorrectly propagated to the loop.

int f(int x1, int x2)
{
  int sum = 0;
  int data[] = {x1, x2};
  int * begin = data, * end = data + 2;
  while(begin != end) {
    sum += *begin++;
  }
  return sum;
}

int main(int argc, char ** argv)
{
  int x1 EXTRAP = atoi(argv[1]);
  int x2 EXTRAP = 2*atoi(argv[2]);
  register_variable(&x1, VARIABLE_NAME(x1));
  register_variable(&x2, VARIABLE_NAME(x2));
  f(x1, x2);

  return 0;
}
