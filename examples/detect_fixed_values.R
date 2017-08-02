\dontrun{
library(validate)
rules <- validator( x >= 0
                  , x <= 0
                  )
detect_fixed_values(rules)
simplify_fixed_values(rules)
}

  # rules <- validate::validator( x1 + x2 + x3 == 0
  #                               , x1 + x2 >= 0
  #                               , x3 >= 0
  # )
