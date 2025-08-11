test_that("dc_has_api_key reflects env var", {
  withr::local_envvar(DATACOMMONS_API_KEY = "")
  expect_false(dc_has_api_key())

  withr::local_envvar(DATACOMMONS_API_KEY = "abc")
  expect_true(dc_has_api_key())
})

test_that("dc_set_api_key and dc_set_base_url set env vars", {
  withr::local_envvar(DATACOMMONS_API_KEY = "", DATACOMMONS_BASE_URL = "")
  dc_set_api_key("k123")
  dc_set_base_url("https://example.org/core/api/v2/")
  expect_equal(Sys.getenv("DATACOMMONS_API_KEY"), "k123")
  expect_equal(
    Sys.getenv("DATACOMMONS_BASE_URL"),
    "https://example.org/core/api/v2/"
  )
})

test_that("next_req returns NULL when no nextToken", {
  # mock resp_body_json to return no token
  testthat::with_mocked_bindings(
    resp_body_json = function(resp) list(),
    {
      req <- httr2::request("https://example.org")
      expect_null(next_req(resp = NULL, req = req))
    }
  )
})

test_that("next_req appends nextToken when present", {
  testthat::with_mocked_bindings(
    resp_body_json = function(resp) list(nextToken = "tok123"),
    {
      req <- httr2::request("https://example.org") |>
        httr2::req_url_path_append("v2/things")

      out <- next_req(resp = NULL, req = req)
      expect_s3_class(out, "httr2_request")

      # Build a URL string regardless of httr2 version/structure
      built <- if (is.character(out$url)) {
        out$url
      } else {
        httr2::url_build(out$url)
      }

      expect_match(built, "/v2/things")
      expect_true(grepl("(\\?|&)nextToken=tok123(&|$)", built))
    }
  )
})

test_that("format_response('json') returns raw strings from responses", {
  testthat::with_mocked_bindings(
    resps_data = function(data, f) f(structure(list(), class = "resp")),
    resp_body_string = function(resp) "RAW_JSON",
    {
      expect_equal(
        format_response(data = "ignored", return_type = "json"),
        "RAW_JSON"
      )
    }
  )
})

test_that("format_response('list') returns parsed lists from responses", {
  testthat::with_mocked_bindings(
    resps_data = function(data, f) f(structure(list(), class = "resp")),
    resp_body_json = function(resp) list(ok = TRUE, n = 1),
    {
      out <- format_response(data = "ignored", return_type = "list")
      expect_type(out, "list")
      expect_true(out$ok)
      expect_equal(out$n, 1)
    }
  )
})

test_that("format_response() builds a tidy table and enriches names", {
  # Craft a minimal raw structure that the formatter expects
  raw <- list(
    byVariable = list(
      "Count_Person" = list(
        byEntity = list(
          "geoId/06" = list(
            orderedFacets = list(
              list(
                facetId = "f1",
                observations = list(
                  list(date = "2020", value = 1),
                  list(date = "2021", value = 2)
                )
              )
            )
          )
        )
      )
    ),
    facets = list(
      f1 = list(importName = list("ACS 1-year"))
    )
  )

  # JSON payloads for dc_get_property_values lookups
  ent_json <- jsonlite::toJSON(
    list(
      data = list(
        "geoId/06" = list(
          arcs = list(name = list(nodes = list(list(value = "California"))))
        )
      )
    ),
    auto_unbox = TRUE
  )

  var_json <- jsonlite::toJSON(
    list(
      data = list(
        "Count_Person" = list(
          arcs = list(name = list(nodes = list(list(value = "Population"))))
        )
      )
    ),
    auto_unbox = TRUE
  )

  testthat::with_mocked_bindings(
    # Return the prebuilt "raw" list instead of touching real responses
    resps_data = function(data, f) raw,
    # Let fromJSON be the real one (we hand it valid JSON)
    dc_get_property_values = function(ids, properties, return_type) {
      if (identical(properties, "name") && any(grepl("^geoId/", ids))) {
        return(ent_json)
      }
      if (identical(properties, "name")) {
        return(var_json)
      }
      stop("unexpected call")
    },
    {
      df <- format_response(data = "ignored", return_type = "data.frame")
      expect_s3_class(df, "data.frame")
      expect_setequal(
        names(df),
        c(
          "entity_dcid",
          "entity_name",
          "variable_dcid",
          "variable_name",
          "date",
          "value",
          "facet_id",
          "facet_name"
        )
      )
      expect_equal(nrow(df), 2)
      # Row contents
      expect_true(all(df$entity_dcid == "geoId/06"))
      expect_true(all(df$variable_dcid == "Count_Person"))
      expect_true(all(df$facet_id == "f1"))
      expect_true(all(df$facet_name == "ACS 1-year"))
      expect_true(all(df$entity_name == "California"))
      expect_true(all(df$variable_name == "Population"))
      expect_setequal(df$date, c("2020", "2021"))
      expect_setequal(df$value, c(1, 2))
    }
  )
})

