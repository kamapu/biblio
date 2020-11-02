#' @name print
#' 
#' @title Print content of lib_df objects
#' 
#' @description 
#' A method for a brief overview on the content of a 'lib_df' object.
#' 
#' @param x An object of class 'lib_df'.
#' @param ... Further arguments passed among methods.
#' 
#' @author Miguel Alvarez
#' 
#' @examples
#' Bib <- read_bib(bib=file.path(path.package("biblio"),
#'     "LuebertPliscoff.bib"))
#' Bib
#' 
#' @method print lib_df
#' @export
#' 
print.lib_df <- function(x, ...) {
	cat(paste0("Object of class 'lib_df'\n\n",
					"Number of references: ", nrow(x), "\n",
					"Number of variables: ", ncol(x), "\n",
					"Duplicated entries: ", any(duplicated(x$bibtexkey)), "\n"))
}
