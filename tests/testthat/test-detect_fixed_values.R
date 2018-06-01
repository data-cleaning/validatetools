context("detect_fixed_variables")

test_that("trivial example", {
  rules <- validate::validator( x >=0, x <= 0)
  fixed_variables <- detect_fixed_variables(rules)
  expect_equal(length(fixed_variables), 1)
  expect_equal(fixed_variables$x, 0)
})

test_that("Pure categorical constraints work", {
  rules <- validate::validator( if (A == "a") B == "b"
                              , A == "a"
                              )
  fixed_variables <- detect_fixed_variables(rules)
  expect_equal(length(fixed_variables), 2)
  expect_equal(fixed_variables$A, "a")
  expect_equal(fixed_variables$B, "b")
})

test_that("a more complex example", {
  rules <- validate::validator( x1 + x2 + x3 == 0
                              , x1 + x2 >= 0
                              , x3 >= 0
                              )
  fixed_variables <- detect_fixed_variables(rules)
  expect_equal(length(fixed_variables), 1)
  expect_equal(fixed_variables$x3, 0)
})

context("simplify_fixed_variables")

test_that("trivial example", {
  rules <- validate::validator( x >=0, x <= 0)
  rules_s <- simplify_fixed_variables(rules)
  expect_equal(length(rules_s), 1)
  expect_equal(rules_s$rules[[1]]@expr, quote(x == 0))
})

test_that("no fixed values generates a message", {
  rules <- validate::validator( x >=0 )
  rules_s <- simplify_fixed_variables(rules)
  expect_equal(to_exprs(rules), to_exprs(rules_s))
})


test_that("a more complex example", {
  rules <- validate::validator( x1 + x2 + x3 == 0
                              , x1 + x2 >= 0
                              , x3 >= 0
                              )
  rules_s <- simplify_fixed_variables(rules)
})
