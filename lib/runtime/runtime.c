#include <stdio.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include <mpi.h>

#include <sanitizer/dfsan_interface.h>

#include "runtime.h"

#define DEBUG false

#define debug_print(fmt, ...) \
  do {\
    if (DEBUG && __EXTRAP_INSTRUMENTATION_MPI_RANK <= 0)\
      fprintf(stderr, fmt, __VA_ARGS__);\
  } while (0)


//extern int32_t __EXTRAP_INSTRUMENTATION_RESULTS[];
//extern int8_t * __EXTRAP_INSTRUMENTATION_FUNCS_NAMES[];
//extern int32_t __EXTRAP_INSTRUMENTATION_FUNCS_COUNT;
//extern int32_t __EXTRAP_INSTRUMENTATION_PARAMS_COUNT;

extern dfsan_label __EXTRAP_INSTRUMENTATION_LABELS[];

callstack __EXTRAP_CALLSTACK = {0, 0, NULL};
nested_call_vec __EXTRAP_NESTED_CALLS = {0, 0, NULL};
int16_t __EXTRAP_CURRENT_CALL = 0;
int __EXTRAP_INSTRUMENTATION_MPI_RANK = -1;
int __EXTRAP_INSTRUMENTATION_EXPLICIT_PARAMS_COUNT = 0;
dependencies * __EXTRAP_LOOP_DEPENDENCIES = NULL;

void __dfsw_EXTRAP_INIT_MPI()
{
  int flag;
  MPI_Initialized(&flag);
  assert(flag);
  int rank;
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  __EXTRAP_INSTRUMENTATION_MPI_RANK = rank;
}

void __dfsw_EXTRAP_PUSH_CALL_FUNCTION(uint16_t idx)
{
  debug_print(
    "Push function %d, new callstack length %lu\n",
    idx,
    __EXTRAP_CALLSTACK.len + 1
  );
  if(__EXTRAP_CALLSTACK.len == __EXTRAP_CALLSTACK.capacity) {
    debug_print(
      "Reached callstack capacity %lu, reallocated to %lu\n",
      __EXTRAP_CALLSTACK.capacity,
      __EXTRAP_CALLSTACK.capacity + 5
    );
    __EXTRAP_CALLSTACK.capacity += 5;
    __EXTRAP_CALLSTACK.stack = realloc(__EXTRAP_CALLSTACK.stack,
            sizeof(uint16_t) * __EXTRAP_CALLSTACK.capacity);
  }
  __EXTRAP_CALLSTACK.stack[__EXTRAP_CALLSTACK.len++] = idx;
}

void __dfsw_EXTRAP_CALL_IMPLICIT_FUNCTION(uint16_t function_idx)
{
    __dfsw_implicit_call(function_idx);
}

void __dfsw_EXTRAP_POP_CALL_FUNCTION(uint16_t idx)
{
  debug_print(
    "Pop function %d, new callstack length %lu\n",
    __EXTRAP_CALLSTACK.stack[__EXTRAP_CALLSTACK.len-1],
    __EXTRAP_CALLSTACK.len - 1
  );
  if(__EXTRAP_CALLSTACK.len == 0) {
    fprintf(stderr, "Callstack below zero!\n");
    abort();
  }
  if(idx != __EXTRAP_CALLSTACK.stack[__EXTRAP_CALLSTACK.len - 1]) {
    fprintf(
        stderr,
        "Incorrect callstack pop - expected %d, found %d !\n",
        idx,
        __EXTRAP_CALLSTACK.stack[__EXTRAP_CALLSTACK.len - 1]
    );
    abort();
  }
  __EXTRAP_CALLSTACK.len--;
}

// Insert function with a given loop_idx and loop_size into a register
// Parameters are necessary during loop commit to know where to place loops
// Return the index in data structure.
// 
// Might allocate memory in __EXTRAP_NESTED_CALLS.data
uint16_t __dfsw_EXTRAP_REGISTER_CALL(int16_t nested_loop_idx, uint16_t loop_size)
{
    if(__EXTRAP_NESTED_CALLS.len == __EXTRAP_NESTED_CALLS.capacity) {
        __EXTRAP_NESTED_CALLS.capacity += 5;
        __EXTRAP_NESTED_CALLS.data = realloc(__EXTRAP_NESTED_CALLS.data,
                sizeof(nested_call) * __EXTRAP_NESTED_CALLS.capacity);
    }
    __EXTRAP_NESTED_CALLS.data[__EXTRAP_NESTED_CALLS.len].nested_loop_idx = nested_loop_idx;
    __EXTRAP_NESTED_CALLS.data[__EXTRAP_NESTED_CALLS.len].loop_size_at_level = loop_size;
    __EXTRAP_NESTED_CALLS.data[__EXTRAP_NESTED_CALLS.len].len = 0;
    __EXTRAP_NESTED_CALLS.data[__EXTRAP_NESTED_CALLS.len].capacity = 0;
    __EXTRAP_NESTED_CALLS.data[__EXTRAP_NESTED_CALLS.len].json_data = NULL;
    return __EXTRAP_NESTED_CALLS.len++;
}

