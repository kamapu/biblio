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
  x <- cbind(cumsum(substring(x, 1, 1) == "@"), x)
  # get bibtype, key and id
  refid <- data.frame(refid = x[substring(x[, 2], 1, 1) == "@", 1])
  bib_type <- substring(x[, 2], 2, nchar(x[, 2]) - 1)
  bib_type <- strsplit(bib_type[substring(x[, 2], 1, 1) == "@"], "{",
    fixed = TRUE
  )
  if (length(bib_type) > 1) {
    bib_type <- do.call(rbind, bib_type)
    bib_type <- data.frame(bibtype = bib_type[, 1], bibtexkey = bib_type[, 2])
  } else {
    bib_type <- data.frame(
      bibtype = bib_type[[1]][1],
      bibtexkey = bib_type[[1]][2]
    )
  }
  # skip comment Notice
  bib_type <- data.frame(bib_type, refid)
  bib_type <- bib_type[tolower(bib_type$bibtype) != "comment", ]
  x <- x[x[, 1] %in% bib_type$refid, ]
  # warn duplicated bibtexkeys
  if (any(duplicated(bib_type$bibtexkey))) {
    warning("Some duplicated values for 'bibtexkey' in 'x'.")
  }
  # getting list of entry fields
  x <- x[substr(x[, 2], 1, 1) != "@" & substr(x[, 2], 1, 1) != "}", ]
  x[, 2] <- gsub("\\s+", " ", str_trim(x[, 2]))
  Content <- strsplit(x[, 2], " = {", fixed = TRUE)
  Content <- lapply(Content, function(x) {
    if (length(x) == 1) {
      x <- c(NA, x)
    }
    return(x)
  })
  Content <- cbind(x[, 1], do.call(rbind, Content))
  # Fill NAs forward (Stack Overflow: 7735647)
  Content[, 2] <- c(NA, na.omit(Content[, 2]))[cumsum(!is.na(Content[
    ,
    2
  ])) + 1]
  # Skip trailing field symbol
  Content[, 3] <- sub("(},)$|(})$", "", Content[, 3])
  # Aggregate for multiple lines entries
  Content <- as.data.frame(Content, stringsAsFactors = FALSE)
  colnames(Content) <- c("refid", "field", "value")
  Content <- aggregate(value ~ refid + field,
    data = Content,
    FUN = function(x) paste0(x, collapse = "\n")
  )
  # Output table
  fields <- unique(Content$field)
  new_x <- expand.grid(
    field = fields, refid = bib_type$refid,
    stringsAsFactors = FALSE
  )
  new_x$value <- with(new_x, Content[match(
    paste(refid, field, sep = "_"),
    paste(Content$refid, Content$field, sep = "_")
  ), 3])
  new_x <- with(new_x, do.call(rbind, split(value, as.integer(refid))))
  colnames(new_x) <- fields
  new_x <- as.data.frame(new_x)
  names(bib_type) <- c("bibtype", "bibtexkey", "refid")
  new_x <- data.frame(
    bib_type[, c("bibtype", "bibtexkey")],
    new_x[match(bib_type$refid, rownames(new_x)), ]
  )
  # Defining S3 class
  class(new_x) <- c("lib_df", "data.frame")
  return(new_x)
}
