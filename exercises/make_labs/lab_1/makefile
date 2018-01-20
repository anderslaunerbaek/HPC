# makefile for the hpc course
CC      = gcc
OPT     = -g -O3
WARN    = -Wall
CFLAGS  = $(OPT) $(WARN) # the compiler flags
OBJECTS = data.o main.o io.o


# define project
excer1 : $(OBJECTS)
	$(CC) $(CFLAGS) -o excer1 $(OBJECTS)

clean : 
	@rm -f *.o compiler

realclean : clean
	@rm -f excer1

# define file dependencies
data.o : data.c data.h
main.o : main.c data.h io.h
io.o : io.c io.h