# TODO:   Add comment
# 
# Author: Miguel Alvarez
################################################################################

library(biblio)

Bib <- read_bib(x = file.path(path.package("biblio"),
        "LuebertPliscoff.bib"))

y2000 <- subset(Bib, year == "2000")

write_bib(y2000, "lab/year_2000.bib")

# New issue

Refs <- read_bib(x = "lab/data/MiguelReferences.bib")
Keys <- readLines("lab/data/Keys.txt")
Refs <- subset(Refs, bibtexkey %in% Keys)
write_bib(Refs, "lab/data/references")

as(Refs, "data.frame")

x <- subset(Refs, grepl("address =", address))
as(x, "data.frame")


