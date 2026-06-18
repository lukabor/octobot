# Interface design for testability (Python)

Vocabulary lives in [`../codebase-design/SKILL.md`](../codebase-design/SKILL.md) —
module, interface, seam, adapter, depth. This file is the Python-flavored leaf.

Rules to apply before writing the test, not after. A deep module is the goal;
a testable interface is the side effect.

## 1. Dependency injection — pass collaborators, don't construct them

Functions that build their own dependencies force the test to patch the
constructor. Inject instead — constructor injection, no IoC framework.

```python
# BAD — constructs its client internally; test must patch
def annotate(gene_ids: list[str]) -> list[Annotation]:
    entrez = EntrezClient(httpx.Client())  # hidden dependency
    ...
```

```python
# GOOD — collaborator is a parameter, typed as a Protocol
class GeneLookup(Protocol):
    def fetch_summary(self, gene_id: str) -> dict[str, object]: ...

def annotate(gene_ids: list[str], lookup: GeneLookup) -> list[Annotation]:
    ...
```

The `Protocol` lives next to the *consumer* (structural typing — the
implementer never imports it). Tests pass a fake or `Mock(spec_set=...)`;
production passes the real client. A default argument is a fine seam:
`def annotate(ids, lookup: GeneLookup = EntrezClient()) -> ...`.

## 2. Pure functions — return, don't mutate

A function that returns its result needs one `assert`. One that writes to
disk, mutates a global, or edits its argument in place needs setup,
teardown, and a side-channel check.

```python
# BAD — mutates the argument in place (pandas defaults to views/copies
# unpredictably; callers get surprised)
def downscale(df: pd.DataFrame) -> None:
    df["total"] *= 0.9
```

```python
# GOOD — returns a new frame, original untouched
def downscale(df: pd.DataFrame) -> pd.DataFrame:
    return df.assign(total=df["total"] * 0.9)
```

Let the caller decide where the result goes. Same rule for the filesystem:
return the bytes/rows, let a thin outer layer write them.

## 3. Minimal interface complexity

Each parameter multiplies test cases; each public method is surface a test
must cover. Shrink it:

- **Wide arguments, narrow returns** (typing.python.org): accept
  `Iterable[str]` / `Mapping`, return concrete `list` / `dict`. Don't
  return `MutableMapping` where `dict` is meant.
- **No stringly-typed params** — `mode: Literal["r", "w", "a"]` or an
  `Enum`, not `mode: str`. The checker rejects bad values before any test
  runs.
- **No boolean traps** — `f(True, False)` at the call site is unreadable;
  prefer keyword-only flags or `@overload` with `Literal` when the return
  type depends on the flag.
- **No `Any`-leak** — a function returning `Any` disables checking for
  every caller. Return a `TypedDict`, dataclass, or `dict[str, object]`.
- Fold orthogonal args into one structured input (a small frozen
  dataclass) rather than six positional parameters.

## 4. Don't pair parameters that can silently disagree

Two parameters that encode the same fact let a caller make them contradict
with no error ever. A function taking both a `conn` and the `db_path` it
"belongs to" can be handed a connection to database A and a path beside
database B — and nothing catches it.

```python
# BAD — two sources of truth for one fact; they can disagree silently
def reindex(conn: Connection, db_path: Path) -> None: ...
```

Split the entry points so each caller supplies exactly **one** source of
truth — derive the other, or take only the one the body actually uses. The
test that would have caught the mismatch is one you never have to write,
because the mismatch is now unrepresentable.

## Choosing the type of "thing"

| Need | Use |
|---|---|
| Plain record | `@dataclass` (`frozen=True`, `slots=True`) |
| Record + validation/conversion at construction | `attrs` |
| Behavior-rich, real work in `__init__`, invariants | plain class (deep module) |
| A contract for a parameter | `Protocol` (next to the consumer) |
| Shared skeleton implementation you own | `ABC`, sparingly |

Subclassing is for **specialization** (must satisfy Liskov), not code
sharing — prefer composition. "Duplication is far cheaper than the wrong
abstraction" (Hynek): start with dedicated classes, extract a hierarchy
only once the shared shape is proven.

The single test: *can a new caller use this correctly without reading the
body?* If no, the interface is too complex, however clever the
implementation.
