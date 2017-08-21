context("simplify_conditional")

test_that("non-relaxing clause works", {
  rules <- validator( r1 = if (x > 1) y > 3
                    , r2 = y < 2
                    )
  rules_s <- simplify_conditional(rules)
  skip_on_cran()
  
  exprs <- to_exprs(rules)
  exprs_s <- to_exprs(rules_s)
  
  skip_on_travis() 
  expect_equal(exprs_s[[1]], quote(x <= 1))
  expect_equal(exprs_s[[2]], exprs[[2]])
})

test_that("non-constraining clause works", {
  
  rules <- validator( r1 = if (x > 0) y > 0
                    , r2 = if (x < 1) y > 1
                    )
  rules_s <- simplify_conditional(rules)
  exprs <- to_exprs(rules)
  exprs_s <- to_exprs(rules_s)
  expect_equal(length(rules_s), 2)

  skip_on_travis()
  expect_equal(exprs_s[[1]], quote(y > 0))
  expect_equal(exprs_s[[2]], quote(if (x < 1)  y > 1))
})

test_that("equality constraints work", {
  rules <- validator( if (z == 0) y == 0
                    , z == 0
                    )
  rules_s <- simplify_conditional(rules)
  exprs <- to_exprs(rules)
  exprs_s <- to_exprs(rules_s)
  expect_equal(exprs_s[[1]], quote(y == 0))
  expect_equal(exprs_s[[2]], quote(z == 0))
})