

#include <llvm/IR/InstrTypes.h>
#include <llvm/IR/Function.h>

#include <dfsan-instr/FunctionDatabase.hpp>

namespace perf_taint {

  size_t FunctionDatabase::parameters_count() const
  {
      return implicit_parameters.size();
  }

  const std::string & FunctionDatabase::parameter_name(size_t idx) const
  {
      return implicit_parameters[idx].name;
  }

  void FunctionDatabase::read(std::ifstream & input)
  {
      json_t json;
      json << input;

      int param_idx = 0;
      for(auto & param : json["parameters"]) {
          implicit_parameters.emplace_back(param.get<std::string>(), param_idx++);
      }

      json_t & functions = json["functions"];
      for(auto it = functions.begin(), end = functions.end(); it != end; ++it) {
          DataBaseEntry entry{it.value()["loops"]};
          this->functions[it.key()] = std::move(entry);
      }
  }

  bool FunctionDatabase::contains(llvm::Function * f)
  {
      return functions.find(f->getName()) != functions.end();
  }

  void FunctionDatabase::processLoop(llvm::Function * f, llvm::Value * call,
          Function & func, vec_t & loop_data)
  {
      auto it = functions.find(f->getName());
      assert(it != functions.end());
      json_t & loops_data = (*it).second.loops_data;
      //TODO: put this into structure to avoid going multiple times through a JSON
      json_t * cur = &loops_data;
      llvm::Instruction * call_i = llvm::dyn_cast<llvm::Instruction>(call);
      assert(call_i);
      llvm::CallBase * base = llvm::dyn_cast<llvm::CallBase>(call_i);
      assert(base);
      std::string name = base->getCalledFunction()->getName();
      while(cur) {
          //TODO: multiple params
          for(auto & v : (*cur)["params"]) {
              std::string param_name = v.get<std::string>();
              auto it = std::find_if(implicit_parameters.begin(), implicit_parameters.end(),
                      [&](const auto & v) { return v.name == param_name; });
              // TODO: here implement non-implicit params
              if(it != implicit_parameters.end()) {
                  func.implicit_loops.emplace_back(call_i, name, (*it).param_idx);
              }
          }
          auto subloop = cur->find("loops");
          if(subloop != cur->end()) {
              loop_data.emplace_back(1, (*subloop).size());
              // TODO: multiple loops
              cur = &(*subloop).front();
          } else {
              loop_data.emplace_back(1, 0);
              cur = nullptr;
          }
      }
      //llvm::errs() << "Insert for function " << f->getName() << '\n';
      //llvm::errs() << "Depth " << loop_data.size() << '\n';
      //for(int i = 0; i < loop_data.size(); ++i) {
      //    llvm::errs() << "Level " << i;
      //    for(int j = 0; j < loop_data[i].size(); ++j)
      //        llvm::errs() << loop_data[i][j];
      //    llvm::errs() << '\n';
      //}
      //auto & subloops = l.getSubLoops();
      //if(depth < data.size())
      //    data[depth].push_back(subloops.size());
      //else {
      //    data.emplace_back(1, subloops.size());
      //}
      //int loop_count = subloops.size();
      //for(llvm::Loop * l : subloops) {
      //    loop_count += analyzeLoop(f, *l, data, depth + 1);
      //}
      // TODO: support multipath loops
      int depth = loop_data.size();
      int loop_count = 0;
      int structure_size = func.loops_structures.size();
      for(auto & vec : loop_data) {
          loop_count += vec.size();
          std::copy(vec.begin(), vec.end(),
                  std::back_inserter(func.loops_structures));
      }
      structure_size = func.loops_structures.size() - structure_size;
      func.loops_sizes.push_back(depth);
      func.loops_sizes.push_back(structure_size);
      func.loops_sizes.push_back(loop_count);
      // obtain nested_loop_idx
  }

}
