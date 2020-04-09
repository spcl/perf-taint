
#include <iostream>
#include <fstream>

#include <dfsan-instr/Statistics.hpp>


namespace perf_taint {

  void Statistics::init()
  {
    stats["functions"] = json_t::object();
  }

  void Statistics::found_function(const std::string & name)
  {
    functions_count++;
    stats["functions"][name] = json_t::object();
  }
 
  void Statistics::pruned_function(const std::string & name,
      const std::string & reason)
  {
    stats["functions"][name]["pruned"].push_back(reason);
    ++pruned_count;
    pruned_functions[reason]++;
  }
  
  void Statistics::instrumented_function(const std::string & name,
      const std::string & reason)
  {
    ++instrumented_count;
    instrumented_functions[reason]++;
    stats["functions"][name]["instrumented"].push_back(reason);
  }

  void Statistics::print(const std::string & file_name)
  {
    stats["statistics"]["functions"]["total"] = functions_count;
    stats["statistics"]["functions"]["total_pruned"] = pruned_count;
    stats["statistics"]["functions"]["total_instrumented"] = instrumented_count;
    stats["statistics"]["functions"]["pruned"] = pruned_functions;
    stats["statistics"]["functions"]["instrumented"] = instrumented_functions;


    std::ofstream json_out(file_name);
    json_out << stats.dump(2) << std::endl;
  }

}
