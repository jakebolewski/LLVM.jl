module FFI

import ..libllvm, ..libllvmgeneral, ..Opcode
using ..Types

typealias TargetOptionFlag Cint
typealias MemoryOrdering   Cint
typealias RMWOperation     Cint
typealias ICmpPredicate    Cint
typealias FastMathFlags    Cint
typealias FloatSemantics   Cint
typealias CPPOpcode        Cint
typealias Linkage          Cint
typealias Visibility       Cint
typealias CallingCov       Cint
typealias FunctionAttr     Cint
typealias ParamAttr        Cuint
typealias COpcode          Cuint
typealias MDKindID         Cint
typealias FloatABIType     Cint
typealias FPOpFusionMode   Cint
typealias LibFunc          Cint
typealias CodeGenFileType  Cint
typealias RelocModel       Cint
typealias CodeModel        Cint
typealias CodeGenOptLevel  Cint
typealias DiagnosticKind   Cint
typealias LLVMOpcode       Cint

# deal with LLVM's linked list structures
list{T<:Types.LLVMPtr}(::Type{T}, first::T, next::Function) = begin
    isnull(first) && return T[]
    lst = T[first]
    while true
        nxt = next(first)::T
        isnull(nxt) && break
        push!(lst, nxt)
        first = nxt
    end
    return lst 
end

dispose_message(msg::Ptr{Uint8}) = 
    ccall((:LLVMDisposeMessage, libllvm), Void, (Ptr{Uint8},), msg)

#------------------------------------------------------------------------------
# Analysis 
#------------------------------------------------------------------------------
verify_module(mod, on_failure_cfunc, str) = 
    bool(ccall((:LLVMVerifyModule, libllvm), LLVMBool, 
               (ModulePtr, Ptr{Void}, Ptr{Uint8}), mod, on_failure_cfunc, str))

#------------------------------------------------------------------------------
# Assembly 
#------------------------------------------------------------------------------

# Use LLVM's parser to parse a string of llvm assembly in a memory buffer to get a module
parse_llvm_assembly(ctx, buff, diag) = 
    ccall((:LLVM_General_ParseLLVMAssembly, libllvmgeneral), ModulePtr,
          (ContextPtr, MemoryBufferPtr, SMDiagnosticPtr), ctx, buff, diag)

# Use LLVM's serializer to generate a string of llvm assembly from a module 
write_llvm_assembly(io, mod) = 
    ccall((:LLVM_General_WriteLLVMAssembly, libllvmgeneral), Void,
          (ModulePtr, RawOStreamPtr), mod, io)

#------------------------------------------------------------------------------
# Basic Block 
#------------------------------------------------------------------------------

# http://llvm.org/doxygen/group__LLVMCCoreValueBasicBlock.html#gab57c996ff697ef40966432055ae47a4e
isa_basicblock(val) =
    ccall((:LLVMIsABasicBlock, libllvm), BasicBlockPtr, (ValuePtr,), val) 

# http://llvm.org/doxygen/group__LLVMCCoreValueBasicBlock.html#ga754e45f69f4b784b658d9e379943f354
get_basicblock_terminator(bb) =
    ccall((:LLVMGetBasicBlockTerminator, libllvm), InstructionPtr, (BasicBlockPtr,), bb)

# http://llvm.org/doxygen/group__LLVMCCoreValueBasicBlock.html#ga9baf824cd325ad211027b23fce8a7494
get_first_instruction(bb) =
    ccall((:LLVMGetFirstInstruction, libllvm), InstructionPtr, (BasicBlockPtr,), bb)

# http://llvm.org/doxygen/group__LLVMCCoreValueBasicBlock.html#gaa0bb2c95802d06bf94f4c55e61fc3477
get_last_instruction(bb) =
    ccall((:LLVMGetLastInstruction, libllvm), InstructionPtr, (BasicBlockPtr,), bb)

# http://llvm.org/doxygen/group__LLVMCCoreValueInstruction.html#ga1b4c3bd197e86e8bffdda247ddf8ec5e
get_next_instruction(instr) =
    ccall((:LLVMGetNextInstruction, libllvm), InstructionPtr, (InstructionPtr,), instr)

#------------------------------------------------------------------------------
# Binary Operator
#------------------------------------------------------------------------------
is_binary_op(val) =
    ccall((:LLVMIsABinaryOperator, libllvm), BinaryOpPtr, (ValuePtr,), val)

no_signed_wrap(val) =
    bool(ccall((:LLVM_General_HasNoSignedWrap, libllvmgeneral), LLVMBool, (ValuePtr,), val))

no_unsigned_wrap(val) =
    bool(ccall((:LLVM_General_HasNoUnsignedWrap, libllvmgeneral), LLVMBool, (ValuePtr,), val))

is_exact(val) =
    bool(ccall((:LLVM_General_IsExact, libllvmgeneral), LLVMBool, (ValuePtr,), val))

get_fast_math_flags(val) =
    ccall((:LLVM_General_GetFastMathFlags, libllvmgeneral), Cuint, (ValuePtr,), val)

#------------------------------------------------------------------------------
# BitCode 
#------------------------------------------------------------------------------
parse_llvm_bitcode(ctx, membuf, modptr, out) = 
    ccall((:LLVMParseBicodeInContext, libllvm), LLVMBool,
          (ContextPtr, MemoryBufferPtr, Ptr{ModulePtr}, Ptr{Ptr{Uint8}}),
          ctx, membuf, modptr, out)

write_llvm_bitcode_file(mod, path) =
    ccall((:LLVMWriteBitcodeToFile, libllvm), LLVMBool,
          (ModulePtr, Ptr{Uint8}), mod, path)

write_llvm_bitcode(io, mod) = 
    ccall((:LLVM_General_WriteBitcode, libllvmgeneral), Void,
          (ModulePtr, RawOStreamPtr), mod, io)

#------------------------------------------------------------------------------
# Builder 
#------------------------------------------------------------------------------
create_builder_in_ctx(ctx) =
    ccall((:LLVMCreateBuilderInContext, libllvm), BuilderPtr, (ContextPtr,), ctx) 

dispose_builder(bld) =
    ccall((:LLVMDisposeBuilder, libllvm), Void, (BuilderPtr,), bld)

position_builder_end(bld, bb) = 
    ccall((:LLVMPositionBuilderAtEnd, libllvm), Void, 
          (BuilderPtr, BasicBlockPtr), bld, bb) 

build_ret_void(bld) =
    ccall((:LLVMBuildRetVoid, libllvm), InstructionPtr,
          (BuilderPtr,), bld)

build_ret(bld, val) = 
    ccall((:LLVMBuildRet, libllvm), InstructionPtr,
          (BuilderPtr, ValuePtr), bld, val)

build_br(bld, bb) = 
    ccall((:LLVMBuildCondBr, libllvm), InstructionPtr, 
          (BuilderPtr, BasicBlockPtr), bld, bb)

build_cond_br(bld, val, bb1, bb2) =
    ccall((:LLVMBuildCondBr, libllvm), InstructionPtr,
          (BuilderPtr, ValuePtr, BasicBlockPtr, BasicBlockPtr), bld, val, bb1, bb2)

build_switch(bld, val, bb, n) =
    ccall((:LLVMBuildSwitch, libllvm), InstructionPtr,
          (BuilderPtr, ValuePtr, BasicBlockPtr, Cuint), bld, val, bb, n)

build_indirect_br(bld, val, n) =
    ccall((:LLVMBuildIndirectBr, libllvm), InstructionPtr,
          (BuilderPtr, ValuePtr, Cuint), bld, val, n)

build_invoke(bld, fn, args, thenbb, catchbb, name) = begin
    nargs = length(args)
    ccall((:LLVMBuildInvoke, libllvm), InstructionPtr,
          (BuilderPtr, ValuePtr, Ptr{ValuePtr}, CUInt, Ptr{BasicBlockPtr},
           Ptr{BasicBlockPtr}, Ptr{Uint8}),
           bld, fn, args, nargs, thenbb, catchbb, name)
end

build_resume(bld, val) =
    ccall((:LLVMBuildResume, libllvm), InstructionPtr,
          (BuilderPtr, ValuePtr), bld, val)

build_unreachable(bld) =
    ccall((:LLVMBuildUnreachable, libllvm), InstructionPtr, (BuilderPtr,), bld)

# build arithmetic instructions
for llvm_inst in [:LLVMBuildAdd,
                  :LLVMBuildNSWAdd,
                  :LLVMBuildNUWAdd,
                  :LLVMBuildFAdd,
                  :LLVMBuildSub,
                  :LLVMBuildNSWSub,
                  :LLVMBuildNUWSub,
                  :LLVMBuildFSub,
                  :LLVMBuildMul,
                  :LLVMBuildNSWMul,
                  :LLVMBuildNUWMul,
                  :LLVMBuildFMul,
                  :LLVMBuildUDiv,
                  :LLVMBuildSDiv,
                  :LLVMBuildExactSDiv,
                  :LLVMBuildFDiv,
                  :LLVMBuildURem,
                  :LLVMBuildSRem,
                  :LLVMBuildFRem,
                  :LLVMBuildShl,
                  :LLVMBuildLShr,
                  :LLVMBuildAShr,
                  :LLVMBuildAnd,
                  :LLVMBuildOr,
                  :LLVMBuildXor]
    iname = lowercase(lstrip(string(llvm_inst), collect("LLVMBuild")))
    fname = symbol(string("build_", iname))
    @eval begin
        $fname(bld, lhs, rhs, name) = 
            ccall((:($llvm_inst), libllvm), InstructionPtr, 
                  (BuilderPtr, ValuePtr, ValuePtr, Ptr{Uint8}), bld, lhs, rhs, name) 
    end
end

build_binop(bld, opcode, lhs, rhs, name) =
    ccall((:LLVMBuildBinOp, libllvm), InstructionPtr,
          (BuilderPtr, LLVMOpcode, ValuePtr, ValuePtr, Ptr{Uint8}),
          bld, opcode, lhs, rhs, name)

# build unary instructions
for llvm_inst in [:LLVMBuildNeg, 
                  :LLVMBuildNSWNeg,
                  :LLVMBuildNUWNeg, 
                  :LLVMBuildFNeg, 
                  :LLVMBuildNot]
    iname = symbol(lowercase(lstrip(string(llvm_inst), collect("LLVMBuild"))))
    fname = symbol(string("build_", iname))
    @eval begin
        $fname(bld, val, name) = 
            ccall((:($llvm_inst), libllvm), InstructionPtr, 
                  (BuilderPtr, ValuePtr, Ptr{Uint8}), bld, val, name)
    end
end

# build casts
for llvm_inst in [:LLVMBuildTrunc,
                  :LLVMBuildZExt,
                  :LLVMBuildSExt,
                  :LLVMBuildFPToUI,
                  :LLVMBuildFPToSI,
                  :LLVMBuildUIToFP,
                  :LLVMBuildSIToFP,
                  :LLVMBuildFPTrunc,
                  :LLVMBuildFPExt,
                  :LLVMBuildPtrToInt,
                  :LLVMBuildIntToPtr,
                  :LLVMBuildBitCast,
                  :LLVMBuildAddrSpaceCast,
                  :LLVMBuildZExtOrBitCast,
                  :LLVMBuildSExtOrBitCast,
                  :LLVMBuildTruncOrBitCast,
                  :LLVMBuildCast,
                  :LLVMBuildPointerCast,
                  :LLVMBuildIntCast,
                  :LLVMBuildFPCast]
    iname = lowercase(lstrip(string(llvm_inst), collect("LLVMBuild")))
    if endswith(iname, "orbitcast")
        iname = replace(iname, "orbitcast", "_or_bitcast")
    end
    fname = symbol(string("build_", iname))
    @eval begin
        $fname(bld, val, name) = 
            ccall((:($llvm_inst), libllvm), InstructionPtr, 
                  (BuilderPtr, ValuePtr, Ptr{Uint8}), bld, val, name) 
    end
