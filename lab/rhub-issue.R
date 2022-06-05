# TODO:   Add comment
# 
# Author: Miguel Alvarez
################################################################################

library(curl)
library(rhub)

File <- "biblio.tar.gz"

curl_download("https://github.com/kamapu/biblio/archive/refs/tags/v0.0.5.tar.gz",
    destfile = File)

untar(File)

check_for_cran("biblio-0.0.5")

check("biblio-0.0.5", platform = "ubuntu-gcc-release")
