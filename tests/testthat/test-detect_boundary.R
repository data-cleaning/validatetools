context("detect_boundary")

test_that("detect num boundary works", {
  rules <- validate::validator(
    x >= 1,
    x + y <= 10,
    y >= 5
  )

  bounds <- detect_boundary_num(rules)
  expect_equal(bounds$x$lower, 1)
  expect_equal(bounds$x$upper, 5)
  expect_equal(bounds$y$lower, 5)
  expect_equal(bounds$y$upper, 9)
})

test_that("detect num boundary works", {
  rules <- validate::validator(
    x >= 1
  )
  
  bounds <- detect_boundary_num(rules)
  expect_equal(bounds$x$lower, 1)
  expect_equal(bounds$x$upper, Inf)
})
