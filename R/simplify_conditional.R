#' Simplify conditional statements
#' 
#' Conditional rules (if-rules) may be constrained by the others rules in a validation rule set.
#' This procedure tries to simplify conditional statements.
#' @references TODO non-constraining, non-relaxing
#' @example ./examples/simplify_conditional.R
#' @export
#' @param x [validate::validator()] object with the validation rules.
#' @param ... not used.
#' @return [validate::validator()] simplified rule set.
simplify_conditional <- function(x, ...){
  x <- check_validator(x)
  
  is_cond <- is_conditional(x) | is_categorical(x)
  vals <- to_exprs(x)
  for (i in which(is_cond)){
    cond <- vals[[i]]
    
    cond <- simplify_dnf(cond, vals[-i])
    vals[[i]] <- cond

    cond <- simplify_non_constraining(cond, vals)
    vals[[i]] <- cond
    
    cond <- simplify_non_relaxing(cond, vals)
    vals[[i]] <- cond
    
  }
  # TODO set meta data correctly for the resulting rule set
  do.call(validate::validator, vals)
}


simplify_non_relaxing <- function(cond_expr, vals){
  clauses <- as_dnf(cond_expr)
  clauses[] <- lapply(clauses, function(clause){
    test_rules <- do.call(validate::validator, c(vals, clause))
    if (is_infeasible(test_rules, verbose=FALSE)){
      return(NULL)
    }
    clause
  })
  is_null <- sapply(clauses, is.null)
  as.expression(clauses[!is_null], as_if = TRUE)[[1]]
}

simplify_non_constraining <- function(cond_expr, vals){
  clauses <- as_dnf(cond_expr)
  for (clause in clauses){
    clause_neg <- invert_or_negate(clause)
    test_rules <- do.call(validate::validator, c(vals, clause_neg))
    if (is_infeasible(test_rules, verbose=FALSE)){
      return(clause)
    }
  }
  cond_expr
}

simplify_dnf <- function(cond_expr, vals){
  clauses <- as_dnf(cond_expr)
  rm <- integer()
  for (i in seq_along(clauses)){
    clause_neg <- invert_or_negate(clauses[[i]])
    for (j in seq_along(clauses)){
      
      if (i == j || j %in% rm){
        next
      }
      
      test_rules <- do.call(validate::validator,c(clauses[j], clause_neg))
      if (is_infeasible(test_rules, verbose=FALSE)){
        rm <- c(rm, j)
        next
      }
    }
  }
  if (length(rm)){
    return(as.expression.dnf(clauses[-rm], as_if = TRUE)[[1]])
  }
  cond_expr
}
