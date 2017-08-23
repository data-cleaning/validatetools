#' Find out for a contradicting 
#' 
#' Find out for a contradicting rule which rules are conflicting. This helps in determining and assessing conflicts in rule sets. Which
#' of the rules should stay and which should go? 
#' @export
#' @example ./examples/feasible.R
#' @param x \code{\link{validator}} object with rules.
#' @param rule_name \code{character} with the names of the rules that are causing infeasibility.
#' @return \code{character} with conflicting rules.
is_contradicted_by <- function(x, rule_name){
  N <- length(x)
  weight <- rep(N, length(rule_name))
  names(weight) <- rule_name
  detect_infeasible_rules(x, weight = weight)
}

# x <- validator( x > 1, r2 = x < 0, x > 2)
# is_contradicted_by(x, "r2")
# make_feasible(x, weight = c(r2=10))

