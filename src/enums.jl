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
