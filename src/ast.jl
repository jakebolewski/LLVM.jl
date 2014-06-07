module Ast

abstract LLVMAstNode 

abstract MetadataNode <: LLVMAstNode 
abstract Operand <: LLVMAstNode
abstract CallableOperand <: LLVMAstNode
abstract LLVMLinkage <: LLVMAstNode

typealias LLVMFloat Union(Float16, Float32, Float64)

# -----------------------------------------------------------------------------
# Ast Names
# -----------------------------------------------------------------------------
abstract LLVMName <: LLVMAstNode

type Name <: LLVMName 
    val::String
end

type UnName <: LLVMName 
    val::Int
end 

# -----------------------------------------------------------------------------
# parameter attributes 
# -----------------------------------------------------------------------------
abstract LLVMParamAttribute <: LLVMAstNode

for typ in [:SignExt, :InReg, :SRet, :NoAlias, :ByVal, :NoCapture, :Nest]
    @eval begin
        immutable $typ <: LLVMParamAttribute
        end
    end
end

# -----------------------------------------------------------------------------
# function attributes 
# -----------------------------------------------------------------------------
abstract LLVMFuncAttribute <: LLVMAstNode

immutable Alignment <: LLVMFuncAttribute
    val::Int
end

immutable StackAlignment <: LLVMFuncAttribute
    val::Int
end

for typ in [:NoReturn, :NoUnwind, :ReadNone, :ReadOnly, :NoInline,
            :AlwaysInline, :OptimizeForSize, :StackProtect, :StackProtectReq, 
            :NoRedZone, :NoImplicitFloat, :Naked, :InlineHint, :ReturnsTwice, 
            :UWTable, :NonLazyBind]
@eval begin
        immutable $typ <: LLVMFuncAttribute 
        end
    end
end 

# -----------------------------------------------------------------------------
# Calling Conventions
# -----------------------------------------------------------------------------
abstract LLVMCallConvention <: LLVMAstNode

immutable CConvention <: LLVMCallConvention
end

immutable FastConvention <: LLVMCallConvention 
end

immutable ColdConvention <: LLVMCallConvention
end

immutable NumberedConvention <: LLVMCallConvention
    val::Int
end

# -----------------------------------------------------------------------------
# Pointer Address Space
# -----------------------------------------------------------------------------
immutable AddrSpace <: LLVMAstNode
    val::Int
end

# -----------------------------------------------------------------------------
# Floating Point Format 
# -----------------------------------------------------------------------------
abstract FloatingPointFormat <: LLVMAstNode

immutable IEEE <: FloatingPointFormat
end

immutable DoubleExtended <: FloatingPointFormat
end

immutable PairOfFloats <: FloatingPointFormat
end

# -----------------------------------------------------------------------------
# LLVM Types
# -----------------------------------------------------------------------------
abstract LLVMType <: LLVMAstNode

immutable VoidType <: LLVMType
end

immutable IntType <: LLVMType
    nbits::Int
end

immutable PtrType <: LLVMType
    typ::LLVMType
    addrspace::AddrSpace
end

immutable FPType <: LLVMType
    nbits::Int
    fmt::FloatingPointFormat
end

immutable VecType <: LLVMType
    typ::LLVMType
    len::Int
end

immutable StructType <: LLVMType
    packed::Bool
    typs::Vector{LLVMType}
end

immutable ArrayType <: LLVMType
    typ::LLVMType
    len::Int
end

# NamedTypeReference Name
abstract MetadataType <: LLVMType

# -----------------------------------------------------------------------------
# constants
# -----------------------------------------------------------------------------
abstract LLVMConstant <: LLVMAstNode

immutable ConstInt <: LLVMConstant
    bits::Int
    val::Integer
end

immutable ConstFloat <: LLVMConstant 
    val::LLVMFloat
end

immutable ConstNull <: LLVMConstant
    typ::LLVMType
end

immutable ConstStruct <: LLVMConstant
    name::Union(Nothing, LLVMName)
    packed::Bool
    vals::Vector{LLVMConstant}
end

immutable ConstArray <: LLVMConstant
    typ::LLVMType
    vals::Vector{LLVMConstant}
end

immutable ConstVector{T<:LLVMConstant} <: LLVMConstant
    vals::Vector{T}
end

immutable ConstUndef <: LLVMConstant
    typ::LLVMType
end

immutable BlockAddress <: LLVMConstant
    func::Name
    block::Name
end

immutable ConstGlobalRef <: LLVMConstant
    typ::LLVMType
    name::Name
end

# -----------------------------------------------------------------------------
# Terminal Instructions
# -----------------------------------------------------------------------------
typealias InstructionMetadata Vector{(String, MetadataNode)}

abstract Instruction <: LLVMAstNode 
abstract Terminator <: LLVMAstNode

type Ret <: Terminator
    op::Union(Nothing, Operand)
    metadata::InstructionMetadata
end

type CondBr <: Terminator
    cond::Operand
    tdest::Name
    fdest::Name
    metadata::InstructionMetadata
