/* datatools.h - support functions for the matrix examples
 *
 * Author:  Bernd Dammann, DTU Compute
 * Version: $Revision: 1.1 $ $Date: 2015/11/10 11:01:43 $
 */
#ifndef __DATATOOLS_H
#define __DATATOOLS_H

void init_data_2d (int m, int n, double **A, double value);

void init_data_1d (int n, double *A, double value);



int check_results(char *comment, /* comment string 		 */
                  int m,         /* number of rows               */
		  int n,         /* number of columns            */
		  double **a      /* vector of length m           */
		 );


double * malloc_1d(int n);
double ** malloc_2d(int m, int n);

double * malloc_1d(int n);
double ** malloc_2d(int m, int n);

void free_1d(double *A);
void free_2d(double **A);

void print_matrix_1d(int no_row, double *C);
void print_matrix_2d(int no_row, int no_col, double **C);

#endif
