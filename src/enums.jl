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

baremodule Opcode
    # Terminator instructions
    const ret = 1
    const br = 2
    const switch = 3
    const indirectbr = 4
    const invoke = 5
    const unreachable = 7

    # Standard binary operators
    const add = 8
    const fadd = 9
    const sub = 10
    const fsub = 11
    const mul = 12
    const fmul = 13
    const udiv = 14
    const sdiv = 15
    const fdiv = 16
    const urem = 17
    const srem = 18
    const frem = 19

    # Logical operators
    const shl = 20
    const lshr = 21
    const ashr = 22
    const and = 23
    const or = 24
    const xor = 25

    # Memory operators
    const alloca = 26
    const load  = 27
    const store = 28
    const get_element_ptr = 29

    # Cast operators
    const trunc = 30
    const zext = 31
    const sext = 32
    const fptoui = 33
    const fptosi = 34
    const uitofp = 35
    const sitofp = 36
    const fptrunc = 37
    const fpext = 38
    const ptrtoint = 39
    const inttoptr = 40
    const bitcast = 41
    const addrspacecast = 60

    # Other operators 
    const icmp = 42
    const fcmp = 43
    const phi = 44
    const call = 45
    const select = 46
    const userop1 = 47
    const userop2 = 48
    const vaarg = 49
    const extract_elem = 50
    const insert_elem = 51
    const shuffle_vector = 52
    const extract_value = 53
    const insert_value = 54

    # Atomic operators
    const fence = 55
    const atomic_cmpxchg = 56
    const atomic_rmw = 57

    # Exception handling operators
    const resume = 58
    const landingpad = 59
end

baremodule IntPred
    const eq  = 32 # equal
    const ne  = 33 # not equal
    const ugt = 34 # unsigned greater than 
    const uge = 35 # unsigned greater than or equal
    const ult = 36 # unsinged less than
    const ule = 37 # unsigned less than or equal
    const sgt = 38 # signed greater than
    const sge = 39 # signed greater than or equal
    const slt = 40 # signed less than
    const sle = 41 # signed less than or equal
end

baremodule RealPred
    const predicate_false =  0  # Always false (always folded)
    const oeq =  1    # True if ordered and equal
    const ogt =  2    # True if ordered and greater than     
    const oge =  3    # True if ordered and greater than or equal
    const olt =  4    # True if ordered and less than
    const ole =  5    # True if ordered and less than or equal
    const one =  6    # True if ordered and operands are unequal
    const ord =  7    # True if ordered (no nans)
    const uno =  8    # True if unordered: isnan(X) | isnan(Y)
    const ueq =  9    # True if unordered or equal
    const ugt = 10    # True if unordered or greater than
    const uge = 11    # True if unordered, greater than, or equal
    const ult = 12    # True if unordered or less than
    const ule = 13    # True if unordered, less than, or equal
    const une = 14    # True if unordered or not equal
    const predicate_true = 15 # Always true (never folded)
end

baremodule CallingCov
    const c = 0
    const fast = 8
    const cold = 9
    const web_kit_js = 12
    const any_reg = 13
    const x86_stdcall = 64
    const x86_fastcall = 65
end

baremodule Attribute
    const z_ext = 1
    const s_ext = 2
    const no_return = 4
    const in_reg = 8
    const struct_ret = 16
    const no_unwind = 32
    const no_alias = 64
    const by_val = 128
    const nest = 256
    const read_none = 512
    const read_only = 1024
    const no_inline = 2048
    const always_inline = 4096
    const optimize_for_size = 8192
    const stack_protect = 16384
    const stack_protect_req = 32768
    const alignment = 2031616
    const no_capture = 2097152
    const no_red_zone = 4194304
    const no_implicit_float = 8388608
    const naked = 16777216
    const inline_hint = 33554432
    const stack_alignment = 469762048
    const returns_twice = 536870912
    const uw_table = 1073741824
end
