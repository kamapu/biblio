#' @name reflist
#' 
#' @rdname reflist
#' 
#' @title Write a Reference List in HTML
#' 
#' @description 
#' A fast way to produce a reference list in an html document from a `lib_df`
#' object.
#' 
#' This function may or may not produce intermediate files (bib and Rmd) and the
#' result can be assigned to an object for further edition
#' (see [yamlme::update()]).
#' 
#' A html file will be written by [write_rmd()] and [render_rmd()] in the
#' working directory and displayed by [browseURL()].
#' 
#' @param obj A `lib_df` object to produce the reference list. In the character
#'     method, a character value indicating the path of a bibtex file
#'     (passed to [biblio::read_bib()]).
#' @param filename A character value with the name for the written Rmd file,
#'     without file extension.
#' @param bib_file A character value with the name for the written bibtex file,
#'     including extension (.bib). In the lib_df method it can be omitted and
#'     will then named by [tempfile()]. In the character method it is not
#'     required.
#' @param delete_files A logical value indicating whether written files (Rmd
#'     and bibtex) should be deleted after rendering or not.
#' @param browse_file A logical value indicating whether the resulting html file
#'     should be opened in a browser or not.
#' @param encoding A character value indicating the encoding string. It is
#'     passed to [biblio::write_bib()].
#' @param title,output,nocite,urlcolor Arguments used for the yaml-header in
#'     r-markdown and passed to [write_rmd()]. They can be cancelled using the
#'     value NULL (not recommended for nocite).
#' @param ... Further arguments passed to [write_rmd()] by the lib_df method, or
#'     to the lib_df method by the character method.
#' 
#' @exportMethod reflist
#' 
setGeneric("reflist",
		function(obj, ...)
			standardGeneric("reflist")
)

#' @rdname reflist
#' 
#' @aliases reflist,lib_df-method
#' 
setMethod("reflist", signature(obj = "lib_df"),
		function(obj, filename, bib_file, delete_files = TRUE,
				browse_file = TRUE,
				title = "Automatic Reference List",
				output = "html_document", nocite = "'@*'", urlcolor = "blue",
				encoding = "UTF-8", ...) {
			# write bib file
			if(missing(bib_file))
				bib_file <- tempfile(pattern = "ref", tmpdir = ".",
						fileext = ".bib")
			biblio::write_bib(obj = obj, file = bib_file, encoding = encoding)
			# write Rmd file
			filename <- paste0(filename, ".Rmd")
			rmd_document <- write_rmd(title = title, output = output,
					bibliography = bib_file, nocite = nocite,
					urlcolor = urlcolor, filename = filename, ...)
			# render file
			render_rmd(input = filename)
			# delete intermediary files
			if(delete_files) {
				file.remove(filename)
				file.remove(bib_file)
			} else
				message(paste0("\n## Intermediary files:\n   ", filename,
								"\n   ", bib_file, "\n"))
			# open the result
			if(browse_file)
				browseURL(url = gsub(".Rmd", ".html", filename))
			# return rmd_doc object if necessary
			invisible(rmd_document)
		})

#' @rdname reflist
#' 
#' @aliases reflist,character-method
#' 
setMethod("reflist", signature(obj = "character"),
		function(obj, filename, bib_file, ...) {
			# Exchange arguments
			bib_file <- obj
			obj <- biblio::read_bib(obj)
			# Execute lib_df method
			reflist(obj = obj, filename = filename, bib_file = bib_file,
					delete_files = FALSE, ...)
		})
