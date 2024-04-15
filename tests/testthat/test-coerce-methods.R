context("coerce objects among classes")

test_that("coercion is working", {
  Bib <- read_bib(x = file.path(
    path.package("biblio"),
    "LuebertPliscoff.bib"
  ))[1:5, ]
  expect_equal(class(as(Bib, "data.frame")), "data.frame")
  expect_equal(class(as(Bib, "bibentry")), "bibentry")
  expect_equal(
    class(as(as(Bib, "bibentry"), "lib_df")),
    c("lib_df", "data.frame")
  )
})
