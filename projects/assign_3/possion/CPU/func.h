#include <stdio.h>
#include <omp.h>

void write_result(double *U, int N, double delta, char filename[40]);
void jac_cpu(int N, double delta, int max_iter, double *f, double *u, double *u_old);
