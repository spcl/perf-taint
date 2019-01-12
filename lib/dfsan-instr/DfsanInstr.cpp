#include "dfsan-instr/DfsanInstr.hpp"
#include "AnnotationAnalyzer.hpp"
#include "DebugInfo.hpp"
#include "ParameterFinder.hpp"
#include "util/util.hpp"

#include <llvm/Analysis/CallGraph.h>
#include <llvm/Analysis/LoopInfo.h>
#include <llvm/Analysis/ScalarEvolution.h>
#include <llvm/IR/InstIterator.h>
#include <llvm/IR/ModuleSlotTracker.h>
#include <llvm/IR/LegacyPassManager.h>
#include <llvm/Support/raw_ostream.h>
#include <llvm/Transforms/IPO/PassManagerBuilder.h>
#include <llvm/Transforms/Scalar.h>
#include <llvm/Transforms/Utils.h>

#include <polly/PolySCEV.h>

#include <algorithm>
#include <iostream>
#include <numeric>
#include <vector>
#include <string>

static llvm::cl::opt<std::string> LogFileName("extrap-extractor-log-name",
                                        llvm::cl::desc("Specify filename for output log"),
                                        llvm::cl::init("unknown"),
                                        llvm::cl::value_desc("filename"));

static llvm::cl::opt<std::string> LogDirName("extrap-extractor-out-dir",
                                       llvm::cl::desc("Specify directory for output logs"),
                                       llvm::cl::init(""),
                                       llvm::cl::value_desc("filename"));

static llvm::cl::opt<bool> EnableSCEV("extrap-extractor-scev",
                                       llvm::cl::desc("Enable LLVM Scalar Evolution"),
                                       llvm::cl::init(true),
                                       llvm::cl::value_desc("boolean flag"));

static llvm::cl::opt<bool> EnablePollySCEV("extrap-extractor-polly-scev",
                                       llvm::cl::desc("Enable Polly Scalar Evolution"),
                                       llvm::cl::init(true),
                                       llvm::cl::value_desc("boolean flag"));

static llvm::cl::opt<std::string> JSONOutputToFile("extrap-extractor-json-output-file",
                                       llvm::cl::desc("Enable Polly Scalar Evolution"),
                                       llvm::cl::init(""),
                                       llvm::cl::value_desc("boolean flag"));

static llvm::cl::opt<bool> GenerateStats("extrap-extractor-export-stats",
                                       llvm::cl::desc("Specify directory for output logs"),
                                       llvm::cl::init(false),
                                       llvm::cl::value_desc("filename"));

namespace extrap {
 
    std::set<Parameters::id_t> LabelAnnotator::annotated_params;

    void DfsanInstr::getAnalysisUsage(llvm::AnalysisUsage &AU) const
    {
        ModulePass::getAnalysisUsage(AU);
        // We require loop information
        AU.addRequired<llvm::LoopInfoWrapperPass>();
        if(EnableSCEV)
            AU.addRequiredTransitive<llvm::ScalarEvolutionWrapperPass>();
        if(EnablePollySCEV)
            AU.addRequired<polly::PolySCEV>();
        // Pass does not modify the input information
        AU.addRequired<llvm::CallGraphWrapperPass>();
        AU.setPreservesAll();
    }

    bool DfsanInstr::runOnModule(llvm::Module &m)
    {
        llvm::legacy::PassManager PM;
        // correlated-propagation
        PM.add(llvm::createInstructionNamerPass());
        //PM.add(llvm::createMetaRenamerPass());
        PM.add(llvm::createCorrelatedValuePropagationPass());
        // mem2reg pass
        //PM.add(llvm::createPromoteMemoryToRegisterPass());
        PM.add(llvm::createDemoteRegisterToMemoryPass());
        // loop-simplify
        PM.add(llvm::createLoopSimplifyPass());
        PM.run(m);

        // Since neither m.getName() or m.getSourceFileName provides a meaningful name
        // We rely on the user to supply an additional log name.

        std::string name = LogDirName.getValue().empty() ?
                           "results" :
                           cppsprintf("%s/results", LogDirName.getValue().c_str());
        log.open(
            cppsprintf("%s_%s", name.c_str(), LogFileName.getValue().c_str()),
            std::ios::app);
        cgraph = &getAnalysis<llvm::CallGraphWrapperPass>().getCallGraph();
        AnnotationAnalyzer annotations("extrap");
        annotations.findGlobalAnnotations(m,
                [](llvm::GlobalVariable * var) {
                    Parameters::process_param(var->getName(), var);
                });

        this->m = &m;
        llvm::Function * main = m.getFunction("main");
        assert(main);

        runOnFunction(*main);

        for(llvm::Function & f : m)
        {
            //for(llvm::Use & use : f.uses())
            //    llvm::outs() << use << '\n';
            if(instrumented_functions.find(&f) == instrumented_functions.end())
               runOnFunction(f);
        }

        Instrumenter instr(m);
        instr.createGlobalStorage(parent_functions,
                instrumented_functions.begin(), instrumented_functions.end(),
                loops_depths, loops_counts);
        instr.initialize(main);
        //instr.annotateParams(found_params);
        size_t params_count = Parameters::globals_names.size() + Parameters::local_names.size();
        for(auto & f : instrumented_functions)
        {
            if(f.second) {
                modifyFunction(*f.first, f.second.getValue(), instr);
            }
        }

        stats.print();

        return false;
    }

