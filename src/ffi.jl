module FFI

using ..Types

import ..libllvm, ..libllvmgeneral

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
          (ContextPtr, Ptr{Uint8}, SMDiagnosticPtr), ctx, buff, diag)

# Use LLVM's serializer to generate a string of llvm assembly from a module 
write_llvm_assembly!(io, mod) = 
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
isbinaryop(val) =
    ccall((:LLVMIsABinaryOperator, libllvm), BinaryOpPtr, (ValuePtr,), val)

no_signed_wrap(val) =
    bool(ccall((:LLVM_General_HasNoSignedWrap, libllvmgeneral), LLVMBool, (ValuePtr,), val))

no_unsigned_wrap(bal) =
    bool(ccall((:LLVM_General_HasNoUnsignedWrap, libllvmgeneral), LLVMBool, (ValuePtr,), val))

isexact(val) =
    bool(ccall((:LLVM_General_IsExact, libllvmgeneral), LLVMBool, (ValuePtr,), val))

get_fast_math_flags(val) =
    ccall((:LLVM_General_GetFastMathFlags, libllvmgeneral), Cuint, (ValuePtr,), val)

#------------------------------------------------------------------------------
# BitCode 
#------------------------------------------------------------------------------
parse_bitcode(ctx, membuf, str) =
    ccall((:LLVM_General_ParseBitcode, libllvmgeneral), ModulePtr,
          (ContextPtr, MemoryBufferPtr, Ptr{Uint8}), ctx, membuf, str)

write_bitcode(io, mod) = 
    ccall((:LLVM_General_WriteBitcode, libllvmgeneral), Void,
          (ModulePtr, RawOStreamPtr), mod, io)

#------------------------------------------------------------------------------
# Builder 
#------------------------------------------------------------------------------
create_builder_in_ctx(ctx) =
    ccall((:LLVMCreateBuilderInContext, libllvm), BuilderPtr, (ContextPtr,), ctx) 

dispose_builder(bld) =
    ccall((:LLVMDisposeBuilder, libllvm), Void, (BuilderPtr,), bld)

pos_builder_end(bld, bb) = 
    ccall((:LLVMPositionBuilderAtEnd, libllvm), Void, 
          (BuilderPtr, BasicBlockPtr), bld, bb) 

