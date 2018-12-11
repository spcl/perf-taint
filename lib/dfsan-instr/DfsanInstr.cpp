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
#include <llvm/Transforms/IPO/PassManagerBuilder.h>
#include <llvm/Transforms/Scalar.h>
#include <llvm/Transforms/Utils.h>

#include <polly/PolySCEV.h>

#include <iostream>
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
        AU.addRequiredTransitive<llvm::LoopInfoWrapperPass>();
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
        Instrumenter instr(m);
        instr.createGlobalStorage(instrumented_functions.begin(), instrumented_functions.end());
        instr.initialize(main);
        //instr.annotateParams(found_params);
        size_t params_count = Parameters::globals_names.size() + Parameters::local_names.size();
        for(auto & f : instrumented_functions)
        {
            modifyFunction(*f.first, f.second, instr);
        }

        return false;
    }

    void DfsanInstr::runOnFunction(llvm::Function & f)
    {
        // ignore declarations
        if(!is_analyzable(*m, f))
            return;
        llvm::CallGraphNode * f_node = (*cgraph)[&f];
        ParameterFinder finder(f);
        FunctionParameters parameters = finder.find_args();
        for(auto & param : parameters.locals) {
            found_params.push_back(param);
        }
        instrumented_functions.insert( std::make_pair(&f, instrumented_functions.size()) );
        
        for(auto & callsite : *f_node)
        {
            llvm::CallGraphNode * node = callsite.second;
            llvm::Function * called_f = node->getFunction();
            llvm::Value * call = callsite.first;
            runOnFunction(*called_f);
        }
    }
    
    void DfsanInstr::modifyFunction(llvm::Function & f, int idx, Instrumenter & instr)
    {
        for(auto i = llvm::inst_begin(&f), end = llvm::inst_end(&f); i != end; ++i)
        {
            if(llvm::BranchInst * br = llvm::dyn_cast<llvm::BranchInst>(&*i)) {
                if(br->isConditional()) {
                    // insert the check for labels
                    instr.checkLabel(idx, br);
                }
            } 
        }
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

    template<typename FuncIter>
    void Instrumenter::createGlobalStorage(FuncIter begin, FuncIter end)
    {
        functions_count = std::distance(begin, end);
        params_count = Parameters::parameters_count();

        // count of functions, count of params
        llvm::Type * llvm_int_type = builder.getInt32Ty();
        glob_funcs_count = new llvm::GlobalVariable(m, llvm_int_type, false,
                llvm::GlobalValue::WeakAnyLinkage,
                builder.getInt32(functions_count),
                glob_funcs_count_name);
        glob_params_count = new llvm::GlobalVariable(m, llvm_int_type, false,
                llvm::GlobalValue::WeakAnyLinkage,
                builder.getInt32(params_count),
                glob_params_count_name); 

        // function names
        llvm::ArrayType * array_type = llvm::ArrayType::get(
                    builder.getInt8PtrTy(),
                    functions_count
                );
        DebugInfo info;
        std::vector<llvm::Constant*> function_names(functions_count);
        // dummy insert since we only create global variables
        // but IRBuilder uses BB to determine the module
        // insert into first BB of first function
        builder.SetInsertPoint( &*(m.begin()->begin()) );
        for(; begin != end; ++begin) {
            llvm::StringRef name = info.getFunctionName( *(*begin).first );
            llvm::Constant * fname = builder.CreateGlobalStringPtr(name);
            function_names[ (*begin).second ] = fname;
        }
        glob_funcs_names = new llvm::GlobalVariable(m,
                array_type,
                false,
                llvm::GlobalValue::WeakAnyLinkage,
                llvm::ConstantArray::get(array_type, function_names),
                glob_funcs_names_name);

        // global int16_t instrumentation_labels[] = {0..}
        array_type = llvm::ArrayType::get(builder.getInt16Ty(), params_count);
        std::vector<llvm::Constant*> labels;
        for(int i = 0; i < params_count; ++i)
            labels.push_back( builder.getInt16(0));
        glob_labels = new llvm::GlobalVariable(m,
                array_type,
                false,
                llvm::GlobalValue::WeakAnyLinkage,
                llvm::ConstantArray::get(array_type, labels),
                glob_labels_name);

        array_type = llvm::ArrayType::get(builder.getInt32Ty(), params_count * functions_count);
        std::vector<llvm::Constant*> V;
        for(int i = 0; i < params_count*functions_count; ++i)
            V.push_back( builder.getInt32(0));
        glob_result_array = new llvm::GlobalVariable(m, array_type, false, llvm::GlobalValue::WeakAnyLinkage,
                llvm::ConstantArray::get(array_type, V), glob_result_array_name); 
    }
    
    void Instrumenter::checkLabel(int function_idx, llvm::BranchInst * br)
    {
        assert(glob_result_array);
        // insert call before branch
        builder.SetInsertPoint( br->getPrevNode() );
        InstrumenterVisiter vis{*this, function_idx};
        const llvm::Instruction * inst = llvm::dyn_cast<llvm::Instruction>(br->getCondition());
        assert(inst);
        // TODO: why instvisit is not for const instruction?
        vis.visit( const_cast<llvm::Instruction*>(inst) );
    }
    
    void Instrumenter::callCheckLabel(int function_idx, size_t size, llvm::Value * operand)
    {
        llvm::Value * cast = builder.CreatePointerCast(operand, builder.getInt8PtrTy());
        builder.CreateCall(load_function, {cast, builder.getInt32(size), builder.getInt32(function_idx) });
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
        //llvm::outs() << *name << '\n';
        //llvm::outs() << *name->getType() << '\n';
        //llvm::Value * gep = builder.CreateConstGEP1_32(glob_labels, 0, "param");
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
        llvm::FunctionType * func_t = llvm::FunctionType::get(void_t, {int8_ptr, idx_t, idx_t}, false);
        m.getOrInsertFunction("__dfsw_EXTRAP_CHECK_LABEL", func_t);
        load_function = m.getFunction("__dfsw_EXTRAP_CHECK_LABEL");
        assert(load_function);

        func_t = llvm::FunctionType::get(void_t, {int8_ptr, idx_t, idx_t, int8_ptr}, false);
        m.getOrInsertFunction("__dfsw_EXTRAP_STORE_LABEL", func_t);
        store_function = m.getFunction("__dfsw_EXTRAP_STORE_LABEL");
        assert(store_function);

        func_t = llvm::FunctionType::get(void_t, {}, false);
        m.getOrInsertFunction("__dfsw_EXTRAP_AT_EXIT", func_t);
        at_exit_function = m.getFunction("__dfsw_EXTRAP_AT_EXIT");
        assert(at_exit_function);
    } 

    // polly lib/CodeGen/PerfMonitor.cpp
    llvm::Function * Instrumenter::getAtExit()
    {
        llvm::Function * f = m.getFunction("atexit");
        if(!f) {
            llvm::GlobalValue::LinkageTypes linkage = llvm::GlobalValue::ExternalLinkage;
            llvm::FunctionType * f_type = llvm::FunctionType::get(
                    builder.getInt32Ty(),
                    {builder.getInt8PtrTy()}, false
                );
            f = llvm::Function::Create(f_type, linkage, "atexit", m);
        }
        return f;
    }

    void Instrumenter::initialize(llvm::Function * main)
    {
        builder.SetInsertPoint(main->getEntryBlock().getTerminator()->getPrevNode());
        llvm::Value * cast_f = builder.CreatePointerCast(at_exit_function, builder.getInt8PtrTy());
        builder.CreateCall(getAtExit(), {cast_f});
    }
        
    void Instrumenter::annotateParams(const std::vector< std::tuple<const llvm::Value *, Parameters::id_t> > & params)
    {
        assert(glob_labels);
        for(int i = 0; i < params.size(); ++i) {
            if(LabelAnnotator::visited(std::get<1>(params[i])))
                continue;
            LabelAnnotator vis{*this, std::get<1>(params[i])};
            llvm::outs() << std::get<1>(params[i]) << ' ' << *std::get<0>(params[i]) << '\n';
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
                //llvm::outs() << *gep << ' ' << *ptr << ' ' << llvm::dyn_cast<llvm::Value>((*gep->idx_begin())) << '\n';
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
        if(processed_loads.count(&load))
            return;
        processed_loads.insert(&load);

        uint64_t size = size_of(load.getPointerOperand());
        instr.callCheckLabel(function_idx, size, load.getPointerOperand());
    }
    
    void InstrumenterVisiter::visitInstruction(llvm::Instruction & inst)
    {
        for(int i = 0; i < inst.getNumOperands(); ++i)
            if(llvm::Instruction * inst_new = llvm::dyn_cast<llvm::Instruction>(inst.getOperand(i)))
                visit(inst_new);
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
        llvm::outs() << *cast.getOperand(0) << ' ' << llvm::isa<llvm::Instruction>(cast.getOperand(0)) << '\n';
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

