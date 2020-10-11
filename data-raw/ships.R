## code to prepare `ships` dataset goes here


ships <- data.table::fread("../../Documents/ships_data/ships.csv")

to_keep <- c("LAT", "LON", "SHIPNAME", "SHIPTYPE", "ELAPSED", "SPEED", "DATETIME")

ships2 <- ships[, ..to_keep]

usethis::use_data(ships2, overwrite = TRUE)
