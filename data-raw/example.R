# TODO: Add comment
# 
# Author: Miguel Alvarez
###############################################################################

remotes::install_github("kamapu/biblio")
remotes::install_github("ropensci/RefManageR")

library(biblio)
library(RefManageR)

## library(devtools)
## install()





Bib <- read_bib(bib=file.path(path.package("biblio"),
    "LuebertPliscoff.bib"))
Bib

match_keys(x=Bib$bibtexkey, rmd_file=file.path(path.package("biblio"),
				"document.Rmd"))


match_keys(x=Bib, rmd_file=file.path(path.package("biblio"),
				"document.Rmd"))

class(Bib)


#




