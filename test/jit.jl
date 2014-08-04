using FactCheck

import LLVM
import LLVM: Ast

ast1 = Ast.Mod("run_something", nothing, nothing, [
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

LLVM.FFI.link_in_mcjit()
LLVM.FFI.init_native_target()
#LLVM.FFI.init_all_targets()

const ctx = LLVM.create_ctx()

# AST -> LLVM Module -> LLVM ASM -> LLVM Module -> Ast
mod1 = LLVM.module_from_ast(ctx, ast1) 
asm  = LLVM.module_to_assembly(ctx, mod1)
mod2 = LLVM.module_from_assembly(ctx, ast1.name, asm)
ast2 = LLVM.module_to_ast(ctx, mod2)

@assert ast1 == ast2

#=
LLVM.with_module_from_ast(ctx, ast1) do mod
    LLVM.with_module_in_engine(mod) do em
        em[:foo](7) = 42
        em[:foo](8) = 42
    end 
end 
=#
