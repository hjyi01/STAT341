data {
  int<lower=0> n;
  vector[n] Reals_USD_Exchange;
  vector[n] FedFundsRate;
  vector[n] JobPostings;
  array[n] int RecessionIndicator;  
}
parameters {
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
    mu[i] = exp(b1 * FedFundsRate[i] + b2 * JobPostings[i] + b3[RecessionIndicator[i]]);
    alpha[i] = mu[i]^2 / sigma^2;
    lambda[i] = mu[i] / sigma^2;
  }
  b1 ~ normal(1.5, 2);
  b2 ~ normal(0.5, 0.5);
  b3 ~ normal(125, 30);
  sigma ~ exp(0,1);
  Reals_USD_Exchange ~ gamma(alpha, lambda); 
}
