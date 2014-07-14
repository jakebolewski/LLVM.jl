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

encode_llvm(ctx::Context, s::String) = begin
    N = length(s)
    ptr = convert(Ptr{Uint8}, Base.c_malloc(sizeof(Uint8) * N + 1))
    unsafe_copy!(ptr, convert(Ptr{Uint8}, s), N)
    unsafe_store!(ptr, zero(Uint8), N+1)
    return ptr
end
decode_llvm(ptr::Ptr{Uint8}) = bytestring(ptr)

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
    #metadata_to_define
    #metadata_nodes
    #meetadata_kinds
end
DecodeState() = DecodeState(Dict{GlobalValuePtr,Int}(),
                            Dict{ValuePtr,Int}(),
                            -1,
                            Dict{TypePtr,Int}(),
                            TypePtr[]) 

get_global_name(ds::DecodeState, val::GlobalValuePtr) = begin
    name = FFI.get_value_name(val)
    !isempty(name) && return Ast.Ast(name)
    n = length(ds.global_var_num)
    ds.global_var_num[val] = n
    return Ast.UnName(n) 
end

get_local_name(ds::DecodeState, val::ValuePtr) = begin
    !isempty(name) && return Ast.Ast(name)
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

module_from_ast(ctx::Context, mod::Ast.Module) = begin
    mod_ptr = FFI.create_module_with_name_in_ctx(mod.name, ctx)    
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
    ds = DecodeState() 
    # lift c++ mdoule to Ast.Module 
    name = FFI.get_module_id(mod_ptr)
    @show name
    #datalayout = FFI.data_layout(mod_ptr)
    fg = FFI.get_first_global(mod_ptr) 
    ty = @show FFI.llvm_typeof(fg)
    @show decode_llvm(ctx, ty)
    n = get_global_name(ds, fg)
end
