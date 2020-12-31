#' @name lib_df-class
#' 
#' @title Class containing library entries
#' 
#' @description 
#' An S3 class for library entries.
#' 
#' @exportClass lib_df
#' 
setOldClass(c("lib_df", "data.frame"))

#' @name comp_df-class
#' 
#' @title Comparison between two data frames
#' 
#' @description 
#' An S3 class for compared data frames.
#' 
#' @exportClass comp_df
#' 
setOldClass(c("comp_df", "list"))
