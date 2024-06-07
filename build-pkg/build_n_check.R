# TODO:   Working script for testing the package 'gisrepos'
# 
# Author: Miguel Alvarez
################################################################################

library(devtools)
library(styler)
library(knitr)
library(qpdf)
library(covr)

# Clean session
rm(list = ls())

# Clean folder
unlink(file.path("build-pkg", list.files("build-pkg", ".tar.gz")))
unlink(file.path("build-pkg", list.files("build-pkg", ".pdf")))

# re-style scripts
style_pkg()

## # Write data
## source("data-raw/create-data.R")
## 
## # Purl vignette R-code
## purl("vignettes/taxlist-intro.Rmd", "vignettes/taxlist-intro.R")

# write documentation
document()

# Build and check package
Folder = "build-pkg"
pkg_loc <- build(path = Folder, args = "--resave-data")
check_built(path = pkg_loc)

# Report coverage
report()

# a posteriori
build_manual(path = Folder)

# Install package
install()

# Carry out the tests
test()

# Write data set
## source("data-raw/Easplist/Easplist.R")

# Check application of good practices
gp()

# Codemetar
# write_codemeta()

# Render readme-file.
render("README.Rmd")

# Check on Win-builder
browseURL("https://win-builder.r-project.org/")
