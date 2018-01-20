#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <cublas_v2.h>

// setting GPU device
const int device = 0;
#define BLOCK_SIZE 16

void matvec(cublasHandle_t handle, double *y, double *A, double *x, int M, int N) {

    int lda = M; // leading dimension of A
    double alpha = 1.0, beta = 0.0; // constants for dgemv
    int incx = 1, incy = 1;

    cublasDgemv(handle, CUBLAS_OP_T, M, N, &alpha, A, lda, x, incx, &beta, y, incy);
}


int main(int argc, char *argv[]) {
    // cuBLAS handle??
    cublasStatus_t stat;
    cublasHandle_t handle;

    // initialization of CUBLAS
    stat = cublasCreate(&handle);
    if(stat != CUBLAS_STATUS_SUCCESS) {
      printf ("CUBLAS initialization failed\n");
      return EXIT_FAILURE;
    }


    // warm up:
    cudaSetDevice(device);
    double *dummy_d;
    cudaMalloc((void**)&dummy_d, 0);

    // command line argument sets the dimensions of the image
    int M,N;
    if ( argc == 3 ) {
        M = atoi(argv[1]);
        N = atoi(argv[2]);
    } else {
        // default   
        N = 2048;
        M = 2048;
    }

    double *d_A, *d_b, *d_c;
    double *h_A, *h_b, *h_c;
    int size_A = sizeof(double)*N*M, size_b = sizeof(double)*N, size_c = sizeof(double)*M;

    // GPU
    // Allocate memory on host and device
    cudaMalloc((void**)&d_A, size_A);
    cudaMalloc((void**)&d_b, size_b);
    cudaMalloc((void**)&d_c, size_c);
    cudaMallocHost((void**)&h_A, size_A);
    cudaMallocHost((void**)&h_b, size_b);
    cudaMallocHost((void**)&h_c, size_c);


    // initialize d_A and d_b
    double init_A = 2.0, init_b = 2.0;
    // double check_ele = (double)M*(init_A * (double)N + init_b * (double)N);
    for (int i = 0; i < M*N; i++) h_A[i] = init_A;
    for (int i = 0; i < N; i++) h_b[i] = init_b;

    // copy data
    double time,time_end,time_IO_1,time_IO_2,time_compute,time_compute_end,tot_time_compute;
    time = omp_get_wtime();
    cudaMemcpy(d_A, h_A, size_A, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, h_b, size_b, cudaMemcpyHostToDevice);
    time_IO_1 = omp_get_wtime()- time;
    
   
    time_compute = omp_get_wtime();   
    matvec(handle, d_c, d_A, d_b, M, N);
    cudaDeviceSynchronize();
    time_compute_end = omp_get_wtime();
    
    // Copy result back to host
    cudaMemcpy(h_c, d_c, size_c, cudaMemcpyDeviceToHost);
    time_end = omp_get_wtime();
    time_IO_2 = time_end - time_compute_end;
    tot_time_compute = time_compute_end - time_compute;

    // stats
    double GB = 1.0e-09;
    double gflops  = (N * M * 2 / tot_time_compute) * GB;
    double memory  = size_A + size_b + size_c;
    double memoryGBs  = memory * GB * (1 / tot_time_compute);

    printf("%g\t", memory); // footprint
    printf("%g\t", gflops); // Gflops
    printf("%g\t", gflops / 70.65); // pct. Gflops

    printf("%g\t", memoryGBs); // bandwidth GB/s
    printf("%g\t", memoryGBs / 8.98); // pct. bandwidth GB/s

    printf("%g\t", time_end - time); // total time
    printf("%g\t", time_IO_1 + time_IO_2); // I/O time
    printf("%g\n", tot_time_compute); // compute time

    // Cleanup
    cudaFreeHost(h_A), cudaFreeHost(h_b), cudaFreeHost(h_c); 
    cudaFree(d_A), cudaFree(d_b), cudaFree(d_c); 
    cublasDestroy(handle);

    return(0);
}
