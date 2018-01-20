#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

// setting GPU device
const int device0 = 0;
const int device1 = 1;
#define BLOCK_SIZE 16

void __global__ matvec(double *y, double *A, double *x, int M, int N) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    int j = blockIdx.y * blockDim.y + threadIdx.y;

    if (i < M && j < N) atomicAdd(&y[i], A[i * N + j] * x[j]);
}

int main(int argc, char *argv[]) {

    // warm up:
    double *dummy_d;
    cudaSetDevice(device0);
    cudaMalloc((void**)&dummy_d, 0);
    cudaSetDevice(device1);
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

    double *d0_A, *d0_b, *d0_c, *d1_A, *d1_b, *d1_c;
    double *h_A, *h_b, *h_c;
    int size_A = sizeof(double)*N*M, size_b = sizeof(double)*N, size_c = sizeof(double)*M;

    // GPU MULTI
    // Allocate memory on host and device
    cudaSetDevice(device0);
    cudaMalloc((void**)&d0_A, size_A/2);
    cudaMalloc((void**)&d0_b, size_b);
    cudaMalloc((void**)&d0_c, size_c/2);
    cudaSetDevice(device1);
    cudaMalloc((void**)&d1_A, size_A/2);
    cudaMalloc((void**)&d1_b, size_b);
    cudaMalloc((void**)&d1_c, size_c/2);
    
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
    cudaSetDevice(device0);
    cudaMemcpy(d0_A, h_A, size_A/2, cudaMemcpyHostToDevice);
    cudaMemcpy(d0_b, h_b, size_b, cudaMemcpyHostToDevice);
    
    cudaSetDevice(device1);
    cudaMemcpy(d1_A, h_A + size_A/2, size_A/2, cudaMemcpyHostToDevice);
    cudaMemcpy(d1_b, h_b, size_b, cudaMemcpyHostToDevice);
    time_IO_1 = omp_get_wtime()- time;
    
    // define grid and threads/block
    dim3 dim_grid((((M/2)+BLOCK_SIZE-1) / BLOCK_SIZE), (((N/2)+BLOCK_SIZE-1) / BLOCK_SIZE));
    dim3 dim_block(BLOCK_SIZE,BLOCK_SIZE);
    time_compute = omp_get_wtime();   
    cudaSetDevice(device0);
    matvec<<<dim_grid, dim_block>>>(d0_c, d0_A, d0_b, M/2, N);
    cudaSetDevice(device1);
    matvec<<<dim_grid, dim_block>>>(d1_c, d1_A, d1_b, M/2, N);
    cudaDeviceSynchronize();
    cudaSetDevice(device0);
    cudaDeviceSynchronize();
    time_compute_end = omp_get_wtime();
    
    // Copy result back to host
    cudaSetDevice(device0);
    cudaMemcpy(h_c, d0_c, size_c/2, cudaMemcpyDeviceToHost);
    cudaSetDevice(device1);
    cudaMemcpy(h_c + size_c/2, d1_c, size_c/2, cudaMemcpyDeviceToHost);

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
    printf("%g\t", gflops / 141.30); // pct. Gflops

    printf("%lg\t", memoryGBs); // bandwidth GB/s
    printf("%lg\t", memoryGBs / 17.96); // pct. bandwidth GB/s

    printf("%g\t", time_end - time); // total time
    printf("%g\t", time_IO_1 + time_IO_2); // I/O time
    printf("%g\n", tot_time_compute); // compute time


    // Cleanup
    cudaFreeHost(h_A), cudaFreeHost(h_b), cudaFreeHost(h_c); 
    cudaFree(d0_A), cudaFree(d0_b), cudaFree(d0_c); 
    cudaFree(d1_A), cudaFree(d1_b), cudaFree(d1_c); 

    return(0);
}


