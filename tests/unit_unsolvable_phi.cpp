

void f(int * A, int len)
{
    int count = 0;
    for(int i = 0; i < len; ++i)
        if(A[i]) ++count;

    for(int i = 0; i < len; ++i) {
        //undef
        for(int j = 0; j < count; ++j)
            A[j] += 1;

        //verify if counting is correctly restarted
        for(int j = 0; j < i; ++j)
            A[j] += 2;
    }
}
