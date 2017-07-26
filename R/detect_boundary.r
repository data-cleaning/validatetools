#' @export
detect_boundary_num <- function(x, ...){
  mip <- errorlocate::miprules(x)
  sapply(variables(x), function(v){
    bounds <- list(lower=-Inf, upper=Inf)
    
    mip$objective <- setNames(1, v)
    lp <- mip$to_lp()
    lpSolveAPI::lp.control(lp, presolve="none")
    # TODO check if was succesfull
    res <- solve(lp)
    i <- match(v, colnames(lp))
    bounds$lower <- lpSolveAPI::get.variables(lp)[i]
    #lpSolveAPI::delete.lp(lp)
    
    mip$objective <- setNames(-1, v)
    lp <- mip$to_lp()
    lpSolveAPI::lp.control(lp, presolve="none")
    # TODO check if was succesfull
    res <- solve(lp)
    if (res %in% c(0,1,4,12)){
      i <- match(v, colnames(lp))
      bounds$upper <- lpSolveAPI::get.variables(lp)[i]
    }
    #lpSolveAPI::delete.lp(lp)
    return(bounds)
  }, simplify = FALSE)
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