build_ret(bld, val) = 
    ccall((:LLVMPositionBuilderAtEnd, libllvm), InstructionPtr,
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

function build_invoke()
end

function build_resume()
end

function build_unreachable()
end

# XXX TODO builder macros XXX
function build_alloca()
end

function build_load() 
end

function build_store()
end

function build_getelem_ptr()
end

function build_inbounds_getelem_ptr()
end

function build_fence()
end

function build_cmp_xchg()
end

function build_atomic_rmw()
end

function build_icmp()
end

function build_fcmp()
end

function build_phi() 
end

function build_call()
end 

function build_select()
end

function build_vaarg()
end

function build_extract_elem()
end 

function build_insert_elem()
end 

function build_shuffle_vector()
end

function build_extract_value()
end

function build_insert_value()
end 

function build_landing_pad()
end 

function set_fastmath_flags()
end 

#------------------------------------------------------------------------------
# ByteRange Callback 
#------------------------------------------------------------------------------
function wrap_byterange_callback()
end

#------------------------------------------------------------------------------
# CommandLine 
#------------------------------------------------------------------------------
function parse_command_line_opts()
end

#------------------------------------------------------------------------------
# Constant 
#------------------------------------------------------------------------------
function isconstant()
end

function isa_constant()
end

function isa_constant_int()
end

function get_constant_operand()
end

function isa_constant_ptr_null()
end

function get_constant_int_words()
end

function const_float_double_val()
end 

function const_float_val()
end 

function const_strct_in_ctx()
end

function const_named_struct()
end

function get_constant_data_seq_elem_as_const()
end 

const_int_arbitrary_precision(typ::TypePtr, nwords::Integer, words::Vector{Int64}) = 
    ccall((:LLVMConstIntOfArbitraryPrecision, libllvm), ValuePtr,
          (TypePtr, Uint32, Ptr{Int64}), typ, nwords, words)

function const_float_arbitrary_precision()
end

function get_const_float_words()
end

function constant_vector()
end

function constant_null()
end

function constant_array()
end

function constant_cast() 
end 

function constatnt_binary_op()
end

function constant_getelem_ptr()
end

function constant_inbounds_getelem_ptr()
end

function get_constant_cpp_opcode()
end

function get_constant_icmp_predicate() 
end

function get_constant_indices()
end

function block_address()
end

function get_block_address_func()
end

function get_block_address_block()
end


#------------------------------------------------------------------------------
# Context 
#------------------------------------------------------------------------------

# http://llvm.org/doxygen/group__LLVMCCoreContext.html#gaac4f39a2d0b9735e64ac7681ab543b4c
create_ctx() = ccall((:LLVMContextCreate, libllvm), ContextPtr, ())

# http://llvm.org/doxygen/group__LLVMCCoreContext.html#ga0055cde9a9b2497b332d639d8844a810
global_ctx() = ccall((:LLVMGetGlobalContext, libllvm), ContextPtr, ())

# http://llvm.org/doxygen/group__LLVMCCoreContext.html#ga9cf8b0fb4a546d4cdb6f64b8055f5f57
dispose_ctx(ctx::ContextPtr) = 
    ccall((:LLVMContextDispose, libllvm), Void, (ContextPtr,), ctx)

function create_datalayout()
end

function dispose_datalayout()
end

function datalayout_to_string()
end

#------------------------------------------------------------------------------
# Execution Engine 
#------------------------------------------------------------------------------
function create_execution_engine_for_module()
end

function create_interpreter_for_module()
end

function create_jit_compiler_for_module()
end

function create_mcjit_compiler_for_module()
end

function dispose_execution_engine()
end

function add_module()
end

function remove_module()
end

function find_function()
end 

function get_ptr_to_global()
end

function link_in_interpreter()
    ccall((:LLVMLinkInInterpreter, libllvm), Void, ())
end

function link_in_jit()
    ccall((:LLVMLinkInJIT, libllvm), Void, ())
end

function link_in_mcjit()
    ccall((:LLVMLinkInMCJIT, libllvm), Void, ())
end 

function get_mcjit_compiler_opts_size()
end

function init_mcjit_compiler_opts()
end

function set_mcjit_compiler_level()
end

function set_mcjit_compiler_codemodel()
end

function set_mcjit_compiler_no_frame_ptr_elim()
end

function set_mcjit_compiler_enable_fast_isel()
end

#------------------------------------------------------------------------------
# Function 
#------------------------------------------------------------------------------
function get_func_call_cov()
end

function set_func_call_cov()
end

function add_func_attr()
end

function get_func_attr()
end

function get_first_basicblock()
end

function get_last_basicblock()
end

function get_next_basicblock()
end

function append_basicblock_in_ctx()
end 

function count_params()
end

function get_params()
end 

function get_attribute()
end

function set_attribute()
end

function get_func_ret_attr()
end

function add_func_ret_attr()
end

function get_gc()
end

function set_gc()
end

#------------------------------------------------------------------------------
# Global Alias 
#------------------------------------------------------------------------------

# test if a value is a global alias 
function isa_global_alias()
end

# get the constant aliased by this alias
function get_aliasee()
end

# set the constant aliased by this alias
function set_aliasee()
end

#------------------------------------------------------------------------------
# Global Value
#------------------------------------------------------------------------------

function isa_global_value()
end

function get_linkage()
end

set_linkage!(val::GlobalValuePtr, link::Uint32) = 
    ccall((:LLVMSetLinkage, libllvm), Void, (GlobalValuePtr, Uint32), val, link)

function get_section()
end

function set_section()
end

function get_visibility()
end

set_visibility!(val::GlobalValuePtr, vis::Uint32) = 
    ccall((:LLVMSetVisibility, libllvm), Void, (GlobalValuePtr, Uint32), val, vis)

function get_alignment()
end

set_alignment!(val::GlobalValuePtr, bytes::Integer) =
    ccall((:LLVMSetAlignment, libllvm), Void, (GlobalValuePtr, Uint32), val, bytes)

function has_unnamed_addr()
end 

# todo this is exposed by the C API in LLVM 3.5
set_unnamed_addr!(val, hasunamed::Bool) =
    ccall((:LLVM_General_SetUnnamedAddr, libllvmgeneral), Void,
          (ValuePtr, LLVMBool), val, hasunamed)

#------------------------------------------------------------------------------
# Global Variable 
#------------------------------------------------------------------------------

function isa_global_variable()
end

function is_global_constant()
end

set_global_constant!(val::GlobalValuePtr, isconst::Bool) =
    ccall((:LLVMSetGlobalConstant, libllvm), Void, (GlobalValuePtr, LLVMBool), val, isconst)

set_initializer!(val::GlobalValuePtr, constval::ValuePtr) = 
    ccall((:LLVMSetInitializer, libllvm), Void, (GlobalValuePtr, ValuePtr), val, constval)
 
function is_thread_local()
end

set_thread_local!(val::GlobalValuePtr, islocal::Bool) =
    ccall((:LLVMSetThreadLocal, libllvm), Void, (GlobalValuePtr, LLVMBool), val, islocal)

#------------------------------------------------------------------------------
# Inline Assembly
#------------------------------------------------------------------------------

function isa_inline_asm()
end

function create_inline_asm()
end

function get_inline_asm_string()
end

function get_inline_asm_constraint_string()
end

function inline_asm_has_sideeffects()
end

function inline_asm_isalign_stack()
end

function get_inline_asm_dialect()
end 

#------------------------------------------------------------------------------
# Instruction
#------------------------------------------------------------------------------

function get_instr_opcode()
end

function get_instr_def_opcode()
end 

function get_icmp_predicate()
end

function get_fcmp_predicate()
end

function get_instr_call_cov()
end

function set_instr_call_cov()
end

function is_tail_call() 
end

function set_tail_call()
end 

function get_call_instr_called_val()
end 

function get_call_instr_func_attr()
end

function add_call_instr_func_attr()
end

function get_call_instr_attr()
end

function add_call_instr_attr()
end

function add_incoming()
end

function count_incoming()
end 

function get_incoming_val()
end

function get_incoming_block() 
end

function add_case()
end

function get_switch_case()
end

function add_destination()
end

function get_indirect_br_dests()
end

function get_instr_alignment()
end

function set_instr_alignment()
end

function get_alloca_num_elements()
end

function get_allocated_type()
end

function get_atomic_ordering()
end

function get_sync_scope()
end

function get_atomicity()
end 

function get_volatile()
end

function get_inbounds()
end

function get_atomic_rmw_bin_op()
end

function count_instr_struct_idxs()
end

function get_instr_struct_idxs()
end

function add_clause()
end

function set_cleanup()
end

function is_cleanup()
end

function set_metadata()
end

function get_metadata()
end 

#------------------------------------------------------------------------------
# Memory Buffer
#------------------------------------------------------------------------------

function create_mem_buffer_with_contents_of_file()
end

function create_mem_buffer_with_mem_range()
end

function get_buffer_start()
end 

function get_buffer_size()
end 

function dispose_mem_buffer()
end 

#------------------------------------------------------------------------------
# Metadata 
#------------------------------------------------------------------------------

function is_amd_string()
end

function is_amd_node()
end

function get_md_kind_in_ctx()
end

function get_md_kind_names()
end

function md_string_in_ctx()
end

function get_md_string()
end

function create_md_node_in_ctx()
end

function create_tmp_md_node_in_ctx()
end

function destroy_tmp_md_node()
end

function get_md_node_num_operands()
end

function get_md_node_operands()
end

function md_node_is_func_local()
end

function get_named_md_name()
end

function get_named_md_operands()
end

function named_md_add_operands()
end

#------------------------------------------------------------------------------
# Module 
#------------------------------------------------------------------------------
create_module_with_name(name::String) = 
    ccall((:LLVMModuleCreateWithName, libllvm), ModulePtr, (Ptr{Uint8},), name)

create_module_with_name_in_ctx(id::String, ctx::ContextPtr) =
    ccall((:LLVMModuleCreateWithNameInContext, libllvm), ModulePtr,
          (Ptr{Uint8}, ContextPtr), id, ctx)

get_module_ctx(mod::ModulePtr) = 
    ccall((:LLVMGetModuleContext, libllvm), ContextPtr, (ModulePtr,), mod)

dispose_module(mod::ModulePtr) = 
    ccall((:LLVMDisposeModule, libllvm), Void, (ModulePtr,), mod)

get_datalayout(mod::ModulePtr) =
    bytestring(ccall((:LLVMGetDataLayout, libllvm), Ptr{Uint8}, (ModulePtr,), mod))

set_datalayout!(mod::ModulePtr, triple::String) = 
    ccall((:LLVMSetDataLayout, libllvm), Void, (ModulePtr, Ptr{Uint8}), mod, triple)

get_target_triple(mod::ModulePtr) =  
    bytestring(ccall((:LLVMGetTarget, libllvm), Ptr{Uint8}, (ModulePtr,), mod))

set_target_triple(mod::ModulePtr, triple::String) = 
    ccall((:LLVMSetTarget, libllvm), Void, (ModulePtr, Ptr{Uint8}), mod, triple)

get_module_id(mod::ModulePtr) =  
    bytestring(ccall((:LLVM_General_GetModuleIdentifier, libllvmgeneral), Ptr{Uint8}, 
                     (ModulePtr,), mod))

get_first_global(mod::ModulePtr) = 
    ccall((:LLVMGetFirstGlobal, libllvm), GlobalValuePtr, (ModulePtr,), mod)

get_next_global(gv::GlobalValuePtr) = 
    ccall((:LLVMGetNextGlobal, libllvm), GlobalValuePtr, (GlobalValuePtr,), gv)

function get_first_alias()
end

function get_next_alias() 
end

function get_first_func()
end

function get_next_func()
end 

function get_first_named_md()
end 

function get_next_named_md()
end

add_global_in_addr_space!(mod::ModulePtr, typ::TypePtr, name::String, addr::Uint32) = 
    ccall((:LLVMAddGlobalInAddressSpace, libllvm), GlobalValuePtr, 
          (ModulePtr, TypePtr, Ptr{Uint8}, Uint32), mod, typ, name, addr)

function just_add_alias()
end 

function add_function()
end

function get_named_function()
end 

function get_or_add_named_md()
end 

function module_append_inline_asm()
end 

function module_get_inline_asm()
end 

function link_modules()
end 

#------------------------------------------------------------------------------
# Pass Manager 
#------------------------------------------------------------------------------

function create_pass_manager()
end 

function dispose_pass_manager()
end 

function run_pass_manager()
end 

function create_func_pass_manager_for_module() 
end 

function init_func_pass_manager() 
end 

function run_func_pass_manager() 
end 

function finalize_func_pass_manager() 
end 

function add_datalayout_pass() 
end 

function add_analysis_pass()
end 

function add_target_libinfo_pass()
end 

function pass_manager_builder_create()
end 

function dispose_pass_manager_builder()
end

function pass_manager_set_opt_level()
end

function pass_manager_set_size_level()
end

function pass_manager_builder_set_disable_unit_at_a_time()
end

function pass_manager_builder_set_unroll_loops()
end 

function pass_manager_builder_set_disable_simplify_lib_calls()
end 

function pass_manager_builder_use_inliner_with_threshold()
end 

function pass_manager_builder_populate_func_pass_manager()
end

function pass_manager_builder_populate_module_pass_manager()
end

function pass_manager_builder_populate_to_pass_manager()
end

function pass_manager_builder_set_lib_info()
end 

#------------------------------------------------------------------------------
# Raw OStream 
#------------------------------------------------------------------------------

function with_file_raw_ostream()
end 

function with_buff_raw_ostream()
end 

#------------------------------------------------------------------------------
# SMDiagnostic
#------------------------------------------------------------------------------

function create_sm_diagnostic()
end 

function dispose_sm_diagnostic()
end

function get_sm_diagnostic_kind()
end

function get_sm_diagnostic_lineno()
end

function get_sm_diagnostic_colno()
end 

function get_sm_diagnostic_filename()
end

function get_sm_diagnostic_message()
end

function get_sm_diagnostic_line_contents()
end

#------------------------------------------------------------------------------
# Target 
#------------------------------------------------------------------------------

function init_native_target()
    return bool(ccall((:LLVM_General_InitializeNativeTarget, libllvmgeneral), LLVMBool, ()))
end

function lookup_target()
end

function create_target_opts()
end

function set_target_opt_flag()
end

function get_target_opt_flag()
end

function set_stack_align_override()
end

function get_stack_align_override()
end

function set_trap_func_name()
end

function get_trap_func_name()
end

function set_float_abi_type()
end

function get_float_abi_type()
end

function set_allow_fp_opt_fusion()
end

function get_allow_fp_opt_fusion()
end

function dispose_target_opts()
end

function create_target_machine()
end

function dispose_target_machine()
end

function target_machine_emit()
end

function get_target_lowering()
end

function get_default_target_triple()
end

function get_process_target_triple()
end

function get_host_cpu_name()
end

function get_host_cpu_features()
end

function get_target_machine_datalayout()
end

function create_target_lib_info()
end

function get_lib_func()
end

function get_lib_func_name()
end

function set_available_lib_func_name()
end

function dispose_target_lib_info()
end

function init_all_targets()
end

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
function func_type()
#TODO:
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
    ccall((:LLVM_General_ArrayType, libllvm), TypePtr, (TypePtr, Uint64), typ, n)  

# http://llvm.org/doxygen/group__LLVMCCoreTypeStruct.html#gaff2af74740a22f7d18701f0d8c3e5a6f
struct_type_in_ctx(ctx, typs, len, packed::Bool) = 
    ccall((:LLVMStructTypeInContext, libllvm), TypePtr, 
          (ContextPtr, Ptr{TypePtr}, Cuint, LLVMBool), ctx, typs, len, packed) 

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
    ccall((:LLVM_General_GetArrayLength, libllvm), Uint64, (TypePtr,), typ)

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
    
get_operand(usr, n) = 
    ccall((:LLVMGetOperand, libllvm), ValuePtr, (UserPtr, Cuint), usr, n)

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
    ccall((:LLVMValueName, libllvm), Void, (ValuePtr, Ptr{Uint8}), val, name)

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
