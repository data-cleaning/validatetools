context("dnf")

test_that("dnf", {
  expr <- quote(if (x > 1) y > 3)
  clause <- as_dnf(expr)
  expect_equal(length(clause), 2)
})

test_that("rewritten if", {
  expr <- quote(!(gender %in% "male" & y > 3) | x > 6)
  clause <- as_dnf(expr)
  expect_equal(as.character(clause), '!(gender %in% "male") | y <= 3 | x > 6')
})

test_that("clause as.character", {
  expr <- quote(if (x > 1) y > 3)
  clause <- as_dnf(expr)
  expect_equal(as.character(clause), "x <= 1 | y > 3")
})

test_that("clause as if", {
  expr <- quote(if (x > 1) y > 3)
  clause <- as_dnf(expr)
  expect_equal(as.character(clause, as_if = TRUE), "if (x > 1) y > 3")
  
  expr <- quote(if (x > 1) (y > 3))
  clause <- as_dnf(expr)
  expect_equal(as.character(clause, as_if = TRUE), "if (x > 1) y > 3")

  expr <- quote(!(x > 1)|(y > 3))
  clause <- as_dnf(expr)
  expect_equal(as.character(clause, as_if = TRUE), "if (x > 1) y > 3")

  expr <- quote(!(x > 1) | y > 3)
  clause <- as_dnf(expr)
  expect_equal(as.character(clause, as_if = TRUE), "if (x > 1) y > 3")

  expr <- quote(!(x > 1 & z > 2) | y > 3)
  clause <- as_dnf(expr)
  expect_equal(as.character(clause), "x <= 1 | z <= 2 | y > 3")
  expect_equal(as.character(clause, as_if=TRUE), "if (x > 1 & z > 2) y > 3")
})

test_that("simple clause works",{
  expr <- quote(x > 1)
  clause <- as_dnf(expr)
  expect_equal(as.character(clause), "x > 1")
  
  expr <- quote((x > 1))
  clause <- as_dnf(expr)
  expect_equal(as.character(clause), "x > 1")

  expr <- quote(!(x > 1))
  clause <- as_dnf(expr)
  expect_equal(as.character(clause), "x <= 1")
})

#as_dnf(quote( )