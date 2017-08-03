# makes a copy of the validation object
check_validator <- function(x, copy = TRUE){
  if (!inherits(x, "validator")){
    stop("This method needs a 'validator' object, but was given a '", class(x), "'.",call. = FALSE)
  }
  # if (copy){
  #   x <- x$copy()
  #   x$options(lin.eq.eps = 0)
  # }
  invisible(x)
}

to_exprs <- function(x, ...){
  x$exprs(lin_eq_eps = 0, lin_ineq_eps = 0, vectorize = F)
}

# x <- validator( x == y + 2, if (x > 1)  y == 0 )
# to_exprs(x)
# x$exprs()
