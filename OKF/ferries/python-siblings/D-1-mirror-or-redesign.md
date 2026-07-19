---
status: open
blocked-by: []
---

# D-1 — mirror the R sibling structure, or redesign for Python?

## Why it must be decided
Every sibling file's outline depends on it; deciding late means
rewriting all six files.

## Options
- **A — mirror**: same file names and section shapes as the R set;
  cheapest, symmetrical cross-links from bdd/diagnose already half-exist.
- **B — redesign**: Python-first outline (typing, fixtures-as-DI,
  pytest idioms) where the R shape doesn't fit; better fit, more work,
  asymmetric maintenance.

## Recommendation
A, with per-file deviations allowed when a section would be a no-op in
Python — mirror is reversible per file, redesign is not.

## Resolution
