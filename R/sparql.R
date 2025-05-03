#' Execute a SPARQL Query via POST to the Data Commons API
#'
#' @description
#' Sends a SPARQL query to the Data Commons SPARQL endpoint using a POST request.
#' The API key is passed in the header, and the query is included as JSON in the request body.
#'
#' @param query A character string containing a valid SPARQL query.
#' @param api_key Your Data Commons API key. If not provided, the function will
#' use the `DATACOMMONS_API_KEY` environment variable.
#' @param base_url The base URL for the Data Commons API. Defaults to the public
#' endpoint \code{https://api.datacommons.org/v2/}. Can also be set via the
#' `DATACOMMONS_BASE_URL` environment variable.
#' @param method Specifies the response format: \code{"list"} for a parsed R object,
#' or \code{"json"} for the raw JSON string.
#'
#' @return A list (if `method = "list"`) or a JSON string (if `method = "json"`),
#' representing the SPARQL query results.
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
  method = "list"
) {
  validate_api_key(api_key)
  validate_base_url(base_url)
  validate_method(method)

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

  format_response(successes, method)
}
