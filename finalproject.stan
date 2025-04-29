data {
  int<lower=0> n;
  vector[n] Reals_USD_Exchange;
  vector[n] FedFundsRate_scaled;
  vector[n] JobPostings_scaled;
  array[n] int RecessionIndicator;  
}

parameters {
  real b0;
  real b1;
  vector[2] b2; // There are two levels: 1 means no recession and 2 means recession.
  real b3;
  real<lower=0> sigma;
}

model {
  vector[n] mu;
  vector[n] alpha;
  vector[n] lambda;
  for ( i in 1:n ) {
    mu[i] = exp(b0 + b1 * FedFundsRate_scaled[i] + b2[RecessionIndicator[i]] + b3 * JobPostings_scaled[i]);
    alpha[i] = mu[i]^2 / sigma^2;
    lambda[i] = mu[i] / sigma^2;
  }
  b0 ~ normal(0, 1); // TODO: change
  b1 ~ normal(1.5, 2);
  b2 ~ normal(1.5, 0.5);
  b3 ~ normal(125, 30);
  sigma ~ exponential(1);
  Reals_USD_Exchange ~ gamma(alpha, lambda);
}
