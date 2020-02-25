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
#' @param db Either a data frame imported by [read_pg()] or a connection
#'     established by [dbConnect()] to a reference database.
#' @param bib Either a data frame imported by [read_bib()] or a path to a bibtex
#'     file. This data set represent an updated version of 'db'.
#' @param print_only Logical value indicating whether the outcome will be only
#'     printed in the console or stored as a list.
#' @param db_args List of named arguments passed to [read_pg()].
#' @param bib_args List of named arguments passed to [read_bib()].
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
				bib="character"), function(db, bib, db_args=list(),
				bib_args=list(), ...) {
			db <- do.call(read_pg, c(list(conn=db), db_args))
			bib <- as.data.frame(do.call(read_bib, c(list(bib=bib), bib_args)),
					stringsAsFactors=FALSE)
			update_report(db, bib, ...)
		})
