library(testthat)

context("categorical domain tests")

describe("infeasible", {
  it("detects infeasible rules with domain set", {
    v <- validator( a %in% c("a1", "a2"),
                    a == "a1",
                    a == "a2"
                  )
    expect_true(is_infeasible(v))
  })
  
  it("detects infeasible rules no domain set", {
    v <- validator( a == "a1",
                    a == "a2"
    )
    expect_true(is_infeasible(v))
  })
  
  it("detects infeasible rules no domain set", {
    v <- validator( a == "a1",
                    a == "a2",
                    b == "b1",
                    c == "c1"
    )
    expect_true(is_infeasible(v))
  })
  
  
})