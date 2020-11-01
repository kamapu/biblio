
# biblio

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
Bib <- read_bib()
```