    bool DfsanInstr::handleOpenMP(llvm::Function & f, int override_counter)
    {
        bool openmp_call = false;
        for(llvm::BasicBlock & bb: f)
            for(llvm::Instruction & instr : bb)
                if(llvm::CallInst * call
                        = llvm::dyn_cast<llvm::CallInst>(&instr)) {
                    if(call->getCalledFunction() &&
                            call->getCalledFunction()->getName() == "__kmpc_fork_call") {
                        llvm::ConstantExpr * cast =
                            llvm::dyn_cast<llvm::ConstantExpr>(call->getOperand(2));
                        assert(cast);
                        llvm::Function * func =
                            llvm::dyn_cast<llvm::Function>(cast->getOperand(0));
                        assert(func);
                        //insert call with the same counter
                        //don't insert into names vector, that's for the parent function
                        int counter = override_counter != -1 ?
                            override_counter : instrumented_functions_counter;
                        //instrumented_functions.insert(
                        //        std::make_pair(func, counter)
                        //    );
                        openmp_call = true;
                        //handle additional calls
                        //OpenMP can split for loop functions into additional
                        //calls e.g. omp.outlined and omp.outlined._debug
                        runOnFunction(*func, counter);
                    } else if(!call->getCalledFunction()) {
                        unknown << "Unknown call: ";
                        std::string str;
                        llvm::raw_string_ostream os(str);
                        os << *call;
                        os << ' ';
                        os << *call->getFunctionType();
                        unknown << os.str() << '\n';
                    }
                }
        return openmp_call;
    }

    void DfsanInstr::foundFunction(llvm::Function &f, bool important, int counter)
    {
        auto it = instrumented_functions.find(&f);
        assert(it == instrumented_functions.end());
        if(important) {
            bool overriden = true;
            if(counter == -1) {
                // when overriding, only the parent function matters
                // don't insert name in such case
                parent_functions.push_back(&f);
                // when not overriding, get the current counter and update
                counter = instrumented_functions_counter;
                instrumented_functions_counter++;
                overriden = false;
            }
            instrumented_functions[&f] =
                llvm::Optional<Function>(Function(counter, overriden));
        } else {
            instrumented_functions[&f] = llvm::Optional<Function>();
            stats.empty_function();
        }
    }

    void DfsanInstr::insertCallsite(llvm::Function & f, llvm::Value * val)
    {
        auto it = instrumented_functions.find(&f);
        if( (*it).second.hasValue() )
            (*it).second->add_callsite(val);
    }

    int DfsanInstr::analyzeLoop(Function & f, llvm::Loop & l, int depth)
    {
        int loops = 0;
        auto & subloops = l.getSubLoops();
        if(subloops.empty()) {
            //f.add_loop(depth + 1);
            loops_depths.push_back(depth + 1);
            loops += 1;
        }
        for(llvm::Loop * l : subloops) {
            loops += analyzeLoop(f, *l, depth + 1);
        }
        return loops;
    }

    bool DfsanInstr::analyzeFunction(llvm::Function & f, int override_counter)
    {
        linfo = &getAnalysis<llvm::LoopInfoWrapperPass>(f).getLoopInfo();
        assert(linfo);
        bool has_openmp_calls = handleOpenMP(f, override_counter);
        // Worth instrumenting
        if(!linfo->empty() || has_openmp_calls) {
            foundFunction(f, true, override_counter);

            Function & func = instrumented_functions[&f].getValue();
            int loops = 0;
            for(llvm::Loop * l : *linfo) {
                loops += analyzeLoop(func, *l,  0);
            }
            loops_counts.push_back(loops);

            return true;
        } else {
            foundFunction(f, false, override_counter);
            return false;
        }
    }

    bool DfsanInstr::runOnFunction(llvm::Function & f, int override_counter)
    {
        // ignore declarations
        // TODO: handle instrumentation of unknown functions
        if(!is_analyzable(*m, f))
            return false;
        auto it = instrumented_functions.find(&f) ;
        if(it != instrumented_functions.end())
            return (*it).second.hasValue();
        stats.found_function();
        llvm::CallGraphNode * f_node = (*cgraph)[&f];
        ParameterFinder finder(f);
        FunctionParameters parameters = finder.find_args();
        for(auto & param : parameters.locals) {
            found_params.push_back(param);
        }

        bool is_important = analyzeFunction(f, override_counter);
        for(auto & callsite : *f_node)
        {
            llvm::CallGraphNode * node = callsite.second;
            llvm::Function * called_f = node->getFunction();
            llvm::Value * call = callsite.first;
            // For some reason I keep seeing nullptr here
            if(called_f) {
                // it's important if at least one of subfunctions is important
                bool f_important = runOnFunction(*called_f, override_counter);
                if(f_important) {
                    insertCallsite(*called_f, call);
                    is_important = true;
                }
            }
        }
        return is_important;
    }