end

bulild__malloc(bld, typ, val, name) =
    ccall((:LLVMBuildArrayMalloc, libllvm), InstructionPtr,
          (BuilderPtr, TypePtr, ValuePtr, Ptr{Uint8}), bld, typ, val, name)

build_alloca(bld, typ, val, name) =
    ccall((:LLVMBuildArrayAlloca, libllvm), InstructionPtr,
          (BuilderPtr, TypePtr, ValuePtr, Ptr{Uint8}), bld, typ, val, name)

build_free(bld, ptrval) = 
    ccall((:LLVMBuildFree, libllvm), InstructionPtr, (BuilderPtr, ValuePtr), bld, ptr)

build_load(bld, isvolatile, ptr, atomicorder, syncscope, align, name) =
    ccall((:LLVM_General_BuildLoad, libllvmgeneral), InstructionPtr,
          (BuilderPtr, LLVMBool, ValuePtr, ValuePtr, MemoryOrdering, 
           LLVMBool, Cuint, Ptr{Uint8}),
          bld, isvolatile, ptr, atomicorder, syncscope, align, name)

build_store(bld, isvolatile, ptr, val, atomicorder, syncscope, align, name) =
    ccall((:LLVM_General_BuildStore, libllvmgeneral), InstructionPtr,
          (BuilderPtr, LLVMBool, ValuePtr, ValuePtr, MemoryOrdering, 
           LLVMBool, Cuint, Ptr{Uint8}),
          bld, isvolatile, ptr, val, atomicorder, syncscope, align, name)

build_getelem_ptr(bld, ptr, idxs, name) = begin
    nidxs = length(idxs)
    ccall((:LLVMBuildGEP, libllvm), InstructionPtr,
          (BuilderPtr, ValuePtr, Ptr{ValuePtr}, Cuint, Ptr{Uint8}),
          bld, ptr, idxs, nidxs, name)
end

build_inbounds_getelem_ptr(bld, val, idxs, name) = begin
    nidxs = length(idxs)
    ccall((:LLVMBuildInBoundsGEP, libllvm), InstructionPtr,
          (BuilderPtr, ValuePtr, Ptr{ValuePtr}, Cuint, Ptr{Uint8}),
          bld, val, idxs, nidxs, name)
end

build_fence(bld, memorder, lss, name) =
    ccall((:LLVM_General_BuildFence, libllvmgeneral), InstructionPtr,
          (BuilderPtr, MemoryOrdering, LLVMBool, Ptr{Uint8}),
           bld, memorder, lss, name)

build_cmp_xchg(bld, v, ptr, cmd, n, lao, lss, name) =
    ccall((:LLVM_General_BuildAtomicCmpXchg, libllvmgeneral), InstructionPtr,
          (BuilderPtr, LLVMBool, ValuePtr, ValuePtr, ValuePtr, 
           MemoryOrdering, LLVMBool,  Ptr{Uint8}),
           bld, v, ptr, cmd, lao, lss, name)

build_atomic_rmw(bld, v, rmwop, ptr, val, lao, lss, name) =
    ccall((:LLVM_General_BuildAtomicRMW, libllvmgeneral), InstructionPtr,
          (BuilderPtr, LLVMBool, RMWOperation, ValuePtr, ValuePtr, 
           MemoryOrdering, LLVMBool, Ptr{Uint8}),
           bld, v, rmwop, ptr, val, lao, lss, name)

build_icmp(bld, op, lhs, rhs, name) =
    ccall((:LLVMBuildICmp, libllvm), InstructionPtr,
          (BuilderPtr, ICmpPredicate, ValuePtr, ValuePtr, Ptr{Uint8}),
          bld, op, lhs, rhs, name)

build_fcmp(bld, op, lhs, rhs, name) =
    ccall((:LLVMBuildFCmp, libllvm), InstructionPtr,
          (BuilderPtr, FCmpPredicate, ValuePtr, ValuePtr, Ptr{Uint8}),
           bld, op, lhs, rhs, name)

build_phi(bld, typ, name) =
    ccall((:LLVMBuildPhi, libllvm), InstructionPtr,
          (BuilderPtr, TypePtr, Ptr{Uint8}), bld, typ, name)

build_call(bld, fn, args, name) = begin
    nargs = length(args)
    ccall((:LLVMBuildCall, libllvm), InstructionPtr,
          (BuilderPtr, ValuePtr, Ptr{ValuePtr}, Cuint, Ptr{Uint8}), bld, fn, args, name)
end 

build_select(bld, sif, sthen, selse, name) =
    ccall((:LLVMBuildCall, libllvm), InstructionPtr,
          (BuilderPtr, ValuePtr, ValuePtr, ValuePtr, Ptr{Uint8}), bld, sif, sthen, selse, name)

build_vaarg(vld, lst, typ, name) =
    ccall((:LLVMBuildVAArg, libllvm), InstructionPtr,
          (BuilderPtr, ValuePtr, TypePtr, Ptr{Uint8}), bld, lst, typ, name)

build_extract_elem(bld, vecval, idx, name) =
    ccall((:LLVMBuildExtractElement, libllvm), InstructionPtr,
          (BuilderPtr, ValuePtr, ValuePtr, Ptr{Uint8}), bld, vecval, idx, name)

build_insert_elem(bld, vecval, eltval, idx, name) = 
    ccall((:LLVMBuildExtractElement, libllvm), InstructionPtr,
          (BuilderPtr, ValuePtr, ValuePtr, ValuePtr, Ptr{Uint8}), bld, vecval, idx, name)

build_shuffle_vector(bld, v1, v2, mask, name) =
    ccall((:LLVMBuildShuffleVector, libllvm), InstructionPtr,
          (BuilderPtr, ValuePtr, ValuePtr, ConstPtr, Ptr{Uint8}),
          bld, v1, v2, mask, name)

# TODO: llvm3.5
build_extract_value(bld, a, idxs, name) = begin
    nidxs = length(idxs)
    ccall((:LLVM_General_BuildExtractValue, libllvmgeneral), InstructionPtr,
          (BuilderPtr, ValuePtr, Ptr{Cuint}, Cuint, Ptr{Uint8}), bld, val, idxs, name)
end 

# TODO: llvm3.5
build_insert_value(bld, a, val, idxs, name) = begin
    nidxs = length(idxs)
    ccall((:LLVM_General_BuildInsertValue, libllvmgeneral), InstructionPtr,
          (BuilderPtr, ValuePtr, ValuePtr, Ptr{Cuint}, Cuint, Ptr{Uint8}),
          bld, a, val, idxs, name)
end

build_landing_pad(bld, typ, persfn, nclauses, name) =
    ccall((:LLVMBuildLandingPad, libllvm), InstructionPtr,
          (BuilderPtr, TypePtr, ValuePtr, Cuint, Ptr{Uint8}), bld, typ, persfn, nclauses, name)

set_fastmath_flags(bld, flags) =
    ccall((:LLVM_General_SetFastMathFlags, libllvmgeneral), Void,
          (BuilderPtr, FastMathFlags), bld, flags)

#------------------------------------------------------------------------------
# ByteRange Callback 
#------------------------------------------------------------------------------
function wrap_byterange_callback()
end

#------------------------------------------------------------------------------
# CommandLine 
#------------------------------------------------------------------------------
parse_command_line_opts(argc, argv, overview) =
    ccall((:LLVM_General_ParseCommandLineOptions, libllvmgeneral), Void,
          (Cuint, Ptr{Ptr{Uint8}}, Ptr{Uint8}), argc, argv, overview)

#------------------------------------------------------------------------------
# Constant 
#------------------------------------------------------------------------------
isconstant(val) = 
    bool(ccall((:LLVMIsConstant, libllvm), Cuint, (ValuePtr,), val))

isa_constant(val) =
    bool(ccall((:LLVMIsAConstant, libllvm), Cuint, (ValuePtr,), val))

isa_constant_int(val) =
    bool(ccall((:LLVMIsAConstantInt, libllvm), Cuint, (ValuePtr,), val))

get_constant_operand(cnst, idx) = begin
    idx > zero(idx) || throw(BoundsError())
    ccall((:LLVMGetOperand, libllvm), ConstPtr, (ConstPtr, Cuint), cnst, idx-1)
end

isa_constant_ptr_null(val) =
    ccall((:LLVMIsAConstantPointerNull, libllvm), ConstPtr, (ValuePtr,), val)

get_constant_int_words(cnst) = begin
    n = Cuint[0]
    res = ccall((:LLVM_General_GetConstantIntWords, libllvmgeneral), Ptr{Uint64},
                (ConstPtr, Ptr{Cuint}), cnst, n)
    out = Array(Uint64, n[1])
    for i=1:length(out)
        out[i] = unsafe_load(res, i)
    end
    return out
end

const_float_double_val(cnst) =
    ccall((:LLVM_General_ConstFloatDoubleValue, libllvmgeneral), Float64, (ConstPtr,), cnst)

const_float_val(cnst) =
    ccall((:LLVM_General_ConstFloatFloatValue, libllvmgeneral), Float32, (ConstPtr,), cnst)

const_struct_in_ctx(ctx, constvals, ispacked::Bool) = begin
    n = length(constvals)
    ccall((:LLVMConstStructInContext, libllvm), ConstPtr,
          (ContextPtr, Ptr{ConstPtr}, Cuint, LLVMBool),  ctx, constvals, n, ispacked)
end

const_named_struct(typ, constvals) = begin
    n = length(constvals)
    ccall((:LLVMConstNamedStruct, libllvm), ConstPtr,
          (TypePtr, Ptr{ConstPtr}, Cuint), typ, constvals, n)
end

get_const_data_seq_elem_as_const(val, idx) = begin
    idx > zero(idx) || throw(BoundsError())
    ccall((:LLVM_General_GetConstantDataSequentialElementAsConstant, libllvmgeneral), 
          ConstPtr,
          (ConstPtr, Uint32), val, idx-1) 
end 

const_int_arbitrary_precision(typ, nwords, words) = 
    ccall((:LLVMConstIntOfArbitraryPrecision, libllvm), ConstPtr,
          (TypePtr, Uint32, Ptr{Uint64}), typ, nwords, words)

const_float_arbitrary_precision(ctx, nbits, words, semantics) =
    ccall((:LLVM_General_ConstFloatOfArbitraryPrecision, libllvmgeneral), ConstPtr,
          (ContextPtr, Uint32, Ptr{Uint64}, FloatSemantics),
          ctx, nbits, words, semantics)

get_const_float_words!(cnst, bits) =
    ccall((:LLVM_General_GetConstantFloatWords, libllvmgeneral), Void,
          (ConstPtr, Ptr{Uint64}), cnst, bits)

constant_vector(cnsts) = begin
    n = length(cnsts)
    ccall((:LLVMConstVector, libllvm), ContextPtr, (Ptr{ConstPtr}, Cuint), cnsts, n) 
end

constant_null(typ) = 
    ccall((:LLVMConstNull, libllvm), ConstPtr, (TypePtr,), typ)

const_array(typ, cnsts) = begin
    n = length(cnsts)
    ccall((:LLVMConstArray, libllvm), ConstPtr, (TypePtr, Ptr{ConstPtr}, Cuint), 
          typ, cnsts, n)
end

