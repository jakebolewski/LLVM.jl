module Ast

using ..OrderedDict

abstract LLVMAstNode 

Base.(:(==))(node1::LLVMAstNode, node2::LLVMAstNode) = begin
    typeof(node1) === typeof(node2) || return false
    for field in names(node1)
        getfield(node1, field) == getfield(node2, field) || return false
    end
    return true
end 

abstract LLVMLinkage <: LLVMAstNode

immutable Linkage{T} <: LLVMLinkage end

#TODO: get rid of this
Base.convert(::Type{LLVMLinkage}, enum::Integer) = 
    enum == 0 ? Linkage{:External}() : error("unknown")


# -----------------------------------------------------------------------------
# Ast Names
# -----------------------------------------------------------------------------
abstract LLVMName <: LLVMAstNode

immutable Name <: LLVMName 
    val::String
end

immutable UnName <: LLVMName 
    val::Int
end 

# -----------------------------------------------------------------------------
# Parameter Attributes 
# -----------------------------------------------------------------------------
abstract ParamAttribute <: LLVMAstNode

for typ in [:SignExt, :InReg, :SRet, :NoAlias, :ByVal, :NoCapture, :Nest]
    @eval begin
        immutable $typ <: ParamAttribute
        end
    end
end

# -----------------------------------------------------------------------------
# Function Attributes 
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
abstract FloatFormat <: LLVMAstNode

immutable IEEE <: FloatFormat 
end

immutable DoubleExtended <: FloatFormat 
end

immutable PairOfFloats <: FloatFormat 
end

# -----------------------------------------------------------------------------
# Memory Ordering 
# http://llvm.org/docs/LangRef.html#atomic-memory-ordering-constraints
# http://llvm.org/docs/Atomics.html
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
# http://llvm.org/docs/Atomics.html
# http://llvm.org/docs/LangRef.html#singlethread 
# -----------------------------------------------------------------------------
immutable Atomicity <: LLVMAstNode
    cross_thread::Bool
    memory_ordering::MemoryOrdering
end

# -----------------------------------------------------------------------------
# Atomic Ops 
# http://llvm.org/docs/LangRef.html#atomicrmw-instruction 
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

# http://llvm.org/docs/LangRef.html#icmp-instruction
typealias IntCmpPredicate Union(EQ, NE, UGT, UGE, ULT, ULE, SGT, SGE, SLT, SLE)

# http://llvm.org/docs/LangRef.html#fcmp-instruction 
typealias FloatCmpPredicate Union(False, OEQ, OGT, OGE, OLT, OLE, ONE, ORD, 
                                  UNO, UEQ, UGT, UGE, ULT, ULE, UNE, True)

# -----------------------------------------------------------------------------
# LLVM Types
# http://llvm.org/docs/LangRef.html#type-system
# -----------------------------------------------------------------------------
abstract LLVMType <: LLVMAstNode

typealias LLVMFloat Union(Float16, Float32, Float64)

# http://llvm.org/docs/LangRef.html#void-type 
immutable VoidType <: LLVMType
end

# http://llvm.org/docs/LangRef.html#integer-type
immutable IntType <: LLVMType
    nbits::Int
end

Base.convert{T<:Integer}(::Type{LLVMType}, ::Type{T}) = 
    IntType(sizeof(T) * 8)

Base.convert(::Type{LLVMType}, ::Type{BigInt}) = 
    error("cannot convert BigInt to LLVMType")

# http://llvm.org/docs/LangRef.html#pointer-type
immutable PtrType <: LLVMType
    typ::LLVMType
    addrspace::AddrSpace
end

Base.convert{T}(::Type{LLVMType}, ::Type{Ptr{T}}) = PtrType(T, AddrSpace(0))

# http://llvm.org/docs/LangRef.html#floating-point-types
immutable FloatType <: LLVMType
    nbits::Int
    fmt::FloatFormat
