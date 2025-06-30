#' Detect redundant rules
#' 
#' Detect redundancies in a rule set, but do not remove the rules.
#' A rule in a ruleset can be redundant if it is implied by another rule
#' or by a combination of rules. See the examples for more information.
#' 
#' @note For removal of duplicate rules, simplify
#' @example ./examples/redundancy.R
#' @param x [validate::validator()] object with the validation rules.
#' @param ... not used.
#' @param verbose if `TRUE` print the redundant rule(s) to the console
#' 
#' @family redundancy
#' 
#' @export
detect_redundancy <- function(x, ..., verbose=interactive()){
  x <- check_validator(x)
  can_be_checked <- is_linear(x) | is_categorical(x) | is_conditional(x)
  vals <- to_exprs(x)
  dnf_set <- lapply(vals[can_be_checked], as_dnf)
  are_redundant <- sapply(seq_along(dnf_set), function(i){
    is_redundant(dnf_set, i)
  })
  
  idx <- which(can_be_checked)[are_redundant]
  ret <- logical(length = length(vals))
  names(ret) <- names(vals)
  ret[idx] <- TRUE
  if (isTRUE(verbose) && any(ret)){
    v <- x[names(ret)[ret]] |> to_exprs() |>  lapply(deparse_all)
    message(
      "Redundant rule(s):\n",
      paste0("  ", names(v), ": ", v, collapse = "\n")
    )
  }
  ret
}

#' Remove redundant rules
#' 
#' Simplify a rule set by removing redundant rules, i.e. rules that are implied by other rules.
#' @export
#' @example ./examples/redundancy.R
#' @param x [validate::validator()] object with validation rules.
#' @param ... not used
#' @param verbose if `TRUE` print the remove rules to the console.
#' 
#' @family redundancy
#' 
#' @return simplified [validate::validator()] object, in which redundant rules are removed.
remove_redundancy <- function(x, ..., verbose = interactive()){
  x <- check_validator(x)

  can_be_checked <- is_linear(x) | is_categorical(x) | is_conditional(x)
  
  vals <- to_exprs(x)
  dnf_set <- lapply(vals[can_be_checked], as_dnf)
  red <- character()
  for (i in rev(seq_along(dnf_set))){  # remove later rules before older rules 
    if (is_redundant(dnf_set, i)){
      red <- c(red, names(dnf_set)[i])
      dnf_set[[i]] <- list()
    }
  }
  if (length(red) && isTRUE(verbose)){
    v <- x[red] |> to_exprs() |> lapply(deparse_all) 
    message(
      "Removed redundant rule(s):\n",
      paste0("  ", names(v), ": ", v, collapse = "\n")
   )
  }
  vals[can_be_checked] <- lapply(dnf_set, as.expression)
  vals <- unlist(vals) # this removes empty expressions
  do.call(validate::validator, vals)
}

# utility function for checking if rule i is redundant.
is_redundant <- function(dnf_set, i, ...){
  dnf <- dnf_set[[i]]
  negated_rules <- lapply(dnf, invert_or_negate)

  # We allow the injection of multiple rules (a negation of a disjunction are multiple rules!)
  dnf_set <- c(dnf_set[-i], negated_rules)
  #names(dnf_set) <- make.unique(names(dnf_set))
  
  exprs <- unlist(lapply(dnf_set, as.expression))
  test_rules <- do.call(validate::validator, exprs)
  # if (i == 2){
  #   for (n in ls()){
  #     cat(n, ': \n')
  #     print(get(n))
  #   }
  # }
  is_infeasible(test_rules)
}

# x <- validator( rule1 = x > 1
#               , rule2 = x > 2
#               )
# remove_redundancy(x)
# detect_redundancy(x)
