# Feedback loops in Python

A bug you can reproduce in 2 seconds with one keystroke is half-fixed. The
loop **is** the product of phase 1. Spend time on it.

## Loop recipes, fastest first

### A single pytest test
The gold standard. Run one test, quiet, stop on first failure.
```bash
just test ARGS="tests/test_assemble.py::test_idempotent -x -q"
# or directly in the dev container:
pytest tests/test_assemble.py::test_idempotent -x -q
```
`-k` selects by name substring; `--lf` reruns last-failed; `-p no:cov`
drops coverage overhead while hunting.

### A single function, no test yet
`python -c` or a 5-line script that prints `PASS` / `FAIL` and exits
non-zero. That is a valid loop.
```bash
python -c "from mypkg.norm import normalize_chrom; assert normalize_chrom('chr1')=='1'; print('PASS')"
```

### A notebook bug
Don't re-run 40 cells. Extract the failing logic into a `.py` module and
drive it from one pytest test — also where the fix will live.

## Make the loop deterministic

- **Seed every RNG**: `np.random.default_rng(42)`, `random.seed(42)`.
  Never rely on global `np.random` state.
- **Pin env**: `monkeypatch.setenv("TZ", "UTC")`, `("PYTHONHASHSEED", "0")`.
- **Freeze versions**: you already build in Docker off `uv.lock` — rules
  out "broke because pandas 2.2 changed a default".
- **Isolate the filesystem**: `tmp_path`, never the repo tree.
- **Kill ambient network** so a hung NCBI call can't masquerade as a bug
  (see [../bdd/mocking-py.md](../bdd/mocking-py.md) autouse fixture).

If the same loop gives two different answers in a row, **fix the loop
before phase 2**.

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
the diagnostic patch into the real fix at the contract boundary (return a
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
