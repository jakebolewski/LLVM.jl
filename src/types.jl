typealias LLVMBool Cint

# A LLVMPtr is an immutable type that wraps a void pointer
abstract LLVMPtr 

isnull(h::LLVMPtr) = is(h.ptr, zero(Ptr{Void}))

Base.convert(::Type{Ptr{Void}}, ptr::LLVMPtr) = ptr.ptr
Base.(:(==))(p1::LLVMPtr, p2::LLVMPtr) = p1.ptr === p2.ptr

immutable ContextPtr <: LLVMPtr
    ptr::Ptr{Void}
end

immutable TypePtr <: LLVMPtr 
    ptr::Ptr{Void}
end

immutable GlobalValuePtr <: LLVMPtr 
    ptr::Ptr{Void}
end

immutable ValuePtr <: LLVMPtr 
    ptr::Ptr{Void}
end

immutable ModulePtr <: LLVMPtr 
    ptr::Ptr{Void}
end
