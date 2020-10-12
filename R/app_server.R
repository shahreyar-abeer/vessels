#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @import data.table
#' @importFrom reactable reactable renderReactable
#' @noRd
app_server <- function( input, output, session ) {
  # List the first level callModules here
  
  r <- reactiveValues(
    ship = NULL,
    max_data = NULL
  )
  
  mod_dropdowns_server("drops", r)
  mod_map_server("map", r)
  
  # observeEvent(r$ship, {
  #   req(r$ship)
  #   print(r$ship)
  #   data <- vessels::ships2
  #   r$max_data <- get_max_data(data, r$ship)
  #   #r$max_data <- distances[which.max(distance), ]
  #   print(r$max_data)
  # })
  
  output$note <- renderText({
    req(r$max_data)
    paste0(r$ship, "'s longest run was of ", round(r$max_data$distance, 1), " metres.")
  })
  
  output$vessel <- renderText({
    req(r$ship)
    paste0("Vessel: ", r$ship)
  })
  
  output$details <- renderReactable({
    ships2[SHIPNAME == r$ship, .(SHIPNAME, SHIP_TYPE = ship_type, LENGTH, FLAG, WIDTH)][1] %>% 
      reactable()
  })
  
}
