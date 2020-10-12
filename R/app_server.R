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
  # List the first level callModules here
  
  r <- reactiveValues(
    ship = NULL,
    max_data = NULL
  )
  
  mod_dropdowns_server("drops", r)
  mod_map_server("map", r)
  
  output$note <- renderUI({
    req(r$max_data)
    header <- paste0(round(r$max_data$distance, 1), " metres.")
    HTML(paste0(h4(header)))
  })
  
  output$vessel <- renderUI({
    req(r$ship)
    HTML(paste0(icon("ship"), " Vessel: ", r$ship))
  })
  
  output$details <- renderReactable({
    vessels::ships2[SHIPNAME == r$ship, .(SHIPNAME, SHIPTYPE = ship_type, LENGTH, FLAG, WIDTH)][1] %>% 
      reactable(
        sortable = FALSE,
        compact = TRUE,
        bordered = TRUE,
        highlight = TRUE,
        striped = TRUE
      )
  })
  
}
