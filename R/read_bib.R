#' @name read_bib
#'
#' @title Read BibTeX Databases
#'
#' @description
#' Reading BibTeX databases and importing into R as a data frame. All the fields
#' will be inserted as character values.
#'
#' @param x A single character value with the path to a BibTeX file.
#'     Alternativelly it can be a character vector containing the lines of a
#'     BibTeX library, for instance after using [readLines()].
#' @param ... Further arguments passed to [readLines()].
#'
#' @return
#' An object of class [lib_df-class].
#'
#' @example examples/read_bib.R
#'
#' @export
read_bib <- function(x, ...) {
  if (length(x) == 1) {
    x <- readLines(x, ...)
  }
  # skip empty lines, lines with a single closing curly brace and comments
  x <- x[!grepl("^\\s*$|^\\s*\\}$|^%", x)]
  # get index for reference
  x <- data.frame(refid = cumsum(substring(x, 1, 1) == "@"), content = x)
  # get bibtype, key and id
  bib_type <- data.frame(
    refid = x$refid[grepl("^@\\w+", x$content)],
    bibtype = regmatches(x$content, regexpr("^@\\K\\w+(?=\\{)",
      x$content,
      perl = TRUE
    )),
    bibtexkey = regmatches(x$content, regexpr("^@\\w+\\{\\K([^,]+|)",
      x$content,
      perl = TRUE
    ))
  )
  # skip comment Notice
  bib_type <- bib_type[tolower(bib_type$bibtype) != "comment", ]
  x <- x[x$refid %in% bib_type$refid, ]
  # warn duplicated bibtexkeys
  d_keys <- with(bib_type, bibtexkey[bibtexkey != "" & duplicated(bibtexkey)])
  if (length(d_keys)) {
    warning(paste0(
      "Following bibtexkeys are duplicated: '",
      paste0(d_keys, collapse = "', '"), "'."
    ))
  }
  # getting list of entry fields
  pattern <- "^\\s+(\\w+)\\s*=\\s*.*"
  x$field <- sub(pattern, "\\1", x$content)
  x$field[!grepl(pattern, x$content)] <- ""
  # clean the content
  x$content[grepl("^@", x$content)] <- ""
  x <- x[x$content != "", ]
  idx <- x$field != ""
  x$content <- gsub("\\s+", " ", str_trim(x$content))
  x$content[idx] <- str_replace(x$content[idx], paste(x$field[idx], "= "), "")
  x$content[idx] <- sub("^\\{", "", x$content[idx])
  idx2 <- c(idx[-1], TRUE)
  x$content[idx2] <- sub("(},)$|(})$", "", x$content[idx2])
  # For fields without braces
  x$content[idx2] <- sub(",$", "", x$content[idx2])
  # Necessary loop to fill fields
  for (i in seq_along(x$field[-1])) {
    if (x$field[i + 1] == "") x$field[i + 1] <- x$field[i]
  }
  x <- aggregate(content ~ refid + field,
    data = x,
    FUN = function(x) paste0(x, collapse = "\n")
  )
  # Output table
  fields <- unique(x$field)
  new_x <- expand.grid(
    field = fields, refid = bib_type$refid,
    stringsAsFactors = FALSE
  )
  new_x$value <- with(new_x, x$content[match(
    paste(refid, field, sep = "_"),
    paste(x$refid, x$field, sep = "_")
  )])
  new_x <- with(new_x, do.call(rbind, split(value, refid)))
  colnames(new_x) <- fields
  new_x <- as.data.frame(new_x)
  new_x <- data.frame(
    bib_type[, c("bibtype", "bibtexkey")],
    new_x[match(bib_type$refid, rownames(new_x)), ]
  )
  # Defining S3 class
  class(new_x) <- c("lib_df", "data.frame")
  return(new_x)
}
