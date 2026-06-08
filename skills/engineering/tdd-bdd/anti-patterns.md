# tdd-bdd anti-patterns

## Horizontal slicing

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

## Passing on first run

If a freshly written test passes without any production-code change, the
test is testing the wrong thing — the behavior was already present, or the
assertion is a tautology. Fix the test before continuing. Never let a green
bar on a brand-new test go unchallenged.

## Refactoring while red

If the suite is red, fix the test or fix the code — do not "tidy while
fixing". Two changes mixed together are two regressions waiting to happen.
Refactor only with a green bar. See also
[`refactoring-r.md`](refactoring-r.md).

## Silently dropping an untestable scenario

If a scenario from step 0 turns out to be untestable at the chosen level,
surface it — don't quietly delete it. Move it up (integration) or down
(unit) one level and reconfirm with the user. A dropped scenario is a
contract the suite no longer protects.
