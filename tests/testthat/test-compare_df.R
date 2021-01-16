context("comparing two data sets")

test_that("comparison is working for data frames", {
			# First data set
			iris1 <- data.frame(id = 1:nrow(iris), iris)
			# Modified data set
			iris2 <- iris1[-c(5, 11, 12), ]
			iris2$Sepal.Length[6] <- 100
			iris2$Petal.Length[100] <- 100
			# Test
			expect_is(compare_df(iris1, iris2, "id"), "list")
		})

# TODO: Resolve the error in next test
test_that("comparison is working for 'lib_df' objects", {
            Bib <- read_bib(x = file.path(path.package("biblio"),
                            "LuebertPliscoff.bib"))
            expect_is(compare_df(Bib, Bib), "list")
        })
