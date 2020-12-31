# TODO: Function to validate url's
# TODO: Function to write doi url's

#' @name valid_file
#' 
#' @title Validation of files in database
#' 
#' @description 
#' List of local files are stored in an external folder. This function check the
#' existence of the mentioned files and also detect files stored in the folder
#' but not mentioned in the database.
#' 
#' @param folder A character value indicating the path to the folder containing
#'     reference files. Usually the folder set as *Main file directory* in the
#'     JabRef options.
#' @param df A data frame containing the file list (see [get_files()]).
#' @param ... Further arguments (not yet used).
#' 
#' @keywords internal
#' 
valid_file <- function(folder, df, ...) {
	Files <- list.files(folder)
	return(list(valid=intersect(Files, df$file),
					missing=df$file[!df$file %in% Files],
					not_in_db=Files[!Files %in% df$file]))
}


#' @name sql_delete
#' 
#' @title Write query and execute it for deleted entries
#' 
#' @param conn A connection established by [dbConnect()].
#' @param obj A comparison object created by `compare_df()`.
#' @param name A character vector with the names of schema and table in
#'     PostgreSQL.
#' @param key A character value. The name of the primary key in the table.
#' @param ... Further arguments (not yet used).
#' 
#' @keywords internal
#' 
sql_delete <- function(conn, obj, name, key, ...) {
	Query <- paste0("DELETE FROM \"",
			paste0(name, collapse="\".\""),
			"\"\n",
			"WHERE \"", key,"\" IN ('", paste0(obj$deleted, collapse="','"),
			"');")
	dbSendQuery(conn, Query)
}

#' @name sql_update
#' 
#' @title Write query and execute it for updates
#' 
#' @description 
#' For arguments, see `sql_delete()`.
#' 
#' @keywords internal
#' 
sql_update <- function(conn, obj, name, key, ...) {
	for(i in rownames(obj$updated)) {
		Query <- paste0("UPDATE \"", paste0(name, collapse="\".\""), "\"\n",
				"SET \"", with(obj,
						paste0(paste0(colnames(updated)[updated[i,]],
										"\" = '", new_vals[i,updated[i,]]),
								collapse="', \n\"")), "'\n",
				"WHERE \"", key, "\" = '", i, "';")
		dbSendQuery(conn, Query)
	}
}
