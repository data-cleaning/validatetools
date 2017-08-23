context("simplify_rules")

test_that("simplify rules works", {
  rules <- validator( x > 0
                      , if (x > 0) y == 1
                      , A %in% c("a1", "a2")
                      , if (A == "a1") y > 1
  )
  
  rules_s <- simplify_rules(rules)
  exprs_s <- to_exprs(rules_s)
  expect_equal(length(exprs_s), 3)
  expect_equal(exprs_s$V1, quote(x > 0))
  expect_equal(exprs_s$.const_y, quote(y == 1))
  expect_equal(exprs_s$.const_A, quote(A == "a2"))
})
