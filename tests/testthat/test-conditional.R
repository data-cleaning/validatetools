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

test_that("low level stuff works", {
  # to test for op edge case
  expect_equal(op(quote(1)), 1)
  
  # to test for or statement
  expr <- quote( x > 1 || y > 2)
  dnf <- as_dnf(expr)
  expect_equal(as.character(dnf), "x > 1 | y > 2")
  
  # to test for print (output is equal to previous test)
  expect_output(print(dnf), as.character(dnf))
  
  # invalid expression
  expr <- quote(while(true){})
  expect_error(as_dnf(expr), "Invalid expression")
})


#as_dnf(quote( )