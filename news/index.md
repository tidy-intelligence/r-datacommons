# Changelog

## datacommons (development version)

- `dc_get_observations(return_type = "data.frame")` again populates
  `facet_name`. The API no longer returns `importName`, so the facet
  name is now derived from `provenanceId` when needed.

- [`dc_post_sparql()`](https://tidy-intelligence.github.io/r-datacommons/reference/dc_post_sparql.md)
  is deprecated because the public Data Commons API has retired its
  SPARQL endpoint (HTTP 410). It still works against custom deployments
  that support SPARQL, but will be removed in a future release.

## datacommons 0.1.0

CRAN release: 2025-08-28

- Initial CRAN submission with
  [`dc_get_node()`](https://tidy-intelligence.github.io/r-datacommons/reference/dc_get_node.md),
  [`dc_get_property_values()`](https://tidy-intelligence.github.io/r-datacommons/reference/dc_get_property_values.md),
  [`dc_get_property_values()`](https://tidy-intelligence.github.io/r-datacommons/reference/dc_get_property_values.md),
  [`dc_get_classes()`](https://tidy-intelligence.github.io/r-datacommons/reference/dc_get_classes.md),
  [`dc_get_observations()`](https://tidy-intelligence.github.io/r-datacommons/reference/dc_get_observations.md),
  [`dc_get_resolve()`](https://tidy-intelligence.github.io/r-datacommons/reference/dc_get_resolve.md),
  [`dc_get_dcids_by_wikidata_id()`](https://tidy-intelligence.github.io/r-datacommons/reference/dc_get_dcids_by_wikidata_id.md),
  [`dc_get_dcid_by_coordinates()`](https://tidy-intelligence.github.io/r-datacommons/reference/dc_get_dcid_by_coordinates.md),
  [`dc_get_dcids_by_name()`](https://tidy-intelligence.github.io/r-datacommons/reference/dc_get_dcids_by_name.md),
  [`dc_post_sparql()`](https://tidy-intelligence.github.io/r-datacommons/reference/dc_post_sparql.md),
  [`dc_has_api_key()`](https://tidy-intelligence.github.io/r-datacommons/reference/dc_has_api_key.md),
  [`dc_set_api_key()`](https://tidy-intelligence.github.io/r-datacommons/reference/dc_set_api_key.md),
  [`dc_set_base_url()`](https://tidy-intelligence.github.io/r-datacommons/reference/dc_set_base_url.md).
