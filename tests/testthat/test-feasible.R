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
