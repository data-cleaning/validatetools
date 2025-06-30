rules <- validator(
  if (nace == "a") export == "y",
  if (nace == "a")  export == "n"
)

conflicts <- detect_contradicting_if_rules(rules, verbose=TRUE)

print(conflicts)


# this creates a implicit contradiction when income > 0
rules <- validator(
  rule1 = if (income > 0) job == "yes",
  rule2 = if (job == "yes") income == 0
)

conflicts <- detect_contradicting_if_rules(rules, verbose=TRUE)

