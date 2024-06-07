#' @name doi2bib
#' @title Downloading bibliogrphic references from DOIs
#'
#' @description
#' Retrieving bibliographic entries from Crossref by DOIs.
#' This function is a wrapper for [cr_cn()].
#'
#' @param x A character vector including DOI identifiers.
#' @param ... Further arguments (not yet used).
#'
#' @example examples/doi2bib.R
#'
#' @return
#' The output is an object of class [lib_df-class].
#'
#' @export
doi2bib <- function(x, ...) {
  x <- do.call(c, cr_cn(dois = x))
  # Break before last curly bracket
  x <- gsub("}\\s*$", "\n}", x)
  # Break after the first comma
  x <- sub(",", ",\n", x, fixed = TRUE)
  # Skip leading blanks
  x <- trimws(x, which = "left")
  # Replace and break single entries
  for (i in standard_bib$field) {
    x <- sub(paste0(i, "="), paste0("\n    ", i, " = "), x, ignore.case = TRUE)
  }
  # Split into single lines
  x <- do.call(c, str_split(x, "\n"))
  # Convert to lib_df
  return(read_bib(x))
}
