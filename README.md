
<!-- README.md is generated from README.Rmd. Please edit that file -->

# datacommons

<!-- badges: start -->

![R CMD
Check](https://github.com/tidy-intelligence/r-datacommons/actions/workflows/R-CMD-check.yaml/badge.svg)
![Lint](https://github.com/tidy-intelligence/r-datacommons/actions/workflows/lint.yaml/badge.svg)
[![Codecov test
coverage](https://codecov.io/gh/tidy-intelligence/r-datacommons/graph/badge.svg)](https://app.codecov.io/gh/tidy-intelligence/r-datacommons)
<!-- badges: end -->

Access the Google [Data Commons API
V2](https://docs.datacommons.org/api/rest/v2/). Data Commons provides
programmatic access to statistical and demographic data from dozens of
sources organized in a knowldege graph.

## Installation

You can install `datacommons` from CRAN via:

``` r
install.packages("datacommons")
```

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

Get a free API key for Data Commons
[here](https://docs.datacommons.org/api/#obtain-an-api-key). Set the
Data Commons API key as the `DATACOMMONS_API_KEY` environment variable
using the helper function and restart your R session to load the key:

``` r
dc_set_api_key("YOUR_API_KEY")
```

If you want to use a [custom Data Commons
instance](https://docs.datacommons.org/api/rest/v2/#base-url-for-custom-instances),
then you can also set the `DATACOMMONS_BASE_URL` environment varibale on
the project or global level:

``` r
dc_set_base_url("YOUR_BASE_URL")
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
#>   entity_dcid              entity_name variable_dcid    variable_name date
#> 1 country/USA United States of America  Count_Person Total population 1960
#> 2 country/USA United States of America  Count_Person Total population 1961
#> 3 country/USA United States of America  Count_Person Total population 1962
#> 4 country/USA United States of America  Count_Person Total population 1963
#> 5 country/USA United States of America  Count_Person Total population 1964
#>       value   facet_id                 facet_name
#> 1 180671000 3981252704 WorldDevelopmentIndicators
#> 2 183691000 3981252704 WorldDevelopmentIndicators
#> 3 186538000 3981252704 WorldDevelopmentIndicators
#> 4 189242000 3981252704 WorldDevelopmentIndicators
#> 5 191889000 3981252704 WorldDevelopmentIndicators
```

If you want to get different population numbers from the [US
Census](https://datacommons.org/browser/dc/base/USCensusPEP_Annual_Population)
on the state level:

``` r
state_level <- dc_get_observations(
  variable_dcids = "Count_Person",
  date = 2021,
  parent_entity = "country/USA",
  entity_type = "State",
  return_type = "data.frame",
  filter_facet_id = 2176550201
)
head(state_level, 5)
#>   entity_dcid entity_name variable_dcid    variable_name date    value
#> 1    geoId/01     Alabama  Count_Person Total population 2021  5039877
#> 2    geoId/02      Alaska  Count_Person Total population 2021   732673
#> 3    geoId/04     Arizona  Count_Person Total population 2021  7276316
#> 4    geoId/05    Arkansas  Count_Person Total population 2021  3025891
#> 5    geoId/06  California  Count_Person Total population 2021 39237836
#>     facet_id                    facet_name
#> 1 2176550201 USCensusPEP_Annual_Population
#> 2 2176550201 USCensusPEP_Annual_Population
#> 3 2176550201 USCensusPEP_Annual_Population
#> 4 2176550201 USCensusPEP_Annual_Population
#> 5 2176550201 USCensusPEP_Annual_Population
```

## Contributing

Contributions to `oecdoda` are welcome! If you’d like to contribute,
please follow these steps:

1.  **Create an issue**: Before making changes, create an issue
    describing the bug or feature you’re addressing.
2.  **Fork the repository**: After receiving supportive feedback from
    the package authors, fork the repository to your GitHub account.
3.  **Create a branch**: Create a branch for your changes with a
    descriptive name.
4.  **Make your changes**: Implement your bug fix or feature.
5.  **Test your changes**: Run tests to ensure your changes don’t break
    existing functionality.
6.  **Submit a pull request**: Push your changes to your fork and submit
    a pull request to the main repository.
