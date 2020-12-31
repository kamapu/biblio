
#' @name compare_df
#' 
#' @title Compare data frames
#' 
#' @description 
#' Detect changes between two versions of a data frame.
#' 
#' @param df1 The reference data frame.
#' @param df2 The updated data frame.
#' @param key A character value with the name of the variable used as primary
#'     key in the tables.
#' 
#' @keywords internal
#' 
compare_df <- function(df1, df2, key) {
	common_cols <- intersect(colnames(df1), colnames(df2))
	if(!setequal(colnames(df1), colnames(df2)))
		warning(paste("Mismatching columns in input data frames.",
						"Only common variables will be compared"))
	if(!key %in% intersect(colnames(df1), colnames(df2)))
		stop(paste("The value of 'key' is missing in the columns of one",
						"or all input data frames."))
	if(any(duplicated(df1[,key])))
		stop(paste("Duplicated key values found in 'df1'."))
	if(any(duplicated(df2[,key])))
		stop(paste("Duplicated key values found in 'df2'."))
	# Now the comparison
	rownames(df1) <- paste(df1[,key])
	rownames(df2) <- paste(df2[,key])
	common_keys <- intersect(df1[,key], df2[,key])
	added <- df2[!df2[,key] %in% common_keys,]
	deleted <- df1[!df1[,key] %in% common_keys, key]
	# Updates
	common_cols <- common_cols[common_cols != key]
	# Function to handle NAs in comparisons
	compareNA <- function(x,y) {
		same <- (x == y) | (is.na(x) & is.na(y))
		same[is.na(same)] <- FALSE
		return(!same)
	}
	df1 <- df1[paste(common_keys),common_cols]
	df2 <- df2[paste(common_keys),common_cols]
	updated <- df1
	for(i in common_cols)
		updated[,i] <- compareNA(df1[,i], df2[,i])
	updated <- as.matrix(updated)
	row_sums <- rowSums(updated)
	col_sums <- colSums(updated)
	return(list(added=added, deleted=deleted,
					updated=updated[row_sums > 0,col_sums > 0,drop=FALSE],
					old_vals=df1[row_sums > 0,col_sums > 0,drop=FALSE],
					new_vals=df2[row_sums > 0,col_sums > 0,drop=FALSE]))
}

#' @name print_comp
#' 
#' @title Print output of comparison
#' 
#' @description 
#' Report changes after update tables.
#' 
#' @param comp A list. The output generated by the function `compare_df()`.
#' 
#' @keywords internal
#' 
print_comp <- function(comp) {
	if(length(comp$deleted) > 0)
		cat(paste0("## deleted entries (", length(comp$deleted),
						"):\n'",
						paste0(comp$deleted, collapse="' '"),
						"'\n\n"))
	if(nrow(comp$added) > 0)
		cat(paste0("## added entries (", nrow(comp$added),
						"):\n'",
						paste0(rownames(comp$added), collapse="' '"),
						"'\n\n"))
	if(nrow(comp$updated) > 0)
		for(i in rownames(comp$updated)) {
			cat(paste0("## updates in entry '", i, "':\n"))
			for(j in colnames(comp$updated)[comp$updated[i,]]) {
				cat(paste0("old ", j, ": ", comp$old_vals[i,j], "\nnew ", j,
								": ", comp$new_vals[i,j], "\n\n"))
			}
		}
	if((length(comp$deleted) == 0) & (nrow(comp$added) == 0) &
			(nrow(comp$updated) == 0))
		cat("## no changes detected\n")
}