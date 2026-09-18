# Retrieve Node Properties from Data Commons

Queries the Data Commons API for specified property relationships of
given nodes.

## Usage

``` r
dc_get_node(
  nodes,
  expression,
  api_key = Sys.getenv("DATACOMMONS_API_KEY"),
  base_url = Sys.getenv("DATACOMMONS_BASE_URL", unset =
    "https://api.datacommons.org/v2/"),
  return_type = "json"
)
```

## Arguments

- nodes:

  A character vector of terms to resolve.

- expression:

  A relation expression string (e.g., `<-*`, `->name`, or
  `->[name, latitude]`).

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

A list or JSON string, depending on `return_type`.

## Examples

``` r
if (FALSE) { # dc_has_api_key()
# Get all property labels for a given node
dc_get_node(nodes = "country/USA", expression = "<-")

# Get one property value for a given node
dc_get_node(nodes = "dc/03lw9rhpendw5", expression = "->name")

# Get multiple property values for multiple nodes
dc_get_node(
  nodes = c("geoId/06085", "geoId/06087"),
  expression = "->[name, latitude, longitude]"
)

# Get all property values for a node
dc_get_node(nodes = "PowerPlant", expression = "<-*")

# Get a list of all existing statistical variables
dc_get_node(nodes = "StatisticalVariable", expression = "<-typeOf")

# Get a list of all existing entity types
dc_get_node(nodes = "Class", expression = "<-typeOf")
}
```
