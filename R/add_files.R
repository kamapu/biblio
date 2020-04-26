#' @name add_files
#' @aliases add_files<-
#' @rdname add_files
#' 
#' @title Add List of Files from Additional Table
#' 
#' @description 
#' The function `add_files<-` attempts to harmonize relational databases listing
#' files in a separated relation (data frame).
#' 
#' The reverse function is called `get_files`, where a string will be converted
#' into a data frame.
#' 
#' @param refs A data frame including reference entries imported from BibTeX
#'     databases by \code{\link{read_bib}}. At least a column called 'bibtexkey'
#'     have to be included in this table.
#' @param value A data frame listing files with respective bibtexkey and
#'     MIME-Type. In this table the columns 'bibtexkey', 'file', and 'mime' are
#'     mandatory. The occurrence of all bibtexkey values in 'value' will be
#'     cross-checked and evenctually cause an error, thus you may clean this
#'     data frame before using it.
#' @param priority Character value. A keyword used as file description to define
#'     which is the main document in the entry. Files including this description
#'     will be listed first in the output bibtex file (JabRef style).
#' 
#' @return
#' In `add_files<-` the same data frame 'refs' with an inserted or updated
#' column 'file'.
#' For `get_files`, a data frame with three columns, namely 'bibtexkey', 'file',
#' 'mime', and 'description' where every file is listed in aseparated row.
#'  
#' @author Miguel Alvarez \email{kamapu78@@gmail.com}
#' 
#' @export add_files<-
#' 
"add_files<-" <- function(refs, priority="main text", value) {
	if(!"bibtexkey" %in% colnames(refs))
		stop("'bibtexkey' is a mandatory column in 'refs'.")
	if(any(!c("bibtexkey", "file", "mime") %in% colnames(value)))
		stop("'bibtexkey', 'file' and 'mime' are mandatory fields in 'value'.")
	if(any(!value$bibtexkey %in% refs$bibtexkey))
		stop("Some values of 'bibtexkey' in 'value' are not present in 'refs'.")
	value <- value[order(value$description == priority, decreasing=TRUE),]
	value$description[is.na(value$description)] <- ""
	value$file <- with(value, paste(description, file, mime, sep=":"))
	value <- split(value, value$bibtexkey)
	value <- do.call(rbind, lapply(value, function(x)
						c(x$bibtexkey[1], paste0(x$file, collapse=";"))))
	refs$file <- value[match(refs$bibtexkey, value[,1]),2]
	return(refs)
}

#' @rdname add_files
#' @aliases get_files
#' 
#' @export get_files
#' 
get_files <- function(refs) {
	if(!all(c("bibtexkey", "file") %in% colnames(refs)))
		stop("Columns 'bibtexkey' and 'file' are mandatory in 'refs'.")
	file_string <- strsplit(refs$file, ";", fixed=TRUE)
	file_string <- data.frame(bibtexkey=rep(refs$bibtexkey, sapply(file_string,
							length)),
			file=unlist(file_string),
			stringsAsFactors=FALSE)
	refs <- do.call(rbind, strsplit(file_string$file, ":", fixed=TRUE))
	file_string$file <- refs[,2]
	file_string$mime <- refs[,3]
	file_string$description <- refs[,1]
	file_string$description[file_string$description == ""] <- NA
	return(file_string[!is.na(file_string$file),])
}
