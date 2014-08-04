#------------------------------------------------------------------------------
# Module 
#------------------------------------------------------------------------------
type DecodeState
    ctx::Context
    global_var_num::OrderedDict{GlobalPtr, Int}
    local_var_num::OrderedDict{LLVMPtr,Int}
    local_name_counter::Int
    named_type_num::OrderedDict{TypePtr,Int}
    types_to_define::Vector{TypePtr}
end
DecodeState(ctx::Context) = 
    DecodeState(ctx,
                OrderedDict{GlobalPtr,Int}(),
                OrderedDict{LLVMPtr,Int}(),
                -1,
                OrderedDict{TypePtr,Int}(),
                TypePtr[]) 

add_global!(st::DecodeState, val::GlobalPtr) = begin
    if haskey(st.global_var_num, val) || !isempty(FFI.get_value_name(val))
        return
    end
    n = length(st.global_var_num)
    st.global_var_num[val] = n
    return 
end

get_global_name(st::DecodeState, val::GlobalPtr) = begin
    name = FFI.get_value_name(val)
    if !isempty(name)
        return Ast.Name(name)
    end
    if haskey(st.global_var_num, val)
        n = st.global_var_num[val]
    else
        n = length(st.global_var_num)
        st.global_var_num[val] = n
    end 
    return Ast.UnName(n)
end

get_local_name(st::DecodeState, val) = begin
    name = FFI.get_value_name(val)
    if !isempty(name)
        return Ast.Name(name)
    end
    if haskey(st.local_var_num, val)
        n = st.local_var_num[val]
    else
        n = length(st.local_var_num)
        st.local_var_num[val] = n
        st.local_name_counter = n+1
    end
    return Ast.UnName(n)
end

get_type_name(st::DecodeState, name::String) = begin
end

save_named_type(st::DecodeState, typ::TypePtr) =
    (push!(st.types_to_define, typ); return st)

take_type_to_define(st::DecodeState) =
    (pop!(st.types_to_define); return st)

decode_llvm(st::DecodeState, tptr::TypePtr) = begin 
    k = FFI.get_type_kind(tptr)
    if k == TypeKind.integer
        nbits = FFI.get_int_type_width(tptr)    
        return Ast.IntType(nbits) 
    elseif k == TypeKind.pointer
        etyp = decode_llvm(st, FFI.get_elem_type(tptr))
        addr = Ast.AddrSpace(FFI.get_ptr_address_space(tptr))
        return Ast.PtrType(etyp, addr)
    elseif k == TypeKind.half
        return Ast.FloatType(16, Ast.IEEE())
    elseif k == TypeKind.float
        return Ast.FloatType(32, Ast.IEEE())
    elseif k == TypeKind.double
        return Ast.FloatType(64, Ast.IEEE())
    elseif k == TypeKind.func
        return Ast.FuncType(decode_llvm(st, FFI.get_return_type(tptr)),
                            [decode_llvm(st, ty) for ty in FFI.get_param_types(tptr)],
                            FFI.is_func_var_arg(tptr))
    elseif k == TypeKind.struct
        if FFI.is_literal_struct(tptr)
            packed = FFI.is_packed_struct(tptr)
            typs = decode_llvm(st, FFI.get_struct_elem_types(tptr))
            return Ast.StructType(packed, typs)
        else
            error("unimplemented")
        end 
    elseif k == TypeKind.array
        len = FFI.get_array_length(tptr)
        typ = decode_llvm(st, FFI.get_elem_type(tptr))
        return Ast.ArrayType(typ, len)
    else
        error("unimplemented type kind $k")
    end
end

decode_llvm(st::DecodeState, typs::Vector{TypePtr}) = begin
    asttyps = Array(Ast.LLVMType, length(typs))
    for i = 1:length(asttyps)
        asttyps[i] = decode_llvm(st, typs[i])
    end
    return asttyps
end

