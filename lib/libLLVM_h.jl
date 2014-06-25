# Julia wrapper for header: /cmn/jldev/deps/llvm-svn/include/llvm-c/Core.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function LLVMLoadLibraryPermanently(Filename::Ptr{Uint8})
    ccall((:LLVMLoadLibraryPermanently,libllvm),LLVMBool,(Ptr{Uint8},),Filename)
end
function LLVMInitializeCore(R::LLVMPassRegistryRef)
    ccall((:LLVMInitializeCore,libllvm),Void,(LLVMPassRegistryRef,),R)
end
function LLVMShutdown()
    ccall((:LLVMShutdown,libllvm),Void,())
end
function LLVMCreateMessage(Message::Ptr{Uint8})
    ccall((:LLVMCreateMessage,libllvm),Ptr{Uint8},(Ptr{Uint8},),Message)
end
function LLVMDisposeMessage(Message::Ptr{Uint8})
    ccall((:LLVMDisposeMessage,libllvm),Void,(Ptr{Uint8},),Message)
end
function LLVMInstallFatalErrorHandler(Handler::LLVMFatalErrorHandler)
    ccall((:LLVMInstallFatalErrorHandler,libllvm),Void,(LLVMFatalErrorHandler,),Handler)
end
function LLVMResetFatalErrorHandler()
    ccall((:LLVMResetFatalErrorHandler,libllvm),Void,())
end
function LLVMEnablePrettyStackTrace()
    ccall((:LLVMEnablePrettyStackTrace,libllvm),Void,())
end
function LLVMContextCreate()
    ccall((:LLVMContextCreate,libllvm),LLVMContextRef,())
end
function LLVMGetGlobalContext()
    ccall((:LLVMGetGlobalContext,libllvm),LLVMContextRef,())
end
function LLVMContextSetDiagnosticHandler(C::LLVMContextRef,Handler::LLVMDiagnosticHandler,DiagnosticContext::Ptr{Void})
    ccall((:LLVMContextSetDiagnosticHandler,libllvm),Void,(LLVMContextRef,LLVMDiagnosticHandler,Ptr{Void}),C,Handler,DiagnosticContext)
end
function LLVMContextSetYieldCallback(C::LLVMContextRef,Callback::LLVMYieldCallback,OpaqueHandle::Ptr{Void})
    ccall((:LLVMContextSetYieldCallback,libllvm),Void,(LLVMContextRef,LLVMYieldCallback,Ptr{Void}),C,Callback,OpaqueHandle)
end
function LLVMContextDispose(C::LLVMContextRef)
    ccall((:LLVMContextDispose,libllvm),Void,(LLVMContextRef,),C)
end
function LLVMGetDiagInfoDescription(DI::LLVMDiagnosticInfoRef)
    ccall((:LLVMGetDiagInfoDescription,libllvm),Ptr{Uint8},(LLVMDiagnosticInfoRef,),DI)
end
function LLVMGetDiagInfoSeverity(DI::LLVMDiagnosticInfoRef)
    ccall((:LLVMGetDiagInfoSeverity,libllvm),LLVMDiagnosticSeverity,(LLVMDiagnosticInfoRef,),DI)
end
function LLVMGetMDKindIDInContext(C::LLVMContextRef,Name::Ptr{Uint8},SLen::Uint32)
    ccall((:LLVMGetMDKindIDInContext,libllvm),Uint32,(LLVMContextRef,Ptr{Uint8},Uint32),C,Name,SLen)
end
function LLVMGetMDKindID(Name::Ptr{Uint8},SLen::Uint32)
    ccall((:LLVMGetMDKindID,libllvm),Uint32,(Ptr{Uint8},Uint32),Name,SLen)
end
function LLVMModuleCreateWithName(ModuleID::Ptr{Uint8})
    ccall((:LLVMModuleCreateWithName,libllvm),LLVMModuleRef,(Ptr{Uint8},),ModuleID)
end
function LLVMModuleCreateWithNameInContext(ModuleID::Ptr{Uint8},C::LLVMContextRef)
    ccall((:LLVMModuleCreateWithNameInContext,libllvm),LLVMModuleRef,(Ptr{Uint8},LLVMContextRef),ModuleID,C)
end
function LLVMDisposeModule(M::LLVMModuleRef)
    ccall((:LLVMDisposeModule,libllvm),Void,(LLVMModuleRef,),M)
end
function LLVMGetDataLayout(M::LLVMModuleRef)
    ccall((:LLVMGetDataLayout,libllvm),Ptr{Uint8},(LLVMModuleRef,),M)
end
function LLVMSetDataLayout(M::LLVMModuleRef,Triple::Ptr{Uint8})
    ccall((:LLVMSetDataLayout,libllvm),Void,(LLVMModuleRef,Ptr{Uint8}),M,Triple)
end
function LLVMGetTarget(M::LLVMModuleRef)
    ccall((:LLVMGetTarget,libllvm),Ptr{Uint8},(LLVMModuleRef,),M)
end
function LLVMSetTarget(M::LLVMModuleRef,Triple::Ptr{Uint8})
    ccall((:LLVMSetTarget,libllvm),Void,(LLVMModuleRef,Ptr{Uint8}),M,Triple)
end
function LLVMDumpModule(M::LLVMModuleRef)
    ccall((:LLVMDumpModule,libllvm),Void,(LLVMModuleRef,),M)
end
function LLVMPrintModuleToFile(M::LLVMModuleRef,Filename::Ptr{Uint8},ErrorMessage::Ptr{Ptr{Uint8}})
    ccall((:LLVMPrintModuleToFile,libllvm),LLVMBool,(LLVMModuleRef,Ptr{Uint8},Ptr{Ptr{Uint8}}),M,Filename,ErrorMessage)
end
function LLVMPrintModuleToString(M::LLVMModuleRef)
    ccall((:LLVMPrintModuleToString,libllvm),Ptr{Uint8},(LLVMModuleRef,),M)
end
function LLVMSetModuleInlineAsm(M::LLVMModuleRef,Asm::Ptr{Uint8})
    ccall((:LLVMSetModuleInlineAsm,libllvm),Void,(LLVMModuleRef,Ptr{Uint8}),M,Asm)
end
function LLVMGetModuleContext(M::LLVMModuleRef)
    ccall((:LLVMGetModuleContext,libllvm),LLVMContextRef,(LLVMModuleRef,),M)
end
function LLVMGetTypeByName(M::LLVMModuleRef,Name::Ptr{Uint8})
    ccall((:LLVMGetTypeByName,libllvm),LLVMTypeRef,(LLVMModuleRef,Ptr{Uint8}),M,Name)
end
function LLVMGetNamedMetadataNumOperands(M::LLVMModuleRef,name::Ptr{Uint8})
    ccall((:LLVMGetNamedMetadataNumOperands,libllvm),Uint32,(LLVMModuleRef,Ptr{Uint8}),M,name)
end
function LLVMGetNamedMetadataOperands(M::LLVMModuleRef,name::Ptr{Uint8},Dest::Ptr{LLVMValueRef})
    ccall((:LLVMGetNamedMetadataOperands,libllvm),Void,(LLVMModuleRef,Ptr{Uint8},Ptr{LLVMValueRef}),M,name,Dest)
end
function LLVMAddNamedMetadataOperand(M::LLVMModuleRef,name::Ptr{Uint8},Val::LLVMValueRef)
    ccall((:LLVMAddNamedMetadataOperand,libllvm),Void,(LLVMModuleRef,Ptr{Uint8},LLVMValueRef),M,name,Val)
end
function LLVMAddFunction(M::LLVMModuleRef,Name::Ptr{Uint8},FunctionTy::LLVMTypeRef)
    ccall((:LLVMAddFunction,libllvm),LLVMValueRef,(LLVMModuleRef,Ptr{Uint8},LLVMTypeRef),M,Name,FunctionTy)
end
function LLVMGetNamedFunction(M::LLVMModuleRef,Name::Ptr{Uint8})
    ccall((:LLVMGetNamedFunction,libllvm),LLVMValueRef,(LLVMModuleRef,Ptr{Uint8}),M,Name)
end
function LLVMGetFirstFunction(M::LLVMModuleRef)
    ccall((:LLVMGetFirstFunction,libllvm),LLVMValueRef,(LLVMModuleRef,),M)
end
function LLVMGetLastFunction(M::LLVMModuleRef)
    ccall((:LLVMGetLastFunction,libllvm),LLVMValueRef,(LLVMModuleRef,),M)
end
function LLVMGetNextFunction(Fn::LLVMValueRef)
    ccall((:LLVMGetNextFunction,libllvm),LLVMValueRef,(LLVMValueRef,),Fn)
end
function LLVMGetPreviousFunction(Fn::LLVMValueRef)
    ccall((:LLVMGetPreviousFunction,libllvm),LLVMValueRef,(LLVMValueRef,),Fn)
end
function LLVMGetTypeKind(Ty::LLVMTypeRef)
    ccall((:LLVMGetTypeKind,libllvm),LLVMTypeKind,(LLVMTypeRef,),Ty)
end
function LLVMTypeIsSized(Ty::LLVMTypeRef)
    ccall((:LLVMTypeIsSized,libllvm),LLVMBool,(LLVMTypeRef,),Ty)
end
function LLVMGetTypeContext(Ty::LLVMTypeRef)
    ccall((:LLVMGetTypeContext,libllvm),LLVMContextRef,(LLVMTypeRef,),Ty)
end
function LLVMDumpType(Val::LLVMTypeRef)
    ccall((:LLVMDumpType,libllvm),Void,(LLVMTypeRef,),Val)
end
function LLVMPrintTypeToString(Val::LLVMTypeRef)
    ccall((:LLVMPrintTypeToString,libllvm),Ptr{Uint8},(LLVMTypeRef,),Val)
end
function LLVMInt1TypeInContext(C::LLVMContextRef)
    ccall((:LLVMInt1TypeInContext,libllvm),LLVMTypeRef,(LLVMContextRef,),C)
end
function LLVMInt8TypeInContext(C::LLVMContextRef)
    ccall((:LLVMInt8TypeInContext,libllvm),LLVMTypeRef,(LLVMContextRef,),C)
end
function LLVMInt16TypeInContext(C::LLVMContextRef)
    ccall((:LLVMInt16TypeInContext,libllvm),LLVMTypeRef,(LLVMContextRef,),C)
end
function LLVMInt32TypeInContext(C::LLVMContextRef)
    ccall((:LLVMInt32TypeInContext,libllvm),LLVMTypeRef,(LLVMContextRef,),C)
end
function LLVMInt64TypeInContext(C::LLVMContextRef)
    ccall((:LLVMInt64TypeInContext,libllvm),LLVMTypeRef,(LLVMContextRef,),C)
end
function LLVMIntTypeInContext(C::LLVMContextRef,NumBits::Uint32)
    ccall((:LLVMIntTypeInContext,libllvm),LLVMTypeRef,(LLVMContextRef,Uint32),C,NumBits)
end
function LLVMInt1Type()
    ccall((:LLVMInt1Type,libllvm),LLVMTypeRef,())
end
function LLVMInt8Type()
    ccall((:LLVMInt8Type,libllvm),LLVMTypeRef,())
end
function LLVMInt16Type()
    ccall((:LLVMInt16Type,libllvm),LLVMTypeRef,())
end
function LLVMInt32Type()
    ccall((:LLVMInt32Type,libllvm),LLVMTypeRef,())
end
function LLVMInt64Type()
    ccall((:LLVMInt64Type,libllvm),LLVMTypeRef,())
end
function LLVMIntType(NumBits::Uint32)
    ccall((:LLVMIntType,libllvm),LLVMTypeRef,(Uint32,),NumBits)
end
function LLVMGetIntTypeWidth(IntegerTy::LLVMTypeRef)
    ccall((:LLVMGetIntTypeWidth,libllvm),Uint32,(LLVMTypeRef,),IntegerTy)
end
function LLVMHalfTypeInContext(C::LLVMContextRef)
    ccall((:LLVMHalfTypeInContext,libllvm),LLVMTypeRef,(LLVMContextRef,),C)
end
function LLVMFloatTypeInContext(C::LLVMContextRef)
    ccall((:LLVMFloatTypeInContext,libllvm),LLVMTypeRef,(LLVMContextRef,),C)
end
function LLVMDoubleTypeInContext(C::LLVMContextRef)
    ccall((:LLVMDoubleTypeInContext,libllvm),LLVMTypeRef,(LLVMContextRef,),C)
end
function LLVMX86FP80TypeInContext(C::LLVMContextRef)
    ccall((:LLVMX86FP80TypeInContext,libllvm),LLVMTypeRef,(LLVMContextRef,),C)
end
function LLVMFP128TypeInContext(C::LLVMContextRef)
    ccall((:LLVMFP128TypeInContext,libllvm),LLVMTypeRef,(LLVMContextRef,),C)
end
function LLVMPPCFP128TypeInContext(C::LLVMContextRef)
    ccall((:LLVMPPCFP128TypeInContext,libllvm),LLVMTypeRef,(LLVMContextRef,),C)
end
function LLVMHalfType()
    ccall((:LLVMHalfType,libllvm),LLVMTypeRef,())
end
function LLVMFloatType()
    ccall((:LLVMFloatType,libllvm),LLVMTypeRef,())
end
function LLVMDoubleType()
    ccall((:LLVMDoubleType,libllvm),LLVMTypeRef,())
end
function LLVMX86FP80Type()
    ccall((:LLVMX86FP80Type,libllvm),LLVMTypeRef,())
end
function LLVMFP128Type()
    ccall((:LLVMFP128Type,libllvm),LLVMTypeRef,())
end
function LLVMPPCFP128Type()
    ccall((:LLVMPPCFP128Type,libllvm),LLVMTypeRef,())
end
function LLVMFunctionType(ReturnType::LLVMTypeRef,ParamTypes::Ptr{LLVMTypeRef},ParamCount::Uint32,IsVarArg::LLVMBool)
    ccall((:LLVMFunctionType,libllvm),LLVMTypeRef,(LLVMTypeRef,Ptr{LLVMTypeRef},Uint32,LLVMBool),ReturnType,ParamTypes,ParamCount,IsVarArg)
end
function LLVMIsFunctionVarArg(FunctionTy::LLVMTypeRef)
    ccall((:LLVMIsFunctionVarArg,libllvm),LLVMBool,(LLVMTypeRef,),FunctionTy)
end
function LLVMGetReturnType(FunctionTy::LLVMTypeRef)
    ccall((:LLVMGetReturnType,libllvm),LLVMTypeRef,(LLVMTypeRef,),FunctionTy)
end
function LLVMCountParamTypes(FunctionTy::LLVMTypeRef)
    ccall((:LLVMCountParamTypes,libllvm),Uint32,(LLVMTypeRef,),FunctionTy)
end
function LLVMGetParamTypes(FunctionTy::LLVMTypeRef,Dest::Ptr{LLVMTypeRef})
    ccall((:LLVMGetParamTypes,libllvm),Void,(LLVMTypeRef,Ptr{LLVMTypeRef}),FunctionTy,Dest)
end
function LLVMStructTypeInContext(C::LLVMContextRef,ElementTypes::Ptr{LLVMTypeRef},ElementCount::Uint32,Packed::LLVMBool)
    ccall((:LLVMStructTypeInContext,libllvm),LLVMTypeRef,(LLVMContextRef,Ptr{LLVMTypeRef},Uint32,LLVMBool),C,ElementTypes,ElementCount,Packed)
end
function LLVMStructType(ElementTypes::Ptr{LLVMTypeRef},ElementCount::Uint32,Packed::LLVMBool)
    ccall((:LLVMStructType,libllvm),LLVMTypeRef,(Ptr{LLVMTypeRef},Uint32,LLVMBool),ElementTypes,ElementCount,Packed)
end
function LLVMStructCreateNamed(C::LLVMContextRef,Name::Ptr{Uint8})
    ccall((:LLVMStructCreateNamed,libllvm),LLVMTypeRef,(LLVMContextRef,Ptr{Uint8}),C,Name)
end
function LLVMGetStructName(Ty::LLVMTypeRef)
    ccall((:LLVMGetStructName,libllvm),Ptr{Uint8},(LLVMTypeRef,),Ty)
end
function LLVMStructSetBody(StructTy::LLVMTypeRef,ElementTypes::Ptr{LLVMTypeRef},ElementCount::Uint32,Packed::LLVMBool)
    ccall((:LLVMStructSetBody,libllvm),Void,(LLVMTypeRef,Ptr{LLVMTypeRef},Uint32,LLVMBool),StructTy,ElementTypes,ElementCount,Packed)
end
function LLVMCountStructElementTypes(StructTy::LLVMTypeRef)
    ccall((:LLVMCountStructElementTypes,libllvm),Uint32,(LLVMTypeRef,),StructTy)
end
function LLVMGetStructElementTypes(StructTy::LLVMTypeRef,Dest::Ptr{LLVMTypeRef})
    ccall((:LLVMGetStructElementTypes,libllvm),Void,(LLVMTypeRef,Ptr{LLVMTypeRef}),StructTy,Dest)
end
function LLVMIsPackedStruct(StructTy::LLVMTypeRef)
    ccall((:LLVMIsPackedStruct,libllvm),LLVMBool,(LLVMTypeRef,),StructTy)
end
function LLVMIsOpaqueStruct(StructTy::LLVMTypeRef)
    ccall((:LLVMIsOpaqueStruct,libllvm),LLVMBool,(LLVMTypeRef,),StructTy)
end
function LLVMGetElementType(Ty::LLVMTypeRef)
    ccall((:LLVMGetElementType,libllvm),LLVMTypeRef,(LLVMTypeRef,),Ty)
end
function LLVMArrayType(ElementType::LLVMTypeRef,ElementCount::Uint32)
    ccall((:LLVMArrayType,libllvm),LLVMTypeRef,(LLVMTypeRef,Uint32),ElementType,ElementCount)
end
function LLVMGetArrayLength(ArrayTy::LLVMTypeRef)
    ccall((:LLVMGetArrayLength,libllvm),Uint32,(LLVMTypeRef,),ArrayTy)
end
function LLVMPointerType(ElementType::LLVMTypeRef,AddressSpace::Uint32)
    ccall((:LLVMPointerType,libllvm),LLVMTypeRef,(LLVMTypeRef,Uint32),ElementType,AddressSpace)
end
function LLVMGetPointerAddressSpace(PointerTy::LLVMTypeRef)
    ccall((:LLVMGetPointerAddressSpace,libllvm),Uint32,(LLVMTypeRef,),PointerTy)
end
function LLVMVectorType(ElementType::LLVMTypeRef,ElementCount::Uint32)
    ccall((:LLVMVectorType,libllvm),LLVMTypeRef,(LLVMTypeRef,Uint32),ElementType,ElementCount)
end
function LLVMGetVectorSize(VectorTy::LLVMTypeRef)
    ccall((:LLVMGetVectorSize,libllvm),Uint32,(LLVMTypeRef,),VectorTy)
end
function LLVMVoidTypeInContext(C::LLVMContextRef)
    ccall((:LLVMVoidTypeInContext,libllvm),LLVMTypeRef,(LLVMContextRef,),C)
end
function LLVMLabelTypeInContext(C::LLVMContextRef)
    ccall((:LLVMLabelTypeInContext,libllvm),LLVMTypeRef,(LLVMContextRef,),C)
end
function LLVMX86MMXTypeInContext(C::LLVMContextRef)
    ccall((:LLVMX86MMXTypeInContext,libllvm),LLVMTypeRef,(LLVMContextRef,),C)
end
function LLVMVoidType()
    ccall((:LLVMVoidType,libllvm),LLVMTypeRef,())
end
function LLVMLabelType()
    ccall((:LLVMLabelType,libllvm),LLVMTypeRef,())
end
function LLVMX86MMXType()
    ccall((:LLVMX86MMXType,libllvm),LLVMTypeRef,())
end
function LLVMTypeOf(Val::LLVMValueRef)
    ccall((:LLVMTypeOf,libllvm),LLVMTypeRef,(LLVMValueRef,),Val)
end
function LLVMGetValueName(Val::LLVMValueRef)
    ccall((:LLVMGetValueName,libllvm),Ptr{Uint8},(LLVMValueRef,),Val)
end
function LLVMSetValueName(Val::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMSetValueName,libllvm),Void,(LLVMValueRef,Ptr{Uint8}),Val,Name)
end
function LLVMDumpValue(Val::LLVMValueRef)
    ccall((:LLVMDumpValue,libllvm),Void,(LLVMValueRef,),Val)
end
function LLVMPrintValueToString(Val::LLVMValueRef)
    ccall((:LLVMPrintValueToString,libllvm),Ptr{Uint8},(LLVMValueRef,),Val)
