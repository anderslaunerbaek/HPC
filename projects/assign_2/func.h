#ifdef _OPM
#include <omp.h>
#endif _OPM


int jac_seq(int N, double delta, double threshold, int max_iter, double *f, double *u, double *u_old);
int jac_seq_con(int N, double delta, double threshold, int max_iter, double *f, double *u, double *u_old);

int jac_mp(int N, double delta, double threshold, int max_iter, double *f, double *u, double *u_old);
int jac_mp_v2(int N, double delta, double threshold, int max_iter, double *f, double *u, double *u_old);
int jac_mp_v3(int N, double delta, double threshold, int max_iter, double *f, double *u, double *u_old);
int jac_mp_v23(int N, double delta, double threshold, int max_iter, double *f, double *u, double *u_old);

int gauss(int N, double delta, double threshold, int max_iter, double *f, double *u);
int gauss_con(int N, double delta, double threshold, int max_iter, double *f, double *u);

int mandel(int disp_width, int disp_height, int *array, int max_iter);

void write_result(double *U, int N, double delta, char filename[20]);
