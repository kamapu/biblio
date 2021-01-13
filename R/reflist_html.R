# TODO:   Add comment
# 
# Author: Miguel Alvarez
################################################################################



setGeneric("reflist",
		function(obj, ...)
			standardGeneric("reflist")
)


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

setMethod("reflist", signature(obj = "character"),
		function(obj, filename, bib_file, ...) {
			# Exchange arguments
			bib_file <- obj
			obj <- biblio::read_bib(obj)
			# Execute lib_df method
			reflist(obj = obj, filename = filename, bib_file = bib_file,
					delete_files = FALSE, ...)
		})