end
function LLVMReplaceAllUsesWith(OldVal::LLVMValueRef,NewVal::LLVMValueRef)
    ccall((:LLVMReplaceAllUsesWith,libllvm),Void,(LLVMValueRef,LLVMValueRef),OldVal,NewVal)
end
function LLVMIsConstant(Val::LLVMValueRef)
    ccall((:LLVMIsConstant,libllvm),LLVMBool,(LLVMValueRef,),Val)
end
function LLVMIsUndef(Val::LLVMValueRef)
    ccall((:LLVMIsUndef,libllvm),LLVMBool,(LLVMValueRef,),Val)
end
function LLVMIsAArgument(Val::LLVMValueRef)
    ccall((:LLVMIsAArgument,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsABasicBlock(Val::LLVMValueRef)
    ccall((:LLVMIsABasicBlock,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAInlineAsm(Val::LLVMValueRef)
    ccall((:LLVMIsAInlineAsm,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAMDNode(Val::LLVMValueRef)
    ccall((:LLVMIsAMDNode,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAMDString(Val::LLVMValueRef)
    ccall((:LLVMIsAMDString,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAUser(Val::LLVMValueRef)
    ccall((:LLVMIsAUser,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAConstant(Val::LLVMValueRef)
    ccall((:LLVMIsAConstant,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsABlockAddress(Val::LLVMValueRef)
    ccall((:LLVMIsABlockAddress,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAConstantAggregateZero(Val::LLVMValueRef)
    ccall((:LLVMIsAConstantAggregateZero,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAConstantArray(Val::LLVMValueRef)
    ccall((:LLVMIsAConstantArray,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAConstantDataSequential(Val::LLVMValueRef)
    ccall((:LLVMIsAConstantDataSequential,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAConstantDataArray(Val::LLVMValueRef)
    ccall((:LLVMIsAConstantDataArray,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAConstantDataVector(Val::LLVMValueRef)
    ccall((:LLVMIsAConstantDataVector,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAConstantExpr(Val::LLVMValueRef)
    ccall((:LLVMIsAConstantExpr,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAConstantFP(Val::LLVMValueRef)
    ccall((:LLVMIsAConstantFP,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAConstantInt(Val::LLVMValueRef)
    ccall((:LLVMIsAConstantInt,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAConstantPointerNull(Val::LLVMValueRef)
    ccall((:LLVMIsAConstantPointerNull,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAConstantStruct(Val::LLVMValueRef)
    ccall((:LLVMIsAConstantStruct,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAConstantVector(Val::LLVMValueRef)
    ccall((:LLVMIsAConstantVector,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAGlobalValue(Val::LLVMValueRef)
    ccall((:LLVMIsAGlobalValue,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAGlobalAlias(Val::LLVMValueRef)
    ccall((:LLVMIsAGlobalAlias,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAGlobalObject(Val::LLVMValueRef)
    ccall((:LLVMIsAGlobalObject,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAFunction(Val::LLVMValueRef)
    ccall((:LLVMIsAFunction,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAGlobalVariable(Val::LLVMValueRef)
    ccall((:LLVMIsAGlobalVariable,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAUndefValue(Val::LLVMValueRef)
    ccall((:LLVMIsAUndefValue,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAInstruction(Val::LLVMValueRef)
    ccall((:LLVMIsAInstruction,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsABinaryOperator(Val::LLVMValueRef)
    ccall((:LLVMIsABinaryOperator,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsACallInst(Val::LLVMValueRef)
    ccall((:LLVMIsACallInst,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAIntrinsicInst(Val::LLVMValueRef)
    ccall((:LLVMIsAIntrinsicInst,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsADbgInfoIntrinsic(Val::LLVMValueRef)
    ccall((:LLVMIsADbgInfoIntrinsic,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsADbgDeclareInst(Val::LLVMValueRef)
    ccall((:LLVMIsADbgDeclareInst,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAMemIntrinsic(Val::LLVMValueRef)
    ccall((:LLVMIsAMemIntrinsic,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAMemCpyInst(Val::LLVMValueRef)
    ccall((:LLVMIsAMemCpyInst,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAMemMoveInst(Val::LLVMValueRef)
    ccall((:LLVMIsAMemMoveInst,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAMemSetInst(Val::LLVMValueRef)
    ccall((:LLVMIsAMemSetInst,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsACmpInst(Val::LLVMValueRef)
    ccall((:LLVMIsACmpInst,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAFCmpInst(Val::LLVMValueRef)
    ccall((:LLVMIsAFCmpInst,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAICmpInst(Val::LLVMValueRef)
    ccall((:LLVMIsAICmpInst,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAExtractElementInst(Val::LLVMValueRef)
    ccall((:LLVMIsAExtractElementInst,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAGetElementPtrInst(Val::LLVMValueRef)
    ccall((:LLVMIsAGetElementPtrInst,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAInsertElementInst(Val::LLVMValueRef)
    ccall((:LLVMIsAInsertElementInst,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAInsertValueInst(Val::LLVMValueRef)
    ccall((:LLVMIsAInsertValueInst,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsALandingPadInst(Val::LLVMValueRef)
    ccall((:LLVMIsALandingPadInst,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAPHINode(Val::LLVMValueRef)
    ccall((:LLVMIsAPHINode,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsASelectInst(Val::LLVMValueRef)
    ccall((:LLVMIsASelectInst,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAShuffleVectorInst(Val::LLVMValueRef)
    ccall((:LLVMIsAShuffleVectorInst,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAStoreInst(Val::LLVMValueRef)
    ccall((:LLVMIsAStoreInst,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsATerminatorInst(Val::LLVMValueRef)
    ccall((:LLVMIsATerminatorInst,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsABranchInst(Val::LLVMValueRef)
    ccall((:LLVMIsABranchInst,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAIndirectBrInst(Val::LLVMValueRef)
    ccall((:LLVMIsAIndirectBrInst,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAInvokeInst(Val::LLVMValueRef)
    ccall((:LLVMIsAInvokeInst,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAReturnInst(Val::LLVMValueRef)
    ccall((:LLVMIsAReturnInst,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsASwitchInst(Val::LLVMValueRef)
    ccall((:LLVMIsASwitchInst,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAUnreachableInst(Val::LLVMValueRef)
    ccall((:LLVMIsAUnreachableInst,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAResumeInst(Val::LLVMValueRef)
    ccall((:LLVMIsAResumeInst,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAUnaryInstruction(Val::LLVMValueRef)
    ccall((:LLVMIsAUnaryInstruction,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAAllocaInst(Val::LLVMValueRef)
    ccall((:LLVMIsAAllocaInst,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsACastInst(Val::LLVMValueRef)
    ccall((:LLVMIsACastInst,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAAddrSpaceCastInst(Val::LLVMValueRef)
    ccall((:LLVMIsAAddrSpaceCastInst,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsABitCastInst(Val::LLVMValueRef)
    ccall((:LLVMIsABitCastInst,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAFPExtInst(Val::LLVMValueRef)
    ccall((:LLVMIsAFPExtInst,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAFPToSIInst(Val::LLVMValueRef)
    ccall((:LLVMIsAFPToSIInst,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAFPToUIInst(Val::LLVMValueRef)
    ccall((:LLVMIsAFPToUIInst,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAFPTruncInst(Val::LLVMValueRef)
    ccall((:LLVMIsAFPTruncInst,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAIntToPtrInst(Val::LLVMValueRef)
    ccall((:LLVMIsAIntToPtrInst,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAPtrToIntInst(Val::LLVMValueRef)
    ccall((:LLVMIsAPtrToIntInst,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsASExtInst(Val::LLVMValueRef)
    ccall((:LLVMIsASExtInst,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsASIToFPInst(Val::LLVMValueRef)
    ccall((:LLVMIsASIToFPInst,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsATruncInst(Val::LLVMValueRef)
    ccall((:LLVMIsATruncInst,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAUIToFPInst(Val::LLVMValueRef)
    ccall((:LLVMIsAUIToFPInst,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAZExtInst(Val::LLVMValueRef)
    ccall((:LLVMIsAZExtInst,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAExtractValueInst(Val::LLVMValueRef)
    ccall((:LLVMIsAExtractValueInst,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsALoadInst(Val::LLVMValueRef)
    ccall((:LLVMIsALoadInst,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMIsAVAArgInst(Val::LLVMValueRef)
    ccall((:LLVMIsAVAArgInst,libllvm),LLVMValueRef,(LLVMValueRef,),Val)
end
function LLVMGetFirstUse(Val::LLVMValueRef)
    ccall((:LLVMGetFirstUse,libllvm),LLVMUseRef,(LLVMValueRef,),Val)
end
function LLVMGetNextUse(U::LLVMUseRef)
    ccall((:LLVMGetNextUse,libllvm),LLVMUseRef,(LLVMUseRef,),U)
end
function LLVMGetUser(U::LLVMUseRef)
    ccall((:LLVMGetUser,libllvm),LLVMValueRef,(LLVMUseRef,),U)
end
function LLVMGetUsedValue(U::LLVMUseRef)
    ccall((:LLVMGetUsedValue,libllvm),LLVMValueRef,(LLVMUseRef,),U)
end
function LLVMGetOperand(Val::LLVMValueRef,Index::Uint32)
    ccall((:LLVMGetOperand,libllvm),LLVMValueRef,(LLVMValueRef,Uint32),Val,Index)
end
function LLVMSetOperand(User::LLVMValueRef,Index::Uint32,Val::LLVMValueRef)
    ccall((:LLVMSetOperand,libllvm),Void,(LLVMValueRef,Uint32,LLVMValueRef),User,Index,Val)
end
function LLVMGetNumOperands(Val::LLVMValueRef)
    ccall((:LLVMGetNumOperands,libllvm),Cint,(LLVMValueRef,),Val)
end
function LLVMConstNull(Ty::LLVMTypeRef)
    ccall((:LLVMConstNull,libllvm),LLVMValueRef,(LLVMTypeRef,),Ty)
end
function LLVMConstAllOnes(Ty::LLVMTypeRef)
    ccall((:LLVMConstAllOnes,libllvm),LLVMValueRef,(LLVMTypeRef,),Ty)
end
function LLVMGetUndef(Ty::LLVMTypeRef)
    ccall((:LLVMGetUndef,libllvm),LLVMValueRef,(LLVMTypeRef,),Ty)
end
function LLVMIsNull(Val::LLVMValueRef)
    ccall((:LLVMIsNull,libllvm),LLVMBool,(LLVMValueRef,),Val)
end
function LLVMConstPointerNull(Ty::LLVMTypeRef)
    ccall((:LLVMConstPointerNull,libllvm),LLVMValueRef,(LLVMTypeRef,),Ty)
end
function LLVMConstInt(IntTy::LLVMTypeRef,N::Culonglong,SignExtend::LLVMBool)
    ccall((:LLVMConstInt,libllvm),LLVMValueRef,(LLVMTypeRef,Culonglong,LLVMBool),IntTy,N,SignExtend)
end
function LLVMConstIntOfArbitraryPrecision(IntTy::LLVMTypeRef,NumWords::Uint32,Words::Ptr{Cint})
    ccall((:LLVMConstIntOfArbitraryPrecision,libllvm),LLVMValueRef,(LLVMTypeRef,Uint32,Ptr{Cint}),IntTy,NumWords,Words)
end
function LLVMConstIntOfString(IntTy::LLVMTypeRef,Text::Ptr{Uint8},Radix::Cint)
    ccall((:LLVMConstIntOfString,libllvm),LLVMValueRef,(LLVMTypeRef,Ptr{Uint8},Cint),IntTy,Text,Radix)
end
function LLVMConstIntOfStringAndSize(IntTy::LLVMTypeRef,Text::Ptr{Uint8},SLen::Uint32,Radix::Cint)
    ccall((:LLVMConstIntOfStringAndSize,libllvm),LLVMValueRef,(LLVMTypeRef,Ptr{Uint8},Uint32,Cint),IntTy,Text,SLen,Radix)
end
function LLVMConstReal(RealTy::LLVMTypeRef,N::Cdouble)
    ccall((:LLVMConstReal,libllvm),LLVMValueRef,(LLVMTypeRef,Cdouble),RealTy,N)
end
function LLVMConstRealOfString(RealTy::LLVMTypeRef,Text::Ptr{Uint8})
    ccall((:LLVMConstRealOfString,libllvm),LLVMValueRef,(LLVMTypeRef,Ptr{Uint8}),RealTy,Text)
end
function LLVMConstRealOfStringAndSize(RealTy::LLVMTypeRef,Text::Ptr{Uint8},SLen::Uint32)
    ccall((:LLVMConstRealOfStringAndSize,libllvm),LLVMValueRef,(LLVMTypeRef,Ptr{Uint8},Uint32),RealTy,Text,SLen)
end
function LLVMConstIntGetZExtValue(ConstantVal::LLVMValueRef)
    ccall((:LLVMConstIntGetZExtValue,libllvm),Culonglong,(LLVMValueRef,),ConstantVal)
end
function LLVMConstIntGetSExtValue(ConstantVal::LLVMValueRef)
    ccall((:LLVMConstIntGetSExtValue,libllvm),Clonglong,(LLVMValueRef,),ConstantVal)
end
function LLVMConstStringInContext(C::LLVMContextRef,Str::Ptr{Uint8},Length::Uint32,DontNullTerminate::LLVMBool)
    ccall((:LLVMConstStringInContext,libllvm),LLVMValueRef,(LLVMContextRef,Ptr{Uint8},Uint32,LLVMBool),C,Str,Length,DontNullTerminate)
end
function LLVMConstString(Str::Ptr{Uint8},Length::Uint32,DontNullTerminate::LLVMBool)
    ccall((:LLVMConstString,libllvm),LLVMValueRef,(Ptr{Uint8},Uint32,LLVMBool),Str,Length,DontNullTerminate)
end
function LLVMConstStructInContext(C::LLVMContextRef,ConstantVals::Ptr{LLVMValueRef},Count::Uint32,Packed::LLVMBool)
    ccall((:LLVMConstStructInContext,libllvm),LLVMValueRef,(LLVMContextRef,Ptr{LLVMValueRef},Uint32,LLVMBool),C,ConstantVals,Count,Packed)
end
function LLVMConstStruct(ConstantVals::Ptr{LLVMValueRef},Count::Uint32,Packed::LLVMBool)
    ccall((:LLVMConstStruct,libllvm),LLVMValueRef,(Ptr{LLVMValueRef},Uint32,LLVMBool),ConstantVals,Count,Packed)
end
function LLVMConstArray(ElementTy::LLVMTypeRef,ConstantVals::Ptr{LLVMValueRef},Length::Uint32)
    ccall((:LLVMConstArray,libllvm),LLVMValueRef,(LLVMTypeRef,Ptr{LLVMValueRef},Uint32),ElementTy,ConstantVals,Length)
end
function LLVMConstNamedStruct(StructTy::LLVMTypeRef,ConstantVals::Ptr{LLVMValueRef},Count::Uint32)
    ccall((:LLVMConstNamedStruct,libllvm),LLVMValueRef,(LLVMTypeRef,Ptr{LLVMValueRef},Uint32),StructTy,ConstantVals,Count)
end
function LLVMConstVector(ScalarConstantVals::Ptr{LLVMValueRef},Size::Uint32)
    ccall((:LLVMConstVector,libllvm),LLVMValueRef,(Ptr{LLVMValueRef},Uint32),ScalarConstantVals,Size)
end
function LLVMGetConstOpcode(ConstantVal::LLVMValueRef)
    ccall((:LLVMGetConstOpcode,libllvm),LLVMOpcode,(LLVMValueRef,),ConstantVal)
end
function LLVMAlignOf(Ty::LLVMTypeRef)
    ccall((:LLVMAlignOf,libllvm),LLVMValueRef,(LLVMTypeRef,),Ty)
end
function LLVMSizeOf(Ty::LLVMTypeRef)
    ccall((:LLVMSizeOf,libllvm),LLVMValueRef,(LLVMTypeRef,),Ty)
end
function LLVMConstNeg(ConstantVal::LLVMValueRef)
    ccall((:LLVMConstNeg,libllvm),LLVMValueRef,(LLVMValueRef,),ConstantVal)
end
function LLVMConstNSWNeg(ConstantVal::LLVMValueRef)
    ccall((:LLVMConstNSWNeg,libllvm),LLVMValueRef,(LLVMValueRef,),ConstantVal)
end
function LLVMConstNUWNeg(ConstantVal::LLVMValueRef)
    ccall((:LLVMConstNUWNeg,libllvm),LLVMValueRef,(LLVMValueRef,),ConstantVal)
end
function LLVMConstFNeg(ConstantVal::LLVMValueRef)
    ccall((:LLVMConstFNeg,libllvm),LLVMValueRef,(LLVMValueRef,),ConstantVal)
end
function LLVMConstNot(ConstantVal::LLVMValueRef)
    ccall((:LLVMConstNot,libllvm),LLVMValueRef,(LLVMValueRef,),ConstantVal)
end
function LLVMConstAdd(LHSConstant::LLVMValueRef,RHSConstant::LLVMValueRef)
    ccall((:LLVMConstAdd,libllvm),LLVMValueRef,(LLVMValueRef,LLVMValueRef),LHSConstant,RHSConstant)
end
function LLVMConstNSWAdd(LHSConstant::LLVMValueRef,RHSConstant::LLVMValueRef)
    ccall((:LLVMConstNSWAdd,libllvm),LLVMValueRef,(LLVMValueRef,LLVMValueRef),LHSConstant,RHSConstant)
end
function LLVMConstNUWAdd(LHSConstant::LLVMValueRef,RHSConstant::LLVMValueRef)
    ccall((:LLVMConstNUWAdd,libllvm),LLVMValueRef,(LLVMValueRef,LLVMValueRef),LHSConstant,RHSConstant)
end
function LLVMConstFAdd(LHSConstant::LLVMValueRef,RHSConstant::LLVMValueRef)
    ccall((:LLVMConstFAdd,libllvm),LLVMValueRef,(LLVMValueRef,LLVMValueRef),LHSConstant,RHSConstant)
end
function LLVMConstSub(LHSConstant::LLVMValueRef,RHSConstant::LLVMValueRef)
    ccall((:LLVMConstSub,libllvm),LLVMValueRef,(LLVMValueRef,LLVMValueRef),LHSConstant,RHSConstant)
end
function LLVMConstNSWSub(LHSConstant::LLVMValueRef,RHSConstant::LLVMValueRef)
    ccall((:LLVMConstNSWSub,libllvm),LLVMValueRef,(LLVMValueRef,LLVMValueRef),LHSConstant,RHSConstant)
end
function LLVMConstNUWSub(LHSConstant::LLVMValueRef,RHSConstant::LLVMValueRef)
    ccall((:LLVMConstNUWSub,libllvm),LLVMValueRef,(LLVMValueRef,LLVMValueRef),LHSConstant,RHSConstant)
end
function LLVMConstFSub(LHSConstant::LLVMValueRef,RHSConstant::LLVMValueRef)
    ccall((:LLVMConstFSub,libllvm),LLVMValueRef,(LLVMValueRef,LLVMValueRef),LHSConstant,RHSConstant)
end
function LLVMConstMul(LHSConstant::LLVMValueRef,RHSConstant::LLVMValueRef)
    ccall((:LLVMConstMul,libllvm),LLVMValueRef,(LLVMValueRef,LLVMValueRef),LHSConstant,RHSConstant)
end
function LLVMConstNSWMul(LHSConstant::LLVMValueRef,RHSConstant::LLVMValueRef)
    ccall((:LLVMConstNSWMul,libllvm),LLVMValueRef,(LLVMValueRef,LLVMValueRef),LHSConstant,RHSConstant)
end
function LLVMConstNUWMul(LHSConstant::LLVMValueRef,RHSConstant::LLVMValueRef)
    ccall((:LLVMConstNUWMul,libllvm),LLVMValueRef,(LLVMValueRef,LLVMValueRef),LHSConstant,RHSConstant)
end
function LLVMConstFMul(LHSConstant::LLVMValueRef,RHSConstant::LLVMValueRef)
    ccall((:LLVMConstFMul,libllvm),LLVMValueRef,(LLVMValueRef,LLVMValueRef),LHSConstant,RHSConstant)
end
function LLVMConstUDiv(LHSConstant::LLVMValueRef,RHSConstant::LLVMValueRef)
    ccall((:LLVMConstUDiv,libllvm),LLVMValueRef,(LLVMValueRef,LLVMValueRef),LHSConstant,RHSConstant)
end
function LLVMConstSDiv(LHSConstant::LLVMValueRef,RHSConstant::LLVMValueRef)
    ccall((:LLVMConstSDiv,libllvm),LLVMValueRef,(LLVMValueRef,LLVMValueRef),LHSConstant,RHSConstant)
end
function LLVMConstExactSDiv(LHSConstant::LLVMValueRef,RHSConstant::LLVMValueRef)
    ccall((:LLVMConstExactSDiv,libllvm),LLVMValueRef,(LLVMValueRef,LLVMValueRef),LHSConstant,RHSConstant)
end
function LLVMConstFDiv(LHSConstant::LLVMValueRef,RHSConstant::LLVMValueRef)
    ccall((:LLVMConstFDiv,libllvm),LLVMValueRef,(LLVMValueRef,LLVMValueRef),LHSConstant,RHSConstant)
end
function LLVMConstURem(LHSConstant::LLVMValueRef,RHSConstant::LLVMValueRef)
    ccall((:LLVMConstURem,libllvm),LLVMValueRef,(LLVMValueRef,LLVMValueRef),LHSConstant,RHSConstant)
end
function LLVMConstSRem(LHSConstant::LLVMValueRef,RHSConstant::LLVMValueRef)
    ccall((:LLVMConstSRem,libllvm),LLVMValueRef,(LLVMValueRef,LLVMValueRef),LHSConstant,RHSConstant)
end
function LLVMConstFRem(LHSConstant::LLVMValueRef,RHSConstant::LLVMValueRef)
    ccall((:LLVMConstFRem,libllvm),LLVMValueRef,(LLVMValueRef,LLVMValueRef),LHSConstant,RHSConstant)
end
function LLVMConstAnd(LHSConstant::LLVMValueRef,RHSConstant::LLVMValueRef)
    ccall((:LLVMConstAnd,libllvm),LLVMValueRef,(LLVMValueRef,LLVMValueRef),LHSConstant,RHSConstant)
end
function LLVMConstOr(LHSConstant::LLVMValueRef,RHSConstant::LLVMValueRef)
    ccall((:LLVMConstOr,libllvm),LLVMValueRef,(LLVMValueRef,LLVMValueRef),LHSConstant,RHSConstant)
end
function LLVMConstXor(LHSConstant::LLVMValueRef,RHSConstant::LLVMValueRef)
    ccall((:LLVMConstXor,libllvm),LLVMValueRef,(LLVMValueRef,LLVMValueRef),LHSConstant,RHSConstant)
end
function LLVMConstICmp(Predicate::LLVMIntPredicate,LHSConstant::LLVMValueRef,RHSConstant::LLVMValueRef)
    ccall((:LLVMConstICmp,libllvm),LLVMValueRef,(LLVMIntPredicate,LLVMValueRef,LLVMValueRef),Predicate,LHSConstant,RHSConstant)
end
function LLVMConstFCmp(Predicate::LLVMRealPredicate,LHSConstant::LLVMValueRef,RHSConstant::LLVMValueRef)
    ccall((:LLVMConstFCmp,libllvm),LLVMValueRef,(LLVMRealPredicate,LLVMValueRef,LLVMValueRef),Predicate,LHSConstant,RHSConstant)
end
function LLVMConstShl(LHSConstant::LLVMValueRef,RHSConstant::LLVMValueRef)
    ccall((:LLVMConstShl,libllvm),LLVMValueRef,(LLVMValueRef,LLVMValueRef),LHSConstant,RHSConstant)
end
function LLVMConstLShr(LHSConstant::LLVMValueRef,RHSConstant::LLVMValueRef)
    ccall((:LLVMConstLShr,libllvm),LLVMValueRef,(LLVMValueRef,LLVMValueRef),LHSConstant,RHSConstant)
end
function LLVMConstAShr(LHSConstant::LLVMValueRef,RHSConstant::LLVMValueRef)
    ccall((:LLVMConstAShr,libllvm),LLVMValueRef,(LLVMValueRef,LLVMValueRef),LHSConstant,RHSConstant)
end
function LLVMConstGEP(ConstantVal::LLVMValueRef,ConstantIndices::Ptr{LLVMValueRef},NumIndices::Uint32)
    ccall((:LLVMConstGEP,libllvm),LLVMValueRef,(LLVMValueRef,Ptr{LLVMValueRef},Uint32),ConstantVal,ConstantIndices,NumIndices)
end
function LLVMConstInBoundsGEP(ConstantVal::LLVMValueRef,ConstantIndices::Ptr{LLVMValueRef},NumIndices::Uint32)
    ccall((:LLVMConstInBoundsGEP,libllvm),LLVMValueRef,(LLVMValueRef,Ptr{LLVMValueRef},Uint32),ConstantVal,ConstantIndices,NumIndices)
end
function LLVMConstTrunc(ConstantVal::LLVMValueRef,ToType::LLVMTypeRef)
    ccall((:LLVMConstTrunc,libllvm),LLVMValueRef,(LLVMValueRef,LLVMTypeRef),ConstantVal,ToType)
end
function LLVMConstSExt(ConstantVal::LLVMValueRef,ToType::LLVMTypeRef)
    ccall((:LLVMConstSExt,libllvm),LLVMValueRef,(LLVMValueRef,LLVMTypeRef),ConstantVal,ToType)
end
function LLVMConstZExt(ConstantVal::LLVMValueRef,ToType::LLVMTypeRef)
    ccall((:LLVMConstZExt,libllvm),LLVMValueRef,(LLVMValueRef,LLVMTypeRef),ConstantVal,ToType)
end
function LLVMConstFPTrunc(ConstantVal::LLVMValueRef,ToType::LLVMTypeRef)
    ccall((:LLVMConstFPTrunc,libllvm),LLVMValueRef,(LLVMValueRef,LLVMTypeRef),ConstantVal,ToType)
end
function LLVMConstFPExt(ConstantVal::LLVMValueRef,ToType::LLVMTypeRef)
    ccall((:LLVMConstFPExt,libllvm),LLVMValueRef,(LLVMValueRef,LLVMTypeRef),ConstantVal,ToType)
end
function LLVMConstUIToFP(ConstantVal::LLVMValueRef,ToType::LLVMTypeRef)
    ccall((:LLVMConstUIToFP,libllvm),LLVMValueRef,(LLVMValueRef,LLVMTypeRef),ConstantVal,ToType)
end
function LLVMConstSIToFP(ConstantVal::LLVMValueRef,ToType::LLVMTypeRef)
    ccall((:LLVMConstSIToFP,libllvm),LLVMValueRef,(LLVMValueRef,LLVMTypeRef),ConstantVal,ToType)
end
function LLVMConstFPToUI(ConstantVal::LLVMValueRef,ToType::LLVMTypeRef)
    ccall((:LLVMConstFPToUI,libllvm),LLVMValueRef,(LLVMValueRef,LLVMTypeRef),ConstantVal,ToType)
end
function LLVMConstFPToSI(ConstantVal::LLVMValueRef,ToType::LLVMTypeRef)
    ccall((:LLVMConstFPToSI,libllvm),LLVMValueRef,(LLVMValueRef,LLVMTypeRef),ConstantVal,ToType)
end
function LLVMConstPtrToInt(ConstantVal::LLVMValueRef,ToType::LLVMTypeRef)
    ccall((:LLVMConstPtrToInt,libllvm),LLVMValueRef,(LLVMValueRef,LLVMTypeRef),ConstantVal,ToType)
end
function LLVMConstIntToPtr(ConstantVal::LLVMValueRef,ToType::LLVMTypeRef)
    ccall((:LLVMConstIntToPtr,libllvm),LLVMValueRef,(LLVMValueRef,LLVMTypeRef),ConstantVal,ToType)
end
function LLVMConstBitCast(ConstantVal::LLVMValueRef,ToType::LLVMTypeRef)
    ccall((:LLVMConstBitCast,libllvm),LLVMValueRef,(LLVMValueRef,LLVMTypeRef),ConstantVal,ToType)
end
function LLVMConstAddrSpaceCast(ConstantVal::LLVMValueRef,ToType::LLVMTypeRef)
    ccall((:LLVMConstAddrSpaceCast,libllvm),LLVMValueRef,(LLVMValueRef,LLVMTypeRef),ConstantVal,ToType)
end
function LLVMConstZExtOrBitCast(ConstantVal::LLVMValueRef,ToType::LLVMTypeRef)
    ccall((:LLVMConstZExtOrBitCast,libllvm),LLVMValueRef,(LLVMValueRef,LLVMTypeRef),ConstantVal,ToType)
end
function LLVMConstSExtOrBitCast(ConstantVal::LLVMValueRef,ToType::LLVMTypeRef)
    ccall((:LLVMConstSExtOrBitCast,libllvm),LLVMValueRef,(LLVMValueRef,LLVMTypeRef),ConstantVal,ToType)
end
function LLVMConstTruncOrBitCast(ConstantVal::LLVMValueRef,ToType::LLVMTypeRef)
    ccall((:LLVMConstTruncOrBitCast,libllvm),LLVMValueRef,(LLVMValueRef,LLVMTypeRef),ConstantVal,ToType)
end
function LLVMConstPointerCast(ConstantVal::LLVMValueRef,ToType::LLVMTypeRef)
    ccall((:LLVMConstPointerCast,libllvm),LLVMValueRef,(LLVMValueRef,LLVMTypeRef),ConstantVal,ToType)
end
function LLVMConstIntCast(ConstantVal::LLVMValueRef,ToType::LLVMTypeRef,isSigned::LLVMBool)
    ccall((:LLVMConstIntCast,libllvm),LLVMValueRef,(LLVMValueRef,LLVMTypeRef,LLVMBool),ConstantVal,ToType,isSigned)
end
function LLVMConstFPCast(ConstantVal::LLVMValueRef,ToType::LLVMTypeRef)
    ccall((:LLVMConstFPCast,libllvm),LLVMValueRef,(LLVMValueRef,LLVMTypeRef),ConstantVal,ToType)
end
function LLVMConstSelect(ConstantCondition::LLVMValueRef,ConstantIfTrue::LLVMValueRef,ConstantIfFalse::LLVMValueRef)
    ccall((:LLVMConstSelect,libllvm),LLVMValueRef,(LLVMValueRef,LLVMValueRef,LLVMValueRef),ConstantCondition,ConstantIfTrue,ConstantIfFalse)
end
function LLVMConstExtractElement(VectorConstant::LLVMValueRef,IndexConstant::LLVMValueRef)
    ccall((:LLVMConstExtractElement,libllvm),LLVMValueRef,(LLVMValueRef,LLVMValueRef),VectorConstant,IndexConstant)
end
function LLVMConstInsertElement(VectorConstant::LLVMValueRef,ElementValueConstant::LLVMValueRef,IndexConstant::LLVMValueRef)
    ccall((:LLVMConstInsertElement,libllvm),LLVMValueRef,(LLVMValueRef,LLVMValueRef,LLVMValueRef),VectorConstant,ElementValueConstant,IndexConstant)
end
function LLVMConstShuffleVector(VectorAConstant::LLVMValueRef,VectorBConstant::LLVMValueRef,MaskConstant::LLVMValueRef)
    ccall((:LLVMConstShuffleVector,libllvm),LLVMValueRef,(LLVMValueRef,LLVMValueRef,LLVMValueRef),VectorAConstant,VectorBConstant,MaskConstant)
end
function LLVMConstExtractValue(AggConstant::LLVMValueRef,IdxList::Ptr{Uint32},NumIdx::Uint32)
    ccall((:LLVMConstExtractValue,libllvm),LLVMValueRef,(LLVMValueRef,Ptr{Uint32},Uint32),AggConstant,IdxList,NumIdx)
end
function LLVMConstInsertValue(AggConstant::LLVMValueRef,ElementValueConstant::LLVMValueRef,IdxList::Ptr{Uint32},NumIdx::Uint32)
    ccall((:LLVMConstInsertValue,libllvm),LLVMValueRef,(LLVMValueRef,LLVMValueRef,Ptr{Uint32},Uint32),AggConstant,ElementValueConstant,IdxList,NumIdx)
end
function LLVMConstInlineAsm(Ty::LLVMTypeRef,AsmString::Ptr{Uint8},Constraints::Ptr{Uint8},HasSideEffects::LLVMBool,IsAlignStack::LLVMBool)
    ccall((:LLVMConstInlineAsm,libllvm),LLVMValueRef,(LLVMTypeRef,Ptr{Uint8},Ptr{Uint8},LLVMBool,LLVMBool),Ty,AsmString,Constraints,HasSideEffects,IsAlignStack)
end
function LLVMBlockAddress(F::LLVMValueRef,BB::LLVMBasicBlockRef)
    ccall((:LLVMBlockAddress,libllvm),LLVMValueRef,(LLVMValueRef,LLVMBasicBlockRef),F,BB)
end
function LLVMGetGlobalParent(Global::LLVMValueRef)
    ccall((:LLVMGetGlobalParent,libllvm),LLVMModuleRef,(LLVMValueRef,),Global)
end
function LLVMIsDeclaration(Global::LLVMValueRef)
    ccall((:LLVMIsDeclaration,libllvm),LLVMBool,(LLVMValueRef,),Global)
end
function LLVMGetLinkage(Global::LLVMValueRef)
    ccall((:LLVMGetLinkage,libllvm),LLVMLinkage,(LLVMValueRef,),Global)
end
function LLVMSetLinkage(Global::LLVMValueRef,Linkage::LLVMLinkage)
    ccall((:LLVMSetLinkage,libllvm),Void,(LLVMValueRef,LLVMLinkage),Global,Linkage)
end
function LLVMGetSection(Global::LLVMValueRef)
    ccall((:LLVMGetSection,libllvm),Ptr{Uint8},(LLVMValueRef,),Global)
end
function LLVMSetSection(Global::LLVMValueRef,Section::Ptr{Uint8})
    ccall((:LLVMSetSection,libllvm),Void,(LLVMValueRef,Ptr{Uint8}),Global,Section)
end
function LLVMGetVisibility(Global::LLVMValueRef)
    ccall((:LLVMGetVisibility,libllvm),LLVMVisibility,(LLVMValueRef,),Global)
end
function LLVMSetVisibility(Global::LLVMValueRef,Viz::LLVMVisibility)
    ccall((:LLVMSetVisibility,libllvm),Void,(LLVMValueRef,LLVMVisibility),Global,Viz)
end
function LLVMGetDLLStorageClass(Global::LLVMValueRef)
    ccall((:LLVMGetDLLStorageClass,libllvm),LLVMDLLStorageClass,(LLVMValueRef,),Global)
end
function LLVMSetDLLStorageClass(Global::LLVMValueRef,Class::LLVMDLLStorageClass)
    ccall((:LLVMSetDLLStorageClass,libllvm),Void,(LLVMValueRef,LLVMDLLStorageClass),Global,Class)
end
function LLVMHasUnnamedAddr(Global::LLVMValueRef)
    ccall((:LLVMHasUnnamedAddr,libllvm),LLVMBool,(LLVMValueRef,),Global)
end
function LLVMSetUnnamedAddr(Global::LLVMValueRef,HasUnnamedAddr::LLVMBool)
    ccall((:LLVMSetUnnamedAddr,libllvm),Void,(LLVMValueRef,LLVMBool),Global,HasUnnamedAddr)
end
function LLVMGetAlignment(V::LLVMValueRef)
    ccall((:LLVMGetAlignment,libllvm),Uint32,(LLVMValueRef,),V)
end
function LLVMSetAlignment(V::LLVMValueRef,Bytes::Uint32)
    ccall((:LLVMSetAlignment,libllvm),Void,(LLVMValueRef,Uint32),V,Bytes)
end
function LLVMAddGlobal(M::LLVMModuleRef,Ty::LLVMTypeRef,Name::Ptr{Uint8})
    ccall((:LLVMAddGlobal,libllvm),LLVMValueRef,(LLVMModuleRef,LLVMTypeRef,Ptr{Uint8}),M,Ty,Name)
end
function LLVMAddGlobalInAddressSpace(M::LLVMModuleRef,Ty::LLVMTypeRef,Name::Ptr{Uint8},AddressSpace::Uint32)
    ccall((:LLVMAddGlobalInAddressSpace,libllvm),LLVMValueRef,(LLVMModuleRef,LLVMTypeRef,Ptr{Uint8},Uint32),M,Ty,Name,AddressSpace)
end
function LLVMGetNamedGlobal(M::LLVMModuleRef,Name::Ptr{Uint8})
    ccall((:LLVMGetNamedGlobal,libllvm),LLVMValueRef,(LLVMModuleRef,Ptr{Uint8}),M,Name)
end
function LLVMGetFirstGlobal(M::LLVMModuleRef)
    ccall((:LLVMGetFirstGlobal,libllvm),LLVMValueRef,(LLVMModuleRef,),M)
end
function LLVMGetLastGlobal(M::LLVMModuleRef)
    ccall((:LLVMGetLastGlobal,libllvm),LLVMValueRef,(LLVMModuleRef,),M)
end
function LLVMGetNextGlobal(GlobalVar::LLVMValueRef)
    ccall((:LLVMGetNextGlobal,libllvm),LLVMValueRef,(LLVMValueRef,),GlobalVar)
end
function LLVMGetPreviousGlobal(GlobalVar::LLVMValueRef)
    ccall((:LLVMGetPreviousGlobal,libllvm),LLVMValueRef,(LLVMValueRef,),GlobalVar)
end
function LLVMDeleteGlobal(GlobalVar::LLVMValueRef)
    ccall((:LLVMDeleteGlobal,libllvm),Void,(LLVMValueRef,),GlobalVar)
end
function LLVMGetInitializer(GlobalVar::LLVMValueRef)
    ccall((:LLVMGetInitializer,libllvm),LLVMValueRef,(LLVMValueRef,),GlobalVar)
end
function LLVMSetInitializer(GlobalVar::LLVMValueRef,ConstantVal::LLVMValueRef)
    ccall((:LLVMSetInitializer,libllvm),Void,(LLVMValueRef,LLVMValueRef),GlobalVar,ConstantVal)
end
function LLVMIsThreadLocal(GlobalVar::LLVMValueRef)
    ccall((:LLVMIsThreadLocal,libllvm),LLVMBool,(LLVMValueRef,),GlobalVar)
end
function LLVMSetThreadLocal(GlobalVar::LLVMValueRef,IsThreadLocal::LLVMBool)
    ccall((:LLVMSetThreadLocal,libllvm),Void,(LLVMValueRef,LLVMBool),GlobalVar,IsThreadLocal)
end
function LLVMIsGlobalConstant(GlobalVar::LLVMValueRef)
    ccall((:LLVMIsGlobalConstant,libllvm),LLVMBool,(LLVMValueRef,),GlobalVar)
end
function LLVMSetGlobalConstant(GlobalVar::LLVMValueRef,IsConstant::LLVMBool)
    ccall((:LLVMSetGlobalConstant,libllvm),Void,(LLVMValueRef,LLVMBool),GlobalVar,IsConstant)
end
function LLVMGetThreadLocalMode(GlobalVar::LLVMValueRef)
    ccall((:LLVMGetThreadLocalMode,libllvm),LLVMThreadLocalMode,(LLVMValueRef,),GlobalVar)
end
function LLVMSetThreadLocalMode(GlobalVar::LLVMValueRef,Mode::LLVMThreadLocalMode)
    ccall((:LLVMSetThreadLocalMode,libllvm),Void,(LLVMValueRef,LLVMThreadLocalMode),GlobalVar,Mode)
end
function LLVMIsExternallyInitialized(GlobalVar::LLVMValueRef)
    ccall((:LLVMIsExternallyInitialized,libllvm),LLVMBool,(LLVMValueRef,),GlobalVar)
end
function LLVMSetExternallyInitialized(GlobalVar::LLVMValueRef,IsExtInit::LLVMBool)
    ccall((:LLVMSetExternallyInitialized,libllvm),Void,(LLVMValueRef,LLVMBool),GlobalVar,IsExtInit)
end
function LLVMAddAlias(M::LLVMModuleRef,Ty::LLVMTypeRef,Aliasee::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMAddAlias,libllvm),LLVMValueRef,(LLVMModuleRef,LLVMTypeRef,LLVMValueRef,Ptr{Uint8}),M,Ty,Aliasee,Name)
end
function LLVMDeleteFunction(Fn::LLVMValueRef)
    ccall((:LLVMDeleteFunction,libllvm),Void,(LLVMValueRef,),Fn)
end
function LLVMGetIntrinsicID(Fn::LLVMValueRef)
    ccall((:LLVMGetIntrinsicID,libllvm),Uint32,(LLVMValueRef,),Fn)
end
function LLVMGetFunctionCallConv(Fn::LLVMValueRef)
    ccall((:LLVMGetFunctionCallConv,libllvm),Uint32,(LLVMValueRef,),Fn)
end
function LLVMSetFunctionCallConv(Fn::LLVMValueRef,CC::Uint32)
    ccall((:LLVMSetFunctionCallConv,libllvm),Void,(LLVMValueRef,Uint32),Fn,CC)
end
function LLVMGetGC(Fn::LLVMValueRef)
    ccall((:LLVMGetGC,libllvm),Ptr{Uint8},(LLVMValueRef,),Fn)
end
function LLVMSetGC(Fn::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMSetGC,libllvm),Void,(LLVMValueRef,Ptr{Uint8}),Fn,Name)
end
function LLVMAddFunctionAttr(Fn::LLVMValueRef,PA::LLVMAttribute)
    ccall((:LLVMAddFunctionAttr,libllvm),Void,(LLVMValueRef,LLVMAttribute),Fn,PA)
end
function LLVMAddTargetDependentFunctionAttr(Fn::LLVMValueRef,A::Ptr{Uint8},V::Ptr{Uint8})
    ccall((:LLVMAddTargetDependentFunctionAttr,libllvm),Void,(LLVMValueRef,Ptr{Uint8},Ptr{Uint8}),Fn,A,V)
end
function LLVMGetFunctionAttr(Fn::LLVMValueRef)
    ccall((:LLVMGetFunctionAttr,libllvm),LLVMAttribute,(LLVMValueRef,),Fn)
end
function LLVMRemoveFunctionAttr(Fn::LLVMValueRef,PA::LLVMAttribute)
    ccall((:LLVMRemoveFunctionAttr,libllvm),Void,(LLVMValueRef,LLVMAttribute),Fn,PA)
end
function LLVMCountParams(Fn::LLVMValueRef)
    ccall((:LLVMCountParams,libllvm),Uint32,(LLVMValueRef,),Fn)
end
function LLVMGetParams(Fn::LLVMValueRef,Params::Ptr{LLVMValueRef})
    ccall((:LLVMGetParams,libllvm),Void,(LLVMValueRef,Ptr{LLVMValueRef}),Fn,Params)
end
function LLVMGetParam(Fn::LLVMValueRef,Index::Uint32)
    ccall((:LLVMGetParam,libllvm),LLVMValueRef,(LLVMValueRef,Uint32),Fn,Index)
end
function LLVMGetParamParent(Inst::LLVMValueRef)
    ccall((:LLVMGetParamParent,libllvm),LLVMValueRef,(LLVMValueRef,),Inst)
end
function LLVMGetFirstParam(Fn::LLVMValueRef)
    ccall((:LLVMGetFirstParam,libllvm),LLVMValueRef,(LLVMValueRef,),Fn)
end
function LLVMGetLastParam(Fn::LLVMValueRef)
    ccall((:LLVMGetLastParam,libllvm),LLVMValueRef,(LLVMValueRef,),Fn)
end
function LLVMGetNextParam(Arg::LLVMValueRef)
    ccall((:LLVMGetNextParam,libllvm),LLVMValueRef,(LLVMValueRef,),Arg)
end
function LLVMGetPreviousParam(Arg::LLVMValueRef)
    ccall((:LLVMGetPreviousParam,libllvm),LLVMValueRef,(LLVMValueRef,),Arg)
end
function LLVMAddAttribute(Arg::LLVMValueRef,PA::LLVMAttribute)
    ccall((:LLVMAddAttribute,libllvm),Void,(LLVMValueRef,LLVMAttribute),Arg,PA)
end
function LLVMRemoveAttribute(Arg::LLVMValueRef,PA::LLVMAttribute)
    ccall((:LLVMRemoveAttribute,libllvm),Void,(LLVMValueRef,LLVMAttribute),Arg,PA)
end
function LLVMGetAttribute(Arg::LLVMValueRef)
    ccall((:LLVMGetAttribute,libllvm),LLVMAttribute,(LLVMValueRef,),Arg)
end
function LLVMSetParamAlignment(Arg::LLVMValueRef,align::Uint32)
    ccall((:LLVMSetParamAlignment,libllvm),Void,(LLVMValueRef,Uint32),Arg,align)
end
function LLVMMDStringInContext(C::LLVMContextRef,Str::Ptr{Uint8},SLen::Uint32)
    ccall((:LLVMMDStringInContext,libllvm),LLVMValueRef,(LLVMContextRef,Ptr{Uint8},Uint32),C,Str,SLen)
end
function LLVMMDString(Str::Ptr{Uint8},SLen::Uint32)
    ccall((:LLVMMDString,libllvm),LLVMValueRef,(Ptr{Uint8},Uint32),Str,SLen)
end
function LLVMMDNodeInContext(C::LLVMContextRef,Vals::Ptr{LLVMValueRef},Count::Uint32)
    ccall((:LLVMMDNodeInContext,libllvm),LLVMValueRef,(LLVMContextRef,Ptr{LLVMValueRef},Uint32),C,Vals,Count)
end
function LLVMMDNode(Vals::Ptr{LLVMValueRef},Count::Uint32)
    ccall((:LLVMMDNode,libllvm),LLVMValueRef,(Ptr{LLVMValueRef},Uint32),Vals,Count)
end
function LLVMGetMDString(V::LLVMValueRef,Len::Ptr{Uint32})
    ccall((:LLVMGetMDString,libllvm),Ptr{Uint8},(LLVMValueRef,Ptr{Uint32}),V,Len)
end
function LLVMGetMDNodeNumOperands(V::LLVMValueRef)
    ccall((:LLVMGetMDNodeNumOperands,libllvm),Uint32,(LLVMValueRef,),V)
end
function LLVMGetMDNodeOperands(V::LLVMValueRef,Dest::Ptr{LLVMValueRef})
    ccall((:LLVMGetMDNodeOperands,libllvm),Void,(LLVMValueRef,Ptr{LLVMValueRef}),V,Dest)
end
function LLVMBasicBlockAsValue(BB::LLVMBasicBlockRef)
    ccall((:LLVMBasicBlockAsValue,libllvm),LLVMValueRef,(LLVMBasicBlockRef,),BB)
end
function LLVMValueIsBasicBlock(Val::LLVMValueRef)
    ccall((:LLVMValueIsBasicBlock,libllvm),LLVMBool,(LLVMValueRef,),Val)
end
function LLVMValueAsBasicBlock(Val::LLVMValueRef)
    ccall((:LLVMValueAsBasicBlock,libllvm),LLVMBasicBlockRef,(LLVMValueRef,),Val)
end
function LLVMGetBasicBlockParent(BB::LLVMBasicBlockRef)
    ccall((:LLVMGetBasicBlockParent,libllvm),LLVMValueRef,(LLVMBasicBlockRef,),BB)
end
function LLVMGetBasicBlockTerminator(BB::LLVMBasicBlockRef)
    ccall((:LLVMGetBasicBlockTerminator,libllvm),LLVMValueRef,(LLVMBasicBlockRef,),BB)
end
function LLVMCountBasicBlocks(Fn::LLVMValueRef)
    ccall((:LLVMCountBasicBlocks,libllvm),Uint32,(LLVMValueRef,),Fn)
end
function LLVMGetBasicBlocks(Fn::LLVMValueRef,BasicBlocks::Ptr{LLVMBasicBlockRef})
    ccall((:LLVMGetBasicBlocks,libllvm),Void,(LLVMValueRef,Ptr{LLVMBasicBlockRef}),Fn,BasicBlocks)
end
function LLVMGetFirstBasicBlock(Fn::LLVMValueRef)
    ccall((:LLVMGetFirstBasicBlock,libllvm),LLVMBasicBlockRef,(LLVMValueRef,),Fn)
end
function LLVMGetLastBasicBlock(Fn::LLVMValueRef)
    ccall((:LLVMGetLastBasicBlock,libllvm),LLVMBasicBlockRef,(LLVMValueRef,),Fn)
end
function LLVMGetNextBasicBlock(BB::LLVMBasicBlockRef)
    ccall((:LLVMGetNextBasicBlock,libllvm),LLVMBasicBlockRef,(LLVMBasicBlockRef,),BB)
end
function LLVMGetPreviousBasicBlock(BB::LLVMBasicBlockRef)
    ccall((:LLVMGetPreviousBasicBlock,libllvm),LLVMBasicBlockRef,(LLVMBasicBlockRef,),BB)
end
function LLVMGetEntryBasicBlock(Fn::LLVMValueRef)
    ccall((:LLVMGetEntryBasicBlock,libllvm),LLVMBasicBlockRef,(LLVMValueRef,),Fn)
end
function LLVMAppendBasicBlockInContext(C::LLVMContextRef,Fn::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMAppendBasicBlockInContext,libllvm),LLVMBasicBlockRef,(LLVMContextRef,LLVMValueRef,Ptr{Uint8}),C,Fn,Name)
end
function LLVMAppendBasicBlock(Fn::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMAppendBasicBlock,libllvm),LLVMBasicBlockRef,(LLVMValueRef,Ptr{Uint8}),Fn,Name)
end
function LLVMInsertBasicBlockInContext(C::LLVMContextRef,BB::LLVMBasicBlockRef,Name::Ptr{Uint8})
    ccall((:LLVMInsertBasicBlockInContext,libllvm),LLVMBasicBlockRef,(LLVMContextRef,LLVMBasicBlockRef,Ptr{Uint8}),C,BB,Name)
end
function LLVMInsertBasicBlock(InsertBeforeBB::LLVMBasicBlockRef,Name::Ptr{Uint8})
    ccall((:LLVMInsertBasicBlock,libllvm),LLVMBasicBlockRef,(LLVMBasicBlockRef,Ptr{Uint8}),InsertBeforeBB,Name)
end
function LLVMDeleteBasicBlock(BB::LLVMBasicBlockRef)
    ccall((:LLVMDeleteBasicBlock,libllvm),Void,(LLVMBasicBlockRef,),BB)
end
function LLVMRemoveBasicBlockFromParent(BB::LLVMBasicBlockRef)
    ccall((:LLVMRemoveBasicBlockFromParent,libllvm),Void,(LLVMBasicBlockRef,),BB)
end
function LLVMMoveBasicBlockBefore(BB::LLVMBasicBlockRef,MovePos::LLVMBasicBlockRef)
    ccall((:LLVMMoveBasicBlockBefore,libllvm),Void,(LLVMBasicBlockRef,LLVMBasicBlockRef),BB,MovePos)
end
function LLVMMoveBasicBlockAfter(BB::LLVMBasicBlockRef,MovePos::LLVMBasicBlockRef)
    ccall((:LLVMMoveBasicBlockAfter,libllvm),Void,(LLVMBasicBlockRef,LLVMBasicBlockRef),BB,MovePos)
end
function LLVMGetFirstInstruction(BB::LLVMBasicBlockRef)
    ccall((:LLVMGetFirstInstruction,libllvm),LLVMValueRef,(LLVMBasicBlockRef,),BB)
end
function LLVMGetLastInstruction(BB::LLVMBasicBlockRef)
    ccall((:LLVMGetLastInstruction,libllvm),LLVMValueRef,(LLVMBasicBlockRef,),BB)
end
function LLVMHasMetadata(Val::LLVMValueRef)
    ccall((:LLVMHasMetadata,libllvm),Cint,(LLVMValueRef,),Val)
end
function LLVMGetMetadata(Val::LLVMValueRef,KindID::Uint32)
    ccall((:LLVMGetMetadata,libllvm),LLVMValueRef,(LLVMValueRef,Uint32),Val,KindID)
end
function LLVMSetMetadata(Val::LLVMValueRef,KindID::Uint32,Node::LLVMValueRef)
    ccall((:LLVMSetMetadata,libllvm),Void,(LLVMValueRef,Uint32,LLVMValueRef),Val,KindID,Node)
end
function LLVMGetInstructionParent(Inst::LLVMValueRef)
    ccall((:LLVMGetInstructionParent,libllvm),LLVMBasicBlockRef,(LLVMValueRef,),Inst)
end
function LLVMGetNextInstruction(Inst::LLVMValueRef)
    ccall((:LLVMGetNextInstruction,libllvm),LLVMValueRef,(LLVMValueRef,),Inst)
end
function LLVMGetPreviousInstruction(Inst::LLVMValueRef)
    ccall((:LLVMGetPreviousInstruction,libllvm),LLVMValueRef,(LLVMValueRef,),Inst)
end
function LLVMInstructionEraseFromParent(Inst::LLVMValueRef)
    ccall((:LLVMInstructionEraseFromParent,libllvm),Void,(LLVMValueRef,),Inst)
end
function LLVMGetInstructionOpcode(Inst::LLVMValueRef)
    ccall((:LLVMGetInstructionOpcode,libllvm),LLVMOpcode,(LLVMValueRef,),Inst)
end
function LLVMGetICmpPredicate(Inst::LLVMValueRef)
    ccall((:LLVMGetICmpPredicate,libllvm),LLVMIntPredicate,(LLVMValueRef,),Inst)
end
function LLVMSetInstructionCallConv(Instr::LLVMValueRef,CC::Uint32)
    ccall((:LLVMSetInstructionCallConv,libllvm),Void,(LLVMValueRef,Uint32),Instr,CC)
end
function LLVMGetInstructionCallConv(Instr::LLVMValueRef)
    ccall((:LLVMGetInstructionCallConv,libllvm),Uint32,(LLVMValueRef,),Instr)
end
function LLVMAddInstrAttribute(Instr::LLVMValueRef,index::Uint32,arg1::LLVMAttribute)
    ccall((:LLVMAddInstrAttribute,libllvm),Void,(LLVMValueRef,Uint32,LLVMAttribute),Instr,index,arg1)
end
function LLVMRemoveInstrAttribute(Instr::LLVMValueRef,index::Uint32,arg1::LLVMAttribute)
    ccall((:LLVMRemoveInstrAttribute,libllvm),Void,(LLVMValueRef,Uint32,LLVMAttribute),Instr,index,arg1)
end
function LLVMSetInstrParamAlignment(Instr::LLVMValueRef,index::Uint32,align::Uint32)
    ccall((:LLVMSetInstrParamAlignment,libllvm),Void,(LLVMValueRef,Uint32,Uint32),Instr,index,align)
end
function LLVMIsTailCall(CallInst::LLVMValueRef)
    ccall((:LLVMIsTailCall,libllvm),LLVMBool,(LLVMValueRef,),CallInst)
end
function LLVMSetTailCall(CallInst::LLVMValueRef,IsTailCall::LLVMBool)
    ccall((:LLVMSetTailCall,libllvm),Void,(LLVMValueRef,LLVMBool),CallInst,IsTailCall)
end
function LLVMGetSwitchDefaultDest(SwitchInstr::LLVMValueRef)
    ccall((:LLVMGetSwitchDefaultDest,libllvm),LLVMBasicBlockRef,(LLVMValueRef,),SwitchInstr)
end
function LLVMAddIncoming(PhiNode::LLVMValueRef,IncomingValues::Ptr{LLVMValueRef},IncomingBlocks::Ptr{LLVMBasicBlockRef},Count::Uint32)
    ccall((:LLVMAddIncoming,libllvm),Void,(LLVMValueRef,Ptr{LLVMValueRef},Ptr{LLVMBasicBlockRef},Uint32),PhiNode,IncomingValues,IncomingBlocks,Count)
end
function LLVMCountIncoming(PhiNode::LLVMValueRef)
    ccall((:LLVMCountIncoming,libllvm),Uint32,(LLVMValueRef,),PhiNode)
end
function LLVMGetIncomingValue(PhiNode::LLVMValueRef,Index::Uint32)
    ccall((:LLVMGetIncomingValue,libllvm),LLVMValueRef,(LLVMValueRef,Uint32),PhiNode,Index)
end
function LLVMGetIncomingBlock(PhiNode::LLVMValueRef,Index::Uint32)
    ccall((:LLVMGetIncomingBlock,libllvm),LLVMBasicBlockRef,(LLVMValueRef,Uint32),PhiNode,Index)
end
function LLVMCreateBuilderInContext(C::LLVMContextRef)
    ccall((:LLVMCreateBuilderInContext,libllvm),LLVMBuilderRef,(LLVMContextRef,),C)
end
function LLVMCreateBuilder()
    ccall((:LLVMCreateBuilder,libllvm),LLVMBuilderRef,())
end
function LLVMPositionBuilder(Builder::LLVMBuilderRef,Block::LLVMBasicBlockRef,Instr::LLVMValueRef)
    ccall((:LLVMPositionBuilder,libllvm),Void,(LLVMBuilderRef,LLVMBasicBlockRef,LLVMValueRef),Builder,Block,Instr)
end
function LLVMPositionBuilderBefore(Builder::LLVMBuilderRef,Instr::LLVMValueRef)
    ccall((:LLVMPositionBuilderBefore,libllvm),Void,(LLVMBuilderRef,LLVMValueRef),Builder,Instr)
end
function LLVMPositionBuilderAtEnd(Builder::LLVMBuilderRef,Block::LLVMBasicBlockRef)
    ccall((:LLVMPositionBuilderAtEnd,libllvm),Void,(LLVMBuilderRef,LLVMBasicBlockRef),Builder,Block)
end
function LLVMGetInsertBlock(Builder::LLVMBuilderRef)
    ccall((:LLVMGetInsertBlock,libllvm),LLVMBasicBlockRef,(LLVMBuilderRef,),Builder)
end
function LLVMClearInsertionPosition(Builder::LLVMBuilderRef)
    ccall((:LLVMClearInsertionPosition,libllvm),Void,(LLVMBuilderRef,),Builder)
end
function LLVMInsertIntoBuilder(Builder::LLVMBuilderRef,Instr::LLVMValueRef)
    ccall((:LLVMInsertIntoBuilder,libllvm),Void,(LLVMBuilderRef,LLVMValueRef),Builder,Instr)
end
function LLVMInsertIntoBuilderWithName(Builder::LLVMBuilderRef,Instr::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMInsertIntoBuilderWithName,libllvm),Void,(LLVMBuilderRef,LLVMValueRef,Ptr{Uint8}),Builder,Instr,Name)
end
function LLVMDisposeBuilder(Builder::LLVMBuilderRef)
    ccall((:LLVMDisposeBuilder,libllvm),Void,(LLVMBuilderRef,),Builder)
end
function LLVMSetCurrentDebugLocation(Builder::LLVMBuilderRef,L::LLVMValueRef)
    ccall((:LLVMSetCurrentDebugLocation,libllvm),Void,(LLVMBuilderRef,LLVMValueRef),Builder,L)
end
function LLVMGetCurrentDebugLocation(Builder::LLVMBuilderRef)
    ccall((:LLVMGetCurrentDebugLocation,libllvm),LLVMValueRef,(LLVMBuilderRef,),Builder)
end
function LLVMSetInstDebugLocation(Builder::LLVMBuilderRef,Inst::LLVMValueRef)
    ccall((:LLVMSetInstDebugLocation,libllvm),Void,(LLVMBuilderRef,LLVMValueRef),Builder,Inst)
end
function LLVMBuildRetVoid(arg1::LLVMBuilderRef)
    ccall((:LLVMBuildRetVoid,libllvm),LLVMValueRef,(LLVMBuilderRef,),arg1)
end
function LLVMBuildRet(arg1::LLVMBuilderRef,V::LLVMValueRef)
    ccall((:LLVMBuildRet,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef),arg1,V)
end
function LLVMBuildAggregateRet(arg1::LLVMBuilderRef,RetVals::Ptr{LLVMValueRef},N::Uint32)
    ccall((:LLVMBuildAggregateRet,libllvm),LLVMValueRef,(LLVMBuilderRef,Ptr{LLVMValueRef},Uint32),arg1,RetVals,N)
end
function LLVMBuildBr(arg1::LLVMBuilderRef,Dest::LLVMBasicBlockRef)
    ccall((:LLVMBuildBr,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMBasicBlockRef),arg1,Dest)
end
function LLVMBuildCondBr(arg1::LLVMBuilderRef,If::LLVMValueRef,Then::LLVMBasicBlockRef,Else::LLVMBasicBlockRef)
    ccall((:LLVMBuildCondBr,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMBasicBlockRef,LLVMBasicBlockRef),arg1,If,Then,Else)
end
function LLVMBuildSwitch(arg1::LLVMBuilderRef,V::LLVMValueRef,Else::LLVMBasicBlockRef,NumCases::Uint32)
    ccall((:LLVMBuildSwitch,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMBasicBlockRef,Uint32),arg1,V,Else,NumCases)
end
function LLVMBuildIndirectBr(B::LLVMBuilderRef,Addr::LLVMValueRef,NumDests::Uint32)
    ccall((:LLVMBuildIndirectBr,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,Uint32),B,Addr,NumDests)
end
function LLVMBuildInvoke(arg1::LLVMBuilderRef,Fn::LLVMValueRef,Args::Ptr{LLVMValueRef},NumArgs::Uint32,Then::LLVMBasicBlockRef,Catch::LLVMBasicBlockRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildInvoke,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,Ptr{LLVMValueRef},Uint32,LLVMBasicBlockRef,LLVMBasicBlockRef,Ptr{Uint8}),arg1,Fn,Args,NumArgs,Then,Catch,Name)
end
function LLVMBuildLandingPad(B::LLVMBuilderRef,Ty::LLVMTypeRef,PersFn::LLVMValueRef,NumClauses::Uint32,Name::Ptr{Uint8})
    ccall((:LLVMBuildLandingPad,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMTypeRef,LLVMValueRef,Uint32,Ptr{Uint8}),B,Ty,PersFn,NumClauses,Name)
end
function LLVMBuildResume(B::LLVMBuilderRef,Exn::LLVMValueRef)
    ccall((:LLVMBuildResume,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef),B,Exn)
end
function LLVMBuildUnreachable(arg1::LLVMBuilderRef)
    ccall((:LLVMBuildUnreachable,libllvm),LLVMValueRef,(LLVMBuilderRef,),arg1)
end
function LLVMAddCase(Switch::LLVMValueRef,OnVal::LLVMValueRef,Dest::LLVMBasicBlockRef)
    ccall((:LLVMAddCase,libllvm),Void,(LLVMValueRef,LLVMValueRef,LLVMBasicBlockRef),Switch,OnVal,Dest)
end
function LLVMAddDestination(IndirectBr::LLVMValueRef,Dest::LLVMBasicBlockRef)
    ccall((:LLVMAddDestination,libllvm),Void,(LLVMValueRef,LLVMBasicBlockRef),IndirectBr,Dest)
end
function LLVMAddClause(LandingPad::LLVMValueRef,ClauseVal::LLVMValueRef)
    ccall((:LLVMAddClause,libllvm),Void,(LLVMValueRef,LLVMValueRef),LandingPad,ClauseVal)
end
function LLVMSetCleanup(LandingPad::LLVMValueRef,Val::LLVMBool)
    ccall((:LLVMSetCleanup,libllvm),Void,(LLVMValueRef,LLVMBool),LandingPad,Val)
end
function LLVMBuildAdd(arg1::LLVMBuilderRef,LHS::LLVMValueRef,RHS::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildAdd,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMValueRef,Ptr{Uint8}),arg1,LHS,RHS,Name)
end
function LLVMBuildNSWAdd(arg1::LLVMBuilderRef,LHS::LLVMValueRef,RHS::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildNSWAdd,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMValueRef,Ptr{Uint8}),arg1,LHS,RHS,Name)
end
function LLVMBuildNUWAdd(arg1::LLVMBuilderRef,LHS::LLVMValueRef,RHS::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildNUWAdd,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMValueRef,Ptr{Uint8}),arg1,LHS,RHS,Name)
end
function LLVMBuildFAdd(arg1::LLVMBuilderRef,LHS::LLVMValueRef,RHS::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildFAdd,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMValueRef,Ptr{Uint8}),arg1,LHS,RHS,Name)
end
function LLVMBuildSub(arg1::LLVMBuilderRef,LHS::LLVMValueRef,RHS::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildSub,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMValueRef,Ptr{Uint8}),arg1,LHS,RHS,Name)
end
function LLVMBuildNSWSub(arg1::LLVMBuilderRef,LHS::LLVMValueRef,RHS::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildNSWSub,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMValueRef,Ptr{Uint8}),arg1,LHS,RHS,Name)
end
function LLVMBuildNUWSub(arg1::LLVMBuilderRef,LHS::LLVMValueRef,RHS::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildNUWSub,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMValueRef,Ptr{Uint8}),arg1,LHS,RHS,Name)
end
function LLVMBuildFSub(arg1::LLVMBuilderRef,LHS::LLVMValueRef,RHS::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildFSub,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMValueRef,Ptr{Uint8}),arg1,LHS,RHS,Name)
end
function LLVMBuildMul(arg1::LLVMBuilderRef,LHS::LLVMValueRef,RHS::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildMul,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMValueRef,Ptr{Uint8}),arg1,LHS,RHS,Name)
end
function LLVMBuildNSWMul(arg1::LLVMBuilderRef,LHS::LLVMValueRef,RHS::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildNSWMul,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMValueRef,Ptr{Uint8}),arg1,LHS,RHS,Name)
end
function LLVMBuildNUWMul(arg1::LLVMBuilderRef,LHS::LLVMValueRef,RHS::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildNUWMul,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMValueRef,Ptr{Uint8}),arg1,LHS,RHS,Name)
end
function LLVMBuildFMul(arg1::LLVMBuilderRef,LHS::LLVMValueRef,RHS::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildFMul,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMValueRef,Ptr{Uint8}),arg1,LHS,RHS,Name)
end
function LLVMBuildUDiv(arg1::LLVMBuilderRef,LHS::LLVMValueRef,RHS::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildUDiv,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMValueRef,Ptr{Uint8}),arg1,LHS,RHS,Name)
end
function LLVMBuildSDiv(arg1::LLVMBuilderRef,LHS::LLVMValueRef,RHS::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildSDiv,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMValueRef,Ptr{Uint8}),arg1,LHS,RHS,Name)
end
function LLVMBuildExactSDiv(arg1::LLVMBuilderRef,LHS::LLVMValueRef,RHS::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildExactSDiv,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMValueRef,Ptr{Uint8}),arg1,LHS,RHS,Name)
end
function LLVMBuildFDiv(arg1::LLVMBuilderRef,LHS::LLVMValueRef,RHS::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildFDiv,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMValueRef,Ptr{Uint8}),arg1,LHS,RHS,Name)
end
function LLVMBuildURem(arg1::LLVMBuilderRef,LHS::LLVMValueRef,RHS::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildURem,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMValueRef,Ptr{Uint8}),arg1,LHS,RHS,Name)
end
function LLVMBuildSRem(arg1::LLVMBuilderRef,LHS::LLVMValueRef,RHS::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildSRem,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMValueRef,Ptr{Uint8}),arg1,LHS,RHS,Name)
end
function LLVMBuildFRem(arg1::LLVMBuilderRef,LHS::LLVMValueRef,RHS::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildFRem,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMValueRef,Ptr{Uint8}),arg1,LHS,RHS,Name)
end
function LLVMBuildShl(arg1::LLVMBuilderRef,LHS::LLVMValueRef,RHS::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildShl,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMValueRef,Ptr{Uint8}),arg1,LHS,RHS,Name)
end
function LLVMBuildLShr(arg1::LLVMBuilderRef,LHS::LLVMValueRef,RHS::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildLShr,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMValueRef,Ptr{Uint8}),arg1,LHS,RHS,Name)
end
function LLVMBuildAShr(arg1::LLVMBuilderRef,LHS::LLVMValueRef,RHS::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildAShr,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMValueRef,Ptr{Uint8}),arg1,LHS,RHS,Name)
end
function LLVMBuildAnd(arg1::LLVMBuilderRef,LHS::LLVMValueRef,RHS::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildAnd,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMValueRef,Ptr{Uint8}),arg1,LHS,RHS,Name)
end
function LLVMBuildOr(arg1::LLVMBuilderRef,LHS::LLVMValueRef,RHS::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildOr,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMValueRef,Ptr{Uint8}),arg1,LHS,RHS,Name)
end
function LLVMBuildXor(arg1::LLVMBuilderRef,LHS::LLVMValueRef,RHS::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildXor,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMValueRef,Ptr{Uint8}),arg1,LHS,RHS,Name)
end
function LLVMBuildBinOp(B::LLVMBuilderRef,Op::LLVMOpcode,LHS::LLVMValueRef,RHS::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildBinOp,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMOpcode,LLVMValueRef,LLVMValueRef,Ptr{Uint8}),B,Op,LHS,RHS,Name)
end
function LLVMBuildNeg(arg1::LLVMBuilderRef,V::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildNeg,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,Ptr{Uint8}),arg1,V,Name)
end
function LLVMBuildNSWNeg(B::LLVMBuilderRef,V::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildNSWNeg,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,Ptr{Uint8}),B,V,Name)
end
function LLVMBuildNUWNeg(B::LLVMBuilderRef,V::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildNUWNeg,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,Ptr{Uint8}),B,V,Name)
end
function LLVMBuildFNeg(arg1::LLVMBuilderRef,V::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildFNeg,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,Ptr{Uint8}),arg1,V,Name)
end
function LLVMBuildNot(arg1::LLVMBuilderRef,V::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildNot,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,Ptr{Uint8}),arg1,V,Name)
end
function LLVMBuildMalloc(arg1::LLVMBuilderRef,Ty::LLVMTypeRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildMalloc,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMTypeRef,Ptr{Uint8}),arg1,Ty,Name)
end
function LLVMBuildArrayMalloc(arg1::LLVMBuilderRef,Ty::LLVMTypeRef,Val::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildArrayMalloc,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMTypeRef,LLVMValueRef,Ptr{Uint8}),arg1,Ty,Val,Name)
end
function LLVMBuildAlloca(arg1::LLVMBuilderRef,Ty::LLVMTypeRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildAlloca,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMTypeRef,Ptr{Uint8}),arg1,Ty,Name)
end
function LLVMBuildArrayAlloca(arg1::LLVMBuilderRef,Ty::LLVMTypeRef,Val::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildArrayAlloca,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMTypeRef,LLVMValueRef,Ptr{Uint8}),arg1,Ty,Val,Name)
end
function LLVMBuildFree(arg1::LLVMBuilderRef,PointerVal::LLVMValueRef)
    ccall((:LLVMBuildFree,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef),arg1,PointerVal)
end
function LLVMBuildLoad(arg1::LLVMBuilderRef,PointerVal::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildLoad,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,Ptr{Uint8}),arg1,PointerVal,Name)
end
function LLVMBuildStore(arg1::LLVMBuilderRef,Val::LLVMValueRef,Ptr::LLVMValueRef)
    ccall((:LLVMBuildStore,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMValueRef),arg1,Val,Ptr)
end
function LLVMBuildGEP(B::LLVMBuilderRef,Pointer::LLVMValueRef,Indices::Ptr{LLVMValueRef},NumIndices::Uint32,Name::Ptr{Uint8})
    ccall((:LLVMBuildGEP,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,Ptr{LLVMValueRef},Uint32,Ptr{Uint8}),B,Pointer,Indices,NumIndices,Name)
end
function LLVMBuildInBoundsGEP(B::LLVMBuilderRef,Pointer::LLVMValueRef,Indices::Ptr{LLVMValueRef},NumIndices::Uint32,Name::Ptr{Uint8})
    ccall((:LLVMBuildInBoundsGEP,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,Ptr{LLVMValueRef},Uint32,Ptr{Uint8}),B,Pointer,Indices,NumIndices,Name)
end
function LLVMBuildStructGEP(B::LLVMBuilderRef,Pointer::LLVMValueRef,Idx::Uint32,Name::Ptr{Uint8})
    ccall((:LLVMBuildStructGEP,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,Uint32,Ptr{Uint8}),B,Pointer,Idx,Name)
end
function LLVMBuildGlobalString(B::LLVMBuilderRef,Str::Ptr{Uint8},Name::Ptr{Uint8})
    ccall((:LLVMBuildGlobalString,libllvm),LLVMValueRef,(LLVMBuilderRef,Ptr{Uint8},Ptr{Uint8}),B,Str,Name)
end
function LLVMBuildGlobalStringPtr(B::LLVMBuilderRef,Str::Ptr{Uint8},Name::Ptr{Uint8})
    ccall((:LLVMBuildGlobalStringPtr,libllvm),LLVMValueRef,(LLVMBuilderRef,Ptr{Uint8},Ptr{Uint8}),B,Str,Name)
end
function LLVMGetVolatile(MemoryAccessInst::LLVMValueRef)
    ccall((:LLVMGetVolatile,libllvm),LLVMBool,(LLVMValueRef,),MemoryAccessInst)
end
function LLVMSetVolatile(MemoryAccessInst::LLVMValueRef,IsVolatile::LLVMBool)
    ccall((:LLVMSetVolatile,libllvm),Void,(LLVMValueRef,LLVMBool),MemoryAccessInst,IsVolatile)
end
function LLVMBuildTrunc(arg1::LLVMBuilderRef,Val::LLVMValueRef,DestTy::LLVMTypeRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildTrunc,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMTypeRef,Ptr{Uint8}),arg1,Val,DestTy,Name)
end
function LLVMBuildZExt(arg1::LLVMBuilderRef,Val::LLVMValueRef,DestTy::LLVMTypeRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildZExt,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMTypeRef,Ptr{Uint8}),arg1,Val,DestTy,Name)
end
function LLVMBuildSExt(arg1::LLVMBuilderRef,Val::LLVMValueRef,DestTy::LLVMTypeRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildSExt,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMTypeRef,Ptr{Uint8}),arg1,Val,DestTy,Name)
end
function LLVMBuildFPToUI(arg1::LLVMBuilderRef,Val::LLVMValueRef,DestTy::LLVMTypeRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildFPToUI,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMTypeRef,Ptr{Uint8}),arg1,Val,DestTy,Name)
end
function LLVMBuildFPToSI(arg1::LLVMBuilderRef,Val::LLVMValueRef,DestTy::LLVMTypeRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildFPToSI,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMTypeRef,Ptr{Uint8}),arg1,Val,DestTy,Name)
end
function LLVMBuildUIToFP(arg1::LLVMBuilderRef,Val::LLVMValueRef,DestTy::LLVMTypeRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildUIToFP,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMTypeRef,Ptr{Uint8}),arg1,Val,DestTy,Name)
end
function LLVMBuildSIToFP(arg1::LLVMBuilderRef,Val::LLVMValueRef,DestTy::LLVMTypeRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildSIToFP,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMTypeRef,Ptr{Uint8}),arg1,Val,DestTy,Name)
end
function LLVMBuildFPTrunc(arg1::LLVMBuilderRef,Val::LLVMValueRef,DestTy::LLVMTypeRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildFPTrunc,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMTypeRef,Ptr{Uint8}),arg1,Val,DestTy,Name)
end
function LLVMBuildFPExt(arg1::LLVMBuilderRef,Val::LLVMValueRef,DestTy::LLVMTypeRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildFPExt,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMTypeRef,Ptr{Uint8}),arg1,Val,DestTy,Name)
end
function LLVMBuildPtrToInt(arg1::LLVMBuilderRef,Val::LLVMValueRef,DestTy::LLVMTypeRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildPtrToInt,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMTypeRef,Ptr{Uint8}),arg1,Val,DestTy,Name)
end
function LLVMBuildIntToPtr(arg1::LLVMBuilderRef,Val::LLVMValueRef,DestTy::LLVMTypeRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildIntToPtr,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMTypeRef,Ptr{Uint8}),arg1,Val,DestTy,Name)
end
function LLVMBuildBitCast(arg1::LLVMBuilderRef,Val::LLVMValueRef,DestTy::LLVMTypeRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildBitCast,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMTypeRef,Ptr{Uint8}),arg1,Val,DestTy,Name)
end
function LLVMBuildAddrSpaceCast(arg1::LLVMBuilderRef,Val::LLVMValueRef,DestTy::LLVMTypeRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildAddrSpaceCast,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMTypeRef,Ptr{Uint8}),arg1,Val,DestTy,Name)
end
function LLVMBuildZExtOrBitCast(arg1::LLVMBuilderRef,Val::LLVMValueRef,DestTy::LLVMTypeRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildZExtOrBitCast,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMTypeRef,Ptr{Uint8}),arg1,Val,DestTy,Name)
end
function LLVMBuildSExtOrBitCast(arg1::LLVMBuilderRef,Val::LLVMValueRef,DestTy::LLVMTypeRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildSExtOrBitCast,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMTypeRef,Ptr{Uint8}),arg1,Val,DestTy,Name)
end
function LLVMBuildTruncOrBitCast(arg1::LLVMBuilderRef,Val::LLVMValueRef,DestTy::LLVMTypeRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildTruncOrBitCast,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMTypeRef,Ptr{Uint8}),arg1,Val,DestTy,Name)
end
function LLVMBuildCast(B::LLVMBuilderRef,Op::LLVMOpcode,Val::LLVMValueRef,DestTy::LLVMTypeRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildCast,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMOpcode,LLVMValueRef,LLVMTypeRef,Ptr{Uint8}),B,Op,Val,DestTy,Name)
end
function LLVMBuildPointerCast(arg1::LLVMBuilderRef,Val::LLVMValueRef,DestTy::LLVMTypeRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildPointerCast,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMTypeRef,Ptr{Uint8}),arg1,Val,DestTy,Name)
end
function LLVMBuildIntCast(arg1::LLVMBuilderRef,Val::LLVMValueRef,DestTy::LLVMTypeRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildIntCast,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMTypeRef,Ptr{Uint8}),arg1,Val,DestTy,Name)
end
function LLVMBuildFPCast(arg1::LLVMBuilderRef,Val::LLVMValueRef,DestTy::LLVMTypeRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildFPCast,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMTypeRef,Ptr{Uint8}),arg1,Val,DestTy,Name)
end
function LLVMBuildICmp(arg1::LLVMBuilderRef,Op::LLVMIntPredicate,LHS::LLVMValueRef,RHS::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildICmp,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMIntPredicate,LLVMValueRef,LLVMValueRef,Ptr{Uint8}),arg1,Op,LHS,RHS,Name)
end
function LLVMBuildFCmp(arg1::LLVMBuilderRef,Op::LLVMRealPredicate,LHS::LLVMValueRef,RHS::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildFCmp,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMRealPredicate,LLVMValueRef,LLVMValueRef,Ptr{Uint8}),arg1,Op,LHS,RHS,Name)
end
function LLVMBuildPhi(arg1::LLVMBuilderRef,Ty::LLVMTypeRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildPhi,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMTypeRef,Ptr{Uint8}),arg1,Ty,Name)
end
function LLVMBuildCall(arg1::LLVMBuilderRef,Fn::LLVMValueRef,Args::Ptr{LLVMValueRef},NumArgs::Uint32,Name::Ptr{Uint8})
    ccall((:LLVMBuildCall,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,Ptr{LLVMValueRef},Uint32,Ptr{Uint8}),arg1,Fn,Args,NumArgs,Name)
end
function LLVMBuildSelect(arg1::LLVMBuilderRef,If::LLVMValueRef,Then::LLVMValueRef,Else::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildSelect,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMValueRef,LLVMValueRef,Ptr{Uint8}),arg1,If,Then,Else,Name)
end
function LLVMBuildVAArg(arg1::LLVMBuilderRef,List::LLVMValueRef,Ty::LLVMTypeRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildVAArg,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMTypeRef,Ptr{Uint8}),arg1,List,Ty,Name)
end
function LLVMBuildExtractElement(arg1::LLVMBuilderRef,VecVal::LLVMValueRef,Index::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildExtractElement,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMValueRef,Ptr{Uint8}),arg1,VecVal,Index,Name)
end
function LLVMBuildInsertElement(arg1::LLVMBuilderRef,VecVal::LLVMValueRef,EltVal::LLVMValueRef,Index::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildInsertElement,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMValueRef,LLVMValueRef,Ptr{Uint8}),arg1,VecVal,EltVal,Index,Name)
end
function LLVMBuildShuffleVector(arg1::LLVMBuilderRef,V1::LLVMValueRef,V2::LLVMValueRef,Mask::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildShuffleVector,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMValueRef,LLVMValueRef,Ptr{Uint8}),arg1,V1,V2,Mask,Name)
end
function LLVMBuildExtractValue(arg1::LLVMBuilderRef,AggVal::LLVMValueRef,Index::Uint32,Name::Ptr{Uint8})
    ccall((:LLVMBuildExtractValue,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,Uint32,Ptr{Uint8}),arg1,AggVal,Index,Name)
end
function LLVMBuildInsertValue(arg1::LLVMBuilderRef,AggVal::LLVMValueRef,EltVal::LLVMValueRef,Index::Uint32,Name::Ptr{Uint8})
    ccall((:LLVMBuildInsertValue,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMValueRef,Uint32,Ptr{Uint8}),arg1,AggVal,EltVal,Index,Name)
end
function LLVMBuildIsNull(arg1::LLVMBuilderRef,Val::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildIsNull,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,Ptr{Uint8}),arg1,Val,Name)
end
function LLVMBuildIsNotNull(arg1::LLVMBuilderRef,Val::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildIsNotNull,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,Ptr{Uint8}),arg1,Val,Name)
end
function LLVMBuildPtrDiff(arg1::LLVMBuilderRef,LHS::LLVMValueRef,RHS::LLVMValueRef,Name::Ptr{Uint8})
    ccall((:LLVMBuildPtrDiff,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMValueRef,LLVMValueRef,Ptr{Uint8}),arg1,LHS,RHS,Name)
end
function LLVMBuildFence(B::LLVMBuilderRef,ordering::LLVMAtomicOrdering,singleThread::LLVMBool,Name::Ptr{Uint8})
    ccall((:LLVMBuildFence,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMAtomicOrdering,LLVMBool,Ptr{Uint8}),B,ordering,singleThread,Name)
end
function LLVMBuildAtomicRMW(B::LLVMBuilderRef,op::LLVMAtomicRMWBinOp,PTR::LLVMValueRef,Val::LLVMValueRef,ordering::LLVMAtomicOrdering,singleThread::LLVMBool)
    ccall((:LLVMBuildAtomicRMW,libllvm),LLVMValueRef,(LLVMBuilderRef,LLVMAtomicRMWBinOp,LLVMValueRef,LLVMValueRef,LLVMAtomicOrdering,LLVMBool),B,op,PTR,Val,ordering,singleThread)
end
function LLVMCreateModuleProviderForExistingModule(M::LLVMModuleRef)
    ccall((:LLVMCreateModuleProviderForExistingModule,libllvm),LLVMModuleProviderRef,(LLVMModuleRef,),M)
end
function LLVMDisposeModuleProvider(M::LLVMModuleProviderRef)
    ccall((:LLVMDisposeModuleProvider,libllvm),Void,(LLVMModuleProviderRef,),M)
end
function LLVMCreateMemoryBufferWithContentsOfFile(Path::Ptr{Uint8},OutMemBuf::Ptr{LLVMMemoryBufferRef},OutMessage::Ptr{Ptr{Uint8}})
    ccall((:LLVMCreateMemoryBufferWithContentsOfFile,libllvm),LLVMBool,(Ptr{Uint8},Ptr{LLVMMemoryBufferRef},Ptr{Ptr{Uint8}}),Path,OutMemBuf,OutMessage)
end
function LLVMCreateMemoryBufferWithSTDIN(OutMemBuf::Ptr{LLVMMemoryBufferRef},OutMessage::Ptr{Ptr{Uint8}})
    ccall((:LLVMCreateMemoryBufferWithSTDIN,libllvm),LLVMBool,(Ptr{LLVMMemoryBufferRef},Ptr{Ptr{Uint8}}),OutMemBuf,OutMessage)
end
function LLVMCreateMemoryBufferWithMemoryRange(InputData::Ptr{Uint8},InputDataLength::Cint,BufferName::Ptr{Uint8},RequiresNullTerminator::LLVMBool)
    ccall((:LLVMCreateMemoryBufferWithMemoryRange,libllvm),LLVMMemoryBufferRef,(Ptr{Uint8},Cint,Ptr{Uint8},LLVMBool),InputData,InputDataLength,BufferName,RequiresNullTerminator)
end
function LLVMCreateMemoryBufferWithMemoryRangeCopy(InputData::Ptr{Uint8},InputDataLength::Cint,BufferName::Ptr{Uint8})
    ccall((:LLVMCreateMemoryBufferWithMemoryRangeCopy,libllvm),LLVMMemoryBufferRef,(Ptr{Uint8},Cint,Ptr{Uint8}),InputData,InputDataLength,BufferName)
end
function LLVMGetBufferStart(MemBuf::LLVMMemoryBufferRef)
    ccall((:LLVMGetBufferStart,libllvm),Ptr{Uint8},(LLVMMemoryBufferRef,),MemBuf)
end
function LLVMGetBufferSize()
    ccall((:LLVMGetBufferSize,libllvm),Cint,())
end
function LLVMDisposeMemoryBuffer(MemBuf::LLVMMemoryBufferRef)
    ccall((:LLVMDisposeMemoryBuffer,libllvm),Void,(LLVMMemoryBufferRef,),MemBuf)
end
function LLVMGetGlobalPassRegistry()
    ccall((:LLVMGetGlobalPassRegistry,libllvm),LLVMPassRegistryRef,())
end
function LLVMCreatePassManager()
    ccall((:LLVMCreatePassManager,libllvm),LLVMPassManagerRef,())
end
function LLVMCreateFunctionPassManagerForModule(M::LLVMModuleRef)
    ccall((:LLVMCreateFunctionPassManagerForModule,libllvm),LLVMPassManagerRef,(LLVMModuleRef,),M)
end
function LLVMCreateFunctionPassManager(MP::LLVMModuleProviderRef)
    ccall((:LLVMCreateFunctionPassManager,libllvm),LLVMPassManagerRef,(LLVMModuleProviderRef,),MP)
end
function LLVMRunPassManager(PM::LLVMPassManagerRef,M::LLVMModuleRef)
    ccall((:LLVMRunPassManager,libllvm),LLVMBool,(LLVMPassManagerRef,LLVMModuleRef),PM,M)
end
function LLVMInitializeFunctionPassManager(FPM::LLVMPassManagerRef)
    ccall((:LLVMInitializeFunctionPassManager,libllvm),LLVMBool,(LLVMPassManagerRef,),FPM)
end
function LLVMRunFunctionPassManager(FPM::LLVMPassManagerRef,F::LLVMValueRef)
    ccall((:LLVMRunFunctionPassManager,libllvm),LLVMBool,(LLVMPassManagerRef,LLVMValueRef),FPM,F)
end
function LLVMFinalizeFunctionPassManager(FPM::LLVMPassManagerRef)
    ccall((:LLVMFinalizeFunctionPassManager,libllvm),LLVMBool,(LLVMPassManagerRef,),FPM)
end
function LLVMDisposePassManager(PM::LLVMPassManagerRef)
    ccall((:LLVMDisposePassManager,libllvm),Void,(LLVMPassManagerRef,),PM)
end
function LLVMStartMultithreaded()
    ccall((:LLVMStartMultithreaded,libllvm),LLVMBool,())
end
function LLVMStopMultithreaded()
    ccall((:LLVMStopMultithreaded,libllvm),Void,())
end
function LLVMIsMultithreaded()
    ccall((:LLVMIsMultithreaded,libllvm),LLVMBool,())
end
# Julia wrapper for header: /cmn/jldev/deps/llvm-svn/include/llvm-c/TargetMachine.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function LLVMInitializeAllTargetInfos()
    ccall((:LLVMInitializeAllTargetInfos,libllvm),Void,())
end
function LLVMInitializeAllTargets()
    ccall((:LLVMInitializeAllTargets,libllvm),Void,())
end
function LLVMInitializeAllTargetMCs()
    ccall((:LLVMInitializeAllTargetMCs,libllvm),Void,())
end
function LLVMInitializeAllAsmPrinters()
    ccall((:LLVMInitializeAllAsmPrinters,libllvm),Void,())
end
function LLVMInitializeAllAsmParsers()
    ccall((:LLVMInitializeAllAsmParsers,libllvm),Void,())
end
function LLVMInitializeAllDisassemblers()
    ccall((:LLVMInitializeAllDisassemblers,libllvm),Void,())
end
function LLVMInitializeNativeTarget()
    ccall((:LLVMInitializeNativeTarget,libllvm),LLVMBool,())
end
function LLVMInitializeNativeAsmParser()
    ccall((:LLVMInitializeNativeAsmParser,libllvm),LLVMBool,())
end
function LLVMInitializeNativeAsmPrinter()
    ccall((:LLVMInitializeNativeAsmPrinter,libllvm),LLVMBool,())
end
function LLVMInitializeNativeDisassembler()
    ccall((:LLVMInitializeNativeDisassembler,libllvm),LLVMBool,())
end
function LLVMCreateTargetData(StringRep::Ptr{Uint8})
    ccall((:LLVMCreateTargetData,libllvm),LLVMTargetDataRef,(Ptr{Uint8},),StringRep)
end
function LLVMAddTargetData(TD::LLVMTargetDataRef,PM::LLVMPassManagerRef)
    ccall((:LLVMAddTargetData,libllvm),Void,(LLVMTargetDataRef,LLVMPassManagerRef),TD,PM)
end
function LLVMAddTargetLibraryInfo(TLI::LLVMTargetLibraryInfoRef,PM::LLVMPassManagerRef)
    ccall((:LLVMAddTargetLibraryInfo,libllvm),Void,(LLVMTargetLibraryInfoRef,LLVMPassManagerRef),TLI,PM)
end
function LLVMCopyStringRepOfTargetData(TD::LLVMTargetDataRef)
    ccall((:LLVMCopyStringRepOfTargetData,libllvm),Ptr{Uint8},(LLVMTargetDataRef,),TD)
end
function LLVMByteOrder(TD::LLVMTargetDataRef)
    ccall((:LLVMByteOrder,libllvm),Cint,(LLVMTargetDataRef,),TD)
end
function LLVMPointerSize(TD::LLVMTargetDataRef)
    ccall((:LLVMPointerSize,libllvm),Uint32,(LLVMTargetDataRef,),TD)
end
function LLVMPointerSizeForAS(TD::LLVMTargetDataRef,AS::Uint32)
    ccall((:LLVMPointerSizeForAS,libllvm),Uint32,(LLVMTargetDataRef,Uint32),TD,AS)
end
function LLVMIntPtrType(TD::LLVMTargetDataRef)
    ccall((:LLVMIntPtrType,libllvm),LLVMTypeRef,(LLVMTargetDataRef,),TD)
end
function LLVMIntPtrTypeForAS(TD::LLVMTargetDataRef,AS::Uint32)
    ccall((:LLVMIntPtrTypeForAS,libllvm),LLVMTypeRef,(LLVMTargetDataRef,Uint32),TD,AS)
end
function LLVMIntPtrTypeInContext(C::LLVMContextRef,TD::LLVMTargetDataRef)
    ccall((:LLVMIntPtrTypeInContext,libllvm),LLVMTypeRef,(LLVMContextRef,LLVMTargetDataRef),C,TD)
end
function LLVMIntPtrTypeForASInContext(C::LLVMContextRef,TD::LLVMTargetDataRef,AS::Uint32)
    ccall((:LLVMIntPtrTypeForASInContext,libllvm),LLVMTypeRef,(LLVMContextRef,LLVMTargetDataRef,Uint32),C,TD,AS)
end
function LLVMSizeOfTypeInBits(TD::LLVMTargetDataRef,Ty::LLVMTypeRef)
    ccall((:LLVMSizeOfTypeInBits,libllvm),Culonglong,(LLVMTargetDataRef,LLVMTypeRef),TD,Ty)
end
function LLVMStoreSizeOfType(TD::LLVMTargetDataRef,Ty::LLVMTypeRef)
    ccall((:LLVMStoreSizeOfType,libllvm),Culonglong,(LLVMTargetDataRef,LLVMTypeRef),TD,Ty)
end
function LLVMABISizeOfType(TD::LLVMTargetDataRef,Ty::LLVMTypeRef)
    ccall((:LLVMABISizeOfType,libllvm),Culonglong,(LLVMTargetDataRef,LLVMTypeRef),TD,Ty)
end
function LLVMABIAlignmentOfType(TD::LLVMTargetDataRef,Ty::LLVMTypeRef)
    ccall((:LLVMABIAlignmentOfType,libllvm),Uint32,(LLVMTargetDataRef,LLVMTypeRef),TD,Ty)
end
function LLVMCallFrameAlignmentOfType(TD::LLVMTargetDataRef,Ty::LLVMTypeRef)
    ccall((:LLVMCallFrameAlignmentOfType,libllvm),Uint32,(LLVMTargetDataRef,LLVMTypeRef),TD,Ty)
end
function LLVMPreferredAlignmentOfType(TD::LLVMTargetDataRef,Ty::LLVMTypeRef)
    ccall((:LLVMPreferredAlignmentOfType,libllvm),Uint32,(LLVMTargetDataRef,LLVMTypeRef),TD,Ty)
end
function LLVMPreferredAlignmentOfGlobal(TD::LLVMTargetDataRef,GlobalVar::LLVMValueRef)
    ccall((:LLVMPreferredAlignmentOfGlobal,libllvm),Uint32,(LLVMTargetDataRef,LLVMValueRef),TD,GlobalVar)
end
function LLVMElementAtOffset(TD::LLVMTargetDataRef,StructTy::LLVMTypeRef,Offset::Culonglong)
    ccall((:LLVMElementAtOffset,libllvm),Uint32,(LLVMTargetDataRef,LLVMTypeRef,Culonglong),TD,StructTy,Offset)
end
function LLVMOffsetOfElement(TD::LLVMTargetDataRef,StructTy::LLVMTypeRef,Element::Uint32)
    ccall((:LLVMOffsetOfElement,libllvm),Culonglong,(LLVMTargetDataRef,LLVMTypeRef,Uint32),TD,StructTy,Element)
end
function LLVMDisposeTargetData(TD::LLVMTargetDataRef)
    ccall((:LLVMDisposeTargetData,libllvm),Void,(LLVMTargetDataRef,),TD)
end
function LLVMGetFirstTarget()
    ccall((:LLVMGetFirstTarget,libllvm),LLVMTargetRef,())
end
function LLVMGetNextTarget(T::LLVMTargetRef)
    ccall((:LLVMGetNextTarget,libllvm),LLVMTargetRef,(LLVMTargetRef,),T)
end
function LLVMGetTargetFromName(Name::Ptr{Uint8})
    ccall((:LLVMGetTargetFromName,libllvm),LLVMTargetRef,(Ptr{Uint8},),Name)
end
function LLVMGetTargetFromTriple(Triple::Ptr{Uint8},T::Ptr{LLVMTargetRef},ErrorMessage::Ptr{Ptr{Uint8}})
    ccall((:LLVMGetTargetFromTriple,libllvm),LLVMBool,(Ptr{Uint8},Ptr{LLVMTargetRef},Ptr{Ptr{Uint8}}),Triple,T,ErrorMessage)
end
function LLVMGetTargetName(T::LLVMTargetRef)
    ccall((:LLVMGetTargetName,libllvm),Ptr{Uint8},(LLVMTargetRef,),T)
end
function LLVMGetTargetDescription(T::LLVMTargetRef)
    ccall((:LLVMGetTargetDescription,libllvm),Ptr{Uint8},(LLVMTargetRef,),T)
end
function LLVMTargetHasJIT(T::LLVMTargetRef)
    ccall((:LLVMTargetHasJIT,libllvm),LLVMBool,(LLVMTargetRef,),T)
end
function LLVMTargetHasTargetMachine(T::LLVMTargetRef)
    ccall((:LLVMTargetHasTargetMachine,libllvm),LLVMBool,(LLVMTargetRef,),T)
end
function LLVMTargetHasAsmBackend(T::LLVMTargetRef)
    ccall((:LLVMTargetHasAsmBackend,libllvm),LLVMBool,(LLVMTargetRef,),T)
end
function LLVMCreateTargetMachine(T::LLVMTargetRef,Triple::Ptr{Uint8},CPU::Ptr{Uint8},Features::Ptr{Uint8},Level::LLVMCodeGenOptLevel,Reloc::LLVMRelocMode,CodeModel::LLVMCodeModel)
    ccall((:LLVMCreateTargetMachine,libllvm),LLVMTargetMachineRef,(LLVMTargetRef,Ptr{Uint8},Ptr{Uint8},Ptr{Uint8},LLVMCodeGenOptLevel,LLVMRelocMode,LLVMCodeModel),T,Triple,CPU,Features,Level,Reloc,CodeModel)
end
function LLVMDisposeTargetMachine(T::LLVMTargetMachineRef)
    ccall((:LLVMDisposeTargetMachine,libllvm),Void,(LLVMTargetMachineRef,),T)
end
function LLVMGetTargetMachineTarget(T::LLVMTargetMachineRef)
    ccall((:LLVMGetTargetMachineTarget,libllvm),LLVMTargetRef,(LLVMTargetMachineRef,),T)
end
function LLVMGetTargetMachineTriple(T::LLVMTargetMachineRef)
    ccall((:LLVMGetTargetMachineTriple,libllvm),Ptr{Uint8},(LLVMTargetMachineRef,),T)
end
function LLVMGetTargetMachineCPU(T::LLVMTargetMachineRef)
    ccall((:LLVMGetTargetMachineCPU,libllvm),Ptr{Uint8},(LLVMTargetMachineRef,),T)
end
function LLVMGetTargetMachineFeatureString(T::LLVMTargetMachineRef)
    ccall((:LLVMGetTargetMachineFeatureString,libllvm),Ptr{Uint8},(LLVMTargetMachineRef,),T)
end
function LLVMGetTargetMachineData(T::LLVMTargetMachineRef)
    ccall((:LLVMGetTargetMachineData,libllvm),LLVMTargetDataRef,(LLVMTargetMachineRef,),T)
end
function LLVMSetTargetMachineAsmVerbosity(T::LLVMTargetMachineRef,VerboseAsm::LLVMBool)
    ccall((:LLVMSetTargetMachineAsmVerbosity,libllvm),Void,(LLVMTargetMachineRef,LLVMBool),T,VerboseAsm)
end
function LLVMTargetMachineEmitToFile(T::LLVMTargetMachineRef,M::LLVMModuleRef,Filename::Ptr{Uint8},codegen::LLVMCodeGenFileType,ErrorMessage::Ptr{Ptr{Uint8}})
    ccall((:LLVMTargetMachineEmitToFile,libllvm),LLVMBool,(LLVMTargetMachineRef,LLVMModuleRef,Ptr{Uint8},LLVMCodeGenFileType,Ptr{Ptr{Uint8}}),T,M,Filename,codegen,ErrorMessage)
end
function LLVMTargetMachineEmitToMemoryBuffer(T::LLVMTargetMachineRef,M::LLVMModuleRef,codegen::LLVMCodeGenFileType,ErrorMessage::Ptr{Ptr{Uint8}},OutMemBuf::Ptr{LLVMMemoryBufferRef})
    ccall((:LLVMTargetMachineEmitToMemoryBuffer,libllvm),LLVMBool,(LLVMTargetMachineRef,LLVMModuleRef,LLVMCodeGenFileType,Ptr{Ptr{Uint8}},Ptr{LLVMMemoryBufferRef}),T,M,codegen,ErrorMessage,OutMemBuf)
end
function LLVMGetDefaultTargetTriple()
    ccall((:LLVMGetDefaultTargetTriple,libllvm),Ptr{Uint8},())
end
function LLVMAddAnalysisPasses(T::LLVMTargetMachineRef,PM::LLVMPassManagerRef)
    ccall((:LLVMAddAnalysisPasses,libllvm),Void,(LLVMTargetMachineRef,LLVMPassManagerRef),T,PM)
end
# Julia wrapper for header: /cmn/jldev/deps/llvm-svn/include/llvm-c/Target.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


# Julia wrapper for header: /cmn/jldev/deps/llvm-svn/include/llvm-c/Support.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


# Julia wrapper for header: /cmn/jldev/deps/llvm-svn/include/llvm-c/Analysis.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function LLVMVerifyModule(M::LLVMModuleRef,Action::LLVMVerifierFailureAction,OutMessage::Ptr{Ptr{Uint8}})
    ccall((:LLVMVerifyModule,libllvm),LLVMBool,(LLVMModuleRef,LLVMVerifierFailureAction,Ptr{Ptr{Uint8}}),M,Action,OutMessage)
end
function LLVMVerifyFunction(Fn::LLVMValueRef,Action::LLVMVerifierFailureAction)
    ccall((:LLVMVerifyFunction,libllvm),LLVMBool,(LLVMValueRef,LLVMVerifierFailureAction),Fn,Action)
end
function LLVMViewFunctionCFG(Fn::LLVMValueRef)
    ccall((:LLVMViewFunctionCFG,libllvm),Void,(LLVMValueRef,),Fn)
end
function LLVMViewFunctionCFGOnly(Fn::LLVMValueRef)
    ccall((:LLVMViewFunctionCFGOnly,libllvm),Void,(LLVMValueRef,),Fn)
end
# Julia wrapper for header: /cmn/jldev/deps/llvm-svn/include/llvm-c/Initialization.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function LLVMInitializeTransformUtils(R::LLVMPassRegistryRef)
    ccall((:LLVMInitializeTransformUtils,libllvm),Void,(LLVMPassRegistryRef,),R)
end
function LLVMInitializeScalarOpts(R::LLVMPassRegistryRef)
    ccall((:LLVMInitializeScalarOpts,libllvm),Void,(LLVMPassRegistryRef,),R)
end
function LLVMInitializeObjCARCOpts(R::LLVMPassRegistryRef)
    ccall((:LLVMInitializeObjCARCOpts,libllvm),Void,(LLVMPassRegistryRef,),R)
end
function LLVMInitializeVectorization(R::LLVMPassRegistryRef)
    ccall((:LLVMInitializeVectorization,libllvm),Void,(LLVMPassRegistryRef,),R)
end
function LLVMInitializeInstCombine(R::LLVMPassRegistryRef)
    ccall((:LLVMInitializeInstCombine,libllvm),Void,(LLVMPassRegistryRef,),R)
end
function LLVMInitializeIPO(R::LLVMPassRegistryRef)
    ccall((:LLVMInitializeIPO,libllvm),Void,(LLVMPassRegistryRef,),R)
end
function LLVMInitializeInstrumentation(R::LLVMPassRegistryRef)
    ccall((:LLVMInitializeInstrumentation,libllvm),Void,(LLVMPassRegistryRef,),R)
end
function LLVMInitializeAnalysis(R::LLVMPassRegistryRef)
    ccall((:LLVMInitializeAnalysis,libllvm),Void,(LLVMPassRegistryRef,),R)
end
function LLVMInitializeIPA(R::LLVMPassRegistryRef)
    ccall((:LLVMInitializeIPA,libllvm),Void,(LLVMPassRegistryRef,),R)
end
function LLVMInitializeCodeGen(R::LLVMPassRegistryRef)
    ccall((:LLVMInitializeCodeGen,libllvm),Void,(LLVMPassRegistryRef,),R)
end
function LLVMInitializeTarget(R::LLVMPassRegistryRef)
    ccall((:LLVMInitializeTarget,libllvm),Void,(LLVMPassRegistryRef,),R)
end
# Julia wrapper for header: /cmn/jldev/deps/llvm-svn/include/llvm-c/BitWriter.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function LLVMWriteBitcodeToFile(M::LLVMModuleRef,Path::Ptr{Uint8})
    ccall((:LLVMWriteBitcodeToFile,libllvm),Cint,(LLVMModuleRef,Ptr{Uint8}),M,Path)
end
function LLVMWriteBitcodeToFD(M::LLVMModuleRef,FD::Cint,ShouldClose::Cint,Unbuffered::Cint)
    ccall((:LLVMWriteBitcodeToFD,libllvm),Cint,(LLVMModuleRef,Cint,Cint,Cint),M,FD,ShouldClose,Unbuffered)
end
function LLVMWriteBitcodeToFileHandle(M::LLVMModuleRef,Handle::Cint)
    ccall((:LLVMWriteBitcodeToFileHandle,libllvm),Cint,(LLVMModuleRef,Cint),M,Handle)
end
# Julia wrapper for header: /cmn/jldev/deps/llvm-svn/include/llvm-c/Linker.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function LLVMLinkModules(Dest::LLVMModuleRef,Src::LLVMModuleRef,Mode::LLVMLinkerMode,OutMessage::Ptr{Ptr{Uint8}})
    ccall((:LLVMLinkModules,libllvm),LLVMBool,(LLVMModuleRef,LLVMModuleRef,LLVMLinkerMode,Ptr{Ptr{Uint8}}),Dest,Src,Mode,OutMessage)
end
# Julia wrapper for header: /cmn/jldev/deps/llvm-svn/include/llvm-c/LinkTimeOptimizer.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function llvm_create_optimizer()
    ccall((:llvm_create_optimizer,libllvm),llvm_lto_t,())
end
function llvm_destroy_optimizer(lto::llvm_lto_t)
    ccall((:llvm_destroy_optimizer,libllvm),Void,(llvm_lto_t,),lto)
end
function llvm_read_object_file(lto::llvm_lto_t,input_filename::Ptr{Uint8})
    ccall((:llvm_read_object_file,libllvm),llvm_lto_status_t,(llvm_lto_t,Ptr{Uint8}),lto,input_filename)
end
function llvm_optimize_modules(lto::llvm_lto_t,output_filename::Ptr{Uint8})
    ccall((:llvm_optimize_modules,libllvm),llvm_lto_status_t,(llvm_lto_t,Ptr{Uint8}),lto,output_filename)
end
# Julia wrapper for header: /cmn/jldev/deps/llvm-svn/include/llvm-c/Object.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function LLVMCreateObjectFile(MemBuf::LLVMMemoryBufferRef)
    ccall((:LLVMCreateObjectFile,libllvm),LLVMObjectFileRef,(LLVMMemoryBufferRef,),MemBuf)
end
function LLVMDisposeObjectFile(ObjectFile::LLVMObjectFileRef)
    ccall((:LLVMDisposeObjectFile,libllvm),Void,(LLVMObjectFileRef,),ObjectFile)
end
function LLVMGetSections(ObjectFile::LLVMObjectFileRef)
    ccall((:LLVMGetSections,libllvm),LLVMSectionIteratorRef,(LLVMObjectFileRef,),ObjectFile)
end
function LLVMDisposeSectionIterator(SI::LLVMSectionIteratorRef)
    ccall((:LLVMDisposeSectionIterator,libllvm),Void,(LLVMSectionIteratorRef,),SI)
end
function LLVMIsSectionIteratorAtEnd(ObjectFile::LLVMObjectFileRef,SI::LLVMSectionIteratorRef)
    ccall((:LLVMIsSectionIteratorAtEnd,libllvm),LLVMBool,(LLVMObjectFileRef,LLVMSectionIteratorRef),ObjectFile,SI)
end
function LLVMMoveToNextSection(SI::LLVMSectionIteratorRef)
    ccall((:LLVMMoveToNextSection,libllvm),Void,(LLVMSectionIteratorRef,),SI)
end
function LLVMMoveToContainingSection(Sect::LLVMSectionIteratorRef,Sym::LLVMSymbolIteratorRef)
    ccall((:LLVMMoveToContainingSection,libllvm),Void,(LLVMSectionIteratorRef,LLVMSymbolIteratorRef),Sect,Sym)
end
function LLVMGetSymbols(ObjectFile::LLVMObjectFileRef)
    ccall((:LLVMGetSymbols,libllvm),LLVMSymbolIteratorRef,(LLVMObjectFileRef,),ObjectFile)
end
function LLVMDisposeSymbolIterator(SI::LLVMSymbolIteratorRef)
    ccall((:LLVMDisposeSymbolIterator,libllvm),Void,(LLVMSymbolIteratorRef,),SI)
end
function LLVMIsSymbolIteratorAtEnd(ObjectFile::LLVMObjectFileRef,SI::LLVMSymbolIteratorRef)
    ccall((:LLVMIsSymbolIteratorAtEnd,libllvm),LLVMBool,(LLVMObjectFileRef,LLVMSymbolIteratorRef),ObjectFile,SI)
end
function LLVMMoveToNextSymbol(SI::LLVMSymbolIteratorRef)
    ccall((:LLVMMoveToNextSymbol,libllvm),Void,(LLVMSymbolIteratorRef,),SI)
end
function LLVMGetSectionName(SI::LLVMSectionIteratorRef)
    ccall((:LLVMGetSectionName,libllvm),Ptr{Uint8},(LLVMSectionIteratorRef,),SI)
end
function LLVMGetSectionSize()
    ccall((:LLVMGetSectionSize,libllvm),Cint,())
end
function LLVMGetSectionContents(SI::LLVMSectionIteratorRef)
    ccall((:LLVMGetSectionContents,libllvm),Ptr{Uint8},(LLVMSectionIteratorRef,),SI)
end
function LLVMGetSectionAddress()
    ccall((:LLVMGetSectionAddress,libllvm),Cint,())
end
function LLVMGetSectionContainsSymbol(SI::LLVMSectionIteratorRef,Sym::LLVMSymbolIteratorRef)
    ccall((:LLVMGetSectionContainsSymbol,libllvm),LLVMBool,(LLVMSectionIteratorRef,LLVMSymbolIteratorRef),SI,Sym)
end
function LLVMGetRelocations(Section::LLVMSectionIteratorRef)
    ccall((:LLVMGetRelocations,libllvm),LLVMRelocationIteratorRef,(LLVMSectionIteratorRef,),Section)
end
function LLVMDisposeRelocationIterator(RI::LLVMRelocationIteratorRef)
    ccall((:LLVMDisposeRelocationIterator,libllvm),Void,(LLVMRelocationIteratorRef,),RI)
end
function LLVMIsRelocationIteratorAtEnd(Section::LLVMSectionIteratorRef,RI::LLVMRelocationIteratorRef)
    ccall((:LLVMIsRelocationIteratorAtEnd,libllvm),LLVMBool,(LLVMSectionIteratorRef,LLVMRelocationIteratorRef),Section,RI)
end
function LLVMMoveToNextRelocation(RI::LLVMRelocationIteratorRef)
    ccall((:LLVMMoveToNextRelocation,libllvm),Void,(LLVMRelocationIteratorRef,),RI)
end
function LLVMGetSymbolName(SI::LLVMSymbolIteratorRef)
    ccall((:LLVMGetSymbolName,libllvm),Ptr{Uint8},(LLVMSymbolIteratorRef,),SI)
end
function LLVMGetSymbolAddress()
    ccall((:LLVMGetSymbolAddress,libllvm),Cint,())
end
function LLVMGetSymbolSize()
    ccall((:LLVMGetSymbolSize,libllvm),Cint,())
end
function LLVMGetRelocationAddress()
    ccall((:LLVMGetRelocationAddress,libllvm),Cint,())
end
function LLVMGetRelocationOffset()
    ccall((:LLVMGetRelocationOffset,libllvm),Cint,())
end
function LLVMGetRelocationSymbol(RI::LLVMRelocationIteratorRef)
    ccall((:LLVMGetRelocationSymbol,libllvm),LLVMSymbolIteratorRef,(LLVMRelocationIteratorRef,),RI)
end
function LLVMGetRelocationType()
    ccall((:LLVMGetRelocationType,libllvm),Cint,())
end
function LLVMGetRelocationTypeName(RI::LLVMRelocationIteratorRef)
    ccall((:LLVMGetRelocationTypeName,libllvm),Ptr{Uint8},(LLVMRelocationIteratorRef,),RI)
end
function LLVMGetRelocationValueString(RI::LLVMRelocationIteratorRef)
    ccall((:LLVMGetRelocationValueString,libllvm),Ptr{Uint8},(LLVMRelocationIteratorRef,),RI)
end
# Julia wrapper for header: /cmn/jldev/deps/llvm-svn/include/llvm-c/IRReader.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function LLVMParseIRInContext(ContextRef::LLVMContextRef,MemBuf::LLVMMemoryBufferRef,OutM::Ptr{LLVMModuleRef},OutMessage::Ptr{Ptr{Uint8}})
    ccall((:LLVMParseIRInContext,libllvm),LLVMBool,(LLVMContextRef,LLVMMemoryBufferRef,Ptr{LLVMModuleRef},Ptr{Ptr{Uint8}}),ContextRef,MemBuf,OutM,OutMessage)
end
# Julia wrapper for header: /cmn/jldev/deps/llvm-svn/include/llvm-c/ExecutionEngine.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function LLVMLinkInJIT()
    ccall((:LLVMLinkInJIT,libllvm),Void,())
end
function LLVMLinkInMCJIT()
    ccall((:LLVMLinkInMCJIT,libllvm),Void,())
end
function LLVMLinkInInterpreter()
    ccall((:LLVMLinkInInterpreter,libllvm),Void,())
end
function LLVMCreateGenericValueOfInt(Ty::LLVMTypeRef,N::Culonglong,IsSigned::LLVMBool)
    ccall((:LLVMCreateGenericValueOfInt,libllvm),LLVMGenericValueRef,(LLVMTypeRef,Culonglong,LLVMBool),Ty,N,IsSigned)
end
function LLVMCreateGenericValueOfPointer(P::Ptr{Void})
    ccall((:LLVMCreateGenericValueOfPointer,libllvm),LLVMGenericValueRef,(Ptr{Void},),P)
end
function LLVMCreateGenericValueOfFloat(Ty::LLVMTypeRef,N::Cdouble)
    ccall((:LLVMCreateGenericValueOfFloat,libllvm),LLVMGenericValueRef,(LLVMTypeRef,Cdouble),Ty,N)
end
function LLVMGenericValueIntWidth(GenValRef::LLVMGenericValueRef)
    ccall((:LLVMGenericValueIntWidth,libllvm),Uint32,(LLVMGenericValueRef,),GenValRef)
end
function LLVMGenericValueToInt(GenVal::LLVMGenericValueRef,IsSigned::LLVMBool)
    ccall((:LLVMGenericValueToInt,libllvm),Culonglong,(LLVMGenericValueRef,LLVMBool),GenVal,IsSigned)
end
function LLVMGenericValueToPointer(GenVal::LLVMGenericValueRef)
    ccall((:LLVMGenericValueToPointer,libllvm),Ptr{Void},(LLVMGenericValueRef,),GenVal)
end
function LLVMGenericValueToFloat(TyRef::LLVMTypeRef,GenVal::LLVMGenericValueRef)
    ccall((:LLVMGenericValueToFloat,libllvm),Cdouble,(LLVMTypeRef,LLVMGenericValueRef),TyRef,GenVal)
end
function LLVMDisposeGenericValue(GenVal::LLVMGenericValueRef)
    ccall((:LLVMDisposeGenericValue,libllvm),Void,(LLVMGenericValueRef,),GenVal)
end
function LLVMCreateExecutionEngineForModule(OutEE::Ptr{LLVMExecutionEngineRef},M::LLVMModuleRef,OutError::Ptr{Ptr{Uint8}})
    ccall((:LLVMCreateExecutionEngineForModule,libllvm),LLVMBool,(Ptr{LLVMExecutionEngineRef},LLVMModuleRef,Ptr{Ptr{Uint8}}),OutEE,M,OutError)
end
function LLVMCreateInterpreterForModule(OutInterp::Ptr{LLVMExecutionEngineRef},M::LLVMModuleRef,OutError::Ptr{Ptr{Uint8}})
    ccall((:LLVMCreateInterpreterForModule,libllvm),LLVMBool,(Ptr{LLVMExecutionEngineRef},LLVMModuleRef,Ptr{Ptr{Uint8}}),OutInterp,M,OutError)
end
function LLVMCreateJITCompilerForModule(OutJIT::Ptr{LLVMExecutionEngineRef},M::LLVMModuleRef,OptLevel::Uint32,OutError::Ptr{Ptr{Uint8}})
    ccall((:LLVMCreateJITCompilerForModule,libllvm),LLVMBool,(Ptr{LLVMExecutionEngineRef},LLVMModuleRef,Uint32,Ptr{Ptr{Uint8}}),OutJIT,M,OptLevel,OutError)
end
function LLVMInitializeMCJITCompilerOptions(Options::Ptr{LLVMMCJITCompilerOptions},SizeOfOptions::Cint)
    ccall((:LLVMInitializeMCJITCompilerOptions,libllvm),Void,(Ptr{LLVMMCJITCompilerOptions},Cint),Options,SizeOfOptions)
end
function LLVMCreateMCJITCompilerForModule(OutJIT::Ptr{LLVMExecutionEngineRef},M::LLVMModuleRef,Options::Ptr{LLVMMCJITCompilerOptions},SizeOfOptions::Cint,OutError::Ptr{Ptr{Uint8}})
    ccall((:LLVMCreateMCJITCompilerForModule,libllvm),LLVMBool,(Ptr{LLVMExecutionEngineRef},LLVMModuleRef,Ptr{LLVMMCJITCompilerOptions},Cint,Ptr{Ptr{Uint8}}),OutJIT,M,Options,SizeOfOptions,OutError)
end
function LLVMCreateExecutionEngine(OutEE::Ptr{LLVMExecutionEngineRef},MP::LLVMModuleProviderRef,OutError::Ptr{Ptr{Uint8}})
    ccall((:LLVMCreateExecutionEngine,libllvm),LLVMBool,(Ptr{LLVMExecutionEngineRef},LLVMModuleProviderRef,Ptr{Ptr{Uint8}}),OutEE,MP,OutError)
end
function LLVMCreateInterpreter(OutInterp::Ptr{LLVMExecutionEngineRef},MP::LLVMModuleProviderRef,OutError::Ptr{Ptr{Uint8}})
    ccall((:LLVMCreateInterpreter,libllvm),LLVMBool,(Ptr{LLVMExecutionEngineRef},LLVMModuleProviderRef,Ptr{Ptr{Uint8}}),OutInterp,MP,OutError)
end
function LLVMCreateJITCompiler(OutJIT::Ptr{LLVMExecutionEngineRef},MP::LLVMModuleProviderRef,OptLevel::Uint32,OutError::Ptr{Ptr{Uint8}})
    ccall((:LLVMCreateJITCompiler,libllvm),LLVMBool,(Ptr{LLVMExecutionEngineRef},LLVMModuleProviderRef,Uint32,Ptr{Ptr{Uint8}}),OutJIT,MP,OptLevel,OutError)
end
function LLVMDisposeExecutionEngine(EE::LLVMExecutionEngineRef)
    ccall((:LLVMDisposeExecutionEngine,libllvm),Void,(LLVMExecutionEngineRef,),EE)
end
function LLVMRunStaticConstructors(EE::LLVMExecutionEngineRef)
    ccall((:LLVMRunStaticConstructors,libllvm),Void,(LLVMExecutionEngineRef,),EE)
end
function LLVMRunStaticDestructors(EE::LLVMExecutionEngineRef)
    ccall((:LLVMRunStaticDestructors,libllvm),Void,(LLVMExecutionEngineRef,),EE)
end
function LLVMRunFunctionAsMain(EE::LLVMExecutionEngineRef,F::LLVMValueRef,ArgC::Uint32,ArgV::Ptr{Ptr{Uint8}},EnvP::Ptr{Ptr{Uint8}})
    ccall((:LLVMRunFunctionAsMain,libllvm),Cint,(LLVMExecutionEngineRef,LLVMValueRef,Uint32,Ptr{Ptr{Uint8}},Ptr{Ptr{Uint8}}),EE,F,ArgC,ArgV,EnvP)
end
function LLVMRunFunction(EE::LLVMExecutionEngineRef,F::LLVMValueRef,NumArgs::Uint32,Args::Ptr{LLVMGenericValueRef})
    ccall((:LLVMRunFunction,libllvm),LLVMGenericValueRef,(LLVMExecutionEngineRef,LLVMValueRef,Uint32,Ptr{LLVMGenericValueRef}),EE,F,NumArgs,Args)
end
function LLVMFreeMachineCodeForFunction(EE::LLVMExecutionEngineRef,F::LLVMValueRef)
    ccall((:LLVMFreeMachineCodeForFunction,libllvm),Void,(LLVMExecutionEngineRef,LLVMValueRef),EE,F)
end
function LLVMAddModule(EE::LLVMExecutionEngineRef,M::LLVMModuleRef)
    ccall((:LLVMAddModule,libllvm),Void,(LLVMExecutionEngineRef,LLVMModuleRef),EE,M)
end
function LLVMAddModuleProvider(EE::LLVMExecutionEngineRef,MP::LLVMModuleProviderRef)
    ccall((:LLVMAddModuleProvider,libllvm),Void,(LLVMExecutionEngineRef,LLVMModuleProviderRef),EE,MP)
end
function LLVMRemoveModule(EE::LLVMExecutionEngineRef,M::LLVMModuleRef,OutMod::Ptr{LLVMModuleRef},OutError::Ptr{Ptr{Uint8}})
    ccall((:LLVMRemoveModule,libllvm),LLVMBool,(LLVMExecutionEngineRef,LLVMModuleRef,Ptr{LLVMModuleRef},Ptr{Ptr{Uint8}}),EE,M,OutMod,OutError)
end
function LLVMRemoveModuleProvider(EE::LLVMExecutionEngineRef,MP::LLVMModuleProviderRef,OutMod::Ptr{LLVMModuleRef},OutError::Ptr{Ptr{Uint8}})
    ccall((:LLVMRemoveModuleProvider,libllvm),LLVMBool,(LLVMExecutionEngineRef,LLVMModuleProviderRef,Ptr{LLVMModuleRef},Ptr{Ptr{Uint8}}),EE,MP,OutMod,OutError)
end
function LLVMFindFunction(EE::LLVMExecutionEngineRef,Name::Ptr{Uint8},OutFn::Ptr{LLVMValueRef})
    ccall((:LLVMFindFunction,libllvm),LLVMBool,(LLVMExecutionEngineRef,Ptr{Uint8},Ptr{LLVMValueRef}),EE,Name,OutFn)
end
function LLVMRecompileAndRelinkFunction(EE::LLVMExecutionEngineRef,Fn::LLVMValueRef)
    ccall((:LLVMRecompileAndRelinkFunction,libllvm),Ptr{Void},(LLVMExecutionEngineRef,LLVMValueRef),EE,Fn)
end
function LLVMGetExecutionEngineTargetData(EE::LLVMExecutionEngineRef)
    ccall((:LLVMGetExecutionEngineTargetData,libllvm),LLVMTargetDataRef,(LLVMExecutionEngineRef,),EE)
end
function LLVMGetExecutionEngineTargetMachine(EE::LLVMExecutionEngineRef)
    ccall((:LLVMGetExecutionEngineTargetMachine,libllvm),LLVMTargetMachineRef,(LLVMExecutionEngineRef,),EE)
end
function LLVMAddGlobalMapping(EE::LLVMExecutionEngineRef,Global::LLVMValueRef,Addr::Ptr{Void})
    ccall((:LLVMAddGlobalMapping,libllvm),Void,(LLVMExecutionEngineRef,LLVMValueRef,Ptr{Void}),EE,Global,Addr)
end
function LLVMGetPointerToGlobal(EE::LLVMExecutionEngineRef,Global::LLVMValueRef)
    ccall((:LLVMGetPointerToGlobal,libllvm),Ptr{Void},(LLVMExecutionEngineRef,LLVMValueRef),EE,Global)
end
function LLVMCreateSimpleMCJITMemoryManager(Opaque::Ptr{Void},AllocateCodeSection::LLVMMemoryManagerAllocateCodeSectionCallback,AllocateDataSection::LLVMMemoryManagerAllocateDataSectionCallback,FinalizeMemory::LLVMMemoryManagerFinalizeMemoryCallback,Destroy::LLVMMemoryManagerDestroyCallback)
    ccall((:LLVMCreateSimpleMCJITMemoryManager,libllvm),LLVMMCJITMemoryManagerRef,(Ptr{Void},LLVMMemoryManagerAllocateCodeSectionCallback,LLVMMemoryManagerAllocateDataSectionCallback,LLVMMemoryManagerFinalizeMemoryCallback,LLVMMemoryManagerDestroyCallback),Opaque,AllocateCodeSection,AllocateDataSection,FinalizeMemory,Destroy)
end
function LLVMDisposeMCJITMemoryManager(MM::LLVMMCJITMemoryManagerRef)
    ccall((:LLVMDisposeMCJITMemoryManager,libllvm),Void,(LLVMMCJITMemoryManagerRef,),MM)
end
# Julia wrapper for header: /cmn/jldev/deps/llvm-svn/include/llvm-c/BitReader.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function LLVMParseBitcode(MemBuf::LLVMMemoryBufferRef,OutModule::Ptr{LLVMModuleRef},OutMessage::Ptr{Ptr{Uint8}})
    ccall((:LLVMParseBitcode,libllvm),LLVMBool,(LLVMMemoryBufferRef,Ptr{LLVMModuleRef},Ptr{Ptr{Uint8}}),MemBuf,OutModule,OutMessage)
end
function LLVMParseBitcodeInContext(ContextRef::LLVMContextRef,MemBuf::LLVMMemoryBufferRef,OutModule::Ptr{LLVMModuleRef},OutMessage::Ptr{Ptr{Uint8}})
    ccall((:LLVMParseBitcodeInContext,libllvm),LLVMBool,(LLVMContextRef,LLVMMemoryBufferRef,Ptr{LLVMModuleRef},Ptr{Ptr{Uint8}}),ContextRef,MemBuf,OutModule,OutMessage)
end
function LLVMGetBitcodeModuleInContext(ContextRef::LLVMContextRef,MemBuf::LLVMMemoryBufferRef,OutM::Ptr{LLVMModuleRef},OutMessage::Ptr{Ptr{Uint8}})
    ccall((:LLVMGetBitcodeModuleInContext,libllvm),LLVMBool,(LLVMContextRef,LLVMMemoryBufferRef,Ptr{LLVMModuleRef},Ptr{Ptr{Uint8}}),ContextRef,MemBuf,OutM,OutMessage)
end
function LLVMGetBitcodeModule(MemBuf::LLVMMemoryBufferRef,OutM::Ptr{LLVMModuleRef},OutMessage::Ptr{Ptr{Uint8}})
    ccall((:LLVMGetBitcodeModule,libllvm),LLVMBool,(LLVMMemoryBufferRef,Ptr{LLVMModuleRef},Ptr{Ptr{Uint8}}),MemBuf,OutM,OutMessage)
end
function LLVMGetBitcodeModuleProviderInContext(ContextRef::LLVMContextRef,MemBuf::LLVMMemoryBufferRef,OutMP::Ptr{LLVMModuleProviderRef},OutMessage::Ptr{Ptr{Uint8}})
    ccall((:LLVMGetBitcodeModuleProviderInContext,libllvm),LLVMBool,(LLVMContextRef,LLVMMemoryBufferRef,Ptr{LLVMModuleProviderRef},Ptr{Ptr{Uint8}}),ContextRef,MemBuf,OutMP,OutMessage)
end
function LLVMGetBitcodeModuleProvider(MemBuf::LLVMMemoryBufferRef,OutMP::Ptr{LLVMModuleProviderRef},OutMessage::Ptr{Ptr{Uint8}})
    ccall((:LLVMGetBitcodeModuleProvider,libllvm),LLVMBool,(LLVMMemoryBufferRef,Ptr{LLVMModuleProviderRef},Ptr{Ptr{Uint8}}),MemBuf,OutMP,OutMessage)
end
# Julia wrapper for header: /cmn/jldev/deps/llvm-svn/include/llvm-c/Disassembler.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function LLVMCreateDisasm(TripleName::Ptr{Uint8},DisInfo::Ptr{Void},TagType::Cint,GetOpInfo::LLVMOpInfoCallback,SymbolLookUp::LLVMSymbolLookupCallback)
    ccall((:LLVMCreateDisasm,libllvm),LLVMDisasmContextRef,(Ptr{Uint8},Ptr{Void},Cint,LLVMOpInfoCallback,LLVMSymbolLookupCallback),TripleName,DisInfo,TagType,GetOpInfo,SymbolLookUp)
end
function LLVMCreateDisasmCPU(Triple::Ptr{Uint8},CPU::Ptr{Uint8},DisInfo::Ptr{Void},TagType::Cint,GetOpInfo::LLVMOpInfoCallback,SymbolLookUp::LLVMSymbolLookupCallback)
    ccall((:LLVMCreateDisasmCPU,libllvm),LLVMDisasmContextRef,(Ptr{Uint8},Ptr{Uint8},Ptr{Void},Cint,LLVMOpInfoCallback,LLVMSymbolLookupCallback),Triple,CPU,DisInfo,TagType,GetOpInfo,SymbolLookUp)
end
function LLVMSetDisasmOptions(DC::LLVMDisasmContextRef,Options::Cint)
    ccall((:LLVMSetDisasmOptions,libllvm),Cint,(LLVMDisasmContextRef,Cint),DC,Options)
end
function LLVMDisasmDispose(DC::LLVMDisasmContextRef)
    ccall((:LLVMDisasmDispose,libllvm),Void,(LLVMDisasmContextRef,),DC)
end
function LLVMDisasmInstruction()
    ccall((:LLVMDisasmInstruction,libllvm),Cint,())
end
# Julia wrapper for header: /cmn/jldev/deps/llvm-svn/include/llvm-c/Transforms/Vectorize.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function LLVMAddBBVectorizePass(PM::LLVMPassManagerRef)
    ccall((:LLVMAddBBVectorizePass,libllvm),Void,(LLVMPassManagerRef,),PM)
end
function LLVMAddLoopVectorizePass(PM::LLVMPassManagerRef)
    ccall((:LLVMAddLoopVectorizePass,libllvm),Void,(LLVMPassManagerRef,),PM)
end
function LLVMAddSLPVectorizePass(PM::LLVMPassManagerRef)
    ccall((:LLVMAddSLPVectorizePass,libllvm),Void,(LLVMPassManagerRef,),PM)
end
# Julia wrapper for header: /cmn/jldev/deps/llvm-svn/include/llvm-c/Transforms/IPO.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function LLVMAddArgumentPromotionPass(PM::LLVMPassManagerRef)
    ccall((:LLVMAddArgumentPromotionPass,libllvm),Void,(LLVMPassManagerRef,),PM)
end
function LLVMAddConstantMergePass(PM::LLVMPassManagerRef)
    ccall((:LLVMAddConstantMergePass,libllvm),Void,(LLVMPassManagerRef,),PM)
end
function LLVMAddDeadArgEliminationPass(PM::LLVMPassManagerRef)
    ccall((:LLVMAddDeadArgEliminationPass,libllvm),Void,(LLVMPassManagerRef,),PM)
end
function LLVMAddFunctionAttrsPass(PM::LLVMPassManagerRef)
    ccall((:LLVMAddFunctionAttrsPass,libllvm),Void,(LLVMPassManagerRef,),PM)
end
function LLVMAddFunctionInliningPass(PM::LLVMPassManagerRef)
    ccall((:LLVMAddFunctionInliningPass,libllvm),Void,(LLVMPassManagerRef,),PM)
end
function LLVMAddAlwaysInlinerPass(PM::LLVMPassManagerRef)
    ccall((:LLVMAddAlwaysInlinerPass,libllvm),Void,(LLVMPassManagerRef,),PM)
end
function LLVMAddGlobalDCEPass(PM::LLVMPassManagerRef)
    ccall((:LLVMAddGlobalDCEPass,libllvm),Void,(LLVMPassManagerRef,),PM)
end
function LLVMAddGlobalOptimizerPass(PM::LLVMPassManagerRef)
    ccall((:LLVMAddGlobalOptimizerPass,libllvm),Void,(LLVMPassManagerRef,),PM)
end
function LLVMAddIPConstantPropagationPass(PM::LLVMPassManagerRef)
    ccall((:LLVMAddIPConstantPropagationPass,libllvm),Void,(LLVMPassManagerRef,),PM)
end
function LLVMAddPruneEHPass(PM::LLVMPassManagerRef)
    ccall((:LLVMAddPruneEHPass,libllvm),Void,(LLVMPassManagerRef,),PM)
end
function LLVMAddIPSCCPPass(PM::LLVMPassManagerRef)
    ccall((:LLVMAddIPSCCPPass,libllvm),Void,(LLVMPassManagerRef,),PM)
end
function LLVMAddInternalizePass(arg1::LLVMPassManagerRef,AllButMain::Uint32)
    ccall((:LLVMAddInternalizePass,libllvm),Void,(LLVMPassManagerRef,Uint32),arg1,AllButMain)
end
function LLVMAddStripDeadPrototypesPass(PM::LLVMPassManagerRef)
    ccall((:LLVMAddStripDeadPrototypesPass,libllvm),Void,(LLVMPassManagerRef,),PM)
end
function LLVMAddStripSymbolsPass(PM::LLVMPassManagerRef)
    ccall((:LLVMAddStripSymbolsPass,libllvm),Void,(LLVMPassManagerRef,),PM)
end
# Julia wrapper for header: /cmn/jldev/deps/llvm-svn/include/llvm-c/Transforms/Scalar.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function LLVMAddAggressiveDCEPass(PM::LLVMPassManagerRef)
    ccall((:LLVMAddAggressiveDCEPass,libllvm),Void,(LLVMPassManagerRef,),PM)
end
function LLVMAddCFGSimplificationPass(PM::LLVMPassManagerRef)
    ccall((:LLVMAddCFGSimplificationPass,libllvm),Void,(LLVMPassManagerRef,),PM)
end
function LLVMAddDeadStoreEliminationPass(PM::LLVMPassManagerRef)
    ccall((:LLVMAddDeadStoreEliminationPass,libllvm),Void,(LLVMPassManagerRef,),PM)
end
function LLVMAddScalarizerPass(PM::LLVMPassManagerRef)
    ccall((:LLVMAddScalarizerPass,libllvm),Void,(LLVMPassManagerRef,),PM)
end
function LLVMAddGVNPass(PM::LLVMPassManagerRef)
    ccall((:LLVMAddGVNPass,libllvm),Void,(LLVMPassManagerRef,),PM)
end
function LLVMAddIndVarSimplifyPass(PM::LLVMPassManagerRef)
    ccall((:LLVMAddIndVarSimplifyPass,libllvm),Void,(LLVMPassManagerRef,),PM)
end
function LLVMAddInstructionCombiningPass(PM::LLVMPassManagerRef)
    ccall((:LLVMAddInstructionCombiningPass,libllvm),Void,(LLVMPassManagerRef,),PM)
end
function LLVMAddJumpThreadingPass(PM::LLVMPassManagerRef)
    ccall((:LLVMAddJumpThreadingPass,libllvm),Void,(LLVMPassManagerRef,),PM)
end
function LLVMAddLICMPass(PM::LLVMPassManagerRef)
    ccall((:LLVMAddLICMPass,libllvm),Void,(LLVMPassManagerRef,),PM)
end
function LLVMAddLoopDeletionPass(PM::LLVMPassManagerRef)
    ccall((:LLVMAddLoopDeletionPass,libllvm),Void,(LLVMPassManagerRef,),PM)
end
function LLVMAddLoopIdiomPass(PM::LLVMPassManagerRef)
    ccall((:LLVMAddLoopIdiomPass,libllvm),Void,(LLVMPassManagerRef,),PM)
end
function LLVMAddLoopRotatePass(PM::LLVMPassManagerRef)
    ccall((:LLVMAddLoopRotatePass,libllvm),Void,(LLVMPassManagerRef,),PM)
end
function LLVMAddLoopRerollPass(PM::LLVMPassManagerRef)
    ccall((:LLVMAddLoopRerollPass,libllvm),Void,(LLVMPassManagerRef,),PM)
end
function LLVMAddLoopUnrollPass(PM::LLVMPassManagerRef)
    ccall((:LLVMAddLoopUnrollPass,libllvm),Void,(LLVMPassManagerRef,),PM)
end
function LLVMAddLoopUnswitchPass(PM::LLVMPassManagerRef)
    ccall((:LLVMAddLoopUnswitchPass,libllvm),Void,(LLVMPassManagerRef,),PM)
end
function LLVMAddMemCpyOptPass(PM::LLVMPassManagerRef)
    ccall((:LLVMAddMemCpyOptPass,libllvm),Void,(LLVMPassManagerRef,),PM)
end
function LLVMAddPartiallyInlineLibCallsPass(PM::LLVMPassManagerRef)
    ccall((:LLVMAddPartiallyInlineLibCallsPass,libllvm),Void,(LLVMPassManagerRef,),PM)
end
function LLVMAddPromoteMemoryToRegisterPass(PM::LLVMPassManagerRef)
    ccall((:LLVMAddPromoteMemoryToRegisterPass,libllvm),Void,(LLVMPassManagerRef,),PM)
end
function LLVMAddReassociatePass(PM::LLVMPassManagerRef)
    ccall((:LLVMAddReassociatePass,libllvm),Void,(LLVMPassManagerRef,),PM)
end
function LLVMAddSCCPPass(PM::LLVMPassManagerRef)
    ccall((:LLVMAddSCCPPass,libllvm),Void,(LLVMPassManagerRef,),PM)
end
function LLVMAddScalarReplAggregatesPass(PM::LLVMPassManagerRef)
    ccall((:LLVMAddScalarReplAggregatesPass,libllvm),Void,(LLVMPassManagerRef,),PM)
end
function LLVMAddScalarReplAggregatesPassSSA(PM::LLVMPassManagerRef)
    ccall((:LLVMAddScalarReplAggregatesPassSSA,libllvm),Void,(LLVMPassManagerRef,),PM)
end
function LLVMAddScalarReplAggregatesPassWithThreshold(PM::LLVMPassManagerRef,Threshold::Cint)
    ccall((:LLVMAddScalarReplAggregatesPassWithThreshold,libllvm),Void,(LLVMPassManagerRef,Cint),PM,Threshold)
end
function LLVMAddSimplifyLibCallsPass(PM::LLVMPassManagerRef)
    ccall((:LLVMAddSimplifyLibCallsPass,libllvm),Void,(LLVMPassManagerRef,),PM)
end
function LLVMAddTailCallEliminationPass(PM::LLVMPassManagerRef)
    ccall((:LLVMAddTailCallEliminationPass,libllvm),Void,(LLVMPassManagerRef,),PM)
end
function LLVMAddConstantPropagationPass(PM::LLVMPassManagerRef)
    ccall((:LLVMAddConstantPropagationPass,libllvm),Void,(LLVMPassManagerRef,),PM)
end
function LLVMAddDemoteMemoryToRegisterPass(PM::LLVMPassManagerRef)
    ccall((:LLVMAddDemoteMemoryToRegisterPass,libllvm),Void,(LLVMPassManagerRef,),PM)
end
function LLVMAddVerifierPass(PM::LLVMPassManagerRef)
    ccall((:LLVMAddVerifierPass,libllvm),Void,(LLVMPassManagerRef,),PM)
end
function LLVMAddCorrelatedValuePropagationPass(PM::LLVMPassManagerRef)
    ccall((:LLVMAddCorrelatedValuePropagationPass,libllvm),Void,(LLVMPassManagerRef,),PM)
end
function LLVMAddEarlyCSEPass(PM::LLVMPassManagerRef)
    ccall((:LLVMAddEarlyCSEPass,libllvm),Void,(LLVMPassManagerRef,),PM)
end
function LLVMAddLowerExpectIntrinsicPass(PM::LLVMPassManagerRef)
    ccall((:LLVMAddLowerExpectIntrinsicPass,libllvm),Void,(LLVMPassManagerRef,),PM)
end
function LLVMAddTypeBasedAliasAnalysisPass(PM::LLVMPassManagerRef)
    ccall((:LLVMAddTypeBasedAliasAnalysisPass,libllvm),Void,(LLVMPassManagerRef,),PM)
end
function LLVMAddBasicAliasAnalysisPass(PM::LLVMPassManagerRef)
    ccall((:LLVMAddBasicAliasAnalysisPass,libllvm),Void,(LLVMPassManagerRef,),PM)
end
# Julia wrapper for header: /cmn/jldev/deps/llvm-svn/include/llvm-c/Transforms/PassManagerBuilder.h
# Automatically generated using Clang.jl wrap_c, version 0.0.0


function LLVMPassManagerBuilderCreate()
    ccall((:LLVMPassManagerBuilderCreate,libllvm),LLVMPassManagerBuilderRef,())
end
function LLVMPassManagerBuilderDispose(PMB::LLVMPassManagerBuilderRef)
    ccall((:LLVMPassManagerBuilderDispose,libllvm),Void,(LLVMPassManagerBuilderRef,),PMB)
end
function LLVMPassManagerBuilderSetOptLevel(PMB::LLVMPassManagerBuilderRef,OptLevel::Uint32)
    ccall((:LLVMPassManagerBuilderSetOptLevel,libllvm),Void,(LLVMPassManagerBuilderRef,Uint32),PMB,OptLevel)
end
function LLVMPassManagerBuilderSetSizeLevel(PMB::LLVMPassManagerBuilderRef,SizeLevel::Uint32)
    ccall((:LLVMPassManagerBuilderSetSizeLevel,libllvm),Void,(LLVMPassManagerBuilderRef,Uint32),PMB,SizeLevel)
end
function LLVMPassManagerBuilderSetDisableUnitAtATime(PMB::LLVMPassManagerBuilderRef,Value::LLVMBool)
    ccall((:LLVMPassManagerBuilderSetDisableUnitAtATime,libllvm),Void,(LLVMPassManagerBuilderRef,LLVMBool),PMB,Value)
end
function LLVMPassManagerBuilderSetDisableUnrollLoops(PMB::LLVMPassManagerBuilderRef,Value::LLVMBool)
    ccall((:LLVMPassManagerBuilderSetDisableUnrollLoops,libllvm),Void,(LLVMPassManagerBuilderRef,LLVMBool),PMB,Value)
end
function LLVMPassManagerBuilderSetDisableSimplifyLibCalls(PMB::LLVMPassManagerBuilderRef,Value::LLVMBool)
    ccall((:LLVMPassManagerBuilderSetDisableSimplifyLibCalls,libllvm),Void,(LLVMPassManagerBuilderRef,LLVMBool),PMB,Value)
end
function LLVMPassManagerBuilderUseInlinerWithThreshold(PMB::LLVMPassManagerBuilderRef,Threshold::Uint32)
    ccall((:LLVMPassManagerBuilderUseInlinerWithThreshold,libllvm),Void,(LLVMPassManagerBuilderRef,Uint32),PMB,Threshold)
end
function LLVMPassManagerBuilderPopulateFunctionPassManager(PMB::LLVMPassManagerBuilderRef,PM::LLVMPassManagerRef)
    ccall((:LLVMPassManagerBuilderPopulateFunctionPassManager,libllvm),Void,(LLVMPassManagerBuilderRef,LLVMPassManagerRef),PMB,PM)
end
function LLVMPassManagerBuilderPopulateModulePassManager(PMB::LLVMPassManagerBuilderRef,PM::LLVMPassManagerRef)
    ccall((:LLVMPassManagerBuilderPopulateModulePassManager,libllvm),Void,(LLVMPassManagerBuilderRef,LLVMPassManagerRef),PMB,PM)
end
function LLVMPassManagerBuilderPopulateLTOPassManager(PMB::LLVMPassManagerBuilderRef,PM::LLVMPassManagerRef,Internalize::LLVMBool,RunInliner::LLVMBool)
    ccall((:LLVMPassManagerBuilderPopulateLTOPassManager,libllvm),Void,(LLVMPassManagerBuilderRef,LLVMPassManagerRef,LLVMBool,LLVMBool),PMB,PM,Internalize,RunInliner)
end
