


delete_inactive_ref <- function(reference_id,
                                dev = TRUE,
                                interactive = TRUE) {
  .validate_ref_id(reference_id)
  # Verify that we're modifying the right reference
  if (interactive) {
    .user_validate_ref_title(ref_id = reference_id,
                             is_secure = TRUE,
                             is_dev = dev)
  }
  # Actually delete the reference:
  delete_ref <- .datastore_request(is_secure = TRUE, is_dev = dev) |>
    httr2::req_url_path_append("Reference",
                               reference_id,
                               "Lifecycle/Inactive") |>
    httr2::req_method("PUT") |>
    httr2::req_perform()
  .validate_resp(delete_ref,
                 nice_msg_500 = paste0("Could not delete ", reference_id,
                                       ". You must be a reference editor to ",
                                       "delete a reference."))
  return(invisble(NULL))
}