constant_cast(opcode, cnst, typ) =
    ccall((:LLVM_General_ConstCast, libllvmgeneral), ConstPtr,
          (CPPOpcode, ConstPtr, TypePtr), opcode, cnst, typ)

constant_binary_op(opcode, op1, op2) = 
    ccall((:LLVM_General_ConstBinaryOperator, libllvmgeneral), ConstPtr,
          (CPPOpcode, ConstPtr, ConstPtr), opcode, op1, op2)

get_const_opcode(cnst) =
    ccall((:LLVMGetConstOpcode, libllvm), CPPOpcode, (ConstPtr,), cnst)

get_const_cpp_opcode(cnst) = 
    ccall((:LLVM_General_GetConstCPPOpcode, libllvmgeneral), CPPOpcode, (ConstPtr,), cnst)

# constant unary instructions
for llvm_inst in [:LLVMConstNeg, 
                  :LLVMConstNSWNeg,
                  :LLVMConstNUWNeg, 
                  :LLVMConstFNeg, 
                  :LLVMConstNot]
    iname = symbol(lowercase(lstrip(string(llvm_inst), collect("LLVMConst"))))
    fname = symbol(string("const_", iname))
    @eval begin
        $fname(val) = 
            ccall(($(string(llvm_inst)), libllvm), ConstPtr, (ConstPtr,), val) 
    end
end

# constant binary instructions
for llvm_inst in [:LLVMConstAdd,
                  :LLVMConstNSWAdd,
                  :LLVMConstNUWAdd,
                  :LLVMConstFAdd,
                  :LLVMConstSub,
                  :LLVMConstNSWSub,
                  :LLVMConstNUWSub,
                  :LLVMConstFSub,
                  :LLVMConstMul,
                  :LLVMConstNSWMul,
                  :LLVMConstNUWMul,
                  :LLVMConstFMul,
                  :LLVMConstUDiv,
                  :LLVMConstSDiv,
                  :LLVMConstExactSDiv,
                  :LLVMConstFDiv,
                  :LLVMConstURem,
                  :LLVMConstSRem,
                  :LLVMConstFRem,
                  :LLVMConstAnd,
                  :LLVMConstOr,
                  :LLVMConstXor,
                  :LLVMConstShl,
                  :LLVMConstLShr,
                  :LLVMConstAShr]
    iname = symbol(lowercase(lstrip(string(llvm_inst), collect("LLVMConst"))))
    fname = symbol(string("const_", iname))
    @eval begin
        $fname(lhs, rhs) = 
            ccall(($(string(llvm_inst)), libllvm), ConstPtr, 
                  (ConstPtr, ConstPtr), lhs, rhs) 
    end
end

get_const_icmp_predicate(cnst) =
    ccall((:LLVM_General_GetConstPredicate, libllvmgeneral), ICmpPredicate, 
          (ConstPtr,), cnst)

const_icmp(pred, lhs, rhs) =
    ccall((:LLVMConstICmp, libllvm), ConstPtr, 
          (ICmpPredicate, ConstPtr, ConstPtr), pred, lhs, rhs)

get_const_fcmp_predicate(cnst) =
    ccall((:LLVM_General_GetConstPredicate, libllvmgeneral), FCmpPredicate, 
          (ConstPtr,), cnst)

const_fcmp(pred, lhs, rhs) =
    ccall((:LLVMConstFCmp, libllvm), ConstPtr,
          (FCmpPredicate, ConstPtr, ConstPtr), pred, lhs, rhs)

const_getelem_ptr(cnst, idxs) = begin
    n = length(idxs)
    ccall((:LLVMConstGEP, libllvm), ConstPtr, 
          (ConstPtr, Ptr{ConstPtr}, Cuint), cnst, idxs, n)
end

const_inbounds_getelem_ptr(cnst, idxs) = begin
    n = length(idxs)
    ccall((:LLVMConstInBoundsGEP, libllvm), ConstPtr,
          (ConstPtr, Ptr{ConstPtr}, Cuint), cnst, idxs, n)
end

# constant cast instruction
for llvm_inst in [:LLVMConstTrunc,
                  :LLVMConstSExt,
                  :LLVMConstZExt,
                  :LLVMConstFPTrunc,
                  :LLVMConstFPExt,
                  :LLVMConstUIToFP,
                  :LLVMConstSIToFP,
                  :LLVMConstFPToUI,
                  :LLVMConstFPToSI,
                  :LLVMConstPtrToInt,
                  :LLVMConstIntToPtr,
                  :LLVMConstBitCast,
                  :LLVMConstAddrSpaceCast,
                  :LLVMConstZExtOrBitCast,
                  :LLVMConstSExtOrBitCast,
                  :LLVMConstTruncOrBitCast,
                  :LLVMConstPointerCast,
                  :LLVMConstFPCast]
    iname = lowercase(lstrip(string(llvm_inst), collect("LLVMConst")))
    fname = symbol(string("const_", iname))
    @eval begin
        $fname(val, typ) = 
            ccall(($(string(llvm_inst)), libllvm), ConstPtr,
                  (ConstPtr, TypePtr), val, typ) 
    end
end

const_intcast(val, typ, issigned::Bool) = 
    ccall((:LLVMConstIntCast, libllvm), ConstPtr,
          (ConstPtr, TypePtr, LLVMBool), val, typ, issigned)

const_select(cond, iftrue, iffalse) = 
    ccall((:LLVMConstSelect, libllvm), ConstPtr,
          (ConstPtr, ConstPtr, ConstPtr), cond, iftrue, iffalse)

const_extract_elem(vec, idx) = 
    ccall((:LLVMConstExtractElement, libllvm), ConstPtr,
          (ConstPtr, ConstPtr), vec, idx)

const_insert_elem(vec, val, idx) =
    ccall((:LLVMConstInsertElement, libllvm), ConstPtr,
          (ConstPtr, ConstPtr, ConstPtr), vec, val, idx)

const_shuffle_vector(vec1, vec2, mask) = 
    ccall((:LLVMConstShuffleVector, libllvm), ConstPtr,
          (ConstPtr, ConstPtr, ConstPtr), vec1, vec2, mask)

const_extract_value(agg, idxs) = begin
    n = length(idxs)
    ccall((:LLVMConstExtractValue, libllvm), ConstPtr,
          (ConstPtr, Ptr{Uint32}, Uint32), agg, uint32(idxs), n)
end

get_const_indices(cnst) = begin
    n = Cuint[0]
    ptr = ccall((:LLVM_General_GetConstIndices, libllvmgeneral), Ptr{Cuint},
                (ConstPtr, Ptr{Cuint}), cnst, n)
    out = Array(Cuint, n[1])
    for i=1:length(out)
        out[i] = unsafe_load(ptr, i)
    end
    return out
end

const_undef(typ) =
    ccall((:LLVMGetUndef, libllvm), ConstPtr, (TypePtr,), typ)

block_address(val, bb) = 
    ccall((:LLVMBlockAddress, libllvm), ConstPtr, (ValuePtr, BasicBlockPtr), val, bb)

get_block_address_func(cnst) =
    ccall((:LLVM_General_GetBlockAddressFunction, libllvmgeneral), ValuePtr, 
          (ConstPtr,), cnst)

get_block_address_block(cnst) = 
    ccall((:LLVM_General_GetBlockAddressBlock, libllvmgeneral), BasicBlockPtr, 
          (ConstPtr,), cnst)

#------------------------------------------------------------------------------
# Context 
#------------------------------------------------------------------------------

# http://llvm.org/doxygen/group__LLVMCCoreContext.html#gaac4f39a2d0b9735e64ac7681ab543b4c
create_ctx() = ccall((:LLVMContextCreate, libllvm), ContextPtr, ())

# http://llvm.org/doxygen/group__LLVMCCoreContext.html#ga0055cde9a9b2497b332d639d8844a810
global_ctx() = ccall((:LLVMGetGlobalContext, libllvm), ContextPtr, ())

# http://llvm.org/doxygen/group__LLVMCCoreContext.html#ga9cf8b0fb4a546d4cdb6f64b8055f5f57
dispose_ctx(ctx) = 
    ccall((:LLVMContextDispose, libllvm), Void, (ContextPtr,), ctx)

#------------------------------------------------------------------------------
# Data Layout
#------------------------------------------------------------------------------

create_datalayout(dl::String) =
    ccall((:LLVMCreateTargetData, libllvm), DataLayoutPtr, (Ptr{Uint8},), dl)

dispose_datalayout(dl) = 
    ccall((:LLVMDisposeTargetData, libllvm), Void, (DataLayoutPtr,), dl)

datalayout_to_string(dl) = begin
    ptr = ccall((:LLVMCopyStringRepOfTargetData, libllvm), Ptr{Uint8}, (DataLayoutPtr,), dl)
    ret = bytestring(ptr)
    c_free(ptr)
    return ret
end

#------------------------------------------------------------------------------
# Execution Engine 
#------------------------------------------------------------------------------
create_execution_engine_for_module(mod) = begin
    errptr = Ptr{Uint8}[0]
    engptr = [ExeEnginePtr(C_NULL)]
    ret = ccall((:LLVMCreateExecutionEngineForModule, libllvm), LLVMBool,
                (Ptr{ExeEnginePtr}, ModulePtr, Ptr{Ptr{Uint8}}), engptr, mod, errptr)
    eng = engptr[1]
    if ret != 0
        isnull(eng) || FFI.dispose_execution_engine(eng)
        if errptr[1] != C_NULL
            msg = bytestring(errptr[1])
            FFI.dispose_message(errptr[1])
        else
            msg = "unknown error in creating execution engine for module"
        end
        throw(ErrorException(msg))
    end
    @assert !isnull(eng)
    return eng
end

create_interpreter_for_module(mod) = begin
    errptr = Ptr{Uint8}[0]
    engptr = [ExeEnginePtr(C_NULL)]
    ret = ccall((:LLVMCreateInterpreterForModule, libllvm), LLVMBool,
                (Ptr{ExeEnginePtr}, ModulePtr, errptr), engptr, mod, errptr)
    eng = engptr[1]
    if ret != 0 
        isnull(eng) || FFI.dispose_execution_engine(eng)
        if errptr[1] != C_NULL
            msg = bytestring(errptr[1])
            FFI.dispose_message(errptr[1])
        else
            msg = "unknown error in creating interpreter for module"
        end
        throw(ErrorException(msg))
    end
    @assert !isnull(eng)
    return eng
end

create_jit_compiler_for_module(mod, optlevel) = begin
    errptr = Ptr{Uint8}[0]
    engptr = [ExeEnginePtr(C_NULL)]
    ret = ccall((:LLVMCreateJITCompilerForModule, libllvm), LLVMBool,
                (Ptr{ExeEnginePtr}, ModulePtr, Cuint, Ptr{Ptr{Uint8}}),
                engptr, mod, optlevel, errptr)
    eng = engptr[1]
    if ret != 0
        isnull(eng) || FFI.dispose_execution_engine(eng) 
        if errptr[1] != C_NULL
            msg = bytestring(errptr[1])
            FFI.dispose_message(errptr[1])
        else
            msg = "unknown error in creating jit compiler for module"
        end
    end
    @assert !isnull(eng)
    return eng
end

create_mcjit_compiler_for_module(mod, opts) = begin
    @assert !isnull(mod)
    errptr = Ptr{Uint8}[0]
    engptr = [ExeEnginePtr(C_NULL)]
    res = ccall((:LLVMCreateMCJITCompilerForModule, libllvm), LLVMBool,
                (Ptr{ExeEnginePtr}, ModulePtr, Ptr{Void}, Csize_t, Ptr{Ptr{Uint8}}),
                engptr, mod, C_NULL, 0, errptr)
    eng = engptr[1]
    if res != 0
        isnull(eng) || FFI.dispose_execution_engine(eng)
        if errptr[1] != C_NULL
            msg = bytestring(errptr[1])
            FFI.dispose_message(errptr[1])
        else
            msg = "unknown error in creating mcjit compiler for module"
        end 
        throw(ErrorException(msg))
    end
    @assert !isnull(eng) 
    return eng 
