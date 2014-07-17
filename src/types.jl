module Types

export LLVMBool, ContextPtr, TypePtr, GlobalValuePtr, ValuePtr, ModulePtr, isnull

typealias LLVMBool Cint

# A LLVMPtr is an immutable type that wraps a void pointer
abstract LLVMPtr 

isnull(h::LLVMPtr) = is(h.ptr, zero(Ptr{Void}))

Base.convert(::Type{Ptr{Void}}, ptr::LLVMPtr) = ptr.ptr
Base.(:(==))(p1::LLVMPtr, p2::LLVMPtr) = p1.ptr === p2.ptr

immutable ContextPtr <: LLVMPtr
    ptr::Ptr{Void}
end

immutable ModulePtr <: LLVMPtr 
    ptr::Ptr{Void}
end

# Pointer Hierarchy

immutable ValuePtr <: LLVMPtr
    ptr::Ptr{Void}
end

immutable UserPtr <: LLVMPtr 
    ptr::Ptr{Void}
end 

Base.convert(::Type{ValuePtr}, ptr::UserPtr) = ValuePtr(ptr.ptr)

immutable ConstPtr <: LLVMPtr
    ptr::Ptr{Void}
end

Base.convert(::Type{UserPtr}, ptr::ConstPtr) = UserPtr(ptr.ptr)
Base.convert(::Type{ValuePtr}, ptr::ConstPtr) = ValuePtr(ptr.ptr)

immutable GlobalValuePtr <: LLVMPtr
    ptr::Ptr{Void}
end 

Base.convert(::Type{ValuePtr}, ptr::GlobalValuePtr) = ValuePtr(ptr.ptr)
Base.convert(::Type{UserPtr},  ptr::GlobalValuePtr) = UserPtr(ptr.ptr)
Base.convert(::Type{ConstPtr}, ptr::GlobalValuePtr) = ConstPtr(ptr.ptr)

immutable GlobalAliasPtr <: LLVMPtr
    ptr::Ptr{Void}
end

Base.convert(::Type{ValuePtr}, ptr::GlobalAliasPtr) = ValuePtr(ptr.ptr)
Base.convert(::Type{UserPtr},  ptr::GlobalAliasPtr) = UserPtr(ptr.ptr)
Base.convert(::Type{ConstPtr}, ptr::GlobalAliasPtr) = ConstPtr(ptr.ptr)
Base.convert(::Type{GlobalValuePtr}, ptr::GlobalAliasPtr) = GlobalValuePtr(ptr.ptr)

immutable FunctionPtr <: LLVMPtr
    ptr::Ptr{Void}
end

Base.convert(::Type{ValuePtr}, ptr::FunctionPtr) = ValuePtr(ptr.ptr)
Base.convert(::Type{UserPtr},  ptr::FunctionPtr) = UserPtr(ptr.ptr)
Base.convert(::Type{ConstPtr}, ptr::FunctionPtr) = ConstPtr(ptr.ptr)
Base.convert(::Type{GlobalValuePtr}, ptr::FunctionPtr) = GlobalValuePtr(ptr.ptr)

immutable BasicBlockPtr <: LLVMPtr
    ptr::Ptr{Void}
end

Base.convert(::Type{ValuePtr}, ptr::BasicBlockPtr) = ValuePtr(ptr.ptr)

immutable ParamPtr <: LLVMPtr
    ptr::Ptr{Void}
end 

Base.convert(::Type{ValuePtr}, ptr::ParamPtr) = ValuePtr(ptr.ptr)

immutable InstructionPtr <: LLVMPtr
    ptr::Ptr{Void}
end

Base.convert(::Type{ValuePtr}, ptr::InstructionPtr) = ValuePtr(ptr.ptr)
Base.convert(::Type{UserPtr},  ptr::InstructionPtr)  = UserPtr(ptr.ptr)

immutable BinaryOpPtr <: LLVMPtr
    ptr::Ptr{Void}
end

Base.convert(::Type{ValuePtr}, ptr::BinaryOpPtr) = ValuePtr(ptr.ptr)
Base.convert(::Type{UserPtr},  ptr::BinaryOpPtr) = UserPtr(ptr.ptr)
Base.convert(::Type{InstructionPtr}, ptr::BinaryOpPtr) = InstructionPtr(ptr.ptr)

immutable MDNodePtr <: LLVMPtr
    ptr::Ptr{Void}
end 

Base.convert(::Type{ValuePtr}, ptr::MDNodePtr) = ValuePtr(ptr.ptr)

immutable MDStringPtr <: LLVMPtr
    ptr::Ptr{Void}
end

Base.convert(::Type{ValuePtr}, ptr::MDStringPtr) = ValuePtr(ptr.ptr)

immutable NamedMetadataPtr <: LLVMPtr
    ptr::Ptr{Void}
end

immutable InlineAsmPtr <: LLVMPtr
    ptr::Ptr{Void}
end 

Base.convert(::Type{ValuePtr}, ptr::InlineAsmPtr) = ValuePtr(ptr.ptr)

immutable TypePtr <: LLVMPtr
    ptr::Ptr{Void}
end

end
