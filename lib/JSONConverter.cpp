#include <iostream>
#include <string>
#include <fstream>
#include <nlohmann/json.hpp>

typedef nlohmann::json json_t;

// loop_idx -> loop
typedef std::map<std::string, std::vector<const json_t*>> set_t;

json_t convert_loop_set(set_t & loop_set)
{
    json_t output;
    return output;
}

json_t convert(json_t & input)
{
    json_t output;
    std::vector<std::string> to_copy{
        "functions_demangled_names",
        "functions_mangled_names",
        "functions_names",
        "parameters"
    };
    std::vector<std::string> to_copy_local{
        "file",
        "line",
        "dbg_name"
    };
    for(const auto & key : to_copy) {
        output[key] = std::move(input[key]);
    }

    json_t & functions = input["functions"];
    json_t & functions_output = output["functions"];
    for(auto it = functions.begin(), end = functions.end(); it != end; ++it) {

        const json_t & loops = it.value()["loops"];
        // callstack -> list of loops
        std::map<json_t, set_t> aggregated_callstacks;
        for(auto it = loops.begin(), end = loops.end(); it != end; ++it) {
            std::string loop_idx = it.key();
            const auto & loop_instances = it.value();
            for(auto & loop_instance : loop_instances) {
                const auto & callstacks = loop_instance["callstacks"];
                for(const auto & callstack : callstacks) {
                    //std::cout << callstack << '\n';
                    auto find = aggregated_callstacks.find(callstack);
                    if(find != aggregated_callstacks.end()) {
                        (*find).second[loop_idx].push_back(&loop_instance["instance"]);
                    } else {
                        aggregated_callstacks[callstack][loop_idx] =
                            std::vector<const json_t*>{1, &loop_instance["instance"]};
                    }
                }
            }
        }

        json_t new_loops;
        for(auto & callstack : aggregated_callstacks) {
            json_t instance;
            instance["callstack"] = callstack.first;
            instance["data"] = convert_loop_set(callstack.second);
            new_loops.push_back(std::move(instance));
        }

        json_t function;
        function["loops"] = std::move(new_loops);
        for(const auto & key : to_copy_local) {
            function[key] = std::move(it.value()[key]);
        }
        functions_output[it.key()] = std::move(function);
    }

    return output;
}


int main(int argc, char ** argv)
{
    json_t input;
    assert(argc == 2);
    std::ifstream in(argv[1], std::ios_base::in);
    in >> input;
    in.close();

    json_t converted = convert(input);
    std::cout << converted.dump(2);
    return 0;
}
