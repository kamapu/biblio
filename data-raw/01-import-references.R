# TODO:   Importing references as example data
# 
# Author: Miguel Alvarez
################################################################################

library(biblio)
library(usethis)

# Adding example data
synopsis <- read_bib("inst/LuebertPliscoff.bib")
use_data(synopsis, overwrite = TRUE)

# TODO: new_lib() template from data-raw/fields_list.ods
