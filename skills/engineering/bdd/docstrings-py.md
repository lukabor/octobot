# Google-style docstrings (Python)

Project standard: **Google-style docstrings** (pyguide §3.8), with **types
carried by annotations, never repeated in the docstring**. `ty` checks the
annotations; the docstring carries semantics only.

## When a docstring is required

A docstring is mandatory for any function that is **public API**,
**nontrivial in size**, or has **non-obvious logic** (pyguide §3.8.3). The
bar: "enough information to write a call to the function without reading
the function's code." Describe semantics, not implementation.

Skip it for a one-line obvious helper. A docstring that only restates the
name ("Returns the value") is noise — omit it.

## Format

```python
def fetch_variants(
    sample_id: str,
    region: GenomicRange,
    min_depth: int = 10,
) -> pl.DataFrame:
    """Fetches called variants for a sample within a region.

    Variants below the depth threshold are dropped before return. The
    region is half-open, following the BED convention.

    Args:
        sample_id: Identifier of the sequenced sample.
        region: Half-open interval to query.
        min_depth: Minimum read depth a variant must meet to be kept.

    Returns:
        One row per surviving variant, sorted by position. Empty if the
        region contains no calls meeting the threshold.

    Raises:
        SampleNotFoundError: If sample_id is not in the cohort.
    """
```

- **Summary line**: ≤80 chars, ends in a period, fits one physical line.
  If more follows, a blank line then the body at the same indent.
- Descriptive ("Fetches…") or imperative ("Fetch…") both allowed —
  pyguide only demands consistency within a file. Pick one for the repo.
- **`Args:`** — `name: description`. **No type** — the annotation has it.
  Hanging-indent continuation lines by 2–4 spaces.
- **`Returns:`** — semantics the annotation can't convey. Omit entirely if
  the function returns `None`. Generators use `Yields:`.
- **`Raises:`** — only exceptions relevant to the interface, not every
  internal one.
- Never document `self` / `cls`.

## Classes, modules, properties

- **Class** docstring sits below `class …:`, opens with one line saying
  what an *instance represents*. Public attributes go in an `Attributes:`
  section (same format as `Args:`), excluding properties.
- **Exception class**: describe what it represents, not when raised —
  `"""No more cheese is available."""`, not `"""Raised when…"""`.
- **`__init__`**: document in the class docstring *or* on `__init__`,
  never both.
- **Module**: top-of-file docstring, one-line summary + overview, optional
  "Typical usage example:".
- **Property**: document on the getter, attribute-style —
  `"""The reference genome build."""`, not `"""Returns the build."""`.

## Anti-patterns

```python
# BAD
def fetch_variants(sample_id, region, min_depth=10):
    """fetch_variants(sample_id, region, min_depth)
    This function is a function that fetches variants.

    Args:
        self: The instance.
        sample_id (str): the sample id.
        region (GenomicRange): the region.
        min_depth: the min depth.
    Returns:
        Returns the value.
    """
```

Faults: repeats the signature; "is a function that" noise; documents
`self`; restates types the annotations already carry; descriptions merely
echo the parameter name (fails the "write a call without reading the body"
bar); "Returns the value" says nothing about semantics; no blank line
after the summary; summary spans more than one line; omits the relevant
`Raises:`.
