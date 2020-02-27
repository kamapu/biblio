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
#' @aliases update_report,data.frame,data.frame-method
#' 
setMethod("update_report", signature(db="data.frame", bib="data.frame"),
		function(db, bib, print_only=TRUE, ...) {
			OUT <- list()
			OUT$deleted <- with(db, bibtexkey[!bibtexkey %in% bib$bibtexkey])
			OUT$added <- with(bib, bibtexkey[!bibtexkey %in% db$bibtexkey])
			OUT$updated <- list()
			common_keys <- intersect(db$bibtexkey, bib$bibtexkey)
			common_cols <- intersect(colnames(db), colnames(bib))
			common_cols <- common_cols[common_cols != "bibtexkey"]
			for(i in common_cols) {
				tmp1 <- with(bib, get(i)[match(common_keys, bibtexkey)])
				tmp2 <- with(db, get(i)[match(common_keys, bibtexkey)])
				tmp2 <- !((tmp1 == tmp2) | (is.na(tmp1) & is.na(tmp2)))
				tmp2[is.na(tmp2)] <- TRUE
				if(any(tmp2))
					OUT$updated[[i]] <- tmp2 else next
			}
			if(length(OUT$updated) > 0) {
				OUT$updated <- do.call(cbind, OUT$updated)
				rownames(OUT$updated) <- common_keys
				OUT$updated <- OUT$updated[apply(OUT$updated, 1,
								function(x) any(x)),,drop=FALSE]
			}
			if(print_only) {
				if(length(OUT$deleted) > 0)
					cat(paste0("## deleted entries (", length(OUT$deleted),
									"):\n'",
									paste0(OUT$deleted, collapse="' '"),
									"'\n\n"))
				if(length(OUT$added) > 0)
					cat(paste0("## added entries (", length(OUT$added),
									"):\n'",
									paste0(OUT$added, collapse="' '"),
									"'\n\n"))
				if(length(OUT$updated) > 0)
					for(i in rownames(OUT$updated)) {
						cat(paste0("## ", i, ":\n"))
						for(j in colnames(OUT$updated)[OUT$updated[i,]]) {
							cat(paste0("old ", j, ": ", db[db$bibtexkey == i,j],
											"\nnew ", j, ": ",
											bib[bib$bibtexkey == i,j], "\n\n"))
						}
					}
				if(sum(sapply(OUT, length)) == 0)
					cat("## no changes detected\n")
			} else {
				return(OUT)
			}
		})

#' @rdname update_pg
#' @aliases update_report,PostgreSQLConnection,character-method
#'
setMethod("update_report", signature(db="PostgreSQLConnection",
				bib="character"), function(db, bib, name, db_args=list(),
				bib_args=list(), ...) {
			db <- do.call(read_pg, c(list(conn=db, name=name), db_args))
			bib <- do.call(read_bib, c(list(bib=bib), bib_args))
			update_report(db, bib, ...)
		})

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
#' @aliases update_pg,PostgreSQLConnection,data.frame-method
#' 
setMethod("update_pg", signature(db="PostgreSQLConnection", bib="data.frame"),
		function(db, bib, name, db_args=list(), get_files=TRUE, delete=FALSE,
				add=FALSE, update=FALSE, main_table="main_table",
				file_list="file_list", ...) {
			db_tab <- do.call(read_pg, c(list(conn=db, name=name), db_args))
			if(all(c(delete, add, update) == FALSE)) {
				update_report(db_tab, bib)
			} else {
				Comp <- update_report(db_tab, bib, print_only=FALSE)
				if(delete & (length(Comp$deleted) > 0)) {
					Query <- paste0("DELETE FROM \"", name, "\".\"",
							file_list, "\"\n",
							"WHERE bibtexkey IN ('",
							paste0(Comp$deleted, collapse="','"),
							"');\n")
					dbSendQuery(db, Query)
					Query <- paste0("DELETE FROM \"", name, "\".\"",
							main_table, "\"\n",
							"WHERE bibtexkey IN ('",
							paste0(Comp$deleted, collapse="','"),
							"');\n")
					dbSendQuery(db, Query)
				}
				if(add & (length(Comp$added) > 0)) {
					to_add <- bib[bib$bibtexkey %in% Comp$added,]
					Query <- paste0("SELECT column_name\n",
							"FROM information_schema.columns\n",
							"WHERE table_schema = '", name, "'\n",
							"AND table_name = '", main_table,"';\n")
					column_names <- unlist(dbGetQuery(db, Query))
					to_add <- to_add[,colnames(to_add) %in% column_names]
					if(get_files) {
						new_files <- get_files(to_add)
						pgInsert(db, c(name, main_table),
								to_add[,colnames(to_add) != "file"])
						pgInsert(db, c(name, file_list), new_files)
					} else pgInsert(db, c(name, main_table), to_add)
				}
				if(update & (length(Comp$updated) > 0)) {
					if(get_files) {
						new_files <- rownames(Comp$updated)[Comp$updated[,
										"file", drop=TRUE]]
						new_files <- bib[bib$bibtexkey %in% new_files,]
						new_files <- get_files(new_files)
						old_files <- unlist(dbGetQuery(db,
										paste0("SELECT file FROM \"", name,
												"\".\"", file_list,"\";")))
						new_files <- new_files[!new_files$file %in% old_files,]
						pgInsert(db, c(name, file_list), new_files)
						if(ncol(Comp$updated) > 1) {
							Comp$updated <- Comp$updated[,
									colnames(Comp$updated) != "file",
									drop=FALSE]
							Comp$updated <- Comp$updated[
									rowSums(Comp$updated) > 0,,drop=FALSE]
						} else Comp$updated <- list()
					}
					if(length(Comp$updated) > 0) {
						for(i in rownames(Comp$updated)) {
							new_entries <-
									colnames(Comp$updated)[Comp$updated[i,]]
							new_values <- bib[bib$bibtexkey == i, new_entries]
							new_values <- gsub("'", "''", new_values)
							new_values <- paste0("\"", new_entries,"\" = '",
									new_values, "'")
							new_values <- paste0(new_values, collapse=" AND ")
							Query <- paste0("UPDATE \"", name, "\".\"",
									main_table, "\"\n",
									"SET ", new_values, "\n",
									"WHERE bibtexkey = '", i, "';\n")
							dbSendQuery(db, Query)
						}
					}
					
				}
			}
			if(any(c(delete, add, update)))
				message("DONE!")
		}
)

#' @rdname update_pg
#' @aliases update_pg,PostgreSQLConnection,character-method
#' 
setMethod("update_pg", signature(db="PostgreSQLConnection", bib="character"),
		function(db, bib, name, db_args=list(), bib_args=list(), ...) {
			bib <- do.call(update_pg, c(bib, bib_args))
			update_pg(db, bib, name, db_args, ...)
		})
