# TODO:   Add comment
# 
# Author: Miguel Alvarez
################################################################################

library(biblio)
library(rpostgis)

conn <- dbConnect("PostgreSQL", dbname="references_db", host="localhost",
		port=5432, user="miguel", password="kamapu")

DB <- read_pg(conn, "miguel2020")

Literatur <- "/media/ma/Miguel/Literatur"

Bib <- read_bib(file.path(Literatur, "Literatur_db/MiguelReferences.bib"))

update_report(DB, Bib)

Test <- update_report(DB, Bib, print_only=FALSE)

# TODO: Update database in postgres



val_files <- biblio:::valid_file("/media/ma/Miguel/Literatur/imported",
		get_files(Test))

