---
status: open
blocked-by: [D-1]
---

# D-2 — mocking doctrine: facade + DI only, or bless monkeypatch?

## Why it must be decided
mocking-py.md is the normative file bdd points at before any `patch`
call; its stance decides what reviews flag.

## Options
- **A — facade + DI only**: monkeypatch/patch treated like mockery::stub
  in R — a smell needing justification. Consistent with codebase-design.
- **B — bless monkeypatch at seams**: pragmatic pytest idiom, weaker
  seam discipline.

## Recommendation
A — matches the R doctrine and the existing bdd "seams only" rule.

## Resolution
