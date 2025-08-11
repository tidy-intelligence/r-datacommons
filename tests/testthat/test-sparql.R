test_that("dc_post_sparql wires calls correctly & returns formatted output", {
  rec <- new.env(parent = emptyenv())

  withr::local_envvar(
    DATACOMMONS_API_KEY = "ENV_KEY",
    DATACOMMONS_BASE_URL = "https://api.datacommons.org/v2/"
  )

  testthat::with_mocked_bindings(
    validate_api_key = function(api_key) NULL,
    validate_base_url = function(base_url) NULL,
    validate_return_type = function(
      return_type,
      allowed_return_types = c("json", "list")
    ) {
      NULL
    },

    construct_request = function(
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
      rec$args <<- list(
        request_type = request_type,
        base_url = base_url,
        path = path,
        key = key,
        query = query
      )
      "REQ"
    },

    perform_request = function(req) {
      expect_equal(req, "REQ")
      "RESPS"
    },

    handle_failures = function(resps) {
      expect_equal(resps, "RESPS")
      NULL
    },

    handle_successes = function(resps) {
      expect_equal(resps, "RESPS")
      "SUCCESSES"
    },

    format_response = function(data, return_type) {
      expect_equal(data, "SUCCESSES")
      expect_equal(return_type, "json")
      "FORMATTED"
    },

    {
      out <- dc_post_sparql("SELECT * WHERE {}", return_type = "json")
      expect_equal(out, "FORMATTED")

      # Parameters passed into construct_request are correct
      expect_equal(rec$args$request_type, "post")
      expect_equal(rec$args$base_url, "https://api.datacommons.org/v2/")
      expect_equal(rec$args$path, "sparql")
      expect_equal(rec$args$key, "ENV_KEY")
      expect_equal(rec$args$query, "SELECT * WHERE {}")
    }
  )
})

test_that("dc_post_sparql respects explicit base_url & return_type = 'list'", {
  rec <- new.env(parent = emptyenv())

  testthat::with_mocked_bindings(
    validate_api_key = function(api_key) NULL,
    validate_base_url = function(base_url) NULL,
    validate_return_type = function(
      return_type,
      allowed_return_types = c("json", "list")
    ) {
      NULL
    },

    construct_request = function(
      request_type = "get",
      base_url,
      path,
      key,
      ...,
      query = NULL
    ) {
      rec$args <<- list(
        request_type = request_type,
        base_url = base_url,
        path = path,
        key = key,
        query = query
      )
      "REQ"
    },
    perform_request = function(req) "RESPS",
    handle_failures = function(resps) NULL,
    handle_successes = function(resps) "SUCCESSES",

    format_response = function(data, return_type) {
      expect_equal(return_type, "list")
      list(ok = TRUE, data = data)
    },

    {
      out <- dc_post_sparql(
        query = "ASK {}",
        api_key = "A_KEY",
        base_url = "https://example.org/core/api/v2/",
        return_type = "list"
      )
      expect_type(out, "list")
      expect_true(out$ok)

      # Confirm the explicit base_url + POST + path
      expect_equal(rec$args$request_type, "post")
      expect_equal(rec$args$base_url, "https://example.org/core/api/v2/")
      expect_equal(rec$args$path, "sparql")
      expect_equal(rec$args$key, "A_KEY")
      expect_equal(rec$args$query, "ASK {}")
    }
  )
})

test_that("dc_post_sparql propagates validation errors", {
  testthat::with_mocked_bindings(
    validate_api_key = function(api_key) cli::cli_abort("bad key"),
    validate_base_url = function(base_url) stop("should not be reached"),
    validate_return_type = function(
      return_type,
      allowed_return_types = c("json", "list")
    ) {
      stop("should not be reached")
    },
    construct_request = function(...) stop("should not be reached"),
    perform_request = function(...) stop("should not be reached"),
    handle_failures = function(...) stop("should not be reached"),
    handle_successes = function(...) stop("should not be reached"),
    format_response = function(...) stop("should not be reached"),
    {
      expect_error(dc_post_sparql("SELECT 1 WHERE {}"), "bad key")
    }
  )
})
