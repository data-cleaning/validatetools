#' @export
detect_fixed_values <- function(x, ...){
  check_validator(x)
  bounds_num <- detect_boundary_num(x)
  is_fixed_num <- (bounds_num$upperbound - bounds_num$lowerbound <= x$options("lin.eq.eps"))
  
  warning("Currently only checking numerical values", call. = FALSE)
  if (any(is_fixed_num)){
    fixed_num <- setNames(bounds_num$lowerbound, bounds_num$variable)[is_fixed_num]
    as.list(fixed_num)
  }
}


# rules <- x <- validator( x >= 0, x <= 0)
# detect_fixed_values(rules)
