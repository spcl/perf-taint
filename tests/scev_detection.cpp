//
// Created by mcopik on 5/21/18.
//

extern const int CONST;

void simple_loop(int len, float * A)
{
    for (int i = 0; i <= len; i++) {
        // incorrect start value with + 1
        for (int j = i - 1; j + 1 < len; j++)
            A[j] += 2.0;
    }

    for (int i = 0; i <= len; i++) {
        for (int j = 0; i > j; j++)
            A[j] += 2.0;
    }

    for (int i = 0; i <= len; i++) {
        // this might be detected as 'i + j' and give 2*i as a first value of scev
        for (int j = i; i + j + 1 < len; j++)
            A[j] += 2.0;
    }

    // this might give a false update of 2*i
    for (int i = 0; 2*i < len; i++) {
        A[i] += 2.0;
    }

    // this might give a false update of const*i
    for (int i = 0; CONST*i <= len; i++) {
        A[i] += 2.0;
    }
}
