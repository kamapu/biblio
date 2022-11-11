#' @name write_bib
#'
#' @rdname write_bib
#'
#' @title Write BibTeX Files
#'
#' @description
#' BibTeX databases can be created from data frames, interacting with Postgres
#' databases.
#'
#' @param x A data frame with bibliographic entries.
#' @param filename A character value with the path and the name of the file to
#'     be written.
#' @param encoding Character value with the encoding (passed to [file()]).
#' @param ... Further arguments passed to [file()].
#'
#' @return
#' A bibtex file.
#'
#' @export
#'
write_bib <- function(x, ...) {
  UseMethod("write_bib", x)
}

#' @rdname write_bib
#'
#' @method write_bib lib_df
#' @export
#'
write_bib.lib_df <- function(x, filename, encoding = "UTF-8", ...) {
  if (missing(filename)) {
    filename <- paste0(deparse(substitute(x)))
  }
  # In case of missing extension
  filename <- paste0(file_path_sans_ext(filename), ".bib")
  # Entries as named characters
  Vars <- colnames(x)
  x <- split(as.matrix(x), 1:nrow(x))
  x <- lapply(x, function(x, n) {
    names(x) <- n
    x[!is.na(x)]
  }, Vars)
  # Final format
  x <- lapply(x, function(x) {
    prefix <- paste(" ", names(x), "= {")
    # rep("  {", length(x))
    prefix[1:2] <- c("@", "{")
    suffix <- rep("},\n", length(x))
    suffix[1:2] <- c("", ",\n")
    paste0(paste0(prefix, x, suffix, collapse = ""), "}\n\n")
  })
  # Write file
  con <- file(filename, "wb", encoding = encoding, ...)
  writeBin(charToRaw(paste0(c(
    "% Encoding: ", encoding, "\n",
    unlist(x)
  ),
  collapse = ""
  )), con, endian = "little")
  close(con)
}
