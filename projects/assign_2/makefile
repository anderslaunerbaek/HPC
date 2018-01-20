# makefile for the hpc course
CC      = suncc
OPT_non = -g -xopenmp=noopt
OPT     = -g -fast -xopenmp
OPT_1     = -g -fast -xrestrict -xopenmp -xloopinfo
WARN    = -Wall
CFLAGS  = $(OPT) $(WARN) # the compiler flags
CFLAGS_1  = $(OPT_1) $(WARN) # the compiler flags
CFLAGS_non  = $(OPT_non) $(WARN) # the compiler flags

OBJECTS_1 = main_gauss.o func.o
OBJECTS_1con = main_gauss_con.o func.o
OBJECTS_2 = main_jac_mp.o func.o
OBJECTS_22 = main_jac_mp_v2.o func.o
OBJECTS_23 = main_jac_mp_v3.o func.o
OBJECTS_3 = main_jac_seq.o func.o
OBJECTS_3con = main_jac_seq_con.o func.o
OBJECTS_4 = main_mandel.o func.o

# define project
all: program_gauss program_gauss_con program_jac_mp program_jac_mp_v2 program_jac_mp_v3 program_jac_seq program_jac_seq_con program_mandel program_jac_mp_non program_jac_mp_v2_non program_jac_mp_v3_non program_mandel_non


program_gauss : $(OBJECTS_1)
	$(CC) $(CFLAGS) -o program_gauss $(OBJECTS_1)

program_gauss_con : $(OBJECTS_1con)
	$(CC) $(CFLAGS) -o program_gauss_con $(OBJECTS_1con)

program_jac_mp : $(OBJECTS_2)
	$(CC) $(CFLAGS_1) -o program_jac_mp $(OBJECTS_2)

program_jac_mp_v2 : $(OBJECTS_22)
	$(CC) $(CFLAGS_1) -o program_jac_mp_v2 $(OBJECTS_22)

program_jac_mp_v3 : $(OBJECTS_23)
	$(CC) $(CFLAGS_1) -o program_jac_mp_v3 $(OBJECTS_23)

program_jac_seq : $(OBJECTS_3)
	$(CC) $(CFLAGS) -o program_jac_seq $(OBJECTS_3)

program_jac_seq_con : $(OBJECTS_3con)
	$(CC) $(CFLAGS) -o program_jac_seq_con $(OBJECTS_3con)

program_mandel : $(OBJECTS_4)
	$(CC) $(CFLAGS_1) -o program_mandel $(OBJECTS_4)

program_jac_mp_non : $(OBJECTS_2)
	$(CC) $(CFLAGS_non) -o program_jac_mp_non $(OBJECTS_2)

program_jac_mp_v2_non : $(OBJECTS_22)
	$(CC) $(CFLAGS_non) -o program_jac_mp_v2_non $(OBJECTS_22)

program_jac_mp_v3_non : $(OBJECTS_23)
	$(CC) $(CFLAGS_non) -o program_jac_mp_v3_non $(OBJECTS_23)

program_mandel_non : $(OBJECTS_4)
	$(CC) $(CFLAGS_non) -o program_mandel_non $(OBJECTS_4)

clean : 
	@rm -f *.o compiler

realclean : clean
	@rm -f program_gauss
	@rm -f program_gauss_con
	@rm -f program_jac_mp
	@rm -f program_jac_mp_v2
	@rm -f program_jac_mp_v3
	@rm -f program_jac_seq
	@rm -f program_jac_seq_con
	@rm -f program_mandel
	@rm -f program_jac_mp_non
	@rm -f program_jac_mp_v2_non
	@rm -f program_jac_mp_v3_non
	@rm -f program_mandel_non

# define file dependencies
func.o : func.c func.h


main_gauss.o : main_gauss.c func.h
main_gauss_con.o : main_gauss_con.c func.h

main_jac_mp.o : main_jac_mp.c func.h
main_jac_mp_v2 : main_jac_mp_v2.c func.h
main_jac_mp_v3 : main_jac_mp_v3.c func.h

main_jac_seq_con.o : main_jac_seq_con.c func.h
main_jac_seq.o : main_jac_seq.c func.h
main_mandel.o : main_mandel.c func.h

