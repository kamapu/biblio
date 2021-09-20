
<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- Use snippet 'render_markdown' for it -->

# biblio

<!-- badges: start -->

[![R-CMD-check](https://github.com/kamapu/biblio/workflows/R-CMD-check/badge.svg)](https://github.com/kamapu/biblio/actions)
[![Codecov test
coverage](https://codecov.io/gh/kamapu/biblio/branch/master/graph/badge.svg)](https://codecov.io/gh/kamapu/biblio?branch=master)
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

## Reading Bibtex Files

A copy of the references cited in the book of [Luebert & Pliscoff
(2016)](https://doi.org/10.5281/zenodo.60800) is also installed with
this package.

``` r
library(biblio)
Bib <- read_bib(x = file.path(path.package("biblio"), "LuebertPliscoff.bib"))
Bib
#> Object of class 'lib_df'
#> 
#> Number of references: 1701
#> Number of variables: 23
#> Duplicated entries: FALSE
```

## Scanning Cited References in R-Markdown Documents

An example of r-markdown document is also installed to test the function
`detect_keys()`, which is able to recognize the bibtexkeys in use within
an r-markdown document.

``` r
my_document <- readLines(file.path(path.package("biblio"), "document.Rmd"))
cited_refs <- detect_keys(my_document)
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

Alternatively to the last option, you can use the function `read_rmd()`
from the package [`yamlme`](https://kamapu.github.io/rpkg/yamlme/). Note
that in this case the position of the citation may change because
`detect_keys()` will start counting lines after the yaml-header.

``` r
library(yamlme)
my_document <- read_rmd(file.path(path.package("biblio"), "document.Rmd"))
#> The yaml-header is not imported by this fucnion. Use 'update()' to re-write the header.
cited_refs <- detect_keys(my_document)
#> Lines are counted only at the body of the document.
cited_refs
#>        bibtexkey line
#> 1 oberdorfer1960    4
#> 2     veblen1995    6
#> 3     veblen1996    6
#> 4 oberdorfer1960    9
#> 5 oberdorfer1960   13
#> 6     veblen1996   18
#> 7   pollmann2004   18
#> 8    ramirez2005   23
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

## Automatic Reference Lists

The package [`yamlme`](https://kamapu.github.io/rpkg/yamlme/) enables
the use of functions to write R-markdown documents and to render them.
In this context, the function `reflist()` will produce automatically a
reference list.

``` r
Bib2 <- subset(x = Bib, subset = as.integer(year) > 2005)
reflist(obj = Bib2, filename = "my_reflist")
```

Note that assigning the output of `reflist()` to a new object and using
the package `yamlme`, you may be able to modify the layout by using the
function `update()`. Remember to set

``` r
library(yamlme)

# Subset and assignment
Bib2 <- subset(x = Bib, subset = as.integer(year) > 2005)
my_reflist <- reflist(x = Bib2, filename = "my_reflist", browse_file = FALSE)

# Updating and rendering
my_reflist <- update(
        object = my_reflist,
        title = "Reference List (PDF version)",
        author = "myself",
        output = "pdf_document",
        body = txt_body(
                "\\setlength{\\parindent}{-5mm}",
                "\\setlength{\\leftskip}{5mm}",
                "\\setlength{\\parskip}{8pt}"))
render_rmd(my_reflist, output_file = "my_reflist")
```

Note that rendering the updated document will also require the written
bibtex file, thus sharing an input bibtexfile or an `lib_df` object
within an R-image may be the most secure way to enable repeatability.
