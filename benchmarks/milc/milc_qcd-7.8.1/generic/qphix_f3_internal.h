#ifndef _QPHIX_F3_INTERNAL_H
#define _QPHIX_F3_INTERNAL_H

#include <qcd_data_types.h>

struct QPHIX_F3_ColorVector_struct {
  fptype *cv;
};

struct QPHIX_F3_FermionLinksAsqtad_struct {
  fptype *fatlinks;
  fptype *longlinks;
  fptype *fwdlinks;
  fptype *bcklinks;
};

#endif /* _QPHIX_F3_INTERNAL_H */


