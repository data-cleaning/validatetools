
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/validatetools)](https://cran.r-project.org/package=validatetools)[![Travis-CI Build Status](https://travis-ci.org/data-cleaning/validatetools.svg?branch=master)](https://travis-ci.org/data-cleaning/validatetools) [![Coverage Status](https://img.shields.io/codecov/c/github/data-cleaning/validatetools/master.svg)](https://codecov.io/github/data-cleaning/validatetools?branch=master)

validatetools
=============

`validatetools` is a utility package for managing validation rule sets that can be defined with `validate`. In production systems validation rule sets tend to grow organically and accumulate redundant or (partial) contradictory rules. `validatetools` helps to identify problems with large rule sets and includes simplification methods for resolving issues.

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
#> Options:
#> raise: none; lin.eq.eps: 1e-08; na.value: NA; sequential: TRUE; na.condition: FALSE

# find out the conflict with this rule
is_contradicted_by(rules, "rule1")
#> [1] "rule2"
```

### Simplifying

The function `simplify_rules` combines most simplification methods in `validatetools` to simplify a rule set. For example, it reduces the following rule set to a simpler form:

``` r
rules <- validator( x > 0
                  , if (x > 0) y == 1
                  , A %in% c("a1", "a2")
                  , if (A == "a1") y > 1
                  )

simplify_rules(rules)
#> Object of class 'validator' with 3 elements:
#>  V1      : x > 0
#>  .const_y: y == 1
#>  .const_A: A == "a2"
```

### Value substitution

``` r
rules <- validator( rule1 = z > 1
                  , rule2 = y > z
                  , rule3 = if (gender == "male") w > 2
                  , rule4 = gender %in% c("male", "female")
                  )
substitute_values(rules, z = 3, gender = "male")
#> Object of class 'validator' with 4 elements:
#>  rule2        : y > 3
#>  rule3        : w > 2
#>  .const_z     : z == 3
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
rules <- validator( r1 = if (x > 1) y > 3
                  , r2 = y < 2
                  )
# y > 3 is always FALSE so r1 can be simplified
simplify_conditional(rules)
#> Object of class 'validator' with 2 elements:
#>  r1: x <= 1
#>  r2: y < 2


# non-constraining clause
rules <- validator( r1 = if (x > 0) y > 0
                  , r2 = if (x < 1) y > 1
                  )
simplify_conditional(rules)
#> Object of class 'validator' with 2 elements:
#>  r1: y > 0
#>  r2: !(x < 1) | y > 1
```

### Removing redundant rules

``` r
rules <- validator( rule1 = x > 1
                  , rule2 = x > 2
                  )

# rule1 is superfluous
simplify_redundancy(rules)
#> Object of class 'validator' with 1 elements:
#>  rule2: x > 2

rules <- validator( rule1 = x > 2
                  , rule2 = x > 2
)

# standout: rule1 and rule2, first rule wins
simplify_redundancy(rules)
#> Object of class 'validator' with 1 elements:
#>  rule1: x > 2

# Note that detection signifies both rules!
detect_redundancy(rules)
#> rule1 rule2 
#>  TRUE  TRUE
```
