## Program to show the usage of the functions in
## gslrand.c and curand.c
## By Adam J. Suarez, Last Edited: 4/10/2015

## Load shared libraries
dyn.load("gslrand.so")
dyn.load("cudanorm.so")

## Set seed and iniitalize resources
seed <- 1
.Call("INIT_GSL_RNG",seed)
.Call("INIT_CURAND_RNG",seed)

## ## Generate N standard normals using N.cores CPU cores
N <- 10
N.cores <- 1
.Call("rnorm_gsl",N,N.cores)

## ## Make an MxM  covariance matrix
M <- 5
diags <- as.numeric(seq(10,0,length.out = M))
Sigma <- toeplitz(diags)

## ## Generate N samples of M-dimemsional multivariate normals
## ## centered at 0 with covariance Sigma
N <- 10
.Call("rmvnorm_cuda",N,M,Sigma)

## Free resources
## Once you run these, you need to initialize again
## Else you may crash R
.Call("FREE_GSL_RNG")
.Call("FREE_CURAND_RNG")

