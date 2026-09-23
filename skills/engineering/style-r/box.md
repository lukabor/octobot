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

**Exception — `dplyr` + `dtplyr`.** The NSE helpers `across`, `all_of`,
`any_of`, `n` must be imported as **bare names** even when the rest of
`dplyr` is aliased. `dtplyr`'s AST matcher does not see `dp$across(...)`
and the call leaks into the generated `data.table` expression
unevaluated. See [dtplyr.md § dtplyr × box::use](dtplyr.md#dtplyr--boxuse--the-nse-restriction).

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
`/bdd`. Every name
you export is a contract you owe future callers and tests.

## `.Rmd` setup chunks — no exception

The rule is the same for `.Rmd` setup chunks as for `.R` files: **no
`library()`, no `source()`**. Migrated bookdown chapters open with a
single `box::use(...)` block and call `knitr::opts_chunk$set(...)` with
explicit `::` namespacing — never `library(knitr)`.

```r
# Rmd/indication/<chapter>.Rmd — migrated style
box::use(targets[tar_read])
knitr::opts_chunk$set(echo = TRUE, message = FALSE, warning = FALSE)
```

**The one documented exception** is a *legacy-script bridge*: when a
chapter must `sys.source()` an older script that resolves bare names
(e.g. `data.table`, `dplyr`) at top level. The shim must (a) carry a
comment explaining *why* it isn't using `box::use`, and (b) be tracked
as a migration target — not a precedent. Example from the repo:

```r
# Legacy script shim: source `legacy_analysis.R` into a private env
# (parent = globalenv) so its many intermediate bindings do NOT leak
# into sibling chapters. ...
library(data.table); library(dplyr); library(tibble); library(stringr); library(magrittr)
box::use(R/base/utility_fn[get_ensembl_link])
hom_env <- new.env(parent = globalenv())
sys.source("R/indication/legacy_script.R", envir = hom_env)
```

Two infrastructure pieces support this policy:

- `R/base/render_book.R` sets `options(box.path = project_root)` so
  `box::use(R/...)` resolves regardless of bookdown's working directory.
- The same file anchors the knit env to `globalenv()` so legacy bare-name
  lookups still work *without* breaking `box::use` bindings.

## Reloading modules — `box::reload()`

`box::use` caches modules across the R session. When you've edited a
module and want the change to take effect in the same session — testing
in the REPL, iterating in a `diagnose` loop, re-rendering a chapter —
call:

```r
box::reload(R/indication/client)        # drops the cache; next box::use re-evaluates
```

Use this in `feedback-loops-r.md` loops where determinism matters more
than speed. See
`/diagnose`.

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
