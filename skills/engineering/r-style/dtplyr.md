# `dtplyr` — `data.table` speed, `dplyr` surface

`dtplyr` lets you keep the `dplyr` verb chain while executing on
`data.table` internals. The right call for large-frame chained
aggregations; the wrong call for small frames and for one-off operations.

## When to use

- Frames ≳ 1 M rows that go through several chained `dplyr` verbs.
- A pipeline whose intermediate steps would each materialise a copy in
  base `dplyr`; `dtplyr` collapses them into one `data.table` expression.
- The caller wants a `tibble`, not a `data.table`, on the way out.

## Canonical pattern

```r
box::use(
  dt = data.table[lazy_dt],
  dplyr[filter, group_by, summarise, n],
  tibble[as_tibble],
)

agg_expression <- function(df) {
  df |>
    dt$lazy_dt() |>
    filter(expr > 0) |>
    group_by(gene_id, tissue) |>
    summarise(n_cells = n(), mean_expr = mean(expr), .groups = "drop") |>
    as_tibble()
}
```

Three rules:
- **Enter with `lazy_dt()`**, **exit with `as_tibble()`** unless the
  caller documented a `data.table` contract. Never leak a lazy frame.
- **No `collect()` mid-pipeline.** The point is one fused expression.
- **No `:=` inside the chain.** Reference semantics defeat lazy
  evaluation; if you need it, drop out to plain `data.table`.

## Reference-semantics warning

`data.table` mutates in place. A function that accepts a `data.table` and
"just does a tweak" may silently change every caller's copy.

### Bad
```r
# Caller passes a data.table; we silently mutate it.
add_log_expr <- function(dt_in) {
  dt_in[, log_expr := log1p(expr)]    # mutates the caller's object
  dt_in
}
```
Two calls in a row look idempotent and aren't:
```r
x <- as.data.table(data.frame(expr = c(1, 2, 3)))
add_log_expr(x); add_log_expr(x)      # log_expr column now wrong
```

### Good — copy at the boundary
```r
add_log_expr <- function(dt_in) {
  dt_in <- data.table::copy(dt_in)    # defensive copy at the seam
  dt_in[, log_expr := log1p(expr)]
  dt_in
}
```
Or, better, stay in the `dtplyr` lane and don't take a `data.table` at
all:
```r
add_log_expr <- function(df) {
  df |> dt$lazy_dt() |> mutate(log_expr = log1p(expr)) |> as_tibble()
}
```
This is exactly the bug class covered in
[../diagnose/feedback-loops-r.md](../diagnose/feedback-loops-r.md)
*"Worked example 1 — in-place mutation, intermittently wrong output"*.
Read that before you reach for `:=`.

## <a id="when-not-to-use"></a>When NOT to use

- Frames < ~100 K rows. The `data.table` setup cost dominates; `dplyr`
  on a `tibble` is the same speed or faster.
- Single-verb operations (just `filter`, just `mutate`). No fusion to
  gain.
- When the caller relies on `data.table` reference semantics in your
  return value. `as_tibble()` materialises and copies.
- Inside `targets` pipelines where the target's contract is a `tibble` —
  don't surprise downstream targets with a `data.table`.

## See also
- [box.md](box.md) — preferred way to bring `data.table` / `dtplyr`
  names into scope (`dt = data.table[...]`).
- [../tdd-bdd/interface-design-r.md](../tdd-bdd/interface-design-r.md) —
  "return, don't mutate" applies even harder to `data.table`.
