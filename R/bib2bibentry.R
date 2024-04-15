#' @name bib2bibentry
#' @rdname bib2bibentry
#'
#' @title Convert lib_df to bibentry
#'
#' @description
#' Conversion method for `lib_df` objects into `bibentry`.
#'
#' @param x A `lib_df` object to be converted.
#' @param ... Further arguments passed among methods (not yet in use).
#'
#' @return
#' An `bibentry` object.
#'
#' @example examples/bib2bibentry.R
#'
#' @export
bib2bibentry <- function(x, ...) {
  UseMethod("bib2bibentry", x)
}

#' @rdname bib2bibentry
#' @aliases bib2bibentry,lib_df-method
#' @method bib2bibentry lib_df
#' @export
bib2bibentry.lib_df <- function(x, ...) {
  names(x)[names(x) == "bibtexkey"] <- "key"
  x <- sapply(
    split(x, seq_along(x$bibtype)),
    function(x) do.call(bibentry, as.list(x))
  )
  class(x) <- "bibentry"
  return(x)
}
