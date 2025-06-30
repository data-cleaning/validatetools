rules <- validator( x > 0)

is_infeasible(rules)

rules <- validator( rule1 = x > 0
                  , rule2 = x < 0
                  )

is_infeasible(rules)

detect_infeasible_rules(rules, verbose=TRUE)
make_feasible(rules, verbose = TRUE)

# find out the conflict with this rule
is_contradicted_by(rules, "rule1", verbose = TRUE)
