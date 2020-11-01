# TODO: Add comment
# 
# Author: Miguel Alvarez
###############################################################################

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


