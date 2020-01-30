
v1 <- validator(
  A %in% c('a','b'),
  (A == "a") | (x >= -500) | (x <= 100) )

substitute_values(v1, A = 'b', .add_constraints = FALSE)

v2 <- validator(
  A %in% c('a','b'),
  (A == "a") | (x <= 100) | (x >= -500) )

r <- substitute_values(v2, A = 'b', .add_constraints = FALSE)
r
