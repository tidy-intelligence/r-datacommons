# Resolve DCIDs from Place Names via Data Commons

Resolves a node (e.g., a place name) to its Data Commons DCID using the
description property. Optionally filters results by entity type.

## Usage

``` r
dc_get_dcids_by_name(
  names,
  entity_type = NULL,
  api_key = Sys.getenv("DATACOMMONS_API_KEY"),
  base_url = Sys.getenv("DATACOMMONS_BASE_URL", unset =
    "https://api.datacommons.org/v2/"),
  return_type = "json"
)
```

## Arguments

- names:

  A vector of names or descriptions of the entities to look up.

- entity_type:

  Optional string to filter results by `typeOf`, such as `"State"` or
  `"City"`. If `NULL`, no filter is applied.

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
# Get the DCID of "Georgia" (ambiguous without type)
dc_get_dcids_by_name(names = "Georgia")
#> [1] "{\"entities\":[{\"node\":\"Georgia\",\"candidates\":[{\"dcid\":\"geoId/13\"},{\"dcid\":\"country/GEO\"},{\"dcid\":\"geoId/5027700\"}]}]}"

# Get the DCID of "Georgia" as a state
dc_get_dcids_by_name(names = "Georgia", entity_type = "State")
#> [1] "{\"entities\":[{\"node\":\"Georgia\",\"candidates\":[{\"dcid\":\"geoId/13\"}]}]}"

# Get the DCID of "New York City" as a city
dc_get_dcids_by_name(names = "New York City", entity_type = "City")
#> [1] "{\"entities\":[{\"node\":\"New York City\",\"candidates\":[{\"dcid\":\"geoId/3651000\"}]}]}"

# Query multiple cities
dc_get_dcids_by_name(
  names = c("Mountain View, CA", "New York City"),
  entity_type = "City"
)
#> [1] "{\"entities\":[{\"node\":\"Mountain View, CA\",\"candidates\":[{\"dcid\":\"geoId/0649670\"},{\"dcid\":\"geoId/0649651\"}]},{\"node\":\"New York City\",\"candidates\":[{\"dcid\":\"geoId/3651000\"}]}]}"
```
