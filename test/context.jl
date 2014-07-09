using FactCheck 
using LLVM

facts("Context") do
    context("simple constructor test") do
        ctx = LLVM.create_ctx()
        @fact isa(ctx, LLVM.Context) => true
        LLVM.dispose!(ctx)
        @fact LLVM.isnull(ctx.handle) => true
    end

    context("simple global context constructor test") do
        ctx1 = LLVM.global_ctx()
        ctx2 = LLVM.global_ctx()
        @fact ctx1 => ctx2
    end

    context("simple with context constructor test") do
        LLVM.with_ctx() do ctx
            @fact isa(ctx, LLVM.Context) => true
        end
    end 

    context("simple with global context constructor test") do
        LLVM.with_global_ctx() do ctx
            @fact isa(ctx, LLVM.Context) => true
            @fact LLVM.isglobalctx(ctx) => true
        end
    end
end
