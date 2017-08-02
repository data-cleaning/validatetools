context("is_infeasible")

test_that("is_infeasbile works", {
  rules <- validate::validator(x > 1)
  expect_false(is_infeasible(rules))
  
  rules <- validate::validator(x > 1, x < 0)
  expect_true(is_infeasible(rules))
})

test_that("is_infeasible ignore non mip rules",{
  rules <- validate::validator(x > 1, x < 0, sum(x) > 0)
#  expect_warning(
    mip <- errorlocate::miprules(rules)
#  )
  expect_true(mip$is_infeasible())
})
