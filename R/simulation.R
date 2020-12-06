#' Predictors and responses generation.
#'
#' Generate a predictor matrix x, and response vector y, following a specified
#'   setup.  Actually, two pairs of predictors and responses are generated:
#'   one for training, and one for validation.
#'
#' @param n,p The number of training observations, and the number of predictors.
#' @param nval The number of validation observations.
#' @param rho Parameter that drives pairwise correlations of the predictor
#'   variables; specifically, predictors i and j have population correlation
#'   rho^abs(i-j). Default is 0.
#' @param s number of nonzero coefficients in the underlying regression model.
#'   Default is 5. (Ignored if beta.type is 4, in which case the number of
#'   nonzero coefficients is 6; and if beta.type is 5, it is interpreted as a
#'   the number of strongly nonzero coefficients in a weak sparsity model.)
#' @param beta.type Integer taking values in between 1 and 5, used to specify
#'   the pattern of nonzero coefficients in the underlying regression model; see
#'   details below. Default is 1.
#' @param snr Desired signal-to-noise ratio (SNR), i.e., var(mu)/sigma^2 where
#'   mu is mean and sigma^2 is the error variance. The error variance is set so
#'   that the given SNR is achieved. Default is 1.
#' @return A list with the following components: x, y, xval, yval, Sigma, beta,
#'   and sigma.
#'
#' @details The data model is: \eqn{Y \sim N(X\beta, \sigma^2 I)}.
#'   The predictor variables have covariance matrix Sigma, with (i,j)th entry
#'   rho^abs(i-j). The error variance sigma^2 is set according to the desired
#'   signal-to-noise ratio. The first 4 options for the nonzero pattern
#'   of the underlying regression coefficients beta follow the simulation setup
#'   in Bertsimas, King, and Mazumder (2016), and the 5th is a weak sparsity
#'   option:
#'   \itemize{
#'   \item 1: beta has s components of 1, occurring at (roughly) equally-spaced
#'      indices in between 1 and p
#'   \item 2: beta has its first s components equal to 1
#'   \item 3: beta has its first s components taking nonzero values, where the
#'       decay in a linear fashion from 10 to 0.5
#'   \item 4: beta has its first 6 components taking the nonzero values -10,-6,
#'       -2,2,6,10
#'   \item 5: beta has its first s components equal to 1, and the rest decaying
#'       to zero at an exponential rate
#'   }
#'
#' @author Trevor Hastie, Rob Tibshirani, Ryan Tibshirani
#' @references Simulation setup based on "Best subset selection via a modern
#'   optimization lens" by Dimitris Bertsimas, Angela King, and Rahul Mazumder,
#'   Annals of Statistics, 44(2), 813-852, 2016.
#' @example examples/ex.fs.R
#' @export sim.xy
sim.xy = function(n, p, nval, rho=0, s=5, beta.type=1, snr=1, prop.missing = 0.2) {

  if(!requireNamespace("mice")) stop("load mice to use this function")

  # Generate predictors
  x = matrix(rnorm(n*p),n,p)
  xval = matrix(rnorm(nval*p),nval,p)

  # Introduce autocorrelation, if needed
  if (rho != 0) {
    inds = 1:p
    Sigma = rho^abs(outer(inds, inds, "-"))
    obj = svd(Sigma)
    Sigma.half = obj$u %*% (sqrt(diag(obj$d))) %*% t(obj$v)
    x = x %*% Sigma.half
    xval = xval %*% Sigma.half
  }
  else Sigma = diag(1,p)

  # Generate underlying coefficients
  s = min(s,p)
  beta = rep(0,p)
  if (beta.type==1) {
    beta[round(seq(1,p,length=s))] = 1
  } else if (beta.type==2) {
    beta[1:s] = 1
  } else if (beta.type==3) {
    beta[1:s] = seq(10,0.5,length=s)
  } else if (beta.type==4) {
    beta[1:6] = c(-10,-6,-2,2,6,10)
  } else {
    beta[1:s] = 1
    beta[(s+1):p] = 0.5^(1:(p-s))
  }

  # Set snr based on sample variance on infinitely large test set
  vmu = as.numeric(t(beta) %*% Sigma %*% beta)
  sigma = sqrt(vmu/snr)

  # Generate responses
  y = as.numeric(x %*% beta + rnorm(n)*sigma)
  yval = as.numeric(xval %*% beta + rnorm(nval)*sigma)

  browser()

  x.miss <- mice::ampute(x, prop = 0.)

  enlist(x,y,xval,yval,Sigma,beta,sigma)
}

enlist <- function (...) {
  result <- list(...)
  if ((nargs() == 1) & is.character(n <- result[[1]])) {
    result <- as.list(seq(n))
    names(result) <- n
    for (i in n) result[[i]] <- get(i)
  }
  else {
    n <- sys.call()
    n <- as.character(n)[-1]
    if (!is.null(n2 <- names(result))) {
      which <- n2 != ""
      n[which] <- n2[which]
    }
    names(result) <- n
  }
  result
}

# Simulate some simple regression data with the first 5 coefficients
# being nonzero
set.seed(0)
n = 100
p = 20
xy.obj = sim.xy(n = n, p = p, nval = n, rho = 0, s=5, beta.type=2, snr=1)
xy.obj
x = xy.obj$x
y = xy.obj$y
