# TODO:   Add comment
# 
# Author: Miguel Alvarez
################################################################################

library(biblio)

Bib <- read_bib("lab/dummy-bib.bib")
Bib
as(Bib, "data.frame")

# Only one entry in file
Bib <- read_bib("lab/dummy-bib2.bib")
Bib

# Month without curly brackets
Bib <- read_bib("lab/dummy-bib3.bib")
Bib
as(Bib, "data.frame")

# Solving issue #49

Refs <- read_bib(x = "lab/data/MiguelReferences.bib")
Keys <- readLines("lab/data/Keys.txt")
Refs <- subset(Refs, bibtexkey %in% Keys)
write_bib(Refs, "lab/data/references")

as(Refs, "data.frame")

x <- subset(Refs, grepl("address =", address))
as(x, "data.frame")




