module LLVM

export Ast

include(joinpath("..", "deps", "ext.jl"))

include("ast.jl")
include("datalayout.jl")

include("types.jl")
include("enums.jl")
include("ffi.jl")

using .Types

include("instrdef.jl")
include("context.jl")
include("diagnostic.jl")
include("module.jl")

end # module
