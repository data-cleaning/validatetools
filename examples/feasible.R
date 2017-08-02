rules <- validator( x > 0)

is_infeasible(rules)

rules <- validator( x > 0
                  , x < 0
                  )

is_infeasible(rules)
