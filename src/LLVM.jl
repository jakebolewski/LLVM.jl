module LLVM

export Ast

include(joinpath("..", "deps", "ext.jl"))

include("ast.jl")
include("datalayout.jl")

include("ffi.jl")

import .FFI: ContextPtr, TypePtr, GlobalValuePtr, ValuePtr, ModulePtr, 
             isnull 

#include("enums.jl")
include("context.jl")
include("module.jl")

end # module
