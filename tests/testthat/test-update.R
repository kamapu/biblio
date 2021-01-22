context("testing update methods")

data(iris)
iris$id <- 1:nrow(iris)
# additions
iris_mod <- aggregate(cbind(Sepal.Length, Sepal.Width, Petal.Length,
				Petal.Width) ~ Species, data = iris, FUN = mean)
iris_mod$id <- (1:nrow(iris_mod)) + nrow(iris)
iris_mod <- do.call(rbind, list(iris, iris_mod[ , colnames(iris)]))
# delete some entries
iris_mod <- iris_mod[-c(15, 75, 105, 145), ]
# modify entries
iris_mod$Petal.Length[c(20, 30)] <- 0
iris_mod$Petal.Width[c(20, 50)] <- 0

# lib_df versions
iris_ld <- iris
iris_ld$bibtexkey <- iris_ld$id
class(iris_ld) <- c("lib_df", "data.frame")

iris_mod_ld <- iris_mod
iris_mod_ld$bibtexkey <- iris_mod_ld$id
class(iris_mod_ld) <- c("lib_df", "data.frame")

## Tests -----------------------------------------------------------------------

test_that("update is workig for data frames", {
			result <- evaluate_promise(update(iris, iris_mod, key = "id"),
					print = TRUE)
			expect_equal(grepl("## deleted entries", result$output), TRUE)
			expect_equal(grepl("## added entries", result$output), TRUE)
			expect_is(update(iris, iris_mod, key = "id", delete = TRUE,
							add = TRUE, update = TRUE), "data.frame")
			
			# Replace method
			Test <- iris
			expect_equal({
						update(Test, key = "id") <- iris_mod
						Test}, iris)
			expect_equal({
						update(Test, key = "id", delete = TRUE, add = TRUE,
								update = TRUE) <- iris_mod
						Test}, iris_mod)
		})

test_that("update is workig for lib_df objects", {
			result <- evaluate_promise(update(iris_ld, iris_mod_ld),
					print = TRUE)
			expect_equal(grepl("## deleted entries", result$output), TRUE)
			expect_equal(grepl("## added entries", result$output), TRUE)
			expect_is(update(iris_ld, iris_mod_ld, delete = TRUE, add = TRUE,
							update = TRUE), "data.frame")
			
			# Replace method
			Test <- iris_ld
			expect_equal({
						update(Test, key = "id") <- iris_mod_ld
						Test}, iris_ld)
			expect_equal({
						update(Test, key = "id", delete = TRUE, add = TRUE,
								update = TRUE) <- iris_mod_ld
						Test}, iris_mod_ld)
		})