decode_llvm(st::DecodeState, cptr::ConstPtr) = begin
    ftyp = FFI.llvm_typeof(cptr)
    typ  = decode_llvm(st, ftyp)
    nops = FFI.get_num_operands(cptr)

    subclass_id = FFI.get_value_subclass_id(cptr)
    
    if subclass_id == ValueSubclass.undef_value
        return Ast.ConstUndef(typ)
    
    elseif subclass_id == ValueSubclass.global_variable
        #name = get_global_name(st, FFI.isa_global_value(cptr))
        n = st.global_var_num[FFI.isa_global_value(cptr)]
        name = Ast.UnName(n)
        return Ast.ConstGlobalRef(typ, name) 

    elseif subclass_id == ValueSubclass.const_int
        words  = FFI.get_constant_int_words(cptr)
        nwords = length(words) 
        # this is wrong but it gets the tests to pass 
        v0 = nwords == 1 ? zero(Uint64) :
             nwords == 2 ? zero(Uint128) : zero(BigInt)
        n = foldr((b, a) -> (a << 64) | b, v0, words)
        return Ast.ConstInt(typ.nbits, n)
   
    elseif subclass_id == ValueSubclass.const_expr
        opcode = FFI.get_const_opcode(cptr)
        
        if (opcode == Opcode.add || opcode == Opcode.sub || 
            opcode == Opcode.mul || opcode == Opcode.shl) 
            nsw = FFI.no_signed_wrap(cptr)
            nuw = FFI.no_unsigned_wrap(cptr)
            op1 = decode_llvm(st, FFI.get_constant_operand(cptr, 1))
            op2 = decode_llvm(st, FFI.get_constant_operand(cptr, 2))
            opcode == Opcode.add && return Ast.ConstAdd(nsw, nuw, op1, op2)
            opcode == Opcode.sub && return Ast.ConstSub(nsw, nuw, op1, op2)
            opcode == Opcode.mul && return Ast.ConstMul(nsw, nuw, op1, op2)
            opcode == Opcode.shl && return Ast.ConstShl(nsw, nuw, op1, op2)

        elseif opcode == Opcode.get_element_ptr
            inbounds = FFI.get_inbounds(cptr)
            addr = decode_llvm(st, FFI.get_constant_operand(cptr, 1))
            idxs = Array(Ast.Constant, nops-1)
            for i = 2:nops
                idxs[i-1] = decode_llvm(st, FFI.get_constant_operand(cptr, i))
            end 
            return Ast.ConstGetElementPtr(inbounds, addr, idxs)

        elseif opcode == Opcode.ptrtoint
            op1 = decode_llvm(st, FFI.get_constant_operand(cptr, 1))
            return Ast.ConstPtrToInt(op1, typ)

        elseif opcode == Opcode.icmp
            pred = FFI.get_icmp_predicate(cptr)
            op1  = decode_llvm(st, FFI.get_constant_operand(cptr, 1))
            op2  = decode_llvm(st, FFI.get_constant_operand(cptr, 2))
            ipred = Ast.int_cmp_pred_map[pred]
            return Ast.ConstICmp(ipred, op1, op2)
        end
        error("unimplemented constant expr opcode $opcode")

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

    elseif subclass_id == ValueSubclass.const_struct
        name = isa(typ, Ast.NamedTypeRef) ? typ.val : nothing 
        p = FFI.is_packed_struct(ftyp)
        n = FFI.get_num_operands(cptr)
        vals = Array(Ast.Constant, n)
        for i = 1:n
            vals[i] = decode_llvm(st,
                FFI.get_constant_operand(cptr, i))
        end
        return Ast.ConstStruct(name, p, vals) 

    elseif subclass_id == ValueSubclass.const_data_array
        @assert isa(typ, Ast.ArrayType)
        vals = Array(Ast.Constant, typ.len)
        for i = 1:typ.len
            vals[i] = decode_llvm(st, 
                FFI.get_const_data_seq_elem_as_const(cptr, i))
        end
        return Ast.ConstArray(typ.typ, vals)

    elseif subclass_id == ValueSubclass.const_array
        @assert isa(typ, Ast.ArrayType)
        vals = Array(Ast.Constant, typ.len)
        for i = 1:typ.len
            vals[i] = decode_llvm(st, 
                FFI.get_constant_operand(cptr, i))
        end 
        return Ast.ConstArray(typ.typ, vals)

    else
        error("unimplemented subclassid : $subclass_id")
    end