// Remove `len` last entries in the register of calls.
void __dfsw_EXTRAP_REMOVE_CALLS(uint16_t len)
{
    if(len > __EXTRAP_NESTED_CALLS.len)
        abort();
    __EXTRAP_NESTED_CALLS.len -= len;
    for(int i = 0; i < len; ++i) {
        size_t idx = __EXTRAP_NESTED_CALLS.len + i;
        // Free allocated array of pointers.
        free(__EXTRAP_NESTED_CALLS.data[idx].json_data);
    }
}

// Store the recent 
void __dfsw_EXTRAP_SET_CURRENT_CALL(int16_t idx)
{
  debug_print("Set current function call index %d\n", idx);
  __EXTRAP_CURRENT_CALL = idx;
}

int16_t __dfsw_EXTRAP_CURRENT_CALL()
{
  debug_print("Get current function call index %d\n", __EXTRAP_CURRENT_CALL);
  return __EXTRAP_CURRENT_CALL;
}

int32_t __dfsw_EXTRAP_VAR_ID()
{
  // Using a local variable prevents static initialization fiasco
  // Parameter ids begin at the last implicit parameter and the ID values
  // grow during program execution.
  static int32_t id = -1;
  if(id == -1)
    id = __EXTRAP_INSTRUMENTATION_IMPLICIT_PARAMS_COUNT;
  __EXTRAP_INSTRUMENTATION_EXPLICIT_PARAMS_COUNT++;
  return id++;
}

void __dfsw_EXTRAP_AT_EXIT()
{
    __dfsw_dump_json_output();
    //dependencies * deps = __dfsw_EXTRAP_DEPS_FUNC(0);
    int deps_count = __EXTRAP_LOOPS_STRUCTURE_PER_FUNC_OFFSETS[
                __EXTRAP_INSTRUMENTATION_FUNCS_COUNT
            ];
    dependencies * deps = __EXTRAP_LOOP_DEPENDENCIES;
    for(int i = 0; i < deps_count; ++i)
        free(deps[i].deps);
    free(deps);

    free(__EXTRAP_CALLSTACK.stack);
}

void __dfsw_EXTRAP_CHECK_CALLSITE(int8_t * addr, size_t size, int32_t function_idx, int32_t callsite_idx, int32_t arg_idx)
{
    //dfsan_label temp = dfsan_read_label(addr, size);
    //for(int i = 0; i < __EXTRAP_INSTRUMENTATION_PARAMS_COUNT; ++i) {
    //    if(__EXTRAP_INSTRUMENTATION_LABELS[i]) {
    //        printf("Call %d func at %d site for arg %d label %d result %d\n",
    //                function_idx, callsite_idx, arg_idx, i, dfsan_has_label(temp, __EXTRAP_INSTRUMENTATION_LABELS[i]));
    //        if(dfsan_has_label(temp, __EXTRAP_INSTRUMENTATION_LABELS[i])) {
    //            int offset = __EXTRAP_INSTRUMENTATION_CALLSITES_OFFSETS[function_idx];
    //            int arg_count = __EXTRAP_INSTRUMENTATION_FUNCS_ARGS[function_idx];
    //            offset += arg_count * callsite_idx;
    //            offset += arg_idx;
    //            __EXTRAP_INSTRUMENTATION_CALLSITES_RESULTS[offset] |= (1 << i);
    //        }
    //    }
    //}
}

bool __dfsw_is_power_of_two(uint16_t val)
{
    return val && !(val & (val - 1) );
}

void __dfsw_add_dep(uint16_t val, dependencies * deps)
{
    //TODO: more efficient with capacity
    for(size_t i = 0; i < deps->len; ++i) {
        if(deps->deps[i] == val)
            return;
        // existing val is subset -> replace
        if( (deps->deps[i] & val) == deps->deps[i]) {
            deps->deps[i] = val;
        }
        // new value is a subset -> ignore
        if( (deps->deps[i] & val) == val) {
            return;
        }
    }
    debug_print("Added dependency %d to size %d\n", val, deps->len);
    if(deps->len == deps->capacity) {
        deps->capacity += 5;
        deps->deps = realloc(deps->deps, sizeof(dependencies) * deps->capacity);
    }
    deps->deps[deps->len] = val;
    deps->len++;
}

