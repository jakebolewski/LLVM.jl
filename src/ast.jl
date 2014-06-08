module Ast

abstract LLVMAstNode 

abstract LandingPadClause

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
abstract ParamAttribute <: LLVMAstNode

for typ in [:SignExt, :InReg, :SRet, :NoAlias, :ByVal, :NoCapture, :Nest]
    @eval begin
        immutable $typ <: ParamAttribute
        end
    end
end

# -----------------------------------------------------------------------------
# function attributes 
# -----------------------------------------------------------------------------
abstract FuncAttribute <: LLVMAstNode

immutable Alignment <: FuncAttribute
    val::Int
end

immutable StackAlignment <: FuncAttribute
    val::Int
end

for typ in [:NoReturn, :NoUnwind, :ReadNone, :ReadOnly, :NoInline,
            :AlwaysInline, :OptimizeForSize, :StackProtect, :StackProtectReq, 
            :NoRedZone, :NoImplicitFloat, :Naked, :InlineHint, :ReturnsTwice, 
            :UWTable, :NonLazyBind]
@eval begin
        immutable $typ <: FuncAttribute 
        end
    end
end 

# -----------------------------------------------------------------------------
# Calling Conventions
# -----------------------------------------------------------------------------
abstract CallingConvention <: LLVMAstNode

immutable CConvention <: CallingConvention
end

immutable FastConvention <: CallingConvention
end

immutable ColdConvention <: CallingConvention
end

immutable NumConvention <: CallingConvention
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
# Comparison Predicates
# -----------------------------------------------------------------------------
abstract CmpPredicate <: LLVMAstNode

for typ in [:UNE,:SGT,:ORD,:UGT,:SLE,:OGT,:OLT,:OEQ,:ULT,:SGE,
            :ONE,:True,:OGE,:UEQ,:UGE,:NE,:ULE,:UNO,:SLT,:False,:OLE,:EQ]
    @eval begin 
        immutable $typ <: CmpPredicate
        end 
    end 
end 

typealias IntPredicate Union(EQ, NE, UGT, UGE, ULT, ULE, SGT, SGE, SLT, SLE)

typealias FloatPredicate Union(False, OEQ, OGT, OGE, OLT, OLE, ONE, ORD, 
                               UNO, UEQ, UGT, UGE, ULT, ULE, UNE, True)

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
# Inline Assembly 
# http://llvm.org/docs/LangRef.html#inline-assembler-expressions
# ----------------------------------------------------------------------------- 
abstract Dialect 

# dialect of assembly used in an inline assembly string
immutable ATTDialect <: Dialect end
immutable IntelDialect <: Dialect end

# Used with 'Call' instruction
type InlineAssembly <: LLVMAstNode 
    typ::LLVMType
    assembly::String
    constraints::String
    has_side_effects::Bool
    alignstack::Bool
    dialect::Dialect
end 

# -----------------------------------------------------------------------------
# Operand 
# ----------------------------------------------------------------------------- 

# 'MetadataNodeId' is a unique number for identifying a metadata node
immutable MetadataNodeID
    val::Int
end 

# http://llvm.org/docs/LangRef.html#metadata
abstract LLVMMetadata <: LLVMAstNode

immutable MetadataNode <: LLVMMetadata
    val::Vector{Union(Nothing, Operand)}
end 

immutable MetadataNodeRef <: LLVMMetadata
    val::MetadataNodeID
end

# an 'Operand' is roughly an argument to a 'LLVM.Ast.Instruction' 
abstract Operand <: LLVMAstNode

# %foo 
type LocalRef <: Operand 
    typ::LLVMType 
    name::LLVMName
end 

type ConstOperand <: Operand 
    val::ConstOperand
end 

type MetadataStrOperand <: Operand
    val::String
end

type MetadataNodeOperand <: Operand
    val::MetadataNode
end 

# the 'LLVM.Ast.Call' instruction is special.  As the callee can be inline asm
typealias CallableOperand Union(Operand, InlineAssembly)

# -----------------------------------------------------------------------------
# Constant
# -----------------------------------------------------------------------------
abstract LLVMConstant <: LLVMAstNode

# TODO: it might make more sense to treat these as literal Julia values,
# and infer bits from the type
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
abstract Terminator <: LLVMAstNode

typealias InstructionMetadata Vector{(String, MetadataNode)}

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
    convention::CallingConvention
    retattrs::Vector{ParamAttribute}
    func::CallableOperand
    args::Vector{(Operand, Vector{ParamAttribute})}
    funcattrs::Vector{FuncAttribute}
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
# Non-Terminal Instructions
# http://llvm.org/docs/LangRef.html#binaryops
# http://llvm.org/docs/LangRef.html#bitwiseops
# http://llvm.org/docs/LangRef.html#memoryops
# http://llvm.org/docs/LangRef.html#otherops
# -----------------------------------------------------------------------------
abstract Instruction <: LLVMAstNode 
abstract FastMathFlags <: LLVMAstNode 

type Add <: Instruction
    nsw::Bool
    nuw::Bool
    op1::Operand
    op2::Operand
    metadata::InstructionMetadata
end

type FAdd <: Instruction
    fmflags::FastMathFlags
    op1::Operand
    op2::Operand
    metadata::InstructionMetadata
end

type Sub <: Instruction
    nsw::Bool
    nuw::Bool
    op1::Operand
    op2::Operand
    metadata::InstructionMetadata
end

type FSub <: Instruction
    fmflags::FastMathFlags
    op1::Operand
    op2::Operand
    metadata::InstructionMetadata
end

type Mul <: Instruction
    nsw::Bool
    nuw::Bool
    op1::Operand
    op2::Operand
    metadata::InstructionMetadata
