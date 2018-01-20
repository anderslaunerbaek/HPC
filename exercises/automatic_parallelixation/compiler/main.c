#include <stdio.h>
#include <stdlib.h>
#include "func.h"

int main ( int argc, char *argv[] )   {
	// init
	int N;
	double res;
	// get input

	if (argc == 2 ) {
		N = atoi(argv[1]);
	}
	else {
		// use default N
		N = 10000000;
	}

	// calculate result
	res = my_phi_func(N);

	printf("phi: ");
	printf("%f\n", res);

	return(0);
}


