
#include <perf-taint/llvm-pass/PerfTaintPass.hpp>
#include <perf-taint/llvm-pass/Instrumenter.hpp>

#include <string>
#include <cxxabi.h>

namespace perf_taint {

  void Instrumenter::writeParameter(llvm::Instruction * instr,
      llvm::Value * dest, int parameter_idx)
  {
    builder.SetInsertPoint(instr->getNextNode());
    llvm::Value* casted = builder.CreatePointerCast(dest, builder.getInt8PtrTy());
    builder.CreateCall(write_parameter_function,
    {
      casted,
      builder.getInt32(size_of(dest)),
      builder.getInt32(parameter_idx)
    });
  }

  void Instrumenter::callImplicitLoop(ImplicitCall & call, int func_idx,
          int called_func_idx, int loop_idx, int nested_loop_idx)
  {
    // TODO: nested calls as well
    builder.SetInsertPoint(call.call);
    for(int arg : call.args) {
      if(arg >= 0) {
        builder.CreateCall(mark_implicit_label,
          {
            builder.getInt16(func_idx),
            builder.getInt16(nested_loop_idx),
            builder.getInt16(arg)
          }
        );
      } else {
        int arg_pos = -arg - 1;
        llvm::Value * label = getLabel(call.call->getArgOperand(arg_pos));
        builder.CreateCall(label_loop_function,
          {
            label,
            builder.getInt32(nested_loop_idx),
            builder.getInt32(func_idx)
          }
        );
      }
    }
    builder.CreateCall(call_implicit_function,
      {
        builder.getInt32(called_func_idx),
        builder.getInt32(func_idx),
        builder.getInt16(loop_idx),
        builder.getInt32(nested_loop_idx)
      }
    );
  }

  void Instrumenter::checkLoop(int nested_loop_idx, int function_idx,
          llvm::Instruction * inst)
  {
    llvm::Instruction * insert_point = inst->getNextNode();
    while(llvm::isa<llvm::PHINode>(insert_point))
      insert_point = insert_point->getNextNode();
    builder.SetInsertPoint(insert_point);
    llvm::Value * label = getLabel(inst);
    builder.CreateCall(label_loop_function,
      {
        label,
        builder.getInt32(nested_loop_idx),
        builder.getInt32(function_idx)
      }
    );
  }

  void Instrumenter::checkLoopLoad(int nested_loop_idx, int function_idx,
          size_t size, llvm::Value * operand)
  {
    llvm::Value * cast = builder.CreatePointerCast(operand, builder.getInt8PtrTy());
    builder.CreateCall(load_loop_function, {
        cast, builder.getInt32(size),
        builder.getInt32(nested_loop_idx),
        builder.getInt32(function_idx)
    });
  }

  void Instrumenter::checkLoopRetval(int nested_loop_idx,
          int function_idx, llvm::CallBase * call)
  {
    llvm::Value * load_tls = builder.CreateLoad(glob_retval_tls);
    llvm::Instruction * ptr =  builder.CreateCall(label_loop_function, {
        load_tls, builder.getInt32(nested_loop_idx),
        builder.getInt32(function_idx)
    });
  }

