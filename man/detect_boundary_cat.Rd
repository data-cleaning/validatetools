% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/detect_boundary.R
\name{detect_boundary_cat}
\alias{detect_boundary_cat}
\title{Detect viable domains for categorical variables}
\usage{
detect_boundary_cat(x, ..., as_df = FALSE)
}
\arguments{
\item{x}{\code{\link{validator}} object with rules}

\item{...}{not used}

\item{as_df}{return result as data.frame (before 0.4.5)}
}
\value{
\code{data.frame} with columns \code{$variable}, \code{$value}, \code{$min}, \code{$max}. Each row is a 
category/value of a categorical variable.
}
\description{
Detect viable domains for categorical variables
}
\examples{
rules <- validator(
  x >= 1,
  x + y <= 10,
  y >= 6
)

detect_boundary_num(rules)

rules <- validator(
  job \%in\% c("yes", "no"),
  if (job == "no") income == 0,
  income > 0
)

detect_boundary_cat(rules)
}
\seealso{
Other feasibility: 
\code{\link{detect_boundary_num}()},
\code{\link{detect_infeasible_rules}()},
\code{\link{is_contradicted_by}()},
\code{\link{is_infeasible}()},
\code{\link{make_feasible}()}
}
\concept{feasibility}
