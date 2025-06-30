rules <- validator( rule1 = x > 1
                  , rule2 = x > 2
                  )

# rule1 is superfluous
remove_redundancy(rules, verbose=TRUE)

# rule 1 is implied by rule 2
is_implied_by(rules, "rule1")

rules <- validator( rule1 = x > 2
                  , rule2 = x > 2
)

# standout: rule1 and rule2, oldest rules wins
remove_redundancy(rules, verbose=TRUE)

# Note that detection signifies both rules!
detect_redundancy(rules)


