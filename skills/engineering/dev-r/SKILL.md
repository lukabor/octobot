---
name: dev-r
description: Orchestrate the full R dev loop; auto-detects package (DESCRIPTION) vs analysis (_targets.R).
disable-model-invocation: true
---

# dev-r

Workflow for R repos. Detects project type from filesystem markers:

| Marker | Type | Loop file |
|---|---|---|
| `DESCRIPTION` only | R package | [`package-loop.md`](package-loop.md) |
| `_targets.R` only | R analysis | [`analysis-loop.md`](analysis-loop.md) |
| both | ambiguous | ask the user |
| neither | refuse | suggest [`/build-r-package`](../../scaffold/build-r-package/SKILL.md) or [`/build-r-analysis`](../../scaffold/build-r-analysis/SKILL.md) |

Apply [`/r-style`](../r-style/SKILL.md) at every implementation step.

## When NOT to use
- Single-task work: bug fix → `/diagnose` + `/bdd` directly.
- Writing tests → `/bdd` only.
- Reviewing R style of one file → `/r-style` only.
- Committing → `/jj-atomic` only.

## Phase 0 — Frame (both loops)

Karpathy guardrails — state assumptions explicitly, name the simpler
approach you're rejecting, surface tradeoffs. Push back when warranted; if
something is unclear, stop and ask. See
[`../../../CLAUDE.md`](../../../CLAUDE.md) for the full version.

If the task is ambiguous, hand off to
[`/grill-me`](../../productivity/grill-me/SKILL.md) (no codebase needed)
or [`/grill-with-docs`](../grill-with-docs/SKILL.md) (anchors to
`CONTEXT.md`) before entering the loop.

## Then enter the appropriate loop

- `DESCRIPTION` detected → [`package-loop.md`](package-loop.md)
  (document → lint → style → test → check → commit)
- `_targets.R` detected → [`analysis-loop.md`](analysis-loop.md)
  (lint → style → test → run pipeline → render → commit)

## See also
- [`../bdd/SKILL.md`](../bdd/SKILL.md) and its R siblings
  (`tests-r.md`, `interface-design-r.md`, `mocking-r.md`,
  `deep-modules-r.md`, `refactoring-r.md`, `anti-patterns.md`).
- [`../diagnose/SKILL.md`](../diagnose/SKILL.md) — six-phase bug hunt
  with R-flavored siblings.
- [`../r-style/SKILL.md`](../r-style/SKILL.md) — coding standards.
- [`../../productivity/jj-atomic/SKILL.md`](../../productivity/jj-atomic/SKILL.md).
- [`../../scaffold/build-r-package/SKILL.md`](../../scaffold/build-r-package/SKILL.md)
  and
  [`../../scaffold/build-r-analysis/SKILL.md`](../../scaffold/build-r-analysis/SKILL.md)
  — set up the projects this workflow assumes.
