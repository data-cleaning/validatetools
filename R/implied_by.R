#' Find which rule(s) make rule_name redundant
#' 
#' Find out which rules are causing rule_name(s) to be redundant.
#' @param x \code{\link{validator}} object with rule
#' @param rule_name \code{character} with the names of the rules to be checked
#' @param ... not used
#' @return \code{character} with the names of the rule that cause the implication.
is_implied_by <- function(x, rule_name, ...){
  check_validator(x)
  idx <- match(rule_name, names(x))
  x_org <- x[-idx]
  x_r <- x[idx] # contains the set of rules that are redundant
  if (length(x_r) == 0){
    return(character())
  }
  N <- length(x)
  
  exprs_org <- to_exprs(x_org)
  # TODO check if x_r can be transformed into mixed integer problem
  exprs_r <- to_exprs(x_r)
  
  negated_rules <- lapply(exprs_r, as_dnf)
  #negated_rules <- lapply(negated_rules, inverse.)

  negated_rules <- lapply(dnf, invert_or_negate)
  
  # We allow the injection of multiple rules (a negation of a disjunction are multiple rules!)
  dnf_set <- c(dnf_set[-i], negated_rules)
  #names(dnf_set) <- make.unique(names(dnf_set))
  
  exprs <- unlist(lapply(dnf_set, as.expression))
  test_rules <- do.call(validate::validator, exprs)
  test_rules
}

# rules <- x <- validator(r1 = x > 1, r2 = x > 2)
# rule_name <- "r1"
# is_implied_by(rules, rule_name = rule_name)
