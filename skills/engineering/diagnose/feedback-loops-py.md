# Feedback loops in Python — worked examples

Two worked instantiations of [loop-recipes.md](loop-recipes.md). Python
idioms: `pytest path::test -x -q` for a single test; `-k` for substring,
`--lf` for last-failed, `-p no:cov` to drop coverage overhead.
Determinism: `np.random.default_rng(42)` (never global `np.random`),
`monkeypatch.setenv("PYTHONHASHSEED", "0")`, `tmp_path` for filesystem
isolation; autouse network-kill fixture in
[../bdd/mocking-py.md](../bdd/mocking-py.md).

---

## Worked example 1 — in-place mutation, intermittently wrong output

**Symptom (user):** `assemble_expr()` sometimes returns a frame with the
wrong totals; running the same step twice gives different results.

**Phase 1 — build the loop.** Compress to an idempotence test:
```python
def test_assemble_expr_is_idempotent():
    """Given one raw frame, when assembled twice, then both results match."""
    raw = make_raw_fixture()
    pd.testing.assert_frame_equal(assemble_expr(raw), assemble_expr(raw))
```
`pytest tests/test_assemble.py -x -q` fails on the second call. Loop is
deterministic and 0.3 s.

**Phase 3 — hypotheses.** H1: `assemble_expr` mutates `raw` in place
(pandas view aliasing). Prediction: a defensive `raw = raw.copy()` makes
call two match call one.

**Phase 4 — instrument.** One tagged line:
```python
def assemble_expr(raw: pd.DataFrame) -> pd.DataFrame:
    raw = raw.copy()  ### DIAGNOSE-2026-06-11
    ...
```
Test passes. H1 confirmed.

**Phase 5 — regression test** = the idempotence test. Move the copy from
the diagnostic patch into the real fix at the contract seam (return a
fresh frame, don't mutate the argument — see
[../bdd/interface-design-py.md](../bdd/interface-design-py.md)).

**Phase 6 — cleanup.** `grep -rn "### DIAGNOSE-" .` → zero hits. Commit:
*"fix(assemble_expr): return a fresh frame — H1: pandas view aliasing
caused non-idempotent totals"*.

---

## Worked example 2 — flaky test that depends on RNG

**Symptom (user):** `test_top_terms_stable` passes locally, fails ~1/10 on CI.

**Phase 1 — build the loop.** Run it many times via the plugin
`pytest-repeat`, or a shell loop:
```bash
for i in $(seq 50); do
  pytest tests/test_textmining.py::test_top_terms_stable -q \
    || { echo "FAIL on iter $i"; break; }
done
```
Fails on iteration 7. Reproduces in < 30 s.

**Phase 3 — hypotheses.** H1: the fixture samples with an unseeded
generator; ties in the z-score ranking sort differently per run. H2:
dict/set iteration order via unset `PYTHONHASHSEED`. H1 more likely (the
mock matrix is tiny → ties common).

**Phase 4 — instrument.** Pass a seeded generator into the fixture; rerun
the 50× loop. All green. H1 confirmed; H2 not pursued (one variable at a
time).

**Phase 5 — regression test:** the seeded test *is* the regression test.

**Phase 6 — cleanup.** Nothing to revert. Commit: *"test(textmining): seed
RNG to stabilise tie-break — H1 confirmed"*. File a follow-up: production
`score_terms()` should break ties on a stable key (`term_id`), not input
order → [../bdd/refactoring-r.md](../bdd/refactoring-r.md) candidate.
