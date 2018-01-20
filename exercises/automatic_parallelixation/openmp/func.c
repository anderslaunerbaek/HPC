#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#ifdef _OPM
#include <omp.h>
#endif _OPM

double my_phi_func(int N) {
	// initialize
	int i;
	double N_inv, tmp_denum, sum_tot;
	sum_tot = 0.0;
	N_inv = pow(N, -1);

	double *sum_tmp = malloc(N * sizeof(double));
	if(sum_tmp == NULL) {
		printf("malloc of size %d failed!\n", N);   // could also call perror here
		exit(1);   // or return an error to caller
	}

	#pragma omp parallel shared(sum_tmp, N_inv, N) private(tmp_denum, i)
	{
	// do loop
	#pragma omp for
		for (i = 0; i < N; i++) {
			// don't do division
			tmp_denum = 1 + pow((i - 0.5) * N_inv, 2);
			sum_tmp[i] = 4 * pow(tmp_denum, -1);
		}
	} /* end of parallel */

	for (i = 0; i < N; i++) {
		sum_tot += sum_tmp[i];
	}


	// free
	free(sum_tmp);
	// division
	sum_tot = sum_tot * N_inv;

	// return
	return(sum_tot);
}