    int DfsanInstr::instrumentLoop(Function & func, llvm::Loop & l,
            int loop_idx, int depth, Instrumenter & instr)
    {
        llvm::SmallVector<llvm::BasicBlock*, 10> exit_blocks;
        l.getExitingBlocks(exit_blocks);
        for(llvm::BasicBlock * bb : exit_blocks) {
            const llvm::Instruction * inst = bb->getTerminator();
            const llvm::BranchInst * br = llvm::dyn_cast<llvm::BranchInst>(inst);
            //llvm::outs() << *inst << '\n';
            assert(br);
            if(br->isConditional()) {
                instr.checkLoop(loop_idx, depth, func.function_idx(), br);
            }
        }
        auto & subloops = l.getSubLoops();
        loop_idx += subloops.empty();
        for(llvm::Loop * l : subloops) {
            loop_idx += instrumentLoop(func, *l, loop_idx, depth + 1, instr);
        }
        return loop_idx;
    }

    void DfsanInstr::modifyFunction(llvm::Function & f, Function & func,
            Instrumenter & instr)
    {
        linfo = &getAnalysis<llvm::LoopInfoWrapperPass>(f).getLoopInfo();
        assert(linfo);

        int loop_idx = 0;
        for(llvm::Loop * l : *linfo) {
            instrumentLoop(func, *l, 0, 0, instr);
        }
        //int labels = 0;
        //for(auto i = llvm::inst_begin(&f), end = llvm::inst_end(&f); i != end; ++i)
        //{
        //    if(llvm::BranchInst * br = llvm::dyn_cast<llvm::BranchInst>(&*i)) {
        //        if(br->isConditional()) {
        //            // is this a part of a loop?
        //            // insert the check for labels
        //            instr.checkCF(func.function_idx(), br);
        //            labels++;
        //        }
        //    }
        //}

        int idx = 0;
        for(llvm::Value * callsite : func.callsites) {
            llvm::Instruction * s = llvm::dyn_cast<llvm::Instruction>(callsite);
            llvm::CallBase * call = llvm::dyn_cast<llvm::CallBase>(s);
            assert(call);
            //instr.checkCall(func.function_idx(), idx++, call);
        }

        //stats.label_function(labels);
    }

    bool DfsanInstr::is_analyzable(llvm::Module & m, llvm::Function & f)
    {
        llvm::Function * in_module = m.getFunction(f.getName());
        if(f.isDeclaration() || !in_module) {
            unknown << f.getName().str() << '\n';
            return false;
        }
        return true;
    }

    template<typename Vector, typename Vector2, typename FuncIter>
    void Instrumenter::createGlobalStorage(const Vector & funcs_names,
            FuncIter begin, FuncIter end, Vector2 & loops_depths,
            Vector2 & loops_counts)
    {
        functions_count = funcs_names.size();
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
        glob_funcs_count = new llvm::GlobalVariable(m, llvm_int_type, false,
                llvm::GlobalValue::WeakAnyLinkage,
                builder.getInt32(functions_count),
                glob_funcs_count_name);
        // int32_t params_count
        glob_params_count = new llvm::GlobalVariable(m, llvm_int_type, false,
                llvm::GlobalValue::WeakAnyLinkage,
                builder.getInt32(params_count),
                glob_params_count_name);

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
        array_type = llvm::ArrayType::get(
                    builder.getInt8PtrTy(),
                    functions_count
                );
        std::vector<llvm::Constant*> function_names(functions_count);
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
            function_names[f_idx] = fname;
        }
        glob_funcs_names = new llvm::GlobalVariable(m,
                array_type,
                false,
                llvm::GlobalValue::WeakAnyLinkage,
                llvm::ConstantArray::get(array_type, function_names),
                glob_funcs_names_name);

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
        array_type = llvm::ArrayType::get(
                    builder.getInt8PtrTy(),
                    params_count
                );
        glob_params_names = new llvm::GlobalVariable(m,
                array_type,
                false,
                llvm::GlobalValue::WeakAnyLinkage,
                llvm::ConstantAggregateZero::get(array_type),
                glob_params_names_name);

        // int16_t instrumentation_labels[] = {0..}
        array_type = llvm::ArrayType::get(builder.getInt16Ty(), params_count);
        std::vector<llvm::Constant*> labels;
        for(int i = 0; i < params_count; ++i)
            labels.push_back(builder.getInt16(0));
        glob_labels = new llvm::GlobalVariable(m,
                array_type,
                false,
                llvm::GlobalValue::WeakAnyLinkage,
                llvm::ConstantArray::get(array_type, labels),
                glob_labels_name);

