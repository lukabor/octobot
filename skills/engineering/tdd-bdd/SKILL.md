---
name: tdd-bdd
description: Drive implementation with a strict red-green-refactor loop where every test is first stated as a BDD-flavored Given/When/Then scenario before being translated into the project's native test framework. Use when the user says "tdd", "/tdd-bdd", "use TDD", "write tests first", or asks to add a feature/fix a bug and a test suite exists (or should exist) in the repo.
---

# tdd-bdd

## When to use
- User says "tdd", "/tdd-bdd", "test first", "write a failing test first".
- A bug fix or new behavior is requested and the repo has a test runner
  (or one can be added in < 5 min).
- Behavior is observable from outside the unit (input → output, state
  change, side effect) — pure refactors are out of scope.

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

### 1. Red — one scenario at a time
- Translate the *first* scenario into the project's native test framework
  (pytest, testthat, vitest, go test, …). The Given/When/Then comments stay
  above the test as a docstring.
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

## Guardrails
- **Never** skip the red step. If a test passes on first run, it is
  testing the wrong thing — fix it before continuing.
- **Never** write more than one failing test at a time.
- If a scenario turns out to be untestable at the chosen level, surface it
  — don't silently drop it. Move it up (integration) or down (unit) one
  level and reconfirm with the user.
- Refactor only with a green bar. No "tidy while red".
