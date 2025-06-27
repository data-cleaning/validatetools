rules <- validator(
  if (nace == "a") export == "y",
  if (nace == "a")  export == "n"
)

detect_contradicting_if_rules(rules)
