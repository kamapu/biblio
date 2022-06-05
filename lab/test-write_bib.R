context("writing backups")

test_that("Backups are written", {
			Bib <- read_bib(x = file.path(path.package("biblio"),
							"LuebertPliscoff.bib"))
      File <- tempfile(fileext = ".bib")
			write_bib(x = Bib, file = File)
			expect_true(file.exists(File))
		})
