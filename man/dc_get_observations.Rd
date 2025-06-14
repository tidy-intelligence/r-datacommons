% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/observation.R
\name{dc_get_observations}
\alias{dc_get_observations}
\title{Retrieve Observations from Data Commons}
\usage{
dc_get_observations(
  date,
  variable_dcids = NULL,
  entity_dcids = NULL,
  entity_expression = NULL,
  parent_entity = NULL,
  entity_type = NULL,
  select = c("date", "entity", "value", "variable"),
  filter_domains = NULL,
  filter_facet_ids = NULL,
  api_key = Sys.getenv("DATACOMMONS_API_KEY"),
  base_url = Sys.getenv("DATACOMMONS_BASE_URL", unset =
    "https://api.datacommons.org/v2/"),
  return_type = "json"
)
}
\arguments{
\item{date}{A date string, \code{"latest"}, or \code{"all"} to return observations for
all dates.}

\item{variable_dcids}{Optional. Vector of statistical variable DCIDs.}

\item{entity_dcids}{Optional. Vector of entity DCIDs (e.g., places). One of
\code{entity_dcids}, \code{entity_expression}, or the combination of \code{parent_entity}
and \code{entity_type} is required.}

\item{entity_expression}{Optional. A relation expression string (used in
place of \code{entity_dcids}). One of \code{entity_dcids}, \code{entity_expression}, or the
combination of \code{parent_entity} and \code{entity_type} is required.}

\item{parent_entity}{Optional. A parent entity DCID to be used in combination
with \code{entity_type} to construct an entity expression.}

\item{entity_type}{Optional. A child entity type (e.g., \code{"County"}) to be
used with \code{parent_entity} to construct an entity expression.}

\item{select}{Required. Character vector of fields to select. Must include
\code{"entity"} and \code{"variable"}. Defaults to
\code{c("date", "entity", "value", "variable")}.}

\item{filter_domains}{Optional. Vector of domain names to filter
facets.}

\item{filter_facet_ids}{Optional. Vector of facet IDs to filter
observations.}

\item{api_key}{Your Data Commons API key. If not provided, uses the
environment variable \code{DATACOMMONS_API_KEY}.}

\item{base_url}{The base URL of the Data Commons API. Defaults to the public
endpoint. For custom deployments, must end with \verb{/core/api/v2/}.}

\item{return_type}{Either \code{"list"} (parsed R object), \code{"json"} (JSON string),
or \code{"data.frame"}.}
}
\value{
A list (if \code{return_type = "list"}), JSON string (if
\code{return_type = "json"}), or data frame (if \code{return_type = "data.frame"})
}
\description{
Retrieve Observations from Data Commons
}
\examples{
\dontshow{if (dc_has_api_key()) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}
# Look up the statistical variables available for a given entity (place)
dc_get_observations(
  date = "latest",
  entity_dcids = c("country/TGO", "country/USA"),
  select = c("entity", "variable")
)

# Look up whether a given entity (place) has data for a given variable
dc_get_observations(
  date = "latest",
  variable_dcids = c("Count_Person_Male", "Count_Person_Female"),
  entity_dcids = c("country/MEX", "country/CAN", "country/MYS"),
  select = c("entity", "variable")
)

# Look up whether a given entity (place) has data for a given variable and
# show the sources
dc_get_observations(
  date = "latest",
  variable_dcids = c("Count_Person_Male", "Count_Person_Female"),
  entity_dcids = c("country/MEX", "country/CAN", "country/MYS"),
  select = c("entity", "variable", "facet")
)

# Get the latest observations for a single entity by DCID
dc_get_observations(
  date = "latest",
  variable_dcids = c("Count_Person"),
  entity_dcids = c("country/CAN")
)

# Get the observations at a particular date for given entities by DCID
dc_get_observations(
  date = 2015,
  variable_dcids = c("Count_Person"),
  entity_dcids = c("country/CAN", "geoId/06")
)

# Get all observations for selected entities by DCID
dc_get_observations(
  date = 2015,
  variable_dcids = "Count_Person",
  entity_dcids = c(
    "cCount_Person_EducationalAttainmentDoctorateDegree",
    "geoId/55",
    "geoId/55"
  )
)

# Get the latest observations for entities specified by expression
dc_get_observations(
  date = "latest",
  variable_dcids = "Count_Person",
  entity_expression = "geoId/06<-containedInPlace+{typeOf:County}"
)

# Get the latest observations for a single entity, filtering by provenance
dc_get_observations(
  date = "latest",
  variable_dcids = "Count_Person",
  entity_dcids = "country/USA",
  filter_domains = "www.census.gov"
)

# Get the latest observations for a single entity, filtering for specific
# dataset
dc_get_observations(
  date = "latest",
  variable_dcids = "Count_Person",
  entity_dcids = "country/BRA",
  filter_facet_ids = "3981252704"
)

# Get observations for all states of a country as a data frame
dc_get_observations(
  variable_dcids = "Count_Person",
  date = 2021,
  parent_entity = "country/USA",
  entity_type = "State",
  return_type = "data.frame"
)
\dontshow{\}) # examplesIf}
}