end

dispose_execution_engine(engine) =
    ccall((:LLVMDisposeExecutionEngine, libllvm), Void, (ExeEnginePtr,), engine)

add_module(engine, mod) =
    ccall((:LLVMAddModule, libllvm), Void, (ExeEnginePtr, ModulePtr), engine, mod)

remove_module(engine, mod) = begin
    errptr = Ptr{Uint8}[0]
    modptr = [ModulePtr(C_NULL)]
    ret = ccall((:LLVMRemoveModule, libllvm), LLVMBool,
                (ExeEnginePtr, ModulePtr, Ptr{ModulePtr}, Ptr{Ptr{Uint8}}),
                engine, mod, modptr, errptr)
    mod = modptr[1]
    if ret != 0
        isnull(mod) || FFI.dispose_module(mod)
        if errptr[1] != C_NULL
            msg = bytestring(errptr[1])
            FFI.dispose_message(errptr[1])
        else
            msg = "unknown error when removing module from engine"
        end
        throw(ErrorException(msg))
    end
    @assert !isnull(mod)
    return mod
end
        
find_function(engine, name) = begin
    fnptr = [FunctionPtr(C_NULL)]
    ret = ccall((:LLVMFindFunction, libllvm), LLVMBool,
                (ExeEnginePtr, Ptr{Uint8}, Ptr{FunctionPtr}),
                engine, name, fnptr)
    ret != 0 && throw(ErrorException("\"$name\" function not found in engine"))
    fn = fnptr[1]
    @assert !isnull(fn)
    return fn
end 

get_ptr_to_global(engine, gval) =
    ccall((:LLVMGetPointerToGlobal, libllvm), Ptr{Void}, 
          (ExeEnginePtr, GlobalValuePtr), engine, gval)

link_in_interpreter() = 
    ccall((:LLVMLinkInInterpreter, libllvm), Void, ())

link_in_jit() = 
    ccall((:LLVMLinkInJIT, libllvm), Void, ())

link_in_mcjit() = 
    ccall((:LLVMLinkInMCJIT, libllvm), Void, ())

get_mcjit_compiler_opts_size() =
    ccall((:LLVM_General_GetMCJITCompilerOptionsSize, libllvmgeneral), Csize_t, ())

init_mcjit_compiler_opts(opts) = begin
    sz = get_mcjit_compiler_opts_size()
    ccall((:LLVMInitializeMCJITCompilerOptions, libllvm), Void,
          (Ptr{JITCompilerOpts}, Csize_t), &opts, sz) 
end

set_mcjit_compiler_level(opts, level) = begin
    optsptr = [opts]
    ccall((:LLVM_General_SetMCJITCompilerOptionsOptLevel, libllvmgeneral), Void,
          (Ptr{JITCompilerOpts}, Cint), optsptr, level)
    return optsptr[1]
end

set_mcjit_compiler_codemodel(opts, model) = begin
    optsptr = [opts]
    ccall((:LLVM_General_SetMCJITCompilerOptionsCodeModel, libllvmgeneral), Void,
          (Ptr{JITCompilerOpts}, CodeModel), optsptr, model)
    return optsptr[1]
end

set_mcjit_compiler_no_frame_ptr_elim(opts, v::Bool) = begin
    ccall((:LLVM_General_SetMCJITCompilerOptionsNoFramePointerElim, libllvmgeneral), Void,
          (MCJITOptsPtr, LLVMBool), opts, v)
    return opts
end

set_mcjit_compiler_enable_fast_isel(opts, v::Bool) = begin
    ccall((:LLVM_General_SetMCJITCompilerOptionsEnableFastISel, libllvmgeneral), Void,
          (MCJITOptsPtr, LLVMBool), opts, val)
    return opts
end

#------------------------------------------------------------------------------
# Function 
#------------------------------------------------------------------------------
get_func_call_cov(fn) =
    ccall((:LLVMGetFunctionCallConv, libllvm), CallingCov, (FunctionPtr,), fn)

set_func_call_cov!(fn, callcov) =
    ccall((:LLVMSetFunctionCallConv, libllvm), Void, (FunctionPtr, CallingCov), fn, callcov)

add_func_attr!(fn, attr) =
    ccall((:LLVMAddFunctionAttr, libllvm), Void, (FunctionPtr, FunctionAttr), fn, attr)

get_func_attr(fn) =
    ccall((:LLVMGetFunctionAttr, libllvm), FunctionAttr, (FunctionPtr,), fn)

get_first_basicblock(fn) =
    ccall((:LLVMGetFirstBasicBlock, libllvm), BasicBlockPtr, (FunctionPtr,), fn)

get_last_basicblock(fn) =
    ccall((:LLVMGetLastBasicBlock, libllvm), BasicBlockPtr, (FunctionPtr,), fn)

get_next_basicblock(bb) =
    ccall((:LLVMGetNextBasicBlock, libllvm), BasicBlockPtr, (BasicBlockPtr,), bb)

append_basicblock_in_ctx(ctx, fn, name) =
    ccall((:LLVMAppendBasicBlockInContext, libllvm), BasicBlockPtr,
          (ContextPtr, FunctionPtr, Ptr{Uint8}), ctx, fn, name)

count_params(fn) =
    ccall((:LLVMCountParams, libllvm), Cuint, (FunctionPtr,), fn)

get_params(fn) = begin
    params = Array(ParamPtr, count_params(fn))
    ccall((:LLVMGetParams, libllvm), Void, (FunctionPtr, Ptr{ParamPtr}), fn, params)
    return params
end 

get_attribute(param) =
    ccall((:LLVMGetAttribute, libllvm), ParamAttr, (ParamPtr,), param) 

add_attribute!(param, attr) =
    ccall((:LLVMAddAttribute, libllvm), Void, (ParamPtr, ParamAttr), param, attr)

get_func_ret_attr(fn) =
    ccall((:LLVM_General_GetFunctionRetAttr, libllvmgeneral), ParamAttr, (FunctionPtr,), fn)

add_func_ret_attr!(fn, attr) =
    ccall((:LLVM_General_AddFunctionRetAttr, libllvmgeneral), Void,
          (FunctionPtr, ParamAttr), fn, attr)

get_gc(fn) = begin
    ptr = ccall((:LLVMGetGC, libllvm), Ptr{Uint8}, (FunctionPtr,), fn)
    ptr != zero(Ptr{Uint8}) ? bytestring(ptr): nothing 
end

set_gc!(fn, name) =
    ccall((:LLVMSetGC, libllvm), Void, (FunctionPtr, Ptr{Uint8}), fn, name)

#------------------------------------------------------------------------------
# Global Alias 
#------------------------------------------------------------------------------

# test if a value is a global alias 
isa_global_alias(val) =
    ccall((:LLVMIsAGlobalAlias, libllvm), GlobalAliasPtr, (ValuePtr,), val)

# get the constant aliased by this alias
get_aliasee(ga) =
    ccall((:LLVM_General_GetAliasee, libllvmgeneral), ConstPtr, (GlobalAliasPtr,), ga)

# set the constant aliased by this alias
set_aliasee!(ga, cnst) =
    ccall((:LLVM_General_SetAliasee, libllvmgeneral), Void, 
          (GlobalAliasPtr, ConstPtr,), ga, cnst)

#------------------------------------------------------------------------------
# Global Value
#------------------------------------------------------------------------------

isa_global_value(val) =
    ccall((:LLVMIsAGlobalValue, libllvm), GlobalValuePtr, (ValuePtr,), val) 

get_linkage(gval) =
    ccall((:LLVMGetLinkage, libllvm), Linkage, (GlobalValuePtr,), gval)

set_linkage!(gval, link) = 
    ccall((:LLVMSetLinkage, libllvm), Void, (GlobalValuePtr, Linkage), gval, link)

get_section(gval) = begin
    ptr = ccall((:LLVMGetSection, libllvm), Ptr{Uint8}, (GlobalValuePtr,), gval)
    res = bytestring(ptr)
    return isempty(res) ? nothing : res
end

set_section!(gval, section) =
    ccall((:LLVMSetSection, libllvm), Void, (GlobalValuePtr, Ptr{Uint8}), gval, section)

get_visibility(gval) =
    ccall((:LLVMGetVisibility, libllvm), Visibility, (GlobalValuePtr,), gval) 

set_visibility!(gval, vis) = 
    ccall((:LLVMSetVisibility, libllvm), Void, (GlobalValuePtr, Uint32), gval, vis)

get_alignment(gval) =
    ccall((:LLVMGetAlignment, libllvm), Cuint, (GlobalValuePtr,), gval)

set_alignment!(gval, bytes) =
    ccall((:LLVMSetAlignment, libllvm), Void, (GlobalValuePtr, Uint32), gval, bytes)

has_unnamed_addr(gval) =
    bool(ccall((:LLVMHasUnnamedAddr, libllvm), LLVMBool, 
               (GlobalValuePtr,), gval))

set_unnamed_addr!(val, hasunamed::Bool) =
    ccall((:LLVMSetUnnamedAddr, libllvm), Void,
          (ValuePtr, LLVMBool), val, hasunamed)

#------------------------------------------------------------------------------
# Global Variable 
#------------------------------------------------------------------------------

isa_global_variable(val) =
    ccall((:LLVMIsAGlobalVariable, libllvm), GlobalValuePtr, (ValuePtr,), val)

is_global_constant(gval) =
    bool(ccall((:LLVMIsGlobalConstant, libllvm), LLVMBool, (GlobalValuePtr,), gval))

set_global_constant!(val, isconst::Bool) =
    ccall((:LLVMSetGlobalConstant, libllvm), Void, (GlobalValuePtr, LLVMBool), val, isconst)

get_initializer(val) =
    ccall((:LLVMGetInitializer, libllvm), ConstPtr , (GlobalValuePtr,), val)

set_initializer!(val, constval) = 
    ccall((:LLVMSetInitializer, libllvm), Void, (GlobalValuePtr, ConstPtr), val, constval)
 
is_thread_local(gval) =
    bool(ccall((:LLVMIsThreadLocal, libllvm), LLVMBool, (GlobalValuePtr,), gval))

set_thread_local!(val, islocal::Bool) =
    ccall((:LLVMSetThreadLocal, libllvm), Void, (GlobalValuePtr, LLVMBool), val, islocal)

#------------------------------------------------------------------------------
# Inline Assembly
#------------------------------------------------------------------------------

isa_inline_asm(val) =
    ccall((:LLVMIsAInlineAsm, libllvm), InlineAsmPtr, (ValuePtr,), val)

create_inline_asm(typ, asm, constraint, 
                  has_side_effects::Bool, is_align_stack::Bool, dialect) = begin
    ccall((:LLVM_General_CreateInlineAsm, libllvmgeneral), InlineAsmPtr,
          (TypePtr, Ptr{Uint8}, Ptr{Uint8}, LLVMBool, LLVMBool, AsmDialect),
          typ, asm, constraint, has_side_effects, is_align_stack, dialect)
end

get_inline_asm_string(asm) =
    bytestring(ccall((:LLVM_General_GetInlineAsmAsmString, libllvmgeneral), Ptr{Uint8},
                     (InlineAsmPtr,), asm))

