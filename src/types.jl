abstract LLVMOpaquePtr

for ty in [:ModulePtr, :TypePtr, :ValuePtr, :BasicBlockPtr, :BuilderPtr, 
           :MemoryBufferPtr, :PassManagerPtr, :PassRegistryPtr, :UsePtr]
    @eval begin
        immutable $ty <: LLVMOpaquePtr
            ptr::Ptr{Void}
        end

        pointer(ptr::$ty) = ptr.ptr
    end
end

baremodule TypeKindEnum
    void      = 0   # type with no size
    half      = 1   # 16 bit floating point type
    float     = 2   # 32 bit floating point type
    double    = 3   # 64 bit floating point type
    x86_fp80  = 4   # 80 bit floating point type 
    fp128     = 5   # 128 bit floating point type (112-bit mantissa)
    ppc_fp128 = 6   # 128 bit floating point type (two 64 bits)
    label     = 7   # labels
    integer   = 8   # arbitrary bit width integers
    function_  = 9   # functions
    struct    = 10  # structures
    array     = 11  # arrays
    pointer   = 12  # pointers
    vector    = 13  # SIMD packed format or other vector type
    metadata  = 14  # metadata
    x86_mmx   = 15  # x86 specific multimedia SIMD types 
end

baremodule OpcodeEnum 
    ret = 1
    br = 2
    switch = 3
    indirect_br = 4
    invoke = 5
    unreachable = 7
    add = 8
    f_add = 9
    sub = 10
    f_sub = 11
    mul = 12
    f_mul = 13
    u_div = 14
    s_div = 15
    f_div = 16
    u_rem = 17
    s_rem = 18
    f_rem = 19
    shl = 20
    l_shr = 21
    a_shr = 22
    and_ = 23
    or_ = 24
    xor = 25
    alloca = 26
    load  = 27
    store = 28
    get_element_ptr = 29
    trunc = 30
    z_ext = 31
    s_ext = 32
    fp_to_ui = 33
    fp_to_si = 34
    ui_to_fp = 35
    si_to_fp = 36
    fp_trunc = 37
    fp_ext = 38
    ptr_to_int = 39
    int_to_ptr = 40
    bit_cast = 41
    addr_space_cast = 60
    i_cmp = 42
    f_cmp = 43
    phi = 44
    call = 45
    select = 46
    user_op1 = 47
    user_op2 = 48
    va_arg = 49
    extract_element = 50
    insert_element = 51
    shuffle_vector = 52
    extract_value = 53
    insert_value = 54
    fence = 55
    atomic_cmp_xchg = 56
    atomic_rmw = 57
    resume = 58
    landing_pad = 59
end

# === Options:
# :external ::
#   
# :available_externally ::
#   < Externally visible function
# :link_once_any ::
#   
# :link_once_odr ::
#   < Keep one copy of function when linking (inline)
# :link_once_odr_auto_hide ::
#   < Same, but only replaced by something
#                               equivalent.
# :weak_any ::
#   < Obsolete
# :weak_odr ::
#   < Keep one copy of function when linking (weak)
# :appending ::
#   < Same, but only replaced by something
#                               equivalent.
# :internal ::
#   < Special purpose, only applies to global arrays
# :private ::
#   < Rename collisions when linking (static
#                                  functions)
# :dll_import ::
#   < Like Internal, but omit from symbol table
# :dll_export ::
#   < Function to be imported from DLL
# :external_weak ::
#   < Function to be accessible from DLL
# :ghost ::
#   < ExternalWeak linkage description
# :common ::
#   < Obsolete
# :linker_private ::
#   < Tentative definitions
# :linker_private_weak ::
#   < Like Private, but linker removes.
# 
baremodule LinkageEnum 
    external = 0
    available_externally = 1
    link_once_any = 2
    link_once_odr = 3
    link_once_odr_auto_hide = 4
    weak_any = 5
    weak_odr = 6
    appending = 7
    internal = 8
    private = 9
    dll_import = 10
    dll_export = 11
    external_weak = 12
    ghost = 13
    common = 14
    linker_private = 15
    linker_private_weak = 16
end
# (Not documented)
# 
# <em>This entry is only for documentation and no real method. The FFI::Enum can be accessed via #enum_type(:visibility).</em>
# 
# === Options:
# :default ::
#   
# :hidden ::
#   < The GV is visible
# :protected ::
#   < The GV is hidden
# 
# @method _enum_visibility_
# @return [Symbol]
# @scope class
baremodule VisibilityEnum
    default   = 0
    hidden    = 1
    protected = 2
end

# (Not documented)
# 
# <em>This entry is only for documentation and no real method. The FFI::Enum can be accessed via #enum_type(:call_conv).</em>
# 
# === Options:
# :c ::
#   
# :fast ::
#   
# :cold ::
#   
# :web_kit_js ::
#   
# :any_reg ::
#   
# :x86_stdcall ::
#   
# :x86_fastcall ::
#   
# 
# @method _enum_call_conv_
# @return [Symbol]
# @scope class
baremodule CallCovEnum
    c = 0
    fast = 8
    cold = 9
    web_kit_js = 12
    any_reg = 13
    x86_stdcall = 64
    x86_fastcall = 65
end

