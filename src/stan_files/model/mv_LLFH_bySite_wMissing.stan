data {
  int<lower=1> N; // Number of data rows
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
  int<lower =0, upper = 1> y_obs2[N_obs];
  int<lower =0, upper = 1> y_mis2[N_mis];
}

// slab_scale = 5, slab_df = 25 -> 8 divergences

transformed data {
  real m0 = 10;           // Expected number of large slopes
  real slab_scale = 3;    // Scale for large slopes
  real slab_scale2 = square(slab_scale);
  real slab_df = 20;      // Effective degrees of freedom for large slopes
  real half_slab_df = 0.5 * slab_df;
  //int N = N_obs + N_mis;
}

parameters {
  matrix[M, R] beta_tilde;
  vector[L] eta;
//  vector[R] zeta;
  matrix<lower=0>[M, R] lambda;
  real<lower=0> c2_tilde;
  real<lower=0> tau_tilde;
  real alpha;
  matrix[M, R] beta_tilde2;
  vector[L] eta2;
//  vector[R] zeta;
  matrix<lower=0>[M, R] lambda2;
  real<lower=0> c2_tilde2;
  real<lower=0> tau_tilde2;
  real alpha2;
  real phi;
 // real mu_zeta;
 // real<lower=0> sigma_zeta;
  //real<lower=0> sigma;
}

transformed parameters {
  matrix[M, R] beta;
  matrix[M, R] beta2;
  {
    real tau0 = (m0 / (M - m0)) * (2 / sqrt(1.0 * N));
    real tau = tau0 * tau_tilde; // tau ~ cauchy(0, tau0)
    real tau2 = tau0 * tau_tilde2;
    // c2 ~ inv_gamma(half_slab_df, half_slab_df * slab_scale2)
    // Implies that marginally beta ~ student_t(slab_df, 0, slab_scale)
    real c2 = slab_scale2 * c2_tilde;
    
    // c2 ~ inv_gamma(half_slab_df, half_slab_df * slab_scale2)
    // Implies that marginally beta ~ student_t(slab_df, 0, slab_scale)
    matrix[M, R] lambda_tilde =
      sqrt( c2 * square(lambda) ./ (c2 + square(tau) * square(lambda)) );
    matrix[M, R] lambda_tilde2 =
      sqrt( c2 * square(lambda2) ./ (c2 + square(tau2) * square(lambda2)) );
    // beta ~ normal(0, tau * lambda_tilde)
    beta = tau * lambda_tilde .* beta_tilde;
    // beta ~ normal(0, tau * lambda_tilde)
    beta2 = tau2 * lambda_tilde2 .* beta_tilde2;
  }
}
model {
  for (r in 1:R) beta_tilde[,r] ~ normal(0, 1);
  for (r in 1:R) lambda[,r] ~ cauchy(0, 1);
  tau_tilde ~ cauchy(0, 1);
  c2_tilde ~ inv_gamma(half_slab_df, half_slab_df);
  eta ~ normal(0, 2);
  alpha ~ normal(0, 2);
  for (r in 1:R) beta_tilde2[,r] ~ normal(0, 1);
  for (r in 1:R) lambda2[,r] ~ cauchy(0, 1);
  tau_tilde2 ~ cauchy(0, 1);
  c2_tilde2 ~ inv_gamma(half_slab_df, half_slab_df);
  eta2 ~ normal(0, 2);
  alpha2 ~ normal(0, 2);
 // zeta ~ normal(mu_zeta, sigma_zeta);
 // mu_zeta ~ normal(0, 2);
 // sigma_zeta ~ normal(0, 2);
  //sigma ~ normal(0, 2);
  for (n in 1:N_obs) {
    y_obs[n] ~ bernoulli_logit(Z_obs[n] * eta + X_obs[n] * beta[,S_obs[n]] + alpha);
    y_obs2[n] ~ bernoulli_logit(Z_obs[n] * eta2 + X_obs[n] * beta2[,S_obs[n]] + alpha2 + phi*inv_logit(Z_obs[n] * eta + X_obs[n] * beta[, S_obs[n]] + alpha));
    
  }
  
  for (n in 1:N_mis) {
  real mu_mis = Z_mis[n] * eta + X_mis[n] * beta[,S_mis[n]] + alpha;
  target += log_mix(inv_logit(mu_mis), bernoulli_logit_lpmf(1 | mu_mis), 
                                    bernoulli_logit_lpmf(0 | mu_mis));
  y_mis2[n] ~ bernoulli_logit(Z_mis[n] * eta2 + X_mis[n] * beta2[,S_mis[n]] + alpha2 + phi*inv_logit(Z_mis[n] * eta + X_mis[n] * beta[, S_mis[n]] + alpha));                                 
}

}
generated quantities {
  vector[N_obs] yhat_obs;
  vector[N_mis] yhat_mis;
  vector[N_obs] yhat_obs2;
  vector[N_mis] yhat_mis2;
  for (n in 1:N_obs) {
    yhat_obs[n] = inv_logit(Z_obs[n] * eta + X_obs[n] * beta[, S_obs[n]] + alpha);
    yhat_obs2[n] = inv_logit(Z_obs[n] * eta2 + X_obs[n] * beta2[, S_obs[n]] + alpha2 + phi*inv_logit(Z_obs[n] * eta + X_obs[n] * beta[, S_obs[n]] + alpha));
  }
  for (n in 1:N_mis) {
    yhat_mis[n] = inv_logit(Z_mis[n] * eta + X_mis[n] * beta[, S_mis[n]] + alpha);
    yhat_mis2[n] = inv_logit(Z_mis[n] * eta2 + X_mis[n] * beta2[, S_mis[n]] + alpha2 + phi*inv_logit(Z_mis[n] * eta + X_mis[n] * beta[, S_mis[n]] + alpha));
}}






