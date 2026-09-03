#' Get a list of valid reference types
#'
#' @inheritParams search_references_by_id
#'
#' @returns A tibble with columns for reference code, label, description, and group code
#' @export
#'
#' @examples
#' \dontrun{
#' valid_ref_types <- get_reference_types()
#' }
#'
get_reference_types <- function(dev = FALSE, verbose = FALSE) {
  # Get the full list of reference types
  ref_types <- .datastore_request(is_secure = FALSE, is_dev = dev, verbose = verbose) |>
    httr2::req_url_path_append("FixedList/ReferenceTypes") |>
    httr2::req_perform()

  .validate_resp(ref_types)

  ref_types <- httr2::resp_body_json(ref_types)

  ref_types <- dplyr::bind_rows(ref_types) |>
    dplyr::rename(code = key)

  ref_types$ref_group_code <- NA

  # Get reference type groupings
  ref_groups <- .datastore_request(is_secure = FALSE, is_dev = dev, verbose = verbose) |>
    httr2::req_url_path_append("FixedList/ReferenceTypeGroups") |>
    httr2::req_perform()

  .validate_resp(ref_groups)

  ref_groups <- httr2::resp_body_json(ref_groups)

  lapply(ref_groups, function(group) {
    group_code <- group$key
    group_ref_types <- stringr::str_split(group$description, ", ")
    group_ref_types <- group_ref_types[[1]]

    ref_types[ref_types$code %in% group_ref_types, "ref_group_code"] <<- group_code
  })

  ref_types <- dplyr::arrange(ref_types, ref_group_code)

  return(ref_types)
}

#' Get a list of valid contact types
#'
#' @inheritParams search_references_by_id
#' @param reference_type Optional. A valid reference type, as found in the `code` column returned by `get_reference_types()`. If omitted, will return contact types for every reference type.
#'
#' @returns A tibble with columns for reference code, key, label, and description
#' @export
#'
#' @examples
#' \dontrun{
#' valid_contact_types <- get_contact_types()
#' }
#'
get_contact_types <- function(reference_type, dev = FALSE, verbose = FALSE) {

  # Get the full list of reference types
  ref_types <- get_reference_types(dev = dev)$code
  ref_types <- ref_types[ref_types != "Movie/Video"]  # Movie/Video ref type breaks the API call because of the slash; filter it out for now until DataStore team fixes the bug

  # Validate input
  if (!missing(reference_type)) {
    match.arg(reference_type, ref_types)
  } else {
    reference_type <- ref_types
  }

  contact_types <- lapply(reference_type, function(ref_code) {
    contact_req <- .datastore_request(is_secure = FALSE, is_dev = dev, verbose = verbose) |>
      httr2::req_url_path_append("FixedList", ref_code, "Contacts") |>
      httr2::req_perform()

    .validate_resp(contact_req,
                   nice_msg_400 = glue::glue("Could not retrieve contact types for {ref_code}. Check that it is a valid reference code."),
                   details = "message")

    contacts <- httr2::resp_body_json(contact_req) |>
      dplyr::bind_rows() |>
      dplyr::mutate(reference_code = ref_code) |>
      dplyr::relocate(reference_code)

    return(contacts)
  })

  contact_types <- dplyr::bind_rows(contact_types) |>
    dplyr::arrange(reference_code, key)

  return(contact_types)
}

#' Get a list of valid values for date precision
#'
#' @inheritParams search_references_by_id
#'
#' @returns A tibble with columns for date precision code and label
#' @export
#'
#' @examples
#' \dontrun{
#' valid_precisions <- get_date_precision()
#' }
#'
get_date_precision <- function(dev = FALSE, verbose = FALSE) {
  # Get the full list of date precision keywords
  precisions <- .datastore_request(is_secure = FALSE,
                                   is_dev = dev,
                                   verbose = verbose) |>
    httr2::req_url_path_append("FixedList/DatePrecisions") |>
    httr2::req_perform()

  .validate_resp(precisions)

  precisions <- httr2::resp_body_json(precisions)

  precisions <- dplyr::bind_rows(precisions) |>
    dplyr::rename(code = key)

  return(precisions)
}

#' Get a list of legal authorities for restricting DataStore reference files
#'
#' The function `get_legal_authority` returns a tibble of the current acceptable legal authorities for restricting files attached to references on DataStore.
#'
#' @inheritParams search_references_by_id
#'
#' @returns A tibble where each row has a separate legal authority for restricting file downloads on DataStore.
#' @export
#'
#' @examples
#'  \dontrun{
#' authorities <- get_legal_authority()
#' }
get_legal_authority <- function(dev = FALSE, verbose = FALSE) {

  authority <- .datastore_request(is_secure= FALSE,
                                  is_dev = dev,
                                  verbose = verbose) |>
    httr2::req_url_path_append("FixedList/AccessConstraints/LegalAuthority") |>
    httr2::req_perform()

  .validate_resp(authority)

  authority <- httr2::resp_body_json(authority)

  authority <- dplyr::bind_rows(authority)

  return(authority)
}
