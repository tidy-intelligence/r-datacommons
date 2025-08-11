test_that("dc_get_node wires calls and returns formatted result", {
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
      out <- dc_get_node(
        nodes = c("geoId/06085", "geoId/06087"),
        expression = "->[name, latitude, longitude]",
        api_key = "KEY",
        base_url = "https://example.org/core/api/v2/",
        return_type = "list"
      )
      expect_equal(out, "FORMATTED")

      # Request details
      expect_equal(rec$args$request_type, "get")
      expect_equal(rec$args$base_url, "https://example.org/core/api/v2/")
      expect_equal(rec$args$path, "node")
      expect_equal(rec$args$key, "KEY")
      expect_equal(rec$args$nodes, c("geoId/06085", "geoId/06087"))
      expect_equal(rec$args$property, "->[name, latitude, longitude]")
    }
  )
})

test_that("dc_get_node propagates validation errors", {
  testthat::with_mocked_bindings(
    validate_api_key = function(api_key) cli::cli_abort("no key"),
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
        dc_get_node(nodes = "x", expression = "->name"),
        "no key"
      )
    }
  )
})

test_that("dc_get_property_values builds correct expressions & forwards args", {
  seen <- list()

  testthat::with_mocked_bindings(
    dc_get_node = function(nodes, expression, api_key, base_url, return_type) {
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
      "OK"
    },
    {
      # All "<-*"
      out1 <- dc_get_property_values(
        nodes = "A",
        properties = "all",
        api_key = "K1",
        base_url = "https://example.org/core/api/v2/",
        return_type = "json"
      )
      expect_equal(out1, "OK")
      expect_equal(seen[[1]]$expression, "<-*")
      expect_equal(seen[[1]]$nodes, "A")

      # Single "->name"
      out2 <- dc_get_property_values(
        nodes = c("B", "C"),
        properties = "name",
        api_key = "K2",
        base_url = "https://example.org/core/api/v2/",
        return_type = "list"
      )
      expect_equal(out2, "OK")
      expect_equal(seen[[2]]$expression, "->name")
      expect_equal(seen[[2]]$nodes, c("B", "C"))
      expect_equal(seen[[2]]$return_type, "list")

      # Multiple "->[p, q, r]"
      out3 <- dc_get_property_values(
        nodes = "D",
        properties = c("name", "latitude", "longitude")
      )
      expect_equal(out3, "OK")
      expect_equal(seen[[3]]$expression, "->[name, latitude, longitude]")
      expect_equal(seen[[3]]$nodes, "D")
    }
  )
})

test_that("dc_get_statistical_variables calls dc_get_node with fixed args", {
  called <- new.env(parent = emptyenv())

  testthat::with_mocked_bindings(
    dc_get_node = function(nodes, expression, api_key, base_url, return_type) {
      called$nodes <- nodes
      called$expression <- expression
      called$api_key <- api_key
      called$base_url <- base_url
      called$return_type <- return_type
      "SV"
    },
    {
      withr::local_envvar(
        DATACOMMONS_API_KEY = "ENVKEY",
        DATACOMMONS_BASE_URL = "https://api.datacommons.org/v2/"
      )
      out <- dc_get_statistical_variables(return_type = "json")
      expect_equal(out, "SV")
      expect_equal(called$nodes, "StatisticalVariable")
      expect_equal(called$expression, "<-typeOf")
      expect_equal(called$api_key, "ENVKEY")
      expect_equal(called$base_url, "https://api.datacommons.org/v2/")
      expect_equal(called$return_type, "json")
    }
  )
})

test_that("dc_get_classes calls dc_get_node with fixed args", {
  called <- new.env(parent = emptyenv())

  testthat::with_mocked_bindings(
    dc_get_node = function(nodes, expression, api_key, base_url, return_type) {
      called$nodes <- nodes
      called$expression <- expression
      called$api_key <- api_key
      called$base_url <- base_url
      called$return_type <- return_type
      "CLS"
    },
    {
      out <- dc_get_classes(
        api_key = "KEY",
        base_url = "https://example.org/core/api/v2/",
        return_type = "list"
      )
      expect_equal(out, "CLS")
      expect_equal(called$nodes, "Class")
      expect_equal(called$expression, "<-typeOf")
      expect_equal(called$api_key, "KEY")
      expect_equal(called$base_url, "https://example.org/core/api/v2/")
      expect_equal(called$return_type, "list")
    }
  )
})
