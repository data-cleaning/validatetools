context("detect_boundary")

test_that("detect num boundary works", {
  rules <- validate::validator(
    x >= 1,
    x + y <= 10,
    y >= 5
  )

  bounds <- detect_boundary_num(rules)
  expect_equal(bounds[,"x"], c(lower=1, upper=5))
  expect_equal(bounds[,"y"], c(lower=5, upper=9))
})

test_that("detect num boundary works", {
  rules <- validate::validator(
    x >= 1
  )
  
  bounds <- detect_boundary_num(rules)
  expect_equal(bounds[,"x"], c(lower=1, upper=Inf))
})
