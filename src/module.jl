#------------------------------------------------------------------------------
# Module 
#------------------------------------------------------------------------------
decode_llvm(ctx::Context, th::TypePtr) = begin 
    k = FFI.get_type_kind(th)
    if k == 8 #Integer
        nbits = FFI.get_int_type_width(th)    
        return Ast.IntType(nbits) 
    elseif k == 12 # pointer
        etyp = decode_llvm(ctx, FFI.get_elem_type(th))
        addr = Ast.AddrSpace(FFI.get_ptr_address_space(th))
        return Ast.PtrType(etyp, addr)
    end 
end

decode_llvm(ctx::Context, cptr::ConstPtr) = begin
    ptr_typ = FFI.llvm_typeof(cptr)
    ty = decode_llvm(ctx, ptr_typ)
    subclass_id = FFI.get_value_subclass_id(cptr)
    nops = FFI.get_num_operands(cptr)
    
    if subclass_id == 11 # constant int 
        words = FFI.get_constant_int_words(cptr)
        n = foldr((a, b) -> (a << 64) | b, 0, words)
        return Ast.ConstInt(ty.nbits, words[1])
    end
end

decode_llvm(ctx::Context, ptr::Ptr{Uint8}) = bytestring(ptr)

encode_llvm(ctx::Context, s::String) = begin
    N = length(s)
    ptr = convert(Ptr{Uint8}, Base.c_malloc(sizeof(Uint8) * N + 1))
    unsafe_copy!(ptr, convert(Ptr{Uint8}, s), N)
    unsafe_store!(ptr, zero(Uint8), N+1)
    return ptr
end

encode_llvm(ctx::Context, typ::Ast.IntType) = 
    FFI.int_type_in_ctx(ctx.handle, uint32(typ.nbits))

encode_llvm(ctx::Context, addr::Ast.AddrSpace) = uint32(addr.val)

encode_llvm(ctx::Context, name::Ast.Name) = name.val
encode_llvm(ctx::Context, name::Ast.UnName) = ""

encode_llvm(ctx::Context, link::Ast.Linkage{:External}) = uint32(0)
encode_llvm(ctx::Context, vis::Ast.DefaultVisibility) = uint32(0)

encode_llvm(ctx::Context, val::Ast.ConstInt) = begin
    v, nbits = val.val, val.nbits
    th = encode_llvm(ctx, Ast.IntType(val.nbits))
    words = Int64[(v >> 64w) & 0xffffffffffffffff for w=0:div(nbits-1, 64)]
    return FFI.const_int_arbitrary_precision(th, length(words), words)
end

type DecodeState
    global_var_num::Dict{GlobalValuePtr, Int}
    local_var_num::Dict{ValuePtr,Int}
    local_name_counter::Int
    named_type_num::Dict{TypePtr,Int}
    types_to_define::Vector{TypePtr}
end
DecodeState() = DecodeState(Dict{GlobalValuePtr,Int}(),
                            Dict{ValuePtr,Int}(),
                            -1,
                            Dict{TypePtr,Int}(),
                            TypePtr[]) 

get_global_name(ds::DecodeState, val::GlobalValuePtr) = begin
    name = FFI.get_value_name(val)
    if !isempty(name)
        return Ast.Ast(name)
    end
    n = length(ds.global_var_num)
    ds.global_var_num[val] = n
    return Ast.UnName(n)
end

get_local_name(ds::DecodeState, val::ValuePtr) = begin
    name = FFI.get_value_name(val)
    if !isempty(name)
        return Ast.Ast(name)
    end
    n = length(ds.local_var_num)
    ds.local_var_num[val] = n
    ds.local_name_counter = n+1
    return Ast.UnName(n)
end

get_type_name(ds::DecodeState, name::String) = begin
end

save_named_type(ds::DecodeState, typ::TypePtr) =
    (push!(ds.types_to_define, typ); return ds)

take_type_to_define(ds::DecodeState) =
    (pop!(ds.types_to_define); return ds)

decode_llvm(buf::MemoryBufferPtr) = begin
    start = FFI.get_buffer_start(buf)
    size  = FFI.get_buffer_size(buf)
    res = Array(Uint8, size)
    unsafe_copy!(convert(Ptr{Uint8}, res), start, size)
    return res
