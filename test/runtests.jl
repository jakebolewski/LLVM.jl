using LLVM.Ast
using Base.Test
using FactCheck 

using DataStructures

facts("Data Layout") do
    context("litle-endian") do
        str = "e"
        @fact string(Ast.DataLayout(endianness=Ast.LittleEndian())) => str
        @fact string(LLVM.parse_datalayout(str)) => str
    end
    
    context("big-endian") do
        str = "E"
        @fact string(Ast.DataLayout(endianness=Ast.BigEndian())) => str
        @fact string(LLVM.parse_datalayout(str)) => str
    end

    context("native") do
        str = "n8:32"
        @fact string(Ast.DataLayout(nativesizes=Set(8,32))) => str 
        @fact string(LLVM.parse_datalayout(str)) => str 
    end

    context("pointerlayouts") do 
        str = "p:8:64"
        as = Ast.AddrSpace(0)
        ai = Ast.AlignmentInfo(64, nothing)
        @fact string(Ast.DataLayout(pointerlayouts=[as=>(8, ai)])) => str
        @fact string(LLVM.parse_datalayout(str)) => str
    end
  
    context("pointerlayouts") do
        str = "p1:8:32:64"
        as = Ast.AddrSpace(1)
        ai = Ast.AlignmentInfo(32, 64)
        @fact string(Ast.DataLayout(pointerlayouts=[as=>(8, ai)])) => str
        @fact string(LLVM.parse_datalayout(str)) => str
    end

    context("big") do
        str = "e-m:e-S128-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-v64:64:64-v128:128:128-f32:32:32-f64:64:64-f80:128:128-a0:0:64-n8:16:32:64"
        dl = Ast.DataLayout(
                endianness=Ast.LittleEndian(),
                mangling=Ast.ELFMangling(),
                stackalignment=128,
                pointerlayouts=[Ast.AddrSpace(0) => (64, Ast.AlignmentInfo(64, 64))],
                typelayouts=OrderedDict(
                             [((Ast.IntegerAlign(),  1), Ast.AlignmentInfo(8, 8)),
                              ((Ast.IntegerAlign(),  8), Ast.AlignmentInfo(8, 8)),
                              ((Ast.IntegerAlign(), 16), Ast.AlignmentInfo(16, 16)),
                              ((Ast.IntegerAlign(), 32), Ast.AlignmentInfo(32, 32)),
                              ((Ast.IntegerAlign(), 64), Ast.AlignmentInfo(64, 64)),
                              ((Ast.VectorAlign(),  64), Ast.AlignmentInfo(64, 64)),
                              ((Ast.VectorAlign(), 128), Ast.AlignmentInfo(128, 128)),
                              ((Ast.FloatAlign(),   32), Ast.AlignmentInfo(32, 32)),
                              ((Ast.FloatAlign(),   64), Ast.AlignmentInfo(64, 64)),
                              ((Ast.FloatAlign(),   80), Ast.AlignmentInfo(128, 128)),
                              ((Ast.AggregateAlign(),0), Ast.AlignmentInfo(0, 64))]),
                nativesizes=Set(8,16,32,64))
        @fact string(dl) => str
        @fact string(LLVM.parse_datalayout(str)) => str
    end
end 

facts("Context") do
    context("simple constructor test") do
        ctx = LLVM.create_ctx()
        @fact isa(ctx, LLVM.Context) => true
        LLVM.dispose_ctx(ctx)
        @fact LLVM.isdisposed(ctx) => true
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
