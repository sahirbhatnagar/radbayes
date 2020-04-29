---
title: "Binomial Frequentist Lasso+Multitask Regression"
author: "by Sahir Bhatnagar"
date: "2020-04-28"
output:
  html_document:
    toc: true
    toc_float: false
    number_sections: true
    toc_depth: 4
    keep_md: true
bibliography: bibliography.bib
editor_options: 
  chunk_output_type: console
---




# Site as fixed effect

Here I produce the coefficient plots for the logistic lasso regression with glmnet [@R-glmnet]. 








```
## 
##  iter imp variable
##   1   1  HPV  PNI  LVI  Smoking  Drinking  TstageGroup
##   2   1  HPV  PNI  LVI  Smoking  Drinking  TstageGroup
##   3   1  HPV  PNI  LVI  Smoking  Drinking  TstageGroup
##   4   1  HPV  PNI  LVI  Smoking  Drinking  TstageGroup
##   5   1  HPV  PNI  LVI  Smoking  Drinking  TstageGroup
```


## Variable Selection

![](lasso_reg_frequentist_files/figure-html/fit-lasso-1.png)<!-- -->


## Prediction Performance

Here I provide the prediction performance. Likely overfit because the training set is also used as the test set. 

![](lasso_reg_frequentist_files/figure-html/prediction-performance-1.png)<!-- -->





# Multitask Lasso

The Objective function for the multitask lasso is given by:

$$
\min\limits_{W, C} \sum_{i=1}^{t}{L(W_i, C_i |X_i, Y_i)} + \lambda ||W||_1 
$$

where $L(\circ)$ is the logistic loss function, $||W||_1$ is the $\ell_1$-norm penalty term on the regression coefficients $W$, $X=\{X_i= n_i \times p | i \in \{1,...,t\}\}$ are the covariates and texture features, $Y=\{Y_i=n_i \times 1 | i \in \{1,...,t\}\}$ is the binary response (Nodal Stage). $W \in \mathbb{R}^{p \times t}$ is the coefficient matrix where $W_i$ is the i$th$ column of $W$ and refers to the coefficient vector of task $i$. $C_i$ is the intercept for task $i$.   



![](lasso_reg_frequentist_files/figure-html/multi-task-1.png)<!-- -->![](lasso_reg_frequentist_files/figure-html/multi-task-2.png)<!-- -->







<br> <br>

# Session Info


