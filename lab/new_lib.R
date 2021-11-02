#' @name new_lib
#' 
#' @title Creates empty reference list
#' 
#' @description 
#' A empty reference list will be created using a installed list of standard
#' column names for BibTeX databases. The columns can be customized by setting
#' an argument to the parameter `cols`.
#' 
#' @param cols A character vector including the names for the columns in the new
#'     reference list.
#' 
#' @export new_lib
#' 
new_lib <- function(cols) {
	if(missing(cols))
		# TODO: this will be imported from a csv-table
		cols <- read_ods(file.path(path.package("biblio"),
									"fields_list.ods"), "main_table")$field
	DB <- list()
	for(i in cols) DB[[i]] <- character(0)
	class(DB) <- c("lib_df", "data.frame")
	return(DB)
}
