TARGET_1 = jac_gpu1
SRCS_1	 = jac_gpu1.cu
OBJS_1	 = jac_gpu1.o

TARGET_2 = jac_gpu2
SRCS_2	 = jac_gpu2.cu
OBJS_2	 = jac_gpu2.o

TARGET_3 = jac_gpu3
SRCS_3	 = jac_gpu3.cu
OBJS_3	 = jac_gpu3.o

OPT = -g
PIC =
XOPTS = -Xptxas=-v
ARCH  = -arch=sm_70
OMP   = -fopenmp

CXX	= nvcc
CXXFLAGS= --compiler-options "$(OPT) $(PIC) $(OMP)" $(ARCH) $(XOPTS) 

CUDA_PATH ?= /appl/cuda/9.1
INCLUDES = -I$(CUDA_PATH)/include -I$(CUDA_PATH)/samples/common/inc

SOFLAGS =
XLIBS	= -L$(CUDA_PATH)/lib -lcublas


# define project
all : $(TARGET_1) $(TARGET_2) $(TARGET_3)

$(TARGET_1): $(OBJS_1)
	$(CXX) -o $@ $(CXXFLAGS) $(SOFLAGS) $(INCLUDES) $^ $(XLIBS)
$(TARGET_2): $(OBJS_2)
	$(CXX) -o $@ $(CXXFLAGS) $(SOFLAGS) $(INCLUDES) $^ $(XLIBS)
$(TARGET_3): $(OBJS_3)
	$(CXX) -o $@ $(CXXFLAGS) $(SOFLAGS) $(INCLUDES) $^ $(XLIBS) 





.SUFFIXES: .cu
.cu.o:
	$(CXX) -o $*.o -c $*.cu $(CXXFLAGS) $(SOFLAGS) $(INCLUDES)

clean:
	@/bin/rm -f $(TARGET_1) $(OBJS_1)
	@/bin/rm -f $(TARGET_2) $(OBJS_2)
	@/bin/rm -f $(TARGET_3) $(OBJS_3) 
