# makefile for the hpc course
CC      = suncc
OPT     = -g -fast -xopenmp -xrestrict
WARN    = -Wall
CFLAGS  = $(OPT) $(WARN) # the compiler flags
OBJECTS = jac_cpu.o func.o

# define project
jac_cpu : $(OBJECTS)
	$(CC) $(CFLAGS) -o jac_cpu $(OBJECTS)

clean : 
	@rm -f *.o compiler


# define file dependencies
func.o : func.c func.h

jac_cpu : jac_cpu.c func.h

