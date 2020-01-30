---
title: "RMarkdown Template"
author: "Author"
date: "2020-01-30"
output:
  html_document:
    toc: true
    toc_float: true
    number_sections: true
    toc_depth: 4
    keep_md: true
bibliography: references.bib
editor_options: 
  chunk_output_type: console
---



The goal of the study is to determine whether resident performance in neonatal head ultrasound improves following brain phantom ultrasound simulation training. We have 2 groups of 5 residents who were scored by 3 radiologists each.

# Compare the scores of residents in Group A pre- and post-phantom training

<br><br>

Since Accuracy is based on a continuous response, we calculate the intraclass correlation (ICC). All websites were
rated by both coders, so Interrater reliability (IRR) was assessed using a two-way mixed, average-measures ICC [@mcgraw1996forming] to assess the degree that raters (or coders) provided consistency in their ratings of number of incorrect statements across websites. 





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
##  date     2020-01-30                  
## 
## ─ Packages ───────────────────────────────────────────────────────────────────
##  package     * version date       lib source        
##  assertthat    0.2.1   2019-03-21 [1] CRAN (R 3.6.2)
##  backports     1.1.5   2019-10-02 [1] CRAN (R 3.6.2)
##  callr         3.4.1   2020-01-24 [1] CRAN (R 3.6.2)
##  cli           2.0.1   2020-01-08 [1] CRAN (R 3.6.2)
##  crayon        1.3.4   2017-09-16 [1] CRAN (R 3.6.2)
##  desc          1.2.0   2018-05-01 [1] CRAN (R 3.6.2)
##  devtools      2.2.1   2019-09-24 [1] CRAN (R 3.6.2)
##  digest        0.6.23  2019-11-23 [1] CRAN (R 3.6.2)
##  ellipsis      0.3.0   2019-09-20 [1] CRAN (R 3.6.2)
##  evaluate      0.14    2019-05-28 [1] CRAN (R 3.6.2)
##  fansi         0.4.1   2020-01-08 [1] CRAN (R 3.6.2)
##  fs            1.3.1   2019-05-06 [1] CRAN (R 3.6.2)
##  glue          1.3.1   2019-03-12 [1] CRAN (R 3.6.2)
##  htmltools     0.4.0   2019-10-04 [1] CRAN (R 3.6.2)
##  knitr         1.27    2020-01-16 [1] CRAN (R 3.6.2)
##  magrittr      1.5     2014-11-22 [1] CRAN (R 3.6.2)
##  memoise       1.1.0   2017-04-21 [1] CRAN (R 3.6.2)
##  pkgbuild      1.0.6   2019-10-09 [1] CRAN (R 3.6.2)
##  pkgload       1.0.2   2018-10-29 [1] CRAN (R 3.6.2)
##  prettyunits   1.1.1   2020-01-24 [1] CRAN (R 3.6.2)
##  processx      3.4.1   2019-07-18 [1] CRAN (R 3.6.2)
##  ps            1.3.0   2018-12-21 [1] CRAN (R 3.6.2)
##  R6            2.4.1   2019-11-12 [1] CRAN (R 3.6.2)
##  Rcpp          1.0.3   2019-11-08 [1] CRAN (R 3.6.2)
##  remotes       2.1.0   2019-06-24 [1] CRAN (R 3.6.2)
##  rlang         0.4.3   2020-01-24 [1] CRAN (R 3.6.2)
##  rmarkdown     2.1     2020-01-20 [1] CRAN (R 3.6.2)
##  rprojroot     1.3-2   2018-01-03 [1] CRAN (R 3.6.2)
##  sessioninfo   1.1.1   2018-11-05 [1] CRAN (R 3.6.2)
##  stringi       1.4.5   2020-01-11 [1] CRAN (R 3.6.2)
##  stringr       1.4.0   2019-02-10 [1] CRAN (R 3.6.2)
##  testthat      2.3.1   2019-12-01 [1] CRAN (R 3.6.2)
##  usethis       1.5.1   2019-07-04 [1] CRAN (R 3.6.2)
##  withr         2.1.2   2018-03-15 [1] CRAN (R 3.6.2)
##  xfun          0.12    2020-01-13 [1] CRAN (R 3.6.2)
##  yaml          2.2.0   2018-07-25 [1] CRAN (R 3.6.2)
## 
## [1] /home/sahir/R/x86_64-pc-linux-gnu-library/3.6
## [2] /usr/local/lib/R/site-library
## [3] /usr/lib/R/site-library
## [4] /usr/lib/R/library
```

<br> <br>

# References
