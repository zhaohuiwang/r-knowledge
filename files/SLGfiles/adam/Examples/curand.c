/* Functions to initialize/free CUDA resources and to generate multivariate normal samples  */
/* For use as a shared library in R */
/* Compile with something like: */
/* gcc -fPIC -shared -O3 -march=native curand.c -o cudanorm.so -lcudart -lcublas -lcurand -lcula_lapack */
/* or */
/* icc -fPIC -shared -O3 -xHost curand.c -o cudanorm.so -lcudart -lcublas -lcurand -lcula_lapack */
/* By Adam J. Suarez, Last Edited: 4/10/2015 */

#include <cuda.h>
#include <curand.h>
#include <cublas.h>
#include <R.h>
#include <Rinternals.h>

curandGenerator_t CURAND_gen;
cublasHandle_t handle;

SEXP INIT_CURAND_RNG(SEXP SEED){
  curandCreateGenerator(&CURAND_gen, CURAND_RNG_PSEUDO_MTGP32);
  curandSetPseudoRandomGeneratorSeed(CURAND_gen,asInteger(SEED));

  culaInitialize();
  cublasCreate_v2(&handle);

  return R_NilValue;
}

SEXP rmvnorm_cuda(SEXP N, SEXP M, SEXP SIGMA)
{
  size_t n = (size_t) asInteger(N), m=asInteger(M),i;

  double * devData, *dev_sigma;  
  cudaMalloc((void **)&devData, n*m*sizeof(double));
  cudaMalloc((void **)&dev_sigma, m*m*sizeof(double));

  SEXP result = PROTECT(allocMatrix(REALSXP,n,m)),SIGMA2 = PROTECT(duplicate(SIGMA));
  double * hostData = REAL(result), * sigma = REAL(SIGMA2),alpha=1.0;

  cudaMemcpy(dev_sigma, sigma, m * m*sizeof(double), cudaMemcpyHostToDevice);

  culaDeviceDpotrf('L',m,dev_sigma,m);

  curandGenerateNormalDouble(CURAND_gen, devData, n*m, 0.0, 1.0);

  cublasDtrmm_v2(handle, CUBLAS_SIDE_RIGHT, CUBLAS_FILL_MODE_LOWER, CUBLAS_OP_T, CUBLAS_DIAG_NON_UNIT,n,m,&alpha,dev_sigma,m,devData,n,devData,n);

  cudaMemcpy(hostData, devData, n * m*sizeof(double), cudaMemcpyDeviceToHost);

  cudaFree(devData);
  cudaFree(dev_sigma);
  UNPROTECT(2);
  return result;
}

SEXP FREE_CURAND_RNG(void){
  cublasDestroy_v2(handle);
  curandDestroyGenerator(CURAND_gen);
  culaShutdown();
  return R_NilValue;
}
