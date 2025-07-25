% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/simplify_conditional.R
\name{simplify_conditional}
\alias{simplify_conditional}
\title{Simplify conditional statements}
\usage{
simplify_conditional(x, ...)
}
\arguments{
\item{x}{\code{\link[validate:validator]{validate::validator()}} object with the validation rules.}

\item{...}{not used.}
}
\value{
\code{\link[validate:validator]{validate::validator()}} simplified rule set.
}
\description{
Conditional rules (if-rules) may be constrained by the others rules in a validation rule set.
This procedure tries to simplify conditional statements.
}
\examples{
library(validate)

# superfluous conditions
rules <- validator(
  r1 = if (x > 0) x < 1,
  r2 = if (y > 0 && y > 1) z > 0
)
# r1: x > 0 is superfluous because r1 equals (x <= 0) | (x < 1)
# r2: y > 0 is superfluous because r2 equals (y <= 0) | (y <= 1) | (z > 0)
simplify_conditional(rules)

# non-relaxing clause
rules <- validator( r1 = if (x > 1) y > 3
                  , r2 = y < 2
                  )
# y > 3 is always FALSE so r1 can be simplified
simplify_conditional(rules)

# non-constraining clause
rules <- validator( r1 = if (x > 0) y > 0
                  , r2 = if (x < 1) y > 1
                  )
simplify_conditional(rules)

rules <- validator( r1 = if (A == "a1") x > 0
                  , r2 = if (A == "a2") x > 1
                  , r3 = A == "a1"
                  )
simplify_conditional(rules)
}
\references{
TODO non-constraining, non-relaxing
}
