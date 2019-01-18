

#ifndef DFSAN_INSTR_PASS_HPP
#define DFSAN_INSTR_PASS_HPP

#include "ParameterFinder.hpp"
#include "DebugInfo.hpp"

#include <llvm/ADT/Optional.h>
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/InstVisitor.h>
#include <llvm/Pass.h>

#include <fstream>
#include <unordered_set>
#include <unordered_map>

#include <nlohmann/json.hpp>

class DebugInfo;

namespace llvm {
    class Function;
    class CallGraph;
    class LoopInfo;
    class Loop;
}

namespace extrap {

    struct Statistics
    {
        int functions_count;
        int empty_functions;
        int functions_checked;
        int calls_to_check;

        Statistics():
            functions_count(0),
            empty_functions(0),
            functions_checked(0),
            calls_to_check(0)
        {}

        void found_function();
        void empty_function();
        void label_function(int labels);
        void print();
    };

    struct Function
    {
        int idx;
        bool overriden;
        llvm::SmallVector<llvm::Value*, 10> callsites;
        // # of entries = loop_depths.size()
        std::vector<int> loops_structures;
        std::vector<int> loops_sizes;

        Function(int _idx, bool _overriden = false):
            idx(_idx),
            overriden(_overriden)
        {}

        int function_idx()
        {
            return idx;
        }

        void add_callsite(llvm::Value* val)
        {
            callsites.push_back(val);
        }

        size_t callsites_size()
        {
            return callsites.size();
        }

        bool is_overriden()
        {
            return overriden;
        }
    };

    struct FileIndex
    {
        typedef std::map<llvm::StringRef,std::tuple<int, llvm::StringRef>> idx_t;
        typedef typename idx_t::iterator iterator;
        // file_name -> (idx, dir)
        idx_t index;

        void import(llvm::Module &, DebugInfo &);
        int getIdx(llvm::StringRef &);
        iterator begin();
        iterator end();
    };

    struct Instrumenter
    {
        llvm::Module & m;
        llvm::IRBuilder<> builder;
        DebugInfo info;
        FileIndex file_index;
        //std::unordered_map<Parameters::id_t, llvm::GlobalVariable> allocated;
        size_t functions_count;
        size_t params_count;

        // __dfsan_retval_tls - thread local global storing return value
        // we need to call check_label on return value from function
        llvm::GlobalVariable * glob_retval_tls;

        // `parameters` dfsan labels, dynamically assigned at runtime
        llvm::GlobalVariable * glob_labels;
        llvm::GlobalVariable * glob_files;

        llvm::GlobalVariable * glob_funcs_count;
        // `functions` C strings, assigned at compile time 
        llvm::GlobalVariable * glob_funcs_names;
        // `functions` C strings, assigned at compile time
        llvm::GlobalVariable * glob_funcs_mangled_names;
        // `functions` ints, storing # of args
        llvm::GlobalVariable * glob_funcs_args;
        // 2*`functions` integers, line of code and file index, compile time
        llvm::GlobalVariable * glob_funcs_dbg;
        llvm::GlobalVariable * glob_params_count;
        // `params` C strings, assigned at compile time 
        llvm::GlobalVariable * glob_params_names;

        // Callsites
        // int8* of size operand_count * callsite_count
        // computed for each function
        //llvm::GlobalVariable * glob_callsites_result;
        // int32* of size `functions
        // stores offsets to the array above
        // necessary because each function has different signature
        // and different number of callsites
        //llvm::GlobalVariable * glob_callsites_offsets;

        // `functions` * `parameters` integers, storing control-flow dependency
        // of a function on each parameter
        llvm::GlobalVariable * glob_result_array;

        // size determined by program properties
        //llvm::GlobalVariable * glob_loops_depths;
        // `func_count + 1` integers providing direct access to deps results
        //llvm::GlobalValue * glob_deps_offsets;
        // `func_count + 1` integers providing direct access to depths array
        //llvm::GlobalValue * glob_depths_array_offsets;
        //
        llvm::GlobalVariable * glob_loops_structures;
        llvm::GlobalVariable * glob_loops_structures_offsets;
        llvm::GlobalVariable * glob_loops_sizes;
        llvm::GlobalVariable * glob_loops_sizes_offsets;
        llvm::GlobalVariable * glob_loops_number;

