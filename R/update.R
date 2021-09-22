#' @name update
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
#' @param delete,add,update A character value indicating whether the action
#'     should be carried out. If all are 'FALSE', this function will just report
#'     differences as done by [compare_df].
#' @param ... Further arguments passed among methods.
#' 
#' @return 
#' Either an invisible output with a print in the console or an updated object
#' of class [lib_df-class].
#' 
#' @examples 
#' # modifying the data set iris
#' data(iris)
#' iris$id <- 1:nrow(iris) # ID column added
#' 
#' # rows to add using mean values per species
#' iris_mod <- aggregate(cbind(Sepal.Length, Sepal.Width, Petal.Length,
#'     Petal.Width) ~ Species, data = iris, FUN = mean)
#' iris_mod$id <- (1:nrow(iris_mod)) + nrow(iris)
#' iris_mod <- do.call(rbind, list(iris, iris_mod[ , colnames(iris)]))
#' 
#' # delete some entries
#' iris_mod <- iris_mod[-c(15, 75, 105, 145), ]
#' 
#' # modify entries
#' iris_mod$Petal.Length[c(20, 30)] <- 0
#' iris_mod$Petal.Width[c(20, 50)] <- 0
#' 
#' # just a comparison
#' update(iris, iris_mod, key = "id")
#' 
#' # do update
#' iris <- update(iris, iris_mod, key = "id", delete = TRUE, add = TRUE,
#'     update = TRUE)
#' 
#' @rdname update
#' 
#' @method update data.frame
#' @export
#' 
update.data.frame <- function(object, revision, key, delete = FALSE,
		add = FALSE, update = FALSE, ...) {
	if(class(revision)[1] != "data.frame")
		stop("Object 'revision' have to be a 'data.frame'.")
	update_report <- compare_df(x = object, y = revision, key = key)
	if(all(!c(delete, add, update)))
		print(update_report) else {
		# Add missing columns to 'revision'
		for(i in colnames(object)[!colnames(object) %in% colnames(revision)])
			revision[ , i] <- NA
		if(delete & length(update_report$deleted) > 0)
			object <- object[!object[ , key] %in% update_report$deleted, ]
		if(add & nrow(update_report$added) > 0)
			object <- do.call(rbind, list(object,
							revision[revision[ , key] %in%
											update_report$added[ , key],
									colnames(object)]))
		if(update & nrow(update_report$new_vals) > 0) {
			for(i in colnames(update_report$updated))
				object[match(rownames(update_report$new_vals),
								paste(object[ , key])), i] <-
						update_report$new_vals[ , i]
		}
		invisible(object)
	}
}

#' @rdname update
#' 
#' @method update lib_df
#' @export
#' 
update.lib_df <- function(object, revision, key = "bibtexkey", delete = FALSE,
		add = FALSE, update = FALSE, ...) {
	if(class(revision)[1] != "lib_df")
		stop("Object 'revision' have to be a 'lib_df' object.")
	if(all(!c(delete, add, update)))
		print(compare_df(x = object, y = revision, ...)) else {
		class(object) <- class(revision) <- "data.frame"
		object <- update(object = object, revision = revision, key = key,
				delete = delete, add = add, update = update, ...)
		class(object) <- c("lib_df", "data.frame")
		invisible(object)
	}
}

#' @rdname update
#' 
#' @aliases update<-
#' 
#' @exportMethod update<-
#' 
setGeneric("update<-", function(object, ..., value)
			standardGeneric("update<-"))

#' @rdname update
#' 
#' @aliases update<-,data.frame,data.frame-method
#' 
setReplaceMethod("update", signature(object = "data.frame",
				value = "data.frame"),
		function(object, key, delete = FALSE, add = FALSE, update = FALSE, ...,
				value) {
			if(all(!c(delete, add, update)))
				return(object) else
				update(object = object, revision = value, key = key,
						delete = delete, add = add, update = update, ...)
		})

#' @rdname update
#' 
#' @aliases update<-,lib_df,lib_df-method
#' 
setReplaceMethod("update", signature(object = "lib_df", value = "lib_df"),
		function(object, key = "bibtexkey", delete = FALSE, add = FALSE,
				update = FALSE, ..., value) {
			if(all(!c(delete, add, update)))
				return(object) else
				update(object = object, revision = value, key = key,
						delete = delete, add = add, update = update, ...)
		})
