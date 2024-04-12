# TODO: Add comment
#
# Author: Miguel Alvarez
################################################################################

library(usethis)
library(readODS)

data_bib <- list()

# Import common files
data_bib$file_list <- read.csv("data-raw/files-jabref.csv")
#data_bib$file_list <- read_ods("data-raw/common-data.ods", "file_list")

# Import bibtex data
data_bib$tags_bib <- read.csv("data-raw/standard-bib.csv")
data_bib$classes_bib <- read.csv("data-raw/standard-bibtypes.csv")

# Import RIS data
data_bib$tags_ris <- read.csv("data-raw/standard-ris.csv")
data_bib$classes_ris <- read.csv("data-raw/standard-ris-types.csv")

# Conversion tables
convert <- list()
convert$entry <- read.csv("data-raw/ris2bib.csv")
convert$type <- read.csv("data-raw/ris2bib-types.csv")

usethis::use_data(data_bib, convert, internal = TRUE, overwrite = TRUE)
