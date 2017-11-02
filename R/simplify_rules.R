#' Simplify a rule set
#' 
#' Simplifies a rule set set by applying different simplification methods. This is a convenience function that 
#' works in common cases. The following simplification methods are executed:
#' \itemize{
#'  \item \code{\link{substitute_values}}: filling in any parameters that are supplied via \code{.values} or \code{...}.
#'  \item \code{\link{simplify_fixed_values}}: find out if there are fixed values. If this is the case, they are substituted.
#'  \item \code{\link{simplify_conditional}}: Simplify conditional statements, by removing clauses that are superfluous.
#'  \item \code{\link{remove_redundancy}}: remove redundant rules.
#' }
#' For more control, these methods can be called separately.
#' @example ./examples/simplify_rules.R
#' @export
#' @param .x \code{\link{validator}} object with the rules to be simplified.
#' @param .values optional named list with values that will be substituted. 
#' @param ... parameters that will be used to substitute values.
#' @family redundancy
simplify_rules <- function(.x, .values = list(...), ...){
  .x <- substitute_values(.x, .values)
  .x <- simplify_fixed_values(.x)
  .x <- simplify_conditional(.x)
  .x <- remove_redundancy(.x)
  .x
}


