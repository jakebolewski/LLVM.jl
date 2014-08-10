@llvmfunc foo(x::Int32) -> Int32 begin
    @block test begin
        @ret Int32 999
    end
end

ast2 = @LLVM.DSL begin
    @mod begin
        @func foo(bar::Int32) -> Int32 begin
            @block test begin
                @ret @const Int32 999
            end
        end
    end
end

ast1 = Ast.Mod("Factorial", nothing, nothing, [
    Ast.Func(:fac, Int32, (:n::Int32, :y::Int32),
        Ast.BasicBlock(:entry,
            :n <= Ast.ICmp{:EQ}(:n, 1, :test),
            Ast.CondBr(test, :result, :recur)
        ),
        Ast.BasicBlock(:recur,
            :n_1 <= Ast.ISub(n, Int32,),
            Ast.Br(:result)
        ),
        Ast.BasicBlock(:result,
            :fac <= Ast.Phi(Int32, 1, :n_fac_n_1, :fac)
            Ast.Ret(:fac)
        ),
    )
])

@llvmfunc fac(n::Int32, y::Int32) -> Int32 begin

    @r(0) = @type {Int32, Ptr{@r(1)}, Ptr{@r(0)}}
    @r(1) = @type opaque

    @v(0) = @global Int32 1
    @v(1) = @external protected addrspace(3) global Int32, section "foo"
    @v(3) = @unnamed_addr global @r(1)
    @v(4) = @external global Int32[4393948493]
    
    @v(".test") = @thread_local global Int32 0

    @v(three) = @alias private Int32 addrspace(3) Ptr{@v(1)}
    @v(two)   = @alias Int32 addrspace(3) Ptr{@v(three)}

    @define bar() -> Int32 begin
        @v(1) = @call zeroext Int32 foo(@inreg(1::Int32), @signext(4::Int32)) @m(0)
        @ret Int32 @v(1)
    end
 
    @block entry begin
        test = @icmp(eq, n, 1)
        @condbr(test, recur, result)
    end
   
    @block recur begin
        n_1 = @sub(n, 1)
        fac_n_1 = @call(fac, n_1)
        n_fac_n_1 = @mul(n, fac_n_1)
        @br(result)
    end

    @block result begin
        fac = @phi Int32 entry=>1 recur=>n_fac_n_1
        @ret fac
    end

end 
