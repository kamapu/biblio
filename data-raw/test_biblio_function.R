# TODO: Add comment
# 
# Author: Miguel Alvarez
###############################################################################

# Required packages
remotes::install_github("kamapu/gisrepos")

Pkgs <- c("biblio", "yamlme", "dbaccess", "rmarkdown")
gisrepos::require_now(Pkgs)

# TODO: pass arguments to different functions

conn <- connect_db2(dbname="references_db")
keys <- c("Alvarez2018", "Alvarez2012", "Luebert2006")
name <- "miguel2020"
bibfile <- "data-raw/references.bib" # Default
rmdfile <- "data-raw/references.Rmd" # Default

# Function
Bib <- read_pg(conn, name) # ...
Bib <- Bib[Bib$bibtexkey %in% keys, ]
write_bib(Bib, bibfile) # ...

# Output
write_yaml(title="References", author="Miguel", output="pdf_document",
		bibliography=bibfile, nocite="'@*'",
		body=paste(c("\\setlength{\\parindent}{-5mm}",
						"\\setlength{\\leftskip}{5mm}",
						"\\setlength{\\parskip}{8pt}"), collapse="\n"),
		filename=rmdfile)

# Render
render("references.Rmd")

# Problems with subfolders
setwd("data-raw")


DBI::dbDisconnect(conn)

# TODO: Check quotations regarding sub-folder problem
# TODO: Option for cleaning written files





