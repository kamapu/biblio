# TODO:   Add comment
# 
# Author: Miguel Alvarez
################################################################################

library(biblio)

Bib <- read_bib(x = file.path(path.package("biblio"),
        "LuebertPliscoff.bib"))


as(Bib[1:5, ], "data.frame")

as(Bib[1:5, ], "bibentry")
