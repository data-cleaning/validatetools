op <- function(e){
  if (is.call(e)) { e[[1]] 
  } else { e }
}

op_to_s <- function(e){
  deparse(op(e))
}

left <- function(e){
  if (length(e) >= 2) e[[2]]
}

right <- function(e){
  if (length(e) >= 3) e[[3]]
}

#TODO move this to errorlocate
invert_or_negate <- function(e){
  if (errorlocate:::is_lin_(e)){
    errorlocate:::invert_(e)
  } else {
    errorlocate:::negate_(e)
  }
}


normalize_conditional <- function(expr, ...){
  # assumes that the expression has been tested with is.conditional
  clauses <- list()
  op_if <- op_to_s(expr)
  
  cond <- NULL
  cons <- expr
  
  if (op_if == "if") {
    cond <- left(expr)
    cons <- right(expr)
  } else if (op_if %in% c("|", "||")){
    if (op_to_s(left(expr)) == "!"){ # this is a rewritten if statement
      cons <- right(expr)
      cond <- left(left(expr))
      if (op_to_s(cond) == "("){
        cond <- left(cond)
      }
    }
  } else {
    stop("Invalid condition")
  }
  # build condition clauses
  if (!is.null(cond)){
    op_and <- op_to_s(cond)
  
    while(op_and %in% c("&", "&&")){
      clauses[[length(clauses) + 1]] <- invert_or_negate(left(cond))
      cond <- right(cond)
      op_and <- op_to_s(cond)
    }
    clauses[[length(clauses) + 1]] <- invert_or_negate(cond)
  }

  # build consequent clauses
  if (!is.null(cons)){
    op_or <- op_to_s(cons)
    while(op_or %in% c("|", "||")){
      clauses[[length(clauses) + 1]] <- left(cons)
      cons <- right(cons)
      op_or <- op_to_s(cons)
    }
    clauses[[length(clauses) + 1]] <- cons
  }
  
  structure(clauses, class="clause")
}

as_clause <- normalize_conditional

as.character.clause <- function(x, as_if = FALSE, ...){
  x <- x[] # removes NULL entries
  x_s <- sapply(x, deparse)
  x_i <- sapply(x, invert_or_negate)
  x_i_s <- sapply(x_i, deparse)
  if (as_if && length(x) > 1){
    s <- paste(head(x_i_s, -1), collapse = " & ")
    paste0("if (",s,") ", tail(x_s, 1))
  } else {
    paste(x_s, collapse = ' | ')
  }
}

print.clause <- function(x, as_if = FALSE, ...){
  cat(as.character(x, as_if = as_if, ...))
}

as.expression.clause <- function(x, as_if = FALSE, ...){
  parse(text=as.character(x, as_if = as_if, ...))
}

#as_clause(quote(!(gender == male) | x > 6))
#as_clause(quote( !(gender %in% "male" & y > 3) | x > 6))

