context("writing backups")

test_that("Backups are written", {
			Bib <- read_bib(bib = file.path(path.package("biblio"),
							"LuebertPliscoff.bib"))
			write_bib(obj = Bib, file = "ex_bib.bib")
			expect_true(file.exists("ex_bib.bib"))
		})
