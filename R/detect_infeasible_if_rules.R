#' Detect infeasible if clauses
#' 
#' Detect if clauses that contradict each other. This is useful to detect if clauses that are not satistifable.
#' 
#' @param x A validator object.
#' @param ... Additional arguments passed to `detect_if_clauses`.
#' @param verbose Logical. If `TRUE`, print the results.
#' @return A list of contradictions found in the if clauses, or `NULL` if none are found.
#' @family feasibility
#' @example ./examples/detect_infeasible_if_rules.R
#' @export
detect_infeasible_if_rules <- function(x, ..., verbose = TRUE){
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
  # to do for %in statement and replace with multiple "=="
  neg_clauses <- lapply(clauses, invert_or_negate)
  
  l <- list()
  for (neg in neg_clauses){
    v <- x + do.call(validate::validator, list(.test = neg))
    if (is_feasible(v)){
      next
    }
    v1 <- is_contradicted_by(v, ".test")
    l[[deparse(neg)]] <- v1
    # op <- op_to_s(neg)
    # if (op == "=="){
    #   .values <- list(neg[[3]]) |> setNames(as.character(neg[[2]]))
    #   test_rules <- substitute_values(x, .values = .values)
    #   v <- detect_infeasible_rules(test_rules)
    #   if (is.null(v)){
    #     next
    #   }
    #   v1 <- is_contradicted_by(test_rules, v)
    #   v <- c(v,v1)
    #   l[[deparse(neg)]] <- v
    # } 
    
    # TODO expand %in% statement here
  }
  l
}
