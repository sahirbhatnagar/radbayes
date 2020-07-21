data {
  int<lower=1> N; // Number of data
  int<lower=1> M; // Number of features
  int<lower=1> L; // Number of covariates
  int<lower=1> R; // Number of sites
  matrix[N, M] X; // matrix of features
  matrix[N, L] Z; //matrix of covariates
  int S[N]; //vector of site
  int<lower =0, upper = 1> y[N];
}

// slab_scale = 5, slab_df = 25 -> 8 divergences

transformed data {
  real m0 = 10;           // Expected number of large slopes
  real slab_scale = 3;    // Scale for large slopes
  real slab_scale2 = square(slab_scale);
  real slab_df = 25;      // Effective degrees of freedom for large slopes
  real half_slab_df = 0.5 * slab_df;
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
  for (n in 1:N) y[n] ~ bernoulli_logit(Z[n] * eta + X[n] * beta[,S[n]] + alpha);
}
generated quantities {
  vector[N] yhat;
  for (n in 1:N) {
    yhat[n] = exp(Z[n] * eta + X[n] * beta[, S[n]] + alpha)/(1+exp(Z[n] * eta + X[n] * beta[, S[n]] + alpha));
  }
}
