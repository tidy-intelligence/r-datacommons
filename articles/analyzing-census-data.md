# Analyzing Census Data with Data Commons

## Learning Objectives

By the end of this vignette, you will be able to:

- Understand what Google Data Commons is and why it offers unique value
  for data integration
- Navigate the knowledge graph structure using relationships between
  geographic entities
- Find and use DCIDs (Data Commons IDs) and statistical variables
- Retrieve demographic data across different geographic levels using the
  `datacommons` R package
- Integrate data from multiple sources through the unified Data Commons
  API
- Handle multiple data sources (facets) and select appropriate ones for
  your analysis
- Build progressively complex demographic analyses that combine
  disparate datasets

## Why Start with Census Data?

Census data provides an ideal introduction to Data Commons for several
reasons:

1.  **Familiar territory**: Many analysts have worked with census data,
    making it easier to focus on learning the Data Commons approach
    rather than the data itself.

2.  **Rich relationships**: Census data showcases the power of the
    knowledge graph through natural hierarchies (country → state →
    county → city), demonstrating how Data Commons connects entities.

3.  **Integration opportunities**: Census demographics become even more
    valuable when combined with health, environmental, and economic
    data—showing the true power of Data Commons.

4.  **Real-world relevance**: The examples we’ll explore address actual
    policy questions that require integrated data to answer properly.

## Why Data Commons?

The R ecosystem has excellent packages for specific data sources. For
example, the [tidycensus](https://walker-data.com/tidycensus/) package
provides fantastic functionality for working with U.S. Census data, with
deep dataset-specific features and conveniences.

So why use Data Commons? **The real value is in data integration.**

Data Commons is part of Google’s philanthropic initiatives, designed to
democratize access to public data by combining datasets from
organizations like the UN, World Bank, and U.S. Census into a unified
knowledge graph.

Imagine you’re a policy analyst studying the social determinants of
health. You need to analyze relationships between:

- Census demographics (population, age, income)
- CDC health statistics (disease prevalence, obesity rates)  
- EPA environmental data (air quality indices)
- Bureau of Labor Statistics (unemployment rates)

With traditional approaches, you’d need to:

1.  Learn multiple different APIs
2.  Deal with different geographic coding systems  
3.  Reconcile different time periods and update cycles
4.  Match entities across datasets (is “Los Angeles County” the same in
    all datasets?)

Data Commons solves this by providing a **unified knowledge graph** that
links all these datasets together. One API, one set of geographic
identifiers, one consistent way to access everything. The `datacommons`
R package is your gateway to this integrated data ecosystem, enabling
reproducible analysis pipelines that seamlessly combine diverse data
sources.

## Understanding the Knowledge Graph

Data Commons organizes information as a graph, similar to how web pages
link to each other. Here’s the key terminology:

### DCIDs (Data Commons IDs)

Every entity in Data Commons has a unique identifier called a DCID.
Think of it like a social security number for data:

- `country/USA` = United States
- `geoId/06` = California (using FIPS code 06—Federal Information
  Processing Standards codes are essentially ZIP codes for governments,
  providing standard numeric identifiers for states, counties, and other
  geographic areas)  
- `Count_Person` = the statistical variable for population count

### Relationships

Entities are connected by relationships, following the
[Schema.org](https://schema.org) standard—a collaborative effort to
create structured data vocabularies that help machines understand web
content. For Data Commons, this means consistent, machine-readable
relationships between places and data:

- California –(`containedInPlace`)–\> United States
- California –(`typeOf`)–\> State
- Los Angeles County –(`containedInPlace`)–\> California

This structure lets us traverse the graph to find related information.
Want all counties in California? Follow the `containedInPlace`
relationships backward.

### Statistical Variables

These are the things we can measure:

- `Count_Person` = total population
- `Median_Age_Person` = median age
- `UnemploymentRate_Person` = unemployment rate
- `Mean_Temperature` = average temperature

The power comes from being able to query any variable for any place
using the same consistent approach through the `datacommons` R package.

## Prerequisites

``` r

# Core packages
library(datacommons)
library(dplyr)
library(tidyr)
library(stringr)
library(ggplot2)
library(scales)
library(knitr)

# Set a consistent theme for plots
theme_set(theme_minimal())
```

## Setting Up API Access

You’ll need a free API key from
<https://docs.datacommons.org/api/#obtain-an-api-key>

``` r

# Set your API key
dc_set_api_key("YOUR_API_KEY_HERE")

# Or manually set DATACOMMONS_API_KEY in your .Renviron file
```

Don’t forget to restart your R session after setting the key to
automatically load it.
