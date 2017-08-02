context("redundancy")

test_that("trivial example works", {
  rules <- validator( rule1 = x > 1
                    , rule2 = x > 2
                    )
  
  # rule1 is superfluous
  rules_s <- simplify_redundancy(rules)
  expect_equal(length(rules_s), 1)
  expect_equal(rules_s$rules[[1]]@expr, quote( x > 2))
  
  red <- detect_redundancy(rules)
  expect_equal(red, c(rule1 = TRUE, rule2 = FALSE))
})

test_that("double rule detection works", {
  
  rules <- validator( rule1 = x > 2
                    , rule2 = x > 2
  )
  
  rules_s <- simplify_redundancy(rules)
  expect_equal(length(rules_s), 1)
  expect_equal(names(rules_s), "rule1")

  red <- detect_redundancy(rules)
  expect_equal(red, c(rule1 = TRUE, rule2 = TRUE))
})
