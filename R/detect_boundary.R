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
#' @param ... currently not used
#' @return \code{\link{data.frame}} with columns "variable", "lowerbound", "upperbound".
detect_boundary_num <- function(x, ...){
  x <- check_validator(x)
  #mip <- errorlocate::miprules(x)
  bounds <- sapply(validate::variables(x), function(v){
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
            , lowerbound = bounds[1,]
            , upperbound = bounds[2,]
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
  stop("To be implemented")
  # for each category detect bound
}