end

type Br <: Terminator
    dest::Name
    metadata::InstructionMetadata
end

type Switch <: Terminator
    op::Operand
    defaultdest::Name
    dests::Vector{(LLVMConstant, Name)}
    metadata::InstructionMetadata
end

type IndirectBr <: Terminator
    op::Operand
    dests::Vector{Name}
    metadata::InstructionMetadata
end

type Invoke <: Terminator
    convention::LLVMCallConvention
    retattrs::Vector{LLVMParamAttribute}
    func::CallableOperand
    args::Vector{(Operand, Vector{LLVMParamAttribute})}
    funcattrs::Vector{LLVMFuncAttribute}
    retdest::Name
    exdest::Name
    metadata::InstructionMetadata
end

type Resume <: Terminator
    op::Operand
    metadata::InstructionMetadata
end

type Unreachable <: Terminator
    metadata::InstructionMetadata
end

# -----------------------------------------------------------------------------
# Memory Ordering 
# -----------------------------------------------------------------------------
abstract MemoryOrdering <: LLVMAstNode

for typ in [:Unordered, :Monotonic, :Acquire, :Release, 
            :AcquireRelease, :SequentiallyConsistent]
    @eval begin
        immutable $typ <: MemoryOrdering
        end
    end 
end

# -----------------------------------------------------------------------------
# Atomicity
# -----------------------------------------------------------------------------
immutable Atomicity <: LLVMAstNode
    cross_thread::Bool
    memory_ordering::MemoryOrdering
end

# -----------------------------------------------------------------------------
# Landing Pad Clauses 
# -----------------------------------------------------------------------------
abstract LandingPadClause <: LLVMAstNode

immutable CatchClause <: LandingPadClause
    val::LLVMConstant
end

immutable FilterClause <: LandingPadClause
    val::LLVMConstant 
end

# -----------------------------------------------------------------------------
# Atomic Ops 
# -----------------------------------------------------------------------------
abstract AtomicRMWOperation  <: LLVMAstNode

for op in [:Xchg, :Add, :Sub, :And, :Nand, :Or, :Xor, :Max, :Min, :UMax, :Umin]
    typ = symbol(string("Atomic", op))
    @eval begin
        immutable $typ <: AtomicRMWOperation
        end
    end
end

# -----------------------------------------------------------------------------
# Integer, FloatingPoint Comparison Predicates 
# -----------------------------------------------------------------------------
abstract CmpPredicate  <: LLVMAstNode

for typ in [:UNE,:SGT,:ORD,:UGT,:SLE,:OGT,:OLT,:OEQ,:ULT,:SGE,
            :ONE,:True,:OGE,:UEQ,:UGE,:NE,:ULE,:UNO,:SLT,:False,:OLE,:EQ]
    @eval begin
        immutable $typ <: CmpPredicate
        end
    end
end 

typealias IntPredicate Union(EQ, NE, UGT, UGE, ULT, ULE, SGT, SGE, SLT, SLE)

typealias FloatPredicate Union(False, OEQ, OGT, OGE, OLT, OLE, ONE, 
                               ORD, UNO, UEQ, UGT, UGE, ULT, ULE, UNE, True)

# -----------------------------------------------------------------------------
# Visibility 
# -----------------------------------------------------------------------------
abstract Visibility <: LLVMAstNode

immutable DefaultVis <: Visibility
end

immutable HiddenVis <: Visibility
end

immutable ProtectedVis <: Visibility
end

# -----------------------------------------------------------------------------
# Globals 
# -----------------------------------------------------------------------------
abstract LLVMGlobal <: LLVMAstNode

type Parameter <: LLVMAstNode
    typ::LLVMType
    name::LLVMName
    attrs::Vector{LLVMParamAttribute}
end

type BasicBlock <: LLVMAstNode
    name::LLVMName
    insts::Vector{Instruction}
    term::Terminator
end

type GlobalVar <: LLVMGlobal
    name::LLVMName
    linkage::LLVMLinkage
    visibility::Visibility
    addrspace::AddrSpace
    unamed_addr::Bool
    isconst::Bool
    typ::LLVMType
    init::Union(Nothing, LLVMConstant)
    section::Union(Nothing, String)
    alignment::Int
end 

type GlobalAlias <: LLVMGlobal
    name::LLVMName
    linkage::LLVMLinkage
    visibility::Visibility
    typ::LLVMType
    aliasee::LLVMConstant
end

type Func <: LLVMGlobal
    linkage::LLVMLinkage 
    visibility::Visibility
    callingcov::LLVMCallConvention
    retattrs::Vector{LLVMParamAttribute}
    rettyp::LLVMType
    name::LLVMName
    params::Vector{Parameter}
    varargs::Bool
    funcattrs::Vector{LLVMFuncAttribute}
    section::Union(Nothing, String)
    alignment::Int
    gcname::Union(Nothing, String)
    blocks::Vector{BasicBlock}
end 


end
