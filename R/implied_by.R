#' Find which rule(s) imply a rule
#' 
#' Find out which rules are causing rule_name(s) to be redundant.
#' A rule set can contain rules that are implied by the other rules, so it is
#' superfluous, see examples.
#' @example ./examples/redundancy.R
#' @export
#' @param x [validate::validator()] object with rule
#' @param rule_name `character` with the names of the rules to be checked
#' @param ... not used
#' @param verbose if `TRUE` print information to the console
#' @family redundancy
#' @return `character` with the names of the rule that cause the implication.
is_implied_by <- function(x, rule_name, ..., verbose = interactive()){
  check_validator(x)
  idx <- match(rule_name, names(x), 0)
  if (any(idx == 0L)){
    nms <- paste0('"', rule_name[idx==0L],'"', collapse = ", ")
    warning("Rule(s) ", nms, " not found in 'x'", call. = FALSE)
  }
  x_org <- x[-idx]
  x_r <- x[idx] # contains the set of rules that are redundant
  if (length(x_r) == 0){
    return(character())
  }

  exprs_org <- to_exprs(x_org)
  # TODO check if x_r can be transformed into mixed integer problem
  exprs_r <- to_exprs(x_r)
  
  negated_rules <- lapply(exprs_r, function(e){
    dnf <- as_dnf(e)
    neg_dnf <- lapply(dnf, invert_or_negate)
    #neg_expr <- lapply(neg_dnf, as.expression)
    neg_dnf
  })
  
  negated_rules <- unlist(negated_rules, recursive = FALSE)
  names(negated_rules) <- paste0(".negated_", names(negated_rules))
  test_rules <- do.call(validate::validator, c(exprs_org, negated_rules))

  # set the weights for the negated rules to a large enough value
  # weight <- rep(length(x), length(negated_rules))
  # names(weight) <- names(negated_rules)
  # detect_infeasible_rules(test_rules, weight)
  
  res <- is_contradicted_by(test_rules, names(negated_rules), verbose = FALSE)
  if (isTRUE(verbose) && length(res)){
    v <- x[rule_name] |> to_exprs() |> lapply(deparse_all)
    v_i <- x[res] |> to_exprs() |> lapply(deparse_all)
    message(
      "Rule(s)\n",
      paste0("  ", names(v),": ", v, collapse = "\n"),
      "\nimplied by:\n",
      paste0("  ", names(v_i),": ", v_i, collapse = "\n")
    )
  }
  res
}

# rules <- x <- validator(r1 = x > 1, r2 = x > 2)
# rule_name <- "r1"
# is_implied_by(rules, rule_name = rule_name)
