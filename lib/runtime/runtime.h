
#ifndef __JSON_EXPORT_
#define __JSON_EXPORT_

#include <stdint.h>

#ifdef __cplusplus
#define EXTERN extern "C"
#else
#define EXTERN
#endif

extern int32_t __EXTRAP_INSTRUMENTATION_RESULTS[];
extern const char * __EXTRAP_INSTRUMENTATION_FUNCS_NAMES[];
extern const char * __EXTRAP_INSTRUMENTATION_FILES[];
extern int32_t __EXTRAP_INSTRUMENTATION_FUNCS_COUNT;
extern int32_t  __EXTRAP_INSTRUMENTATION_FUNCS_DBG[];
extern int32_t __EXTRAP_INSTRUMENTATION_PARAMS_COUNT;
extern const char * __EXTRAP_INSTRUMENTATION_PARAMS_NAMES[];

EXTERN void __dfsw_dump_json_output();

#endif
