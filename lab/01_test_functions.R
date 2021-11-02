# TODO:   for developing functions
# 
# Author: Miguel Alvarez
################################################################################

## library(devtools)
## install_github("kamapu/biblio", "miguel")

library(biblio)
library(taxlist)
library(RPostgreSQL)

load_last("data-raw/references_db")

conn <- dbConnect("PostgreSQL", dbname="references_db", host="localhost",
        port=5432, user="miguel", password="kamapu")

## write_pg(conn, "miguel2020", Bib, files_tab)
## write_pg(conn, "miguel2020", Bib, files_tab, overwrite=TRUE)
## write_pg(conn, "miguel2020", Bib, files_tab, overwrite=TRUE,
##         partial.match=TRUE)

bib <- write_bib(read_pg(conn, "miguel2020", journal=TRUE),
		"data-raw/MiguelReferences.bib")


# Test update_pg
db <- conn
bib <- read_bib("/media/ma/Miguel/Literatur/Literatur_db/MiguelReferences.bib")
get_files=TRUE
delete=FALSE
main_table="main_table"
file_list="file_list"
name="miguel2020"
db_args=list()



Comp_mt <- compare_df(db_tab, bib, "bibtexkey")
Comp_fl <- compare_df(db_fl, bib_fl, "file")




add=FALSE, update=FALSE, , ...








Test <- read_pg(conn, "miguel2020")

val_files <- biblio:::valid_file("/media/ma/Miguel/Literatur/imported",
		get_files(Test))




data(iris)

iris$obs <- 1:nrow(iris)

iris2 <- iris
iris2$obs[5] <- 200
iris2[17,3] <- 10.5
iris2[50:60, 4] <- NA

df1 <- iris
df2 <- iris2
key="obs"
Test <- compare_df(iris, iris2, "obs")







Test <- Bib
add_files(Test) <- files_tab


Test <- add_files(files_tab)




refs <- Bib
value <- files_tab
priority="main text"


df <- files_tab
path <- "/media/ma/Miguel/Literatur/imported"

Test <- valid_file(path, files_tab)





A <- c("yo",NA,"yo",NA,"b","yo")

(DF <- data.frame(VAR1=A, VAR2=letters[1:length(A)]))

DF[order(DF$VAR1 == "yo", decreasing=TRUE),]



Bib <- read_bib("/media/ma/Miguel/Literatur/Literatur_db/MiguelReferences.bib")


dbDisconnect(conn)

library(readODS)




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

