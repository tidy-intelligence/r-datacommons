#' Execute a SPARQL Query via POST to the Data Commons API
#'
#' Sends a SPARQL query to the Data Commons SPARQL endpoint using a POST
#' request.
#'
#' @param query A character string containing a valid SPARQL query.
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
#'
#' # Get a list of all cities with a particular property
#' query <- c(
#'   paste0(
#'     "SELECT DISTINCT ?subject ",
#'     "WHERE {?subject unDataLabel ?object . ?subject typeOf City} LIMIT 10"
#'   )
#' )
#' dc_post_sparql(query)
#'
#' # Get a list of biological specimens
#' query <- c(
#'   paste0(
#'     "SELECT DISTINCT ?name ",
#'     "WHERE {?biologicalSpecimen typeOf BiologicalSpecimen . ",
#'     "?biologicalSpecimen name ?name} ",
#'     "ORDER BY DESC(?name)",
#'     "LIMIT 10"
#'   )
#' )
#' dc_post_sparql(query)
#'
#' @export
dc_post_sparql <- function(
  query,
  api_key = Sys.getenv("DATACOMMONS_API_KEY"),
  base_url = Sys.getenv(
    "DATACOMMONS_BASE_URL",
    unset = "https://api.datacommons.org/v2/"
  ),
  return_type = "list"
) {
  validate_api_key(api_key)
  validate_base_url(base_url)
  validate_return_type(return_type)

  req <- construct_request(
    request_type = "post",
    base_url = base_url,
    path = "sparql",
    key = api_key,
    query = query
  )

  resps <- perform_request(req)

  handle_failures(resps)

  successes <- handle_successes(resps)

  format_response(successes, return_type)
}
