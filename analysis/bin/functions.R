`%ni%` <- Negate("%in%")


my_makeX <- function (train, test = NULL, na.impute = FALSE, sparse = FALSE,
                      ...) {
  df = train
  istest = !is.null(test)
  ntr = nrow(train)
  if (istest) {
    nte = nrow(test)
    df = rbind(df, test)
  }
  x = my_prepareX(df, sparse = sparse)
  if (na.impute) {
    xbar = colMeans(x[seq(ntr), ], na.rm = TRUE)
    x = na.replace(x, xbar)
  }
  if (istest) {
    xt = x[seq(ntr + 1, ntr + nte), ]
    x = x[seq(ntr), ]
  }
  if (na.impute)
    attr(x, "means") = xbar
  if (istest)
    list(x = x, xtest = xt)
  else x
}

my_prepareX <- function(df, sparse = FALSE, ...) {
  if (!inherits(df, "data.frame"))
    stop("first argument must be of class `data.frame`")
  whichfac = sapply(df, inherits, "factor")
  oldna = options()$na.action
  cna = as.character(substitute(na.action))
  options(na.action = na.pass)
  on.exit(options(na.action = oldna))
  if (any(whichfac))
    ctr = lapply(df[, whichfac], contrasts, contrast = FALSE)
  else ctr = NULL
  if (sparse) {
    m = sparse.model.matrix(~. , data = df, contrasts.arg = ctr,
                            ...)
    m = na_sparse_fix(m, names(df))
  }
  else m = model.matrix(~. , data = df, contrasts.arg = ctr,
                        ...)
  if (any(whichfac))
    attr(m, "contrasts") = NULL
  attr(m, "assign") = NULL
  m
}
