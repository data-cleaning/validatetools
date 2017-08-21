rules <- validator( x > 0
                  , if (x >= 0) y == 1
                  , A %in% c("a1", "a2")
                  , if (A == "a1") y > 1
                  )

simplify_conditional(rules)
simplify_fixed_values(rules)

simplify_rules(rules)
