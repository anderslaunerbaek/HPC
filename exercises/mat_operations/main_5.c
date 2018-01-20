#include <stdlib.h>
#include <stdio.h>
#include <time.h>

#include "datatools.h"		/* helper functions	        */
#include "matadd.h"		/* my matrix add fucntion	*/
#include "matmat.h"		/* my matrix add fucntion	*/
#include "matvec.h"		/* my matrix add fucntion	*/


#if defined(__MACH__) && defined(__APPLE__)
#include <Accelerate/Accelerate.h>
#else
#include <cblas.h>
#endif


#define NREPEAT 100		/* repeat count for the experiment loop */

#define mytimer clock
#define delta_t(a,b) (1e3 * (b - a) / CLOCKS_PER_SEC)

int main(int argc, char *argv[]) {

    int    i, m, n, k, N = NREPEAT;
    double **A, **B, **C;
    double tcpu1; 

    clock_t t1, t2;
    
    m = 2;
	n = 6;
	k = 7;
	
	/* Allocate memory */
	A = malloc_2d(m,k);
	B = malloc_2d(k,n);
	C = malloc_2d(m,n);

	if (A == NULL || B == NULL | C == NULL) {
		fprintf(stderr, "Memory allocation error...\n");
		/* Free memory */
		free_2d(A);
		free_2d(B);
		free_2d(C);
		exit(EXIT_FAILURE);
	} 

	/* initialize with useful data - last argument is reference */
	init_data_2d(m,k,A,1);
	init_data_2d(k,n,B,2);

	// printf("dette er A \n");
	// print_matrix_2d(m,k,A);
	// printf("\n");

	// printf("dette er b \n");
	// print_matrix_1d(n, b);
	// printf("\n");

	/* timings for matadd */
	t1 = mytimer();
	for (i = 0; i < N; i++) {
		// matrix addition
		matmat(m,n,k,A,B,C);
	}		
	t2 = mytimer();
	tcpu1 = delta_t(t1, t2) / N;
	
	printf("dette er C \n");
	print_matrix_2d(m,n, C);
	printf("\n");

	// check_results("main", m, n, C);

	/* Print n and results  */
	printf("%4d %4d %8.3f\n", m, n, tcpu1);

	/* Free memory */
	free_2d(A);
	free_2d(B);
	free_2d(C);


	/* BLAS */
	int ii, incx, nn;
	double aa, xx[5] = {2.0,2.0,2.0,2.0,2.0};
	nn = 5; aa= 3.0; incx=1;
	cblas_dscal(nn,aa,xx,incx);
   
    return EXIT_SUCCESS;
}
