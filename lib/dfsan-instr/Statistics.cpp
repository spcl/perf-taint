
#include <iostream>
#include <fstream>

#include <dfsan-instr/Statistics.hpp>


namespace perf_taint {

  void Statistics::init()
  {
    stats["functions"] = json_t::array();
    stats["functions_pruned"] = json_t::array();
    stats["functions_instrumented"] = json_t::array();
    stats["statistics"]["pruned"] = json_t::object();
  }

  void Statistics::found_function(const std::string & name)
  {
    functions_count++;
    stats["functions"].push_back(name);
  }

  void Statistics::pruned_function(const std::string & name, const std::string & reason)
  {
    if(stats["statistics"]["pruned"].find(reason)
        == stats["statistics"]["pruned"].end())
      stats["statistics"]["pruned"][reason] = 0;
    stats["statistics"]["pruned"][reason]
      = stats["statistics"]["pruned"][reason].get<int>() + 1;
    stats["functions_pruned"].push_back(name);
  }
  
  void Statistics::instrumented_function(const std::string & name)
  {
    stats["functions_instrumented"].push_back(name);
    instrumented_count++;
  }

  void Statistics::print()
  {
    stats["statistics"]["functions"] = functions_count;
    stats["statistics"]["instrumented"] = instrumented_count;

    std::ofstream json_out("perf-taint-pass.json");
    json_out << stats.dump(2) << std::endl;
  }

}
