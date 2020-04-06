#include <cmath>
#include <cstdlib>

#include "ExtraPInstrumenter.hpp"

// Test reproducing a bug where a call to an important function is not registered
// inside a deeply nested loop. This corresponds to function `imp_gauge_force_cpu`
// in MILC's generic/gauge_force_imp.c and a call to `path_product_fields` inside
// of it.
//
// In this case, the loop processing algorithm does not completely walk over
// all known loops. However, we didn't catch the issue because some loops
// were not processed while committing the loop, we noticed it because the call
// to important function was not present in the JSON.
// The problem was caused by multipath level where at least one of last functions
// didn't have any subloops. This lead to a loop structure entry: 0 1 0,
// in this case for level 3, and the pointer to loop structure was not increment
// enought to cover for not used loops.
//
// Bug fix: increment loop structure increment enough times to propagate to the
// next loop level.

int call_interesting_function(int x1, int x2)
{
  int tmp = 0;
  for(int i = x1; i < x2; i += 1)
    tmp += i;
  return tmp;
}

int f(int x1, int x2)
{
  int tmp = 0;
  for(int i = 0; i < x1; i += 1) {
    // first unimportant OpenMP loop
    for(int j = 0; j < x2; ++j)
      tmp += i*1.1;
    for(int j = 0; j < x2; j += 1) {
      for(int k = 0; k < x1; k += 1) {
        // Unimportant nested loop
        for(int l = 0; l < x2; l += 1) {
          tmp += i*1.1;
        }
        // main loop
        for(int l = 0; l < x2; l += 1) {
          // Another two loops that don't bring anything
          for(int m = 0; m < x1; m += 1) {
            tmp += i*1.1;
          }
          for(int m = 0; m < x1; m += 1) {
            tmp += i*1.1;
          }
          // The interesting call
          tmp += call_interesting_function(x1, x2);
          // Some OpenMP loop
          for(int m = 0; m < x1; m += 1) {
            // Some other loop
            for(int n = 0; n < x2; n += 1) {
              tmp += i*1.1;
            }
          }
        }
      }
    }
    // Final OMP loop
    for(int l = 0; l < x2; l += 1) {
      tmp += i*1.1;
    }
  }
  return tmp;
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