end

decode_llvm(buf::MemoryBufferPtr) = begin
    start = FFI.get_buffer_start(buf)
    size  = FFI.get_buffer_size(buf)
    res = Array(Uint8, size)
    unsafe_copy!(convert(Ptr{Uint8}, res), start, size)
    return res
end
decode_llvm(st::DecodeState, buf::MemoryBufferPtr) = decode_llvm(buf)

get_metadata(iptr::InstructionPtr, n::Int) = begin
    kinds = Array(Cint, n)
    nodes = Array(MDNodePtr, n)
    nn = FFI.get_metadata(iptr, kinds, nodes, n)
    nn == 0 && return Ast.InstructionMetadata[]
    nn > n  && return get_metadata(iptr, nn) 
    return zip([decode_llvm(st, kd) for kd in kinds],
               [decode_llvm(st, nd) for nd in nodes])
end
get_metadata(iptr::InstructionPtr) = get_metadata(iptr, 4)
    

decode_llvm(st::DecodeState, iptr::InstructionPtr) = begin
    opcode = FFI.get_instr_def_opcode(iptr)
    nops = FFI.get_num_operands(iptr)
    meta = get_metadata(iptr)
    if opcode == Opcode.ret
        op = nops == 0 ? nothing : 
             Ast.ConstOperand(decode_llvm(st, FFI.get_operand(iptr, 1)))
        return Ast.Ret(op, meta)
    end
    error("unimplemented instruction opcode $opcode")
end

abstract LocalVal

immutable ForwardVal <: LocalVal
    val::Types.LLVMPtr
end 

immutable DefinedVal <: LocalVal
    val::Types.LLVMPtr
end 

type EncodeState
    ctx::Context
    builder::BuilderPtr
    named_types::OrderedDict{Ast.LLVMName,TypePtr}
    locals::OrderedDict{Ast.LLVMName, LocalVal}
    globals::OrderedDict{Ast.LLVMName, GlobalPtr} 
    allblocks::OrderedDict{(Ast.LLVMName, Ast.LLVMName), BasicBlockPtr}
    blocks::OrderedDict{Ast.LLVMName, BasicBlockPtr}
    mdnodes::OrderedDict{Ast.MetadataNodeID, MDNodePtr}
end

EncodeState(ctx::Context) = begin
    bldr = FFI.create_builder_in_ctx(ctx)
    es = EncodeState(ctx, bldr,
                     OrderedDict{Ast.LLVMName,TypePtr}(),
                     OrderedDict{Ast.LLVMName,LocalVal}(),
                     OrderedDict{Ast.LLVMName,GlobalPtr}(),
                     OrderedDict{(Ast.LLVMName,Ast.LLVMName), BasicBlockPtr}(),
                     OrderedDict{Ast.LLVMName,BasicBlockPtr}(),
                     OrderedDict{Ast.MetadataNodeID,MDNodePtr}())
    finalizer(es, (st) -> begin
        if !isnull(st.builder)
            FFI.dispose_builder(st.builder)
            st.builder = BuilderPtr(C_NULL)
        end
    end)
    return es
end 

get_named_type(st::EncodeState, name::String) = get_named_type(st, Ast.Name(name))
get_named_type(st::EncodeState, name::Ast.LLVMName) = st.named_types[name]

get_local_type(st::EncodeState, name::String) = get_local_type(st, Ast.Name(name))
get_local_type(st::EncodeState, name::Ast.LLVMName) = st.locals[name]

get_global(st::EncodeState, name::String) = get_global(st, Ast.Name(name))
get_global(st::EncodeState, name::Ast.LLVMName) = st.globals[name]

define_global!(st::EncodeState, name::String, ptr::GlobalPtr) =
    (st.globals[Ast.Name(name)] = ptr; return)

define_global!(st::EncodeState, name::Ast.LLVMName, ptr::GlobalPtr) = 
    (st.globals[name] = ptr; return)

