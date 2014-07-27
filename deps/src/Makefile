all: check-env default

ifeq (exists, $(shell [ -e Make.user ] && echo exists ))
include Make.user 
endif

.PHONY: all clean check-env default

check-env:
ifndef JULIA_ROOT
  $(error Environment variable JULIA_ROOT is not set.)
endif

JULIA_ROOT = /home/jake/Julia/julia

CC  = clang
CXX = clang

LLVM_CONFIG ?= $(JULIA_ROOT)/usr/bin/llvm-config

LLVM_VER = $(shell $(LLVM_CONFIG) --version)

CFLAGS   = $(shell $(LLVM_CONFIG) --cflags)
CXXFLAGS = $(shell $(LLVM_CONFIG) --cxxflags) 

FLAGS   = 
LIBS    = $(shell $(LLVM_CONFIG) --libs) 
LDFLAGS = $(shell $(LLVM_CONFIG) --ldflags) 

INC     += -I$(shell $(LLVM_CONFIG) --includedir)
LIB_DIR += -L$(shell $(LLVM_CONFIG) --libdir)

OBJS += AssemblyC.cpp.o \
	BitcodeC.cpp.o \
	BuilderC.cpp.o \
	CommandLineC.cpp.o \
	ConstantC.cpp.o \
	ExecutionEngineC.cpp.o \
	FunctionC.cpp.o \
	GlobalAliasC.cpp.o \
	InlineAssemblyC.cpp.o \
	InstructionC.cpp.o \
	MetadataC.cpp.o \
	ModuleC.cpp.o \
	PassManagerC.cpp.o \
	RawOStreamC.cpp.o \
	SMDiagnosticC.cpp.o \
	TypeC.cpp.o \
	TargetC.cpp.o \
	ValueC.cpp.o

# OS and architecture
OS = $(shell uname)
ifeq ($(OS), MINGW32_NT-6.1)
  OS = WINNT
endif

# file extensions
ifeq ($(OS), WINNT)
  SHLIB_EXT = dll 
else ifeq ($(OS), Darwin)
  SHLIB_EXT = dylib
else
  SHLIB_EXT = so
endif

default: libllvmgeneral.$(SHLIB_EXT)

%.c.o: %.c
	$(CC) $< -fPIC -c -o $@ $(INC) $(CFLAGS) $(FLAGS)

%.cpp.o: %.cpp
	$(CXX) $< -fPIC -c -o $@ $(INC) $(CXXFLAGS) $(FLAGS)

libllvmgeneral.$(SHLIB_EXT): $(OBJS)
	$(CXX) $(OBJS) -rdynamic -shared -o $@ $(LIB_DIR) $(LDFLAGS) $(LIBS)

clean:
	rm -f *.o *.$(SHLIB_EXT)
