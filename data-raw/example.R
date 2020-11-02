# TODO: Add comment
# 
# Author: Miguel Alvarez
###############################################################################

remotes::install_github("kamapu/biblio")
library(biblio)

## library(devtools)
## install()

Bib <- read_bib(bib=file.path(path.package("biblio"),
    "LuebertPliscoff.bib"))
Bib

match_keys(x=Bib, rmd_file=file.path(path.package("biblio"),
				"document.Rmd"))


