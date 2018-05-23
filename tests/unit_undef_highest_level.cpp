
void f(int * A, int len, int test)
{
    for(int i = 0; i < len; ++i)
        test += A[i];
    // undef not coming from multiple exits
    // child loop should not be printed
    for(int i = 0; i < test; ++i) {
        for(int j = 0; j < i; ++j) {}
    }
}
