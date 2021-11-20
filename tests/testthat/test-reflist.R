context("writing reference lists")

test_that("Backups are written", {
			Bib <- read_bib(x = file.path(path.package("biblio"),
							"LuebertPliscoff.bib"))
      File1 <- tempfile()
      File2 <- tempfile(fileext = ".bib")
			reflist(x = Bib, filename = File1, bib_file = File2, delete_rmd = FALSE)
			expect_true(file.exists(File2))
			expect_true(file.exists(paste0(File1, ".Rmd")))
      File3 <- tempfile()
      reflist(x = file.path(path.package("biblio"),
							"LuebertPliscoff.bib"), filename = File3,
					delete_rmd = FALSE)
			expect_true(file.exists(paste0(File3, ".Rmd")))
		})
