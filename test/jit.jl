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
                    Ast.Ret(Ast.ConstOperand(Ast.ConstInt(32, 999)))
                )
            ]
        )
    )]
)

facts("test jitting a simple module") do
    
    LLVM.FFI.link_in_mcjit()
    LLVM.FFI.init_native_target()

    LLVM.with_ctx() do ctx
        # AST -> LLVM Module -> LLVM ASM -> LLVM Module -> Ast
        mod1 = LLVM.module_from_ast(ctx, ast1) 
        asm1 = LLVM.module_to_assembly(ctx, mod1)
        mod2 = LLVM.module_from_assembly(ctx, ast1.name, asm1)
        ast2 = LLVM.module_to_ast(ctx, mod2)

        LLVM.FFI.dump_module(mod1)
        LLVM.FFI.dump_module(mod2)

        @fact ast1 => ast2

        @fact LLVM.with_jit(mod1) do eng
            fptr = LLVM.get_function(eng, mod1, "foo")
            ccall(fptr, Int32, (Int32,), 10)
        end => 999

        @fact LLVM.with_jit(mod2) do eng
            fptr = LLVM.get_function(eng, mod2, "foo")
            ccall(fptr, Int32, (Int32,), 10)
        end => 999
    end
end
