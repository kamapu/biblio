#' @name match_keys
#' 
#' @rdname match_keys
#' 
#' @title Match bibtexkeys used in an r-markdown document
#' 
#' @description 
#' This function scan an Rmd file in relation to a reference bibtex library
#' (the one used to insert citations) and finds the line position of the
#' respective citation.
#' 
#' This function can be useful to produce subsets of bibtex libraries to be
#' shared in companion to a depending r-markdown document.
#' It can be also used to count the occurrences of citations in a document and
#' through this way to detect rarely cited articles.
#' 
#' @param x An object of class 'lib_df'.
#' @param rmd_file A character vector indicating the path to the r-markdown file
#'     to be scanned.
#' @param ... Further arguments passed among methods (not in use).
#' 
#' @return 
#' A data frame with two columns, `bibtexkey` for the found keys and `line`
#' with the line number of the occurrence of the key in the document.
#' 
#' @export match_keys
#' 
match_keys <- function (x, ...) {
	UseMethod("match_keys", x)
}

#' @rdname match_keys
#' 
#' @method match_keys lib_df
#' @export 
#' 
match_keys.lib_df <- function(x, rmd_file, ...) {
	rmd_file <- readLines(rmd_file, ...)
	keys <- paste0("@", x$bibtexkey)
	cited_refs <- list()
	for(i in 1:length(rmd_file)) {
		cited_refs[[i]] <- data.frame(
				bibtexkey=sub("@", "", str_extract(rmd_file[i], keys)),
				line=i, stringsAsFactors=FALSE)
	}
	cited_refs <- do.call(rbind, cited_refs)
	cited_refs <- cited_refs[!is.na(cited_refs$bibtexkey), ]
	return(cited_refs)
}
