context("is_infeasible")

test_that("is_infeasbile works", {
  rules <- validate::validator(x > 1)
  mip <- errorlocate::miprules(rules)
  expect_false(mip$is_infeasible())
  
  rules <- validate::validator(x > 1, x < 0)
  mip <- errorlocate::miprules(rules)
  expect_true(mip$is_infeasible())
})

test_that("is_infeasible ignore non mip rules",{
  skip("Implement warning")
  rules <- validate::validator(x > 1, x < 0, sum(x) > 0)
  mip <- errorlocate::miprules(rules)
  expect_true(mip$is_infeasible())
})
