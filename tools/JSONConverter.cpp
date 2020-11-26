#include <iostream>
#include <string>
#include <fstream>
#include <set>
#include <nlohmann/json.hpp>

typedef nlohmann::json json_t;

#define ENABLE_FIX_ICS_2019_RESULTS FALSE

// loop_idx -> loop
typedef std::map<std::string, std::vector<const json_t*>> set_t;
json_t convert_loop_set(const json_t & loop_set);

json_t convert_params(const json_t & params)
{
    json_t output;
    output["dependency"] = "unknown";
    json_t & ops = output["operands"];
    for(const auto & param : params) {
        if(param.is_array()) {
            for(const auto & p : param)
                ops.push_back(p);
        } else
            ops.push_back(param);
    }
    //if(ops.size() == 1)
    //    return ops[0];
    //else
    return output;
}

json_t convert_loop(const json_t & loop)
{
    std::vector<json_t> layers;

    json_t current;
    std::vector<json_t> additive_layers;

    //array of jsons coming from nested calls
    if(loop.is_array()) {
        for(const auto & single_loop : loop) {
            json_t j = convert_loop_set(single_loop);
            if(!j.empty())
                additive_layers.push_back(j);
        }
        json_t additive;
        additive["dependency"] = "additive";
        if(additive_layers.size() != 0) {
            additive["operands"] = std::move(additive_layers);
        } else {
            additive["operands"] = json_t{};
        }
        return additive;
    } else {

        auto subloops = loop.find("loops");
        if(subloops != loop.end()) {
            for(auto it = subloops->begin(), end = subloops->end(); it != end; ++it) {
                //std::cout << it.key() << ' ' << it.value() << '\n';
                //std::cout << "Convert: " << it.value() << '\n';
                additive_layers.push_back( convert_loop(it.value()) );
                //std::cout << "Converted: " << additive_layers.back() << '\n';
            }
        }
        auto it = loop.find("params");
        //std::cout << "Properconvert: " << loop << " " << additive_layers.size() << '\n';
        if(it != loop.end()) {
            json_t params = convert_params(*it);
            // no additional dependency
            if(additive_layers.size() == 0) {
                return params;
            }
            else {
                json_t additive;
                additive["dependency"] = "additive";
                additive["operands"] = std::move(additive_layers);
                json_t result;
                result["dependency"] = "multiplicative";
                result["operands"].push_back(params);
                result["operands"].push_back(additive);
                return result;
            }
        } else {
            // no params? skip this, return an additive over subloops
            if(additive_layers.size() == 1) {
                return additive_layers[0];
            }
            //else if(additive_layers.size() == 0) {
            //    return json_t();
            //}
            else {
                json_t additive;
                additive["dependency"] = "additive";
                additive["operands"] = std::move(additive_layers);
                return additive;
            }
        }
    }

    //while(cur_layer) {
    //    auto it = cur_layer->find("params");
    //    //std::cout << *cur_layer << ' ' << (it != cur_layer->end()) << '\n';
    //    if(it != cur_layer->end()) {
    //        layers.push_back( convert_params(*it) );
    //    }
    //    auto subloops = cur_layer->find("loops");
    //    //std::cout << *cur_layer << ' ' << (subloops != cur_layer->end()) << '\n';
    //    cur_layer = (subloops != cur_layer->end()) ? &(*subloops) : nullptr;
    //    additive_layers.clear();
    //    if(cur_layer) {
    //        for(auto it = cur_layer->begin(), end = cur_layer->end(); it != end; ++it) {
    //            std::cout << it.key() << ' ' << it.value() << '\n';
    //        }
    //    }
    //}

    //output["dependency"] = "multiplicative";
    //output["operands"] = layers;

    //return output;
}


json_t convert_loop_set(const json_t & loop_set)
{
    json_t output;
    output["dependency"] = "additive";
    json_t & deps = output["operands"];
    for(auto it = loop_set.begin(), end = loop_set.end(); it != end; ++it)
    {
        // TODO : change when we get sequence of loops comitted at instance
        //json_t dep;
        //for(auto v : it.value()) {
        //dep.push_back(convert_loop(*v));
        //}
        //deps.push_back(dep);
        json_t converted = convert_loop(it.value());
        if(converted["operands"].size() != 0) {
            deps.push_back( std::move(converted) );
        }
    }

    return deps.size() != 0 ? output : json_t{};
}

