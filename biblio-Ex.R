pkgname <- "biblio"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
library('biblio')

base::assign(".oldSearch", base::search(), pos = 'CheckExEnv')
base::assign(".old_wd", base::getwd(), pos = 'CheckExEnv')
cleanEx()
nameEx("compare_df")
### * compare_df

flush(stderr()); flush(stdout())

### Name: compare_df
### Title: Compare data frames and libraries
### Aliases: compare_df compare_df,data.frame,data.frame,character-method
###   compare_df,lib_df,lib_df,missing-method

### ** Examples

# Partially matching libraries
Refs1 <- synopsis[1:10, ]
Refs2 <- synopsis[6:15, ]

# some modification in second library
Refs2[3, "title"] <- "New Title"

# compare libraries
compare_df(Refs1, Refs2)




cleanEx()
nameEx("detect_keys")
### * detect_keys

flush(stderr()); flush(stdout())

### Name: detect_keys
### Title: Detect bibtexkeys used in an r-markdown document
### Aliases: detect_keys detect_keys.character detect_keys,character-method
###   detect_keys.rmd_doc detect_keys,rmd_doc-method

### ** Examples

## Read installed r-markdown document
my_document <- readLines(file.path(path.package("biblio"), "document.Rmd"))

## Screen for citations
cited_refs <- detect_keys(my_document)
cited_refs




cleanEx()
nameEx("print")
### * print

flush(stderr()); flush(stdout())

### Name: print
### Title: Print content of lib_df objects
### Aliases: print print.lib_df print,lib_df-method print.comp_df
###   print,comp_df-method

### ** Examples

synopsis




cleanEx()
nameEx("read_bib")
### * read_bib

flush(stderr()); flush(stdout())

### Name: read_bib
### Title: Read BibTeX Databases
### Aliases: read_bib

### ** Examples

Refs <- read_bib(x = file.path(path.package("biblio"),
  "LuebertPliscoff.bib"))
Refs




cleanEx()
nameEx("reflist")
### * reflist

flush(stderr()); flush(stdout())

### Name: reflist
### Title: Write a Reference List in rmarkdown
### Aliases: reflist reflist,lib_df-method reflist,character-method

### ** Examples

## Not run: 
##D reflist(synopsis)
## End(Not run)




cleanEx()
nameEx("synopsis")
### * synopsis

flush(stderr()); flush(stdout())

### Name: synopsis
### Title: References by Lueber and Pliscoff (2018)
### Aliases: synopsis
### Keywords: datasets

### ** Examples

data(synopsis)

## Import from installed bibtex file
synopsis <- read_bib(x = file.path(path.package("biblio"),
  "LuebertPliscoff.bib"))




cleanEx()
nameEx("update")
### * update

flush(stderr()); flush(stdout())

### Name: update
### Title: Update data frames
### Aliases: update update.data.frame update.lib_df update<-
###   update<-,data.frame,data.frame-method update<-,lib_df,lib_df-method

### ** Examples

# modifying the data set iris
data(iris)
iris$id <- 1:nrow(iris) # ID column added

# rows to add using mean values per species
iris_mod <- aggregate(cbind(Sepal.Length, Sepal.Width, Petal.Length,
    Petal.Width) ~ Species, data = iris, FUN = mean)
iris_mod$id <- (1:nrow(iris_mod)) + nrow(iris)
iris_mod <- do.call(rbind, list(iris, iris_mod[ , colnames(iris)]))

# delete some entries
iris_mod <- iris_mod[-c(15, 75, 105, 145), ]

# modify entries
iris_mod$Petal.Length[c(20, 30)] <- 0
iris_mod$Petal.Width[c(20, 50)] <- 0

# just a comparison
update(iris, iris_mod, key = "id")

# do update
iris <- update(iris, iris_mod, key = "id", delete = TRUE, add = TRUE,
    update = TRUE)




### * <FOOTER>
###
cleanEx()
options(digits = 7L)
base::cat("Time elapsed: ", proc.time() - base::get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
