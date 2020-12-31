#' @name write_bib
#' 
#' @rdname write_bib
#' 
#' @title Write BibTeX Files
#' 
#' @description 
#' BibTeX databases can be created from data frames, interacting with Postgres
#' databases.
#' 
#' @param obj A data frame with bibliographic entries.
#' @param file A character value with the path and the name of the file to be
#'     written.
#' @param encoding Character value with the encoding (passed to
#'     \code{\link{file}}).
#' @param ... Further arguments passed to \code{\link{file}}.
#' 
#' @exportMethod write_bib
#' 
setGeneric("write_bib",
		function(obj, file, ...)
			standardGeneric("write_bib")
)

#' @rdname write_bib
#' 
#' @aliases write_bib,lib_df,character-method
#' 
setMethod("write_bib", signature(obj = "lib_df", file = "character"),
		function(obj, file, encoding = "UTF-8", ...) {
			# Entries as named characters
			Vars <- colnames(obj)
			obj <- split(as.matrix(obj), 1:nrow(obj))
			obj <- lapply(obj, function(x, n) {
						names(x) <- n
						x[!is.na(x)]
					}, Vars)
			# Final format
			obj <- lapply(obj, function(x) {
						prefix <- paste(" ", names(x), "= {")
						#rep("  {", length(x))
						prefix[1:2] <- c("@", "{")
						suffix <- rep("},\n", length(x))
						suffix[1:2] <- c("", ",\n")
						paste0(paste0(prefix, x, suffix, collapse=""), "}\n\n")
					})
			# Write file
			con <- file(file, "wb", encoding = encoding, ...)
			writeBin(charToRaw(paste0(c("% Encoding: ", encoding, "\n",
											unlist(obj)),
									collapse="")), con, endian="little")
			close(con)
		})
