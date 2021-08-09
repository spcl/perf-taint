#include <cmath>

#include "perf-taint/PerfTaint.hpp"

int g(int x1, int x2)
{
  int tmp = 1;
  // First exit condition - depends on x1, x2
  for(int i = 0; i < x1 + x2; ++i) {
      tmp += i;
  }
  return tmp;
}

