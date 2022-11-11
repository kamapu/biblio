# TODO:   Add comment
# 
# Author: Miguel Alvarez
################################################################################

library(biblio)

setwd("lab")

Refs <- read_bib(x = file.path(
        path.package("biblio"),
        "LuebertPliscoff.bib"
    ))
Refs

reflist(Refs)

reflist(Refs, "reflists/my_refs",
    output = list(pdf_document = list(latex_engine = "xelatex")))

reflist(Refs, "reflists/my_refs2",
    output = list(pdf_document = list(latex_engine = "xelatex")),
    delete_source = FALSE)
