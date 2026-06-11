# Instrumentation in Python

Phase 4 of `diagnose`. The rule: **prefer interactive inspection over
logging, change one variable at a time, tag every line you add so cleanup
is `grep`-able**.

## Interactive inspection (prefer these)

### `breakpoint()`
Drop a breakpoint at the suspected frame and poke around (honours
`PYTHONBREAKPOINT`; defaults to pdb).
```python
def assemble_expr(raw: pd.DataFrame) -> pd.DataFrame:
    breakpoint()                  ### DIAGNOSE-2026-06-11
    df = raw.pipe(reshape).pipe(rename)
    return df
```
At the prompt: `pp df.head()`, `df.dtypes`, `raw.shape`, `n` step, `c`
continue, `q` abort, `w` show the stack.

### pytest `--pdb` / `--trace`
Drop into the debugger without editing code.
```bash
pytest tests/test_assemble.py::test_idempotent --pdb   # break at the failure
pytest tests/test_assemble.py::test_idempotent --trace  # break at test start
```
`--pdb` opens the frame *at the moment of the exception* — best
post-mortem when you don't yet know which line throws. No cleanup needed.

### Post-mortem on a script
```python
import pdb, traceback, sys
try:
    main()
except Exception:                 ### DIAGNOSE-2026-06-11
    traceback.print_exc(); pdb.post_mortem(sys.exc_info()[2])
```
Reset by deleting the tagged block in cleanup.

## Logging (only when interactive isn't possible)

When the bug only repros non-interactively (CI, a `multiprocessing`
worker, a long batch run), print *with the diagnose tag*:
```python
print(f"### DIAGNOSE-2026-06-11 assemble_expr: shape={df.shape} "
      f"sha={pd.util.hash_pandas_object(df).sum()}", file=sys.stderr)
```
No tag, no cleanup. `pytest -s` lets prints through; `caplog` captures
`logging` records if the code already logs.

## Performance bugs

### `cProfile` → find the dominant call
```bash
python -m cProfile -s cumtime -m mypkg.pipeline | head -20
```
One function dominating cumulative time → target it. Thousands of tiny
calls → a Python-level loop that should be vectorised (pandas/numpy/polars).

### `timeit` / `pytest-benchmark` for A/B
Once you have a hypothesis about the slow path:
```python
def test_assemble_faster(benchmark):
    benchmark(new_assemble, raw)   # pytest-benchmark plugin
```
Line-level attribution: `line_profiler`'s `@profile` on the suspect
function.

## The `### DIAGNOSE-<date>` tag convention

- **Every** line you add for diagnosis carries `### DIAGNOSE-YYYY-MM-DD`.
- One date format, one tag, one regex finds them all.
- Phase 6 ends only when `grep -rn "### DIAGNOSE-" .` returns zero hits.

## Anti-patterns

- **`print()` without a tag** — survives into commits. (ruff's `T201` flags
  bare prints; lean on it.)
- **Multiple hypotheses instrumented at once** — loses the signal.
- **Editing the function under test to "make it work"** while still
  collecting evidence — that's a fix smuggled into instrumentation.
- **Leaving `breakpoint()` in** — hangs CI waiting on stdin. ruff `T100`
  catches it; let the linter gate the commit.
