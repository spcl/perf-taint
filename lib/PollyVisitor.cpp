
#include "PollyVisitor.hpp"
#include "DependencyFinder.hpp"
#include "util/util.hpp"

#include <llvm/Support/raw_ostream.h>

#include <polly/PolySCEV.h>
#include <isl/printer.h>

namespace extrap {

    bool PollyVisitor::call(isl::set set)
    {
        bool understood = true;
        for(size_t j = 0; j < set.dim( isl::dim::param ); ++j) {
            isl::id id = set.get_dim_id( isl::dim::param, j);
            if(llvm::Value * val = SCEV.findValue(id))
                understood &= dep.find(val);
            else {
                isl_printer * isl_print = isl_printer_to_str( set.get_ctx().get() );
                isl_printer_print_set(isl_print, set.get());
                char * ptr = isl_printer_get_str(isl_print);
                std::string set_str(ptr);
                free(ptr);
                isl_printer_free(isl_print);
                throw std::runtime_error(
                        cppsprintf("ID %s in set %s not matched to LLVM::Value!", id.get_name(), set_str)
                        );
            }
        }
        return understood;
    }
 
    bool PollyVisitor::is_computable(isl::set domain)
    {
        return isl_set_is_bounded(domain.get())
            && !isl_set_is_empty(domain.get()); 
    }

}
