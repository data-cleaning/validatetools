#' Tools for validation rules
#'
#' \code{validatetools} is a utility package for managing validation rule sets
#' that can be defined with \code{\link{validate}}. In production systems
#' validation rule sets tend to grow organically and accumulate redundant or
#' (partial) contradictory rules. `validatetools` helps to identify problems
#' with large rule sets and includes simplification methods for resolving
#' issues.
#' 
#' @section Problem detection:
#' 
#' The following methods allow for problem detection:
#' 
#' \itemize{
#'   \item \code{\link{is_infeasible}} checks a rule set for feasibility. An infeasible system must be corrected to be useful.
#'   \item \code{\link{detect_boundary_num}} shows for each numerical variable the allowed range of values.
#'   \item \code{\link{detect_fixed_values}} shows variables whose value is fixated by the rule set.
#'   \item \code{\link{detect_redundancy}} shows which rules are already implied by other rules.
#' }
#' 
#' @section Simplifying rule set:
#'
#' The following methods detect possible simplifications and apply them to a rule set.
#' 
#' \itemize{
#'   \item \code{\link{substitute_values}}: replace variables with constants. 
#'   \item \code{\link{simplify_fixed_values}}: substitute the fixed values of a rule set.
#'   \item \code{\link{simplify_conditional}}: remove redundant (parts of) conditional rules.
#'   \item \code{\link{simplify_redundancy}}: remove redundant rules.
#' }
#' 
#' @name validatetools
#' @importFrom methods substituteDirect
#' @importFrom stats setNames
#' @importFrom utils head tail
#' @import validate
#' @docType package
NULL