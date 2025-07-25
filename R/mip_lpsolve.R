# provides an interface to mip solvers.
# currently only lpSolveAPI, should be workable for glpt

#' translate linear rules into an lp problem
#' @importFrom lpSolveAPI dimnames<-.lpExtPtr
#' @param  rules mip rules
#' @param objective function
#' @param eps accuracy for equality/inequality
#' @keywords internal
translate_mip_lp <- function( rules
                            , objective=NULL
                            , eps = 1e-3
                            ){
  
  lc <- get_mr_matrix(rules)
  type <- get_mr_type(rules)

  A <- lc$A
  nvar <- ncol(A)

  lps <- lpSolveAPI::make.lp( nrow = nrow(A)
                            , ncol = nvar
                            )

  lpSolveAPI::lp.control( lps,
                          presolve = "rows",
                          epsint = 1e-15,
                          epspivot = 1e-15
                        )

  dimnames(lps) <- dimnames(A)

  for (v in 1:ncol(A)){
    lpSolveAPI::set.column(lps, v, A[,v])
  }

  ops <- lc$operator
  ops[ops=="=="] <- "="
  ops[strict <- ops=="<"] <- "<="

  is_binary <- type  == "binary"
  if (any(is_binary)){
    columns <- type[is_binary]
    columns <- match(names(columns), colnames(A))
    lpSolveAPI::set.type(lps, columns, "binary")
  }
  is_double <- !is_binary

  if (any(is_double)){
    columns <- type[is_double]
    columns <- match(names(columns), colnames(A))
    lpSolveAPI::set.type(lps, columns, "real")
    lpSolveAPI::set.bounds(lps, lower=rep(-Inf, length(columns)), columns=columns)
  }

  if (length(objective)){
    obj <- objective[objective != 0]
    columns <- match(names(obj), colnames(A))
    if (any(is.na(columns))){
      stop("Invalid objective function")
    }
    lpSolveAPI::set.objfn(lps, unname(obj), columns)
  }

  lpSolveAPI::set.constr.type(lps,types=ops)

  b <- ifelse(strict, lc$b - eps, lc$b)
  lpSolveAPI::set.constr.value(lps, b)
  lps
}

### testing

# v <- validator( a>1, b+4 > c-z, A %in% "a")
# rules <- lin_as_mip_rules(v)
# translate_mip_lp(c(rules, cat_as_mip_rules(v)))
