# Resolve DCIDs from Latitude and Longitude via Data Commons

Resolves geographic coordinates (provided as latitude and longitude) to
Data Commons DCIDs using the geoCoordinate property.

## Usage

``` r
dc_get_dcid_by_coordinates(
  latitude,
  longitude,
  api_key = Sys.getenv("DATACOMMONS_API_KEY"),
  base_url = Sys.getenv("DATACOMMONS_BASE_URL", unset =
    "https://api.datacommons.org/v2/"),
  return_type = "json"
)
```

## Arguments

- latitude:

  A numeric vector of latitude values.

- longitude:

  A numeric vector of longitude values.

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
# Get the DCID for a coordinate
dc_get_dcid_by_coordinates(37.42, -122.08)

# Batch query for multiple coordinates
dc_get_dcid_by_coordinates(c(34.05, 40.71), c(-118.25, -74.01))
}
```
