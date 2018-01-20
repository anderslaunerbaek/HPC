void matmult_nat(int M, int N, int K, double **A, double **B, double **C) {
	for (int m = 0; m < M; m++) {
		for (int n = 0; n < N; n++) {
			C[m][n] = 0;
			for (int k = 0; k < K; k++) {
				C[m][n] += A[m][k] * B[k][n];
			}
    	}	
    }
}