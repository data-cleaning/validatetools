detect_clauses <- function(x){
  check_validator(x)
  
  is_cond <- errorlocate::is_conditional(x)
  vals <- x$exprs()
  lapply(vals[is_cond], function(cond){
    clauses <- as_clause(cond)
    for (clause in clauses){
       # if (check_infeasibility(c(vals, clause))){
       #   
       # }
    }
  })
  do.call(validate::validator, vals)
}

# check_infeais
# 
# x <- rules <- validator( if (x > 1) y > 3
#                        , y < 2
#                        )
# 
# detect_clauses(rules)