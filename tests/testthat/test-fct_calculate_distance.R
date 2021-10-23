

test_that("read_data() works", {
  data = read_data("../../inst/ships_04112020/ships.csv", to_keep = NULL)
  
  testthat::expect_is(data, "data.table")
  testthat::expect_gt(nrow(data), 0)
  testthat::expect_equal(ncol(data), 20)
  testthat::expect_success(testthat::expect_true("Cargo" %in% data$ship_type))
})


test_that("get_max_data() works properly", {
  data = read_data("../../inst/ships_04112020/ships.csv", to_keep = NULL)
  data = data[SHIPNAME == "PINTA" & ship_type == "Cargo"]
  max_data = get_max_data(data)
  
  testthat::expect_equal(nrow(max_data), 2)
  testthat::expect_is(max_data, "data.table")
  testthat::expect_is(max_data$distances, "numeric")
  testthat::expect_equal(max_data$SHIPNAME[1], max_data$SHIPNAME[2])
  testthat::expect_equal(max_data$ship_type[1], max_data$ship_type[2])
})
