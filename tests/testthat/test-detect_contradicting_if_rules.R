context("if clauses")

describe("detect contradictory categorical if clauses", {
  it("detects contradictory if clauses", {
    v <- validator(
      if (a == "a") b == "b1",
      if (a == "a") b == "b2"
    )
    
    expect_output_file(
      a <- detect_contradicting_if_rules(v, verbose = TRUE),
      file = "detect_contradicting_if_rules.txt"
    )
    expect_equal(a, list("a == \"a\"" = c("V1", "V2")))
  })
  
  it("detects contradictory numerical consequents clauses", {
    v <- validator(
      if (a == "a") x > 1,
      if (a == "a") x < -1
    )
    
     a <- detect_contradicting_if_rules(v, verbose = FALSE)
     expect_equal(a, list("a == \"a\"" = c("V2", "V1")))
  })
  
  it("detects contradictory categorical consequents clauses", {
    v <- validator(
      if (x > 0) b == "b1",
      if (x > 0) b == "b2"
    )
    
    a <- detect_contradicting_if_rules(v, verbose=FALSE)
    expect_equal(a, list("x > 0" = c("V2", "V1")))
  })
  
  it("detects contradictory categorical consequents clauses", {
    v <- validator(
      if (x > 0) y  > 0,
      if (x > 0) y < 0
    )
    
    a <- detect_contradicting_if_rules(v, verbose=FALSE)
    expect_equal(a, list("x > 0" = c("V2", "V1")))
  })
  
  it("detects conflicting chains", {
    v <- validator(
      if (income > 0) job == "yes",
      if (job == "yes") income == 0
    )
    
    a <- detect_contradicting_if_rules(v, verbose=FALSE)
    expect_equal(a, list("income > 0" = c("V2", "V1")))
  })

  it("detects multi conditions 1", {
    v <- validator(
      if (nace == "a" && export > 0) international == TRUE,
      if (nace == "a") international == FALSE
    )
    
    a <- detect_contradicting_if_rules(v, verbose=FALSE)
    expect_equal(a, list("nace == \"a\" && export > 0" = c("V2", "V1")))
  })
  
  it("detects multi conditions 2", {
    v <- validator(
      if (income > 0) status == "working" | status == "self-employed",
      if (status == "unemployed") income > 0
    )
    
    a <- detect_contradicting_if_rules(v, verbose=FALSE)
    expect_equal(a, list("status == \"unemployed\"" = c("V1", "V2")))
  })
  
  
})
