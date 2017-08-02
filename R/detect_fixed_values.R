#' Detect fixed values
#' 
#' Detect fixed values
#' @example ./examples/detect_fixed_values.R
#' @seealso \code{\link{simplify_fixed_values}}
#' @param x \code{\link{validator}} object with the validation rules.
#' @param ... not used.
#' @export
detect_fixed_values <- function(x, ...){
  check_validator(x)
  bounds_num <- detect_boundary_num(x)
  is_fixed_num <- (bounds_num$upperbound - bounds_num$lowerbound <= x$options("lin.eq.eps"))
  
  warning("Currently only checking numerical values\n", call. = FALSE)
  if (any(is_fixed_num)){
    fixed_num <- setNames(bounds_num$lowerbound, bounds_num$variable)[is_fixed_num]
    as.list(fixed_num)
  }
}

#' Simplify fixed values
#' 
#' Simplify fixed values
#' @export
#' @example ./examples/detect_fixed_values.R
#' @param x \code{\link{validator}} object with validation rules
#' @param ... passed to \code{\link{substitute_values}}.
#' @return \code{\link{validator}} object in which 
simplify_fixed_values <- function(x, ...){
  check_validator(x)
  fv <- detect_fixed_values(x, ...)
  if (length(fv)) {
    substitute_values(x, .values = fv, ...)
  } else {
    message("No fixed values found.")
    x
  }
}

# rules <- x <- validator( x >= 0, x <= 0)
# detect_fixed_values(rules)