get_inline_asm_constraint_string(asm) =
    bytestring(ccall((:LLVM_General_GetInlineAsmConstraintString, libllvmgeneral), Ptr{Uint8},
                     (InlineAsmPtr,), asm))

inline_asm_has_sideeffects(asm) =
    bool(ccall((:LLVM_General_InlineAsmHasSideEffects, libllvmgeneral), LLVMBool,
               (InlineAsmPtr,), asm))

inline_asm_isalign_stack(asm) =
    bool(ccall((:LLVM_General_InlineAsmIsAlignStack, libllvmgeneral), LLVMBool,
               (InlineAsmPtr,), asm))

get_inline_asm_dialect(asm) =
    ccall((:LLVM_General_GetInlineAsmDialect, libllvmgeneral), AsmDialect,
          (InlineAsmPtr,), asm)

#------------------------------------------------------------------------------
# Instruction
#------------------------------------------------------------------------------
isa_instruction(val) =
    ccall((:LLVMIsAInstruction, libllvm), COpcode, (ValuePtr,), inst)

get_instr_opcode(inst) =
    ccall((:LLVMGetInstructionOpcode, libllvm), COpcode, (InstructionPtr,), inst)

# c++ opcode
get_instr_def_opcode(inst) =
    ccall((:LLVM_General_GetInstructionDefOpcode, libllvmgeneral), COpcode, 
          (InstructionPtr,), inst)

get_icmp_predicate(inst) =
    ccall((:LLVMGetICmpPredicate,  libllvm), ICmpPredicate, 
          (InstructionPtr,), inst)

#TODO: const instruction pointer that can cast to an instruction pointer
get_icmp_predicate(inst::ConstPtr) =
    ccall((:LLVMGetICmpPredicate, libllvm), ICmpPredicate,
          (ConstPtr,), inst)

get_fcmp_predicate(inst) =
    ccall((:LLVM_General_GetFCmpPredicate, libllvmgeneral), FCmpPredicate,
          (InstructionPtr,), inst)

get_instr_call_cov(inst) =
    ccall((:LLVMGetInstructionCallConv, libllvm), CallConv, (InstructionPtr,), inst) 

set_instr_call_cov!(inst, callcov) =
    ccall((:LLVMSetInstructionCallConv, libllvm), Void, 
          (InstructionPtr, CallConv), inst, callcov)

is_tail_call(inst) =
    bool(ccall((:LLVMIsTailCall, libllvm), LLVMBool, (InstructionPtr,), inst))

set_tail_call!(inst, istail::Bool) =
    bool(ccall((:LLVMSetTailCall, libllvm), Void, (InstructionPtr, LLVMBool), inst, istail))

get_call_instr_called_val(inst) =
    ccall((:LLVM_General_GetCallInstCalledValue, libllvmgeneral), ValuePtr, 
          (InstructionPtr,), inst)

get_call_instr_func_attr(inst) = 
    ccall((:LLVM_General_GetCallInstFunctionAttr, libllvmgeneral), FunctionAttr, 
          (InstructionPtr,), inst)

add_call_instr_func_attr(inst, attr) =
    ccall((:LLVM_General_AddCallInstAttr, libllvmgeneral), Void, 
          (InstructionPtr, FunctionAttr), inst, attr)

get_call_instr_attr(inst, attr) =
    ccall((:LLVM_General_GetCallInstCalledValue, libllvmgeneral), ParamAttr,
          (InstructionPtr, Cuint), inst, attr)

add_call_instr_attr(inst, i, attr) =
    ccall((:LLVM_General_AddCallInstAttr, libllvmgeneral), Void,
          (InstructionPtr, Cuint, ParamAttr), inst, i, attr)

add_incoming(inst, vals, bbs) = begin
    @assert length(vals) == length(bbs) 
    ccall((:LLVMAddIncoming, libllvm), Void,
          (InstructionPtr, Ptr{ValuePtr}, Ptr{BasicBlockPtr}, Cuint),
          inst, vals, bbs, length(vals))
end

count_incoming(inst) =
    ccall((:LLVMCountIncoming, libllvm), Cuint, (InstructionPtr,), inst)

get_incoming_val(inst, idx) = begin
    idx > zero(idx) || throw(BoundsError())
    ccall((:LLVMGetIncomingValue, libllvm), ValuePtr, (InstructionPtr, Cuint), inst, idx-1)
end

get_incoming_block(inst, idx) = begin
    idx > zero(idx) || throw(BoundsError())
    ccall((:LLVMGetIncomingBlock, libllvm), BasicBlockPtr, (InstructionPtr, Cuint), inst, idx-1)
end

add_case(switch, onval, dest) =
    ccall((:LLVMAddCase, libllvm), Void,
          (InstructionPtr, ConstPtr, BasicBlockPtr,), switch, onval, dest) 

get_switch_cases(inst, values, dests) =
    ccall((:LLVM_General_GetSwitchCases, libllvmgeneral), Void,
          (InstructionPtr, Ptr{ConstPtr}, Ptr{BasicBlockPtr}), inst, values, dests)

add_destination(indirectbr, dest) =
    ccall((:LLVMAddDestination, libllvm), Void, 
          (InstructionPtr, BasicBlockPtr), indirectbr, dest)

get_indirect_br_dests(indirectbr, dests) =
    ccall((:LLVM_General_GetIndirectBrDests, libllvmgeneral), Void,
          (InstructionPtr, Ptr{BasicBlockPtr},), indirectbr, dests)

get_instr_alignment(inst) =
    ccall((:LLVM_General_GetInstrAlignment, libllvmgeneral), Cuint, (InstructionPtr,), inst)

set_instr_alignment(inst, align) =
    ccall((:LLVM_General_SetInstrAlignment, libllvmgeneral), Void, 
          (InstructionPtr, Cuint), inst, align)

get_alloca_num_elements(inst) =
    ccall((:LLVM_General_GetAllocaNumElements, libllvmgeneral), ValuePtr,
          (InstructionPtr,), inst)

get_allocated_type(inst) =
    ccall((:LLVM_General_GetAllocatedType, libllvmgeneral), TypePtr,
          (InstructionPtr,), inst)

get_atomic_ordering(inst) =
    ccall((:LLVM_General_GetAtomicOrdering, libllvmgeneral), MemoryOrdering,
          (InstructionPtr,), inst)

get_sync_scope(inst) =
    ccall((:LLVM_General_GetSynchronizationScope, libllvmgeneral), LLVMBool,
          (InstructionPtr,), inst)

get_atomicity(inst) =
    (get_atomic_ordering(inst), get_sync_scope(inst))

get_volatile(inst) = 
    bool(ccall((:LLVM_General_GetVolatile, libllvmgeneral), LLVMBool, (InstructionPtr,), inst))

get_inbounds(inst) =
    bool(ccall((:LLVM_General_GetInBounds, libllvmgeneral), LLVMBool, (InstructionPtr,), inst))

get_atomic_rmw_bin_op(inst) =
    ccall((:LLVM_General_GetAtomicRMWBinOp, libllvmgeneral), RMWOperation,
          (InstructionPtr,), inst)

count_instr_struct_idxs(inst) =
    ccall((:LLVM_General_CountInstStructureIndices, libllvmgeneral), Cuint, 
          (InstructionPtr,), inst)

get_instr_struct_idxs(inst) = begin
    n = count_instr_struct_idxs(inst)
    out = Array(Cuint, n)
    ccall((:LLVM_General_GetInstStructureIndices, libllvmgeneral), Void,
          (InstructionPtr, Ptr{Cuint}), inst, out)
    return out
end

add_clause(landingpad, clauseval) =
    ccall((:LLVMAddClause, libllvm), Void, (InstructionPtr, ConstPtr,), landingpad, clauseval)

set_cleanup(landingpad, val::Bool) =
    ccall((:LLVMSetCleanup, libllvm), Void, (InstructionPtr, LLVMBool), landingpad, val)

is_cleanup(landingpad) =
    bool(ccall((:LLVM_General_IsCleanup, libllvmgeneral), LLVMBool, 
               (InstructionPtr,), landingpad))

set_metadata(inst, mdkind, mdnodes) =
    ccall((:LLVMSetMetadata, libllvm), Void,
          (InstructionPtr, MDKindID, Ptr{MDNodePtr}), inst, mdkind, mdnodes)
            
get_metadata(inst, mdkinds, mdnodes, nkinds) =
    ccall((:LLVM_General_GetMetadata, libllvmgeneral), Cuint,
          (InstructionPtr, Ptr{MDKindID}, Ptr{MDNodePtr}, Cuint),
          inst, mdkinds, mdnodes, nkinds)

#------------------------------------------------------------------------------
# Memory Buffer
#------------------------------------------------------------------------------

create_mem_buffer_with_contents_of_file(path) = begin
    !isfile(path) && throw(ArgumentError("file $path does not exist"))
    errmsg = Ptr{Uint8}[0]
    bufptr = [MemoryBufferPtr(C_NULL)]
    status = ccall((:LLVMCreateMemoryBufferWithContentsOfFile, libllvm), LLVMBool,
                   (Ptr{Uint8}, Ptr{MemoryBufferPtr}, Ptr{Ptr{Uint8}}),
                   path, bufptr, errmsg)
    if status != 0
        if errmsg[1] == C_NULL
            error("unknown error when creating mem buffer with contents of file \"$path\"")
        else
            error(bytestring(errmsg[1]))
        end
    end
    @assert !isnull(bufptr[1])
    return bufptr[1]
end

create_mem_buffer_with_mem_range(name, input) = begin
    # we always null terminate input
    len = length(input)
    ccall((:LLVMCreateMemoryBufferWithMemoryRange, libllvm), MemoryBufferPtr,
          (Ptr{Uint8}, Csize_t, Ptr{Uint8}, LLVMBool), input, len, name, true)
end

get_buffer_start(buf) =
    ccall((:LLVMGetBufferStart, libllvm), Ptr{Uint8}, (MemoryBufferPtr,), buf)

get_buffer_size(buf) =
    ccall((:LLVMGetBufferSize, libllvm), Csize_t, (MemoryBufferPtr,), buf)

dispose_mem_buffer(buf) = 
    ccall((:LLVMDisposeMemoryBuffer, libllvm), Void, (MemoryBufferPtr,), buf)

#------------------------------------------------------------------------------
# Metadata 
#------------------------------------------------------------------------------

is_amd_string(val) =
    ccall((:LLVMIsAMDString, libllvm), MDStringPtr, (ValuePtr,), val)

is_amd_node(val) =
    ccall((:LLVMIsAMDNode, libllvm), MDNodePtr, (ValuePtr,), val)

get_md_kind_in_ctx(ctx, name) = begin
    len = length(name)
    ccall((:LLVMGetMDKindIDInContext, libllvm), MDKindID,
          (ContextPtr, Ptr{Uint8}, Cuint), ctx, name, len)
end

get_md_kind_names(ctx, strs , lens) = begin
    @assert length(strs) == length(lens)
    ccall((:LLVM_General_GetMDKindNames, libllvmgeneral), Cuint,
          (ContextPtr, Ptr{Ptr{Uint8}}, Ptr{Cuint}, Cuint),
          ctx, strs, lens, length(lens))
end

md_string_in_ctx(ctx, str) =
    bytestring(ccall((:LLVMMDNodeInContext, libllvm), Ptr{Uint8},
                     (ContextPtr, Ptr{Uint8}, Cuint), ctx, str, length(str)))

get_md_string(mdstr) = begin
    len = Ptr{Cuint}[0]
    ptr = ccall((:LLVMGetMDString, libllvm), Ptr{Uint8}, (MDStringPtr, Ptr{Cuint}), mdstr, len)
    return bytestring(ptr, len[1])
end

