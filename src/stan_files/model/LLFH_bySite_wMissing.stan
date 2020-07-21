data {
  //int<lower=1> N; // Number of data rows
  int<lower = 1> N_obs; // Number of observed
  int<lower = 1> N_mis; // Number of missing
  int<lower=1> M; // Number of features
  int<lower=1> L; // Number of covariates
  int<lower=1> R; // Number of sites
  matrix[N_obs, M] X_obs; // matrix of features for observed outcomes
  matrix[N_mis, M] X_mis; // matrix of features for missing outcomes
  matrix[N_obs, L] Z_obs; //matrix of covariates for observed outcomes
  matrix[N_mis, L] Z_mis; //matrix of covariates for missing outcomes
  int S_obs[N_obs]; //vector of site for observed outcomes
  int S_mis[N_mis]; //vector of site for missing outcomes
  int<lower =0, upper = 1> y_obs[N_obs];
}

// slab_scale = 5, slab_df = 25 -> 8 divergences

transformed data {
  real m0 = 10;           // Expected number of large slopes
  real slab_scale = 3;    // Scale for large slopes
  real slab_scale2 = square(slab_scale);
  real slab_df = 25;      // Effective degrees of freedom for large slopes
  real half_slab_df = 0.5 * slab_df;
  int N = N_obs + N_mis;
}

parameters {
  matrix[M, R] beta_tilde;
  vector[L] eta;
//  vector[R] zeta;
  matrix<lower=0>[M, R] lambda;
  real<lower=0> c2_tilde;
  real<lower=0> tau_tilde;
  real alpha;
 // real mu_zeta;
 // real<lower=0> sigma_zeta;
  //real<lower=0> sigma;
}

transformed parameters {
  matrix[M, R] beta;
  {
    real tau0 = (m0 / (M - m0)) * (4 / sqrt(1.0 * N));
    real tau = tau0 * tau_tilde; // tau ~ cauchy(0, tau0)
    
    // c2 ~ inv_gamma(half_slab_df, half_slab_df * slab_scale2)
    // Implies that marginally beta ~ student_t(slab_df, 0, slab_scale)
    real c2 = slab_scale2 * c2_tilde;
    
    matrix[M, R] lambda_tilde =
      sqrt( c2 * square(lambda) ./ (c2 + square(tau) * square(lambda)) );
    
    // beta ~ normal(0, tau * lambda_tilde)
    beta = tau * lambda_tilde .* beta_tilde;
  }
}

model {
  for (r in 1:R) beta_tilde[,r] ~ normal(0, 1);
  for (r in 1:R) lambda[,r] ~ cauchy(0, 1);
  tau_tilde ~ cauchy(0, 1);
  c2_tilde ~ inv_gamma(half_slab_df, half_slab_df);
  eta ~ normal(0, 2);
  alpha ~ normal(0, 2);
 // zeta ~ normal(mu_zeta, sigma_zeta);
 // mu_zeta ~ normal(0, 2);
 // sigma_zeta ~ normal(0, 2);
  //sigma ~ normal(0, 2);
  for (n in 1:N_obs) y_obs[n] ~ bernoulli_logit(Z_obs[n] * eta + X_obs[n] * beta[,S_obs[n]] + alpha);
  
  for (n in 1:N_mis) {
  real mu_mis = Z_mis[n] * eta + X_mis[n] * beta[,S_mis[n]] + alpha;
  target += log_mix(inv_logit(mu_mis), bernoulli_logit_lpmf(1 | mu_mis), 
                                    bernoulli_logit_lpmf(0 | mu_mis));
}
}
generated quantities {
  vector[N_obs] yhat_obs;
  vector[N_mis] yhat_mis;
  for (n in 1:N_obs) {
    yhat_obs[n] = exp(Z_obs[n] * eta + X_obs[n] * beta[, S_obs[n]] + alpha)/(1+exp(Z_obs[n] * eta + X_obs[n] * beta[, S_obs[n]] + alpha));
  }
  for (n in 1:N_mis) {
    yhat_mis[n] = exp(Z_mis[n] * eta + X_mis[n] * beta[, S_mis[n]] + alpha)/(1+exp(Z_mis[n] * eta + X_mis[n] * beta[, S_mis[n]] + alpha));
}}






