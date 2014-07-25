#------------------------------------------------------------------------------
# Module 
#------------------------------------------------------------------------------
baremodule FloatSemantics
    const IEEEHalf   = 0
    const IEEESingle = 1
    const IEEEDouble = 2
    const IEEEQuad   = 3
    const PPCDoubleDouble   = 4
    const x87DoubleExtended = 5
    const bogus = 6
end

baremodule TypeKind
    const void      = 0   # type with no size
    const half      = 1   # 16 bit floating point type
    const float     = 2   # 32 bit floating point type
    const double    = 3   # 64 bit floating point type
    const x86_fp80  = 4   # 80 bit floating point type 
    const fp128     = 5   # 128 bit floating point type (112-bit mantissa)
    const ppc_fp128 = 6   # 128 bit floating point type (two 64 bits)
    const label     = 7   # labels
    const integer   = 8   # arbitrary bit width integers
    const func      = 9   # functions
    const struct    = 10  # structures
    const array     = 11  # arrays
    const pointer   = 12  # pointers
    const vector    = 13  # SIMD packed format or other vector type
    const metadata  = 14  # metadata
    const x86_mmx   = 15  # x86 specific multimedia SIMD types 
end

baremodule ValueSubclass
    const argument = 0
    const basic_block = 1
    const func = 2
    const global_alias = 3
    const global_variable = 4
    const undef_value = 5
    const block_address = 6
    const const_expr = 7 
    const const_aggregate_zero = 8
    const const_data_array = 9 
    const const_data_vector = 10
    const const_int = 11
    const const_fp = 12 
    const const_array = 13
    const const_struct = 14 
    const const_vector = 15
    const const_pointer_null = 16
    const md_node = 17 
    const md_string = 18
    const inline_asm = 19 
    const pseudo_source_value = 20
    const fixed_stack_pseudo_source_value = 21
    const instruction = 22
end

type DecodeState
    ctx::Context
    global_var_num::Dict{GlobalValuePtr, Int}
    local_var_num::Dict{ValuePtr,Int}
    local_name_counter::Int
    named_type_num::Dict{TypePtr,Int}
    types_to_define::Vector{TypePtr}
end
DecodeState(ctx::Context) = DecodeState(ctx,
                                        Dict{GlobalValuePtr,Int}(),
                                        Dict{ValuePtr,Int}(),
                                        -1,
                                        Dict{TypePtr,Int}(),
                                        TypePtr[]) 

get_global_name(st::DecodeState, val::GlobalValuePtr) = begin
    name = FFI.get_value_name(val)
    if !isempty(name)
        return Ast.Ast(name)
    end
    n = length(st.global_var_num)
    st.global_var_num[val] = n
    return Ast.UnName(n)
end

get_local_name(st::DecodeState, val::ValuePtr) = begin
    name = FFI.get_value_name(val)
    if !isempty(name)
        return Ast.Ast(name)
    end
    n = length(st.local_var_num)
    st.local_var_num[val] = n
    st.local_name_counter = n+1
    return Ast.UnName(n)
end

get_type_name(st::DecodeState, name::String) = begin
end

save_named_type(st::DecodeState, typ::TypePtr) =
    (push!(st.types_to_define, typ); return st)

take_type_to_define(st::DecodeState) =
    (pop!(st.types_to_define); return st)

decode_llvm(st::DecodeState, th::TypePtr) = begin 
    k = FFI.get_type_kind(th)
    if k == TypeKind.integer
        nbits = FFI.get_int_type_width(th)    
        return Ast.IntType(nbits) 
    elseif k == TypeKind.pointer
        etyp = decode_llvm(st, FFI.get_elem_type(th))
        addr = Ast.AddrSpace(FFI.get_ptr_address_space(th))
        return Ast.PtrType(etyp, addr)
    elseif k == TypeKind.half
        return Ast.FloatType(16, Ast.IEEE())
    elseif k == TypeKind.float
        return Ast.FloatType(32, Ast.IEEE())
    elseif k == TypeKind.double
        return Ast.FloatType(64, Ast.IEEE())
    else
        error("unimplemented")
    end
end

decode_llvm(st::DecodeState, cptr::ConstPtr) = begin
    typ = decode_llvm(st, FFI.llvm_typeof(cptr))
    subclass_id = FFI.get_value_subclass_id(cptr)
    nops = FFI.get_num_operands(cptr)
    
    if subclass_id == ValueSubclass.const_int
        words  = FFI.get_constant_int_words(cptr)
        nwords = length(words) 
        # this is wrong but it gets the tests to pass 
        v0 = nwords == 1 ? zero(Uint64) :
             nwords == 2 ? zero(Uint128) : zero(BigInt)
        n = foldr((b, a) -> (a << 64) | b, v0, words)
        return Ast.ConstInt(typ.nbits, n)

    elseif subclass_id == ValueSubclass.const_fp
        nbits, fmt = typ.nbits, typ.fmt
        words = zeros(Uint64, div((nbits - 1), 64) + 1)
        FFI.get_const_float_words!(cptr, words)
        if nbits == 16 && typeof(fmt) === Ast.IEEE 
            return Ast.ConstFloat(reinterpret(Float16, uint16(words[1])))
        elseif nbits == 32 && typeof(fmt) === Ast.IEEE
            return Ast.ConstFloat(reinterpret(Float32, uint32(words[1])))
        elseif nbits == 64 && typeof(fmt) === Ast.IEEE
            return Ast.ConstFloat(reinterpret(Float64, uint64(words[1])))
        else
            error("unimplemented constant floating point type")
        end
    else
        error("unimplemented")
    end
