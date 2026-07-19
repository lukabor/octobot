# R tests for bdd

Paired good/bad examples for R (testthat ed. 3+, `box::use`,
`describe`/`it`). One principle per section: bad first, good second, then a
one-paragraph reason. Use these as the concrete reference when applying the
core bdd loop in an R repo.

---

## Test-file prologue (`box::use` for testthat)

Every test file under `tests/testthat/**/test_*.R` opens with the same
three blocks:

```r
# R

project_root <- normalizePath(file.path(
  testthat::test_path(), "..", "..", ".."
))
options(box.path = project_root)

box::use(
  testthat[
    describe, it,
    expect_true, expect_false, expect_equal, expect_error,
    expect_type, expect_identical, expect_null, expect_silent
  ]
)

box::use(
  R/indication/get_modb_bulk_config[get_dataset_config],
  R/indication/query_modb[get_modb_client]
)
```

Why each block:
- **`testthat::test_path()` walk-up + `options(box.path = ...)`** anchors
  `box::use(R/...)` resolution to the repo root regardless of where
  `testthat::test_dir()` set the working directory.
- **`box::use(testthat[...])`** — bare-name imports of every `describe`,
  `it`, and `expect_*` the file calls. No `library(testthat)`.
- **Separate `box::use(R/.../module[...])` block** for the system under
  test, alphabetised, named imports only.

Snippets below show only the `describe(...) { it(...) ... }` body — the
prologue is implied. When writing a new test file, copy this prologue
verbatim.

---

## Characteristics — what makes a test good or bad

Use this rubric before writing any `it(...)` block. The paired examples
below are concrete instances of these rules in R.

### Good tests
- Verify **behavior users or callers care about** — inputs in, observable
  outputs/state/errors out.
- Exercise the **public interface only** (`box::use`'d exports, the
  `targets` pipeline output, the exported S3/S4 method).
- **Survive internal refactors.** Rename a helper, split a function,
  swap an internal data structure — the test stays green.
- **Test WHAT, not HOW.** "Returns NULL when no terms pass the threshold",
  not "calls `filter_terms()` once with `z >= threshold`".
- **One logical assertion per `it`.** Multiple `expect_*()` calls are fine
  if they describe one outcome (e.g. a returned data.frame's class *and*
  its columns); two unrelated outcomes belong in two `it` blocks.
- **The test name reads like a blueprint line.** A reader who sees only the
  `describe` + `it` titles understands the contract.

### Bad tests (anti-patterns)
- **Mock internal collaborators** (`mockery::stub()` on a function inside
  the same module, just to "isolate" it). The test now passes when the
  real wiring is broken.
- **Reach past the public interface** to verify — e.g. call a non-exported
  `pkg:::private_helper()`, inspect an environment slot, regex over
  `capture.output()` of an internal `print` method.
- **Assert on call counts or call order** of internal helpers. Refactor
  the helper away and the test fails for no behavior change.
- **Fail during refactor despite unchanged behavior.** The clearest
  diagnostic: if `git diff` shows only renames or extractions and the
  suite goes red, those tests were testing implementation.
- **Test names describe mechanics**, not intent: "iterates twice over the
  list", "calls `purrr::map` with the right lambda".
- **Verify through a side channel** instead of the function's return
  value — e.g. read a temp file the function wrote, then parse it,
  instead of asserting on the function's exposed result.

The single-sentence test: *if a colleague refactors the function's internals
without changing its contract, this test should stay green.* If you can't
honestly say yes, the test is coupled to implementation.

---

## 1. Make the "Given" explicit — fixture, not environment

### Bad — depends on a real project directory
```r
it("loads dataset configs from JSON files", {
  config_dir <- file.path(project_root, "data_config", "inf_pf")  # real path!
  configs <- get_dataset_config(config_dir)
  expect_true(is.list(configs))
  expect_true(all(sapply(configs, inherits, "list")))             # near-tautology
})
```

