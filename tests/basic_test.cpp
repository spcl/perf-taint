
extern int TEST;

void f(int len)
{    
    for(int i = 2*len; i >= 0; --i) {
        for(int j = len + 3; j >= 0; --j) {
            for(int k = 0; k <= len; ++k) {
            if(TEST == 0)
                break;
            TEST = TEST / 2; 
            }
        }

        for(int j = 1; j <= len; ++j) {
        }
    }

}
