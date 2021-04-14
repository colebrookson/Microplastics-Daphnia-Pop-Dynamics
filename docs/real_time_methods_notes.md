## Doc Usage

This document will serve as a home for notes (and citations) for tips I find along the way of figuring out this model fitting process.

### 2021-04-14

* Thing that might be helpful is giving stan some starting values to look at - this can be done by specifying a list of lists where there's one inner list for each chain, and then the parameters are given an initial value for each chain. This is done via `init` in the `stan()` function in R.
* Rescaling the parameters has to be done somehow - it's definitely a problem that the model is looking for most of its parameters close to zero but the tolerance concentration and NEC are >1000 particles/mL. Initial try to fix this is to get rid of the uniform prior (info coming from (this link)[https://github.com/stan-dev/stan/wiki/Prior-Choice-Recommendations])
