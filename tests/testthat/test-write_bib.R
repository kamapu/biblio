context("writing bibtex files")

test_that("bibtex files are written", {
  Bib <- read_bib(x = file.path(
    path.package("biblio"),
    "LuebertPliscoff.bib"
  ))
  Bib <- subset(Bib, year == "2000")
  file_name <- "year_2000.bib"
  write_bib(Bib, file.path(tempdir(), file_name))
  expect_true(file_name %in% list.files(tempdir()))
})
