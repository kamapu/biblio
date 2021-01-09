context("detecting citations in r-markdown documents")

test_that("bibtex files are read", {
			my_document <- readLines(file.path(path.package("biblio"),
							"document.Rmd"))
			expect_is(detect_keys(my_document), "data.frame")
			my_document <- yamlme::read_rmd(file.path(path.package("biblio"),
			                "document.Rmd"))
			expect_is(detect_keys(my_document), "data.frame")
		})
