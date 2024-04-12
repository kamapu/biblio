## Read installed electronic library
Bib <- read_bib(x = file.path(path.package("biblio"),
        "LuebertPliscoff.bib"))

## Convert the first five entries
bib2bibentry(Bib[1:5, ])
