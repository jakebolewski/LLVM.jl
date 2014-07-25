using FactCheck 
using LLVM

check_bitcode(buf1, buf2) = buf1.data == buf2.data

function check_result(ast, asm)
    LLVM.with_global_ctx() do ctx
        
        mod1 = LLVM.module_from_assembly(ctx, asm)
        mod2 = LLVM.module_from_ast(ctx, ast)

        # check that we can correctly serialize both to assembly / bitcode
        @fact LLVM.module_to_assembly(ctx, mod1) => LLVM.module_to_assembly(ctx, mod2)
        @fact check_bitcode(LLVM.module_to_bitcode(ctx, mod1), 
                            LLVM.module_to_bitcode(ctx, mod2)) => true
        
        # check that we can lift from assembly to an
        # Ast.Module and perform equality checks on the ast
        @fact LLVM.module_to_ast(ctx, mod1) => ast
        
        # check that we can produce a valid assembly string from the ast
        @fact LLVM.module_to_assembly(ctx, mod2) => asm
    end 
end

test_float_roundtrip{T}(::Type{T}, ctx, n) = begin
    for i = 1:n
        v  = rand(T)
        a1 = LLVM.Ast.ConstFloat(v)
        
        es = LLVM.EncodeState(ctx)
        c  = LLVM.encode_llvm(es, a1)

        ds = LLVM.DecodeState(ctx)
        a2 = LLVM.decode_llvm(ds, c)
        @assert a1 == a2
    end 
end 

const ctx = LLVM.global_ctx()

test_ast(typ, val, str) = begin
    ast = Ast.Module("<string>", nothing, nothing, [
            Ast.GlobalDefinition(
                Ast.GlobalVar(name=Ast.UnName(0), typ=typ, init=val)),
            Ast.GlobalDefinition(
                Ast.GlobalVar(name=Ast.UnName(1), typ=Uint32, init=nothing)),
            Ast.GlobalDefinition(
                Ast.GlobalVar(name=Ast.UnName(2), typ=Uint32, init=nothing)),
        ])
    astr ="""; ModuleID = '<string>'

@0 = $str
@1 = external global i32
@2 = external global i32
"""
    return (ast, astr)
end


facts("test constants") do
    context("integer") do
        ast, asm = test_ast(Uint32,
                            one(Uint32),
                            "global i32 1")
        check_result(ast, asm)
    end

    context("wide integer") do
        ast, asm  = test_ast(Ast.IntType(65),
                             Ast.ConstInt(65,1),
                             "global i65 1")
        check_result(ast, asm)
    end

    context("big wide integer") do
        ast, asm = test_ast(Ast.IntType(66),
                            Ast.ConstInt(66, 20000000000000000000),
                            "global i66 20000000000000000000")
        check_result(ast, asm)
    end

    context("negative wide integer") do
        ast, asm = test_ast(Ast.IntType(65),
                            Ast.ConstInt(65, 36893488147419103231),
                            "global i65 -1")
        check_result(ast, asm)
    end
    
    context("half") do
        test_float_roundtrip(Float16, ctx, 1e3)
        ast, asm = test_ast(Float16,
                            Ast.ConstFloat(float16(3.5645)),
                            "global half 0xH4321")
        check_result(ast, asm)
    end

    context("single") do
        test_float_roundtrip(Float32, ctx, 1e3)
        ast, asm = test_ast(Float32,
                            Ast.ConstFloat(1.0f0),
                            "global float 1.000000e+00")
        check_result(ast, asm)
    end
    
    context("double") do
        test_float_roundtrip(Float64, ctx, 1e3)
        ast, asm = test_ast(Float64,
                            Ast.ConstFloat(1.0),
                            "global double 1.000000e+00")
        check_result(ast, asm)
    end

    # crazy float types are missing...
    
    context("struct") do
        ast, asm = test_ast(Ast.StructType(false, [Uint32, Uint32]),
                            Ast.ConstStruct(nothing, 
                                            false,
                                            [Ast.ConstInt(32, 1), 
                                             Ast.ConstInt(32, 1)]),
                            "global { i32, i32 } { i32 1, i32 1 }")
        check_result(ast, asm)
    end 

    context("dataarray") do
        ast, asm = test_ast(Ast.ArrayType(Uint32, 3),
                            Ast.ConstArray(Ast.ArrayType(Uint32, 3),
                                [Ast.ConstInt(32, uint32(i)) for i in (1,2,1)]),
                            "global [3 x i32] [i32 1, i32 2, i32 1]")
        check_result(ast, asm)
    end
    
    #=
    context("array") do
        ast, asm = test_ast(
            Ast.ArrayType(Ast.StructType(false, [Uint32]), 3),
            Ast.ConstArray(Ast.StructType(false, [Uint32]),
                [Ast.ConstStruct(nothing, false, [Ast.ConstInt(32, i)]) 
                 for i in (1,2,3)]),
        "global [3 x { i32 }] [{ i32 } { i32 1 }, { i32 } { i32 2 }, { i32 } { i32 1 }]")
        check_result(ast, asm)
    end
    =#

    context("undef") do
        ast, asm = test_ast(Int32, Ast.ConstUndef(Int32), "global i32 undef")
        check_result(ast, asm)
    end
end

#=
ast, asm = test_ast(
    Ast.ArrayType(Ast.StructType(false, [Uint32]), 3),
    Ast.ConstArray(Ast.StructType(false, [Uint32]),
        [Ast.ConstStruct(nothing, false, [Ast.ConstInt(32, i) for i=(1,2,3)])]),
    "global [3 x { i32 }] [{ i32 } { i32 1 }, { i32 } { i32 2 }, { i32 } { i32 1 }]")
mod = LLVM.module_from_assembly(ctx, asm)
res = LLVM.module_to_ast(ctx, mod)
=#