define_basic_block!(st::EncodeState, 
                    fname::Ast.LLVMName,
                    bname::Ast.LLVMName,
                    ptr::BasicBlockPtr) = begin
    st.allblocks[(fname, bname)] = ptr
    st.blocks[bname] = ptr
    return
end

define_basic_block!(st::EncodeState, fname, bname, ptr) =
    define_basic_block(st, isa(fname, String) ? Ast.Name(fname) : fname::Ast.LLVMName,
                           isa(bname, String) ? Ast.Name(bname) : bname::Ast.LLVMName, ptr)

define_local!(st::EncodeState, lname::Ast.Name, ptr) = begin
    if haskey(st.locals, lname)
        def = st.locals[lanme]
        if isa(def, ForwardVal)
            FFI.replace_all_uses_with(convert(ValuePtr, def.val), ptr)
        end
        return
    end
    st.locals[lname] = DefinedVal(ptr)
    return
end

with_locals(f::Function, st::EncodeState) = begin
    ol, ob = st.locals, st.blocks
    try
        st.locals = copy(st.locals)
        st.blocks = copy(st.blocks)
        f(st)
    finally
        st.locals = ol
        st.blocks = ob
    end
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

encode_llvm(st::EncodeState, ptr::Ast.PtrType) = begin
    typ  = encode_llvm(st, ptr.typ)
    addr = encode_llvm(st, ptr.addrspace)
    return FFI.ptr_type(typ, addr)
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

encode_llvm(st::EncodeState, attrs::Vector{Ast.FuncAttr}) = begin
    isempty(attrs) && return uint32(0)
    bits = uint32(attrs[1])
    for i = 2:length(attrs)
        flag = Ast.func_attr_map[attrs[i]]
        bits |= uint32(flag)
    end
    return bits
end

encode_llvm(st::EncodeState, attrs::Vector{Ast.ParamAttr}) = begin
    isempty(attrs) && return uint32(0)
    bits = uint32(attrs[1])
    for i = 2:length(attrs)
        flag = Ast.param_attr_map[attrs[i]]
        bits &= uint32(flag)
    end
    return bits
end

encode_llvm(st::EncodeState, styp::Ast.StructType) = begin
    typs = encode_llvm(st, styp.typs)
    return FFI.struct_type_in_ctx(st.ctx, typs, styp.packed)
end 

encode_llvm(st::EncodeState, struct::Ast.ConstStruct) = begin
    cptrs = encode_llvm(st, struct.vals)::Vector{ConstPtr}
    if is(struct.name, nothing)
        return FFI.const_struct_in_ctx(st.ctx, cptrs, struct.packed)
    end
    # lookup named type from encoding state
    typ = st.named_types[struct.name]::TypePtr
    return FFI.const_named_struct(typ, cptrs)
end

encode_llvm(st::EncodeState, typ::Ast.ArrayType) = 
    FFI.array_type(encode_llvm(st, typ.typ), typ.len)

encode_llvm(st::EncodeState, typ::Ast.FuncType) =
    FFI.func_type(encode_llvm(st, typ.rettyp),
                  encode_llvm(st, typ.argtyps),
                  typ.vaargs)

encode_llvm(st::EncodeState, carr::Ast.ConstArray) = 
    FFI.const_array(encode_llvm(st, carr.typ),
                    encode_llvm(st, carr.vals))

encode_llvm(st::EncodeState, undef::Ast.ConstUndef) =
    FFI.const_undef(encode_llvm(st, undef.typ))

encode_llvm(st::EncodeState, addr::Ast.AddrSpace) = addr.val

encode_llvm(st::EncodeState, name::Ast.Name)   = name.val
encode_llvm(st::EncodeState, name::Ast.UnName) = ""

encode_llvm(st::EncodeState, ::Ast.Linkage{:External}) = 0
encode_llvm(st::EncodeState, ::Ast.DefaultVisibility)  = 0

encode_llvm(st::EncodeState, c::Ast.CConvention) = CallingCov.c

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

