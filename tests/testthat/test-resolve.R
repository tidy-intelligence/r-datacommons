test_that("dc_get_resolve wires calls and returns formatted result", {
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
        nodes = nodes,
        property = property
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
      expect_equal(return_type, "list")
      "FORMATTED"
    },

    {
      out <- dc_get_resolve(
        nodes = c("Q30", "Q60"),
        expression = "<-wikidataId->dcid",
        api_key = "KEY",
        base_url = "https://example.org/core/api/v2/",
        return_type = "list"
      )
      expect_equal(out, "FORMATTED")

      expect_equal(rec$args$request_type, "get")
      expect_equal(rec$args$base_url, "https://example.org/core/api/v2/")
      expect_equal(rec$args$path, "resolve")
      expect_equal(rec$args$key, "KEY")
      expect_equal(rec$args$nodes, c("Q30", "Q60"))
      expect_equal(rec$args$property, "<-wikidataId->dcid")
    }
  )
})

test_that("dc_get_resolve propagates validation errors", {
  testthat::with_mocked_bindings(
    validate_api_key = function(api_key) cli::cli_abort("missing key"),
    validate_base_url = function(base_url) stop("should not run"),
    validate_return_type = function(
      return_type,
      allowed_return_types = c("json", "list")
    ) {
      stop("should not run")
    },
    construct_request = function(...) stop("should not run"),
    perform_request = function(...) stop("should not run"),
    handle_failures = function(...) stop("should not run"),
    handle_successes = function(...) stop("should not run"),
    format_response = function(...) stop("should not run"),
    {
      expect_error(
        dc_get_resolve(nodes = "x", expression = "<-d->dcid"),
        "missing key"
      )
    }
  )
})

test_that(
  paste(
    "dc_get_dcids_by_wikidata_id forwards to dc_get_resolve",
    "with fixed expression"
  ),
  {
    seen <- new.env(parent = emptyenv())

    testthat::with_mocked_bindings(
      dc_get_resolve = function(
        nodes,
        expression,
        api_key,
        base_url,
        return_type
      ) {
        seen$nodes <- nodes
        seen$expression <- expression
        seen$api_key <- api_key
        seen$base_url <- base_url
        seen$return_type <- return_type
        "OK"
      },
      {
        out <- dc_get_dcids_by_wikidata_id(
          wikidata_ids = c("Q30", "Q60"),
          api_key = "K",
          base_url = "https://example.org/core/api/v2/",
          return_type = "json"
        )
        expect_equal(out, "OK")
        expect_equal(seen$nodes, c("Q30", "Q60"))
        expect_equal(seen$expression, "<-wikidataId->dcid")
        expect_equal(seen$api_key, "K")
        expect_equal(seen$base_url, "https://example.org/core/api/v2/")
        expect_equal(seen$return_type, "json")
      }
    )
  }
)

test_that("dc_get_dcid_by_coordinates builds 'lat#lon' nodes", {
  # Length mismatch -> error
  expect_error(
    dc_get_dcid_by_coordinates(latitude = c(1, 2), longitude = 3),
    "Latitude and longitude vectors must be the same length"
  )

  seen <- new.env(parent = emptyenv())

  testthat::with_mocked_bindings(
    dc_get_resolve = function(
      nodes,
      expression,
      api_key,
      base_url,
      return_type
    ) {
      seen$nodes <- nodes
      seen$expression <- expression
      seen$api_key <- api_key
      seen$base_url <- base_url
      seen$return_type <- return_type
      "COORDS"
    },
    {
      out <- dc_get_dcid_by_coordinates(
        latitude = c(37.42, 34.05),
        longitude = c(-122.08, -118.25),
        api_key = "KEY",
        base_url = "https://example.org/core/api/v2/",
        return_type = "list"
      )
      expect_equal(out, "COORDS")
      expect_equal(seen$nodes, c("37.42#-122.08", "34.05#-118.25"))
      expect_equal(seen$expression, "<-geoCoordinate->dcid")
      expect_equal(seen$api_key, "KEY")
      expect_equal(seen$base_url, "https://example.org/core/api/v2/")
      expect_equal(seen$return_type, "list")
    }
  )
})

test_that("dc_get_dcids_by_name builds expression w/ or w/o entity_type", {
  seen <- list()

  testthat::with_mocked_bindings(
    dc_get_resolve = function(
      nodes,
      expression,
      api_key,
      base_url,
      return_type
    ) {
      seen <<- append(
        seen,
        list(list(
          nodes = nodes,
          expression = expression,
          api_key = api_key,
          base_url = base_url,
          return_type = return_type
        ))
      )
      "NAME"
    },
    {
      # no type filter
      out1 <- dc_get_dcids_by_name(
        names = "Georgia",
        api_key = "K1",
        base_url = "https://example.org/core/api/v2/",
        return_type = "json"
      )
      expect_equal(out1, "NAME")
      expect_equal(seen[[1]]$nodes, "Georgia")
      expect_equal(seen[[1]]$expression, "<-description->dcid")
      expect_equal(seen[[1]]$api_key, "K1")
      expect_equal(seen[[1]]$base_url, "https://example.org/core/api/v2/")
      expect_equal(seen[[1]]$return_type, "json")

      # with type filter
      out2 <- dc_get_dcids_by_name(
        names = c("Mountain View, CA", "New York City"),
        entity_type = "City",
        return_type = "list"
      )
      expect_equal(out2, "NAME")
      expect_equal(seen[[2]]$nodes, c("Mountain View, CA", "New York City"))
      expect_equal(seen[[2]]$expression, "<-description{typeOf:City}->dcid")
      expect_equal(seen[[2]]$return_type, "list")
    }
  )
})

test_that("dc_get_resolve supports return_type = 'json' and 'list'", {
  # Just ensure validate_return_type gets the default allowed set and that
  # format_response receives the chosen return_type.
  seen <- new.env(parent = emptyenv())

  testthat::with_mocked_bindings(
    validate_api_key = function(api_key) NULL,
    validate_base_url = function(base_url) NULL,
    validate_return_type = function(
      return_type,
      allowed_return_types = c("json", "list")
    ) {
      seen$allowed <- allowed_return_types
      NULL
    },
    construct_request = function(...) "REQ",
    perform_request = function(req) "RESPS",
    handle_failures = function(resps) NULL,
    handle_successes = function(resps) "OK",
    format_response = function(data, return_type) {
      seen$return_type <- return_type
      "OUT"
    },
    {
      out <- dc_get_resolve(
        nodes = "x",
        expression = "->name",
        return_type = "json"
      )
      expect_equal(out, "OUT")
      expect_setequal(seen$allowed, c("json", "list"))
      expect_equal(seen$return_type, "json")
    }
  )
})