create_md_node_in_ctx(ctx, vals) = begin
    n = length(vals)
    ccall((:LLVMMDNodeInContext, libllvm), MDNodePtr,
          (ContextPtr, Ptr{ValuePtr}, Cuint), ctx, vals, n)
end

create_tmp_md_node_in_ctx(ctx) =
    ccall((:LLVM_General_CreateTemporaryMDNodeInContext, libllvmgeneral), MDNodePtr,
          (ContextPtr,), ctx)

destroy_tmp_md_node(mdnode) =
    ccall((:LLVM_General_DestroyTemporaryMDNode, libllvmgeneral), Void, (MDNodePtr,), mdnode)

get_md_node_num_operands(mdnode) =
    ccall((:LLVM_General_GetMDNodeNumOperands, libllvmgeneral), Cuint, (MDNodePtr,), mdnode)

get_md_node_operands(mdnode) = begin
    n = get_md_node_num_operands(mdnode)
    vals = Array(ValuePtr, n)
    ccall((:LLVMGetMDNodeOperands, libllvm), Void, (MDNodePtr, Ptr{ValuePtr}), mdnode, vals)
    return vals
end

md_node_is_func_local(mdnode) =
    bool(ccall((:LLVM_General_MDNodeIsFunctionLocal, libllvmgeneral), LLVMBool,
               (MDNodePtr,), mdnode))

get_named_md_name(mdnode, len) =
    bytestring(ccall((:LLVM_General_GetNamedMetadataName, libllvmgeneral), Ptr{Uint8},
                     (MDNodePtr, Cuint), mdnode, len))

get_named_md_num_operands(nmd) =
    ccall((:LLVM_General_GetNamedMetadataNumOperands, libllvmgeneral), Cuint,
          (NamedMetadataPtr,), nmd)

get_named_md_operands(nmd, nodes) = 
    ccall((:LLVM_General_GetNamedMetadataOperands, libllvmgeneral), Void,
          (NamedMetadataPtr, Ptr{MDNodePtr}), nmd, nodes)

named_md_add_operands(nmd, nodes) = begin
    n = length(nodes)
    ccall((:LLVM_General_NamedMetadataAddOperands, libllvmgeneral), Void,
          (NamedMetadataPtr, Ptr{MDNodePtr},), nmd, nodes, n)
end

#------------------------------------------------------------------------------
# Module 
#------------------------------------------------------------------------------
create_module_with_name(name) = 
    ccall((:LLVMModuleCreateWithName, libllvm), ModulePtr, (Ptr{Uint8},), name)

create_module_with_name_in_ctx(id, ctx) =
    ccall((:LLVMModuleCreateWithNameInContext, libllvm), ModulePtr,
          (Ptr{Uint8}, ContextPtr), id, ctx)

get_module_ctx(mod) = 
    ccall((:LLVMGetModuleContext, libllvm), ContextPtr, (ModulePtr,), mod)

dispose_module(mod) = 
    ccall((:LLVMDisposeModule, libllvm), Void, (ModulePtr,), mod)

get_datalayout(mod) =
    bytestring(ccall((:LLVMGetDataLayout, libllvm), Ptr{Uint8}, (ModulePtr,), mod))

set_datalayout!(mod, triple) = 
    ccall((:LLVMSetDataLayout, libllvm), Void, (ModulePtr, Ptr{Uint8}), mod, triple)

get_target_triple(mod) =  
    bytestring(ccall((:LLVMGetTarget, libllvm), Ptr{Uint8}, (ModulePtr,), mod))

set_target_triple(mod, triple) = 
    ccall((:LLVMSetTarget, libllvm), Void, (ModulePtr, Ptr{Uint8}), mod, triple)

get_module_id(mod) =  
    bytestring(ccall((:LLVM_General_GetModuleIdentifier, libllvmgeneral), Ptr{Uint8}, 
                     (ModulePtr,), mod))

get_first_global(mod) = 
    ccall((:LLVMGetFirstGlobal, libllvm), GlobalValuePtr, (ModulePtr,), mod)

get_next_global(gv) = 
    ccall((:LLVMGetNextGlobal, libllvm), GlobalValuePtr, (GlobalValuePtr,), gv)

get_first_alias(mod) =
    ccall((:LLVM_General_GetFirstAlias, libllvmgeneral), GlobalAliasPtr, (ModulePtr,), mod)

get_next_alias(a) =
    ccall((:LLVM_General_GetNextAlias, libllvmgeneral), GlobalAliasPtr,
          (GlobalAliasPtr,), a)

get_first_func(mod) =
    ccall((:LLVMGetFirstFunction, libllvm), FunctionPtr, (ModulePtr,), mod)

get_next_func(func) =
    ccall((:LLVMGetNextFunction, libllvm), FunctionPtr, (FunctionPtr,), func)

get_first_named_md(mod) =
    ccall((:LLVM_General_GetFirstNamedMetadata, libllvmgeneral), NamedMetadataPtr, 
          (ModulePtr,), mod)

get_next_named_md(mod) =
    ccall((:LLVM_General_GetNextNamedMetadata, libllvmgeneral), NamedMetadataPtr,
          (ModulePtr,), mod)

add_global_in_addr_space!(mod, typ, name, addr) = 
    ccall((:LLVMAddGlobalInAddressSpace, libllvm), GlobalValuePtr, 
          (ModulePtr, TypePtr, Ptr{Uint8}, Uint32), mod, typ, name, addr)

just_add_alias(mod, typ, name) =
    ccall((:LLVM_General_JustAddAlias, libllvmgeneral), GlobalAliasPtr, 
          (ModulePtr, TypePtr, Ptr{Uint8}), mod, typ, name)

add_function(mod, name, typ) =
    ccall((:LLVMAddFunction, libllvm), FunctionPtr,
          (ModulePtr, Ptr{Uint8}, TypePtr), mod, name, typ)

get_named_function(mod, name) =
    ccall((:LLVMGetNamedFunction, libllvm), FunctionPtr, (ModulePtr, Ptr{Uint8}), mod, name)

get_or_add_named_md(mod, name) =
    ccall((:LLVM_General_GetOrAddNamedMetadata, libllvmgeneral), NamedMetadataPtr,
          (ModulePtr, Ptr{Uint8}), mod, name)

module_append_inline_asm(mod, src, pos) =
    ccall((:LLVM_General_ModuleAppendInlineAsm, libllvmgeneral), Void,
          (ModulePtr, Ptr{Uint8}, Cuint), mod, src, pos)

module_get_inline_asm(mod) = begin
    bytestring(ccall((:LLVM_General_ModuleGetInlineAsm, libllvmgeneral), Ptr{Uint8}, 
                (ModulePtr,), mod))
end 

link_modules(dest, src, mode, msg) = begin
    out_msg = Ptr{Uint8}[0] # TODO: message output
    ccall((:LLVMLinkModules, libllvm), LLVMBool,
          (ModulePtr, ModulePtr, LinkerMode, Ptr{Ptr{Uint8}},),
          dest, src, mode, out_msg)
end 

dump_module(mod) =
    ccall((:LLVMDumpModule, libllvm), Void, (ModulePtr,), mod)

#------------------------------------------------------------------------------
# Pass Manager 
#------------------------------------------------------------------------------

create_pass_manager() =
    ccall((:LLVMCreatePassManager, libllvm), PassManagerPtr, ())

dispose_pass_manager(pm) =
    ccall((:LLVMDisposePassManager, libllvm), Void, (PassManagerPtr,), pm)

run_pass_manager(pm, mod) = 
    bool(ccall((:LLVMRunPassManager, libllvm), LLVMBool,
               (PassManagerPtr, ModulePtr,), pm, mod))

create_func_pass_manager_for_module(mod) =
    ccall((:LLVMCreateFunctionPassManagerForModule, libllvm), PassManagerPtr, (ModulePtr,), mod)

init_func_pass_manager(pm) =
    ccall((:LLVMInitializeFunctionPassManager, libllvm), PassManagerPtr, (ModulePtr,), mod)

run_func_pass_manager(pm, val) =
    bool(ccall((:LLVMRunFunctionPassManager, libllvm), LLVMBool,
               (ModulePtr, ValuePtr), pm, val))

finalize_func_pass_manager(pm) =
    bool(ccall((:LLVMFinalizeFunctionPassManager, libllvm), LLVMBool, (PassManagerPtr,), pm))

add_datalayout_pass(pm, dl) = 
    ccall((:LLVMAddTargetData, libllvm), Void, (DataLayoutPtr, PassManagerPtr), dl, pm)

add_analysis_pass(pm, tmachine) = 
    ccall((:LLVM_General_LLVMAddAnalysisPasses, libllvm), Void, 
          (TargetLibInfoPtr, PassManagerPtr), tmachie, pm)

add_target_libinfo_pass(pm, tinfo) =
    ccall((:LLVMAddTargetLibraryInfo, libllvm), Void,
          (TargetLibInfoPtr, PassManagerPtr), tinfo, pm)

#TODO: add individual passes...

pass_manager_builder_create() =
    ccall((:LLVMPassManagerBuilderCreate, libllvm), PassBuilderPtr, ())

dispose_pass_manager_builder(bld) =
    ccall((:LLVMPassManagerBuilderDispose, libllvm), Void, (PassBuilderPtr,), bld)

pass_manager_set_opt_level(bld, level) =
    ccall((:LLVMPassManagerBuilderSetOptLevel, libllvm), Void,
          (PassBuilderPtr, Cuint), bld, level)

pass_manager_set_size_level(bld, level) =
    ccall((:LLVMPassManagerBuilderSetSizeLevel, libllvm), Void,
          (PassBuilderPtr, Cuint), bld, level)

pass_manager_builder_set_disable_unit_at_a_time(bld, enable::Bool) =
    ccall((:LLVMPassManagerBuilderSetDisableUnitAtATime, libllvm), Void, 
          (PassBuilderPtr, LLVMBool), bld, enable)

pass_manager_builder_set_unroll_loops(bld, enable::Bool) =
    ccall((:LLVMPassManagerBuilderSetDisableUnrollLoops, libllvm), Void,
          (PassBuilderPtr, LLVMBool), bld, enable)

pass_manager_builder_set_disable_simplify_lib_calls(bld, enable::Bool) =
    ccall((:LLVMPassManagerBuilderSetDisableUnitAtATime, libllvm), Void,
          (PassBuilderPtr, LLVMBool), bld, enable)

pass_manager_builder_use_inliner_with_threshold(bld, thresh) = 
    ccall((:LLVMPassManagerBuilderUseInlinerWithThreshold, libllvm), Void,
          (PassBuilderPtr, Cuint), bld, thresh)

pass_manager_builder_populate_func_pass_manager(bld, pm) =
    ccall((:LLVMPassManagerBuilderPopulateFunctionPassManager, libllvm), Void,
          (PassBuilderPtr, PassManagerPtr), bld, pm)

pass_manager_builder_populate_module_pass_manager(bld, pm) = 
    ccall((:LLVMPassManagerBuilderPopulateModulePassManager, libllvm), Void,
          (PassBuilderPtr, PassManagerPtr), bld, pm)

pass_manager_builder_populate_lto_pass_manager(bld, pm, a1, a2) =
    ccall((:LLVMPassManagerBuilderPopulateLTOPassManager, libllvm), Void,
          (PassBuilderPtr, PassManagerPtr, Uint8, Uint8), bld, pm, a1, a2)

pass_manager_builder_set_lib_info(bld, tinfo) =
    ccall((:LLVM_General_PassManagerBuilderSetLibraryInfo, libllvmgeneral), Void,
          (PassBuilderPtr, TargetLibInfoPtr), bld, tinfo)

