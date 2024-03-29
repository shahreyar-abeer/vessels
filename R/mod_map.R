#' map UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#' 
#' @importFrom shiny NS tagList
#' @importFrom leaflet leafletOutput
#' 
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_map_ui <- function(id){
  ns <- NS(id)
  tagList(
    leafletOutput(ns("map"), height = "500px")
  )
}
    
#' map Server Function
#' 
#' @import leaflet
#' @importFrom data.table fcase
#' @importFrom shiny moduleServer
#'
#' @noRd 
mod_map_server <- function(id, r){
  
  moduleServer(
    id = id,
    function(input, output, session) {
      ns <- session$ns
      
      output$map <- renderLeaflet({
        req(r$max_data)
        print(r$max_data)
        x1 <- r$max_data$this_point[[1]][1]
        y1 <- r$max_data$this_point[[1]][2]
        x2 <- r$max_data$this_point[[2]][1]
        y2 <- r$max_data$this_point[[2]][2]
        
        icon1 = awesomeIcons(
          icon = "ship",
          iconColor = "#ffffff",
          library = "fa",
          markerColor = "cadetblue"
        )
        
        icon2 = awesomeIcons(
          icon = "anchor",
          iconColor = "#ffffff",
          library = "fa",
          markerColor = "red"
        )
        
        text1 <- glue::glue("{r$selected_vessel}'s longest run started here.")
        text2 <- glue::glue("{r$selected_vessel}'s longest run ended here.")
        
        leaflet(r$data) %>% 
          addProviderTiles(providers$CartoDB.Voyager) %>%
          #setView(lng = (x1+x2)/2, lat = (y1+y2)/2, zoom = 10) %>% 
          fitBounds(x1, y1, x2, y2, options = list(padding = c(150, 150))) %>% 
          addAwesomeMarkers(lng = x1, lat = y1, popup = text1,
                            icon = icon1) %>% 
          addAwesomeMarkers(lng = x2, lat = y2, popup = text2,
                            icon = icon2) %>% 
          #clearBounds() %>% 
          addMiniMap()
      })
    }
  )
  
 
}
    
## this_point be copied in the UI
# mod_map_ui("map_ui_1")
    
## this_point be copied in the server
# callModule(mod_map_server, "map_ui_1")
 
