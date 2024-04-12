## Read installed library
Bib <- read_bib(x = file.path(path.package("biblio"),
        "LuebertPliscoff.bib"))

# Convert lib_df to data frame
as(Bib[1:5, ], "data.frame")

# Convert lib_df to bibentry
as(Bib[1:5, ], "bibentry")
