#' Detect infeasible if rules
#' 
#' Detect whether conditions in if-rules may generate contradictions. Strictly
#' speaking these rules do not make the rule set infeasible but rather make
#' the if-condition unsatisfiable. So semantically speaking these rules are 
#' contradicting, because the writer of the rule set did not have the intention 
#' to make the condition forbidden. See examples for more details.
#' 
#' @param x A validator object.
#' @param ... Additional arguments passed to `detect_if_clauses`.
#' @param verbose Logical. If `TRUE`, print the results.
#' @return A list of contradictions found in the if clauses, or `NULL` if none are found.
#' @family feasibility
#' @example ./examples/detect_contradicting_if_rules.R
#' @export
detect_contradicting_if_rules <- function(x, ..., verbose = interactive()){
  res <- detect_if_clauses(x, ...)
  if (length(res) == 0){
    if (verbose){
      message("No contradictory if clauses found.")
    }
    return(NULL)
  }
  
  if (verbose){
    message(
      length(res), 
      " contradiction(s) with if clauses found:"
    )
    for (i in seq_along(res)){
      cat(sprintf("When %s:\n", names(res)[i]))
      x_c <- x[res[[i]]]
      
      expr <- sapply(x_c$rules, function(r){
        deparse(r@expr)
      })
      cat(paste0("  ", res[[i]], ": ", expr, collapse = "\n"))
      cat("\n")
    }
  }
  
  invisible(res)
}

# Detect if clauses that contradict each other. This is useful to detect if clauses that are not satistifable
detect_if_clauses <- function(x, ...){
  x <- check_validator(x)
  is_cond <- is_conditional(x) | is_categorical(x)
  vals <- to_exprs(x)
  
  l <- list()
  for (i in which(is_cond)){
    cond <- vals[[i]]
    r <- check_condition(cond, x)
    l[names(r)] <- r
  }
  
  l
}

check_condition <- function(cond_expr, x){
  clauses <- as_dnf(cond_expr)
  
  # test whether it is an if statement
  if (length(clauses) <= 1){
    return(NULL)
  }
  # browser()
  # take last clause as consequent, and the rest as the condition
  cond <- 
    utils::head(clauses, -1) |> 
    lapply(invert_or_negate)
  
  names(cond) <- paste0(".test", seq_along(cond))
  cond_s <- sapply(cond, deparse_all) |> paste0(collapse = " && ")

  v <- x + do.call(validate::validator, cond)
  if (is_feasible(v)){
    return(NULL)
  }
  l <- list()
  v1 <- is_contradicted_by(v, names(cond), verbose = FALSE)
  l[[cond_s]] <- v1
  l
}
