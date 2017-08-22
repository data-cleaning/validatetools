#' Detect the range for numerical variables
#' 
#' Detect for each numerical variable in a validation rule set, what its maximum and minimum values are.
#' This allows for manual rule set checking: does rule set \code{x} overly constrain numerical values?
#' 
#' This procedure only finds minimum and maximum values, but misses gaps.
#' 
#' @seealso \code{\link{detect_fixed_values}}
#' @references Statistical Data Cleaning with R (2017), Chapter 8, M. van der Loo, E. de Jonge
#' @references Simplifying constraints in data editing (2015). Technical Report 2015|18, Statistics Netherlands, J. Daalmans
#' @example ./examples/detect_boundary.R
#' @export
#' @param x \code{\link{validator}} object, rule set to be checked
#' @param eps detected fixed values will have this precission.
#' @param ... currently not used
#' @return \code{\link{data.frame}} with columns "variable", "lowerbound", "upperbound".
detect_boundary_num <- function(x, eps = 1e-8, ...){
  x <- check_validator(x)
  prec <- -log(eps, 10)
  bounds <- sapply(get_variables_num(x), function(v){
    bounds <- c(lower=-Inf, upper=Inf)
    
    objective <- setNames(1, v)
    lp <- to_lp(x, objective = objective)
    lpSolveAPI::lp.control(lp, presolve="none")
    res <- solve(lp)

    if (res %in% c(0,1,4,12)){ # succesful, TODO warn if failure...
      i <- match(v, colnames(lp))
      bounds[1] <- lpSolveAPI::get.variables(lp)[i]
    }

    objective <- setNames(-1, v)
    lp <- to_lp(x, objective = objective)
    lpSolveAPI::lp.control(lp, presolve="none")
    # TODO check if was succesfull
    
    res <- solve(lp)
    if (res %in% c(0,1,4,12)){
      i <- match(v, colnames(lp))
      bounds[2] <- lpSolveAPI::get.variables(lp)[i]
    } else if (!(res %in% c(3,13))){
      
    }
    #lpSolveAPI::delete.lp(lp)
    return(bounds)
  }, simplify = TRUE)
  
  data.frame( variable = colnames(bounds)
            , lowerbound = round(bounds[1,], prec)
            , upperbound = round(bounds[2,], prec)
            , stringsAsFactors = FALSE
            )
}


#' Detect viable domains for categorical variables
#' 
#' Detect viable domains for categorical variables
#' @param x \code{\link{validator}} object with rules
#' @param ... not used
#' @export
detect_boundary_cat <- function(x, ...){
  var_cat <- get_variables_cat(x)
  bounds <- sapply(seq_len(nrow(var_cat)), function(i){
    bounds <- c(min=0L, max=1L)
    v <- var_cat$bin_variable[i]
    
    objective <- setNames(1, v)
    lp <- to_lp(x, objective = objective)
    lpSolveAPI::lp.control(lp, presolve="none")
    res <- solve(lp)
    
    if (res %in% c(0,1,4,12)){ # succesful, TODO warn if failure...
      i <- match(v, colnames(lp))
      bounds[1] <- lpSolveAPI::get.variables(lp)[i]
    }
    
    objective <- setNames(-1, v)
    lp <- to_lp(x, objective = objective)
    lpSolveAPI::lp.control(lp, presolve="none")
    res <- solve(lp)
    
    if (res %in% c(0,1,4,12)){ # succesful, TODO warn if failure...
      i <- match(v, colnames(lp))
      bounds[2] <- lpSolveAPI::get.variables(lp)[i]
    }
    bounds
  })
  #stop("To be implemented")
  # for each category detect bound
  if (length(bounds)){
    cbind(var_cat[-1], t(bounds))
  } else{
    NULL
  }
}

# rules <- x <-  validator( x > 1
#                         , if (x > 0) A == 'a1'
#                         , B %in% c("b1", "b2")
#                         )
# detect_boundary_cat(rules)

