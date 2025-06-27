rules <- validator(
  if (nace == "a") export == "y",
  if (nace == "a")  export == "n"
)

conflicts <- detect_contradicting_if_rules(rules)

print(conflicts)


