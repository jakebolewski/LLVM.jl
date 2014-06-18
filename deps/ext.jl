const llvmgeneral = find_library(["libllvmgeneral",],
                                 [Pkg.dir("LLVM", "deps", "usr", "lib"),])
@assert(llvmgeneral != "", """Failed to find required library libllvmgeneral. 
                              Try re-running the package script using Pkg.build(\"LLVM\")""")
