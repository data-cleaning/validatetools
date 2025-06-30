#' Find out which rules are conflicting 
#' 
#' Find out for a contradicting rule which rules are conflicting. This helps in determining and assessing conflicts in rule sets. Which
#' of the rules should stay and which should go? 
#' @export
#' @example ./examples/feasible.R
#' @param x [validate::validator()] object with rules.
#' @param rule_name `character` with the names of the rules that are causing infeasibility.
#' @param verbose if `TRUE` prints the 
#' @family feasibility
#' @return `character` with conflicting rules.
is_contradicted_by <- function(x, rule_name, verbose = interactive()){
  rn <- rule_name %in% names(x)

  if (any(!rn)){
    nms <- paste0('"',rule_name[!rn], '"', collapse = ", ")
    warning("Rule(s) ", nms, " not found in rule set 'x'.", call. = FALSE)
  }
  
  N <- length(x)
  #weight <- rep(N, length(rule_name))
  weight <- rep(Inf, length(rule_name))
  names(weight) <- rule_name
  
  
  res <- character()
  contra <- detect_infeasible_rules(x, weight = weight, verbose = FALSE)
  while (length(contra) && !any(contra %in% names(weight))){
    res <- c(res, contra)
    weight[contra] <- N
    contra <- detect_infeasible_rules(x, weight = weight, verbose = FALSE)
  }
  if (isTRUE(verbose) && length(res)){
    v <- x[rule_name] |> to_exprs() |> lapply(deparse_all)
    v_cont <- x[res] |> to_exprs() |> lapply(deparse_all)
    message(
      "Rule(s): \n",
      paste0(" ", names(v), ": ", v, collapse = "\n"), 
      "\ncontradicted by:\n",
      paste0(" ", names(v_cont), ": ", v_cont, collapse = "\n")
    )
  }
  res
}

# x <- validator( x > 1, r2 = x < 0, x > 2)
# is_contradicted_by(x, "r2")
# make_feasible(x, weight = c(r2=10))

