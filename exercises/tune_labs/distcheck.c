#include "distcheck.h"
#include <unistd.h>

#ifdef ALL_IN_ONE

double 
distcheck(particle_t *p, int n) {

	double tmp_tot_length = 0;

	for (int i = 0; i < n; i++ ) {
		tmp_tot_length += p[i].dist;
    }
    return(tmp_tot_length);
}

#else

double 
distcheck(double *v, int n) {

	double tmp_tot_length = 0;
	for (int i = 0; i < n; i++ ) {
    	tmp_tot_length += v[i];
    }
    return(tmp_tot_length);
}

#endif
