
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

Get a data frame with US population data from [World Development
Indicators](https://datacommons.org/browser/dc/base/WorldDevelopmentIndicators):

``` r
country_level <- dc_get_observations(
  date = "all",
  variable_dcids = "Count_Person",
  entity_dcids = "country/USA",
  return_type = "data.frame",
  filter_facet_id = 3981252704
)
head(country_level, 5)
#>   entity_dcid variable_dcid date     value   facet_id
#> 1 country/USA  Count_Person 1960 180671000 3981252704
#> 2 country/USA  Count_Person 1961 183691000 3981252704
#> 3 country/USA  Count_Person 1962 186538000 3981252704
#> 4 country/USA  Count_Person 1963 189242000 3981252704
#> 5 country/USA  Count_Person 1964 191889000 3981252704
#>                   facet_name
#> 1 WorldDevelopmentIndicators
#> 2 WorldDevelopmentIndicators
#> 3 WorldDevelopmentIndicators
#> 4 WorldDevelopmentIndicators
#> 5 WorldDevelopmentIndicators
```

If you want to get different population numbers from the [US
Census](https://datacommons.org/browser/dc/base/USCensusPEP_Annual_Population)
on the state level:

``` r
state_level <- dc_get_observations(
  variable_dcids = c("Count_Person"),
  date = 2021,
  parent_entity = "country/USA",
  entity_type = "State",
  return_type = "data.frame",
  filter_facet_id = 2176550201
)
head(state_level, 5)
#>   entity_dcid variable_dcid date   value   facet_id
#> 1    geoId/47  Count_Person 2021 6975218 2176550201
#> 2    geoId/54  Count_Person 2021 1782959 2176550201
#> 3    geoId/04  Count_Person 2021 7276316 2176550201
#> 4    geoId/40  Count_Person 2021 3986639 2176550201
#> 5    geoId/19  Count_Person 2021 3193079 2176550201
#>                      facet_name
#> 1 USCensusPEP_Annual_Population
#> 2 USCensusPEP_Annual_Population
#> 3 USCensusPEP_Annual_Population
#> 4 USCensusPEP_Annual_Population
#> 5 USCensusPEP_Annual_Population
```
