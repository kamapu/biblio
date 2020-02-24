# TODO:   for developing functions
# 
# Author: Miguel Alvarez
################################################################################

library(biblio)
library(RPostgreSQL)

Bib <- as.data.frame(read_bib("/media/ma/Miguel/Literatur/Literatur_db/MiguelReferences.bib"),
		stringsAsFactors=FALSE)

conn <- dbConnect("PostgreSQL", dbname="references_db", host="localhost",
		port=5432, user="miguel", password="kamapu")

DB <- read_pg(conn, "miguel_references")


