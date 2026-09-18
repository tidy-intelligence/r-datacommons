# Get Property Values for Data Commons Nodes

A convenience wrapper around
[`dc_get_node()`](https://tidy-intelligence.github.io/r-datacommons/reference/dc_get_node.md)
to retrieve all property values for the specified nodes. This is
equivalent to calling
[`dc_get_node()`](https://tidy-intelligence.github.io/r-datacommons/reference/dc_get_node.md)
with `expression = "<-"`.

## Usage

``` r
dc_get_property_values(
  nodes,
  properties = "name",
  api_key = Sys.getenv("DATACOMMONS_API_KEY"),
  base_url = Sys.getenv("DATACOMMONS_BASE_URL", unset =
    "https://api.datacommons.org/v2/"),
  return_type = "json"
)
```

## Arguments

- nodes:

  A character vector of terms to resolve.

- properties:

  A character vector of properties (e.g. "name", "latitude", "all")

- api_key:

  Your Data Commons API key. If not provided, uses the environment
  variable `DATACOMMONS_API_KEY`.

- base_url:

  The base URL of the Data Commons API. Defaults to the public endpoint.
  For custom deployments, must end with `/core/api/v2/`.

- return_type:

  Return format: either `"list"` (parsed R object) or `"json"` (JSON
  string).

## Value

A list containing the requested property values for each node. The
structure depends on the properties requested and follows the same
format as
[`dc_get_node()`](https://tidy-intelligence.github.io/r-datacommons/reference/dc_get_node.md).

## Examples

``` r
if (FALSE) { # dc_has_api_key()
# Get the name property (default)
dc_get_property_values(nodes = "country/USA")

# Get a specific property
dc_get_property_values(nodes = "country/USA", properties = "latitude")

# Get multiple specific properties
dc_get_property_values(
  nodes = c("geoId/06085", "geoId/06087"),
  properties = c("name", "latitude", "longitude")
)

# Get all properties
dc_get_property_values(nodes = "PowerPlant", properties = "all")
}
```
