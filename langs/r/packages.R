#!/usr/bin/env Rscript

CRAN_PACKAGES <- c('devtools', 'setwidth')

GITHUB_PACKAGES <- c('sckott/cowsay')

install.packages(CRAN_PACKAGES)

library('devtools')

for (package in GITHUB_PACKAGES) {
  install_github(package)
}
