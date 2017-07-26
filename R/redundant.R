#' @export
detect_redundant <- function(x, ...){
  mip <- errorlocate::miprules(x)
  mip$objective <- c(x=1)
  res <- mip$execute()
  lpSolveAPI::get.bounds(res$lp)
  lpSolveAPI::get.basis(res$lp)
}


#x <- validator(x > 1, x  + y < 3, x > 2, y > 0)
