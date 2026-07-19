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

## `dtplyr` × `box::use` — the NSE restriction

`dtplyr` rewrites your `dplyr` verb chain into a `data.table`
`j`-expression by **pattern-matching the AST**. The matcher only sees
calls that are either **bare** (`across(...)`) or **`::`-namespaced**
(`dplyr::across(...)`). Anything else — including the aliased form
`dp$across(...)` you get from `box::use(dp = dplyr)` — is opaque and
leaks into the generated `j`-expression *unevaluated*. You then get a
cryptic `data.table` error or a silently wrong result.

The names that matter (the `dplyr` NSE helpers used by `dtplyr`):
`across`, `all_of`, `any_of`, `n`, plus any non-standard-evaluation helper
you put inside a `summarise()` / `mutate()` / `group_by()`.

### Bad — aliased import only
```r
box::use(
  dp = dplyr,
  dt = data.table[lazy_dt],
)

agg <- df |>
  dt$lazy_dt() |>
  dp$group_by(dp$across(dp$all_of(grp))) |>   # opaque to dtplyr!
  dp$summarise(n = dp$n())
```

### Good — alias the verbs, import NSE helpers as bare names
```r
box::use(
  dplyr,
  # bare names: dtplyr's NSE pattern matcher only recognises
  # `across`/`all_of`/`any_of`/`n` when the AST is a bare call or
  # `::`-namespaced; `dplyr$across(...)` is opaque to it and leaks
  # into data.table's j-expression unevaluated.
  dplyr[across, all_of, any_of, n],
  dtplyr,
  tibble,
)

agg <- df |>
  dtplyr$lazy_dt() |>
  dplyr$group_by(across(all_of(grp))) |>      # bare — dtplyr sees it
  dplyr$summarise(n = n()) |>
  tibble$as_tibble()
```

Two-line rule:
1. Keep `dplyr$verb()` aliasing for the **verbs** (`filter`, `mutate`,
   `summarise`, `group_by`, …) — those execute normally.
2. Import `across`, `all_of`, `any_of`, `n` as **bare names** so the
   `dtplyr` AST matcher recognises them.

The same applies for any other NSE helper that `dtplyr` special-cases
(`if_any`, `if_all`, `desc`, `cur_group`, …). When in doubt: bare-name
import, then verify the pipeline returns a `tibble` not a `data.table`
error.

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
- [../bdd/interface-design-r.md](../bdd/interface-design-r.md) —
  "return, don't mutate" applies even harder to `data.table`.
