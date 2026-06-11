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
Before hypothesising, construct a reproducible pass/fail signal. Iterate on
the loop itself until it runs in seconds and the failure is unambiguous.
Recipes + two worked examples per language:
[feedback-loops-py.md](feedback-loops-py.md) (pytest) /
[feedback-loops-r.md](feedback-loops-r.md) (testthat, `targets`, bookdown).

### 2. Reproduce
Run the loop. Confirm it triggers the **exact** symptom the user reported,
not a neighbour. *"Got an error"* is not the same as *"got `subscript out
of bounds` at `R/plot/build_plot.R:42`"*. If you can't reproduce, you
don't have the bug — go back to phase 1.

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
Hand off to [tdd-bdd](../tdd-bdd/SKILL.md):
- State the bug as one Given/When/Then scenario.
- Translate into a failing testthat test at the **public** interface
  (see `../tdd-bdd/mocking-r.md` — do not reach past it).
- Watch it fail with the original error.
- Apply the fix. Watch it pass. Re-run the original user-facing scenario.

### 6. Cleanup + post-mortem
- `grep -r "### DIAGNOSE-" .` and remove every tagged line.
- Confirm the bug no longer reproduces in the user-facing context
  (re-render the book, re-run the pipeline end-to-end).
- Commit message names the confirmed hypothesis ("H1: `data.table`
  reference semantics in `assemble_expr`") so future readers see the *why*.
- Note architectural follow-ups as
  [refactoring-r.md](../tdd-bdd/refactoring-r.md) candidates; file them,
  don't auto-fix in the same commit.

## Guardrails
- **Never** skip phase 1. Hypothesising without a loop is guessing.
- **Never** test more than one hypothesis at a time — you lose the signal.
- **Never** apply the fix before the regression test fails for the right
  reason.
- **Never** ship instrumentation. Cleanup is a phase, not an afterthought.

## See also
- [../tdd-bdd/SKILL.md](../tdd-bdd/SKILL.md) — phase 5 is a tdd-bdd cycle.
- [../tdd-bdd/refactoring-r.md](../tdd-bdd/refactoring-r.md) — file
  architectural follow-ups here.
- [../grill-with-docs/SKILL.md](../grill-with-docs/SKILL.md) — phase 3
  hypothesis names should use canonical terms from `CONTEXT.md`.
