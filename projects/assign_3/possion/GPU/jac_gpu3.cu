extern "C" { 
#include <stdio.h>
#include <stdlib.h>
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
}

const int device0 = 0;
const int device1 = 1;
#define BLOCK_SIZE 16


void __global__ jac_gpu3_d0(int N, double delta, int max_iter, double *f, double *u, double *u_old, double *d1_u_old) {
    int j = blockIdx.x * blockDim.x + threadIdx.x;
    int i = blockIdx.y * blockDim.y + threadIdx.y;
    if (i < (N/2-1) && j < (N-1) && i > 0 && j > 0) {
        u[i*N + j] = 0.25 * (u_old[(i-1)*N + j] + u_old[(i+1)*N + j] + u_old[i*N + (j-1)] + u_old[i*N + (j+1)] + delta*delta*f[i*N + j]);    
    }
    else if (i == (N/2-1) && j < (N-1) && j > 0) {
        u[i*N + j] = 0.25 * (u_old[(i-1)*N + j] + d1_u_old[j] + u_old[i*N + (j-1)] + u_old[i*N + (j+1)] + delta*delta*f[i*N + j]);    
    }
}

void __global__ jac_gpu3_d1(int N, double delta, int max_iter, double *f, double *u, double *u_old, double *d0_u_old) {
    int j = blockIdx.x * blockDim.x + threadIdx.x;
    int i = blockIdx.y * blockDim.y + threadIdx.y;
    if (i < (N/2-1) && j < (N-1) && i > 0 && j > 0) { // i < N/2
        u[i*N + j] = 0.25 * (u_old[(i-1)*N + j] + u_old[(i+1)*N + j] + u_old[i*N + (j-1)] + u_old[i*N + (j+1)] + delta*delta*f[i*N + j]);        
    }
    else if (i == 0 && j < (N-1) && j > 0) {
        u[i*N + j] = 0.25 * (d0_u_old[(N/2-1)*N + j] + u_old[(i+1)*N+j] + u_old[i*N + (j-1)] + u_old[i*N + (j+1)] + delta*delta*f[i*N + j]);    
    }
}

