# TODO:   Add comment
# 
# Author: Miguel Alvarez
################################################################################

library(biblio)

Bib <- read_bib(x = file.path(path.package("biblio"),
        "LuebertPliscoff.bib"))

as(Bib[1:5, ], "data.frame")

as(Bib[1:5, ], "bibentry")

# Example for back conversion
y2000 <- subset(Bib, year == "2000")
y2000

## y2000 <- bib2bibentry(y2000)
## print(y2000, "bibtex")

y2000 <- as(y2000, "bibentry")
print(y2000, "bibtex")

# Other way around
y2000_2 <- as(y2000, "lib_df")
y2000_2
