# Check if a Data Commons API key is available

Checks whether the `DATACOMMONS_API_KEY` environment variable has been
set. Useful for examples, tests, or conditional execution of functions
requiring authentication.

## Usage

``` r
dc_has_api_key()
```

## Value

A logical value: `TRUE` if an API key is set, `FALSE` otherwise.
