#------------------------------------------------------------------------------
# Context 
#------------------------------------------------------------------------------
export Context, create_ctx, global_ctx, dispose_ctx, with_ctx, with_global_ctx

immutable ContextHandle
    ptr::Ptr{Void}
end 

Base.convert(::Type{Ptr{Void}}, handle::ContextHandle) = handle.ptr
Base.(:(==))(h1::ContextHandle, h2::ContextHandle) = h1.ptr === h2.ptr

type Context
    handle::ContextHandle
    isglobal::Bool
    disposed::Bool

    Context(handle::ContextHandle, isglobal=false) = begin
        ctx = new(handle, isglobal, false)
        !isglobal && finalizer(ctx, dispose_ctx)
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

isdisposed(c::Context) = c.disposed

dispose_ctx(c::ContextHandle) = begin
    ccall((:LLVMContextDispose, libllvm), Void, (ContextHandle,), c)
end
dispose_ctx(c::Context) = begin
    if !(isdisposed(c) || isglobalctx(c))
        dispose_ctx(c.handle)
        c.disposed = true 
    end 
end 

with_ctx(f::Function) = begin
    ctx = create_ctx() 
    try
        f(ctx)
    finally
        dispose_ctx(ctx)
    end
end

with_global_ctx(f::Function) = begin
    ctx = global_ctx()
    f(ctx)
end 
