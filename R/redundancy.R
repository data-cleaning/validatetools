#' @export
detect_redundancy <- function(x, ...){
  check_validator(x)
}

simplify_redundancy <- function(x, ...){
  check_validator(x)
  
  can_be_checked <- errorlocate::is_linear(x) | errorlocate::is_categorical(x) | errorlocate::is_conditional(x)
  
  vals <- x$exprs()
  dnf_set <- lapply(vals[can_be_checked], as_dnf)
  for (i in rev(seq_along(dnf_set))){  # remove later rules before older rules 
    if (is_redundant(dnf_set, i)){
      dnf_set[[i]] <- list()
    }
  }
  vals[can_be_checked] <- lapply(dnf_set, as.expression)
  vals <- unlist(vals) # this removes empty expressions
  do.call(validate::validator, vals)
}

is_redundant <- function(dnf_set, i, ...){
  dnf <- dnf_set[[i]]
  negated_rules <- lapply(dnf, invert_or_negate)
  
  # Note the single "[" to allow the injection of multiple rules (a negation of a disjunction are multiple rules!)
  dnf_set[i] <- negated_rules
  #names(dnf_set) <- make.unique(names(dnf_set))
  
  exprs <- unlist(lapply(dnf_set, as.expression))
  test_rules <- do.call(validate::validator, exprs)
  is_infeasible(test_rules)
}

# x <- validator( rule1 = x > 1
#               , rule2 = x > 2
#               , rule3 = x > 2
#               )
# simplify_redundancy(x)
