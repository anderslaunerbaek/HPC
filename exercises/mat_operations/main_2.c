#include <stdlib.h>
#include <stdio.h>
#include <time.h>

#include "datatools.h"		/* helper functions	        */
#include "matadd.h"		/* my matrix add fucntion	*/
#include "matmat.h"		/* my matrix add fucntion	*/
#include "matvec.h"		/* my matrix add fucntion	*/

#define NREPEAT 100		/* repeat count for the experiment loop */

#define mytimer clock
#define delta_t(a,b) (1e3 * (b - a) / CLOCKS_PER_SEC)

int main(int argc, char *argv[]) {

    int    i, m, n, N = NREPEAT;
    double **A, *b, *c;
    double tcpu1; 

    clock_t t1, t2;
    
    m = 10;
	n = 10;
	
	/* Allocate memory */
	A = malloc_2d(m, n);
	b = malloc_1d(n);
	c = malloc_1d(m);

	if (A == NULL || b == NULL | c == NULL) {
		fprintf(stderr, "Memory allocation error...\n");
		exit(EXIT_FAILURE);
	} 

	/* initialize with useful data - last argument is reference */

	init_data_2d(m,n,A,1);
	init_data_1d(n,b,2);

	// A[0][0]=1; A[1][0]=1;	A[0][1]=1; A[1][1]=1;	A[0][2]=1; A[1][2]=1;
	// b[0]=2;	b[1]=2;	b[2]=2;



	printf("dette er A \n");
	print_matrix_2d(m,n,A);
	printf("\n");

	printf("dette er b \n");
	print_matrix_1d(n, b);
	printf("\n");

	/* timings for matadd */
	t1 = mytimer();
	for (i = 0; i < N; i++) {
		// matrix addition
		matvec(m,n,A,b,c);
	}		
	t2 = mytimer();
	tcpu1 = delta_t(t1, t2) / N;
	
	printf("dette er c \n");
	print_matrix_1d(m, c);
	printf("\n");

	// check_results("main", m, n, C);

	/* Print n and results  */
	printf("%4d %4d %8.3f\n", m, n, tcpu1);

	/* Free memory */
	free_2d(A);
	free_1d(b);
	free_1d(c);
   
    return EXIT_SUCCESS;
}