### Good — `local_tempdir()` owns the fixture; assertion pins the shape
```r
it("loads one entry per JSON file, keyed by data_set_id", {
  dir <- local_tempdir()
  write_json(list(data_set_id = "DS001",
                  modb_data_iri = "https://modb.example.com/DS001"),
             file.path(dir, "DS001.json"), auto_unbox = TRUE)

  configs <- get_dataset_config(dir)

  expect_named(configs, "DS001")
  expect_equal(configs$DS001$modb_data_iri, "https://modb.example.com/DS001")
})
```

Moving the repo or reorganizing config breaks the bad version for reasons
unrelated to the function. The shape assertion (`is.list && all(is.list)`)
would accept a malformed config that *happens* to be a nested list. The good
version makes "Given" inspectable in three lines and pins the contract
callers depend on.

---

## 2. The "Then" must be observable behavior, not "didn't blow up"

### Bad — untyped `expect_error`
```r
it("fails with non-existent directory", {
  expect_error(get_dataset_config("non_existent_dir"))   # any error passes
})
```

### Good — typed condition class
```r
it("raises `config_missing` when the directory does not exist", {
  expect_error(get_dataset_config(tempfile()), class = "config_missing")
})
```

Requires the production function to signal a structured error
(`rlang::abort(..., class = "config_missing")`). Now a regression that swaps
validation for a stray NULL-dereference fails loudly, instead of silently
satisfying "something threw".

---

## 3. Test the data, not the render

### Bad — regex over `capture.output()` HTML
```r
it("uses id_col for both anchor and label", {
  cfg  <- make_cfg()
  html <- paste(capture.output(generate_tab_buttons(cfg, "transcript_id")),
                collapse = "\n")
  for (id in cfg$transcript_id) {
    expect_match(html, sprintf("onclick=\"unrolltab\\(event, '%s'\\)\">%s<", id, id))
  }
  expect_no_match(html, "MDK-00")
})
```

### Good — assert the structured config the renderer consumes
```r
it("uses id_col for both anchor and label when label_col is omitted", {
  cfg  <- data.frame(transcript_id = c("ENST1","ENST2","ENST3"))
  tabs <- build_tab_config(cfg, id_col = "transcript_id")

  expect_equal(vapply(tabs, `[[`, "", "anchor"),
               vapply(tabs, `[[`, "", "label"))
})
```

The bad version couples to attribute order, whitespace, and quote style —
harmless refactors turn it red — and bundles many assertions in one `it`, so
the first failure masks the rest. Test the data layer; cover rendering once
with a single `expect_snapshot(generate_tab_buttons(cfg))` in a separate
file.

---

## 4. Put the precondition in the fixture, not in a magic constant

### Bad — `z_threshold = 99` to force "no terms pass"
```r
it("returns NULL when no terms pass the Z threshold", {
  expect_null(build_plot(mock_zmat(), mock_anno(), "GENE_A", z_threshold = 99))
})
```

### Good — fixture encodes the precondition
```r
make_zmat_no_signal <- function()
  matrix(0, nrow = 3, ncol = 2,
         dimnames = list(c("TERM1","TERM2","TERM3"), c("GENE_A","GENE_B")))

it("returns NULL when no term reaches the default Z threshold", {
  expect_null(build_plot(make_zmat_no_signal(), make_anno(), "GENE_A"))
})
```

In the bad version the "Given" hides inside the number 99: a reader can't
tell whether 99 is "way above any score" or a meaningful business
threshold. Tightening the mock so a term scores 99 would silently break the
premise and the test would stay green for the wrong reason. The good
version names the precondition (`no_signal`) and uses the function's default.

---

## 5. Canonical Given/When/Then in `it`

For reference — what a well-shaped `it` looks like end-to-end.

```r
it("creates the log file when none exists", {
  env <- setup_test_env(); on.exit(cleanup_test_env(env))

  # given: no log file on disk
  expect_false(file.exists(env$logfile))

  # when: we initialize the logger and write a message
  setup_log(log_file = env$logfile); log_msg(msg = "init")

  # then: the log file is created
  expect_true(file.exists(env$logfile))
})
```

Three labelled stanzas, one observable outcome, isolated fixture via
`setup_test_env()` + `on.exit(cleanup_test_env(env))`.
