## Read installed r-markdown document
my_document <- readLines(file.path(path.package("biblio"), "document.Rmd"))

## Screen for citations
cited_refs <- detect_keys(my_document)
cited_refs
