#' Retrieve Node Properties from Data Commons
#'
#' Queries the Data Commons API for specified property relationships of given
#' nodes.
#'
#' @param nodes A character vector of terms to resolve.
#' @param expression A relation expression string (e.g., `<-*`, `->name`, or
#' `->[name, latitude]`).
#' @param api_key Your Data Commons API key. If not provided, uses the
#' environment variable `DATACOMMONS_API_KEY`.
#' @param base_url The base URL of the Data Commons API. Defaults to the public
#' endpoint. For custom deployments, must end with `/core/api/v2/`.
#' @param return_type Return format: either `"list"` (parsed R object) or
#' `"json"` (JSON string).
#'
#' @return A list or JSON string, depending on `return_type`.
#'
#' @examplesIf dc_has_api_key()
#' # Get all property labels for a given node
#' dc_get_node(nodes = "country/USA", expression = "<-")
#'
#' # Get one property value for a given node
#' dc_get_node(nodes = "dc/03lw9rhpendw5", expression = "->name")
#'
#' # Get multiple property values for multiple nodes
#' dc_get_node(
#'   nodes = c("geoId/06085", "geoId/06087"),
#'   expression = "->[name, latitude, longitude]"
#' )
#'
#' # Get all property values for a node
#' dc_get_node(nodes = "PowerPlant", expression = "<-*")
#'
#' # Get a list of all existing statistical variables
#' dc_get_node(nodes = "StatisticalVariable", expression = "<-typeOf")
#'
#' # Get a list of all existing entity types
#' dc_get_node(nodes = "Class", expression = "<-typeOf")
#'
#' @export
dc_get_node <- function(
  nodes,
  expression,
  api_key = Sys.getenv("DATACOMMONS_API_KEY"),
  base_url = Sys.getenv(
    "DATACOMMONS_BASE_URL",
    unset = "https://api.datacommons.org/v2/"
  ),
  return_type = "json"
) {
  validate_api_key(api_key)
  validate_base_url(base_url)
  validate_return_type(return_type)

  req <- construct_request(
    base_url = base_url,
    path = "node",
    key = api_key,
    nodes = nodes,
    property = expression
  )

  resps <- perform_request(req)

  handle_failures(resps)

  successes <- handle_successes(resps)

  format_response(successes, return_type)
}

#' Get Property Values for Data Commons Nodes
#'
#' A convenience wrapper around [dc_get_node()] to retrieve all property values
#' for the specified nodes. This is equivalent to calling [dc_get_node()] with
#' `expression = "<-"`.
#'
#' @inheritParams dc_get_node
#' @param properties A character vector of properties (e.g. "name", "latitude",
#' "all")
#'
#' @return A list containing the requested property values for each node.
#'   The structure depends on the properties requested and follows the same
#'   format as [dc_get_node()].
#'
#' @examplesIf dc_has_api_key()
#' # Get the name property (default)
#' dc_get_property_values(nodes = "country/USA")
#'
#' # Get a specific property
#' dc_get_property_values(nodes = "country/USA", properties = "latitude")
#'
#' # Get multiple specific properties
#' dc_get_property_values(
#'   nodes = c("geoId/06085", "geoId/06087"),
#'   properties = c("name", "latitude", "longitude")
#' )
#'
#' # Get all properties
#' dc_get_property_values(nodes = "PowerPlant", properties = "all")
#'
#' @export
dc_get_property_values <- function(
  nodes,
  properties = "name",
  api_key = Sys.getenv("DATACOMMONS_API_KEY"),
  base_url = Sys.getenv(
    "DATACOMMONS_BASE_URL",
    unset = "https://api.datacommons.org/v2/"
  ),
  return_type = "json"
) {
  if (identical(properties, "all")) {
    expression <- "<-*"
  } else if (length(properties) == 1) {
    expression <- paste0("->", properties)
  } else {
    props <- paste(properties, collapse = ", ")
    expression <- paste0("->[", props, "]")
  }
  dc_get_node(
    nodes = nodes,
    expression = expression,
    api_key = api_key,
    base_url = base_url,
    return_type = return_type
  )
}

#' Get Available Statistical Variables from Data Commons
#'
#' A convenience wrapper around [dc_get_node()] to retrieve all available
#' statistical variables in Data Commons. This is equivalent to calling
#' [dc_get_node()] with `nodes = "StatisticalVariable"` and
#' `expression = "<-typeOf"`.
#'
#' @param api_key Your Data Commons API key. If not provided, will use the
#'   environment variable `DATACOMMONS_API_KEY`.
#' @param base_url The base URL of the Data Commons API. Defaults to the public
#'   endpoint. For custom deployments, it must end with "/core/api/v2/".
#' @param return_type Return format: either `"list"` (parsed R object) or
#' `"json"` (JSON string).
#'
#' @return A list (if `return_type = "list"`) or JSON string (if
#' `return_type = "json"`) containing all available statistical variables.
#'
#' @examplesIf dc_has_api_key()
#' # Get all statistical variables
#' statistical_vars <- dc_get_available_statistical_variables()
#'
#' @export
dc_get_available_statistical_variables <- function(
  api_key = Sys.getenv("DATACOMMONS_API_KEY"),
  base_url = Sys.getenv(
    "DATACOMMONS_BASE_URL",
    unset = "https://api.datacommons.org/v2/"
  ),
  return_type = "json"
) {
  dc_get_node(
    nodes = "StatisticalVariable",
    expression = "<-typeOf",
    api_key = api_key,
    base_url = base_url,
    return_type = return_type
  )
}

#' Get All Available Classes from Data Commons
#'
#' A convenience wrapper around [dc_get_node()] to retrieve all available
#' entity classes in Data Commons. This is equivalent to calling [dc_get_node()]
#' with `nodes = "Class"` and `expression = "<-typeOf"`.
#'
#' @param api_key Your Data Commons API key. If not provided, will use the
#' environment variable `DATACOMMONS_API_KEY`.
#' @param base_url The base URL of the Data Commons API. Defaults to the public
#' endpoint. For custom deployments, it must end with "/core/api/v2/".
#' @param return_type Return format: either `"list"` (parsed R object) or
#' `"json"` (JSON string).
#'
#' @return A list (if `return_type = "list"`) or JSON string (if
#' `return_type = "json"`) containing all available entity classes.
#'
#' @examplesIf dc_has_api_key()
#' # Get all entity classes
#' all_classes <- dc_get_all_classes()
#'
#' @export
dc_get_all_classes <- function(
  api_key = Sys.getenv("DATACOMMONS_API_KEY"),
  base_url = Sys.getenv(
    "DATACOMMONS_BASE_URL",
    unset = "https://api.datacommons.org/v2/"
  ),
  return_type = "json"
) {
  dc_get_node(
    nodes = "Class",
    expression = "<-typeOf",
    api_key = api_key,
    base_url = base_url,
    return_type = return_type
  )
}
