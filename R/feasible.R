#' Check the feasibility of a rule set
#' 
#' This function checks if the linear, categorical and conditional rules are consistent. If not
#' the system is said to be "infeasible" and it is not possible to validate any data with it, because
#' there will be always a rule that is not obeyed. 
#' 
#' It works by translating these rules into a mixed integer problem and check this system of
#' (in)equalities for feasibility.
#' @example ./examples/feasible.R
#' @param x \code{validator} object with validation rules.
#' @param ... not used
#' @return TRUE or FALSE
#' @export
is_infeasible <- function(x, ...){
  check_validator(x)
  mip <- errorlocate::miprules(x)
  mip$is_infeasible()
}


#' Make an infeasible system feasible.
#' 
#' Make an infeasible system feasible.
#' @param x \code{\link{validator}} object with the validation rules.
#' @param ... not used.
make_feasible <- function(x, ...){
  if (!is_infeasible(x)){
    message("No infeasibility found, returning original rule set")
    return(x)
  }
  # mip_rules <- errorlocate::miprules(x)
  # mip_rules$._lin_rules
  stop("to be implemented")
}
# x <- validator( x > 1, x < 0)
# make_feasible(x)
