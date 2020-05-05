// RUN: %clangxx %cxx_flags %s -emit-llvm -o %t1.bc
// RUN: %opt %opt_flags -perf-taint-scev -perf-taint-pass-stats=%t1.scev.json \
// RUN: %t1.bc 2> /dev/null > %t1.tainted.bc
// RUN: diff -w %s.pass.json %t1.scev.json

#include <cstdlib>

// This test verifies that using LLVM SCEV helps to prune some loops.

int empty_function(int x1, int x2)
{
  return x1 + x2;
}

int constant_loop(int x1, int x2)
{
  int tmp = 0;
  for(int i = 0; i < 100; ++i)
      tmp += i;
  return tmp + x1 + x2;
}

int nonconstant_loop(int x1, int x2)
{
  int tmp = 0;
  for(int i = 0; i < x1; ++i)
      tmp += i;
  return tmp + x1 + x2;
}

int mixed_loop(int x1, int x2)
{
  int tmp = 0;
  for(int i = 0; i < x1; ++i)
      tmp += i;
  for(int i = 10; i < 93; i += 2)
      tmp += i;
  return tmp + x1 + x2;
}

int main(int argc, char ** argv)
{
  int x1 = atoi(argv[1]);
  int x2 = atoi(argv[2]);

  empty_function(x1, x2);
  constant_loop(x1, x2);
  nonconstant_loop(x1, x2);
  mixed_loop(x1, x2);

  return 0;
}
