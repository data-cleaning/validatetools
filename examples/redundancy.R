rules <- validator( rule1 = x > 1
                  , rule2 = x > 2
                  )

# rule1 is superfluous
simplify_redundancy(rules)

rules <- validator( rule1 = x > 2
                  , rule2 = x > 2
)

# standout: rule1 and rule2, oldest rules wins
simplify_redundancy(rules)

# Note that detection signifies both rules!
detect_redundancy(rules)
