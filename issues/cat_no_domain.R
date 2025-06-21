library(validate)
rules <- validator(x == 1, x == 2)

is_feasible(rules)
detect_infeasible_rules(rules)

rules <- validator(x == "1", x == "2")
is_feasible(rules)



conflicts <- detect_infeasible_rules(rules)
conflict
conflict2 <- is_contradicted_by(rules, conflicts)
make_feasible(rules)
