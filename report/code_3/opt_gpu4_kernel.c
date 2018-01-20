void __global__ matmatgpu4(int M, int N, int K, double *d_A, double *d_B, double *d_C) 
{
    int i, j, k, sm, is;

    i = (blockIdx.y * blockDim.y + threadIdx.y)*6;
    j = blockIdx.x * blockDim.x + threadIdx.x;

    for (sm = 0; sm < 6; sm++){
        is = i + sm;
        if (is < M && j < N){
            d_C[is*N + j] = 0.0;

            for (k = 0; k < K; k++)
                d_C[is*N + j] += d_A[is*K + k] * d_B[k*N + j];
        }
    }
};