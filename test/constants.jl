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
        ast, asm = test_ast(Uint32, one(Uint32), "global i32 1")
    end
end 
