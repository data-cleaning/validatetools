#' Simplify a rule set
#' 
#' Simplifies a rule set set by applying different simplification methods. This is a convenience function that 
#' works in common cases. The following simplification methods are executed:
#' \itemize{
#'  \item [substitute_values()]: filling in any parameters that are supplied via `.values` or `...`.
#'  \item [simplify_fixed_variables()]: find out if there are fixed values. If this is the case, they are substituted.
#'  \item [simplify_conditional()]: Simplify conditional statements, by removing clauses that are superfluous.
#'  \item [remove_redundancy()]: remove redundant rules.
#' }
#' For more control, these methods can be called separately.
#' 
#' Note that it is wise to call [detect_contradicting_if_rules()]
#' before calling this function.
#' @example ./examples/simplify_rules.R
#' @export
#' @param .x [validate::validator()] object with the rules to be simplified.
#' @param .values optional named list with values that will be substituted. 
#' @param ... parameters that will be used to substitute values.
#' @family redundancy
simplify_rules <- function(.x, .values = list(...), ...){
  .x <- substitute_values(.x, .values)
  .x <- simplify_fixed_variables(.x)
  .x <- simplify_conditional(.x)
  .x <- remove_redundancy(.x, verbose=FALSE)
  .x
}


