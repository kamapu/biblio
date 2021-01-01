#' @name detect_keys
#' 
#' @rdname detect_keys
#' 
#' @title Detect bibtexkeys used in an r-markdown document
#' 
#' @description 
#' This function screens a character vector (usually an imported r-markdown
#' document) for the use of citations by bibtexkeys ('@@bibtexkey'), retrieving
#' the detected key with its occurrence in the vector, assuming each element as
#' a line of the original document.
#' 
#' This function is based on `bbt_detect_citations()` from the package
#' \href{rbbt}{https://github.com/paleolimbot/rbbt}.
#' 
#' @param x A character vector to be scanned, for instance a file imported
#'     either by [readLines()] or [yamlme::read_rmd()].
#' @param ... Further arguments passed among methods.
#' 
#' @return 
#' A data frame with two columns, `bibtexkey` for the found keys and `line`
#' with the line number of the occurrence of the key in the document.
#' 
#' @examples 
#' ## Read installed r-markdown document
#' my_documents <- readLines(file.path(path.package("biblio"), "document.Rmd"))
#' 
#' ## Screen for citations
#' cited_refs <- detect_keys(my_documents)
#' cited_refs
#' 
#' @export detect_keys
#' 
detect_keys <- function (x, ...) {
	UseMethod("detect_keys", x)
}

#' @rdname detect_keys
#' 
#' @method detect_keys character
#' @export 
#' 
detect_keys.character <- function(x, ...) {
	# Code from rbbt::detect_citations()
	match_str <- function(content)
		stringr::str_match_all(
				content,
				stringr::regex("[^a-zA-Z0-9\\\\]@([a-zA-Z0-9_.-]+[a-zA-Z0-9])",
						multiline = TRUE, dotall = TRUE))[[1]][ , 2,
				drop =  TRUE]
	# keys and lines
	Keys <- lapply(x, match_str)
	Lines <- do.call(c, lapply(Keys, length))
	Lines <- rep(seq_along(Lines), times = Lines)
	Keys <- do.call(c, Keys)
	# Final output
	return(data.frame(bibtexkey = Keys, line = Lines))
}
