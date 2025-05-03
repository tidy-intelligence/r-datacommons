#' Resolve Nodes using Data Commons Resolve API
#'
#' @param nodes A character vector of terms to resolve.
#' @param property A string defining the property expression (e.g., "<-description->dcid").
#' @param api_key Your Data Commons API key. If not provided, will use the
#' environment variable `DATACOMMONS_API_KEY`.
#' @param base_url The base URL of the Data Commons API. Defaults to the public
#' endpoint for the resolve service.
#' @param method Either `"list"` for a parsed R object or `"json"` for raw JSON.
#'
#' @return A list (if `method = "list"`) or a JSON string (if `method = "json"`).
#'
#' @examples
#' # Find the DCID of a place by another known ID
#' dc_get_resolve(
#'   nodes = "Q30",
#'   property = "<-wikidataId->dcid"
#' )
#'
#' # Find the DCID of a place by coordinates
#' dc_get_resolve(
#'   nodes = "37.42#-122.08",
#'   property = "<-geoCoordinate->dcid"
#' )
#'
#' # Find the DCID of a place by name
#' dc_get_resolve(
#'   nodes = "Georgia",
#'   property = "<-description->dcid"
#' )
#'
#' # Find the DCID of a place by name, with a type filter
#' dc_get_resolve(
#'   nodes = "Georgia",
#'   property = "<-description{typeOf:State}->dcid"
#' )
#'
#' # Find the DCID of multiple places by name, with a type filter
#' dc_get_resolve(
#'   nodes = "Mountain View, CA", "New York City",
#'   property = "<-description{typeOf:City}->dcid"
#' )
#'
#' @export
dc_get_resolve <- function(
  nodes,
  property,
  api_key = Sys.getenv("DATACOMMONS_API_KEY"),
  base_url = Sys.getenv(
    "DATACOMMONS_BASE_URL",
    unset = "https://api.datacommons.org/v2/"
  ),
  method = "list"
) {
  validate_api_key(api_key)
  validate_base_url(base_url)
  validate_method(method)

  req <- construct_request(
    request_type = "get",
    base_url = base_url,
    path = "resolve",
    key = api_key,
    nodes = nodes,
    property = property
  )

  resps <- perform_request(req)

  handle_failures(resps)

  successes <- handle_successes(resps)

  format_response(successes, method)
}
