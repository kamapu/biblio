Refs <- read_bib(x = file.path(
        path.package("biblio"),
        "LuebertPliscoff.bib"
    ))

print(Refs, maxsum = 10)