end

Base.convert(::Type{LLVMType}, ::Type{Float16}) = FloatType(16, IEEE())
Base.convert(::Type{LLVMType}, ::Type{Float32}) = FloatType(32, IEEE())
Base.convert(::Type{LLVMType}, ::Type{Float64}) = FloatType(64, IEEE())

# http://llvm.org/docs/LangRef.html#function-type
immutable FunctionType <: LLVMType
    restyp::LLVMType
    argtyps::Vector{LLVMType}
    varargs::Bool
end 

# http://llvm.org/docs/LangRef.html#vector-type 
immutable VecType <: LLVMType
    typ::LLVMType
    len::Int
end

# http://llvm.org/docs/LangRef.html#structure-type
immutable StructType <: LLVMType
    packed::Bool
    typs::Vector{LLVMType}
end

# http://llvm.org/docs/LangRef.html#array-type
immutable ArrayType <: LLVMType
    typ::LLVMType
    len::Int
end

# http://llvm.org/docs/LangRef.html#opaque-structure-types
immutable NamedTypeRef 
    val::Name
end 

# http://llvm.org/docs/LangRef.html#opaque-structure-types
abstract MetadataType <: LLVMType

# -----------------------------------------------------------------------------
# Inline Assembly 
# http://llvm.org/docs/LangRef.html#inline-assembler-expressions
# ----------------------------------------------------------------------------- 
abstract Dialect <: LLVMAstNode

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
# an 'Operand' is roughly an argument to a 'LLVM.Ast.Instruction' 
abstract Operand <: LLVMAstNode

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
# http://llvm.org/docs/LangRef.html#constants
# http://llvm.org/docs/LangRef.html#constant-expressions 
# -----------------------------------------------------------------------------
abstract Constant <: LLVMAstNode

typealias MaybeConstant Union(Nothing, Constant)

immutable ConstInt <: Constant
    nbits::Int
    val::Integer
end

Base.(:(==))(c1::ConstInt, c2::ConstInt) = 
    c1.nbits == c2.nbits && ((v1, v2) = promote(c1.val, c2.val); v1 == v2)

Base.convert{T<:Integer}(::Type{Constant}, v::T) = ConstInt(sizeof(T)*8, v)
Base.convert{T<:Integer}(::Type{MaybeConstant}, v::T) = convert(Constant, v)
Base.convert(::Type{MaybeConstant}, n::Nothing) = nothing

immutable ConstFloat <: Constant 
    val::LLVMFloat
end

Base.convert{T<:LLVMFloat}(::Type{Constant}, v::T) = ConstFloat(v)

immutable ConstNull <: Constant
    typ::LLVMType
end

immutable ConstStruct <: Constant
    name::Union(Nothing, LLVMName)
    packed::Bool
    vals::Vector{Constant}
end

immutable ConstArray <: Constant
    typ::LLVMType
    vals::Vector{Constant}
end

immutable ConstVector{T<:Constant} <: Constant
    vals::Vector{T}
end

immutable ConstUndef <: Constant
    typ::LLVMType
end

immutable ConstBlockAddress <: Constant
    func::Name
    block::Name
end

immutable ConstGlobalRef <: Constant
    typ::LLVMType
    name::LLVMName
end

type ConstGetElementPtr <: Constant
    inbounds::Bool
    addr::Constant
    idxs::Vector{Constant}
end

for op in [:Add, :Sub, :Mul, :Shl]
    typ = symbol(string("Const", op))
    @eval begin
        type $typ <: Constant
            nsw::Bool
            nuw::Bool
            op1::Constant
            op2::Constant
        end
    end
end

for op in [:FAdd, :FSub, :FMul, :FDiv, :URem, :SRem, :FRem, :And, :Or, :Xor]
    typ = symbol(string("Const", op))
    @eval begin
        type $typ <: Constant
            op1::Constant
            op2::Constant
        end 
    end
