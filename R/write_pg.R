#' @name write_pg
#' 
#' @title Writing References from Data Frame to a Postgres Table
#' 
#' @description 
#' This function implement the creation of a Postgres table and its population
#' with data imported by \code{\link{read_bib}}. To import data from a Postgres
#' table created by this function just use \code{\link{dbReadTable}}.
#' 
#' @param conn A connection established with \code{\link{dbConnect}}.
#' @param name A character vector with the names of the schema and the table.
#' @param value A data frame including the data to be inserted in the created
#'     table.
#' @param ... Further arguments passed to \code{\link{dbWriteTable}}.
#' 
#' @export 
write_pg <- function(conn, name, value, ...) {
	# TODO: Use S4 method for PostgreSQLConnection,character,data.frame
	# TODO: Files should be exported in a different table
	if(!"bibtexkey" %in% colnames(value))
		stop("The column 'bibtexkey' is mandatory in 'value'.")
	# TODO: Build a list of field names from the documentation (perhaps also comments)
	if(any(duplicated(value$bibtexkey)))
		stop("Duplicated values are not allowed in column 'bibtexkey'.")
	dbWriteTable(conn, name, value, ...)
	Query <- paste0("ALTER TABLE \"", paste(name, collapse="\".\""), "\"\n",
			"ADD PRIMARY KEY (bibtexkey);\n")
	dbSendQuery(conn, Query)
}
