# A LLVMHandle is an immutable type that wraps a void pointer
abstract LLVMHandle 

isnull(h::LLVMHandle) = h.ptr == zero(Ptr{Void})

Base.convert(::Type{Ptr{Void}}, handle::LLVMHandle) = handle.ptr
Base.(:(==))(h1::LLVMHandle, h2::LLVMHandle) = h1.ptr === h2.ptr


