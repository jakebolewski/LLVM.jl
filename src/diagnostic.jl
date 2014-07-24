# describes problems during parsing of LLVM IR

type Diagnostic <: Exception
    lineno::Int
    colno::Int
    kind::Symbol
    filename::String
    message::String
    linecontents::String
end

Diagnostic(smd::SMDiagnosticPtr) = begin
    l  = FFI.get_sm_diagnostic_lineno(smd)
    c  = FFI.get_sm_diagnostic_colno(smd)
    k  = FFI.get_sm_diagnostic_kind(smd)
    f  = FFI.get_sm_diagnostic_filename(smd)
    m  = FFI.get_sm_diagnostic_message(smd)
    lc = FFI.get_sm_diagnostic_line_contents(smd)
    kind = k == 0 ? :Error :
           k == 1 ? :Warning :
           k == 2 ? :Note :
           error("unknown diagnostic kind constant $k")
    return Diagnostic(l, c, kind, f, m, lc)
end 

Base.show(io::IO, diag::Diagnostic) =
    print(io, "$(diag.filename):$(diag.lineno):$(diag.colno):\n",
              "$(diag.kind): $(diag.message)\n",
              "$(diag.linecontents)\n")
