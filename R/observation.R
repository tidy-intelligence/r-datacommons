#' Retrieve Observations from Data Commons
#'
#' @param date A date string, `"latest"`, or `"all"` to return observations for
#' all dates.
#' @param variable_dcids Optional. Vector of statistical variable DCIDs.
#' @param entity_dcids Optional. Vector of entity DCIDs (e.g., places). One of
#' `entity_dcids`, `entity_expression`, or the combination of `parent_entity`
#' and `entity_type` is required.
#' @param entity_expression Optional. A relation expression string (used in
#' place of `entity_dcids`). One of `entity_dcids`, `entity_expression`, or the
#' combination of `parent_entity` and `entity_type` is required.
#' @param parent_entity Optional. A parent entity DCID to be used in combination
#' with `entity_type` to construct an entity expression.
#' @param entity_type Optional. A child entity type (e.g., `"County"`) to be
#' used with `parent_entity` to construct an entity expression.
#' @param select Required. Character vector of fields to select. Must include
#' `"entity"` and `"variable"`. Defaults to
#' `c("date", "entity", "value", "variable")`.
#' @param filter_domains Optional. Vector of domain names to filter
#' facets.
#' @param filter_facet_ids Optional. Vector of facet IDs to filter
#' observations.
#' @param api_key Your Data Commons API key. If not provided, uses the
#' environment variable `DATACOMMONS_API_KEY`.
#' @param base_url The base URL of the Data Commons API. Defaults to the public
#' endpoint. For custom deployments, must end with `/core/api/v2/`.
#' @param return_type Either `"list"` (parsed R object), `"json"` (JSON string),
#' or `"data.frame"`.
#'
#' @return A list (if `return_type = "list"`), JSON string (if
#' `return_type = "json"`), or data frame (if `return_type = "data.frame"`)
#'
#' @examplesIf dc_has_api_key()
#' # Look up the statistical variables available for a given entity (place)
#' dc_get_observations(
#'   date = "latest",
#'   entity_dcids = c("country/TGO", "country/USA"),
#'   select = c("entity", "variable")
#' )
#'
#' # Look up whether a given entity (place) has data for a given variable
#' dc_get_observations(
#'   date = "latest",
#'   variable_dcids = c("Count_Person_Male", "Count_Person_Female"),
#'   entity_dcids = c("country/MEX", "country/CAN", "country/MYS"),
#'   select = c("entity", "variable")
#' )
#'
#' # Look up whether a given entity (place) has data for a given variable and
#' # show the sources
#' dc_get_observations(
#'   date = "latest",
#'   variable_dcids = c("Count_Person_Male", "Count_Person_Female"),
#'   entity_dcids = c("country/MEX", "country/CAN", "country/MYS"),
#'   select = c("entity", "variable", "facet")
#' )
#'
#' # Get the latest observations for a single entity by DCID
#' dc_get_observations(
#'   date = "latest",
#'   variable_dcids = c("Count_Person"),
#'   entity_dcids = c("country/CAN")
#' )
#'
#' # Get the observations at a particular date for given entities by DCID
#' dc_get_observations(
#'   date = 2015,
#'   variable_dcids = c("Count_Person"),
#'   entity_dcids = c("country/CAN", "geoId/06")
#' )
#'
#' # Get all observations for selected entities by DCID
#' dc_get_observations(
#'   date = 2015,
#'   variable_dcids = "Count_Person",
#'   entity_dcids = c(
#'     "cCount_Person_EducationalAttainmentDoctorateDegree",
#'     "geoId/55",
#'     "geoId/55"
#'   )
#' )
#'
#' # Get the latest observations for entities specified by expression
#' dc_get_observations(
#'   date = "latest",
#'   variable_dcids = "Count_Person",
#'   entity_expression = "geoId/06<-containedInPlace+{typeOf:County}"
#' )
#'
#' # Get the latest observations for a single entity, filtering by provenance
#' dc_get_observations(
#'   date = "latest",
#'   variable_dcids = "Count_Person",
#'   entity_dcids = "country/USA",
#'   filter_domains = "www2.census.gov"
#' )
#'
#' # Get the latest observations for a single entity, filtering for specific
#' # dataset
#' dc_get_observations(
#'   date = "latest",
#'   variable_dcids = "Count_Person",
#'   entity_dcids = "country/BRA",
#'   filter_facet_ids = "3981252704"
#' )
#'
#' # Get observations for all states of a country
#' dc_get_observations(
#'   variable_dcids = c("Count_Person"),
#'   date = 2021,
#'   parent_entity = "country/USA",
#'   entity_type = "State",
#'   return_type = "data.frame"
#' )
#'
#' @export
dc_get_observations <- function(
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
  base_url = Sys.getenv(
    "DATACOMMONS_BASE_URL",
    unset = "https://api.datacommons.org/v2/"
  ),
  return_type = "json"
) {
  validate_api_key(api_key)
  validate_base_url(base_url)
  validate_return_type(
    return_type,
    allowed_return_types = c("json", "list", "data.frame")
  )
  validate_date(date)
  validate_select(select)
  validate_entity(entity_dcids, entity_expression, parent_entity, entity_type)

  if (date == "all") {
    date <- ""
  }
  if (date == "latest") {
    date <- "LATEST"
  }

  if (!is.null(parent_entity) & !is.null(entity_type)) {
    entity_expression <- paste0(
      parent_entity,
      "<-containedInPlace+{typeOf:",
      entity_type,
      "}"
    )
  }

  req <- construct_request(
    base_url = base_url,
    path = "observation",
    key = api_key,
    date = date,
    variable_dcids = variable_dcids,
    entity_dcids = entity_dcids,
    entity_expression = entity_expression,
    select = select,
    filter_domains = filter_domains,
    filter_facet_ids = filter_facet_ids
  )

  resps <- perform_request(req)

  handle_failures(resps)

  successes <- handle_successes(resps)

  format_response(successes, return_type)
}