#------------------------------------------------------------------------------
# Raw OStream 
#------------------------------------------------------------------------------

function ostreamcb(ptr::Ptr{Void}, data::Ptr{Void})
    (callback, _) = unsafe_pointer_to_objref(data)::(Function,IOBuffer)
    callback(RawOStreamPtr(ptr))
    return nothing
end
const c_ostream_cb = cfunction(ostreamcb, Void, (Ptr{Void}, Ptr{Void}))

with_file_raw_ostream(f::Function, filename, excl::Bool) = begin
    payload = (f, IOBuffer())
    errptr  = Ptr{Uint8}[0]
    status  = zero(LLVMBool) 
    try
        status = ccall((:LLVM_General_WithFileRawOStream, libllvmgeneral), LLVMBool,
                       (Ptr{Uint8}, LLVMBool, LLVMBool, Ptr{Ptr{Uint8}}, Ptr{Void}, Any),
                       filename, excl, binary, errptr, c_ostream_cb, payload)
        if status != zero(LLVMBool)
            errptr[1] == C_NULL ? error("unknown error in `with_file_raw_ostream`") :
                                  error(bytestring(errptr[1]))
        end
    catch ex
        rethrow(ex)
    end
    return 
end 

function savebuffercb(ptr::Ptr{Void}, len::Csize_t, data::Ptr{Void})
    (callback, buff) = unsafe_pointer_to_objref(data)::(Function,IOBuffer)
    Base.write(buff, ptr, len)
    return nothing
end
const c_savebuffer_cb = cfunction(savebuffercb, Void, (Ptr{Void}, Csize_t, Ptr{Void}))

with_buff_raw_ostream(f::Function) = begin
    payload = (f, IOBuffer())
    ccall((:LLVM_General_WithBufferRawOStream, libllvmgeneral), Void,
          (Ptr{Void}, Ptr{Void}, Any), c_savebuffer_cb, c_ostream_cb, payload)
    return payload[2]
end 

#------------------------------------------------------------------------------
# SMDiagnostic
#------------------------------------------------------------------------------

create_sm_diagnostic() = 
    ccall((:LLVM_General_CreateSMDiagnostic, libllvmgeneral), SMDiagnosticPtr, ()) 

dispose_sm_diagnostic(smd) =
    ccall((:LLVM_General_DisposeSMDiagnostic, libllvmgeneral), Void, (SMDiagnosticPtr,), smd)

get_sm_diagnostic_kind(smd) =
    ccall((:LLVM_General_GetSMDiagnosticKind, libllvmgeneral), DiagnosticKind,
          (SMDiagnosticPtr,), smd)

get_sm_diagnostic_lineno(smd) =
    ccall((:LLVM_General_GetSMDiagnosticLineNo, libllvmgeneral), Cuint,
          (SMDiagnosticPtr,), smd)

get_sm_diagnostic_colno(smd) =
    ccall((:LLVM_General_GetSMDiagnosticColumnNo, libllvmgeneral), Cuint,
          (SMDiagnosticPtr,), smd)

get_sm_diagnostic_filename(smd) = begin
    szptr = Cuint[0]
    ptr = ccall((:LLVM_General_GetSMDiagnosticFilename, libllvmgeneral), Ptr{Uint8},
                (SMDiagnosticPtr, Ptr{Cuint}), smd, szptr) 
    return bytestring(ptr, szptr[1])
end

get_sm_diagnostic_message(smd) = begin
    szptr = Cuint[0]
    ptr = ccall((:LLVM_General_GetSMDiagnosticMessage, libllvmgeneral), Ptr{Uint8},
                (SMDiagnosticPtr, Ptr{Cuint}), smd, szptr)
    return bytestring(ptr, szptr[1])
end

get_sm_diagnostic_line_contents(smd) = begin
    szptr = Cuint[0]
    ptr = ccall((:LLVM_General_GetSMDiagnosticLineContents, libllvmgeneral), Ptr{Uint8},
                (SMDiagnosticPtr, Ptr{Cuint}), smd, szptr)
    return bytestring(ptr, szptr[1])
end

#------------------------------------------------------------------------------
# Target 
#------------------------------------------------------------------------------

init_native_target() = 
    ccall((:LLVM_General_InitializeNativeTarget, libllvmgeneral), LLVMBool, ()) == 0

lookup_target(arch, ctriple, tripleout, cerr) = begin
    tripleout, cerr = Ptr{Uint8}[0], Ptr{Uint8}[0]
    target = ccall((:LLVM_General_LookupTarget, libllvmgeneral), TargetPtr,
                   (Ptr{Uint8}, Ptr{Uint8}, Ptr{Ptr{Uint8}}, Ptr{Ptr{Uint8}}),
                   arch, ctriple, tripleout, cerr)
    return (target, bytestring(tripleout[1]), bytestring(cerr[1]))
end

create_target_opts() =
    ccall((:LLVM_General_CreateTargetOptions, libllvmgeneral), TargetOptionsPtr, ())

set_target_opt_flag(topt, flag) =
    ccall((:LLVM_General_SetTargetOptionFlag, libllvmgeneral), LLVMBool,
          (TargetOptionsPtr, TargetOptionFlag), topt, flag) == 0

get_target_opt_flag(topt, flag) =
    ccall((:LLVM_General_GetTargetOptionFlag, libllvmgeneral), LLVMBool,
          (TargetOptionsPtr, TargetOptionFlag), topt, flag) == 0

set_stack_align_override(topt, val) =
    ccall((:LLVM_General_SetStackAlignmentOverride, libllvmgeneral), Void, 
          (TargetOptionsPtr, Cuint), topt, val)

get_stack_align_override(topt) =
    ccall((:LLVM_General_GetStackAlignmentOverride, libllvmgeneral), Cuint,
          (TargetOptionsPtr,), topt)

set_trap_func_name(topt, name) = 
    ccall((:LLVM_General_SetTrapFuncName, libllvmgeneral), Void,
          (TargetOptionsPtr, Ptr{Uint8}), topt, name)

get_trap_func_name(topt) =
    bytestring(ccall((:LLVM_General_GetTrapFuncName, libllvmgeneral), Ptr{Uint8},
                     (TargetOptionsPtr,), topt))

set_float_abi_type(topt, abitype) =
    ccall((:LLVM_General_SetFloatABIType, libllvmgeneral), Void,
          (TargetOptionsPtr, FloatABIType), topt, abitype)

get_float_abi_type(topt) =
    ccall((:LLVM_General_GetFloatABIType, libllvmgeneral), FloatABIType,
          (TargetOptionsPtr,), topt)

set_allow_fpopt_fusion(topt, mode) =
    ccall((:LLVM_General_SetAllowFPOpFusion, libllvmgeneral), Void,
          (TargetOptionsPtr, FPOpFusionMode), topt, mode)

get_allow_fpopt_fusion(topt) =
    ccall((:LLVM_General_GetAllowFPOpFusion, libllvmgeneral), FPOpFusionMode,
          (TargetOptionsPtr,), topt)

dispose_target_opts(topts) =
    ccall((:LLVM_General_DisposeTargetOptions, libllvmgeneral), Void,
          (TargetOptionsPtr,), topts)

create_target_machine(target, triple, cpu, features,
                      topts, reloc_model, code_model, optlevel) = begin
    ccall((:LLVM_General_CreateTargetMachine, libllvmgeneral), TargetMachinePtr,
          (TargetPtr, Ptr{Uint8}, Ptr{Uint8}, Ptr{Uint8}, TargetOptionsPtr,
           RelocModel, CodeModel, CodeGenOptLevel),
           target, triple, cpu, features, topts, reloc_model, code_model, optlevel)
end

dispose_target_machine(tmachine) =
    ccall((:LLVMDisposeTargetMachine, libllvm), Void, (TargetMachinePtr,), tmachine)

target_machine_emit(tmachine, mod, code_gen_ftype, dest) = begin
    errptr = Ptr{Uint8}[0]
    res = ccall((:LLVM_General_TargetMachineEmit, libllvmgeneral), LLVMBool,
                (TargetMachinePtr, ModulePtr, CodeGenFileType, Ptr{Ptr{Uint8}}, RawOStreamPtr),
                tmachine, mod, code_gen_ftype, errmsg, dest)
    #TODO: errsmg
    return res
end

get_target_lowering(tmachine) = 
    ccall((:LLVM_General_GetTargetLowering, libllvmgeneral), TargetLoweringPtr,
          (TargetMachinePtr,), tmachine)

get_default_target_triple() = begin
    ptr = ccall((:LLVM_General_GetDefaultTargetTriple, libllvmgeneral), Ptr{Uint8}, ())
    res = bytestring(ptr)
    Base.c_free(ptr)
    return res
end

get_process_target_triple() = begin
    ptr = ccall((:LLVM_General_GetProcessTargetTriple, libllvmgeneral), Ptr{Uint8}, ())
    res = bytestring(ptr)
    Base.c_free(ptr)
    return res
end

get_host_cpu_name() = begin
    sz  = Csize_t[0]
    ptr = ccall((:LLVM_General_GetHostCPUName, libllvmgeneral), Ptr{Uint8}, (Ptr{Csize_t},), sz)
    buf = pointer_to_array(ptr, (sz[1],), true)
    return bytestring(buf)
end

get_host_cpu_features() = begin
    ptr = ccall((:LLVM_General_GetHostCPUFeatures, libllvmgeneral), Ptr{Uint8}, ())
    res = bytestring(ptr)
    Base.c_free(ptr)
    return res
end

get_target_machine_datalayout(tmachine) = begin
    ptr = ccall((:LLVM_General_GetTargetMachineDataLayout, libllvmgeneral), Ptr{Uint8},
                (TargeMachinePtr,), tmachine)
    res = bytestring(ptr)
    Base.c_free(ptr)
    return res
end

create_target_lib_info(triple) =
    ccall((:LLVM_General_CreateTargetLibraryInfo, libllvmgeneral), TargetLibInfoPtr,
          (Ptr{Uint8},), triple)

get_lib_func(tinfo, fnname) = begin
    fnptr = LibFunc[0] 
    ccall((:LLVM_General_GetLibFunc, libllvmgeneral), LLVMBool,
          (TargetLibInfoPtr, Ptr{Uint8}, Ptr{LibFunc}), tinfo, fnname, fnptr)
    return fnptr[1]
end

get_lib_func_name(tinfo, lfunc) = begin
    szptr = Csize_t[0]
    ptr = ccall((:LLVM_General_LibFuncGetName, libllvmgeneral), LLVMBool,
                (TargetLibInfoPtr, LibFunc, Ptr{Csize_t}), tinfo, lfunc, sz)
    buf = pointer_to_array(ptr, (szptr[1],), true)
    return bytestring(buf)
end

set_available_lib_func_name(tinfo, lfunc, name) =
    ccall((:LLVM_General_LibFuncSetAvailableWithName, libllvmgeneral), Void,
          (TargetLibInfoPtr, LibFunc, Ptr{Uint8}), tinfo, lfunc, name)

dispose_target_lib_info(tinfo) =
    ccall((:LLVM_General_DisposeTargetLibraryInfo, libllvmgeneral), Void,
          (TargetLibInfoPtr,), tinfo)

init_all_targets() = 
    ccall((:LLVM_General_InitializeAllTargets, libllvmgeneral), Void, ())

#------------------------------------------------------------------------------
# Type
#------------------------------------------------------------------------------

# http://llvm.org/doxygen/group__LLVMCCoreType.html#ga112756467f0988613faa6043d674d843
get_type_kind(typ) =
    ccall((:LLVMGetTypeKind, libllvm), Uint32, (TypePtr,), typ)

