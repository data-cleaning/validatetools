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

# look ahead
la <- function(e){
  op_to_s(left(e))
}

# consume tokens, typically handy for brackets
consume <- function(e, token = "("){
  while(op_to_s(e) ==  token){
    e = left(e)
  }
  e
}

is_lin_eq <- function(e){
  errorlocate:::is_lin_(e) && op_to_s(e) == "=="
}

#TODO move this to errorlocate
invert_or_negate <- function(e){
  if (errorlocate:::is_lin_(e)){
    if (is_lin_eq(e)){
      # Dirty Hack but it works for now. Ideally this should be split in two statements
      substitute( l < r | l > r, list(l = left(e), r = right(e))) 
    } else {
      errorlocate:::invert_(e)
    }
  } else {
    errorlocate:::negate_(e)
  }
}

# convert an expression to its disjunctive normal form
as_dnf <- function(expr, ...){
  # assumes that the expression has been tested with is.conditional
  clauses <- list()
  expr <- consume(expr)
  op_if <- op_to_s(expr)
  
  cond <- NULL
  cons <- expr
  
  if (op_if == "if") {
    cond <- left(expr)
    cons <- right(expr)
  } else if (op_if %in% c("|", "||")){
    if (la(expr) == "!"){ # this is a rewritten if statement
      cons <- right(expr)
      cond <- left(left(expr))
    }
  } else if(op_if == "!"){
    cond <- left(expr)
    cons <- NULL
  } else if (errorlocate:::is_cat_(expr) || errorlocate:::is_lin_(expr)){
    return(structure(list(expr), class="dnf"))
  } else {
    stop("Invalid expression")
  }
  # build condition clauses
  if (!is.null(cond)){
    cond <- consume(cond)
    op_and <- op_to_s(cond)
  
    while(op_and %in% c("&", "&&")){
      clauses[[length(clauses) + 1]] <- invert_or_negate(left(cond))
      cond <- consume(right(cond))
      op_and <- op_to_s(cond)
    }
    clauses[[length(clauses) + 1]] <- invert_or_negate(cond)
  }

  # build consequent clauses
  if (!is.null(cons)){
    cons <- consume(cons)
    op_or <- op_to_s(cons)
    while(op_or %in% c("|", "||")){
      clauses[[length(clauses) + 1]] <- left(cons)
      cons <- consume(right(cons))
      op_or <- op_to_s(cons)
    }
    clauses[[length(clauses) + 1]] <- cons
  }
  
  # the nasty case of negating equalities...
  clauses <- unlist(lapply(clauses, function(clause){
    if (op_to_s(clause) == "|"){
      as_dnf(clause)
    } else{
      clause
    }
  }))
  # unroll <- FALSE
  # for (i in seq_along(clauses)){
  #   clause <- clauses[[i]]
  #   if (op_to_s(clause) == "|") { # got-ya
  #     clauses[[i]] <- as_dnf(clause)
  #     unroll <- TRUE
  #   }
  # }
  # if (unroll){
  #   clauses <- unlist(clauses)
  # }
  # forget about it
  
  structure(clauses, class="dnf")
}

as_clause <- as_dnf

as.character.dnf <- function(x, as_if = FALSE, ...){
  x <- x[] # removes NULL entries
  x_s <- sapply(x, deparse)
  if (as_if && length(x) > 1){
    x_i <- sapply(x, invert_or_negate)
    x_i_s <- sapply(x_i, deparse)
    s <- paste(utils::head(x_i_s, -1), collapse = " & ")
    paste0("if (",s,") ", utils::tail(x_s, 1))
  } else {
    paste(x_s, collapse = ' | ')
  }
}

print.dnf <- function(x, as_if = FALSE, ...){
  cat(as.character(x, as_if = as_if, ...))
}

as.expression.dnf <- function(x, as_if = FALSE, ...){
  parse(text=as.character(x, as_if = as_if, ...))
}

# as_dnf(quote(!(gender == "male") | x > 6))
# as_dnf(quote(if (y == 1) x > 6))
# as_dnf(quote( !(gender %in% "male" & y > 3) | x > 6))

# e <- quote( x == 1)
# invert_or_negate(e)

