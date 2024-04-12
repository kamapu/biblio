## Read installed library
Refs <- read_bib(x = file.path(path.package("biblio"),
        "LuebertPliscoff.bib"))

# Convert lib_df to data frame
as(Refs[1:5, ], "data.frame")

# Convert lib_df to bibentry
as(Refs[1:5, ], "bibentry")
