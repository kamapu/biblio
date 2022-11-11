#' @name reflist
#' @rdname reflist
#'
#' @title Write a Reference List in rmarkdown
#'
#' @description
#' A fast way to produce a reference list in an r-markdown document from a
#' `lib_df` object.
#'
#' This function may or may not produce intermediate files (bib and Rmd) and the
#' result can be assigned to an object for further edition
#' (see [yamlme::update()]).
#'
#' A html file will be written by [write_rmd()] and [render_rmd()] in the
#' working directory and displayed by [browseURL()].
#'
#' @param x A `lib_df` object to produce the reference list. In the character
#'     method, a character value indicating the path of a bibtex file
#'     (passed to [biblio::read_bib()]).
#' @param filename A character value with the name for the written Rmd file,
#'     without file extension.
#' @param output_file A character value with the name for the written Rmarkdown
#'     file.
#' @param delete_source A logical value indicating whether written bib file should
#'     be deleted after rendering html or not.
#' @param encoding A character value indicating the encoding string. It is
#'     passed to [write_bib()].
#' @param title,output,nocite,urlcolor Arguments used for the yaml-header in
#'     r-markdown and passed to [write_rmd()]. They can be cancelled using the
#'     value NULL (not recommended for nocite).
#' @param ... Further arguments passed to the yaml header in the intermediate
#'     Rmarkdown document.
#'
#' @return
#' An invisible object of class `rmd_doc`. A Rmd file will be written by
#' [write_rmd()] as well.
#'
#' @examples
#' \dontrun{
#' reflist(synopsis)
#' }
#'
#' @export
reflist <- function(x, ...) {
  UseMethod("reflist", x)
}

#' @rdname reflist
#' @aliases reflist,character-method
#' @method reflist character
#' @export
reflist.character <- function(x, output_file, delete_source = TRUE,
                              title = "Automatic Reference List",
                              output = "html_document",
                              nocite = "'@*'", urlcolor = "blue",
                              encoding = "UTF-8", ...) {
  # Bibliography to tempdir
  x <- paste0(file_path_sans_ext(x), ".bib")
  if (missing(output_file)) {
    output_file <- file_path_sans_ext(x)
  }
  file.copy(from = x, to = tempdir())
  # Write Rmd file
  bib_rmd <- as(list(
    title = title,
    output = output,
    bibliography = basename(x),
    nocite = nocite,
    urlcolor = urlcolor,
    encoding = encoding,
    ...
  ), "rmd_doc")
  # Render Rmd file
  render_rmd(bib_rmd, output_file = file.path(tempdir(), basename(output_file)))
  # Copy Rmarkdown document and bibliography
  if (!delete_source) {
    file.copy(
      from = file.path(tempdir(), paste0(basename(output_file), ".Rmd")),
      to = dirname(output_file)
    )
    if (dirname(x) != dirname(output_file)) {
      file.copy(from = x, to = dirname(output_file))
    }
  }
  # return rmd_doc if necessary
  invisible(bib_rmd)
}

#' @rdname reflist
#' @aliases reflist,lib_df-method
#' @method reflist lib_df
#' @export
reflist.lib_df <- function(x, filename, delete_source = TRUE, ...) {
  # set filename
  if (missing(filename)) {
    filename <- paste0(deparse(substitute(x)))
  } else {
    filename <- file_path_sans_ext(filename)
  }
  write_bib(x, filename = file.path(tempdir(), basename(filename)))
  # Render the reference list
  obj <- reflist(file.path(tempdir(), basename(filename)), ...)
  Files <- list.files(tempdir())
  Files <- Files[grepl(basename(filename), Files, fixed = TRUE)]
  if (delete_source) {
    Files <- Files[!Files %in% paste0(basename(filename), c(".bib", ".Rmd"))]
  }
  file.copy(
    from = file.path(tempdir(), Files),
    to = dirname(filename)
  )
  invisible(obj)
}
