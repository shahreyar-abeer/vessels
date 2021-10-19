
<!-- README.md is generated from README.Rmd. Please edit that file -->

# vessels

App hosted [here](https://shahreyar-abeer.shinyapps.io/vessels/)

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R build
status](https://github.com/shahreyar-abeer/vessels/workflows/R-CMD-check/badge.svg)](https://github.com/shahreyar-abeer/vessels/actions)
<!-- badges: end -->

An app that shows the starting and ending positions of a ship in a Leaflet map.
It also uses the spatial data to calculate the longest run between two time points.
The data is saved in a PostgreSQL table and it reads from there.

## Installation

You can install the development version from
[GitHub](https://github.com/) and run with:

``` r
# install.packages("devtools")
devtools::install_github("shahreyar-abeer/vessels")

# run
vessels::run_app()
```
