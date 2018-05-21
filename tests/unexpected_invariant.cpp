//
// Created by mcopik on 5/8/18.
//
#define	NA	1400
#define	NONZER	7
#define	NZ	NA*(NONZER+1)*(NONZER+1)+NA*(NONZER+2)

static int rowstr[NA+1+1];
static int colidx[NZ+1];

void f()
{
    int firstrow = 1;
    int lastrow  = NA;
    int firstcol=1;
    int j, k;
    for (j = 1; j <= lastrow - firstrow + 1; j++) {
        for (k = rowstr[j]; k < rowstr[j + 1]; k++) {
            colidx[k] = colidx[k] - firstcol + 1;
        }
    }
}