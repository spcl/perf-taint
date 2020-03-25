
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
  }
  
  void Statistics::instrumented_function(const std::string & name,
      const std::string & reason)
  {
    stats["functions"][name]["instrumented"].push_back(reason);
  }

  void Statistics::print(const std::string & file_name)
  {
    stats["statistics"]["functions"] = functions_count;

    std::ofstream json_out(file_name);
    json_out << stats.dump(2) << std::endl;
  }

}
