# get the base image, the rocker/verse has R, RStudio and pandoc
FROM rocker/verse:3.6.1

# required
MAINTAINER Sahir Bhatnagar <sahir.bhatnagar@gmail.com>

COPY . /radbayes

# go into the repo directory
RUN . /etc/environment \

  # Install linux depedendencies here
  # e.g. need this for ggforce::geom_sina
  && sudo apt-get update \
  && sudo apt-get install libudunits2-dev -y \

  # build this compendium package
  && R -e "devtools::install('/radbayes', dependencies=TRUE, quick = TRUE, quiet = TRUE)" \

  # make project directory writable to save images and other output
  && sudo chmod a+rwx -R radbayes \

  # render the manuscript into a html output
  && sudo R -e "setwd('/radbayes/analysis/paper'); rmarkdown::render('paper.Rmd')"

  # render the manuscript into a docx, you'll need to edit this if you've
  # customised the location and name of your main Rmd file
