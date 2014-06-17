mangling_char(node::Ast.Mangling) = begin
    if isa(node, Ast.ELFMangling)
        return 'e'
    elseif isa(node, Ast.MIPSMangling)
        return 'm'
    elseif isa(node, Ast.MachOMangling)
        return 'o'
    elseif isa(node, Ast.WindowsCOFFMangling)
        return 'w'
    else
        error("unknown type $(typeof(node))")
    end
end

alignment_char(node::Ast.AlignType) = begin
    if isa(node, Ast.IntegerAlign)
        return 'i'
    elseif isa(node, Ast.VectorAlign)
        return 'v'
    elseif isa(node, Ast.FloatAlign)
        return 'f'
    elseif isa(node, Ast.AggregateAlign)
        return 'a'
    else
        error("unknown type $(typeof(node))")
    end
end

endianness_str(node::Ast.BigEndian)    = "E"
endianness_str(node::Ast.LittleEndian) = "e"

mangling_str(node::Ast.Mangling) = "m:$(mangling_char(node))"

nativesizes_str(sizes::Set{Int}) = "n" * join(sort([s for s in sizes]), ":")

write_triple!(io::IO, t::(Int, Ast.AlignmentInfo)) = begin
    s, ai = t
    write(io, string(s))
    write(io, ':')
    write(io, string(ai.abi))
    if ai.perferred != nothing
        write(io, ':') 
        write(io, string(ai.perferred))
    end
end

pointerlayouts_str(layouts::Ast.PointerLayoutMap) = begin
    io = IOBuffer()
    write(io, 'p')
    for (a, t) in layouts
        a.val > 0 && write(io, string(a.val))
        write(io, ':')
        write_triple!(io, t)
    end
    return bytestring(io)
end

typelayouts_str(layouts::Ast.TypeLayoutMap) = begin
    strs = {}
    for (t, ai) in layouts
        at, s = t
        io = IOBuffer()
        write(io, alignment_char(at))
        write_triple!(io, (s, ai))
        push!(strs, bytestring(io))
    end
    return strs
end

Base.print(io::IO, layout::Ast.DataLayout) = begin
    strs = {}
    if layout.endianness != nothing
        push!(strs, endianness_str(layout.endianness)) 
    end 
    if layout.mangling != nothing
        push!(strs, mangling_str(layout.mangling))
    end
    if layout.stackalignment != nothing
        push!(strs, string("S", layout.stackalignment))
    end
    if !isempty(layout.pointerlayouts)
        push!(strs, pointerlayouts_str(layout.pointerlayouts))
    end
    if !isempty(layout.typelayouts)
        append!(strs, typelayouts_str(layout.typelayouts))
    end
    if layout.nativesizes != nothing
        push!(strs, nativesizes_str(layout.nativesizes))
    end
    write(io, join(strs, "-"))
end
