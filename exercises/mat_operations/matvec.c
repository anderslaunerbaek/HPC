void matvec(int m, int n, double **A, double *B, double *C) {
    
    for(int i = 0; i < m; i++) {
    	C[i] = 0;
    	for(int j = 0; j < n; j++) {
			C[i] += A[i][j] * B[j];
    	}
    }
}
