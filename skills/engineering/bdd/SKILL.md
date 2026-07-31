---
name: bdd
description: Drive implementation with a strict red-green-refactor loop where every test is first stated as a BDD-flavored Given/When/Then scenario before being translated into the project's native test framework. Use when the user says "tdd", "bdd", "/bdd", "use TDD", "use BDD", "behaviour-driven development", "behavior-driven development", "red-green-refactor", "write tests first", or asks to add a feature/fix a bug and a test suite exists (or should exist) in the repo.
---

# bdd

## When to use
- User says "tdd", "/bdd", "test first", "write a failing test first".
- A bug fix or new behavior is requested and the repo has a test runner
  (or one can be added in < 5 min).
- Behavior is observable from outside the unit (input → output, state
  change, side effect) — pure refactors are out of scope.

## Vocabulary
Before step 1, anchor on [../design-codebase/SKILL.md](../design-codebase/SKILL.md) —
module, interface, seam, adapter, depth, leverage, locality.

## Language references
**Python** (pytest only — fixtures, `parametrize`, scenario as docstring):
[tests-py.md](tests-py.md), [interface-design-py.md](interface-design-py.md)
(*before step 1*), [mocking-py.md](mocking-py.md) (*before `patch` /
`monkeypatch`* — seams only, façade + DI), [docstrings-py.md](docstrings-py.md).
**R** (testthat ed. 3+, `box::use`, `describe`/`it`):
[tests-r.md](tests-r.md), [interface-design-r.md](interface-design-r.md)
(*before step 1*), [deep-modules-r.md](deep-modules-r.md),
[mocking-r.md](mocking-r.md) (*before `mockery::stub`* — seams only),
[refactoring-r.md](refactoring-r.md) (*step 3*).

## Process

### 0. Frame
- Restate the change as one sentence: *"<actor> should be able to <action>
  so that <outcome>"*.
- List 2–5 **scenarios** in Given/When/Then form. Include at least one
  happy path and one edge / failure case.
  ```
  Scenario: <short name>
    Given <precondition>
    When  <action>
    Then  <observable outcome>
  ```
- Show the scenarios to the user and get a yes before writing code.
- The scenarios are a **plan**, not a batch of tests to write upfront. See
  the horizontal-slicing anti-pattern below.

### 0.5 Agree the seams
- Write down the **seams under test** and confirm them with the user
  before any test exists — no test at an unconfirmed seam. Up-front
  agreement puts effort on critical paths, not every edge. Inside
  [rig](../../loop/rig/SKILL.md), the blueprint's *Seams touched*
  pre-answers this — reuse it.

### 1. Red — one scenario at a time
- Translate **only the first** scenario into the project's native test
  framework (pytest, testthat, vitest, go test, …). Leave the rest as
  prose. The Given/When/Then comments stay above the test as a docstring.
- Run the test. **Confirm it fails for the right reason** (missing
  behavior, not a typo / import error).

### 2. Green — minimum code
- Write the smallest change that makes the failing test pass. No
  speculative abstractions, no extra cases.
- Run the *full* test suite, not just the new test.

### 3. Refactor
- With the suite green, clean up names, duplication, dead branches.
- Re-run the suite after every non-trivial edit.

### 4. Next scenario
- Loop back to step 1 with the next scenario. Stop when every scenario
  from step 0 is green.

### 5. Report
- One-line summary per scenario: ✓ name → file:test_name.
- Note any scenario that revealed a missing requirement and got added
  mid-loop.

## Output / done criteria
- Every scenario in step 0 has a matching, passing test.
- The full test suite is green.
- Each test carries its Given/When/Then docstring.
- No production code exists that is not exercised by a test added in this
  loop.

## After green — necessary, not sufficient

A green suite is a *claim*, not a proof: it never exercised thread death,
caller ordering, stale data, or the shape the real producer emits (see
[anti-patterns.md](anti-patterns.md) *"Fixtures that don't match what the
producer emits"*). After the loop is green, **budget a review pass** across
four axes: correctness ([`../review-angles/SKILL.md`](../review-angles/SKILL.md)),
blueprint fidelity ([`../review-blueprint/SKILL.md`](../review-blueprint/SKILL.md)),
structural quality ([`../nuke-review/SKILL.md`](../nuke-review/SKILL.md)),
mechanical debloat ([`../winnow/SKILL.md`](../winnow/SKILL.md)). Refute
each finding ([refute.md](../review-angles/refute.md)); fix red-test-first.

## Guardrails
- **Never** skip red, write >1 failing test at once, or refactor while red.
- **Never** test at a seam the user hasn't confirmed (step 0.5).
- A scenario untestable at the chosen level gets surfaced, not dropped.
- Refactor stays **inside** the loop (step 3) — deliberate divergence
  from upstream tdd; octobot's reviews are a separate post-green pass.
See [anti-patterns.md](anti-patterns.md) — horizontal slicing, passing on
first run, tautological tests, refactoring while red, dropped scenarios.

## See also
- [../diagnose/SKILL.md](../diagnose/SKILL.md) — chasing an existing bug?
  Run `/diagnose` first; phase 5 hands back here for the regression test.
- [../model-domain/SKILL.md](../model-domain/SKILL.md) — run before step 0 so scenarios use canonical `CONTEXT.md` vocabulary.
