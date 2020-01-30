
<!-- README.md is generated from README.Rmd. Please edit that file -->

# radbayes

<!--[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh///master?urlpath=rstudio)-->

[![Travis-CI Build
Status](https://travis-ci.org/sahirbhatnagar/radbayes.svg?branch=master)](https://travis-ci.org/sahirbhatnagar/radbayes)

    analysis/
    |
    ├── paper/
    │   ├── paper.Rmd       # this is the main document to edit. just testing code for now
    │   └── references.bib  # this contains the reference list information
    ├── figures/            # location of the figures produced by the Rmd
    |
    ├── data/
    │   ├── raw_data/       # data obtained from elsewhere
    │   └── derived_data/   # data generated during the analysis
    |
    └── templates # not currently being used
        ├── journal-of-archaeological-science.csl
        |                   # this sets the style of citations & reference list
        ├── template.docx   # used to style the output of the paper.Rmd
        └── template.Rmd

This repository contains the data and code for our paper:

> Authors, (YYYY). *Title of your paper goes here*. Name of journal/book
> <https://doi.org/xxx/xxx>

Our pre-print is online here:

> Authors, (YYYY). *Title of your paper goes here*. Name of
> journal/book, Accessed 30 Jan 2020. Online at
> <https://doi.org/xxx/xxx>

# Docker Image

``` bash
# https://github.com/rocker-org/rocker/wiki/Using-the-RStudio-image
# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-16-04
# https://docs.docker.com/engine/reference/run/ which explains the run tags
docker pull sahirbhatnagar/radbayes:latest # pulls the image locally
docker images # see list of images
docker ps -a # also see list of images
docker run -d -p 8787:8787 -e PASSWORD=<YOUR_PASS> --name radbayes sahirbhatnagar/radbayes
# then go to http://localhost:8787
# username is rstudio, password is what you specified
# in R do: setwd('/radbayes/') and then you should see the folder with all the materials in the folder RStudio pane
docker stop radbayes # this can be what you supplied to --name in the above command or the container ID
```

### How to cite

Please cite this compendium as:

> Authors, (2020). *Compendium of R code and data for Title of your
> paper goes here*. Accessed 30 Jan 2020. Online at
> <https://doi.org/xxx/xxx>

### How to download or install

You can download the compendium as a zip from from this URL:
</archive/master.zip>

Or you can install this compendium as an R package, radbayes, from
GitHub with:

``` r
# install.packages("devtools")
remotes::install_github("/")
```

### Licenses

**Text and figures :**
[CC-BY-4.0](http://creativecommons.org/licenses/by/4.0/)

**Code :** See the [DESCRIPTION](DESCRIPTION) file

**Data :** [CC-0](http://creativecommons.org/publicdomain/zero/1.0/)
attribution requested in reuse

### Contributions

We welcome contributions from everyone. Before you get started, please
see our [contributor guidelines](CONTRIBUTING.md). Please note that this
project is released with a [Contributor Code of Conduct](CONDUCT.md). By
participating in this project you agree to abide by its terms.
