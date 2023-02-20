# Partially matching libraries
Refs1 <- synopsis[1:10, ]
Refs2 <- synopsis[6:15, ]

# some modification in second library
Refs2[3, "title"] <- "New Title"

# compare libraries
compare_df(Refs1, Refs2)
