#------------------------------------------------------------------------------
# Context 
#------------------------------------------------------------------------------
export Context, create_ctx, global_ctx, dispose_ctx, with_ctx

immutable ContextHandle
    ptr::Ptr{Void}
end 

Base.convert(::Type{Ptr{Void}}, handle::ContextHandle) = handle.ptr

type Context
    handle::ContextHandle

    Context(handle::ContextHandle) = begin
        ctx = new(handle)
        finalizer(ctx, dispose_ctx)
        return ctx
    end 
end 

# http://llvm.org/doxygen/group__LLVMCCoreContext.html#gaac4f39a2d0b9735e64ac7681ab543b4c
function create_ctx()
    return Context(ccall((:LLVMContextCreate, libllvm), ContextHandle, ()))
end

# http://llvm.org/doxygen/group__LLVMCCoreContext.html#ga0055cde9a9b2497b332d639d8844a810
function global_ctx()
    return Context(ccall((:LLVMGetGlobalContext, libllvm), ContextHandle, ()))
end

# http://llvm.org/doxygen/group__LLVMCCoreContext.html#ga9cf8b0fb4a546d4cdb6f64b8055f5f57

function dispose_ctx(c::ContextHandle)
    ccall((:LLVMContextDispose, libllvm), Void, (ContextHandle,), c)
end
dispose_ctx(c::Context) = dispose_ctx(c.handle)

with_ctx(f::Function) = begin
    ctx = create_ctx() 
    try
        f(ctx)
    finally
        dispose_ctx(ctx)
    end
end
