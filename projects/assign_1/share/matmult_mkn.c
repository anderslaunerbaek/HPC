void matmult_mkn(int M, int N, int K, double **A, double **B, double **C) {
	for (int l = 0; l < M*N; l++) {
		C[0][l] = 0;
	}
    for (int m = 0; m < M; m++) {
    	for (int k = 0; k < K; k++) {
			for (int n = 0; n < N; n++) {
				C[m][n] += A[m][k] * B[k][n];
			}
    	}	
    }
}