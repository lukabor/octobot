# Mocking in Python

**Mock at system boundaries. Never mock your own internals. Don't patch
what you don't own — wrap it.**

## Boundaries you may mock

- HTTP / REST APIs — but through a façade you own (below), or replay
  fixtures with `respx` / `responses`.
- Databases — prefer a real in-memory DB (`sqlite3 :memory:`) or a fake
  repository over patching cursors.
- Time — inject `now: Callable[[], datetime]`, or `monkeypatch` a clock
  boundary; never patch `datetime.datetime` globally.
- Randomness — pass an `rng: np.random.Generator` parameter; seed it in
  the test.
- File system — `tmp_path`. Real temp files are cheaper than mocks.
- Environment — `monkeypatch.setenv` / `delenv`.

## Things you must NOT mock

- Your own modules' functions and classes (internal collaborators).
- Third-party *internals* — `httpx.Client.get`, `pandas.read_sql`, DB
  cursors. You don't own these APIs (Hynek: "don't mock what you don't
  own"); mocks of them drift silently when the library changes.
- Builtins (`open`, `compile`) — pytest docs: patching them "might break
  pytest's internals". Use `tmp_path` and real files instead.

If a test needs to stub an internal helper, the function under test is
doing two things. Split it.

## Don't mock what you don't own — own a façade

```python
# GOOD — thin wrapper you own; tests mock THIS, never httpx
class EntrezClient:
    def __init__(self, http: httpx.Client) -> None:
        self._http = http

    def fetch_summary(self, gene_id: str) -> dict[str, object]:
        resp = self._http.get(f"{BASE}/esummary.fcgi", params={"id": gene_id})
        resp.raise_for_status()
        return resp.json()["result"]
```

```python
# in tests — spec'd mock of the façade, or a fake
client = Mock(spec_set=EntrezClient)
client.fetch_summary.return_value = {"name": "TP53"}
assert annotate(["7157"], entrez=client)[0].name == "TP53"
```

```python
# BAD — Mock Hell: patching a third-party internal
with patch("httpx.Client.get") as m:
    m.return_value.json.return_value = {"result": {"name": "TP53"}}
    ...
```

## Dependency injection over patching

```python
# Easy to test — boundary passed in
def annotate(gene_ids: list[str], entrez: EntrezClient) -> list[Annotation]: ...

# Hard to test — constructs its client internally; forces patching
def annotate(gene_ids: list[str]) -> list[Annotation]:
    entrez = EntrezClient(httpx.Client())  # buried dependency
```

Prefer a **fake** (working implementation with a shortcut — Fowler's
taxonomy) over a behavior-verifying mock: an in-memory `FakeRegistry`
asserted by *state* survives refactors that call-count assertions break.

## Tool rules

- **`monkeypatch` (pytest)** — env vars, attributes, dict items,
  `sys.path`. Auto-undone after each test, so no leakage. Suite-wide
  network kill-switch (no accidental NCBI calls):
  ```python
  @pytest.fixture(autouse=True)
  def no_network(monkeypatch):
      monkeypatch.delattr("httpx.Client.send")
  ```
- **`unittest.mock.patch`** — patch where the object is *looked up*, not
  where it's defined: `b.py` does `from a import X` → patch `"b.X"`,
  not `"a.X"`.
- **Always `autospec=True` / `spec_set=`.** A bare `Mock()` accepts any
  signature and any attribute — tests keep passing after the real API
  changes, and `mock.assret_called_with(...)` typos pass silently.

## Anti-patterns

- **Call-count theater** — `assert m.call_count == 3` on an internal step
  while the output goes unchecked. Verifies HOW, breaks on refactor
  (Fowler: behavior-verification coupling).
- **Specless mocks** — drift from the real API; see tool rules.
- **Patching the definition site** — silently patches nothing.
- **Hand-rolled `module.attr = fake`** without teardown — leaks into
  later tests; use `monkeypatch`, which undoes itself.
- **Mocking `pandas.read_sql` / cursors** — wrap data access in an owned
  repository class; fake or spec-mock the wrapper.

## The single-sentence test

*If I refactor the body of the function under test without changing its
public contract, do the mocks in this test still make sense?* If they
target internals — or a library's guts — the answer is no.
