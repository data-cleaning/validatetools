context("simplify_conditional")

test_that("non-relaxing clause works", {
  rules <- validator( r1 = if (x > 1) y > 3
                    , r2 = y < 2
                    )
  rules_s <- simplify_conditional(rules)
  
  exprs <- rules$exprs()
  exprs_s <- rules_s$exprs()
  
  expect_equal(exprs_s[[1]], quote(x <= 1))
  expect_equal(exprs_s[[2]], exprs[[2]])
})


test_that("non-constraining clause works", {
  
  rules <- validator( r1 = if (x > 0) y > 0
                    , r2 = if (x < 1) y > 1
                    )
  rules_s <- simplify_conditional(rules)
  
  exprs <- rules$exprs()
  exprs_s <- rules_s$exprs()
  expect_equal(length(rules_s), 2)
  expect_equal(exprs_s[[1]], quote(y > 0))
  expect_equal(exprs_s[[2]], quote(x >= 1 | y > 1))
  #skip_on_cran()
})
