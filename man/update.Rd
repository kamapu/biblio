% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/update.R
\name{update}
\alias{update}
\alias{update.data.frame}
\alias{update.lib_df}
\alias{update<-}
\alias{update<-,data.frame,data.frame-method}
\alias{update<-,lib_df,lib_df-method}
\title{Update data frames}
\usage{
\method{update}{data.frame}(object, revision, key, delete = FALSE, add = FALSE, update = FALSE, ...)

\method{update}{lib_df}(
  object,
  revision,
  key = "bibtexkey",
  delete = FALSE,
  add = FALSE,
  update = FALSE,
  ...
)

update(object, ...) <- value

\S4method{update}{data.frame,data.frame}(object, key, delete = FALSE, add = FALSE, update = FALSE, ...) <- value

\S4method{update}{lib_df,lib_df}(
  object,
  key = "bibtexkey",
  delete = FALSE,
  add = FALSE,
  update = FALSE,
  ...
) <- value
}
\arguments{
\item{object}{A data frame or a \linkS4class{lib_df} object representing the
original version.}

\item{revision}{The updated version of 'object' to be compared.}

\item{key}{A character value indicating the column used as identifier. This
variable have to be in both versions otherwise this function will
retrieve an error.}

\item{delete, add, update}{A character value indicating whether the action
should be carried out. If all are 'FALSE', this function will just report
differences as done by \link{compare_df}.}

\item{...}{Further arguments passed among methods.}

\item{value}{The updated version of 'object' in the replace methods.}
}
\description{
This function compares two versions of the same data frame and detect changes
as additions, deleted entries or updates (modified entries).

A method to compare \linkS4class{lib_df} objects is also provided as well as a
replace method.
}
\examples{
# modifying the data set iris
data(iris)
iris$id <- 1:nrow(iris) # ID column added

# rows to add using mean values per species
iris_mod <- aggregate(cbind(Sepal.Length, Sepal.Width, Petal.Length,
    Petal.Width) ~ Species, data = iris, FUN = mean)
iris_mod$id <- (1:nrow(iris_mod)) + nrow(iris)
iris_mod <- do.call(rbind, list(iris, iris_mod[ , colnames(iris)]))

# delete some entries
iris_mod <- iris_mod[-c(15, 75, 105, 145), ]

# modify entries
iris_mod$Petal.Length[c(20, 30)] <- 0
iris_mod$Petal.Width[c(20, 50)] <- 0

# just a comparison
update(iris, iris_mod, key = "id")

# do update
iris <- update(iris, iris_mod, key = "id", delete = TRUE, add = TRUE,
    update = TRUE)

}
