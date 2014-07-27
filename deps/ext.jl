const libllvmgeneral = find_library(["libllvmgeneral",], ["/home/jake/.julia/v0.3/LLVM/deps/usr/lib"])
@assert(libllvmgeneral != "", """Failed to find required library libllvmgeneral. 
                            Try re-running the package script using Pkg.build("LLVM")""")
const libllvm = find_library(["libLLVM-3.5.0svn"])
@assert(libllvm != "", "Failed to find llvm library libLLVM-3.5.0svn") 
