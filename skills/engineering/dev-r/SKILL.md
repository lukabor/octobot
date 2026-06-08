---
name: dev-r
description: Orchestrate the full R development workflow. Auto-detects project type — `DESCRIPTION` present → R package; `_targets.R` present → R analysis — and runs the appropriate loop (implement → lint → style → test → commit). Applies /r-style throughout. Use ONLY when the user explicitly asks for the workflow ("run the R workflow", "full R dev loop", "/dev-r"). Do NOT auto-invoke for individual R tasks — those use `/tdd-bdd`, `/diagnose`, `/r-style`, or `/jj-atomic` directly.
---

# dev-r

Workflow for R repos. Detects project type from filesystem markers:

| Marker | Type | Loop |
|---|---|---|
| `DESCRIPTION` only | R package | `lint → style → test → check → commit` |
| `_targets.R` only | R analysis | `lint → style → test → run pipeline → render → commit` |
| both | ambiguous | ask the user |
| neither | refuse | suggest [`/build-r-package`](../../scaffold/build-r-package/SKILL.md) or [`/build-r-analysis`](../../scaffold/build-r-analysis/SKILL.md) |

Apply [`/r-style`](../r-style/SKILL.md) at every implementation step.

## When NOT to use
- Single-task work: bug fix → `/diagnose` + `/tdd-bdd` directly.
- Writing tests → `/tdd-bdd` only.
- Reviewing R style of one file → `/r-style` only.
- Committing → `/jj-atomic` only.

## R-package phases (`DESCRIPTION` detected)

### 0. Frame
Karpathy guardrails ([`../../../CLAUDE.md`](../../CLAUDE.md)). If
ambiguous, hand to [`/grill-me`](../../productivity/grill-me/SKILL.md)
or [`/grill-with-docs`](../grill-with-docs/SKILL.md).

### 1. Implement
- Code in `R/`, following [`/r-style`](../r-style/SKILL.md) (box, native
  pipe, `\(x)`, snake_case).
- Add/update roxygen2 docs on every exported function.

### 2. Document
```bash
just document       # devtools::document()
```
Fix all roxygen2 warnings.

### 3. Lint & style
```bash
just lint           # lintr
just style-check    # styler dry run
# if style-check fails:
just style
```

### 4. Test (TDD-BDD)
Hand to [`/tdd-bdd`](../tdd-bdd/SKILL.md). Test prologue follows
[`tdd-bdd/tests-r.md`](../tdd-bdd/tests-r.md). Run:
```bash
just test           # devtools::test()
```

### 5. Full check
```bash
just check          # devtools::check()
```
All notes, warnings, and errors resolved before commit.

### 6. Commit
Hand to [`/jj-atomic`](../../productivity/jj-atomic/SKILL.md).

## R-analysis phases (`_targets.R` detected)

### 0. Frame
Same as above.

### 1. Implement
- Functions in `R/functions/` as box modules.
- Pipeline steps in `R/pipeline/` as box modules.
- All code under [`/r-style`](../r-style/SKILL.md).

### 2. Lint & style
```bash
just lint
just style-check    # fix with: just style
```

### 3. Test (TDD-BDD)
Hand to [`/tdd-bdd`](../tdd-bdd/SKILL.md) for `R/functions/`. Then:
```bash
just test
```

### 4. Pipeline
```bash
just run            # targets::tar_make()
```
Verify outputs in `data/processed/`.

### 5. Render (if applicable)
```bash
just render         # quarto render reports/
```

### 6. Commit
Hand to [`/jj-atomic`](../../productivity/jj-atomic/SKILL.md).

## See also
- [`../tdd-bdd/SKILL.md`](../tdd-bdd/SKILL.md) and its R siblings
  (`tests-r.md`, `interface-design-r.md`, `mocking-r.md`,
  `deep-modules-r.md`, `refactoring-r.md`).
- [`../diagnose/SKILL.md`](../diagnose/SKILL.md) — six-phase bug hunt
  with R-flavored siblings.
- [`../r-style/SKILL.md`](../r-style/SKILL.md) — coding standards.
- [`../../productivity/jj-atomic/SKILL.md`](../../productivity/jj-atomic/SKILL.md).
- [`../../scaffold/build-r-package/SKILL.md`](../../scaffold/build-r-package/SKILL.md)
  and
  [`../../scaffold/build-r-analysis/SKILL.md`](../../scaffold/build-r-analysis/SKILL.md)
  — set up the projects this workflow assumes.
