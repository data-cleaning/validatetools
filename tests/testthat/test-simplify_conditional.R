context("simplify_conditional")

test_that("non-relaxing clause works", {
  rules <- validator( r1 = if (x > 1) y > 3
                    , r2 = y < 2
                    )
  rules_s <- simplify_conditional(rules)
  
  exprs <- to_exprs(rules)
  exprs_s <- to_exprs(rules_s)
  
  #skip_on_travis() 
  expect_equal(exprs_s$r1, quote(x <= 1))
  expect_equal(exprs_s$r2, quote(y < 2))
})

test_that("non-relaxing clause works (pure categorical)", {
  rules <- validator( r1 = B %in% c("b1", "b2") # TODO this should not be necessary!
                    , r2 = if (A == "a") B == "b1"
                    , r3 = B == "b2"
  )
  rules_s <- simplify_conditional(rules)
  
  exprs_s <- to_exprs(rules_s)
  
  #skip_on_travis() 
  expect_equal(exprs_s$r2, quote(!(A == "a")))
})


test_that("non-constraining clause works", {
  
  rules <- validator( r1 = if (x > 0) y > 0
                    , r2 = if (x < 1) y > 1
                    )
  rules_s <- simplify_conditional(rules)
  exprs <- to_exprs(rules)
  exprs_s <- to_exprs(rules_s)
  expect_equal(length(rules_s), 2)

  #skip_on_travis()
  expect_equal(exprs_s[[1]], quote(y > 0))
  expect_equal(exprs_s[[2]], quote(if (x < 1)  y > 1))
})

test_that("non-constraining clause works (pure categorical)", {
  
  rules <- validator( dB = B %in% c("b1", "b2")
                    , dA = A %in% c("a1", "a2", "a3")
                    , r1 = if (B == "b1") A %in% c("a1", "a2")
                    , r2 = if (B == "b2") A %in% c("a2")
  )
  rules_s <- simplify_conditional(rules)
  
  exprs <- to_exprs(rules_s)
  exprs_s <- to_exprs(rules_s)

  expect_equal(length(rules_s), 4)
  
  #skip_on_travis()
  expect_equal(exprs_s$r1, quote(A %in% c("a1", "a2")))
  expect_equal(exprs_s$r2, exprs$r2)
  expect_equal(exprs_s$dA, exprs$dA) # superfluous, will be removed with remove_redundance
  expect_equal(exprs_s$dB, exprs$dB)
})

test_that("equality constraints work", {
  rules <- validator( if (z == 0) y == 0
                    , z == 0
                    )
  rules_s <- simplify_conditional(rules)
  exprs <- to_exprs(rules)
  exprs_s <- to_exprs(rules_s)
  expect_equal(exprs_s[[1]], quote(y == 0))
  expect_equal(exprs_s[[2]], quote(z == 0))
})

test_that("equality constraints work (pure categorical)", {
  rules <- validator( dA = A %in% c("a1", "a2")
                    , dB = B %in% c('b1', 'b2')
                    , r1 = if (A == "a1") B == "b1"
                    , r2 = A == "a1"
                    )
  rules_s <- simplify_conditional(rules)
  exprs <- to_exprs(rules)
  exprs_s <- to_exprs(rules_s)
  
  expect_equal(exprs_s$r1, quote(B == "b1"))
  expect_equal(exprs_s$r2, exprs$r2)
  expect_equal(exprs_s$dA, exprs$dA) # superfluous, will be removed with remove_redundance
  expect_equal(exprs_s$dB, exprs$dB)
  
})