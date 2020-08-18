functions {
  int sum2d(int[,] a) {
    int s = 0;
    for (i in 1:size(a))
      s += sum(a[i]);
    return s;
  }
}
data {
  int<lower=1> N; // Number of data
  int<lower=1> M; // Number of features
  int<lower=1> L; // Number of covariates
  int<lower=1> R; // Number of sites
  int<lower=1> D; // Number of outcomes
  matrix[N, M] X; // matrix of features
  matrix[N, L] Z; //matrix of covariates
  int S[N]; //vector of site
  int<lower =0, upper = 1> y[N, D];
}
transformed data {
  real m0 = 10;           // Expected number of large slopes
  real slab_scale = 3;    // Scale for large slopes
  real slab_scale2 = square(slab_scale);
  real slab_df = 25;      // Effective degrees of freedom for large slopes
  real half_slab_df = 0.5 * slab_df;
  int<lower=0> N_pos;
  int<lower=1,upper=N> n_pos[sum2d(y)];
  int<lower=1,upper=D> d_pos[size(n_pos)];
  int<lower=0> N_neg;
  int<lower=1,upper=N> n_neg[(N * D) - size(n_pos)];
  int<lower=1,upper=D> d_neg[size(n_neg)];

  N_pos = size(n_pos);
  N_neg = size(n_neg);
  {
    int i;
    int j;
    i = 1;
    j = 1;
    for (n in 1:N) {
      for (d in 1:D) {
        if (y[n,d] == 1) {
          n_pos[i] = n;
          d_pos[i] = d;
          i += 1;
        } else {
          n_neg[j] = n;
          d_neg[j] = d;
          j += 1;
        }
      }
    }
  }
}
parameters {
  matrix[M, D] beta_tilde[R];
  matrix[L, D] eta;
  matrix<lower=0>[M, D] lambda[R];
  real<lower=0> c2_tilde;
  real<lower=0> tau_tilde;
  vector[D] alpha;
  cholesky_factor_corr[D] L_Omega;
  vector<lower=0>[N_pos] z_pos;
  vector<upper=0>[N_neg] z_neg;
}
transformed parameters {
  vector[D] z[N];
  matrix[M, D] beta[R];
  {
    real tau0 = (m0 / (M - m0)) * (4 / sqrt(1.0 * N));
    real tau = tau0 * tau_tilde; 
    real c2 = slab_scale2 * c2_tilde;
    matrix[M, D] lambda_tilde[R];
    for (r in 1:R) {
      lambda_tilde[r] = sqrt( c2 * square(lambda[r]) ./ (c2 + square(tau) * square(lambda[r])) );
      beta[r] = tau * lambda_tilde[r] .* beta_tilde[r];
    }
  }
  for (n in 1:N_pos)
    z[n_pos[n], d_pos[n]] = z_pos[n];
  for (n in 1:N_neg)
    z[n_neg[n], d_neg[n]] = z_neg[n];
}

model {
  L_Omega ~ lkj_corr_cholesky(4);
  for (r in 1:R) to_vector(beta_tilde[r]) ~ normal(0, 1);
  for (r in 1:R) to_vector(lambda[r]) ~ cauchy(0, 1);
  tau_tilde ~ cauchy(0, 1);
  c2_tilde ~ inv_gamma(half_slab_df, half_slab_df);
  to_vector(eta) ~ normal(0, 2);
  alpha ~ normal(0, 2);
  for (n in 1:N) z[n] ~ multi_normal_cholesky(Z[n] * eta + X[n] * beta[S[n]] + alpha', L_Omega);
}
generated quantities {
  matrix[N, D] zhat;
  corr_matrix[D] Omega;
  Omega = multiply_lower_tri_self_transpose(L_Omega);
  for (n in 1:N) {
    zhat[n] = Z[n] * eta + X[n] * beta[S[n]] + alpha';
  }
}