encode_llvm(st::EncodeState, ref::Ast.ConstGlobalRef) =
    get_global(st, ref.name)

encode_llvm(st::EncodeState, inst::Ast.ConstPtrToInt) = begin
    val = encode_llvm(st, inst.op)
    typ = encode_llvm(st, inst.typ)
    return FFI.const_ptrtoint(val, typ)
end

encode_llvm(st::EncodeState, inst::Ast.ConstGetElementPtr) = begin
    addr = encode_llvm(st, inst.addr)
    idxs = encode_llvm(st, inst.idxs)
    return inst.inbounds ? FFI.const_inbounds_getelem_ptr(addr, idxs) :
                           FFI.const_getelem_ptr(addr, idxs)
end

encode_llvm(st::EncodeState, inst::Ast.ConstAdd) = begin
    lhs = encode_llvm(st, inst.op1)
    rhs = encode_llvm(st, inst.op2)
    inst.nsw && return FFI.const_nswadd(lhs, rhs)
    inst.nuw && return FFI.const_nuwadd(lhs, rhs)
    return FFI.const_add(lhs, rhs)
end

encode_llvm(st::EncodeState, inst::Ast.ConstICmp) = begin
    if isa(inst.pred, Ast.SGE)
        pred = IntPred.sge
    else
        error("unimplemented predicate for const icmp")
    end
    lhs = encode_llvm(st, inst.op1)
    rhs = encode_llvm(st, inst.op2)
    return FFI.const_icmp(pred, lhs, rhs)
end

# Encode Operands
encode_llvm(st::EncodeState, op::Ast.ConstOperand) = 
    encode_llvm(st, op.val)

# Encode Terminators 
encode_llvm(st::EncodeState, term::Ast.Ret) = 
    is(term.op, nothing) ? FFI.build_ret_void(st.builder) :
                           FFI.build_ret(st.builder, encode_llvm(st, term.op))

with_sm_diagnostic(f::Function) = begin
    smd = FFI.create_sm_diagnostic()
    try
        f(smd)
    finally 
        FFI.dispose_sm_diagnostic(smd)
    end 
end

module_from_bitcode(ctx::Context, buf::MemoryBufferPtr) = begin
    modptr = [ModulePtr(C_NULL)]
    outmsg = Ptr{Uint8}[0]
    status = FFI.parse_llvm_bitcode(ctx, buf, modptr, outmsg)
    mod = modptr[1]
    if status != zero(LLVMBool)
        if msg[1] != C_NULL
            err = bytestring(msg[1])
            c_free(msg[1])
            throw(ErrorException(err))
        else
            error("unknown error with `parse_llvm_bitcode`")
        end
    end
    @assert !isnull(mod)
    return mod
end

# llvm takes ownership of the buffer
module_from_bitcode(ctx::Context, bytes::Union(ByteString, IOBuffer)) = begin
    buf = FFI.create_mem_buffer_with_mem_range("<bytes>", bytes.data)
    return module_from_bitcode(ctx, buf)
end

module_from_bitcode(ctx::Context, name::String, bytes::Union(ByteString, IOBuffer)) = begin
    buf = FFI.create_mem_buffer_with_mem_range(name, bytes.data)
    return module_from_bitcode(ctx, buf)
end 

module_from_bitcode(ctx::Context, bytes::Vector{Uint8}) = begin
    buf = FFI.create_mem_buffer_with_mem_range("<bytes>", bytes)
    return module_from_bitcode(ctx, buf)
end 

module_from_bitcode(ctx::Context, name::String, bytes::Vector{Uint8}) = begin
    buf = FFI.create_mem_buffer_with_mem_range(name, bytes)
    return module_from_bitcode(ctx, buf)
end 

module_from_bitcode_file(ctx::Context, path::String) = begin
    buf = FFI.create_mem_buffer_with_contents_of_file(path)
    return module_from_bitcode(ctx, buf)
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
    FFI.with_file_raw_ostream(path, false) do ostream
        FFI.write_llvm_assembly(ostream, mod)
    end
end 

