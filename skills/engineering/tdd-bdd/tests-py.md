# Python tests for tdd-bdd

Paired good/bad examples for Python (pytest only). One principle per
section: bad first, good second, then a one-paragraph reason. Use these as
the concrete reference when applying the core tdd-bdd loop in a Python
repo.

**Framework rule — pytest, nothing else.** Fixtures via `@pytest.fixture`
(never `unittest.TestCase` / `setUp`), parametrization via
`@pytest.mark.parametrize`, BDD behavior expressed inside pytest: the
Given/When/Then scenario lives as the test's docstring, the Given lives in
fixtures. Gherkin frameworks (pytest-bdd, behave) only when non-developers
co-author scenarios — Cucumber's own guidance: Gherkin is a collaboration
tool first, a testing tool second. If that day comes, pytest-bdd (runs
inside pytest, fixtures become Given steps), never behave.

---

## Test-file conventions

- Files: `tests/test_<module>.py`; functions: `test_<behavior>` — the name
  reads like a spec line, not mechanics.
- Layout: tests outside `src/` (the `/build-py-project` scaffold already
  does this); pytest docs strongly suggest src layout + `importlib` mode.
- Every test carries its scenario as the docstring:

```python
def test_low_coverage_variants_are_dropped(variant_frame: pd.DataFrame):
    """
    Given a variant table with one row below 10x coverage
    When the table is filtered with default thresholds
    Then the low-coverage row is absent and all others survive
    """
```

---

## Characteristics — what makes a test good or bad

### Good tests
- Verify **behavior callers care about** — inputs in, observable
  outputs/state/errors out.
- Exercise the **public interface only** (what `src/<package>` exports).
- **Survive internal refactors** — rename a helper, split a function, the
  test stays green.
- **Test WHAT, not HOW** — "drops rows below threshold", not "calls
  `_filter_rows` once".
- **One behavior per test.** Several `assert`s are fine when they pin one
  outcome (a frame's shape *and* its columns); two unrelated outcomes are
  two tests (Meszaros: Eager Test → split into Single Condition Tests).
- **The Given is visible in the test** — fixture or inline literal, never
  an opaque external file (Mystery Guest).

### Bad tests (anti-patterns)
- **Mock internal collaborators** to "isolate" a unit — passes while the
  real wiring is broken. See [mocking-py.md](mocking-py.md).
- **Reach past the public interface** — touch `_private` helpers, inspect
  internal state.
- **Assert call counts / call order** of internals — red on refactor, no
  behavior change.
- **Mystery Guest** — load `tests/data/big_real_export.csv` and assert
  numbers nobody can trace to the input.
- **General Fixture** — one giant conftest fixture serving every test;
  nobody can tell which parts each test needs. Keep fixtures minimal and
  intent-named; session scope only for expensive resources (DB container),
  with per-test unique data.
- **Assertion Roulette** — a wall of asserts covering several behaviors;
  the first failure masks the rest.

The single-sentence test: *if a colleague refactors the function's
internals without changing its contract, this test should stay green.*

---

## 1. Make the "Given" explicit — fixture, not environment

### Bad — mystery guest from a real data file
```python
def test_load_sample_sheet():
    df = load_sample_sheet("tests/data/run_2024_export.csv")  # 4k rows, opaque
    assert len(df) == 3981                                    # why 3981?
```

### Good — `tmp_path` + inline content; fixture names the precondition
```python
@pytest.fixture
def sheet_with_duplicate_sample(tmp_path: Path) -> Path:
    path = tmp_path / "samples.csv"
    path.write_text("sample_id,condition\nS1,ctrl\nS1,treated\n")
    return path

def test_duplicate_sample_ids_raise(sheet_with_duplicate_sample: Path):
    """
    Given a sample sheet where one sample_id appears twice
    When the sheet is loaded
    Then a DuplicateSampleError names the offending id
    """
    with pytest.raises(DuplicateSampleError, match="S1"):
        load_sample_sheet(sheet_with_duplicate_sample)
```

The bad version depends on a file nobody can read at a glance and pins a
count with no visible cause. The good version builds the Given in two
lines (Meszaros: Fresh Fixture, inline setup), the fixture name states the
precondition, and the assertion pins the contract.

---

## 2. Parametrize, don't loop or copy-paste

### Bad — loop hides which case failed; one failure stops the rest
```python
def test_normalize_chromosome_names():
    for raw, expected in [("chr1", "1"), ("chrX", "X"), ("MT", "MT")]:
        assert normalize_chrom(raw) == expected
```

### Good — one test run per case, each named
```python
@pytest.mark.parametrize(
    ("raw", "expected"),
    [("chr1", "1"), ("chrX", "X"), ("MT", "MT")],
    ids=["ucsc-autosome", "ucsc-sex", "already-ensembl"],
)
def test_normalize_chromosome_names(raw: str, expected: str):
    """Given a chromosome name in any supported convention,
    when normalized, then the Ensembl form is returned."""
    assert normalize_chrom(raw) == expected
```

pytest runs and reports each case independently; `ids` make the failing
case self-describing. Three parametrization levels exist
(`fixture(params=...)`, `parametrize`, `pytest_generate_tests`) — the
decorator covers nearly all needs.

---

## 3. The "Then" must be specific — typed error, pinned message

### Bad — any exception passes
```python
def test_missing_config_fails():
    with pytest.raises(Exception):
        load_config("nope.toml")
```

### Good — exact type + message fragment
```python
def test_missing_config_names_the_path():
    """Given no config file at the path, when loading,
    then ConfigMissingError carries that path."""
    with pytest.raises(ConfigMissingError, match=r"nope\.toml"):
        load_config("nope.toml")
```

`pytest.raises(Exception)` is satisfied by a typo-level `NameError` inside
the function — a regression that replaces validation with a crash stays
green. Requires production code to raise a dedicated exception type.

---

## 4. DataFrames: assert with the testing API, not eyeballs

### Bad — row-by-row asserts / string comparison
```python
def test_tpm_normalization(counts):
    out = to_tpm(counts)
    assert str(out.head()) == EXPECTED_HEAD          # whitespace-fragile
    for i in range(len(out)):
        assert abs(out.iloc[i].sum() - 1e6) < 1.0    # roulette
```

### Good — `assert_frame_equal` against a small literal expectation
```python
def test_tpm_columns_sum_to_one_million(small_counts: pd.DataFrame):
    """Given a 3-gene count matrix, when converted to TPM,
    then every sample column sums to 1e6."""
    out = to_tpm(small_counts)
    pd.testing.assert_series_equal(
        out.sum(), pd.Series(1e6, index=out.columns), check_names=False
    )
```

`pandas.testing.assert_frame_equal` / `polars.testing.assert_frame_equal`
diff dtypes, index, and values with readable failure output and tolerance
control (`rtol`/`atol`, `check_like`). Keep the input small enough that
the expected output is derivable by eye.

---

## 5. Canonical Given/When/Then in pytest

```python
@pytest.fixture
def empty_registry(tmp_path: Path) -> ResultRegistry:
    return ResultRegistry(root=tmp_path)

def test_first_write_creates_the_run_record(empty_registry: ResultRegistry):
    """
    Given an empty result registry
    When a run result is recorded
    Then the run is retrievable with its status set to "done"
    """
    # given
    assert empty_registry.runs() == []

    # when
    empty_registry.record(run_id="r1", status="done")

    # then
    assert empty_registry.get("r1").status == "done"
```

Three labelled stanzas, one observable outcome, the Given isolated in a
named fixture built on `tmp_path` — pytest's own auto-cleaned temp dir, no
manual teardown.