test_that("format_response() sets facet_name = NA when importName is NULL", {
  raw <- list(
    byVariable = list(
      "Count_Person" = list(
        byEntity = list(
          "geoId/06" = list(
            orderedFacets = list(
              list(
                facetId = "f_no_name",
                observations = list(
                  list(date = "2022", value = 10)
                )
              )
            )
          )
        )
      )
    ),
    facets = list(
      f_no_name = list(importName = NULL) # <- the case we want to hit
    )
  )

  ent_json <- jsonlite::toJSON(
    list(
      data = list(
        "geoId/06" = list(
          arcs = list(name = list(nodes = list(list(value = "California"))))
        )
      )
    ),
    auto_unbox = TRUE
  )

  var_json <- jsonlite::toJSON(
    list(
      data = list(
        "Count_Person" = list(
          arcs = list(name = list(nodes = list(list(value = "Population"))))
        )
      )
    ),
    auto_unbox = TRUE
  )

  testthat::with_mocked_bindings(
    resps_data = function(data, f) raw,
    dc_get_property_values = function(ids, properties, return_type) {
      if (identical(properties, "name") && any(grepl("^geoId/", ids))) {
        return(ent_json)
      }
      if (identical(properties, "name")) {
        return(var_json)
      }
      stop("unexpected call")
    },
    {
      df <- format_response(data = "ignored", return_type = "data.frame")
      expect_s3_class(df, "data.frame")
      expect_equal(nrow(df), 1)
      expect_true(is.na(df$facet_name))
      expect_equal(df$facet_id, "f_no_name")
      expect_equal(df$entity_name, "California")
      expect_equal(df$variable_name, "Population")
      expect_equal(df$date, "2022")
      expect_equal(df$value, 10)
    }
  )
})

test_that("construct_request builds GET requests", {
  req <- construct_request(
    request_type = "get",
    base_url = "https://example.org/core/api/v2/",
    path = "node/property-values",
    key = "K",
    nodes = c("a", "b"),
    property = "name",
    variable_dcids = "x"
  )
  expect_s3_class(req, "httr2_request")

  out <- paste(capture.output(req), collapse = "\n")
  expect_match(out, "GET")
  expect_match(out, "node/property-values")
  expect_match(out, "key=K")
  expect_match(out, "nodes=a")
  expect_match(out, "nodes=b")
  expect_match(out, "property=name")
  expect_match(out, "variable.dcids=x")
  expect_match(out, "datacommons R package")
})

test_that("construct_request builds POST requests", {
  req <- construct_request(
    request_type = "post",
    base_url = "https://example.org/core/api/v2/",
    path = "search",
    key = "K",
    query = "hello world"
  )
  expect_s3_class(req, "httr2_request")

  out <- paste(capture.output(httr2::req_dry_run(req)), collapse = "\n")

  # Method and path
  expect_match(out, "^POST\\b")
  expect_match(out, "/core/api/v2/search")

  # API key header present (case-insensitive header names across versions)
  expect_match(out, "(?i)x-api-key:.*K", perl = TRUE)

  # Body contains the query JSON
  expect_match(out, '"query"\\s*:\\s*"hello world"')

  # UA string regardless of how it's printed
  expect_match(
    out,
    "datacommons R package",
    perl = TRUE
  )
})

test_that("construct_request errors on invalid request_type", {
  expect_error(
    construct_request(
      request_type = "patch",
      base_url = "https://example.org/core/api/v2/",
      path = "x",
      key = "k"
    ),
    "must be 'get' or 'post'"
  )
})

test_that("perform_request delegates to req_perform_iterative", {
  testthat::with_mocked_bindings(
    req_perform_iterative = function(req, next_req) "SENTINEL",
    {
      req <- httr2::request("https://example.org")
      expect_equal(perform_request(req), "SENTINEL")
    }
  )
})

test_that("handle_failures warns once per failed response", {
  fake_resp <- list(
    request = list(url = "https://example.org/core/api/v2/x"),
    status_code = 403
  )
  class(fake_resp) <- "httr2_response"

  testthat::with_mocked_bindings(
    resps_failures = function(resps) list(fake_resp),
    resp_body_string = function(resp) '{"message":"forbidden"}',
    {
      expect_warning(handle_failures("ignored"))
    }
  )
})

test_that("handle_successes returns only successful responses", {
  testthat::with_mocked_bindings(
    resps_successes = function(resps) "ONLY_OK",
    {
      expect_equal(handle_successes("ignored"), "ONLY_OK")
    }
  )
})

test_that("%||% returns lhs when not NULL, else rhs", {
  expect_equal(`%||%`(1, 2), 1)
  expect_equal(`%||%`(NULL, 2), 2)
})
