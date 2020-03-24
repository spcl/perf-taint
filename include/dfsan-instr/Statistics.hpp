
#include <dfsan-instr/common.hpp>

namespace perf_taint {

  struct Statistics
  {
    json_t stats;
    int functions_count;
    int instrumented_count;
    int calls_to_check;

    Statistics():
      functions_count(0),
      instrumented_count(0)
    {
      init();
    }

    void init();
    void found_function(const std::string & name);
    void instrumented_function(const std::string & name);
    void pruned_function(const std::string & name, const std::string & reason);
    void print();
  };

}
