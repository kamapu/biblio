#' @name insert_rows
#' @title Insert new rows in a data frame
#' @keywords internal
insert_rows <- function(x, y) {
  for (i in colnames(y)[!colnames(y) %in% colnames(x)]) {
    x[, i] <- NA
  }
  for (i in colnames(x)[!colnames(x) %in% colnames(y)]) {
    y[, i] <- NA
  }
  x <- do.call(rbind, list(x, y[, colnames(x)]))
  return(x)
}

#' @name update_data
#'
#' @title Update data frames
#'
#' @description
#' This function compares two versions of the same data frame and detect changes
#' as additions, deleted entries or updates (modified entries).
#'
#' A method to compare [lib_df-class] objects is also provided as well as a
#' replace method.
#'
#' @param object A data frame or a [lib_df-class] object representing the
#'     original version.
#' @param revision The updated version of 'object' to be compared.
#' @param value The updated version of 'object' in the replace methods.
#' @param key A character value indicating the column used as identifier. This
#'     variable have to be in both versions otherwise this function will
#'     retrieve an error.
#' @param delete,add,update Logical value indicating whether the action
#'     should be carried out. If all are `'FALSE'`, this function will just
#'     report differences as done by [compare_df].
#' @param ... Further arguments passed among methods.
#'
#' @return
#' Either an invisible output with a print in the console or an updated object
#' of class [lib_df-class].
#'
#' @example examples/update_data.R
#'
#' @rdname update_data
#' @exportMethod update_data
setGeneric("update_data", function(object, revision, key, ...) {
  standardGeneric("update_data")
})

#' @rdname update_data
#' @aliases update_data,data.frame,data.frame,character-method
setMethod(
  "update_data", signature(
    object = "data.frame",
    revision = "data.frame", key = "character"
  ),
  function(object, revision, key, add = FALSE, delete = FALSE, update = FALSE,
           ...) {{ if (class(revision)[1] != "data.frame") {
    stop("Object 'revision' have to be a 'data.frame'.")
  }
  update_report <- compare_df(x = object, y = revision, key = key)
  if (all(!c(delete, add, update))) {
    print(update_report)
  } else {
    if (delete) {
      object <- object[
        !object[[key]] %in% update_report$deleted,
        !names(object) %in% update_report$deleted_vars
      ]
    }
    if (add) {
      if (length(update_report$added) > 0) {
        object <- insert_rows(object, revision[revision[[key]] %in%
          update_report$added, ])
      }
      if (length(update_report$added_vars) > 0) {
        for (i in update_report$added_vars) {
          object[, i] <- revision[[i]][match(
            object[[key]],
            revision[[key]]
          )]
        }
      }
    }
    if (update) {
      if (sum(dim(update_report$updated)) > 0) {
        for (i in colnames(update_report$updated)) {
          object[match(
            rownames(update_report$new_vals),
            paste(object[, key])
          ), i] <-
            update_report$new_vals[, i]
        }
      }
    }
    invisible(object)
  } }}
)

#' @rdname update_data
#' @aliases update_data,lib_df,lib_df,character-method
setMethod(
  "update_data", signature(
    object = "lib_df",
    revision = "lib_df", key = "missing"
  ),
  function(object, revision, key, ...) {
    return(update_data(object, revision, key = "bibtexkey", ...))
  }
)

#' @rdname update_data
#' @aliases update_data<-
#' @exportMethod update_data<-
setGeneric("update_data<-", function(object, key, ..., value) {
  standardGeneric("update_data<-")
})

#' @rdname update_data
#' @aliases update_data<-,data.frame,character,data.frame-method
setReplaceMethod(
  "update_data", signature(
    object = "data.frame",
    key = "character",
    value = "data.frame"
  ),
  function(object, key, ..., value) {
    return(update_data(object, value, key, ...))
  }
)

#' @rdname update_data
#' @aliases update_data<-,lib_df,missing,lib_df-method
setReplaceMethod(
  "update_data", signature(
    object = "lib_df", key = "missing",
    value = "lib_df"
  ),
  function(object, key, ..., value) {
    return(update_data(object, value, key = "bibtexkey", ...))
  }
)
