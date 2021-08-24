

#ifndef __PERF_TAINT_PASS_HPP__
#define __PERF_TAINT_PASS_HPP__

#include <perf-taint/llvm-pass/ParameterFinder.hpp>
#include <perf-taint/llvm-pass/DebugInfo.hpp>
#include <perf-taint/llvm-pass/FunctionDatabase.hpp>
#include <perf-taint/llvm-pass/common.hpp>
#include <perf-taint/llvm-pass/Statistics.hpp>

#include <llvm/ADT/Optional.h>
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/InstVisitor.h>
#include <llvm/Pass.h>

#include <fstream>
#include <unordered_set>
#include <unordered_map>


namespace llvm {
    class Function;
    class CallGraph;
    class CallGraphNode;
    class LoopInfo;
    class Loop;
    class ScalarEvolution;
}

namespace perf_taint {

  struct Function;
  struct ImplicitCall;

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
        llvm::DataLayout * layout;
        //std::unordered_map<Parameters::id_t, llvm::GlobalVariable> allocated;
        size_t functions_count;
        size_t params_count;

        // __dfsan_retval_tls - thread local global storing return value
        // we need to call check_label on return value from function
        llvm::GlobalVariable * glob_retval_tls;

        // `parameters` dfsan labels, dynamically assigned at runtime
        llvm::GlobalVariable * glob_labels;
        llvm::GlobalVariable * glob_files;
        llvm::GlobalVariable * glob_output_filename;

        llvm::GlobalVariable * glob_instr_funcs_count;
        llvm::GlobalVariable * glob_funcs_count;
        llvm::GlobalVariable * glob_implicit_funcs_count;
        // `functions` C strings, assigned at compile time 
        llvm::GlobalVariable * glob_funcs_names;
        // `functions` C strings, assigned at compile time
        llvm::GlobalVariable * glob_funcs_mangled_names;
        // `functions` C strings, assigned at compile time
        llvm::GlobalVariable * glob_funcs_demangled_names;
        // `functions` ints, storing # of args
        llvm::GlobalVariable * glob_funcs_args;
        // 2*`functions` integers, line of code and file index, compile time
        llvm::GlobalVariable * glob_funcs_dbg;
        llvm::GlobalVariable * glob_implicit_params_count;
        llvm::GlobalVariable * glob_params_max_count;
        // `params` C strings, assigned at compile time 
        llvm::GlobalVariable * glob_params_names;
        llvm::GlobalVariable * glob_params_used;
        llvm::GlobalVariable * glob_params_redirect;

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

        // branches
        llvm::GlobalVariable * glob_branches_offsets;
        llvm::GlobalVariable * glob_branches_counts;
        llvm::GlobalVariable * glob_branches_data;
        static constexpr const char * glob_branches_offsets_name
            = "__perf_taint_loop_branches_offsets";
        static constexpr const char * glob_branches_counts_name
            = "__perf_taint_loop_branches_counts";
        static constexpr const char * glob_branches_data_name
            = "__perf_taint_loop_branches_data";
        static constexpr const char * glob_branches_enabled_name
            = "__perf_taint_loop_branches_enabled";

        static constexpr const char * glob_retval_tls_name
            = "__dfsan_retval_tls";
        static constexpr const char * glob_labels_name
            = "__EXTRAP_INSTRUMENTATION_LABELS";
        static constexpr const char * glob_files_name
            = "__EXTRAP_INSTRUMENTATION_FILES";
        static constexpr const char * glob_output_filename_name
            = "__EXTRAP_INSTRUMENTATION_OUTPUT_FILENAME";
        static constexpr const char * glob_funcs_count_name
            = "__EXTRAP_FUNCS_COUNT";
        static constexpr const char * glob_implicit_funcs_count_name
            = "__EXTRAP_INSTRUMENTATION_IMPLICIT_FUNCS_COUNT";
        static constexpr const char * glob_instr_funcs_count_name
            = "__EXTRAP_INSTRUMENTATION_FUNCS_COUNT";
        static constexpr const char * glob_implicit_params_count_name
            = "__EXTRAP_INSTRUMENTATION_IMPLICIT_PARAMS_COUNT";
        static constexpr const char * glob_params_max_count_name
            = "__EXTRAP_INSTRUMENTATION_IMPLICIT_PARAMS_MAX_COUNT";
        static constexpr const char * glob_result_array_name
            = "__EXTRAP_INSTRUMENTATION_RESULTS";
        static constexpr const char * glob_funcs_args_name
            = "__EXTRAP_INSTRUMENTATION_FUNCS_ARGS";
        static constexpr const char * glob_funcs_names_name
            = "__EXTRAP_INSTRUMENTATION_FUNCS_NAMES";
        static constexpr const char * glob_funcs_mangled_names_name
            = "__EXTRAP_INSTRUMENTATION_FUNCS_MANGLED_NAMES";
        static constexpr const char * glob_funcs_demangled_names_name
            = "__EXTRAP_INSTRUMENTATION_FUNCS_DEMANGLED_NAMES";
        static constexpr const char * glob_funcs_dbg_name
            = "__EXTRAP_INSTRUMENTATION_FUNCS_DBG";
        static constexpr const char * glob_callsites_result_name
            = "__EXTRAP_INSTRUMENTATION_CALLSITES_RESULTS";
        static constexpr const char * glob_callsites_offsets_name
            = "__EXTRAP_INSTRUMENTATION_CALLSITES_OFFSETS";
        static constexpr const char * glob_params_names_name
            = "__EXTRAP_INSTRUMENTATION_PARAMS_NAMES";
        static constexpr const char * glob_params_used_name
            = "__EXTRAP_INSTRUMENTATION_PARAMS_USED";
        static constexpr const char * glob_params_redirect_name
            = "__EXTRAP_INSTRUMENTATION_PARAMS_REDIRECT";
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

