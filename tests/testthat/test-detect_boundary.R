context("detect_boundary")

test_that("detect num boundary works", {
  rules <- validate::validator(
    x >= 1,
    x + y <= 10,
    y >= 6
  )

  bounds <- detect_boundary_num(rules)
  expect_equal(bounds$lowerbound, c(1,6))
  expect_equal(bounds$upperbound, c(4, 9))
})

test_that("detect num boundary works", {
  rules <- validate::validator(
    x >= 1
  )
  
  bounds <- detect_boundary_num(rules)
  expect_equal(as.list(bounds[1,]), list(variable="x", lowerbound=1, upperbound=Inf))
})

test_that("detect num boundary works without num variables", {
  rules <- validate::validator(
    if (A == "a")  B == "b"
  )
  bounds <- detect_boundary_num(rules)
  expect_equal(nrow(bounds), 0)
})

test_that("detect cat boundary works", {
  rules <- x <-  validator( x > 1
                          , if (x > 0) A == 'a1'
                          , B %in% c("b1", "b2")
                          )
  cat_bounds <- detect_boundary_cat(rules)
  expect_equal(as.list(cat_bounds[1,]), list(variable="A", value="a1", min=1, max=1))
  expect_equal(as.list(cat_bounds[2,]), list(variable="B", value="b1", min=0, max=1))
  expect_equal(as.list(cat_bounds[3,]), list(variable="B", value="b2", min=0, max=1))
})

test_that("detect cat boundary works for longer named variables", {
  rules <- validator(
    job %in% c("yes", "no"),
    if (job == "no") income == 0,
    income > 0
  )
  
  cat_bounds <- detect_boundary_cat(rules)
  expect_equal(as.list(cat_bounds[1,]), list(variable="job", value="yes", min=1, max=1))
  expect_equal(as.list(cat_bounds[2,]), list(variable="job", value="no", min=0, max=0))
})

