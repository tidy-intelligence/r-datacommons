# Get Available Statistical Variables from Data Commons

A convenience wrapper around
[`dc_get_node()`](https://tidy-intelligence.github.io/r-datacommons/reference/dc_get_node.md)
to retrieve all available statistical variables in Data Commons. This is
equivalent to calling
[`dc_get_node()`](https://tidy-intelligence.github.io/r-datacommons/reference/dc_get_node.md)
with `nodes = "StatisticalVariable"` and `expression = "<-typeOf"`.

## Usage

``` r
dc_get_statistical_variables(
  api_key = Sys.getenv("DATACOMMONS_API_KEY"),
  base_url = Sys.getenv("DATACOMMONS_BASE_URL", unset =
    "https://api.datacommons.org/v2/"),
  return_type = "json"
)
```

## Arguments

- api_key:

  Your Data Commons API key. If not provided, will use the environment
  variable `DATACOMMONS_API_KEY`.

- base_url:

  The base URL of the Data Commons API. Defaults to the public endpoint.
  For custom deployments, it must end with "/core/api/v2/".

- return_type:

  Return format: either `"list"` (parsed R object) or `"json"` (JSON
  string).

## Value

A list (if `return_type = "list"`) or JSON string (if
`return_type = "json"`) containing all available statistical variables.

## Examples

``` r
if (FALSE) { # dc_has_api_key()
# Get all statistical variables
statistical_vars <- dc_get_statistical_variables()
}
```
