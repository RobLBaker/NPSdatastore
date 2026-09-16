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

get_unit_geography <- function(units, detail, dataformat, verbose = FALSE)
{}

