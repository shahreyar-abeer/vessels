
#' Title
#'
#' @param r 
#' @param ship_name 
#'
#' @import data.table
#' @importFrom sf st_point st_sfc st_distance
#'
#' @return
#' @export

get_max_data <- function(data, ship_name) {

  data <- data[SHIPNAME == ship_name][, x := .I]
  data <- data[, .(LAT, LON, DATETIME, this_point = .(st_point(c(LON, LAT)))), by = x]
  data <- data[, prev_point := c(this_point[1], this_point[1:(.N-1)])]
  data <- data[, this_date := DATETIME][, previous_date := c(this_date[1], this_date[1:(.N-1)])]
  data <- data[, time_diff := difftime(this_date, previous_date, units = "mins")]
  data <- data[time_diff > 100, prev_point := NA ] # a time diff of greater that 100 mins is regarded as not-consecutive
  max_distance_list <- calculate_max_distance(data)
  data <- data[max_distance_list$index][, distance := max_distance_list$value]
  data <- data[, .(LAT, LON, DATETIME, prev_point, this_point, distance)]
  data
}


calculate_max_distance <- function(data) {
  sf_geometry <- st_sfc(data$prev_point, crs = 4326)
  distance_matrix <- st_distance(sf_geometry)
  
  ## get the values of consecutive rows only in the upper triangle of the matrix
  distances <- distance_matrix[col(distance_matrix) - row(distance_matrix) == 1]
  
  list(
    index = which.max(distances),
    value = max(distances, na.rm = TRUE)
  )
}