end
decode_llvm(ctx::Context, buf::MemoryBufferPtr) = decode_llvm(buf)

with_sm_diagnostic(f::Function) = begin
    smd = FFI.create_sm_diagnostic()
    try
        f(smd)
    finally 
        FFI.dispose_sm_diagnostic(smd)
    end 
end

module_from_bitcode(ctx::Context, buf::MemoryBufferPtr) = begin
    msg = Ptr{Uint8}[0]
    mod = FFI.parse_llvm_bitcode(ctx.handle, buf, msg)
    if isnull(mod)
        if msg[1] == C_NULL
            error("unknown error with `module_from_bitcode`")
        else
            err = bytestring(msg[1])
            c_free(msg[1])
            throw(ErrorException(err))
        end 
    end
    return mod
end

# llvm takes ownership of the buffer
module_from_bitcode(ctx::Context, bytes::Union(ByteString, IOBuffer)) = begin
    buf = FFI.create_mem_buffer_with_mem_range("<bytes>", bytes.data)
    module_from_bitcode(ctx, buf)
end

module_from_bitcode(ctx::Context, name::String, bytes::Union(ByteString, IOBuffer)) = begin
    buf = FFI.create_mem_buffer_with_mem_range(name, bytes.data)
    module_from_bitcode(ctx, buf)
end 

module_from_bitcode(ctx::Context, bytes::Vector{Uint8}) = begin
    buf = FFI.create_mem_buffer_with_mem_range("<bytes>", bytes)
    module_from_bitcode(ctx, buf)
end 

module_from_bitcode(ctx::Context, name::String, bytes::Vector{Uint8}) = begin
    buf = FFI.create_mem_buffer_with_mem_range(name, bytes)
    module_from_bitcode(ctx, buf)
end 

module_from_bitcode_file(ctx::Context, path::String) = begin
    buf = FFI.create_mem_buffer_with_contents_of_file(path)
    module_from_bitcode(ctx, buf)
end 

module_to_bitcode(ctx::Context, mod::ModulePtr) = begin
    buf = FFI.with_buff_raw_ostream() do ostream
        FFI.write_llvm_bitcode(ostream, mod)
    end
    return buf 
end

module_from_assembly(ctx::Context, buf::MemoryBufferPtr) = begin
    smd = FFI.create_sm_diagnostic()
    mod = FFI.parse_llvm_assembly(ctx.handle, buf, smd)
    try
        isnull(mod) && throw(Diagnostic(smd))
        return mod
    finally
        FFI.dispose_sm_diagnostic(smd)
    end
end

# llvm takes ownership of the buffer
module_from_assembly(ctx::Context, asm::String) = begin
    buf = FFI.create_mem_buffer_with_mem_range("<string>", asm)
    return module_from_assembly(ctx, buf)
end

module_from_assembly(ctx::Context, name::String, asm::String) = begin
    buf = FFI.create_mem_buffer_with_mem_range(name, asm)
    return module_from_assembly(ctx, buf)
end

module_from_assembly_file(ctx::Context, path::String) = begin
    buf = FFI.create_mem_buffer_with_contents_of_file(path)
    return module_from_assembly(ctx, buf)
end 

module_to_assembly(ctx::Context, mod::ModulePtr) = begin
    buf = FFI.with_buff_raw_ostream() do ostream
        FFI.write_llvm_assembly(ostream, mod)
    end
    return bytestring(buf)
end

# write LLVM Assembly from a 'ModulePtr' to a file
write_assembly_file(path::String, mod::ModulePtr) = begin
    FFI.with_file_raw_ostream(path, false, false) do ostream
        FFI.write_llvm_assembly(ostream, mod)
    end
end 

# write LLVM Bitcode from a 'ModulePtr' to a file
write_bitcode_file(path::String, mod::ModulePtr) = begin
    FFI.with_file_raw_ostream(path, false, false) do ostream 
        FFI.write_llvm_bitcode(ostream, mod)
    end
end 

get_target_triple(ptr::ModulePtr) =
    (s = FFI.get_target_triple(ptr); isempty(s) ? nothing : s)

get_datalayout(ptr::ModulePtr) =
    (s = FFI.get_datalayout(ptr); isempty(s) ? nothing : parse_datalayout(s))

