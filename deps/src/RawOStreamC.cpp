#include "llvm-c/Core.h"

#include "llvm/Support/raw_ostream.h"

using namespace llvm;
using sys::fs::F_Excl;
using sys::fs::F_None;
using sys::fs::F_Binary;

extern "C" {

LLVMBool LLVM_General_WithFileRawOStream(
	const char *filename,
	LLVMBool excl,
	LLVMBool binary,
	const char *&error,
	void (&callback)(raw_ostream &ostream, const void *data),
    const void *data
) {
	std::string e;
	raw_fd_ostream os(filename, e, (excl ? F_Excl : F_None) |
				       (binary ? F_Binary : F_None));
	if (!e.empty()) {
		error = strdup(e.c_str());
		return false;
	}
	callback(os, data);
	return true;
}

void LLVM_General_WithBufferRawOStream(
	void (&outputCallback)(const char *start, size_t length, const void *data),
	void (&streamCallback)(raw_ostream &ostream, const void *data),
    const void *data
) {
	std::string s;
	{
		raw_string_ostream os(s);
		streamCallback(os, data);
	}
	outputCallback(s.data(), s.size(), data);
}
	
}
