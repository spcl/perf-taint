
#ifndef __PERF_TAINT_HPP__
#define __PERF_TAINT_HPP__

#include <cstdint>

extern "C"{
  void __dfsw_EXTRAP_WRITE_LABEL(int8_t *, int32_t, const char*);
  bool __dfsw_perf_taint_has_label(int8_t *, int32_t, const char*);
  void __dfsw_perf_taint_delete_label(int8_t *, int32_t, const char*);
  void __dfsw_perf_taint_delete_labels(int8_t *, int32_t);
}

#define EXTRAP __attribute__(( annotate("extrap") ))
#define VARIABLE_NAME(var) #var

namespace perf_taint {

  template<typename T>
  void register_variable(T * ptr, const char * name)
  {
    __dfsw_EXTRAP_WRITE_LABEL(reinterpret_cast<int8_t*>(ptr), sizeof(T), name);
  }

  template<typename T>
  bool has_label(T * ptr, const char * label)
  {
    return __dfsw_perf_taint_has_label(reinterpret_cast<int8_t*>(ptr), sizeof(T), label);
  }

  template<typename T>
  void delete_label(T * ptr, const char * label)
  {
    __dfsw_perf_taint_delete_label(reinterpret_cast<int8_t*>(ptr), sizeof(T), label);
  }

  template<typename T>
  void delete_labels(T * ptr)
  {
    __dfsw_perf_taint_delete_labels(reinterpret_cast<int8_t*>(ptr), sizeof(T));
  }

}

#endif
