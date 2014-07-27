#include "llvm/Config/llvm-config.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Support/MemoryBuffer.h"
#include "llvm/Bitcode/ReaderWriter.h"

#include "llvm-c/Core.h"

using namespace llvm;

extern "C" {

void LLVM_General_WriteBitcode(LLVMModuleRef m, raw_ostream &os) {
	WriteBitcodeToFile(unwrap(m), os);
}

}
