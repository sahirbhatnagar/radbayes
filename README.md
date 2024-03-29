
<!-- README.md is generated from README.Rmd. Please edit that file -->

# radbayes

<!--[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh///master?urlpath=rstudio)-->

[![Travis-CI Build
Status](https://travis-ci.org/sahirbhatnagar/radbayes.svg?branch=master)](https://travis-ci.org/sahirbhatnagar/radbayes)

    ├── analysis
    │   ├── bin
    │   │   ├── analysis.R # my code for lasso. still work in progress. the first three lines source the functions.R, packages.R and data.R
    │   │   ├── data.R # script to clean data 
    │   │   ├── functions.R # my functions
    │   │   ├── packages.R # packages used 
    │   │   └── tsne-analysis.R # cluster analysis
    │   ├── data # this contains the raw data. see bin/data.R for cleaning it. 
    │   │   ├── DO-NOT-EDIT-ANY-FILES-IN-HERE-BY-HAND
    │   │   ├── HNSCCT-input.csv
    │   │   └── HNSCCT-outcome.csv
    │   ├── paper
    │   │   ├── paper_files
    │   │   │   └── figure-html
    │   │   │       ├── unnamed-chunk-3-1.png
    │   │   │       ├── unnamed-chunk-5-1.png
    │   │   │       └── unnamed-chunk-7-1.png
    │   │   ├── paper.html
    │   │   ├── paper.md
    │   │   ├── paper.Rmd # source file for paper.
    │   │   ├── references.bib
    │   │   └── skeleton.bib
    │   ├── README.md # description of variables in the data
    │   ├── report
    │   │   └── descriptive_stats.html # descriptive stats using DataExplorer package
    │   └── templates
    │       ├── author-info-blocks.lua
    │       ├── journal-of-archaeological-science.csl
    │       ├── pagebreak.lua
    │       ├── scholarly-metadata.lua
    │       ├── template.docx
    │       └── template.Rmd
    ├── CONDUCT.md
    ├── CONTRIBUTING.md
    ├── DESCRIPTION
    ├── Dockerfile
    ├── LICENSE
    ├── LICENSE.md
    ├── NAMESPACE
    ├── radbayes.Rproj
    ├── README.md
    ├── README.Rmd
    ├── references
    │   ├── comparing_classifiers
    │   │   ├── Benavoli2017_Time_for_a_change_tutorial_for_comparing_multiple_classifiers_through_bayesian_analysis_JMLR.pdf
    │   │   └── Corani_ParametricBayesianComparison_slides.pdf
    │   ├── multitask
    │   │   ├── bayesian multi task.pdf
    │   │   └── multi-modal_imaging genetics.pdf
    │   ├── radiology
    │   │   ├── Beyond imaging: The promise of radiomics.pdf
    │   │   ├── Forghani_EurRad_2019_HNSCC cervical node prediction DECT-texture-ML.pdf # Shirin
    │   │   ├── Images Are More than pictures_they are data_Radiology 2015.pdf
    │   │   ├── machine_learning_methods_for_quantitative_radiomic_biomarkers_sci_reports_2015.pdf # Shirin
    │   │   ├── Quantitative_Imaging_of_cancer_in_the_Postgenomic_Era_Radiogenomics_Deep_Learning_and_Habitats.pdf
    │   │   ├── Radiomic Features at Contrast-enhanced CT Predict_Radiology_2020.pdf # Shirin
    │   │   ├── radiomics_strategies_for_risk_assessment of tumour failure_in_HNNC.pdf # Shirin
    │   │   ├── Revealing Tumor Habitats from from texture heterogenietyAnalysis_Sci_Reports.pdf
    │   │   ├── Savadjiev2019_Article_Image-basedBiomarkersForSolidT.pdf
    │   │   ├── Thierry_Presentation.pdf
    │   │   └── Unravelling tumor heterogeneity_habitat_imaging_Sala_2017.pdf
    │   ├── RSNA_2019_HNSCC_Dec5 (1).pdf # abstract presented at RSNA conference on this data
    │   └── sparsity
    │       └── Pironen2017_Sparsity information and regularization_EJS.pdf
    └── tests
        └── testthat.R

<!--

This repository contains the data and code for our paper:

> Authors, (YYYY). _Title of your paper goes here_. Name of journal/book <https://doi.org/xxx/xxx>

Our pre-print is online here:

> Authors, (YYYY). _Title of your paper goes here_. Name of journal/book, Accessed 17 Mar 2020. Online at <https://doi.org/xxx/xxx>

-->

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

<!--

### How to cite

Please cite this compendium as:

> Authors, (2020). _Compendium of R code and data for Title of your paper goes here_. Accessed 17 Mar 2020. Online at <https://doi.org/xxx/xxx>

### How to download or install

You can download the compendium as a zip from from this URL: </archive/master.zip>

Or you can install this compendium as an R package, radbayes, from GitHub with:



```r
# install.packages("devtools")
remotes::install_github("/")
```


### Licenses

**Text and figures :**  [CC-BY-4.0](http://creativecommons.org/licenses/by/4.0/)

**Code :** See the [DESCRIPTION](DESCRIPTION) file

**Data :** [CC-0](http://creativecommons.org/publicdomain/zero/1.0/) attribution requested in reuse

### Contributions

We welcome contributions from everyone. Before you get started, please see our [contributor guidelines](CONTRIBUTING.md). Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

-->