int main(int argc, char *argv[]) {

    // warm up:
    double *dummy_d;
    cudaSetDevice(device0);
    cudaMalloc((void**)&dummy_d, 0);
    cudaSetDevice(device1);
    cudaMalloc((void**)&dummy_d, 0);

    int max_iter, N,i,j;

    if (argc == 3) {
        N = atoi(argv[1]) + 2;
        max_iter = atoi(argv[2]);
    }
    else {
        // use default N
        N = 128 + 2;
        max_iter = 5000;
    }
    double delta = 2.0/N;

    // allocate mem
    double *h_f, *h_u, *h_u_old;
    double *d0_f, *d0_u, *d0_u_old, *d1_f, *d1_u, *d1_u_old;

    int size_f = N * N * sizeof(double);
    int size_u = N * N * sizeof(double);
    int size_u_old = N * N * sizeof(double);
    int size_f_p2 = N*N/2;
    int size_u_p2 = N*N/2;
    int size_u_old_p2 = N*N/2;

    //Allocate memory on device
    cudaSetDevice(device0);
    cudaMalloc((void**)&d0_f, size_f/2);
    cudaMalloc((void**)&d0_u, size_u/2);
    cudaMalloc((void**)&d0_u_old, size_u_old/2);
    cudaSetDevice(device1);
    cudaMalloc((void**)&d1_f, size_f/2);
    cudaMalloc((void**)&d1_u, size_u/2);
    cudaMalloc((void**)&d1_u_old, size_u_old/2);
    //Allocate memory on host
    cudaMallocHost((void**)&h_f, size_f);
    cudaMallocHost((void**)&h_u, size_u);
    cudaMallocHost((void**)&h_u_old, size_u_old);

    // initialize boarder
    for (i = 0; i < N; i++){
        for (j = 0; j < N; j++){
            if (i >= N * 0.5  &&  i <= N * 2.0/3.0  &&  j >= N * 1.0/6.0  &&  j <= N * 1.0/3.0)
                h_f[i*N + j] = 200.0;
            else
                h_f[i*N + j] = 0.0; 

            if (i == (N - 1) || i == 0 || j == (N - 1)){
                h_u[i*N + j] = 20.0;
                h_u_old[i*N + j] = 20.0;
            }
            else{
                h_u[i*N + j] = 0.0;
                h_u_old[i*N + j] = 0.0;
            } 
        }
    }
    
    //Copy memory host -> device
    double time_tmp = omp_get_wtime(); 
    cudaSetDevice(device0);
    cudaMemcpy(d0_f, h_f, size_f/2, cudaMemcpyHostToDevice);
    cudaMemcpy(d0_u, h_u, size_u/2, cudaMemcpyHostToDevice);
    cudaMemcpy(d0_u_old, h_u_old, size_u_old/2, cudaMemcpyHostToDevice);
    cudaSetDevice(device1);
    cudaMemcpy(d1_f, h_f + size_f_p2, size_f/2, cudaMemcpyHostToDevice);
    cudaMemcpy(d1_u, h_u + size_u_p2, size_u/2, cudaMemcpyHostToDevice);
    cudaMemcpy(d1_u_old, h_u_old + size_u_old_p2, size_u_old/2, cudaMemcpyHostToDevice);
    double time_IO_1 = omp_get_wtime() - time_tmp; 

    // peer enable
    cudaSetDevice(device0);
    cudaDeviceEnablePeerAccess(device1,0);
    cudaSetDevice(device1);
    cudaDeviceEnablePeerAccess(device0,0);

    // do program
    int k = 0;
    dim3 dim_grid(((N +BLOCK_SIZE-1) / BLOCK_SIZE), ((N/2+BLOCK_SIZE-1) / BLOCK_SIZE));
    dim3 dim_block(BLOCK_SIZE, BLOCK_SIZE);
    double *temp_p;
    double time_compute = omp_get_wtime(); 
    while (k < max_iter) {
        // Set u_old = u device 0
        temp_p = d0_u;
        d0_u = d0_u_old;
        d0_u_old = temp_p;
        // Set u_old = u device 0
        temp_p = d1_u;
        d1_u = d1_u_old;
        d1_u_old = temp_p;

        cudaSetDevice(device0);
        jac_gpu3_d0<<<dim_grid, dim_block>>>(N, delta, max_iter, d0_f, d0_u, d0_u_old, d1_u_old);
        cudaSetDevice(device1);
        jac_gpu3_d1<<<dim_grid, dim_block>>>(N, delta, max_iter, d1_f, d1_u, d1_u_old, d0_u_old);
        cudaDeviceSynchronize();
        cudaSetDevice(device0);
        cudaDeviceSynchronize();
        k++;
    }/* end while */
    double tot_time_compute = omp_get_wtime() - time_compute;
    // end program

    //Copy memory host -> device
    time_tmp = omp_get_wtime(); 
    cudaSetDevice(device0);
    cudaMemcpy(h_u, d0_u, size_u/2, cudaMemcpyDeviceToHost);
    cudaSetDevice(device1);
    cudaMemcpy(h_u + size_u_p2, d1_u, size_u/2, cudaMemcpyDeviceToHost);
    double time_IO_2 = omp_get_wtime() - time_tmp; 

    tot_time_compute += time_IO_1 + time_IO_2;

    // stats
    double GB = 1.0e-09;
    double flop = max_iter * (double)(N-2) * (double)(N-2) * 10.0;
    double gflops  = (flop / tot_time_compute) * GB;
    double memory  = size_f + size_u + size_u_old;
    double memoryGBs  = memory * GB * (1 / tot_time_compute);

    printf("%g\t", memory); // footprint
    printf("%g\t", gflops); // Gflops
    printf("%g\t", memoryGBs); // bandwidth GB/s
    printf("%g\t", tot_time_compute); // total time
    printf("%g\t", time_IO_1 + time_IO_2); // I/O time
    printf("%g\t", tot_time_compute); // compute time
    printf("# gpu3\n");

    //write_result(h_u, N, delta, "./../../analysis/pos/jac_gpu3.txt");

    // peer enable
    cudaSetDevice(device0);
    cudaDeviceDisablePeerAccess(device1);
    cudaSetDevice(device1);
    cudaDeviceDisablePeerAccess(device0);

    // free mem
    cudaFree(d0_f), cudaFree(d0_u), cudaFree(d0_u_old);
    cudaFree(d1_f), cudaFree(d1_u), cudaFree(d1_u_old);
    cudaFreeHost(h_f), cudaFreeHost(h_u), cudaFreeHost(h_u_old);
    // end program
    return(0);
}
