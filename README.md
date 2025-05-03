
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
result <- dc_get_node(
    nodes = "country/USA", 
    property = "<-"
)
str(result)
#> List of 1
#>  $ data:List of 1
#>   ..$ country/USA:List of 1
#>   .. ..$ properties:List of 9
#>   .. .. ..$ : chr "affectedPlace"
#>   .. .. ..$ : chr "comparisonRegion"
#>   .. .. ..$ : chr "containedInPlace"
#>   .. .. ..$ : chr "exportDestination"
#>   .. .. ..$ : chr "importSource"
#>   .. .. ..$ : chr "lendingEntity"
#>   .. .. ..$ : chr "location"
#>   .. .. ..$ : chr "member"
#>   .. .. ..$ : chr "placeOfBirth"
```

Find the DCID of a place by another known ID

``` r
result <- dc_get_resolve(
    nodes = "Q30",
    property = "<-wikidataId->dcid"
)
str(result)
#> List of 1
#>  $ entities:List of 1
#>   ..$ :List of 2
#>   .. ..$ node      : chr "Q30"
#>   .. ..$ candidates:List of 1
#>   .. .. ..$ :List of 1
#>   .. .. .. ..$ dcid: chr "country/USA"
```
