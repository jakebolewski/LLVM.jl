#------------------------------------------------------------------------------
# Context 
#------------------------------------------------------------------------------
export Context, create_ctx, global_ctx, dispose!, with_ctx, with_global_ctx

type Context
    handle::ContextPtr
    isglobal::Bool

    Context(ptr::ContextPtr, isglobal::Bool=false) = begin
        ctx = new(ptr, isglobal)
        !isglobal && finalizer(ctx, dispose!)
        return ctx
    end 
end 

Base.convert(::Type{ContextPtr}, ctx::Context) = ctx.handle
Base.(:(==))(ctx1::Context, ctx2::Context) = ctx1.handle === ctx2.handle

create_ctx() = Context(FFI.create_ctx())
global_ctx() = Context(FFI.global_ctx(), true)

isglobalctx(c::Context) = c.isglobal

dispose!(c::Context) = begin
    if !(isnull(c.handle) || isglobalctx(c))
        FFI.dispose_ctx(c.handle)
        c.handle = ContextPtr(C_NULL)
    end 
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
