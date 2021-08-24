
#include <stdio.h>

#include "test.h"

// will generate a conflict as well
static void test1(int x)
{
  int sum = 0;
  for(int i = 0; i < x; ++i)
    sum++;
  f(x);
}

void test2(int x)
{
  test1(x);
}
