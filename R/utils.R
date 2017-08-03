# makes a copy of the validation object
check_validator <- function(x, copy = TRUE){
  if (!inherits(x, "validator")){
    stop("This method needs a 'validator' object, but was given a '", class(x), "'.",call. = FALSE)
  }
  if (copy){
    x <- x$copy()
    x$options(lin.eq.eps = 0)
  }
  invisible(x)
}
