/* Functions to set GSL rng and generate standard normal random variables */
/* Multithreaded */
/* For use as a shared library in R */
/* Compile with something like: */
/* gcc -fPIC -shared -fopenmp -O3 -march=native gslrand.c -o gslrand.so -lgsl */
/* or */
/* icc -fPIC -shared -openmp -O3 -xHost gslrand.c -o gslrand.so -lgsl */
/* By Adam J. Suarez, Last Edited: 4/3/2015 */

#include <omp.h> 
#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>
#include <R.h>
#include <Rinternals.h>

const gsl_rng_type *GSL_rng_t;
gsl_rng **GSL_rng;
int GSL_nt;
char L_char='L',N_char='N',R_char='R',T_char='T';

SEXP INIT_GSL_RNG(SEXP SEED){
  int j,seed=asInteger(SEED),i;
  GSL_nt=omp_get_max_threads();
    
  gsl_rng_env_setup();
  GSL_rng_t = gsl_rng_mt19937;
  GSL_rng = (gsl_rng **) malloc(GSL_nt * sizeof(gsl_rng *));

  omp_set_num_threads(GSL_nt);

#pragma omp parallel for private(i) shared(GSL_rng,GSL_rng_t) schedule(static,1)
  for(j=0;j<GSL_nt;j++){
    i=omp_get_thread_num();
    GSL_rng[i] = gsl_rng_alloc (GSL_rng_t);
    gsl_rng_set(GSL_rng[i],seed+i);
  }

  return R_NilValue; 
}

void generate_normal(double *out_v, int n, int nt){
  int j;
#pragma omp parallel for shared(out_v,GSL_rng) num_threads(nt)
   for(j=0;j<n;j++){
       out_v[j] = gsl_ran_gaussian_ziggurat(GSL_rng[omp_get_thread_num()],1);
   }
}

SEXP rnorm_gsl(SEXP N, SEXP NT)
 {
   int n=asInteger(N),nt=asInteger(NT);
   SEXP result = PROTECT(allocVector(REALSXP,n));
   double * out_v = REAL(result);

   generate_normal(out_v,n,nt);

   UNPROTECT(1);
   return result;
 }

SEXP FREE_GSL_RNG(void){
  int j;
  for(j=0;j<GSL_nt;j++) {gsl_rng_free(GSL_rng[j]);}
  return R_NilValue;
}

