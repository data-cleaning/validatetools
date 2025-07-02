library(validate)
rules <- validator(x == 1, x == 2)

is_feasible(rules, verbose=TRUE)
detect_infeasible_rules(rules)

rules <- validator(x == "1", x == "2")
is_feasible(rules, verbose=TRUE)



conflicts <- detect_infeasible_rules(rules, verbose=TRUE)
conflicts
conflict2 <- is_contradicted_by(rules, conflicts, verbose=TRUE)
make_feasible(rules)


