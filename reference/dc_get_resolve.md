# Resolve Nodes from Data Commons

Resolve Nodes from Data Commons

## Usage

``` r
dc_get_resolve(
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

  A string defining the property expression (e.g.,
  "\<-description-\>dcid").

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
# Find the DCID of a place by another known ID
dc_get_resolve(
  nodes = "Q30",
  expression = "<-wikidataId->dcid"
)

# Find the DCID of a place by coordinates
dc_get_resolve(
  nodes = "37.42#-122.08",
  expression = "<-geoCoordinate->dcid"
)

# Find the DCID of a place by name
dc_get_resolve(
  nodes = "Georgia",
  expression = "<-description->dcid"
)

# Find the DCID of a place by name, with a type filter
dc_get_resolve(
  nodes = "Georgia",
  expression = "<-description{typeOf:State}->dcid"
)

# Find the DCID of multiple places by name, with a type filter
dc_get_resolve(
  nodes = "Mountain View, CA", "New York City",
  expression = "<-description{typeOf:City}->dcid"
)
}
```
