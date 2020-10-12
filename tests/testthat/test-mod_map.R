test_that("mod_map_ui() works()", {
  expect_is(mod_map_ui("id"), "shiny.tag.list")
})

test_that("mod_map_server() works", {
  r = data.frame(
    max_data = get_max_data(ships2, "PINTA")
  )
  shiny::testServer( mod_map_server,
                     args = list(
                       r = reactiveValues(
                         max_data = get_max_data(ships2, "PINTA")
                       )
                     ), {
    expect_is(session$output$map, "json")
  })
})
