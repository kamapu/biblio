#' @name write_pg
#' 
#' @title Writing References from Data Frame to a Postgres Table
#' 
#' @description 
#' This function implement the creation of a Postgres table and its population
#' with data imported by [read_bib()]. To import data from a Postgres
#' table created by this function just use [dbReadTable()].
#' 
#' @param conn A connection established with [dbConnect()].
#' @param name A character vector with the names of the schema and the table.
#' @param df1 A data frame with the content for the main table.
#' @param df2 A data frame with the content for the file table.
#' @param main_table A character value indicating the name of the main table in
#'     the database.
#' @param file_list A character value indicating the name of the file list in
#'     the database.
#' @param overwrite A logical value indicating whether existing tables should be
#'     overwritten or not.
#' @param ... Further arguments passed to pgInsert.
#' 
#' @export write_pg
#' 
write_pg <- function(conn, name, df1, df2, main_table="main_table",
		file_list="file_list", overwrite=FALSE, ...) {
	# Create Schema if missing
	Query <- paste0("SELECT EXISTS(SELECT 1 FROM pg_namespace", "\n",
			"WHERE nspname = '", name,"');\n")
	EX <- unlist(dbGetQuery(conn, Query))
	if(!EX) {
		Query <- paste0("CREATE SCHEMA \"", name, "\";")
		dbSendQuery(conn, Query)
	}
	# Check existence of file list
	Query <- paste0("SELECT EXISTS (\n",
			"SELECT FROM information_schema.tables\n",
			"WHERE table_schema = '", name,"'\n",
			"AND table_name = '", file_list,"'\n",
			");\n")
	EX <- unlist(dbGetQuery(conn, Query))
	if(EX & !overwrite)
		stop(paste0("Table '", file_list, "' already exists. ",
						"Consider option 'overwrite=TRUE'."))
	if(EX & overwrite) {
		warning(paste0("Table '", file_list, "' already exists ",
						"and will be overwritten."))
		Query <- paste0("DROP TABLE \"", name, "\".\"", file_list, "\";\n")
		dbSendQuery(conn, Query)
	}
	# Check existence of main table
	Query <- paste0("SELECT EXISTS (\n",
			"SELECT FROM information_schema.tables\n",
			"WHERE table_schema = '", name,"'\n",
			"AND table_name = '", main_table,"'\n",
			");\n")
	EX <- unlist(dbGetQuery(conn, Query))
	if(EX & !overwrite)
		stop(paste0("Table '", main_table, "' already exists. ",
						"Consider option 'overwrite=TRUE'."))
	if(EX & overwrite) {
		warning(paste0("Table '", main_table, "' already exists ",
						"and will be overwritten."))
		Query <- paste0("DROP TABLE \"", name, "\".\"", main_table, "\";\n")
		dbSendQuery(conn, Query)
	}
	# Writing tables
	suppressMessages(desc_tab <- read_ods(file.path(path.package("biblio"),
							"fields_list.ods"), "main_table"))
	desc_tab <- desc_tab[desc_tab$field != "file",]
	suppressMessages(desc_fl <- read_ods(file.path(path.package("biblio"),
							"fields_list.ods"), "file_list"))
	message("Creating tables...")
	# Main table
	Query <- with(desc_tab, {
				field2 <- rep("TEXT", length(field))
				field2[field == "bibtexkey"] <- "TEXT PRIMARY KEY"
				field2 <- paste0("\"", field, "\" ", field2)
				paste0(field2, collapse=",\n")
			})
	Query <- paste0("CREATE TABLE \"", name, "\".\"", main_table, "\" (\n",
			Query, "\n);\n")
	dbSendQuery(conn, Query)
	# Comments on main table
	with(desc_tab, {
				for(i in 1:length(field)) {
					Query <- paste0("COMMENT ON COLUMN \"", name, "\".\"",
							main_table, "\".\"", field[i], "\"\nIS '",
							description[i], "';\n")
					dbSendQuery(conn, Query)
				}
			})
	# File list
	Query <- with(desc_fl, {
				field2 <- rep("TEXT", length(field))
				field2[field == "file"] <- "TEXT PRIMARY KEY"
				field2 <- paste0("\"", field, "\" ", field2)
				paste0(field2, collapse=",\n")
			})
	Query <- paste0("CREATE TABLE \"", name, "\".\"", file_list, "\" (\n",
			Query, "\n);\n")
	dbSendQuery(conn, Query)
	# Comments on file list
	with(desc_fl, {
				for(i in 1:length(field)) {
					Query <- paste0("COMMENT ON COLUMN \"", name, "\".\"",
							file_list, "\".\"", field[i], "\"\nIS '",
							description[i], "';\n")
					dbSendQuery(conn, Query)
				}
			})
	# Inserting data
	message("Inserting data...")
	pgInsert(conn, c(name, main_table), df1, ...)
	pgInsert(conn, c(name, file_list), df2, ...)
	message("DONE!")
}
