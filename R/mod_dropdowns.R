#' dropdowns UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList div
#' @importFrom shiny.semantic dropdown_input update_dropdown_input
#' @import data.table
mod_dropdowns_ui <- function(id){
  ns <- NS(id)
  tagList(
    
    div(class = "ui grid",
        div(class = "four column row",
            div(class = "column"),
            div(class = "column",
                div(class = "header",
                  "Select vessel type"
                ),
                dropdown_input(
                  input_id = ns("type"),
                  default_text = "Vessel Type",
                  choices = NULL
                )
            ),
            div(class = "column",
              div(class = "header",
                "Select vessel name"
              ),
              dropdown_input(
                input_id = ns("ship"),
                default_text = "Vessel name, choose a type first",
                choices = NULL
              )
            )
        )
      
      
    )

  )
}
    
#' dropdowns Server Function
#' 
#' @import data.table
#' @importFrom shiny moduleServer observeEvent
#'
#' @noRd 
mod_dropdowns_server <- function(id, r){
  
  moduleServer(
    id = id,
    function(input, output, session) {
      ns <- session$ns
      
      observeEvent(r$data, {
        req(r$data)
        update_dropdown_input(
          session = session,
          input_id = "type",
          choices = unique(r$data$ship_type)
        )
      })
      
      observeEvent(input$type, {
        req(r$data)
        update_dropdown_input(
          session = session,
          input_id = "ship",
          choices = unique(r$data[ship_type == input$type][, SHIPNAME])
        )
      })
      
      observeEvent(input$ship, {
        req(r$data)
        r$ship <- input$ship
        #print(r$ship)
        req(r$ship)
        r$max_data <- get_max_data(r$data, r$ship)
        #r$max_data <- distances[which.max(distance), ]
        #print(r$max_data)
      })
      
    }
  )
 
}


