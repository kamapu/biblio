# TODO:   Add comment
# 
# Author: Miguel Alvarez
################################################################################


library(biblio)

single_entry <- function(x) do.call(bibentry, as.list(x))

bib <- read_bib(x = file.path(path.package("biblio"),
        "LuebertPliscoff.bib"))

be2 <- sapply(split(bib, seq_along(bib$bibtype)), single_entry)

class(be2) <- "bibentry"

be2[4:5]
