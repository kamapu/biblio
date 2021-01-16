context("print methods")

test_that("print is working for imported files", {
			result <- evaluate_promise(print(read_bib(
									x = file.path(path.package("biblio"),
											"LuebertPliscoff.bib"))),
					print = TRUE)
			expect_equal(grepl("Number of references", result$output), TRUE)
		})

test_that("print is working for comparisons", {
			# First data set
			iris1 <- data.frame(id = 1:nrow(iris), iris)
			# Modified data set
			iris2 <- iris1[-c(5, 11, 12), ]
			iris2$Sepal.Length[6] <- 100
			iris2$Petal.Length[100] <- 100
			result <- evaluate_promise(print(compare_df(iris1, iris2, "id")),
					print = TRUE)
			# Test
			expect_equal(grepl("##", result$output), TRUE)
		})
