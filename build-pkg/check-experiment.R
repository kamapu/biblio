# TODO:   Attempt to check package in Linux
# 
# Author: miguel
###############################################################################

check_linux <- function(path) {
  pkg_loc <- normalizePath(build(path = path))
  pkg_name <- strsplit(pkg_loc, "/")[[1]]
  pkg_name <- strsplit(pkg_name[length(pkg_name)], "_")[[1]][1]
  Temp  <- tempdir()
  Cmd <- paste0(c(
          paste0("targz=", pkg_loc),
          paste0("lib=", Temp),
          "mkdir -p ${lib}",
          "R_LIBS_USER=${lib} R -e 'install.packages(c(\"Rcpp\", \"remotes\"))'",
          ## "R_LIBS_USER=${lib} R CMD INSTALL ${targz}",
          paste0("R_LIBS_USER=${lib} R -e 'remotes::install_local(\"",
              pkg_loc, "\", dependencies = TRUE)'"),
          "bindfs -r ${lib} ${lib}",
          paste0("R_LIBS_USER=${lib} R -e 'tools::testInstalledPackage(\"",
              pkg_name, "\")'"),
          "fusermount -u ${lib}\n"),
      collapse = "\n")
  return(Cmd)
}


Test <- check_linux("build-pkg")

system(Test)

