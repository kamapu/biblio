#' @name compare_df
#' 
#' @rdname compare_df
#' 
#' @title Compare data frames
#' 
#' @description 
#' Detect changes between two versions of a data frame.
#' 
#' @param x The reference data frame.
#' @param y The updated data frame.
#' @param key A character value with the name of the variable used as primary
#'     key in the tables.
#' @param ... Further arguments passed among methods.
#' 
#' @exportMethod compare_df
#' 
setGeneric("compare_df",
		function(x, y, key, ...)
			standardGeneric("compare_df")
)

#' @rdname compare_df
#' 
#' @aliases compare_df,data.frame,data.frame,character-method
#' 
setMethod("compare_df", signature(x = "data.frame", y = "data.frame",
				key = "character"), function(x, y, key, ...) {
			# Compare variables in data frames
			common_cols <- intersect(colnames(x), colnames(y))
			if(!setequal(colnames(x), colnames(y)))
				warning(paste("Mismatching columns in input data frames.",
								"Only common variables will be compared"))
			# Other checks
			if(!key %in% common_cols)
				stop(paste("The value of 'key' is missing in the columns",
								"of at least one input data frames."))
			if(any(duplicated(x[ ,key])))
				stop(paste("Duplicated key values found in 'x'."))
			if(any(duplicated(y[ ,key])))
				stop(paste("Duplicated key values found in 'y'."))
			# Compare entries
			rownames(x) <- paste(x[ ,key])
			rownames(y) <- paste(y[ ,key])
			common_keys <- intersect(x[ ,key], y[ ,key])
			added <- y[!y[ ,key] %in% common_keys, ]
			deleted <- x[!x[ ,key] %in% common_keys, key]
			# Updates
			common_cols <- common_cols[common_cols != key]
			# Function to handle NAs in comparisons
			compareNA <- function(x, y) {
				same <- (x == y) | (is.na(x) & is.na(y))
				same[is.na(same)] <- FALSE
				return(!same)
			}
			x <- x[paste(common_keys), common_cols]
			y <- y[paste(common_keys), common_cols]
			updated <- x
			for(i in common_cols)
				updated[ ,i] <- compareNA(x[ ,i], y[, i])
			updated <- as.matrix(updated)
			row_sums <- rowSums(updated)
			col_sums <- colSums(updated)
			OUT <- list(added = added, deleted = deleted,
					updated = updated[row_sums > 0, col_sums > 0, drop = FALSE],
					old_vals = x[row_sums > 0,col_sums > 0, drop = FALSE],
					new_vals = y[row_sums > 0,col_sums > 0,drop=FALSE])
			class(OUT) <- c("comp_df", "list")
			return(OUT)
		})

#' @rdname compare_df
#' 
#' @aliases compare_df,lib_df,lib_df,missing-method
#' 
setMethod("compare_df", signature(x = "lib_df", y = "lib_df",
				key = "missing"), function(x, y, ...) {
			key <- "bibtexkey"
			class(x) <- "data.frame"
			class(y) <- "data.frame"
			compare_df(x = x, y = y, key = key, ...)
		})
