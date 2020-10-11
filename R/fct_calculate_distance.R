
#' Title
#'
#' @param r 
#' @param ship_name 
#'
#' @import data.table
#'
#' @return
#' @export

calculate_distance <- function(r, ship_name) {
  #ships <- r$ships
  #ships <- r
  #ships2 <- ships[, ..to_keep]
  print(colnames(r))
  print(is.data.table(r))
  data <- ships2[SHIPNAME == "KAROLI"]
  data <- data[, x := .I]
  #ships3 <- ships3[, x := .I]
  
  #ships3 <- ships2[1:3,]
  
  data <- data[, .(LAT, LON, to = .(st_point(c(LON, LAT)))), by = x]
  
  
  data <- data[, from := c(to[1], to[1:(.N-1)])]
  
  
  data <- data[, distance := calc_sf_dist(from[[1]], to[[1]]), by = x]
  
  data <- data[, .(LAT, LON, from, to, distance)]
  #ships5 <- ships4[, .(from2 = st_point(from)), by = x]
  data
}


calc_sf_dist <- function(x, y) {
  s <- st_sfc(x, y, crs = 4326)
  max(st_distance(s))
}