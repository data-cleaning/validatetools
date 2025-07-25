% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/conditional.R
\name{is_conditional}
\alias{is_conditional}
\title{Check whether rules are conditional rules}
\usage{
is_conditional(rules, ...)
}
\arguments{
\item{rules}{validator object containing validation rules}

\item{...}{not used}
}
\value{
logical indicating which rules are conditional
}
\description{
Check whether rules are conditional rules
}
\examples{
v <- validator( A \%in\% c("a1", "a2")
              , B \%in\% c("b1", "b2")
              , if (A == "a1")  x > 1 # conditional
              , if (y > 0) x >= 0 # conditional
              , if (A == "a1") B == "b1" # categorical
              )

is_conditional(v)
}
