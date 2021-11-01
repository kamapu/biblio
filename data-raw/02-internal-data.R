# TODO: Add comment
# 
# Author: Miguel Alvarez
################################################################################

library(usethis)
library(readODS)

data_bib <- list()

# Import common files
data_bib$file_list <- read_ods("data-raw/common-data.ods", "file_list")

# Import bibtex data
data_bib$tags_bib <- read_ods("data-raw/prototype-bib.ods", "main_table")
data_bib$classes_bib <- read_ods("data-raw/prototype-bib.ods", "entry_type")

# Import RIS data
data_bib$tags_ris <- read_ods("data-raw/prototype-ris.ods", "main_table")
data_bib$classes_ris <- read_ods("data-raw/prototype-ris.ods", "entry_type")

usethis::use_data(data_bib, internal = TRUE)
