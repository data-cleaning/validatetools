#' add meta data to the simplified validator object
decorate_validator <- function(x_old, x_new, description = "simplified"){
  idx <- match(names(x_new), names(x_old), nomatch = 0)
  x_old <- x_old[idx]
  
  idx <- match(names(x_old), names(x_new))
  
  # newly created rules
  if (length(idx) < length(x_new)){
    origin(x_new)[-idx] <- "validatetools"
    description(x_new)[-idx] <- description
  }
  
  # reuse all meta data
  if (length(idx)){
    label(x_new)[idx] <- label(x_old)[]
    created(x_new)[idx] <- created(x_old)[]
    origin(x_new)[idx] <- origin(x_old)[]
    description(x_new)[idx] <- description(x_old)[]
  
    # update meta data for changed expressions
    exprs_old <- as.character(to_exprs(x_old))
    exprs_new <- as.character(to_exprs(x_new[idx]))
    changed <- exprs_new != exprs_old
    if (any(changed)){
      idx <- idx[changed]
      origin(x_new)[idx] <- "validatetools"
      description(x_new)[idx] <- paste0( description
                                       , " from '"
                                       , exprs_old[idx]
                                       , "'\n"
                                       , description(x_new)[idx]
                                       )
    }
  }
  
  x_new
}

# x_old <- validator( r1 = x > 1
#                   , r2 = x > 2
#                   , r4 = y > 3
#                   , r7 = if (y > 1) w < 3
#                   )

# description = "hi!"
# x_new2 <- decorate_validator(x_old, x_new, "hi!")
# 
# cat(as_yaml(x_new2))
# 
# validate::export_yaml(x_old, 'test.yaml')
# x_old <- validator(.file = "test.yaml")
# 
# x_new <- simplify_rules(x_old, y = 4)
# x_new2 <- decorate_validator(x_old, x_new, "simplified")
# 
# cat(as_yaml(x_new2))
