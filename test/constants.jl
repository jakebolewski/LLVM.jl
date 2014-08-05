using FactCheck 

import LLVM
import LLVM: Ast, IntPred

include("util.jl")

test_ast(typ, val, str) = begin
    ast = Ast.Mod("<string>", nothing, nothing, [
            Ast.GlobalDef(
                Ast.GlobalVar(name=Ast.UnName(0), typ=typ, init=val)),
            Ast.GlobalDef(
                Ast.GlobalVar(name=Ast.UnName(1), typ=Uint32, init=nothing)),
            Ast.GlobalDef(
                Ast.GlobalVar(name=Ast.UnName(2), typ=Uint32, init=nothing)),
        ])
    astr ="""; ModuleID = '<string>'

@0 = $str
@1 = external global i32
@2 = external global i32
"""
    return (ast, astr)
end

LLVM.with_ctx() do ctx
    
    facts("test constants") do

        context("integer") do
            ast, asm = test_ast(Uint32,
                                one(Uint32),
                                "global i32 1")
            check_result(ctx, ast, asm)
        end

        context("wide integer") do
            ast, asm  = test_ast(Ast.IntType(65),
                                 Ast.ConstInt(65,1),
                                 "global i65 1")
            check_result(ctx, ast, asm)
        end

        context("big wide integer") do
            ast, asm = test_ast(Ast.IntType(66),
                                Ast.ConstInt(66, 20000000000000000000),
                                "global i66 20000000000000000000")
            check_result(ctx, ast, asm)
        end

        context("negative wide integer") do
            ast, asm = test_ast(Ast.IntType(65),
                                Ast.ConstInt(65, 36893488147419103231),
                                "global i65 -1")
            check_result(ctx, ast, asm)
        end
        
        context("half") do
            test_float_roundtrip(Float16, ctx, 1e3)
            ast, asm = test_ast(Float16,
                                Ast.ConstFloat(float16(3.5645)),
                                "global half 0xH4321")
            check_result(ctx, ast, asm)
        end
        
        context("single") do
            test_float_roundtrip(Float32, ctx, 1e3)
            ast, asm = test_ast(Float32,
                                Ast.ConstFloat(1.0f0),
                                "global float 1.000000e+00")
            check_result(ctx, ast, asm)
        end
        
        context("double") do
            test_float_roundtrip(Float64, ctx, 1e3)
            ast, asm = test_ast(Float64,
                                Ast.ConstFloat(1.0),
                                "global double 1.000000e+00")
            check_result(ctx, ast, asm)
        end

        # crazy float types are missing...
        
        context("struct") do
            ast, asm = test_ast(Ast.StructType(false, [Uint32, Uint32]),
                                Ast.ConstStruct(nothing, 
                                                false,
                                                [Ast.ConstInt(32, 1), 
                                                 Ast.ConstInt(32, 1)]),
                                "global { i32, i32 } { i32 1, i32 1 }")
            check_result(ctx, ast, asm)
        end 

        context("dataarray") do
            ast, asm = test_ast(Ast.ArrayType(Int32, 3),
                                Ast.ConstArray(Int32, 
                                    [Ast.ConstInt(32, uint32(i)) for i in (1,2,1)]),
                                "global [3 x i32] [i32 1, i32 2, i32 1]")
            check_result(ctx, ast, asm)
        end
        
        context("array") do
            ast, asm = test_ast(
                Ast.ArrayType(Ast.StructType(false, [Uint32]), 3),
                Ast.ConstArray(Ast.StructType(false, [Uint32]),
                    [Ast.ConstStruct(nothing, false, [Ast.ConstInt(32, i)]) for i in (1,2,3)]),
            "global [3 x { i32 }] [{ i32 } { i32 1 }, { i32 } { i32 2 }, { i32 } { i32 3 }]")
            check_result(ctx, ast, asm)
        end
        
        context("undef") do
            ast, asm = test_ast(Int32, Ast.ConstUndef(Int32), "global i32 undef")
            check_result(ctx, ast, asm)
        end
        
        context("binop / cast") do
            ast, asm = test_ast(Int64,
                        Ast.ConstAdd(false, false,
                            Ast.ConstPtrToInt(
                                Ast.ConstGlobalRef(Ptr{Int32}, Ast.UnName(1)), 
                                Int64),
                            Ast.ConstInt(64, 2)),
                         "global i64 add (i64 ptrtoint (i32* @1 to i64), i64 2)")
            check_result(ctx, ast, asm)
        end
        
        context("binop / cast signed/unsigned wrap") do
            ast, asm = test_ast(Int64,
                        Ast.ConstAdd(true, false,
                            Ast.ConstPtrToInt(
                                Ast.ConstGlobalRef(Ptr{Int32}, Ast.UnName(1)),
                                Int64),
                            int64(2)),
                        "global i64 add nsw (i64 ptrtoint (i32* @1 to i64), i64 2)")
            check_result(ctx, ast, asm)
        end

        context("icmp") do
            ast, asm = test_ast(Ast.IntType(1),
                                Ast.ConstICmp(
                                    Ast.SGE(), # todo this sucks
                                    Ast.ConstGlobalRef(Ptr{Int32}, Ast.UnName(1)),
                                    Ast.ConstGlobalRef(Ptr{Int32}, Ast.UnName(2))),
                                "global i1 icmp sge (i32* @1, i32* @2)")
            check_result(ctx, ast, asm) 
        end

        context("getelementptr") do
            ast, asm = test_ast(Ptr{Int32},
                                Ast.ConstGetElementPtr(true,
                                    Ast.ConstGlobalRef(Ptr{Int32}, Ast.UnName(1)),
                                    [Ast.ConstInt(64, 27)]),
                            "global i32* getelementptr inbounds (i32* @1, i64 27)")
            check_result(ctx, ast, asm)
        end

        #LLVM.dispose!(ctx)
    end
end
