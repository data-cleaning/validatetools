#' @export
is_infeasible <- function(x, ...){
  # TODO check if x is a validator object
  mip <- errorlocate::miprules(x)
  mip$is_infeasible()
}
