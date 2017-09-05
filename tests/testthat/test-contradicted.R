context("contradicted")

test_that("is_contradicted_by works", {
  rules <- validator( r1 = x > 1
                    , r2 = x < 0
                    , r3 = x > 2
                    )
  rules_cd <- is_contradicted_by(rules, "r2")
  expect_equal(rules_cd, c("r1", "r3"))
})

test_that("is_contradicted_by works for non-contradicting rule", {
  rules <- validator( r1 = x > 1
                    , r2 = y > 2
                    )
  rules_cd <- is_contradicted_by(rules, "r2")
  expect_equal(rules_cd, character())
})

test_that("is_contradicted_by works for multiple rules (IIS)", {
  rules <- validator( r1 = x > 0
                    , r2 = y > 0
                    , r3 = x + y == -1
                    )
  
  rules_cd <- is_contradicted_by(rules,"r3")
  expect_equal(rules_cd, c("r2","r1"))
})


