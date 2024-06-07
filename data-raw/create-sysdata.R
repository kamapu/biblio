# TODO:   Add tables to system data
#
# Author: Miguel Alvarez
################################################################################

library(tools)

dfs <- file_path_sans_ext(list.files("data-raw", pattern = ".csv"))

for (i in dfs) {
  assign(i, read.csv(paste0("data-raw/", i, ".csv")))
}

save(list = dfs, file = "R/sysdata.rda")
