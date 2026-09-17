#' Provides a list of all National Park Service Units
#'
#' @inheritParams search_references_by_id
#'
#' @returns a tibble where each row is an NPS unit
#' @export
#'
#' @examples
#' \dontrun{
#' units <- get_all_nps_units()
#' }
get_all_nps_units <- function(dev = FALSE, verbose = FALSE) {
  units_url <- .get_base_units_url(is_dev = dev)
  all_units <- httr2::request(units_url) |>
      httr2::req_headers(Accept = "application/json",
                         `Content-Type` = "application/json") |>
      httr2::req_options(verbose = verbose) |>
      httr2::req_perform()

  all_units <- httr2::resp_body_json(all_units)

  all_units <- suppressWarnings(data.table::rbindlist(all_units,
                                                      use.names = TRUE,
                                                      fill = TRUE))
  all_units <- tibble::as_tibble(all_units)
  return(all_units)
}

#' Get unit geography
#'
#' @param units String, List. One or more valid units (e.g. "ROMO" or c("ROMO", "YElL"))
#' @param detail String. Defaults to "convexHull". Acceptable alternatives are "envelope" or "feature".
#' @param dataformat String. Defaults to "wkt". An acceptable alternative is "glm"
#' @param dev Logical. Defaults to FALSE. Should the dev API be used?
#' @param verbose Logical. Defaults to FALSE. Should lots of information about the API call be printed to the console? Great for debugging.
#'
#' @returns
#' @export
#'
#' @examples
get_unit_geography <- function(units,
                               detail = c("convexHull", "envelope", "feature"),
                               dataformat = c("wkt", "glm"),
                               dev = FALSE,
                               verbose = FALSE) {
  detail <- match.arg(detail)
  dataformat <- match.arg(dataformat)
  units <- toupper(units)

  if (length(units) > 1) {
    units <- curl::curl_escape(paste(units, collapse = "; "))
  }

  unit_geo_url <- .get_base_units_url(is_dev = dev)
  unit_geo <- httr2::request(unit_geo_url) |>
    httr2::req_url_path_append(units, "geography") |>
    httr2::req_url_query(detail = detail, dataformat = dataformat) |>
    httr2::req_headers(Accept = "application/json") |>
    httr2::req_options(verbose = verbose) |>
    httr2::req_perform()

  unit_geo <- httr2::resp_body_json(unit_geo)

  unit_geo <- suppressWarnings(data.table::rbindlist(unit_geo,
                                                     use.names = TRUE,
                                                     fill = TRUE))
  unit_geo <- tibble::as_tibble(unit_geo)
  return(unit_geo)
}


