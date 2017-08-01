context("detect_fixed_values")

test_that("trivial example", {
  rules <- validate::validator( x >=0, x <= 0)
  expect_warning(fixed_values <- detect_fixed_values(rules))
  expect_equal(length(fixed_values), 1)
  expect_equal(fixed_values$x, 0)
})
