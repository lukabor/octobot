---
name: tdd-bdd
description: Drive implementation with a strict red-green-refactor loop where every test is first stated as a BDD-flavored Given/When/Then scenario before being translated into the project's native test framework. Use when the user says "tdd", "bdd", "/tdd-bdd", "use TDD", "use BDD", "behaviour-driven development", "behavior-driven development", "red-green-refactor", "write tests first", or asks to add a feature/fix a bug and a test suite exists (or should exist) in the repo.
---

# tdd-bdd

## When to use
- User says "tdd", "/tdd-bdd", "test first", "write a failing test first".
- A bug fix or new behavior is requested and the repo has a test runner
  (or one can be added in < 5 min).
- Behavior is observable from outside the unit (input → output, state
  change, side effect) — pure refactors are out of scope.

## Language references — R

Testthat ed. 3+, `box::use`, `describe`/`it`.

- [tests-r.md](tests-r.md) — paired good/bad examples + characteristics.
- [interface-design-r.md](interface-design-r.md) — DI, pure functions,
  minimal surface. *Consult before step 1.*
- [deep-modules-r.md](deep-modules-r.md) — small interface, large impl.
- [mocking-r.md](mocking-r.md) — boundaries only. *Consult before `mockery::stub` / `local_mocked_bindings`.*
- [refactoring-r.md](refactoring-r.md) — what to look for in step 3.

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

## Anti-pattern: horizontal slicing

**DO NOT write all the tests first, then all the implementation.** Treating
RED as "write every test from step 0" and GREEN as "make them all pass" is
horizontal slicing. It produces tests of *imagined* behavior — you commit to
shapes and signatures before the code teaches you what actually matters.

```
WRONG (horizontal):    RIGHT (vertical, tracer bullets):
  RED:   t1 t2 t3        RED→GREEN: t1 → impl1
  GREEN: i1 i2 i3        RED→GREEN: t2 → impl2
                         RED→GREEN: t3 → impl3
```

Each cycle responds to what the previous cycle revealed. The scenario list
from step 0 is a *plan*; it is not a queue of tests to enqueue at once.

## Guardrails
- **Never** skip the red step. If a test passes on first run, it is
  testing the wrong thing — fix it before continuing.
- **Never** write more than one failing test at a time (horizontal-slicing
  trap above).
- If a scenario turns out to be untestable at the chosen level, surface it
  — don't silently drop it. Move it up (integration) or down (unit) one
  level and reconfirm with the user.
- Refactor only with a green bar. No "tidy while red".

## See also
- [../diagnose/SKILL.md](../diagnose/SKILL.md) — chasing an existing bug?
  Run `/diagnose` first; phase 5 hands back here for the regression test.
