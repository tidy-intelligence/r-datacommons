
<!-- README.md is generated from README.Rmd. Please edit that file -->

# datacommons

<!-- badges: start -->

<!-- [![CRAN status](https://www.r-pkg.org/badges/version/uisapi)](https://cran.r-project.org/package=datacommons)
[![CRAN downloads](https://cranlogs.r-pkg.org/badges/uisapi)](https://cran.r-project.org/package=datacommons) -->

![R CMD
Check](https://github.com/tidy-intelligence/r-datacommons/actions/workflows/R-CMD-check.yaml/badge.svg)
![Lint](https://github.com/tidy-intelligence/r-datacommons/actions/workflows/lint.yaml/badge.svg)
[![Codecov test
coverage](https://codecov.io/gh/tidy-intelligence/r-datacommons/graph/badge.svg)](https://app.codecov.io/gh/tidy-intelligence/r-datacommons)
<!-- badges: end -->

Retrieve data from the [Data Commons REST API
V2](https://docs.datacommons.org/api/rest/v2/). Data Commons provides
harmonized access to dozens of data sources and thousands of datasets
organized in a knowledge graph.

## Installation

<!-- You can install `datacommons` from [CRAN](https://cran.r-project.org/package=datacommons) via:
&#10;
``` r
install.packages("datacommons")
```
-->

You can install the development version of `datacommons` from GitHub
with:

``` r
# install.packages("pak")
pak::pak("tidy-intelligence/r-datacommons")
```

## Usage

Load the package:

``` r
library(datacommons)
```

Get all property labels for a given node:

``` r
dc_get_node(
    nodes = "country/USA", 
    property = "<-"
)
#> $data
#> $data$`country/USA`
#> $data$`country/USA`$properties
#> $data$`country/USA`$properties[[1]]
#> [1] "affectedPlace"
#> 
#> $data$`country/USA`$properties[[2]]
#> [1] "comparisonRegion"
#> 
#> $data$`country/USA`$properties[[3]]
#> [1] "containedInPlace"
#> 
#> $data$`country/USA`$properties[[4]]
#> [1] "exportDestination"
#> 
#> $data$`country/USA`$properties[[5]]
#> [1] "importSource"
#> 
#> $data$`country/USA`$properties[[6]]
#> [1] "lendingEntity"
#> 
#> $data$`country/USA`$properties[[7]]
#> [1] "location"
#> 
#> $data$`country/USA`$properties[[8]]
#> [1] "member"
#> 
#> $data$`country/USA`$properties[[9]]
#> [1] "placeOfBirth"
```

Find the DCID of a place by another known ID

``` r
dc_get_resolve(
    nodes = "Q30",
    property = "<-wikidataId->dcid"
)
#> $entities
#> $entities[[1]]
#> $entities[[1]]$node
#> [1] "Q30"
#> 
#> $entities[[1]]$candidates
#> $entities[[1]]$candidates[[1]]
#> $entities[[1]]$candidates[[1]]$dcid
#> [1] "country/USA"
```
