
#' Calculates the distance between each consecutive points
#' Ignores if the time difference is more than 10 mins
#'
#' @param r \code{reactiveValues}
#' @param ship_name \code{character}
#' @param time_difference \code{numeric}
#'
#' @import data.table
#' @importFrom sf st_point st_sfc st_distance
#'
#' @return \code{data.frame} containing a single row
#' @export

get_max_data <- function(data, ship_name, time_difference = 10) {

  data <- data[SHIPNAME == ship_name][, x := .I]
  data <- data[, .(LAT, LON, DATETIME, this_point = .(st_point(c(LON, LAT)))), by = x]
  data <- data[, prev_point := c(this_point[1], this_point[1:(.N-1)])]
  data <- data[, this_date := DATETIME][, previous_date := c(this_date[1], this_date[1:(.N-1)])]
  data <- data[, time_diff := difftime(this_date, previous_date, units = "mins")]
  
  # a time diff of less than 10 minutes is considered as a consecutive value.
  # although it was mentioned in the description to 'ca. 30 sec',
  # a diff of 30 seconds makes the distance too small to distinguish the 2 points
  # on the map even with the highgest zoom level.
  # thus, a threshold of 10 mins is taken.
  
  data <- data[time_diff > time_difference, prev_point := NA ] 
  max_distance_list <- calculate_max_distance(data)
  data <- data[max_distance_list$index][, distance := max_distance_list$value]
  data <- data[, .(LAT, LON, DATETIME, prev_point, this_point, distance)]
  data
}


#' Helper function for get_max_data()
#'
#' @param data 
#'
#' @return \code{list} of 2, an index and a value
#' @export
#'
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