# (Not documented)
# 
# <em>This entry is only for documentation and no real method. The FFI::Enum can be accessed via #enum_type(:int_predicate).</em>
# 
# === Options:
# :eq ::
#   
# :ne ::
#   < equal
# :ugt ::
#   < not equal
# :uge ::
#   < unsigned greater than
# :ult ::
#   < unsigned greater or equal
# :ule ::
#   < unsigned less than
# :sgt ::
#   < unsigned less or equal
# :sge ::
#   < signed greater than
# :slt ::
#   < signed greater or equal
# :sle ::
#   < signed less than
# 
# @method _enum_int_predicate_
# @return [Symbol]
# @scope class
baremodule IntPredicateEnum
    eq = 32
    ne = 33
    ugt = 34
    uge = 35
    ult = 36
    ule = 37
    sgt = 38
    sge = 39
    slt = 40
    sle = 41
end

# (Not documented)
# 
# <em>This entry is only for documentation and no real method. The FFI::Enum can be accessed via #enum_type(:real_predicate).</em>
# 
# === Options:
# :predicate_false ::
#   
# :oeq ::
#   < Always false (always folded)
# :ogt ::
#   < True if ordered and equal
# :oge ::
#   < True if ordered and greater than
# :olt ::
#   < True if ordered and greater than or equal
# :ole ::
#   < True if ordered and less than
# :one ::
#   < True if ordered and less than or equal
# :ord ::
#   < True if ordered and operands are unequal
# :uno ::
#   < True if ordered (no nans)
# :ueq ::
#   < True if unordered: isnan(X) | isnan(Y)
# :ugt ::
#   < True if unordered or equal
# :uge ::
#   < True if unordered or greater than
# :ult ::
#   < True if unordered, greater than, or equal
# :ule ::
#   < True if unordered or less than
# :une ::
#   < True if unordered, less than, or equal
# :predicate_true ::
#   < True if unordered or not equal
# 
# @method _enum_real_predicate_
# @return [Symbol]
# @scope class
baremodule RealPredicateEnum
    predicate_false =  0
    oeq =  1
    ogt =  2
    oge =  3
    olt =  4
    ole =  5
    one =  6
    ord =  7
    uno =  8
    ueq =  9
    ugt = 10
    uge = 11
    ult = 12
    ule = 13
    une = 14
    predicate_true = 15
end

# (Not documented)
# 
# <em>This entry is only for documentation and no real method. The FFI::Enum can be accessed via #enum_type(:landing_pad_clause_ty).</em>
# 
# === Options:
# :catch ::
#   
# :filter ::
#   < A catch clause  
# 
# @method _enum_landing_pad_clause_ty_
# @return [Symbol]
# @scope class
baremodule LandingPadClauseTyEnum
    catch_  = 0
    filter = 1
end

# (Not documented)
# 
# <em>This entry is only for documentation and no real method. The FFI::Enum can be accessed via #enum_type(:thread_local_mode).</em>
# 
# === Options:
# :not_thread_local ::
#   
# :general_dynamic_tls_model ::
#   
# :local_dynamic_tls_model ::
#   
# :initial_exec_tls_model ::
#   
# :local_exec_tls_model ::
#   
# 
# @method _enum_thread_local_mode_
# @return [Symbol]
# @scope class
baremodule ThreadLocalModeEnum
    not_thread_local = 0
    general_dynamic_tls_mode = 1
    local_dynamic_tls_mode =  2
    initial_exec_tls_model = 3
    local_exec_tls_model = 4
end

# (Not documented)
# 
# <em>This entry is only for documentation and no real method. The FFI::Enum can be accessed via #enum_type(:atomic_ordering).</em>
# 
# === Options:
# :not_atomic ::
#   
# :unordered ::
#   < A load or store which is not atomic
# :monotonic ::
#   < Lowest level of atomicity, guarantees
#                                        somewhat sane results, lock free.
# :acquire ::
#   < guarantees that if you take all the
#                                        operations affecting a specific address,
#                                        a consistent ordering exists
# :release ::
#   < Acquire provides a barrier of the sort
#                                      necessary to acquire a lock to access other
#                                      memory with normal loads and stores.
# :acquire_release ::
#   < Release is similar to Acquire, but with
#                                      a barrier of the sort necessary to release
#                                      a lock.
# 
# @method _enum_atomic_ordering_
# @return [Symbol]
# @scope class
baremodule AtomicOrderingEnum
    not_atomic = 0
    unordered = 1
    monotonic = 2
    acquire = 4
    release = 5
    acquire_release = 6
end

# (Not documented)
# 
# <em>This entry is only for documentation and no real method. The FFI::Enum can be accessed via #enum_type(:atomic_rmw_bin_op).</em>
# 
# === Options:
# :xchg ::
#   
# :add ::
#   < Set the new value and return the one old
# :sub ::
#   < Add a value and return the old one
# :and_ ::
#   < Subtract a value and return the old one
# :nand ::
#   < And a value and return the old one
# :or_ ::
#   < Not-And a value and return the old one
# :xor ::
#   < OR a value and return the old one
# :max ::
#   < Xor a value and return the old one
# :min ::
#   < Sets the value if it's greater than the
#                                original using a signed comparison and return
#                                the old one
# :u_max ::
#   < Sets the value if it's Smaller than the
#                                original using a signed comparison and return
#                                the old one
# :u_min ::
#   < Sets the value if it's greater than the
#                                original using an unsigned comparison and return
#                                the old one
# 
# @method _enum_atomic_rmw_bin_op_
# @return [Symbol]
# @scope class
baremodule AtomicRMWBinOpEnum
    xchg = 0
    add = 1
    sub = 2
    and = 3
    nand = 4
    or = 5
    xor = 6
    max = 7
    min = 8
    u_max = 9
    u_min = 10
end