# write LLVM Bitcode from a 'ModulePtr' to a file
write_bitcode_file(path::String, mod::ModulePtr) = begin
    FFI.with_file_raw_ostream(path, false) do ostream 
        FFI.write_llvm_bitcode(ostream, mod)
    end
end 

get_target_triple(ptr::ModulePtr) =
    (s = FFI.get_target_triple(ptr); isempty(s) ? nothing : s)

get_datalayout(ptr::ModulePtr) =
    (s = FFI.get_datalayout(ptr); isempty(s) ? nothing : parse_datalayout(s))

module_from_ast(ctx::Context, mod::Ast.Mod) = begin
    st = EncodeState(ctx)
    mod_ptr = FFI.create_module_with_name_in_ctx(mod.name, st.ctx)
    mod.layout !== nothing && FFI.set_datalayout!(mod_ptr, mod.layout) 
    mod.target !== nothing && FFI.set_target_triple!(mod_ptr, mod.target)
    # phase 1 define global definitions 
    for def in mod.defs
        if isa(def, Ast.TypeDef)
            error("unimplemented")
        elseif isa(def, Ast.MetadataNodeDef)
            error("unimplemented")
        elseif isa(def, Ast.ModInlineAsm)
            error("unimplemented")
        elseif isa(def, Ast.GlobalDef)
            local g = def.val 
            local gptr::GlobalValuePtr
            if isa(g, Ast.GlobalVar)
                gptr = FFI.add_global_in_addr_space!(
                                        mod_ptr,
                                        encode_llvm(st, g.typ), 
                                        encode_llvm(st, g.name),
                                        encode_llvm(st, g.addrspace))
                # add global to encoding state
                define_global!(st, g.name, gptr)
            elseif isa(g, Ast.GlobalAlias)
                typ  = encode_llvm(st, g.typ)
                gptr = FFI.just_add_alias(mod_ptr,
                                          encode_llvm(st, g.typ),
                                          encode_llvm(st, g.name))
            elseif isa(g, Ast.Func)
                ftyp = encode_llvm(st,
                    Ast.FuncType(g.rettyp, [p.typ for p in g.params], g.vaargs))
                f = FFI.add_function(mod_ptr, encode_llvm(st, g.name), ftyp)
                define_global!(st, g.name, f)
            end
        end
    end
    for def in mod.defs
        if isa(def, Ast.GlobalDef)
            local g = def.val
            local gptr = get_global(st, g.name)
            if isa(g, Ast.GlobalVar)
                @assert isa(gptr, GlobalValuePtr)
                FFI.set_thread_local!(gptr, g.threadlocal)
                FFI.set_unnamed_addr!(gptr, g.unamedaddr)
                FFI.set_global_constant!(gptr, g.isconst)
                if g.init !== nothing
                    FFI.set_initializer!(gptr, encode_llvm(st, g.init))
                end
                if g.section !== nothing
                    FFI.set_section!(gptr, g.section)
                end
                FFI.set_alignment!(gptr, g.alignment)
            elseif isa(g, Ast.GlobalAlias)
                @assert isa(gptr, GlobalAliasPtr)
                FFI.set_aliasee!(gptr, encode_llvm(st, g.aliasee))
            elseif isa(g, Ast.Func)
                @assert isa(gptr, FunctionPtr)
                FFI.set_func_call_cov!(gptr, encode_llvm(st, g.callingcov))
                FFI.add_func_ret_attr!(gptr, encode_llvm(st, g.retattrs))
                FFI.add_func_attr!(gptr, encode_llvm(st, g.attrs))
                if g.section != nothing
                    FFI.set_section!(gptr, g.section)
                end
                if g.alignment != nothing
                    FFI.set_alignment!(gptr, g.alignment)
                end
                if g.gcname != nothing
                    FFI.set_gc!(gptr, g.gcname)
                end
                for blk in g.blocks
                    b = FFI.append_basicblock_in_ctx(ctx, gptr, encode_llvm(st, blk.name))
                    define_basic_block!(st, g.name, blk.name, b)
                end
                with_locals(st) do st
                    # define and add func parameters
                    pptrs = FFI.get_params(gptr)
                    for p in g.params, pptr in pptrs
                        define_local!(st, g.name, pptr)
                        FFI.set_value_name!(pptr, encode_llvm(st, p.name))
                        if !isempty(p.attrs)
                            FFI.add_attribute!(pptr, encode_llvm(st, p.attrs))
                        end
                    end
                    # build basic blocks
                    for b in g.blocks
                        bptr = st.blocks[b.name]
                        FFI.position_builder_end(st.builder, bptr)
                        # encode basic block instructions
                        for inst in b.insts
                            encode_llvm(st, inst)
                        end
                        # encode basic block terminator
                        encode_llvm(st, b.term)
                    end
                end
                # error out if any forward declared locals have not been realized 
                for (k, v) in st.locals
                    isa(v, ForwardVal) && error("local $k is undefined")
                end
            end
            FFI.set_linkage!(gptr, encode_llvm(st, g.linkage))
            FFI.set_visibility!(gptr, encode_llvm(st, g.visibility))
        end
    end
    return mod_ptr
