#' @name update_pg
#' @aliases update_report
#' @rdname update_pg
#' 
#' @title Compare Bibtex-files with Postgres databases and update
#' 
#' @description 
#' When changes done in the Bibtex duplicated file, they can be briefly
#' displayed before export.
#' 
#' In `update_pg` actions 'delete', 'add', and 'update' have to be accordingly
#' set as `TRUE`, otherwise only `print_report()` will be executed.
#' 
#' @param db Either a data frame imported by [read_pg()] or a connection
#'     established by [dbConnect()] to a reference database.
#' @param bib Either a data frame imported by [read_bib()] or a path to a bibtex
#'     file. This data set represent an updated version of 'db'.
#' @param print_only Logical value indicating whether the outcome will be only
#'     printed in the console or stored as a list.
#' @param name Character value indicating the name of the schema in Postgres.
#'     This argument is passed to [read_pg()].
#' @param db_args List of named arguments passed to [read_pg()].
#' @param bib_args List of named arguments passed to [read_bib()].
#' @param get_files Logical value indicating whether a list of files should be
#'     extracted from 'bib' or not. If `TRUE`, then function [get_files()] will
#'     be applied.
#' @param main_table Character value indicating the name of main table in
#'     Postgres (see [read_pg()]).
#' @param file_list Character value indicating the name of file list table in
#'     Postgres (see [read_pg()]).
#' @param delete Logical value indicating whether missing entries in 'bib' have
#'     to be deleted in 'db'.
#' @param add Logical value indicating whether new entries in 'bib' have to be
#'     inserted in 'db'.
#' @param update Logical value indicating whether entries modified in 'bib' have
#'     to be updated in 'db'.
#' @param ... Further arguments passed among methods.
#' 
#' @exportMethod update_report
#' 
setGeneric("update_report",
		function(db, bib, ...)
			standardGeneric("update_report")
)

#' @rdname update_pg
#' @aliases update_report,lib_df,lib_df-method
#' 
setMethod("update_report", signature(db="lib_df", bib="lib_df"),
		function(db, bib, get_files=TRUE, print_only=TRUE, ...) {
			# Printing heads
			pr_head <- list()
			pr_head$main_table <- paste0(paste0(rep("#", times=40),
							collapse=""), "\n# MAIN TABLE ENTRIES\n",
					paste0(rep("#", times=40), collapse=""), "\n\n")
			pr_head$file_list <- paste0("\n", paste0(rep("#", times=40),
							collapse=""), "\n# FILE LIST ENTRIES\n",
					paste0(rep("#", times=40), collapse=""), "\n\n")
			# Getting file list
			if(get_files) {
				fl_1 <- get_files(db)
				fl_2 <- get_files(bib)
				db <- db[,colnames(db) != "file"]
				bib <- bib[,colnames(bib) != "file"]
			}
			# Comparing versions
			OUT <- list()
			OUT$main_table <- biblio:::compare_df(db, bib, "bibtexkey")
			if(get_files) {
				OUT$file_list <- biblio:::compare_df(fl_1, fl_2, "file")
			}
			if(print_only) {
				for(i in names(OUT)) {
					cat(pr_head[[i]])
					biblio:::print_comp(OUT[[i]])
					cat("\n")
				}
			} else return(OUT)
		})


# TODO: Adapt update_pg function

#' @rdname update_pg
#' @aliases update_pg
#' 
#' @exportMethod update_pg
#' 
setGeneric("update_pg",
		function(db, bib, ...)
			standardGeneric("update_pg")
)

#' @rdname update_pg
#' @aliases update_pg,PostgreSQLConnection,lib_df-method
#' 
setMethod("update_pg", signature(db="PostgreSQLConnection", bib="lib_df"),
		function(db, bib, name, db_args=list(), delete=FALSE, add=FALSE,
				update=FALSE, main_table="main_table", file_list="file_list",
				...) {
			db_tab <- do.call(read_pg, c(list(conn=db, name=name), db_args))
			if(all(c(delete, add, update) == FALSE)) {
				update_report(db_tab, bib)
			} else {
				db_fl <- get_files(db_tab)
				db_tab <- db_tab[,colnames(db_tab) != "file"]
				bib_fl <- get_files(bib)
				bib <- bib[,!colnames(bib) %in% c("file","journal")]
				Comp_mt <- biblio:::compare_df(db_tab, bib, "bibtexkey")
				Comp_fl <- biblio:::compare_df(db_fl, bib_fl, "file")
				if(add) {
					if(nrow(Comp_mt$added) > 0) {
						class(Comp_mt$added) <- "data.frame"
						pgInsert(db, c(name, main_table), Comp_mt$added, ...)
					}
					if(nrow(Comp_fl$added) > 0) {
						class(Comp_fl$added) <- "data.frame"
						pgInsert(db, c(name, file_list), Comp_fl$added, ...)
					}
				}
				if(delete) {
					if(length(Comp_fl$deleted) > 0)
						biblio:::sql_delete(db, Comp_fl, c(name, file_list),
								"file")
					if(length(Comp_mt$deleted) > 0)
						biblio:::sql_delete(db, Comp_mt, c(name, main_table),
								"bibtexkey")
				}
				if(update) {
					if(nrow(Comp_mt$updated) > 0) {
						for(i in colnames(Comp_mt$new_vals))
							Comp_mt$new_vals[,i] <- gsub("'", "''",
									Comp_mt$new_vals[,i], fixed=TRUE)
						biblio:::sql_update(db, Comp_mt, c(name, main_table),
								"bibtexkey")
					}
					if(nrow(Comp_fl$updated) > 0) {
						for(i in colnames(Comp_fl$new_vals))
							Comp_fl$new_vals[,i] <- gsub("'", "''",
									Comp_fl$new_vals[,i], fixed=TRUE)
						biblio:::sql_update(db, Comp_fl, c(name, file_list),
								"file")
					}
				}
			}
			if(any(c(add, delete, update)))
				message("DONE!")
		})


#' @rdname update_pg
#' @aliases update_pg,PostgreSQLConnection,character-method
#' 
setMethod("update_pg", signature(db="PostgreSQLConnection", bib="character"),
		function(db, bib, name, db_args=list(), bib_args=list(), ...) {
			bib <- do.call(read_bib, c(list(bib=bib), bib_args))
			update_pg(db, bib, name, db_args, ...)
		})
