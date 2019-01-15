
#ifndef __JSON_EXPORT_
#define __JSON_EXPORT_

#include <stdint.h>
#ifndef __cplusplus
    #include <stdbool.h>
#endif

#ifdef __cplusplus
#define EXTERN extern "C"
#else
#define EXTERN
#endif

typedef struct _dependencies
{
    size_t len;
    size_t capacity;
    uint16_t * deps;
} dependencies;

extern int32_t __EXTRAP_INSTRUMENTATION_RESULTS[];
extern const char * __EXTRAP_INSTRUMENTATION_FUNCS_NAMES[];
extern const char * __EXTRAP_INSTRUMENTATION_FUNCS_MANGLED_NAMES[];
extern const char * __EXTRAP_INSTRUMENTATION_FILES[];
extern int32_t __EXTRAP_INSTRUMENTATION_FUNCS_COUNT;
extern int32_t  __EXTRAP_INSTRUMENTATION_FUNCS_ARGS[];
extern int32_t  __EXTRAP_INSTRUMENTATION_FUNCS_DBG[];
extern int32_t __EXTRAP_INSTRUMENTATION_PARAMS_COUNT;
extern const char * __EXTRAP_INSTRUMENTATION_PARAMS_NAMES[];

extern bool __EXTRAP_INSTRUMENTATION_CALLSITES_RESULTS[];
extern int __EXTRAP_INSTRUMENTATION_CALLSITES_OFFSETS[];
//int __EXTRAP_INSTRUMENTATION_CALLSITES[] = {0, 1, 0};
//int __EXTRAP_INSTRUMENTATION_CALLSITES_IDX[2] = {0, 2, 3};
//
//

// Store `dependencies` object for each loop depth.
// Example: for a function with three loops X, Y, Z with depths 3, 2, 1:
// Store XXX YY Z
// There are no marks or boundaries inside the array. To find out where loops
// and functions begin, use static offsets array.
//
// Allocated dynamically by __dfsw_EXTRAP_INIT()
dependencies * __EXTRAP_LOOP_DEPENDENCIES;

// Store offsets to easily access dependencies.
// Each value points to the place where `dependencies`
// start for each function in the array __EXTRAP_LOOP_DEPENDENCIES.
extern int32_t __EXTRAP_LOOPS_DEPS_OFFSETS[];

// Store depths for each loop and each function. Contents of this array
// are necessary to understand how dependencies array is structured.
// Example: for a function with three loops X, Y, Z with depths 3, 2, 1:
// Store 3 2 1
extern int32_t __EXTRAP_LOOPS_DEPTHS_PER_FUNC[];

// Store offsets to easily access loop depths.
// Each value points to the place where depths start for a function
// in array __EXTRAP_LOOPS_DEPTHS_PER_FUNC
// It's necessary because each function has an unknown number of entries.
extern int32_t __EXTRAP_LOOPS_DEPTHS_FUNC_OFFSETS[];

EXTERN void __dfsw_dump_json_output();
EXTERN void __dfsw_json_initialize();
EXTERN void __dfsw_json_write_loop(int function_idx, int loop_idx);
EXTERN dependencies * __dfsw_EXTRAP_DEPS_FUNC(int func_idx);
EXTERN dependencies * __dfsw_EXTRAP_GET_DEPS(int32_t loop_idx, int32_t depth,
        int32_t function_idx);

#endif
