#include "JSONExporter.hpp"
#include "FunctionAnalysis.hpp"

#include <llvm/IR/DebugInfoMetadata.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/Module.h>

#include <tuple>

namespace extrap {

    JSONExporter::JSONExporter(llvm::Module & m)
    {
        // extract file information
        auto it = m.debug_compile_units_begin(), end = m.debug_compile_units_end();
        std::vector< nlohmann::json > units;
        units.reserve( std::distance(it, end) );
        for(;it != end; ++it) {
            llvm::DICompileUnit * unit = *it;
            nlohmann::json debug_info;
            debug_info["directory"] = unit->getDirectory();
            debug_info["file_name"] = unit->getFilename();
            units.push_back( std::move(debug_info) );
        }
        out["debug"] = units;
    }


    nlohmann::json JSONExporter::export_callsite(CallSite & site)
    {
        nlohmann::json callsite;
        llvm::DISubprogram * subprogram = llvm::dyn_cast<llvm::DISubprogram>(site.dbg_loc->getScope());
        assert(subprogram);
        callsite["file"] = subprogram->getFile()->getFilename();
        callsite["line"] = site.dbg_loc->getLine();
        for(auto & param : site.parameters) {
            Parameters::vec_t & vec = std::get<1>(param);
            llvm::SmallVector<std::string, 5> sv(vec.size());
            // id -> param_name
            std::transform(vec.begin(), vec.end(), sv.begin(),
                    [](Parameters::id_t id) {
                        return Parameters::get_param(id);
                    });
            callsite["operands"].push_back( std::make_pair(std::get<0>(param), sv) );
        }
        return callsite;
    }

    nlohmann::json JSONExporter::export_function(llvm::Function & f)
    {
        nlohmann::json function;
        llvm::DISubprogram * debug = f.getSubprogram();
        assert(debug);
        function["name"] = debug->getName();
        function["line"] = debug->getLine();
        return function;
    }
    
    nlohmann::json JSONExporter::export_function(llvm::Function & f, AnalyzedFunction & func)
    {
        nlohmann::json function = export_function(f);
        auto callsite_begin = func.callsites.begin(), callsite_end = func.callsites.end(); 
        while(callsite_begin != callsite_end) {
            nlohmann::json callsite = export_callsite(*callsite_begin);
            //group callsites by function
            std::string function_name = llvm::dyn_cast<llvm::DISubprogram>((*callsite_begin).dbg_loc->getScope())->getName();
            function["callsites"][function_name].push_back(callsite);
            ++callsite_begin;
        }

        if(func.globals)
            for(auto id : func.globals.getValue())
                function["globals"].push_back(Parameters::get_param(id));

        out["functions"].push_back(function);
    }

}
