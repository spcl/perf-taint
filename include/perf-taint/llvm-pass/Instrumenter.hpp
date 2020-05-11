
#ifndef __PERF_TAINT_INSTRUMENTER_HPP__
#define __PERF_TAINT_INSTRUMENTER_HPP__

#include <perf-taint/llvm-pass/DebugInfo.hpp>
#include <perf-taint/llvm-pass/FileIndex.hpp>
#include <perf-taint/llvm-pass/FunctionDatabase.hpp>
#include <perf-taint/llvm-pass/Loop.hpp>

#include <llvm/ADT/SmallSet.h>
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/InstVisitor.h>

#include <functional>
#include <set>
#include <unordered_set>

namespace perf_taint {

  struct DfsanInstr;
  struct Instrumenter;

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

  struct Instrumenter
  {
    DfsanInstr & pass;
    llvm::Module & m;
    llvm::IRBuilder<> builder;
    DebugInfo info;
    FileIndex file_index;
    llvm::DataLayout * layout;
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

    std::string output_file_name;

    Instrumenter(DfsanInstr & _pass,
        llvm::Module & _m,
        std::string _output_file_name):
      pass(_pass),
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
      glob_result_array(nullptr),
      output_file_name(_output_file_name)
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
    //TODO: library dependent
    void initialize_MPI(llvm::Function * main);
    void declareFunctions();
    template<typename Vector, typename FuncIter, typename FuncIter2, typename FuncIter3>
    void createGlobalStorage(const Vector & funcs_names,
            const FunctionDatabase & database,
            FuncIter begin, FuncIter end,
            FuncIter3 implicit_begin, FuncIter3 implicit_end,
            FuncIter2 not_instr_begin, FuncIter2 not_instr_end)
    {
      functions_count = funcs_names.size();
      int implicit_functions_count = std::distance(implicit_begin,
              implicit_end);
      int not_instr_functions_count = std::distance(not_instr_begin,
              not_instr_end);
      std::vector<Function*> functions(functions_count);
      params_count = Parameters::parameters_count();
      // dummy insert since we only create global variables
      // but IRBuilder uses BB to determine the module
      // insert into first BB of first function
      builder.SetInsertPoint( &*(m.begin()->begin()) );

      // uint16_t __dfsan__retval_tls;
      glob_retval_tls = new llvm::GlobalVariable(m, builder.getInt16Ty(),
              false, llvm::GlobalValue::ExternalWeakLinkage,
              nullptr, glob_retval_tls_name, nullptr,
              llvm::GlobalValue::InitialExecTLSModel);

      // int32_t functions_count;
      llvm::Type * llvm_int_type = builder.getInt32Ty();
      glob_instr_funcs_count = new llvm::GlobalVariable(m, llvm_int_type, false,
              llvm::GlobalValue::WeakAnyLinkage,
              builder.getInt32(functions_count),
              glob_instr_funcs_count_name);

      // int32_t functions_count;
      llvm_int_type = builder.getInt32Ty();
      glob_implicit_funcs_count = new llvm::GlobalVariable(m, llvm_int_type, false,
              llvm::GlobalValue::WeakAnyLinkage,
              builder.getInt32(implicit_functions_count),
              glob_implicit_funcs_count_name);

      // int32_t functions_count;
      glob_funcs_count = new llvm::GlobalVariable(m, llvm_int_type, false,
              llvm::GlobalValue::WeakAnyLinkage,
              builder.getInt32(functions_count + implicit_functions_count + not_instr_functions_count),
              glob_funcs_count_name);

      // int32_t params_count
      glob_implicit_params_count = new llvm::GlobalVariable(m,
              llvm_int_type, false,
              llvm::GlobalValue::WeakAnyLinkage,
              builder.getInt32(database.parameters_count()),
              glob_implicit_params_count_name);

      glob_params_max_count = new llvm::GlobalVariable(m, llvm_int_type, false,
              llvm::GlobalValue::WeakAnyLinkage,
              builder.getInt32(params_count),
              glob_params_max_count_name);

      // char * output_filename
      glob_output_filename = new llvm::GlobalVariable(m,
              builder.getInt8PtrTy(), false,
              llvm::GlobalValue::WeakAnyLinkage,
              builder.CreateGlobalStringPtr(output_file_name),
              glob_output_filename_name);

      // char ** file_names
      auto file_it = file_index.begin(), file_end = file_index.end();
      size_t file_count = std::distance(file_it, file_end);
      llvm::ArrayType * array_type = llvm::ArrayType::get(
                  builder.getInt8PtrTy(),
                  file_count
              );
      std::vector<llvm::Constant*> file_names(file_count);
      for(; file_it != file_end; ++file_it) {
          llvm::StringRef fname = (*file_it).first;
          llvm::Constant * allocated = builder.CreateGlobalStringPtr(fname);
          file_names[ std::get<0>((*file_it).second) ] = allocated;
      }
      glob_files = new llvm::GlobalVariable(m,
              array_type,
              false,
              llvm::GlobalValue::WeakAnyLinkage,
              llvm::ConstantArray::get(array_type, file_names),
              glob_files_name);

      // char ** functions_names
      // char ** functions_mangled_names
      int database_size = functions_count + implicit_functions_count + not_instr_functions_count;
      array_type = llvm::ArrayType::get(
                  builder.getInt8PtrTy(),
                  database_size
              );
      std::vector<llvm::Constant*> function_names(database_size),
          mangled_function_names(database_size),
          demangled_function_names(database_size);
      for(auto it = begin; it != end; ++it) {
          if( !(*it).second.hasValue() )
              continue;
          int f_idx = (*it).second->function_idx();
          // another function with the same ID already wrote data
          if(function_names[f_idx])
              continue;
          // Func -> ID is a many-to-one mapping
          // but only one parent function provides name
          llvm::Function * func = funcs_names[f_idx];
          llvm::StringRef name = info.getFunctionName(*func);
          llvm::Constant * fname = builder.CreateGlobalStringPtr(name);
          llvm::StringRef mangled_name = func->getName();
          mangled_function_names[f_idx] =
              builder.CreateGlobalStringPtr(mangled_name);
          demangled_function_names[f_idx] = builder.CreateGlobalStringPtr(
                  demangle(mangled_name));
          function_names[f_idx] = fname;
      }
      for(auto it = implicit_begin; it != implicit_end; ++it) {
          int f_idx = (*it).second;

          llvm::StringRef name = (*it).first;
          llvm::Constant * fname = builder.CreateGlobalStringPtr(name);
          mangled_function_names[f_idx] = fname;
          demangled_function_names[f_idx] = fname;
          function_names[f_idx] = fname;
      }
      int idx = functions_count + implicit_functions_count;
      for(auto it = not_instr_begin; it != not_instr_end; ++it) {
          llvm::Function * func = *it;
          llvm::StringRef name = info.getFunctionName(*func);
          llvm::Constant * fname = builder.CreateGlobalStringPtr(name);
          llvm::StringRef mangled_name = func->getName();
          mangled_function_names[idx] =
              builder.CreateGlobalStringPtr(mangled_name);
          demangled_function_names[idx] = builder.CreateGlobalStringPtr(
                  demangle(mangled_name));
          function_names[idx] = fname;
          idx++;
      }
      glob_funcs_names = new llvm::GlobalVariable(m,
              array_type,
              false,
              llvm::GlobalValue::WeakAnyLinkage,
              llvm::ConstantArray::get(array_type, function_names),
              glob_funcs_names_name);
      glob_funcs_mangled_names = new llvm::GlobalVariable(m,
              array_type,
              false,
              llvm::GlobalValue::WeakAnyLinkage,
              llvm::ConstantArray::get(array_type, mangled_function_names),
              glob_funcs_mangled_names_name);
      glob_funcs_demangled_names = new llvm::GlobalVariable(m,
              array_type,
              false,
              llvm::GlobalValue::WeakAnyLinkage,
              llvm::ConstantArray::get(array_type, demangled_function_names),
              glob_funcs_demangled_names_name);

      // int32_t * functions_sizes
      array_type = llvm::ArrayType::get(
                  builder.getInt32Ty(),
                  functions_count
              );
      std::vector<llvm::Constant*> functions_args(functions_count);
      for(auto it = begin; it != end; ++it) {
          if( !(*it).second.hasValue() || (*it).second->is_overriden())
              continue;
          int f_idx = (*it).second->function_idx();
          int arg_size = (*it).first->arg_size();
          functions[f_idx] = &(*it).second.getValue();
          functions_args[f_idx] = builder.getInt32(arg_size);
      }
      glob_funcs_args = new llvm::GlobalVariable(m,
              array_type, false,
              llvm::GlobalValue::WeakAnyLinkage,
              llvm::ConstantArray::get(array_type, functions_args),
              glob_funcs_args_name);

      // int * functions_dbg_info
      array_type = llvm::ArrayType::get(
                  builder.getInt32Ty(),
                  functions_count*2
              );
      std::vector<llvm::Constant*> functions_dbg_info(2*functions_count);
      for(auto it = begin; it != end; ++it) {
          if( !(*it).second.hasValue() )
              continue;
          int f_idx = (*it).second->function_idx();
          // another function with the same ID already wrote data
          if(functions_dbg_info[2*f_idx])
              continue;
          auto loc = info.getFunctionLocation(*(*it).first);
          int line = -1, file_idx = -1;
          if(loc.hasValue()) {
              // line of code
              line = std::get<1>(*loc);
              // file index
              file_idx = file_index.getIdx(std::get<0>(*loc));
          }
          // line of code
          functions_dbg_info[2*f_idx] = builder.getInt32(line);
          // file index
          functions_dbg_info[2*f_idx + 1] = builder.getInt32(file_idx);
      }

      glob_funcs_dbg = new llvm::GlobalVariable(m,
              array_type,
              false,
              llvm::GlobalValue::WeakAnyLinkage,
              llvm::ConstantArray::get(array_type, functions_dbg_info),
              glob_funcs_dbg_name);

      // char ** params_names
      // filled during execution
      size_t full_params_count = params_count + database.parameters_count();
      array_type = llvm::ArrayType::get(
                  builder.getInt8PtrTy(),
                  full_params_count);
      std::vector<llvm::Constant*> params_names(full_params_count);
      for(int i = 0; i < database.parameters_count(); ++i)
          params_names[i] =
              builder.CreateGlobalStringPtr(database.parameter_name(i));
      for(int i = 0; i < params_count; ++i)
          params_names[i + database.parameters_count()] = llvm::ConstantPointerNull::get(builder.getInt8PtrTy());
      glob_params_names = new llvm::GlobalVariable(m,
              array_type,
              false,
              llvm::GlobalValue::WeakAnyLinkage,
              //llvm::GlobalValue::WeakAnyLinkage,
              llvm::ConstantArray::get(array_type, params_names),
              glob_params_names_name);

      array_type = llvm::ArrayType::get(
                  builder.getInt1Ty(),
                  full_params_count);
      glob_params_used = new llvm::GlobalVariable(m,
              array_type,
              false,
              llvm::GlobalValue::WeakAnyLinkage,
              llvm::ConstantAggregateZero::get(array_type),
              glob_params_used_name);

      array_type = llvm::ArrayType::get(
                  builder.getInt16Ty(),
                  database.parameters_count());
      glob_params_redirect = new llvm::GlobalVariable(m,
              array_type,
              false,
              llvm::GlobalValue::WeakAnyLinkage,
              llvm::ConstantAggregateZero::get(array_type),
              glob_params_redirect_name);

      // int16_t instrumentation_labels[] = {0..}
      array_type = llvm::ArrayType::get(builder.getInt16Ty(), full_params_count);
      std::vector<llvm::Constant*> labels;
      for(int i = 0; i < params_count; ++i)
          labels.push_back(builder.getInt16(0));
      glob_labels = new llvm::GlobalVariable(m,
              array_type,
              false,
              llvm::GlobalValue::WeakAnyLinkage,
              llvm::ConstantArray::get(array_type, labels),
              glob_labels_name);

      // number of loops in the entire program
      std::vector<int> loops_structures;
      std::vector<int> loops_structures_offsets(functions_count + 1);
      std::vector<int> loops_sizes;
      std::vector<int> loops_sizes_offsets(functions_count + 1);
      loops_sizes_offsets[0] = 0;
      loops_structures_offsets[0] = 0;
      int number_of_loops = 0;
      for(Function * f : functions) {
        size_t structure_size_before = loops_structures.size();
        int top_level_loops = f->loop_structures.size();
        // For each loop in the function, copy the loop structure data
        // and insert corresponding data on loop size.
        // Loop size data: # of loops, depth, structure size
        for(const LoopStructure & s : f->loop_structures) {
          std::copy(s.structure.begin(), s.structure.end(),
            std::back_inserter(loops_structures)
          );
          loops_sizes.push_back(s.depth);
          loops_sizes.push_back(s.loops_count);
          loops_sizes.push_back(s.structure.size());
          number_of_loops += s.structure.size();
        }
        size_t structure_size_diff = loops_structures.size() - structure_size_before;
        int f_idx = f->function_idx();
        loops_sizes_offsets[f_idx + 1] = top_level_loops * 3;
        loops_structures_offsets[f_idx + 1] = structure_size_diff;
        //int loops = f->loops_sizes.size() / 3;
        //for(int i = 0; i < loops; ++i)
        //    number_of_loops += f->loops_sizes[3*i + 2];
      }

      std::vector<llvm::Constant*> structures(loops_structures.size());
      std::transform(loops_structures.begin(), loops_structures.end(),
        structures.begin(),
        [this](int offset) {
            return builder.getInt32(offset);
        }
      );
      array_type = llvm::ArrayType::get(builder.getInt32Ty(),
              loops_structures.size());
      glob_loops_structures = new llvm::GlobalVariable(m,
              array_type, false, llvm::GlobalValue::WeakAnyLinkage,
              llvm::ConstantArray::get(array_type, structures),
              glob_loops_structures_name);

      std::vector<llvm::Constant*> sizes(loops_sizes.size());
      std::transform(loops_sizes.begin(), loops_sizes.end(),
        sizes.begin(),
        [this](int offset) {
            return builder.getInt32(offset);
        }
      );
      array_type = llvm::ArrayType::get(builder.getInt32Ty(),
              loops_sizes.size());
      glob_loops_sizes = new llvm::GlobalVariable(m,
              array_type, false, llvm::GlobalValue::WeakAnyLinkage,
              llvm::ConstantArray::get(array_type, sizes),
              glob_loops_sizes_name);

      std::partial_sum(loops_sizes_offsets.begin(), loops_sizes_offsets.end(),
          loops_sizes_offsets.begin());
      std::vector<llvm::Constant*> sizes_llvm(functions_count + 1);
      std::transform(loops_sizes_offsets.begin(), loops_sizes_offsets.end(),
              sizes_llvm.begin(),
              [this](int offset) {
                  return builder.getInt32(offset);
              }
      );
      array_type = llvm::ArrayType::get(builder.getInt32Ty(),
              functions_count + 1);
      glob_loops_sizes_offsets = new llvm::GlobalVariable(m,
              array_type, false, llvm::GlobalValue::WeakAnyLinkage,
              llvm::ConstantArray::get(array_type, sizes_llvm),
              glob_loops_sizes_offsets_name);

      std::partial_sum(loops_structures_offsets.begin(), loops_structures_offsets.end(),
          loops_structures_offsets.begin());
      std::vector<llvm::Constant*> structs_llvm(functions_count + 1);
      std::transform(loops_structures_offsets.begin(), loops_structures_offsets.end(),
              structs_llvm.begin(),
              [this](int offset) {
                  return builder.getInt32(offset);
              }
      );
      array_type = llvm::ArrayType::get(builder.getInt32Ty(),
              functions_count + 1);
      glob_loops_sizes_offsets = new llvm::GlobalVariable(m,
              array_type, false, llvm::GlobalValue::WeakAnyLinkage,
              llvm::ConstantArray::get(array_type, structs_llvm),
              glob_loops_structures_offsets_name);

      glob_loops_number = new llvm::GlobalVariable(m,
              builder.getInt32Ty(), false, llvm::GlobalValue::WeakAnyLinkage,
              builder.getInt32(number_of_loops),
              glob_loops_number_name);
    }
    void commitLoop(llvm::Loop &, int function_idx, int loop_idx);
    void commitLoops(llvm::Function &, int function_idx, int calls_count);
    LoopStructure  instrumentLoop(Function & func, const Loop & loop, int nested_loop_idx,
        FunctionCalls & calls);

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

    llvm::Instruction* instrumentLoopCall(llvm::Function &,
        llvm::CallBase * call, int16_t nested_loop_idx,
        uint16_t loop_size, llvm::Instruction*);
    void removeLoopCalls(llvm::Function & f, size_t size);
    void saveCurrentCall(llvm::Function & f);

    void callImplicitLoop(ImplicitCall &, int func_idx, int called_func_idx,
            int loop_idx, int nested_loop_idx);
    void callImplicitFunction(int func_idx);
    void writeParameter(llvm::Instruction * instr, llvm::Value * dest, int parameter_idx);
    void findTerminator(llvm::Function & f, llvm::SmallVector<llvm::ReturnInst*, 5> & returns);
    llvm::Function * getAtExit();
    uint64_t size_of(llvm::Value * val);
    std::string demangle(llvm::StringRef);
    bool callsImportantFunction(const llvm::CallBase * call);
    bool callsImportantFunction(const llvm::Function * called_f,
          std::set<llvm::Function*> & recursive_calls);
  };
}

#endif

