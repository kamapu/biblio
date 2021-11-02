# TODO:   Working script for testing the package 'taxlist'
# 
# Author: Miguel Alvarez
################################################################################

# Needed packages
library(devtools)

# Document package
document()

# Build package
Root <- sub("/biblio", "", getwd(), fixed=TRUE)
Ploc <- build(path=file.path(Root, "00_Rpackages"))

# Test the package
check_built(path=Ploc)
