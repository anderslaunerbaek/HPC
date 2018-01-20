/* datatools.c - support functions for the matrix examples
 *
 * Author:  Bernd Dammann, DTU Compute
 * Version: $Revision: 1.2 $ $Date: 2015/11/10 11:03:12 $
 */
#include <stdlib.h>
#include <stdio.h>
#include <float.h>
#include <math.h>

#include "datatools.h"

void init_data_2d (int m, int n, double **A, double value) {
  for(int i = 0; i < m; i++) {
    for(int j = 0; j < n; j++) {
      A[i][j] = value;	   	    
    }
  }
}

void init_data_1d (int n, double *A, double value) {
  for(int i = 0; i < n; i++) {
      A[i] = value;         
  }
}

int check_results(char *comment, int m, int n, double **A) { 
  double relerr;
  double *a = A[0];
  double ref = 3.0;
  int    i, errors = 0;
  char   *marker;
  double TOL   = 100.0 * DBL_EPSILON;
  double SMALL = 100.0 * DBL_MIN;

  if ( (marker=(char *)malloc(m*n*sizeof(char))) == NULL ) {
    perror("array marker");
    exit(-1);
  }

  for (i=0; i<m*n; i++) {
    relerr = fabs((a[i]-ref));
    if ( relerr <= TOL ) {
      marker[i] = ' ';
    } else {
      errors++;
      marker[i] = '*';
    }
  }
   
  if ( errors > 0 ) {
     printf("Routine: %s\n",comment);
     printf("Found %d differences in results for m=%d n=%d:\n",errors,m,n);
     for (i=0; i<m*n; i++) {
      printf("\t%c a[%d]=%f ref[%d]=%f\n",marker[i],i,a[i],i,ref);
     }
   }
   return(errors);
}

/* Routine for allocating two-dimensional array */
double ** malloc_2d(int m, int n) {
  int i;
  if (m <= 0 || n <= 0) {
    return NULL;  
  }

  double **A = malloc(m * sizeof(double *));
  if (A == NULL) {
    return NULL;  
  }

  A[0] = malloc(m*n*sizeof(double));
  if (A[0] == NULL) {
    free(A);
    return NULL;
  }

  for (i = 1; i < m; i++) {
    A[i] = A[0] + i * n;
  }
  return A;
}

void free_2d(double **A) {
    free(A[0]);
    free(A);
}

/* Routine for allocating two-dimensional array */
double * malloc_1d(int n) {
  
  if (n <= 0) {
    return NULL;  
  }

  double *A = malloc(n * sizeof(double));
  if (A == NULL) {
    return NULL;  
  }
  return A;
}

void free_1d(double *A) {
    free(A);
}

void print_matrix_2d(int no_row, int no_col, double **C) {
  for (int row = 0; row < no_row; row++) {
    for (int columns = 0; columns < no_col; columns++) {
      printf("%f     ", C[row][columns]);
    }
    printf("\n");
  }
} 








void print_matrix_1d(int no_row, double *C) {
  for (int row = 0; row < no_row; row++) {
    printf("%f     ", C[row]);
    printf("\n");
  }
} 



