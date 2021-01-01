context("detecting citations in r-markdown documents")

test_that("bibtex files are read", {
			my_documents <- readLines(file.path(path.package("biblio"),
							"document.Rmd"))
			expect_is(detect_keys(my_documents), "data.frame")
		})
