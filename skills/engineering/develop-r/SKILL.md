---
name: develop-r
description: Orchestrate the full R dev loop; auto-detects package (DESCRIPTION) vs analysis (_targets.R).
disable-model-invocation: true
---

# develop-r

Workflow for R repos. Detects project type from filesystem markers:

| Marker | Type | Loop file |
|---|---|---|
| `DESCRIPTION` only | R package | [`package-loop.md`](package-loop.md) |
| `_targets.R` only | R analysis | [`analysis-loop.md`](analysis-loop.md) |
| both | ambiguous | ask the user |
| neither | refuse | suggest `/build-r-package` or `/build-r-analysis` |

Apply `/style-r` at every implementation step.

## When NOT to use
- Single-task work: bug fix → `/diagnose` + `/bdd` directly.
- Writing tests → `/bdd` only.
- Reviewing R style of one file → `/style-r` only.
- Committing → `/commit-atomic-jj` only.

## Phase 0 — Frame (both loops)

Karpathy guardrails — state assumptions explicitly, name the simpler
approach you're rejecting, surface tradeoffs. Push back when warranted; if
something is unclear, stop and ask. See
[`../../../CLAUDE.md`](../../../CLAUDE.md) for the full version.

If the task is ambiguous, hand off to
`/grill-me` (no codebase needed)
or `/grill-with-docs` (anchors to
`CONTEXT.md`) before entering the loop.

## Then enter the appropriate loop

- `DESCRIPTION` detected → [`package-loop.md`](package-loop.md)
  (document → lint → style → test → check → commit)
- `_targets.R` detected → [`analysis-loop.md`](analysis-loop.md)
  (lint → style → test → run pipeline → render → commit)

## See also
- `/bdd` and its R siblings
  (`tests-r.md`, `interface-design-r.md`, `mocking-r.md`,
  `deep-modules-r.md`, `refactoring-r.md`, `anti-patterns.md`).
- `/diagnose` — six-phase bug hunt
  with R-flavored siblings.
- `/style-r` — coding standards.
- `/commit-atomic-jj`.
- `/build-r-package`
  and
  `/build-r-analysis`
  — set up the projects this workflow assumes.
