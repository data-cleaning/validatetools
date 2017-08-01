#' Check the feasibility of a rule set
#' 
#' This function checks if the linear, categorical and conditional rules are consistent. If not
#' the system is said to be "infeasible" and it is not possible to validate any data with it, because
#' there will be always a rule that is not obeyed. 
#' 
#' It works by translating these rules into a mixed integer problem and check this system of
#' (in)equalities for feasibility.
#' @param x \code{validator} object with validation rules
#' @param ... not used
#' @return TRUE or FALSE
#' @export
is_infeasible <- function(x, ...){
  # TODO check if x is a validator object
  mip <- errorlocate::miprules(x)
  mip$is_infeasible()
}


#' If a system is infeasible 
make_feasible <- function(x, ...){
  if (!is_infeasible(x)){
    message("No infeasibility found, returning original system")
    return(x)
  }
  
  stop("to be implemented")
}
