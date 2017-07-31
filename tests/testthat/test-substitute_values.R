context("substitute_values")
library(validate)

test_that("substitute trival works", {
  rules <- validator(rule1 = x > 1)
  rules_sv  <- substitute_values(rules, list(x=2)) 
  expect_equal(rules_sv$rules, list())
})

test_that("substitute multiple value works", {
  rules <- validator(rule1 = x > 1, rule2 = y > x)
  rules_sv  <- substitute_values(rules, list(x=2, y=3))
  expect_equal(rules_sv$rules, list())
})

test_that("substitute_value works", {
  rules <- validator(rule1 = x > 1, rule2 = y > x)
  rules_sv  <- substitute_values(rules, list(x=2))
  expect_equal(length(rules_sv$rules), 1)
  rule2 <- rules_sv[[1]]
  
  expect_equal(rule2@name, "rule2")
  expect_equal(rule2@expr, quote(y > 2))
})

test_that("substitute wrong value gives warning", {
  rules <- validator(rule1 = x > 1)
  expect_warning(
    substitute_values(rules, list(x=0))
  ) 
})


test_that("substitute_value works with components", {
  rules <- validator(gender %in% c("male","female"), if (gender == "male") x > 6)
  substitute_values(rules, gender="female")
  skip("implement component check")
})
