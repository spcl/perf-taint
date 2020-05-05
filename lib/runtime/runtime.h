
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

typedef struct _callstack
{
  size_t len;
  size_t capacity;
  uint16_t * stack;
} callstack;

// Represents a scenario where a single call might produce multiple results.
// f -> g -> h1, h2, h3...
// Thus, we need to store both the position of result and the function idx.
typedef struct _nested_call_data {
  uint16_t function_idx;
  size_t pos;
} nested_call_data;

typedef struct _nested_call {
  int16_t nested_loop_idx;
  uint16_t loop_size_at_level;
  nested_call_data * data;
  size_t len;
  size_t capacity;
} nested_call;

typedef struct _nested_call_vec {
  uint16_t len;
  size_t capacity;
  nested_call * data;
} nested_call_vec;

extern int32_t __EXTRAP_INSTRUMENTATION_RESULTS[];
extern const char * __EXTRAP_INSTRUMENTATION_FUNCS_NAMES[];
extern const char * __EXTRAP_INSTRUMENTATION_FUNCS_MANGLED_NAMES[];
extern const char * __EXTRAP_INSTRUMENTATION_FUNCS_DEMANGLED_NAMES[];
extern const char * __EXTRAP_INSTRUMENTATION_FILES[];
extern int32_t __EXTRAP_INSTRUMENTATION_FUNCS_COUNT;
extern int32_t __EXTRAP_INSTRUMENTATION_IMPLICIT_FUNCS_COUNT;
extern int32_t __EXTRAP_FUNCS_COUNT;
extern int32_t  __EXTRAP_INSTRUMENTATION_FUNCS_ARGS[];
extern int32_t  __EXTRAP_INSTRUMENTATION_FUNCS_DBG[];

// Number of currently registered parameters
extern int32_t __EXTRAP_INSTRUMENTATION_EXPLICIT_PARAMS_COUNT;
// Maximal number of parameters that can appear.
// Computed as: number of parameters introduced by implicit library calls
// plus the number of calls to register_variable.
// Actual number of params might be lower if several calls to register_variable
// create the same label (distinct control-flow paths).
extern int32_t __EXTRAP_INSTRUMENTATION_EXPLICIT_PARAMS_MAX_COUNT;
extern const int32_t __EXTRAP_INSTRUMENTATION_IMPLICIT_PARAMS_COUNT;
// Names of all parameters - first max_count, then implicit
extern const char * __EXTRAP_INSTRUMENTATION_PARAMS_NAMES[];
extern bool  __EXTRAP_INSTRUMENTATION_PARAMS_USED[];
extern int16_t __EXTRAP_INSTRUMENTATION_PARAMS_REDIRECT[];

extern const char * __EXTRAP_INSTRUMENTATION_OUTPUT_FILENAME;

extern bool __EXTRAP_INSTRUMENTATION_CALLSITES_RESULTS[];
extern int __EXTRAP_INSTRUMENTATION_CALLSITES_OFFSETS[];

#if defined(PERF_TAINT_WITH_MPI)
  #define debug_print(fmt, ...) \
    do {\
      if (DEBUG && __EXTRAP_INSTRUMENTATION_MPI_RANK <= 0)\
        fprintf(stderr, fmt, __VA_ARGS__);\
    } while (0)
  extern int __EXTRAP_INSTRUMENTATION_MPI_RANK;
#else
  #define debug_print(fmt, ...) \
    do {\
      if (DEBUG)\
        fprintf(stderr, fmt, __VA_ARGS__);\
    } while (0)
#endif

//uint16_t * __dfsw_EXTRAP_CALLSTACK();
extern callstack __EXTRAP_CALLSTACK;

extern nested_call_vec __EXTRAP_NESTED_CALLS;
extern int16_t __EXTRAP_CURRENT_CALL;
uint16_t __dfsw_EXTRAP_REGISTER_CALL(int16_t nested_loop_idx, uint16_t loop_size);
void __dfsw_EXTRAP_REMOVE_CALLS(uint16_t len);
void __dfsw_EXTRAP_SET_CURRENT_CALL(int16_t idx);
EXTERN int16_t __dfsw_EXTRAP_CURRENT_CALL();

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
extern dependencies * __EXTRAP_LOOP_DEPENDENCIES;

// Store offsets to easily access dependencies.
// Each value points to the place where `dependencies`
// start for each function in the array __EXTRAP_LOOP_DEPENDENCIES.
//extern int32_t __EXTRAP_LOOPS_DEPS_OFFSETS[];

// Store depths for each loop and each function. Contents of this array
// are necessary to understand how dependencies array is structured.
// Example: for a function with three loops X, Y, Z with depths 3, 2, 1:
// Store 3 2 1
//extern int32_t __EXTRAP_LOOPS_DEPTHS_PER_FUNC[];
//extern int32_t __EXTRAP_LOOPS_DEPTHS_PER_FUNC[];
//extern int32_t __EXTRAP_LOOPS_SIZES_PER_FUNC[];

// Store offsets to easily access loop depths.
// Each value points to the place where depths start for a function
// in array __EXTRAP_LOOPS_DEPTHS_PER_FUNC
// It's necessary because each function has an unknown number of entries.
//extern int32_t __EXTRAP_LOOPS_DEPTHS_FUNC_OFFSETS[];
//
//
extern int32_t __EXTRAP_NUMBER_OF_LOOPS;

// For each function store a triplet of values corresponding to each loop
// (loop depth, # of entries in loops_data array, # of loops)
extern int32_t __EXTRAP_LOOPS_SIZES_PER_FUNC[];
extern int32_t __EXTRAP_LOOPS_SIZES_PER_FUNC_OFFSETS[];
// For each loop store the corresponding information
extern int32_t __EXTRAP_LOOPS_STRUCTURE_PER_FUNC[];
extern int32_t __EXTRAP_LOOPS_STRUCTURE_PER_FUNC_OFFSETS[];

extern int16_t __EXTRAP_LOOPS_DEPS_OFFSETS[];

// dependencies array
// for writing labels, the offset inside loop can be precomputed statically
// for comitting loop, the offset can be computed from the array loops_sizes

EXTERN void __dfsw_dump_json_output();
EXTERN void __dfsw_json_initialize();
EXTERN void __dfsw_implicit_call(int, int, uint16_t, int);
EXTERN bool __dfsw_json_write_loop(int function_idx, int calls_count);
EXTERN dependencies * __dfsw_EXTRAP_DEPS_FUNC(int func_idx);
EXTERN dependencies * __dfsw_EXTRAP_GET_DEPS(int32_t loop_idx, int32_t depth,
        int32_t function_idx);

#endif
