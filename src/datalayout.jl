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
        io = IOBuffer()
        at, s = t
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

parse_num(io::IO) = begin
    num = Char[]
    while !eof(io)
        c = read(io, Char)
        if !isdigit(c)
            skip(io, -1)
            break
        end
        push!(num, c)
    end
    return int(utf32(num))
end

parse_triple(io::IO) = begin
    s = parse_num(io)
    read(io, Char) === ':' || error("ill formed data layout")
    abi = parse_num(io)
    if eof(io)
        return (s, Ast.AlignmentInfo(abi, nothing))
    end
    c = read(io, Char)
    if c === ':'
        pref = parse_num(io)
        return (s, Ast.AlignmentInfo(abi, pref))
    elseif c !== '-'
        error("ill formed data layout")
    end
    skip(io, -1)
    return (s, Ast.AlignmentInfo(abi, nothing))
end

parse_spec(io::IO, dl::Ast.DataLayout) = begin
    eof(io) && error("cannot parse empty data layout spec")
    while !eof(io)
        c = read(io, Char)
        if c === 'e'
            dl.endianness == nothing || error("ill formed data layout string")
            dl.endianness = Ast.LittleEndian()
            (eof(io) || read(io, Char) === '-') || error("ill formed data layout")
            continue
        elseif c === 'E'
            dl.endianness == nothing || error("ill formed data layout string")
            dl.endianness = Ast.BigEndian()
            (eof(io) || read(io, Char) === '-') || error("ill formed data layout")
            continue
        elseif c === 'm'
            dl.mangling == nothing || error("ill formed data layout string")
            read(io, Char) === ':' || error("ill formed data layout string")
            c = read(io, Char)
            if c === 'e'
                dl.mangling = Ast.ELFMangling()
            elseif c === 'm'
                dl.mangling = Ast.MIPSMangling()
            elseif c === 'o'
                dl.mangling = Ast.MachOMangling()
            elseif c === 'w'
                dl.mangling = Ast.WindowsCOFFMangling()
            end 
            (eof(io) || read(io, Char) === '-') || error("ill formed data layout string")
            continue
        elseif c === 'S'
            dl.stackalignment == nothing || error("ill formed data layout string")
            dl.stackalignment = parse_num(io)
            (eof(io) || read(io, Char) === '-') || error("ill formed data layout string")
            continue
        elseif c === 'p'
            c = read(io, Char)
            as = 0
            if isdigit(c)
                as = int(string(c))
                c = read(io, Char)
            end
            c === ':' || error("ill formed data layout string")
            t = parse_triple(io)
            dl.pointerlayouts[Ast.AddrSpace(as)] = t 
            (eof(io) || read(io, Char) === '-') || error("ill formed data layout string")
            continue
        elseif c === 'i'
            at = Ast.IntegerAlign()
            (sz, ai) = parse_triple(io)
            (eof(io) || read(io, Char) === '-') || error("ill formed data layout string")
            dl.typelayouts[(at, sz)] = ai
            continue
        elseif c === 'v'
            at = Ast.VectorAlign()
            (sz, ai) = parse_triple(io)
            (eof(io) || read(io, Char) === '-') || error("ill formed data layout string")
            dl.typelayouts[(at, sz)] = ai
            continue
        elseif c === 'f'
            at = Ast.FloatAlign()
            (sz, ai) = parse_triple(io)
            (eof(io) || read(io, Char) === '-') || error("ill formed data layout string")
            dl.typelayouts[(at, sz)] = ai
            continue
        elseif c === 'a'
            at = Ast.AggregateAlign()
            (sz, ai) = parse_triple(io)
            (eof(io) || read(io, Char) === '-') || error("ill formed data layout string")
            dl.typelayouts[(at, sz)] = ai 
            continue
        elseif c === 'n'
            dl.nativesizes == nothing || error("ill formed data layout string")
            ns = Set{Int}()
            while true
                push!(ns, parse_num(io))
                eof(io) && break
                read(io, Char) === ':' || error("ill formed data layout string") 
            end
            dl.nativesizes = ns
            eof(io) || error("ill formed data layout string")
        end
    end
    return dl
end

parse_datalayout(io::IO) = begin
    dl = Ast.DataLayout()
    return parse_spec(io, dl)
end

parse_datalayout(s::String) = parse_datalayout(IOBuffer(s))
