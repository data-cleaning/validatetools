#' Check the feasibility of a rule set
#' 
#' This function checks if the linear, categorical and conditional rules have inconsistencies.
#' It works by translating these rules into a mixed integer problem and check this system of
#' (in)equalities for feasibility.
#' @param x \code{validator} object with validation rules
#' @param ... not used
#' @return TRUE
#' @export
is_infeasible <- function(x, ...){
  # TODO check if x is a validator object
  mip <- errorlocate::miprules(x)
  mip$is_infeasible()
}
