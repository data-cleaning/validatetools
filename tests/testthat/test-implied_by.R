context("implied_by")

test_that("is_implied_by finds the implicating rule", {
  rules <- validator(r1 = x > 1, r2 = x > 2)
  res <- is_implied_by(rules, rule_name = "r1")
  expect_equal(res, "r2")
})

test_that("is_implied_by works for non-redundant rules", {
  rules <- validator(r1 = x > 1, r2 = y > 2)
  res <- is_implied_by(rules, rule_name = "r1")
  expect_equal(res, character())
})

test_that("is_implied_by with equality constraint", {
  rules <- validator(r1 = x == 12, r2 = x > 6)
  res <- is_implied_by(rules, rule_name = "r2")
  expect_equal(res, "r1")
})

test_that("is_implied_by with no rule name", {
  rules <- validator(r1 = x == 12, r2 = x > 6)
  res <- is_implied_by(rules, rule_name = NULL)
  expect_equal(res, character())
})

test_that("is_implied_by with wrong rule name", {
  rules <- validator(r1 = x == 12, r2 = x > 6)
  expect_warning(res <- is_implied_by(rules, rule_name = "r3"), regexp = "not found")
  expect_equal(res, character())
})


test_that("is_implied_by works with multiple implicators", {
  rules <- validator( r1 = x + y >= 0
                    , r2 = x >= 0
                    , r3 = y >= 0
                    )
  res <- is_implied_by(rules, rule_name = "r1")
  expect_equal(res, c("r2","r3"))
  
  rules <- validator( r1 = x >= 0
                    , r2 = x >= 1
                    , r3 = x >= 2
                    )
  res <- is_implied_by(rules, rule_name = "r1")
  expect_equal(res, c("r2","r3"))
})
