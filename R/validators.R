#' @keywords internal
#' @noRd
validate_api_key <- function(api_key = NULL) {
  if (is.null(api_key)) {
    key <- Sys.getenv("DATACOMMONS_API_KEY")
    if (key == "" || is.null(key)) {
      stop(
        paste0(
          "API key not provided. Set it via the 'api_key' parameter or the ",
          "?set_api_key() helper."
        )
      )
    }
  }
  invisible(TRUE)
}

#' @keywords internal
#' @noRd
validate_base_url <- function(base_url) {
  default_url <- "https://api.datacommons.org/v2/"

  is_valid <- identical(base_url, default_url) ||
    grepl("^https?://.+/core/api/v2/?$", base_url)

  if (!is_valid) {
    stop(
      paste0(
        "Invalid base_url. It must be either:\n",
        " - '",
        default_url,
        "'\n",
        " - Or a custom URL ending in '/core/api/v2/'"
      )
    )
  }

  invisible(TRUE)
}

#' @keywords internal
#' @noRd
validate_return_type <- function(
  return_type,
  allowed_return_types = c("json", "list")
) {
  if (!return_type %in% allowed_return_types) {
    stop("Invalid return_type. Must be either 'json' or 'list'.")
  }
  invisible(TRUE)
}

#' @keywords internal
#' @noRd
validate_date <- function(date) {
  if (missing(date)) stop("Parameter `date` is required.")
}

#' @keywords internal
#' @noRd
validate_select <- function(select) {
  if (missing(select) || !all(c("entity", "variable") %in% select)) {
    stop("`select` must include both 'entity' and 'variable'.")
  }
}

#' @keywords internal
#' @noRd
validate_entity <- function(entity_dcids, entity_expression) {
  if (is.null(entity_dcids) && is.null(entity_expression)) {
    stop("Either `entity_dcids` or `entity_expression` must be provided.")
  }
}
