#' Retrieve Node Properties from Data Commons
#'
#' @param nodes A character vector of DCIDs.
#' @param property A relation expression string (e.g., "<-*").
#' @param api_key Your Data Commons API key. If not provided, will use the
#' environment variable `DATACOMMONS_API_KEY`.
#' @param base_url The base URL of the Data Commons API. Defaults to the public
#' endpoint. For custom deployments, it must end with "/core/api/v2/".
#' @param method Either `"list"` (parsed R object) or `"json"` (JSON string).
#'
#' @return A list (if `method = "list"`) or JSON string (if `method = "json"`).
#'
#' @examples
#' # Get all property labels for a given node
#' dc_get_node(nodes = "country/USA", property = "<-")
#'
#' # Get one property value for a given node
#' dc_get_node(nodes = "dc/03lw9rhpendw5", property = "->name")
#'
#' # Get multiple property values for multiple nodes
#' dc_get_node(
#'   nodes = c("geoId/06085", "geoId/06087"),
#'   property = "->[name, latitude, longitude]"
#' )
#'
#' # Get all property values for a node
#' dc_get_node(nodes = "PowerPlant", property = "<-*")
#'
#' # Get a list of all existing statistical variables
#' dc_get_node(nodes = "StatisticalVariable", property = "<-typeOf")
#'
#' # Get a list of all existing entity types
#' dc_get_node(nodes = "Class", property = "<-typeOf")
#'
#' @export
dc_get_node <- function(
  nodes,
  property,
  api_key = Sys.getenv("DATACOMMONS_API_KEY"),
  base_url = "https://api.datacommons.org/v2/",
  method = "list"
) {
  validate_api_key(api_key)
  validate_base_url(base_url)
  validate_method(method)

  req <- construct_request(
    base_url,
    "node",
    key = api_key,
    nodes = nodes,
    property = property
  )

  resps <- perform_request(req)

  handle_failures(resps)

  successes <- handle_successes(resps)

  format_response(successes, method)
}
