#' Simplify conditional statements
#' 
#' Conditional rules may be constrained by the others rules in a validation rule set.
#' This procedure tries to simplify conditional statements.
#' 
#' @references TODO non-constraining, non-relaxing
#' @example ./examples/simplify_conditional.R
#' @export
simplify_conditional <- function(x, ...){
  check_validator(x)
  
  is_cond <- errorlocate::is_conditional(x)
  vals <- x$exprs()
  for (i in which(is_cond)){
    cond <- vals[[i]]
    cond <- simplify_non_constraining(cond, vals)
    #cat("non_constraining:", as.expression(cond))
    vals[[i]] <- cond
    if (errorlocate:::is_condition_(cond)){
      cond <- simplify_non_relaxing(cond, vals)
      vals[[i]] <- cond
      #cat("non_relaxing:")
    }
  }
  # TODO set meta data correctly for the resulting rule set
  do.call(validate::validator, vals)
}


simplify_non_relaxing <- function(cond_expr, vals){
  clauses <- as_dnf(cond_expr)
  #browser()
  clauses[] <- lapply(clauses, function(clause){
    test_rules <- do.call(validate::validator, c(vals, clause))
    if (is_infeasible(test_rules)){
      return(NULL)
    }
    clause
  })
  as.expression(clauses)[[1]]
}

simplify_non_constraining <- function(cond_expr, vals){
  clauses <- as_dnf(cond_expr)
  for (clause in clauses){
    clause_neg <- invert_or_negate(clause)
    test_rules <- do.call(validate::validator, c(vals, clause_neg))
    if (is_infeasible(test_rules)){
      return(clause)
    }
  }
  cond_expr
}

# check_infeais
# 
# x <- rules <- validate::validator( if (x > 1) y > 3
#                        , y < 2
#                        )
# #
# simplify_conditional(rules)
