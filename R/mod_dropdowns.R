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
                  "Vessel type"
                ),
                dropdown_input(
                  input_id = ns("selected_type"),
                  default_text = "Select Vessel Type",
                  choices = NULL
                )
            ),
            div(class = "column",
              div(class = "header",
                "Vessel name"
              ),
              dropdown_input(
                input_id = ns("selected_vessel"),
                default_text = "Select Vessel Name",
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
          input_id = "selected_type",
          choices = unique(r$data$ship_type)
        )
      })
      
      observeEvent(input$selected_type, {
        req(r$data)
        update_dropdown_input(
          session = session,
          input_id = "selected_vessel",
          choices = unique(r$data[ship_type == input$selected_type][, SHIPNAME])
        )
        r$selected_type = input$selected_type
      })
      
      observeEvent(input$selected_vessel, {
        req(r$data)
        r$selected_vessel <- input$selected_vessel
      })
      
    }
  )
 
}


