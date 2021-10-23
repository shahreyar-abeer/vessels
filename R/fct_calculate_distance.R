
#' Read the ships data
#'
#' @param path 
#' @param to_keep 
#'
#' @return
read_data = function(path, to_keep) {
  if (!is.null(to_keep)) {
    data = data.table::fread(path)[, ..to_keep][order(ship_type, SHIPNAME, DATETIME)]
  } else {
    data = data.table::fread(path)
  }

}


#' Calculates the distance between each consecutive points
#' Ignores if the time difference is more than 10 mins
#'
#' @param r \code{reactiveValues}
#' @param vessel_name \code{character}
#' @param time_difference \code{numeric}
#'
#' @import data.table
#'
#' @return \code{data.frame} containing a single row
#' @export

get_max_data <- function(data) {
  ## bring LON & LAT under a single column
  data = data[, this_point := mapply(c, LON, LAT, SIMPLIFY = FALSE)]
  ## calculate the distances
  data = data[, distances := c(geosphere::distHaversine(do.call(rbind, this_point)), 0)]
  ## get the max distance
  m_row = which.max(data$distances)
  
  data[c(m_row, m_row + 1), ]
}


