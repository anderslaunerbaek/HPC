void matmult_mnk(int M, int N, int K, double **A, double **B, double **C) {
	for (int l = 0; l < M*N; l++) {
		C[0][l] = 0;
	}
    for (int m = 0; m < M; m++) {
    	for (int n = 0; n < N; n++) {
			for (int k = 0; k < K; k++) {
				C[m][n] += A[m][k] * B[k][n];
			}
    	}	
    }
}