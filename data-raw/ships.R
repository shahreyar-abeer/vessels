## code to prepare `ships` dataset goes here


ships <- data.table::fread("../../Documents/ships_data/ships.csv")

ships <- ships[, DATETIME := as.POSIXct(DATETIME)]

to_keep <- c("LAT", "LON", "SHIPNAME", "ship_type", "ELAPSED", "SPEED", "DATETIME",
             "LENGTH", "FLAG", "WIDTH")

ships2 <- ships[, ..to_keep][order(ship_type, SHIPNAME, DATETIME)]

usethis::use_data(ships2, overwrite = TRUE)
