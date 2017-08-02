context("detect_fixed_values")

test_that("trivial example", {
  rules <- validate::validator( x >=0, x <= 0)
  expect_warning(fixed_values <- detect_fixed_values(rules))
  expect_equal(length(fixed_values), 1)
  expect_equal(fixed_values$x, 0)
})


test_that("a more complex example", {
  rules <- validate::validator( x1 + x2 + x3 == 0
                              , x1 + x2 >= 0
                              , x3 >= 0
                              )
  expect_warning(fixed_values <- detect_fixed_values(rules))
  expect_equal(length(fixed_values), 1)
  expect_equal(fixed_values$x3, 0)
})

context("simplify_fixed_values")

test_that("trivial example", {
  rules <- validate::validator( x >=0, x <= 0)
  expect_warning(rules_s <- simplify_fixed_values(rules))
  expect_equal(length(rules_s), 1)
  expect_equal(rules_s$rules[[1]]@expr, quote(x == 0))
})


test_that("a more complex example", {
  rules <- validate::validator( x1 + x2 + x3 == 0
                              , x1 + x2 >= 0
                              , x3 >= 0
                              )
  expect_warning(rules_s <- simplify_fixed_values(rules))
})
