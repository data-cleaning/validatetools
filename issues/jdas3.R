#' ---
#' author: ejne
#' ---
library(validatetools)
#' #1
#+ test 
rules <- validator(x==0, x==1)
detect_infeasible_rules(rules)

#' #2
#detect_infeasible_rules(validator(if (x>1) y<0, x> 2, y> 1))

#' #3
rules <- validator( rule1 = x > 0
                  , rule2 = y > 0
                  , rule3 = x + y == -1
                  )

is_contradicted_by(rules,"rule2")




