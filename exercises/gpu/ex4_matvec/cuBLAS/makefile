TARGET = matvec
SRCS	 = 
OBJS	 = main.o

OPT = -g -O3
PIC = -fpic
OMP   = -fopenmp
XPIC  = -Xcompiler -fpic
XOPT  = -Xptxas=-v # use -lineinfo for profiler, use -G for debugging
XARCH = -arch=sm_70


CXX	= nvcc
CXXFLAGS= --compiler-options "$(OPT) $(PIC) $(OMP)" $(ARCH) $(XOPTS) 

CUDA_PATH ?= /appl/cuda/9.1
INCLUDES = -I$(CUDA_PATH)/include -I$(CUDA_PATH)/samples/common/inc

SOFLAGS =
XLIBS   = -L$(CUDA_PATH)/lib -lcublas




$(TARGET): $(OBJS)
	$(CXX) -o $@ $(CXXFLAGS) $(SOFLAGS) $(INCLUDES) $^ $(XLIBS) 

.SUFFIXES: .cu
.cu.o:
	$(CXX) -o $*.o -c $*.cu $(CXXFLAGS) $(SOFLAGS) $(INCLUDES)

clean:
	@/bin/rm -f $(TARGET) $(OBJS) 


# dependencies
#
main.o  : main.cu
