# TODO:   for developing functions
# 
# Author: Miguel Alvarez
################################################################################

library(devtools)
install_github("kamapu/biblio")
library(taxlist)

library(biblio)
library(RPostgreSQL)

Bib <- read_bib("/media/ma/Miguel/Literatur/Literatur_db/MiguelReferences.bib")

files_tab <- get_files(Bib)
files_tab$description <- with(files_tab, {
			description[tolower(file) == tolower(paste0(bibtexkey, ".pdf"))] <-
					"main text"
			description
		})









backup_object(Bib, files_tab, file="data-raw/references_db")


refs <- Bib




Bib <- as.data.frame(read_bib("/media/ma/Miguel/Literatur/Literatur_db/MiguelReferences.bib"),
		stringsAsFactors=FALSE)

conn <- dbConnect("PostgreSQL", dbname="references_db", host="localhost",
		port=5432, user="miguel", password="kamapu")

DB <- read_pg(conn, "miguel_references")


## From write_pg

###
library(readODS)
library(rpostgis)

df1 <- Bib
df2 <- files_tab

conn <- dbConnect("PostgreSQL", dbname="references_db", host="localhost",
		port=5432, user="miguel", password="kamapu")



name="references_test"
main_table="main_table"
file_list="file_list"
overwrite=FALSE
desc_tab <- read_ods(file.path("inst", "fields_list.ods"),
		"main_table")
desc_fl <- read_ods(file.path("inst", "fields_list.ods"),
		"file_list")


Query <- paste0("SELECT EXISTS(SELECT 1 FROM pg_namespace WHERE nspname = '",
				name,"');\n")
unlist(dbGetQuery(conn, Query))

