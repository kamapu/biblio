context("reading bibtex files")

test_that("bibtex files are read", {
			expect_is(read_bib(x = file.path(path.package("biblio"),
									"LuebertPliscoff.bib")), "lib_df")
		})