        static constexpr const char * glob_retval_tls_name
            = "__dfsan_retval_tls";
        static constexpr const char * glob_labels_name
            = "__EXTRAP_INSTRUMENTATION_LABELS";
        static constexpr const char * glob_files_name
            = "__EXTRAP_INSTRUMENTATION_FILES";
        static constexpr const char * glob_funcs_count_name
            = "__EXTRAP_INSTRUMENTATION_FUNCS_COUNT";
        static constexpr const char * glob_params_count_name
            = "__EXTRAP_INSTRUMENTATION_PARAMS_COUNT";
        static constexpr const char * glob_result_array_name
            = "__EXTRAP_INSTRUMENTATION_RESULTS";
        static constexpr const char * glob_funcs_args_name
            = "__EXTRAP_INSTRUMENTATION_FUNCS_ARGS";
        static constexpr const char * glob_funcs_names_name
            = "__EXTRAP_INSTRUMENTATION_FUNCS_NAMES";
        static constexpr const char * glob_funcs_mangled_names_name
            = "__EXTRAP_INSTRUMENTATION_FUNCS_MANGLED_NAMES";
        static constexpr const char * glob_funcs_dbg_name
            = "__EXTRAP_INSTRUMENTATION_FUNCS_DBG";
        static constexpr const char * glob_callsites_result_name
            = "__EXTRAP_INSTRUMENTATION_CALLSITES_RESULTS";
        static constexpr const char * glob_callsites_offsets_name
            = "__EXTRAP_INSTRUMENTATION_CALLSITES_OFFSETS";
        static constexpr const char * glob_params_names_name
            = "__EXTRAP_INSTRUMENTATION_PARAMS_NAMES";
        static constexpr const char * glob_loops_depths_name
            = "__EXTRAP_LOOPS_DEPTHS_PER_FUNC";
        static constexpr const char * glob_deps_offsets_name
            = "__EXTRAP_LOOPS_DEPS_OFFSETS";
        static constexpr const char * glob_depths_array_offsets_name
            = "__EXTRAP_LOOPS_DEPTHS_FUNC_OFFSETS";
        static constexpr const char * glob_loops_structures_name
            = "__EXTRAP_LOOPS_STRUCTURE_PER_FUNC";
        static constexpr const char * glob_loops_sizes_name
            = "__EXTRAP_LOOPS_SIZES_PER_FUNC";
        static constexpr const char * glob_loops_structures_offsets_name
            = "__EXTRAP_LOOPS_STRUCTURE_PER_FUNC_OFFSETS";
        static constexpr const char * glob_loops_sizes_offsets_name
            = "__EXTRAP_LOOPS_SIZES_PER_FUNC_OFFSETS";
        static constexpr const char * glob_loops_number_name
            = "__EXTRAP_NUMBER_OF_LOOPS";

        // __EXTRAP_CHECK_LOAD(int * addr, size_t size, function_idx)
        llvm::Function * load_function;
        // __EXTRAP_CHECK_LABEL(uint16_t label, function_idx)
        llvm::Function * label_function;
        // __EXTRAP_STORE_LABEL(int * addr, param_idx)
        llvm::Function * store_function;
        // __EXTRAP_CHECK_CALLSITE(int * addr, size, func_idx, arg_idx, site_idx)
        llvm::Function * callsite_function;
        // __EXTRAP_AT_EXIT()
        llvm::Function * at_exit_function;
        // __EXTRAP_INIT()
        llvm::Function * init_function;

        // __EXTRAP_CHECK_LABEL(label, depth, loop_idx, func_idx)
        llvm::Function * label_loop_function;
        // __EXTRAP_CHECK_LOAD(addr, size, depth, loop_idx, func_idx)
        llvm::Function * load_loop_function;
        // __EXTRAP_COMMIT_LOOP(loop_idx, depth, function_idx)
        llvm::Function * commit_loop_function;

        // __dfsw_EXTRAP_PUSH_CALL_FUNCTION(idx)
        llvm::Function * push_function;
        // __dfsw_EXTRAP_POP_CALL_FUNCTION(idx)
        llvm::Function * pop_function;

        Instrumenter(llvm::Module & _m):
            m(_m),
            builder(m.getContext()),
            functions_count(0),
            params_count(0),
            glob_retval_tls(nullptr),
            glob_labels(nullptr),
            glob_files(nullptr),
            glob_funcs_count(nullptr),
            glob_funcs_names(nullptr),
            glob_funcs_args(nullptr),
            glob_funcs_dbg(nullptr),
            glob_params_count(nullptr),
            glob_params_names(nullptr),
            glob_result_array(nullptr)
        {
            file_index.import(m, info);
            declareFunctions();
        }

        // insert a call atexit(__EXTRAP__AT_EXIT)
        void initialize(llvm::Function * main);
        void declareFunctions();
        template<typename Vector, typename FuncIter>
        void createGlobalStorage(const Vector & func_names,
                FuncIter begin, FuncIter end);
        void commitLoop(llvm::Loop &, int function_idx, int loop_idx);

        void checkCF(int function_idx, llvm::BranchInst * br);
        void checkCFLoad(int function_idx, size_t size, llvm::Value * load_addr);
        void checkCFRetval(int function_idx, llvm::CallBase * cast);

        void checkLoop(int loop_idx, int function_idx,
                const llvm::BranchInst * br);
        void checkLoopLoad(int loop_idx, int function_idx,
                size_t size, llvm::Value * load_addr);
        void checkLoopRetval(int loop_idx, int function_idx,
                llvm::CallBase * cast);

