void matmult_lib(int M, int N, int K, double **A, double **B, double **C) {
	int layout, TRANSA, TRANSB, LDA, LDB, LDC;
	double alpha, beta;

    layout = 101; // rowmajor
	TRANSA = 111; // A is not transposed
	TRANSB = 111; // B is not transposed

	LDA = fmax(1,K); // leading dimension of A
	LDB = fmax(1,N); // leading dimension of B
	LDC = fmax(1,N); // leading dimension of C

	alpha = 1.0; // no scaling
	beta = 0.0; //

	cblas_dgemm(layout, TRANSA, TRANSB, M, N, K, alpha, *A, LDA, *B, LDB, beta, *C, LDC);    
}