#------------------------------------------------------------------------------
# Module 
#------------------------------------------------------------------------------

typealias ValueHandle Ptr{Void}

immutable ModuleHandle <: LLVMHandle
    ptr::Ptr{Void}
end

encode_llvm(s::String) = begin
    N = length(s)
    ptr = convert(Ptr{Uint8}, Base.c_malloc(sizeof(Uint8) * N + 1))
    unsafe_copy!(ptr, convert(Ptr{Uint8}, s), N)
    unsafe_store!(ptr, zero(Uint8), N+1)
    return ptr
end

decode_llvm(ptr::Ptr{Uint8}) = begin
    return bytestring(ptr)
end 

module_from_ast(ctx::Context, mod::Ast.Module) = begin
    modh = create_module_with_name_in_ctx(mod.name, ctx)    
    if mod.layout != nothing
        set_datalayout(modh, string(mod.layout)) 
    end
    if mod.triple != nothing
        set_target_triple(modh, mod.target)
    end
    for def in mod.defs
        if isa(def, TypeDefinition)
            # todo 
        elseif isa(def, MetadataNodeDefinition)
            # todo
        elseif isa(def, InlineAssembly)
            # todo
        elseif isa(def, GlobalDefinition)
            # todo
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

set_datalayout(mh:ModuleHandle, triple::String) = 
    ccall((:LLVMSetDataLayout, libllvm), Void, (ModuleHandle, Ptr{Uint8}), mh, triple)

get_target_triple(mh::ModuleHandle) =  
    bytestring(ccall((:LLVMGetTarget, libllvm), Ptr{Uint8}, (ModuleHandle,), mh))

set_target_triple(mh::ModuleHandle, triple::String) = 
    ccall((:LLVMSetTarget, libllvm), Void, (ModuleHandle, Ptr{Uint8}), mh, triple)

get_module_id(mh::ModuleHandle) =  
    bytestring(ccall((:LLVM_General_GetModuleIdentifier, :libllvmgeneral), Ptr{Uint8},
                     (ModuleHandle,), mh))

get_first_global(mh::ModuleHandle) = 
    ccall((:LLVMGetFirstGlobal, libllvm), ValueHandle, (ModuleHandle,), mh)

get_next_global(mh::ModuleHandle) = 
    ccall((:LLVMGetNextGlobal, libllvm), ValueHandle, (LLVMValueRef,),GlobalVar)

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

function add_global_in_addr_space()
end 

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
