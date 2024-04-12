# TODO:   Add comment
# 
# Author: Miguel Alvarez
################################################################################

library(biblio)

Bib <- read_bib(x = file.path(path.package("biblio"),
        "LuebertPliscoff.bib"))

bib2bibentry(Bib[1:5, ])