//dependencies * __dfsw_EXTRAP_GET_DEPS(int32_t loop_idx, int32_t depth,
//        int32_t function_idx)
//{
//    int32_t depths_offset = __EXTRAP_LOOPS_DEPTHS_FUNC_OFFSETS[function_idx];
//    //Position of `dependencies` object for this loop is composed from
//    //a) beginning offset of this function
//    //b) sum of depths for all previous loops in this function
//    //c) depth level for this loop
//    int offset = __EXTRAP_LOOPS_DEPS_OFFSETS[function_idx];
//    for(int i = 0; i < loop_idx; ++i)
//        offset += __EXTRAP_LOOPS_DEPTHS_PER_FUNC[depths_offset + i];
//    offset += depth;
//    return &__EXTRAP_LOOP_DEPENDENCIES[offset];
//}

void __dfsw_EXTRAP_COMMIT_LOOP(int32_t function_idx, int calls_count)
{
  if(__EXTRAP_LOOP_DEPENDENCIES) {
    //fprintf(stderr, "Idx %d CallsCount %d\n", function_idx, calls_count);
    __dfsw_json_write_loop(function_idx, calls_count);
  }
}

void __dfsw_EXTRAP_CHECK_LABEL(uint16_t temp, int32_t nested_loop_idx, int32_t function_idx)
{
    // First, we track all of found labels.
    // If there is more then one label, we write down dynamically a tuple.
    // If there is exactly one label, we write it statically.
    // Otherwise we don't write any results.
    //int offset = function_idx*__EXTRAP_INSTRUMENTATION_PARAMS_COUNT;
    //uint16_t found_params = 0;
    //for(int i = 0; i < __EXTRAP_INSTRUMENTATION_PARAMS_COUNT; ++i)
    //    if(__EXTRAP_INSTRUMENTATION_LABELS[i]) {
    //        bool has_label = dfsan_has_label(temp, __EXTRAP_INSTRUMENTATION_LABELS[i]);
    //        found_params |= (has_label << i);
    //        //printf("%d %d %d\n", function_idx, has_label, found_params);
    //    }
    ////printf("%d %d \n", function_idx, found_params);
    //// write down only a combination
    //if(found_params && !__dfsw_is_power_of_two(found_params)) {
    //    __dfsw_add_dep(found_params, __dfsw_EXTRAP_DEPS_FUNC(function_idx));
    //}
    //// write down a parameter
    //else if(found_params) {
    //    for(int i = 0; i < __EXTRAP_INSTRUMENTATION_PARAMS_COUNT; ++i) {
    //        if(found_params & (1 << i)) {
    //            __EXTRAP_INSTRUMENTATION_RESULTS[offset + i] = true;
    //            break;
    //        }
    //    }
    //}

    //Position of `dependencies` object for this loop is composed from
    //a) beginning offset of this function
    //b) sum of depths for all previous loops in this function
    //c) depth level for this loop
    //int offset = __EXTRAP_LOOPS_DEPS_OFFSETS[function_idx];
    //for(int i = 0; i < loop_idx; ++i)
    //    offset += __EXTRAP_LOOPS_DEPTHS_PER_FUNC[depths_offset + i];
    //offset += depth;
    int32_t offset = __EXTRAP_LOOPS_STRUCTURE_PER_FUNC_OFFSETS[function_idx];
    offset += nested_loop_idx;
    uint16_t found_params = 0;
    size_t param_count = __EXTRAP_INSTRUMENTATION_EXPLICIT_PARAMS_COUNT
      + __EXTRAP_INSTRUMENTATION_IMPLICIT_PARAMS_COUNT;
    // We iterate only to # of currently known parameters
    for(int i = 0; i < param_count; ++i)
        if(__EXTRAP_INSTRUMENTATION_LABELS[i]) {
            bool has_label = dfsan_has_label(temp, __EXTRAP_INSTRUMENTATION_LABELS[i]);
            found_params |= (has_label << i);
            //printf("%d %d %d\n", function_idx, has_label, found_params);
        }
    if(found_params)
        __dfsw_add_dep(found_params, &__EXTRAP_LOOP_DEPENDENCIES[offset]);
}

void __dfsw_EXTRAP_CHECK_LOAD(int8_t * addr, size_t size,
        int32_t nested_loop_idx, int32_t func_idx)
{
    if(!addr)
        return;
    dfsan_label temp = dfsan_read_label(addr, size);
    debug_print("Read label %d at addr: %p, loop %d func %d \n", temp, addr, nested_loop_idx, func_idx);
    __dfsw_EXTRAP_CHECK_LABEL(temp, nested_loop_idx, func_idx);
}