```
## ─ Session info ───────────────────────────────────────────────────────────────
##  setting  value                       
##  version  R version 3.6.2 (2019-12-12)
##  os       Pop!_OS 19.10               
##  system   x86_64, linux-gnu           
##  ui       X11                         
##  language en_US:en                    
##  collate  en_US.UTF-8                 
##  ctype    en_US.UTF-8                 
##  tz       America/Toronto             
##  date     2020-04-28                  
## 
## ─ Packages ───────────────────────────────────────────────────────────────────
##  package     * version    date       lib source                            
##  assertthat    0.2.1      2019-03-21 [1] CRAN (R 3.6.2)                    
##  backports     1.1.5      2019-10-02 [1] CRAN (R 3.6.2)                    
##  broom         0.5.5      2020-02-29 [1] CRAN (R 3.6.2)                    
##  callr         3.4.3      2020-03-28 [1] CRAN (R 3.6.2)                    
##  cellranger    1.1.0      2016-07-27 [1] CRAN (R 3.6.2)                    
##  cli           2.0.2      2020-02-28 [1] CRAN (R 3.6.2)                    
##  codetools     0.2-16     2018-12-24 [4] CRAN (R 3.6.0)                    
##  colorspace    1.4-1      2019-03-18 [1] CRAN (R 3.6.2)                    
##  crayon        1.3.4      2017-09-16 [1] CRAN (R 3.6.2)                    
##  data.table  * 1.12.8     2019-12-09 [1] CRAN (R 3.6.2)                    
##  DBI           1.1.0      2019-12-15 [1] CRAN (R 3.6.2)                    
##  dbplyr        1.4.2      2019-06-17 [1] CRAN (R 3.6.2)                    
##  desc          1.2.0      2018-05-01 [1] CRAN (R 3.6.2)                    
##  devtools      2.2.2      2020-02-17 [1] CRAN (R 3.6.2)                    
##  digest        0.6.25     2020-02-23 [1] CRAN (R 3.6.2)                    
##  doParallel    1.0.15     2019-08-02 [1] CRAN (R 3.6.2)                    
##  dplyr       * 0.8.5      2020-03-07 [1] CRAN (R 3.6.2)                    
##  ellipsis      0.3.0      2019-09-20 [1] CRAN (R 3.6.2)                    
##  evaluate      0.14       2019-05-28 [1] CRAN (R 3.6.2)                    
##  fansi         0.4.1      2020-01-08 [1] CRAN (R 3.6.2)                    
##  farver        2.0.3      2020-01-16 [1] CRAN (R 3.6.2)                    
##  forcats     * 0.4.0      2019-02-17 [1] CRAN (R 3.6.2)                    
##  foreach       1.4.8      2020-02-09 [1] CRAN (R 3.6.2)                    
##  fs            1.3.2      2020-03-05 [1] CRAN (R 3.6.2)                    
##  generics      0.0.2      2018-11-29 [1] CRAN (R 3.6.2)                    
##  ggplot2     * 3.3.0.9000 2020-03-31 [1] Github (tidyverse/ggplot2@4f6818e)
##  glmnet      * 3.0-2      2019-12-11 [1] CRAN (R 3.6.2)                    
##  glue          1.4.0      2020-04-03 [1] CRAN (R 3.6.2)                    
##  gtable        0.3.0      2019-03-25 [1] CRAN (R 3.6.2)                    
##  hardhat     * 0.1.1      2020-01-08 [1] CRAN (R 3.6.2)                    
##  haven         2.2.0      2019-11-08 [1] CRAN (R 3.6.2)                    
##  here        * 0.1        2017-05-28 [1] CRAN (R 3.6.2)                    
##  hms           0.5.3      2020-01-08 [1] CRAN (R 3.6.2)                    
##  htmltools     0.4.0      2019-10-04 [1] CRAN (R 3.6.2)                    
##  httr          1.4.1      2019-08-05 [1] CRAN (R 3.6.2)                    
##  iterators     1.0.12     2019-07-26 [1] CRAN (R 3.6.2)                    
##  jsonlite      1.6.1      2020-02-02 [1] CRAN (R 3.6.2)                    
##  knitr         1.28       2020-02-06 [1] CRAN (R 3.6.2)                    
##  labeling      0.3        2014-08-23 [1] CRAN (R 3.6.2)                    
##  lattice       0.20-38    2018-11-04 [4] CRAN (R 3.6.0)                    
##  lifecycle     0.2.0      2020-03-06 [1] CRAN (R 3.6.2)                    
##  lubridate     1.7.4      2018-04-11 [1] CRAN (R 3.6.2)                    
##  magrittr      1.5        2014-11-22 [1] CRAN (R 3.6.2)                    
##  Matrix      * 1.2-18     2019-11-27 [4] CRAN (R 3.6.1)                    
##  memoise       1.1.0      2017-04-21 [1] CRAN (R 3.6.2)                    
##  mice          3.8.0      2020-02-21 [1] CRAN (R 3.6.2)                    
##  modelr        0.1.5      2019-08-08 [1] CRAN (R 3.6.2)                    
##  munsell       0.5.0      2018-06-12 [1] CRAN (R 3.6.2)                    
##  nlme          3.1-143    2019-12-10 [4] CRAN (R 3.6.2)                    
##  nnet          7.3-12     2016-02-02 [4] CRAN (R 3.6.0)                    
##  pacman        0.5.1      2019-03-11 [1] CRAN (R 3.6.2)                    
##  pillar        1.4.3      2019-12-20 [1] CRAN (R 3.6.2)                    
##  pkgbuild      1.0.6      2019-10-09 [1] CRAN (R 3.6.2)                    
##  pkgconfig     2.0.3      2019-09-22 [1] CRAN (R 3.6.2)                    
##  pkgload       1.0.2      2018-10-29 [1] CRAN (R 3.6.2)                    
##  plyr          1.8.6      2020-03-03 [1] CRAN (R 3.6.2)                    
##  prettyunits   1.1.1      2020-01-24 [1] CRAN (R 3.6.2)                    
##  pROC        * 1.16.1     2020-01-14 [1] CRAN (R 3.6.2)                    
##  processx      3.4.2      2020-02-09 [1] CRAN (R 3.6.2)                    
##  ps            1.3.2      2020-02-13 [1] CRAN (R 3.6.2)                    
##  purrr       * 0.3.3      2019-10-18 [1] CRAN (R 3.6.2)                    
##  R6            2.4.1      2019-11-12 [1] CRAN (R 3.6.2)                    
##  Rcpp          1.0.4.6    2020-04-09 [1] CRAN (R 3.6.2)                    
##  readr       * 1.3.1      2018-12-21 [1] CRAN (R 3.6.2)                    
##  readxl        1.3.1      2019-03-13 [1] CRAN (R 3.6.2)                    
##  remotes       2.1.1      2020-02-15 [1] CRAN (R 3.6.2)                    
##  reprex        0.3.0      2019-05-16 [1] CRAN (R 3.6.2)                    
##  rlang         0.4.5      2020-03-01 [1] CRAN (R 3.6.2)                    
##  rmarkdown     2.1        2020-01-20 [1] CRAN (R 3.6.2)                    
##  RMTL        * 0.9        2019-02-27 [1] CRAN (R 3.6.2)                    
##  rprojroot     1.3-2      2018-01-03 [1] CRAN (R 3.6.2)                    
##  rstudioapi    0.11       2020-02-07 [1] CRAN (R 3.6.2)                    
##  rvest         0.3.5      2019-11-08 [1] CRAN (R 3.6.2)                    
##  scales        1.1.0      2019-11-18 [1] CRAN (R 3.6.2)                    
##  sessioninfo   1.1.1      2018-11-05 [1] CRAN (R 3.6.2)                    
##  shape         1.4.4      2018-02-07 [1] CRAN (R 3.6.2)                    
##  stringi       1.4.6      2020-02-17 [1] CRAN (R 3.6.2)                    
##  stringr     * 1.4.0      2019-02-10 [1] CRAN (R 3.6.2)                    
##  testthat      2.3.2      2020-03-02 [1] CRAN (R 3.6.2)                    
##  tibble      * 3.0.0      2020-03-30 [1] CRAN (R 3.6.2)                    
##  tidyr       * 1.0.2      2020-01-24 [1] CRAN (R 3.6.2)                    
##  tidyselect    1.0.0      2020-01-27 [1] CRAN (R 3.6.2)                    
##  tidyverse   * 1.3.0      2019-11-21 [1] CRAN (R 3.6.2)                    
##  usethis       1.5.1      2019-07-04 [1] CRAN (R 3.6.2)                    
##  vctrs         0.2.4      2020-03-10 [1] CRAN (R 3.6.2)                    
##  withr         2.1.2      2018-03-15 [1] CRAN (R 3.6.2)                    
##  xfun          0.13       2020-04-13 [1] CRAN (R 3.6.2)                    
##  xml2          1.3.0      2020-04-03 [1] Github (r-lib/xml2@1079c51)       
##  yaml          2.2.1      2020-02-01 [1] CRAN (R 3.6.2)                    
## 
## [1] /home/sahir/R/x86_64-pc-linux-gnu-library/3.6
## [2] /usr/local/lib/R/site-library
## [3] /usr/lib/R/site-library
## [4] /usr/lib/R/library
```

<br> <br>

# References
