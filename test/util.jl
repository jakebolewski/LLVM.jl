check_bitcode(buf1, buf2) = buf1.data == buf2.data

function check_result(ctx, ast, asm)
    
    mod1 = LLVM.module_from_assembly(ctx, asm)
    mod2 = LLVM.module_from_ast(ctx, ast)

    # check that we can correctly serialize both to assembly / bitcode
    gold = LLVM.module_to_assembly(ctx, mod1)
    test = LLVM.module_to_assembly(ctx, mod2)

    Base.print_with_color(:yellow, gold)
    Base.print_with_color(gold == test ? :green : :red, test)
    Base.print_with_color(:blue, "-"^80 * "\n")

    @fact LLVM.module_to_assembly(ctx, mod1) => LLVM.module_to_assembly(ctx, mod2)
    @fact check_bitcode(LLVM.module_to_bitcode(ctx, mod1), 
                        LLVM.module_to_bitcode(ctx, mod2)) => true
    
    # check that we can lift from assembly to an
    # Ast.Module and perform equality checks on the ast
    @fact LLVM.module_to_ast(ctx, mod1) => ast
    
    # check that we can produce a valid assembly string from the ast
    @fact LLVM.module_to_assembly(ctx, mod2) => asm

    LLVM.FFI.dispose_module(mod1)
    LLVM.FFI.dispose_module(mod2)
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
