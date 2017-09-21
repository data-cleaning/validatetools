
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/validatetools)](https://cran.r-project.org/package=validatetools)[![Travis-CI Build Status](https://travis-ci.org/data-cleaning/validatetools.svg?branch=master)](https://travis-ci.org/data-cleaning/validatetools) [![Coverage Status](https://img.shields.io/codecov/c/github/data-cleaning/validatetools/master.svg)](https://codecov.io/github/data-cleaning/validatetools?branch=master)

validatetools
=============

`validatetools` is a utility package for managing validation rule sets that are defined with `validate`. In production systems validation rule sets tend to grow organically and accumulate redundant or (partially) contradictory rules. `validatetools` helps to identify problems with large rule sets and includes simplification methods for resolving issues.

Installation
------------

You can install a beta version of `validatetools` with

``` r
install.packages("validatetools", repos = "https://data-cleaning.github.io/drat")
```

The adventurous can install an (unstable) `validatetools` from github with:

``` r
# install.packages("devtools")
devtools::install_github("data-cleaning/validatetools")
```

Example
-------

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

detect_infeasible_rules(rules)
#> [1] "rule1"
make_feasible(rules)
#> Dropping rule(s): "rule1"
#> Object of class 'validator' with 1 elements:
#>  rule2: x < 0
#> Rules are evaluated using locally defined options

# find out the conflict with this rule
is_contradicted_by(rules, "rule1")
#> [1] "rule2"
```

Simplifying
-----------

The function `simplify_rules` combines most simplification methods of `validatetools` to simplify a rule set. For example, it reduces the following rule set to a simpler form:

``` r
rules <- validator( if (age < 16) income == 0
                  , job %in% c("yes", "no")
                  , if (job == "yes") income > 0
                  )
simplify_rules(rules, age = 13)
#> Object of class 'validator' with 3 elements:
#>  .const_income: income == 0
#>  .const_age   : age == 13
#>  .const_job   : job == "no"
#or 
simplify_rules(rules, job = "yes")
#> Object of class 'validator' with 3 elements:
#>  V1        : age >= 16
#>  V3        : income > 0
#>  .const_job: job == "yes"
```

`simplify_rules` combines the following simplification and substitution methods:

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
rules <- validator( x >= 0, x <=0)
detect_fixed_values(rules)
#> $x
#> [1] 0
simplify_fixed_values(rules)
#> Object of class 'validator' with 1 elements:
#>  .const_x: x == 0

rules <- validator( rule1 = x1 + x2 + x3 == 0
                  , rule2 = x1 + x2 >= 0
                  , rule3 = x3 >=0
                  )
simplify_fixed_values(rules)
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
rules <- validator( if (age  < 16) income == 0
                  , if (age >=16) income >= 0
                  )
simplify_conditional(rules)
#> Object of class 'validator' with 2 elements:
#>  V1: !(age < 16) | (income == 0)
#>  V2: income >= 0
```

### Removing redundant rules

``` r
rules <- validator( rule1 = age > 12
                  , rule2 = age > 18
                  )

# rule1 is superfluous
simplify_redundancy(rules)
#> Object of class 'validator' with 1 elements:
#>  rule2: age > 18

rules <- validator( rule1 = age > 12
                  , rule2 = age > 12
)

# standout: rule1 and rule2, first rule wins
simplify_redundancy(rules)
#> Object of class 'validator' with 1 elements:
#>  rule1: age > 12

# Note that detection signifies both rules!
detect_redundancy(rules)
#> rule1 rule2 
#>  TRUE  TRUE
```
