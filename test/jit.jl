using FactCheck

import LLVM
import LLVM: Ast

testast = Ast.Mod("run_something", nothing, nothing, [
    Ast.GlobalDef(
        Ast.Func(
            name = Ast.Name("foo"),
            rettyp = Ast.IntType(32),
            params = [Ast.Param(Int32, Ast.Name("bar"))],
            blocks = [
                Ast.BasicBlock(Ast.Name("test"), 
                    Ast.Ret(Ast.ConstOperand(Ast.ConstInt(32, 42)))
                )
            ]
        )
    )]
)

const ctx = LLVM.global_ctx()

ast = LLVM.module_from_ast(ctx, testast) 
println(LLVM.module_to_assembly(ctx, ast))
