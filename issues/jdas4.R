library(validatetools)

rules <- validator(.file = "issues/hardk2.txt")

rules_s <- simplify_rules(rules)
