data {
  int<lower=1> N; // Number of data
  int<lower=1> M; // Number of covariates
  matrix[M, N] X;
  int<lower =0, upper = 1> y[N];
}

parameters {
  vector[M] beta_tilde;
  vector<lower=0>[M] lambda;
  real<lower=0> tau_tilde;
  real alpha;
  //real<lower=0> sigma;
}

model {
   // tau ~ cauchy(0, sigma)
  // beta ~ normal(0, tau * lambda)
  vector[M] beta = beta_tilde .* lambda * .25 * tau_tilde;

  beta_tilde ~ normal(0, 1);
  lambda ~ cauchy(0, 1);
  tau_tilde ~ cauchy(0, 1);

  alpha ~ normal(0, 2);
  //sigma ~ normal(0, 2);
  
  y ~ bernoulli_logit(X' * beta + alpha);
}