        void checkCallSite(int function_idx, int callsite_idx, llvm::CallBase *);
        void checkCallSiteLoad(int function_idx, int callsite_idx, int arg_idx,
                uint64_t size, llvm::Value * ptr);
        void checkCallSiteRetval(int function_idx, int callsite_idx,
                int arg_idx, llvm::CallBase *);

        void annotateParams(const std::vector< std::tuple<const llvm::Value *, Parameters::id_t> > & params);
        void setLabel(Parameters::id_t param, const llvm::Value * val);
        void callSetLabel(int param_idx, const char * param_name,
                size_t size, llvm::Value * operand);
        void setInsertPoint(llvm::Instruction & inst);
        llvm::Instruction * createGlobalStringPtr(const char * name, llvm::Instruction * placement);
        void enterFunction(llvm::Function &, Function &);

        llvm::Function * getAtExit();
    };

    struct LabelAnnotator : public llvm::InstVisitor<LabelAnnotator, bool>
    {
        static std::set<Parameters::id_t> annotated_params;
        Instrumenter & instr;
        int param_idx;
        LabelAnnotator(Instrumenter & _instr, int idx):
            instr(_instr),
            param_idx(idx)
            {}
        //struct load
        bool visitLoadInst(llvm::LoadInst &);
        bool visitAllocaInst(llvm::AllocaInst &);
        bool visitInstruction(llvm::Instruction &);
        bool visitBitCastInst(llvm::BitCastInst &);
        // struct load
        bool visitGetElementPtrInst(llvm::GetElementPtrInst &);
        static bool visited(Parameters::id_t);
    };

    struct InstrumenterVisiter : public llvm::InstVisitor<InstrumenterVisiter, void>
    {
        llvm::DataLayout * layout;
        Instrumenter & instr;
        bool avoid_duplicates;
        // avoid duplicates
        llvm::SmallSet<llvm::LoadInst*, 10> processed_loads;
        std::unordered_set<llvm::PHINode*> phis;
        llvm::SmallSet<llvm::CallBase*, 10> processed_calls;
        //TODO: std::function overhead?
        std::function<void(uint64_t, llvm::Value*)> load_function;
        std::function<void(llvm::CallBase *)> label_function;

        template<typename F, typename U>
        InstrumenterVisiter(Instrumenter & _instr, F && _load, U && _label,
                bool _avoid_duplicates = true):
            layout(new llvm::DataLayout(&_instr.m)),
            instr(_instr),
            load_function(_load),
            label_function(_label),
            avoid_duplicates(_avoid_duplicates)
            {}
        ~InstrumenterVisiter()
        {
            delete layout;
        }
        void visitLoadInst(llvm::LoadInst &);
        void visitInstruction(llvm::Instruction &);
        void visitPHINode(llvm::PHINode &);
        void visitCallInst(llvm::CallInst &);
        void visitInvokeInst(llvm::InvokeInst &);

        uint64_t size_of(llvm::Value * val);
        void processCall(llvm::CallBase * call);
    };

    struct DfsanInstr : public llvm::ModulePass
    {
        static char ID;
        std::fstream log;
        llvm::Module * m;
        llvm::CallGraph * cgraph;
        llvm::LoopInfo * linfo;
        FunctionParameters parameters;


        // Insert null value when function is not importan
        // Important function:
        // a) has non-const loops
        // b) has call to OpenMP fork-call
        // c) has MPI call?
        //
        std::unordered_map<llvm::Function *, llvm::Optional<Function>> instrumented_functions;
        //std::vector<int> loops_depths;
        //std::vector<int> loops_counts;
        std::vector<llvm::Function *> parent_functions;
        int instrumented_functions_counter;
        std::ofstream unknown;
        Statistics stats;
        // TODO: something smarter here
        // first traversal of functions cannot 
        std::vector< std::tuple<const llvm::Value*, Parameters::id_t>> found_params;

        //Statistics stats;
        DfsanInstr():
            ModulePass(ID),
            m(nullptr),
            cgraph(nullptr),
            linfo(nullptr),
            instrumented_functions_counter(0),
            unknown(std::ofstream("unknown", std::ios::out))
        {
        }

        ~DfsanInstr()
        {
            unknown.close();
        }

        void getAnalysisUsage(llvm::AnalysisUsage & AU) const override;
        bool runOnFunction(llvm::Function & f, int override_counter = -1);
        void modifyFunction(llvm::Function & f, Function & func, Instrumenter &);
        void instrumentLoop(Function & func, llvm::Loop & l,
                int loop_idx, Instrumenter &);
        bool analyzeFunction(llvm::Function & f, int override_counter = -1);
        bool runOnModule(llvm::Module & f) override;
        bool is_analyzable(llvm::Module & m, llvm::Function & f);
        bool handleOpenMP(llvm::Function &f, int override_counter = -1);
        void foundFunction(llvm::Function &f, bool important, int counter = -1);
        void insertCallsite(llvm::Function & f, llvm::Value * val);
        int analyzeLoop(Function & f, llvm::Loop & l,
                std::vector<std::vector<int>> & data, int depth);
    };

}

#endif
