# Tidyverse style — paired good/bad

Follows the [Tidyverse style guide](https://style.tidyverse.org/) where it
matches the project's idiom. Four substitutions matter most.

> Snippets below show only the function bodies; the `box::use(...)`
> prologue is omitted for clarity. Real files start with one — see
> [box.md](box.md).

## <a id="for-loops"></a>1. `for` loops → `purrr` mapping

### Bad — real example, list-column flattening
```r
# R/base/cache.R
for (col in names(df)) {
  if (is.list(df[[col]])) {
    df[[col]] <- vapply(df[[col]], function(v) {
      if (is.null(v) || (length(v) == 1 && is.na(v[[1]]))) NA_character_
      else if (length(v) == 1) as.character(v[[1]])
      else toJSON(v, auto_unbox = TRUE)
    }, character(1))
  }
}
```
The loop mutates `df` by column-name lookup; the intent ("flatten every
list column to a character vector") is buried.

### Good
```r
flatten_one <- function(v) {
  if (is.null(v) || (length(v) == 1 && is.na(v[[1]]))) NA_character_
  else if (length(v) == 1) as.character(v[[1]])
  else jsonlite::toJSON(v, auto_unbox = TRUE)
}

df <- df |>
  dplyr::mutate(dplyr::across(
    dplyr::where(is.list),
    \(col) purrr::map_chr(col, flatten_one)
  ))
```
Intent visible at the call site; the row-level transform is a pure
function (`flatten_one`) you can test in isolation.

## 2. `library()` → `pkg::fn()` or `box::use`

### Bad — real example
```r
# R/base/ntcs.R
library(readr)
read_csv("...")
```

### Good
```r
box::use(readr[read_csv])
read_csv("...")
```
See [box.md](box.md) for the longer argument.

## <a id="extraction"></a>3. `$` / `[[` → `purrr::chuck` / `pluck`

### Bad — real example, silent NA on missing key
```r
# R/base/query_ntcs.R
patentNumber    = map_chr(patents, ~ paste(.x[["patentNumber"]],    collapse = "; ")),
publicationDate = map_chr(patents, ~ paste(.x[["publicationDate"]], collapse = "; "))
```
If a patent record is missing `patentNumber`, `.x[["patentNumber"]]`
returns `NULL`, `paste(NULL, collapse = "; ")` returns `""`, and the row
goes out wrong with no warning.

### Good
```r
patentNumber    = purrr::map_chr(patents, \(p) paste(purrr::chuck(p, "patentNumber"),    collapse = "; ")),
publicationDate = purrr::map_chr(patents, \(p) paste(purrr::chuck(p, "publicationDate"), collapse = "; "))
```
`chuck` errors at the missing key — you find the schema bug in the first
test run instead of seeing empty cells in a rendered report. When a
missing key is genuinely OK, use `purrr::pluck(p, "patentNumber",
.default = NA_character_)` — the *intent* (lenient default) is now in the
code, not in the absence of an error.

## 4. `source()` → `box::use`

### Bad — real example
```r
# R/base/dw_base_data.R
source("R/base/dw_hippie.R", local = TRUE)
```

### Good
```r
box::use(./dw_hippie[load_hippie])
load_hippie()
```
See [box.md](box.md). `source` is invisible imports + arbitrary side
effects; `box::use` is named imports + tested boundaries.

## 5. Native pipe `|>` only — no `%>%`

Use the base R native pipe. `magrittr`'s `%>%` is an extra dependency
with subtly different semantics (`.` placeholder, lazy evaluation, S4
method dispatch quirks).

### Bad
```r
df %>% filter(x > 0) %>% select(a, b)
```

### Good
```r
df |> filter(x > 0) |> select(a, b)
```

When you need a placeholder, name the argument:

```r
df |> filter(x > 0) |> with(cor(a, b))   # WRONG — looks like magrittr `.`
df |> filter(x > 0) |> (\(d) cor(d$a, d$b))()   # RIGHT — explicit lambda
```

## 6. Anonymous functions — `\(x)` over `function(x)`

The native shorthand is shorter, scans faster inside a pipe, and is
unambiguous in argument position.

### Bad
```r
list |> map(function(x) x^2)
```

### Good
```r
list |> map(\(x) x^2)
```

`function(x)` is fine for top-level definitions (`flatten_one <-
function(v) ...`); the shorthand is the default *inline*.

## 7. Naming — `snake_case` for everything except constants

```r
# Functions, variables
calculate_mean   <- function(x) mean(x)
dataset_ids      <- c("DS001", "DS002")

# Constants
MAX_ITERATIONS   <- 1000
DEFAULT_TIMEOUT  <- 30L
```

Anti-patterns: `camelCase`, `dot.separated` (legacy base R idiom), and
`PascalCase` for anything that isn't an S4 class.

```r
# WRONG
calculateMean    <- function(x) mean(x)
my.helper        <- function(x) x
maxIterations    <- 1000
```

## 8. Roxygen2 docs on every exported function (packages only)

In an R package (`DESCRIPTION` present), every `@export`ed function
needs a roxygen2 block. Markdown enabled.

```r
#' Calculate the mean of a numeric vector
#'
#' @param x A numeric vector.
#' @param na_rm Logical. Remove NAs before computing? Default `TRUE`.
#' @returns A scalar numeric.
#' @export
calculate_mean <- function(x, na_rm = TRUE) {
  mean(x, na.rm = na_rm)
}
```

Minimum required tags: title (the first line), `@param` for every
argument, `@returns`, `@export`. `@examples` when the function is
non-trivial. No docs is a `devtools::check()` warning.

In `box::use`-based projects without a `DESCRIPTION`, roxygen2 is
optional — but a one-line `#'` comment over every exported function is
still strongly recommended.

## Tooling

- `styler::style_pkg()` — auto-format to Tidyverse rules.
- `lintr` — flag violations in CI; configure with `.lintr` at the repo
  root.

The skill states the rules. The tools enforce them. Don't run tooling
inside the edit you're being asked to review — that conflates style
changes with logic changes (anti-atomic — see
[`../../productivity/commit-atomic-jj/SKILL.md`](../../productivity/commit-atomic-jj/SKILL.md)).
