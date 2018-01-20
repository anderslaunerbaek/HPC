#include <stdio.h>
#include <omp.h>

void write_result(double *U, int N, double delta, char filename[40]) {
	double u, y, x;
	FILE *matrix=fopen(filename, "w");
	for (int i = 0; i < N; i++) {
		x = -1.0 + i * delta + delta * 0.5;
		for (int j = 0; j < N; j++) {
			y = -1.0 + j * delta + delta * 0.5;
			u = U[i*N + j];
			fprintf(matrix, "%g\t%g\t%g\n", x,y,u);
		}
	}
	fclose(matrix);
}

void jac_cpu(int N, double delta, int max_iter, double *f, double *u, double *u_old) {
    int i,j,k=0;
    double *temp;
    
    // do calculations
    #pragma omp parallel shared(f, u, u_old, N) private(i, j) firstprivate(k)
    {
    while (k < max_iter) {
        #pragma omp single 
        {
            // Set u_old = u
            temp = u;
            u = u_old;
            u_old = temp;
        }
        #pragma omp for
        for (i = 1; i < N-1; i++) {
            for (j = 1; j < N-1; j++) {
                // Update u
                u[i*N + j] = 0.25 * (u_old[(i-1)*N + j] + u_old[(i+1)*N + j] + u_old[i*N + (j-1)] + u_old[i*N + (j+1)] + delta*delta*f[i*N + j]);
            }
        }
        k++;
    }/* end while */
    } /* end of parallel region */;
}
