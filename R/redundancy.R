#' @export
detect_redundancy <- function(x, ...){
  check_validator(x)
  mip <- errorlocate::miprules(x)
  mip$objective <- c(x=1)
  res <- mip$execute()
}

#x <- validator(x > 1, x  + y < 3, x > 2, y > 0)