end

for op in [:UDiv, :SDiv, :LShr, :AShr]
    typ = symbol(string("Const", op))
    @eval begin
        type $typ <: Constant
            exact::Bool
            op1::Constant
            op2::Constant
        end
    end
end

for op in [:Trunc, :ZExt, :Sext, :FPToUI, :FPToSI, :UIToFP, :SIToFP,
           :FPTrunc, :FPExt, :PtrToInt, :IntToPtr, :BitCast]
    typ = symbol(string("Const", op))
    @eval begin
        type $typ <: Constant
            op::Constant
            typ::LLVMType
        end
    end
end

type ConstICmp <: Constant
    pred::IntCmpPredicate
    op1::Constant
    op2::Constant
end

type ConstFCmp <: Constant
    pred::FloatCmpPredicate
    op1::Constant 
    op2::Constant
end

type ConstSelect <: Constant
    cond::Constant
    tval::Operand
    fval::Operand
end

type ConstExtractElement <: Constant
    vec::Constant
    idx::Constant
end

type ConstInsertElement <: Constant
    vec::Constant
    elem::Constant
    idx::Constant
end

type ConstShuffleVector <: Constant
    op1::Constant
    op2::Constant
    mask::Constant
end

type ConstExtractValue <: Constant
    aggregate::Constant 
    idxs::Vector{Int}
end

type ConstInsertValue <: Constant
    aggregate::Constant
    elem::Operand
    idxs::Vector{Int}
end

# -----------------------------------------------------------------------------
# Terminal Instructions
# http://llvm.org/docs/LangRef.html#terminators 
# -----------------------------------------------------------------------------
abstract Terminator <: LLVMAstNode

# http://llvm.org/docs/LangRef.html#metadata-nodes-and-metadata-strings 
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
    dests::Vector{(Constant, Name)}
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

abstract LandingPadClause <: LLVMAstNode

immutable Catch <: LandingPadClause
    val::Constant
end 

immutable Filter <: LandingPadClause
    val::Constant
end 

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
    pred::IntCmpPredicate
    op1::Operand
    op2::Operand
    metadata::InstructionMetadata
end 

type FCmp <: Instruction
    pred::FloatCmpPredicate
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
    mask::Constant
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
# http://llvm.org/docs/LangRef.html#visibility
# -----------------------------------------------------------------------------
abstract Visibility <: LLVMAstNode

immutable DefaultVisibility <: Visibility
end

immutable HiddenVisibility <: Visibility
end

immutable ProtectedVisibility <: Visibility
end

# -----------------------------------------------------------------------------
# Globals 
# http://llvm.org/doxygen/classllvm_1_1GlobalValue.html
# -----------------------------------------------------------------------------
abstract LLVMGlobal <: LLVMAstNode

# Parameters for 'LLVM.Ast.Function'
type Parameter <: LLVMAstNode
    typ::LLVMType
    name::LLVMName
    attrs::Vector{ParamAttribute}
end

# LLVM code in a function is a sequence of 'LLVM.Ast.BasicBlocks' with a
# label, some instructions, and terminator
# http://llvm.org/doxygen/classllvm_1_1BasicBlock.html>
type BasicBlock <: LLVMAstNode
    name::LLVMName
    insts::Vector{Instruction}
    term::Terminator 
end

# http://llvm.org/docs/LangRef.html#global-variables
type GlobalVar <: LLVMGlobal
    name::LLVMName
    linkage::LLVMLinkage
    visibility::Visibility
    threadlocal::Bool
    addrspace::AddrSpace
    unamedaddr::Bool
    isconst::Bool
    typ::LLVMType
    init::Union(Nothing, Constant)
    section::Union(Nothing, String)
    alignment::Int
end 

#TODO: get rid of this
Base.convert(::Type{Visibility}, enum::Integer) = 
    enum == 0 ? DefaultVisibility() : error("unhandled visibility")

