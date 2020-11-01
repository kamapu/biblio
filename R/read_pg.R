#' @name read_pg
#' @rdname read_pg
#' 
#' @title Read bibliographic databases from PostgreSQL
#' 
#' @description 
#' Databases tabulated in PostgreSQL will be imported in a data frame.
#' 
#' @param conn A database connection established with [dbConnect()] or
#'     [dbaccess::connect_db2()].
#' @param name Name of the database corresponding to a schema in the PostgreSQL
#'     database.
#' @param main_table A character value indicating the name of the main table in
#'     in the schema 'name'.
#' @param file_list A character value indicating the name of the table in schema
#'     'name', which contains the names of the files and the respective
#'     attributes.
#' @param add_files Logical value indicating whether information in table
#'     'file_list' should be appended to the output or not.
#' @param ... Further arguments passed among methods.
#' 
#' @exportMethod read_pg
#' 
setGeneric("read_pg",
		function(conn, name, ...)
			standardGeneric("read_pg")
)

#' @rdname read_pg
#' @aliases read_pg,PostgreSQLConnection,character-method
#' 
setMethod("read_pg", signature(conn="PostgreSQLConnection", name="character"),
		function(conn, name, main_table="main_table", file_list="file_list",
				add_files=TRUE, ...) {
			Refs <- dbReadTable(conn, c(name, main_table))
			if(add_files) {
				Files <- dbReadTable(conn, c(name, file_list))
				add_files(Refs) <- Files
			}
			class(Refs) <- c("lib_df", "data.frame")
			return(Refs)
		})
