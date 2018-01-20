void matadd(int m, int n, double **A, double **B, double **C) {
    for(int i = 0; i < m; i++) {
    	for(int j = 0; j < n; j++) {
    		C[i][j] = A[i][j] + B[i][j];	
    	}	
    }
}
