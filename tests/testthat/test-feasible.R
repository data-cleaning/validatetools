context("feasible")

test_that("trivial feasible works", {
  rules <- validator( x > 0)
  
  expect_false(is_infeasible(rules))
})

test_that("infeasible works", {
  rules <- validator( x > 0
                    , x < 0
                    )
  
  expect_true(is_infeasible(rules))
})

test_that("trivial feasible works", {
  rules <- validator( x > 0)
  expect_message({
    rules_s <- make_feasible(rules)
  }, "returning original rule set")
  expect_identical(rules_s, rules)
})

test_that("errorring works",{
  expect_error(is_infeasible("A"), "This method needs a 'validator'")
})
