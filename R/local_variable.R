is_local_var_ <- function(e){
  return(op_to_s(e) == ":=")
}

is_local_variable <- function(rules, ...){
  if (is.expression(rules)){
    return(sapply(rules, is_local_var_))
  }
  stopifnot(inherits(rules, "validator"))
  sapply(rules$rules, function(rule){
    is_local_var_(rule@expr)
  })
}


