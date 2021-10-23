test_that("mod_map_ui() works()", {
  expect_is(mod_map_ui("id"), "shiny.tag.list")
})

test_that("mod_map_server() works", {
  
  data = read_data(path = "../../inst/ships_04112020/ships.csv", to_keep = NULL)
  data = data[SHIPNAME == "PINTA" & ship_type == "Cargo"]
  
  shiny::testServer( mod_map_server,
                     args = list(
                       r = reactiveValues(
                         max_data = get_max_data(data)
                       )
                     ), {
    expect_is(session$output$map, "json")
  })
})