uint32_t param_to_int(const json_t & op, const json_t & params)
{
    uint32_t res = 0;
    for(auto & v: op) {
        size_t i = 0;
        for(; i < params.size(); ++i)
            if(params[i] == v)
                break;
        res |= (1 << i);
    }
    return res;
}

std::vector<uint32_t> parse(const json_t & op, const json_t & all_params)
{
    // now we process each instance per callstack
    //if(op.is_array()) {
    //    std::cout << "Process param: " << op << ' ' << param_to_int(op, all_params) << '\n';
    //    return std::vector<uint32_t>(1, param_to_int(op, all_params));
    //} else
    //if(op.is_array()) {
    //    std::cout << "Process param: " << op << ' ' << param_to_int(op, all_params) << '\n';
    //    return std::vector<uint32_t>(1, param_to_int(op, all_params));
    //} else
    if(op.is_array()) {
        return parse(op[0], all_params);
    } else if(op["dependency"] == "additive") {
        const json_t ops = op["operands"];
        std::vector<uint32_t> params;
        for(const auto & v : ops) {
            //std::cout << "Process additive arg: " << v << '\n';
            auto res = parse(v, all_params);
            //std::cout << "Process additive arg: " << v << " results: ";
            for(uint32_t val : res) {
                //std::cout << val << ' ';
                params.push_back(val);
            }
            //std::cout << '\n';
        }
        //std::cout << "Process additive: " << ops << ' ' << params.size() << '\n';
        return params;
    } else if(op["dependency"] == "multiplicative") {
        const json_t ops = op["operands"];
        std::vector<uint32_t> params = parse(ops[0], all_params);
        //std::cout << "Process multiplicative arg: " << ops[0]  << " begin: ";
        //for(auto v : params)
        //    std::cout << v << ' ';
        //std::cout << '\n';
        // TODO: remove duplicates
        for(int i = 1; i < ops.size(); ++i) {
           auto res = parse(ops[i], all_params);
           std::vector<uint32_t> new_params;
            //std::cout << "Process multiplicative arg: " << ops[i]  << " results: ";
            for(int i = 0; i < params.size(); ++i) {
               for(int j = 0; j < res.size(); ++j) {
                    uint32_t result = params[i] | res[j];
                    //std::cout << result << ' ';
                    new_params.push_back(result);
               }
            }
            //std::cout << '\n';
            // if there is nothing beneath, don't override old results
            if(res.size() != 0)
                params = std::move(new_params);
        }
        //std::cout << "Process mul: " << ops << ' ' << params.size() << '\n';
        return params;
    } else if(op["dependency"] == "unknown") {
        uint32_t res = 0;
        //std::cout << "Process unknown: " << op["operands"] << '\n';
        for(const auto & v : op["operands"])
            res |= param_to_int(v, all_params);
        //std::cout << "Process unknown: " << op["operands"] << ' ' << res << '\n';
        return std::vector<uint32_t>{res};
    } else {
        assert(false);
    }
}

void get_deps(json_t & out, json_t & loop, const json_t & params)
{
    // pessimistic implementation - each unknown is multiplication
    // TODO : change when we get sequence of loops comitted at instance
    //json_t & ops = loop["operands"];
    json_t & deps = out["deps"];
    std::set<uint32_t> dependencies;
    json_t & not_found_params = out["not_found_params"];
    uint32_t aggregation = 0;
    // TODO: nested array, shouldn't be here
    // right now we have have a list of loops and for each one list of instances
    // this should be a list of instances where each one is additive instance
    //std::cout << "Op: " << ops << '\n';
    //for(const auto & op_array : ops)
    //{
    //    std::cout << "Op: " << op_array << '\n';
    //    for(const auto & op : op_array)
    //    {
    //        std::vector<uint32_t> results = parse(op, params);
    //        for(uint32_t v : results)
    //        {
    //            aggregation |= v;
    //            dependencies.insert(v);
    //        }
    //    }
    //}
    std::vector<uint32_t> loop_data = parse(loop, params);
    for(uint32_t v : loop_data)
    {
        aggregation |= v;
        dependencies.insert(v);
    }
    for(int i = 0; i < params.size(); ++i)
        if(!(aggregation & (1 << i)))
           not_found_params.push_back(params[i]);
    for(auto v : dependencies)
    {
        json_t dependency;
        for(int i = 0; i < params.size(); ++i)
            if(v & (1 << i))
                dependency.push_back(params[i]);
        deps.push_back( std::move(dependency) );
    }
}

