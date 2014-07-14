#------------------------------------------------------------------------------
# Context 
#------------------------------------------------------------------------------
export Context, 
       create_ctx, global_ctx, dispose!, with_ctx, with_global_ctx

type Context
    handle::ContextPtr
    isglobal::Bool

    Context(ctx_ptr::ContextPtr, isglobal=false) = begin
        ctx = new(ctx_ptr, isglobal)
        !isglobal && finalizer(ctx, dispose!)
        return ctx
    end 
end 

Base.(:(==))(ctx1::Context, ctx2::Context) = ctx1.handle === ctx2.handle

# http://llvm.org/doxygen/group__LLVMCCoreContext.html#gaac4f39a2d0b9735e64ac7681ab543b4c
function create_ctx()
    return Context(ccall((:LLVMContextCreate, libllvm), ContextPtr, ()))
end

# http://llvm.org/doxygen/group__LLVMCCoreContext.html#ga0055cde9a9b2497b332d639d8844a810
function global_ctx()
    return Context(ccall((:LLVMGetGlobalContext, libllvm), ContextPtr, ()), true)
end

isglobalctx(c::Context) = c.isglobal

# http://llvm.org/doxygen/group__LLVMCCoreContext.html#ga9cf8b0fb4a546d4cdb6f64b8055f5f57

dispose!(c::Context) = begin
    if !(isnull(c.handle) || isglobalctx(c))
        dispose!(c.handle)
        c.handle = ContextHandle(C_NULL)
    end 
end 

dispose!(ctx::ContextPtr) = begin
    ccall((:LLVMContextDispose, libllvm), Void, (ContextPtr,), ctx)
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
