#' @name synopsis
#'
#' @title References by Lueber and Pliscoff (2018)
#'
#' @description
#' Example of an object formatted as [lib_df-class]. This library is published
#' with the references of the book
#' \bold{Bioclimatic and vegetational synopsis of Chile} by
#' [Luebert and Pliscoff (2017)](https://www.uchile.cl/publicaciones/141285/sinopsis-bioclimatica-y-vegetacional-de-chile).
#'
#' @source
#' \doi{10.5281/zenodo.60800}
#'
#' @examples
#' data(synopsis)
#'
#' ## Import from installed bibtex file
#' synopsis <- read_bib(x = file.path(
#'   path.package("biblio"),
#'   "LuebertPliscoff.bib"
#' ))
#'
"synopsis"
