# datacommons 0.1.1

* `dc_get_observations(return_type = "data.frame")` again populates `facet_name`. The API no longer returns `importName`, so the facet name is now derived from `provenanceId` when needed.

* `dc_get_observations(return_type = "data.frame")` now returns an empty data frame with a warning when a query matches no observations, instead of failing inside `merge()`.

* `dc_post_sparql()` is deprecated because the public Data Commons API has retired its SPARQL endpoint (HTTP 410). It still works against custom deployments that support SPARQL, but will be removed in a future release.

* Requests no longer send an empty API key. When no key is set, the `key` query parameter and the `X-API-Key` header are left out, so the package works with custom Data Commons deployments that don't require authentication (@novica, #13).

* New vignette `vignette("using-un-data-commons")` shows how to use the package with the UN System Data Commons, a custom deployment that doesn't need an API key (@novica, #13).

# datacommons 0.1.0

* Initial CRAN submission with `dc_get_node()`, `dc_get_property_values()`, `dc_get_property_values()`, `dc_get_classes()`, `dc_get_observations()`, `dc_get_resolve()`, `dc_get_dcids_by_wikidata_id()`, `dc_get_dcid_by_coordinates()`, `dc_get_dcids_by_name()`, `dc_post_sparql()`, `dc_has_api_key()`, `dc_set_api_key()`, `dc_set_base_url()`.
