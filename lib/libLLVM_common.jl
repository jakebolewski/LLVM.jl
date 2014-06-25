# Skipping MacroDefinition: LLVM_FOR_EACH_VALUE_SUBCLASS ( macro ) macro ( Argument ) macro ( BasicBlock ) macro ( InlineAsm ) macro ( MDNode ) macro ( MDString ) macro ( User ) macro ( Constant ) macro ( BlockAddress ) macro ( ConstantAggregateZero ) macro ( ConstantArray ) macro ( ConstantExpr ) macro ( ConstantFP ) macro ( ConstantInt ) macro ( ConstantPointerNull ) macro ( ConstantStruct ) macro ( ConstantVector ) macro ( GlobalValue ) macro ( Function ) macro ( GlobalAlias ) macro ( GlobalVariable ) macro ( UndefValue ) macro ( Instruction ) macro ( BinaryOperator ) macro ( CallInst ) macro ( IntrinsicInst ) macro ( DbgInfoIntrinsic ) macro ( DbgDeclareInst ) macro ( MemIntrinsic ) macro ( MemCpyInst ) macro ( MemMoveInst ) macro ( MemSetInst ) macro ( CmpInst ) macro ( FCmpInst ) macro ( ICmpInst ) macro ( ExtractElementInst ) macro ( GetElementPtrInst ) macro ( InsertElementInst ) macro ( InsertValueInst ) macro ( LandingPadInst ) macro ( PHINode ) macro ( SelectInst ) macro ( ShuffleVectorInst ) macro ( StoreInst ) macro ( TerminatorInst ) macro ( BranchInst ) macro ( IndirectBrInst ) macro ( InvokeInst ) macro ( ReturnInst ) macro ( SwitchInst ) macro ( UnreachableInst ) macro ( ResumeInst ) macro ( UnaryInstruction ) macro ( AllocaInst ) macro ( CastInst ) macro ( BitCastInst ) macro ( FPExtInst ) macro ( FPToSIInst ) macro ( FPToUIInst ) macro ( FPTruncInst ) macro ( IntToPtrInst ) macro ( PtrToIntInst ) macro ( SExtInst ) macro ( SIToFPInst ) macro ( TruncInst ) macro ( UIToFPInst ) macro ( ZExtInst ) macro ( ExtractValueInst ) macro ( LoadInst ) macro ( VAArgInst )
# Skipping MacroDefinition: LLVM_DECLARE_VALUE_CAST ( name ) LLVMValueRef LLVMIsA ## name ( LLVMValueRef Val ) ;
typealias LLVMBool Cint
type LLVMOpaqueContext
end
typealias LLVMContextRef Ptr{LLVMOpaqueContext}
type LLVMOpaqueModule
end
typealias LLVMModuleRef Ptr{LLVMOpaqueModule}
type LLVMOpaqueType
end
typealias LLVMTypeRef Ptr{LLVMOpaqueType}
type LLVMOpaqueValue
end
typealias LLVMValueRef Ptr{LLVMOpaqueValue}
type LLVMOpaqueBasicBlock
end
typealias LLVMBasicBlockRef Ptr{LLVMOpaqueBasicBlock}
type LLVMOpaqueBuilder
end
typealias LLVMBuilderRef Ptr{LLVMOpaqueBuilder}
type LLVMOpaqueModuleProvider
end
typealias LLVMModuleProviderRef Ptr{LLVMOpaqueModuleProvider}
type LLVMOpaqueMemoryBuffer
end
typealias LLVMMemoryBufferRef Ptr{LLVMOpaqueMemoryBuffer}
type LLVMOpaquePassManager
end
typealias LLVMPassManagerRef Ptr{LLVMOpaquePassManager}
type LLVMOpaquePassRegistry
end
typealias LLVMPassRegistryRef Ptr{LLVMOpaquePassRegistry}
type LLVMOpaqueUse
end
typealias LLVMUseRef Ptr{LLVMOpaqueUse}
# begin enum ANONYMOUS_1
typealias ANONYMOUS_1 Cint
const LLVMZExtAttribute = int32(1)
const LLVMSExtAttribute = int32(2)
const LLVMNoReturnAttribute = int32(4)
const LLVMInRegAttribute = int32(8)
const LLVMStructRetAttribute = int32(16)
const LLVMNoUnwindAttribute = int32(32)
const LLVMNoAliasAttribute = int32(64)
const LLVMByValAttribute = int32(128)
const LLVMNestAttribute = int32(256)
const LLVMReadNoneAttribute = int32(512)
const LLVMReadOnlyAttribute = int32(1024)
const LLVMNoInlineAttribute = int32(2048)
const LLVMAlwaysInlineAttribute = int32(4096)
const LLVMOptimizeForSizeAttribute = int32(8192)
const LLVMStackProtectAttribute = int32(16384)
const LLVMStackProtectReqAttribute = int32(32768)
const LLVMAlignment = int32(2031616)
const LLVMNoCaptureAttribute = int32(2097152)
const LLVMNoRedZoneAttribute = int32(4194304)
const LLVMNoImplicitFloatAttribute = int32(8388608)
const LLVMNakedAttribute = int32(16777216)
const LLVMInlineHintAttribute = int32(33554432)
const LLVMStackAlignment = int32(469762048)
const LLVMReturnsTwice = int32(536870912)
const LLVMUWTable = int32(1073741824)
const LLVMNonLazyBind = int32(-2147483648)
# end enum ANONYMOUS_1
# begin enum LLVMAttribute
typealias LLVMAttribute Cint
const LLVMZExtAttribute = int32(1)
const LLVMSExtAttribute = int32(2)
const LLVMNoReturnAttribute = int32(4)
const LLVMInRegAttribute = int32(8)
const LLVMStructRetAttribute = int32(16)
const LLVMNoUnwindAttribute = int32(32)
const LLVMNoAliasAttribute = int32(64)
const LLVMByValAttribute = int32(128)
const LLVMNestAttribute = int32(256)
const LLVMReadNoneAttribute = int32(512)
const LLVMReadOnlyAttribute = int32(1024)
const LLVMNoInlineAttribute = int32(2048)
const LLVMAlwaysInlineAttribute = int32(4096)
const LLVMOptimizeForSizeAttribute = int32(8192)
const LLVMStackProtectAttribute = int32(16384)
const LLVMStackProtectReqAttribute = int32(32768)
const LLVMAlignment = int32(2031616)
const LLVMNoCaptureAttribute = int32(2097152)
const LLVMNoRedZoneAttribute = int32(4194304)
const LLVMNoImplicitFloatAttribute = int32(8388608)
const LLVMNakedAttribute = int32(16777216)
const LLVMInlineHintAttribute = int32(33554432)
const LLVMStackAlignment = int32(469762048)
const LLVMReturnsTwice = int32(536870912)
const LLVMUWTable = int32(1073741824)
const LLVMNonLazyBind = int32(-2147483648)
# end enum LLVMAttribute
# begin enum LLVMOpcode
typealias LLVMOpcode Uint32
const LLVMRet = uint32(1)
const LLVMBr = uint32(2)
const LLVMSwitch = uint32(3)
const LLVMIndirectBr = uint32(4)
const LLVMInvoke = uint32(5)
const LLVMUnreachable = uint32(7)
const LLVMAdd = uint32(8)
const LLVMFAdd = uint32(9)
const LLVMSub = uint32(10)
const LLVMFSub = uint32(11)
const LLVMMul = uint32(12)
const LLVMFMul = uint32(13)
const LLVMUDiv = uint32(14)
const LLVMSDiv = uint32(15)
const LLVMFDiv = uint32(16)
const LLVMURem = uint32(17)
const LLVMSRem = uint32(18)
const LLVMFRem = uint32(19)
const LLVMShl = uint32(20)
const LLVMLShr = uint32(21)
const LLVMAShr = uint32(22)
const LLVMAnd = uint32(23)
const LLVMOr = uint32(24)
const LLVMXor = uint32(25)
const LLVMAlloca = uint32(26)
const LLVMLoad = uint32(27)
const LLVMStore = uint32(28)
const LLVMGetElementPtr = uint32(29)
const LLVMTrunc = uint32(30)
const LLVMZExt = uint32(31)
const LLVMSExt = uint32(32)
const LLVMFPToUI = uint32(33)
const LLVMFPToSI = uint32(34)
const LLVMUIToFP = uint32(35)
const LLVMSIToFP = uint32(36)
const LLVMFPTrunc = uint32(37)
const LLVMFPExt = uint32(38)
const LLVMPtrToInt = uint32(39)
const LLVMIntToPtr = uint32(40)
const LLVMBitCast = uint32(41)
const LLVMICmp = uint32(42)
const LLVMFCmp = uint32(43)
const LLVMPHI = uint32(44)
const LLVMCall = uint32(45)
const LLVMSelect = uint32(46)
const LLVMUserOp1 = uint32(47)
const LLVMUserOp2 = uint32(48)
const LLVMVAArg = uint32(49)
const LLVMExtractElement = uint32(50)
const LLVMInsertElement = uint32(51)
const LLVMShuffleVector = uint32(52)
const LLVMExtractValue = uint32(53)
const LLVMInsertValue = uint32(54)
const LLVMFence = uint32(55)
const LLVMAtomicCmpXchg = uint32(56)
const LLVMAtomicRMW = uint32(57)
const LLVMResume = uint32(58)
const LLVMLandingPad = uint32(59)
# end enum LLVMOpcode
# begin enum LLVMTypeKind
typealias LLVMTypeKind Uint32
const LLVMVoidTypeKind = uint32(0)
const LLVMHalfTypeKind = uint32(1)
const LLVMFloatTypeKind = uint32(2)
const LLVMDoubleTypeKind = uint32(3)
const LLVMX86_FP80TypeKind = uint32(4)
const LLVMFP128TypeKind = uint32(5)
const LLVMPPC_FP128TypeKind = uint32(6)
const LLVMLabelTypeKind = uint32(7)
const LLVMIntegerTypeKind = uint32(8)
const LLVMFunctionTypeKind = uint32(9)
const LLVMStructTypeKind = uint32(10)
const LLVMArrayTypeKind = uint32(11)
const LLVMPointerTypeKind = uint32(12)
const LLVMVectorTypeKind = uint32(13)
const LLVMMetadataTypeKind = uint32(14)
const LLVMX86_MMXTypeKind = uint32(15)
# end enum LLVMTypeKind
# begin enum LLVMLinkage
typealias LLVMLinkage Uint32
const LLVMExternalLinkage = uint32(0)
const LLVMAvailableExternallyLinkage = uint32(1)
const LLVMLinkOnceAnyLinkage = uint32(2)
const LLVMLinkOnceODRLinkage = uint32(3)
const LLVMLinkOnceODRAutoHideLinkage = uint32(4)
const LLVMWeakAnyLinkage = uint32(5)
const LLVMWeakODRLinkage = uint32(6)
const LLVMAppendingLinkage = uint32(7)
const LLVMInternalLinkage = uint32(8)
const LLVMPrivateLinkage = uint32(9)
const LLVMDLLImportLinkage = uint32(10)
const LLVMDLLExportLinkage = uint32(11)
const LLVMExternalWeakLinkage = uint32(12)
const LLVMGhostLinkage = uint32(13)
const LLVMCommonLinkage = uint32(14)
const LLVMLinkerPrivateLinkage = uint32(15)
const LLVMLinkerPrivateWeakLinkage = uint32(16)
# end enum LLVMLinkage
# begin enum LLVMVisibility
typealias LLVMVisibility Uint32
const LLVMDefaultVisibility = uint32(0)
const LLVMHiddenVisibility = uint32(1)
const LLVMProtectedVisibility = uint32(2)
# end enum LLVMVisibility
# begin enum LLVMCallConv
typealias LLVMCallConv Uint32
const LLVMCCallConv = uint32(0)
const LLVMFastCallConv = uint32(8)
const LLVMColdCallConv = uint32(9)
const LLVMX86StdcallCallConv = uint32(64)
const LLVMX86FastcallCallConv = uint32(65)
# end enum LLVMCallConv
# begin enum LLVMIntPredicate
typealias LLVMIntPredicate Uint32
const LLVMIntEQ = uint32(32)
const LLVMIntNE = uint32(33)
const LLVMIntUGT = uint32(34)
const LLVMIntUGE = uint32(35)
const LLVMIntULT = uint32(36)
const LLVMIntULE = uint32(37)
const LLVMIntSGT = uint32(38)
const LLVMIntSGE = uint32(39)
const LLVMIntSLT = uint32(40)
const LLVMIntSLE = uint32(41)
# end enum LLVMIntPredicate
# begin enum LLVMRealPredicate
typealias LLVMRealPredicate Uint32
const LLVMRealPredicateFalse = uint32(0)
const LLVMRealOEQ = uint32(1)
const LLVMRealOGT = uint32(2)
const LLVMRealOGE = uint32(3)
const LLVMRealOLT = uint32(4)
const LLVMRealOLE = uint32(5)
const LLVMRealONE = uint32(6)
const LLVMRealORD = uint32(7)
const LLVMRealUNO = uint32(8)
const LLVMRealUEQ = uint32(9)
const LLVMRealUGT = uint32(10)
const LLVMRealUGE = uint32(11)
const LLVMRealULT = uint32(12)
const LLVMRealULE = uint32(13)
const LLVMRealUNE = uint32(14)
const LLVMRealPredicateTrue = uint32(15)
# end enum LLVMRealPredicate
# begin enum LLVMLandingPadClauseTy
typealias LLVMLandingPadClauseTy Uint32
const LLVMLandingPadCatch = uint32(0)
const LLVMLandingPadFilter = uint32(1)
# end enum LLVMLandingPadClauseTy
# begin enum LLVMThreadLocalMode
typealias LLVMThreadLocalMode Uint32
const LLVMNotThreadLocal = uint32(0)
const LLVMGeneralDynamicTLSModel = uint32(1)
const LLVMLocalDynamicTLSModel = uint32(2)
const LLVMInitialExecTLSModel = uint32(3)
const LLVMLocalExecTLSModel = uint32(4)
# end enum LLVMThreadLocalMode
# begin enum LLVMAtomicOrdering
typealias LLVMAtomicOrdering Uint32
const LLVMAtomicOrderingNotAtomic = uint32(0)
const LLVMAtomicOrderingUnordered = uint32(1)
const LLVMAtomicOrderingMonotonic = uint32(2)
const LLVMAtomicOrderingAcquire = uint32(4)
const LLVMAtomicOrderingRelease = uint32(5)
const LLVMAtomicOrderingAcquireRelease = uint32(6)
const LLVMAtomicOrderingSequentiallyConsistent = uint32(7)
# end enum LLVMAtomicOrdering
# begin enum LLVMAtomicRMWBinOp
typealias LLVMAtomicRMWBinOp Uint32
const LLVMAtomicRMWBinOpXchg = uint32(0)
const LLVMAtomicRMWBinOpAdd = uint32(1)
const LLVMAtomicRMWBinOpSub = uint32(2)
const LLVMAtomicRMWBinOpAnd = uint32(3)
const LLVMAtomicRMWBinOpNand = uint32(4)
const LLVMAtomicRMWBinOpOr = uint32(5)
const LLVMAtomicRMWBinOpXor = uint32(6)
const LLVMAtomicRMWBinOpMax = uint32(7)
const LLVMAtomicRMWBinOpMin = uint32(8)
const LLVMAtomicRMWBinOpUMax = uint32(9)
const LLVMAtomicRMWBinOpUMin = uint32(10)
# end enum LLVMAtomicRMWBinOp
# Skipping MacroDefinition: LLVM_TARGET ( TargetName ) void LLVMInitialize ## TargetName ## TargetInfo ( void ) ;
# Skipping MacroDefinition: LLVM_ASM_PRINTER ( TargetName ) void LLVMInitialize ## TargetName ## AsmPrinter ( void ) ;
# Skipping MacroDefinition: LLVM_ASM_PARSER ( TargetName ) void LLVMInitialize ## TargetName ## AsmParser ( void ) ;
# Skipping MacroDefinition: LLVM_DISASSEMBLER ( TargetName ) void LLVMInitialize ## TargetName ## Disassembler ( void ) ;
# begin enum LLVMByteOrdering
typealias LLVMByteOrdering Uint32
const LLVMBigEndian = uint32(0)
const LLVMLittleEndian = uint32(1)
# end enum LLVMByteOrdering
type LLVMOpaqueTargetData
end
typealias LLVMTargetDataRef Ptr{LLVMOpaqueTargetData}
type LLVMOpaqueTargetLibraryInfotData
end
typealias LLVMTargetLibraryInfoRef Ptr{LLVMOpaqueTargetLibraryInfotData}
type LLVMStructLayout
end
typealias LLVMStructLayoutRef Ptr{LLVMStructLayout}
type LLVMOpaqueTargetMachine
end
typealias LLVMTargetMachineRef Ptr{LLVMOpaqueTargetMachine}
type LLVMTarget
end
typealias LLVMTargetRef Ptr{LLVMTarget}
# begin enum LLVMCodeGenOptLevel
typealias LLVMCodeGenOptLevel Uint32
const LLVMCodeGenLevelNone = uint32(0)
const LLVMCodeGenLevelLess = uint32(1)
const LLVMCodeGenLevelDefault = uint32(2)
const LLVMCodeGenLevelAggressive = uint32(3)
# end enum LLVMCodeGenOptLevel
# begin enum LLVMRelocMode
typealias LLVMRelocMode Uint32
const LLVMRelocDefault = uint32(0)
const LLVMRelocStatic = uint32(1)
const LLVMRelocPIC = uint32(2)
const LLVMRelocDynamicNoPic = uint32(3)
# end enum LLVMRelocMode
# begin enum LLVMCodeModel
typealias LLVMCodeModel Uint32
const LLVMCodeModelDefault = uint32(0)
const LLVMCodeModelJITDefault = uint32(1)
const LLVMCodeModelSmall = uint32(2)
const LLVMCodeModelKernel = uint32(3)
const LLVMCodeModelMedium = uint32(4)
const LLVMCodeModelLarge = uint32(5)
# end enum LLVMCodeModel
# begin enum LLVMCodeGenFileType
typealias LLVMCodeGenFileType Uint32
const LLVMAssemblyFile = uint32(0)
const LLVMObjectFile = uint32(1)
# end enum LLVMCodeGenFileType
# begin enum LLVMVerifierFailureAction
typealias LLVMVerifierFailureAction Uint32
const LLVMAbortProcessAction = uint32(0)
const LLVMPrintMessageAction = uint32(1)
const LLVMReturnStatusAction = uint32(2)
# end enum LLVMVerifierFailureAction
# begin enum LLVMLinkerMode
typealias LLVMLinkerMode Uint32
const LLVMLinkerDestroySource = uint32(0)
const LLVMLinkerPreserveSource = uint32(1)
# end enum LLVMLinkerMode
typealias llvm_lto_t Ptr{Void}
# begin enum llvm_lto_status
typealias llvm_lto_status Uint32
const LLVM_LTO_UNKNOWN = uint32(0)
const LLVM_LTO_OPT_SUCCESS = uint32(1)
const LLVM_LTO_READ_SUCCESS = uint32(2)
const LLVM_LTO_READ_FAILURE = uint32(3)
const LLVM_LTO_WRITE_FAILURE = uint32(4)
const LLVM_LTO_NO_TARGET = uint32(5)
const LLVM_LTO_NO_WORK = uint32(6)
const LLVM_LTO_MODULE_MERGE_FAILURE = uint32(7)
const LLVM_LTO_ASM_FAILURE = uint32(8)
const LLVM_LTO_NULL_OBJECT = uint32(9)
# end enum llvm_lto_status
# begin enum llvm_lto_status_t
typealias llvm_lto_status_t Uint32
const LLVM_LTO_UNKNOWN = uint32(0)
const LLVM_LTO_OPT_SUCCESS = uint32(1)
const LLVM_LTO_READ_SUCCESS = uint32(2)
const LLVM_LTO_READ_FAILURE = uint32(3)
const LLVM_LTO_WRITE_FAILURE = uint32(4)
const LLVM_LTO_NO_TARGET = uint32(5)
const LLVM_LTO_NO_WORK = uint32(6)
const LLVM_LTO_MODULE_MERGE_FAILURE = uint32(7)
const LLVM_LTO_ASM_FAILURE = uint32(8)
const LLVM_LTO_NULL_OBJECT = uint32(9)
# end enum llvm_lto_status_t
type LLVMOpaqueObjectFile
end
typealias LLVMObjectFileRef Ptr{LLVMOpaqueObjectFile}
type LLVMOpaqueSectionIterator
end
typealias LLVMSectionIteratorRef Ptr{LLVMOpaqueSectionIterator}
type LLVMOpaqueSymbolIterator
end
typealias LLVMSymbolIteratorRef Ptr{LLVMOpaqueSymbolIterator}
type LLVMOpaqueRelocationIterator
end
typealias LLVMRelocationIteratorRef Ptr{LLVMOpaqueRelocationIterator}
type LLVMOpaqueGenericValue
end
typealias LLVMGenericValueRef Ptr{LLVMOpaqueGenericValue}
type LLVMOpaqueExecutionEngine
end
typealias LLVMExecutionEngineRef Ptr{LLVMOpaqueExecutionEngine}
type LLVMMCJITCompilerOptions
    OptLevel::Uint32
    CodeModel::LLVMCodeModel
    NoFramePointerElim::LLVMBool
    EnableFastISel::LLVMBool
