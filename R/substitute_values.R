
#' substitute a value in a rule set
#' 
#' Substitute values into expression, thereby simplifying the rule set.
#' Rules that evaluate to TRUE because of the substition are removed.
#' @example ./examples/substitute_values.R
#' @param x \code{validator} object with rules
#' @param .values (optional) named list with values for variables to substitute
#' @param .add_constraints \code{logical}, should values be added as constraints to the resulting validator object?
#' @export
substitute_values <- function (x, .values = list(...), ..., .add_constraints = TRUE){
  check_validator(x)
  
  vals <- lapply(x$exprs(), function(e) {
    e <- substituteDirect(e, .values)
    tryCatch(r <- eval(e), error = function(x) {
      e
    })
  })
  
  is_cond <- errorlocate::is_conditional(x)
  vals[is_cond] <- lapply(vals[is_cond], function(cond){
    clauses <- as_dnf(cond)
    # try to simplify clauses
    s_clauses <- lapply(clauses, function(clause){
      tryCatch(r <- eval(clause), error = function(x) {
        clause
      })
    })
    is_logi_clause <- sapply(s_clauses, is.logical)
    if (any(unlist(s_clauses[is_logi_clause]))){
      # one of the clause is TRUE so the whole statement is TRUE
      TRUE
    } else if (any(is_logi_clause)){
      # remove parts that are FALSE
      s_clauses <- s_clauses[!is_logi_clause]
      as.expression(s_clauses, as_if = TRUE)[[1]] # turn into an expression
    } else {
      cond
    }
  })
  
  is_logical <- sapply(vals, is.logical)
  if (any(is_logical)) {
    is_true <- unlist(vals[is_logical])
    if (!all(is_true)) {
      broken <- names(is_true)[!is_true]
      warning("Invalid rule set: rule(s) '", x[broken]$exprs(), "' evaluates to FALSE", call. = FALSE)
    }
  }
  
  
  
  vals <- vals[!is_logical]
  if (isTRUE(.add_constraints)){
    eq_ <- lapply(names(.values), function(v){
      substitute(v == value, list(v=as.symbol(v), value=.values[[v]]))
    })
    names(eq_) <- paste0(".const_", names(.values))
    vals <- c(vals, eq_)
  }
  # TODO improve the metadata of the resulting validator object!
  do.call(validator, vals)
}

# library(validate)
# rules <- validator(rule1 = x > 1, rule2 = y > x)
# substitute_values(rules, list(x=2))
# #
# #
# rules <- validator(gender %in% c("male","female"), if (gender == "male") x > 6)
# substitute_values(rules, gender="female")
# x <- rules
# x
