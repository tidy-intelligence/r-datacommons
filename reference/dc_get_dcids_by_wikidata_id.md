# Resolve DCIDs from Wikidata IDs via Data Commons

Resolves Wikidata identifiers (e.g., `"Q30"` for the United States) to
Data Commons DCIDs using the wikidataId property.

## Usage

``` r
dc_get_dcids_by_wikidata_id(
  wikidata_ids,
  api_key = Sys.getenv("DATACOMMONS_API_KEY"),
  base_url = Sys.getenv("DATACOMMONS_BASE_URL", unset =
    "https://api.datacommons.org/v2/"),
  return_type = "json"
)
```

## Arguments

- wikidata_ids:

  The Wikidata IDs of the entities to look up.

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
# Get the DCID for the United States (Wikidata ID "Q30")
dc_get_dcids_by_wikidata_id("Q30")
#> [1] "{\"entities\":[{\"node\":\"Q30\",\"candidates\":[{\"dcid\":\"country/USA\"}]}]}"

# Batch query for multiple Wikidata IDs
dc_get_dcids_by_wikidata_id(c("Q30", "Q60"))
#> [1] "{\"entities\":[{\"node\":\"Q60\",\"candidates\":[{\"dcid\":\"geoId/3651000\"}]},{\"node\":\"Q30\",\"candidates\":[{\"dcid\":\"country/USA\"}]}]}"
```
