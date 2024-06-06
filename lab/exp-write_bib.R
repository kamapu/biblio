# TODO:   Add comment
# 
# Author: Miguel Alvarez
################################################################################

library(biblio)

Bib <- read_bib(x = file.path(path.package("biblio"),
        "LuebertPliscoff.bib"))

y2000 <- subset(Bib, year == "2000")

write_bib(y2000, "lab/year_2000.bib")
