#------------------------------------------------------------------------------
# Module 
#------------------------------------------------------------------------------
typealias LLVMBool Cint

immutable TypeHandle <: LLVMHandle
    ptr::Ptr{Void}
end

int_type_in_ctx(ch::ContextHandle, nbits::Uint32) =
    ccall((:LLVMIntTypeInContext, libllvm), TypeHandle, (ContextHandle, Uint32), ch, nbits)

immutable GlobalValueHandle <: LLVMHandle
    ptr::Ptr{Void}
end

immutable ValueHandle <: LLVMHandle
    ptr::Ptr{Void}
end

set_thread_local!(gvh::GlobalValueHandle, isthreadlocal::Bool) = 
    ccall((:LLVMSetThreadLocal, libllvm), Void, 
          (GlobalValueHandle, LLVMBool), gvh, isthreadlocal)

# todo this is exposed by the C API in LLVM 3.5
set_unnamed_addr!(gvh::GlobalValueHandle, hasunamed::Bool) = 
    ccall((:LLVM_General_SetUnnamedAddr, libllvmgeneral), Void, 
          (GlobalValueHandle, LLVMBool), gvh, hasunamed)

set_global_constant!(gvh::GlobalValueHandle, isconst::Bool) = 
    ccall((:LLVMSetGlobalConstant, libllvm), Void,
          (GlobalValueHandle, LLVMBool), gvh, isconst)

set_initializer!(gvh::GlobalValueHandle, cvh::ValueHandle) = 
    ccall((:LLVMSetInitializer, libllvm), Void, 
          (GlobalValueHandle, ValueHandle), gvh, cvh)

immutable ModuleHandle <: LLVMHandle
    ptr::Ptr{Void}
end

encode_llvm(ctx::Context, s::String) = begin
    N = length(s)
    ptr = convert(Ptr{Uint8}, Base.c_malloc(sizeof(Uint8) * N + 1))
    unsafe_copy!(ptr, convert(Ptr{Uint8}, s), N)
    unsafe_store!(ptr, zero(Uint8), N+1)
    return ptr
end
decode_llvm(ptr::Ptr{Uint8}) = bytestring(ptr)

encode_llvm(ctx::Context, typ::Ast.IntType) = 
    int_type_in_ctx(ctx.handle, uint32(typ.nbits))

encode_llvm(ctx::Context, addr::Ast.AddrSpace) = 
    uint32(addr.val)

encode_llvm(ctx::Context, name::Ast.Name) = name.val
encode_llvm(ctx::Context, name::Ast.UnName) = ""

encode_llvm(ctx::Context, link::Ast.Linkage{:External}) = uint32(0)
encode_llvm(ctx::Context, vis::Ast.DefaultVisibility) = uint32(0)

encode_llvm(ctx::Context, val::Ast.ConstInt) = begin
    v, nbits = val.val, val.nbits
    th = encode_llvm(ctx, Ast.IntType(val.nbits))
    words = Int64[(v >> 64w) & 0xffffffffffffffff for w=0:div(nbits-1, 64)]
    return const_int_arbitrary_precision(th, length(words), words)
end

const_int_arbitrary_precision(th::TypeHandle, nwords::Integer, words::Vector{Int64}) = 
    ccall((:LLVMConstIntOfArbitraryPrecision, libllvm), ValueHandle,
          (TypeHandle, Uint32, Ptr{Int64}), th, nwords, words)

set_alignment!(gvh::GlobalValueHandle, bytes::Integer) =
    ccall((:LLVMSetAlignment, libllvm), Void, (GlobalValueHandle, Uint32), gvh, bytes)

set_linkage!(gvh::GlobalValueHandle, link::Uint32) = begin
    ccall((:LLVMSetLinkage, libllvm), Void, (GlobalValueHandle, Uint32), gvh, link)
end

set_visibility!(gvh::GlobalValueHandle, vis::Uint32) = begin
    ccall((:LLVMSetVisibility, libllvm), Void,
          (GlobalValueHandle, Uint32), gvh, vis)
end

