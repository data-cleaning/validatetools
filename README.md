
<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- badges: start -->

[![R-CMD-check](https://github.com/data-cleaning/validatetools/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/data-cleaning/validatetools/actions/workflows/R-CMD-check.yaml)
[![CRAN
status](https://www.r-pkg.org/badges/version/validatetools)](https://CRAN.R-project.org/package=validatetools)
[![Mentioned in Awesome Official
Statistics](https://awesome.re/mentioned-badge.svg)](http://www.awesomeofficialstatistics.org)
[![Codecov test
coverage](https://codecov.io/gh/data-cleaning/validatetools/graph/badge.svg)](https://app.codecov.io/gh/data-cleaning/validatetools)
<!-- badges: end -->

# validatetools

`validatetools` is a utility package for managing validation rule sets
that are defined with `validate`. In production systems validation rule
sets tend to grow organically and accumulate redundant or (partially)
contradictory rules. `validatetools` helps to identify problems with
large rule sets and includes simplification methods for resolving
issues.

## Installation

`validatetools` is available from CRAN and can be installed with

``` r
install.packages("validatetools")
```

The latest beta version of `validatetools` can be installed with

``` r
install.packages("validatetools", repos = "https://data-cleaning.github.io/drat")
```

The adventurous can install an (unstable) development version of
`validatetools` from github with:

``` r
# install.packages("devtools")
devtools::install_github("data-cleaning/validatetools")
```

## Example

### Check for feasibility

``` r
rules <- validator( x > 0)
is_infeasible(rules)
#> [1] FALSE

rules <- validator( rule1 = x > 0
                  , rule2 = x < 0
                  )
is_infeasible(rules)
#> [1] TRUE

detect_infeasible_rules(rules, verbose=TRUE)
#> Found: 
#>   rule1: x > 0
#> [1] "rule1"
make_feasible(rules, verbose=TRUE)
#> Found: 
#>   rule1: x > 0
#> Dropping rule(s): "rule1"
#> Object of class 'validator' with 1 elements:
#>  rule2: x < 0
#> Rules are evaluated using locally defined options

# find out the conflict with this rule
is_contradicted_by(rules, "rule1", verbose=TRUE)
#> Rule(s): 
#>  rule1: x > 0
#> contradicted by:
#>  rule2: x < 0
#> [1] "rule2"
```

### Finding contradicting if rules

``` r
rules <- validator(
  rule1 = if (income > 0) job == "yes",
  rule2 = if (job == "yes") income == 0
)
    

conflicts <- detect_contradicting_if_rules(rules, verbose=TRUE)
#> 1 contradiction(s) with if clauses found:
#> When income > 0:
#>   rule2: if (job == "yes") income == 0
#>   rule1: if (income > 0) job == "yes"
```

``` r
print(conflicts)
#> $`income > 0`
#> [1] "rule2" "rule1"
```

## Simplifying

The function `simplify_rules` combines most simplification methods of
`validatetools` to simplify a rule set. For example, it reduces the
following rule set to a simpler form:

``` r
rules <- validator( rule1 = if (age < 16) income == 0
                  , rule2 = job %in% c("yes", "no")
                  , rule3 = if (job == "yes") income > 0
                  )
simplify_rules(rules, age = 13)
#> Object of class 'validator' with 3 elements:
#>  .const_income: income == 0
#>  .const_age   : age == 13
#>  .const_job   : job == "no"
#or 
simplify_rules(rules, job = "yes")
#> Object of class 'validator' with 3 elements:
#>  rule1     : age >= 16
#>  rule3     : income > 0
#>  .const_job: job == "yes"
```

`simplify_rules` combines the following simplification and substitution
methods:

### Value substitution

``` r
rules <- validator( rule1 = height > 5
                  , rule2 = max_height >= height
                  , rule3 = if (gender == "male") weight > 100
                  , rule4 = gender %in% c("male", "female")
                  )
substitute_values(rules, height = 6, gender = "male")
#> Object of class 'validator' with 4 elements:
#>  rule2        : max_height >= 6
#>  rule3        : weight > 100
#>  .const_height: height == 6
#>  .const_gender: gender == "male"
```

### Finding fixed values

``` r
rules <- validator( rule1 = x >= 0, rule2 = x <=0)
detect_fixed_variables(rules)
#> $x
#> [1] 0
simplify_fixed_variables(rules)
#> Object of class 'validator' with 1 elements:
#>  .const_x: x == 0

rules <- validator( rule1 = x1 + x2 + x3 == 0
                  , rule2 = x1 + x2 >= 0
                  , rule3 = x3 >=0
                  )
simplify_fixed_variables(rules)
#> Object of class 'validator' with 3 elements:
#>  rule1    : x1 + x2 + 0 == 0
#>  rule2    : x1 + x2 >= 0
#>  .const_x3: x3 == 0
```

### Simplifying conditional statements

``` r
# non-relaxing clause
rules <- validator( r1 = if (income > 0) age >= 16
                  , r2 = age < 12
                  )
# age > 16 is always FALSE so r1 can be simplified
simplify_conditional(rules)
#> Object of class 'validator' with 2 elements:
#>  r1: income <= 0
#>  r2: age < 12


# non-constraining clause
rules <- validator( rule1 = if (age  < 16) income == 0
                  , rule2 = if (age >=16) income >= 0
                  )
simplify_conditional(rules)
#> Object of class 'validator' with 2 elements:
#>  rule1: age >= 16 | (income == 0)
#>  rule2: income >= 0
```

### Removing redundant rules

``` r
rules <- validator( rule1 = age > 12
                  , rule2 = age > 18
                  )

# rule1 is superfluous
remove_redundancy(rules, verbose=TRUE)
#> Removed redundant rule(s):
#>   rule1: age > 12
#> Object of class 'validator' with 1 elements:
#>  rule2: age > 18

rules <- validator( rule1 = age > 12
                  , rule2 = age > 12
)

# standout: rule1 and rule2, first rule wins
remove_redundancy(rules, verbose=TRUE)
#> Removed redundant rule(s):
#>   rule2: age > 12
#> Object of class 'validator' with 1 elements:
#>  rule1: age > 12

# Note that detection signifies both rules!
detect_redundancy(rules, verbose=TRUE)
#> Redundant rule(s):
#>   rule1: age > 12
#>   rule2: age > 12
#> rule1 rule2 
#>  TRUE  TRUE
```