module_from_ast(ctx::Context, mod::Ast.Module) = begin
    mod_ptr = FFI.create_module_with_name_in_ctx(mod.name, ctx.handle)
    mod.layout !== nothing && FFI.set_datalayout!(mod_ptr, mod.layout) 
    mod.target !== nothing && FFI.set_target_triple!(mod_ptr, mod.target)
    for def in mod.defs
        if isa(def, Ast.TypeDefinition)
            error("unimplemented")
        elseif isa(def, Ast.MetadataNodeDefinition)
            error("unimplemented")
        elseif isa(def, Ast.InlineAssembly)
            error("unimplemented")
        elseif isa(def, Ast.GlobalDefinition)
            local g = def.val 
            local gval_ptr::GlobalValuePtr
            if isa(g, Ast.GlobalVar)
                gval_ptr = FFI.add_global_in_addr_space!(
                                        mod_ptr,
                                        encode_llvm(ctx, g.typ), 
                                        encode_llvm(ctx, g.name),
                                        encode_llvm(ctx, g.addrspace))
                FFI.set_thread_local!(gval_ptr, g.threadlocal)
                FFI.set_unnamed_addr!(gval_ptr, g.unamedaddr)
                FFI.set_global_constant!(gval_ptr, g.isconst)
                if g.init !== nothing
                    FFI.set_initializer!(gval_ptr, encode_llvm(ctx, g.init))
                end
                if g.section !== nothing
                    FFI.set_section!(gval_ptr, g.section)
                end
                FFI.set_alignment!(gval_ptr, g.alignment)
                #define global <- add global to module encoding state
            elseif isa(g, Ast.GlobalAlias)
                error("unimplemented")
            elseif isa(g, Ast.Function)
                error("unimplemented")
            end
            FFI.set_linkage!(gval_ptr, encode_llvm(ctx, g.linkage))
            FFI.set_visibility!(gval_ptr, encode_llvm(ctx, g.visibility))
        end
    end
    return mod_ptr
end

module_to_ast(ctx::Context, mod_ptr::ModulePtr) = begin
    # lift c++ module to Ast.Module 
    @assert ctx.handle == FFI.get_module_ctx(mod_ptr)

    ds = DecodeState()
    
    moduleid   = FFI.get_module_id(mod_ptr)
    datalayout = get_datalayout(mod_ptr)
    triple     = get_target_triple(mod_ptr)

    local defs = Ast.Definition[] 
    for g in FFI.list(GlobalValuePtr,
                      FFI.get_first_global(mod_ptr), 
                      FFI.get_next_global)
        name  = get_global_name(ds, g)
        ptrty = decode_llvm(ctx, FFI.llvm_typeof(g))
        init  = FFI.get_initializer(g)
        var = Ast.GlobalVar(name,
                            FFI.get_linkage(g),
                            FFI.get_visibility(g),
                            FFI.is_thread_local(g),
                            ptrty.addrspace,
                            FFI.has_unnamed_addr(g),
                            FFI.is_global_constant(g),
                            ptrty.typ,
                            !isnull(init) ? decode_llvm(ctx, init) : nothing, 
                            FFI.get_section(g),
                            FFI.get_alignment(g))
        push!(defs, Ast.GlobalDefinition(var))
    end
    for a in FFI.list(GlobalAliasPtr,
                      FFI.get_first_alias(mod_ptr),
                      FFI.get_next_alias)
        aname = get_global_name(ds, a)
        var = Ast.GlobalAlias(aname,
                              FFI.get_linkage(a),
                              FFI.get_visibility(a),
                              FFI.llvm_typeof(a),
                              decode_llvm(ctx, FFI.get_aliasee(a)))
        push!(defs, Ast.GlobalDefinition(var))
    end
    for f in FFI.list(FunctionPtr,
                      FFI.get_first_func(mod_ptr),
                      FFI.get_next_func)
        fname = get_global_name(ds, f)
        bblocks = BasicBlockPtr[]
        for b in FFI.list(BasicBlockPtr,
                          FFI.get_first_basicblock(f),
                          FFI.get_next_basicblock)
        end
        error("unimplemented")
    end

    # struct definitions
    # module inline asm
    # named metadata nodes
    # metadata definitions

    return Ast.Module(moduleid, datalayout, triple, defs)
end
