# Adding an ID to data set iris
iris2 <- iris
iris2$id <- 1:nrow(iris2)

# rows to add using mean values per species
iris_mod <- aggregate(cbind(
  Sepal.Length, Sepal.Width, Petal.Length,
  Petal.Width
) ~ Species, data = iris2, FUN = mean)
iris_mod$id <- (1:nrow(iris_mod)) + nrow(iris2)
iris_mod <- do.call(rbind, list(iris2, iris_mod[, colnames(iris2)]))

# delete some entries
iris_mod <- iris_mod[-c(15, 75, 105, 145), ]

# modify entries
iris_mod$Petal.Length[c(20, 30)] <- 0
iris_mod$Petal.Width[c(20, 50)] <- 0

# just a comparison
update_data(iris2, iris_mod, key = "id")

# do update
iris2 <- update_data(iris2, iris_mod,
  key = "id", delete = TRUE, add = TRUE,
  update = TRUE
)