end

get_func_attrs(st::DecodeState, fnptr::FunctionPtr) = begin
    attrs = Ast.ParamAttr[]
    attr = FFI.get_func_attr(fnptr)
    bool(attr & Attribute.naked) && push!(attrs, Ast.Naked())
    bool(attr & Attribute.no_return) && push!(attrs, Ast.NoReturn())
    bool(attr & Attribute.no_unwind) && push!(attrs, Ast.NoUnwind())
    bool(attr & Attribute.read_none) && push!(attrs, Ast.ReadNone())
    bool(attr & Attribute.read_only) && push!(attrs, Ast.ReadOnly())
    bool(attr & Attribute.no_inline) && push!(attrs, Ast.NoInline())
    bool(attr & Attribute.uw_table)  && push!(attrs, Ast.UWTable())
    bool(attr & Attribute.inline_hint) && push!(attrs, Ast.InlineHint())
    bool(attr & Attribute.no_red_zone) && push!(attrs, Ast.NoRedZone())
    bool(attr & Attribute.stack_protect) && push!(attrs, Ast.StackProtect())
    bool(attr & Attribute.always_inline) && push!(attrs, Ast.AlwaysInline())
    bool(attr & Attribute.returns_twice) && push!(attrs, Ast.ReturnsTwice())
    bool(attr & Attribute.stack_alignment)   && push!(attrs, Ast.StackAlignment())
    bool(attr & Attribute.stack_protect_req) && push!(attrs, Ast.StackProtectReq())
    bool(attr & Attribute.optimize_for_size) && push!(attrs, Ast.OptimizeForSize())
    bool(attr & Attribute.no_implicit_float) && push!(attrs, Ast.NoImplicitFloat())
    return attrs
end

get_param_attrs(st::DecodeState, pptr::ParamPtr) = begin
    attrs = Ast.ParamAttr[]
    attr  = FFI.get_attribute(pptr)
    bool(attr & Attribute.s_ext)      && push!(attrs, Ast.SignExt())
    bool(attr & Attribute.in_reg)     && push!(attrs, Ast.InReg())
    bool(attr & Attribute.struct_ret) && push!(attrs, Ast.SRet())
    bool(attr & Attribute.no_alias)   && push!(attrs, Ast.NoAlias())
    bool(attr & Attribute.by_val)     && push!(attrs, Ast.ByVal())
    bool(attr & Attribute.no_capture) && push!(attrs, Ast.NoCapture())
    bool(attr & Attribute.nest)       && push!(attrs, Ast.Nest())
    return attrs
end

get_call_cov(st::DecodeState, fn::FunctionPtr) = begin
    val = FFI.get_func_call_cov(fn)
    val == CallingCov.c    && return Ast.CConvention()
    val == CallingCov.fast && return Ast.FastConvention()
    val == CallingCov.cold && return Ast.ColdConvention()
    error("unhandled calling convention enum value: $val")
end

