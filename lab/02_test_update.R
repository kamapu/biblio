# TODO:   Update a data frame
# 
# Author: Miguel Alvarez
################################################################################

library(biblio)

# Modify iris
data(iris)

iris$id <- 1:nrow(iris)

iris_mod <- aggregate(cbind(Sepal.Length, Sepal.Width, Petal.Length,
				Petal.Width) ~ Species, data = iris, FUN = mean)

iris_mod$id <- (1:nrow(iris_mod)) + nrow(iris)

iris_mod <- do.call(rbind, list(iris, iris_mod[ , colnames(iris)]))

# delete some entries
iris_mod <- iris_mod[-c(15, 75, 105, 145), ]

# modify entries
iris_mod$Petal.Length[c(20, 30)] <- 0
iris_mod$Petal.Width[c(20, 50)] <- 0

Test <- compare_df(iris, iris_mod, key = "id")



update_report <- Test
object <- iris

update_report$new_vals

key <- "id"


match(rownames(update_report$new_vals), paste(object[ , key]))


# Test the function
update(iris, iris_mod, key = "id")

Test <- update(iris, iris_mod, key = "id", delete = TRUE)
update(iris, Test, key = "id")

Test <- update(iris, iris_mod, key = "id", add = TRUE)
update(iris, Test, key = "id")

Test <- update(iris, iris_mod, key = "id", update = TRUE)
update(iris, Test, key = "id")


# Fake lib_df
iris$bibtexkey <- iris$id
class(iris) <- c("lib_df", "data.frame")

iris_mod$bibtexkey <- iris_mod$id
class(iris_mod) <- c("lib_df", "data.frame")


# Again
update(iris, iris_mod)

Test <- update(iris, iris_mod, delete = TRUE)
update(iris, Test, key = "id")

Test <- update(iris, iris_mod, key = "id", add = TRUE)
update(iris, Test, key = "id")

Test <- update(iris, iris_mod, key = "id", update = TRUE)
update(iris, Test, key = "id")






