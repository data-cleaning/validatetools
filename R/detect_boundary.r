#' @export
detect_boundary_num <- function(x, ...){
  mip <- errorlocate::miprules(x)
  sapply(variables(x), function(v){
    mip$objective <- setNames(1, v)
    res <- mip$execute()
    i <- match(v, colnames(res$lp))
    bounds <- lpSolveAPI::get.bounds(r$lp, i)
    bounds$lower <- max(bounds$lower, res$values[v], na.rm = TRUE)
    
    mip$objective <- setNames(-1, v)
    res <- mip$execute()
    bounds$upper <- min(bounds$upper, res$values[v], na.rm = TRUE)
    return(bounds)
  }, simplify = FALSE)
}


# x <- validate::validator(
#   x >= 1, x + y <= 10, y >= 5
# )
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
detect_boundary_num(x)
