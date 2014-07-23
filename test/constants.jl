using FactCheck 
using LLVM

test_ast(typ, val, str) = begin
    ast = Ast.Module("<string>", nothing, nothing, [
            Ast.GlobalDefinition(
                Ast.GlobalVar(name=Ast.UnName(0), typ=typ, init=val)),
            Ast.GlobalDefinition(
                Ast.GlobalVar(name=Ast.UnName(1), typ=Uint32, init=nothing)),
            Ast.GlobalDefinition(
                Ast.GlobalVar(name=Ast.UnName(2), typ=Uint32, init=nothing)),
        ])
    astr ="; ModuleID = '<string>'\n\n@0 = $str\n\
           \@1 = external global i32\n\
           \@2 = external global i32\n"
    return (ast, astr)
end

facts("test constants") do
    context("integer") do
        ast, asm = test_ast(Uint32,
                            one(Uint32),
                            "global i32 1")
    end

    context("wide integer") do
        ast, asm  = test_ast(Ast.IntType(65),
                             Ast.ConstInt(65,1),
                             "global i65 1")
    end

    context("big wide integer") do
        ast, asm = test_ast(Ast.IntType(65),
                            Ast.ConstInt(65, 20000000000000000000),
                            "global i66 20000000000000000000")
    end
end 

ctx = LLVM.global_ctx()
ast, asm = test_ast(Uint32, one(Uint32), "global i32 1")
modh = LLVM.module_from_ast(ctx, ast)
res = LLVM.module_to_ast(ctx, modh)