GlobalVar(;name=error("global variable name not defined"),
           linkage=Linkage{:External}(),
           visibility=DefaultVisibility(),
           threadlocal=false,
           addrspace=AddrSpace(0),
           has_unnamed_addr=false,
           isconst=false,
           typ=error("global variable typ not defined"),
           init=nothing,
           section=nothing,
           alignment=0) = begin
    GlobalVar(name,
              linkage,
              visibility,
              threadlocal,
              addrspace,
              has_unnamed_addr,
              isconst,
              typ,
              init,
              section,
              alignment)
end

# http://llvm.org/docs/LangRef.html#aliases 
type GlobalAlias <: LLVMGlobal
    name::LLVMName
    linkage::LLVMLinkage
    visibility::Visibility
    typ::LLVMType
    aliasee::Constant
end

# http://llvm.org/docs/LangRef.html#functions
type Function <: LLVMGlobal
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

# -----------------------------------------------------------------------------
# DataLayout
# http://llvm.org/docs/LangRef.html#data-layout>
# -----------------------------------------------------------------------------
abstract Endianness <: LLVMAstNode

immutable LittleEndian <: Endianness
end

immutable BigEndian <: Endianness
end

# describes how a given type must be aligned
immutable AlignmentInfo <: LLVMAstNode
    abi::Int
    perferred::Union(Nothing, Int)
end

# typeo of type for which 'AlignmentInfo' may be specified
abstract AlignType <: LLVMAstNode

immutable IntegerAlign <: AlignType end
immutable VectorAlign <: AlignType end
immutable FloatAlign <: AlignType end
immutable AggregateAlign <: AlignType end

# style of name mangling
abstract Mangling <: LLVMAstNode

immutable ELFMangling <: Mangling end
immutable MIPSMangling <: Mangling end
immutable MachOMangling <: Mangling end
immutable WindowsCOFFMangling <: Mangling end

typealias PointerLayoutMap Associative{AddrSpace, (Int, AlignmentInfo)}
typealias PointerLayoutDict OrderedDict{AddrSpace, (Int, AlignmentInfo)}

typealias TypeLayoutMap Associative{(AlignType, Int), AlignmentInfo}
typealias TypeLayoutDict OrderedDict{(AlignType, Int), AlignmentInfo}

# description of various data layout properties which may be used during optimization
type DataLayout <: LLVMAstNode
    endianness::Union(Nothing, Endianness)
    mangling::Union(Nothing, Mangling)
    stackalignment::Union(Nothing, Int)
    pointerlayouts::PointerLayoutMap
    typelayouts::TypeLayoutMap
    nativesizes::Union(Nothing, Set{Int})
end

DataLayout(;endianness=nothing, 
            mangling=nothing, 
            stackalignment=nothing,
            pointerlayouts=PointerLayoutDict(),
            typelayouts=TypeLayoutDict(),
            nativesizes=nothing) = DataLayout(endianness,
                                              mangling,
                                              stackalignment,
                                              pointerlayouts,
                                              typelayouts,
                                              nativesizes)

# -----------------------------------------------------------------------------
# Module
# -----------------------------------------------------------------------------
# Anything that can be at the top level of a 'Module'
abstract Definition <: LLVMAstNode

type GlobalDefinition <: Definition
    val::LLVMGlobal
end

type TypeDefinition <: Definition
    name::LLVMName
    typs::Vector{LLVMType}
end

type MetadataNodeDefinition <: Definition
    id::MetadataNodeID
    ops::Vector{Operand}
end

type NamedMetadataDefinition <: Definition
    name::String
    ids::Vector{MetadataNodeID}
end

type ModuleInlineAsm <: Definition
    source::String
end

type Module <: LLVMAstNode
    name::String
    layout::Union(Nothing, DataLayout)
    target::Union(Nothing, String)
    defs::Vector{Definition}
end

end