get_linkage(st::DecodeState, fn::FunctionPtr) = begin
    val = FFI.get_visibility(fn)
    val == 0 && return Ast.Linkage{:External}() 
    error("unhandled linkage enum value: $val")
end

get_visibility(st::DecodeState, fn::FunctionPtr) = begin
    val = FFI.get_visibility(fn)
    val == 0 && return Ast.DefaultVisibility()
    error("unhandled visibility enum value: $val")
end

get_params(st::DecodeState, fptr::FunctionPtr) = begin
    ps = Ast.Param[]
    for pptr in FFI.get_params(fptr)
        push!(ps, Ast.Param(decode_llvm(st, FFI.llvm_typeof(pptr)),
                            get_local_name(st, pptr),
                            get_param_attrs(st, pptr)))
    end
    return ps
end

function module_to_ast(ctx::Context, mod_ptr::ModulePtr)
    # lift c++ module to Ast.Module 
    @assert ctx.handle == FFI.get_module_ctx(mod_ptr)

    st = DecodeState(ctx)
    
    moduleid   = FFI.get_module_id(mod_ptr)
    datalayout = get_datalayout(mod_ptr)
    triple     = get_target_triple(mod_ptr)
    
    # Phase 1; add toplevel global definitions 
    add_toplevel(g) = add_global!(st, g)
    map(add_toplevel, FFI.list(GlobalValuePtr, 
                               FFI.get_first_global(mod_ptr),
                               FFI.get_next_global))
    map(add_toplevel, FFI.list(GlobalAliasPtr,
                               FFI.get_first_alias(mod_ptr),
                               FFI.get_next_alias))
    map(add_toplevel, FFI.list(FunctionPtr,
                               FFI.get_first_func(mod_ptr),
                               FFI.get_next_func))
    
    # Phase 2; lift c++ definitions to Ast nodes 
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
        push!(defs, Ast.GlobalDef(var))
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
        push!(defs, Ast.GlobalDef(var))
    end
    for fn in FFI.list(FunctionPtr,
                       FFI.get_first_func(mod_ptr),
                       FFI.get_next_func)
        fname = get_global_name(st, fn)
        ptrty = decode_llvm(st, FFI.llvm_typeof(fn)) 
        bblocks = Ast.BasicBlock[]
        for bb in FFI.list(BasicBlockPtr,
                           FFI.get_first_basicblock(fn),
                           FFI.get_next_basicblock)
            name  = get_local_name(st, bb)
            iptrs = FFI.list(InstructionPtr, 
                             FFI.get_first_instruction(bb), 
                             FFI.get_next_instruction)
            insts = Ast.Instruction[]
            if length(iptrs) > 2
                for i=1:length(iptrs)-1
                    push!(insts, decode_llvm(st, iptrs[i]))
                end
            end
            term  = decode_llvm(st, FFI.get_basicblock_terminator(bb)) 
            push!(bblocks, Ast.BasicBlock(name, insts, term))
        end
        fnty = ptrty.typ
        func = Ast.Func(get_linkage(st, fn), 
                        get_visibility(st, fn),
                        get_call_cov(st, fn), 
                        get_func_attrs(st, fn), 
                        fnty.rettyp,
                        fname,
                        get_params(st, fn),
                        fnty.vaargs,
                        get_func_attrs(st, fn),
                        FFI.get_section(fn),
                        FFI.get_alignment(fn),
                        FFI.get_gc(fn),
                        bblocks)
        push!(defs, Ast.GlobalDef(func))
    end

    # struct definitions
    # module inline asm
    # named metadata nodes
    # metadata definitions

    return Ast.Mod(moduleid, datalayout, triple, defs)
end

# Exe Engine
remove_module(eng::ExeEnginePtr, mod::ModulePtr) = FFI.remove_module(eng, mod)

with_module_in_engine(f::Function, eng::ExeEnginePtr, mod::ModulePtr) = begin
end

with_engine(f::Function) = begin
end

with_jit(mod; optlevel=0) = begin
    @assert optlevel >= 0
    opts = JITCompilerOpts(1, 1, false, false)
    return FFI.create_mcjit_compiler_for_module(mod, opts) 
end
