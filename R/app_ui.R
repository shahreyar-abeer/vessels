#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#' @importFrom shiny tagList uiOutput h1 div tags
#' @import shiny.semantic
#' @importFrom reactable reactableOutput
#' @noRd
app_ui <- function(request) {
  tagList(
    golem_add_external_resources(),
    semanticPage(
      title = "Vessels",
      
      div(class = "ui container", style = "width:1127px;",
          
        h1(class = "ui header", style = "color:#aaa",
          div(class = "content",
            "Vessels: a couple of entry points"
          ),
          div(class = "content", style = "float:right;",
            tags$img(src = "https://raw.githubusercontent.com/rstudio/hex-stickers/4a66b3c2f37423aa2139ecd2123b3066895a8c98/SVG/shiny.svg",
                     width = "60px")
          )
        ),
        br(),
        div(class = "ui container",
            mod_dropdowns_ui("drops"),
        ),
        div(class = "ui raised segment", style = "width: 1127px;",
          mod_map_ui("map"),
          br(),
          div(class = "ui grid",
            div(class = "four column row",
              div(class = "column", style = "width:40% !important",
                  card(style = "width: 100%",
                       div(class = "content",
                           div(class = "header",
                               uiOutput("vessel")
                           ),
                           div(class = "meta", "Longest run"), 
                           div(class = "description", uiOutput("note"))
                       )
                  )
              ),
              div(class = "column", style = "width:60% !important",
                  card(style = "width: 100%",
                    div(class = "content",
                      div(class = "header", style = "text-align: center;",
                        "Vessel details"
                      ),
                      div(class = "description", reactableOutput("details"))
                  )
                )
              )
            )
          )
        )
      )
    )
  )
}

#' Add external Resources to the Application
#' 
#' This function is internally used to add external 
#' resources inside the Shiny application. 
#' 
#' @importFrom shiny tags
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){
  
  add_resource_path(
    'www', app_sys('app/www')
  )
 
  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'vessels'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert() 
  )
}

