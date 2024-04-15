#' @name as
#' @rdname coerce-methods
#'
#' @title Coerce 'lib_df' objects
#'
#' @description
#' Coercion 'lib_df' objects.
#'
#' @param x An object to be coerced.
#'
#' @example examples/coerce-methods.R
#'
#' @aliases coerce,lib_df,data.frame-method
setAs(from = "lib_df", to = "data.frame", def = function(from) {
  return(as.data.frame(from))
})

#' @name as
#' @rdname coerce-methods
#' @aliases coerce,lib_df,bibentry-method
setAs(from = "lib_df", to = "bibentry", def = function(from) {
  return(bib2bibentry(from))
})

#' @name as
#' @rdname coerce-methods
#' @aliases coerce,bibentry,lib_df-method
setAs(from = "bibentry", to = "lib_df", def = function(from) {
  return(read_bib(capture.output(print(from, "bibtex"))))
})