bool process_entry(json_t & entry, const json_t & input, json_t & out)
{
  auto elem = entry.find("entry_id");
  if(elem != entry.end()) {
    uint32_t f_idx = entry["function_idx"].get<uint32_t>();
    std::string f_name = input["functions_mangled_names"][f_idx].get<std::string>();
    auto function_instance = input["functions"].find(f_name);
    assert(function_instance != input["functions"].end());
    uint32_t id = (*elem).get<uint32_t>();
    out.push_back((*function_instance)["loops"][id]["instance"]);
    return true;
  }
  return false;
}

bool replace(const json_t & input, json_t & instance)
{
  bool replaced = true;
  while(replaced) {
    replaced = false;
    for(auto it = instance.begin(), end = instance.end(); it != end; ++it) {
      auto elem = it.value().find("loops");
      if(elem != it.value().end())
        replaced |= replace(input, *elem); 
      if(it.value().is_array()) {
        json_t out;
        for(auto & entry : it.value()) {

          if(!process_entry(entry, input, out)) {
            replace(input, entry);
            // for recursive processing - replaced one, now we have to replace the same thing again
            //for(auto entry_elem = entry.begin(); entry_elem != entry.end(); ++entry_elem) {
            //  for(auto & entry_elem2 : entry_elem.value())
            //    process_entry(entry_elem2, input, out);
            //}
          }
        }
        // will be null for an array of params, 
        if(!out.is_null()) {
          (*it) = std::move(out);
          replaced = true;
        }
      }
    }
  }
  return replaced;
}

bool is_important_instance(const json_t & instance, const json_t & names)
{
  bool is_important = false;
  for(auto loop_it  = instance.begin(); loop_it != instance.end(); ++loop_it) {
    // if it's an array, it will contain entries of called functions
    const json_t & loop = loop_it.value();
    if(!loop.is_array()) {
      if(loop.count("params")) {
        return true;
      }
      auto subloops = loop.find("loops");
      if(subloops != loop.end())
        is_important |= is_important_instance(subloops.value(), names);
    }
    //FIXME: temporary fix to handle implicit calls to MPI functions
    else {
      for(const json_t & entry : loop) {
        std::string name = names[entry["function_idx"].get<int>()];
        if(name.find("MPI_") == 0)
          is_important = true;
      }
    }
    // as soon as we find an important subloop then we're done
    if(is_important)
      return true;
  }
  return false;
}

bool is_important(const json_t & func, const json_t & names)
{
  for(auto it = func.begin(); it != func.end(); ++it) {
    const json_t & instance = it.value()["instance"];
    if(is_important_instance(instance, names))
      return true;
  }
  return false;
}

int count_loops(json_t & loop, std::map<int, std::set<std::string>> & loops)
{
  for(auto it = loop.begin(); it != loop.end(); ++it) {
    //std::cerr << it.key() << " " << *it << std::endl;
    auto it_params = (*it).find("params");
    if(it_params != (*it).end()) {
      for(json_t & params: (*it_params)) {
        int loop_idx = (*it)["level"].get<int>()*100 + std::stoi(it.key());
        //std::cerr << params << loop_idx << std::endl;
        for(const std::string & name : params) {
          std::set<std::string> & loops_deps = loops[loop_idx];
          loops_deps.insert(name);
        }
      }
    }
    auto it_loop = (*it).find("loops");
    if(it_loop != (*it).end()) {
      count_loops(*it_loop, loops);
    }
  }
  return 0;
}

