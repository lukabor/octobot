# Imports with `box::use`

`box::use` replaces both `library()` and `source()`. It gives function-
level imports (so you see exactly what each file depends on), aliasing,
and module reload semantics — none of which `library` provides.

## Canonical import block

The project pattern, from a real cache module:

```r
box::use(
  nanoparquet[read_parquet, write_parquet],
  jsonlite[toJSON, fromJSON],
  fs[dir_create, dir_exists, file_exists, file_info],
  tibble[tibble],
  ./log[relocate_log, log_msg, setup_log, ensure_log]
)
```

Rules of thumb:
- **One `box::use(...)` block per file**, at the top, no trailing
  `library()` calls.
- **Name the imports** (`pkg[fn1, fn2]`). Avoid `pkg[...]` — the wildcard
  hides the contract.
- **Relative paths for in-repo modules** (`./log`, `../indication/client`).
- **Sort alphabetically** within the block; in-repo modules last.

## Aliased imports

When you'd rather keep the package name visible:

```r
box::use(
  dp = dplyr,
  dt = data.table[setDT, setnames],
)

result <- df |> dp$filter(x > 0) |> dp$summarise(n = dp$n())
```

This is the project's preferred form when calling many functions from one
package — avoids 12 names in the import list and keeps grep-ability.

## Public surface = `box::export`

When writing a `box` module:

```r
# R/indication/client.R
box::export(query_dataset)              # only this is callable from outside

query_dataset   <- function(id) { ... }
prepare_request <- function(id) { ... } # internal — invisible to callers
fetch_pages     <- function(req) { ... }
```

Keep `box::export()` deliberately small — see
[../tdd-bdd/deep-modules-r.md](../tdd-bdd/deep-modules-r.md). Every name
you export is a contract you owe future callers and tests.

## Anti-patterns

### `library()` at the top of a file — BAD
```r
# R/base/ntcs.R
library(readr)              # leaks into every chapter that sources this
read_csv("...")
```
**Fix:**
```r
box::use(readr[read_csv])
read_csv("...")
```
In a bookdown repo a stray `library()` in an early chapter can change
later chapters silently (e.g. `dplyr` masking `stats::filter`). Always
scoped imports.

### `source()` — BAD
```r
# R/base/dw_base_data.R
source("R/base/dw_hippie.R", local = TRUE)
```
**Fix:**
```r
box::use(./dw_hippie[load_hippie])
load_hippie()
```
`source` runs the whole file for its side effects; you cannot see what
landed in your namespace, and you cannot test it in isolation.