end

decode_llvm(st::DecodeState, ptr::Ptr{Uint8}) = bytestring(ptr)

decode_llvm(buf::MemoryBufferPtr) = begin
    start = FFI.get_buffer_start(buf)
    size  = FFI.get_buffer_size(buf)
    res = Array(Uint8, size)
    unsafe_copy!(convert(Ptr{Uint8}, res), start, size)
    return res
end
decode_llvm(st::DecodeState, buf::MemoryBufferPtr) = decode_llvm(buf)

type EncodeState
    ctx::Context
    builder::BuilderPtr
    named_types::Dict{Ast.LLVMName,TypePtr}
    locals::Dict{Ast.LLVMName,ValuePtr}
    globals::Dict{Ast.LLVMName,GlobalValuePtr}
    blocks::Dict{Ast.LLVMName,BasicBlockPtr}
    mdnodes::Dict{Ast.MetadataNodeID, MDNodePtr}
end

EncodeState(ctx::Context) = begin
    bldr = FFI.create_builder_in_ctx(ctx)
    es = EncodeState(ctx, bldr,
                     Dict{Ast.LLVMName, TypePtr}(),
                     Dict{Ast.LLVMName, ValuePtr}(),
                     Dict{Ast.LLVMName, GlobalValuePtr}(),
                     Dict{Ast.LLVMName, BasicBlockPtr}(),
                     Dict{Ast.MetadataNodeID, MDNodePtr}())
    finalizer(es, (s) -> begin
        if !isnull(s.builder)
            FFI.dispose_builder(s.builder)
            s.builder = BuilderPtr(C_NULL)
        end
    end)
    return es
end 

encode_llvm(es::EncodeState, s::String) = begin
    N = length(s)
    ptr = convert(Ptr{Uint8}, Base.c_malloc(sizeof(Uint8) * N + 1))
    unsafe_copy!(ptr, convert(Ptr{Uint8}, s), N)
    unsafe_store!(ptr, zero(Uint8), N+1)
    return ptr
end

encode_llvm(es::EncodeState, typ::Ast.IntType) = 
    FFI.int_type_in_ctx(es.ctx, typ.nbits)

# should all types be parametric types so we can dispatch on them more easily?
encode_llvm(st::EncodeState, typ::Ast.FloatType) = begin
    nbits, fmt = typ.nbits, typ.fmt
    if nbits == 16 && typeof(fmt) === Ast.IEEE
        return FFI.half_type_in_ctx(st.ctx)
    elseif nbits == 32 && typeof(fmt) === Ast.IEEE
        return FFI.float_type_in_ctx(st.ctx)
    elseif nbits == 64 && typeof(fmt) === Ast.IEEE
        return FFI.double_type_in_ctx(st.ctx)
    elseif nbits == 80 && typeof(fmt) === Ast.DoubleExtended
        return FFI.x86_fp80_type_in_ctx(st.ctx)
    elseif nbits == 128 && typeof(fmt) === Ast.IEEE
        return FFI.fp128_type_in_ctx(st.ctx)
    elseif nbits == 128 && typeof(fmt) === Ast.PairOfFloats
        return FFI.ppc_fp128_type_in_ctx(st.ctx)
    else
        error("unsupported floating point type $typ")
    end
end 

encode_llvm(st::EncodeState, typs::Vector{Ast.LLVMType}) = begin
    tptrs = TypePtr[]
    for ty in typs
        push!(tptrs, encode_llvm(st, ty))
    end
    return tptrs
end 

encode_llvm(st::EncodeState, cnsts::Vector{Ast.Constant}) = begin
    cptrs = ConstPtr[]
    for c in cnsts
        push!(cptrs, encode_llvm(st, c))
    end
    return cptrs
end

encode_llvm(st::EncodeState, styp::Ast.StructType) = begin
    typs = encode_llvm(st, styp.typs)
    return FFI.struct_type_in_ctx(st.ctx, typs, styp.packed)
end 

encode_llvm(st::EncodeState, struct::Ast.ConstStruct) = begin
    cptrs = encode_llvm(st, struct.vals)::Vector{ConstPtr}
    if is(struct.name, nothing)
        return FFI.const_struct_in_ctx(st.ctx, cptrs, struct.packed)
    else
        typ = lookup_named_type(name)
        return FFI.const_named_struct(typ, cptrs)
    end 
