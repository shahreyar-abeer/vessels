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
                  choices = unique(vessels::ships2$ship_type),
                  value = "Cargo"
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
      
      observeEvent(input$type, {
        update_dropdown_input(
          session = session,
          input_id = "ship",
          choices = unique(vessels::ships2$SHIPNAME[ships2$ship_type == input$type]),
          value = "PINTA"
        )
      })
      
      observeEvent(input$ship, {
        
        r$ship <- input$ship
        #print(r$ship)
        req(r$ship)
        r$max_data <- get_max_data(vessels::ships2, r$ship)
        #r$max_data <- distances[which.max(distance), ]
        #print(r$max_data)
      })
      
    }
  )
 
}


