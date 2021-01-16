#' @name read_bib
#' 
#' @title Read BibTeX Databases
#' 
#' @description 
#' Reading BibTeX databases and importing into R as a data frame. All the fields
#' will be inserted as character values.
#' 
#' @param x Path to BibTeX file.
#' @param ... Further arguments passed to \code{\link{readLines}}.
#' 
#' #' @examples
#' x <- read_bib(x = file.path(path.package("biblio"), "LuebertPliscoff.bib"))
#' x
#' 
#' @export read_bib
#' 
read_bib <- function(x, ...) {
	x <- readLines(x, ...)
	# skip empty lines and comments
	x <- x[nchar(x) > 0 & substring(x, 1, 1) != "%"]
	# get index for reference
	x <- cbind(cumsum(substring(x, 1, 1) == "@"), x)
	# get type, key and id
	refid <- x[substring(x[,2], 1, 1) == "@", 1]
	type <- substring(x[,2], 2, nchar(x[,2]) - 1)
	type <- strsplit(type[substring(x[,2], 1, 1) == "@"], "{", fixed=TRUE)
	type <- do.call(rbind, type)
	# skip comment fields
	type <- cbind(type, refid)
	type <- type[type[,1] != "Comment",]
	x <- x[x[,1] %in% type[,3],]
	# warn duplicated bibtexkeys
	if(any(duplicated(type[,3])))
		warning("Some duplicated values for 'bibtexkey' in 'x'.")
	# getting list of entry fields
	x <- x[grepl(" = ", x[,2], fixed=TRUE),]
	x <- cbind(x[,1], do.call(rbind, strsplit(x[,2], " = ", TRUE)))
	x[,2] <- trimws(x[,2], "both")
	x[,3] <- substring(x[,3], 2, nchar(x[,3]) - 2)
	fields <- unique(x[,2])
	# Output table
	new_x <- expand.grid(field=fields, refid=type[,3], stringsAsFactors=FALSE)
	new_x$value <- with(new_x, x[match(paste(refid, field, sep="_"),
							paste(x[,1], x[,2], sep="_")),3])
	new_x <- with(new_x, do.call(rbind, split(value, as.integer(refid))))
	colnames(new_x) <- fields
	colnames(type)[1:2] <- c("bib_type","bibtexkey")
	new_x <- cbind(type[,c("bib_type","bibtexkey")],
			new_x[match(type[,"refid"], rownames(new_x)),])
	# Defining S3 class
	new_x <- as.data.frame(new_x, stringsAsFactors=FALSE)
	class(new_x) <- c("lib_df", "data.frame")
	return(new_x)
}
