# Feedback loops in R — worked examples

Two worked instantiations of [loop-recipes.md](loop-recipes.md). R
idioms: `testthat::test_file(..., reporter="minimal")` for a single test;
`targets::tar_make(names = ...)` for one pipeline target;
`bookdown::preview_chapter()` for one Rmd; `shinytest2::test_app()` for
Shiny. Determinism: `withr::local_seed/local_envvar/local_options`,
`box::reload(R/<module>)` to drop cached `box::use` state,
`renv::snapshot()` to pin versions before hunting.

---

## Worked example 1 — in-place mutation, intermittently wrong output

**Symptom (user):** `build_plot()` sometimes returns a plot with the wrong
y-axis; running the same chapter twice in a row gives different results.

**Phase 1 — build the loop.**
The bookdown render is too slow and the bug is intermittent. Compress to a
testthat test that runs the broken target twice and compares:
```r
test_that("assemble_expr is idempotent", {
  withr::local_seed(1)
  raw  <- make_modb_mock()
  a <- assemble_expr(raw)
  b <- assemble_expr(raw)            # same input, expect same output
  expect_equal(a, b)
})
```
Run: `testthat::test_file("tests/testthat/test_assemble.R", reporter="minimal")`.
It fails on second invocation only. Loop is now deterministic and 0.4 s.

**Phase 3 — hypotheses.**
H1: `assemble_expr` mutates `raw` in place (data.table reference
semantics). Prediction: wrapping the input with `data.table::copy(raw)`
makes the second call match the first.

**Phase 4 — instrument.**
One line:
```r
assemble_expr <- function(raw) {
  raw <- data.table::copy(raw)   ### DIAGNOSE-2026-05-28
  ...
}
```
Test passes. H1 confirmed.

**Phase 5 — regression test** = the idempotence test above (already
written). Now move the `copy()` from the diagnostic patch into the real
fix at the boundary the contract requires (likely the constructor of the
`modb_result` object — see `../bdd/interface-design-r.md`).

**Phase 6 — cleanup.**
`grep -r "### DIAGNOSE-" .` shows zero hits. Commit message:
*"fix(assemble_expr): defensive copy of modb_result — H1 confirmed:
data.table ref-semantics caused intermittent y-axis swap"*.

---

## Worked example 2 — flaky test that depends on RNG

**Symptom (user):** `test_textmining.R::"top terms are stable"` passes
locally, fails 1/10 times on CI.

**Phase 1 — build the loop.**
Run the single test 50 times in a row in a one-liner:
```bash
for i in $(seq 50); do
  Rscript -e 'testthat::test_file("tests/testthat/test_textmining.R", reporter="minimal")' \
    || { echo "FAIL on iter $i"; break; }
done
```
Fails on iteration 7. Loop reproduces in < 30 s.

**Phase 3 — hypotheses.**
H1: the mock data uses `runif()` without a seed; ties in the z-score
ranking sort differently across runs.
H2: a locale-dependent sort on term names.

H1 is more likely (untied scores are improbable when sampling 100 uniforms;
ties happen when the test mock samples a tiny matrix).

**Phase 4 — instrument.**
Add `withr::local_seed(42)` at the top of the test. Run the 50× loop again.
All green. H1 confirmed; H2 not pursued (one variable at a time).

**Phase 5 — regression test:** the seeded test *is* the regression test.
Add a comment: `# seed pins the tie-breaking order; see DIAGNOSE post-mortem`.

**Phase 6 — cleanup.**
Nothing to revert. Commit: *"test(textmining): seed RNG to stabilise
top-term tie-break — H1 confirmed"*. File an architectural follow-up:
"production `score_terms()` should break ties on a stable key
(`term_id`) rather than relying on input order" → goes to
`../bdd/refactoring-r.md` candidate list.
