# TODO: Add comment
# 
# Author: Miguel Alvarez
###############################################################################

remotes::install_github("kamapu/biblio")
library(biblio)



Bib <- read_bib(bib=file.path(path.package("biblio"),
    "LuebertPliscoff.bib"))
Bib

match_keys(x=Bib, rmd_file=file.path(path.package("biblio"),
				"document.Rmd"))


###


setwd("data-raw")

## Writing the document example
rmd_text <- c("# Introduction",
		"",
		"Lorem ipsum dolor sit amet [@bibkey_a], consectetur adipisici elit [@bibkey_b],",
		"sed eiusmod tempor incidunt ut labore et dolore magna aliqua [@bibkey_c;@bibkey_d].",
		"",
		"According to @Noname2000, the world is round [@Ladybug1999;Ladybug2009].",
		"This knowledge got lost [@Ladybug2009a].")
writeLines(rmd_text, "document.Rmd")

# Bibtexkeys from bib file
keys <- c("bibkey_a", "bibkey_b", "bibkey_c", "bibkey_d",
		"Noname2000", "Ladybug1999", "Ladybug2009", "Ladybug2009a")


# Generic
match_keys <- function (x, ...) {
	UseMethod("match_keys", x)
}

# Method
match_keys.lib_df <- function(x, rmd_file, ...) {
	rmd_file <- readLines(rmd_file, ...)
	keys <- paste0("@", x$bibtexkey)
	cited_refs <- list()
	for(i in 1:length(rmd_file)) {
		cited_refs[[i]] <- data.frame(
				bibtexkey=sub("@", "", str_extract(rmd_file[i], keys)),
				line=i, stringsAsFactors=FALSE)
	}
	cited_refs <- do.call(rbind, cited_refs)
	cited_refs <- cited_refs[!is.na(cited_refs$bibtexkey), ]
	return(cited_refs)
}


library(biblio)
library(stringr)


Bib <- read_bib("inst/LuebertPliscoff.bib")

Test <- match_keys(Bib, rmd_file="inst/document.Rmd")

aggregate(line ~ bibtexkey, data=Test, FUN=length)





setwd(gsub("/data-raw", "", getwd()))



keys <- paste0("@", keys)

# Read document
document <- readLines("document.Rmd")

# Scan document line by line
cited_refs <- list()
for(i in 1:length(document)) {
	cited_refs[[i]] <- str_extract(document[i], keys)
}

# Final output
cited_refs <- unlist(cited_refs)
cited_refs <- cited_refs[!is.na(cited_refs)]

summary(as.factor(cited_refs))

### For read_bib

Bib <- read_bib("inst/luebert_pliscoff.bib")


