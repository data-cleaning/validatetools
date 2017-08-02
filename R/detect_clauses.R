#' @export
simplify_conditional <- function(x){
  check_validator(x)
  
  is_cond <- errorlocate::is_conditional(x)
  vals <- x$exprs()
  vals[is_cond] <- 
    lapply(vals[is_cond], function(cond){
      clauses <- as_clause(cond)
      clauses <- simplify_non_constraining(clauses, vals)
      clauses <- simplify_non_restraining(clauses, vals)
      as.expression(clauses)[[1]]
    })
  # TODO set meta data correctly for the resulting rule set
  do.call(validate::validator, vals)
}


simplify_non_restraining <- function(clauses, vals){
  clauses_s <- lapply(clauses, function(clause){
    test_rules <- do.call(validate::validator, c(vals, clause))
    if (is_infeasible(test_rules)){
      return(NULL)
    }
    clause
  })
  clauses_s
}

simplify_non_constraining <- function(clauses, vals){
  clauses_s <- clauses 
  for (clause in clauses){
    clause_neg <- invert_or_negate(clause)
    test_rules <- do.call(validate::validator, c(vals, clause_neg))
    if (is_infeasible(test_rules)){
      clauses_s <- structure(list(clause), "clause")
      break
    }
  }
  clauses_s
}

# check_infeais
# 
# x <- rules <- validate::validator( if (x > 1) y > 3
#                        , y < 2
#                        )
# #
# detect_clauses(rules)
