
#' substitute a value in a rule set
#' @export
substitute_values <- function (x, .values = list(...), ...){
  vals <- lapply(x$exprs(), function(e) {
    e <- substituteDirect(e, .values)
    tryCatch(r <- eval(e), error = function(x) {
      e
    })
  })
  is_logical <- sapply(vals, is.logical)
  if (any(is_logical)) {
    is_true <- unlist(vals[is_logical])
    if (!all(is_true)) {
      broken <- names(is_true)[!is_true]
      warning("Invalid rule set: rule(s) '", x[broken]$exprs(), "' evaluate to FALSE", call. = FALSE)
    }
  }
  vals <- vals[!is_logical]
  # TODO iterate all components of conditional statements
  do.call(validator, vals)
}

# library(validate)
# rules <- validator(rule1 = x > 1, rule2 = y > x)
# substitute_values(rules, list(x=0)) 
# 
# 
# rules <- validator(gender %in% c("male","female"), if (gender == "male") x > 6)
# substitute_values(rules, gender="female")
