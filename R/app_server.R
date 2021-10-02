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
    data = NULL,
    max_data = NULL
  )
  
  con = DBI::dbConnect(
    drv = RPostgreSQL::PostgreSQL(),
    user = "lrpdgiby",
    password = "l8tPNicx_0pEk-HbwgmVa39XqJgHURrx",
    host = "raja.db.elephantsql.com",
    port = 5432,
    dbname = "lrpdgiby"
  )
  
  shiny::onStop(function() {
    DBI::dbDisconnect(con)
  })
  
  observeEvent(con, {
    r$data = DBI::dbGetQuery(con, "SELECT * FROM vessels") %>% data.table::data.table()
    print(r$data)
  })
  
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
    req(r$data, r$ship)
    r$data[SHIPNAME == r$ship, .(SHIPNAME, SHIPTYPE = ship_type, LENGTH, FLAG, WIDTH)][1] %>% 
      reactable(
        sortable = FALSE,
        compact = TRUE,
        bordered = TRUE,
        highlight = TRUE,
        striped = TRUE
      )
  })
  
}
