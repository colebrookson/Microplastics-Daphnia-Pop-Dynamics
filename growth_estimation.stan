functions{
  real[] dZ_dt(
    real t, // time values
    real [] Z, // System state (length, reproductive rate)
    real [] theta, // parameters
    real [] dat, // data
    int [] dat_i) {
    real l = Z[1]; // system, length
    real R = Z[2]; // system, reproductive rate
    
    real r = theta[1]; // von bertalanffy growth rate 
    real sA = theta[2]; // 
    
    }

    real dl_dt = r*(2/(2 - sA))*(1-sA - l);
    real R_r = b + H*(c*(O*P/(1 + O*P*h))-u);
    return({dl_dt,R_r}); // Return the system state
}

data{
  int<lower=0>N; // Define N as non-negative integer
  real ts[N]; // Assigns time points to N
  real y0[2]; // Initial conditions for ODE
  real<lower=0>y[N,2]; // Define y as real and non-negative
}

parameters{
  real<lower=0>r;
  real<lower=0,upper=1>O;
  real<lower=0>h;
  real<lower=0>b;
  real<lower=0>c;
  real<lower=0,upper=1>u;
}

transformed parameters{
  // Stiff solver; backwards differentiation formula
  real Z[N-1,2];
  for (i in 2:N) { // Start at 2nd time step because giving the first
    Z[i-1,] = integrate_ode_bdf(dZ_dt, // Function
    y[i-1], // Initial value (empirical data point at previous time step)
    0, // Current time step; keep this at 0
    ts[i], // Next time step (time step to be solved/estimated)
    {r, O, h, b, c, u},
    rep_array(0.0,2),rep_array(0,2),1e-10,1e-10,2e4);
  }
}

model{ // Ignore the means/variances for now...
  r~normal(2.5,1);
  O~normal(0.015,0.5); 
  h~normal(0.075,0.5); 
  b~normal(35,1); 
  c~normal(0.3,0.5); 
  u~normal(0.4,0.5);
  for (k in 1:2){
    y[ ,k]~poisson(Z[ ,k]);
  }
}

generated quantities {
  int y_rep[N, 2];
  for (k in 1:2) {
    for (n in 1:N)
      y_rep[n,k] = poisson_rng(Z[n,k]);
  }
}