json_t convert(json_t & input, bool generate_full_data)
{
    json_t output;

    //int i = 0;
    //for(; i < output["functions_names"].size(); ++i) {
    //    if(output["functions_names"][i] == "update_h")
    //        std::cerr << i << '\n';

    //}
    std::vector<std::string> to_copy_local{
        "file",
        "line",
        "func_idx"
    };

    std::ofstream of("all_functions.filter", std::ios_base::out);
    of << "SCOREP_REGION_NAMES_BEGIN\n";
    for(const auto & name : input["functions_names"]) {
        of << "INCLUDE *" << name.get<std::string>() << "*\n";
    }
    of << "SCOREP_REGION_NAMES_END\n";
    of.close();

    json_t & functions = input["functions"];
    json_t & unimportant_functions = input["unimportant_functions"];
    json_t & functions_output = output["functions"];
    json_t & params = input["parameters"];
    std::vector<std::string> important_functions(functions.size() + unimportant_functions.size());
    of.open("important_functions.filter", std::ios_base::out);
    of << "SCOREP_REGION_NAMES_BEGIN\n";
    of << "EXCLUDE *\n";
    std::cerr << "Analyze " << unimportant_functions.size() << " unimportant and " << functions.size() << " important functions" << '\n';
    std::set<int> important_indices;//{1, 0};
    for(auto it = functions.begin(), end = functions.end(); it != end; ++it) {
      int idx = it.value()["func_idx"].get<int>();
      if(is_important(it.value()["loops"], input["functions_names"])) {
        important_indices.insert(idx);
        bool is_mangled =
          input["functions_demangled_names"][idx].get<std::string>() !=
            input["functions_mangled_names"][idx].get<std::string>();
        if(is_mangled) {
          std::string name = input["functions_names"][idx].get<std::string>();
          std::string demangled_name = input["functions_demangled_names"][idx].get<std::string>();
          size_t pos = demangled_name.rfind(name);
          assert(pos != std::string::npos);
          size_t l_pos = pos > 0 ? demangled_name.rfind(" \t\r\n", pos) : pos;
          if(l_pos == std::string::npos)
            l_pos = 0;
          // if the name includes namespace, we don't add a space in front.
          // otherwise we might miss constructos since score-p will not match
          // space + name::name()
          // having space is beneficial for other functions since we avoid
          // incorrect matching with some prefix
          // e.g. rule *x(* matching for function f_x()
          std::string parsed_name = demangled_name.substr(l_pos, pos + name.size());
          bool contains_namespace = parsed_name.find("::") != std::string::npos;

          of << "INCLUDE *";
          if(!contains_namespace)
            of << "\\ ";
          of << parsed_name << "(*\n";
        } else
          of << "INCLUDE " << input["functions_names"][idx].get<std::string>() << "\n";
      } else {
        #if ENABLE_FIX_ICS_2019_RESULTS
          important_indices.insert(idx);
        #endif
        std::cerr << "Function excluded from filter because it does not have computations " << it.key() << '\n';
      }
    }

    std::cerr << "Important: " << important_indices.size() << std::endl;
    // before replacing and after finding out what's important
    std::map<std::string, int> loops_params;
    std::map<std::string, int> functions_params;
    std::map<std::string, std::vector<std::string>> functions_names;
    int dynamic_loops = 0;
    int count = 0, count_empty_params = 0;
    for(int func_idx : important_indices)
    {
      std::string name = input["functions_mangled_names"][func_idx].get<std::string>();
      if(name.find("MPI_") == 0) {
        ++count;
      } else {
        json_t & entry = functions[name];
        //std::cerr << name << " " << entry << std::endl;
        std::map<int, std::set<std::string>> loops;
        for(json_t & instance : entry["loops"]) {
          count_loops(instance["instance"], loops);
        }
        std::set<std::string> params;
        for(auto it = loops.begin(); it != loops.end(); ++it) {
          for(const std::string & param : (*it).second) {
            loops_params[param]++;
            params.insert(param);
            for(const std::string & param2 : (*it).second) {
              if(param2 != param) {
                if(param < param2) {
                  for(const std::string & param3 : (*it).second)
                    if(param2 != param3)
                      if(param2 < param3)
                        loops_params[param + "_" + param2 + "_" + param3]++;
                  loops_params[param + "_" + param2]++;
                  //params.insert(param);
                }
              }
            }
          }
        }
        std::cerr << "Function: " << name << " params: " << params.size() << std::endl;
        if(params.size() == 0)
          count_empty_params++;
        for(const std::string & param : params) {
          functions_params[param]++;
          functions_names[param].push_back(name);
          for(const std::string & param2 : params) {
            if(param2 != param) {
              if(param < param2) {
                for(const std::string & param3 : params)
                  if(param2 != param3)
                    if(param2 < param3) {
                      functions_params[param + "_" + param2 + "_" + param3]++;
                      functions_names[param + "_" + param2 + "_" + param3].push_back(name);
                    }
                functions_params[param + "_" + param2]++;
                functions_names[param + "_" + param2].push_back(name);
                //params.insert(param);
              }
            }
          }
        }
        dynamic_loops += loops.size();
        //std::cerr << "FUNC: " << name << " " << loops.size() << std::endl;
        //for(auto it = loops_params.begin(); it != loops_params.end(); ++it)
        //  std::cerr << it->first << " " << it->second << " ";
        //std::cerr << std::endl;
      }
    }
    std::cerr << "MPI functions: " << count << "  empty params: " << count_empty_params << std::endl;
    json_t loops_out;
    loops_out["functions"] = functions_params;
    loops_out["functions_names"] = functions_names;
    loops_out["loops"] = dynamic_loops;
    for(auto it = loops_params.begin(); it != loops_params.end(); ++it)
      loops_out["param"][it->first] = it->second;
    std::cerr << loops_out.dump(2) << std::endl;


    for(auto it = functions.begin(), end = functions.end(); it != end; ++it) {
        int idx = it.value()["func_idx"].get<int>();
        std::string name = input["functions_names"][idx].get<std::string>();
        //std::cout << "Name: " << it.key() << '\n';
        json_t & loops = it.value()["loops"];
        // callstack -> list of loops
        //std::map<json_t, set_t> aggregated_callstacks;
        //for(const auto & loop_instances : loops) {
        ////for(auto it = loops.begin(), end = loops.end(); it != end; ++it) {
        //    //std::string loop_idx = it.key();
        //    //const auto & loop_instances = it.value();
        //    for(auto & loop_instance : loop_instances) {
        //        const auto & callstacks = loop_instance["callstacks"];
        //        for(const auto & callstack : callstacks) {
        //            //std::cout << callstack << '\n';
        //            auto find = aggregated_callstacks.find(callstack);
        //            if(find != aggregated_callstacks.end()) {
        //                (*find).second[loop_idx].push_back(&loop_instance["instance"]);
        //            } else {
        //                aggregated_callstacks[callstack][loop_idx] =
        //                    std::vector<const json_t*>{1, &loop_instance["instance"]};
        //            }
        //        }
        //    }
        //}

        std::map<json_t, std::tuple<json_t, std::vector<uint32_t>> > aggregated_callstacks;
        json_t new_loops;
        for(auto & callstack : loops) {//aggregated_callstacks) {
            replace(input, callstack["instance"]);
            json_t & callstack_data = callstack["callstacks"];

            json_t converted_callstacks;
            for(auto value : callstack_data) {
                json_t new_callstack;
                //new_callstack.push_back(json_t::array());
                for(auto v : value) {

                    //size_t size = new_callstack.size();
                    //if(!important_indices.count(v.get<int>())) {
                    //  new_callstack.resize(size*2);
                    //  std::copy_n(std::begin(new_callstack), size, std::begin(new_callstack) + size);
                    //}
                    //for(int i = 0; i < size; ++i)
                    //  new_callstack[i].push_back(v);

                    // push update_u -> update_h :( old hack around ScoreP filtering
                    if(important_indices.count(v.get<int>())
                        #if ENABLE_FIX_ICS_2019_RESULTS
                          //update_h
                          || v.get<int>() == 418
                          || v.get<int>() == 420
                          //setup_output_gauge_file
                          || v.get<int>() == 352
                          || v.get<int>() == 354
                          //cleanup_gathers 
                          || v.get<int>() == 345
                          || v.get<int>() == 347
                        #endif
                        || input["functions_names"][v.get<int>()] == "main")
                      new_callstack.push_back(v);
                }
                bool found = false;
                for(json_t & prev_callstack : converted_callstacks)
                  if(prev_callstack == new_callstack)
                    found = true;
                if(!found)
                  converted_callstacks.push_back(new_callstack);
            }
            callstack_data = std::move(converted_callstacks);

            json_t converted = convert_loop_set(callstack["instance"]);
            if(converted.empty())
                continue;
            std::vector<uint32_t> loop_data = parse(converted, params);
            auto it = aggregated_callstacks.find(callstack_data);
            if(it != aggregated_callstacks.end()) {
                std::get<0>((*it).second)["data"].push_back(std::move(converted));
                for(uint32_t v : loop_data)
                    std::get<1>((*it).second).push_back(v);
            } else {
                json_t instance;
                instance["callstack"] = callstack_data;
                instance["data"].push_back(std::move(converted));
                aggregated_callstacks[callstack_data] =
                    std::make_tuple(std::move(instance), std::move(loop_data));
            }
             //callstack.first;
            //std::cout << "Start data: " << callstack.second << '\n';
            //get_deps(instance, instance["data"], output["parameters"]);
            //new_loops.push_back(std::move(instance));
        }

        json_t function;
        for(auto & v : aggregated_callstacks) {
            std::set<uint32_t> dependencies;
            json_t & deps = std::get<0>(v.second)["deps"];
            json_t & not_found_params = std::get<0>(v.second)["not_found_params"];
            uint32_t aggregation = 0;
            for(uint32_t v : std::get<1>(v.second))
            {
                aggregation |= v;
                dependencies.insert(v);
            }
            for(int i = 0; i < params.size(); ++i)
                if(!(aggregation & (1 << i)))
                   not_found_params.push_back(params[i]);
            for(auto v : dependencies)
            {
                json_t dependency;
                for(int i = 0; i < params.size(); ++i)
                    if(v & (1 << i))
                        dependency.push_back(params[i]);
                deps.push_back( std::move(dependency) );
            }
            new_loops.push_back( std::move(std::get<0>(v.second)) );
        }
        // TODO: nested array, shouldn't be here
        // right now we have have a list of loops and for each one list of instances
        // this should be a list of instances where each one is additive instance
        //std::cout << "Op: " << ops << '\n';
        //for(const auto & op_array : ops)
        //{
        //    std::cout << "Op: " << op_array << '\n';
        //    for(const auto & op : op_array)
        //    {
        //        std::vector<uint32_t> results = parse(op, params);
        //        for(uint32_t v : results)
        //        {
        //            aggregation |= v;
        //            dependencies.insert(v);
        //        }
        //    }
        //}

        function["loops"] = std::move(new_loops);
        for(const auto & key : to_copy_local) {
            function[key] = std::move(it.value()[key]);
        }
        functions_output[it.key()] = std::move(function);
    }
    std::vector<std::string> to_copy{
        "functions_demangled_names",
        "functions_mangled_names",
        "functions_names",
        "parameters",
        "unused_parameters"
    };
    for(const auto & key : to_copy) {
        if(!input[key].empty())
            output[key] = std::move(input[key]);
    }
    of << "INCLUDE *\\ main(*\n";
    of << "SCOREP_REGION_NAMES_END\n";
    of.close();

    return output;
}


int main(int argc, char ** argv)
{
    json_t input;
    assert(argc >= 2);
    std::ifstream in(argv[1], std::ios_base::in);
    in >> input;
    in.close();
    bool generate_full_data = false;
    if(argc > 3)
      generate_full_data = atoi(argv[3]);

    json_t converted = convert(input, generate_full_data);
    if(argc > 2) {
      std::ofstream out(argv[2]);
      out << converted.dump(2);
    } else
      std::cout << converted.dump(2);
    return 0;
}