  void Instrumenter::checkCF(int function_idx, llvm::BranchInst * br)
  {
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

  llvm::Value * Instrumenter::getLabel(llvm::Value * val)
  {
    if(val->getType()->isIntegerTy()) {
      llvm::Value * input = builder.CreateZExtOrTrunc(
        val,
        builder.getInt64Ty()
      );
      return builder.CreateCall(dfsan_get_label, {input});
    } else
      throw std::runtime_error("unimplemented");
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

  //void Instrumenter::commitLoop(llvm::Loop & l, int func_idx, int loop_idx)
  //{
  //  llvm::SmallVector<llvm::BasicBlock*, 5> exit_blocks;
  //  l.getExitBlocks(exit_blocks);
  //  for(llvm::BasicBlock * bb : exit_blocks) {
  //    builder.SetInsertPoint(&bb->front());
  //    builder.CreateCall(commit_loop_function,
  //      {builder.getInt32(func_idx)}
  //    );
  //  }
  //}

  void Instrumenter::commitLoops(llvm::Function & f, int func_idx, int calls_count)
  {
    llvm::SmallVector<llvm::ReturnInst*, 5> returns;
    findTerminator(f, returns);
    for(llvm::ReturnInst * ret : returns) {
      builder.SetInsertPoint(ret);
      builder.CreateCall(commit_loop_function,
        {builder.getInt32(func_idx), builder.getInt32(calls_count)}
      );
    }
  }

  llvm::Instruction * Instrumenter::instrumentLoopCall(llvm::Function & f,
      llvm::CallBase * call, int16_t nested_loop_idx, uint16_t loop_size,
      llvm::Instruction * insert_place)
  {
    if(insert_place)
      builder.SetInsertPoint(insert_place);
    else
      builder.SetInsertPoint(&f.front().front());
    llvm::Instruction * idx = builder.CreateCall(register_call_function,
        {builder.getInt16(nested_loop_idx), builder.getInt16(loop_size)}
    );
    // just before the call
    builder.SetInsertPoint(call);
    builder.CreateCall(set_current_call_function, {idx});
    return idx;
  }

  void Instrumenter::removeLoopCalls(llvm::Function & f, size_t size)
  {
    llvm::SmallVector<llvm::ReturnInst*, 5> returns;
    findTerminator(f, returns);
    for(llvm::ReturnInst * ret : returns) {
        builder.SetInsertPoint(ret);
        builder.CreateCall(remove_calls_function, {builder.getInt16(size)});
    }
  }

  void Instrumenter::findTerminator(llvm::Function & f, llvm::SmallVector<llvm::ReturnInst*, 5> & returns)
  {
    bool found_unreachable = false;
    for(llvm::BasicBlock & bb : f) {
      llvm::Instruction * instr = bb.getTerminator();
      if(llvm::ReturnInst * ret = llvm::dyn_cast<llvm::ReturnInst>(instr)) {
        returns.push_back(ret);
      } else if(llvm::UnreachableInst * unreachable = llvm::dyn_cast<llvm::UnreachableInst>(instr))
        found_unreachable = true;
    }
    // TODO: more generic solution where there are unreachable blocks
    assert(found_unreachable || returns.size());
  }

  void Instrumenter::saveCurrentCall(llvm::Function & f)
  {
    builder.SetInsertPoint(&f.front().front());
    llvm::Value * last_val = builder.CreateCall(
      get_current_call_function,
      {}
    );
    llvm::SmallVector<llvm::ReturnInst*, 5> returns;
    findTerminator(f, returns);
    for(llvm::ReturnInst * ret : returns) {
      builder.SetInsertPoint(ret);
      builder.CreateCall(set_current_call_function, {last_val});
    }
  }

  void Instrumenter::declareFunctions()
  {
    llvm::Type * void_t = builder.getVoidTy();
    llvm::Type * int8_ptr = builder.getInt8PtrTy();
    llvm::Type * idx_t = builder.getInt32Ty();
    llvm::Type * i16_t = builder.getInt16Ty();
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
    func_t = llvm::FunctionType::get(i16_t, {builder.getInt64Ty()}, false);
    m.getOrInsertFunction("dfsan_get_label", func_t);
    dfsan_get_label = m.getFunction("dfsan_get_label");
    assert(dfsan_get_label);

    // void store_label(int8_t *, int32_t, int32_t, int8_t*)
    func_t = llvm::FunctionType::get(void_t,
            {int8_ptr, idx_t, idx_t, int8_ptr}, false);
    m.getOrInsertFunction("__dfsw_EXTRAP_STORE_LABEL", func_t);
    store_function = m.getFunction("__dfsw_EXTRAP_STORE_LABEL");
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

    // void __EXTRAP_CHECK_LABEL(label, loop_idx, func_idx)
    func_t = llvm::FunctionType::get(void_t,
            {builder.getInt16Ty(), idx_t, idx_t}, false);
    m.getOrInsertFunction("__dfsw_EXTRAP_CHECK_LABEL", func_t);
    label_loop_function = m.getFunction("__dfsw_EXTRAP_CHECK_LABEL");

    // __EXTRAP_CHECK_LOAD(addr, size, loop_idx, func_idx)
    func_t = llvm::FunctionType::get(void_t,
            {int8_ptr, idx_t, idx_t, idx_t}, false);
    m.getOrInsertFunction("__dfsw_EXTRAP_CHECK_LOAD", func_t);
    load_loop_function = m.getFunction("__dfsw_EXTRAP_CHECK_LOAD");

    // __EXTRAP_COMMIT_LOOP(loop_idx, function_idx, calls_count)
    func_t = llvm::FunctionType::get(void_t, {idx_t, idx_t}, false);
    m.getOrInsertFunction("__dfsw_EXTRAP_COMMIT_LOOP", func_t);
    commit_loop_function = m.getFunction("__dfsw_EXTRAP_COMMIT_LOOP");
    assert(commit_loop_function);

    // __dfsw_EXTRAP_PUSH_CALL_FUNCTION(idx)
    func_t = llvm::FunctionType::get(void_t,
            {i16_t}, false);
    m.getOrInsertFunction("__dfsw_EXTRAP_PUSH_CALL_FUNCTION", func_t);
    push_function = m.getFunction("__dfsw_EXTRAP_PUSH_CALL_FUNCTION");
    assert(push_function);

    // __dfsw_EXTRAP_POP_CALL_FUNCTION
    func_t = llvm::FunctionType::get(void_t, {i16_t}, false);
    m.getOrInsertFunction("__dfsw_EXTRAP_POP_CALL_FUNCTION", func_t);
    pop_function = m.getFunction("__dfsw_EXTRAP_POP_CALL_FUNCTION");
    assert(pop_function);

    // uint16_t __dfsw_EXTRAP_REGISTER_CALL(uint16_t, uint16_t);
    func_t = llvm::FunctionType::get(i16_t, {i16_t, i16_t}, false);
    m.getOrInsertFunction("__dfsw_EXTRAP_REGISTER_CALL", func_t);
    register_call_function = m.getFunction("__dfsw_EXTRAP_REGISTER_CALL");
    assert(register_call_function);

    // void __dfsw_EXTRAP_REMOVE_CALLS(uint16_t)
    func_t = llvm::FunctionType::get(void_t, {i16_t}, false);
    m.getOrInsertFunction("__dfsw_EXTRAP_REMOVE_CALLS", func_t);
    remove_calls_function = m.getFunction("__dfsw_EXTRAP_REMOVE_CALLS");
    assert(remove_calls_function);

    // void __dfsw_EXTRAP_SET_CURRENT_CALL(int16_t)
    func_t = llvm::FunctionType::get(void_t, {i16_t}, false);
    m.getOrInsertFunction("__dfsw_EXTRAP_SET_CURRENT_CALL", func_t);
    set_current_call_function = m.getFunction("__dfsw_EXTRAP_SET_CURRENT_CALL");
    assert(set_current_call_function);

    // int16_t __dfsw_EXTRAP_CURRENT_CALL()
    func_t = llvm::FunctionType::get(i16_t, {}, false);
    m.getOrInsertFunction("__dfsw_EXTRAP_CURRENT_CALL", func_t);
    get_current_call_function = m.getFunction("__dfsw_EXTRAP_CURRENT_CALL");
    assert(get_current_call_function);

    // void __dfsw_EXTRAP_INIT_MPI
    func_t = llvm::FunctionType::get(void_t, {}, false);
    m.getOrInsertFunction("__dfsw_EXTRAP_INIT_MPI", func_t);
    init_mpi_function = m.getFunction("__dfsw_EXTRAP_INIT_MPI");
    assert(init_mpi_function);

    // void __dfsw_EXTRAP_MARK_IMPLICIT_LABEL(uint16_t, uint16_t, uint16_t)
    func_t = llvm::FunctionType::get(void_t, {i16_t, i16_t, i16_t}, false);
    m.getOrInsertFunction("__dfsw_EXTRAP_MARK_IMPLICIT_LABEL", func_t);
    mark_implicit_label = m.getFunction("__dfsw_EXTRAP_MARK_IMPLICIT_LABEL");
    assert(mark_implicit_label);

    // void __dfsw_EXTRAP_CALL_IMPLICIT_FUNCTION(int, int, uint16_t, int)
    func_t = llvm::FunctionType::get(void_t, {idx_t,idx_t, i16_t,idx_t}, false);
    m.getOrInsertFunction("__dfsw_EXTRAP_CALL_IMPLICIT_FUNCTION", func_t);
    call_implicit_function = m.getFunction("__dfsw_EXTRAP_CALL_IMPLICIT_FUNCTION");
    assert(call_implicit_function);

    // void __dfsw_EXTRAP_WRITE_PARAMETER(int8_t *, size_t, int32_t)
    func_t = llvm::FunctionType::get(void_t, {int8_ptr, idx_t, idx_t}, false);
    m.getOrInsertFunction("__dfsw_EXTRAP_WRITE_PARAMETER", func_t);
    write_parameter_function = m.getFunction("__dfsw_EXTRAP_WRITE_PARAMETER");
    assert(write_parameter_function);
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

  void Instrumenter::enterFunction(llvm::Function & f, Function & func)
  {
    enterFunction(f, func.function_idx());
  }

  void Instrumenter::enterFunction(llvm::Function & f, size_t idx)
  {
    builder.SetInsertPoint(&f.front().front());
    builder.CreateCall(push_function,
            { builder.getInt16(idx) });
    llvm::SmallVector<llvm::ReturnInst*, 5> returns;
    findTerminator(f, returns);
    for(llvm::ReturnInst * ret : returns) {
      builder.SetInsertPoint(ret);
      builder.CreateCall(pop_function, {builder.getInt16(idx)});
    }
  }

  void Instrumenter::setInsertPoint(llvm::Instruction & instr)
  {
    builder.SetInsertPoint(&instr);
  }
 
  //TODO: make library dependent 
  void Instrumenter::initialize_MPI(llvm::Function * main)
  {
    // TODO: make it work outside of main
    for(llvm::BasicBlock & bb : *main) {
      for(llvm::Instruction & instr : bb) {
        if(llvm::CallBase * call =
                llvm::dyn_cast<llvm::CallBase>(&instr)) {
            if(llvm::Function * f = call->getCalledFunction()) {
                llvm::StringRef name = f->getName();
              if(name == "MPI_Init" || name == "MPI_Init_thread") {
                builder.SetInsertPoint(instr.getNextNode());
                builder.CreateCall(init_mpi_function);
              }
            }
          }
      }
    }
  }

  void Instrumenter::initialize(llvm::Function * main)
  {
    //builder.SetInsertPoint(main->getEntryBlock().getTerminator()->getPrevNode());
    builder.SetInsertPoint( &(*main->getEntryBlock().begin()) );
    llvm::Value * cast_f = builder.CreatePointerCast(at_exit_function, builder.getInt8PtrTy());
    builder.CreateCall(getAtExit(), {cast_f});
    builder.CreateCall(init_function);
  }

  llvm::Instruction * Instrumenter::createGlobalStringPtr(const char * name, llvm::Instruction * placement)
  {
    llvm::Value * str = builder.CreateGlobalString(name, "");
    llvm::Value * zero = builder.getInt32(0);
    llvm::Value * indices[] = {zero, zero};
    return llvm::GetElementPtrInst::CreateInBounds(str, llvm::makeArrayRef(indices, 2), "", placement);
  }

  uint64_t Instrumenter::size_of(llvm::Value * val)
  {
    llvm::PointerType * ptr = llvm::dyn_cast<llvm::PointerType>(val->getType());
    assert(ptr);
    assert(layout);
    return layout->getTypeStoreSize(ptr->getPointerElementType());
  }

  LoopStructure Instrumenter::instrumentLoop(Function & func, const Loop & l,
    int nested_loop_idx, FunctionCalls & calls)
  {
    typedef std::vector<const Loop*> loops_t;
    loops_t buf_first{1, &l}, buf_second;

    loops_t * cur_loops = &buf_first, * next_loops = &buf_second;
    int internal_nested_index = 0;
    LoopStructure ret = l.analyze();

    while(!cur_loops->empty()) {

      for(const Loop * l : *cur_loops) {

        const std::vector<Loop> & subloops = l->subloops();
        llvm::SmallSet<llvm::BasicBlock*, 20> subloops_bb;
        for(const Loop & subloop : subloops) {
          for(llvm::BasicBlock * bb : subloop.blocks())
            subloops_bb.insert(bb);
        }

        int calls_count = 0;
        for(llvm::BasicBlock * bb : l->blocks()) {
          // loop basic block that is not a part of subloop
          if(!subloops_bb.count(bb)) {
            for(llvm::Instruction & inst : *bb) {
              // call!
              if(llvm::CallBase * call =
                    llvm::dyn_cast<llvm::CallBase>(&inst)) {
                if(pass.callsImportantFunction(call)) {
                  // TODO: optimize by checking if this call could
                  // produce any loop - in case we know function
                  calls.calls.emplace_back(call, nested_loop_idx,
                    subloops.size() + calls_count++);
                }
              }
            }
          }
        }

        for(llvm::BasicBlock * bb : l->exit_blocks()) {
          llvm::Instruction * inst = bb->getTerminator();
          const llvm::BranchInst * br = llvm::dyn_cast<llvm::BranchInst>(inst);
          if(br && br->isConditional()) {
            llvm::Instruction * inst =
                llvm::dyn_cast<llvm::Instruction>(br->getCondition());
            assert(inst);
            checkLoop(nested_loop_idx, func.function_idx(), inst);
          } else if(const llvm::SwitchInst * _switch = llvm::dyn_cast<llvm::SwitchInst>(inst)) {
            llvm::Instruction * inst =
                llvm::dyn_cast<llvm::Instruction>(_switch->getCondition());
            assert(inst);
            checkLoop(nested_loop_idx, func.function_idx(), inst);
          } else if(const llvm::InvokeInst * invoke = llvm::dyn_cast<llvm::InvokeInst>(inst)) {
              // ignore the exception control flow outside of the loop
              //const llvm::InvokeInst * invoke = llvm::dyn_cast<llvm::InvokeInst>(inst);
          } else {
            llvm::errs() << "Unknown branch: " << *inst << '\n';
          }
        }
        nested_loop_idx++;
        internal_nested_index++;
        // add adresses of subloops to next iteration storage
        std::transform(
            subloops.begin(),
            subloops.end(),
            std::back_inserter(*next_loops),
            [](const Loop & l) { return &l; }
        );
      }
      std::swap(cur_loops, next_loops);
      next_loops->clear();
    }
    return ret;
  }

  std::string Instrumenter::demangle(llvm::StringRef name)
  {
    int status = 0;
    char * demangled_name =
        abi::__cxa_demangle(name.data(), 0, 0, &status);
    std::string str_name;
    if(status == 0)
      str_name = demangled_name;
    else if(status == -2)
      str_name = name;
    else
      assert(false);
    free( static_cast<void*>(demangled_name) );
    return str_name;
  }

  void InstrumenterVisiter::visitLoadInst(llvm::LoadInst & load)
  {
    if(avoid_duplicates) {
      if(processed_loads.count(&load))
        return;
      processed_loads.insert(&load);
    }
    // we perform verification close to the original load
    // branches
    instr.setInsertPoint(load);
    uint64_t size = instr.size_of(load.getPointerOperand());
    load_function(size, load.getPointerOperand());
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
    instr.setInsertPoint(*call);
    label_function(call);
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

