context("detect_boundary")

test_that("detect num boundary works", {
  rules <- validate::validator(
    x >= 1,
    x + y <= 10,
    y >= 6
  )

  bounds <- detect_boundary_num(rules)
  expect_equal(bounds$lowerbound, c(1,6))
  expect_equal(bounds$upperbound, c(4, 9))
})

test_that("detect num boundary works", {
  rules <- validate::validator(
    x >= 1
  )
  
  bounds <- detect_boundary_num(rules)
  expect_equal(as.list(bounds[1,]), list(variable="x", lowerbound=1, upperbound=Inf))
})
