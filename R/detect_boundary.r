#' @export
detect_boundary_num <- function(x, ...){
  mip <- errorlocate::miprules(x)
  sapply(variables(x), function(v){
    bounds <- c(lower=-Inf, upper=Inf)
    
    mip$objective <- setNames(1, v)
    lp <- mip$to_lp()
    lpSolveAPI::lp.control(lp, presolve="none")
    res <- solve(lp)

    if (res %in% c(0,1,4,12)){ # succesful, TODO warn if failure...
      i <- match(v, colnames(lp))
      bounds[1] <- lpSolveAPI::get.variables(lp)[i]
    }

    mip$objective <- setNames(-1, v)
    lp <- mip$to_lp()
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
}


#' @export
detect_boundary_cat <- function(x, ...){
  stop("To be implemented")
  # for each category detect bound
}

# x <- validate::validator(
#   x >= 1,
#   x + y <= 10,
#   y >= 5
# )
# 
#detect_boundary_num(x)
# 
# mip <- errorlocate::miprules(x)
# 
# mip$objective <- c(y=-1)
# r <- mip$execute()
# r$lp
# colnames(r$lp)
# lpSolveAPI::get.bounds(r$lp)
# r$lp
# r$values
# detect_boundary_num(x)