        // int32_t instrumentation_results[functions * params];
        array_type = llvm::ArrayType::get(builder.getInt32Ty(),
                params_count * functions_count);
        glob_result_array = new llvm::GlobalVariable(m,
                array_type, false, llvm::GlobalValue::WeakAnyLinkage,
                llvm::ConstantAggregateZero::get(array_type),
                glob_result_array_name);

        // callsite_count * operand_count
        // last element stores the final size
        std::vector<int> sizes(functions_count + 1);
        for(auto it = begin; it != end; ++it) {
            if( (*it).second.hasValue() && !(*it).second->is_overriden()) {
                int operands_count = (*it).first->arg_size();
                int callsites_count = (*it).second->callsites_size();
                int f_idx = (*it).second->function_idx();
                sizes[f_idx] = operands_count * callsites_count;
                //llvm::outs() << (*it).first->getName() << ' ' << operands_count << ' ' << callsites_count << '\n';
            }
        }
        // compute offsets with a prefix sum
        std::partial_sum(sizes.begin(), sizes.end(), sizes.begin());
        int total_size = sizes.back();
        // int8_t callsites_results[total_size];
        array_type = llvm::ArrayType::get(builder.getInt1Ty(), total_size);
        glob_callsites_result = new llvm::GlobalVariable(m,
                array_type, false, llvm::GlobalValue::WeakAnyLinkage,
                llvm::ConstantAggregateZero::get(array_type),
                glob_callsites_result_name);
        // int32_t callsites_offsets[functions_count + 1];
        // first element is always zero, the last one is an accumulated sum
        std::vector<llvm::Constant*> offsets(functions_count + 1);
        std::transform(sizes.begin(), sizes.end(), offsets.begin(),
            [this](int offset) {
                return builder.getInt32(offset);
            }
        );
        array_type = llvm::ArrayType::get(builder.getInt32Ty(),
                functions_count + 1);
        glob_callsites_offsets = new llvm::GlobalVariable(m,
                array_type, false, llvm::GlobalValue::WeakAnyLinkage,
                llvm::ConstantArray::get(array_type, offsets),
                glob_callsites_offsets_name);

        //int32_t loop_depths
        std::vector<llvm::Constant*> depths(loops_depths.size());
        std::transform(loops_depths.begin(), loops_depths.end(), depths.begin(),
            [this](int depth) {
                return builder.getInt32(depth);
            }
        );
        array_type = llvm::ArrayType::get(builder.getInt32Ty(),
                loops_depths.size());
        glob_loops_depths = new llvm::GlobalVariable(m,
                array_type, false, llvm::GlobalValue::WeakAnyLinkage,
                llvm::ConstantArray::get(array_type, depths),
                glob_loops_depths_name);

        //int32_t loops_depths_offsets
        std::vector<int> depths_offsets(functions_count + 1);
        std::partial_sum(loops_counts.begin(), loops_counts.end(),
            depths_offsets.begin() + 1);
        depths_offsets[0] = 0;
        std::vector<llvm::Constant*> depths_offsets_ir(functions_count + 1);
        std::transform(depths_offsets.begin(), depths_offsets.end(),
                depths_offsets_ir.begin(),
                [this](int offset) {
                    return builder.getInt32(offset);
                });
        array_type = llvm::ArrayType::get(builder.getInt32Ty(),
                functions_count + 1);
        glob_depths_array_offsets = new llvm::GlobalVariable(m,
                array_type, false, llvm::GlobalValue::WeakAnyLinkage,
                llvm::ConstantArray::get(array_type, depths_offsets_ir),
                glob_depths_array_offsets_name);

