#include "distance.h"
#include <unistd.h>
#include <math.h>

#ifdef ALL_IN_ONE

double 
distance(particle_t *p, int n) {
    
	double tmp_tot_length = 0;
	for (int i = 0; i < n; i++ ) {
		
		p[i].dist = sqrt(pow(p[i].x,2) + pow(p[i].y,2) + pow(p[i].z,2));
		tmp_tot_length += p[i].dist;

    }
    return(tmp_tot_length);
}

#else

double 
distance(particle_t *p, double *v, int n) {
    
	double tmp_tot_length = 0;
	for (int i = 0; i < n; i++ ) {
		v[i] = sqrt(pow(p[i].x,2) + pow(p[i].y,2) + pow(p[i].z,2));
    	tmp_tot_length += v[i];
    }
    return(tmp_tot_length);
}

#endif
