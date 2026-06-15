# Refactor candidates (R)

After every bdd cycle goes green, scan for these. Refactor only with a
green test bar.

## Duplication → extract a function

Three lines that recur in two places: probably noise. Three *similar* lines
in three places, with a shared shape: extract.

```r
# Before — same column rename pattern in three pipelines
df1 |> rename(gene = gene_symbol, expr = expression)
df2 |> rename(gene = gene_symbol, expr = expression)
df3 |> rename(gene = gene_symbol, expr = expression)
```

```r
# After
normalize_cols <- function(df) rename(df, gene = gene_symbol, expr = expression)
```

Resist extracting on first sight — premature abstractions are worse than
duplication.

## Long functions → private helpers, public interface unchanged

A 200-line `query_modb()` can be split into `prepare_request()`,
`fetch_pages()`, `parse_response()` — *kept inside the same `box` module
without `box::export()`*. Tests still target `query_modb()`. The helpers
are an internal convenience, not part of the contract.

```r
# R/modb/client.R
box::export(query_modb)               # only this is public

query_modb    <- function(id) prepare_request(id) |> fetch_pages() |> parse_response()
prepare_request <- function(id) { ... }
fetch_pages     <- function(req) { ... }
parse_response  <- function(raw) { ... }
```

## Shallow modules → combine or deepen

Two modules that always travel together, each exporting one thin function?
Merge them. A module that exports eight helpers users always call in the
same order? Deepen — collapse them behind one entry point. (See
`deep-modules-r.md`.)

## Feature envy → move logic to where the data lives

A function in `R/plot/plot_bxp.R` that does heavy reshaping of a
`modb_result` tibble probably belongs in `R/modb/client.R` (or wherever
`modb_result` is constructed). The test of `plot_bxp` then becomes about
plotting, not about reshape.

```r
# Before — plot module reaches into modb internals
build_bxp_plot <- function(modb_raw) {
  df <- modb_raw$data |> filter(...) |> pivot_longer(...) |> rename(...)
  ggplot(df, aes(...)) + geom_point()
}
```

```r
# After — modb module owns its shape
# R/modb/client.R
as_long_expr <- function(modb_raw) modb_raw$data |> filter(...) |> pivot_longer(...)

# R/plot/plot_bxp.R
build_bxp_plot <- function(modb_raw) {
  ggplot(as_long_expr(modb_raw), aes(...)) + geom_point()
}
```

## Primitive obsession → S3 value objects

Passing `dataset_id = "DS001"`, `genes = c("ENSG1","ENSG2")`, `cohort =
"PRODUCTION"` everywhere? Wrap them in a constructor + validator:

```r
new_query <- function(dataset_id, genes, cohort = "PRODUCTION") {
  stopifnot(is.character(dataset_id), length(dataset_id) == 1L)
  structure(
    list(dataset_id = dataset_id, genes = genes, cohort = cohort),
    class = "modb_query"
  )
}
validate_query <- function(q) { ... ; q }
```

Now `query_modb()` takes one `modb_query`, every test builds one with
`new_query(...)`, and validation lives in one place.

## Existing code the new code reveals as problematic

The most valuable refactor after a TDD cycle is sometimes *not* in the code
you just wrote. New tests often expose nearby code that is untested,
implicit, or duplicated. Flag it; don't necessarily fix it in the same
commit, but capture the finding so it isn't forgotten.

## `targets` pipelines

Refactor target definitions to keep transforms pure: each `tar_target` is
a function of upstream targets, no side effects. If a target writes a file
out-of-band, that file is invisible to `targets`' invalidation and your
tests can't reason about it. Return the data; let `targets` cache it.

## Never refactor while red

If the suite is red, fix the test or fix the code — do not "tidy while
fixing". Two changes mixed together are two regressions waiting to happen.
