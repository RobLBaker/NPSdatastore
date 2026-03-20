test_that(".get_base_url returns the correct URL", {
  expect_equal(.get_base_url(is_secure = FALSE, is_dev = FALSE), "https://irmaservices.nps.gov/datastore/v8/rest")
  expect_equal(.get_base_url(is_secure = TRUE, is_dev = FALSE), "https://irmaservices.nps.gov/datastore-secure/v8/rest")
  expect_equal(.get_base_url(is_secure = FALSE, is_dev = TRUE), "https://irmadevservices.nps.gov/datastore/v8/rest")
  expect_equal(.get_base_url(is_secure = TRUE, is_dev = TRUE), "https://irmadevservices.nps.gov/datastore-secure/v8/rest")
})

test_that(".datastore_request returns the correct URL and auth info", {

  public <- .datastore_request(is_secure = FALSE, is_dev = FALSE)
  secure <- .datastore_request(is_secure = TRUE, is_dev = FALSE)
  public_dev <- .datastore_request(is_secure = FALSE, is_dev = TRUE)
  secure_dev <- .datastore_request(is_secure = TRUE, is_dev = TRUE)

  expect_equal(public$url, "https://irmaservices.nps.gov/datastore/v8/rest")
  expect_equal(secure$url, "https://irmaservices.nps.gov/datastore-secure/v8/rest")
  expect_equal(public_dev$url, "https://irmadevservices.nps.gov/datastore/v8/rest")
  expect_equal(secure_dev$url, "https://irmadevservices.nps.gov/datastore-secure/v8/rest")

  expect_length(public$options, 0)
  expect_length(public_dev$options, 0)

  expect_equal(secure$options, list(httpauth = 4, userpwd = ":::"))
  expect_equal(secure_dev$options, list(httpauth = 4, userpwd = ":::"))

})

test_that("example_ref_ids returns example reference IDs", {
  expect_length(example_ref_ids(n = 5), 5)
  expect_length(example_ref_ids(visibility = "internal"), 45)
  expect_length(example_ref_ids(visibility = "public"), 48)
  expect_length(example_ref_ids(visibility = "both"), 45 + 48)
  expect_length(suppressWarnings(example_ref_ids(n = 500)), 48)
  expect_warning(example_ref_ids(n = 500), "exceeds total number")

})

test_that(".get_ref_profile_url constructs the correct URL", {

  public <- .get_ref_profile_url(public_refs[37], is_dev = FALSE)
  public_dev <- .get_ref_profile_url(public_refs[5], is_dev = TRUE)
  secure <- .get_ref_profile_url(internal_refs[22], is_dev = FALSE)
  secure_dev <- .get_ref_profile_url(internal_refs[9], is_dev = TRUE)


  expect_type(public_dev, "character")
  expect_type(public, "character")
  expect_type(secure_dev, "character")
  expect_type(secure, "character")

  expect_equal(substr(public_dev, 1, 52), "https://irmadev.nps.gov/DataStore/Reference/Profile/")
  expect_equal(substr(public, 1, 49), "https://irma.nps.gov/DataStore/Reference/Profile/")
  expect_equal(substr(secure_dev, 1, 52), "https://irmadev.nps.gov/DataStore/Reference/Profile/")
  expect_equal(substr(secure, 1, 49), "https://irma.nps.gov/DataStore/Reference/Profile/")
})
