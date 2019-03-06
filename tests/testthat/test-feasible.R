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

test_that("make_feasible works", {
  rules <- validator( x > 1, r2 = x < 0, x > 2)
  expect_message(rules_f <- make_feasible(rules))
  exprs_f <- to_exprs(rules_f)
  expect_equal(exprs_f[[1]], quote(x > 1))
  expect_equal(exprs_f[[2]], quote(x > 2))
})

test_that("make_feasible works with weights", {
  rules <- validator( x > 1, r2 = x < 0, x > 2)
  expect_message(rules_f <- make_feasible(rules, weight = c(r2=10)))
  exprs_f <- to_exprs(rules_f)
  expect_equal(exprs_f[[1]], quote(x < 0))
})

test_that("detect_infeasible_rules with equality constraint works",{
  rules <- validator( r1 = x == 0
                    , r2 = x == 1
                    )
  res <- detect_infeasible_rules(rules)
  expect_equal(res, "r1")
})


test_that("detect_infeasible_rules with equality constraint works",{
  rules <- validator( r1 = if ( x > 1) y < 0
                    , r2 = x > 2
                    , r3 = y > 1
                    )
  res <- detect_infeasible_rules(rules)
  expect_equal(res, "r3")
})

test_that("detect_infeasible works on categorical rules", {
  rules <- validator( dA = A %in% c("a1", "a2")
                      , r1 = A == "a1"
                      , r2 = A == "a2"
  )
  res <- detect_infeasible_rules(rules)
  expect_equal(res, "r1")
})

test_that("detect_infeasible works on negated categorical rules", {
  rules <- validator( dA = A %in% c("a1", "a2")
                      , r1 = A == "a1"
                      , r2 = !(A == "a1")
  )
  res <- detect_infeasible_rules(rules)
  expect_equal(res, "r1")
})
