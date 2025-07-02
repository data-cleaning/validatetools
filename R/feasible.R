#' Check the feasibility of a rule set
#' 
#' An infeasible rule set cannot be satisfied by any data because of internal 
#' contradictions: the combination of the rules make it inconsistent.
#' This function checks whether the record-wise linear,
#' categorical and conditional rules in a rule set are consistent.
#' Note that is it wise to also check `detect_contradicting_if_rules()`: 
#' conditional If-rules
#' may not be strictly inconsistent, but can be semantically inconsistent.
#'  
#' @example ./examples/feasible.R
#' @param x `validator` object with validation rules.
#' @param ... not used
#' @param verbose if `TRUE` print information to the console
#' @family feasibility
#' @return TRUE or FALSE
#' @export
is_infeasible <- function(x, ..., verbose = interactive()){
  lp <- to_lp(x) # TODO find out how to treat eps for linear inequalities...
  lpSolveAPI::lp.control(lp, presolve="rows", break.at.first = TRUE)
  res <- solve(lp)
  # any of the following means that there is a solution found by lpSolveAPI:
  # TODO generate errors if the lpSolveAPI gives other return values...
  i <- !(res %in% c(0,1,4,12))
  
  if (isTRUE(verbose)){
    if (i){
      message(
        "The rule set is infeasible:\n",
        "  use `detect_infeasible_rules()` and `is_contradicted_by` to find out\n",
        "  which rules are causing infeasibility.",
        "  or `make_feasible()` to make the rule set feasible."
      )
    } else {
      message(
        "The rule set is feasible,\n",
        "  but may contain contradictions in conditional if-rules.\n",
        "  use `detect_contradicting_if_rules()` to find out whether there are \n",
        "  contradictions in the if-clauses."
      )
    }
  }
  
  i
}

is_feasible <- function(x, ...){
  !is_infeasible(x, ...)
}


#' Make an infeasible system feasible.
#' 
#' Make an infeasible system feasible, by removing the minimum (weighted) number of rules, such that the remaining
#' rules are not conflicting.
#' This function uses [detect_infeasible_rules()] for determining the rules to be removed.
#' Note that this may not result in your desired system, because some rules may be more important. 
#' This can be mediated by supplying weights for the rules. Default weight is 1.
#' 
#' Also `make_feasible()` does not check for contradictions in `if` rules, so it is wise to also check
#' `detect_contradicting_if_rules()` after making the system feasible.
#' @export
#' @param x [validate::validator()] object with the validation rules.
#' @param ... passed to [detect_infeasible_rules()]
#' @param verbose if `TRUE` print information to the console
#' @family feasibility
#' @example ./examples/feasible.R
#' @return [validate::validator()] object with feasible rules.
make_feasible <- function(x, ..., verbose = interactive()){
  dropping <- detect_infeasible_rules(x, ..., verbose = verbose) 
  
  if (length(dropping) == 0){
    message("No infeasibility found, returning original rule set")
    return(x)
  }
  
  message("Dropping rule(s): ", paste0('"', dropping, '"', collapse=", "))
  x[-match(dropping, names(x))]
}

#' Detect which rules cause infeasibility
#' 
#' Detect which rules cause infeasibility. This methods tries to remove the minimum number of rules to make the system
#' mathematically feasible. Note that this may not result in your desired system, because some rules may be more important
#' to you than others. This can be mitigated by supplying weights for the rules. Default weight is 1.
#' @export
#' @example ./examples/feasible.R
#' @param x [validate::validator()] object with rules
#' @param weight optional named [numeric()] with weights. Unnamed variables in the weight are given the default
#' weight `1`.
#' @family feasibility
#' @param ... not used
#' @param verbose if `TRUE` it prints the infeasible rules that have been found.
#' @return `character` with the names of the rules that are causing infeasibility.
detect_infeasible_rules <- function(x, weight = numeric(), ..., verbose = interactive()){
  # browser()
  if (!is_infeasible(x, verbose=FALSE)){
    return(character())
  }
  # browser()

  mr <- to_miprules(x)
  mr <- fix_cat_domain(mr)
  
  nms <- mr |> sapply(\(x) x$rule)
  # meaning: all rules that start with a dot are "hard rules"
  w_inf <- nms[grepl("^\\.", nms)] |> sapply(\(x) Inf)
  weight <- c(weight, w_inf)

  is_equality <- sapply(mr, function(m){
    m$op == "==" && all(m$type == "double")
  })
  
  # replace each equality with two inequalities
  if (any(is_equality)){
    mr[is_equality] <- lapply(mr[is_equality], function(m){
      m$op <- "<="
      m
    })
    
    mr <- c(mr, lapply(mr[is_equality], function(m){
      m$a <- -m$a
      m$b <- -m$b
      m
    }))
  }
  
  # make all rules soft rules
  wl <- as.list(weight)
  objective <- numeric()
  mr <- lapply(mr , function(r){
    w <- wl[[r$rule]]
    exclude <- (is.numeric(w) && w == Inf)
    if (exclude){
      return(r)
    }
    
    is_lin <- all(r$type == "double")
    is_cat <- all(r$type == "binary")
    if (is_lin){
      r <- soft_lin_rule(r, prefix = ".delta_")
    } else if (is_cat){
      r <- soft_cat_rule(r, prefix = ".delta_")
    } else {
      return(r)
    }
    r$weight <- 1
    objective[[paste0(".delta_", r$rule)]] <<- r$weight
    r
  })
  # set the weights to the weights supplied by the user
  if (length(weight) && !is.null(names(weight))){
    weight <- weight[sapply(weight, is.finite)]
    if (length(weight)){
      names(weight) <- paste0(".delta_", names(weight))
      objective[names(weight)] <- weight
    }
  }
  lp <- translate_mip_lp(mr, objective = objective) #TODO figure out "eps" param
  lpSolveAPI::lp.control( lp
                        #, verbose="full"
                        , presolve="rows"
                        )
  res <- solve(lp)
  
  if (res %in% c(0,1,4,12)){
    vars <- lpSolveAPI::get.variables(lp)
    names(vars) <- colnames(lp)
    idx <- grep("^\\.delta_", names(vars))
    rules <- vars[idx]
    names(rules) <- sub("^\\.delta_", "", names(rules))
    
    dropping <- names(rules)[rules == 1]
    if (isTRUE(verbose)){
       v <- x[dropping] |> to_exprs() |> lapply(deparse_all)
       message("Found: \n", paste0("  ", names(v), ": ", v, collapse = "\n"))
    }
    dropping
  } else {
    stop("No solution found to make system feasible.", call. = FALSE)
  }
}

# x <- validator( x > 1, r2 = x < 0, x > 2)
# detect_infeasible_rules(x, weight = c(r2=10))
# make_feasible(x, weight = c(r2=10))