end

type FMul <: Instruction
    fmflags::FastMathFlags
    op1::Operand
    op2::Operand
    metadata::InstructionMetadata
end

type UDiv <: Instruction
    exact::Bool
    op1::Operand
    op2::Operand
    metadata::InstructionMetadata
end

type SDiv <: Instruction
    exact::Bool
    op1::Operand
    op2::Operand
    metadata::InstructionMetadata
end

type FDiv <: Instruction
    fmflags::FastMathFlags
    op1::Operand
    op2::Operand
    metadata::InstructionMetadata
end

type URem <: Instruction
    op1::Operand
    op2::Operand
    metadata::InstructionMetadata
end

type SRem <: Instruction
    op1::Operand
    op2::Operand
    metadata::InstructionMetadata
end

type FRem <: Instruction
    fmflags::FastMathFlags
    op1::Operand
    op2::Operand
    metadata::InstructionMetadata
end

type Sh1 <: Instruction
    nsw::Bool
    nuw::Bool
    op1::Operand
    op2::Operand
    metadata::InstructionMetadata
end

type LShr <: Instruction
    exact::Bool
    op1::Operand
    op2::Operand
    metadata::InstructionMetadata
end

type AShr <: Instruction
    exact::Bool
    op1::Operand
    op2::Operand
    metadata::InstructionMetadata
end

type And <: Instruction
    op1::Operand
    op2::Operand
    metadata::InstructionMetadata
end 

type Or <: Instruction
    op1::Operand
    op2::Operand
    metadata::InstructionMetadata
end 

type XOr <: Instruction
    op1::Operand
    op2::Operand
    metadata::InstructionMetadata
end

type Alloca <: Instruction 
    typ::LLVMType
    len::Union(Nothing, Operand)
    align::Int
    metadata::InstructionMetadata
end

type Load <: Instruction
    volatile::Bool
    addr::Operand
    val::Operand
    atomicity::Union(Nothing, Atomicity)
    align::Int
    metadata::InstructionMetadata
end

type Store <: Instruction
    volatile::Bool
    addr::Operand
    val::Operand
    atomicity::Union(Nothing, Atomicity)
    align::Int
    metadata::InstructionMetadata
end

type GetElemPtr <: Instruction
    inbounds::Bool
    addr::Operand
    idxs::Vector{Operand}
    metadata::InstructionMetadata
end

type Fence <: Instruction
    atomicity::Atomicity 
    metadata::InstructionMetadata
end

type CmpXchg <: Instruction
    volatile::Bool 
    addr::Operand 
    expect::Operand
    replace::Operand
    atomicity::Atomicity
    metadata::InstructionMetadata 
end 

type AtomicRMW <: Instruction
    volatile::Bool 
    op::AtomicRMWOperation 
    addr::Operand
    val::Operand
    atomicity::Atomicity 
    metadata::InstructionMetadata
end 

for typ in [:Trunc, :ZExt, :SExt, :FPToUI, :FPToSI, :UIToFP, :SIToFP,
            :FPTrunc, :FPExt, :PtrToInt, :IntToPtr, :BitCast, :AddrSpaceCast]
    @eval begin
        type $typ <: Instruction
            op::Operand
            typ::LLVMType
            metadata::InstructionMetadata
        end 
    end 
end 

type ICmp <: Instruction
    pred::IntPredicate
    op1::Operand
    op2::Operand
    metadata::InstructionMetadata
end 

type FCmp <: Instruction
    pred::FloatPredicate
    op1::Operand
    op2::Operand
    metadata::InstructionMetadata
end

type Phi <: Instruction
    typ::LLVMType
    incoming::Vector{(Operand, Name)}
    metadata::InstructionMetadata
end 

typealias CallArgs Vector{(Operand, Vector{ParamAttribute})}

type Call <: Instruction
    istailcall::Bool
    callcov::CallingConvention 
    retattrs::Vector{ParamAttribute}
    func::CallableOperand
    args::CallArgs
    funcattrs::Vector{FuncAttribute}
    metadata::InstructionMetadata
end 

type Select <: Instruction
    cond::Operand
    tval::Operand
    fval::Operand
    metadata::InstructionMetadata
end 

type VAArg <: Instruction
    args::Operand
    typ::LLVMType
    metadata::InstructionMetadata 
end 

type ExtractElement <: Instruction
    vec::Operand
    idx::Operand
    metadata::InstructionMetadata 
end 

type InsertElement <: Instruction
    vec::Operand
    elem::Operand
    idx::Operand
    metadata::Operand
end 

type ShuffleVector <: Instruction
    op1::Operand
    op2::Operand
    mask::LLVMConstant
    metadata::InstructionMetadata 
end 

type ExtractValue <: Instruction
    aggregate::Operand
    idxs::Vector{Int}
    metadata::InstructionMetadata 
end 

type InsertValue <: Instruction
    aggregate::Operand
    elem::Operand
    idxs::Vector{Int}
    metadata::InstructionMetadata 
end 

type LandingPad <: Instruction
    typ::LLVMType
    func::Operand
    cleanup::Bool
    clauses::Vector{LandingPadClause}
    metadata::InstructionMetadata
end 

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
    attrs::Vector{ParamAttribute}
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
    unamedaddr::Bool
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
    callingcov::CallingConvention
    retattrs::Vector{ParamAttribute}
    rettyp::LLVMType
    name::LLVMName
    params::Vector{Parameter}
    varargs::Bool
    funcattrs::Vector{FuncAttribute}
    section::Union(Nothing, String)
    alignment::Int
    gcname::Union(Nothing, String)
    blocks::Vector{BasicBlock}
end 

end
