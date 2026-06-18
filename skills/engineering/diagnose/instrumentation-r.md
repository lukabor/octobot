# Instrumentation in R

Phase 4 of `diagnose`. The rule: **prefer interactive inspection over
logging, change one variable at a time, tag every line you add so cleanup
is `grep`-able**.

## Interactive inspection (prefer these)

### `browser()`
Drop a breakpoint at the suspected frame and poke around.
```r
build_plot <- function(modb_raw) {
  browser()                     ### DIAGNOSE-2026-05-28
  df <- modb_raw |> reshape() |> rename()
  ggplot(df, aes(...))
}
```
At the prompt: `ls()`, `str(df)`, `head(modb_raw)`, `n` to step, `c` to
continue, `Q` to abort.

### `debugonce(fn)` / `debug(fn)`
Same effect as `browser()` but without editing the function. Best when the
target function lives in a package or `box` module.
```r
debugonce(build_plot)
build_plot(modb_raw)              # browser fires once, then disables itself
```
Cleanup is automatic. `debug()` persists until `undebug()`.

### `options(error = ...)` for post-mortem
Drop into the failing frame *at the moment of the error*.
```r
options(error = rlang::entrace)  ### DIAGNOSE-2026-05-28
# reproduce the bug, then:
rlang::last_trace()              # clean stack with frame numbers
rlang::last_trace(drop = FALSE)  # everything
```
Or the classic:
```r
options(error = recover)         # pick a frame after the crash
```
Reset with `options(error = NULL)` in cleanup.

### `lobstr::cst()` — mid-execution stack
```r
build_plot <- function(modb_raw) {
  lobstr::cst()                  ### DIAGNOSE-2026-05-28 — see who called me
  ...
}
```
Useful when the same helper is called from multiple sites and you can't
tell which path hit it.

## Logging (only when interactive isn't possible)

When the bug only repros in a non-interactive run (CI, `targets`
workers, a long bookdown render), `cat()` *with the diagnose tag*:
```r
cat(sprintf("### DIAGNOSE-2026-05-28 assemble_expr: nrow=%d md5=%s\n",
            nrow(df), digest::digest(df)))
```

## Performance bugs

### `profvis::profvis()`
Wrap the slow call. Open the resulting flamegraph in the IDE.
```r
profvis::profvis(build_book())
```
Look for: one box that dominates (target it), or thousands of tiny boxes
(loop / vectorisation problem).

### `bench::mark()`
For A/B microbenchmarks once you have a hypothesis about the slow path:
```r
bench::mark(
  baseline = old_assemble(raw),
  patched  = new_assemble(raw),
  iterations = 50
)
```

## `targets` pipelines

After a target fails, inspect upstream inputs without re-running them:
```r
targets::tar_load_everything()
browser()                        ### DIAGNOSE-2026-05-28
```

## The `### DIAGNOSE-<date>` tag convention

- **Every** line you add for diagnosis carries `### DIAGNOSE-YYYY-MM-DD`.
- Phase 6 ends only when `grep -r "### DIAGNOSE-" .` returns zero hits.

## Anti-patterns
- **Adding `print()`s without a tag.** They survive into commits.
- **Multiple hypotheses instrumented at once.** Loses the signal.
- **Smuggling a fix into instrumentation.** Separate the two phases.
- **Leaving `options(error = recover)` in `.Rprofile`** — devastating in CI.
