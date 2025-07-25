#' Detect fixed variables
#' 
#' Detects variables that are constrained by the rule set to have one fixed value.
#' To simplify a rule set, these variables can be substituted with their value.
#' See examples.
#' @example ./examples/detect_fixed_variables.R
#' @seealso [simplify_fixed_variables()]
#' @param x [validate::validator()] object with the validation rules.
#' @param eps detected fixed values will have this precission.
#' @param ... not used.
#' @family redundancy
#' @export
detect_fixed_variables <- function(x, eps = x$options("lin.eq.eps"), ...){
  x <- check_validator(x)
  bounds_num <- detect_boundary_num(x, eps = eps)
  is_fixed_num <- (bounds_num$upperbound - bounds_num$lowerbound <= eps)
  
  fixed_num <- NULL
  if (any(is_fixed_num)){
    fixed_num <- setNames(bounds_num$lowerbound, bounds_num$variable)[is_fixed_num]
    fixed_num <- as.list(fixed_num)
  }
  fixed_cat <- NULL
  bounds_cat <- detect_boundary_cat(x, as_df = TRUE)
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
#' @example ./examples/detect_fixed_variables.R
#' @param x [validate::validator()] object with validation rules
#' @param eps detected fixed values will have this precission.
#' @param ... passed to [substitute_values()].
#' @family redundancy
#' @return [validate::validator()] object in which 
simplify_fixed_variables <- function(x, eps = 1e-8, ...){
  x <- check_validator(x)
  fv <- detect_fixed_variables(x, eps = eps, ...)
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
# detect_fixed_variables(x)
