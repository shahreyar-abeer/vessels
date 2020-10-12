#' map UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#' 
#' @import leaflet
#' @importFrom data.table fcase
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
#'
#' @noRd 
mod_map_server <- function(id, r){
  

  
  moduleServer(
    id = id,
    function(input, output, session) {
      ns <- session$ns
      output$map <- renderLeaflet({
        
        req(r$max_data)
        
        x1 <- r$max_data$prev_point[[1]][1]
        y1 <- r$max_data$prev_point[[1]][2]
        x2 <- r$max_data$this_point[[1]][1]
        y2 <- r$max_data$this_point[[1]][2]
        
        
        icon1 = leaflet::awesomeIcons(
          icon = "ship",
          iconColor = "#ffffff",
          library = "fa",
          markerColor = "cadetblue"
        )
        
        icon2 = leaflet::awesomeIcons(
          icon = "anchor",
          iconColor = "#ffffff",
          library = "fa",
          markerColor = "red"
        )
        
        text1 <- paste0(r$ship, "'s longest run started here.")
        text2 <- paste0(r$ship, "'s longest run ended here.")
        
        leaflet(ships2) %>% 
          addProviderTiles(providers$Esri.WorldGrayCanvas) %>%
          setView(lng = (x1+x2)/2, lat = (y1+y2)/2, zoom = 10) %>% 
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
 
