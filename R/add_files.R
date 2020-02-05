#' @name add_files
#' @aliases add_files<-
#' 
#' @title Add List of Files from Additional Table
#' 
#' @description 
#' This function attempts to harmonize relational databases listing files in
#' a separated relation (data frame).
#' 
#' @param refs A data frame including reference entries imported from BibTeX
#'     databases by \code{\link{read_bib}}. At least a column called 'bibtexkey'
#'     have to be included in this table.
#' @param value A data frame listing files with respective bibtexkey and
#'     MIME-Type. In this table the columns 'bibtexkey', 'file', and 'mime' are
#'     mandatory. The occurrence of all bibtexkey values in 'value' will be
#'     cross-checked and evenctually cause an error, thus you may clean this
#'     data frame before using it.
#' 
#' @return The same data frame 'refs' with an inserted or updated column 'file'.
#' 
#' @author Miguel Alvarez \email{kamapu78@@gmail.com}
#' 
#' @export 
"add_files<-" <- function(refs, value) {
	if(!"bibtexkey" %in% colnames(refs))
		stop("'bibtexkey' is a mandatory column in 'refs'.")
	if(any(!c("bibtexkey", "file", "mime") %in% colnames(value)))
		stop("'bibtexkey', 'file' and 'mime' are mandatory fields in 'value'.")
	if(any(!value$bibtexkey %in% refs$bibtexkey))
		stop("Some values of 'bibtexkey' in 'value' are not present in 'refs'.")
	value$file <- with(value, paste(file, mime, sep=":"))
	value <- split(value, value$bibtexkey)
	value <- do.call(rbind, lapply(value, function(x)
						c(x$bibtexkey[1], paste0(x$file, collapse=";"))))
	refs$file <- value[match(refs$bibtexkey, value[,1]),2]
	return(refs)
}
