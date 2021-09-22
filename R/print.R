#' @name print
#' 
#' @rdname print
#' 
#' @aliases print,lib_df-method
#' 
#' @title Print content of lib_df objects
#' 
#' @description 
#' A method for a brief overview on the content of a [lib_df-class] or a
#' [comp_df-class] object.
#' 
#' @param x An object of class 'lib_df'.
#' @param ... Further arguments passed among methods.
#' 
#' @author Miguel Alvarez
#' 
#' @examples
#' synopsis
#' 
#' @return 
#' An invisible object, printed in the console.
#' 
#' @method print lib_df
#' 
#' @export
#' 
print.lib_df <- function(x, ...) {
	cat(paste0("Object of class 'lib_df'\n\n",
					"Number of references: ", nrow(x), "\n",
					"Number of variables: ", ncol(x), "\n",
					"Duplicated entries: ", any(duplicated(x$bibtexkey)), "\n"))
}

#' @rdname print
#' 
#' @aliases print,comp_df-method
#' 
#' @method print comp_df
#' 
#' @export 
#' 
print.comp_df <- function(x, ...) {
	if(length(x$deleted) > 0)
		cat(paste0("## deleted entries (", length(x$deleted), "):\n'",
						paste0(x$deleted, collapse="' '"), "'\n\n"))
	if(nrow(x$added) > 0)
		cat(paste0("## added entries (", nrow(x$added), "):\n'",
						paste0(rownames(x$added), collapse="' '"), "'\n\n"))
	if(nrow(x$updated) > 0)
		for(i in rownames(x$updated)) {
			cat(paste0("## updates in entry '", i, "'\n"))
			for(j in colnames(x$updated)[x$updated[i,]]) {
				cat(paste0(" - old ", j, ": ", x$old_vals[i,j],
								"\n - new ", j,
								": ", x$new_vals[i,j], "\n\n"))
			}
		}
	if((length(x$deleted) == 0) & (nrow(x$added) == 0) & (nrow(x$updated) == 0))
		cat("## no changes detected\n\n")
}
