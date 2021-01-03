
<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- Use snippet 'render_markdown' for it -->

# biblio

<!-- badges: start -->

[![Travis build
status](https://travis-ci.com/kamapu/biblio.svg?branch=master)](https://travis-ci.com/kamapu/biblio)
[![Codecov test
coverage](https://codecov.io/gh/kamapu/biblio/branch/master/graph/badge.svg)](https://codecov.io/gh/kamapu/biblio?branch=master)
[![R-CMD-check](https://github.com/kamapu/biblio/workflows/R-CMD-check/badge.svg)](https://github.com/kamapu/biblio/actions)
<!-- badges: end -->

An R-package to manage bibliographic references. This package is focused
on data import-export to a data frame format based on the software
[**JabRef**](http://www.jabref.org/).

## Installing biblio

You can install this package from **GitHub**.

``` r
library(remotes)
install_github("kamapu/biblio")
```

A copy of the references cited in the book of [Luebert & Pliscoff
(2016)](https://doi.org/10.5281/zenodo.60800) is also installed with
this package.

``` r
library(biblio)
Bib <- read_bib(bib = file.path(path.package("biblio"), "LuebertPliscoff.bib"))
Bib
#> Object of class 'lib_df'
#> 
#> Number of references: 1701
#> Number of variables: 23
#> Duplicated entries: FALSE
```

An example of r-markdown document is also installed to test the function
`detect_keys()`, which is able to recognize the bibtexkeys in use within
an r-markdown document.

``` r
my_documents <- readLines(file.path(path.package("biblio"), "document.Rmd"))
cited_refs <- detect_keys(my_documents)
cited_refs
#>        bibtexkey line
#> 1 oberdorfer1960   10
#> 2     veblen1995   12
#> 3     veblen1996   12
#> 4 oberdorfer1960   15
#> 5 oberdorfer1960   19
#> 6     veblen1996   24
#> 7   pollmann2004   24
#> 8    ramirez2005   29
```

The output shows the respective bibtexkey by its occurrence in the
document (line number). With this output it is also possible to do some
statistics.

``` r
stats_refs <- aggregate(line ~ bibtexkey, data = cited_refs, FUN = length)

# Number of citations in text
sum(stats_refs$line)
#> [1] 8

# Number of cited articles
nrow(stats_refs)
#> [1] 5

# Respective frequency to know rare citations in text
stats_refs[order(stats_refs$line, decreasing = TRUE), ]
#>        bibtexkey line
#> 1 oberdorfer1960    3
#> 5     veblen1996    2
#> 2   pollmann2004    1
#> 3    ramirez2005    1
#> 4     veblen1995    1
```
