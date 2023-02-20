#' @name lib_df-class
#'
#' @title Electronic library
#'
#' @description
#' An S3 class for library entries. This class inherits properties from data
#' frames.
#'
#' @exportClass lib_df
setOldClass(c("lib_df", "data.frame"))

#' @name comp_df-class
#'
#' @title Compared libraries
#'
#' @description
#' An S3 class for compared data frames. A list containing added, deleted
#' entries on the regarding a key column and cells that are modified.
#'
#' @exportClass comp_df
setOldClass(c("comp_df", "list"))
