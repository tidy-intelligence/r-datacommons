#' Resolve Nodes from Data Commons
#'
#' @param nodes A character vector of terms to resolve.
#' @param expression A string defining the property expression
#' (e.g., "<-description->dcid").
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
#' # Find the DCID of a place by another known ID
#' dc_get_resolve(
#'   nodes = "Q30",
#'   expression = "<-wikidataId->dcid"
#' )
#'
#' # Find the DCID of a place by coordinates
#' dc_get_resolve(
#'   nodes = "37.42#-122.08",
#'   expression = "<-geoCoordinate->dcid"
#' )
#'
#' # Find the DCID of a place by name
#' dc_get_resolve(
#'   nodes = "Georgia",
#'   expression = "<-description->dcid"
#' )
#'
#' # Find the DCID of a place by name, with a type filter
#' dc_get_resolve(
#'   nodes = "Georgia",
#'   expression = "<-description{typeOf:State}->dcid"
#' )
#'
#' # Find the DCID of multiple places by name, with a type filter
#' dc_get_resolve(
#'   nodes = "Mountain View, CA", "New York City",
#'   expression = "<-description{typeOf:City}->dcid"
#' )
#'
#' @export
dc_get_resolve <- function(
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
    request_type = "get",
    base_url = base_url,
    path = "resolve",
    key = api_key,
    nodes = nodes,
    property = expression
  )

  resps <- perform_request(req)

  handle_failures(resps)

  successes <- handle_successes(resps)

  format_response(successes, return_type)
}

#' Resolve DCIDs from Wikidata IDs via Data Commons
#'
#' Resolves Wikidata identifiers (e.g., `"Q30"` for the United States) to
#' Data Commons DCIDs using the wikidataId property.
#'
#' @inheritParams dc_get_resolve
#' @param wikidata_ids The Wikidata IDs of the entities to look up.
#' @param return_type Return format: either `"list"` (parsed R object) or
#' `"json"` (JSON string).
#'
#' @return A list or JSON string, depending on `return_type`.
#'
#' @examplesIf dc_has_api_key()
#' # Get the DCID for the United States (Wikidata ID "Q30")
#' dc_get_dcids_by_wikidata_id("Q30")
#'
#' # Batch query for multiple Wikidata IDs
#' dc_get_dcids_by_wikidata_id(c("Q30", "Q60"))
#'
#' @export
dc_get_dcids_by_wikidata_id <- function(
  wikidata_ids,
  api_key = Sys.getenv("DATACOMMONS_API_KEY"),
  base_url = Sys.getenv(
    "DATACOMMONS_BASE_URL",
    unset = "https://api.datacommons.org/v2/"
  ),
  return_type = "json"
) {
  dc_get_resolve(
    nodes = wikidata_ids,
    expression = "<-wikidataId->dcid",
    api_key = api_key,
    base_url = base_url,
    return_type = return_type
  )
}

#' Resolve DCIDs from Latitude and Longitude via Data Commons
#'
#' Resolves geographic coordinates (provided as latitude and longitude) to
#' Data Commons DCIDs using the geoCoordinate property.
#'
#' @inheritParams dc_get_resolve
#' @param latitude A numeric vector of latitude values.
#' @param longitude A numeric vector of longitude values.
#' @param return_type Return format: either `"list"` (parsed R object) or
#' `"json"` (JSON string).
#'
#' @return A list or JSON string, depending on `return_type`.
#'
#' @examplesIf dc_has_api_key()
#' # Get the DCID for a coordinate
#' dc_get_dcid_by_coordinates(37.42, -122.08)
#'
#' # Batch query for multiple coordinates
#' dc_get_dcid_by_coordinates(c(34.05, 40.71), c(-118.25, -74.01))
#'
#' @export
dc_get_dcid_by_coordinates <- function(
  latitude,
  longitude,
  api_key = Sys.getenv("DATACOMMONS_API_KEY"),
  base_url = Sys.getenv(
    "DATACOMMONS_BASE_URL",
    unset = "https://api.datacommons.org/v2/"
  ),
  return_type = "json"
) {
  if (length(latitude) != length(longitude)) {
    cli::cli_abort("Latitude and longitude vectors must be the same length.")
  }

  nodes <- paste(latitude, longitude, sep = "#")

  dc_get_resolve(
    nodes,
    expression = "<-geoCoordinate->dcid",
    api_key = api_key,
    base_url = base_url,
    return_type = return_type
  )
}

#' Resolve DCIDs from Place Names via Data Commons
#'
#' Resolves a node (e.g., a place name) to its Data Commons DCID using the
#' description property. Optionally filters results by entity type.
#'
#' @inheritParams dc_get_resolve
#' @param names A vector of names or descriptions of the entities to look up.
#' @param entity_type Optional string to filter results by `typeOf`, such as
#' `"State"` or `"City"`. If `NULL`, no filter is applied.
#'
#' @return A list or JSON string, depending on `return_type`.
#'
#' @examplesIf dc_has_api_key()
#' # Get the DCID of "Georgia" (ambiguous without type)
#' dc_get_dcids_by_name(names = "Georgia")
#'
#' # Get the DCID of "Georgia" as a state
#' dc_get_dcids_by_name(names = "Georgia", entity_type = "State")
#'
#' # Get the DCID of "New York City" as a city
#' dc_get_dcids_by_name(names = "New York City", entity_type = "City")
#'
#' # Query multiple cities
#' dc_get_dcids_by_name(
#'   names = c("Mountain View, CA", "New York City"),
#'   entity_type = "City"
#' )
#'
#' @export
dc_get_dcids_by_name <- function(
  names,
  entity_type = NULL,
  api_key = Sys.getenv("DATACOMMONS_API_KEY"),
  base_url = Sys.getenv(
    "DATACOMMONS_BASE_URL",
    unset = "https://api.datacommons.org/v2/"
  ),
  return_type = "json"
) {
  if (is.null(entity_type)) {
    expression <- "<-description->dcid"
  } else {
    expression <- paste0("<-description{typeOf:", entity_type, "}->dcid")
  }

  dc_get_resolve(
    nodes = names,
    expression = expression,
    api_key = api_key,
    base_url = base_url,
    return_type = return_type
  )
}