        // i16 @dfsan_get_label(i64)
        llvm::Function * dfsan_get_label;

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
        // __EXTRAP_COMMIT_LOOP(loop_idx, function_idx, calls_count)
        llvm::Function * commit_loop_function;

        // __dfsw_EXTRAP_PUSH_CALL_FUNCTION(idx)
        llvm::Function * push_function;
        // __dfsw_EXTRAP_POP_CALL_FUNCTION(idx)
        llvm::Function * pop_function;

        // uint16_t __dfsw_EXTRAP_REGISTER_CALL(uint16_t, uint16_t);
        llvm::Function * register_call_function;
        // void __dfsw_EXTRAP_REMOVE_CALLS(size_t);
        llvm::Function * remove_calls_function;
        // void __dfsw_EXTRAP_SET_CURRENT_CALL(int16_t)
        llvm::Function * set_current_call_function;
        // int16_t __dfsw_EXTRAP_CURRENT_CALL()
        llvm::Function * get_current_call_function;

        // void __dfsw_EXTRAP_INIT_MPI
        llvm::Function * init_mpi_function;

        // void __dfsw_EXTRAP_MARK_IMPLICIT_LABEL(uint16_t, uint16_t, uint16_t)
        llvm::Function * mark_implicit_label;
        llvm::Function * call_implicit_function;

        // void __dfsw_EXTRAP_WRITE_PARAMETER(int8_t *, size_t, int32_t)
        llvm::Function * write_parameter_function;

        // void __dfsw_perf_taint_branch(int16, int32, int32, int32)
        llvm::Function * taint_branch_function;

        Instrumenter(llvm::Module & _m):
            m(_m),
            builder(m.getContext()),
            layout(new llvm::DataLayout(&m)),
            functions_count(0),
            params_count(0),
            glob_retval_tls(nullptr),
            glob_labels(nullptr),
            glob_files(nullptr),
            glob_funcs_count(nullptr),
            glob_funcs_names(nullptr),
            glob_funcs_args(nullptr),
            glob_funcs_dbg(nullptr),
            glob_implicit_params_count(nullptr),
            glob_params_names(nullptr),
            glob_result_array(nullptr)
        {
            file_index.import(m, info);
            declareFunctions();
        }

        ~Instrumenter()
        {
            delete layout;
        }

        // insert a call atexit(__EXTRAP__AT_EXIT)
        void initialize(llvm::Function * main);
        void initialize_MPI(llvm::Function * main);
        void declareFunctions();
        template<typename Vector, typename FuncIter, typename FuncIter2, typename FuncIter3>
        void createGlobalStorage(const Vector & func_names,
                const FunctionDatabase & database,
                FuncIter begin, FuncIter end,
                FuncIter3 implicit_begin, FuncIter3 implicit_end,
                FuncIter2 not_instr_begin, FuncIter2 not_instr_end);
        void commitLoop(llvm::Loop &, int function_idx, int loop_idx);
        void commitLoops(llvm::Function &, int function_idx, int calls_count);

        void checkCF(int function_idx, llvm::BranchInst * br);
        void checkCFLoad(int function_idx, size_t size, llvm::Value * load_addr);
        void checkCFRetval(int function_idx, llvm::CallBase * cast);

