#' Import a RIS file to a data frame
#'
#' Since this package is focussing on reference lists in BibTeX, a translation
#' routine needs to be developed. For keeping it simple, the read function will
#' be kept as internal function producing a data frame.
#'
#' @param x A character value indicating the path to the RIS file.
#' @param ... Further arguments (not yet in use).
#'
#' @return A `data.frame` object.
#'
#' @keywords internal
ris2df <- function(x, ...) {
  x <- readLines(x, ...)
  # delete leading and trailing blanks
  x <- trimws(x)
  # delete double spaces within lines
  x <- gsub("\\s+", " ", x)
  # delete empty lines
  x <- x[nchar(x) > 0]
  # Get head and body
  Head <- substr(x, 1, 2)
  Sep <- substr(x, 3, 5)
  Body <- substr(x, 6, nchar(x))
  # Scan separator and resolve
  for (i in 1:length(x)) {
    if (Head[i] != "ER" & Sep[i] != " - ") {
      Head[i] <- Head[i - 1]
      Body[i] <- x[i]
    }
  }
  # Split by reference
  idx <- rev(cumsum(as.integer(rev(Head) == "ER")))
  idx <- max(idx) - idx + 1
  x <- data.frame(temporary_id = idx, tag = Head, value = Body)
  x <- aggregate(value ~ tag + temporary_id, data = x, FUN = function(x) {
    paste(x, collapse = ";")
  })
  x <- split(x, x$temporary_id)
  df_from_ris <- function(y) {
    y <- y$value[match(data_bib$tags_ris$tag, y$tag)]
    y <- matrix(y, nrow = 1, dimnames = list(
      m = NULL,
      n = data_bib$tags_ris$tag
    ))
    return(y)
  }
  x <- lapply(x, df_from_ris)
  x <- as.data.frame(do.call(rbind, x))
  # skip empty columns
  x <- x[, apply(x, 2, function(z) !all(is.na(z)))]
  return(x)
}