end

encode_llvm(st::EncodeState, addr::Ast.AddrSpace) = addr.val

encode_llvm(st::EncodeState, name::Ast.Name) = name.val
encode_llvm(st::EncodeState, name::Ast.UnName) = ""

encode_llvm(st::EncodeState, ::Ast.Linkage{:External}) = 0
encode_llvm(st::EncodeState, ::Ast.DefaultVisibility)  = 0

encode_llvm(st::EncodeState, val::Ast.ConstInt) = begin
    v, nbits = val.val, val.nbits
    th = encode_llvm(st, Ast.IntType(val.nbits))
    words = Uint64[(v >> 64w) & 0xffffffffffffffff for w=0:div(nbits-1, 64)]
    return FFI.const_int_arbitrary_precision(th, length(words), words)
end

encode_llvm(st::EncodeState, val::Ast.ConstFloat) = begin
    v = val.val 
    nbits = 8 * sizeof(v)
    words = zeros(Uint64, div((nbits - 1), 64) + 1)
    if isa(v, Float16)
        fpsem = FloatSemantics.IEEEHalf
        words[1] = convert(Uint64, reinterpret(Uint16, v))
    elseif isa(v, Float32)
        fpsem = FloatSemantics.IEEESingle
        words[1] = convert(Uint64, reinterpret(Uint32, v))
    elseif isa(v, Float64)
        fpsem = FloatSemantics.IEEEDouble
        words[1] = reinterpret(Uint64, v)
    else
        error("unimplemented")
    end
    FFI.const_float_arbitrary_precision(st.ctx, nbits, words, fpsem)
end

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
    mod = FFI.parse_llvm_bitcode(ctx, buf, msg)
    if isnull(mod)
        if msg[1] != C_NULL
            err = bytestring(msg[1])
            c_free(msg[1])
            throw(ErrorException(err))
        else 
            error("unknown error with `module_from_bitcode`")
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
    mod = FFI.parse_llvm_assembly(ctx, buf, smd)
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
    st = EncodeState(ctx)
    mod_ptr = FFI.create_module_with_name_in_ctx(mod.name, st.ctx)
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
                                        encode_llvm(st, g.typ), 
                                        encode_llvm(st, g.name),
                                        encode_llvm(st, g.addrspace))
                FFI.set_thread_local!(gval_ptr, g.threadlocal)
                FFI.set_unnamed_addr!(gval_ptr, g.unamedaddr)
                FFI.set_global_constant!(gval_ptr, g.isconst)
                if g.init !== nothing
                    FFI.set_initializer!(gval_ptr, encode_llvm(st, g.init))
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
            FFI.set_linkage!(gval_ptr, encode_llvm(st, g.linkage))
            FFI.set_visibility!(gval_ptr, encode_llvm(st, g.visibility))
        end
    end
    return mod_ptr
end

module_to_ast(ctx::Context, mod_ptr::ModulePtr) = begin
    # lift c++ module to Ast.Module 
    @assert ctx.handle == FFI.get_module_ctx(mod_ptr)

    st = DecodeState(ctx)
    
    moduleid   = FFI.get_module_id(mod_ptr)
    datalayout = get_datalayout(mod_ptr)
    triple     = get_target_triple(mod_ptr)

    local defs = Ast.Definition[] 
    for g in FFI.list(GlobalValuePtr,
                      FFI.get_first_global(mod_ptr), 
                      FFI.get_next_global)
        name  = get_global_name(st, g)
        ptrty = decode_llvm(st, FFI.llvm_typeof(g))
        init  = FFI.get_initializer(g)
        var = Ast.GlobalVar(name,
                            FFI.get_linkage(g),
                            FFI.get_visibility(g),
                            FFI.is_thread_local(g),
                            ptrty.addrspace,
                            FFI.has_unnamed_addr(g),
                            FFI.is_global_constant(g),
                            ptrty.typ,
                            !isnull(init) ? decode_llvm(st, init) : nothing, 
                            FFI.get_section(g),
                            FFI.get_alignment(g))
        push!(defs, Ast.GlobalDefinition(var))
    end
    for a in FFI.list(GlobalAliasPtr,
                      FFI.get_first_alias(mod_ptr),
                      FFI.get_next_alias)
        aname = get_global_name(st, a)
        var = Ast.GlobalAlias(aname,
                              FFI.get_linkage(a),
                              FFI.get_visibility(a),
                              FFI.llvm_typeof(a),
                              decode_llvm(st, FFI.get_aliasee(a)))
        push!(defs, Ast.GlobalDefinition(var))
    end
    for f in FFI.list(FunctionPtr,
                      FFI.get_first_func(mod_ptr),
                      FFI.get_next_func)
        fname = get_global_name(st, f)
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
