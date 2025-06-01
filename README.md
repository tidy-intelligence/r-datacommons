
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

Get a data frame with US population data from World Development
Indicators:

``` r
dc_get_observations(
  date = "all",
  variable_dcids = "Count_Person",
  entity_dcids = "country/USA",
  return_type = "data.frame",
  filter_facet_id = 3981252704
)
#>    entity_dcid variable_dcid date     value   facet_id
#> 1  country/USA  Count_Person 1960 180671000 3981252704
#> 2  country/USA  Count_Person 1961 183691000 3981252704
#> 3  country/USA  Count_Person 1962 186538000 3981252704
#> 4  country/USA  Count_Person 1963 189242000 3981252704
#> 5  country/USA  Count_Person 1964 191889000 3981252704
#> 6  country/USA  Count_Person 1965 194303000 3981252704
#> 7  country/USA  Count_Person 1966 196560000 3981252704
#> 8  country/USA  Count_Person 1967 198712000 3981252704
#> 9  country/USA  Count_Person 1968 200706000 3981252704
#> 10 country/USA  Count_Person 1969 202677000 3981252704
#> 11 country/USA  Count_Person 1970 205052000 3981252704
#> 12 country/USA  Count_Person 1971 207661000 3981252704
#> 13 country/USA  Count_Person 1972 209896000 3981252704
#> 14 country/USA  Count_Person 1973 211909000 3981252704
#> 15 country/USA  Count_Person 1974 213854000 3981252704
#> 16 country/USA  Count_Person 1975 215973000 3981252704
#> 17 country/USA  Count_Person 1976 218035000 3981252704
#> 18 country/USA  Count_Person 1977 220239000 3981252704
#> 19 country/USA  Count_Person 1978 222585000 3981252704
#> 20 country/USA  Count_Person 1979 225055000 3981252704
#> 21 country/USA  Count_Person 1980 227225000 3981252704
#> 22 country/USA  Count_Person 1981 229466000 3981252704
#> 23 country/USA  Count_Person 1982 231664000 3981252704
#> 24 country/USA  Count_Person 1983 233792000 3981252704
#> 25 country/USA  Count_Person 1984 235825000 3981252704
#> 26 country/USA  Count_Person 1985 237924000 3981252704
#> 27 country/USA  Count_Person 1986 240133000 3981252704
#> 28 country/USA  Count_Person 1987 242289000 3981252704
#> 29 country/USA  Count_Person 1988 244499000 3981252704
#> 30 country/USA  Count_Person 1989 246819000 3981252704
#> 31 country/USA  Count_Person 1990 249623000 3981252704
#> 32 country/USA  Count_Person 1991 252981000 3981252704
#> 33 country/USA  Count_Person 1992 256514000 3981252704
#> 34 country/USA  Count_Person 1993 259919000 3981252704
#> 35 country/USA  Count_Person 1994 263126000 3981252704
#> 36 country/USA  Count_Person 1995 266278000 3981252704
#> 37 country/USA  Count_Person 1996 269394000 3981252704
#> 38 country/USA  Count_Person 1997 272657000 3981252704
#> 39 country/USA  Count_Person 1998 275854000 3981252704
#> 40 country/USA  Count_Person 1999 279040000 3981252704
#> 41 country/USA  Count_Person 2000 282162411 3981252704
#> 42 country/USA  Count_Person 2001 284968955 3981252704
#> 43 country/USA  Count_Person 2002 287625193 3981252704
#> 44 country/USA  Count_Person 2003 290107933 3981252704
#> 45 country/USA  Count_Person 2004 292805298 3981252704
#> 46 country/USA  Count_Person 2005 295516599 3981252704
#> 47 country/USA  Count_Person 2006 298379912 3981252704
#> 48 country/USA  Count_Person 2007 301231207 3981252704
#> 49 country/USA  Count_Person 2008 304093966 3981252704
#> 50 country/USA  Count_Person 2009 306771529 3981252704
#> 51 country/USA  Count_Person 2010 309327143 3981252704
#> 52 country/USA  Count_Person 2011 311583481 3981252704
#> 53 country/USA  Count_Person 2012 313877662 3981252704
#> 54 country/USA  Count_Person 2013 316059947 3981252704
#> 55 country/USA  Count_Person 2014 318386329 3981252704
#> 56 country/USA  Count_Person 2015 320738994 3981252704
#> 57 country/USA  Count_Person 2016 323071755 3981252704
#> 58 country/USA  Count_Person 2017 325122128 3981252704
#> 59 country/USA  Count_Person 2018 326838199 3981252704
#> 60 country/USA  Count_Person 2019 328329953 3981252704
#> 61 country/USA  Count_Person 2020 331526933 3981252704
#> 62 country/USA  Count_Person 2021 332048977 3981252704
#> 63 country/USA  Count_Person 2022 333271411 3981252704
#> 64 country/USA  Count_Person 2023 334914895 3981252704
#>                    facet_name
#> 1  WorldDevelopmentIndicators
#> 2  WorldDevelopmentIndicators
#> 3  WorldDevelopmentIndicators
#> 4  WorldDevelopmentIndicators
#> 5  WorldDevelopmentIndicators
#> 6  WorldDevelopmentIndicators
#> 7  WorldDevelopmentIndicators
#> 8  WorldDevelopmentIndicators
#> 9  WorldDevelopmentIndicators
#> 10 WorldDevelopmentIndicators
#> 11 WorldDevelopmentIndicators
#> 12 WorldDevelopmentIndicators
#> 13 WorldDevelopmentIndicators
#> 14 WorldDevelopmentIndicators
#> 15 WorldDevelopmentIndicators
#> 16 WorldDevelopmentIndicators
#> 17 WorldDevelopmentIndicators
#> 18 WorldDevelopmentIndicators
#> 19 WorldDevelopmentIndicators
#> 20 WorldDevelopmentIndicators
#> 21 WorldDevelopmentIndicators
#> 22 WorldDevelopmentIndicators
#> 23 WorldDevelopmentIndicators
#> 24 WorldDevelopmentIndicators
#> 25 WorldDevelopmentIndicators
#> 26 WorldDevelopmentIndicators
#> 27 WorldDevelopmentIndicators
#> 28 WorldDevelopmentIndicators
#> 29 WorldDevelopmentIndicators
#> 30 WorldDevelopmentIndicators
#> 31 WorldDevelopmentIndicators
#> 32 WorldDevelopmentIndicators
#> 33 WorldDevelopmentIndicators
#> 34 WorldDevelopmentIndicators
#> 35 WorldDevelopmentIndicators
#> 36 WorldDevelopmentIndicators
#> 37 WorldDevelopmentIndicators
#> 38 WorldDevelopmentIndicators
#> 39 WorldDevelopmentIndicators
#> 40 WorldDevelopmentIndicators
#> 41 WorldDevelopmentIndicators
#> 42 WorldDevelopmentIndicators
#> 43 WorldDevelopmentIndicators
#> 44 WorldDevelopmentIndicators
#> 45 WorldDevelopmentIndicators
#> 46 WorldDevelopmentIndicators
#> 47 WorldDevelopmentIndicators
#> 48 WorldDevelopmentIndicators
#> 49 WorldDevelopmentIndicators
#> 50 WorldDevelopmentIndicators
#> 51 WorldDevelopmentIndicators
#> 52 WorldDevelopmentIndicators
#> 53 WorldDevelopmentIndicators
#> 54 WorldDevelopmentIndicators
#> 55 WorldDevelopmentIndicators
#> 56 WorldDevelopmentIndicators
#> 57 WorldDevelopmentIndicators
#> 58 WorldDevelopmentIndicators
#> 59 WorldDevelopmentIndicators
#> 60 WorldDevelopmentIndicators
#> 61 WorldDevelopmentIndicators
#> 62 WorldDevelopmentIndicators
#> 63 WorldDevelopmentIndicators
#> 64 WorldDevelopmentIndicators
```
