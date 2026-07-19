---
type: Decision
status: open
blocked-by: [D-1]
---

# D-3 — feedback-loops-py vs instrumentation-py: where does the split fall?

## Why it must be decided
diagnose links both; overlapping content (pdb in both?) would violate
one-fact-one-home.

## Options
- **A — R-parallel split**: loops = constructing red-capable commands;
  instrumentation = interactive inspection (breakpoint, --pdb, cProfile).
- **B — merge into one file**: fewer files, but breaks the R symmetry
  and the diagnose phase-1/phase-4 pointer split.

## Recommendation
A — the two diagnose phases consume them separately.

## Resolution
