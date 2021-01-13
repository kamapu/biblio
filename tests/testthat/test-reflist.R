context("writing reference lists")

test_that("Backups are written", {
			Bib <- read_bib(bib = file.path(path.package("biblio"),
							"LuebertPliscoff.bib"))
			reflist(obj = Bib, filename = "test_refs", bib_file = "refs.bib",
					delete_rmd = FALSE, browse_file = FALSE)
			
			expect_true(file.exists("refs.bib"))
			expect_true(file.exists("test_refs.Rmd"))
			expect_true(file.exists("test_refs.html"))
			
			reflist(obj = file.path(path.package("biblio"),
							"LuebertPliscoff.bib"), filename = "test_refs2",
					delete_rmd = FALSE, browse_file = FALSE)
			
			expect_true(file.exists("test_refs2.Rmd"))
			expect_true(file.exists("test_refs2.html"))
		})
