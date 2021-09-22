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
#' @param x A `lib_df` object to produce the reference list. In the character
#'     method, a character value indicating the path of a bibtex file
#'     (passed to [biblio::read_bib()]).
#' @param filename A character value with the name for the written Rmd file,
#'     without file extension.
#' @param bib_file A character value with the name for the written bibtex file.
#'     In the lib_df method it can be omitted and will then named by
#'     [tempfile()]. In the character method it is not required.
#' @param delete_rmd A logical value indicating whether written Rmd file should
#'     be deleted after rendering html or not.
#' @param delete_bib A logical value indicating whether written bib file should
#'     be deleted after rendering html or not.
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
#' @return 
#' By default a html document with ta list of references. The output can be
#' modified to other options using **R-markdown** (see documentation for the
#' package [yamlme](https://kamapu.github.io/rpkg/yamlme/)).
#' 
#' @examples
#' \dontrun{
#' reflist(synopsis)
#' }
#' 
#' @exportMethod reflist
#' 
setGeneric("reflist",
		function(x, ...)
			standardGeneric("reflist")
)

#' @rdname reflist
#' 
#' @aliases reflist,lib_df-method
#' 
setMethod("reflist", signature(x = "lib_df"),
		function(x, filename = "references", bib_file, delete_rmd = FALSE,
				delete_bib = delete_rmd, browse_file = TRUE,
				title = "Automatic Reference List", output = "html_document",
				nocite = "'@*'", urlcolor = "blue", encoding = "UTF-8", ...) {
			# write bib file
			if(missing(bib_file))
				bib_file <- tempfile(pattern = "ref", tmpdir = ".",
						fileext = ".bib")
			N <- nchar(bib_file)
			if(substring(tolower(bib_file), N - 3, N) != ".bib")
				bib_file <- paste0(bib_file, ".bib")
			biblio::write_bib(x = x, file = bib_file, encoding = encoding)
			# write Rmd file
			filename <- paste0(filename, ".Rmd")
			rmd_document <- write_rmd(title = title, output = output,
					bibliography = bib_file, nocite = nocite,
					urlcolor = urlcolor, filename = filename, ...)
			# render file
			render_rmd(input = filename)
			# delete intermediary files
			w_files <- c(filename, bib_file)
			if(delete_rmd) {
				file.remove(filename)
				w_files <- w_files[w_files != filename]
			}
			if(delete_bib) {
				file.remove(bib_file)
				w_files <- w_files[w_files != bib_file]
			}
			# message for intermediary files
			if(length(w_files) > 0)
				message(paste0("\n## Intermediary files:\n   ", paste0(w_files,
										collapse = "\n   "), "\n"))
			# open the result
			if(browse_file)
				browseURL(url = gsub(".Rmd", ".html", filename))
			# return rmd_doc xect if necessary
			invisible(rmd_document)
		})

#' @rdname reflist
#' 
#' @aliases reflist,character-method
#' 
setMethod("reflist", signature(x = "character"),
		function(x, filename = "references", ...) {
			# Exchange arguments
			bib_file <- x
			N <- nchar(bib_file)
			if(substring(tolower(bib_file), N - 3, N) != ".bib")
				bib_file <- paste0(bib_file, ".bib")
			x <- biblio::read_bib(bib_file)
			# Execute lib_df method
			reflist(x = x, filename = filename, bib_file = bib_file,
					delete_bib = FALSE, ...)
		})