module_from_ast(ctx::Context, mod::Ast.Module) = begin
    modh = create_module_with_name_in_ctx(mod.name, ctx)    
    mod.layout !== nothing && set_datalayout!(modh, mod.layout) 
    mod.target !== nothing && set_target_triple!(modh, mod.target)
    for def in mod.defs
        if isa(def, Ast.TypeDefinition)
            error("unimplemented")
        elseif isa(def, Ast.MetadataNodeDefinition)
            error("unimplemented")
        elseif isa(def, Ast.InlineAssembly)
            error("unimplemented")
        elseif isa(def, Ast.GlobalDefinition)
            local gh::GlobalValueHandle
            local g = def.val 
            if isa(g, Ast.GlobalVar)
                gh = add_global_in_addr_space!(modh,
                                               encode_llvm(ctx, g.typ), 
                                               encode_llvm(ctx, g.name),
                                               encode_llvm(ctx, g.addrspace))
                set_thread_local!(gh, g.threadlocal)
                set_unnamed_addr!(gh, g.unamedaddr)
                set_global_constant!(gh, g.isconst)
                if g.init !== nothing
                    set_initializer!(gh, encode_llvm(ctx, g.init))
                end
                if g.section !== nothing
                    set_section!(gh, g.section)
                end
                set_alignment!(gh, g.alignment)
                #define global <- add global to module encoding state
            elseif isa(g, Ast.GlobalAlias)
                error("unimplemented")
            elseif isa(g, Ast.Function)
                error("unimplemented")
            end
            set_linkage!(gh, encode_llvm(ctx, g.linkage))
            set_visibility!(gh, encode_llvm(ctx, g.visibility))
        end
    end
    return modh
end

create_module_with_name_in_ctx(id::String, ctx::Context) = 
    create_module_with_name_in_ctx(id, ctx.handle)

create_module_with_name_in_ctx(id::String, ctx::ContextHandle) = 
    ccall((:LLVMModuleCreateWithNameInContext,libllvm), ModuleHandle,
          (Ptr{Uint8}, ContextHandle), id, ctx)

create_module_with_name(name::String) = 
    ccall((:LLVMModuleCreateWithName, libllvm), ModuleHandle, (Ptr{Uint8},), name)

get_module_ctx(mh::ModuleHandle) = 
    ccall((:LLVMGetModuleContext, libllvm), ContextHandle, (ModuleHandle,), mh)

dispose_module(mh::ModuleHandle) = 
    ccall((:LLVMDisposeModule, libllvm), Void, (ModuleHandle,), mh)

get_datalayout(mh::ModuleHandle) =
    bytestring(ccall((:LLVMGetDataLayout, libllvm), Ptr{Uint8}, (ModuleHandle,), mh))

set_datalayout!(mh::ModuleHandle, triple::String) = 
    ccall((:LLVMSetDataLayout, libllvm), Void, (ModuleHandle, Ptr{Uint8}), mh, triple)

get_target_triple(mh::ModuleHandle) =  
    bytestring(ccall((:LLVMGetTarget, libllvm), Ptr{Uint8}, (ModuleHandle,), mh))

set_target_triple!(mh::ModuleHandle, triple::String) = 
    ccall((:LLVMSetTarget, libllvm), Void, (ModuleHandle, Ptr{Uint8}), mh, triple)

get_module_id(mh::ModuleHandle) =  
    bytestring(ccall((:LLVM_General_GetModuleIdentifier, :libllvmgeneral), Ptr{Uint8},
                     (ModuleHandle,), mh))

get_first_global(mh::ModuleHandle) = 
    ccall((:LLVMGetFirstGlobal, libllvm), GlobalValueHandle, (ModuleHandle,), mh)

get_next_global(mh::ModuleHandle) = 
    ccall((:LLVMGetNextGlobal, libllvm), GlobalValueHandle, (LLVMValueRef,),GlobalVar)

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

add_global_in_addr_space!(mh::ModuleHandle, th::TypeHandle, name::String, addr::Uint32) = 
    ccall((:LLVMAddGlobalInAddressSpace, libllvm), GlobalValueHandle, 
          (ModuleHandle, TypeHandle, Ptr{Uint8}, Uint32), mh, th, name, addr)

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
