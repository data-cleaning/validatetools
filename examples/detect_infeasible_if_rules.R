rules <- validator(
  if (nace == "a") export == "y",
  if (nace == "a")  export == "n"
)

detect_infeasible_if_rules(rules)
