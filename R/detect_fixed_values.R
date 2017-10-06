#' Detect fixed values
#' 
#' Detects fixed values in the rule set. To simplify a rule set, these fixed values can be substituted. 
#' @example ./examples/detect_fixed_values.R
#' @seealso \code{\link{simplify_fixed_values}}
#' @param x \code{\link{validator}} object with the validation rules.
#' @param eps detected fixed values will have this precission.
#' @param ... not used.
#' @family redundancy
#' @export
detect_fixed_values <- function(x, eps = x$options("lin.eq.eps"), ...){
  x <- check_validator(x)
  bounds_num <- detect_boundary_num(x, eps = eps)
  is_fixed_num <- (bounds_num$upperbound - bounds_num$lowerbound <= eps)
  
  fixed_num <- NULL
  if (any(is_fixed_num)){
    fixed_num <- setNames(bounds_num$lowerbound, bounds_num$variable)[is_fixed_num]
    fixed_num <- as.list(fixed_num)
  }
  fixed_cat <- NULL
  bounds_cat <- detect_boundary_cat(x)
  if (NROW(bounds_cat)){
    bounds_cat <- subset(bounds_cat, min == 1)
    if (nrow(bounds_cat)){
      fixed_cat <- as.list(setNames(bounds_cat$value, bounds_cat$variable))
    }
  }
  c(fixed_num, fixed_cat)
}

#' Simplify fixed variables
#' 
#' Detect variables of which the values are restricted to a single value by the
#' rule set. Simplify the rule set by replacing fixed variables with these values.
#' 
#'   
#' @export
#' @example ./examples/detect_fixed_values.R
#' @param x \code{\link{validator}} object with validation rules
#' @param eps detected fixed values will have this precission.
#' @param ... passed to \code{\link{substitute_values}}.
#' @family redundancy
#' @return \code{\link{validator}} object in which 
simplify_fixed_values <- function(x, eps = 1e-8, ...){
  x <- check_validator(x)
  fv <- detect_fixed_values(x, eps = eps, ...)
  if (length(fv)) {
    substitute_values(x, .values = fv, ...)
  } else {
    message("No fixed values found.")
    x
  }
}

# rules <- x <-  validator( x > 1
#                         , if (x > 0) A == 'a1'
#                         , B %in% c("b1", "b2")
#                         )
# detect_fixed_values(x)
