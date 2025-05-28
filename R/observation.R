#' Retrieve Observation Data from Data Commons
#'
#' @param date A date string or `"LATEST"`.
#' @param variable_dcids Optional. Vector of statistical variable DCIDs.
#' @param entity_dcids Optional. Vector of entity DCIDs (e.g., places).
#' @param entity_expression Optional. A relation expression string (used in place of `entity_dcids`).
#' @param select Required. Character vector of fields to select. Must include `"entity"` and `"variable"`.
#' @param filter_facet_domains Optional. Vector of domain names to filter facets.
#' @param filter_facet_idsn Optional. Vector of facet IDs to filter observations.
#' @param api_key Your Data Commons API key. If not provided, uses the
#' environment variable `DATACOMMONS_API_KEY`.
#' @param base_url The base URL of the Data Commons API. Defaults to the public
#' endpoint. For custom deployments, must end with `/core/api/v2/`.
#' @param return_type Return format: either `"list"` (parsed R object) or
#' `"json"` (JSON string).
#'
#' @return A list or JSON string, depending on `return_type`.
#'
#' @examples
#' # Look up the statistical variables available for a given entity (place)
#' dc_get_observation(
#'   date = "LATEST",
#'   entity_dcids = "country/TGO",
#'   select = c("entity", "variable")
#' )
#'
#' @export
dc_get_observation <- function(
  date,
  variable_dcids = NULL,
  entity_dcids = NULL,
  entity_expression = NULL,
  select,
  filter_facet_domains = NULL,
  filter_facet_idsn = NULL,
  api_key = Sys.getenv("DATACOMMONS_API_KEY"),
  base_url = Sys.getenv(
    "DATACOMMONS_BASE_URL",
    unset = "https://api.datacommons.org/v2/"
  ),
  return_type = "list"
) {
  validate_api_key(api_key)
  validate_base_url(base_url)
  validate_return_type(
    return_type,
    allowed_return_types = c("json", "list", "data.frame")
  )
  validate_date(date)
  validate_select(select)
  validate_entity(entity_dcids, entity_expression)

  req <- construct_request(
    base_url = base_url,
    path = "observation",
    key = api_key,
    date = date,
    variable_dcids = variable_dcids,
    entity_dcids = entity_dcids,
    entity_expression = entity_expression,
    select = select,
    filter_facet_domains = filter_facet_domains,
    filter_facet_idsn = filter_facet_idsn
  )

  resps <- perform_request(req)

  handle_failures(resps)

  successes <- handle_successes(resps)

  # TODO: add formatting of data.frame return_type only for
  format_response(successes, return_type)
}
