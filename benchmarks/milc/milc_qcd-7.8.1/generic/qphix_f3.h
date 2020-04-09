#ifndef _QPHIX_F3_H
#define _QPHIX_F3_H

typedef struct QPHIX_F3_ColorVector_struct   QPHIX_F3_ColorVector;
typedef struct QPHIX_F3_FermionLinksAsqtad_struct  QPHIX_F3_FermionLinksAsqtad;

/* copy QPHIX field into a raw field */
void QPHIX_F3_extract_V_to_raw(QPHIX_F_Real *dest, QPHIX_F3_ColorVector *src, QPHIX_evenodd_t evenodd);

/* destroy a QPHIX field */
void QPHIX_F3_destroy_V(QPHIX_F3_ColorVector *field);
void QPHIX_F3_destroy_G(QPHIX_F3_GaugeField *field);

  /*********************/
  /*  Asqtad routines  */
  /*********************/

  /* fermion matrix link routines */

QPHIX_F3_FermionLinksAsqtad *
  QPHIX_F3_asqtad_create_L_from_raw(QPHIX_F_Real *fatlinks[], QPHIX_F_Real *longlinks[],
				    QPHIX_evenodd_t evenodd);

void QPHIX_F3_asqtad_extract_L_to_raw(QPHIX_F_Real *fatlinks[], QPHIX_F_Real *longlinks[],
				      QPHIX_F3_FermionLinksAsqtad *src,
				      QPHIX_evenodd_t evenodd);

void QPHIX_F3_asqtad_destroy_L(QPHIX_F3_FermionLinksAsqtad *field);

/* inverter routines */

void QPHIX_F3_asqtad_invert(QPHIX_info_t *info,
			    QPHIX_F3_FermionLinksAsqtad *asqtad,
			    QPHIX_invert_arg_t *inv_arg,
			    QPHIX_resid_arg_t *res_arg,
			    QPHIX_F_Real mass,
			    QPHIX_F3_ColorVector *out_pt,
			    QPHIX_F3_ColorVector *in_pt);

void QPHIX_F3_asqtad_invert_multi(QPHIX_info_t *info,
				  QPHIX_F3_FermionLinksAsqtad *asqtad,
				  QPHIX_invert_arg_t *inv_arg,
				  QPHIX_resid_arg_t **res_arg[],
				  QPHIX_F_Real *masses[],
				  int nmass[],
				  QPHIX_F3_ColorVector **out_pt[],
				  QPHIX_F3_ColorVector *in_pt[],
				  int nsrc);

#endif /* _QPHIX_F3_H */
