#' Execute a SPARQL Query via POST to the Data Commons API
#'
#' `r lifecycle::badge("deprecated")`
#'
#' Sends a SPARQL query to the Data Commons SPARQL endpoint using a POST
#' request.
#'
#' This function is deprecated because the public Data Commons API
#' (`https://api.datacommons.org/v2/`) has retired its SPARQL endpoint and
#' now responds with HTTP 410 Gone. It still works against custom Data Commons
#' deployments that support SPARQL queries, but will be removed in a future
#' release.
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
#' \dontrun{
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
#' }
#'
#' @export
dc_post_sparql <- function(
  query,
  api_key = Sys.getenv("DATACOMMONS_API_KEY"),
  base_url = Sys.getenv(
    "DATACOMMONS_BASE_URL",
    unset = "https://api.datacommons.org/v2/"
  ),
  return_type = "json"
) {
  lifecycle::deprecate_warn(
    when = "0.1.1",
    what = "dc_post_sparql()",
    details = paste(
      "The public Data Commons API has retired its SPARQL endpoint.",
      "The function still works against custom deployments that support it."
    )
  )

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
