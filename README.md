
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/validatetools)](https://cran.r-project.org/package=validatetools)[![Travis-CI Build Status](https://travis-ci.org/data-cleaning/validatetools.svg?branch=master)](https://travis-ci.org/data-cleaning/validatetools) [![Coverage Status](https://img.shields.io/codecov/c/github/data-cleaning/validatetools/master.svg)](https://codecov.io/github/data-cleaning/validatetools?branch=master)

validatetools
=============

`validatetools` is a utility package for managing validation rule sets that can be defined with `validate`. In production systems validation rule sets tend to grow organically and accumulate redundant or (partial) contradictory rules. `validatetools` helps to identify problems with large rule sets and includes simplification methods for resolving issues.

Installation
------------

You can install validatetools from github with:

``` r
# install.packages("devtools")
devtools::install_github("data-cleaning/validatetools")
```

Example
-------

### Value substitution

``` r
library(validatetools)
#> Loading required package: validate
rules <- validator( rule1 = z > 1
                  , rule2 = y > z
                  , rule3 = if (gender == "male") w > 2
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
#> Warning: Currently only checking numerical values
#> $x
#> [1] 0
```
