rules <- validator( x > 0)

is_infeasible(rules)

# infeasible system!
rules <- validator( rule1 = x > 0
                  , rule2 = x < 0
                  )

is_infeasible(rules)

detect_infeasible_rules(rules, verbose=TRUE)

# but we want to keep rule1, so specify that it has an Inf weight
detect_infeasible_rules(rules, weight=c(rule1=Inf), verbose=TRUE)

# detect and remove
make_feasible(rules, weight=c(rule1=Inf), verbose = TRUE)

# find out the conflict with rule2
is_contradicted_by(rules, "rule2", verbose = TRUE)
