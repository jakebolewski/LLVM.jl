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
        ast, asm = test_ast(Ast.IntType(65),
                            Ast.ConstInt(65, 20000000000000000000),
                            "global i66 20000000000000000000")
    end
end 

#=
ctx = LLVM.global_ctx()
ast, asm = test_ast(Uint32, one(Uint32), "global i32 1")
modh = LLVM.module_from_ast(ctx, ast)
res = LLVM.module_to_ast(ctx, modh)
#LLVM.write_assembly("/home/jake/test.llvm", modh)
=#
