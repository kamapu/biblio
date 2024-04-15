# TODO:   Add comment
# 
# Author: Miguel Alvarez
################################################################################

library(biblio)

Bib <- read_bib(x = file.path(path.package("biblio"),
        "LuebertPliscoff.bib"))

x <- bib2bibentry(Bib[1:5, ])

# Back to bib
y <- capture.output(print(x, "bibtex"))

cat(paste0(y, collapse = "\n"))

