test_that("validate_api_key errors when neither arg nor env var provided", {
  withr::local_envvar(DATACOMMONS_API_KEY = "")
  expect_error(validate_api_key(NULL), "API key not provided")
})

test_that("validate_api_key succeeds when env var is set", {
  withr::local_envvar(DATACOMMONS_API_KEY = "abc123")
  expect_invisible(validate_api_key(NULL))
  expect_error(validate_api_key(NULL), NA)
})

test_that("validate_api_key succeeds when api_key is provided directly", {
  withr::local_envvar(DATACOMMONS_API_KEY = "")
  expect_invisible(validate_api_key("explicit-key"))
  expect_error(validate_api_key("explicit-key"), NA)
})

test_that("validate_base_url accepts default and valid custom URLs", {
  expect_invisible(validate_base_url("https://api.datacommons.org/v2/"))
  expect_invisible(validate_base_url("https://example.org/core/api/v2/"))
  expect_invisible(validate_base_url("http://host.local/core/api/v2"))
  expect_error(validate_base_url("https://example.org/v2/"), "Invalid base_url")
  expect_error(
    validate_base_url("https://example.org/core/api/v1/"),
    "Invalid base_url"
  )
  expect_error(validate_base_url("not-a-url"), "Invalid base_url")
})

test_that("validate_return_type enforces allowed set", {
  expect_invisible(validate_return_type("json"))
  expect_invisible(validate_return_type("list"))
  expect_error(validate_return_type("xml"), "Invalid return_type")

  # Custom allow-list should be respected
  expect_invisible(validate_return_type("csv", allowed_return_types = "csv"))
})

test_that("validate_date requires the `date` argument", {
  expect_error(validate_date(), "Parameter `date` is required")
  expect_error(validate_date(Sys.Date()), NA) # supplying any value is OK
})

test_that("validate_select requires both 'entity' and 'variable'", {
  expect_error(
    validate_select(),
    "`select` must include both 'entity' and 'variable'"
  )
  expect_error(
    validate_select("entity"),
    "`select` must include both 'entity' and 'variable'"
  )
  expect_invisible(validate_select(c("entity", "variable")))
  expect_invisible(validate_select(c("variable", "entity", "extra")))
})

test_that("validate_entity requires at least one valid specification", {
  # All missing → error
  expect_error(
    validate_entity(NULL, NULL, NULL, NULL)
  )

  # Only one of parent_entity/entity_type missing → error
  expect_error(
    validate_entity(NULL, NULL, parent_entity = "geoId/06", entity_type = NULL),
    "You must provide either"
  )
  expect_error(
    validate_entity(NULL, NULL, parent_entity = NULL, entity_type = "County"),
    "You must provide either"
  )

  # Any valid way to specify entities → OK
  expect_error(
    validate_entity(entity_dcids = c("geoId/06"), NULL, NULL, NULL),
    NA
  )
  expect_error(
    validate_entity(NULL, entity_expression = 'dcids("geoId/06")', NULL, NULL),
    NA
  )
  expect_error(
    validate_entity(
      NULL,
      NULL,
      parent_entity = "geoId/06",
      entity_type = "County"
    ),
    NA
  )
})
