#ifndef __JSONEXPORTER_HPP__
#define __JSONEXPORTER_HPP__

#include <llvm/IR/DebugInfoMetadata.h>

#include <nlohmann/json.hpp>

namespace llvm {
    class Function;
    class Module;
}

namespace extrap {

    class CallSite;
    class AnalyzedFunction;
    class Parameters;

#if defined(EXTRAP_JSON_WITH_INSERT_ORDER)
    // Workaround to enforce a constant ordering in the output
    // See issue 485 on library GH
    // Disable this in case of any compatibility or compilation issues
    template<typename Key, typename Value, typename Compare, typename A>
    using my_fifo_map = nlohmann::fifo_map<Key, Value, nlohmann::fifo_map_compare<Key>, A>;
    typedef nlohmann::basic_json<my_fifo_map> json_t;
#else
    typedef nlohmann::json json_t;
#endif

    struct JSONExporter
    {
        json_t out;

        JSONExporter(llvm::Module &);
        
        json_t export_callsite(CallSite &);
        void export_function(llvm::Function & f, AnalyzedFunction &); 
        void export_parameters(const Parameters & params);
        void export_statistics_found(int, int);
        void export_statistics_total(int, int);
 
        json_t & json();

        template<typename OS>
        void print(OS & os) const
        {
            os << out.dump(2) << '\n';
        }
    private:
        json_t export_function(llvm::Function & f); 
    };

}


#endif
