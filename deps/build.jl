using BinDeps

ENV["JULIA_ROOT"] = abspath(JULIA_HOME, "../../")

cd(joinpath(Pkg.dir(), "LLVM", "deps", "src") )

# Build libLLVMGeneral library
run(`make clean`)
run(`make`)

DIR = abspath(dirname(@__FILE__))
USRDIR = abspath(joinpath(DIR, "usr"))
USRLIBDIR = abspath(joinpath(USRDIR, "lib"))

ispath(USRDIR)    || mkdir(USRDIR)
ispath(USRLIBDIR) || mkdir(USRLIBDIR)

const LIBNAME = "libllvmgeneral.$(BinDeps.shlib_ext)"
mv(LIBNAME, joinpath(USRLIBDIR, LIBNAME))

# Generate ext.jl with hardcoded paths to llvm libraries
LLVMVER = readchomp(`llvm-config --version`)

lv = VersionNumber(map(int, split(LLVMVER, ['.', '-']))...)
if lv.major != 3 || lv.minor < 4
    error("Only llvm versions 3.4 or 3.5 are supported")
end 

LLVM_GENRAL_DIR = Pkg.dir("LLVM", "deps", "usr", "lib")

if isfile(joinpath(DIR, "ext.jl"))
    rm(joinpath(DIR, "ext.jl"))
end

EXTSRC = """
const libllvmgeneral = find_library(["libllvmgeneral",], ["$LLVM_GENRAL_DIR"])
@assert(libllvmgeneral != "", \"\"\"Failed to find required library libllvmgeneral. 
                            Try re-running the package script using Pkg.build("LLVM")\"\"\")
const libllvm = find_library(["libLLVM-$LLVMVER"])
@assert(libllvm != "", "Failed to find llvm library libLLVM-$LLVMVER") 
"""

fh = open(joinpath(DIR, "ext.jl"), "w")
write(fh, EXTSRC)
close(fh)
