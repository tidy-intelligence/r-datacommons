#' Is a Data Commons API key avaiable?
#'
#' Used for examples/testing.
#'
#' @keywords internal
#'
#' @export
dc_has_api_key <- function() {
  Sys.getenv("DATACOMMONS_API_KEY") != ""
}

#' Set environment variable for Data Commons API key
#'
#' @param api_key description
#'
#' @export
dc_set_api_key <- function(api_key) {
  Sys.setenv("DATACOMMONS_API_KEY" = api_key)
}

#' Set environment variable for Data Commons base URL
#'
#' @param base_url description
#'
#' @export
dc_set_base_url <- function(base_url) {
  Sys.setenv("DATACOMMONS_BASE_URL" = base_url)
}

#' @keywords internal
#' @noRd
next_req <- function(resp, req) {
  body <- resp_body_json(resp)

  next_token <- body$nextToken
  if (is.null(next_token)) {
    return(NULL)
  }

  req |>
    req_url_query(nextToken = next_token)
}

#' @keywords internal
#' @noRd
format_response <- function(data, method) {
  if (method == "json") {
    data |>
      resps_data(\(resp) resp_body_string(resp)) |>
      fromJSON() |>
      toJSON(pretty = TRUE)
  } else if (method == "list") {
    data |>
      resps_data(\(resp) resp_body_json(resp))
  } else if (method == "data.frame") {
    raw <- data |>
      resps_data(\(resp) resp_body_json(resp))

    rows <- list()

    by_variable <- raw$byVariable
    facets_info <- raw$facets

    for (variable_name in names(by_variable)) {
      by_entity <- by_variable[[variable_name]]$byEntity
      for (entity_name in names(by_entity)) {
        ordered_facets <- by_entity[[entity_name]]$orderedFacets
        for (facet in ordered_facets) {
          facet_id <- facet$facetId
          observations <- facet$observations

          if (!is.null(facets_info[[facet_id]]$importName)) {
            facet_name <- facets_info[[facet_id]]$importName[[1]]
          } else {
            facet_name <- NA
          }

          for (obs in observations) {
            row <- list(
              entity_dcid = entity_name,
              variable_dcid = variable_name,
              date = obs$date,
              value = obs$value,
              facet_id = facet_id,
              facet_name = facet_name
            )
            rows[[length(rows) + 1]] <- row
          }
        }
      }
    }

    df <- as.data.frame(do.call(
      rbind,
      lapply(rows, as.data.frame, stringsAsFactors = FALSE)
    ))

    df
  }
}

#' @keywords internal
#' @noRd
construct_request <- function(
  request_type = "get",
  base_url,
  path,
  key,
  nodes = NULL,
  property = NULL,
  date = NULL,
  select = NULL,
  variable_dcids = NULL,
  entity_dcids = NULL,
  entity_expression = NULL,
  filter_domains = NULL,
  filter_facet_ids = NULL,
  query = NULL
) {
  query_params <- list(
    key = key,
    nodes = nodes,
    property = property,
    date = date,
    select = select,
    "variable.dcids" = variable_dcids,
    "entity.dcids" = entity_dcids,
    "entity.expression" = entity_expression,
    "filter.domains" = filter_domains,
    "filter.facet_ids" = filter_facet_ids,
    query = query
  )

  if (request_type == "get") {
    query_params <- Filter(Negate(is.null), query_params)

    request(base_url) |>
      req_url_path_append(path) |>
      req_url_query(!!!query_params, .multi = "explode") |>
      req_user_agent(
        "datacommons R package (https://github.com/tidy-intelligence/r-datacommons)"
      )
  } else if (request_type == "post") {
    request(base_url) |>
      req_url_path_append(path) |>
      req_method("POST") |>
      req_headers(
        "X-API-Key" = key
      ) |>
      req_body_json(list(query = query)) |>
      req_user_agent(
        "datacommons R package (https://github.com/tidy-intelligence/r-datacommons)"
      )
  } else {
    cli::cli_abort(
      c("!" = "{.param request_type} must be 'get' or 'post'")
    )
  }
}

#' @keywords internal
#' @noRd
perform_request <- function(req) {
  req_perform_iterative(req, next_req = next_req)
}

#' @keywords internal
#' @noRd
handle_failures <- function(resps) {
  failed_resps <- resps_failures(resps)
  if (length(failed_resps) > 0) {
    for (resp in failed_resps) {
      url <- resp$request$url %||% "<unknown>"
      status <- resp$status_code %||% "unknown"
      msg <- tryCatch(
        {
          content <- resp_body_string(resp)
          jsonlite::fromJSON(content)$message %||% "<no message>"
        },
        error = function(e) "<could not parse error message>"
      )
      cli::cli_warn(c(
        "!" = "Request to {.url {url}} failed with status {.code {status}}.",
        ">" = msg
      ))
    }
  }
}

#' @keywords internal
#' @noRd
handle_successes <- function(resps) {
  resps |>
    resps_successes()
}

#' @keywords internal
#' @noRd
`%||%` <- function(a, b) if (!is.null(a)) a else b