        void checkLoop(int loop_idx, int function_idx,
                llvm::Instruction * inst);
        void checkLoopLoad(int loop_idx, int function_idx,
                size_t size, llvm::Value * load_addr);
        void checkLoopRetval(int loop_idx, int function_idx,
                llvm::CallBase * cast);
        llvm::Value* getLabel(llvm::Value*);

        void annotateParams(const std::vector< std::tuple<const llvm::Value *, Parameters::id_t> > & params);
        void setLabel(Parameters::id_t param, const llvm::Value * val);
        void callSetLabel(int param_idx, const char * param_name,
                size_t size, llvm::Value * operand);
        void setInsertPoint(llvm::Instruction & inst);
        llvm::Instruction * createGlobalStringPtr(const char * name, llvm::Instruction * placement);
        void enterFunction(llvm::Function &, Function &);
        void enterFunction(llvm::Function &, size_t idx);

        llvm::Instruction* instrumentLoopCall(llvm::Function &, llvm::CallBase * call,
                int16_t nested_loop_idx, uint16_t loop_size, llvm::Instruction*);
        void removeLoopCalls(llvm::Function & f, size_t size);
        void saveCurrentCall(llvm::Function & f);

        void callImplicitLoop(ImplicitCall &, int func_idx, int called_func_idx,
                int loop_idx, int nested_loop_idx);
        void callImplicitFunction(int func_idx);
        void writeParameter(llvm::Instruction * instr, llvm::Value * dest, int parameter_idx);
        void findTerminator(llvm::Function & f, llvm::SmallVector<llvm::ReturnInst*, 5> & returns);
        llvm::Function * getAtExit();
        uint64_t size_of(llvm::Value * val);

      void instrumentLoopBranch(llvm::Instruction * branch, int32_t function_idx,
          int32_t nested_loop_idx, int32_t branch_idx);
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
            instr(_instr),
            avoid_duplicates(_avoid_duplicates),
            load_function(_load),
            label_function(_label)
            {}
        void visitLoadInst(llvm::LoadInst &);
        void visitInstruction(llvm::Instruction &);
        void visitPHINode(llvm::PHINode &);
        void visitCallInst(llvm::CallInst &);
        void visitInvokeInst(llvm::InvokeInst &);

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
        FunctionDatabase database;
        std::unique_ptr<llvm::Module> analyzed_module;


        // Insert null value when function is not importan
        // Important function:
        // a) has non-const loops
        // b) has call to OpenMP fork-call
        // c) has MPI call?
        //
        std::unordered_map<llvm::Function *, llvm::Optional<Function>> instrumented_functions;
        std::vector<llvm::Function *> notinstrumented_functions;
        std::unordered_map<std::string, int> implicit_functions;
        //std::vector<int> loops_depths;
        //std::vector<int> loops_counts;
        std::vector<llvm::Function *> parent_functions;
        int instrumented_functions_counter;
        std::ofstream unknown;
        Statistics stats;
        // TODO: something smarter here
        // first traversal of functions cannot 
        std::vector< std::tuple<const llvm::Value*, Parameters::id_t>> found_params;

        std::unordered_map<llvm::Function*, bool> calls_important;

        std::set<llvm::Function*> recursive_functions;

        void analyzeLoopBranches(Function & f, llvm::Loop & l, int & nested_loop_idx);

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

        typedef std::tuple<llvm::CallBase *, int16_t, uint16_t> call_t;
        typedef llvm::SmallVector<call_t, 5> call_vec_t;
        void instrumentLoop(Function & func, llvm::Loop & l,
                int nested_loop_idx,
                call_vec_t & calls, Instrumenter &);
        bool callsImportantFunction(llvm::CallBase * call);
        bool callsImportantFunction(llvm::Function *, std::set<llvm::Function*> & recursive_calls);
        bool analyzeFunction(llvm::Function & f, llvm::CallGraphNode * cg_node,
                int override_counter = -1);
        bool runOnModule(llvm::Module & f) override;
        bool is_analyzable(llvm::Module & m, llvm::Function & f);
        bool handleOpenMP(llvm::Function &f, int override_counter = -1);
        void foundFunction(llvm::Function &f, bool important, int counter = -1);
        void insertCallsite(llvm::Function & f, llvm::Value * val);
        int analyzeLoop(Function & f, llvm::Loop & l,
                std::vector<std::vector<int>> & data, int depth);
        std::tuple<int, int, int, bool> analyzeLoopSCEV(llvm::Loop *l, llvm::ScalarEvolution & scev);
        void removeDuplicates();
    };

}

#endif

