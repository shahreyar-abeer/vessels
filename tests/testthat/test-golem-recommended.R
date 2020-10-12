test_that("app ui", {
  ui <- app_ui()
  golem::expect_shinytaglist(ui)
})

test_that("app server", {
  server <- app_server
  expect_is(server, "function")
})

test_that(
  "app launches",{
    skip_if_not(interactive())
    golem::expect_running(sleep = 5)
  }
)