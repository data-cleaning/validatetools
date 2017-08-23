# makes a copy of the validation object
check_validator <- function(x, copy = TRUE, check_infeasible = TRUE){
  if (!inherits(x, "validator")){
    stop("This method needs a 'validator' object, but was given a '", class(x), "'.",call. = FALSE)
  }
  if (isTRUE(check_infeasible) && is_infeasible(x)){
    stop("This rule set is infeasible. Please fix and repair the rule set before continuing.", call. = FALSE)
  }
  invisible(x)
}

to_exprs <- function(x, ...){
  x$exprs(lin_eq_eps = 0, lin_ineq_eps = 0, vectorize = F)
}


get_variables_num <- function(x){
  var_num <- sapply(to_miprules(x), function(mr){
    names(mr$type)[mr$type == "double"]
  })
  unique(unlist(var_num))
}

get_variables_cat <- function(x){
  var_cat <- sapply(to_miprules(x), function(mr){
    nms <- names(mr$type)
    nms[mr$type == "binary" & grepl(":", nms)]
  })
  unique(unlist(var_cat))
}
# x <- validator( x == y + 2, if (x > 1)  y == 0 )
# to_exprs(x)
# x$exprs()
