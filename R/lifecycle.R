#' Delete an inactive reference
#'
#' This function will delete one reference. The reference must be in an inactive status and the person running the function must be an editor on the reference to delete it. Use with caution. This is not easily undone!
#'
#' @inheritParams upload_file_to_reference
#'
#' @returns NULL (invisibly)
#' @export
#'
#' @examples
#' \dontrun{
#' delete_inactive_ref(reference_id = 00000,
#'                     dev = TRUE,
#'                     interactive = TRUE)
#' }
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
  request_body <- "null"
  delete_ref <- .datastore_request(is_secure = TRUE, is_dev = dev) |>
    httr2::req_url_path_append("Reference",
                               reference_id,
                               "Lifecycle/Inactive") |>
    httr2::req_body_json(request_body,
                         type = "application/json") |>
    httr2::req_method("PUT") |>
    httr2::req_perform()
  .validate_resp(delete_ref,
                 nice_msg_500 = paste0("Could not modify ", reference_id,
                                       ". You must be a reference editor to ",
                                       "modify a reference."))
  # notify of success:
  if (interactive && delete_ref$status_code == 200) {
    msg <- paste0("Reference ", reference_id, " has been deleted.")
    cli::cli_inform(msg)
  }
  return(invisble(NULL))
}
