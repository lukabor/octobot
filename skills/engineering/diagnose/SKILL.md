---
name: diagnose
description: Systematic six-phase bug hunt — build a fast deterministic feedback loop first, reproduce, hypothesize, instrument one variable at a time, fix with a regression test, then clean up and post-mortem. Use when the user says "diagnose", "/diagnose", "debug this", "find the bug", "root cause", "this is flaky", "this is intermittent", "regression", "performance issue", or reports an unexpected failure / hang / wrong output that is not a one-line typo.
---

# diagnose

## When to use
- User says "diagnose", "/diagnose", "find the bug", "root cause",
  "intermittent / flaky", "regression", "perf issue".
- A reported failure is *not* a one-line typo — the cause is non-obvious.
- A test that used to pass is now red and the diff alone doesn't explain it.

## Core principle
**The feedback loop is the product.** If you have a fast, deterministic,
agent-runnable pass/fail signal for the bug, you will find the cause. If
you don't, you are guessing.

## Phases

### 1. Build the feedback loop
Before hypothesising, construct a reproducible pass/fail signal — iterate
on the loop itself until it satisfies the gate below.

Recipe taxonomy: [loop-recipes.md](loop-recipes.md). Worked examples:
[feedback-loops-py.md](feedback-loops-py.md) / [feedback-loops-r.md](feedback-loops-r.md).

**Completion gate** (Phase 1 is done only when *all four* hold):
- [ ] **Red** on the bug — the assert names the user's exact symptom.
- [ ] **Tight** — seconds, not minutes.
- [ ] **Deterministic** — same verdict every run.
- [ ] **Agent-runnable** — unattended; no human prompt mid-loop.

**No red-capable command, no Phase 2.**

### 2. Reproduce + minimise
Run the loop. Confirm it triggers the **exact** symptom the user reported,
not a neighbour. *"Got an error"* is not the same as *"got `subscript out
of bounds` at `R/plot/build_plot.R:42`"*. If you can't reproduce, you
don't have the bug — go back to phase 1.

Once red, **shrink** the repro to the smallest scenario that still goes
red — cut inputs, callers, config, data one at a time, re-running after
each cut. Every remaining element must be load-bearing.

### 3. Hypothesise (before touching code)
Generate **3–5 falsifiable hypotheses**, ranked by plausibility. Each must
include a prediction the loop can decide.
```
H1 (most likely): <cause>.
   Prediction: <change> makes the failure disappear / move.
H2: ...
```
Share the ranking with the user. Cheap course-correction before
instrumentation.

### 4. Instrument
Map each test to **one** Phase-3 prediction. Change one variable at a time.
Prefer interactive inspection over logging —
[instrumentation-py.md](instrumentation-py.md) (`breakpoint`, `--pdb`,
`cProfile`) / [instrumentation-r.md](instrumentation-r.md) (`browser`,
`debugonce`, `profvis`) — plus the `### DIAGNOSE-<date>` tag convention so
cleanup is `grep`-able.

### 5. Fix + regression test
Hand off to [bdd](../bdd/SKILL.md):
- State the bug as one Given/When/Then scenario.
- Translate into a failing test at the **public** interface
  (see `../bdd/mocking-r.md` — do not reach past it).
- Watch it fail with the original error.
- Apply the fix. Watch it pass. Re-run the original user-facing scenario.

If no correct seam exists, **that is itself the finding** — the codebase
architecture is preventing the bug from being locked down. File a
[refactoring-r.md](../bdd/refactoring-r.md) candidate; don't write a test
that lies about the bug pattern.

### 6. Cleanup + post-mortem
Then ask: **what would have prevented this bug?**

- `grep -r "### DIAGNOSE-" .` and remove every tagged line.
- Confirm the bug no longer reproduces in the user-facing context
  (re-render the book, re-run the pipeline end-to-end).
- Commit message names the confirmed hypothesis ("H1: `data.table`
  reference semantics in `assemble_expr`") so future readers see the *why*.
- File architectural follow-ups to [refactoring-r.md](../bdd/refactoring-r.md); don't auto-fix in the same commit.

## Guardrails
- **Never** test more than one hypothesis at a time — you lose the signal.
- **Never** apply the fix before the regression test fails for the right
  reason.
- **Never** ship instrumentation. Cleanup is a phase, not an afterthought.

## See also
- [../bdd/SKILL.md](../bdd/SKILL.md) — phase 5 is a bdd cycle.
- [../bdd/refactoring-r.md](../bdd/refactoring-r.md) — file
  architectural follow-ups here.
- [../design-codebase/SKILL.md](../design-codebase/SKILL.md) — definition of **seam** (Phase 5's "no correct seam" finding).
- [../model-domain/SKILL.md](../model-domain/SKILL.md) — phase 3
  hypothesis names should use canonical terms from `CONTEXT.md`.
