# NPSdatastore (development version)
## 2026-09-17
  * add two new functions, `get_unit_geography` and `get_all_nps_units` that hit the Units API via a new helper function `.get_base_units_url`

## 2026-09-03
  * move all function for lookup lists to a separate lookup_lists.R file
  * add function `get_legal_authority` for retrieving a list of authorities to use when restricting file downloads on DataStore

## 2026-08-26
  * Add file lifecycle.R
  * Add function `delete_inactive_ref`
  
## 2026-08-07
  * Add function `add_producing_units`

* `.datastore_request()` now includes a `verbose` option that prints the API request info to the console, and this can be enabled for any function in the package. It is, in fact, verbose, so don't use this option unless you are debugging and truly need diagnostic info regarding the API request.
* `.datastore_request()` now adds a user-agent string identifying this package
* add news.md
