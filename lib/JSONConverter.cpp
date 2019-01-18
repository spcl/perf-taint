#include <iostream>
#include <string>
#include <fstream>
#include <nlohmann/json.hpp>

typedef nlohmann::json json_t;

json_t convert(json_t & input)
{
    json_t output;
    std::vector<std::string> to_copy{
        "functions_demangled_names",
        "functions_mangled_names",
        "functions_names",
        "parameters"
    };
    for(const auto & key : to_copy) {
        output[key] = std::move(input[key]);
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
