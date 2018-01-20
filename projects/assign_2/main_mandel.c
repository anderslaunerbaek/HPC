#include <stdio.h>
#include <stdlib.h>
#include "func.h"
#include <omp.h>



int main(int argc, char *argv[]) {

    int   width, height;
    int	  max_iter, loops, n_cores;
    int   *image;
    double memory, mflops, ts, te; 
    
    memory = 0.0;
    mflops = 0.0;
    loops = 1;

    // command line argument sets the dimensions of the image
    if (argc == 3 ) {
		width = height = atoi(argv[1]);
        max_iter = atoi(argv[2]);
	}
	else {
		// use default N
        width    = 2601;
        height   = 2601;
        max_iter = 400;
	}

    // command line argument sets the dimensions of the image
    if ( argc == 2 ) width = height = atoi(argv[1]);

    image = (int *)malloc( width * height * sizeof(int));
    if ( image == NULL ) {
       fprintf(stderr, "memory allocation failed!\n");
       return(1);
    }
    
    // do program
    ts = omp_get_wtime();
    for(int i = 0; i < loops; i++ ) {
        n_cores = mandel(width, height, image, max_iter);
    }
    te = omp_get_wtime() - ts;

    printf("%d\t", n_cores);
    printf("%g\t", memory);
    printf("%g\t", mflops);
    printf("%g\n", te / loops);

    return(0);
}


