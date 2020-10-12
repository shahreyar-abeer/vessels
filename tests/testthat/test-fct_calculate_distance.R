test_that("get_max_data() works", {
  expect_is(get_max_data(ships2, "PINTA"), "data.table")
})
