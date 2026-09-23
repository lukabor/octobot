# Interface design for testability (R)

Vocabulary lives in `/design-codebase` —
module, interface, seam, adapter. This file is the R-flavored leaf.

Three rules. Apply them before writing the test, not after.

> Snippets below show only the function bodies; the `box::use(...)`
> prologue is omitted for clarity. Real files start with one — see
> `/style-r`.

## 1. Dependency injection — pass clients, don't construct them

Functions that build their own dependencies are hard to test because the
test has to monkey-patch the constructor.

```r
# BAD — constructs the client internally
process_order <- function(order) {
  client <- get_modb_client(Sys.getenv("MODB_CRED"))  # hidden global!
  client$charge(order$total)
}
```

```r
# GOOD — client is a parameter
process_order <- function(order, client) {
  client$charge(order$total)
}
```

The test passes a stub list `list(charge = function(x) list(status = "ok"))`
instead of mocking `get_modb_client` and `Sys.getenv`.

R-specific: default arguments are the idiomatic seam.

```r
process_order <- function(order, client = get_modb_client()) { ... }
```

Production code uses the default; tests pass an explicit stub.

## 2. Pure functions — return, don't mutate

A function that returns its result is testable with one `expect_equal`.
A function that writes to disk, modifies `options()`, or assigns into the
global env needs setup, teardown, and a side-channel assertion.

```r
# BAD — mutates state
reduce_expr <- function(expr_df) {
  expr_df$total <<- expr_df$total * 0.9   # global mutation
  invisible(NULL)
}
```

```r
# GOOD — returns the new expr data frame
reduce_expr <- function(expr_df) {
  expr_df$total <- expr_df$total * 0.9
  expr_df
}
```

For pipelines, return a tibble (or `data.table`) and let the caller decide
where it goes. `targets` factors this naturally: each target is a pure
function of its upstream targets.

## 3. Minimal interface complexity

Each parameter is a multiplier on the number of test cases. Each method on
an S3 object is something a test must consider. Shrink the surface:

- Fold orthogonal arguments into one structured input
  (`opts = list(retries = 3, timeout = 10)` beats six positional args).
- Use S3 generics with one dispatch path instead of `if (is.character(x))
  ... else if (is.numeric(x)) ...` inside the function.
- Default everything that has an obvious default; require only what varies.

The single test: *can a new caller use this function correctly without
reading its body?* If no, the interface is too complex regardless of how
clever the implementation is.
