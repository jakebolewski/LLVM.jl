OUTNAME = "cppinstr.jl"

instdef = open(readall, ARGS[1])

TERMS  = {}
BINARY = {}
MEMORY = {}
CAST   = {}
OTHER  = {}

parse_line(line, name) = begin
    t = split(lstrip(lstrip(line, collect("$name(")), [' ', '(']), ',')
    (int(t[1]), rstrip(lstrip(t[2])), rstrip(split(lstrip(t[3]), ')')[1]))
end

for line in split(chomp(instdef), '\n')
    if beginswith(line, "HANDLE_TERM_INST") 
        push!(TERMS, parse_line(line, "HANDLE_TERM_INST"))
    end
    if beginswith(line, "HANDLE_BINARY_INST")
        push!(BINARY, parse_line(line, "HANDLE_BINARY_INST"))
    end 
    if beginswith(line, "HANDLE_MEMORY_INST")
        push!(MEMORY, parse_line(line, "HANDLE_MEMORY_INST"))
    end
    if beginswith(line, "HANDLE_CAST_INST")
        push!(CAST, parse_line(line, "HANDLE_CAST_INST"))
    end
    if beginswith(line, "HANDLE_OTHER_INST")
        push!(OTHER, parse_line(line, "HANDLE_OTHER_INST"))
    end
end

io = open(OUTNAME, "w")
write(io, """
immutable InstructionDef{T}
    opcode::Cint
    capi_name::String
    capi_classname::String
end

""")

write(io, """
const InstructionDefs = [
""")

writeinst(typ, t) = write(io, "\t$(t[1]) => InstructionDef{:$typ}($t...),\n")

map(t -> writeinst(:Term, t), TERMS)
map(t -> writeinst(:Binary, t), BINARY)
map(t -> writeinst(:Memory, t), MEMORY)
map(t -> writeinst(:Cast, t), CAST)
map(t -> writeinst(:Other,t), OTHER)

write(io, "]\n")
close(io)
