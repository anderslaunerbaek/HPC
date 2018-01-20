# makefile for the hpc course
CC      = suncc
OPT     = -g -fast -xrestrict -xopenmp -xloopinfo
WARN    = -Wall
CFLAGS  = $(OPT) $(WARN) # the compiler flags
OBJECTS = main.o func.o

# define project
program : $(OBJECTS)
	$(CC) $(CFLAGS) -o program $(OBJECTS)

clean : 
	@rm -f *.o compiler

realclean : clean
	@rm -f program

# define file dependencies
func.o : func.c func.h
main.o : main.c func.h
