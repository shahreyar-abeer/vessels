#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#' 
#' @importFrom shiny reactiveValues HTML h4 req renderUI
#' @import data.table
#' @importFrom reactable reactable renderReactable
#' 
#' @noRd
app_server <- function( input, output, session ) {
  
  ## the reactiveValues object that can be called from within the modules
  r <- reactiveValues(
    selected_vessel = NULL,
    data = NULL,
    max_data = NULL
  )
  
  ## calling the module server functions
  mod_dropdowns_server("drops", r)
  mod_map_server("map", r)
  
  ## reading the data, keep only columns required
  to_keep <- c("LAT", "LON", "SHIPNAME", "ship_type", "SPEED", "DATETIME", "LENGTH", "FLAG", "WIDTH")
  data = read_data(path = "inst/ships_04112020/ships.csv", to_keep = to_keep)
  
  print(str(data))
  
  observeEvent(data, {
    r$data = data
  })
  
  ## once the vessel is selected, calculate the distances and get the maximum distance.
  observeEvent(r$selected_vessel, {
    req(r$data, r$selected_vessel)
    
    ## calculate the max distance
    df = r$data[SHIPNAME == r$selected_vessel & ship_type == r$selected_type]
    r$max_data <- get_max_data(df)
  })
  
  ## the note
  output$note <- renderUI({
    req(r$max_data)
    header <- paste0(round(r$max_data$distances[1], 1), " metres.")
    HTML(paste0(h4(header)))
  })
  
  ## the name of the vessel
  output$vessel <- renderUI({
    req(r$selected_vessel)
    HTML(paste0(icon("ship"), " Vessel: ", r$selected_vessel))
  })
  
  ## the details of the selected vessel
  output$details <- renderReactable({
    req(r$data, r$selected_vessel)
    r$data[SHIPNAME == r$selected_vessel & ship_type == r$selected_type, .(SHIPNAME, SHIPTYPE = ship_type, LENGTH, FLAG, WIDTH)][1] %>% 
      reactable(
        sortable = FALSE,
        compact = TRUE,
        bordered = TRUE,
        highlight = TRUE,
        striped = TRUE
      )
  })
  
}