# http://llvm.org/doxygen/group__LLVMCCoreTypeInt.html#gadfb8ba2f605f0860a4bf2e3c480ab6a2
get_int_type_width(typ) = 
    ccall((:LLVMGetIntTypeWidth, libllvm), Uint32, (TypePtr,), typ)

# http://llvm.org/doxygen/group__LLVMCCoreTypeFunction.html#ga2970f0f4d9ee8a0f811f762fb2fa7f82
is_func_var_arg(typ) = 
    bool(ccall((:LLVMIsFunctionVarArg, libllvm), LLVMBool, (TypePtr,), typ))

# http://llvm.org/doxygen/group__LLVMCCoreTypeFunction.html#gacfa4594cbff421733add602a413cae9f
get_return_type(typ) =
    ccall((:LLVMGetReturnType, libllvm), TypePtr, (TypePtr,), typ) 

# http://llvm.org/doxygen/group__LLVMCCoreTypeFunction.html#ga44fa41d22ed1f589b8202272f54aad77
count_param_types(typ) =
    ccall((:LLVMCountParamTypes, libllvm), Cuint, (TypePtr,), typ)

# http://llvm.org/doxygen/group__LLVMCCoreTypeFunction.html#ga83dd3a49a0f3f017f4233fc0d667bda2
get_param_types(typ) = begin
    n = count_param_types(typ)
    n == 0 && return TypePtr[]
    ptyps = Array(TypePtr, n) 
    ccall((:LLVMGetParamTypes, libllvm), Void, (TypePtr, Ptr{TypePtr}), typ, ptyps)
    return ptyps
end 

# http://llvm.org/doxygen/group__LLVMCCoreTypeSequential.html#ga0b03e26a2d254530a9b5c279cdf52257
get_elem_type(typ) = 
    ccall((:LLVMGetElementType, libllvm), TypePtr, (TypePtr,), typ)

# http://llvm.org/doxygen/group__LLVMCCoreTypeFunction.html#ga8b0c32e7322e5c6c1bf7eb95b0961707
func_type(rtyp, ptyps, vaargs::Bool) = begin
    n = length(ptyps)
    ccall((:LLVMFunctionType, libllvm), TypePtr,
          (TypePtr, Ptr{TypePtr}, Cuint, LLVMBool), rtyp, ptyps, n, vaargs)
end

# http://llvm.org/doxygen/group__LLVMCCoreTypeSequential.html#ga299fe6147083678d0494b1b875f542fae
ptr_type(typ, addr) = 
    ccall((:LLVMPointerType, libllvm), TypePtr, (TypePtr, Cuint), typ, addr)

# http://llvm.org/doxygen/group__LLVMCCoreTypeSequential.html#ga124b162b69b5def41dde2fda3668cbd9
get_ptr_address_space(typ) = 
    ccall((:LLVMGetPointerAddressSpace, libllvm), Cuint, (TypePtr,), typ)

# http://llvm.org/doxygen/group__LLVMCCoreTypeSequential.html#ga5ec731adf74fb40bc3b401956d0c6ff2
vector_type(typ, n) = 
    ccall((:LLVMVectorType, libllvm), TypePtr, (TypePtr, Cuint), typ, n)

# what http://llvm.org/doxygen/group__LLVMCCoreTypeSequential.html#gabd1666e080f693e1af0b4018005cd927
array_type(typ, n) =
    ccall((:LLVM_General_ArrayType, libllvmgeneral), TypePtr, (TypePtr, Uint64), typ, n)  

# http://llvm.org/doxygen/group__LLVMCCoreTypeStruct.html#gaff2af74740a22f7d18701f0d8c3e5a6f
struct_type_in_ctx(ctx, typs, packed::Bool) = 
    ccall((:LLVMStructTypeInContext, libllvm), TypePtr, 
          (ContextPtr, Ptr{TypePtr}, Cuint, LLVMBool), ctx, typs, length(typs), packed) 

create_named_stuct(ctx, name) =
    ccall((:LLVM_General_StructCreateNamed, libllvmgeneral), TypePtr,
          (ContextPtr, Ptr{Uint8}), ctx, name)

get_struct_name(typ) = begin
    ptr = ccall((:LLVMGetStructName, libllvm), Ptr{Uint8}, (TypePtr,), typ)
    ptr != C_NULL ? bytestring(ptr) : ""
end

is_literal_struct(typ) =
    bool(ccall((:LLVM_General_StructIsLiteral, libllvmgeneral), LLVMBool, (TypePtr,), typ))

is_opaque_struct(typ) =
    bool(ccall((:LLVM_General_StructIsOpaque, libllvmgeneral), LLVMBool, (TypePtr,), typ))

# http://llvm.org/doxygen/group__LLVMCCoreTypeStruct.html#ga3e940e660375ae0cbdde81c0d8ec91e3
is_packed_struct(typ) =
    bool(ccall((:LLVMIsPackedStruct, libllvm), LLVMBool, (TypePtr,), typ))

# http://llvm.org/doxygen/group__LLVMCCoreTypeStruct.html#gaf32e6d6bcec38b786efbef689b0dddf7
count_struct_elem_types(typ) =
    ccall((:LLVMCountStructElementTypes, libllvm), Cuint, (TypePtr,), typ)

get_struct_elem_types(typ) = begin
    n = count_struct_elem_types(typ)
    n == 0 && return TypePtr[]
    etyps = Array(TypePtr, n)
    ccall((:LLVMGetStructElementTypes, libllvm), Void, (TypePtr, Ptr{TypePtr}), typ, etyps)
    return etyps
end

struct_set_body!(typ, typs, len, packed::Bool) =
    ccall((:LLVMStructSetBody, libllvm), Void,
          (TypePtr, Ptr{TypePtr}, Cuint, LLVMBool), typ, typs, len, packed)

# http://llvm.org/doxygen/group__LLVMCCoreTypeSequential.html#gafb88a5ebd2a8062e105854910dc7ca17
get_vector_size(typ) =
    ccall((:LLVMGetVectorSize, libllvm), Cuint, (TypePtr,), typ)

# what http://llvm.org/doxygen/group__LLVMCCoreTypeSequential.html#ga02dc08041a12265cb700ee469497df63
get_array_length(typ) =
    ccall((:LLVM_General_GetArrayLength, libllvmgeneral), Uint64, (TypePtr,), typ)

# http://llvm.org/doxygen/group__LLVMCCoreTypeOther.html#ga1c78ca6d7bf279330b9195fa52f23828
void_type_in_ctx(ctx) =
    ccall((LLVMVoidTypeInContext, libllvm), TypePtr, (ContextPtr,), ctx)

# http://llvm.org/doxygen/group__LLVMCCoreTypeInt.html#ga2e5db8cbc30daa156083f2c42989138d
int_type_in_ctx(ctx, nbits) =
    ccall((:LLVMIntTypeInContext, libllvm), TypePtr, (ContextPtr, Uint32), ctx, nbits)

# http://llvm.org/doxygen/group__LLVMCCoreTypeFloat.html#ga3a5332a1d075602bccad7576d1a8e36f
half_type_in_ctx(ctx) =
    ccall((:LLVMHalfTypeInContext, libllvm), TypePtr, (ContextPtr,), ctx)

# http://llvm.org/doxygen/group__LLVMCCoreTypeFloat.html#ga529c83a8a5461e5beac19eb867216e3c
float_type_in_ctx(ctx) =
    ccall((:LLVMFloatTypeInContext, libllvm), TypePtr, (ContextPtr,), ctx)

# http://llvm.org/doxygen/group__LLVMCCoreTypeFloat.html#ga200527010747eab31b73d3e3f6d94935
double_type_in_ctx(ctx) = 
    ccall((:LLVMDoubleTypeInContext, libllvm), TypePtr, (ContextPtr,), ctx)

# http://llvm.org/doxygen/group__LLVMCCoreTypeFloat.html#ga24f77b84b625ed3dd516b52480606093
x86_fp80_type_in_ctx(ctx) = 
    ccall((:LLVMX86FP80TypeInContext, libllvm), TypePtr, (ContextPtr,), ctx)

# http://llvm.org/doxygen/group__LLVMCCoreTypeFloat.html#ga1c02fb08f9ae12a719ed42099d42ccd8
fp128_type_in_ctx(ctx) =
    ccall((:LLVMFP128TypeInContext, libllvm), TypePtr, (ContextPtr,), ctx)

# http://llvm.org/doxygen/group__LLVMCCoreTypeFloat.html#gac2491184fc3d8631c7b264c067f2f761
ppc_fp128_type_in_ctx(ctx) =
    ccall((:LLVMPPCFP128TypeInContext, libllvm), TypePtr, (ContextPtr,), ctx)

# http://llvm.org/doxygen/classllvm_1_1Type.html#a28fdf240b8220065bc60d6d1b1a2f174
md_type_in_ctx(ctx) =
    ccall((:LLVM_General_MetadataTypeInContext, libllvmgeneral), TypePtr, (ContextPtr,), ctx)

#------------------------------------------------------------------------------
# User 
#------------------------------------------------------------------------------

isa_user(val) = 
    ccall((:LLVMIsAUser, libllvm), UserPtr, (ValuePtr,), val)

get_first_use(usr) = 
    ccall((:LLVMGetFirstUse, libllvm), UserPtr, (UserPtr,), usr)

get_next_use(usr) =
    ccall((:LLVMGetNextUse, libllvm), UserPtr, (UserPtr,), usr)

get_num_operands(usr) =
    ccall((:LLVMGetNumOperands, libllvm), Cuint, (UserPtr,), usr)
    
get_operand(usr, n) = begin
    (n < 1 || n > get_num_operands(usr)) && throw(BoundsError())
    vptr = ccall((:LLVMGetOperand, libllvm), ValuePtr, (UserPtr, Cuint), usr, n-1)
    isa_constant(vptr) ? ConstPtr(vptr.ptr) : vptr
end

#------------------------------------------------------------------------------
# Value 
#------------------------------------------------------------------------------

# http://llvm.org/doxygen/group__LLVMCCoreValueGeneral.html#ga12179f46b79de8436852a4189d4451e0
llvm_typeof(val) =
    ccall((:LLVMTypeOf, libllvm), TypePtr, (ValuePtr,), val)

# http://llvm.org/doxygen/group__LLVMCCoreValueGeneral.html#ga70948786725c43968d15225dd584e5a9
get_value_name(val) =
    bytestring(ccall((:LLVMGetValueName, libllvm), Ptr{Uint8}, (ValuePtr,), val))

# http://llvm.org/doxygen/group__LLVMCCoreValueGeneral.html#gac1f61f74d83d218d4943c018e8fd8d13
set_value_name!(val, name) =
    ccall((:LLVMSetValueName, libllvm), Void, (ValuePtr, Ptr{Uint8}), val, name)

# This function exposes the ID returned by llvm::Value::getValueID()
# http://llvm.org/doxygen/classllvm_1_1Value.html#a2983b7b4998ef5b9f51b18c01588af3c
get_value_subclass_id(val) = 
    ccall((:LLVM_General_GetValueSubclassId, libllvmgeneral), Cuint, (ValuePtr,), val)

replace_all_uses_with!(old, new) = 
    ccall((:LLVMReplaceAllUsesWith, libllvm), Void, (ValuePtr, ValuePtr), old, new)

create_argument(val, arg) = 
    ccall((:LLVM_General_CreateArgument, libllvmgeneral), ValuePtr, 
          (ValuePtr, Ptr{Uint8}), val, arg)

dump_value(val) = 
    ccall((:LLVMDumpValue, libllvm), Void, (ValuePtr,), val)

end
