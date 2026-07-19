---
name: dev-python
description: Orchestrate the full Python dev loop: implement, lint, typecheck, test (bdd), commit.
disable-model-invocation: true
---

# dev-python

Workflow for `build-py-project`-shaped repos (uv + Docker + justfile).
Each phase must pass before the next. Do not advance silently.

## When to use
- User says "run the python workflow", "full dev loop", "/dev-python".
- A fresh feature or fix needs the complete loop, not a single skill.

## When NOT to use
- Single-task work: a bug fix → `/diagnose` + `/bdd` directly.
- Writing tests for an already-implemented behaviour → `/bdd` only.
- Committing a single change → `/jj-atomic` only.

## Phases

### 0. Frame
Karpathy guardrails — state assumptions explicitly, name the simpler
approach you're rejecting, surface tradeoffs. Push back when warranted; if
something is unclear, stop and ask. See
[`../../../CLAUDE.md`](../../../CLAUDE.md) for the full version. If the
task is ambiguous, hand off to
[`/grill-me`](../../productivity/grill-me/SKILL.md) or
[`/grill-with-docs`](../grill-with-docs/SKILL.md) first.

### 1. Implement
- Write code under `src/<package>/`.
- Match existing style; touch only what the task requires.

### 2. Lint
```bash
just lint           # ruff check
```
If it fails:
```bash
just lint-fix && just fmt
just lint && just fmt-check   # confirm clean
```

### 3. Typecheck
```bash
just typecheck      # ty check
```
Fix type errors. Don't suppress with `# type: ignore` unless genuinely
unavoidable — explain inline why.

### 4. Test (TDD-BDD)
Hand to [`/bdd`](../bdd/SKILL.md), which loops red→green→refactor
**one scenario at a time** — never write all the tests upfront (that's the
horizontal-slicing anti-pattern called out in bdd itself). When every
scenario from step 0 is green:
```bash
just test
```
The full suite must be green before commit. New edge case found mid-loop
→ add as the next scenario, don't skip.

### 5. Commit
Hand to [`/jj-atomic`](../../productivity/jj-atomic/SKILL.md). The fix
+ the regression test land in the **same** atomic change.

## Reference: justfile commands

| Command | What |
|---|---|
| `just build-dev` / `build-prod` | Build dev / prod container |
| `just up` / `up-prod` | Shell into dev / start prod container |
| `just down` | Stop all containers |
| `just lint` / `lint-fix` | ruff check / with auto-fix |
| `just fmt` / `fmt-check` | ruff format (apply / check) |
| `just typecheck` | ty check |
| `just test` / `test-verbose` | pytest with coverage |
| `just check` | lint + fmt-check + typecheck + test |
| `just fix-and-check` | lint-fix + fmt + typecheck + test |

## See also
- [`../bdd/SKILL.md`](../bdd/SKILL.md) — Given/When/Then loop;
  Python siblings `tests-py.md`, `mocking-py.md`, `interface-design-py.md`,
  `docstrings-py.md`.
- [`../diagnose/SKILL.md`](../diagnose/SKILL.md) — six-phase bug hunt.
- [`../../productivity/jj-atomic/SKILL.md`](../../productivity/jj-atomic/SKILL.md)
  — commit discipline.
- [`../../scaffold/build-py-project/SKILL.md`](../../scaffold/build-py-project/SKILL.md)
  — sets up the project this workflow assumes.
- [`write-readme-py`](../write-readme-py/SKILL.md) — README from
  `pyproject.toml` + `justfile`.
