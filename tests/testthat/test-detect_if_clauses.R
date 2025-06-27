context("if clauses")

describe("detect contradictory categorical if clauses", {
  it("detects contradictory if clauses", {
    v <- validator(
      if (a == "a") b == "b1",
      if (a == "a") b == "b2"
    )
    
    a <- detect_infeasible_if_rules(v)
    expect_equal(a, list("a == \"a\"" = c("V1", "V2")))
  })
  
  it("detects contradictory numerical consequents clauses", {
    v <- validator(
      if (a == "a") x > 1,
      if (a == "a") x < -1
    )
    
     a <- detect_infeasible_if_rules(v)
     expect_equal(a, list("a == \"a\"" = c("V2", "V1")))
  })
  
  it("detects contradictory categorical consequents clauses", {
    v <- validator(
      if (x > 0) b == "b1",
      if (x > 0) b == "b2"
    )
    
    a <- detect_infeasible_if_rules(v)
    expect_equal(a, list("x > 0" = c("V2", "V1")))
  })
  
  it("detects contradictory categorical consequents clauses", {
    v <- validator(
      if (x > 0) y  > 0,
      if (x > 0) y < 0
    )
    
    a <- detect_if_clauses(v)
    expect_equal(a, list("x > 0" = c("V2", "V1")))
  })
  
})