#' @name read_bib
#' 
#' @title Read BibTeX Databases
#' 
#' @description 
#' Reading BibTeX databases and importing into R as a data frame. All the fields
#' will be inserted as character values.
#' 
#' @param x Path to BibTeX file.
#' @param ... Further arguments passed to [readLines()].
#' 
#' @return 
#' An object of class [lib_df-class].
#' 
#' @examples
#' Refs <- read_bib(x = file.path(path.package("biblio"),
#'   "LuebertPliscoff.bib"))
#' Refs
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
	# skip comment Notice
	type <- cbind(type, refid)
	type <- type[type[,1] != "Comment",]
	x <- x[x[,1] %in% type[,3],]
	# warn duplicated bibtexkeys
	if(any(duplicated(type[,3])))
		warning("Some duplicated values for 'bibtexkey' in 'x'.")
	# getting list of entry fields
	x <- x[substr(x[ , 2], 1, 1) != "@" & substr(x[ , 2], 1, 1) != "}", ]
	x[ , 2] <- gsub("\\s+", " ", str_trim(x[ , 2]))
	## x[,2] <- trimws(x[,2], "both")
	Content <- strsplit(x[ , 2], " = {", fixed = TRUE)
	Content <- lapply(Content, function(x) {
				if(length(x) == 1)
					x <- c(NA, x)
				return(x)
			})
	Content <- cbind(x[ , 1], do.call(rbind, Content))
	# Fill NAs forward (Stack Overflow: 7735647)
	Content[ , 2] <- c(NA, na.omit(Content[ , 2]))[cumsum(!is.na(Content[ ,
									2])) + 1]
	# Skip trailing field symbol
	idx <- substr(Content[ , 3], nchar(Content[ , 3]) - 1,
			nchar(Content[ , 3])) == "},"
	Content[idx, 3] <- substr(Content[idx, 3], 1, nchar(Content[idx, 3]) - 2)
	# Aggregate for multiple lines entries
	Content <- as.data.frame(Content, stringsAsFactors = FALSE)
	colnames(Content) <- c("refid", "field", "value")
	Content <- aggregate(value ~ refid + field, data = Content,
			FUN = function(x) paste0(x, collapse = "\n"))
	# Output table
	fields <- unique(Content$field)
	new_x <- expand.grid(field = fields, refid = type[ , 3],
			stringsAsFactors = FALSE)
	new_x$value <- with(new_x, Content[match(paste(refid, field, sep = "_"),
							paste(Content$refid, Content$field, sep = "_")), 3])
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
