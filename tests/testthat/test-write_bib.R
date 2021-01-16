context("writing backups")

test_that("Backups are written", {
			Bib <- read_bib(x = file.path(path.package("biblio"),
							"LuebertPliscoff.bib"))
			write_bib(x = Bib, file = "ex_bib.bib")
			expect_true(file.exists("ex_bib.bib"))
		})
