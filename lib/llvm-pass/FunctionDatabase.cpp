

#include <perf-taint/llvm-pass/FunctionDatabase.hpp>
#include <perf-taint/llvm-pass/Instrumenter.hpp>

#include <llvm/IR/InstrTypes.h>
#include <llvm/IR/Function.h>


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
      input >> json;

      int param_idx = 0;
      for(auto & param : json["parameters"]) {
          implicit_parameters.emplace_back(param.get<std::string>(), param_idx++);
      }

      json_t & functions = json["functions"];
      for(auto it = functions.begin(), end = functions.end(); it != end; ++it) {
          DataBaseEntry entry{it.value()["loops"]};
          this->functions[it.key()] = std::move(entry);
      }

      json_t & sources = json["sources"];
      for(auto it = sources.begin(), end = sources.end(); it != end; ++it) {

        ParameterSource source;
        auto & args_positions = it.value()["positions"];
        for (auto v = args_positions.begin(), v_end = args_positions.end();
            v != v_end;
            ++v
        ) {
          int pos = std::stoi(v.key());
          const ImplicitParameter * param = find_parameter(v.value().get<std::string>());
          assert(param);
          source.function_parameters.emplace_back(pos, param);
        }
        if(!(*it)["retval"].is_null()) {
          const ImplicitParameter * param = find_parameter(
              (*it)["retval"].get<std::string>()
          );
          assert(param);
          source.return_value = param;
        }
        this->parameter_sources[it.key()] = std::move(source);
      }
  }

  const FunctionDatabase::ImplicitParameter * FunctionDatabase::find_parameter(
      const std::string & param_name
  ) const
  {
    auto it = std::find_if(implicit_parameters.begin(), implicit_parameters.end(),
            [&](const auto & v) { return v.name == param_name; });
    return it != implicit_parameters.end() ? &(*it) : nullptr;
  }

  void FunctionDatabase::setInstrumenter(perf_taint::Instrumenter * _instr)
  {
    this->instrumenter = _instr;
  }

  bool FunctionDatabase::contains(llvm::Function * f)
  {
      return functions.find(f->getName()) != functions.end();
  }

  void FunctionDatabase::annotateParameters(
      llvm::Function * called_function,
      llvm::Value * call
  ) const
  {
    auto it = parameter_sources.find(called_function->getName());
    if(it != parameter_sources.end()) {
      llvm::CallBase * call_instr
        = llvm::dyn_cast<llvm::CallBase>(call);
      assert(call_instr);
      const ParameterSource & source = (*it).second; 
      // write label to corresponding arguments
      for(auto & arg : source.function_parameters)
        instrumenter->writeParameter(
            call_instr,
            call_instr->getArgOperand(std::get<0>(arg)),
            std::get<1>(arg)->param_idx
        );
      // write label to return value from the function
      if(source.return_value)
        instrumenter->writeParameter(
            call_instr,
            call_instr,
            source.return_value->param_idx
        );

    }
  }

  int FunctionDatabase::processLoop(llvm::Function * f, llvm::Value * call,
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

      //TODO: this currently does not support multiple loops
      ImplicitCall implicit_call{base, name};
      while(cur) {
        for(auto & v : (*cur)["params"]) {
          // a string name of an implicit parameter
          if(!v.is_object()) {
            std::string param_name = v.get<std::string>();
            auto it = std::find_if(implicit_parameters.begin(), implicit_parameters.end(),
                    [&](const auto & v) { return v.name == param_name; });
            // TODO: remove after removing leftovers of non-implicit params from mpi abilist
            if(it != implicit_parameters.end())
              implicit_call.args.push_back((*it).param_idx);
          } else {
            std::string type = v["type"].get<std::string>();
            //TODO: retval?
            if(type == "arg") {
              int pos = v["pos"].get<int>();
              implicit_call.args.push_back( -(pos + 1) );
            } else
              throw std::runtime_error("Not implemented");
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
      func.implicit_loops.push_back(implicit_call);
    // TODO: support multipath loops
    //int depth = loop_data.size();
    int loop_count = 0;
    //int structure_size = func.loops_structures.size();
    //for(auto & vec : loop_data) {
    //    loop_count += vec.size();
    //    std::copy(vec.begin(), vec.end(),
    //            std::back_inserter(func.loops_structures));
    //}
    //structure_size = func.loops_structures.size() - structure_size;
    //func.loops_sizes.push_back(depth);
    //func.loops_sizes.push_back(structure_size);
    //func.loops_sizes.push_back(loop_count);
    //// obtain nested_loop_idx
    return loop_count;
  }

}

