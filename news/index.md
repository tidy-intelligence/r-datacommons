# Changelog

## datacommons 0.1.1

CRAN release: 2026-09-19

- `dc_get_observations(return_type = "data.frame")` again populates
  `facet_name`. The API no longer returns `importName`, so the facet
  name is now derived from `provenanceId` when needed.

- `dc_get_observations(return_type = "data.frame")` now returns an empty
  data frame with a warning when a query matches no observations,
  instead of failing inside
  [`merge()`](https://rdrr.io/r/base/merge.html).

- [`dc_post_sparql()`](https://tidy-intelligence.github.io/r-datacommons/reference/dc_post_sparql.md)
  is deprecated because the public Data Commons API has retired its
  SPARQL endpoint (HTTP 410). It still works against custom deployments
  that support SPARQL, but will be removed in a future release.

- Requests no longer send an empty API key. When no key is set, the
  `key` query parameter and the `X-API-Key` header are left out, so the
  package works with custom Data Commons deployments that don’t require
  authentication ([@novica](https://github.com/novica),
  [\#13](https://github.com/tidy-intelligence/r-datacommons/issues/13)).

- New vignette
  [`vignette("using-un-data-commons")`](https://tidy-intelligence.github.io/r-datacommons/articles/using-un-data-commons.md)
  shows how to use the package with the UN System Data Commons, a custom
  deployment that doesn’t need an API key
  ([@novica](https://github.com/novica),
  [\#13](https://github.com/tidy-intelligence/r-datacommons/issues/13)).

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
