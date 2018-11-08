#include "JSONExporter.hpp"
#include "FunctionAnalysis.hpp"

#include <llvm/IR/DebugInfoMetadata.h>
#include <llvm/IR/Function.h>
#include <llvm/IR/Module.h>

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
            for(auto id : std::get<1>(param))
                callsite["operands"].push_back( std::make_pair(std::get<0>(param), Parameters::get_param(id)));
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

}