void __dfsw_EXTRAP_STORE_LABELS(const char * name, int32_t param_idx, size_t count, va_list args)
{
    dfsan_label lab = dfsan_create_label(name, NULL);
    __EXTRAP_INSTRUMENTATION_LABELS[param_idx] = lab;
    __EXTRAP_INSTRUMENTATION_PARAMS_NAMES[param_idx] = name;
    debug_print("Register %lu variables\n", count);
    //va_start(args, count);
    for (int i = 0; i < count; ++i) {
        void * addr = va_arg(args, void*);
        size_t size = va_arg(args, size_t);
        debug_print("Register variable %s at %p of size %lu\n", name, addr, size);
        dfsan_set_label(lab, addr, size);
    }
    //va_end(args);
}

void __dfsw_EXTRAP_STORE_LABEL(int8_t * addr, size_t size, int32_t param_idx, const char * name);
void __dfsw_EXTRAP_WRITE_LABEL(int8_t * addr, size_t size, const char * name)
{
  size_t param_count = __EXTRAP_INSTRUMENTATION_EXPLICIT_PARAMS_COUNT
    + __EXTRAP_INSTRUMENTATION_IMPLICIT_PARAMS_COUNT;
  for(int i = 0; i < param_count; ++i) {
      if(!strcmp(__EXTRAP_INSTRUMENTATION_PARAMS_NAMES[i], name)) {
          dfsan_label lab = __EXTRAP_INSTRUMENTATION_LABELS[i];
          dfsan_set_label(lab, addr, size);
          debug_print("Write label %d for variable %s at pos %d \n", lab, name, i);
          return;
      }
  }
  int32_t param_id = __dfsw_EXTRAP_VAR_ID();
  debug_print("Write new label %s at pos %d\n", name, param_id);
  __dfsw_EXTRAP_STORE_LABEL(addr, size, param_id, name);
}

void __dfsw_EXTRAP_WRITE_PARAMETER(int8_t * addr, size_t size, int32_t param_idx)
{
  dfsan_set_label(
    __EXTRAP_INSTRUMENTATION_LABELS[param_idx],
    addr,
    size
  );
}

void __dfsw_EXTRAP_STORE_LABEL(int8_t * addr, size_t size, int32_t param_idx, const char * name)
{
    dfsan_label lab = dfsan_create_label(name, NULL);
    __EXTRAP_INSTRUMENTATION_LABELS[param_idx] = lab;
    __EXTRAP_INSTRUMENTATION_PARAMS_NAMES[param_idx] = name;
    debug_print("Store label %s with label %ld\n", name, lab);
    dfsan_set_label(lab, addr, size);
}

void __dfsw_EXTRAP_INIT()
{
    int deps_count = __EXTRAP_LOOPS_STRUCTURE_PER_FUNC_OFFSETS[
                __EXTRAP_INSTRUMENTATION_FUNCS_COUNT
            ];
    for(int i = 0; i < __EXTRAP_INSTRUMENTATION_IMPLICIT_PARAMS_COUNT; ++i) {
      dfsan_label lab = dfsan_create_label(
          __EXTRAP_INSTRUMENTATION_PARAMS_NAMES[i],
          NULL
      );
      __EXTRAP_INSTRUMENTATION_LABELS[i] = lab;
    }
    __EXTRAP_LOOP_DEPENDENCIES = calloc(deps_count, sizeof(dependencies));
    __EXTRAP_CURRENT_CALL = -1;
    __dfsw_json_initialize();
}

void __dfsw_EXTRAP_MARK_IMPLICIT_LABEL(uint16_t function_idx,
        uint16_t nested_loop_idx, uint16_t implicit_label_idx)
{
    int32_t offset = __EXTRAP_LOOPS_STRUCTURE_PER_FUNC_OFFSETS[function_idx];
    offset += nested_loop_idx;
    uint16_t found_params = (1 << (implicit_label_idx));
    __dfsw_add_dep(found_params, &__EXTRAP_LOOP_DEPENDENCIES[offset]);
}

void __dfsw_EXTRAP_REGISTER_FUNCTION_CALL(uint16_t function_idx)
{
    
}

//void __dfsw_EXTRAP_CHECK_CALLSITE(int function_idx, int callsite_idx,
//        int arg_idx, int8_t * addr, size_t size)
//{
//    dfsan_label temp = dfsan_read_label(addr, size);
//    bool found_params[__EXTRAP_INSTRUMENTATION_PARAMS_COUNT] = {0};
//    for(int i = 0; i < __EXTRAP_INSTRUMENTATION_PARAMS_COUNT; ++i)
//        if(__EXTRAP_INSTRUMENTATION_LABELS[i]) {
//            dfound_params[i] =
//                dfsan_has_label(temp, __EXTRAP_INSTRUMENTATION_LABELS[i]);
//    __dfsw_json_callsite(function_idx, callsite_idx, arg_idx, found_params);
//}