        //int32_t deps_offsets
        // for each function compute the number of `dependencies` objects
        // corresponds to sum of loop depths
        std::vector<int> loops_per_func(functions_count);
        std::vector<int> deps_offsets(functions_count + 1);
        int cnt = 0;
        for(int i = 0; i < functions_count; ++i) {
            int loops = 0;
            for(int j = 0; j < loops_counts[i]; ++j) {
                loops += loops_depths[cnt++];
            }
            loops_per_func[i] = loops;
        }
        std::partial_sum(loops_per_func.begin(), loops_per_func.end(),
            deps_offsets.begin() + 1);
        deps_offsets[0] = 0;
        std::vector<llvm::Constant*> deps(functions_count + 1);
        std::transform(deps_offsets.begin(), deps_offsets.end(), deps.begin(),
            [this](int offset) {
                return builder.getInt32(offset);
            }
        );
        array_type = llvm::ArrayType::get(builder.getInt32Ty(),
                loops_counts.size() + 1);
        glob_deps_offsets = new llvm::GlobalVariable(m,
                array_type, false, llvm::GlobalValue::WeakAnyLinkage,
                llvm::ConstantArray::get(array_type, deps),
                glob_deps_offsets_name);
    }

    void Instrumenter::checkLoop(int loop_idx, int depth, int function_idx,
            const llvm::BranchInst * br)
    {
        assert(glob_result_array);
        // insert call before branch
        InstrumenterVisiter vis(*this,
            [this, loop_idx, depth, function_idx](uint64_t size, llvm::Value * ptr) {
                checkLoopLoad(loop_idx, depth, function_idx, size, ptr);
            },
            [this, loop_idx, depth, function_idx](llvm::CallBase * ptr) {
                checkLoopRetval(loop_idx, depth, function_idx, ptr);
            }
        );
        const llvm::Instruction * inst =
            llvm::dyn_cast<llvm::Instruction>(br->getCondition());
        assert(inst);
        // TODO: why instvisit is not for const instruction?
        vis.visit( const_cast<llvm::Instruction*>(inst) );
    }

    void Instrumenter::checkLoopLoad(int loop_idx, int depth, int function_idx,
            size_t size, llvm::Value * operand)
    {
        llvm::Value * cast = builder.CreatePointerCast(operand, builder.getInt8PtrTy());
        builder.CreateCall(load_loop_function, {
                cast, builder.getInt32(size),
                builder.getInt32(loop_idx), builder.getInt32(depth),
                builder.getInt32(function_idx)
            });
    }

    void Instrumenter::checkLoopRetval(int loop_idx, int depth,
            int function_idx, llvm::CallBase * call)
    {
        llvm::Value * load_tls = builder.CreateLoad(glob_retval_tls);
        builder.CreateCall(label_loop_function, {
                load_tls, builder.getInt32(loop_idx),
                builder.getInt32(depth),
                builder.getInt32(function_idx)
            });
    }

    void Instrumenter::checkCF(int function_idx, llvm::BranchInst * br)
    {
        assert(glob_result_array);
        // insert call before branch
        InstrumenterVisiter vis(*this,
            [this, function_idx](uint64_t size, llvm::Value * ptr) {
                checkCFLoad(function_idx, size, ptr);
            },
            [this, function_idx](llvm::CallBase * ptr) {
                checkCFRetval(function_idx, ptr);
            }
        );
        const llvm::Instruction * inst = llvm::dyn_cast<llvm::Instruction>(br->getCondition());
        assert(inst);
        // TODO: why instvisit is not for const instruction?
        vis.visit( const_cast<llvm::Instruction*>(inst) );
    }

    void Instrumenter::checkCFLoad(int function_idx, size_t size, llvm::Value * operand)
    {
        llvm::Value * cast = builder.CreatePointerCast(operand, builder.getInt8PtrTy());
        builder.CreateCall(load_function, {cast, builder.getInt32(size), builder.getInt32(function_idx) });
    }

    void Instrumenter::checkCFRetval(int function_idx, llvm::CallBase * call)
    {
        llvm::Value * load_tls = builder.CreateLoad(glob_retval_tls);
        builder.CreateCall(label_function,
                {load_tls, builder.getInt32(function_idx)}
            );
    }

    void Instrumenter::checkCallSite(int function_idx, int callsite_idx,
            llvm::CallBase * call)
    {
        // dom't cache loads because we update args seperately
        // same load might appear twice
        // TODO: optimize this to call check with multiple arg ids
        int arg_idx = 0;
        auto load_check =
            [=, &arg_idx](uint64_t size, llvm::Value * ptr) {
                checkCallSiteLoad(function_idx, callsite_idx, arg_idx++, size, ptr);
            };
        auto label_check =
            [=, &arg_idx](llvm::CallBase * ptr) {
                checkCallSiteRetval(function_idx, callsite_idx, arg_idx++, ptr);
            };
        InstrumenterVisiter vis(*this, load_check, label_check, false);
        for(int i = 0; i < call->getNumArgOperands(); ++i) {
            llvm::Value * arg = call->getArgOperand(i);
            // constant values (int, fp)
            if(llvm::isa<llvm::ConstantData>(arg))
                continue;
            llvm::Instruction * instr = llvm::dyn_cast<llvm::Instruction>(arg);
            assert(instr);
            vis.visit(*instr);
        }
    }

    void Instrumenter::checkCallSiteLoad(int function_idx, int callsite_idx,
            int arg_idx, uint64_t size, llvm::Value * ptr)
    {
        llvm::Value * cast = builder.CreatePointerCast(ptr, builder.getInt8PtrTy());
        builder.CreateCall(callsite_function, {cast, builder.getInt32(size),
                builder.getInt32(function_idx), builder.getInt32(callsite_idx),
                builder.getInt32(arg_idx)});
    }

    void Instrumenter::checkCallSiteRetval(int function_idx, int callsite_idx,
            int arg_idx, llvm::CallBase * ptr)
    {
    }

    void Instrumenter::setLabel(Parameters::id_t param, const llvm::Value * val)
    {
        assert(glob_labels);
        LabelAnnotator vis{*this, param};
        const llvm::Instruction * inst = llvm::dyn_cast<llvm::Instruction>(val);
        assert(inst);
        vis.visit( const_cast<llvm::Instruction*>(inst) );
    }

    void Instrumenter::callSetLabel(int param_idx, const char * param_name, size_t size, llvm::Value * operand)
    {
        //TODO: can we embed a const string in code?
        //llvm::Constant * name = llvm::ConstantDataArray::getString(builder.getContext(), param_name, false);
        llvm::Value * name = builder.CreateGlobalString(param_name, "");
        llvm::Value * cast = builder.CreatePointerCast(operand, builder.getInt8PtrTy());
        llvm::Value * zero = builder.getInt32(0);
        llvm::Value * indices[] = {zero, zero};
        llvm::Value * gep = llvm::GetElementPtrInst::CreateInBounds(name, llvm::makeArrayRef(indices, 2), "", llvm::dyn_cast<llvm::Instruction>(cast));
        //llvm::Value * name_cast = builder.CreatePointerCast(name, builder.getInt8PtrTy());
        // set_label(data, size, param_idx, param_name)
        builder.CreateCall(store_function,{
                    cast, builder.getInt32(size),
                    builder.getInt32(param_idx),
                    gep
                    //llvm::ConstantExpr::getPointerCast(name, builder.getInt8PtrTy())
                });
    }

    void Instrumenter::declareFunctions()
    {
        llvm::Type * void_t = builder.getVoidTy();
        llvm::Type * int8_ptr = builder.getInt8PtrTy();
        llvm::Type * idx_t = builder.getInt32Ty();
        llvm::FunctionType * func_t = nullptr;

        //// void check_load(int8_t *, int32_t, int32_t)
        //func_t = llvm::FunctionType::get(
        //        void_t, {int8_ptr, idx_t, idx_t}, false);
        //m.getOrInsertFunction("__dfsw_EXTRAP_CHECK_LOAD", func_t);
        //load_function = m.getFunction("__dfsw_EXTRAP_CHECK_LOAD");
        //assert(load_function);

        //// void check_label(uint16_t, int32_t)
        //func_t = llvm::FunctionType::get(
        //        void_t, {builder.getInt16Ty(), idx_t}, false);
        //m.getOrInsertFunction("__dfsw_EXTRAP_CHECK_LABEL", func_t);
        //label_function = m.getFunction("__dfsw_EXTRAP_CHECK_LABEL");
        //assert(label_function);

        // void store_label(int8_t *, int32_t, int32_t, int8_t*)
        func_t = llvm::FunctionType::get(void_t,
                {int8_ptr, idx_t, idx_t, int8_ptr}, false);
        m.getOrInsertFunction("__dfsw_EXTRAP_STORE_LABEL", func_t);
        store_function = m.getFunction("__dfsw_EXTRAP_STORE_LABEL");
        assert(store_function);

        // void check_arg(int8_t *, int32_t, int32_t, int32_t, int32_t)
        func_t = llvm::FunctionType::get(void_t,
                {int8_ptr, idx_t, idx_t, idx_t, idx_t}, false);
        m.getOrInsertFunction("__dfsw_EXTRAP_CHECK_CALLSITE", func_t);
        callsite_function = m.getFunction("__dfsw_EXTRAP_CHECK_CALLSITE");
        assert(store_function);

        // void at_exit()
        func_t = llvm::FunctionType::get(void_t, {}, false);
        m.getOrInsertFunction("__dfsw_EXTRAP_AT_EXIT", func_t);
        at_exit_function = m.getFunction("__dfsw_EXTRAP_AT_EXIT");
        assert(at_exit_function);

        // void extrap_init()
        func_t = llvm::FunctionType::get(void_t, {}, false);
        m.getOrInsertFunction("__dfsw_EXTRAP_INIT", func_t);
        init_function = m.getFunction("__dfsw_EXTRAP_INIT");
        assert(init_function);

        // void __EXTRAP_CHECK_LABEL(label, depth, loop_idx, func_idx)
        func_t = llvm::FunctionType::get(void_t,
                {builder.getInt16Ty(), idx_t, idx_t, idx_t}, false);
        m.getOrInsertFunction("__dfsw_EXTRAP_CHECK_LABEL", func_t);
        label_loop_function = m.getFunction("__dfsw_EXTRAP_CHECK_LABEL");

        // __EXTRAP_CHECK_LOAD(addr, size, depth, loop_idx, func_idx)
        func_t = llvm::FunctionType::get(void_t,
                {int8_ptr, idx_t, idx_t, idx_t, idx_t}, false);
        m.getOrInsertFunction("__dfsw_EXTRAP_CHECK_LOAD", func_t);
        load_loop_function = m.getFunction("__dfsw_EXTRAP_CHECK_LOAD");
    }

    // polly lib/CodeGen/PerfMonitor.cpp
    llvm::Function * Instrumenter::getAtExit()
    {
        llvm::Function * f = m.getFunction("atexit");
        if(!f) {
            //int32_t atexit(int8_t*)
            llvm::GlobalValue::LinkageTypes linkage
                = llvm::GlobalValue::ExternalLinkage;
            llvm::FunctionType * f_type = llvm::FunctionType::get(
                    builder.getInt32Ty(),
                    {builder.getInt8PtrTy()}, false
                );
            f = llvm::Function::Create(f_type, linkage, "atexit", m);
        }
        return f;
    }

    void Instrumenter::setInsertPoint(llvm::Instruction & instr)
    {
        builder.SetInsertPoint(&instr);
    }

    void Instrumenter::initialize(llvm::Function * main)
    {
        //builder.SetInsertPoint(main->getEntryBlock().getTerminator()->getPrevNode());
        builder.SetInsertPoint( &(*main->getEntryBlock().begin()) );
        llvm::Value * cast_f = builder.CreatePointerCast(at_exit_function, builder.getInt8PtrTy());
        builder.CreateCall(getAtExit(), {cast_f});
        builder.CreateCall(init_function);
    }

    void Instrumenter::annotateParams(const std::vector< std::tuple<const llvm::Value *, Parameters::id_t> > & params)
    {
        assert(glob_labels);
        for(int i = 0; i < params.size(); ++i) {
            if(LabelAnnotator::visited(std::get<1>(params[i])))
                continue;
            LabelAnnotator vis{*this, std::get<1>(params[i])};
            const llvm::Value * param = std::get<0>(params[i]);
            if(const llvm::Instruction * inst = llvm::dyn_cast<llvm::Instruction>(param)) {
                assert( vis.visit( const_cast<llvm::Instruction*>(inst) ) );
            } else if(const llvm::GEPOperator * gep = llvm::dyn_cast<llvm::GEPOperator>(param)) {
                //assert(vis.visit(*gep));
                //TODO: get rid of that
                llvm::Value * ptr = const_cast<llvm::Value*>(gep->getPointerOperand());
                llvm::Value ** indices = new llvm::Value*[gep->getNumIndices()];
                auto it = gep->idx_begin();
                for(int i = 0; i < gep->getNumIndices(); ++i, ++it) {
                    indices[i] = llvm::dyn_cast<llvm::Value>(*it);
                    assert(indices[i]);
                }
                llvm::Value * value = builder.CreateGEP(ptr, llvm::makeArrayRef(indices, gep->getNumIndices()));
                delete[] indices;
                //for(const llvm::Value * use : gep->users()) {
                //    llvm::outs() << *gep << ' ' << *use << '\n';
                //    const llvm::Instruction * inst = llvm::dyn_cast<llvm::Instruction>(use);
                //    assert(inst);
                //    assert( vis.visit( const_cast<llvm::Instruction*>(inst) ) );
                //}
            } else
                assert(false);
            LabelAnnotator::annotated_params.insert(std::get<1>(params[i]));
        }
    }

    llvm::Instruction * Instrumenter::createGlobalStringPtr(const char * name, llvm::Instruction * placement)
    {
        llvm::Value * str = builder.CreateGlobalString(name, "");
        llvm::Value * zero = builder.getInt32(0);
        llvm::Value * indices[] = {zero, zero};
        return llvm::GetElementPtrInst::CreateInBounds(str, llvm::makeArrayRef(indices, 2), "", placement);
    }

    uint64_t InstrumenterVisiter::size_of(llvm::Value * val)
    {
        llvm::PointerType * ptr = llvm::dyn_cast<llvm::PointerType>(val->getType());
        assert(ptr);
        assert(layout);
        return layout->getTypeStoreSize(ptr->getPointerElementType());
    }

    void InstrumenterVisiter::visitLoadInst(llvm::LoadInst & load)
    {
        if(avoid_duplicates) {
            if(processed_loads.count(&load))
                return;
            processed_loads.insert(&load);
        }

        if(load.getType()->isPointerTy()) {
            instr.setInsertPoint(*load.getNextNode());
            uint64_t size = size_of(&load);
            load_function(size, &load);
        } else {
            // we perform verification close to the original load
            // branches 
            instr.setInsertPoint(load);
            uint64_t size = size_of(load.getPointerOperand());
            //instr.callCheckLabel(function_idx, size, load.getPointerOperand());
            load_function(size, load.getPointerOperand());
        }
    }

    llvm::Instruction * to_instr(llvm::Value * val)
    {
        return llvm::dyn_cast<llvm::Instruction>(val);
    }

    void InstrumenterVisiter::visitPHINode(llvm::PHINode & inst)
    {
        // Avoid cyclic references in loops
        if(phis.find(&inst) != phis.end())
            return;
        phis.insert(&inst);
        for(int i = 0; i < inst.getNumIncomingValues(); ++i) {
            if(llvm::Instruction * operand
                    = to_instr(inst.getIncomingValue(i)))
                visit(operand);
        }
        phis.erase(&inst);
    }

    void InstrumenterVisiter::visitCallInst(llvm::CallInst & inst)
    {
        processCall(&inst);
    }

    void InstrumenterVisiter::visitInvokeInst(llvm::InvokeInst & inst)
    {
        processCall(&inst);
    }

    void InstrumenterVisiter::processCall(llvm::CallBase * call)
    {
        if(avoid_duplicates) {
            if(processed_calls.count(call))
                return;
            processed_calls.insert(call);
        }
        label_function(call);
    }

    void InstrumenterVisiter::visitInstruction(llvm::Instruction & inst)
    {
        for(int i = 0; i < inst.getNumOperands(); ++i)
            if(llvm::Instruction * inst_new = llvm::dyn_cast<llvm::Instruction>(inst.getOperand(i)))
                visit(inst_new);
    }

    void Statistics::found_function()
    {
        functions_count++;
    }
    
    void Statistics::label_function(int labels)
    {
        functions_checked++;
        calls_to_check += labels;
    }

    void Statistics::empty_function()
    {
        empty_functions++;
    }

    void Statistics::print()
    {
        llvm::errs() << "Found internal functions: "
            << functions_count << '\n';
        llvm::errs() << "Skipped functions without loops: "
            << empty_functions << '\n';
        llvm::errs() << "Instrumented internal functions: "
            << functions_checked << '\n';
        llvm::errs() << "Average # of labels: "
            << double(calls_to_check) / functions_checked << '\n';
    }

    FileIndex::iterator FileIndex::begin()
    {
        return index.begin();
    }
    
    FileIndex::iterator FileIndex::end()
    {
        return index.end();
    }

    void FileIndex::import(llvm::Module & m, DebugInfo & info)
    {
        int idx = 0;
        info.getTranslationUnits(m,
            [this, &idx](const llvm::StringRef & dir,
                        const llvm::StringRef & name) {
                index[name] = std::make_tuple(idx++, dir);
            }
        );
    }
        
    int FileIndex::getIdx(llvm::StringRef & name)
    {
        auto it = index.find(name);
        if(it != index.end())
            return std::get<0>((*it).second);
        else
            return -1;
    }

    bool LabelAnnotator::visitLoadInst(llvm::LoadInst & load)
    {
        instr.builder.SetInsertPoint(load.getNextNode());
        //TODO: param names
        //TODO: size from load
        //TODO: correct offset
        instr.callSetLabel(param_idx, "param", 4, load.getPointerOperand());
        return true;
    }
    
    bool LabelAnnotator::visitAllocaInst(llvm::AllocaInst & alloca)
    {
        instr.builder.SetInsertPoint(alloca.getNextNode());
        //TODO: param names
        //TODO: size from load
        //TODO: correct offset
        instr.callSetLabel(param_idx, "param", 4, &alloca);
        return true;
    }
    
    bool LabelAnnotator::visitInstruction(llvm::Instruction & inst)
    {
        bool ret = false;
        for(int i = 0; i < inst.getNumOperands(); ++i)
            if(llvm::Instruction * inst_new = llvm::dyn_cast<llvm::Instruction>(inst.getOperand(i)))
                ret |= visit(inst_new);
        return ret;
    }
        
    bool LabelAnnotator::visitGetElementPtrInst(llvm::GetElementPtrInst & gepinst)
    {
        instr.builder.SetInsertPoint(gepinst.getNextNode());
        //TODO: param names
        //TODO: size from load
        //TODO: correct offset
        instr.callSetLabel(param_idx, "param", 4, &gepinst);
        return true;
    }
    
    bool LabelAnnotator::visitBitCastInst(llvm::BitCastInst & cast)
    {
        instr.builder.SetInsertPoint(cast.getNextNode());
        if(!llvm::isa<llvm::Instruction>(cast.getOperand(0))) {
            llvm::GEPOperator * gep = llvm::dyn_cast<llvm::GEPOperator>(cast.getOperand(0));
            assert(gep);
            llvm::SmallVector<llvm::Value*, 5> indices;
            for(auto it = gep->idx_begin(), end = gep->idx_end(); it != end; ++it)
                indices.push_back(*it );
            llvm::Value * new_gep = llvm::GetElementPtrInst::CreateInBounds(
                    gep->getPointerOperand(),
                    llvm::makeArrayRef(indices.data(), indices.size()),
                    "", &cast);
            instr.callSetLabel(param_idx, "param", 4, new_gep);
        } else
            instr.callSetLabel(param_idx, "param", 4, cast.getOperand(0));
        return true;
    }

    bool LabelAnnotator::visited(Parameters::id_t id)
    {
        return annotated_params.find(id) != annotated_params.end();
    }
}

char extrap::DfsanInstr::ID = 0;
static llvm::RegisterPass<extrap::DfsanInstr> register_pass(
    "extrap-extractor",
    "Extract loop information",
    true /* Only looks at CFG */,
    false /* Analysis Pass */);

// Allow running dynamically through frontend such as Clang
void addDfsanInstr(const llvm::PassManagerBuilder &Builder,
                        llvm::legacy::PassManagerBase &PM) {
  PM.add(new extrap::DfsanInstr());
}

// run after optimizations
llvm::RegisterStandardPasses SOpt(llvm::PassManagerBuilder::EP_OptimizerLast,
                            addDfsanInstr);

