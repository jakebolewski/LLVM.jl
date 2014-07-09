#------------------------------------------------------------------------------
# Context 
#------------------------------------------------------------------------------
export Context, 
       create_ctx, global_ctx, dispose!, with_ctx, with_global_ctx

immutable ContextHandle <: LLVMHandle
    ptr::Ptr{Void}
end

type Context
    handle::ContextHandle
    isglobal::Bool

    Context(handle::ContextHandle, isglobal=false) = begin
        ctx = new(handle, isglobal)
        !isglobal && finalizer(ctx, dispose!)
        return ctx
    end 
end 

Base.(:(==))(ctx1::Context, ctx2::Context) = ctx1.handle === ctx2.handle

# http://llvm.org/doxygen/group__LLVMCCoreContext.html#gaac4f39a2d0b9735e64ac7681ab543b4c
function create_ctx()
    return Context(ccall((:LLVMContextCreate, libllvm), ContextHandle, ()))
end

# http://llvm.org/doxygen/group__LLVMCCoreContext.html#ga0055cde9a9b2497b332d639d8844a810
function global_ctx()
    return Context(ccall((:LLVMGetGlobalContext, libllvm), ContextHandle, ()), true)
end

isglobalctx(c::Context) = c.isglobal

# http://llvm.org/doxygen/group__LLVMCCoreContext.html#ga9cf8b0fb4a546d4cdb6f64b8055f5f57

dispose!(c::Context) = begin
    if !(isnull(c.handle) || isglobalctx(c))
        dispose!(c.handle)
        c.handle = ContextHandle(C_NULL)
    end 
end 

dispose!(c::ContextHandle) = begin
    ccall((:LLVMContextDispose, libllvm), Void, (ContextHandle,), c)
end

with_ctx(f::Function) = begin
    ctx = create_ctx() 
    try
        f(ctx)
    finally
        dispose!(ctx)
    end
end

with_global_ctx(f::Function) = begin
    ctx = global_ctx()
    f(ctx)
end 
