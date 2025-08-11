test_that("dc_get_observations wires calls and maps special dates", {
  rec <- new.env(parent = emptyenv())

  # Use explicit api_key/base_url and the non-default select/filters.
  testthat::with_mocked_bindings(
    validate_api_key = function(api_key) NULL,
    validate_base_url = function(base_url) NULL,
    validate_return_type = function(
      return_type,
      allowed_return_types = c("json", "list", "data.frame")
    ) {
      NULL
    },
    validate_date = function(date) NULL,
    validate_select = function(select) NULL,
    validate_entity = function(
      entity_dcids,
      entity_expression,
      parent_entity,
      entity_type
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
        date = date,
        select = select,
        variable_dcids = variable_dcids,
        entity_dcids = entity_dcids,
        entity_expression = entity_expression,
        filter_domains = filter_domains,
        filter_facet_ids = filter_facet_ids
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
      out <- dc_get_observations(
        date = "latest",
        variable_dcids = c("Count_Person"),
        entity_dcids = c("country/USA", "country/CAN"),
        select = c("entity", "variable"),
        filter_domains = "www.census.gov",
        filter_facet_ids = c("123", "456"),
        api_key = "AK",
        base_url = "https://example.org/core/api/v2/",
        return_type = "json"
      )
      expect_equal(out, "FORMATTED")

      # Request details
      expect_equal(rec$args$request_type, "get")
      expect_equal(rec$args$base_url, "https://example.org/core/api/v2/")
      expect_equal(rec$args$path, "observation")
      expect_equal(rec$args$key, "AK")
      expect_equal(rec$args$date, "LATEST") # 'latest' mapped to 'LATEST'
      expect_equal(rec$args$variable_dcids, "Count_Person")
      expect_equal(rec$args$entity_dcids, c("country/USA", "country/CAN"))
      expect_null(rec$args$entity_expression) # untouched when dcids provided
      expect_equal(rec$args$select, c("entity", "variable"))
      expect_equal(rec$args$filter_domains, "www.census.gov")
      expect_equal(rec$args$filter_facet_ids, c("123", "456"))
    }
  )
})

test_that(
  paste(
    "dc_get_observations constructs entity_expression from ",
    "parent_entity/entity_type and maps 'all' date"
  ),
  {
    rec <- new.env(parent = emptyenv())
    withr::local_envvar(
      DATACOMMONS_API_KEY = "ENVKEY",
      DATACOMMONS_BASE_URL = "https://api.datacommons.org/v2/"
    )

    testthat::with_mocked_bindings(
      validate_api_key = function(api_key) {
        expect_equal(api_key, "ENVKEY")
        NULL
      },
      validate_base_url = function(base_url) {
        expect_equal(base_url, "https://api.datacommons.org/v2/")
        NULL
      },
      validate_return_type = function(
        return_type,
        allowed_return_types = c("json", "list", "data.frame")
      ) {
        NULL
      },
      validate_date = function(date) NULL,
      validate_select = function(select) NULL,
      validate_entity = function(
        entity_dcids,
        entity_expression,
        parent_entity,
        entity_type
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
          date = date,
          select = select,
          variable_dcids = variable_dcids,
          entity_dcids = entity_dcids,
          entity_expression = entity_expression
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
        out <- dc_get_observations(
          date = "all", # becomes empty string
          variable_dcids = "Count_Person",
          parent_entity = "country/USA",
          entity_type = "State",
          # omit select to use the default
          return_type = "list"
        )
        expect_true(out$ok)

        expect_equal(rec$args$request_type, "get")
        expect_equal(rec$args$path, "observation")
        expect_equal(rec$args$date, "") # 'all' mapped to empty string
        expect_equal(rec$args$variable_dcids, "Count_Person")
        expect_null(rec$args$entity_dcids)
        expect_equal(
          rec$args$entity_expression,
          "country/USA<-containedInPlace+{typeOf:State}"
        )
        # default select from the function signature
        expect_equal(rec$args$select, c("date", "entity", "value", "variable"))
      }
    )
  }
)

test_that("dc_get_observations propagates validation errors", {
  testthat::with_mocked_bindings(
    validate_api_key = function(api_key) NULL,
    validate_base_url = function(base_url) NULL,
    validate_return_type = function(
      return_type,
      allowed_return_types = c("json", "list", "data.frame")
    ) {
      NULL
    },
    validate_date = function(date) NULL,
    validate_select = function(select) cli::cli_abort("bad select"),
    validate_entity = function(
      entity_dcids,
      entity_expression,
      parent_entity,
      entity_type
    ) {
      NULL
    },
    construct_request = function(...) stop("should not be reached"),
    perform_request = function(...) stop("should not be reached"),
    handle_failures = function(...) stop("should not be reached"),
    handle_successes = function(...) stop("should not be reached"),
    format_response = function(...) stop("should not be reached"),
    {
      expect_error(
        dc_get_observations(
          date = "latest",
          variable_dcids = "x",
          entity_dcids = "y",
          select = "entity"
        ),
        "bad select"
      )
    }
  )
})

test_that("dc_get_observations supports return_type = 'data.frame'", {
  rec <- new.env(parent = emptyenv())

  testthat::with_mocked_bindings(
    validate_api_key = function(api_key) NULL,
    validate_base_url = function(base_url) NULL,
    validate_return_type = function(
      return_type,
      allowed_return_types = c("json", "list", "data.frame")
    ) {
      expect_true("data.frame" %in% allowed_return_types)
      NULL
    },
    validate_date = function(date) NULL,
    validate_select = function(select) NULL,
    validate_entity = function(
      entity_dcids,
      entity_expression,
      parent_entity,
      entity_type
    ) {
      NULL
    },

    construct_request = function(
      request_type = "get",
      base_url,
      path,
      key,
      ...,
      select = NULL
    ) {
      rec$args <<- list(
        request_type = request_type,
        path = path,
        select = select
      )
      "REQ"
    },
    perform_request = function(req) "RESPS",
    handle_failures = function(resps) NULL,
    handle_successes = function(resps) "SUCCESSES",

    format_response = function(data, return_type) {
      expect_equal(return_type, "data.frame")
      data.frame(ok = TRUE)
    },

    {
      df <- dc_get_observations(
        date = 2021,
        variable_dcids = "Count_Person",
        entity_dcids = "country/USA",
        return_type = "data.frame"
      )
      expect_s3_class(df, "data.frame")
      expect_true(df$ok[1])
      expect_equal(rec$args$request_type, "get")
      expect_equal(rec$args$path, "observation")
    }
  )
})
