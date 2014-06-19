module LLVM

include(joinpath("..", "deps", "ext.jl"))

include("ast.jl")
include("datalayout.jl")
include("ffi.jl")

end # module
