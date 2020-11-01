#' @name read_bib
#' 
#' @title Read BibTeX Databases
#' 
#' @description 
#' Reading BibTeX databases and importing into R as a data frame. All the fields
#' will be inserted as character values.
#' 
#' @param bib Path to BibTeX file.
#' @param ... Further arguments passed to \code{\link{readLines}}.
#' 
#' #' @examples
#' Bib <- read_bib(bib=file.path(path.package("biblio"),
#'     "LuebertPliscoff.bib"))
#' Bib
#' 
#' @export read_bib
#' 
read_bib <- function(bib, ...) {
	bib <- readLines(bib, ...)
	# skip empty lines and comments
	bib <- bib[nchar(bib) > 0 & substring(bib, 1, 1) != "%"]
	# get index for reference
	bib <- cbind(cumsum(substring(bib, 1, 1) == "@"), bib)
	# get type, key and id
	refid <- bib[substring(bib[,2], 1, 1) == "@", 1]
	type <- substring(bib[,2], 2, nchar(bib[,2]) - 1)
	type <- strsplit(type[substring(bib[,2], 1, 1) == "@"], "{", fixed=TRUE)
	type <- do.call(rbind, type)
	# skip comment fields
	type <- cbind(type, refid)
	type <- type[type[,1] != "Comment",]
	bib <- bib[bib[,1] %in% type[,3],]
	# warn duplicated bibtexkeys
	if(any(duplicated(type[,3])))
		warning("Some duplicated values for 'bibtexkey' in 'bib'.")
	# getting list of entry fields
	bib <- bib[grepl(" = ", bib[,2], fixed=TRUE),]
	bib <- cbind(bib[,1], do.call(rbind, strsplit(bib[,2], " = ", TRUE)))
	bib[,2] <- trimws(bib[,2], "both")
	bib[,3] <- substring(bib[,3], 2, nchar(bib[,3]) - 2)
	fields <- unique(bib[,2])
	# Output table
	new_bib <- expand.grid(field=fields, refid=type[,3], stringsAsFactors=FALSE)
	new_bib$value <- with(new_bib, bib[match(paste(refid, field, sep="_"),
							paste(bib[,1], bib[,2], sep="_")),3])
	new_bib <- with(new_bib, do.call(rbind, split(value, as.integer(refid))))
	colnames(new_bib) <- fields
	colnames(type)[1:2] <- c("bib_type","bibtexkey")
	new_bib <- cbind(type[,c("bib_type","bibtexkey")],
			new_bib[match(type[,"refid"], rownames(new_bib)),])
	# Defining S3 class
	new_bib <- as.data.frame(new_bib, stringsAsFactors=FALSE)
	class(new_bib) <- c("lib_df", "data.frame")
	return(new_bib)
}
