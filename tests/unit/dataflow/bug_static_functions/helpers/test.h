

// This function is private to a translation unit because of the static keyword.
// Thus, different TUs are going to see different copies.
static inline int f(int a)
{
  int x = 0;
  for(int i = 0; i < a; ++i)
    x++;
  return x;
}

