
#include <map>

#include <dfsan-instr/common.hpp>

namespace perf_taint {

  struct Statistics
  {
    json_t stats;
    int functions_count;
    int instrumented_count;
    int pruned_count;
    int calls_to_check;
    std::map<std::string, int> pruned_functions;
    std::map<std::string, int> instrumented_functions;

    Statistics():
      functions_count(0),
      instrumented_count(0),
      pruned_count(0)
    {
      init();
    }

    void init();
    void found_function(const std::string & name);
    void instrumented_function(const std::string & name, const std::string & reason);
    void pruned_function(const std::string & name, const std::string & reason);
    void print(const std::string & file_name);

    template<typename T>
    void function_statistics(const std::string & name, const std::string & cat,
        const std::string & stat, T && val)
    {
      stats["functions"][name][cat][stat] = val;
    }
  };

}