end
const LLVMDisassembler_VariantKind_None = 0
const LLVMDisassembler_VariantKind_ARM_HI16 = 1
const LLVMDisassembler_VariantKind_ARM_LO16 = 2
const LLVMDisassembler_ReferenceType_InOut_None = 0
const LLVMDisassembler_ReferenceType_In_Branch = 1
const LLVMDisassembler_ReferenceType_In_PCrel_Load = 2
const LLVMDisassembler_ReferenceType_Out_SymbolStub = 1
const LLVMDisassembler_ReferenceType_Out_LitPool_SymAddr = 2
const LLVMDisassembler_ReferenceType_Out_LitPool_CstrAddr = 3
const LLVMDisassembler_Option_UseMarkup = 1
const LLVMDisassembler_Option_PrintImmHex = 2
const LLVMDisassembler_Option_AsmPrinterVariant = 4
typealias LLVMDisasmContextRef Ptr{Void}
typealias LLVMOpInfoCallback Ptr{Void}
type LLVMOpInfoSymbol1
    Present::Uint64
    Name::Ptr{Uint8}
    Value::Uint64
end
type LLVMOpInfo1
    AddSymbol::LLVMOpInfoSymbol1
    SubtractSymbol::LLVMOpInfoSymbol1
    Value::Uint64
    VariantKind::Uint64
end
typealias LLVMSymbolLookupCallback Ptr{Void}
type LLVMOpaquePassManagerBuilder
end
typealias LLVMPassManagerBuilderRef Ptr{LLVMOpaquePassManagerBuilder}
