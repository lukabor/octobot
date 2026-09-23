---
name: style-r
description: Project R coding standards — Tidyverse style, `box::use` for imports (no `library()` / `source()`), `purrr::chuck`/`pluck` instead of `$`/`[[`, `purrr::map`/`walk` instead of `for`, and `dtplyr` for large data.table work. Use when the user writes or edits R code, asks "is this R idiomatic", "review my R style", "use box", "use dtplyr", or opens an .R / .Rmd file and asks for help.
---

# style-r

## When to use
- Writing or editing R (`.R` / `.Rmd`) in a project that follows the
  Tidyverse style guide.
- Reviewing R code for style / idiom.
- User says "use box", "use dtplyr", "make this tidyverse-y", "review my
  R style".

## Top-level rules
1. **Imports go through `box::use`.** No `library()` calls in `.R` or
   `.Rmd` files (top-of-Rmd setup chunks included). No `source()`. See
   [box.md](box.md).
2. **No `for` loops** where a `purrr` mapping fits. Prefer `map`/`walk`/
   `map_chr`/`map_dfr`/`pmap`. See [tidyverse.md](tidyverse.md#for-loops).
3. **No raw `$` or `[[`** on named lists / S3 objects when the key could
   be missing. Use `purrr::chuck()` (strict — errors on miss) or
   `purrr::pluck()` (lenient — `NULL` on miss). See
   [tidyverse.md](tidyverse.md#extraction).
4. **`dtplyr` for large pipelines.** When chained `dplyr` verbs hit
   `data.table`-class objects above ~1 M rows, wrap with
   `data.table::lazy_dt(df)` and exit with `as_tibble()`. See
   [dtplyr.md](dtplyr.md).
5. **Native pipe `|>` only.** No `%>%`. Anonymous functions: `\(x)`,
   not `function(x)`. See [tidyverse.md §5–6](tidyverse.md).
6. **`snake_case` for names, `SCREAMING_SNAKE_CASE` for constants.**
   No `camelCase`, no `dot.separated`. See [tidyverse.md §7](tidyverse.md).
7. **Roxygen2 on every exported function** in a package
   (`DESCRIPTION` present). See [tidyverse.md §8](tidyverse.md).

## Tooling, not enforcement
The skill states the rules; `styler::style_pkg()` and `lintr` enforce them.
Mention these when relevant; never invoke them as part of editing the
file under review.

## Guardrails
- **Never** add `library()` to fix an import — replace the underlying
  call with `pkg::fn()` or add a `box::use` line.
- **Never** introduce a `for` loop "just to keep the diff small". If the
  surrounding code is loop-based, flag it and ask before changing scope.
- **Never** silently swap `$` for `chuck`. They have different failure
  modes — `chuck` errors loudly, which is the right default but a
  behaviour change. Confirm before flipping in legacy code.
- **Never** wrap small frames with `lazy_dt`. The overhead exceeds the
  saving. See [dtplyr.md](dtplyr.md#when-not-to-use).

## See also
- `/bdd` —
  `box::export()` is the public-surface control mechanism.
- `/bdd` —
  pure functions + DI compose with these style rules.
- `/diagnose` —
  worked example #1 (in-place mutation) is the canonical `dtplyr` /
  `data.table::copy()` failure mode.
- `/commit-atomic-jj`
  — when a style refactor changes more than one file, it's an atomic
  commit of its own.
