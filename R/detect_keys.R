#' @name detect_keys
#'
#' @rdname detect_keys
#'
#' @title Detect bibtexkeys used in an r-markdown document
#'
#' @description
#' This function screens a character vector (usually an imported r-markdown
#' document) for the use of citations by bibtexkeys (`@@bibtexkey`), retrieving
#' the detected key with its occurrence in the vector, assuming each element as
#' a line of the original document.
#'
#' This function is based on `bbt_detect_citations()` from the package
#' [rbbt](https://github.com/paleolimbot/rbbt).
#'
#' @param x A character vector, a file imported by [readLines()] or an object
#'     imported by [read_rmd()]. If the character vector is the name of a Rmd
#'     file, [readLines()] will be internally called to read it.
#' @param ... Further arguments passed among methods. In character-method they
#'     are passed to [readLines()].
#'
#' @return
#' A data frame with two columns, `bibtexkey` for the found keys and `line`
#' with the line number of the occurrence of the key in the document.
#'
#' @example examples/detect_keys.R
#'
#' @export detect_keys
#'
detect_keys <- function(x, ...) {
  UseMethod("detect_keys", x)
}

#' @rdname detect_keys
#'
#' @aliases detect_keys,character-method
#'
#' @method detect_keys character
#' @export
#'
detect_keys.character <- function(x, ...) {
  # If character the name of a file
  if (length(x) == 1 & substr(x[1], nchar(x) - 3, nchar(x)) == ".Rmd") {
    x <- readLines(x, ...)
  }
  # Code from rbbt::detect_citations()
  match_str <- function(content, exp) {
    str_match_all(content, regex(exp, multiline = TRUE, dotall = TRUE))[[1]][,
      2,
      drop = TRUE
    ]
  }
  # keys and lines
  do_df <- function(content, exp) {
    Keys <- lapply(X = content, match_str, exp = exp)
    Lines <- do.call(c, lapply(Keys, length))
    Lines <- rep(seq_along(Lines), times = Lines)
    Keys <- do.call(c, Keys)
    return(data.frame(bibtexkey = Keys, line = Lines))
  }
  # Expressions (second solving issue 32)
  exp1 <- "[^a-zA-Z0-9\\\\]@([a-zA-Z0-9_.-]+[a-zA-Z0-9])"
  exp2 <- "^@([a-zA-Z0-9_.-]+[a-zA-Z0-9])"
  # Final output
  return(do.call(rbind, list(do_df(x, exp1), do_df(x, exp2))))
}

#' @rdname detect_keys
#'
#' @aliases detect_keys,rmd_doc-method
#'
#' @method detect_keys rmd_doc
#' @export
#'
detect_keys.rmd_doc <- function(x, ...) {
  message("Lines are counted only at the body of the document.")
  detect_keys(x[["body"]], ...)
}
