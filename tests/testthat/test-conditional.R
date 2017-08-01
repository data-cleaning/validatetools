context("conditional")

test_that("normalize conditional", {
  expr <- quote(if (x > 1) y > 3)
  clause <- as_clause(expr)
  expect_equal(length(clause), 2)
})


test_that("clause as.character", {
  expr <- quote(if (x > 1) y > 3)
  clause <- as_clause(expr)
  expect_equal(as.character(clause), "x <= 1 | y > 3")
})

test_that("clause as if", {
  expr <- quote(if (x > 1) y > 3)
  clause <- as_clause(expr)
  expect_equal(as.character(clause, as_if = TRUE), "if (x > 1) y > 3")
})
