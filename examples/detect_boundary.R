rules <- validator(
  x >= 1,
  x + y <= 10,
  y >= 6
)

detect_boundary_num(rules)

rules <- validator(
  job %in% c("yes", "no"),
  if (job == "no") income == 0,
  income > 0
)

detect_boundary_cat(rules)
