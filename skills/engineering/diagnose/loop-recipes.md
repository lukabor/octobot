# Loop recipes — the taxonomy

A bug you can reproduce in 2 seconds with one keystroke is half-fixed.
Phase 1's product *is* the loop. Spend time on it.

## Recipes, fastest-acceptable first

1. **Failing test** — one test file, minimal reporter, stop on first
   failure. The gold standard.
2. **Curl / HTTP script** — for an endpoint bug, the request is the loop.
3. **CLI invocation with fixture input** — when the CLI itself reproduces
   on a small fixture file.
4. **Headless browser script** — for UI bugs that survive a unit test
   (Playwright, `shinytest2`).
5. **Replay a captured trace** — record one production trace, replay
   it deterministically.
6. **Throwaway harness** — a 5-line script printing `PASS`/`FAIL` with a
   non-zero exit on failure. Valid when nothing native exists.
7. **Property / fuzz loop** — when the bug only surfaces under randomised
   inputs, pin the seed and run the family.
8. **Bisection harness** — when "what changed?" is the question, the
   loop wraps `git bisect run`.
9. **Differential loop** — two implementations, same input, assert equal.
10. **HITL bash script** — last resort. A human-in-the-loop step is the
    escape valve when nothing automated can decide.

Language-flavored worked examples:
[feedback-loops-r.md](feedback-loops-r.md) /
[feedback-loops-py.md](feedback-loops-py.md).

## Tighten the loop

- **Red on the bug**, not a neighbour. The assert names the user's exact
  symptom.
- **Tight — seconds, not minutes.** Strip coverage, strip orchestration,
  strip rebuild. If the loop won't shrink, run a smaller slice.
- **One keystroke.** A typed-out command bus rewires per-bug context loss;
  put it in a `justfile` recipe or shell history.

## Kill non-determinism

If the same loop produces two answers in a row, **fix the loop before
Phase 2**. Universal moves:

- **Seed every RNG**; never rely on global state.
- **Pin the environment** — timezone (`UTC`), locale, hash seed.
- **Freeze package versions** — `renv.lock`, `uv.lock`, or container.
- **Isolate the filesystem** — temp dirs, never the repo tree.
- **Quarantine ambient network** so a hung outbound call can't masquerade
  as a logic bug.

## When you genuinely cannot build a loop

The bug is real, the loop won't form. Two paths:

1. **Build a worse loop, knowingly.** A 30-second smoke test that passes
   *most* of the time you fix the bug is better than no loop. Document
   the false-positive/negative rate next to the assert.
2. **Escalate to the human.** State out loud: *"I can reproduce this
   symptom but cannot pin it to a deterministic test. The architectural
   cost of doing so is X. Want me to spend that, or accept a smoke
   test?"* Then wait.

Never silently abandon Phase 1 and start guessing. That is the failure
mode this skill exists to prevent.
