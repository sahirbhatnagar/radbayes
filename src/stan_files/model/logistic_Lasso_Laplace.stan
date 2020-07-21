data {
  int<lower=1> N; // Number of data
  int<lower=1> M; // Number of covariates
  matrix[N, M] X;
  int<lower =0, upper = 1> y[N];
}


parameters {
  vector[M] beta;
  real alpha;
  //real<lower=0> sigma;
}

model {
   // tau ~ cauchy(0, sigma)
  // beta ~ normal(0, tau * lambda)
    beta ~ double_exponential(0, 1);
  alpha ~ normal(0, 2);

  //sigma ~ normal(0, 2);
  
  y ~ bernoulli_logit(X * beta + alpha);
}
generated quantities {
  vector[N] log_lik;
  for (n in 1:N) {
    log_lik[n] = bernoulli_logit_lpmf(y[n] |  X[n] * beta + alpha);
  }
}
